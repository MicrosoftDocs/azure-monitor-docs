---
title: Supported log categories - Microsoft.OperationalInsights/workspaces
description: Reference for Microsoft.OperationalInsights/workspaces in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.OperationalInsights/workspaces, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.OperationalInsights/workspaces

The following table lists the types of logs available for the Microsoft.OperationalInsights/workspaces resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.OperationalInsights/workspaces](../supported-metrics/microsoft-operationalinsights-workspaces-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`Audit` |Audit |[LAQueryLogs](/azure/azure-monitor/reference/tables/laquerylogs)<p>Audit logs for queries executed in Log Analytics Workspaces.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/laquerylogs)|No |
|`Jobs` |Jobs |[LAJobLogs](/azure/azure-monitor/reference/tables/lajoblogs)<p>Provides information about jobs executions (e.g. Export Job) within Log Analytics workspace. Including job status, duration, and errors.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/lajoblogs)|Yes |
|`SummaryLogs` |Summary Logs |[LASummaryLogs](/azure/azure-monitor/reference/tables/lasummarylogs)<p>Provides Summary logs rules execution details, including run status, duration and errors. Can be used to view bins executions statuses, identify rules that take a long time to complete, and failures that could be optimized in query, or shorted bin time.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/lasummarylogs)|Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
