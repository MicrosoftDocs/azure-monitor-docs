---
title: Supported metrics - microsoft.network/expressroutegateways
description: Reference for microsoft.network/expressroutegateways metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: microsoft.network/expressroutegateways, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for microsoft.network/expressroutegateways

The following table lists the metrics available for the microsoft.network/expressroutegateways resource type.

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



### Category: Performance
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Bits Received Per second**<br><br>Total Bits received on ExpressRoute Gateway per second |`ExpressRouteGatewayBitsPerSecond` |BitsPerSecond |Average, Minimum, Maximum |`roleInstance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**CPU utilization**<br><br>CPU Utilization of the ExpressRoute Gateway |`ExpressRouteGatewayCpuUtilization` |Percent |Average, Minimum, Maximum |`roleInstance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Packets received per second**<br><br>Total Packets received on ExpressRoute Gateway per second |`ExpressRouteGatewayPacketsPerSecond` |CountPerSecond |Average, Minimum, Maximum |`roleInstance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|

### Category: Scalability
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Active Flows**<br><br>Number of Active Flows on ExpressRoute Gateway |`ExpressRouteGatewayActiveFlows` |Count |Average, Minimum, Maximum |`roleInstance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Count Of Routes Advertised to Peer**<br><br>Count Of Routes Advertised To Peer by ExpressRoute Gateway |`ExpressRouteGatewayCountOfRoutesAdvertisedToPeer` |Count |Maximum |`roleInstance`, `BgpPeerAddress`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Count Of Routes Learned from Peer**<br><br>Count Of Routes Learned From Peer by ExpressRoute Gateway |`ExpressRouteGatewayCountOfRoutesLearnedFromPeer` |Count |Maximum |`roleInstance`, `BgpPeerAddress`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Frequency of Routes change**<br><br>Frequency of Routes change in ExpressRoute Gateway |`ExpressRouteGatewayFrequencyOfRoutesChanged` |Count |Total (Sum) |`roleInstance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Max Flows Created Per Second**<br><br>Maximum Number of Flows Created Per Second on ExpressRoute Gateway |`ExpressRouteGatewayMaxFlowsCreationRate` |CountPerSecond |Maximum |`roleInstance`, `direction`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Number of VMs in the Virtual Network**<br><br>Number of VMs in the Virtual Network |`ExpressRouteGatewayNumberOfVmInVnet` |Count |Maximum |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|

### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Bits In Per Second**<br><br>Bits per second ingressing Azure via ExpressRoute Gateway which can be further split for specific connections |`ErGatewayConnectionBitsInPerSecond` |BitsPerSecond |Average |`ConnectionName`|PT1M |No|
|**Bits Out Per Second**<br><br>Bits per second egressing Azure via ExpressRoute Gateway which can be further split for specific connections |`ErGatewayConnectionBitsOutPerSecond` |BitsPerSecond |Average |`ConnectionName`|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
