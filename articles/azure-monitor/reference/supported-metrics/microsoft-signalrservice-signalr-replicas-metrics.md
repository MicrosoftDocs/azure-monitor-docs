---
title: Supported metrics - Microsoft.SignalRService/SignalR/replicas
description: Reference for Microsoft.SignalRService/SignalR/replicas metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: Microsoft.SignalRService/SignalR/replicas, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.SignalRService/SignalR/replicas

The following table lists the metrics available for the Microsoft.SignalRService/SignalR/replicas resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.SignalRService/SignalR/replicas](../supported-logs/microsoft-signalrservice-signalr-replicas-logs.md)


### Category: Errors
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**System Errors**<br><br>The percentage of system errors |`SystemErrors` | No | Percent |Maximum |\<none\>|PT1M |Yes|
|**User Errors**<br><br>The percentage of user errors |`UserErrors` | No | Percent |Maximum |\<none\>|PT1M |Yes|

### Category: Saturation
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Server Load**<br><br>SignalR server load. |`ServerLoad` | No | Percent |Minimum, Maximum, Average |\<none\>|PT1M |No|

### Category: Traffic
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Connection Close Count**<br><br>The count of connections closed by various reasons. |`ConnectionCloseCount` | No | Count |Total (Sum) |`Endpoint`, `ConnectionCloseCategory`|PT1M |Yes|
|**Connection Count**<br><br>The amount of user connection. |`ConnectionCount` | No | Count |Maximum |`Endpoint`|PT1M |Yes|
|**Connection Open Count**<br><br>The count of new connections opened. |`ConnectionOpenCount` | No | Count |Total (Sum) |`Endpoint`|PT1M |Yes|
|**Connection Quota Utilization**<br><br>The percentage of connection connected relative to connection quota. |`ConnectionQuotaUtilization` | No | Percent |Minimum, Maximum, Average |\<none\>|PT1M |Yes|
|**Inbound Traffic**<br><br>The inbound traffic of service |`InboundTraffic` | No | Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**Message Count**<br><br>The total amount of messages. |`MessageCount` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Outbound Traffic**<br><br>The outbound traffic of service |`OutboundTraffic` | No | Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**Server Connection Latency**<br><br>The latency of server connection in milliseconds |`ServerConnectionLatency` | No | Milliseconds |Minimum, Maximum, Average |\<none\>|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
