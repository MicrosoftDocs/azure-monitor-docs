---
title: Supported metrics - Microsoft.DBforPostgreSQL/flexibleServers
description: Reference for Microsoft.DBforPostgreSQL/flexibleServers metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.DBforPostgreSQL/flexibleServers, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.DBforPostgreSQL/flexibleServers

The following table lists the metrics available for the Microsoft.DBforPostgreSQL/flexibleServers resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.DBforPostgreSQL/flexibleServers](../supported-logs/microsoft-dbforpostgresql-flexibleservers-logs.md)


### Category: Activity
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Oldest Query**<br><br>The age in seconds of the longest query that is currently running |`longest_query_time_sec` |Seconds |Maximum |`ServerName`|PT1M |Yes|
|**Oldest Transaction**<br><br>The age in seconds of the longest transaction (including idle transactions) |`longest_transaction_time_sec` |Seconds |Maximum |`ServerName`|PT1M |Yes|
|**Oldest Backend**<br><br>The age in seconds of the oldest backend (irrespective of the state) |`oldest_backend_time_sec` |Seconds |Maximum |`ServerName`|PT1M |Yes|
|**Oldest xmin**<br><br>The actual value of the oldest xmin. |`oldest_backend_xmin` |Count |Maximum |`ServerName`|PT1M |Yes|
|**Oldest xmin Age**<br><br>Age in units of the oldest xmin. It indicated how many transactions passed since oldest xmin |`oldest_backend_xmin_age` |Count |Maximum |`ServerName`|PT1M |Yes|
|**Sessions by State**<br><br>Overall state of the backends |`sessions_by_state` |Count |Maximum, Minimum, Average |`State`, `ServerName`|PT1M |Yes|
|**Sessions by WaitEventType**<br><br>Sessions by the type of event for which the backend is waiting |`sessions_by_wait_event_type` |Count |Maximum, Minimum, Average |`WaitEventType`, `ServerName`|PT1M |Yes|

### Category: Autovacuum
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Analyze Counter User Tables**<br><br>Number of times user only tables have been manually analyzed in this database |`analyze_count_user_tables` |Count |Maximum, Minimum, Average |`DatabaseName`, `ServerName`|PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**AutoAnalyze Counter User Tables**<br><br>Number of times user only tables have been analyzed by the autovacuum daemon in this database |`autoanalyze_count_user_tables` |Count |Maximum, Minimum, Average |`DatabaseName`, `ServerName`|PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**AutoVacuum Counter User Tables**<br><br>Number of times user only tables have been vacuumed by the autovacuum daemon in this database |`autovacuum_count_user_tables` |Count |Maximum, Minimum, Average |`DatabaseName`, `ServerName`|PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Bloat Percent (Preview)**<br><br>Estimated bloat percentage for user only tables in this database |`bloat_percent` |Percent |Maximum |`DatabaseName`, `ServerName`|PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Estimated Dead Rows User Tables**<br><br>Estimated number of dead rows for user only tables in this database |`n_dead_tup_user_tables` |Count |Maximum, Minimum, Average |`DatabaseName`, `ServerName`|PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Estimated Live Rows User Tables**<br><br>Estimated number of live rows for user only tables in this database |`n_live_tup_user_tables` |Count |Maximum, Minimum, Average |`DatabaseName`, `ServerName`|PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Estimated Modifications User Tables**<br><br>Estimated number of rows modified since user only tables were last analyzed |`n_mod_since_analyze_user_tables` |Count |Maximum, Minimum, Average |`DatabaseName`, `ServerName`|PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**User Tables Analyzed**<br><br>Number of user only tables that have been analyzed in this database |`tables_analyzed_user_tables` |Count |Maximum, Minimum, Average |`DatabaseName`, `ServerName`|PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**User Tables AutoAnalyzed**<br><br>Number of user only tables that have been analyzed by the autovacuum daemon in this database |`tables_autoanalyzed_user_tables` |Count |Maximum, Minimum, Average |`DatabaseName`, `ServerName`|PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**User Tables AutoVacuumed**<br><br>Number of user only tables that have been vacuumed by the autovacuum daemon in this database |`tables_autovacuumed_user_tables` |Count |Maximum, Minimum, Average |`DatabaseName`, `ServerName`|PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**User Tables Counter**<br><br>Number of user only tables in this database |`tables_counter_user_tables` |Count |Maximum, Minimum, Average |`DatabaseName`, `ServerName`|PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**User Tables Vacuumed**<br><br>Number of user only tables that have been vacuumed in this database |`tables_vacuumed_user_tables` |Count |Maximum, Minimum, Average |`DatabaseName`, `ServerName`|PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Vacuum Counter User Tables**<br><br>Number of times user only tables have been manually vacuumed in this database (not counting VACUUM FULL) |`vacuum_count_user_tables` |Count |Maximum, Minimum, Average |`DatabaseName`, `ServerName`|PT30M, PT1H, PT6H, PT12H, P1D |Yes|

