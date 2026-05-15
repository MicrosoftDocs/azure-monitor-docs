---
title: Supported log categories - Microsoft.AppConfiguration/configurationStores
description: Reference for Microsoft.AppConfiguration/configurationStores in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.AppConfiguration/configurationStores, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.AppConfiguration/configurationStores

The following table lists the types of logs available for the Microsoft.AppConfiguration/configurationStores resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.AppConfiguration/configurationStores](../supported-metrics/microsoft-appconfiguration-configurationstores-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`Audit` |Audit |[AACAudit](/azure/azure-monitor/reference/tables/aacaudit)<p>Azure App Configuration audit logs.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/aacaudit)|Yes |
|`HttpRequest` |HTTP Requests |[AACHttpRequest](/azure/azure-monitor/reference/tables/aachttprequest)<p>Incoming requests to Azure App Configuration. The records in this table are aggregated. The 'HitCount' field describes the number of requests that each record accounts for.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/aachttprequest)|Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
