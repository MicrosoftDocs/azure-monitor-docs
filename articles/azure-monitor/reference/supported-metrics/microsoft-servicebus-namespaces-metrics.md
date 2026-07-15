---
title: Supported metrics - Microsoft.ServiceBus/Namespaces
description: Reference for Microsoft.ServiceBus/Namespaces metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: Microsoft.ServiceBus/Namespaces, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.ServiceBus/Namespaces

The following table lists the metrics available for the Microsoft.ServiceBus/Namespaces resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.ServiceBus/Namespaces](../supported-logs/microsoft-servicebus-namespaces-logs.md)


|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Abandoned Messages**<br><br>Count of messages abandoned on a Queue/Topic. |`AbandonMessage` | No | Count |Total (Sum) |`EntityName`|PT1M |Yes|
|**ActiveConnections**<br><br>Total Active Connections for Microsoft.ServiceBus. |`ActiveConnections` | No | Count |Total (Sum) |\<none\>|PT1M |No|
|**Count of active messages in a Queue/Topic.**<br><br>Count of active messages in a Queue/Topic. |`ActiveMessages` | No | Count |Average, Minimum, Maximum |`EntityName`|PT1M |No|
|**Completed Messages**<br><br>Count of messages completed on a Queue/Topic. |`CompleteMessage` | No | Count |Total (Sum) |`EntityName`|PT1M |Yes|
|**Connections Closed.**<br><br>Connections Closed for Microsoft.ServiceBus. |`ConnectionsClosed` | No | Count |Average |`EntityName`|PT1M |No|
|**Connections Opened.**<br><br>Connections Opened for Microsoft.ServiceBus. |`ConnectionsOpened` | No | Count |Average |`EntityName`|PT1M |No|
|**CPU (Deprecated)**<br><br>Service bus premium namespace CPU usage metric. This metric is depricated. Please use the CPU metric (NamespaceCpuUsage) instead. |`CPUXNS` | No | Percent |Maximum |`Replica`|PT1M |No|
|**Count of dead-lettered messages in a Queue/Topic.**<br><br>Count of dead-lettered messages in a Queue/Topic. |`DeadletteredMessages` | No | Count |Average, Minimum, Maximum |`EntityName`|PT1M |No|
|**Incoming Bytes.**<br><br>Incoming Bytes for Microsoft.ServiceBus. |`IncomingBytes` | No | Bytes |Total (Sum) |`EntityName`|PT1M |Yes|
|**Incoming Messages**<br><br>Incoming Messages for Microsoft.ServiceBus. |`IncomingMessages` | No | Count |Total (Sum) |`EntityName`|PT1M |Yes|
|**Incoming Requests**<br><br>Incoming Requests for Microsoft.ServiceBus. |`IncomingRequests` | No | Count |Total (Sum) |`EntityName`|PT1M |Yes|
|**Count of messages in a Queue/Topic.**<br><br>Count of messages in a Queue/Topic. |`Messages` | No | Count |Average, Minimum, Maximum |`EntityName`|PT1M |No|
|**CPU**<br><br>Service bus premium namespace CPU usage metric. |`NamespaceCpuUsage` | No | Percent |Maximum |`Replica`|PT1M |No|
|**Memory Usage**<br><br>Service bus premium namespace memory usage metric. |`NamespaceMemoryUsage` | No | Percent |Maximum |`Replica`|PT1M |No|
|**Outgoing Bytes.**<br><br>Outgoing Bytes for Microsoft.ServiceBus. |`OutgoingBytes` | No | Bytes |Total (Sum) |`EntityName`|PT1M |Yes|
|**Outgoing Messages**<br><br>Outgoing Messages for Microsoft.ServiceBus. |`OutgoingMessages` | No | Count |Total (Sum) |`EntityName`|PT1M |Yes|
|**Pending Checkpoint Operations Count.**<br><br>Pending Checkpoint Operations Count. |`PendingCheckpointOperationCount` | No | Count |Total (Sum) |\<none\>|PT1M |No|
|**ReplicationLagCount**<br><br>Replication lag by message count |`ReplicationLagCount` | No | Count |Maximum, Minimum, Average |`EntityName`|PT1M |No|
|**ReplicationLagDuration**<br><br>Replication lag by time duration |`ReplicationLagDuration` | No | Seconds |Maximum, Minimum, Average |`EntityName`|PT1M |Yes|
|**Count of scheduled messages in a Queue/Topic.**<br><br>Count of scheduled messages in a Queue/Topic. |`ScheduledMessages` | No | Count |Average, Minimum, Maximum |`EntityName`|PT1M |No|
|**Server Errors.**<br><br>Server Errors for Microsoft.ServiceBus. |`ServerErrors` | No | Count |Total (Sum) |`EntityName`, `OperationResult`|PT1M |No|
|**Server Send Latency.**<br><br>Latency of Send Message operations for Service Bus resources. |`ServerSendLatency` | No | MilliSeconds |Average |`EntityName`|PT1M |Yes|
|**Size**<br><br>Size of an Queue/Topic in Bytes. |`Size` | No | Bytes |Average, Minimum, Maximum |`EntityName`|PT1M |No|
|**Successful Requests**<br><br>Total successful requests for a namespace |`SuccessfulRequests` | No | Count |Total (Sum) |`EntityName`, `OperationResult`|PT1M |No|
|**Throttled Requests.**<br><br>Throttled Requests for Microsoft.ServiceBus. |`ThrottledRequests` | No | Count |Total (Sum) |`EntityName`, `OperationResult`, `MessagingErrorSubCode`|PT1M |No|
|**User Errors.**<br><br>User Errors for Microsoft.ServiceBus. |`UserErrors` | No | Count |Total (Sum) |`EntityName`, `OperationResult`|PT1M |No|
|**Memory Usage (Deprecated)**<br><br>Service bus premium namespace memory usage metric. This metric is deprecated. Please use the Memory Usage (NamespaceMemoryUsage) metric instead. |`WSXNS` | No | Percent |Maximum |`Replica`|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
