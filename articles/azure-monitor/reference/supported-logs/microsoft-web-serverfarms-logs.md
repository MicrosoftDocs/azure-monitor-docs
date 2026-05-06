---
title: Supported log categories - Microsoft.Web/serverfarms
description: Reference for Microsoft.Web/serverfarms in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 10/31/2025
ms.custom: Microsoft.Web/serverfarms, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.Web/serverfarms

The following table lists the types of logs available for the Microsoft.Web/serverfarms resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.Web/serverfarms](../supported-metrics/microsoft-web-serverfarms-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`AppServiceConsoleLogs` |App Service Console Logs |[AppServiceConsoleLogs](/azure/azure-monitor/reference/tables/appserviceconsolelogs)<p>Console logs generated from application or container.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/appserviceconsolelogs)|Yes |
|`AppServicePlatformLogs` |App Service Platform logs |[AppServicePlatformLogs](/azure/azure-monitor/reference/tables/appserviceplatformlogs)<p>Logs generated through AppService platform for your application.|No|Yes||Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
