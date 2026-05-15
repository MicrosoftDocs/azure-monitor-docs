---
title: Supported metrics - Microsoft.ManagedNetworkFabric/internetGateways
description: Reference for Microsoft.ManagedNetworkFabric/internetGateways metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.ManagedNetworkFabric/internetGateways, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.ManagedNetworkFabric/internetGateways

The following table lists the metrics available for the Microsoft.ManagedNetworkFabric/internetGateways resource type.

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



### Category: Proxy Connection Metrics
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Inbound active connections**<br><br>Count of inbound active connections |`InboundConnectionsActive` |Count |Average, Maximum, Minimum |`nfcId`, `gatewayType`|PT1M |Yes|
|**Total inbound connections**<br><br>Count of inbound connections |`InboundConnectionsTotal` |Count |Average, Maximum, Minimum |`nfcId`, `gatewayType`|PT1M |Yes|
|**Total outbound active connections**<br><br>Count of outbound active connections |`OutboundConnectionsActive` |Count |Average, Maximum, Minimum |`nfcId`, `gatewayType`|PT1M |Yes|
|**Total outbound failed connections**<br><br>Count of outbound total failed connections |`OutboundConnectionsFail` |Count |Average, Maximum, Minimum |`nfcId`, `gatewayType`|PT1M |Yes|
|**Total outbound connection timeouts**<br><br>Count of outbound connection timeouts |`OutboundConnectionsTimeout` |Count |Average, Maximum, Minimum |`nfcId`, `gatewayType`|PT1M |Yes|
|**Total outbound connections**<br><br>Count of outbound total connections |`OutboundConnectionsTotal` |Count |Average, Maximum, Minimum |`nfcId`, `gatewayType`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
