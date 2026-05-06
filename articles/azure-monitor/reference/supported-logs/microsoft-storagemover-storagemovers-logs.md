---
title: Supported log categories - Microsoft.StorageMover/storageMovers
description: Reference for Microsoft.StorageMover/storageMovers in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.StorageMover/storageMovers, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.StorageMover/storageMovers

The following table lists the types of logs available for the Microsoft.StorageMover/storageMovers resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.StorageMover/storageMovers](../supported-metrics/microsoft-storagemover-storagemovers-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`CopyLogsFailed` |Copy logs - Failed |[StorageMoverCopyLogsFailed](/azure/azure-monitor/reference/tables/storagemovercopylogsfailed)<p>The result logs generated during the execution of Storage Mover job runs where the transfer result is 'Failed'. The logs include the details of the scanned items and their transfer result.|Yes|Yes||Yes |
|`JobRunLogs` |Job run logs |[StorageMoverJobRunLogs](/azure/azure-monitor/reference/tables/storagemoverjobrunlogs)<p>Logs associated with Storage Mover job runs.|Yes|Yes||Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
