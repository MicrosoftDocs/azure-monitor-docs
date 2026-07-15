---
title: Supported metrics - Microsoft.Web/serverfarms
description: Reference for Microsoft.Web/serverfarms metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: Microsoft.Web/serverfarms, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Web/serverfarms

The following table lists the metrics available for the Microsoft.Web/serverfarms resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.Web/serverfarms](../supported-logs/microsoft-web-serverfarms-logs.md)


|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Data In**<br><br>The average incoming bandwidth used across all instances of the plan. |`BytesReceived` | No | Bytes |Total (Sum) |`Instance`|PT1M |Yes|
|**Data Out**<br><br>The average outgoing bandwidth used across all instances of the plan. |`BytesSent` | No | Bytes |Total (Sum) |`Instance`|PT1M |Yes|
|**CPU Percentage**<br><br>The average CPU used across all instances of the plan. |`CpuPercentage` | No | Percent |Average |`Instance`|PT1M |Yes|
|**Disk Queue Length**<br><br>The average number of both read and write requests that were queued on storage. A high disk queue length is an indication of an app that might be slowing down because of excessive disk I/O. |`DiskQueueLength` | No | Count |Average |`Instance`|PT1M |Yes|
|**Http Queue Length**<br><br>The average number of HTTP requests that had to sit on the queue before being fulfilled. A high or increasing HTTP Queue length is a symptom of a plan under heavy load. |`HttpQueueLength` | No | Count |Average |`Instance`|PT1M |Yes|
|**Memory Percentage**<br><br>The average memory used across all instances of the plan. |`MemoryPercentage` | No | Percent |Average |`Instance`|PT1M |Yes|
|**Socket Count for Inbound Requests**<br><br>The average number of sockets used for incoming HTTP requests across all the instances of the plan. |`SocketInboundAll` | No | Count |Average |`Instance`|PT1M |Yes|
|**Socket Count for Loopback Connections**<br><br>The average number of sockets used for loopback connections across all the instances of the plan. |`SocketLoopback` | No | Count |Average |`Instance`|PT1M |Yes|
|**Socket Count of Outbound Requests**<br><br>The average number of sockets used for outbound connections across all the instances of the plan irrespective of their TCP states. Having too many outbound connections can cause connectivity errors. |`SocketOutboundAll` | No | Count |Average |`Instance`|PT1M |Yes|
|**Established Socket Count for Outbound Requests**<br><br>The average number of sockets in ESTABLISHED state used for outbound connections across all the instances of the plan. |`SocketOutboundEstablished` | No | Count |Average |`Instance`|PT1M |Yes|
|**Time Wait Socket Count for Outbound Requests**<br><br>The average number of sockets in TIME_WAIT state used for outbound connections across all the instances of the plan. High or increasing outbound socket counts in TIME_WAIT state can cause connectivity errors. |`SocketOutboundTimeWait` | No | Count |Average |`Instance`|PT1M |Yes|
|**TCP Close Wait**<br><br>The average number of sockets in CLOSE_WAIT state across all the instances of the plan. |`TcpCloseWait` | No | Count |Average |`Instance`|PT1M |Yes|
|**TCP Closing**<br><br>The average number of sockets in CLOSING state across all the instances of the plan. |`TcpClosing` | No | Count |Average |`Instance`|PT1M |Yes|
|**TCP Established**<br><br>The average number of sockets in ESTABLISHED state across all the instances of the plan. |`TcpEstablished` | No | Count |Average |`Instance`|PT1M |Yes|
|**TCP Fin Wait 1**<br><br>The average number of sockets in FIN_WAIT_1 state across all the instances of the plan. |`TcpFinWait1` | No | Count |Average |`Instance`|PT1M |Yes|
|**TCP Fin Wait 2**<br><br>The average number of sockets in FIN_WAIT_2 state across all the instances of the plan. |`TcpFinWait2` | No | Count |Average |`Instance`|PT1M |Yes|
|**TCP Last Ack**<br><br>The average number of sockets in LAST_ACK state across all the instances of the plan. |`TcpLastAck` | No | Count |Average |`Instance`|PT1M |Yes|
|**TCP Syn Received**<br><br>The average number of sockets in SYN_RCVD state across all the instances of the plan. |`TcpSynReceived` | No | Count |Average |`Instance`|PT1M |Yes|
|**TCP Syn Sent**<br><br>The average number of sockets in SYN_SENT state across all the instances of the plan. |`TcpSynSent` | No | Count |Average |`Instance`|PT1M |Yes|
|**TCP Time Wait**<br><br>The average number of sockets in TIME_WAIT state across all the instances of the plan. |`TcpTimeWait` | No | Count |Average |`Instance`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
