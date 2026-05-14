---
title: Supported metrics - Microsoft.HorizonDB/clusters
description: Reference for Microsoft.HorizonDB/clusters metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 05/14/2026
ms.custom: Microsoft.HorizonDB/clusters, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.HorizonDB/clusters

The following table lists the metrics available for the Microsoft.HorizonDB/clusters resource type.

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



### Category: Availability
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Postgres Instance Is Alive**<br><br>Indicates if the Postgres process is running |`PGHeartbeat` |Count |Average, Maximum, Minimum |`ReplicaName`|PT1M |No|

### Category: Errors
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Failed Connections**<br><br>Failed Connections |`ConnectionsFailed` |Count |Total (Sum) |`ReplicaName`|PT1M |No|

### Category: Saturation
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**CPU percent**<br><br>Host CPU utilization percent |`CpuPercent` |Percent |Average, Maximum, Minimum |`ReplicaName`|PT1M |No|
|**Memory percent**<br><br>Host memory utilization percent |`MemoryPercent` |Percent |Average, Maximum, Minimum |`ReplicaName`|PT1M |No|

### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Active Connections**<br><br>Active Database Connections |`ActiveConnections` |Count |Average, Maximum, Minimum |`ReplicaName`|PT1M |No|
|**Succeeded Connections**<br><br>Succeeded Connections |`ConnectionsSucceeded` |Count |Total (Sum) |`ReplicaName`|PT1M |No|
|**Max Connections**<br><br>Maximum Database connections configured in server parameters |`MaxConnections` |Count |Maximum |`ReplicaName`|PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Network Out**<br><br>Network Out across active connections |`NetworkBytesEgress` |Bytes |Total (Sum) |`ReplicaName`|PT1M |No|
|**Network In**<br><br>Network In across active connections |`NetworkBytesIngress` |Bytes |Total (Sum) |`ReplicaName`|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
