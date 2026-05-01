---
title: Supported metrics - Microsoft.Sql/servers/elasticpools
description: Reference for Microsoft.Sql/servers/elasticpools metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Sql/servers/elasticpools, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Sql/servers/elasticpools

The following table lists the metrics available for the Microsoft.Sql/servers/elasticpools resource type.

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
|**Data space allocated**<br><br>Data space allocated |`allocated_data_storage` |Bytes |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Data space allocated percent**<br><br>Data space allocated percent. Not applicable to hyperscale |`allocated_data_storage_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**App CPU billed**<br><br>App CPU billed. Applies to serverless elastic pools. |`app_cpu_billed` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**App CPU percentage**<br><br>App CPU percentage. Applies to serverless elastic pools. |`app_cpu_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**App memory percentage**<br><br>App memory percentage. Applies to serverless elastic pools. |`app_memory_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**CPU limit**<br><br>CPU limit. Applies to vCore-based elastic pools. |`cpu_limit` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**CPU percentage**<br><br>CPU percentage |`cpu_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**CPU used**<br><br>CPU used. Applies to vCore-based elastic pools. |`cpu_used` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**DTU percentage**<br><br>DTU Percentage. Applies to DTU-based elastic pools. |`dtu_consumption_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**eDTU limit**<br><br>eDTU limit. Applies to DTU-based elastic pools. |`eDTU_limit` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**eDTU used**<br><br>eDTU used. Applies to DTU-based elastic pools. |`eDTU_used` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Log IO percentage**<br><br>Log IO percentage |`log_write_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Data IO percentage**<br><br>Data IO percentage |`physical_data_read_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Sessions Count**<br><br>Number of active sessions |`sessions_count` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Sessions percentage**<br><br>Sessions percentage |`sessions_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Data max size**<br><br>Data max size. Not applicable to hyperscale |`storage_limit` |Bytes |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Data space used percent**<br><br>Data space used percent. Not applicable to hyperscale |`storage_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Data space used**<br><br>Data space used |`storage_used` |Bytes |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Workers percentage**<br><br>Workers percentage |`workers_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**In-Memory OLTP storage percent**<br><br>In-Memory OLTP storage percent. Not applicable to hyperscale |`xtp_storage_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|

### Category: InstanceAndAppAdvanced
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**SQL instance CPU percent**<br><br>CPU usage by all user and system workloads. Applies to elastic pools. |`sql_instance_cpu_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**SQL instance memory percent**<br><br>Memory usage by the database engine instance. Applies to elastic pools. |`sql_instance_memory_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**SQL Server process core percent**<br><br>CPU usage as a percentage of the SQL DB process. Applies to elastic pools. (This metric is equivalent to sql_instance_cpu_percent, and will be removed in the future.) |`sqlserver_process_core_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**SQL Server process memory percent**<br><br>Memory usage as a percentage of the SQL DB process. Applies to elastic pools. (This metric is equivalent to sql_instance_memory_percent, and will be removed in the future.) |`sqlserver_process_memory_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Tempdb Data File Size Kilobytes**<br><br>Space used in tempdb data files in kilobytes. |`tempdb_data_size` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Tempdb Log File Size Kilobytes**<br><br>Space used in tempdb transaction log file in kilobytes. |`tempdb_log_size` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Tempdb Percent Log Used**<br><br>Space used percentage in tempdb transaction log file |`tempdb_log_used_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
