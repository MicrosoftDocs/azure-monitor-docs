---
title: Supported metrics - Microsoft.Kusto/clusters
description: Reference for Microsoft.Kusto/clusters metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Kusto/clusters, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Kusto/clusters

The following table lists the metrics available for the Microsoft.Kusto/clusters resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.Kusto/clusters](../supported-logs/microsoft-kusto-clusters-logs.md)


### Category: Cluster health
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Cache utilization (deprecated)**<br><br>Utilization level in the cluster scope. The metric is deprecated and presented for backward compatibility only, you should use the 'Cache utilization factor' metric instead. |`CacheUtilization` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Cache utilization factor**<br><br>Percentage of utilized disk space dedicated for hot cache in the cluster. 100% means that the disk space assigned to hot data is optimally utilized. No action is needed in terms of the cache size. More than 100% means that the cluster's disk space is not large enough to accommodate the hot data, as defined by your caching policies. To ensure that sufficient space is available for all the hot data, the amount of hot data needs to be reduced or the cluster needs to be scaled out. Enabling auto scale is recommended. |`CacheUtilizationFactor` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**CPU**<br><br>CPU utilization level |`CPU` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**FollowerLatency**<br><br>The follower databases synchronize changes in the leader databases. Because of the synchronization, there's a data lag of a few seconds to a few minutes in data availability.This metric measures the length of the time lag. The time lag depends on the overall size of the leader database metadata.This is a cluster level metrics: the followers catch metadata of all databases that are followed. This metric represents the latency of the process. |`FollowerLatency` |MilliSeconds |Average, Maximum, Minimum |`State`, `RoleInstance`|PT1M |Yes|
|**Ingestion utilization**<br><br>Ratio of used ingestion slots in the cluster |`IngestionUtilization` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Instance Count**<br><br>Total instance count |`InstanceCount` |Count |Average, Maximum, Minimum, Count, Total (Sum) |\<none\>|PT1M |Yes|
|**Keep alive**<br><br>Sanity check indicates the cluster responds to queries |`KeepAlive` |Count |Average |\<none\>|PT1M |Yes|
|**Total number of extents**<br><br>Total number of data extents |`TotalNumberOfExtents` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Total number of throttled commands**<br><br>Total number of throttled commands |`TotalNumberOfThrottledCommands` |Count |Average, Maximum, Minimum, Total (Sum) |`CommandType`|PT1M |Yes|

### Category: Export health and performance
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Continuous Export Max Lateness**<br><br>The lateness (in minutes) reported by the continuous export jobs in the cluster |`ContinuousExportMaxLatenessMinutes` |Count |Maximum |\<none\>|PT1M |Yes|
|**Continuous export - num of exported records**<br><br>Number of records exported, fired for every storage artifact written during the export operation |`ContinuousExportNumOfRecordsExported` |Count |Total (Sum) |`ContinuousExportName`, `Database`|PT1M |Yes|
|**Continuous Export Pending Count**<br><br>The number of pending continuous export jobs ready for execution |`ContinuousExportPendingCount` |Count |Maximum |\<none\>|PT1M |Yes|
|**Continuous Export Result**<br><br>Indicates whether Continuous Export succeeded or failed |`ContinuousExportResult` |Count |Count |`ContinuousExportName`, `Result`, `Database`|PT1M |Yes|
|**Export Utilization**<br><br>Export utilization |`ExportUtilization` |Percent |Maximum |\<none\>|PT1M |Yes|

