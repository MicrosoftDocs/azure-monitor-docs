---
title: Supported metrics - Wandisco.Fusion/migrators/liveDataMigrations
description: Reference for Wandisco.Fusion/migrators/liveDataMigrations metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Wandisco.Fusion/migrators/liveDataMigrations, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Wandisco.Fusion/migrators/liveDataMigrations

The following table lists the metrics available for the Wandisco.Fusion/migrators/liveDataMigrations resource type.

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



|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Bytes Migrated by Migration**<br><br>Provides a detailed view of a migration's Bytes Transferred |`BytesMigratedByMigration` |Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**Data Transactions by Migration**<br><br>Provides a detailed view of a migration's Data Transactions |`DataTransactionsByMigration` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Directories Created Count**<br><br>This provides a running view of how many directories have been created as part of a migration. |`DirectoriesCreatedCount` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Files Migration Count**<br><br>This provides a running total of how many files have been migrated. |`FileMigrationCount` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Initial Scan Data Migrated in Bytes**<br><br>This provides the view of the total bytes which have been transferred in a new migrator as a result of the initial scan of the On-Premises file system. Any data which is added to the migration after the initial scan migration, is NOT included in this metric. |`InitialScanDataMigratedInBytes` |Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**Live Data Migrated in Bytes**<br><br>Provides a running total of LiveData which has been changed due to Client activity, since the migration started. |`LiveDataMigratedInBytes` |Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**Number of Excluded Paths**<br><br>Provides a running count of the paths which have been excluded from the migration due to Exclusion Rules. |`NumberOfExcludedPaths` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Number of Failed Paths**<br><br>A count of which paths have failed to migrate. |`NumberOfFailedPaths` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Recurring Scan Duration In Seconds**<br><br>The metric shows the duration in seconds of each scan. |`RecurringScanDurationInSeconds` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Total Bytes Transferred**<br><br>This metric covers how many bytes have been transferred (does not reflect how many have successfully migrated, only how much has been transferred). |`TotalBytesTransferred` |Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**Total Recurring Scans**<br><br>This metric shows the count of how many scans have been completed on a recurring migration. |`TotalRecurringScans` |Count |Total (Sum) |\<none\>|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
