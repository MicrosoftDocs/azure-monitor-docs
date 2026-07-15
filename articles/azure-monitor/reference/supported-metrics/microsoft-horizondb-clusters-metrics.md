---
title: Supported metrics - Microsoft.HorizonDB/clusters
description: Reference for Microsoft.HorizonDB/clusters metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: Microsoft.HorizonDB/clusters, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.HorizonDB/clusters

The following table lists the metrics available for the Microsoft.HorizonDB/clusters resource type.

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



### Category: Activity
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Active Connections**<br><br>Active Database Connections |`ActiveConnections` | No | Count |Average, Maximum, Minimum |`ReplicaName`|PT1M |No|
|**Succeeded Connections**<br><br>Succeeded Connections |`ConnectionsSucceeded` | No | Count |Total (Sum) |`ReplicaName`|PT1M |No|
|**Query Store Flush Status**<br><br>Indicates if the last query store flush succeeded (1) or failed (0) |`QueryStoreFlushStatus` | No | Count |Average, Maximum, Minimum |`ReplicaName`|PT1M |No|
|**Total Transactions**<br><br>Number of total transactions executed in this database |`TotalTransactions` | No | Count |Total (Sum) |`database_name`, `ReplicaName`|PT1M |No|
|**Transactions Committed**<br><br>Number of transactions in this database that have been committed |`TransactionsCommitted` | No | Count |Total (Sum) |`database_name`, `ReplicaName`|PT1M |No|
|**Transactions per Second**<br><br>Number of transactions executed within a second |`TransactionsPerSecond` | No | Count |Minimum, Maximum, Total (Sum) |`ReplicaName`|PT1M |No|
|**Transactions Rolled Back**<br><br>Number of transactions in this database that have been rolled back |`TransactionsRolledBack` | No | Count |Total (Sum) |`database_name`, `ReplicaName`|PT1M |No|
|**Tuples Deleted**<br><br>Number of rows deleted by queries in this database |`TuplesDeleted` | No | Count |Total (Sum) |`database_name`, `ReplicaName`|PT1M |No|
|**Tuples Fetched**<br><br>Number of rows fetched by queries in this database |`TuplesFetched` | No | Count |Total (Sum) |`database_name`, `ReplicaName`|PT1M |No|
|**Tuples Inserted**<br><br>Number of rows inserted by queries in this database |`TuplesInserted` | No | Count |Total (Sum) |`database_name`, `ReplicaName`|PT1M |No|
|**Tuples Returned**<br><br>Number of rows returned by queries in this database |`TuplesReturned` | No | Count |Total (Sum) |`database_name`, `ReplicaName`|PT1M |No|
|**Tuples Updated**<br><br>Number of rows updated by queries in this database |`TuplesUpdated` | No | Count |Total (Sum) |`database_name`, `ReplicaName`|PT1M |No|

### Category: Compute
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**CPU percent**<br><br>Host CPU utilization percent |`CpuPercent` | No | Percent |Average, Maximum, Minimum |`ReplicaName`|PT1M |No|
|**Memory percent**<br><br>Host memory utilization percent |`MemoryPercent` | No | Percent |Average, Maximum, Minimum |`ReplicaName`|PT1M |No|

