---
title: Supported metrics - Oracle.Database/exadbVmClusters
description: Reference for Oracle.Database/exadbVmClusters metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/31/2026
ms.custom: Oracle.Database/exadbVmClusters, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Oracle.Database/exadbVmClusters

The following table lists the metrics available for the Oracle.Database/exadbVmClusters resource type.

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


For a list of supported logs, see [Supported log categories - Oracle.Database/exadbVmClusters](../supported-logs/oracle-database-exadbvmclusters-logs.md)


### Category: Availability
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Node Status**<br><br>Indicates whether the host is reachable. |`oci_database_cluster/NodeStatus` | No | Count |Minimum, Maximum, Average |`Oracle.resourceId`, `Oracle.resourceName`, `hostName`, `deploymentType`, `Oracle.resourceId_dbnode`, `Oracle.resourceName_dbnode`|PT1M |Yes|

### Category: Saturation
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**CPU Utilization (OCI Database Cluster)**<br><br>Percent CPU utilization |`oci_database_cluster/CpuUtilization` | No | Percent |Minimum, Maximum, Average |`Oracle.resourceId`, `Oracle.resourceName`, `hostName`, `deploymentType`, `Oracle.resourceId_dbnode`, `Oracle.resourceName_dbnode`|PT1M |Yes|
|**Filesystem Utilization**<br><br>Percent utilization of provisioned filesystem |`oci_database_cluster/FilesystemUtilization` | No | Percent |Minimum, Maximum, Average |`Oracle.resourceId`, `Oracle.resourceName`, `hostName`, `deploymentType`, `Oracle.resourceId_dbnode`, `Oracle.resourceName_dbnode`, `filesystemName`|PT1M |Yes|
|**Load Average**<br><br>System load average over 5 minutes |`oci_database_cluster/LoadAverage` | No | Count |Minimum, Maximum, Average |`Oracle.resourceId`, `Oracle.resourceName`, `hostName`, `deploymentType`, `Oracle.resourceId_dbnode`, `Oracle.resourceName_dbnode`|PT1M |Yes|
|**Memory Utilization**<br><br>Percentage of memory available for starting new applications, without swapping. The available memory can be obtained via the following command: cat /proc/meminfo |`oci_database_cluster/MemoryUtilization` | No | Percent |Minimum, Maximum, Average |`Oracle.resourceId`, `Oracle.resourceName`, `hostName`, `deploymentType`, `Oracle.resourceId_dbnode`, `Oracle.resourceName_dbnode`|PT1M |Yes|
|**OCPU Allocated**<br><br>The number of OCPUs allocated |`oci_database_cluster/OcpusAllocated` | No | Count |Minimum, Maximum, Average |`Oracle.resourceId`, `Oracle.resourceName`, `deploymentType`|PT1M |Yes|
|**Swap Utilization**<br><br>Percent utilization of total swap space |`oci_database_cluster/SwapUtilization` | No | Percent |Minimum, Maximum, Average |`Oracle.resourceId`, `Oracle.resourceName`, `hostName`, `deploymentType`, `Oracle.resourceId_dbnode`, `Oracle.resourceName_dbnode`|PT1M |Yes|
|**DB Block Changes**<br><br>The Average number of blocks changed per second. |`oci_database/BlockChanges` | No | CountPerSecond |Minimum, Maximum, Average |`Oracle.resourceId`, `Oracle.resourceName`, `instanceNumber`, `instanceName`, `hostName`, `deploymentType`, `Oracle.resourceId_database`, `Oracle.resourceName_database`|PT1M |Yes|
|**CPU Utilization (OCI Database)**<br><br>The CPU utilization expressed as a percentage, aggregated across all consumer groups. The utilization percentage is reported with respect to the number of CPUs the database is allowed to use. |`oci_database/CpuUtilization` | No | Percent |Minimum, Maximum, Average |`Oracle.resourceId`, `Oracle.resourceName`, `instanceNumber`, `instanceName`, `hostName`, `deploymentType`, `Oracle.resourceId_database`, `Oracle.resourceName_database`|PT1M |Yes|
|**Parse Count**<br><br>The number of hard and soft parses during the selected interval. |`oci_database/ParseCount` | No | Count |Minimum, Maximum, Average, Total (Sum) |`Oracle.resourceId`, `Oracle.resourceName`, `instanceNumber`, `instanceName`, `hostName`, `deploymentType`, `Oracle.resourceId_database`, `Oracle.resourceName_database`|PT1M |Yes|
|**Storage Space Allocated**<br><br>Total amount of storage space allocated to the database at the collection time |`oci_database/StorageAllocated` | No | Bytes |Minimum, Maximum, Average |`Oracle.resourceId`, `Oracle.resourceName`, `deploymentType`, `Oracle.resourceId_database`, `Oracle.resourceName_database`|PT1H, PT6H, PT12H, P1D |Yes|
|**Allocated Storage Space By Tablespace**<br><br>Total amount of storage space allocated to the tablespace at the collection time. In case of container database, this metric provides root container tablespaces. |`oci_database/StorageAllocatedByTablespace` | No | Bytes |Minimum, Maximum, Average |`Oracle.resourceId`, `Oracle.resourceName`, `TablespaceName`, `tablespaceType`, `deploymentType`, `Oracle.resourceId_database`, `Oracle.resourceName_database`|PT1H, PT6H, PT12H, P1D |Yes|
|**Storage Space Used**<br><br>Total amount of storage space used by the database at the collection time. |`oci_database/StorageUsed` | No | Bytes |Minimum, Maximum, Average |`Oracle.resourceId`, `Oracle.resourceName`, `deploymentType`, `Oracle.resourceId_database`, `Oracle.resourceName_database`|PT1H, PT6H, PT12H, P1D |Yes|
|**Storage Space Used By Tablespace**<br><br>Total amount of storage space used by tablespace at the collection time. In case of container database, this metric provides root container tablespaces. |`oci_database/StorageUsedByTablespace` | No | Bytes |Minimum, Maximum, Average |`Oracle.resourceId`, `Oracle.resourceName`, `tablespaceName`, `tablespaceType`, `deploymentType`, `Oracle.resourceId_database`, `Oracle.resourceName_database`|PT1H, PT6H, PT12H, P1D |Yes|
|**Storage Utilization**<br><br>The percentage of provisioned storage capacity currently in use. Represents the total allocated space for all tablespaces. |`oci_database/StorageUtilization` | No | Percent |Minimum, Maximum, Average |`Oracle.resourceId`, `Oracle.resourceName`, `deploymentType`, `Oracle.resourceId_database`, `Oracle.resourceName_database`|PT1H, PT6H, PT12H, P1D |Yes|
|**Storage Space Utilization By Tablespace**<br><br>This indicates the percentage of storage space utilized by the tablespace at the collection time. In case of container database, this metric provides root container tablespaces.. |`oci_database/StorageUtilizationByTablespace` | No | Percent |Minimum, Maximum, Average |`Oracle.resourceId`, `Oracle.resourceName`, `tablespaceName`, `tablespaceType`, `deploymentType`|PT1H, PT6H, PT12H, P1D |Yes|

