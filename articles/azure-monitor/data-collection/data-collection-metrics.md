---
title: Metrics export using data collection rules (Preview)
description: Learn how to create data collection rules for metrics.
ms.topic: concept-article
ms.date: 09/15/2024
ms.custom: references_regions
---

# Metrics export using data collection rules (Preview)

Platform metrics measure the performance of different aspects of your Azure resources. [Diagnostic settings](../platform/diagnostic-settings.md) are used to collect and export platform metrics from all Azure resources that support them. [Data collection rules (DCRs)](./data-collection-rule-overview.md) can also be used to collect and export platform metrics from [supported Azure resources](#supported-resources-and-regions). This article describes how to use DCRs to export metrics.

> [!NOTE]
> While you can use DCRs and diagnostic settings at the same time, you should disable any diagnostic settings for metrics when using DCRs to avoid duplicate data collection.

Using DCRs to export metrics provides the following advantages over diagnostic settings:

* DCR configuration enables exporting metrics with dimensions.
* DCR configuration enables filtering based on metric name - so that you can export only the metrics that you need.
* DCRs are more flexible and scalable compared to Diagnostic Settings.
* End to end latency for DCRs is within 3 minutes. This is a major improvement over Diagnostic Settings where metrics export latency is 6-10 minutes.


> [!NOTE]
> Use metrics export with DCRs for continuous export of metrics data as it's created. To query historical data that's already been collected, use the [Data plane Metrics Batch API](/rest/api/monitor/metrics-batch/batch). See [Data plane Metrics Batch API query versus Metrics export](data-plane-versus-metrics-export.md) for a comparison of the two strategies.


## Export destinations

Metrics can be exported to the following destinations.

| Destination type | Details |
|:---|:---|
| Log Analytics workspaces | Exporting to Log Analytics workspaces can be across regions. The Log Analytics workspace and the DCR must be in the same region but resources that are being monitored can be in any region. Metrics sent to a log analytics workspace are stored in the `AzureMetricsV2` table. |
| Azure storage accounts |  The storage account, the DCR, and the resources being monitored must all be in the same region. |
| Event Hubs | The Event Hubs, the DCR, and the resources being monitored must all be in the same region. |

> [!NOTE]
> Latency for exporting metrics is approximately 3 minutes. Allow up to 15 minutes for metrics to begin to appear in the destination after the initial setup.

## Limitations

DCRs for metrics export have the following limitations:

* Only one destination type can be specified per DCR. To send to multiple destinations, create multiple DCRs.
* A maximum of 5 DCRs can be associated with a single Azure resource.
* Metrics export with DCR doesn't support the export of hourly grain metrics.

## Supported resources and regions

The following resources currently support metrics export using data collection rules:

| Resource type | Stream specification |
|---------------|----------------------|
| Virtual Machine scale sets | Microsoft.compute/virtualmachinescalesets |
| Virtual machines | Microsoft.compute/virtualmachines |
| Redis cache | Microsoft.cache/redis |
| IOT hubs | Microsoft.devices/iothubs |
| Key vaults | Microsoft.keyvault/vaults |
| Storage accounts | Microsoft.storage/storageaccounts<br>Microsoft.storage/Storageaccounts/blobservices<br>Microsoft.storage/storageaccounts/fileservices<br>Microsoft.storage/storageaccounts/queueservices<br>Microsoft.storage/storageaccounts/tableservices |
| SQL Server | Microsoft.sql/servers<br>Microsoft.sql/servers/databases |
|Operational Insights | Microsoft.operationalinsights/workspaces |
| Data protection | Microsoft.dataprotection/backupvaults |
| Azure Kubernetes Service| Microsoft.ContainerService/managedClusters |

### Supported regions

You can create a DCR for metrics export in any region, but the resources that you want to export metrics from must be in one of the following regions:

* Australia East
* Central US
* CentralUsEuap
* South Central US
* East US
* East US 2
* Eastus2Euap
* West US
* West US 2
* North Europe
* West Europe
* UK South





## Create DCRs for metrics export

Create DCRs for metrics export using the Azure portal, CLI, PowerShell, REST API, or ARM template. For more information, see [Create a data collection rule (DCR) for metrics export](metrics-export-create.md).






## Next steps

* [Create and edit data collection rules](data-collection-rule-create-edit.md)
* [Data plane metrics batch API query versus Metrics Export](data-plane-versus-metrics-export.md)
* [Data collection rules, overview](/azure/azure-monitor/essentials/data-collection-rule-overview?tabs=portal)
* [Best practices for data collection rule creation and management in Azure Monitor](/azure/azure-monitor/essentials/data-collection-rule-best-practices)
