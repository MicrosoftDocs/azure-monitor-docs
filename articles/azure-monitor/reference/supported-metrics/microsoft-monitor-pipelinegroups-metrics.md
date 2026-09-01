---
title: Supported metrics - Microsoft.Monitor/pipelineGroups
description: Reference for Microsoft.Monitor/pipelineGroups metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 08/21/2026
ms.custom: Microsoft.Monitor/pipelineGroups, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Monitor/pipelineGroups

The following table lists the metrics available for the Microsoft.Monitor/pipelineGroups resource type.

**Table headings**

- **Metric** - The metric display name as it appears in the Azure portal.
- **Name in Rest API** - Metric name as referred to in the [REST API](/azure/azure-monitor/essentials/rest-api-walkthrough).
- **Advanced platform metrics** - A premium, [paid tier of platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform) in Azure Monitor that provide more granular observability for Azure resources.
- **Unit** - Unit of measure.
- **Aggregation** - The default [aggregation](/azure/azure-monitor/essentials/metrics-aggregation-explained) type. Valid values: Average, Minimum, Maximum, Total, Count.
- **Dimensions** - [Dimensions](/azure/azure-monitor/essentials/metrics-aggregation-explained#dimensions-splitting-and-filtering) available for the metric.
- **Time Grains** - [Intervals at which the metric is sampled](/azure/azure-monitor/essentials/metrics-aggregation-explained#granularity). For example, `PT1M` indicates that the metric is sampled every minute, `PT30M` every 30 minutes, `PT1H` every hour, and so on.
- **DS Export** - Shows whether the metric is exportable to Azure Monitor Logs via Diagnostic Settings.

For information on exporting metrics, see - [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics) and [Create diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/create-diagnostic-settings?tabs=portal).

For information on metric retention, see [Azure Monitor Metrics overview](/azure/azure-monitor/essentials/data-platform-metrics#retention-of-metrics).


For a list of supported logs, see [Supported log categories - Microsoft.Monitor/pipelineGroups](../supported-logs/microsoft-monitor-pipelinegroups-logs.md)


### Category: Export
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Logs exported(preview)**<br><br>Number of log records successfully sent to the destination. |`exported_log_records` | No | Count |Total (Sum) |`signal`, `outcome`, `instanceId`, `pipelineName`, `componentName`|PT1M |No|
|**Logs failed to export(preview)**<br><br>The number of log records the pipeline could not deliver after exhausting its own retries, if any. The same logs may be counted more than once if resubmitted by an upstream retry or buffering mechanism. A non-zero value indicates export issues but not necessarily data loss, as the pipeline may still retry successfully. |`log_records_failed_to_export` | No | Count |Total (Sum) |`signal`, `outcome`, `instanceId`, `pipelineName`, `componentName`|PT1M |No|
|**Logs currently pending export(preview)**<br><br>Current number of log records queued or in flight for export. |`log_records_pending_export` | No | Count |Total (Sum), Minimum, Maximum |`instanceId`, `pipelineName`, `componentName`|PT1M |No|

### Category: Ingestion
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Logs accepted(preview)**<br><br>Number of log records accepted into the pipeline. |`accepted_log_records` | No | Count |Total (Sum) |`signal`, `instanceId`, `componentName`|PT1M |No|
|**Logs rejected(preview)**<br><br>Number of log records rejected by validation while entering the pipeline. |`rejected_log_records` | No | Count |Total (Sum) |`signal`, `instanceId`, `componentName`|PT1M |No|

### Category: Persistent storage
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Logs dropped from persistent storage(preview)**<br><br>Number of log records dropped from persistent storage. |`log_records_dropped_from_storage` | No | Count |Total (Sum) |`signal`, `reason`, `instanceId`, `pipelineName`, `componentName`|PT1M |No|
|**Persistent storage utilization(preview)**<br><br>Percentage of configured persistent storage currently in use. |`persistent_storage_utilization` | No | Percent |Average, Minimum, Maximum |`instanceId`, `pipelineName`, `componentName`|PT1M |No|

### Category: Processing
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Logs processing duration(preview)**<br><br>Time spent processing log records in the configured processor. |`processing_duration` | No | Milliseconds |Average, Minimum, Maximum |`signal`, `instanceId`, `pipelineName`, `componentName`|PT1M |No|
|**Logs entering processor(preview)**<br><br>Number of log records entering the configured processor. |`processor_input_log_records` | No | Count |Total (Sum) |`signal`, `instanceId`, `pipelineName`, `componentName`|PT1M |No|
|**Logs leaving processor(preview)**<br><br>Number of log records leaving the configured processor. |`processor_output_log_records` | No | Count |Total (Sum) |`signal`, `instanceId`, `pipelineName`, `componentName`|PT1M |No|

### Category: Runtime
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**CPU utilization**<br><br>The percentage of CPU utilized by the pipeline group process, normalized across all cores. |`process_cpu_utilization` | No | Percent |Average, Minimum, Maximum |`instanceId`|PT1M |Yes|
|**Memory used**<br><br>Total physical memory (resident set size) used by the pipeline group process. |`process_memory_usage` | No | Bytes |Average, Minimum, Maximum |`instanceId`|PT1M |Yes|
|**Process uptime**<br><br>Uptime of the pipeline group process since last start. |`process_uptime` | No | Seconds |Maximum |`instanceId`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
