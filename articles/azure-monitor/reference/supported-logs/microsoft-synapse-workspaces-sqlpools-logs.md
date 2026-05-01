---
title: Supported log categories - Microsoft.Synapse/workspaces/sqlPools
description: Reference for Microsoft.Synapse/workspaces/sqlPools in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Synapse/workspaces/sqlPools, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.Synapse/workspaces/sqlPools

The following table lists the types of logs available for the Microsoft.Synapse/workspaces/sqlPools resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.Synapse/workspaces/sqlPools](../supported-metrics/microsoft-synapse-workspaces-sqlpools-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`DmsWorkers` |Dms Workers |[SynapseSqlPoolDmsWorkers](/azure/azure-monitor/reference/tables/synapsesqlpooldmsworkers)<p>Information about workers completing DMS steps in an Azure Synapse dedicated SQL pool.|Yes|Yes||No |
|`ExecRequests` |Exec Requests |[SynapseSqlPoolExecRequests](/azure/azure-monitor/reference/tables/synapsesqlpoolexecrequests)<p>Information about SQL requests or queries in an Azure Synapse dedicated SQL pool.|Yes|Yes||No |
|`RequestSteps` |Request Steps |[SynapseSqlPoolRequestSteps](/azure/azure-monitor/reference/tables/synapsesqlpoolrequeststeps)<p>Information about request steps that compose a given SQL request or query in an Azure Synapse dedicated SQL pool.|Yes|Yes||No |
|`SqlRequests` |Sql Requests |[SynapseSqlPoolSqlRequests](/azure/azure-monitor/reference/tables/synapsesqlpoolsqlrequests)<p>Information about query distributions of the steps of SQL requests/queries in an Azure Synapse dedicated SQL pool.|Yes|Yes||No |
|`SQLSecurityAuditEvents` |Sql Security Audit Event |[SQLSecurityAuditEvents](/azure/azure-monitor/reference/tables/sqlsecurityauditevents)<p>Azure Synapse SQL Audit Log.|No|Yes||No |
|`Waits` |Waits |[SynapseSqlPoolWaits](/azure/azure-monitor/reference/tables/synapsesqlpoolwaits)<p>Information about the wait states encountered during execution of a SQL request/query in an Azure Synapse dedicated SQL pool, including locks and waits on transmission queues.|Yes|Yes||No |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
