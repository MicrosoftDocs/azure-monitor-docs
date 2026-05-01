---
title: Supported metrics - Microsoft.DBforMySQL/flexibleServers
description: Reference for Microsoft.DBforMySQL/flexibleServers metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.DBforMySQL/flexibleServers, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.DBforMySQL/flexibleServers

The following table lists the metrics available for the Microsoft.DBforMySQL/flexibleServers resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.DBforMySQL/flexibleServers](../supported-logs/microsoft-dbformysql-flexibleservers-logs.md)


### Category: Availability
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**HA IO Status**<br><br>Status for replication IO thread running |`HA_IO_status` |Count |Maximum |\<none\>|PT1M |Yes|
|**HA SQL Status**<br><br>Status for replication SQL thread running |`HA_SQL_status` |Count |Maximum |\<none\>|PT1M |Yes|
|**Replica IO Status**<br><br>Status for replication IO thread running |`Replica_IO_Running` |Count |Maximum |\<none\>|PT1M |No|
|**Replica SQL Status**<br><br>Status for replication SQL thread running |`Replica_SQL_Running` |Count |Maximum |\<none\>|PT1M |No|

### Category: Errors
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Aborted Connections**<br><br>Aborted Connections |`aborted_connections` |Count |Total (Sum) |\<none\>|PT1M |Yes|

### Category: Latency
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**HA Replication Lag**<br><br>HA Replication lag in seconds |`HA_replication_lag` |Seconds |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Innodb Row Lock Time**<br><br>The total time spent in acquiring row locks for InnoDB tables, in milliseconds. |`Innodb_row_lock_time` |Milliseconds |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Innodb Row Lock Waits**<br><br>The number of times operations on InnoDB tables had to wait for a row lock. |`Innodb_row_lock_waits` |Count |Total (Sum), Maximum, Minimum |\<none\>|PT1M |Yes|
|**Replication Lag In Seconds**<br><br>Replication lag in seconds |`replication_lag` |Seconds |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**MySQL Uptime**<br><br>The number of seconds that the server has been up. |`Uptime` |Seconds |Total (Sum), Maximum |\<none\>|PT1M |Yes|

