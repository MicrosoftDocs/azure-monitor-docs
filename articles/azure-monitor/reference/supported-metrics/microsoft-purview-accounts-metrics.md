---
title: Supported metrics - microsoft.purview/accounts
description: Reference for microsoft.purview/accounts metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: microsoft.purview/accounts, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for microsoft.purview/accounts

The following table lists the metrics available for the microsoft.purview/accounts resource type.

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


For a list of supported logs, see [Supported log categories - microsoft.purview/accounts](../supported-logs/microsoft-purview-accounts-logs.md)


|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Data Map Capacity Units**<br><br>Indicates Data Map Capacity Units. |`DataMapCapacityUnits` | No | Count |Total (Sum), Count |\<none\>|PT1H, P1D |Yes|
|**Data Map Storage Size**<br><br>Indicates the data map storage size. |`DataMapStorageSize` | No | Bytes |Total (Sum), Average |\<none\>|PT1H, P1D |Yes|
|**Scan Cancelled**<br><br>Indicates the number of scans cancelled. |`ScanCancelled` | No | Count |Total (Sum), Count |\<none\>|PT1M, PT15M, PT1H, P1D |Yes|
|**Scan Completed**<br><br>Indicates the number of scans completed successfully. |`ScanCompleted` | No | Count |Total (Sum), Count |\<none\>|PT1M, PT15M, PT1H, P1D |Yes|
|**Scan Failed**<br><br>Indicates the number of scans failed. |`ScanFailed` | No | Count |Total (Sum), Count |\<none\>|PT1M, PT15M, PT1H, P1D |Yes|
|**Scan time taken**<br><br>Indicates the total scan time in seconds. |`ScanTimeTaken` | No | Seconds |Minimum, Maximum, Total (Sum), Average |\<none\>|PT1M, PT15M, PT1H, P1D |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
