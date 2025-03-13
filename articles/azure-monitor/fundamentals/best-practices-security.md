---
title: Azure Monitor security overview and guidelines
description: Describes .
ms.topic: conceptual
ms.date: 03/12/2024
ms.reviewer: bwren
---

# Azure Monitor security overview and guidelines 

This article provides [Security](/azure/architecture/framework/security/) guidelines for Azure Monitor as part of the [Azure Well-Architected Framework](/azure/architecture/framework/). 

Azure Monitor security guidelines help you understand the security features of Azure Monitor and how to configure them to optimize security based on: 

- [Cloud Adoption Framework](/azure/cloud-adoption-framework/secure/overview), which provides security guidance for teams that manage the technology infrastructure.
- [Azure Well-Architected Framework](/azure/architecture/framework/), which provides architectural best practices for building secure applications.
- [Microsoft cloud security benchmark (MCSB)](/security/benchmark/azure/overview), which describes the available security features and recommended optimal configurations. 
- [Zero Trust security principles](/security/zero-trust/zero-trust-overview), which provides guidance for security teams to implement technical capabilities to support a Zero Trust modernization initiative.

The guidelines in this article build on the [Microsoft security responsibility model](/azure/security/fundamentals/shared-responsibility). As part of this model of shared responsibility, Microsoft provides these security measures for Azure Monitor customers:

- [Azure infrastructure security](/azure/security/fundamentals/infrastructure)
- [Azure customer data protection](/azure/security/fundamentals/protection-customer-data)
- [Encryption of data in transit during data ingestion](/azure/security/fundamentals/double-encryption#data-in-transit)
- [Encryption of data at rest with Microsoft managed keys](/azure/security/fundamentals/encryption-atrest#encryption-at-rest-in-microsoft-cloud-services)
- [Microsoft Entra authentication for data plane access](/azure/azure-monitor/app/azure-ad-authentication)
- [Authentication of Azure Monitor Agent and Application Insights using managed identities](/entra/identity/managed-identities-azure-resources/overview)
- [Privileged access to data plane actions using Role-Based Access Control (Azure RBAC)](/azure/role-based-access-control/overview)
- [Compliance with industry standards and regulations](/azure/compliance/offerings)


## Log ingestion and storage

[!INCLUDE [waf-logs-reliability](includes/waf-logs-security.md)]

## Alerts

[!INCLUDE [waf-containers-reliability](includes/waf-alerts-security.md)]

## Virtual machine monitoring

[!INCLUDE [waf-vm-reliability](includes/waf-vm-security.md)]

## Container monitoring

[!INCLUDE [waf-containers-reliability](includes/waf-containers-security.md)]

## Next step

- [Get best practices for a complete deployment of Azure Monitor](best-practices.md).

