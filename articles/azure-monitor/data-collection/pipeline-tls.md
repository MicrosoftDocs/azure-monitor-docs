---
title: Azure Monitor Ingress Setup and TLS Configuration
description: Configuration of Azure Monitor pipeline for edge and multicloud scenarios
ms.topic: article
ms.date: 05/21/2025
ms.custom: references_regions, devx-track-azurecli
---

# Azure Monitor ingress setup and TLS configuration (preview)

Azure Monitor pipeline supports Bring Your Own Certificates (BYOC) for transport security. This enables you to secure data ingestion from external endpoints into your Kubernetes clusters hosted in Azure Monitor, ensuring compliance with internal PKI policies and delivering end‑to‑end security for sensitive data.

BYOC empowers you to maintain control and flexibility over certificate management, meeting regulatory and security requirements while integrating with existing PKI infrastructure. Azure Monitor pipeline currently supports both TLS and mutual TLS (mTLS) for TCP‑based receivers. This allows you to:

- Provide your own keys and certificates that the Azure Monitor receiver TLS endpoint should use.
- Configure TLS with your own CA cert and PKI that Azure Monitor should provision certs from for its receiver TLS endpoint.

This document provides step‑by‑step guidance for enabling secure communication between clients and Azure Monitor Pipeline in Private Preview.

## Prerequisites

- Ensure you follow all the documented Azure Monitor Pipeline prerequisites and confirm the cluster meets each requirement.
- You must have `kubectl` and az access to the Arc‑enabled cluster context.

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

There are two methods to manage TLS certificates for Azure Monitor Pipeline:


