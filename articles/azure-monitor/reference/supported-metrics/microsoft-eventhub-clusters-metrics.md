---
title: Supported metrics - Microsoft.EventHub/clusters
description: Reference for Microsoft.EventHub/clusters metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.EventHub/clusters, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.EventHub/clusters

The following table lists the metrics available for the Microsoft.EventHub/clusters resource type.

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
|**ActiveConnections**<br><br>Total Active Connections for Microsoft.EventHub. |`ActiveConnections` |Count |Average |\<none\>|PT1M |No|
|**Available Memory**<br><br>Available memory for the Event Hub Cluster as a percentage of total memory. |`AvailableMemory` |Percent |Maximum |`Role`|PT1M |No|
|**Capture Backlog.**<br><br>Capture Backlog for Microsoft.EventHub. |`CaptureBacklog` |Count |Total (Sum) |\<none\>|PT1M |No|
|**Captured Bytes.**<br><br>Captured Bytes for Microsoft.EventHub. |`CapturedBytes` |Bytes |Total (Sum) |\<none\>|PT1M |No|
|**Captured Messages.**<br><br>Captured Messages for Microsoft.EventHub. |`CapturedMessages` |Count |Total (Sum) |\<none\>|PT1M |No|
|**Cluster Utilization (preview)**<br><br>Aggregated utilization percentage across all resources of which your cluster comprises. |`ClusterUtilization` |Percent |Average |\<none\>|PT1M |No|
|**Connections Closed.**<br><br>Connections Closed for Microsoft.EventHub. |`ConnectionsClosed` |Count |Average |\<none\>|PT1M |No|
|**Connections Opened.**<br><br>Connections Opened for Microsoft.EventHub. |`ConnectionsOpened` |Count |Average |\<none\>|PT1M |No|
|**CPU**<br><br>CPU utilization for the Event Hub Cluster as a percentage |`CPU` |Percent |Maximum |`Role`|PT1M |No|
|**Incoming Bytes.**<br><br>Incoming Bytes for Microsoft.EventHub. |`IncomingBytes` |Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**Incoming Messages**<br><br>Incoming Messages for Microsoft.EventHub. |`IncomingMessages` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Incoming Requests**<br><br>Incoming Requests for Microsoft.EventHub. |`IncomingRequests` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Outgoing Bytes.**<br><br>Outgoing Bytes for Microsoft.EventHub. |`OutgoingBytes` |Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**Outgoing Messages**<br><br>Outgoing Messages for Microsoft.EventHub. |`OutgoingMessages` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Quota Exceeded Errors.**<br><br>Quota Exceeded Errors for Microsoft.EventHub. |`QuotaExceededErrors` |Count |Total (Sum) |`OperationResult`|PT1M |No|
|**Server Errors.**<br><br>Server Errors for Microsoft.EventHub. |`ServerErrors` |Count |Total (Sum) |`OperationResult`|PT1M |No|
|**Size**<br><br>Size of an EventHub in Bytes. |`Size` |Bytes |Average, Minimum, Maximum |`Role`|PT1M |No|
|**Successful Requests**<br><br>Successful Requests for Microsoft.EventHub. |`SuccessfulRequests` |Count |Total (Sum) |`OperationResult`|PT1M |No|
|**Throttled Requests.**<br><br>Throttled Requests for Microsoft.EventHub. |`ThrottledRequests` |Count |Total (Sum) |`OperationResult`|PT1M |No|
|**User Errors.**<br><br>User Errors for Microsoft.EventHub. |`UserErrors` |Count |Total (Sum) |`OperationResult`|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