### Category: Traffic
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Current Logons**<br><br>The number of successful logons during the selected interval. |`oci_database/CurrentLogons` | No | Count |Minimum, Maximum, Average, Total (Sum) |`Oracle.resourceId`, `Oracle.resourceName`, `instanceNumber`, `instanceName`, `hostName`, `deploymentType`, `Oracle.resourceId_database`, `Oracle.resourceName_database`|PT1M |Yes|
|**Execute Count**<br><br>The number of user and recursive calls that executed SQL statements during the selected interval. |`oci_database/ExecuteCount` | No | Count |Minimum, Maximum, Average, Total (Sum) |`Oracle.resourceId`, `Oracle.resourceName`, `instanceNumber`, `instanceName`, `hostName`, `deploymentType`|PT1M |Yes|
|**Transaction Count**<br><br>The combined number of user commits and user rollbacks during the selected interval. |`oci_database/TransactionCount` | No | Count |Minimum, Maximum, Average, Total (Sum) |`Oracle.resourceId`, `Oracle.resourceName`, `instanceNumber`, `instanceName`, `hostName`, `deploymentType`, `Oracle.resourceId_database`, `Oracle.resourceName_database`|PT1M |Yes|
|**User Calls**<br><br>The combined number of logons, parses, and execute calls during the selected interval. |`oci_database/UserCalls` | No | Count |Minimum, Maximum, Average, Total (Sum) |`Oracle.resourceId`, `Oracle.resourceName`, `instanceNumber`, `instanceName`, `hostName`, `deploymentType`, `Oracle.resourceId_database`, `Oracle.resourceName_database`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
