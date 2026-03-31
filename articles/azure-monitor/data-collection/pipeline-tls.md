---
title: Azure Monitor pipeline TLS configuration
description: Secure data ingestion to Azure Monitor pipeline by configuring TLS.
ms.topic: article
ms.date: 01/15/2026
ms.custom: references_regions, devx-track-azurecli
---

# Azure Monitor pipeline TLS configuration (preview)

Use this article to choose how to secure TCP-based ingestion for [Azure Monitor pipeline](./pipeline-overview.md). The pipeline supports TLS and mutual TLS (mTLS) for TCP-based receivers through two certificate management approaches:

- **Default TLS**: Automated certificate management with zero-downtime rotation, managed by the Certificate Manager extension
- **Bring Your Own Certificates (BYOC)**: Customer-managed certificates and keys created by users with their own PKI that the Azure Monitor receiver TLS endpoint should use

Choose one of the following approaches:

- Use automated certificate management with zero-downtime rotation.
- Provide your own server certificate and key.
- Provide your own CA for client certificate validation.

Use the following sections to choose the approach that fits your deployment.

## Prerequisites

See the prerequisites in [Configure Azure Monitor pipeline](./pipeline-configure.md#prerequisites) for details on the requirements for enabling and configuring the Azure Monitor pipeline.  
Additionally, add the following to your cluster:

- Access to `kubectl` and the Azure CLI for the Arc-enabled cluster context.

## TLS modes

The Azure Monitor pipeline supports three TLS modes:

- **mutualTls** (default): Full mTLS with both server and client certificate authentication
- **serverOnly**: TLS encryption without client certificate validation
- **disabled**: Plain text communication

## Option 1: Default TLS (automated certificate management)

Use this option when you want the Certificate Manager extension to manage certificate issuance and rotation for you.

See [TLS configuration - Using automated certificate management](./pipeline-tls-automated.md) for more information on how to set this up.

## Option 2: BYOC (Bring Your Own Certificates)

Use this option when you need to use your own certificates or integrate with your existing PKI. With BYOC, you can:

- Replace the default collector server certificate with your own
- Provide your own CA for client certificate validation
- Integrate with Azure Key Vault for certificate storage

See [TLS configuration - Using your own certificate management](./pipeline-tls-custom.md) for more information on how this works and how to set this up.

## Option 3: Disable TLS and mTLS

If your environment doesn't require encrypted ingestion, you can disable TLS and mTLS.

1. Disable the configuration by using the following settings.
2. You must have the CME extension and gateway installed, even for non-TLS ingestion from your resources. [Review prerequisites](./pipeline-configure.md#prerequisites) for detailed guidance.

**Disable TLS**

```json
"tlsConfigurations": [
    {
        "name": "tls-disabled",
        "mode": "disabled"
    }
],
"receivers": [
    {
        "type": "Syslog",
        "name": "receiverSyslog",
        "tlsConfiguration": "tls-disabled",
          ....
    }
]
 
```

## Related articles

- Use the default certificate flow in [TLS configuration - Using automated certificate management](./pipeline-tls-automated.md).
- Use customer-managed certificates in [TLS configuration - Using your own certificate management](./pipeline-tls-custom.md).
- Expose secure receivers to external clients by using [Configure a Kubernetes gateway for Azure Monitor pipeline](./pipeline-kubernetes-gateway.md).
- Configure client connections in [Configure a Kubernetes gateway for Azure Monitor pipeline](./pipeline-kubernetes-gateway.md).



