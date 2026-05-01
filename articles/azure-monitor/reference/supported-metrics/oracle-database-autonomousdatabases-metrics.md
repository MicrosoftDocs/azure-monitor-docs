---
title: Supported metrics - Oracle.Database/autonomousDatabases
description: Reference for Oracle.Database/autonomousDatabases metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/28/2026
ms.custom: Oracle.Database/autonomousDatabases, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Oracle.Database/autonomousDatabases

The following table lists the metrics available for the Oracle.Database/autonomousDatabases resource type.

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


For a list of supported logs, see [Supported log categories - Oracle.Database/autonomousDatabases](../supported-logs/oracle-database-autonomousdatabases-logs.md)


### Category: Availability
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Database Availability**<br><br>The database is available for connections in the given minute, with possible values: 1 = DB Available, 0 = DB Unavailable. (Statistic: Mean, Interval: 1 minute) |`oci_autonomous_database/DatabaseAvailability` |Count |Minimum, Maximum, Average |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|

### Category: Error
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Failed Connections**<br><br>The number of failed database connections. (Statistic: Sum, Interval: 1 minute) |`oci_autonomous_database/FailedConnections` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**Failed Logons**<br><br>The number of log ons that failed because of an invalid user name and/or password, during the selected interval. (Statistic: Mean, Interval: 1 minute) |`oci_autonomous_database/FailedLogons` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**Parse Count (Failures)**<br><br>The number of parse failures during the selected time interval. (Statistic: Sum, Interval: 1 minute) |`oci_autonomous_database/ParseFailureCount` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|

### Category: Latency
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**APEX Page Load Time**<br><br>Average APEX page execution time over the time interval. |`oci_autonomous_database/APEXPageLoadTime` |CountPerSecond |Minimum, Maximum, Average |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**Connection Latency**<br><br>The time taken to connect to an Oracle Autonomous Database Serverless instance in each region from a Compute service virtual machine in the same region. (Statistic: Max, Interval: 5 minutes) |`oci_autonomous_database/ConnectionLatency` |Milliseconds |Minimum, Maximum, Average |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**Peer Lag**<br><br>The total time in seconds by which the Disaster Recovery peer lags behind its Primary database. For a local Disaster Recovery peer, the metric is displayed under the Primary database. For a cross-region Disaster Recovery peer, this metric is displayed under the Disaster Recovery peer. (Statistic: Max, Interval: 1 minute) |`oci_autonomous_database/PeerLag` |Seconds |Minimum, Maximum, Average |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**Query Latency**<br><br>The time taken to display the results of a simple query on the user's screen. (Statistic: Max, Interval: 5 minutes) |`oci_autonomous_database/QueryLatency` |Milliseconds |Minimum, Maximum, Average |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Wait Time**<br><br>Average rate of accumulation of non-idle wait time by foreground sessions in the database over the time interval. (Statistic: Mean, Interval: 1 minute) |`oci_autonomous_database/WaitTime` |CountPerSecond |Minimum, Maximum, Average |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|