### Category: Concurrency
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Deadlocks**<br><br>Number of deadlocks that are detected in this database |`Deadlocks` | No | Count |Total (Sum) |`database_name`, `ReplicaName`|PT1M |Yes|
|**Max Connections**<br><br>Maximum Database connections configured in server parameters |`MaxConnections` | No | Count |Maximum |`ReplicaName`|PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Oldest Backend**<br><br>Age in seconds of the oldest backend (irrespective of the state) |`OldestBackend` | No | Seconds |Maximum |`ReplicaName`|PT1M |No|
|**Oldest Query**<br><br>Age in seconds of the longest query that's currently running |`OldestQuery` | No | Seconds |Maximum |`ReplicaName`|PT1M |No|
|**Oldest Transaction**<br><br>Age in seconds of the longest query that's currently running |`OldestTransaction` | No | Seconds |Maximum |`ReplicaName`|PT1M |No|
|**Oldest xmin**<br><br>The actual value of the oldest xmin. If xmin isn't increasing, it indicates that there are some long-running transactions that can potentially hold dead tuples from being removed. |`OldestXmin` | No | Count |Maximum |`ReplicaName`|PT1M |No|
|**Oldest xmin Age**<br><br>Age in units of the oldest xmin. Indicates how many transactions passed since the oldest |`OldestXminAge` | No | Count |Maximum |`ReplicaName`|PT1M |No|
|**Sessions by State**<br><br>Sessions by state as shown in pg_stat_activity view. It categorizes client backends into various states, such as active or idle |`SessionsByState` | No | Count |Maximum, Minimum, Average |`state`, `ReplicaName`|PT1M |No|
|**Sessions by WaitEventType**<br><br>Sessions by the type of event for which the client backend is waiting |`SessionsByWaitEventType` | No | Count |Maximum, Minimum, Average |`wait_event_type`, `ReplicaName`|PT1M |No|

### Category: Database
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Buffer Pool Cache Hit Ratio**<br><br>Cache hit ratio for shared buffers |`BufferPoolCacheHitRatio` | No | Count |Average, Maximum, Minimum |`ReplicaName`|PT1M |No|
|**Maximum Used Transaction IDs**<br><br>Largest number of transaction IDs consumed; used to monitor proximity to XID wraparound |`MaximumUsedTransactionIDs` | No | Count |Average, Maximum, Minimum |`ReplicaName`|PT1M |No|
|**Temporary Files**<br><br>Number of temporary files that were created by queries in this database |`TemporaryFiles` | No | Count |Total (Sum) |`database_name`, `ReplicaName`|PT1M |No|
|**Temporary Files Size**<br><br>Total amount of data that's written to temporary files by queries in this database |`TemporaryFilesSize` | No | Bytes |Total (Sum) |`database_name`, `ReplicaName`|PT1M |No|

### Category: Errors
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Failed Connections**<br><br>Failed Connections |`ConnectionsFailed` | No | Count |Total (Sum) |`ReplicaName`|PT1M |No|

### Category: Health
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Postgres Instance Is Alive**<br><br>Indicates if the Postgres process is running |`PGHeartbeat` | No | Count |Average, Maximum, Minimum |`ReplicaName`|PT1M |No|

### Category: Network
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Network Out**<br><br>Network Out across active connections |`NetworkBytesEgress` | No | Bytes |Total (Sum) |`ReplicaName`|PT1M |No|
|**Network In**<br><br>Network In across active connections |`NetworkBytesIngress` | No | Bytes |Total (Sum) |`ReplicaName`|PT1M |No|

### Category: Storage
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Commit Latency, in Microsecond**<br><br>The maximum duration taken by the engine to complete the commit operations |`CommitLatency` | No | Unspecified |Maximum |\<none\>|PT1M |No|
|**Storage Used**<br><br>Amount of storage space that's used. The storage that's used by the service can include the database files and the transaction log tail |`StorageUsed` | No | Bytes |Average, Maximum, Minimum |\<none\>|PT1M |No|
|**WAL Bytes Written**<br><br>Amount of WAL Bytes generated by PostgreSQL Engine |`WALBytesWritten` | No | BytesPerSecond |Maximum |\<none\>|PT1M |No|
|**WAL Writes per Second**<br><br>Number of WAL I/O operations per second |`WALWritesPerSecond` | No | CountPerSecond |Maximum |\<none\>|PT1M |No|
|**Write Latency, in Microsecond**<br><br>The maximum duration taken by WAL record to be flushed |`WriteLatency` | No | Unspecified |Maximum |\<none\>|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
