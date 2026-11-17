---
title: Azure Monitor pipeline TLS configuration (Automated certificate management)
description: Secure data ingestion to Azure Monitor pipeline by using automated certificate management.
ai-usage: ai-assisted
ms.topic: article
ms.date: 10/21/2026
ms.custom: references_regions, devx-track-azurecli
---

# TLS configuration - Using automated certificate management

Use this article when you want the Certificate Manager extension to manage certificates for TLS-enabled Azure Monitor pipeline receivers. For the customer-managed option, see [Using your own certificate management](./pipeline-tls-custom.md).

## Prerequisites

- Arc-enabled Kubernetes cluster with Azure Monitor pipeline installed, along with additional components and prerequisites described in [Configure Azure Monitor pipeline](./pipeline-configure.md).
- The [cert-manager extension](/azure/azure-arc/kubernetes/cert-manager-overview) installed on the cluster before you install the pipeline extension.
- Access to `kubectl` and the Azure CLI for the Arc-enabled cluster context.

## How automated certificate management works

The Certificate Manager extension manages certificate lifecycle and rotation for the pipeline. This process includes the following components:

- **Server Certificates**: Unique TLS certificates for each collector service.
- **Client CA Certificates**: Client CA certificates for mTLS authentication.
- **Cluster issuer for client certificates**: Use the extension's managed client-root-CA `ClusterIssuer` to issue client certificates for mTLS. DCR-mode resources are scoped to the extension instance, rather than using the shared legacy issuer name.
- **Trust Bundles**: Automatically distributed CA certificates for validation.
- **Zero-Downtime Rotation**: Certificates are renewed seamlessly without service interruption.

### Certificate lifecycle

The following sections summarize the lifecycle for server and client certificates:

**Server leaf certificates:**

- Duration: 48 hours (2 days)
- Automatic renewal 24 hours before expiration
- Managed automatically by the pipeline operator

**Client certificates:**

Clients control the lifetimes of client certificates, but they must meet zero-downtime rotation constraints. The certificate must renew within 2 days.

Recommended configurations:
- `duration: 48h` and `renewBefore: 24h` 
- `duration: 72h` and `renewBefore: 25h` 
- `duration: 24h` and `renewBefore: 12h`

> [!NOTE]
> This flow distributes trust and renews client certificates inside the cluster. A direct collector connection requires a reachable endpoint and a server certificate valid for the hostname the client uses. For external clients, plan certificate distribution, trust, and renewal explicitly. A gateway can provide a separate client-facing TLS endpoint, but the [gateway examples](./pipeline-kubernetes-gateway.md) protect only the gateway-to-collector hop unless you also configure client-facing TLS termination or TLS passthrough.

> [!WARNING]
> Client certificates that don't renew within 2 days might become invalid when the CA rotates. Always set `renewBefore` to ensure renewal happens before the CA enters its next incubation period.

## Use automated certificate management

When you deploy a pipeline instance with automated certificate management, the operator automatically:

- Creates unique TLS certificates for each collector service.
- Configures collectors to use managed server certificates.
- Distributes trust bundles containing server or client CA certificates to labeled namespaces. You must label the client namespace so the server CA certificate ConfigMap is available in that namespace.
- Enables mTLS with automatic certificate rotation when client authentication is required.

### Step 1: Deploy the pipeline

Deploy the pipeline with TLS enabled. Enable client authentication if you require mTLS. See [Configure Azure Monitor pipeline](./pipeline-configure.md).

For DCR-mode ARM deployments, set `properties.pipelineSettings` in the settings DCR to the following object. Keep the dataflow's endpoint routing and its settings-DCR reference aligned with `syslog6514`, and associate both DCRs with the same extension:

```json
{
  "endpoints": [
    {
      "name": "syslog6514",
      "type": "syslog",
      "networkingConfig": {
        "endpoint": "0.0.0.0:6514",
        "transportProtocol": "tcp",
        "tlsConfiguration": "managed-mtls"
      }
    }
  ],
  "tlsConfigurations": [
    {
      "name": "managed-mtls",
      "mode": "mutualTls"
    }
  ]
}
```

Omitting certificate references uses the operator's managed server certificate, private key, and client CA. For default server-only TLS, replace the configuration entry with the following entry and change the endpoint's `tlsConfiguration` to `managed-server-tls`:

```json
{
  "name": "managed-server-tls",
  "mode": "serverOnly"
}
```

For server-only TLS, complete the server-trust setup in the next section but skip client-certificate issuance.

To explicitly disable TLS instead, replace the configuration entry with the following entry and set the endpoint's `tlsConfiguration` to `unencrypted`. Don't include certificate references or use this mode on an untrusted network:

