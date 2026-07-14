---
title: Supported log categories - Microsoft.Synapse/workspaces/scopePools
description: Reference for Microsoft.Synapse/workspaces/scopePools in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 07/14/2026
ms.custom: Microsoft.Synapse/workspaces/scopePools, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.Synapse/workspaces/scopePools

The following table lists the types of logs available for the Microsoft.Synapse/workspaces/scopePools resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.Synapse/workspaces/scopePools](../supported-metrics/microsoft-synapse-workspaces-scopepools-metrics.md)


|Category|Costs to export|Log table|[Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)|Example queries|
|---|---|---|---|---|---|
|Scope Pool Scope Jobs Ended|Yes|[SynapseScopePoolScopeJobsEnded](/azure/azure-monitor/reference/tables/synapsescopepoolscopejobsended)<p>SCOPE ended event including SCOPE job result and Information about the job.|No|Yes||
|Scope Pool Scope Jobs State Change|Yes||No|No||

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
