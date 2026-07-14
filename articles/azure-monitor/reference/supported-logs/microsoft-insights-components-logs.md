---
title: Supported log categories - microsoft.insights/components
description: Reference for microsoft.insights/components in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 07/14/2026
ms.custom: microsoft.insights/components, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for microsoft.insights/components

The following table lists the types of logs available for the microsoft.insights/components resource type.

For a list of supported metrics, see [Supported metrics - microsoft.insights/components](../supported-metrics/microsoft-insights-components-metrics.md)


|Category|Costs to export|Log table|[Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)|Example queries|
|---|---|---|---|---|---|
|Availability results|No|[AppAvailabilityResults](/azure/azure-monitor/reference/tables/appavailabilityresults)<p>Application Insights availability test results.|No|Yes||
|Browser timings|No|[AppBrowserTimings](/azure/azure-monitor/reference/tables/appbrowsertimings)<p>Application Insights browser timings.|No|Yes||
|Dependencies|No|[AppDependencies](/azure/azure-monitor/reference/tables/appdependencies)<p>Application Insights dependencies.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/appdependencies)|
|Events|No|[AppEvents](/azure/azure-monitor/reference/tables/appevents)<p>Application Insights events.|No|Yes||
|Exceptions|No|[AppExceptions](/azure/azure-monitor/reference/tables/appexceptions)<p>Application Insights exceptions.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/appexceptions)|
|Metrics|No|[AppMetrics](/azure/azure-monitor/reference/tables/appmetrics)<p>Application Insights metrics.|No|Yes||
|Page views|No|[AppPageViews](/azure/azure-monitor/reference/tables/apppageviews)<p>Application Insights page views.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/apppageviews)|
|Performance counters|No|[AppPerformanceCounters](/azure/azure-monitor/reference/tables/appperformancecounters)<p>Application Insights performance counters.|No|Yes||
|Requests|No|[AppRequests](/azure/azure-monitor/reference/tables/apprequests)<p>Application Insights requests.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/apprequests)|
|System events|No|[AppSystemEvents](/azure/azure-monitor/reference/tables/appsystemevents)<p>Application Insights system events.|No|Yes||
|Traces|No|[AppTraces](/azure/azure-monitor/reference/tables/apptraces)<p>Application Insights traces.|Yes|Yes||
|Resources|Yes||No|No||

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
