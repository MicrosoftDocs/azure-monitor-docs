---
title: Create a query-based alert in Azure Monitor
description: "This article shows you how to create a query-based alert from Prometheus or custom (OTel) metrics in Azure Monitor Workspace (AMW)."
ms.topic: how-to 
ms.date: 09/02/2025
ms.author: inhenkel
author: IngridAtMicrosoft
---

# Create a query-based alert (preview)

This article shows you how to create a query-based alert from Prometheus or custom (OTel) metrics in Azure Monitor Workspace (AMW).

## Prerequisites
- Read the [query-based alerts overview]().
- An AMW that is already ingesting Prometheus or custom metrics from your resources.
    - If you want AKS or ARC-enabled metrics, [onboard AKS or ARC-enabled clusters to Azure Managed Prometheus](/azure/azure-monitor/essentials/prometheus-metrics-overview#enable-azure-monitor-managed-service-for-prometheus).
    - If you want to use custom metrics, [ingest custom metrics to AMW](https://learn.microsoft.com/en-us/azure/azure-monitor/metrics/azure-monitor-workspace-monitor-ingest-limits).
- Enable AMS for resource-centric samping and access.
- Create a [user-assigned managed identity](/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities?pivots=identity-mi-methods-azp) and configure it with the `Monitoring Reader` role (or equivalent permissions) on your rule scope, or create a [system-assigned managed identity](/entra/identity/managed-identities-azure-resources/overview#differences-between-system-assigned-and-user-assigned-managed-identities).

## Create a query based alert

You can create a query based alert using the Azure portal, CLI, and an ARM template.

## [Azure portal](#tab/portal)



## [CLI](#tab/cli)

## [ARM](#tab/arm)
---