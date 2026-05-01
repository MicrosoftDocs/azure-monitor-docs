---
title: Supported metrics - Wandisco.Fusion/migrators
description: Reference for Wandisco.Fusion/migrators metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Wandisco.Fusion/migrators, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Wandisco.Fusion/migrators

The following table lists the metrics available for the Wandisco.Fusion/migrators resource type.

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
|**Bytes per Second.**<br><br>Throughput speed of Bytes/second being utilised for a migrator. |`BytesPerSecond` |BytesPerSecond |Average |\<none\>|PT1M |Yes|
|**Directories Created Count**<br><br>This provides a running view of how many directories have been created as part of a migration. |`DirectoriesCreatedCount` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Files Migration Count**<br><br>This provides a running total of how many files have been migrated. |`FileMigrationCount` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Initial Scan Data Migrated in Bytes**<br><br>This provides the view of the total bytes which have been transferred in a new migrator as a result of the initial scan of the On-Premises file system. Any data which is added to the migration after the initial scan migration, is NOT included in this metric. |`InitialScanDataMigratedInBytes` |Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**Live Data Migrated in Bytes**<br><br>Provides a running total of LiveData which has been changed due to Client activity, since the migration started. |`LiveDataMigratedInBytes` |Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**Migrator CPU Load**<br><br>CPU consumption by the migrator process. |`MigratorCPULoad` |Percent |Average |\<none\>|PT1M |Yes|
|**Number of Excluded Paths**<br><br>Provides a running count of the paths which have been excluded from the migration due to Exclusion Rules. |`NumberOfExcludedPaths` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Number of Failed Paths**<br><br>A count of which paths have failed to migrate. |`NumberOfFailedPaths` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**System CPU Load**<br><br>Total CPU consumption. |`SystemCPULoad` |Percent |Average |\<none\>|PT1M |Yes|
|**Total Migrated Data in Bytes**<br><br>This provides a view of the successfully migrated Bytes for a given migrator |`TotalMigratedDataInBytes` |Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**Total Transactions**<br><br>This provides a running total of the Data Transactions for which the user could be billed. |`TotalTransactions` |Count |Total (Sum) |\<none\>|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