### Category: Saturation
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Backup Storage Used**<br><br>Backup Storage Used |`backup_storage_used` |Bytes |Average, Maximum, Minimum |\<none\>|PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Binlog Storage Used**<br><br>Storage used by Binlog files. |`binlog_storage_used` |Bytes |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**CPU Credits Consumed**<br><br>CPU Credits Consumed |`cpu_credits_consumed` |Count |Average, Maximum, Minimum |\<none\>|PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**CPU Credits Remaining**<br><br>CPU Credits Remaining |`cpu_credits_remaining` |Count |Average, Maximum, Minimum |\<none\>|PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Host CPU Percent**<br><br>Host CPU Percent |`cpu_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Data Storage Used**<br><br>Storage used by data files. |`data_storage_used` |Bytes |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Ibdata1 Storage Used**<br><br>Storage used by ibdata1 files. |`ibdata1_storage_used` |Bytes |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**InnoDB Buffer Pool Pages Data**<br><br>The number of pages in the InnoDB buffer pool containing data. |`Innodb_buffer_pool_pages_data` |Count |Total (Sum), Maximum, Minimum |\<none\>|PT1M |Yes|
|**InnoDB Buffer Pool Pages Dirty**<br><br>The current number of dirty pages in the InnoDB buffer pool. |`Innodb_buffer_pool_pages_dirty` |Count |Total (Sum), Maximum, Minimum |\<none\>|PT1M |Yes|
|**InnoDB Buffer Pool Pages Free**<br><br>The number of free pages in the InnoDB buffer pool. |`Innodb_buffer_pool_pages_free` |Count |Total (Sum), Maximum, Minimum |\<none\>|PT1M |Yes|
|**InnoDB Buffer Pool Read Requests**<br><br>The number of logical read requests. |`Innodb_buffer_pool_read_requests` |Count |Total (Sum), Maximum, Minimum |\<none\>|PT1M |Yes|
|**InnoDB Buffer Pool Reads**<br><br>The number of logical reads that InnoDB could not satisfy from the buffer pool, and had to read directly from disk. |`Innodb_buffer_pool_reads` |Count |Total (Sum), Maximum, Minimum |\<none\>|PT1M |Yes|
|**Storage IO Percent**<br><br>Storage I/O consumption percent |`io_consumption_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Memory Percent**<br><br>Memory Percent |`memory_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Others Storage Used**<br><br>Storage used by other files. |`others_storage_used` |Bytes |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Serverlog Storage Limit**<br><br>Serverlog Storage Limit |`serverlog_storage_limit` |Bytes |Maximum |\<none\>|PT1M |Yes|
|**Serverlog Storage Percent**<br><br>Serverlog Storage Percent |`serverlog_storage_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Serverlog Storage Used**<br><br>Serverlog Storage Used |`serverlog_storage_usage` |Bytes |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Sort Merge Passes**<br><br>The number of merge passes that the sort algorithm has had to do. If this value is large, you should consider increasing the value of the sort_buffer_size system variable. |`Sort_merge_passes` |Count |Total (Sum), Maximum, Minimum |\<none\>|PT1M |Yes|
|**Storage Limit**<br><br>Storage Limit |`storage_limit` |Bytes |Maximum |\<none\>|PT1M |Yes|
|**Storage Percent**<br><br>Storage Percent |`storage_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Storage Used**<br><br>Storage Used |`storage_used` |Bytes |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Threads Running**<br><br>The number of threads that are not sleeping. |`Threads_running` |Count |Total (Sum), Maximum, Minimum |\<none\>|PT1M |Yes|

### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Active Connections**<br><br>Active Connections |`active_connections` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Active Transactions**<br><br>Number of active transactions. |`active_transactions` |Count |Total (Sum), Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Com Alter Table**<br><br>The number of times ALTER TABLE statement has been executed. |`Com_alter_table` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Com Create DB**<br><br>The number of times CREATE DB statement has been executed. |`Com_create_db` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Com Create Table**<br><br>The number of times CREATE TABLE statement has been executed. |`Com_create_table` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Com Delete**<br><br>The number of times DELETE statement has been executed. |`Com_delete` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Com Drop DB**<br><br>The number of times DROP DB statement has been executed. |`Com_drop_db` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Com Drop Table**<br><br>The number of times DROP TABLE statement has been executed. |`Com_drop_table` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Com Insert**<br><br>The number of times INSERT statement has been executed. |`Com_insert` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Com Select**<br><br>The number of times SELECT statement has been executed. |`Com_select` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Com Update**<br><br>The number of times UPDATE statement has been executed. |`Com_update` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Innodb Buffer Pool Pages Flushed**<br><br>The number of requests to flush pages from the InnoDB buffer pool. |`Innodb_buffer_pool_pages_flushed` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Innodb Data Writes**<br><br>The total number of data writes. |`Innodb_data_writes` |Count |Total (Sum), Maximum, Minimum |\<none\>|PT1M |Yes|
|**MySQL Lock Deadlocks**<br><br>Number of deadlocks. |`lock_deadlocks` |Count |Total (Sum), Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**MySQL Lock Timeouts**<br><br>Number of lock timeouts. |`lock_timeouts` |Count |Total (Sum), Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Host Network Out**<br><br>Host Network egress in bytes |`network_bytes_egress` |Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**Host Network In**<br><br>Host Network ingress in bytes |`network_bytes_ingress` |Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**Queries**<br><br>Queries |`Queries` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Slow Queries**<br><br>The number of queries that have taken more than long_query_time seconds. |`Slow_queries` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Storage IO Count**<br><br>The number of storage I/O consumed. |`storage_io_count` |Count |Total (Sum) |\<none\>|PT1M |No|
|**Total Connections**<br><br>Total Connections |`total_connections` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**MySQL History List Length**<br><br>Length of the TRX_RSEG_HISTORY list. |`trx_rseg_history_len` |Count |Total (Sum), Average, Maximum, Minimum |\<none\>|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
