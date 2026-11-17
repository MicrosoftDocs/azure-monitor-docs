---
title: Azure Monitor pipeline TLS configuration (Customer managed)
description: Secure data ingestion to Azure Monitor pipeline by using customer-managed certificates.
ai-usage: ai-assisted
ms.topic: article
ms.date: 10/22/2026
ms.custom: references_regions, devx-track-azurecli
---

# TLS configuration - Using your own certificate management (customer managed or BYOC)

Use this article when you want to manage certificates for Azure Monitor pipeline receivers yourself. For the automated option, see [Using automated certificate management](./pipeline-tls-automated.md).

Advantages of BYOC:

- Replace the default collector server certificate with your own
- Provide your own CA for client certificate validation
- Integrate with Azure Key Vault for certificate storage

## Prerequisites

- Arc-enabled Kubernetes cluster with Azure Monitor pipeline installed, along with additional components and prerequisites described in [Configure Azure Monitor pipeline](./pipeline-configure.md).
- Access to `kubectl` and the Azure CLI for the Arc-enabled cluster context.
- The [cert-manager extension](/azure/azure-arc/kubernetes/cert-manager-overview) if you use the external PKI procedure below.

## Configure cert-manager with external PKI

The following example uses Let's Encrypt, but you can use any supported external PKI.

### Create issuer resource for external PKI

Save the following YAML to a file named *external-pki-issuer.yaml*.

```yml
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: external-pki-issuer
  namespace: pipeline
spec:
  acme:
    # You must replace this email address with your own.
    # Let's Encrypt will use this to contact you about expiring
    # certificates, and issues related to your account.
    email: user@contoso.com
    # If the ACME server supports profiles, you can specify the profile name here.
    # See #acme-certificate-profiles below.
    profile: tlsserver
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      # Secret resource that will be used to store the account's private key.
      # This is your identity with your ACME provider. Any secret name may be
      # chosen. It will be populated with data automatically, so generally
      # nothing further needs to be done with the secret. If you lose this
      # identity/secret, you will be able to generate a new one and generate
      # certificates for any/all domains managed using your previous account,
      # but you will be unable to revoke any certificates generated using that
      # previous account.
      name: example-issuer-account-key
    # Add a single challenge solver, HTTP01 using nginx
    solvers:
    - http01:
        ingress:
          ingressClassName: nginx
```

Apply the YAML to your cluster by using the following command.

```bash
kubectl apply -f external-pki-issuer.yaml
```

## Create certificate resource

Save the following YAML to a file named `azmonpipeline-server-cert.yaml`.

```yml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: azmonpipeline-server-cert
  namespace: pipeline
spec:
  secretName: collector-server-tls
  issuerRef:
    name: external-pki-issuer
  commonName: azmonpipeline-receiver.pipeline.svc.cluster.local
  dnsNames: azmonpipeline-receiver.pipeline.svc.cluster.local
```

Apply the YAML to your cluster by using the following command. cert-manager adds the certificate and key to the `collector-server-tls` secret.

```bash
kubectl apply -f azmonpipeline-server-cert.yaml
```

## BYOC server certificate requirements

When you bring your own server certificate:

- **Certificate and Private Key**: Provide both together.
- **DNS Subject Alternative Names (SANs)**: The certificate must include appropriate SANs that match the service endpoints.

> [!IMPORTANT]
> Azure Monitor pipeline only supports PEM format. All certificates and keys must be converted to PEM before use.

The server certificate must include the service FQDN at minimum:

```ini
<pipeline-name>-service.<namespace>.svc.cluster.local
```

Optionally, include shorter variants for flexibility:

```ini
<pipeline-name>-service.<namespace>.svc
<pipeline-name>-service.<namespace>
<pipeline-name>-service
```

**Example:**

For a pipeline named `byoc-pipeline` in the `production` namespace, the certificate must include:

```ini
DNS SANs:
  - byoc-pipeline-service.production.svc.cluster.local
  - byoc-pipeline-service.production.svc (optional)
  - byoc-pipeline-service.production (optional)
  - byoc-pipeline-service (optional)
```

## Certificate storage

Store certificates and keys in Kubernetes resources in the **same namespace** as the pipeline instance:

- **Certificates**: Store in Secrets or ConfigMaps
- **Private keys**: Store in Secrets only (for security)

## Configure TLS or mTLS

### Create Kubernetes secrets

To provide your own certificate and key for the client or the pipeline, store them in a Kubernetes secret. Use the following secrets in the pipeline namespace:

