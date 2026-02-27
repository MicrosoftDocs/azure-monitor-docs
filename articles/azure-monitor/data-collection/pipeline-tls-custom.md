---
title: Azure Monitor pipeline TLS configuration (Customer managed)
description: Secure the connection from your Azure Monitor pipeline to Azure Monitor by configuring TLS (Customer managed).
ms.topic: article
ms.date: 01/15/2026
ms.custom: references_regions, devx-track-azurecli
---

# Azure Monitor pipeline TLS configuration - Using your own certificate management (Customer managed or BYOC)

The [Azure Monitor pipeline](./pipeline-overview.md) supports both TLS and mutual TLS (mTLS) for TCP‑based receivers through two certificate management approaches:

- **Default TLS**: Automated certificate management with zero-downtime rotation, managed by the Certificate Manager extension
- **Bring Your Own Certificates (BYOC)**: Customer-managed certificates and keys created by users with their own PKI that the Azure Monitor receiver TLS endpoint should use

This article provides detailed guidance for the **BYOC** option. [Click here](./pipeline-tls-automated.md) for the **Default TLS** option. 

You can provide your own certificates to meet compliance, security, and custom PKI requirements. With BYOC, you can:

- Replace the default collector server certificate with your own
- Provide your own CA for client certificate validation
- Integrate with Azure Key Vault for certificate storage

## Prerequisites

- Arc-enabled Kubernetes cluster with Azure Monitor pipeline installed, along with additional components and prerequisites described in [Configure Azure Monitor pipeline](./pipeline-configure.md).
- `kubectl` and `az access` to the Arc‑enabled cluster context.

## Configure cert-manager with external PKI

The following example uses LetsEncrypt, but you can use any supported external PKI.

### Create issuer resource for external PKI

Save the following YAML to a file named external-pki-issuer.yaml.

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
    email: user@example.com
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

Apply the YAML to your cluster using the following command.

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

Apply the YAML to your cluster using the following command. cert‑manager will populate the collector-server-tls secret with certificate and key.

```bash
kubectl apply -f azmonpipeline-server-cert.yaml
```

## BYOC server certificate requirements

When bringing your own server certificate:

- **Certificate and Private Key**: Both must be provided together.
- **DNS Subject Alternative Names (SANs)**: The certificate must include appropriate SANs matching the service endpoints.

The server certificate must include the service FQDN at minimum:

```ini
<pipeline-name>-service.<namespace>.svc.cluster.local
```

Optionally include shorter variants for flexibility:

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

## Certificate Storage

Certificates and keys must be stored in Kubernetes resources in the **same namespace** as the pipeline group:

- **Certificates**: Can be stored in Secrets or ConfigMaps
- **Private Keys**: Must be stored in Secrets only (for security)

## Configure TLS or mTLS

### Create Kubernetes secrets

In order to provide your own certificate and key for client or the pipeline, it must be stored in a Kubernetes secret. Ensure that the following secrets exist in the pipeline namespace so the ARM template can reference them directly.

  - Kubernetes TLS secret named `collector-server-tls` containing `tls.crt` and `tls.key` for the collector
  - Opaque secret named `byoc-client-root-ca-secret` that stores `ca.crt`

```bash
kubectl create secret tls my-tls-secret --cert=tls.crt --key=tls.key -n <namespace>
```

You can optionally leverage the [Secret Store Extension (SSE)](/azure/azure-arc/kubernetes/secret-store-extension) to automatically synchronize certificates from Azure Key Vault to Kubernetes secrets. This provides a secure and automated way to manage certificate lifecycle without manually creating secrets.

To encrypt Secrets at rest, see [Update the key vault mode for an Azure Kubernetes Service (AKS) cluster](/azure/aks/update-kms-key-vault).


### Configure pipeline

Use one of the following templates to configure TLS or mTLS for your Azure Monitor pipeline receivers. Before you deploy the template, change the `tlsConfigurations` section to provide your required TLS settings according to the following guidelines:

- Set `name` to a friendly identifier, such as `byoc-mtls`, and reference that identifier from any receiver in the `tlsConfiguration` field.
- If the receiver omits `tlsConfiguration`, it uses the platform’s default TLS chain created during bootstrap which covers server-side encryption only.
- Receivers can share the same TLS configuration, or you can define multiple entries and map each receiver to the appropriate configuration.
- For BYOC, specify Kubernetes secrets or ConfigMaps for `tlsCertificate` and `clientCa` and specify the correct key for `subLocation` (`tls.crt`, `tls.key`, `ca.crt`).
- Specify one of the following values for `mode`:
  - `serverOnly`: Encrypted transport only, no client authentication.
  - `mutualTls`: Clients must present certificates.
  - `disabled`: TLS is not required and all TLS material is cleared


### [ARM](#tab/arm)

```json
{
  "type": "Microsoft.Monitor/pipelineGroups",
  "apiVersion": "2025-03-01-preview",
  "name": "byoc-cm-pipeline-arm",
  "location": "eastus2",
  "properties": {
    "receivers": [
      {
        "name": "syslog",
        "type": "Syslog",
        "tlsConfiguration": "byoc-mtls",
        "syslog": { "endpoint": "0.0.0.0:514" }
      }
    ],
    "tlsConfigurations": [
      {
        "name": "byoc-mtls",
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
```

### [Bicep](#tab/bicep)

```bicep
param name string = 'byoc-sample'
param location string = resourceGroup().location

resource pipelineGroup 'Microsoft.Monitor/pipelineGroups@2025-03-01-preview' = {
  name: '${name}-pipeline'
  location: location
  properties: {
    receivers: [
      {
        name: '${name}-syslog'
        type: 'Syslog'
        tlsConfiguration: '${name}-mtls'
        syslog: {
          endpoint: '0.0.0.0:514'
        }
      }
    ]
    tlsConfigurations: [
      {
        name: '${name}-mtls'
        mode: 'mutualTls'
        tlsCertificate: {
          certificate: {
            type: 'kubernetesSecret'
            location: 'collector-server-tls'
            subLocation: 'tls.crt'
          }
          privateKey: {
            type: 'kubernetesSecret'
            location: 'collector-server-tls'
            subLocation: 'tls.key'
          }
        }
        clientCa: {
          type: 'kubernetesSecret'
          location: 'byoc-client-root-ca-secret'
          subLocation: 'ca.crt'
        }
      }
    ]
  }
}
```
---

## Example configurations
The following section provides different configurations to include in the `tlsCertificate` section of the pipeline configuration shown above. Plug in the appropriate JSON snippet based on your desired configuration before applying to the configuration to the pipeline.

## TLS Modes

The Azure Monitor pipeline supports three TLS modes:

- **mutualTls** (default): Full mTLS with both server and client certificate authentication
- **serverOnly**: TLS encryption without client certificate validation
- **disabled**: Plain text communication


**BYOC TLS**: Enable TLS secure encryption using customer-managed certificates

```json
{
  "name": "byoc-server-tls",
  "mode": "serverOnly",
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
  }
}
```

**Default TLS + BYOC mTLS**: Enable TLS secure encryption using automated certificate management, and mTLS client authentication using customer-managed certificates

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

**BYOC (TLS + mTLS)**: Enable TLS secure encryption and mTLS client authentication, both using customer-managed certificates

```json
{
  "name": "byoc-mtls",
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
  "clientCA": {
    "type": "kubernetesSecret",
    "location": "byoc-client-root-ca-secret",
    "subLocation": "ca.crt"
  }
}
```

