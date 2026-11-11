---
title: Supported metrics - Microsoft.AzureStackHCI/edgeMachines
description: Reference for Microsoft.AzureStackHCI/edgeMachines metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 09/28/2026
ms.custom: Microsoft.AzureStackHCI/edgeMachines, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.AzureStackHCI/edgeMachines

The following table lists the metrics available for the Microsoft.AzureStackHCI/edgeMachines resource type.

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



### Category: Capacity
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**GPU Memory Total**<br><br>Total GPU memory reported by NVML in mebibytes. Unified-memory platforms can report zero when framebuffer memory is unavailable through NVML. |`GpuMemoryTotal` | No | Unspecified |Minimum, Maximum, Average, Total (Sum), Count |`GpuIndex`, `GpuName`, `GpuUuid`, `GpuPciAddress`, `EdgeMachineName`, `Region`|PT1M |No|
|**GPU Memory Used**<br><br>GPU memory in use reported by NVML in mebibytes. Unified-memory platforms can report zero when framebuffer memory is unavailable through NVML. |`GpuMemoryUsed` | No | Unspecified |Minimum, Maximum, Average, Total (Sum), Count |`GpuIndex`, `GpuName`, `GpuUuid`, `GpuPciAddress`, `EdgeMachineName`, `Region`|PT1M |No|

### Category: Errors
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Network Errors**<br><br>Count of network errors on interfaces. |`system.network.errors` | No | Count |Minimum, Maximum, Average, Total (Sum), Count |`direction`, `device`, `EdgeMachineName`, `region`|PT1M |Yes|

### Category: Information
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**GPU Information**<br><br>GPU identity and driver metadata. The metric value is always one. |`GpuInfo` | No | Count |Minimum, Maximum, Average, Total (Sum), Count |`GpuIndex`, `GpuName`, `GpuUuid`, `GpuPciAddress`, `GpuDriverVersion`, `EdgeMachineName`, `Region`|PT1M |No|

### Category: Performance
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**GPU Graphics Clock Speed**<br><br>Current GPU graphics clock speed in megahertz. |`GpuGraphicsClockSpeed` | No | Unspecified |Minimum, Maximum, Average, Total (Sum), Count |`GpuIndex`, `GpuName`, `GpuUuid`, `GpuPciAddress`, `EdgeMachineName`, `Region`|PT1M |No|
|**GPU Memory Clock Speed**<br><br>Current GPU memory clock speed in megahertz. |`GpuMemoryClockSpeed` | No | Unspecified |Minimum, Maximum, Average, Total (Sum), Count |`GpuIndex`, `GpuName`, `GpuUuid`, `GpuPciAddress`, `EdgeMachineName`, `Region`|PT1M |No|

### Category: Resource Utilization
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**GPU Power**<br><br>Instantaneous GPU power draw in watts. |`GpuPower` | No | Unspecified |Minimum, Maximum, Average, Total (Sum), Count |`GpuIndex`, `GpuName`, `GpuUuid`, `GpuPciAddress`, `EdgeMachineName`, `Region`|PT1M |No|

### Category: Saturation
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**GPU Memory Utilization**<br><br>Percentage of GPU memory-controller or memory-bandwidth activity reported by NVML. |`GpuMemoryUtilization` | No | Percent |Minimum, Maximum, Average, Total (Sum), Count |`GpuIndex`, `GpuName`, `GpuUuid`, `GpuPciAddress`, `EdgeMachineName`, `Region`|PT1M |No|
|**GPU Temperature**<br><br>Current GPU core temperature in degrees Celsius. |`GpuTemperature` | No | Unspecified |Minimum, Maximum, Average, Total (Sum), Count |`GpuIndex`, `GpuName`, `GpuUuid`, `GpuPciAddress`, `EdgeMachineName`, `Region`|PT1M |No|
|**GPU Utilization**<br><br>Percentage of time the GPU was not idle. |`GpuUtilization` | No | Percent |Minimum, Maximum, Average, Total (Sum), Count |`GpuIndex`, `GpuName`, `GpuUuid`, `GpuPciAddress`, `EdgeMachineName`, `Region`|PT1M |No|
|**Disk IO Time**<br><br>Time disk spent activated. |`system.disk.io_time` | No | Seconds |Minimum, Maximum, Average, Total (Sum), Count |`device`, `EdgeMachineName`, `region`|PT1M |Yes|
|**Disk Operation Time**<br><br>Time spent in disk operations. |`system.disk.operation_time` | No | Seconds |Minimum, Maximum, Average, Total (Sum), Count |`direction`, `device`, `EdgeMachineName`, `region`|PT1M |Yes|
|**Filesystem Inodes Usage**<br><br>Number of filesystem inodes used or free. |`system.filesystem.inodes.usage` | No | Count |Minimum, Maximum, Average, Total (Sum), Count |`device`, `mode`, `mountpoint`, `state`, `type`, `EdgeMachineName`, `region`|PT1M |Yes|
|**Filesystem Usage**<br><br>Filesystem bytes used or free per partition. |`system.filesystem.usage` | No | Bytes |Minimum, Maximum, Average, Total (Sum), Count |`device`, `mode`, `mountpoint`, `state`, `type`, `EdgeMachineName`, `region`|PT1M |Yes|
|**Filesystem Utilization**<br><br>Percentage of filesystem space used per partition. |`system.filesystem.utilization` | No | Percent |Minimum, Maximum, Average, Total (Sum), Count |`device`, `mode`, `mountpoint`, `type`, `EdgeMachineName`, `region`|PT1M |Yes|

### Category: Traffic
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Disk IO Bytes**<br><br>Rate of bytes read from or written to disk devices. |`system.disk.io` | No | BytesPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`direction`, `device`, `EdgeMachineName`, `region`|PT1M |Yes|
|**Disk Operations**<br><br>Rate of read or write operations on disk devices. |`system.disk.operations` | No | CountPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`direction`, `device`, `EdgeMachineName`, `region`|PT1M |Yes|
|**Network Connections**<br><br>Count of network connections by state and protocol. |`system.network.connections` | No | Count |Minimum, Maximum, Average, Total (Sum), Count |`protocol`, `state`, `EdgeMachineName`, `region`|PT1M |Yes|
|**Network IO Bytes**<br><br>Rate of bytes received or transmitted by network interfaces. |`system.network.io` | No | BytesPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`direction`, `device`, `EdgeMachineName`, `region`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
