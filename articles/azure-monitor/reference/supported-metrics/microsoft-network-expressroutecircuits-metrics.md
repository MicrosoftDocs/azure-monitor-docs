---
title: Supported metrics - Microsoft.Network/expressRouteCircuits
description: Reference for Microsoft.Network/expressRouteCircuits metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Network/expressRouteCircuits, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Network/expressRouteCircuits

The following table lists the metrics available for the Microsoft.Network/expressRouteCircuits resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.Network/expressRouteCircuits](../supported-logs/microsoft-network-expressroutecircuits-logs.md)


### Category: Circuit Availability
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Arp Availability**<br><br>ARP Availability from MSEE towards all peers. |`ArpAvailability` |Percent |Average |`PeeringType`, `Peer`|PT1M |Yes|
|**Bgp Availability**<br><br>BGP Availability from MSEE towards all peers. |`BgpAvailability` |Percent |Average |`PeeringType`, `Peer`|PT1M |Yes|

### Category: Circuit Qos
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**DroppedInBitsPerSecond**<br><br>Ingress bits of data dropped per second |`QosDropBitsInPerSecond` |BitsPerSecond |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**DroppedOutBitsPerSecond**<br><br>Egress bits of data dropped per second |`QosDropBitsOutPerSecond` |BitsPerSecond |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|

### Category: Circuit Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**BitsInPerSecond**<br><br>Bits ingressing Azure per second |`BitsInPerSecond` |BitsPerSecond |Average |`PeeringType`, `DeviceRole`|PT1M |Yes|
|**BitsOutPerSecond**<br><br>Bits egressing Azure per second |`BitsOutPerSecond` |BitsPerSecond |Average |`PeeringType`, `DeviceRole`|PT1M |Yes|
|**EgressBandwidthUtilization**<br><br>Egress Link Bandwidth percentage utilization |`EgressBandwidthUtilization` |Percent |Maximum |`PeeringType`, `DeviceRole`|PT1M |Yes|
|**IngressBandwidthUtilization**<br><br>Ingress Link Bandwidth percentage utilization |`IngressBandwidthUtilization` |Percent |Maximum |`PeeringType`, `DeviceRole`|PT1M |Yes|

### Category: Fastpath
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**FastPathRoutesCount**<br><br>Count of fastpath routes configured on circuit |`FastPathRoutesCountForCircuit` |Count |Maximum |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|

### Category: GlobalReach Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**GlobalReachBitsInPerSecond**<br><br>Bits ingressing Azure per second |`GlobalReachBitsInPerSecond` |BitsPerSecond |Average |`PeeredCircuitSKey`|PT1M |No|
|**GlobalReachBitsOutPerSecond**<br><br>Bits egressing Azure per second |`GlobalReachBitsOutPerSecond` |BitsPerSecond |Average |`PeeredCircuitSKey`|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
