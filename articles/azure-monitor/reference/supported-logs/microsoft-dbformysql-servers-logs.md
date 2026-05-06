---
title: Supported log categories - Microsoft.DBforMySQL/servers
description: Reference for Microsoft.DBforMySQL/servers in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.DBforMySQL/servers, arm

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.DBforMySQL/servers

The following table lists the types of logs available for the Microsoft.DBforMySQL/servers resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.DBforMySQL/servers](../supported-metrics/microsoft-dbformysql-servers-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`MySqlAuditLogs` |MySQL Audit Logs |[AzureDiagnostics](/azure/azure-monitor/reference/tables/azurediagnostics)<p>Logs from multiple Azure resources.|No|No|[Queries](/azure/azure-monitor/reference/queries/azurediagnostics#queries-for-microsoftdbformysql)|No |
|`MySqlSlowLogs` |MySQL Server Logs |[AzureDiagnostics](/azure/azure-monitor/reference/tables/azurediagnostics)<p>Logs from multiple Azure resources.|No|No|[Queries](/azure/azure-monitor/reference/queries/azurediagnostics#queries-for-microsoftdbformysql)|No |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
