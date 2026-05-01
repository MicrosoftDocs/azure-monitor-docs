---
title: Supported log categories - Oracle.Database/autonomousDatabases
description: Reference for Oracle.Database/autonomousDatabases in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/28/2026
ms.custom: Oracle.Database/autonomousDatabases, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Oracle.Database/autonomousDatabases

The following table lists the types of logs available for the Oracle.Database/autonomousDatabases resource type.

For a list of supported metrics, see [Supported metrics - Oracle.Database/autonomousDatabases](../supported-metrics/oracle-database-autonomousdatabases-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`Backup` |Backup Events ||No|No||Yes |
|`Creation` |Creation Events ||No|No||Yes |
|`Critical` |Critical Events ||No|No||Yes |
|`Delete` |Delete Events ||No|No||Yes |
|`Information` |Information Events |[OracleCloudDatabase](/azure/azure-monitor/reference/tables/oracleclouddatabase)<p>Oracle Cloud Event logs.|Yes|No||Yes |
|`Restore` |Restore Events ||No|No||Yes |
|`Update` |Update Events ||No|No||Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
