---
title: Data collection rules for Kubernetes clusters
description: Options for filtering Container insights data that you don't require.
ms.topic: how-to
ms.date: 09/22/2025
ms.reviewer: aul
---

# Data collection rules for Kubernetes clusters
When you enable monitoring for your Kubernetes clusters in Azure Monitor, [data collection rules (DCRs)](../data-collection/data-collection-rule-overview.md) are created to define how logs and metrics are collected from your clusters. You can continue to use methods such as CLI and the Azure portal to configure log and metric collection settings for your clusters rather than working with the DCRs directly. 

This article describes 


## DCRs created

The resources that are created when you enable monitoring Prometheus metrics and container logging for your Kubernetes clusters in the Azure monitor are described in the following tables. 

**Log collection**

| Resource Name | Resource Type | Resource Group | Region/Location | Description |
|:---|:---|:---|:---|:---|
| `MSCI-<aksclusterregion>-<clustername>` | [Data Collection Rule](../data-collection/data-collection-rule-overview.md) | Same as cluster | Same as Log Analytics workspace | Associated with the AKS cluster resource, defines configuration of logs collection by the Azure Monitor agent. **This is the DCR to add the transformation.** |

**Managed Prometheus**

| Resource Name | Resource Type | Resource Group | Region/Location | Description |
|:---|:---|:---|:---|:---|
| `MSPROM-<aksclusterregion>-<clustername>` | [Data Collection Rule](../data-collection/data-collection-rule-overview.md) | Same as cluster | Same as Azure Monitor workspace | Associated with the AKS cluster resource, defines configuration of prometheus metrics collection by metrics addon. |
| `MSPROM-<aksclusterregion>-<clustername>` | [Data Collection endpoint](../data-collection/data-collection-endpoint-overview.md) | Same as cluster | Same as Azure Monitor workspace | Used by the DCR for ingesting Prometheus metrics from the metrics addon. |
    
When you create a new Azure Monitor workspace, the following additional resources are created.

| Resource Name | Resource Type | Resource Group | Region/Location | Description |
|:---|:---|:---|:---|:---|
| `<azuremonitor-workspace-name>` | [Data Collection Rule](../data-collection/data-collection-rule-overview.md) | MA_\<azuremonitor-workspace-name>_\<azuremonitor-workspace-region>_managed | Same as Azure Monitor Workspace | DCR to be used if you use Remote Write from a Prometheus server. |
| `<azuremonitor-workspace-name>` | [Data Collection endpoint](../data-collection/data-collection-endpoint-overview.md) | MA_\<azuremonitor-workspace-name>_\<azuremonitor-workspace-region>_managed | Same as Azure Monitor Workspace | DCE to be used if you use Remote Write from a Prometheus server. |


## Transformations



## Reusing existing DCRs

When you enable monitoring for a cluster, new DCRs for both logs and metrics are created for that cluster. If you have multiple clusters that you want to monitor with the same DCR configuration, then you can share DCRs across clusters. 






## Next steps

- See [Data transformations in Container insights](./container-insights-transformations.md) to add transformations to the DCR that will further filter data based on detailed criteria.
