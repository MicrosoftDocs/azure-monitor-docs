---
title: Supported metrics - Microsoft.Relay/clusters
description: Reference for Microsoft.Relay/clusters metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 10/16/2026
ms.custom: Microsoft.Relay/clusters, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Relay/clusters

The following table lists the metrics available for the Microsoft.Relay/clusters resource type.

**Table headings**

- **Metric** - The metric display name as it appears in the Azure portal.
- **Name in Rest API** - Metric name as referred to in the [REST API](/azure/azure-monitor/essentials/rest-api-walkthrough).
- **Advanced platform metrics** - A premium, [paid tier of platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform) in Azure Monitor that provide more granular observability for Azure resources.
- **Unit** - Unit of measure.
- **Aggregation** - The default [aggregation](/azure/azure-monitor/essentials/metrics-aggregation-explained) type. Valid values: Average, Minimum, Maximum, Total, Count.
- **Dimensions** - [Dimensions](/azure/azure-monitor/essentials/metrics-aggregation-explained#dimensions-splitting-and-filtering) available for the metric.
- **Time Grains** - [Intervals at which the metric is sampled](/azure/azure-monitor/essentials/metrics-aggregation-explained#granularity). For example, `PT1M` indicates that the metric is sampled every minute, `PT30M` every 30 minutes, `PT1H` every hour, and so on.
- **DS Export** - Shows whether the metric is exportable to Azure Monitor Logs via Diagnostic Settings.

For information on exporting metrics, see - [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics) and [Create diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/create-diagnostic-settings?tabs=portal).

For information on metric retention, see [Azure Monitor Metrics overview](/azure/azure-monitor/essentials/data-platform-metrics#retention-of-metrics).



|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**ActiveConnections**<br><br>Total ActiveConnections across the Relay Cluster. |`ActiveConnections` | No | Count |Maximum, Minimum, Average |\<none\>|PT1M |No|
|**ActiveListeners**<br><br>Total ActiveListeners across the Relay Cluster. |`ActiveListeners` | No | Count |Maximum, Minimum, Average |\<none\>|PT1M |No|
|**AvailableMemory**<br><br>Available memory for the Relay Cluster as a percentage of total memory. |`AvailableMemory` | No | Percent |Maximum |`Role`|PT1M |No|
|**BytesTransferred**<br><br>Total BytesTransferred across the Relay Cluster. |`BytesTransferred` | No | Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**CPU**<br><br>CPU utilization for the Relay Cluster as a percentage |`CPU` | No | Percent |Maximum |`Role`, `Instance`|PT1M |No|
|**ListenerConnections-ClientError**<br><br>ClientError on ListenerConnections across the Relay Cluster. |`ListenerConnections-ClientError` | No | Count |Total (Sum) |`OperationResult`|PT1M |No|
|**ListenerConnections-ServerError**<br><br>ServerError on ListenerConnections across the Relay Cluster. |`ListenerConnections-ServerError` | No | Count |Total (Sum) |`OperationResult`|PT1M |No|
|**ListenerConnections-Success**<br><br>Successful ListenerConnections across the Relay Cluster. |`ListenerConnections-Success` | No | Count |Total (Sum) |`OperationResult`|PT1M |No|
|**ListenerConnections-TotalRequests**<br><br>Total ListenerConnections across the Relay Cluster. |`ListenerConnections-TotalRequests` | No | Count |Total (Sum) |\<none\>|PT1M |No|
|**ListenerDisconnects**<br><br>Total ListenerDisconnects across the Relay Cluster. |`ListenerDisconnects` | No | Count |Total (Sum) |\<none\>|PT1M |No|
|**SenderConnections-ClientError**<br><br>ClientError on SenderConnections across the Relay Cluster. |`SenderConnections-ClientError` | No | Count |Total (Sum) |`OperationResult`|PT1M |No|
|**SenderConnections-ServerError**<br><br>ServerError on SenderConnections across the Relay Cluster. |`SenderConnections-ServerError` | No | Count |Total (Sum) |`OperationResult`|PT1M |No|
|**SenderConnections-Success**<br><br>Successful SenderConnections across the Relay Cluster. |`SenderConnections-Success` | No | Count |Total (Sum) |`OperationResult`|PT1M |No|
|**SenderConnections-TotalRequests**<br><br>Total SenderConnections requests across the Relay Cluster. |`SenderConnections-TotalRequests` | No | Count |Total (Sum) |\<none\>|PT1M |No|
|**SenderDisconnects**<br><br>Total SenderDisconnects across the Relay Cluster. |`SenderDisconnects` | No | Count |Total (Sum) |\<none\>|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
