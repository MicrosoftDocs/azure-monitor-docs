---
title: Supported metrics - Microsoft.HorizonDB/clusters
description: Reference for Microsoft.HorizonDB/clusters metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 10/16/2026
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
- **DS Export** - Shows whether the metric is exportable to Azure Monitor Logs via Diagnostic Settings.

For information on exporting metrics, see - [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics) and [Create diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/create-diagnostic-settings?tabs=portal).

For information on metric retention, see [Azure Monitor Metrics overview](/azure/azure-monitor/essentials/data-platform-metrics#retention-of-metrics).


For a list of supported logs, see [Supported log categories - Microsoft.HorizonDB/clusters](../supported-logs/microsoft-horizondb-clusters-logs.md)


### Category: Activity
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Active Connections**<br><br>Active database connections |`ActiveConnections` | No | Count |Average, Maximum, Minimum |`Pool`, `Node`, `Role`|PT1M |No|
|**Queries**<br><br>Number of top-level queries executed per second, excluding queries nested within functions |`Queries` | No | CountPerSecond |Minimum, Maximum, Total (Sum) |`Pool`, `Node`, `Role`|PT1M |No|
|**Successful Connections**<br><br>Number of successful connections |`SuccessfulConnections` | No | Count |Total (Sum) |`Pool`, `Node`, `Role`|PT1M |No|
|**Total Transactions**<br><br>Number of transactions executed in this database |`TotalTransactions` | No | Count |Total (Sum) |`Database`, `Pool`, `Node`, `Role`|PT1M |No|
|**Transactions**<br><br>Number of transactions executed per second |`Transactions` | No | CountPerSecond |Minimum, Maximum, Total (Sum) |`Pool`, `Node`, `Role`|PT1M |No|
|**Transactions Committed**<br><br>Number of transactions committed in this database |`TransactionsCommitted` | No | Count |Total (Sum) |`Database`, `Pool`, `Node`, `Role`|PT1M |No|
|**Transactions Rolled Back**<br><br>Number of transactions rolled back in this database |`TransactionsRolledBack` | No | Count |Total (Sum) |`Database`, `Pool`, `Node`, `Role`|PT1M |No|
|**Tuples Deleted**<br><br>Number of rows deleted by queries in this database |`TuplesDeleted` | No | Count |Total (Sum) |`Database`|PT1M |No|
|**Tuples Fetched**<br><br>Number of rows fetched by queries in this database |`TuplesFetched` | No | Count |Total (Sum) |`Database`, `Pool`, `Node`, `Role`|PT1M |No|
|**Tuples Inserted**<br><br>Number of rows inserted by queries in this database |`TuplesInserted` | No | Count |Total (Sum) |`Database`|PT1M |No|
|**Tuples Returned**<br><br>Number of rows returned by queries in this database |`TuplesReturned` | No | Count |Total (Sum) |`Database`, `Pool`, `Node`, `Role`|PT1M |No|
|**Tuples Updated**<br><br>Number of rows updated by queries in this database |`TuplesUpdated` | No | Count |Total (Sum) |`Database`|PT1M |No|

### Category: Compute
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**CPU Utilization**<br><br>Host CPU utilization |`CpuUtilization` | No | Percent |Average, Maximum, Minimum |`Pool`, `Node`, `Role`|PT1M |No|
|**Memory Utilization**<br><br>Host memory utilization |`MemoryUtilization` | No | Percent |Average, Maximum, Minimum |`Pool`, `Node`, `Role`|PT1M |No|

### Category: Concurrency
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Deadlocks**<br><br>Number of deadlocks detected in this database |`Deadlocks` | No | Count |Total (Sum) |`Database`, `Pool`, `Node`, `Role`|PT1M |Yes|
|**Maximum Connections**<br><br>Maximum database connections configured through server parameters |`MaximumConnections` | No | Count |Maximum |`Pool`, `Node`, `Role`|PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Oldest Backend**<br><br>Age of the oldest backend, regardless of state |`OldestBackend` | No | Seconds |Maximum |`Pool`, `Node`, `Role`|PT1M |No|
|**Oldest Query**<br><br>Age of the longest currently running query |`OldestQuery` | No | Seconds |Maximum |`Pool`, `Node`, `Role`|PT1M |No|
|**Oldest Transaction**<br><br>Age of the longest currently running transaction |`OldestTransaction` | No | Seconds |Maximum |`Pool`, `Node`, `Role`|PT1M |No|
|**Oldest xmin**<br><br>Value of the oldest xmin; a value that is not advancing can indicate long-running transactions preventing dead-tuple removal |`OldestXmin` | No | Count |Maximum |`Pool`, `Node`, `Role`|PT1M |No|
|**Oldest xmin Age**<br><br>Number of transactions that have elapsed since the oldest xmin was assigned |`OldestXminAge` | No | Count |Maximum |`Pool`, `Node`, `Role`|PT1M |No|
|**Sessions by State**<br><br>Number of sessions by state as reported by the pg_stat_activity view, such as active or idle |`SessionsByState` | No | Count |Maximum, Minimum, Average |`State`, `Pool`, `Node`, `Role`|PT1M |No|
|**Sessions by Wait Event Type**<br><br>Number of sessions by the event type for which the client backend is waiting |`SessionsByWaitEventType` | No | Count |Maximum, Minimum, Average |`WaitEventType`, `Pool`, `Node`, `Role`|PT1M |No|

### Category: Database
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Buffer Pool Cache Hit Ratio**<br><br>Percentage of reads served from shared buffers |`BufferPoolCacheHitRatio` | No | Percent |Average, Maximum, Minimum |`Pool`, `Node`, `Role`|PT1M |No|
|**Database Size**<br><br>Amount of storage used by the database |`DatabaseSize` | No | Bytes |Average, Maximum, Minimum |`Database`|PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Maximum Used Transaction IDs**<br><br>Largest number of transaction IDs consumed; used to monitor proximity to XID wraparound |`MaximumUsedTransactionIDs` | No | Count |Average, Maximum, Minimum |`Pool`, `Node`, `Role`|PT1M |No|
|**Temporary Files**<br><br>Number of temporary files created by queries in this database |`TemporaryFiles` | No | Count |Total (Sum) |`Database`, `Pool`, `Node`, `Role`|PT1M |No|
|**Temporary Files Size**<br><br>Amount of data written to temporary files by queries in this database |`TemporaryFilesSize` | No | Bytes |Total (Sum) |`Database`, `Pool`, `Node`, `Role`|PT1M |No|

### Category: Errors
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Failed Connections**<br><br>Number of failed connections |`FailedConnections` | No | Count |Total (Sum) |`Pool`, `Node`, `Role`|PT1M |No|

### Category: Health
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**PostgreSQL Instance Is Alive**<br><br>Indicates whether the PostgreSQL process is running |`PostgreSqlInstanceIsAlive` | No | Count |Average, Maximum, Minimum |`Pool`, `Node`, `Role`|PT1M |No|

### Category: Network
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Network Egress**<br><br>Amount of network data sent across active connections |`NetworkEgress` | No | Bytes |Total (Sum) |`Pool`, `Node`, `Role`|PT1M |No|
|**Network Ingress**<br><br>Amount of network data received across active connections |`NetworkIngress` | No | Bytes |Total (Sum) |`Pool`, `Node`, `Role`|PT1M |No|

### Category: Replication
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Max Logical Replication Lag**<br><br>Maximum lag across all logical replication slots |`MaxLogicalReplicationDelay` | No | Bytes |Maximum, Minimum, Average |\<none\>|PT1M |No|

### Category: Storage
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Commit Latency**<br><br>Maximum time taken by the engine to complete commit operations (microseconds) |`CommitLatency` | No | Unspecified |Maximum |\<none\>|PT1M |No|
|**Page Read Iops**<br><br>Number of page read I/O operations from storage |`PageReadIops` | No | CountPerSecond |Average, Maximum, Minimum |`Pool`, `Node`, `Role`|PT1M |No|
|**Page Read Throughput**<br><br>Amount of data in pages read from storage |`PageReadThroughput` | No | BytesPerSecond |Average, Maximum, Minimum |`Pool`, `Node`, `Role`|PT1M |No|
|**SSD Cache Hit Ratio**<br><br>Percentage of reads served by the local SSD cache |`SsdCacheHitRatio` | No | Percent |Average, Maximum, Minimum |`Pool`, `Node`, `Role`|PT1M |No|
|**SSD Cache Hits**<br><br>Number of reads served by the local SSD cache |`SsdCacheHits` | No | Count |Average, Maximum, Minimum, Total (Sum) |`Pool`, `Node`, `Role`|PT1M |No|
|**SSD Cache Misses**<br><br>Number of reads that missed the SSD cache and were served from storage |`SsdCacheMisses` | No | Count |Average, Maximum, Minimum, Total (Sum) |`Pool`, `Node`, `Role`|PT1M |No|
|**SSD Cache Writes**<br><br>Number of writes performed into the SSD cache |`SsdCacheWrites` | No | Count |Average, Maximum, Minimum, Total (Sum) |`Pool`, `Node`, `Role`|PT1M |No|
|**Storage Used**<br><br>Amount of storage used by the service, including database files and the transaction log tail |`StorageUsed` | No | Bytes |Average, Maximum, Minimum |\<none\>|PT1M |No|
|**WAL Write Iops**<br><br>Number of WAL write I/O operations to storage |`WALWriteIops` | No | CountPerSecond |Maximum |\<none\>|PT1M |No|
|**WAL Write Throughput**<br><br>Amount of WAL written to storage |`WALWriteThroughput` | No | BytesPerSecond |Maximum |\<none\>|PT1M |No|
|**Write Latency**<br><br>Maximum time taken to flush a WAL record (microseconds) |`WriteLatency` | No | Unspecified |Maximum |\<none\>|PT1M |No|

### Category: Vacuum
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Analyze Operations on User Tables**<br><br>Number of times user tables have been manually analyzed in this database |`AnalyzeUserTables` | No | Count |Maximum, Minimum, Average |`Database`|PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Autoanalyze Operations on User Tables**<br><br>Number of times user tables have been analyzed by the autovacuum daemon in this database |`AutoanalyzeUserTables` | No | Count |Maximum, Minimum, Average |`Database`|PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Autovacuum Operations on User Tables**<br><br>Number of times user tables have been vacuumed by the autovacuum daemon in this database |`AutovacuumUserTables` | No | Count |Maximum, Minimum, Average |`Database`|PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Bloat Percent**<br><br>Estimated bloat percentage for user tables in this database |`BloatPercent` | No | Percent |Maximum |`Database`|PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Estimated Dead Rows in User Tables**<br><br>Estimated number of dead rows in user tables in this database |`EstimatedDeadRowsUserTables` | No | Count |Maximum, Minimum, Average |`Database`|PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Estimated Live Rows in User Tables**<br><br>Estimated number of live rows in user tables in this database |`EstimatedLiveRowsUserTables` | No | Count |Maximum, Minimum, Average |`Database`|PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Rows Modified Since Analyze in User Tables**<br><br>Estimated number of rows modified since user tables were last analyzed in this database |`ModifiedRowsSinceAnalyzeUserTables` | No | Count |Maximum, Minimum, Average |`Database`|PT30M, PT1H, PT6H, PT12H, P1D |No|
|**User Tables**<br><br>Number of user tables in this database |`UserTables` | No | Count |Maximum, Minimum, Average |`Database`|PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Analyzed User Tables**<br><br>Number of user tables analyzed in this database |`UserTablesAnalyzed` | No | Count |Maximum, Minimum, Average |`Database`|PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Autoanalyzed User Tables**<br><br>Number of user tables analyzed by the autovacuum daemon in this database |`UserTablesAutoanalyzed` | No | Count |Maximum, Minimum, Average |`Database`|PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Autovacuumed User Tables**<br><br>Number of user tables vacuumed by the autovacuum daemon in this database |`UserTablesAutovacuumed` | No | Count |Maximum, Minimum, Average |`Database`|PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Vacuumed User Tables**<br><br>Number of user tables vacuumed in this database |`UserTablesVacuumed` | No | Count |Maximum, Minimum, Average |`Database`|PT30M, PT1H, PT6H, PT12H, P1D |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
