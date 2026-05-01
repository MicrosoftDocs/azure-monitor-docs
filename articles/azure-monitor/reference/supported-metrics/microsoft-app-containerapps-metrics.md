---
title: Supported metrics - Microsoft.App/containerapps
description: Reference for Microsoft.App/containerapps metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.App/containerapps, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.App/containerapps

The following table lists the metrics available for the Microsoft.App/containerapps resource type.

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



### Category: Basic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Reserved Cores**<br><br>Number of reserved cores for container app revisions |`CoresQuotaUsed` |Count |Maximum, Minimum |`revisionName`|PT1M |Yes|
|**CPU Usage Percentage (Preview)**<br><br>Percentage of CPU limit used in percentage points |`CpuPercentage` |Percent |Total (Sum), Average, Maximum, Minimum |`podName`|PT1M |Yes|
|**Memory Percentage (Preview)**<br><br>Percentage of memory limit used, in percentage points |`MemoryPercentage` |Percent |Total (Sum), Average, Maximum, Minimum |`podName`|PT1M |Yes|
|**Replica Count**<br><br>Number of replicas count of container app |`Replicas` |Count |Average, Total (Sum), Maximum, Minimum |`revisionName`|PT1M |Yes|
|**Requests**<br><br>Requests processed |`Requests` |Count |Average, Total (Sum), Maximum, Minimum |`revisionName`, `podName`, `statusCodeCategory`, `statusCode`|PT1M |Yes|
|**Resiliency Connection Timeouts**<br><br>Total connection timeouts |`ResiliencyConnectTimeouts` |Count |Total (Sum), Average, Maximum, Minimum |`revisionName`|PT1M |Yes|
|**Resiliency Ejected Hosts**<br><br>Number of currently ejected hosts |`ResiliencyEjectedHosts` |Count |Total (Sum), Average, Maximum, Minimum |`revisionName`|PT1M |Yes|
|**Resiliency Ejections Aborted**<br><br>Number of ejections aborted due to the max ejection % |`ResiliencyEjectionsAborted` |Count |Total (Sum), Average, Maximum, Minimum |`revisionName`|PT1M |Yes|
|**Resiliency Request Retries**<br><br>Total request retries |`ResiliencyRequestRetries` |Count |Total (Sum), Average, Maximum, Minimum |`revisionName`|PT1M |Yes|
|**Resiliency Requests Pending Connection Pool**<br><br>Total requests pending a connection pool connection |`ResiliencyRequestsPendingConnectionPool` |Count |Total (Sum), Average, Maximum, Minimum |`revisionName`|PT1M |Yes|
|**Resiliency Request Timeouts**<br><br>Total request that timed out waiting for a response |`ResiliencyRequestTimeouts` |Count |Total (Sum), Average, Maximum, Minimum |`revisionName`|PT1M |Yes|
|**Average Response Time (Preview)**<br><br>Average Response Time per Status Code |`ResponseTime` |Milliseconds |Average, Total (Sum), Maximum, Minimum |`statusCodeCategory`, `statusCode`|PT1M |Yes|
|**Total Replica Restart Count**<br><br>The cumulative number of times the replica has restarted since it was created. |`RestartCount` |Count |Average, Total (Sum), Maximum, Minimum |`revisionName`, `podName`|PT1M |Yes|
|**Network In Bytes**<br><br>Network received bytes |`RxBytes` |Bytes |Average, Total (Sum), Maximum, Minimum |`revisionName`, `podName`|PT1M |Yes|
|**Total Reserved Cores**<br><br>Number of total reserved cores for the container app |`TotalCoresQuotaUsed` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Network Out Bytes**<br><br>Network transmitted bytes |`TxBytes` |Bytes |Average, Total (Sum), Maximum, Minimum |`revisionName`, `podName`|PT1M |Yes|
|**CPU Usage**<br><br>CPU consumed by the container app, in nano cores. 1,000,000,000 nano cores = 1 core |`UsageNanoCores` |NanoCores |Total (Sum), Average, Maximum, Minimum |`revisionName`, `podName`|PT1M |Yes|
|**Memory Working Set Bytes**<br><br>Container App working set memory used in bytes. |`WorkingSetBytes` |Bytes |Total (Sum), Average, Maximum, Minimum |`revisionName`, `podName`|PT1M |Yes|

