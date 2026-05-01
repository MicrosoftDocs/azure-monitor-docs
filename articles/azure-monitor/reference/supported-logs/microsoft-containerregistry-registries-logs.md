---
title: Supported log categories - Microsoft.ContainerRegistry/registries
description: Reference for Microsoft.ContainerRegistry/registries in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.ContainerRegistry/registries, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.ContainerRegistry/registries

The following table lists the types of logs available for the Microsoft.ContainerRegistry/registries resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.ContainerRegistry/registries](../supported-metrics/microsoft-containerregistry-registries-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`ContainerRegistryLoginEvents` |Login Events |[ContainerRegistryLoginEvents](/azure/azure-monitor/reference/tables/containerregistryloginevents)<p>Azure Container Registry Login Auditing Logs|No|Yes|[Queries](/azure/azure-monitor/reference/queries/containerregistryloginevents)|No |
|`ContainerRegistryRepositoryEvents` |RepositoryEvent logs |[ContainerRegistryRepositoryEvents](/azure/azure-monitor/reference/tables/containerregistryrepositoryevents)<p>Azure Container Registry Repository Auditing Logs|No|Yes|[Queries](/azure/azure-monitor/reference/queries/containerregistryrepositoryevents)|No |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
