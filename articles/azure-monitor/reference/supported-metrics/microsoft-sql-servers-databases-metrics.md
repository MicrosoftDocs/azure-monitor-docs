---
title: Supported metrics - Microsoft.Sql/servers/databases
description: Reference for Microsoft.Sql/servers/databases metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Sql/servers/databases, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Sql/servers/databases

The following table lists the metrics available for the Microsoft.Sql/servers/databases resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.Sql/servers/databases](../supported-logs/microsoft-sql-servers-databases-logs.md)


### Category: Basic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Active queries**<br><br>Active queries across all workload groups. Applies only to data warehouses. |`active_queries` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Data space allocated**<br><br>Allocated data storage. Not applicable to data warehouses. |`allocated_data_storage` |Bytes |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**App CPU billed**<br><br>App CPU billed. Applies to serverless databases. |`app_cpu_billed` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**App CPU billed HA replicas**<br><br>Sum of app CPU billed across all HA replicas associated with the primary replica or a named replica. |`app_cpu_billed_ha_replicas` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**App CPU percentage**<br><br>App CPU percentage. Applies to serverless databases. |`app_cpu_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**App memory percentage**<br><br>App memory percentage. Applies to serverless databases. |`app_memory_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Availability**<br><br>The percentage of SLA compliant availability for the database. Availability is calculated based on connections and for each one-minute data point the value will be either 100% if connection(s) succeed or 0% if all connections fail due to system errors. Note:Select 1-minute time granularity to view SLA compliant availability. |`availability` |Percent |Average, Maximum, Minimum, Count, Total (Sum) |\<none\>|PT1M |Yes|
|**Data storage size**<br><br>Data storage size. Applies to Hyperscale databases. |`base_blob_size_bytes` |Bytes |Average, Maximum, Minimum |\<none\>|P1D |Yes|
|**Blocked by Firewall**<br><br>Blocked by Firewall |`blocked_by_firewall` |Count |Total (Sum), Count |\<none\>|PT1M |Yes|
|**Cache hit percentage**<br><br>Cache hit percentage. Applies only to data warehouses. |`cache_hit_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Cache used percentage**<br><br>Cache used percentage. Applies only to data warehouses. |`cache_used_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Failed Connections : System Errors**<br><br>Failed Connections |`connection_failed` |Count |Total (Sum), Count |`Error`, `ValidatedDriverNameAndVersion`|PT1M |Yes|
|**Failed Connections : User Errors**<br><br>Failed Connections : User Errors |`connection_failed_user_error` |Count |Total (Sum), Count |`Error`, `ValidatedDriverNameAndVersion`|PT1M |Yes|
|**Successful Connections**<br><br>Successful Connections |`connection_successful` |Count |Total (Sum), Count |`SslProtocol`, `ValidatedDriverNameAndVersion`|PT1M |Yes|
|**CPU limit**<br><br>CPU limit. Applies to vCore-based databases. |`cpu_limit` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**CPU percentage**<br><br>CPU percentage |`cpu_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**CPU used**<br><br>CPU used. Applies to vCore-based databases. |`cpu_used` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Deadlocks**<br><br>Deadlocks. Not applicable to data warehouses. |`deadlock` |Count |Total (Sum), Count |\<none\>|PT1M |Yes|
|**Differential backup storage size**<br><br>Cumulative differential backup storage size. Applies to vCore-based databases. Not applicable to Hyperscale databases. |`diff_backup_size_bytes` |Bytes |Average, Maximum, Minimum |\<none\>|P1D |Yes|
|**DTU percentage**<br><br>DTU Percentage. Applies to DTU-based databases. |`dtu_consumption_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**DTU Limit**<br><br>DTU Limit. Applies to DTU-based databases. |`dtu_limit` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**DTU used**<br><br>DTU used. Applies to DTU-based databases. |`dtu_used` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**DWU percentage**<br><br>DWU percentage. Applies only to data warehouses. |`dwu_consumption_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**DWU limit**<br><br>DWU limit. Applies only to data warehouses. |`dwu_limit` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**DWU used**<br><br>DWU used. Applies only to data warehouses. |`dwu_used` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Free amount consumed**<br><br>Free amount of vCore seconds consumed this month. Applies only to free database offer. |`free_amount_consumed` |Count |Average, Maximum, Minimum |\<none\>|PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Free amount remaining**<br><br>Free amount of vCore seconds remaining this month. Applies only to free database offer. |`free_amount_remaining` |Count |Average, Maximum, Minimum |\<none\>|PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Full backup storage size**<br><br>Cumulative full backup storage size. Applies to vCore-based databases. Not applicable to Hyperscale databases. |`full_backup_size_bytes` |Bytes |Average, Maximum, Minimum |\<none\>|P1D |Yes|
|**Failed Ledger Digest Uploads**<br><br>Ledger digests that failed to be uploaded. |`ledger_digest_upload_failed` |Count |Count |\<none\>|PT1M |Yes|
|**Successful Ledger Digest Uploads**<br><br>Ledger digests that were successfully uploaded. |`ledger_digest_upload_success` |Count |Count |\<none\>|PT1M |Yes|
|**Local tempdb percentage**<br><br>Local tempdb percentage. Applies only to data warehouses. |`local_tempdb_usage_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Log backup storage size**<br><br>Cumulative log backup storage size. Applies to vCore-based and Hyperscale databases. |`log_backup_size_bytes` |Bytes |Average, Maximum, Minimum |\<none\>|P1D |Yes|
|**Log IO percentage**<br><br>Log IO percentage. Not applicable to data warehouses. |`log_write_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Memory percentage**<br><br>Memory percentage. Applies only to data warehouses. |`memory_usage_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Data IO percentage**<br><br>Data IO percentage |`physical_data_read_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Queued queries**<br><br>Queued queries across all workload groups. Applies only to data warehouses. |`queued_queries` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Replication lag (preview)**<br><br>Replication lag or RPO is the number of seconds that the secondary database is behind the primary database. This value is available on the primary database only. |`replication_lag_seconds` |Seconds |Average, Maximum, Minimum |`PartnerResourceId`, `PartnerServerName`, `PartnerDatabaseName`|PT1M |Yes|
|**Sessions count**<br><br>Number of active sessions. Not applicable to Synapse DW Analytics. |`sessions_count` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Sessions percentage**<br><br>Sessions percentage. Not applicable to data warehouses. |`sessions_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Data backup storage size**<br><br>Cumulative data backup storage size. Applies to Hyperscale databases. |`snapshot_backup_size_bytes` |Bytes |Average, Maximum, Minimum |\<none\>|P1D |Yes|
|**Data space used**<br><br>Data space used. Not applicable to data warehouses. |`storage` |Bytes |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Data space used percent**<br><br>Data space used percent. Not applicable to data warehouses or hyperscale databases. |`storage_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Workers percentage**<br><br>Workers percentage. Not applicable to data warehouses. |`workers_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**In-Memory OLTP storage percent**<br><br>In-Memory OLTP storage percent. Not applicable to data warehouses. |`xtp_storage_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|

### Category: InstanceAndAppAdvanced
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**SQL instance CPU percent**<br><br>CPU usage by all user and system workloads. Not applicable to data warehouses. |`sql_instance_cpu_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**SQL instance memory percent**<br><br>Memory usage by the database engine instance. Not applicable to data warehouses. |`sql_instance_memory_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**SQL Server process core percent**<br><br>CPU usage as a percentage of the SQL DB process. Not applicable to data warehouses. (This metric is equivalent to sql_instance_cpu_percent, and will be removed in the future.) |`sqlserver_process_core_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**SQL Server process memory percent**<br><br>Memory usage as a percentage of the SQL DB process. Not applicable to data warehouses. (This metric is equivalent to sql_instance_memory_percent, and will be removed in the future.) |`sqlserver_process_memory_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Tempdb Data File Size Kilobytes**<br><br>Space used in tempdb data files in kilobytes. Not applicable to data warehouses. |`tempdb_data_size` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Tempdb Log File Size Kilobytes**<br><br>Space used in tempdb transaction log file in kilobytes. Not applicable to data warehouses. |`tempdb_log_size` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Tempdb Percent Log Used**<br><br>Space used percentage in tempdb transaction log file. Not applicable to data warehouses. |`tempdb_log_used_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|

