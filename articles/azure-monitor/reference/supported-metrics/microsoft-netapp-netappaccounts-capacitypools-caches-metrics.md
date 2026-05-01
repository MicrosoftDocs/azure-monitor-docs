---
title: Supported metrics - Microsoft.NetApp/netAppAccounts/capacityPools/caches
description: Reference for Microsoft.NetApp/netAppAccounts/capacityPools/caches metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 01/20/2026
ms.custom: Microsoft.NetApp/netAppAccounts/capacityPools/caches, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.NetApp/netAppAccounts/capacityPools/caches

The following table lists the metrics available for the Microsoft.NetApp/netAppAccounts/capacityPools/caches resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.NetApp/netAppAccounts/capacityPools/caches](../supported-logs/microsoft-netapp-netappaccounts-capacitypools-caches-logs.md)


|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Average Read Latency**<br><br>Average read latency in milliseconds per operation. |`AverageReadLatency` |MilliSeconds |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Average Write Latency**<br><br>Average write latency in milliseconds per operation. |`AverageWriteLatency` |MilliSeconds |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Other IOPS**<br><br>The number of operations per second that are neither reads nor writes, such as management commands or metadata operations. |`OtherIops` |CountPerSecond |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Other Throughput**<br><br>Throughput metric for other I/O operations. Other I/O operations can be metadata operations, such as directory lookups and so on. |`OtherThroughput` |BytesPerSecond |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Read IOPS**<br><br>The number of read operations per second. |`ReadIops` |CountPerSecond |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Read Throughput**<br><br>The total amount of data read from the cache volume per second. |`ReadThroughput` |BytesPerSecond |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Throughput limit reached**<br><br>Has the throughput limit been reached, 1 if it has and 0 if not. |`ThroughputLimitReached` |Count |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Total IOPS**<br><br>The total number of all operations per second (read, write, and other). |`TotalIops` |CountPerSecond |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Total Throughput**<br><br>The combined total amount of data read from and written to the cache volume per second |`TotalThroughput` |BytesPerSecond |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Cache Volume Allocated Size**<br><br>The provisioned size of a cache volume. |`VolumeAllocatedSize` |Bytes |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Allocated Throughput**<br><br>The provisioned throughput of a cache volume. |`VolumeAllocatedThroughput` |Bytes |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Client Requested Blocks**<br><br>The number of blocks requested by the client. |`VolumeCacheClientRequestedBlocks` |Count |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Cache Volume Connection Status**<br><br>The status of the connection to the origin volume. |`VolumeCacheConnectionStatus` |Count |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Constituents At Capacity**<br><br>The number of constituents that are at capacity in the cache volume. |`VolumeCacheConstituentsAtCapacityCount` |Count |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Maximum File Size**<br><br>The maximum file size that can be stored in the cache volume. |`VolumeCacheMaximumFileSize` |Bytes |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Cache Volume Miss Blocks**<br><br>The number of blocks that were not found in the cache volume and had to be fetched from the backend storage. |`VolumeCacheMissBlocks` |Count |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Cache Volume Consumed Size Percentage**<br><br>The percentage of the cache volume consumed including snapshots. |`VolumeConsumedSizePercentage` |Percent |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Cache Volume Inodes Percentage**<br><br>The Percentage of Inodes used. |`VolumeInodesPercentage` |Bytes |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Cache Volume Inodes Quota**<br><br>Cumulative bytes transferred for the relationship. |`VolumeInodesQuota` |Bytes |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Cache Volume Inodes Total**<br><br>Maximum number of inodes that the cache volume can support. Can be overwritten by Cache Inodes Quota. |`VolumeInodesTotal` |Bytes |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Cache Volume Inodes Used**<br><br>Number of inodes used. |`VolumeInodesUsed` |Bytes |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Consumed Size**<br><br>Logical size of the cache volume (used bytes). |`VolumeLogicalSize` |Bytes |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Snapshot Size**<br><br>Cache volume snapshot size. |`VolumeSnapshotSize` |Bytes |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Write IOPS**<br><br>The number of write operations per second. |`WriteIops` |CountPerSecond |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Write Throughput**<br><br>The total amount of data written to the cache volume per second. |`WriteThroughput` |BytesPerSecond |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
