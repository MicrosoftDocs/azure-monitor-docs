---
title: Supported log categories - Microsoft.Logic/Workflows
description: Reference for Microsoft.Logic/Workflows in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Logic/Workflows, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.Logic/Workflows

The following table lists the types of logs available for the Microsoft.Logic/Workflows resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.Logic/Workflows](../supported-metrics/microsoft-logic-workflows-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`WorkflowRuntime` |Workflow runtime diagnostic events |[AzureDiagnostics](/azure/azure-monitor/reference/tables/azurediagnostics)<p>Logs from multiple Azure resources.|No|No|[Queries](/azure/azure-monitor/reference/queries/azurediagnostics#queries-for-microsoftlogic)|No |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
