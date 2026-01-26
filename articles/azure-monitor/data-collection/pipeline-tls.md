---
title: Azure Monitor ingress setup and TLS configuration
description: Secure the connection from your Azure Monitor pipeline to Azure Monitor by configuring TLS.
ms.topic: article
ms.date: 01/15/2026
ms.custom: references_regions, devx-track-azurecli
---

# Azure Monitor ingress setup and TLS configuration (preview)

The [Azure Monitor pipeline](./pipeline-overview.md) extends the data collection capabilities of Azure Monitor to your local data center and multicloud environments. With support for Bring Your Own Certificates (BYOC), you can meet your security requirements while integrating with your existing PKI infrastructure. Azure Monitor pipeline currently supports both TLS and mutual TLS (mTLS) for TCP‑based receivers, allowing you to:

- Provide your own keys and certificates that the Azure Monitor receiver TLS endpoint should use.
- Configure TLS with your own CA cert and PKI that Azure Monitor should provision certs from for its receiver TLS endpoint.

This article describes how to secure the connection between your pipeline and Azure Monitor using custom certificates to authenticate endpoints and clients. Use your existing PKI to issue and manage certificates and [cert-manager](https://cert-manager.io/docs/) to automate certificate issuance and renewal.

## Prerequisites

- Arc-enabled Kubernetes cluster with Azure Monitor pipeline installed.
- `kubectl` and `az access` to the Arc‑enabled cluster context.


## Configure cert-manager with external PKI
This section describes how to install cert-manager as an Azure Arc extension. Alternatively, you can install the open source version of cert-manager using the guidance at [Deploy cert-manager on Azure Kubernetes Service (AKS) and use Let's Encrypt to sign a certificate for an HTTPS website](https://cert-manager.io/docs/tutorials/getting-started-aks-letsencrypt/).

### Install cert-manager for Arc-enabled Kubernetes

> [!NOTE]
> Supported Kubernetes distributions for cert‑manager extension on Arc-enabled Kubernetes include the following.
>
> - VMware Tanzu Kubernetes Grid multicloud (TKGm) v1.28.11
> - SUSE Rancher K3s v1.33.3+k3s1
> - AKS Arc v1.32.7

Installing cert-manager as a cluster managed extension (CME) will register the `cert-manager` and `trust-manager` services on your cluster. 

1. Remove any existing instances of `cert‑manager` and `trust‑manager` from the cluster. Any open source versions must be removed before installing the Microsoft version.

    > [!WARNING]
    > Between uninstalling the open source version and installing the Arc extension, certificate rotation won't occur, and trust bundles won't be distributed to the new namespaces. Ensure this period is as short as possible to minimize potential security risks. Uninstalling the open source cert-manager and trust-manager doesn't remove any existing certificates or related resources you created. These will remain usable once the Azure cert-manager is installed.

    The specific steps for removal will depend on your installation method. See [Uninstalling cert-manager](https://cert-manager.io/docs/installation/uninstall/) and [Uninstalling trust-manager](https://cert-manager.io/docs/trust/trust-manager/installation/#uninstalling) for detailed guidance. If you used Helm for installation, use the following command to check which namespace cert-manager and trust-manager installed using this command.

    `helm list -A | grep -E 'trust-manager|cert-manager'`

    If you have an existing cert-manager extension installed, uninstall it using the following commands:

    ```azurecli
    export RESOURCE_GROUP="<resource-group-name>"
    export CLUSTER_NAME="<arc-enabled-cluster-name>"
    export LOCATION="<arc-enabled-cluster-location"
    
    NAME_OF_OLD_EXTENSION=$(az k8s-extension list --resource-group ${RESOURCE_GROUP} --cluster-name ${CLUSTER_NAME})
    az k8s-extension delete --name ${NAME_OF_OLD_EXTENSION} --cluster-name ${CLUSTER_NAME} \
      --resource-group ${RESOURCE_GROUP} --cluster-type connectedClusters
    ```

1. Use the following command to connect your cluster to Arc if it wasn't already connected. 

    ```azurecli
    az connectedk8s connect --name ${CLUSTER_NAME} --resource-group ${RESOURCE_GROUP} --location ${LOCATION}
    ```

2. Install the cert‑manager extension using the following command:

    ```azurecli
    az k8s-extension create \
      --resource-group ${RESOURCE_GROUP} \
      --cluster-name ${CLUSTER_NAME} \
      --cluster-type connectedClusters \
      --name "azure-cert-management" \
      --extension-type "microsoft.certmanagement" \
      --release-train rc
    ```

### Create issuer resource for external PKI

The following example uses LetsEncrypt, but you can use any supported external PKI.

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

### Create Certificate Resource

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


## Next steps

* [Read more about data collection rules (DCRs) in Azure Monitor](data-collection-rule-overview.md).
