---
title: Azure Monitor pipeline TLS configuration
description: Secure the connection from your Azure Monitor pipeline to Azure Monitor by configuring TLS.
ms.topic: article
ms.date: 01/15/2026
ms.custom: references_regions, devx-track-azurecli
---

# Azure Monitor pipeline TLS configuration (preview)

The [Azure Monitor pipeline](./pipeline-overview.md) extends the data collection capabilities of Azure Monitor to your local data center and multicloud environments. Azure Monitor pipeline supports both TLS and mutual TLS (mTLS) for TCP‑based receivers through two certificate management approaches:

- **Default TLS**: Automated certificate management with zero-downtime rotation, managed by the Certificate Manager extension
- **Bring Your Own Certificates (BYOC)**: Customer-managed certificates and keys created by users with their own PKI that the Azure Monitor receiver TLS endpoint should use

With these options, you can:

- Use automated certificate management for simplified operations and zero-downtime rotation
- Provide your own keys and certificates that the Azure Monitor receiver TLS endpoint should use
- Configure TLS with your own CA cert and PKI that Azure Monitor should provision certs from for its receiver TLS endpoint

This article describes how to secure the connection between your pipeline and clients using TLS. You can use the default automated certificate management or use your existing PKI to issue and manage certificates to automate certificate issuance and renewal.

## Prerequisites

See the prerequisites in [Configure Azure Monitor pipeline](./pipeline-configure.md#prerequisites) for details on the requirements for enabling and configuring the Azure Monitor pipeline.  
Additionally, add the following to your cluster:

- `kubectl` and `az access` to the Arc‑enabled cluster context.

## TLS Modes

The Azure Monitor pipeline supports three TLS modes:

- **mutualTls** (default): Full mTLS with both server and client certificate authentication
- **serverOnly**: TLS encryption without client certificate validation
- **disabled**: Plain text communication

## Option 1: Default TLS (automated certificate management)

The Certificate Manager extension provides automated certificate lifecycle management with zero-downtime rotation. This means certificates are automatically renewed and rotated without any service interruption or manual intervention.

See [Azure Monitor pipeline TLS configuration - Using automated certificate management](./pipeline-tls-automated.md) for more information on how to set this up.

## Option 2: BYOC (Bring Your Own Certificates)

Customers can provide their own certificates to meet compliance, security, and custom PKI requirements. With BYOC, you can:

- Replace the default collector server certificate with your own
- Provide your own CA for client certificate validation
- Integrate with Azure Key Vault for certificate storage

See [Azure Monitor pipeline TLS configuration - Using your own certificate management](./pipeline-tls-custom.md) for more information on how this works and how to set this up.

## Option 3: Disable TLS and mTLS 
While it's not recommended from a security standpoint, you may choose to disable TLS and mTLS when using the pipeline. Follow the guidance below to safely do so:

1. Disable the config [following the example configuration](#disable-tls-disable-tls-secure-encryption)
2. You must have the CME extension and gateway installed, even for non-TLS ingestion from your resources