### Category: Availability
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Database Is Alive**<br><br>Indicates if the database is up or not |`is_db_alive` |Count |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|

### Category: Database
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Disk Blocks Hit**<br><br>Number of times disk blocks were found already in the buffer cache, so that a read was not necessary |`blks_hit` |Count |Total (Sum) |`DatabaseName`, `ServerName`|PT1M |Yes|
|**Disk Blocks Read**<br><br>Number of disk blocks read in this database |`blks_read` |Count |Total (Sum) |`DatabaseName`, `ServerName`|PT1M |Yes|
|**Database Size**<br><br>Total database size |`database_size_bytes` |Bytes |Average, Maximum, Minimum |`DatabaseName`, `ServerName`|PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Deadlocks**<br><br>Number of deadlocks detected in this database |`deadlocks` |Count |Total (Sum) |`DatabaseName`, `ServerName`|PT1M |Yes|
|**Backends**<br><br>Number of backends connected to this database |`numbackends` |Count |Maximum, Minimum, Average |`DatabaseName`, `ServerName`|PT1M |Yes|
|**Temporary Files Size**<br><br>Total amount of data written to temporary files by queries in this database |`temp_bytes` |Bytes |Total (Sum) |`DatabaseName`, `ServerName`|PT1M |Yes|
|**Temporary Files**<br><br>Number of temporary files created by queries in this database |`temp_files` |Count |Total (Sum) |`DatabaseName`, `ServerName`|PT1M |Yes|
|**Transactions per second (Preview)**<br><br>Number of transactions executed within a second |`tps` |Count |Minimum, Maximum, Total (Sum) |`DatabaseName`, `ServerName`|PT1M |Yes|
|**Tuples Deleted**<br><br>Number of rows deleted by queries in this database |`tup_deleted` |Count |Total (Sum) |`DatabaseName`, `ServerName`|PT1M |Yes|
|**Tuples Fetched**<br><br>Number of rows fetched by queries in this database |`tup_fetched` |Count |Total (Sum) |`DatabaseName`, `ServerName`|PT1M |Yes|
|**Tuples Inserted**<br><br>Number of rows inserted by queries in this database |`tup_inserted` |Count |Total (Sum) |`DatabaseName`, `ServerName`|PT1M |Yes|
|**Tuples Returned**<br><br>Number of rows returned by queries in this database |`tup_returned` |Count |Total (Sum) |`DatabaseName`, `ServerName`|PT1M |Yes|
|**Tuples Updated**<br><br>Number of rows updated by queries in this database |`tup_updated` |Count |Total (Sum) |`DatabaseName`, `ServerName`|PT1M |Yes|
|**Transactions Committed**<br><br>Number of transactions in this database that have been committed |`xact_commit` |Count |Total (Sum) |`DatabaseName`, `ServerName`|PT1M |Yes|
|**Transactions Rolled Back**<br><br>Number of transactions in this database that have been rolled back |`xact_rollback` |Count |Total (Sum) |`DatabaseName`, `ServerName`|PT1M |Yes|
|**Total Transactions**<br><br>Number of total transactions executed in this database |`xact_total` |Count |Total (Sum) |`DatabaseName`, `ServerName`|PT1M |Yes|

### Category: Errors
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Failed Connections**<br><br>Failed Connections |`connections_failed` |Count |Total (Sum) |`ServerName`|PT1M |Yes|

### Category: Logical Replication
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Max Logical Replication Lag**<br><br>Maximum lag across all logical replication slots |`logical_replication_delay_in_bytes` |Bytes |Maximum, Minimum, Average |`ServerName`|PT1M |Yes|
|**Logical Replication Slot Sync Status (Preview)**<br><br>Displays status of logical replication slots in HA. |`logical_replication_slot_sync_status` |Count |Total (Sum), Maximum, Minimum |`ReplicationSlotName`, `LogicalServerName`|PT30M, PT1H, PT6H, PT12H, P1D |Yes|

### Category: PgBouncer metrics
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Active client connections**<br><br>Connections from clients which are associated with a PostgreSQL connection |`client_connections_active` |Count |Maximum, Minimum, Average |`DatabaseName`, `ServerName`|PT1M |Yes|
|**Waiting client connections**<br><br>Connections from clients that are waiting for a PostgreSQL connection to service them |`client_connections_waiting` |Count |Maximum, Minimum, Average |`DatabaseName`, `ServerName`|PT1M |Yes|
|**Number of connection pools**<br><br>Total number of connection pools |`num_pools` |Count |Maximum, Minimum, Average |`DatabaseName`, `ServerName`|PT1M |Yes|
|**Active server connections**<br><br>Connections to PostgreSQL that are in use by a client connection |`server_connections_active` |Count |Maximum, Minimum, Average |`DatabaseName`, `ServerName`|PT1M |Yes|
|**Idle server connections**<br><br>Connections to PostgreSQL that are idle, ready to service a new client connection |`server_connections_idle` |Count |Maximum, Minimum, Average |`DatabaseName`, `ServerName`|PT1M |Yes|
|**Total pooled connections**<br><br>Current number of pooled connections |`total_pooled_connections` |Count |Maximum, Minimum, Average |`DatabaseName`, `ServerName`|PT1M |Yes|

