---
title: Azure Monitor pipeline TLS configuration (Automated)
description: Secure the connection from your Azure Monitor pipeline to Azure Monitor by configuring TLS.
ms.topic: article
ms.date: 01/15/2026
ms.custom: references_regions, devx-track-azurecli
---

# Azure Monitor pipeline TLS configuration - Using automated certificate management

The [Azure Monitor pipeline](./pipeline-overview.md) supports both TLS and mutual TLS (mTLS) for TCP‑based receivers through two certificate management approaches:

- **Default TLS**: Automated certificate management with zero-downtime rotation, managed by the Certificate Manager extension
- **Bring Your Own Certificates (BYOC)**: Customer-managed certificates and keys created by users with their own PKI that the Azure Monitor receiver TLS endpoint should use

This article provides detailed guidance for the **Default TLS** option. [Click here](./pipeline-tls-byoc.md) for the **BYOC** option. 

## Prerequisites

- Arc-enabled Kubernetes cluster with Azure Monitor pipeline installed, along with additional components and prerequisites described in [Configure Azure Monitor pipeline](./pipeline-configure.md).
- `kubectl` and `az access` to the Arc‑enabled cluster context.

## How automated certificate management works
The Certificate Manager extension provides automated certificate lifecycle management with zero-downtime rotation. This means certificates are automatically renewed and rotated without any service interruption or manual intervention.
The automated certificate management includes:

- **Server Certificates**: Unique TLS certificates for each collector service
- **Client CA Certificates**: Client CA Certificates for mTLS authentication
- **Cluster Issuer for client certificates**: Use cluster issuer `arc-amp-client-root-ca-cluster-issuer` to issue client certificates for mTLS
- **Trust Bundles**: Automatically distributed CA certificates for validation
- **Zero-Downtime Rotation**: Certificates are renewed seamlessly without service interruption

### Certificate lifecycle

Following are the details of the lifecycle for server and client certificates:

**Server leaf Certificates:**

- Duration: 48 hours (2 days)
- Automatic renewal 24 hours before expiration
- Managed automatically by the pipeline operator

**Client Certificates:**

Client certificate lifetimes are controlled by clients, but must meet zero-downtime rotation constraints. The certificate must renew within 2 days.

Recommended configurations:
- `duration: 48h` and `renewBefore: 24h` 
- `duration: 72h` and `renewBefore: 25h` 
- `duration: 24h` and `renewBefore: 12h`

> [!NOTE]
> Client certificates generated using this option should only be used for intra-cluster communication with the pipeline—that is, by clients running within the same Kubernetes cluster. Do NOT use these certificates for clients connecting from outside the cluster. External clients should instead connect through a gateway (see [Set up Gateway for Azure Monitor pipeline](#set-up-gateway-for-azure-monitor-pipeline)).

> [!WARNING]
> Client certificates that don't renew within 2 days may become invalid when the CA rotates. Always set `renewBefore` to ensure renewal happens before the CA enters its next incubation period.

## Using automated certificate management
The Certificate Manager extension provides automated certificate lifecycle management with zero-downtime rotation. This means certificates are automatically renewed and rotated without any service interruption or manual intervention.
When you deploy a pipeline group with default settings, the operator automatically:

- Creates unique TLS certificates for each collector service
- Configures collectors to use managed server certificates
- Distributes trust bundles containing server or client CA certificates to labeled namespaces. It's the responsibility of the user to label the client namespace so the server CA certificate configmap is available in the client namespace.
- Enables mTLS with automatic certificate rotation

### Step 1: Deploy pipeline group

Deploy a pipeline group with default TLS settings (mTLS enabled). No tlsConfigurations needed for default mTLS behavior.

### Step 2: Get server CA certificate for client validation

Clients need the server CA certificate to validate the collector's TLS certificate. The pipeline operator automatically distributes CA certificates via trust bundles.

Label your client namespace to receive the server trust bundle:

```bash
kubectl label namespace <client-namespace> arc-amp-trust-bundle=true
```

Extract the server CA certificate:

```bash
# Get the server CA certificate from the trust bundle
kubectl get configmap arc-amp-trust-bundle \
      -n <client-namespace> \
      -o jsonpath='{.data.ca\.crt}' > server-ca.pem
```

The trust bundle is automatically updated during certificate rotation, ensuring clients always have valid CA certificates to validate server connections.

### Step 3: Create Client Certificate for mTLS

For mutual TLS authentication, intra-cluster clients need their own certificates issued by the managed client CA.

> [!NOTE]
>
> The `arc-amp-client-root-ca-cluster-issuer` ClusterIssuer should only be used to issue client certificates for intra-cluster clients. Do NOT use certificates issued by this ClusterIssuer for clients connecting from outside the cluster. External clients should instead connect through a gateway (see [Set up Gateway for Azure Monitor pipeline](#set-up-gateway-for-azure-monitor-pipeline)).

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
    name: arc-amp-client-root-ca-cluster-issuer
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

Once the certificate is issued, extract the client certificate and private key:

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

The pipeline service is accessible via these DNS names (from most to least specific):

- `<pipeline-name>-service.<namespace>.svc.cluster.local` (fully qualified)
- `<pipeline-name>-service.<namespace>.svc` (cross-namespace)
- `<pipeline-name>-service.<namespace>` (namespace-qualified)
- `<pipeline-name>-service` (within same namespace)



## Example configurations
The following section provides different configurations to include in the `tlsCertificate` section of the pipeline configuration shown above. Plug in the appropriate JSON snippet based on your desired configuration before applying to the configuration to the pipeline.

### TLS Modes

The Azure Monitor pipeline supports three TLS modes:

- **mutualTls** (default): Full mTLS with both server and client certificate authentication
- **serverOnly**: TLS encryption without client certificate validation
- **disabled**: Plain text communication

### **Default TLS**: Enable TLS secure encryption using automated certificate management

```json
{			
"name": "default-server-tls",			
"mode": "serverOnly"			
}	
```

### **Default TLS + BYOC mTLS**: Enable TLS secure encryption using automated certificate management, and mTLS client authentication using customer-managed certificates

```json
{
  "name": "default-server-byoc-client",
  "clientCA": {
    "type": "kubernetesSecret",
    "location": "custom-client-root-ca",
    "subLocation": "ca.crt"
  }
}
```


