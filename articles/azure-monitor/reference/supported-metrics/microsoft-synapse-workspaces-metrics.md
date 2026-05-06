---
title: Supported metrics - Microsoft.Synapse/workspaces
description: Reference for Microsoft.Synapse/workspaces metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Synapse/workspaces, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Synapse/workspaces

The following table lists the metrics available for the Microsoft.Synapse/workspaces resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.Synapse/workspaces](../supported-logs/microsoft-synapse-workspaces-logs.md)


### Category: Built-in SQL Pool
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Data processed (bytes)**<br><br>Amount of data processed by queries |`BuiltinSqlPoolDataProcessedBytes` |Bytes |Total (Sum) |\<none\>|PT1M |No|
|**Login attempts**<br><br>Count of login attempts that succeded or failed |`BuiltinSqlPoolLoginAttempts` |Count |Average, Minimum, Maximum, Total (Sum) |`Result`|PT1M |No|
|**Requests ended**<br><br>Count of Requests that succeeded, failed, or were cancelled |`BuiltinSqlPoolRequestsEnded` |Count |Average, Minimum, Maximum, Total (Sum) |`Result`|PT1M |No|

### Category: Integration
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Activity runs ended**<br><br>Count of integration activities that succeeded, failed, or were cancelled |`IntegrationActivityRunsEnded` |Count |Count, Total (Sum) |`Result`, `FailureType`, `Activity`, `ActivityType`, `Pipeline`|PT1M, PT1H |No|
|**Link connection events**<br><br>Number of Synapse Link connection events including start, stop and failure. |`IntegrationLinkConnectionEvents` |Count |Total (Sum) |`EventType`, `LinkConnectionName`|PT1M |No|
|**Link processed rows**<br><br>Changed row count processed by Synapse Link. |`IntegrationLinkProcessedChangedRows` |Count |Total (Sum) |`TableName`, `LinkConnectionName`|PT1M |No|
|**Link processed data volume (bytes)**<br><br>Data volume in bytes processed by Synapse Link. |`IntegrationLinkProcessedDataVolume` |Bytes |Total (Sum) |`TableName`, `LinkTableStatus`, `LinkConnectionName`|PT1M |No|
|**Link latency in seconds**<br><br>Synapse Link data processing latency in seconds. |`IntegrationLinkProcessingLatencyInSeconds` |Count |Maximum, Minimum, Average |`LinkConnectionName`|PT1M |No|
|**Link table events**<br><br>Number of Synapse Link table events including snapshot, removal and failure. |`IntegrationLinkTableEvents` |Count |Total (Sum) |`TableName`, `EventType`, `LinkConnectionName`|PT1M |No|
|**Pipeline runs ended**<br><br>Count of integration pipeline runs that succeeded, failed, or were cancelled |`IntegrationPipelineRunsEnded` |Count |Count, Total (Sum) |`Result`, `FailureType`, `Pipeline`|PT1M, PT1H |No|
|**Trigger Runs ended**<br><br>Count of integration triggers that succeeded, failed, or were cancelled |`IntegrationTriggerRunsEnded` |Count |Count, Total (Sum) |`Result`, `FailureType`, `Trigger`|PT1M, PT1H |No|