### Category: Replication
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Max Physical Replication Lag**<br><br>Maximum lag across all asynchronous physical replication slots |`physical_replication_delay_in_bytes` |Bytes |Maximum, Minimum, Average |`ServerName`|PT1M |Yes|
|**Read Replica Lag**<br><br>Read Replica lag in seconds |`physical_replication_delay_in_seconds` |Seconds |Maximum, Minimum, Average |`ServerName`|PT1M |Yes|

### Category: Saturation
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Backup Storage Used**<br><br>Backup Storage Used |`backup_storage_used` |Bytes |Average, Maximum, Minimum |`LogicalServerName`|PT1M |Yes|
|**CPU Credits Consumed**<br><br>Total number of credits consumed by the database server |`cpu_credits_consumed` |Count |Average, Maximum, Minimum |`LogicalServerName`|PT1M |Yes|
|**CPU Credits Remaining**<br><br>Total number of credits available to burst |`cpu_credits_remaining` |Count |Average, Maximum, Minimum |`LogicalServerName`|PT1M |Yes|
|**CPU percent**<br><br>CPU percent |`cpu_percent` |Percent |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|
|**Disk Bandwidth Consumed Percentage**<br><br>Percentage of disk bandwidth consumed per minute |`disk_bandwidth_consumed_percentage` |Percent |Average, Maximum, Minimum |`LogicalServerName`|PT1M |Yes|
|**Disk IOPS Consumed Percentage**<br><br>Percentage of disk I/Os consumed per minute |`disk_iops_consumed_percentage` |Percent |Average, Maximum, Minimum |`LogicalServerName`|PT1M |Yes|
|**Disk Queue Depth**<br><br>Number of outstanding I/O operations to the data disk |`disk_queue_depth` |Count |Average, Maximum, Minimum |`LogicalServerName`|PT1M |Yes|
|**IOPS**<br><br>IO Operations per second |`iops` |Count |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|
|**Memory percent**<br><br>Memory percent |`memory_percent` |Percent |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|
|**Postmaster Process cpu usage**<br><br>CPU usage of Postmaster process. Not applicable for Burstable SKU |`postmaster_process_cpu_usage_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |No|
|**Read IOPS**<br><br>Number of data disk I/O read operations per second |`read_iops` |Count |Average, Maximum, Minimum |`LogicalServerName`|PT1M |Yes|
|**Read Throughput Bytes/Sec**<br><br>Bytes read per second from the data disk during monitoring period |`read_throughput` |Count |Average, Maximum, Minimum |`LogicalServerName`|PT1M |Yes|
|**Storage Free**<br><br>Storage Free |`storage_free` |Bytes |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|
|**Storage percent**<br><br>Storage percent |`storage_percent` |Percent |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|
|**Storage used**<br><br>Storage used |`storage_used` |Bytes |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|
|**Transaction Log Storage Used**<br><br>Transaction Log Storage Used |`txlogs_storage_used` |Bytes |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|
|**Write IOPS**<br><br>Number of data disk I/O write operations per second |`write_iops` |Count |Average, Maximum, Minimum |`LogicalServerName`|PT1M |Yes|
|**Write Throughput Bytes/Sec**<br><br>Bytes written per second to the data disk during monitoring period |`write_throughput` |Count |Average, Maximum, Minimum |`LogicalServerName`|PT1M |Yes|

### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Active Connections**<br><br>Active Connections |`active_connections` |Count |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|
|**Succeeded Connections**<br><br>Succeeded Connections |`connections_succeeded` |Count |Total (Sum) |`ServerName`|PT1M |Yes|
|**Max Connections**<br><br>Max connections |`max_connections` |Count |Maximum |`ServerName`|PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Maximum Used Transaction IDs**<br><br>Maximum Used Transaction IDs |`maximum_used_transactionIDs` |Count |Average, Maximum, Minimum |`ServerName`|PT1M |Yes|
|**Network Out**<br><br>Network Out across active connections |`network_bytes_egress` |Bytes |Total (Sum) |`ServerName`|PT1M |Yes|
|**Network In**<br><br>Network In across active connections |`network_bytes_ingress` |Bytes |Total (Sum) |`ServerName`|PT1M |Yes|
|**TCP Connection Backlog**<br><br>Number of pending TCP connections waiting to be processed by the server. Applicable for 8vcore and above |`tcp_connection_backlog` |Count |Maximum, Minimum, Average |\<none\>|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
