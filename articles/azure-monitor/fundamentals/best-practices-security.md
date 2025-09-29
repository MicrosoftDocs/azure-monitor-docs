---
title: Secure your Azure Monitor deployment
description: This article provides instructions for deploying Azure Monitor securely and explains how Microsoft secures Azure Monitor. 
ms.topic: article
ms.date: 03/19/2025
ms.custom: horz-security
ms.reviewer: bwren
---

# Secure your Azure Monitor deployment 

This article provides instructions for deploying Azure Monitor securely and explains how Microsoft secures Azure Monitor. 

## Log ingestion and storage

[!INCLUDE [waf-logs-security](../logs/includes/waf-logs-security.md)]

### Application Insights TLS ingestion

[!INCLUDE [application-insights-tls-requirements](../app/includes/application-insights-tls-requirements.md)]

[!INCLUDE [application-insights-tls-requirements](../app/includes/application-insights-tls-requirements-deprecating.md)]

For more information, see [TLS support in Application Insights FAQ](../app/application-insights-faq.yml#tls-support).

## Alerts

[!INCLUDE [waf-alerts-security](../alerts/includes/waf-alerts-security.md)]

## Virtual machine monitoring

[!INCLUDE [waf-vm-security](../vm/includes/waf-vm-security.md)]

## Container monitoring

[!INCLUDE [waf-containers-security](../containers/includes/waf-containers-security.md)]

## How Microsoft secures Azure Monitor

The instructions in this article build on the [Microsoft security responsibility model](/azure/security/fundamentals/shared-responsibility). As part of this model of shared responsibility, Microsoft provides these security measures to Azure Monitor customers:

- [Azure infrastructure security](/azure/security/fundamentals/infrastructure)
- [Azure customer data protection](/azure/security/fundamentals/protection-customer-data)
- [Encryption of data in transit during data ingestion](/azure/security/fundamentals/double-encryption#data-in-transit)
- [Encryption of data at rest with Microsoft managed keys](/azure/security/fundamentals/encryption-atrest#encryption-at-rest-in-microsoft-cloud-services)
- [Microsoft Entra authentication for data plane access](/azure/azure-monitor/app/azure-ad-authentication)
- [Authentication of Azure Monitor Agent and Application Insights using managed identities](/entra/identity/managed-identities-azure-resources/overview)
- [Privileged access to data plane actions using Role-Based Access Control (Azure RBAC)](/azure/role-based-access-control/overview)
- [Compliance with industry standards and regulations](/azure/compliance/offerings)

## Azure security guidance and best practices

Azure Monitor secure deployment instructions are based on and consistent with Azure's comprehensive cloud security guidelines and best practices, which include:

- [Cloud Adoption Framework](/azure/cloud-adoption-framework/secure/overview), which provides security guidance for teams that manage the technology infrastructure.
- [Azure Well-Architected Framework](/azure/architecture/framework/), which provides architectural best practices for building secure applications.
- [Microsoft cloud security benchmark (MCSB)](/security/benchmark/azure/overview), which describes the available security features and recommended optimal configurations. 
- [Zero Trust security principles](/security/zero-trust/zero-trust-overview), which provides guidance for security teams to implement technical capabilities to support a Zero Trust modernization initiative.

## Next step

* Learn more about [getting started with Azure Monitor](getting-started.md).
