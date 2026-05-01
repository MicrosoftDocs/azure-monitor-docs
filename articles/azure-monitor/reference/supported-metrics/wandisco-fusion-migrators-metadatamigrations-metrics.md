---
title: Supported metrics - Wandisco.Fusion/migrators/metadataMigrations
description: Reference for Wandisco.Fusion/migrators/metadataMigrations metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Wandisco.Fusion/migrators/metadataMigrations, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Wandisco.Fusion/migrators/metadataMigrations

The following table lists the metrics available for the Wandisco.Fusion/migrators/metadataMigrations resource type.

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
|**Hive Items Added After Scan**<br><br>Provides a running total of how many items have been added after the initial scan. |`LiveHiveAddedAfterScan` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Discovered Hive Items**<br><br>Provides a running total of how many items have been discovered. |`LiveHiveDiscoveredItems` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Initially Discovered Hive Items**<br><br>This provides the view of the total items discovered as a result of the initial scan of the On-Premises file system. Any items that are discovered after the initial scan, are NOT included in this metric. |`LiveHiveInitiallyDiscoveredItems` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Initially Migrated Hive Items**<br><br>This provides the view of the total items migrated as a result of the initial scan of the On-Premises file system. Any items that are added after the initial scan, are NOT included in this metric. |`LiveHiveInitiallyMigratedItems` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Migrated Hive Items**<br><br>Provides a running total of how many items have been migrated. |`LiveHiveMigratedItems` |Count |Total (Sum) |\<none\>|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
