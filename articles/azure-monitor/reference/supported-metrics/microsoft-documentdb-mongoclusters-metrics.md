---
title: Supported metrics - Microsoft.DocumentDB/mongoClusters
description: Reference for Microsoft.DocumentDB/mongoClusters metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.DocumentDB/mongoClusters, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.DocumentDB/mongoClusters

The following table lists the metrics available for the Microsoft.DocumentDB/mongoClusters resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.DocumentDB/mongoClusters](../supported-logs/microsoft-documentdb-mongoclusters-logs.md)


### Category: Latency
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Mongo request duration**<br><br>The end-to-end duration in milliseconds of client Mongo DB requests handled by the Mongo cluster. Updated every 60 seconds. |`MongoRequestDurationMs` |Milliseconds |Average, Count, Maximum, Minimum, Total (Sum) |`Authentication`, `CollectionName`, `DatabaseName`, `ErrorCode`, `Operation`, `Protocol`, `ServerName`, `StatusCode`, `StatusCodeClass`, `StatusText`|PT1M |Yes|

### Category: Saturation
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Autoscale Utilization percent**<br><br>Percent Autoscale utilization |`AutoscaleUtilizationPercent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Committed Memory percent**<br><br>Percentage of Commit Memory Limit allocated by applications on node |`CommittedMemoryPercent` |Percent |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|
|**CPU percent**<br><br>Percent CPU utilization on node |`CpuPercent` |Percent |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|
|**Memory percent**<br><br>Percent memory utilization on node |`MemoryPercent` |Percent |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|
|**Storage percent**<br><br>Percent of available storage used on node |`StoragePercent` |Percent |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|
|**Storage used**<br><br>Quantity of available storage used on node |`StorageUsed` |Bytes |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|

### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**IOPS**<br><br>Disk IO operations per second on node |`IOPS` |Count |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|
|**Network bytes egress**<br><br>Network bytes sent on node |`NetworkBytesEgress` |Bytes |Average, Maximum, Minimum, Total (Sum) |`ServerName`|PT1M |Yes|
|**Network bytes ingress**<br><br>Network bytes received on node |`NetworkBytesIngress` |Bytes |Average, Maximum, Minimum, Total (Sum) |`ServerName`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
