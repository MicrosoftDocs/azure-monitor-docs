---
title: Supported metrics - Microsoft.Storage/contextCaches/contextCacheContainers
description: Reference for Microsoft.Storage/contextCaches/contextCacheContainers metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 08/21/2026
ms.custom: Microsoft.Storage/contextCaches/contextCacheContainers, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Storage/contextCaches/contextCacheContainers

The following table lists the metrics available for the Microsoft.Storage/contextCaches/contextCacheContainers resource type.

**Table headings**

- **Metric** - The metric display name as it appears in the Azure portal.
- **Name in Rest API** - Metric name as referred to in the [REST API](/azure/azure-monitor/essentials/rest-api-walkthrough).
- **Advanced platform metrics** - A premium, [paid tier of platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform) in Azure Monitor that provide more granular observability for Azure resources.
- **Unit** - Unit of measure.
- **Aggregation** - The default [aggregation](/azure/azure-monitor/essentials/metrics-aggregation-explained) type. Valid values: Average, Minimum, Maximum, Total, Count.
- **Dimensions** - [Dimensions](/azure/azure-monitor/essentials/metrics-aggregation-explained#dimensions-splitting-and-filtering) available for the metric.
- **Time Grains** - [Intervals at which the metric is sampled](/azure/azure-monitor/essentials/metrics-aggregation-explained#granularity). For example, `PT1M` indicates that the metric is sampled every minute, `PT30M` every 30 minutes, `PT1H` every hour, and so on.
- **DS Export** - Shows whether the metric is exportable to Azure Monitor Logs via Diagnostic Settings.

For information on exporting metrics, see - [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics) and [Create diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/create-diagnostic-settings?tabs=portal).

For information on metric retention, see [Azure Monitor Metrics overview](/azure/azure-monitor/essentials/data-platform-metrics#retention-of-metrics).



### Category: Latency
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Lookup latency**<br><br>End-to-end latency of Lookup requests. Only successful requests with a bounded latency are included. |`LookupLatency` | No | MilliSeconds |Average, Minimum, Maximum, Total (Sum), Count |`providerName`, `modelName`|PT1M |Yes|
|**Read latency**<br><br>End-to-end latency of StreamingRead requests. Only successful requests with a bounded latency are included. |`ReadLatency` | No | MilliSeconds |Average, Minimum, Maximum, Total (Sum), Count |`providerName`, `modelName`|PT1M |Yes|
|**Write latency**<br><br>End-to-end latency of Write requests. Only successful requests with a bounded latency are included. |`WriteLatency` | No | MilliSeconds |Average, Minimum, Maximum, Total (Sum), Count |`providerName`, `modelName`|PT1M |Yes|

### Category: Traffic
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Cache hit rate**<br><br>Percentage of prompt tokens served from cache (token-weighted). Derived as CacheHitCount / (CacheHitCount + CacheMissCount) x 100 over successful Lookups. |`CacheHitRate` | No | Percent |Average, Minimum, Maximum |`providerName`, `modelName`|PT1M |Yes|
|**Read tokens per minute**<br><br>StreamingRead throughput in tokens per minute. Derived as sum(ReadSize) over 1-minute windows grouped by container. |`ReadTpm` | No | Count |Average, Minimum, Maximum |`providerName`, `modelName`|PT1M |Yes|
|**Write tokens per minute**<br><br>Write throughput in tokens per minute. Derived as sum(WriteSize) over 1-minute windows grouped by container. |`WriteTpm` | No | Count |Average, Minimum, Maximum |`providerName`, `modelName`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
