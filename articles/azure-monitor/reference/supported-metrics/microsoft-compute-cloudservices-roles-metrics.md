---
title: Supported metrics - Microsoft.Compute/cloudServices/roles
description: Reference for Microsoft.Compute/cloudServices/roles metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Compute/cloudServices/roles, arm

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Compute/cloudServices/roles

The following table lists the metrics available for the Microsoft.Compute/cloudServices/roles resource type.

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



|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Available Memory Bytes (Preview)**<br><br>Amount of physical memory, in bytes, immediately available for allocation to a process or for system use in the Virtual Machine |`Available Memory Bytes` |Bytes |Average |`RoleInstanceId`, `RoleId`|PT1M |Yes|
|**Disk Read Bytes**<br><br>Bytes read from disk during monitoring period |`Disk Read Bytes` |Bytes |Total (Sum) |`RoleInstanceId`, `RoleId`|PT1M |Yes|
|**Disk Read Operations/Sec**<br><br>Disk Read IOPS |`Disk Read Operations/Sec` |CountPerSecond |Average |`RoleInstanceId`, `RoleId`|PT1M |Yes|
|**Disk Write Bytes**<br><br>Bytes written to disk during monitoring period |`Disk Write Bytes` |Bytes |Total (Sum) |`RoleInstanceId`, `RoleId`|PT1M |Yes|
|**Disk Write Operations/Sec**<br><br>Disk Write IOPS |`Disk Write Operations/Sec` |CountPerSecond |Average |`RoleInstanceId`, `RoleId`|PT1M |Yes|
|**Network In Total**<br><br>The number of bytes received on all network interfaces by the Virtual Machine(s) (Incoming Traffic) |`Network In Total` |Bytes |Total (Sum) |`RoleInstanceId`, `RoleId`|PT1M |Yes|
|**Network Out Total**<br><br>The number of bytes out on all network interfaces by the Virtual Machine(s) (Outgoing Traffic) |`Network Out Total` |Bytes |Total (Sum) |`RoleInstanceId`, `RoleId`|PT1M |Yes|
|**Percentage CPU**<br><br>The percentage of allocated compute units that are currently in use by the Virtual Machine(s) |`Percentage CPU` |Percent |Average |`RoleInstanceId`, `RoleId`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
