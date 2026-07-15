---
title: Supported metrics - Microsoft.EventGrid/namespaces
description: Reference for Microsoft.EventGrid/namespaces metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: Microsoft.EventGrid/namespaces, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.EventGrid/namespaces

The following table lists the metrics available for the Microsoft.EventGrid/namespaces resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.EventGrid/namespaces](../supported-logs/microsoft-eventgrid-namespaces-logs.md)


|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Acknowledge Operations Latency**<br><br>The observed latency in milliseconds for acknowledge events operation. |`AcknowledgeLatencyInMilliseconds` | No | MilliSeconds |Average |`Topic`, `EventSubscriptionName`|PT1M |No|
|**Dead Lettered Events**<br><br>Total dead lettered events matching to this event subscription. |`DeadLetteredCount` | No | Count |Total (Sum) |`Topic`, `EventSubscriptionName`, `DeadLetterReason`|PT1M |No|
|**Dropped Events**<br><br>Total dropped events matching to this event subscription. |`DroppedEventCount` | No | Count |Total (Sum) |`Topic`, `EventSubscriptionName`, `DropReason`|PT1M |No|
|**Failed Acknowledged Events**<br><br>The number of events for which acknowledgments from clients failed. |`FailedAcknowledgedEvents` | No | Count |Total (Sum) |`Topic`, `EventSubscriptionName`, `Error`, `ErrorType`|PT1M |No|
|**Failed Publish Events**<br><br>The number of events that weren't accepted by Event Grid. This count excludes events that were published but failed to reach Event Grid due to a network issue, for example. |`FailedPublishedEvents` | No | Count |Total (Sum) |`Topic`, `Error`, `ErrorType`|PT1M |No|
|**Failed Received Events**<br><br>The number of events that were requested by clients but weren't delivered successfully by Event Grid. |`FailedReceivedEvents` | No | Count |Total (Sum) |`Topic`, `EventSubscriptionName`, `Error`, `ErrorType`|PT1M |No|
|**Failed Released Events**<br><br>The number of events for which release failed. |`FailedReleasedEvents` | No | Count |Total (Sum) |`Topic`, `EventSubscriptionName`, `Error`, `ErrorType`|PT1M |No|
|**Matched Events**<br><br>Total events matched to this event subscription. |`MatchedEventCount` | No | Count |Total (Sum) |`Topic`, `EventSubscriptionName`|PT1M |No|
|**MQTT: Connections**<br><br>The number of active connections in the namespace. |`Mqtt.Connections` | No | Count |Total (Sum) |`Protocol`|PT1M |Yes|
|**MQTT: Dropped Sessions**<br><br>The number of dropped sessions by the namespace. |`Mqtt.DroppedSessions` | No | Count |Total (Sum) |`DropReason`|PT1M |Yes|
|**MQTT: Expired Retained Messages**<br><br>The number of expired retained messages by the namespace. |`Mqtt.ExpiredRetainedMessages` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**MQTT: Failed Published Messages**<br><br>The number of MQTT messages that failed to be published into the namespace. |`Mqtt.FailedPublishedMessages` | No | Count |Total (Sum) |`QoS`, `Protocol`, `Error`, `Retain`|PT1M |Yes|
|**MQTT: Failed Routed Messages**<br><br>The number of failed routed messages by the namespace. |`Mqtt.FailedRoutedMessages` | No | Count |Total (Sum) |`Error`|PT1M |Yes|
|**MQTT: Failed Subscription Operations**<br><br>The number of failed subscription operations (Subscribe, Unsubscribe). This metric is incremented for every topic filter within a subscription request. |`Mqtt.FailedSubscriptionOperations` | No | Count |Total (Sum) |`Protocol`, `OperationType`, `Error`|PT1M |Yes|
|**MQTT: Failed Webhook Authentication Requests**<br><br>The number of failed authentication requests to the webhook |`Mqtt.FailedWebhookAuthenticationRequests` | No | Count |Total (Sum) |`StatusCode`, `Error`|PT1M |No|
|**MQTT: Request Count**<br><br>The number of MQTT requests. |`Mqtt.RequestCount` | No | Count |Total (Sum) |`OperationType`, `Protocol`, `Error`, `Result`|PT1M |Yes|
|**MQTT: Retained Messages Count**<br><br>The number of retained messages by the namespace. |`Mqtt.RetainedMessagesCount` | No | Count |Average |\<none\>|PT1M |Yes|
|**MQTT: Retained Messages Size**<br><br>The size of retained messages by the namespace. |`Mqtt.RetainedMessagesSize` | No | Bytes |Average |\<none\>|PT1M |Yes|
|**MQTT: Successful Connect Latency**<br><br>The observed latency in milliseconds for successful MQTT connects. |`Mqtt.SuccessfulConnectLatencyInMilliseconds` | No | MilliSeconds |Average |`Protocol`|PT1M |Yes|
|**MQTT: Successful Delivered Messages**<br><br>The number of messages delivered by the namespace. There are no failures for this operation. |`Mqtt.SuccessfulDeliveredMessages` | No | Count |Total (Sum) |`QoS`, `Protocol`, `Retain`|PT1M |Yes|
|**MQTT: Successful Published Messages**<br><br>The number of MQTT messages that were published successfully into the namespace. |`Mqtt.SuccessfulPublishedMessages` | No | Count |Total (Sum) |`QoS`, `Protocol`, `Retain`|PT1M |Yes|
|**MQTT: Successful Publish Latency**<br><br>The observed latency in milliseconds for successful MQTT publishes. |`Mqtt.SuccessfulPublishLatencyInMilliseconds` | No | MilliSeconds |Average |`QoS`, `Protocol`, `Retain`|PT1M |Yes|
|**MQTT: Successful Routed Messages**<br><br>The number of successful routed messages by the namespace. |`Mqtt.SuccessfulRoutedMessages` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**MQTT: Successful Subscription Operations**<br><br>The number of successful subscription operations (Subscribe, Unsubscribe). This metric is incremented for every topic filter within a subscription request. |`Mqtt.SuccessfulSubscriptionOperations` | No | Count |Total (Sum) |`Protocol`, `OperationType`|PT1M |Yes|
|**MQTT: Successful Webhook Authentication Requests**<br><br>The number of successful authentication requests to the webhook |`Mqtt.SuccessfulWebhookAuthenticationRequests` | No | Count |Total (Sum) |`Decision`|PT1M |No|
|**MQTT: Throttling Enforcements**<br><br>The number of times Event Grid throttled a request because it exceeded the limit. |`Mqtt.ThrottlingEnforcements` | No | Count |Total (Sum) |`ThrottleType`|PT1M |Yes|
|**MQTT: Throughput**<br><br>The number of bytes published to or delivered by the namespace. |`Mqtt.Throughput` | No | Bytes |Total (Sum) |`Direction`|PT1M |Yes|
|**Namespace Throughput Units**<br><br>The current throughput units allocated to the namespace. |`NamespaceThroughputUnits` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Publish Operations Latency**<br><br>The observed latency in milliseconds for publish events operation. |`PublishLatencyInMilliseconds` | No | MilliSeconds |Average |`Topic`|PT1M |No|
|**Receive Operations Latency**<br><br>The observed latency in milliseconds for receive events operation. |`ReceiveLatencyInMilliseconds` | No | MilliSeconds |Average |`Topic`, `EventSubscriptionName`|PT1M |No|
|**Reject Operations Latency**<br><br>The observed latency in milliseconds for reject events operation. |`RejectLatencyInMilliseconds` | No | MilliSeconds |Average |`Topic`, `EventSubscriptionName`|PT1M |No|
|**Successful Acknowledged Events**<br><br>The number of events for which delivery was successfully acknowledged by clients. |`SuccessfulAcknowledgedEvents` | No | Count |Total (Sum) |`Topic`, `EventSubscriptionName`|PT1M |No|
|**Successful Publish Events**<br><br>The number of events published successfully to a topic or topic space within a namespace. |`SuccessfulPublishedEvents` | No | Count |Total (Sum) |`Topic`|PT1M |No|
|**Successful Received Events**<br><br>The total number of events that were successfully returned to (received by) clients by Event Grid. |`SuccessfulReceivedEvents` | No | Count |Total (Sum) |`Topic`, `EventSubscriptionName`|PT1M |No|
|**Successful Released Events**<br><br>The number of events that were released successfully by queue subscriber clients. |`SuccessfulReleasedEvents` | No | Count |Total (Sum) |`Topic`, `EventSubscriptionName`|PT1M |No|
|**Unmatched Events**<br><br>Total events not matching any of the event subscriptions for this topic. |`UnmatchedEventCount` | No | Count |Total (Sum) |`Topic`|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
