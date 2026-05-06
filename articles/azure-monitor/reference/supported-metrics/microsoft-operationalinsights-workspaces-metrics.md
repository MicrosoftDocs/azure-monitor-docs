---
title: Supported metrics - Microsoft.OperationalInsights/workspaces
description: Reference for Microsoft.OperationalInsights/workspaces metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.OperationalInsights/workspaces, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.OperationalInsights/workspaces

The following table lists the metrics available for the Microsoft.OperationalInsights/workspaces resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.OperationalInsights/workspaces](../supported-logs/microsoft-operationalinsights-workspaces-logs.md)


### Category: DataExport
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Bytes Exported (preview)**<br><br>Total number of bytes exported per the specified data export rule to the specified destination from this workspace. |`BytesExported` |Bytes |Total (Sum) |`LogAnalyticsDataExportDestinationType`, `LogAnalyticsDataExportRuleName`|PT1M |Yes|
|**Exports Failed (preview)**<br><br>Total number of data exports failed per the specified data export rule to the specified destination from this workspace. |`ExportFailed` |Count |Total (Sum) |`LogAnalyticsDataExportDestinationType`, `LogAnalyticsDataExportRuleName`, `LogAnalyticsDataExportErrorType`|PT1M |Yes|
|**Records Exported (preview)**<br><br>Total number of records exported per the specified data export rule to the specified destination from this workspace. |`RecordsExported` |Count |Total (Sum) |`LogAnalyticsDataExportDestinationType`, `LogAnalyticsDataExportRuleName`|PT1M |Yes|

