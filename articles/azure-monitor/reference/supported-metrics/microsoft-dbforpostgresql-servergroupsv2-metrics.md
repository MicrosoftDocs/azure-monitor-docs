---
title: Supported metrics - Microsoft.DBForPostgreSQL/serverGroupsv2
description: Reference for Microsoft.DBForPostgreSQL/serverGroupsv2 metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.DBForPostgreSQL/serverGroupsv2, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.DBForPostgreSQL/serverGroupsv2

The following table lists the metrics available for the Microsoft.DBForPostgreSQL/serverGroupsv2 resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.DBForPostgreSQL/serverGroupsv2](../supported-logs/microsoft-dbforpostgresql-servergroupsv2-logs.md)


### Category: Latency
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Replication lag**<br><br>Allows to see how much read replica nodes are behind their counterparts in the primary cluster |`replication_lag` |MilliSeconds |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|

### Category: Saturation
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Reserved Memory percent**<br><br>Percentage of Commit Memory Limit Reserved by Applications |`apps_reserved_memory_percent` |Percent |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|
|**CPU Credits Consumed**<br><br>Total number of credits consumed by the node. Only available when burstable compute is provisioned on the node. |`cpu_credits_consumed` |Count |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|
|**CPU Credits Remaining**<br><br>Total number of credits available to burst. Only available when burstable compute is provisioned on the node. |`cpu_credits_remaining` |Count |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|
|**CPU percent**<br><br>CPU percent |`cpu_percent` |Percent |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|
|**Memory percent**<br><br>Memory percent |`memory_percent` |Percent |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|
|**Storage percent**<br><br>Storage percent |`storage_percent` |Percent |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|
|**Storage used**<br><br>Storage used |`storage_used` |Bytes |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|
|**VM Cached Bandwidth Consumed Percentage**<br><br>Percentage of cached disk bandwidth consumed by the VM |`vm_cached_bandwidth_percent` |Percent |Average |`ServerName`|PT1M |Yes|
|**VM Cached IOPS Consumed Percentage**<br><br>Percentage of cached disk IOPS consumed by the VM |`vm_cached_iops_percent` |Percent |Average |`ServerName`|PT1M |Yes|
|**VM Uncached Bandwidth Consumed Percentage**<br><br>Percentage of uncached disk bandwidth consumed by the VM |`vm_uncached_bandwidth_percent` |Percent |Average |`ServerName`|PT1M |Yes|
|**VM Uncached IOPS Consumed Percentage**<br><br>Percentage of uncached disk IOPS consumed by the VM |`vm_uncached_iops_percent` |Percent |Average |`ServerName`|PT1M |Yes|

### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Active Connections**<br><br>Active Connections |`active_connections` |Count |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|
|**IOPS**<br><br>IO operations per second |`iops` |Count |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|
|**Network Out**<br><br>Network Out across active connections |`network_bytes_egress` |Bytes |Total (Sum) |`ServerName`|PT1M |Yes|
|**Network In**<br><br>Network In across active connections |`network_bytes_ingress` |Bytes |Total (Sum) |`ServerName`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
