---
title: Supported metrics - Microsoft.DigitalTwins/digitalTwinsInstances
description: Reference for Microsoft.DigitalTwins/digitalTwinsInstances metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.DigitalTwins/digitalTwinsInstances, arm

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.DigitalTwins/digitalTwinsInstances

The following table lists the metrics available for the Microsoft.DigitalTwins/digitalTwinsInstances resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.DigitalTwins/digitalTwinsInstances](../supported-logs/microsoft-digitaltwins-digitaltwinsinstances-logs.md)


|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**API Requests**<br><br>The number of API requests made for Digital Twins read, write, delete and query operations. |`ApiRequests` |Count |Total (Sum) |`Operation`, `Authentication`, `Protocol`, `StatusCode`, `StatusCodeClass`, `StatusText`|PT1M |Yes|
|**API Requests Failure Rate**<br><br>The percentage of API requests that the service receives for your instance that return an internal error (500) response code for Digital Twins read, write, delete and query operations. |`ApiRequestsFailureRate` |Percent |Average |`Operation`, `Authentication`, `Protocol`|PT1M |Yes|
|**API Requests Latency**<br><br>The response time for API requests, i.e. from when the request is received by Azure Digital Twins until the service sends a success/fail result for Digital Twins read, write, delete and query operations. |`ApiRequestsLatency` |Milliseconds |Average, Minimum, Maximum, Total (Sum) |`Operation`, `Authentication`, `Protocol`, `StatusCode`, `StatusCodeClass`, `StatusText`|PT1M |Yes|
|**Billing API Operations**<br><br>Billing metric for the count of all API requests made against the Azure Digital Twins service. |`BillingApiOperations` |Count |Average, Minimum, Maximum, Total (Sum) |`MeterId`|PT1M |Yes|
|**Billing Messages Processed**<br><br>Billing metric for the number of messages sent out from Azure Digital Twins to external endpoints. |`BillingMessagesProcessed` |Count |Average, Minimum, Maximum, Total (Sum) |`MeterId`|PT1M |Yes|
|**Billing Query Units**<br><br>The number of Query Units, an internally computed measure of service resource usage, consumed to execute queries. |`BillingQueryUnits` |Count |Average, Minimum, Maximum, Total (Sum) |`MeterId`|PT1M |Yes|
|**Data History Messages Routed (preview)**<br><br>The number of messages routed to a time series database. |`DataHistoryRouting` |Count |Total (Sum) |`EndpointType`, `Result`|PT1M |Yes|
|**Data History Routing Failure Rate (preview)**<br><br>The percentage of events that result in an error as they are routed from Azure Digital Twins to a time series database. |`DataHistoryRoutingFailureRate` |Percent |Average |`EndpointType`|PT1M |Yes|
|**Data History Routing Latency (preview)**<br><br>Time elapsed between an event getting routed from Azure Digital Twins to when it is posted to a time series database. |`DataHistoryRoutingLatency` |Milliseconds |Average, Minimum, Maximum, Total (Sum) |`EndpointType`, `Result`|PT1M |Yes|
|**Delete Job Entity Count**<br><br>The number of models, twins, and relationships deleted by a delete job. |`DeleteJobEntityCount` |Count |Average, Minimum, Maximum, Total (Sum) |`Operation`, `Result`|PT1M |Yes|
|**Delete Job Latency**<br><br>Total time taken for a delete job to complete. |`DeleteJobLatency` |Milliseconds |Average, Minimum, Maximum, Total (Sum) |`Operation`, `Authentication`, `Protocol`|PT1M |Yes|
|**Import Job Entity Count**<br><br>The number of twins, models, or relationships processed by an import job. |`ImportJobEntityCount` |Count |Average, Minimum, Maximum, Total (Sum) |`Operation`, `Result`|PT1M |Yes|
|**Import Job Latency**<br><br>Total time taken for an import job to complete. |`ImportJobLatency` |Milliseconds |Average, Minimum, Maximum, Total (Sum) |`Operation`, `Authentication`, `Protocol`|PT1M |Yes|
|**Ingress Events**<br><br>The number of incoming telemetry events into Azure Digital Twins. |`IngressEvents` |Count |Total (Sum) |`Result`|PT1M |Yes|
|**Ingress Events Failure Rate**<br><br>The percentage of incoming telemetry events for which the service returns an internal error (500) response code. |`IngressEventsFailureRate` |Percent |Average |\<none\>|PT1M |Yes|
|**Ingress Events Latency**<br><br>The time from when an event arrives to when it is ready to be egressed by Azure Digital Twins, at which point the service sends a success/fail result. |`IngressEventsLatency` |Milliseconds |Average, Minimum, Maximum, Total (Sum) |`Result`|PT1M |Yes|
|**Model Count**<br><br>Total number of models in the Azure Digital Twins instance. Use this metric to determine if you are approaching the service limit for max number of models allowed per instance. |`ModelCount` |Count |Average, Minimum, Maximum, Total (Sum) |\<none\>|PT1M |Yes|
|**Messages Routed**<br><br>The number of messages routed to an endpoint Azure service such as Event Hub, Service Bus or Event Grid. |`Routing` |Count |Total (Sum) |`EndpointType`, `Result`|PT1M |Yes|
|**Routing Failure Rate**<br><br>The percentage of events that result in an error as they are routed from Azure Digital Twins to an endpoint Azure service such as Event Hub, Service Bus or Event Grid. |`RoutingFailureRate` |Percent |Average |`EndpointType`|PT1M |Yes|
|**Routing Latency**<br><br>Time elapsed between an event getting routed from Azure Digital Twins to when it is posted to the endpoint Azure service such as Event Hub, Service Bus or Event Grid. |`RoutingLatency` |Milliseconds |Average, Minimum, Maximum, Total (Sum) |`EndpointType`, `Result`|PT1M |Yes|
|**Twin Count**<br><br>Total number of twins in the Azure Digital Twins instance. Use this metric to determine if you are approaching the service limit for max number of twins allowed per instance. |`TwinCount` |Count |Average, Minimum, Maximum, Total (Sum) |\<none\>|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
