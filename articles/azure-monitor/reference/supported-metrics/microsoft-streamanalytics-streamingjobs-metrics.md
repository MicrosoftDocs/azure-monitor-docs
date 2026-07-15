---
title: Supported metrics - Microsoft.StreamAnalytics/streamingjobs
description: Reference for Microsoft.StreamAnalytics/streamingjobs metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: Microsoft.StreamAnalytics/streamingjobs, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.StreamAnalytics/streamingjobs

The following table lists the metrics available for the Microsoft.StreamAnalytics/streamingjobs resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.StreamAnalytics/streamingjobs](../supported-logs/microsoft-streamanalytics-streamingjobs-logs.md)


|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Failed Function Requests**<br><br>Failed Function Requests |`AMLCalloutFailedRequests` | No | Count |Total (Sum) |`LogicalName`, `PartitionId`, `ProcessorInstance`, `NodeName`|PT1M |Yes|
|**Function Events**<br><br>Function Events |`AMLCalloutInputEvents` | No | Count |Total (Sum) |`LogicalName`, `PartitionId`, `ProcessorInstance`, `NodeName`|PT1M |Yes|
|**Function Requests**<br><br>Function Requests |`AMLCalloutRequests` | No | Count |Total (Sum) |`LogicalName`, `PartitionId`, `ProcessorInstance`, `NodeName`|PT1M |Yes|
|**Data Conversion Errors**<br><br>Data Conversion Errors |`ConversionErrors` | No | Count |Total (Sum) |`LogicalName`, `PartitionId`, `ProcessorInstance`, `NodeName`|PT1M |Yes|
|**Input Deserialization Errors**<br><br>Input Deserialization Errors |`DeserializationError` | No | Count |Total (Sum) |`LogicalName`, `PartitionId`, `ProcessorInstance`, `NodeName`|PT1M |Yes|
|**Out of order Events**<br><br>Out of order Events |`DroppedOrAdjustedEvents` | No | Count |Total (Sum) |`LogicalName`, `PartitionId`, `ProcessorInstance`, `NodeName`|PT1M |Yes|
|**Early Input Events**<br><br>Early Input Events |`EarlyInputEvents` | No | Count |Total (Sum) |`LogicalName`, `PartitionId`, `ProcessorInstance`, `NodeName`|PT1M |Yes|
|**Runtime Errors**<br><br>Runtime Errors |`Errors` | No | Count |Total (Sum) |`LogicalName`, `PartitionId`, `ProcessorInstance`, `NodeName`|PT1M |Yes|
|**Input Event Bytes**<br><br>Input Event Bytes |`InputEventBytes` | No | Bytes |Total (Sum) |`LogicalName`, `PartitionId`, `ProcessorInstance`, `NodeName`|PT1M |Yes|
|**Input Events**<br><br>Input Events |`InputEvents` | No | Count |Total (Sum) |`LogicalName`, `PartitionId`, `ProcessorInstance`, `NodeName`|PT1M |Yes|
|**Backlogged Input Events**<br><br>Backlogged Input Events |`InputEventsSourcesBacklogged` | No | Count |Average, Maximum, Minimum |`LogicalName`, `PartitionId`, `ProcessorInstance`, `NodeName`|PT1M |Yes|
|**Input Sources Received**<br><br>Input Sources Received |`InputEventsSourcesPerSecond` | No | Count |Total (Sum) |`LogicalName`, `PartitionId`, `ProcessorInstance`, `NodeName`|PT1M |Yes|
|**Late Input Events**<br><br>Late Input Events |`LateInputEvents` | No | Count |Total (Sum) |`LogicalName`, `PartitionId`, `ProcessorInstance`, `NodeName`|PT1M |Yes|
|**Output Events**<br><br>Output Events |`OutputEvents` | No | Count |Total (Sum) |`LogicalName`, `PartitionId`, `ProcessorInstance`, `NodeName`|PT1M |Yes|
|**Watermark Delay**<br><br>Watermark Delay |`OutputWatermarkDelaySeconds` | No | Seconds |Average, Maximum, Minimum |`LogicalName`, `PartitionId`, `ProcessorInstance`, `NodeName`|PT1M |Yes|
|**CPU % Utilization**<br><br>CPU % Utilization |`ProcessCPUUsagePercentage` | No | Percent |Average, Maximum, Minimum |`LogicalName`, `PartitionId`, `ProcessorInstance`, `NodeName`|PT1M |Yes|
|**SU (Memory) % Utilization**<br><br>SU (Memory) % Utilization |`ResourceUtilization` | No | Percent |Average, Maximum, Minimum |`LogicalName`, `PartitionId`, `ProcessorInstance`, `NodeName`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
