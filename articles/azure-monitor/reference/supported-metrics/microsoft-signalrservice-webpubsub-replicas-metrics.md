---
title: Supported metrics - Microsoft.SignalRService/WebPubSub/replicas
description: Reference for Microsoft.SignalRService/WebPubSub/replicas metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.SignalRService/WebPubSub/replicas, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.SignalRService/WebPubSub/replicas

The following table lists the metrics available for the Microsoft.SignalRService/WebPubSub/replicas resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.SignalRService/WebPubSub/replicas](../supported-logs/microsoft-signalrservice-webpubsub-replicas-logs.md)


### Category: Saturation
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Server Load**<br><br>WebPubSub server load. |`ServerLoad` |Percent |Minimum, Maximum, Average |\<none\>|PT1M |No|

### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Client Request Status Code**<br><br>The status code of client connection requests. |`ClientRequestStatus` |Count |Total (Sum) |`ClientType`, `Status`|PT1M |Yes|
|**Connection Close Count**<br><br>The count of connections closed by various reasons. |`ConnectionCloseCount` |Count |Total (Sum) |`ConnectionCloseCategory`|PT1M |Yes|
|**Connection Open Count**<br><br>The count of new connections opened. |`ConnectionOpenCount` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Connection Quota Utilization**<br><br>The percentage of connection connected relative to connection quota. |`ConnectionQuotaUtilization` |Percent |Minimum, Maximum, Average |\<none\>|PT1M |Yes|
|**Inbound Traffic**<br><br>The traffic originating from outside to inside of the service. It is aggregated by adding all the bytes of the traffic. |`InboundTraffic` |Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**Outbound Traffic**<br><br>The traffic originating from inside to outside of the service. It is aggregated by adding all the bytes of the traffic. |`OutboundTraffic` |Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**Rest API Response Time**<br><br>The response time of REST API request categorized by endpoint. |`RestApiResponseTimeCount` |Count |Total (Sum) |`ResponseTime`, `RestApiCategory`|PT1M |Yes|
|**Connection Count**<br><br>The number of user connections established to the service. It is aggregated by adding all the online connections. |`TotalConnectionCount` |Count |Maximum, Average |\<none\>|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