### Category: WorkloadManagement
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Workload group active queries**<br><br>Active queries within the workload group. Applies only to data warehouses. |`wlg_active_queries` |Count |Total (Sum) |`WorkloadGroupName`, `IsUserDefined`|PT1M |Yes|
|**Workload group query timeouts**<br><br>Queries that have timed out for the workload group. Applies only to data warehouses. |`wlg_active_queries_timeouts` |Count |Total (Sum) |`WorkloadGroupName`, `IsUserDefined`|PT1M |Yes|
|**Workload group allocation by system percent**<br><br>Allocated percentage of resources relative to the entire system per workload group. Applies only to data warehouses. |`wlg_allocation_relative_to_system_percent` |Percent |Average, Maximum, Minimum, Total (Sum) |`WorkloadGroupName`, `IsUserDefined`|PT1M |Yes|
|**Workload group allocation by cap resource percent**<br><br>Allocated percentage of resources relative to the specified cap resources per workload group. Applies only to data warehouses. |`wlg_allocation_relative_to_wlg_effective_cap_percent` |Percent |Average, Maximum, Minimum |`WorkloadGroupName`, `IsUserDefined`|PT1M |Yes|
|**Effective cap resource percent**<br><br>A hard limit on the percentage of resources allowed for the workload group, taking into account Effective Min Resource Percentage allocated for other workload groups. Applies only to data warehouses. |`wlg_effective_cap_resource_percent` |Percent |Average, Maximum, Minimum |`WorkloadGroupName`, `IsUserDefined`|PT1M |Yes|
|**Effective min resource percent**<br><br>Minimum percentage of resources reserved and isolated for the workload group, taking into account the service level minimum. Applies only to data warehouses. |`wlg_effective_min_resource_percent` |Percent |Average, Maximum, Minimum, Total (Sum) |`WorkloadGroupName`, `IsUserDefined`|PT1M |Yes|
|**Workload group queued queries**<br><br>Queued queries within the workload group. Applies only to data warehouses. |`wlg_queued_queries` |Count |Total (Sum) |`WorkloadGroupName`, `IsUserDefined`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
