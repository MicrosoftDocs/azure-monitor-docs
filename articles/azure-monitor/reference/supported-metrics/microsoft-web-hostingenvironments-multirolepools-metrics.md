---
title: Supported metrics - Microsoft.Web/hostingenvironments/multirolepools
description: Reference for Microsoft.Web/hostingenvironments/multirolepools metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: Microsoft.Web/hostingenvironments/multirolepools, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Web/hostingenvironments/multirolepools

The following table lists the metrics available for the Microsoft.Web/hostingenvironments/multirolepools resource type.

**Table headings**

- **Metric** - The metric display name as it appears in the Azure portal.
- **Name in Rest API** - Metric name as referred to in the [REST API](/azure/azure-monitor/essentials/rest-api-walkthrough).
- **Advanced platform metrics** - A premium, [paid tier of platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform) in Azure Monitor that provide more granular observability for Azure resources.
- **Unit** - Unit of measure.
- **Aggregation** - The default [aggregation](/azure/azure-monitor/essentials/metrics-aggregation-explained) type. Valid values: Average, Minimum, Maximum, Total, Count.
- **Dimensions** - [Dimensions](/azure/azure-monitor/essentials/metrics-aggregation-explained#dimensions-splitting-and-filtering) available for the metric.
- **Time Grains** - [Intervals at which the metric is sampled](/azure/azure-monitor/essentials/metrics-aggregation-explained#granularity). For example, `PT1M` indicates that the metric is sampled every minute, `PT30M` every 30 minutes, `PT1H` every hour, and so on.
- **DS Export** -S Whether the metric is exportable to Azure Monitor Logs via Diagnostic Settings.

For information on exporting metrics, see - [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics) and [Create diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/create-diagnostic-settings?tabs=portal).

For information on metric retention, see [Azure Monitor Metrics overview](/azure/azure-monitor/essentials/data-platform-metrics#retention-of-metrics).



|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Active Requests (deprecated)**<br><br>Active Requests |`ActiveRequests` | No | Count |Total (Sum) |`Instance`|PT1M |Yes|
|**Average Response Time (deprecated)**<br><br>The average time taken for the front end to serve requests, in seconds. |`AverageResponseTime` | No | Seconds |Average |`Instance`|PT1M |Yes|
|**Data In**<br><br>The average incoming bandwidth used across all front ends, in MiB. |`BytesReceived` | No | Bytes |Total (Sum) |`Instance`|PT1M |Yes|
|**Data Out**<br><br>The average incoming bandwidth used across all front end, in MiB. |`BytesSent` | No | Bytes |Total (Sum) |`Instance`|PT1M |Yes|
|**CPU Percentage**<br><br>The average CPU used across all instances of front end. |`CpuPercentage` | No | Percent |Average |`Instance`|PT1M |Yes|
|**Disk Queue Length**<br><br>The average number of both read and write requests that were queued on storage. A high disk queue length is an indication of an app that might be slowing down because of excessive disk I/O. |`DiskQueueLength` | No | Count |Average |`Instance`|PT1M |Yes|
|**Http 101**<br><br>The count of requests resulting in an HTTP status code 101. |`Http101` | No | Count |Total (Sum) |`Instance`|PT1M |Yes|
|**Http 2xx**<br><br>The count of requests resulting in an HTTP status code >= 200 but < 300. |`Http2xx` | No | Count |Total (Sum) |`Instance`|PT1M |Yes|
|**Http 3xx**<br><br>The count of requests resulting in an HTTP status code >= 300 but < 400. |`Http3xx` | No | Count |Total (Sum) |`Instance`|PT1M |Yes|
|**Http 401**<br><br>The count of requests resulting in HTTP 401 status code. |`Http401` | No | Count |Total (Sum) |`Instance`|PT1M |Yes|
|**Http 403**<br><br>The count of requests resulting in HTTP 403 status code. |`Http403` | No | Count |Total (Sum) |`Instance`|PT1M |Yes|
|**Http 404**<br><br>The count of requests resulting in HTTP 404 status code. |`Http404` | No | Count |Total (Sum) |`Instance`|PT1M |Yes|
|**Http 406**<br><br>The count of requests resulting in HTTP 406 status code. |`Http406` | No | Count |Total (Sum) |`Instance`|PT1M |Yes|
|**Http 4xx**<br><br>The count of requests resulting in an HTTP status code >= 400 but < 500. |`Http4xx` | No | Count |Total (Sum) |`Instance`|PT1M |Yes|
|**Http Server Errors**<br><br>The count of requests resulting in an HTTP status code >= 500 but < 600. |`Http5xx` | No | Count |Total (Sum) |`Instance`|PT1M |Yes|
|**Http Queue Length**<br><br>The average number of HTTP requests that had to sit on the queue before being fulfilled. A high or increasing HTTP Queue length is a symptom of a plan under heavy load. |`HttpQueueLength` | No | Count |Average |`Instance`|PT1M |Yes|
|**Response Time**<br><br>The time taken for the front end to serve requests, in seconds. |`HttpResponseTime` | No | Seconds |Average |`Instance`|PT1M |Yes|
|**Large App Service Plan Workers**<br><br>Large App Service Plan Workers |`LargeAppServicePlanInstances` | No | Count |Average |\<none\>|PT1M |Yes|
|**Medium App Service Plan Workers**<br><br>Medium App Service Plan Workers |`MediumAppServicePlanInstances` | No | Count |Average |\<none\>|PT1M |Yes|
|**Memory Percentage**<br><br>The average memory used across all instances of front end. |`MemoryPercentage` | No | Percent |Average |`Instance`|PT1M |Yes|
|**Requests**<br><br>The total number of requests regardless of their resulting HTTP status code. |`Requests` | No | Count |Total (Sum) |`Instance`|PT1M |Yes|
|**Small App Service Plan Workers**<br><br>Small App Service Plan Workers |`SmallAppServicePlanInstances` | No | Count |Average |\<none\>|PT1M |Yes|
|**Total Front Ends**<br><br>Total Front Ends |`TotalFrontEnds` | No | Count |Average |\<none\>|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
