---
title: Supported log categories - Microsoft.Monitor/pipelineGroups
description: Reference for Microsoft.Monitor/pipelineGroups in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/28/2026
ms.custom: Microsoft.Monitor/pipelineGroups, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.Monitor/pipelineGroups

The following table lists the types of logs available for the Microsoft.Monitor/pipelineGroups resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.Monitor/pipelineGroups](../supported-metrics/microsoft-monitor-pipelinegroups-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`LogErrors` |Log Errors |[AzureMonitorPipelineLogErrors](/azure/azure-monitor/reference/tables/azuremonitorpipelinelogerrors)<p>Errors occurred during Azure Monitor pipeline data collection, transformation, and export.|Yes|No|[Queries](/azure/azure-monitor/reference/queries/azuremonitorpipelinelogerrors)|Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