- A Kubernetes TLS secret named `collector-server-tls` containing `tls.crt` and `tls.key` for the collector.
- For mTLS, an opaque secret named `byoc-client-root-ca-secret` containing the client CA bundle as `ca.crt`.

If you supply certificate files directly instead of using cert-manager, create the server TLS secret:

```bash
kubectl create secret tls collector-server-tls --cert=tls.crt --key=tls.key -n <namespace>
```

For mTLS, create the client CA secret from your CA bundle:

```bash
kubectl create secret generic byoc-client-root-ca-secret --from-file=ca.crt -n <namespace>
```

You can optionally use the [Secret Store Extension (SSE)](/azure/azure-arc/kubernetes/secret-store-extension) to automatically synchronize certificates from Azure Key Vault to Kubernetes secrets.

To encrypt Secrets at rest, see [Update the key vault mode for an Azure Kubernetes Service (AKS) cluster](/azure/aks/update-kms-key-vault).


### Configure pipeline

Define TLS in the `PipelineSettings` DCR associated with your extension. Add a named configuration under `properties.pipelineSettings.tlsConfigurations`, then select it from a TCP endpoint's `networkingConfig.tlsConfiguration`. This approach separates the TLS definition from the endpoint that uses it and lets endpoints share a configuration.

The following resource example uses the secrets you created earlier to configure mTLS for a Syslog listener on TCP port 6514. Use it as the settings DCR resource in your ARM template, replacing the name and location as needed. If you update an existing settings DCR, retain its other endpoints and TLS configurations.

```json
{
  "type": "Microsoft.Insights/dataCollectionRules",
  "apiVersion": "2025-05-11",
  "name": "syslog-pipeline-settings",
  "location": "<workspace-region>",
  "kind": "PipelineSettings",
  "properties": {
    "pipelineSettings": {
      "endpoints": [
        {
          "name": "syslog6514",
          "type": "syslog",
          "networkingConfig": {
            "endpoint": "0.0.0.0:6514",
            "transportProtocol": "tcp",
            "tlsConfiguration": "syslog-mtls"
          }
        }
      ],
      "tlsConfigurations": [
        {
          "name": "syslog-mtls",
          "mode": "mutualTls",
          "tlsCertificate": {
            "certificate": {
              "type": "kubernetesSecret",
              "location": "collector-server-tls",
              "subLocation": "tls.crt"
            },
            "privateKey": {
              "type": "kubernetesSecret",
              "location": "collector-server-tls",
              "subLocation": "tls.key"
            }
          },
          "clientCa": {
            "type": "kubernetesSecret",
            "location": "byoc-client-root-ca-secret",
            "subLocation": "ca.crt"
          }
        }
      ]
    }
  }
}
```

In this example, `syslog-mtls` joins the endpoint to its TLS definition. `syslog6514` is the endpoint name that the dataflow DCR selects. These names serve different purposes:

1. In the dataflow DCR, set the Syslog data source's `endpointRouting` to `["syslog6514"]`.
1. Add a `references.pipelineSettingsEndpointRouting` entry named `syslog6514` with `pipelineSettingsResourceId` set to the full ARM resource ID of this settings DCR.
1. Associate both DCRs with the same pipeline extension. For the association resource structure, see [Associate both DCRs with the extension](./pipeline-configure-cli.md#associate-both-dcrs-with-the-extension).
1. Expose the TCP listener to the intended clients and configure them to use TLS on that port.

For server-only TLS, set `mode` to `serverOnly` and omit `clientCa`. Keep the server certificate and matching private-key references. For mTLS, retain `clientCa` to validate client certificates. The DCR contains references to certificate material, not the certificate or private-key contents.

Configure clients with the CA certificate that signed the pipeline's server certificate. For mTLS, each client also needs a certificate and private key signed by a CA trusted by the pipeline.

### Verify certificate configuration

Before sending telemetry:

- Confirm that the server certificate's DNS SAN matches the hostname clients use to connect.
- Confirm that the certificate and private key match and that the certificate hasn't expired.
- Confirm that the pipeline can access the certificate and key in its namespace.
- Establish a TLS connection from a client that trusts the issuing CA.
- For mTLS, verify that a client with a trusted certificate connects and that a client without a certificate is rejected.

## Related articles

- Review the overview in [Azure Monitor pipeline TLS configuration](./pipeline-tls.md).
- Use the default certificate flow in [TLS configuration - Using automated certificate management](./pipeline-tls-automated.md).
- Expose secure receivers to external clients by using [Configure a Kubernetes gateway for Azure Monitor pipeline](./pipeline-kubernetes-gateway.md).
