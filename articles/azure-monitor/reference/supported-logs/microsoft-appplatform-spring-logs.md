---
title: Supported log categories - Microsoft.AppPlatform/spring
description: Reference for Microsoft.AppPlatform/spring in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.AppPlatform/spring, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.AppPlatform/spring

The following table lists the types of logs available for the Microsoft.AppPlatform/spring resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.AppPlatform/spring](../supported-metrics/microsoft-appplatform-spring-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`ApplicationConsole` |Application Console |[AppPlatformLogsforSpring](/azure/azure-monitor/reference/tables/appplatformlogsforspring)<p>App Platform Logs for Spring.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/appplatformlogsforspring)|No |
|`BuildLogs` |Build Logs |[AppPlatformBuildLogs](/azure/azure-monitor/reference/tables/appplatformbuildlogs)<p>Azure Spring Cloud build logs of user source codes.|No|No||Yes |
|`ContainerEventLogs` |Container Event Logs |[AppPlatformContainerEventLogs](/azure/azure-monitor/reference/tables/appplatformcontainereventlogs)<p>Azure Spring Cloud container event logs of user applications.|No|No||Yes |
|`IngressLogs` |Ingress Logs |[AppPlatformIngressLogs](/azure/azure-monitor/reference/tables/appplatformingresslogs)<p>Azure Spring Cloud ingress logs, currently it is nginx access logs.|No|Yes||Yes |
|`SystemLogs` |System Logs |[AppPlatformSystemLogs](/azure/azure-monitor/reference/tables/appplatformsystemlogs)<p>Azure Spring Cloud System Logs.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/appplatformsystemlogs)|No |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
