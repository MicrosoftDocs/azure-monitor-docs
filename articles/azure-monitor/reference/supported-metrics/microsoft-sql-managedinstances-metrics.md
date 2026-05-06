---
title: Supported metrics - Microsoft.Sql/managedInstances
description: Reference for Microsoft.Sql/managedInstances metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Sql/managedInstances, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Sql/managedInstances

The following table lists the metrics available for the Microsoft.Sql/managedInstances resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.Sql/managedInstances](../supported-logs/microsoft-sql-managedinstances-logs.md)


|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Average CPU percentage**<br><br>Average CPU percentage |`avg_cpu_percent` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**IO bytes read**<br><br>IO bytes read |`io_bytes_read` |Bytes |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**IO bytes written**<br><br>IO bytes written |`io_bytes_written` |Bytes |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**IO requests count**<br><br>IO requests count |`io_requests` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Storage space reserved**<br><br>Storage space reserved |`reserved_storage_mb` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Storage space used**<br><br>Storage space used |`storage_space_used_mb` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Virtual core count**<br><br>Virtual core count |`virtual_core_count` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
