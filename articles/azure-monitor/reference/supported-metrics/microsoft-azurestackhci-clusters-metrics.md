---
title: Supported metrics - Microsoft.azurestackhci/clusters
description: Reference for Microsoft.azurestackhci/clusters metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: Microsoft.azurestackhci/clusters, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.azurestackhci/clusters

The following table lists the metrics available for the Microsoft.azurestackhci/clusters resource type.

**Table headings**

- **Metric** - The metric display name as it appears in the Azure portal.
- **Name in Rest API** - Metric name as referred to in the [REST API](/azure/azure-monitor/essentials/rest-api-walkthrough).
- **Advanced platform metrics** - A premium, [paid tier of platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform) in Azure Monitor that provide more granular observability for Azure resources.
- **Unit** - Unit of measure.
- **Aggregation** - The default [aggregation](/azure/azure-monitor/essentials/metrics-aggregation-explained) type. Valid values: Average, Minimum, Maximum, Total, Count.
- **Dimensions** - [Dimensions](/azure/azure-monitor/essentials/metrics-aggregation-explained#dimensions-splitting-and-filtering) available for the metric.
- **Time Grains** - [Intervals at which the metric is sampled](/azure/azure-monitor/essentials/metrics-aggregation-explained#granularity). For example, `PT1M` indicates that the metric is sampled every minute, `PT30M` every 30 minutes, `PT1H` every hour, and so on.
- **DS Export** -S Whether the metric is exportable to Azure Monitor Logs via Diagnostic Settings.

For information on exporting metrics, see - [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics) and [Create diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/create-diagnostic-settings?tabs=portal).

For information on metric retention, see [Azure Monitor Metrics overview](/azure/azure-monitor/essentials/data-platform-metrics#retention-of-metrics).



### Category: Availability
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Memory Used**<br><br>The used memory of the node. |`Clusternode Memory Used` | No | Bytes |Minimum, Maximum, Average |`ClusterName`, `ClusterNodeName`|PT1M |Yes|
|**Vm Memory Pressure**<br><br>The ratio of memory demanded by the virtual machine over memory allocated to the virtual machine. |`Hyper-V Dynamic Memory VM\Current Pressure` | No | Percent |Minimum, Maximum, Average |`ClusterName`, `ClusterNodeName`, `Instance`, `LUN`|PT1M |Yes|
|**Vm Memory Total**<br><br>Total memory. |`Hyper-V Dynamic Memory VM\Guest Visible Physical Memory` | No | Bytes |Minimum, Maximum, Average |`ClusterName`, `ClusterNodeName`, `Instance`, `LUN`|PT1M |Yes|
|**Memory Available**<br><br>The available memory of the node. |`Memory\Available Bytes` | No | Bytes |Minimum, Maximum, Average |`ClusterName`, `ClusterNodeName`|PT1M |Yes|
|**Memory Total**<br><br>The total physical memory of the node. |`NUMA Node Memory\Total MBytes` | No | Bytes |Minimum, Maximum, Average |`ClusterName`, `ClusterNodeName`|PT1M |Yes|
|**Physicaldisk Capacity Size Total**<br><br>The total storage capacity of the drive. |`Physicaldisk Capacity Size Total` | No | Bytes |Minimum, Maximum, Average |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|
|**Vhd Size Current**<br><br>The current file size of the virtual hard disk, if dynamically expanding. If fixed, the series is not collected. |`VHD Size Current` | No | Bytes |Minimum, Maximum, Average |`ClusterName`, `ClusterNodeName`, `Instance`|PT1M |Yes|
|**Vhd Size Maximum**<br><br>The maximum size of the virtual hard disk, if dynamically expanding. If fixed, the series is the size. |`VHD Size Maximum` | No | Bytes |Minimum, Maximum, Average |`ClusterName`, `ClusterNodeName`, `Instance`|PT1M |Yes|
|**Vm Memory Assigned**<br><br>The quantity of memory assigned to the virtual machine. |`VM Assigned Memory` | No | Bytes |Minimum, Maximum, Average |`ClusterName`, `ClusterNodeName`, `Instance`, `LUN`|PT1M |Yes|
|**Vm Memory Maximum**<br><br>If using dynamic memory, this is the maximum quantity of memory that may be assigned to the virtual machine. |`vm memory maximum` | No | Bytes |Minimum, Maximum, Average |`ClusterName`, `ClusterNodeName`, `Instance`, `LUN`|PT1M |Yes|
|**Vm Memory Minimum**<br><br>If using dynamic memory, this is the minimum quantity of memory that may be assigned to the virtual machine. |`vm memory minimum` | No | Bytes |Minimum, Maximum, Average |`ClusterName`, `ClusterNodeName`, `Instance`, `LUN`|PT1M |Yes|
|**Vm Memory Startup**<br><br>The quantity of memory required for the virtual machine to start. |`Vm Memory Startup` | No | Bytes |Minimum, Maximum, Average |`ClusterName`, `ClusterNodeName`, `Instance`, `LUN`|PT1M |Yes|
|**VM Memory Used**<br><br>The used memory. |`VM Memory Used` | No | Bytes |Minimum, Maximum, Average |`ClusterName`, `ClusterNodeName`, `Instance`, `LUN`|PT1M |Yes|
|**Volume Size Total**<br><br>The total storage capacity of the volume. |`volume size total` | No | Bytes |Minimum, Maximum, Average |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|

### Category: Errors
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Storage Degraded**<br><br>Total number of failed or missing drives in the storage pool. |`Cluster Node Storage Degraded` | No | Bytes |Minimum, Maximum, Total (Sum), Count, Average |`ClusterName`, `ClusterNodeName`|PT1M |Yes|

### Category: Latency
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Volume Latency Read**<br><br>Average latency of read operations from this volume. |`Cluster CSVFS\Avg. sec/Read` | No | Seconds |Minimum, Maximum, Average, Total (Sum) |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|
|**Volume Latency Write**<br><br>Average latency of write operations to this volume. |`Cluster CSVFS\Avg. sec/Write` | No | Seconds |Minimum, Maximum, Average, Total (Sum) |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|
|**Vhd Latency Average**<br><br>Average latency of all operations to or from the virtual hard disk. |`Hyper-V Virtual Storage Device\Latency` | No | Seconds |Minimum, Maximum, Average, Total (Sum) |`ClusterName`, `ClusterNodeName`, `Instance`|PT1M |Yes|
|**Physicaldisk Latency Read**<br><br>Average latency of read operations from the drive. |`PhysicalDisk\Avg. Disk sec/Read` | No | Seconds |Minimum, Maximum, Average, Total (Sum) |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|
|**Physicaldisk Latency Average**<br><br>Average latency of all operations to or from the drive. |`PhysicalDisk\Avg. Disk sec/Transfer` | No | Seconds |Minimum, Maximum, Average, Total (Sum) |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|
|**Physicaldisk Latency Write**<br><br>Average latency of write operations to the drive. |`PhysicalDisk\Avg. Disk sec/Write` | No | Seconds |Minimum, Maximum, Average, Total (Sum) |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|
|**Volume Latency Average**<br><br>Average latency of all operations to or from this volume. |`Volume Latency Average` | No | Seconds |Minimum, Maximum, Total (Sum), Average |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|

### Category: Saturation
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Percentage CPU Guest**<br><br>Percentage of processor time used for guest (virtual machine) demand. |`Clusternode CPU Usage Guest` | No | Percent |Minimum, Maximum, Total (Sum), Count, Average |`ClusterName`, `ClusterNodeName`|PT1M |Yes|
|**Percentage Memory**<br><br>The allocated (not available) memory of the node. |`ClusterNode Memory Usage` | No | Percent |Minimum, Maximum, Total (Sum), Count, Average |`ClusterName`, `ClusterNodeName`|PT1M |Yes|
|**Percentage GPU Memory**<br><br>The percentage of GPU memory in use. |`GpuMemoryConsumption` | No | Percent |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `GpuIndex`, `GpuName`, `GpuPciAddress`, `GpuUuid`|PT1M |Yes|
|**GPU Temperature**<br><br>The current temperature of the GPU in degrees Celsius. |`GpuTemperature` | No | Count |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `GpuIndex`, `GpuName`, `GpuPciAddress`, `GpuUuid`|PT1M |Yes|
|**Percentage GPU**<br><br>The percentage of time the GPU was busy processing. |`GpuUsage` | No | Percent |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `GpuIndex`, `GpuName`, `GpuPciAddress`, `GpuUuid`|PT1M |Yes|
|**Percentage CPU**<br><br>The percentage of processor time that is not idle. |`Hyper-V Hypervisor Logical Processor\% Total Run Time` | No | Percent |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`|PT1M |Yes|
|**Percentage CPU Host**<br><br>Percentage of processor time used for host demand. |`Hyper-V Hypervisor Root Virtual Processor\% Guest Run Time` | No | Percent |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`|PT1M |Yes|
|**Percentage Memory Guest**<br><br>The memory allocated to guest (virtual machine) demand. |`Percentage Memory Guest` | No | Percent |Minimum, Maximum, Total (Sum), Count, Average |`ClusterName`, `ClusterNodeName`|PT1M |Yes|
|**Percentage Memory Host**<br><br>The memory allocated to host demand. |`Percentage Memory Host` | No | Percent |Minimum, Maximum, Total (Sum), Count, Average |`ClusterName`, `ClusterNodeName`|PT1M |Yes|
|**Physicaldisk Capacity Size Used**<br><br>The used storage capacity of the drive. |`Physicaldisk Capacity Size Used` | No | Bytes |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|
|**Vm Percentage CPU**<br><br>Percentage the virtual machine is using of its host processor(s). |`Virtual Processor Guest Run Time` | No | Percent |Minimum, Maximum, Total (Sum), Count, Average |`ClusterName`, `ClusterNodeName`, `Instance`|PT1M |Yes|
|**Vm Memory Available**<br><br>The quantity of memory that remains available, of the amount assigned. |`VM Memory Available` | No | Bytes |Minimum, Maximum, Total (Sum), Count, Average |`ClusterName`, `ClusterNodeName`, `Instance`, `LUN`|PT1M |Yes|
|**Volume Size Available**<br><br>The available storage capacity of the volume. |`volume size available` | No | Bytes |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|

### Category: Traffic
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Disk Read Bytes/Sec**<br><br>Quantity of data read from this volume per second. |`Cluster CSVFS\Read Bytes/sec` | No | BytesPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|
|**Disk Read Operations/Sec**<br><br>Number of read operations per second completed by this volume. |`Cluster CSVFS\Reads/sec` | No | CountPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|
|**Disk Write Bytes/Sec**<br><br>Quantity of data written to this volume per second. |`Cluster CSVFS\Write Bytes/sec` | No | BytesPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|
|**Disk Write Operations/Sec**<br><br>Number of write operations per second completed by this volume. |`Cluster CSVFS\Writes/sec` | No | CountPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|
|**Csvcache Read Hit**<br><br>Cache hit PerSecond for read operations. |`Clusternode CsvCache Read Hit` | No | CountPerSecond |Minimum, Maximum, Total (Sum), Count, Average |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|
|**Csvcache Read Hitrate**<br><br>Cache hit rate for read operations. |`Clusternode Csvcache Read Hitrate` | No | Percent |Minimum, Maximum, Total (Sum), Count, Average |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|
|**Csvcache Read Miss**<br><br>Cache missPerSecond for read operations. |`Clusternode Csvcache Read Miss` | No | CountPerSecond |Minimum, Maximum, Total (Sum), Count, Average |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|
|**GPU Graphics Clock Speed**<br><br>The current graphics clock speed of the GPU in MHz. |`GpuGraphicsClockSpeed` | No | CountPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `GpuIndex`, `GpuName`, `GpuPciAddress`, `GpuUuid`|PT1M |Yes|
|**GPU Memory Clock Speed**<br><br>The current memory clock speed of the GPU in MHz. |`GpuMemoryClockSpeed` | No | CountPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `GpuIndex`, `GpuName`, `GpuPciAddress`, `GpuUuid`|PT1M |Yes|
|**Vmnetworkadapter Network In/Sec**<br><br>Rate of data received by the virtual machine across all its virtual network adapters. |`Hyper-V Virtual Network Adapter\Bytes Received/sec` | No | BitsPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `Instance`|PT1M |Yes|
|**Vmnetworkadapter Network Out/Sec**<br><br>Rate of data sent by the virtual machine across all its virtual network adapters. |`Hyper-V Virtual Network Adapter\Bytes Sent/sec` | No | BitsPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `Instance`|PT1M |Yes|
|**Vmnetworkadapter Network In and Out/Sec**<br><br>Total rate of data received or sent by the virtual machine across all its virtual network adapters. |`Hyper-V Virtual Network Adapter\Bytes/sec` | No | BitsPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `Instance`|PT1M |Yes|
|**Vhd Read Bytes/Sec**<br><br>Quantity of data read from the virtual hard disk per second. |`Hyper-V Virtual Storage Device\Read Bytes/sec` | No | BytesPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `Instance`|PT1M |Yes|
|**Vhd Read Operations/Sec**<br><br>Number of read operations per second completed by the virtual hard disk. |`Hyper-V Virtual Storage Device\Read Operations/Sec` | No | CountPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `Instance`|PT1M |Yes|
|**Vhd Write Bytes/Sec**<br><br>Quantity of data written to the virtual hard disk per second. |`Hyper-V Virtual Storage Device\Write Bytes/sec` | No | BytesPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `Instance`|PT1M |Yes|
|**Vhd Write Operations/Sec**<br><br>Number of write operations per second completed by the virtual hard disk. |`Hyper-V Virtual Storage Device\Write Operations/Sec` | No | CountPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `Instance`|PT1M |Yes|
|**Netadapter Bandwidth Rdma Total**<br><br>Total rate of data received or sent over RDMA by the network adapter. |`Netadapter Bandwidth Rdma Total` | No | BytesPerSecond |Minimum, Maximum, Total (Sum), Count, Average |`ClusterName`, `ClusterNodeName`, `Instance`, `LUN`|PT1M |Yes|
|**Network In/Sec**<br><br>Rate of data received by the network adapter |`Network Adapter\Bytes Received/sec` | No | BytesPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `Instance`, `LUN`|PT1M |Yes|
|**Network Out/Sec**<br><br>Rate of data sent by the network adapter. |`Network Adapter\Bytes Sent/sec` | No | BytesPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `Instance`, `LUN`|PT1M |Yes|
|**Network Total/Sec**<br><br>Total rate of data received or sent by the network adapter. |`Network Adapter\Bytes Total/sec` | No | BytesPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `Instance`, `LUN`|PT1M |Yes|
|**Physicaldisk Read and Write**<br><br>Total quantity of data read from or written to the drive per second. |`PhysicalDisk\Disk Bytes/sec` | No | BytesPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|
|**Physicaldisk Read Bytes/Sec**<br><br>Quantity of data read from the drive per second. |`physicaldisk\Disk Read Bytes/sec` | No | BytesPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|
|**Physicaldisk Read Operations/Sec**<br><br>Number of read operations completed by the drive. |`physicaldisk\disk reads/sec` | No | CountPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|
|**Physicaldisk Read and Write Operations/Sec**<br><br>Total number of read or write operations per second completed by the drive. |`physicaldisk\disk transfers/sec` | No | CountPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|
|**Physicaldisk Write Bytes/Sec**<br><br>Quantity of data written to the drive per second. |`physicaldisk\Disk Write Bytes/sec` | No | BytesPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|
|**Physicaldisk Write Operations/Sec**<br><br>Number of write operations completed by the drive. |`physicaldisk\disk writes/sec` | No | CountPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|
|**Netadapter Bandwidth Rdma Inbound**<br><br>Rate of data received over RDMA by the network adapter. |`RDMA Activity\RDMA Inbound Bytes/sec` | No | BytesPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `Instance`, `LUN`|PT1M |Yes|
|**Netadapter Bandwidth Rdma Outbound**<br><br>Rate of data sent over RDMA by the network adapter. |`RDMA Activity\RDMA Outbound Bytes/sec` | No | BytesPerSecond |Minimum, Maximum, Average, Total (Sum), Count |`ClusterName`, `ClusterNodeName`, `Instance`, `LUN`|PT1M |Yes|
|**Vhd Read and Write Operations/Sec**<br><br>Total number of read or write operations per second completed by the virtual hard disk. |`VHD IOPS Total` | No | CountPerSecond |Minimum, Maximum, Total (Sum), Count, Average |`ClusterName`, `ClusterNodeName`, `Instance`|PT1M |Yes|
|**Vhd Read and Write Bytes/Sec**<br><br>Total quantity of data read from or written to the virtual hard disk per second. |`VHD Throughput Total` | No | BytesPerSecond |Minimum, Maximum, Total (Sum), Count, Average |`ClusterName`, `ClusterNodeName`, `Instance`|PT1M |Yes|
|**Disk Read and Write Operations/Sec**<br><br>Total number of read or write operations per second completed by this volume. |`Volume IOPS Total` | No | CountPerSecond |Minimum, Maximum, Total (Sum), Count, Average |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|
|**Disk Read and Write**<br><br>Total quantity of data read from or written to this volume per second. |`Volume Throughput Total` | No | BytesPerSecond |Minimum, Maximum, Total (Sum), Count, Average |`ClusterName`, `ClusterNodeName`, `LUN`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