### Category: Saturation
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Active APEX Applications**<br><br>The number of APEX applications that had activity over the time interval. |`oci_autonomous_database/APEXApps` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**APEX Page Events**<br><br>The number of APEX page events over the time interval. |`oci_autonomous_database/APEXPageEvents` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**APEX Workspace Count**<br><br>Total number of user-created APEX workspaces at given time. |`oci_autonomous_database/APEXWorkspaceCount` |Count |Minimum, Maximum, Average |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**Blocking Sessions**<br><br>The number of current blocking sessions. (Statistic: Max, Interval: 1 minute) |`oci_autonomous_database/BlockingSessions` |Count |Minimum, Maximum, Average |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**CPU Time**<br><br>Average rate of accumulation of CPU time by foreground sessions in the database over the time interval. (Statistic: Mean, Interval: 1 minute) |`oci_autonomous_database/CPUTime` |CountPerSecond |Minimum, Maximum, Average |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**CPU Utilization**<br><br>The CPU usage expressed as a percentage, aggregated across all consumer groups. The utilization percentage is reported with respect to the number of CPUs the database is allowed to use. (Statistic: Mean, Interval: 1 minute) |`oci_autonomous_database/CpuUtilization` |Percent |Minimum, Maximum, Average |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**DB Block Changes**<br><br>The number of changes that were part of an update or delete operation that were made to all blocks in the SGA. Such changes generate redo log entries and thus become permanent changes to the database if the transaction is committed. This approximates total database work. This statistic indicates the rate at which buffers are being dirtied, during the selected time interval. (Statistic: Sum, Interval: 1 minute) |`oci_autonomous_database/DBBlockChanges` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**DB Time**<br><br>The amount of time database user sessions spend executing database code (CPU Time + WaitTime). DB Time is used to infer database call latency, because DB Time increases in direct proportion to both database call latency (response time) and call volume. It is calculated as the average rate of accumulation of database time by foreground sessions in the database over the time interval. (Statistic: Mean, Interval: 1 minute) |`oci_autonomous_database/DBTime` |CountPerSecond |Minimum, Maximum, Average |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**Parse Count (Hard)**<br><br>The number of parse calls (real parses) during the selected time interval. A hard parse is an expensive operation in terms of memory use, because it requires Oracle to allocate a workheap and other memory structures and then build a parse tree. (Statistic: Sum, Interval: 1 minute) |`oci_autonomous_database/HardParseCount` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**Session Logical Reads**<br><br>The sum of "db block gets" plus "consistent gets", during the selected time interval. This includes logical reads of database blocks from either the buffer cache or process private memory. |`oci_autonomous_database/LogicalReads` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**Parse Count (Total)**<br><br>The number of hard and soft parses during the selected interval. (Statistic: Sum, Interval: 1 minute) |`oci_autonomous_database/ParseCount` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**Physical Reads**<br><br>The number of data blocks read from disk, during the selected time interval. (Statistic: Sum, Interval: 1 minute) |`oci_autonomous_database/PhysicalReads` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**Physical Read Total Bytes**<br><br>The size in bytes of disk reads by all database instance activity including application reads, backup and recovery, and other utilities, during the selected time interval. (Statistic: Sum, Interval: 1 minute) |`oci_autonomous_database/PhysicalReadTotalBytes` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**Physical Writes**<br><br>The number of data blocks written to disk, during the selected time interval. (Statistic: Sum, Interval: 1 minute) |`oci_autonomous_database/PhysicalWrites` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**Physical Write Total Bytes**<br><br>The size in bytes of all disk writes for the database instance including application activity, backup and recovery, and other utilities, during the selected time interval. (Statistic: Sum, Interval: 1 minute) |`oci_autonomous_database/PhysicalWriteTotalBytes` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**Redo Generated**<br><br>Amount of redo generated in bytes, during the selected time interval. (Statistic: Sum, Interval: 1 minute) |`oci_autonomous_database/RedoGenerated` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**Bytes Received via SQL*Net from Client**<br><br>The number of bytes received from the client over Oracle Net Services, during the selected time interval. (Statistic: Sum, Interval: 1 minute) |`oci_autonomous_database/SQLNetBytesFromClient` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**Bytes Received via SQL*Net from DBLink**<br><br>The number of bytes received from a database link over Oracle Net Services, during the selected time interval. (Statistic: Sum, Interval: 1 minute) |`oci_autonomous_database/SQLNetBytesFromDBLink` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**Bytes Sent via SQL*Net to Client**<br><br>The number of bytes sent to the client from the foreground processes, during the selected time interval. (Statistic: Sum, Interval: 1 minute) |`oci_autonomous_database/SQLNetBytesToClient` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**Bytes Sent via SQL*Net to DBLink**<br><br>The number of bytes sent over a database link, during the selected time interval. (Statistic: Sum, Interval: 1 minute) |`oci_autonomous_database/SQLNetBytesToDBLink` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**Storage Space Allocated**<br><br>Amount of space allocated to the database for all tablespaces, during the interval. (Statistic: Max, Interval: 1 hour) |`oci_autonomous_database/StorageAllocated` |Bytes |Minimum, Maximum, Average |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1H, PT6H, PT12H, P1D |Yes|
|**Maximum Storage Space**<br><br>Maximum amount of storage reserved for the database during the interval. (Statistic: Max, Interval: 1 hour) |`oci_autonomous_database/StorageMax` |Bytes |Minimum, Maximum, Average |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1H, PT6H, PT12H, P1D |Yes|
|**Storage Space Used**<br><br>Maximum amount of space used during the interval. (Statistic: Max, Interval: 1 hour) |`oci_autonomous_database/StorageUsed` |Bytes |Minimum, Maximum, Average |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1H, PT6H, PT12H, P1D |Yes|
|**Storage Utilization**<br><br>The percentage of the reserved maximum storage currently allocated for all database tablespaces. Represents the total reserved space for all tablespaces. (Statistic: Mean, Interval: 1 hour) |`oci_autonomous_database/StorageUtilization` |Percent |Minimum, Maximum, Average |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1H, PT6H, PT12H, P1D |Yes|

### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Current Logons**<br><br>The number of successful logons during the selected interval. (Statistic: Count, Interval: 1 minute) |`oci_autonomous_database/CurrentLogons` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**Execute Count**<br><br>The number of user and recursive calls that executed SQL statements during the selected interval. (Statistic: Sum, Interval: 1 minute) |`oci_autonomous_database/ExecuteCount` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**Queued Statements**<br><br>The number of queued SQL statements, aggregated across all consumer groups, during the selected interval. (Statistic: Sum, Interval: 1 minute) |`oci_autonomous_database/QueuedStatements` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**Running Statements**<br><br>The number of running SQL statements, aggregated across all consumer groups, during the selected interval. (Statistic: Mean, Interval: 1 minute) |`oci_autonomous_database/RunningStatements` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**Sessions**<br><br>The number of sessions in the database. (Statistic: Sum, Interval: 1 minute) |`oci_autonomous_database/Sessions` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**Transaction Count**<br><br>The combined number of user commits and user rollbacks during the selected interval. (Statistic: Sum, Interval: 1 minute) |`oci_autonomous_database/TransactionCount` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**User Calls**<br><br>The combined number of logons, parses, and execute calls during the selected interval. (Statistic: Sum, Interval: 1 minute) |`oci_autonomous_database/UserCalls` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**User Commits**<br><br>The number of user commits during the selected time interval. When a user commits a transaction, the generated redo that reflects the changes made to database blocks must be written to disk. Commits often represent the closest thing to a user transaction rate. (Statistic: Sum, Interval: 1 minute) |`oci_autonomous_database/UserCommits` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|
|**User Rollbacks**<br><br>Number of times users manually issue the ROLLBACK statement or an error occurs during a user's transactions, during the selected time interval. (Statistic: Sum, Interval: 1 minute) |`oci_autonomous_database/UserRollbacks` |Count |Minimum, Maximum, Average, Total (Sum) |`autonomousDbType`, `deploymentType`, `displayName`, `region`, `Oracle.resourceId`, `Oracle.resourceName`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
