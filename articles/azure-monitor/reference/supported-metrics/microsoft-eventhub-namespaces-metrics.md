---
title: Supported metrics - Microsoft.EventHub/Namespaces
description: Reference for Microsoft.EventHub/Namespaces metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: Microsoft.EventHub/Namespaces, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.EventHub/Namespaces

The following table lists the metrics available for the Microsoft.EventHub/Namespaces resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.EventHub/Namespaces](../supported-logs/microsoft-eventhub-namespaces-logs.md)


|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**ActiveConnections**<br><br>Total Active Connections for Microsoft.EventHub. |`ActiveConnections` | No | Count |Maximum, Minimum, Average |\<none\>|PT1M |No|
|**Capture Backlog.**<br><br>Backlog of bytes to be captured for Microsoft.EventHub. |`CaptureBacklog` | No | Count |Total (Sum) |`EntityName`|PT1M |No|
|**Captured Bytes.**<br><br>Captured Bytes for Microsoft.EventHub. |`CapturedBytes` | No | Bytes |Total (Sum) |`EntityName`|PT1M |No|
|**Captured Messages.**<br><br>Captured Messages for Microsoft.EventHub. |`CapturedMessages` | No | Count |Total (Sum) |`EntityName`|PT1M |No|
|**Connections Closed.**<br><br>Connections Closed for Microsoft.EventHub. |`ConnectionsClosed` | No | Count |Maximum |`EntityName`|PT1M |No|
|**Connections Opened.**<br><br>Connections Opened for Microsoft.EventHub. |`ConnectionsOpened` | No | Count |Maximum |`EntityName`|PT1M |No|
|**Archive backlog messages (Deprecated)**<br><br>Event Hub archive messages in backlog for a namespace (Deprecated) |`EHABL` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Archive message throughput (Deprecated)**<br><br>Event Hub archived message throughput in a namespace (Deprecated) |`EHAMBS` | No | Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**Archive messages (Deprecated)**<br><br>Event Hub archived messages in a namespace (Deprecated) |`EHAMSGS` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Incoming bytes (Deprecated)**<br><br>Event Hub incoming message throughput for a namespace (Deprecated) |`EHINBYTES` | No | Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**Incoming bytes (obsolete) (Deprecated)**<br><br>Event Hub incoming message throughput for a namespace. This metric is deprecated. Please use Incoming bytes metric instead (Deprecated) |`EHINMBS` | No | Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**Incoming Messages (Deprecated)**<br><br>Total incoming messages for a namespace (Deprecated) |`EHINMSGS` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Outgoing bytes (Deprecated)**<br><br>Event Hub outgoing message throughput for a namespace (Deprecated) |`EHOUTBYTES` | No | Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**Outgoing bytes (obsolete) (Deprecated)**<br><br>Event Hub outgoing message throughput for a namespace. This metric is deprecated. Please use Outgoing bytes metric instead (Deprecated) |`EHOUTMBS` | No | Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**Outgoing Messages (Deprecated)**<br><br>Total outgoing messages for a namespace (Deprecated) |`EHOUTMSGS` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Failed Requests (Deprecated)**<br><br>Total failed requests for a namespace (Deprecated) |`FAILREQ` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Incoming Bytes.**<br><br>Incoming Bytes for Microsoft.EventHub. |`IncomingBytes` | No | Bytes |Total (Sum) |`EntityName`|PT1M |Yes|
|**Incoming Messages**<br><br>Incoming Messages for Microsoft.EventHub. |`IncomingMessages` | No | Count |Total (Sum) |`EntityName`|PT1M |Yes|
|**Incoming Requests**<br><br>Incoming Requests for Microsoft.EventHub. |`IncomingRequests` | No | Count |Total (Sum) |`EntityName`|PT1M |Yes|
|**Incoming Messages (obsolete) (Deprecated)**<br><br>Total incoming messages for a namespace. This metric is deprecated. Please use Incoming Messages metric instead (Deprecated) |`INMSGS` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Incoming Requests (Deprecated)**<br><br>Total incoming send requests for a namespace (Deprecated) |`INREQS` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Internal Server Errors (Deprecated)**<br><br>Total internal server errors for a namespace (Deprecated) |`INTERR` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Other Errors (Deprecated)**<br><br>Total failed requests for a namespace (Deprecated) |`MISCERR` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**CPU**<br><br>CPU usage metric for Premium SKU namespaces. |`NamespaceCpuUsage` | No | Percent |Maximum, Minimum, Average |`Replica`|PT1M |No|
|**Memory Usage**<br><br>Memory usage metric for Premium SKU namespaces. |`NamespaceMemoryUsage` | No | Percent |Maximum, Minimum, Average |`Replica`|PT1M |No|
|**Outgoing Bytes.**<br><br>Outgoing Bytes for Microsoft.EventHub. |`OutgoingBytes` | No | Bytes |Total (Sum) |`EntityName`|PT1M |Yes|
|**Outgoing Messages**<br><br>Outgoing Messages for Microsoft.EventHub. |`OutgoingMessages` | No | Count |Total (Sum) |`EntityName`|PT1M |Yes|
|**Outgoing Messages (obsolete) (Deprecated)**<br><br>Total outgoing messages for a namespace. This metric is deprecated. Please use Outgoing Messages metric instead (Deprecated) |`OUTMSGS` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Quota Exceeded Errors.**<br><br>Quota Exceeded Errors for Microsoft.EventHub. |`QuotaExceededErrors` | No | Count |Total (Sum) |`EntityName`, `OperationResult`|PT1M |No|
|**ReplicationLagCount**<br><br>Replication lag by message count |`ReplicationLagCount` | No | Count |Maximum, Minimum, Average |`EntityName`|PT1M |No|
|**ReplicationLagDuration**<br><br>Replication lag by time duration |`ReplicationLagDuration` | No | Seconds |Maximum, Minimum, Average |`EntityName`|PT1M |Yes|
|**Server Errors.**<br><br>Server Errors for Microsoft.EventHub. |`ServerErrors` | No | Count |Total (Sum) |`EntityName`, `OperationResult`|PT1M |No|
|**Size**<br><br>Size of an EventHub in Bytes. |`Size` | No | Bytes |Average, Minimum, Maximum |`EntityName`|PT1M |No|
|**Successful Requests**<br><br>Successful Requests for Microsoft.EventHub. |`SuccessfulRequests` | No | Count |Total (Sum) |`EntityName`, `OperationResult`|PT1M |No|
|**Successful Requests (Deprecated)**<br><br>Total successful requests for a namespace (Deprecated) |`SUCCREQ` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Server Busy Errors (Deprecated)**<br><br>Total server busy errors for a namespace (Deprecated) |`SVRBSY` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Throttled Requests.**<br><br>Throttled Requests for Microsoft.EventHub. |`ThrottledRequests` | No | Count |Total (Sum) |`EntityName`, `OperationResult`|PT1M |No|
|**User Errors.**<br><br>User Errors for Microsoft.EventHub. |`UserErrors` | No | Count |Total (Sum) |`EntityName`, `OperationResult`|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
