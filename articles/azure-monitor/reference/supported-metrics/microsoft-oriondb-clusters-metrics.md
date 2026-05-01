---
title: Supported metrics - Microsoft.OrionDB/clusters
description: Reference for Microsoft.OrionDB/clusters metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 01/20/2026
ms.custom: Microsoft.OrionDB/clusters, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.OrionDB/clusters

The following table lists the metrics available for the Microsoft.OrionDB/clusters resource type.

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
|**Database Is Alive**<br><br>Indicates if the database process is running |`is_db_alive` |Count |Average, Maximum, Minimum |`ReplicaName`|PT1M |No|

### Category: Errors
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Failed Connections**<br><br>Failed Connections |`connections_failed` |Count |Total (Sum) |`ReplicaName`|PT1M |Yes|

### Category: Saturation
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**CPU percent**<br><br>Host CPU utilization percent |`cpu_percent` |Percent |Average, Maximum, Minimum |`ReplicaName`|PT1M |Yes|
|**Memory percent**<br><br>Host memory utilization percent |`memory_percent` |Percent |Average, Maximum, Minimum |`ReplicaName`|PT1M |Yes|

### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Active Connections**<br><br>Active Database Connections |`active_connections` |Count |Average, Maximum, Minimum |`ReplicaName`|PT1M |Yes|
|**Succeeded Connections**<br><br>Succeeded Connections |`connections_succeeded` |Count |Total (Sum) |`ReplicaName`|PT1M |Yes|
|**Max Connections**<br><br>Maximum Database connections configured in server parameters |`max_connections` |Count |Maximum |`ReplicaName`|PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Network Out**<br><br>Network Out across active connections |`network_bytes_egress` |Bytes |Total (Sum) |`ReplicaName`|PT1M |Yes|
|**Network In**<br><br>Network In across active connections |`network_bytes_ingress` |Bytes |Total (Sum) |`ReplicaName`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
