---
title: Supported metrics - microsoft.bing/accounts
description: Reference for microsoft.bing/accounts metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: microsoft.bing/accounts, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for microsoft.bing/accounts

The following table lists the metrics available for the microsoft.bing/accounts resource type.

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



### Category: Errors
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Client Errors**<br><br>Number of calls with any client error (HTTP status code 4xx) |`ClientErrors` |Count |Total (Sum) |`ApiName`, `ServingRegion`, `StatusCode`|PT1M |Yes|
|**Server Errors**<br><br>Number of calls with any server error (HTTP status code 5xx) |`ServerErrors` |Count |Total (Sum) |`ApiName`, `ServingRegion`, `StatusCode`|PT1M |Yes|
|**Total Errors**<br><br>Number of calls with any error (HTTP status code 4xx or 5xx) |`TotalErrors` |Count |Total (Sum) |`ApiName`, `ServingRegion`, `StatusCode`|PT1M |Yes|

### Category: Latency
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Latency**<br><br>Latency in milliseconds |`Latency` |Milliseconds |Average, Minimum, Maximum |`ApiName`, `ServingRegion`, `StatusCode`|PT1M |Yes|

### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Blocked Calls**<br><br>Number of calls that exceeded the rate or quota limit |`BlockedCalls` |Count |Total (Sum) |`ApiName`, `ServingRegion`, `StatusCode`|PT1M |Yes|
|**Data In**<br><br>Incoming request Content-Length in bytes |`DataIn` |Bytes |Total (Sum) |`ApiName`, `ServingRegion`, `StatusCode`|PT1M |Yes|
|**Data Out**<br><br>Outgoing response Content-Length in bytes |`DataOut` |Bytes |Total (Sum) |`ApiName`, `ServingRegion`, `StatusCode`|PT1M |Yes|
|**Successful Calls**<br><br>Number of successful calls (HTTP status code 2xx) |`SuccessfulCalls` |Count |Total (Sum) |`ApiName`, `ServingRegion`, `StatusCode`|PT1M |Yes|
|**Total Calls**<br><br>Total number of calls |`TotalCalls` |Count |Total (Sum) |`ApiName`, `ServingRegion`, `StatusCode`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