### Category: Ingestion health and performance
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Batch Blob Count**<br><br>Number of data sources in an aggregated batch for ingestion. |`BatchBlobCount` |Count |Average, Maximum, Minimum |`Database`|PT1M |Yes|
|**Batch Duration**<br><br>The duration of the aggregation phase in the ingestion flow. |`BatchDuration` |Seconds |Average, Maximum, Minimum |`Database`|PT1M |Yes|
|**Batches Processed**<br><br>Number of batches aggregated for ingestion. Batching Type: whether the batch reached batching time, data size or number of files limit set by batching policy |`BatchesProcessed` |Count |Total (Sum), Average, Maximum, Minimum |`Database`, `SealReason`|PT1M |Yes|
|**Batch Size**<br><br>Uncompressed expected data size in an aggregated batch for ingestion. |`BatchSize` |Bytes |Average, Maximum, Minimum |`Database`|PT1M |Yes|
|**Blobs Dropped**<br><br>Number of blobs permanently rejected by a component. |`BlobsDropped` |Count |Total (Sum), Average, Minimum, Maximum |`Database`, `ComponentType`, `ComponentName`|PT1M |Yes|
|**Blobs Processed**<br><br>Number of blobs processed by a component. |`BlobsProcessed` |Count |Total (Sum), Average, Minimum, Maximum |`Database`, `ComponentType`, `ComponentName`|PT1M |Yes|
|**Blobs Received**<br><br>Number of blobs received from input stream by a component. |`BlobsReceived` |Count |Total (Sum), Average, Minimum, Maximum |`Database`, `ComponentType`, `ComponentName`|PT1M |Yes|
|**Discovery Latency**<br><br>Reported by data connections (if exist). Time in seconds from when a message is enqueued or event is created until it is discovered by data connection. This time is not included in the Azure Data Explorer total ingestion duration. |`DiscoveryLatency` |Seconds |Average |`ComponentType`, `ComponentName`|PT1M |Yes|
|**Events Dropped**<br><br>Number of events dropped permanently by data connection. An Ingestion result metric with a failure reason will be sent. |`EventsDropped` |Count |Total (Sum), Average, Minimum, Maximum |`ComponentType`, `ComponentName`|PT1M |Yes|
|**Events Processed**<br><br>Number of events processed by the cluster |`EventsProcessed` |Count |Total (Sum), Average, Minimum, Maximum |`ComponentType`, `ComponentName`|PT1M |Yes|
|**Events Received**<br><br>Number of events received by data connection. |`EventsReceived` |Count |Total (Sum), Average, Minimum, Maximum |`ComponentType`, `ComponentName`|PT1M |Yes|
|**Ingestion Latency**<br><br>Latency of data ingested, from the time the data was received in the cluster until it's ready for query. The ingestion latency period depends on the ingestion scenario. |`IngestionLatencyInSeconds` |Seconds |Average, Maximum, Minimum |`IngestionKind`|PT1M |Yes|
|**Ingestion result**<br><br>Total number of sources that either failed or succeeded to be ingested. Splitting the metric by status, you can get detailed information about the status of the ingestion operations. |`IngestionResult` |Count |Total (Sum) |`IngestionResultDetails`, `FailureKind`|PT1M |Yes|
|**Ingestion Volume**<br><br>Overall volume of ingested data to the cluster |`IngestionVolumeInMB` |Bytes |Total (Sum), Maximum |`Database`|PT1M |Yes|
|**Queue Length**<br><br>Number of pending messages in a component's queue. |`QueueLength` |Count |Average |`ComponentType`|PT1M |Yes|
|**Queue Oldest Message**<br><br>Time in seconds from when the oldest message in queue was inserted. |`QueueOldestMessage` |Count |Average |`ComponentType`|PT1M |Yes|
|**Received Data Size Bytes**<br><br>Size of data received by data connection. This is the size of the data stream, or of raw data size if provided. |`ReceivedDataSizeBytes` |Bytes |Average, Total (Sum) |`ComponentType`, `ComponentName`|PT1M |Yes|
|**Stage Latency**<br><br>Cumulative time from when a message is discovered until it is received by the reporting component for processing (discovery time is set when message is enqueued for ingestion queue, or when discovered by data connection). |`StageLatency` |Seconds |Average |`Database`, `ComponentType`|PT1M |Yes|

