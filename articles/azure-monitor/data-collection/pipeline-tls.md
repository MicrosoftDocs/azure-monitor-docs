---
title: Azure Monitor Ingress Setup and TLS Configuration
description: Configuration of Azure Monitor pipeline for edge and multicloud scenarios
ms.topic: article
ms.date: 05/21/2025
ms.custom: references_regions, devx-track-azurecli
---

# Azure Monitor Ingress Setup and TLS Configuration

## Introduction
Azure Monitor Pipeline now supports Bring Your Own Certificates (BYOC) for transport security, available in Private Preview. This feature enables organisations to secure data ingestion from external endpoints into Azure Monitor in Kubernetes clusters, ensuring compliance with internal PKI policies and delivering end‑to‑end security for sensitive data.

BYOC empowers enterprises to maintain control and flexibility over certificate management, meeting regulatory and security requirements while integrating with existing PKI infrastructure. With this release, Azure Monitor Pipeline supports both TLS and mutual TLS (mTLS) for TCP‑based receivers, allowing you to:

- Provide your own keys and certificates that the Azure Monitor receiver TLS endpoint should use.
- Configure TLS with your own CA cert and PKI that Azure Monitor should provision certs from for its receiver TLS endpoint.

## Use Case
Organizations can securely transmit telemetry data from external sources to Azure Monitor, leveraging custom certificates to authenticate endpoints and clients. This approach protects data in transit, supports advanced compliance needs, and integrates seamlessly with enterprise security practices.
This document provides step‑by‑step guidance for enabling secure communication between clients and Azure Monitor Pipeline in Private Preview.

## Prerequisites

- Ensure you follow all the documented Azure Monitor Pipeline prerequisites and confirm the cluster meets each requirement.
- Ensure you have kubectl and az access to the Arc‑enabled cluster context.

## Use Case: Secure Ingress to Azure Monitor from External Endpoints
Enable secure data ingestion (e.g., telemetry) from external endpoints into your Kubernetes cluster using Azure Monitor.

- Configure an external endpoint (Azure Monitor receiver) to accept data.
- Secure the endpoint with TLS using user‑provided certificates and keys or integrating with your own PKI.
- Clients authenticate the endpoint before transmitting data.

### Key Steps

- Provide a server certificate and private key for the Azure Monitor receiver TLS endpoint or configure it with your own PKI.
- Clients use the provided CA certificate to verify endpoint identity.

## TLS Configuration: Kubernetes Secrets

### Server certificate & private key
Stored in Kubernetes Secret:

```yaml
collector-server-tls
  tls.crt : Certificate
  tls.key : Private key
```

### Client CA certificate
Stored in Kubernetes Secret:

```yaml
byoc-client-root-ca-secret
  ca.crt : CA certificate to verify clients
```

Note: Both secrets must reside in the pipeline namespace for direct referencing in ARM/Bicep templates.

## TLS Certificate Management Scenarios

### Scenario 1: cert-manager with External PKI

- Certificates are issued and managed by the customer’s external PKI.
- cert‑manager automates certificate issuance and renewal via Issuer and Certificate resources.

### Scenario 2: Azure Key Vault (AKV) + Secret Store Extension (SSE)

- Certificates are issued by the customer’s external PKI, stored in AKV, and synchronized to Kubernetes Secrets via SSE.
- SSE automates secret population and lifecycle management.

## Scenario 1: Setting Up cert-manager with External PKI

You may also install the open‑source cert‑manager instead. See OSS documentation for more details.

### Step 1: Install cert-manager for Arc-enabled Kubernetes (CME)

#### Supported Kubernetes distributions:

- VMware Tanzu Kubernetes Grid Multi‑Cloud (TKGm) v1.28.11
- Suse Rancher K3s v1.33.3+k3s1
- AKS Arc v1.32.7

**Installation Process**

1. Remove prior versions of cert‑manager or trust‑manager:

    `helm list -A | grep -E 'trust-manager|cert-manager'`

2. Uninstall existing cert‑manager extension:

    ```azurecli
    export RESOURCE_GROUP="Your Resource Group"
    export CLUSTER_NAME="Your Arc enabled Cluster Name"
    export LOCATION="Your Arc enabled cluster location"
    
    NAME_OF_OLD_EXTENSION=$(az k8s-extension list --resource-group ${RESOURCE_GROUP} --cluster-name ${CLUSTER_NAME})
    az k8s-extension delete --name ${NAME_OF_OLD_EXTENSION} --cluster-name ${CLUSTER_NAME} \
      --resource-group ${RESOURCE_GROUP} --cluster-type connectedClusters
    ```

3. Ensure Arc connectivity and extension availability:

    ```azurecli
    az group create --name ${RESOURCE_GROUP} --location ${LOCATION}
    az connectedk8s 
    ```

4. Install cert‑manager:

    ```azurecli
    az k8s-extension create \
      --resource-group ${RESOURCE_GROUP} \
      --cluster-name ${CLUSTER_NAME} \
      --cluster-type connectedClusters \
      --name "azure-cert-management" \
      --extension-type "microsoft.certmanagement" \
      --release-train rc
    ```

## Step 2: Create Issuer Resource for External PKI

Example using Let’s Encrypt:

```yml
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: external-pki-issuer
  namespace: pipeline
spec:
  acme:
    email: user@example.com
    profile: tlsserver
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: example-issuer-account-key
    solvers:
      - http01:
          ingress:
            ingressClassName: nginx
```

## Step 3: Create Certificate Resource

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
  dnsNames:
    - azmonpipeline-receiver.pipeline.svc.cluster.local
```

cert‑manager will populate the collector-server-tls secret with certificate and key.

## Setup Azure Monitor TLS / mTLS with BYOC

### Manually set up Azure Monitor

1. Create Kubernetes secrets:
    - collector-server-tls: server cert + private key
    - byoc-client-root-ca-secret: client CA cert
2. (Optional) Use SSE to sync Key Vault certs.
3. Deploy Azure Monitor Pipeline extension:

```azurecli
az k8s-extension create \
  --name "azure-monitor" \
  --extension-type "microsoft.monitor.lab.pipelinecontroller" \
  --scope cluster \
  --cluster-type connectedClusters \
  --cluster-name ${CLUSTER_NAME} \
  --resource-group ${RESOURCE_GROUP} \
  --release-train stable \
  --release-namespace pipeline \
  --version 0.154.0-25315.2-buddy \
  --auto-upgrade false
```

ARM template example

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

Bicep example

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

## TLS configuration scenarios

| Scenario | TLS configuration | Status |
|:---|:---|:---|
| Default mTLS | – | Q1CY26 Public preview |
| Default TLS |{name: default-server-tls, mode: serverOnly} | Q1CY26 Public preview |
| BYOC mTLS | byoc-mtls | Private preview | 
| BYOC TLS | byoc-server-tls | Private preview | 
| Default + BYOC (server default, client BYOC) | default-server-byoc-client | Q1CY26 Public preview |
| Default + BYOC (server BYOC, client default) | byoc-server-default-client | Q1CY26 Public preview |
| Disable | TLStls-disabled | Private preview |

## 6. Optional: Encrypt Secrets at Rest with KMS

- Use KMS to encrypt Kubernetes Secrets at rest.
- Azure Key Vault may be used as a KMS provider.
- More information: https://learn.microsoft.com/en-us/azure/aks/kms-azure-key-vault

## Next steps

* [Read more about data collection rules (DCRs) in Azure Monitor](data-collection-rule-overview.md).