### Category: Streaming job
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Backlogged input events (preview)**<br><br>This is a preview metric available in East US, West Europe. Number of input events sources backlogged. |`SQLStreamingBackloggedInputEventSources` |Count |Total (Sum) |`SQLPoolName`, `SQLDatabaseName`, `JobName`, `LogicalName`, `PartitionId`, `ProcessorInstance`|PT1M |No|
|**Data conversion errors (preview)**<br><br>This is a preview metric available in East US, West Europe. Number of output events that could not be converted to the expected output schema. Error policy can be changed to 'Drop' to drop events that encounter this scenario. |`SQLStreamingConversionErrors` |Count |Total (Sum) |`SQLPoolName`, `SQLDatabaseName`, `JobName`, `LogicalName`, `PartitionId`, `ProcessorInstance`|PT1M |No|
|**Input deserialization errors (preview)**<br><br>This is a preview metric available in East US, West Europe. Number of input events that could not be deserialized. |`SQLStreamingDeserializationError` |Count |Total (Sum) |`SQLPoolName`, `SQLDatabaseName`, `JobName`, `LogicalName`, `PartitionId`, `ProcessorInstance`|PT1M |No|
|**Early input events (preview)**<br><br>This is a preview metric available in East US, West Europe. Number of input events which application time is considered early compared to arrival time, according to early arrival policy. |`SQLStreamingEarlyInputEvents` |Count |Total (Sum) |`SQLPoolName`, `SQLDatabaseName`, `JobName`, `LogicalName`, `PartitionId`, `ProcessorInstance`|PT1M |No|
|**Input event bytes (preview)**<br><br>This is a preview metric available in East US, West Europe. Amount of data received by the streaming job, in bytes. This can be used to validate that events are being sent to the input source. |`SQLStreamingInputEventBytes` |Count |Total (Sum) |`SQLPoolName`, `SQLDatabaseName`, `JobName`, `LogicalName`, `PartitionId`, `ProcessorInstance`|PT1M |No|
|**Input events (preview)**<br><br>This is a preview metric available in East US, West Europe. Number of input events. |`SQLStreamingInputEvents` |Count |Total (Sum) |`SQLPoolName`, `SQLDatabaseName`, `JobName`, `LogicalName`, `PartitionId`, `ProcessorInstance`|PT1M |No|
|**Input sources received (preview)**<br><br>This is a preview metric available in East US, West Europe. Number of input events sources per second. |`SQLStreamingInputEventsSourcesPerSecond` |Count |Total (Sum) |`SQLPoolName`, `SQLDatabaseName`, `JobName`, `LogicalName`, `PartitionId`, `ProcessorInstance`|PT1M |No|
|**Late input events (preview)**<br><br>This is a preview metric available in East US, West Europe. Number of input events which application time is considered late compared to arrival time, according to late arrival policy. |`SQLStreamingLateInputEvents` |Count |Total (Sum) |`SQLPoolName`, `SQLDatabaseName`, `JobName`, `LogicalName`, `PartitionId`, `ProcessorInstance`|PT1M |No|
|**Out of order events (preview)**<br><br>This is a preview metric available in East US, West Europe. Number of Event Hub Events (serialized messages) received by the Event Hub Input Adapter, received out of order that were either dropped or given an adjusted timestamp, based on the Event Ordering Policy. |`SQLStreamingOutOfOrderEvents` |Count |Total (Sum) |`SQLPoolName`, `SQLDatabaseName`, `JobName`, `LogicalName`, `PartitionId`, `ProcessorInstance`|PT1M |No|
|**Output events (preview)**<br><br>This is a preview metric available in East US, West Europe. Number of output events. |`SQLStreamingOutputEvents` |Count |Total (Sum) |`SQLPoolName`, `SQLDatabaseName`, `JobName`, `LogicalName`, `PartitionId`, `ProcessorInstance`|PT1M |No|
|**Watermark delay (preview)**<br><br>This is a preview metric available in East US, West Europe. Output watermark delay in seconds. |`SQLStreamingOutputWatermarkDelaySeconds` |Count |Maximum, Minimum, Average |`SQLPoolName`, `SQLDatabaseName`, `JobName`, `LogicalName`, `PartitionId`, `ProcessorInstance`|PT1M |No|
|**Resource % utilization (preview)**<br><br>This is a preview metric available in East US, West Europe.<br> Resource utilization expressed as a percentage. High utilization indicates that the job is using close to the maximum allocated resources. |`SQLStreamingResourceUtilization` |Percent |Maximum, Minimum, Average |`SQLPoolName`, `SQLDatabaseName`, `JobName`, `LogicalName`, `PartitionId`, `ProcessorInstance`|PT1M |No|
|**Runtime errors (preview)**<br><br>This is a preview metric available in East US, West Europe. Total number of errors related to query processing (excluding errors found while ingesting events or outputting results). |`SQLStreamingRuntimeErrors` |Count |Total (Sum) |`SQLPoolName`, `SQLDatabaseName`, `JobName`, `LogicalName`, `PartitionId`, `ProcessorInstance`|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
