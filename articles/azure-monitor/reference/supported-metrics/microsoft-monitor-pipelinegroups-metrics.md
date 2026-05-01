---
title: Supported metrics - Microsoft.Monitor/pipelineGroups
description: Reference for Microsoft.Monitor/pipelineGroups metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/28/2026
ms.custom: Microsoft.Monitor/pipelineGroups, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Monitor/pipelineGroups

The following table lists the metrics available for the Microsoft.Monitor/pipelineGroups resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.Monitor/pipelineGroups](../supported-logs/microsoft-monitor-pipelinegroups-logs.md)


|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Logs failed to export(preview)**<br><br>The number of log records the exporter could not deliver after exhausting its own retries, if any. The same logs may be counted more than once if resubmitted by an upstream retry or buffering mechanism. A non-zero value indicates export issues but not necessarily data loss, as the pipeline may still retry successfully. |`exporter_send_failed_log_records` |Count |Total (Sum) |`instanceId`, `pipelineName`, `componentName`|PT1M |Yes|
|**Logs exported(preview)**<br><br>Number of log records successfully sent by the exporter to the destination. |`exporter_sent_log_records` |Count |Total (Sum) |`instanceId`, `pipelineName`, `componentName`|PT1M |Yes|
|**CPU utilization(preview)**<br><br>The percentage of CPU utilized by the pipeline group process, normalized across all cores. |`process_cpu_utilization` |Percent |Average, Minimum, Maximum |`instanceId`|PT1M |Yes|
|**Memory used(preview)**<br><br>Total physical memory (resident set size) used by the pipeline group process. |`process_memory_usage` |Bytes |Average, Minimum, Maximum |`instanceId`|PT1M |Yes|
|**Process uptime(preview)**<br><br>Uptime of the pipeline group process since last start. |`process_uptime` |Seconds |Maximum |`instanceId`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
