---
title: Supported metrics - microsoft.insights/components
description: Reference for microsoft.insights/components metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: microsoft.insights/components, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for microsoft.insights/components

The following table lists the metrics available for the microsoft.insights/components resource type.

**Table headings**

**Metric** - The metric display name as it appears in the Azure portal.
**Name in Rest API** - Metric name as referred to in the [REST API](/azure/azure-monitor/essentials/rest-api-walkthrough).
**Unit** - Unit of measure.
**Aggregation** - The default [aggregation](/azure/azure-monitor/essentials/metrics-aggregation-explained) type. Valid values: Average, Minimum, Maximum, Total, Count.
**Dimensions** - [Dimensions](/azure/azure-monitor/essentials/metrics-aggregation-explained#dimensions-splitting-and-filtering) available for the metric.
**Time Grains** - [Intervals at which the metric is sampled](/azure/azure-monitor/essentials/metrics-aggregation-explained#granularity). For example, `PT1M` indicates that the metric is sampled every minute, `PT30M` every 30 minutes, `PT1H` every hour, and so on.
**DS Export**- Whether the metric is exportable to Azure Monitor Logs via Diagnostic Settings.

For information on exporting metrics, see - [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics) and [Create diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/create-diagnostic-settings?tabs=portal).

For information on metric retention, see [Azure Monitor Metrics overview](/azure/azure-monitor/essentials/data-platform-metrics#retention-of-metrics).


For a list of supported logs, see [Supported log categories - microsoft.insights/components](../supported-logs/microsoft-insights-components-logs.md)


### Category: Availability
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Availability**<br><br>Percentage of successfully completed availability tests |`availabilityResults/availabilityPercentage` |Percent |Average |`availabilityResult/name`, `availabilityResult/location`|PT1M |Yes|
|**Availability tests**<br><br>Count of availability tests |`availabilityResults/count` |Count |Count |`availabilityResult/name`, `availabilityResult/location`, `availabilityResult/success`|PT1M |No|
|**Availability test duration**<br><br>Availability test duration |`availabilityResults/duration` |MilliSeconds |Average, Maximum, Minimum |`availabilityResult/name`, `availabilityResult/location`, `availabilityResult/success`|PT1M |Yes|

### Category: Browser
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Page load network connect time**<br><br>Time between user request and network connection. Includes DNS lookup and transport connection. |`browserTimings/networkDuration` |MilliSeconds |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Client processing time**<br><br>Time between receiving the last byte of a document until the DOM is loaded. Async requests may still be processing. |`browserTimings/processingDuration` |MilliSeconds |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Receiving response time**<br><br>Time between the first and last bytes, or until disconnection. |`browserTimings/receiveDuration` |MilliSeconds |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Send request time**<br><br>Time between network connection and receiving the first byte. |`browserTimings/sendDuration` |MilliSeconds |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Browser page load time**<br><br>Time from user request until DOM, stylesheets, scripts and images are loaded. |`browserTimings/totalDuration` |MilliSeconds |Average, Maximum, Minimum |\<none\>|PT1M |Yes|

### Category: Failures
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Dependency call failures**<br><br>Count of failed dependency calls made by the application to external resources. |`dependencies/failed` |Count |Count |`dependency/type`, `dependency/performanceBucket`, `dependency/success`, `dependency/target`, `dependency/resultCode`, `operation/synthetic`, `cloud/roleInstance`, `cloud/roleName`|PT1M |No|
|**Browser exceptions**<br><br>Count of uncaught exceptions thrown in the browser. |`exceptions/browser` |Count |Count |`client/isServer`, `cloud/roleName`|PT1M |No|
|**Exceptions**<br><br>Combined count of all uncaught exceptions. |`exceptions/count` |Count |Count |`cloud/roleName`, `cloud/roleInstance`, `client/type`|PT1M |Yes|
|**Server exceptions**<br><br>Count of uncaught exceptions thrown in the server application. |`exceptions/server` |Count |Count |`client/isServer`, `cloud/roleName`, `cloud/roleInstance`|PT1M |No|
|**Failed requests**<br><br>Count of HTTP requests marked as failed. In most cases these are requests with a response code >= 400 and not equal to 401. |`requests/failed` |Count |Count |`request/performanceBucket`, `request/resultCode`, `request/success`, `operation/synthetic`, `cloud/roleInstance`, `cloud/roleName`|PT1M |No|

### Category: Performance counters
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Exception rate**<br><br>Count of handled and unhandled exceptions reported to windows, including .NET exceptions and unmanaged exceptions that are converted into .NET exceptions. |`performanceCounters/exceptionsPerSecond` |CountPerSecond |Average, Maximum, Minimum |`cloud/roleInstance`|PT1M |Yes|
|**Available memory**<br><br>Physical memory immediately available for allocation to a process or for system use. |`performanceCounters/memoryAvailableBytes` |Bytes |Average, Maximum, Minimum |`cloud/roleInstance`|PT1M |Yes|
|**Process CPU**<br><br>The percentage of elapsed time that all process threads used the processor to execute instructions. This can vary between 0 to 100. This metric indicates the performance of w3wp process alone. |`performanceCounters/processCpuPercentage` |Percent |Average, Maximum, Minimum |`cloud/roleInstance`|PT1M |Yes|
|**Process IO rate**<br><br>Total bytes per second read and written to files, network and devices. |`performanceCounters/processIOBytesPerSecond` |BytesPerSecond |Average, Maximum, Minimum |`cloud/roleInstance`|PT1M |Yes|
|**Processor time**<br><br>The percentage of time that the processor spends in non-idle threads. |`performanceCounters/processorCpuPercentage` |Percent |Average, Maximum, Minimum |`cloud/roleInstance`|PT1M |Yes|
|**Process private bytes**<br><br>Memory exclusively assigned to the monitored application's processes. |`performanceCounters/processPrivateBytes` |Bytes |Average, Maximum, Minimum |`cloud/roleInstance`|PT1M |Yes|
|**HTTP request execution time**<br><br>Execution time of the most recent request. |`performanceCounters/requestExecutionTime` |MilliSeconds |Average, Maximum, Minimum |`cloud/roleInstance`|PT1M |Yes|
|**HTTP requests in application queue**<br><br>Length of the application request queue. |`performanceCounters/requestsInQueue` |Count |Average, Maximum, Minimum |`cloud/roleInstance`|PT1M |Yes|
|**HTTP request rate**<br><br>Rate of all requests to the application per second from ASP.NET. |`performanceCounters/requestsPerSecond` |CountPerSecond |Average, Maximum, Minimum |`cloud/roleInstance`|PT1M |Yes|

### Category: Server
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Dependency calls**<br><br>Count of calls made by the application to external resources. |`dependencies/count` |Count |Count |`dependency/type`, `dependency/performanceBucket`, `dependency/success`, `dependency/target`, `dependency/resultCode`, `operation/synthetic`, `cloud/roleInstance`, `cloud/roleName`|PT1M |No|
|**Dependency duration**<br><br>Duration of calls made by the application to external resources. |`dependencies/duration` |MilliSeconds |Average, Maximum, Minimum |`dependency/type`, `dependency/performanceBucket`, `dependency/success`, `dependency/target`, `dependency/resultCode`, `operation/synthetic`, `cloud/roleInstance`, `cloud/roleName`|PT1M |Yes|
|**Server requests**<br><br>Count of HTTP requests completed. |`requests/count` |Count |Count |`request/performanceBucket`, `request/resultCode`, `operation/synthetic`, `cloud/roleInstance`, `request/success`, `cloud/roleName`|PT1M |No|
|**Server response time**<br><br>Time between receiving an HTTP request and finishing sending the response. |`requests/duration` |MilliSeconds |Average, Maximum, Minimum |`request/performanceBucket`, `request/resultCode`, `operation/synthetic`, `cloud/roleInstance`, `request/success`, `cloud/roleName`|PT1M |Yes|
|**Server request rate**<br><br>Rate of server requests per second |`requests/rate` |CountPerSecond |Average |`request/performanceBucket`, `request/resultCode`, `operation/synthetic`, `cloud/roleInstance`, `request/success`, `cloud/roleName`|PT1M |No|

### Category: Usage
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Page views**<br><br>Count of page views. |`pageViews/count` |Count |Count |`operation/synthetic`, `cloud/roleName`|PT1M |Yes|
|**Page view load time**<br><br>Page view load time |`pageViews/duration` |MilliSeconds |Average, Maximum, Minimum |`operation/synthetic`, `cloud/roleName`|PT1M |Yes|
|**Traces**<br><br>Trace document count |`traces/count` |Count |Count |`trace/severityLevel`, `operation/synthetic`, `cloud/roleName`, `cloud/roleInstance`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
