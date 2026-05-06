---
title: Supported metrics - Microsoft.DBforPostgreSQL/serversv2
description: Reference for Microsoft.DBforPostgreSQL/serversv2 metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 03/31/2026
ms.custom: Microsoft.DBforPostgreSQL/serversv2, arm

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.DBforPostgreSQL/serversv2

The following table lists the metrics available for the Microsoft.DBforPostgreSQL/serversv2 resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.DBforPostgreSQL/serversv2](../supported-logs/microsoft-dbforpostgresql-serversv2-logs.md)


### Category: Saturation
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**CPU percent**<br><br>CPU percent |`cpu_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**IOPS**<br><br>IO Operations per second |`iops` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Memory percent**<br><br>Memory percent |`memory_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Storage percent**<br><br>Storage percent |`storage_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Storage used**<br><br>Storage used |`storage_used` |Bytes |Average, Maximum, Minimum |\<none\>|PT1M |Yes|

### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Active Connections**<br><br>Active Connections |`active_connections` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Network Out**<br><br>Network Out across active connections |`network_bytes_egress` |Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**Network In**<br><br>Network In across active connections |`network_bytes_ingress` |Bytes |Total (Sum) |\<none\>|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