```json
{
  "name": "unencrypted",
  "mode": "disabled"
}
```

For a complete unencrypted endpoint example, see [Disable TLS and mTLS](./pipeline-tls.md#option-3-disable-tls-and-mtls).

### Step 2: Get server CA certificate for client validation

Clients need the server CA certificate to validate the collector's TLS certificate. The pipeline operator automatically distributes CA certificates through trust bundles.

First identify the extension's server trust `Bundle` and client-root-CA `ClusterIssuer`:

```bash
kubectl get bundles
kubectl get clusterissuers
kubectl get bundle <extension-server-trust-bundle-name> -o yaml
```

For typical extension names, these resources are named `<extension-name>-amp-trust-bundle` and `<extension-name>-amp-client-root-ca-cluster-issuer`. Long names are shortened, so inspect the actual resources. Use the server bundle's `spec.target.namespaceSelector.matchLabels`` key and value to label your client namespace. DCR mode uses an extension-specific label, not the shared legacy `arc-amp-trust-bundle` label:

```bash
kubectl label namespace <client-namespace> <server-bundle-namespace-label-key>=true
```

Extract the server CA certificate:

```bash
# Get the server CA certificate from the trust bundle
kubectl get configmap <extension-server-trust-bundle-name> \
      -n <client-namespace> \
      -o jsonpath='{.data.ca\.crt}' > server-ca.pem
```

The trust bundle is automatically updated during certificate rotation, ensuring clients always have valid CA certificates to validate server connections.

### Step 3: Create Client Certificate for mTLS

For mutual TLS authentication, intra-cluster clients need their own certificates issued by the managed client CA.

> [!NOTE]
>
> Use the managed client-root-CA `ClusterIssuer` that belongs to the same extension as the collector. This example handles issuance and renewal for clients running in the cluster. If you expose a collector directly to external clients, you must also arrange trusted client certificates and renewal outside the cluster. A gateway's backend mTLS certificate doesn't secure its client-facing listener.

Create a certificate resource in your namespace with values that meet zero-downtime rotation constraints:

Save the following YAML to a file named `client-certificate.yaml`:

```yml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: my-client-certificate
  namespace: <client-namespace>
spec:
  secretName: my-client-tls
  issuerRef:
    name: <extension-client-root-ca-cluster-issuer-name>
    kind: ClusterIssuer
    group: cert-manager.io
  commonName: my-client
  usages:
    - client auth
  duration: 48h      # Must renew within 2 days to meet rotation constraints
  renewBefore: 24h   # Renews at 24 hours, well before CA rotation
  privateKey:
    algorithm: ECDSA
    size: 256
```

Apply the certificate:

```bash
kubectl apply -f client-certificate.yaml
```

Wait for cert-manager to issue the certificate (usually within seconds):

```bash
kubectl get certificate my-client-certificate -n <client-namespace> -w
```

### Step 4: Extract Client Certificate and Key

After cert-manager issues the certificate, extract the client certificate and private key:

```bash
# Extract client certificate
kubectl get secret my-client-tls -n <client-namespace> \
  -o jsonpath='{.data.tls\.crt}' | base64 -d > client-cert.pem

# Extract client private key
kubectl get secret my-client-tls -n <client-namespace> \
  -o jsonpath='{.data.tls\.key}' | base64 -d > client-key.pem
```

### Step 5: Connect with mTLS

Use the extracted certificates to establish an mTLS connection.

**Service DNS Names:**

Use the collector service's fully qualified DNS name, such as `<collector-service-name>.<namespace>.svc.cluster.local`, when your client can reach it and it's included in the server certificate's subject alternative names. Inspect the generated service and certificate rather than assuming that shorter service names or external aliases are covered:

```bash
kubectl get services,certificates --namespace <pipeline-namespace>
kubectl get certificate <collector-certificate-name> --namespace <pipeline-namespace> -o yaml
```

If you connect through a gateway, verify TLS on both hops separately. The client must validate the gateway's client-facing certificate when the gateway terminates TLS, while the gateway validates the collector's certificate on its backend connection.

## Verify client trust

For server-only TLS, configure clients to trust the server CA certificate. For mTLS, also configure each client to present its certificate and private key.

Confirm that clients continue to connect after certificate renewal. Keep the trust bundle synchronized and renew client certificates within the rotation constraints.

## Related articles

- Review the overview in [Azure Monitor pipeline TLS configuration](./pipeline-tls.md).
- Expose secure receivers to external clients by using [Configure a Kubernetes gateway for Azure Monitor pipeline](./pipeline-kubernetes-gateway.md).
- Configure client connections in [Configure a Kubernetes gateway for Azure Monitor pipeline](./pipeline-kubernetes-gateway.md).
