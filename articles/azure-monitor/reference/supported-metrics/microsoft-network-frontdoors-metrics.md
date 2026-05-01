---
title: Supported metrics - Microsoft.Network/frontdoors
description: Reference for Microsoft.Network/frontdoors metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Network/frontdoors, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Network/frontdoors

The following table lists the metrics available for the Microsoft.Network/frontdoors resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.Network/frontdoors](../supported-logs/microsoft-network-frontdoors-logs.md)


### Category: Backend Health
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Backend Health Percentage**<br><br>The percentage of successful health probes from the HTTP/S proxy to backends |`BackendHealthPercentage` |Percent |Average |`Backend`, `BackendPool`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|

### Category: Latency
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Backend Request Latency**<br><br>The time calculated from when the request was sent by the HTTP/S proxy to the backend until the HTTP/S proxy received the last response byte from the backend |`BackendRequestLatency` |MilliSeconds |Average |`Backend`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Total Latency**<br><br>The time calculated from when the client request was received by the HTTP/S proxy until the client acknowledged the last response byte from the HTTP/S proxy |`TotalLatency` |MilliSeconds |Average |`HttpStatus`, `HttpStatusGroup`, `ClientRegion`, `ClientCountry`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|

### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Backend Request Count**<br><br>The number of requests sent from the HTTP/S proxy to backends |`BackendRequestCount` |Count |Total (Sum) |`HttpStatus`, `HttpStatusGroup`, `Backend`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Billable Response Size**<br><br>The number of billable bytes (minimum 2KB per request) sent as responses from HTTP/S proxy to clients. |`BillableResponseSize` |Bytes |Total (Sum) |`HttpStatus`, `HttpStatusGroup`, `ClientRegion`, `ClientCountry`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Request Count**<br><br>The number of client requests served by the HTTP/S proxy |`RequestCount` |Count |Total (Sum) |`HttpStatus`, `HttpStatusGroup`, `ClientRegion`, `ClientCountry`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Request Size**<br><br>The number of bytes sent as requests from clients to the HTTP/S proxy |`RequestSize` |Bytes |Total (Sum) |`HttpStatus`, `HttpStatusGroup`, `ClientRegion`, `ClientCountry`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Response Size**<br><br>The number of bytes sent as responses from HTTP/S proxy to clients |`ResponseSize` |Bytes |Total (Sum) |`HttpStatus`, `HttpStatusGroup`, `ClientRegion`, `ClientCountry`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Web Application Firewall Request Count**<br><br>The number of client requests processed by the Web Application Firewall |`WebApplicationFirewallRequestCount` |Count |Total (Sum) |`PolicyName`, `RuleName`, `Action`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