### Category: Materialized View health and performance
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Materialized View Age**<br><br>The materialized view age in minutes |`MaterializedViewAgeMinutes` |Count |Average |`Database`, `MaterializedViewName`|PT1M |Yes|
|**Materialized View Age**<br><br>The materialized view age in seconds |`MaterializedViewAgeSeconds` |Seconds |Average, Minimum, Maximum |`Database`, `MaterializedViewName`|PT1M |Yes|
|**Materialized View Data Loss**<br><br>Indicates potential data loss in materialized view |`MaterializedViewDataLoss` |Count |Maximum |`Database`, `MaterializedViewName`, `Kind`|PT1M |Yes|
|**Materialized View Extents Rebuild**<br><br>Number of extents rebuild |`MaterializedViewExtentsRebuild` |Count |Average |`Database`, `MaterializedViewName`|PT1M |Yes|
|**Materialized View Health**<br><br>The health of the materialized view (1 for healthy, 0 for non-healthy) |`MaterializedViewHealth` |Count |Average |`Database`, `MaterializedViewName`|PT1M |Yes|
|**Materialized View Records In Delta**<br><br>The number of records in the non-materialized part of the view |`MaterializedViewRecordsInDelta` |Count |Average |`Database`, `MaterializedViewName`|PT1M |Yes|
|**Materialized View Result**<br><br>The result of the materialization process |`MaterializedViewResult` |Count |Average |`Database`, `MaterializedViewName`, `Result`|PT1M |Yes|

### Category: Partitioning
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Partitioning Percentage**<br><br>Percentage of records partitioned versus total number of records. |`PartitioningPercentage` |Percent |Average, Maximum, Minimum |`Database`, `Table`|PT1M |Yes|
|**Partitioning Percentage Hot**<br><br>Percentage of records partitioned versus total number of records (in hot / cached extents only). |`PartitioningPercentageHot` |Percent |Average, Maximum, Minimum |`Database`, `Table`|PT1M |Yes|
|**Processed Partitioned Records**<br><br>Number of records partitioned in measured time window. |`ProcessedPartitionedRecords` |Count |Average, Maximum, Minimum |`Database`, `Table`|PT1M |Yes|

### Category: Query performance
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Query duration**<br><br>Queries duration in seconds |`QueryDuration` |MilliSeconds |Average, Maximum, Minimum, Total (Sum) |`QueryStatus`|PT1M |Yes|
|**Query Result**<br><br>Total number of queries. |`QueryResult` |Count |Count |`QueryStatus`|PT1M |No|
|**Total number of concurrent queries**<br><br>Total number of concurrent queries |`TotalNumberOfConcurrentQueries` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Total number of throttled queries**<br><br>Total number of throttled queries |`TotalNumberOfThrottledQueries` |Count |Average, Maximum, Minimum, Total (Sum) |\<none\>|PT1M |Yes|
|**Weak consistency latency**<br><br>The max latency between the previous metadata sync and the next one (in DB/node scope) |`WeakConsistencyLatency` |Seconds |Average, Maximum, Minimum |`Database`, `RoleInstance`|PT1M |Yes|

### Category: Streaming Ingest
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Streaming Ingest Data Rate**<br><br>Streaming ingest data rate |`StreamingIngestDataRate` |Bytes |Average, Minimum, Maximum |\<none\>|PT1M |Yes|
|**Streaming Ingest Duration**<br><br>Streaming ingest duration in milliseconds |`StreamingIngestDuration` |MilliSeconds |Average, Minimum, Maximum |\<none\>|PT1M |Yes|
|**Streaming Ingest Result**<br><br>Streaming ingest result |`StreamingIngestResults` |Count |Count |`Result`|PT1M |Yes|
|**Streaming Ingest Utilization**<br><br>Streaming Ingest Utilization is the percentage of actual concurrent streaming ingestion requests performed, compared to the maximum number of concurrent streaming ingestion requests. |`StreamingIngestUtilization` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
