---
title: Supported metrics - Microsoft.Relay/namespaces
description: Reference for Microsoft.Relay/namespaces metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Relay/namespaces, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Relay/namespaces

The following table lists the metrics available for the Microsoft.Relay/namespaces resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.Relay/namespaces](../supported-logs/microsoft-relay-namespaces-logs.md)


|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**ActiveConnections**<br><br>Total ActiveConnections for Microsoft.Relay. |`ActiveConnections` |Count |Total (Sum) |`EntityName`|PT1M |No|
|**ActiveListeners**<br><br>Total ActiveListeners for Microsoft.Relay. |`ActiveListeners` |Count |Total (Sum) |`EntityName`|PT1M |No|
|**BytesTransferred**<br><br>Total BytesTransferred for Microsoft.Relay. |`BytesTransferred` |Bytes |Total (Sum) |`EntityName`|PT1M |Yes|
|**ListenerConnections-ClientError**<br><br>ClientError on ListenerConnections for Microsoft.Relay. |`ListenerConnections-ClientError` |Count |Total (Sum) |`EntityName`, `OperationResult`|PT1M |No|
|**ListenerConnections-ServerError**<br><br>ServerError on ListenerConnections for Microsoft.Relay. |`ListenerConnections-ServerError` |Count |Total (Sum) |`EntityName`, `OperationResult`|PT1M |No|
|**ListenerConnections-Success**<br><br>Successful ListenerConnections for Microsoft.Relay. |`ListenerConnections-Success` |Count |Total (Sum) |`EntityName`, `OperationResult`|PT1M |No|
|**ListenerConnections-TotalRequests**<br><br>Total ListenerConnections for Microsoft.Relay. |`ListenerConnections-TotalRequests` |Count |Total (Sum) |`EntityName`|PT1M |No|
|**ListenerDisconnects**<br><br>Total ListenerDisconnects for Microsoft.Relay. |`ListenerDisconnects` |Count |Total (Sum) |`EntityName`|PT1M |No|
|**SenderConnections-ClientError**<br><br>ClientError on SenderConnections for Microsoft.Relay. |`SenderConnections-ClientError` |Count |Total (Sum) |`EntityName`, `OperationResult`|PT1M |No|
|**SenderConnections-ServerError**<br><br>ServerError on SenderConnections for Microsoft.Relay. |`SenderConnections-ServerError` |Count |Total (Sum) |`EntityName`, `OperationResult`|PT1M |No|
|**SenderConnections-Success**<br><br>Successful SenderConnections for Microsoft.Relay. |`SenderConnections-Success` |Count |Total (Sum) |`EntityName`, `OperationResult`|PT1M |No|
|**SenderConnections-TotalRequests**<br><br>Total SenderConnections requests for Microsoft.Relay. |`SenderConnections-TotalRequests` |Count |Total (Sum) |`EntityName`|PT1M |No|
|**SenderDisconnects**<br><br>Total SenderDisconnects for Microsoft.Relay. |`SenderDisconnects` |Count |Total (Sum) |`EntityName`|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
