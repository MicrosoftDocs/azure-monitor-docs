---
title: Azure Monitor ingress setup and TLS configuration
description: Secure the connection from your Azure Monitor pipeline to Azure Monitor by configuring TLS.
ms.topic: article
ms.date: 01/15/2026
ms.custom: references_regions, devx-track-azurecli
---

# Azure Monitor ingress setup and TLS configuration (preview)

The [Azure Monitor pipeline](./pipeline-overview.md) extends the data collection capabilities of Azure Monitor to your local data center and multicloud environments. This article describes how to secure the connection between your pipeline and Azure Monitor using custom certificates to authenticate endpoints and clients.

With support for Bring Your Own Certificates (BYOC), you can meet your security requirements while integrating with your existing PKI infrastructure. Azure Monitor pipeline currently supports both TLS and mutual TLS (mTLS) for TCP‑based receivers, allowing you to:

- Provide your own keys and certificates that the Azure Monitor receiver TLS endpoint should use.
- Configure TLS with your own CA cert and PKI that Azure Monitor should provision certs from for its receiver TLS endpoint.

## Prerequisites

- Arc-enabled Kubernetes cluster with Azure Monitor pipeline installed.
- `kubectl` and az access to the Arc‑enabled cluster context.


## Create Kubernetes secrets

In order to provide your own certificate and key for client or the pipeline, it must be stored in a Kubernetes secret. Ensure that the following secrets exist in the pipeline namespace so the ARM template can reference them directly.

  - Kubernetes TLS secret named `collector-server-tls` containing `tls.crt` and `tls.key` for the collector
  - Opaque secret named `byoc-client-root-ca-secret` that stores `ca.crt`

```bash
kubectl create secret tls my-tls-secret --cert=tls.crt --key=tls.key -n <namespace>
```

You can optionally leverage the [Secret Store Extension (SSE)](/azure/azure-arc/kubernetes/secret-store-extension) to automatically synchronize certificates from Azure Key Vault to Kubernetes secrets. This provides a secure and automated way to manage certificate lifecycle without manually creating secrets.


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

### Example configurations


**Default TLS**

```json
{			
"name": "default-server-tls",			
"mode": "serverOnly"			
}	
```

**BYOC mTLS**

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

**BYOC TLS**

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

**Server: Default, Client: BYOC**

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

**Server: BYOC, Client: default**

```json
{
  "name": "byoc-server-default-client",
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

**Disable TLS**

```json
{
  "name": "tls-disabled",
  "mode": "disabled"
}
```

## 6. Optional: Encrypt Secrets at Rest with KMS

- Use KMS to encrypt Kubernetes Secrets at rest.
- Azure Key Vault may be used as a KMS provider.
- More information: [Update the key vault mode for an Azure Kubernetes Service (AKS) cluster](/azure/aks/update-kms-key-vault)

## Next steps

* [Read more about data collection rules (DCRs) in Azure Monitor](data-collection-rule-overview.md).
