---
title: Supported log categories - Microsoft.Synapse/workspaces/sqlPools
description: Reference for Microsoft.Synapse/workspaces/sqlPools in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 07/14/2026
ms.custom: Microsoft.Synapse/workspaces/sqlPools, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.Synapse/workspaces/sqlPools

The following table lists the types of logs available for the Microsoft.Synapse/workspaces/sqlPools resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.Synapse/workspaces/sqlPools](../supported-metrics/microsoft-synapse-workspaces-sqlpools-metrics.md)


|Category|Costs to export|Log table|[Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)|Example queries|
|---|---|---|---|---|---|
|Dms Workers|No|[SynapseSqlPoolDmsWorkers](/azure/azure-monitor/reference/tables/synapsesqlpooldmsworkers)<p>Information about workers completing DMS steps in an Azure Synapse dedicated SQL pool.|Yes|Yes||
|Exec Requests|No|[SynapseSqlPoolExecRequests](/azure/azure-monitor/reference/tables/synapsesqlpoolexecrequests)<p>Information about SQL requests or queries in an Azure Synapse dedicated SQL pool.|Yes|Yes||
|Request Steps|No|[SynapseSqlPoolRequestSteps](/azure/azure-monitor/reference/tables/synapsesqlpoolrequeststeps)<p>Information about request steps that compose a given SQL request or query in an Azure Synapse dedicated SQL pool.|Yes|Yes||
|Sql Requests|No|[SynapseSqlPoolSqlRequests](/azure/azure-monitor/reference/tables/synapsesqlpoolsqlrequests)<p>Information about query distributions of the steps of SQL requests/queries in an Azure Synapse dedicated SQL pool.|Yes|Yes||
|Sql Security Audit Event|No|[SQLSecurityAuditEvents](/azure/azure-monitor/reference/tables/sqlsecurityauditevents)<p>Azure Synapse SQL Audit Log.|No|Yes||
|Waits|No|[SynapseSqlPoolWaits](/azure/azure-monitor/reference/tables/synapsesqlpoolwaits)<p>Information about the wait states encountered during execution of a SQL request/query in an Azure Synapse dedicated SQL pool, including locks and waits on transmission queues.|Yes|Yes||

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