### Category: Gpu
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**GPU Utilization Percentage (Preview)**<br><br>Gpu utilization indicates the percent of time over the past sample period during which one or more kernels were executing on the GPU. |`GpuUtilizationPercentage` |Percent |Average, Maximum, Minimum |`revisionName`, `podName`|PT1M |Yes|

### Category: Java
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**jvm.buffer.count**<br><br>Number of buffers in the memory pool |`JvmBufferCount` |Count |Average, Maximum, Minimum |`revisionName`, `podName`, `container`, `poolName`|PT1M |Yes|
|**jvm.buffer.memory.limit**<br><br>Amount of total memory capacity of buffers (in bytes) |`JvmBufferMemoryLimit` |Bytes |Average, Maximum, Minimum |`revisionName`, `podName`, `container`, `poolName`|PT1M |Yes|
|**jvm.buffer.memory.usage**<br><br>Amount of memory used by buffers, such as direct memory (in bytes) |`JvmBufferMemoryUsage` |Bytes |Average, Maximum, Minimum |`revisionName`, `podName`, `container`, `poolName`|PT1M |Yes|
|**jvm.gc.count**<br><br>Count of JVM garbage collection actions |`JvmGcCount` |Count |Total (Sum), Average, Maximum, Minimum |`revisionName`, `podName`, `container`, `gcName`|PT1M |Yes|
|**jvm.gc.duration**<br><br>Duration of JVM garbage collection actions (in milliseconds) |`JvmGcDuration` |Milliseconds |Total (Sum), Average, Maximum, Minimum |`revisionName`, `podName`, `container`, `gcName`|PT1M |Yes|
|**jvm.memory.committed**<br><br>Amount of memory guaranteed to be available for each pool (in bytes) |`JvmMemoryCommitted` |Bytes |Average, Maximum, Minimum |`revisionName`, `podName`, `container`, `poolName`, `poolType`|PT1M |Yes|
|**jvm.memory.limit**<br><br>Amount of maximum obtainable memory for each pool (in bytes) |`JvmMemoryLimit` |Bytes |Average, Maximum, Minimum |`revisionName`, `podName`, `container`, `poolName`, `poolType`|PT1M |Yes|
|**jvm.memory.total.committed**<br><br>Total amount of memory guaranteed to be available for heap or non-heap (in bytes) |`JvmMemoryTotalCommitted` |Bytes |Average, Maximum, Minimum |`revisionName`, `podName`, `container`, `poolType`|PT1M |Yes|
|**jvm.memory.total.limit**<br><br>Total amount of maximum obtainable memory for heap or non-heap (in bytes) |`JvmMemoryTotalLimit` |Bytes |Average, Maximum, Minimum |`revisionName`, `podName`, `container`, `poolType`|PT1M |Yes|
|**jvm.memory.total.used**<br><br>Total amount of memory used by heap or non-heap (in bytes) |`JvmMemoryTotalUsed` |Bytes |Average, Maximum, Minimum |`revisionName`, `podName`, `container`, `poolType`|PT1M |Yes|
|**jvm.memory.used**<br><br>Amount of memory used by each pool (in bytes) |`JvmMemoryUsed` |Bytes |Average, Maximum, Minimum |`revisionName`, `podName`, `container`, `poolName`, `poolType`|PT1M |Yes|
|**jvm.thread.count**<br><br>Number of executing platform threads |`JvmThreadCount` |Count |Average, Maximum, Minimum |`revisionName`, `podName`, `container`, `daemon`, `threadState`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