- **cert-manager with External PKI**. Certificates are issued and managed by your external PKI, and [cert‑manager](https://cert-manager.io/) automates certificate issuance and renewal using issuer and certificate resources.
- **Azure Key Vault AKV + Secret Store Extension (SSE)**. Certificates are issued by your external PKI, stored [Key Vault](/azure/key-vault/general/overview), and synchronized to [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/) using [Secret Store Extension (SSE)](/azure/azure-arc/kubernetes/secret-store-extension). SSE automates secret population and lifecycle management.

## Configure cert-manager with external PKI

> [!NOTE]
> Alternatively, you can install the [open source cert‑manager](https://cert-manager.io/docs/installation/).
> 
> Supported Kubernetes distributions for cert‑manager extension on Arc-enabled Kubernetes include the following.
>
> - VMware Tanzu Kubernetes Grid Multi‑Cloud (TKGm) v1.28.11
> - Suse Rancher K3s v1.33.3+k3s1
> - AKS Arc v1.32.7
 

### 1. Install cert-manager for Arc-enabled Kubernetes (CME)

Installing CME will register the cert-manager and trust-manager services on your cluster. 

1. Remove any existing instances of cert‑manager and trust‑manager from the cluster. Any open source versions must be removed before installing the Microsoft version.

    > [!WARNING]
    > Between uninstalling the open source version and installing the Arc extension, certificate rotation will not occur, and trust bundles will not be distributed to the new namespaces. Ensure this period is as short as possible to minimize potential security risks. Uninstalling the open source cert-manager and trust-manager does not remove any existing certificates or related resources you created. These will remain usable once the Azure cert-manager is installed.

    The specific steps for removal will depend on your installation method. Refer to [Uninstalling cert-manager](https://cert-manager.io/docs/installation/uninstall/) and [Uninstalling trust-manager](https://cert-manager.io/docs/trust/trust-manager/installation/#uninstalling) for detailed guidance. If you used Helm for installation, use the following command to check which namespace cert-manager and trust-manager installed using this command.

    `helm list -A | grep -E 'trust-manager|cert-manager'`

2. If you have an existing cert-manager extension installed, uninstall it using the following commands:

    ```azurecli
    export RESOURCE_GROUP="<resource-group-name>"
    export CLUSTER_NAME="<arc-enabled-cluster-name>"
    export LOCATION="<arc-enabled-cluster-location"
    
    NAME_OF_OLD_EXTENSION=$(az k8s-extension list --resource-group ${RESOURCE_GROUP} --cluster-name ${CLUSTER_NAME})
    az k8s-extension delete --name ${NAME_OF_OLD_EXTENSION} --cluster-name ${CLUSTER_NAME} \
      --resource-group ${RESOURCE_GROUP} --cluster-type connectedClusters
    ```

3. If you haven't already connected your cluster to Arc, use the following commands :

    ```azurecli
    az connectedk8s connect --name ${CLUSTER_NAME} --resource-group ${RESOURCE_GROUP} --location ${LOCATION}
    ```

4. Install the cert‑manager extension using the following command:

    ```azurecli
    az k8s-extension create \
      --resource-group ${RESOURCE_GROUP} \
      --cluster-name ${CLUSTER_NAME} \
      --cluster-type connectedClusters \
      --name "azure-cert-management" \
      --extension-type "microsoft.certmanagement" \
      --release-train rc
    ```

## 2. Create issuer resource for external PKI

The following example uses LetsEncrypt.

1. Save the following YAML to a file named `external-pki-issuer.yaml`.

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

2. Apply the YAML to your cluster using the following command.

    ```bash
    kubectl apply -f external-pki-issuer.yaml
    ```

## Step 3: Create Certificate Resource

1. Save the following YAML to a file named `azmonpipeline-server-cert.yaml`.

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

2. Apply the YAML to your cluster using the following command. cert‑manager will populate the `collector-server-tls` secret with certificate and key.


    ```bash
    kubectl apply -f azmonpipeline-server-cert.yaml
    ```


## Setup Azure Monitor TLS / mTLS with BYOC

### Manually set up Azure Monitor

1. In order to provide your own certificate and key for client or the pipeline, it must be stored in a Kubernetes secret. Ensure that the following secrets live in the pipeline namespace so the ARM template can reference them directly.
  - Kubernetes TLS secret named `collector-server-tls` containing `tls.crt` and `tls.key` for the collector
  - Opaque secret named `byoc-client-root-ca-secret` that stores `ca.crt`

2. Optionally, leverage the Secret Store Extension (SSE) to automatically synchronize certificates from Azure Key Vault to Kubernetes secrets. This provides a secure and automated way to manage certificate lifecycle without manual secret creation.

3. Deploy the Azure Monitor Pipeline extension using the following command:

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

### Use template to set up Azure Monitor


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

#### tlsConfigurations

- Each entry inside `tlsConfigurations` defines a named bundle of TLS material.
- Set name to a friendly identifier, such as `byoc-mtls`, and reference that identifier from any receiver in the `tlsConfiguration` field.
- If the receiver omits `tlsConfiguration`, it uses the platform’s default TLS chain created during bootstrap which covers server-side encryption only.
- For BYOC, point `tlsCertificate` and `clientCa` to Kubernetes secrets or ConfigMaps and use `subLocation` to pick the correct key - `tls.crt`, `tls.key`, or `ca.crt`.
- Receivers can share the same TLS configuration, or you can define multiple entries and map each receiver to the appropriate configuration.
- Modes:
  - `serverOnly`: encrypted transport only, no client authentication
  - `mutualTls`: clients must present certificates
  - `disabled`: TLS is not required and all TLS material is cleared


**Default TLS**

```json
{			
"name": "default-server-tls",			
"mode": "serverOnly"			
}	
```

**BYOCmTLS**

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

**Default + BYOC mTLS – server: default, clientCA: BYOC**

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

**Default + BYOC mTLS – server: BYOC, clientCA: default**

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

## 6. Optional: Encrypt Secrets at Rest with KMS

- Use KMS to encrypt Kubernetes Secrets at rest.
- Azure Key Vault may be used as a KMS provider.
- More information: https://learn.microsoft.com/en-us/azure/aks/kms-azure-key-vault

## Next steps

* [Read more about data collection rules (DCRs) in Azure Monitor](data-collection-rule-overview.md).
