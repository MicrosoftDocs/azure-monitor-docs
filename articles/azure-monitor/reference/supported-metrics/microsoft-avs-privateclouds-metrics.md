---
title: Supported metrics - microsoft.avs/privateClouds
description: Reference for microsoft.avs/privateClouds metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: microsoft.avs/privateClouds, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for microsoft.avs/privateClouds

The following table lists the metrics available for the microsoft.avs/privateClouds resource type.

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


For a list of supported logs, see [Supported log categories - microsoft.avs/privateClouds](../supported-logs/microsoft-avs-privateclouds-logs.md)


### Category: Cluster
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Percentage CPU**<br><br>Percentage of Used CPU resources in Cluster |`EffectiveCpuAverage` |Percent |Average |`clustername`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Average Effective Memory**<br><br>Total available amount of machine memory in cluster |`EffectiveMemAverage` |Bytes |Average |`clustername`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Average Memory Overhead**<br><br>Host physical memory consumed by the virtualization infrastructure |`OverheadAverage` |Bytes |Average |`clustername`|PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Average Total Memory**<br><br>Total memory in cluster |`TotalMbAverage` |Bytes |Average |`clustername`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Average Memory Usage**<br><br>Memory usage as percentage of total configured or available memory |`UsageAverage` |Percent |Average |`clustername`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|

### Category: Cluster (new)
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Average Effective Memory (new)**<br><br>Total available amount of machine memory in cluster |`ClusterSummaryEffectiveMemory` |Bytes |Average |`clustername`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Average Total Memory (new)**<br><br>Total memory in cluster |`ClusterSummaryTotalMemCapacityMB` |Bytes |Average |`clustername`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Percentage CPU (new)**<br><br>Percentage of Used CPU resources in Cluster |`CpuUsageAverage` |Percent |Average |`clustername`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Average Memory Overhead (new)**<br><br>Host physical memory consumed by the virtualization infrastructure |`MemOverheadAverage` |Bytes |Average |`clustername`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Average Memory Usage (new)**<br><br>Memory usage as percentage of total configured or available memory |`MemUsageAverage` |Percent |Average |`clustername`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|

### Category: Datastore
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Datastore Disk Total Capacity**<br><br>The total capacity of disk in the datastore |`CapacityLatest` |Bytes |Average |`dsname`|PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Datastore Disk Used**<br><br>The total amount of disk used in the datastore |`UsedLatest` |Bytes |Average |`dsname`|PT30M, PT1H, PT6H, PT12H, P1D |Yes|

### Category: Datastore (new)
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Datastore Disk Total Capacity (new)**<br><br>The total capacity of disk in the datastore |`DiskCapacityLatest` |Bytes |Average |`dsname`|PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Datastore Disk Used (new)**<br><br>The total amount of disk used in the datastore |`DiskUsedLatest` |Bytes |Average |`dsname`|PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Percentage Datastore Disk Used (new)**<br><br>Percent of available disk used in Datastore |`DiskUsedPercentage` |Percent |Average |`dsname`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
