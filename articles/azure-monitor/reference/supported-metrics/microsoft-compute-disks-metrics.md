---
title: Supported metrics - microsoft.compute/disks
description: Reference for microsoft.compute/disks metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: microsoft.compute/disks, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for microsoft.compute/disks

The following table lists the metrics available for the microsoft.compute/disks resource type.

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



### Category: Disk Performance
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Disk Read Bytes/sec**<br><br>Bytes/sec read from disk during monitoring period |`Composite Disk Read Bytes/sec` |BytesPerSecond |Average |\<none\>|PT1M |No|
|**Disk Read Operations/sec**<br><br>Number of read IOs performed on a disk during monitoring period |`Composite Disk Read Operations/sec` |CountPerSecond |Average |\<none\>|PT1M |No|
|**Disk Write Bytes/sec**<br><br>Bytes/sec written to disk during monitoring period |`Composite Disk Write Bytes/sec` |BytesPerSecond |Average |\<none\>|PT1M |No|
|**Disk Write Operations/sec**<br><br>Number of Write IOs performed on a disk during monitoring period |`Composite Disk Write Operations/sec` |CountPerSecond |Average |\<none\>|PT1M |No|
|**Disk On-demand Burst Operations**<br><br>The accumulated operations of burst transactions used for disks with on-demand burst enabled. Emitted on an hour interval |`DiskPaidBurstIOPS` |Count |Average |\<none\>|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
