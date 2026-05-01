---
title: Supported log categories - microsoft.videoindexer/accounts
description: Reference for microsoft.videoindexer/accounts in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: microsoft.videoindexer/accounts, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for microsoft.videoindexer/accounts

The following table lists the types of logs available for the microsoft.videoindexer/accounts resource type.


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`Audit` |Audit |[VIAudit](/azure/azure-monitor/reference/tables/viaudit)<p>Audit logs from Video Indexer.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/viaudit)|Yes |
|`IndexingLogs` |Indexing Logs |[VIIndexing](/azure/azure-monitor/reference/tables/viindexing)<p>Indexing logs from Video Indexer.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/viindexing)|Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