### Category: Legacy Log-based metrics
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**% Available Memory**<br><br>Average_% Available Memory. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_% Available Memory` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**% Available Swap Space**<br><br>Average_% Available Swap Space. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_% Available Swap Space` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**% Committed Bytes In Use**<br><br>Average_% Committed Bytes In Use. Supported for: Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_% Committed Bytes In Use` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**% DPC Time**<br><br>Average_% DPC Time. Supported for: Linux, Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_% DPC Time` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**% Free Inodes**<br><br>Average_% Free Inodes. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_% Free Inodes` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**% Free Space**<br><br>Average_% Free Space. Supported for: Linux, Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_% Free Space` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**% Idle Time**<br><br>Average_% Idle Time. Supported for: Linux, Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_% Idle Time` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**% Interrupt Time**<br><br>Average_% Interrupt Time. Supported for: Linux, Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_% Interrupt Time` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**% IO Wait Time**<br><br>Average_% IO Wait Time. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_% IO Wait Time` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**% Nice Time**<br><br>Average_% Nice Time. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_% Nice Time` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**% Privileged Time**<br><br>Average_% Privileged Time. Supported for: Linux, Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_% Privileged Time` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**% Processor Time**<br><br>Average_% Processor Time. Supported for: Linux, Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_% Processor Time` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**% Used Inodes**<br><br>Average_% Used Inodes. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_% Used Inodes` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**% Used Memory**<br><br>Average_% Used Memory. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_% Used Memory` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**% Used Space**<br><br>Average_% Used Space. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_% Used Space` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**% Used Swap Space**<br><br>Average_% Used Swap Space. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_% Used Swap Space` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**% User Time**<br><br>Average_% User Time. Supported for: Linux, Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_% User Time` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Available MBytes**<br><br>Average_Available MBytes. Supported for: Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Available MBytes` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Available MBytes Memory**<br><br>Average_Available MBytes Memory. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Available MBytes Memory` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Available MBytes Swap**<br><br>Average_Available MBytes Swap. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Available MBytes Swap` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Avg. Disk sec/Read**<br><br>Average_Avg. Disk sec/Read. Supported for: Linux, Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Avg. Disk sec/Read` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Avg. Disk sec/Transfer**<br><br>Average_Avg. Disk sec/Transfer. Supported for: Linux, Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Avg. Disk sec/Transfer` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Avg. Disk sec/Write**<br><br>Average_Avg. Disk sec/Write. Supported for: Linux, Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Avg. Disk sec/Write` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Bytes Received/sec**<br><br>Average_Bytes Received/sec. Supported for: Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Bytes Received/sec` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Bytes Sent/sec**<br><br>Average_Bytes Sent/sec. Supported for: Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Bytes Sent/sec` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Bytes Total/sec**<br><br>Average_Bytes Total/sec. Supported for: Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Bytes Total/sec` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Current Disk Queue Length**<br><br>Average_Current Disk Queue Length. Supported for: Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Current Disk Queue Length` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Disk Read Bytes/sec**<br><br>Average_Disk Read Bytes/sec. Supported for: Linux, Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Disk Read Bytes/sec` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Disk Reads/sec**<br><br>Average_Disk Reads/sec. Supported for: Linux, Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Disk Reads/sec` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Disk Transfers/sec**<br><br>Average_Disk Transfers/sec. Supported for: Linux, Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Disk Transfers/sec` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Disk Write Bytes/sec**<br><br>Average_Disk Write Bytes/sec. Supported for: Linux, Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Disk Write Bytes/sec` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Disk Writes/sec**<br><br>Average_Disk Writes/sec. Supported for: Linux, Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Disk Writes/sec` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Free Megabytes**<br><br>Average_Free Megabytes. Supported for: Linux, Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Free Megabytes` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Free Physical Memory**<br><br>Average_Free Physical Memory. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Free Physical Memory` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Free Space in Paging Files**<br><br>Average_Free Space in Paging Files. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Free Space in Paging Files` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Free Virtual Memory**<br><br>Average_Free Virtual Memory. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Free Virtual Memory` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Logical Disk Bytes/sec**<br><br>Average_Logical Disk Bytes/sec. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Logical Disk Bytes/sec` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Page Reads/sec**<br><br>Average_Page Reads/sec. Supported for: Linux, Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Page Reads/sec` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Page Writes/sec**<br><br>Average_Page Writes/sec. Supported for: Linux, Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Page Writes/sec` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Pages/sec**<br><br>Average_Pages/sec. Supported for: Linux, Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Pages/sec` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Pct Privileged Time**<br><br>Average_Pct Privileged Time. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Pct Privileged Time` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Pct User Time**<br><br>Average_Pct User Time. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Pct User Time` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Physical Disk Bytes/sec**<br><br>Average_Physical Disk Bytes/sec. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Physical Disk Bytes/sec` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Processes**<br><br>Average_Processes. Supported for: Linux, Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Processes` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Processor Queue Length**<br><br>Average_Processor Queue Length. Supported for: Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Processor Queue Length` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Size Stored In Paging Files**<br><br>Average_Size Stored In Paging Files. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Size Stored In Paging Files` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Total Bytes**<br><br>Average_Total Bytes. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Total Bytes` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Total Bytes Received**<br><br>Average_Total Bytes Received. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Total Bytes Received` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Total Bytes Transmitted**<br><br>Average_Total Bytes Transmitted. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Total Bytes Transmitted` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Total Collisions**<br><br>Average_Total Collisions. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Total Collisions` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Total Packets Received**<br><br>Average_Total Packets Received. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Total Packets Received` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Total Packets Transmitted**<br><br>Average_Total Packets Transmitted. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Total Packets Transmitted` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Total Rx Errors**<br><br>Average_Total Rx Errors. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Total Rx Errors` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Total Tx Errors**<br><br>Average_Total Tx Errors. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Total Tx Errors` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Uptime**<br><br>Average_Uptime. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Uptime` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Used MBytes Swap Space**<br><br>. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Used MBytes Swap Space` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Used Memory kBytes**<br><br>Average_Used Memory kBytes. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Used Memory kBytes` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Used Memory MBytes**<br><br>Average_Used Memory MBytes. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Used Memory MBytes` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Users**<br><br>Average_Users. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Users` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Virtual Shared Memory**<br><br>Average_Virtual Shared Memory. Supported for: Linux. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Average_Virtual Shared Memory` |Count |Average |`Computer`, `ObjectName`, `InstanceName`, `CounterPath`, `SourceSystem`|PT1M |Yes|
|**Event**<br><br>Event. Supported for: Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Event` |Count |Average |`Source`, `EventLog`, `Computer`, `EventCategory`, `EventLevel`, `EventLevelName`, `EventID`|PT1M |Yes|
|**Heartbeat**<br><br>Heartbeat. Supported for: Linux, Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Heartbeat` |Count |Total (Sum) |`Computer`, `OSType`, `Version`, `SourceComputerId`|PT1M |Yes|
|**Update**<br><br>Update. Supported for: Windows. Part of [metric alerts for logs feature](https://aka.ms/am-log-to-metric). |`Update` |Count |Average |`Computer`, `Product`, `Classification`, `UpdateState`, `Optional`, `Approved`|PT1M |Yes|

### Category: SLI
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**AvailabilityRate_Query**<br><br>User query success rate for this workspace. |`AvailabilityRate_Query` |Percent |Average |`IsUserQuery`|PT1M |No|
|**Ingestion Time**<br><br>Time in seconds it took since record recieved in Azure Monitor Logs cloud service until it was available for queries. |`Ingestion Time` |Seconds |Average, Maximum, Minimum |`Table Name`, `TableClassification`|PT1M |No|
|**Ingestion Volume**<br><br>Number of records ingested into a workspace or a table. |`Ingestion Volume` |Count |Count |`Table Name`, `TableClassification`|PT1M |No|

### Category: User Queries
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Query Count**<br><br>Total number of user queries for this workspace. |`Query Count` |Count |Count |`IsUserQuery`|PT1M |No|
|**Query Failure Count**<br><br>Total number of failed user queries for this workspace. |`Query Failure Count` |Count |Count |`IsUserQuery`|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
