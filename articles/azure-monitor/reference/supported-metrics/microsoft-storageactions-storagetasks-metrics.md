---
title: Supported metrics - Microsoft.StorageActions/storageTasks
description: Reference for Microsoft.StorageActions/storageTasks metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: Microsoft.StorageActions/storageTasks, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.StorageActions/storageTasks

The following table lists the metrics available for the Microsoft.StorageActions/storageTasks resource type.

**Table headings**

- **Metric** - The metric display name as it appears in the Azure portal.
- **Name in Rest API** - Metric name as referred to in the [REST API](/azure/azure-monitor/essentials/rest-api-walkthrough).
- **Advanced platform metrics** - A premium, [paid tier of platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform) in Azure Monitor that provide more granular observability for Azure resources.
- **Unit** - Unit of measure.
- **Aggregation** - The default [aggregation](/azure/azure-monitor/essentials/metrics-aggregation-explained) type. Valid values: Average, Minimum, Maximum, Total, Count.
- **Dimensions** - [Dimensions](/azure/azure-monitor/essentials/metrics-aggregation-explained#dimensions-splitting-and-filtering) available for the metric.
- **Time Grains** - [Intervals at which the metric is sampled](/azure/azure-monitor/essentials/metrics-aggregation-explained#granularity). For example, `PT1M` indicates that the metric is sampled every minute, `PT30M` every 30 minutes, `PT1H` every hour, and so on.
- **DS Export** -S Whether the metric is exportable to Azure Monitor Logs via Diagnostic Settings.

For information on exporting metrics, see - [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics) and [Create diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/create-diagnostic-settings?tabs=portal).

For information on metric retention, see [Azure Monitor Metrics overview](/azure/azure-monitor/essentials/data-platform-metrics#retention-of-metrics).



### Category: Transaction
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Objects operated count**<br><br>The number of objects operated in storage task |`ObjectsOperatedCount` | No | Count |Total (Sum) |`AccountName`, `TaskAssignmentId`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Objects failed count**<br><br>The number of objects failed in storage task |`ObjectsOperationFailedCount` | No | Count |Total (Sum) |`AccountName`, `TaskAssignmentId`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Objects succeeded count**<br><br>The number of objects succeeded in storage task |`ObjectsOperationSucceededCount` | No | Count |Total (Sum) |`AccountName`, `TaskAssignmentId`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Objects targed count**<br><br>The number of objects targeted in storage task |`ObjectsTargetedCount` | No | Count |Total (Sum) |`AccountName`, `TaskAssignmentId`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Runs count**<br><br>The number of runs in storage task |`StorageTasksRunCount` | No | Count |Total (Sum) |`AccountName`, `TaskAssignmentId`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Runs failed count**<br><br>The number of runs failed in storage task |`StorageTasksRunFailureCount` | No | Count |Total (Sum) |`AccountName`, `TaskAssignmentId`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Runs succeeded count**<br><br>The number of runs succeeded in storage task |`StorageTasksRunSuccessCount` | No | Count |Total (Sum) |`AccountName`, `TaskAssignmentId`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Runs failed with at least one operation count**<br><br>The number of runs failed with at least one opeartion count in storage task |`StorageTasksRunWithFailedOperationCount` | No | Count |Total (Sum) |`AccountName`, `TaskAssignmentId`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
