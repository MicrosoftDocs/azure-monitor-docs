---
title: Supported metrics - microsoft.network/virtualnetworkgateways
description: Reference for microsoft.network/virtualnetworkgateways metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: microsoft.network/virtualnetworkgateways, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for microsoft.network/virtualnetworkgateways

The following table lists the metrics available for the microsoft.network/virtualnetworkgateways resource type.

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


For a list of supported logs, see [Supported log categories - microsoft.network/virtualnetworkgateways](../supported-logs/microsoft-network-virtualnetworkgateways-logs.md)


### Category: Errors
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Tunnel Egress Packet Drop Count**<br><br>Count of outgoing packets dropped by tunnel |`TunnelEgressPacketDropCount` |Count |Total (Sum) |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Tunnel Egress TS Mismatch Packet Drop**<br><br>Outgoing packet drop count from traffic selector mismatch of a tunnel |`TunnelEgressPacketDropTSMismatch` |Count |Total (Sum) |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Tunnel Ingress Packet Drop Count**<br><br>Count of incoming packets dropped by tunnel |`TunnelIngressPacketDropCount` |Count |Total (Sum) |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Tunnel Ingress TS Mismatch Packet Drop**<br><br>Incoming packet drop count from traffic selector mismatch of a tunnel |`TunnelIngressPacketDropTSMismatch` |Count |Total (Sum) |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Tunnel NAT Packet Drops**<br><br>Number of NATed packets on a tunnel that dropped by drop type and NAT rule |`TunnelNatPacketDrop` |Count |Total (Sum) |`NatRule`, `DropType`, `ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|

### Category: Ipsec
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Tunnel MMSA Count**<br><br>MMSA Count |`MmsaCount` |Count |Total (Sum) |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Tunnel QMSA Count**<br><br>QMSA Count |`QmsaCount` |Count |Total (Sum) |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|

### Category: Performance
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Bits Received Per second**<br><br>Total Bits received on ExpressRoute Gateway per second |`ExpressRouteGatewayBitsPerSecond` |BitsPerSecond |Average, Minimum, Maximum |`roleInstance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**CPU utilization**<br><br>CPU Utilization of the ExpressRoute Gateway |`ExpressRouteGatewayCpuUtilization` |Percent |Average, Minimum, Maximum |`roleInstance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Packets received per second**<br><br>Total Packets received on ExpressRoute Gateway per second |`ExpressRouteGatewayPacketsPerSecond` |CountPerSecond |Average, Minimum, Maximum |`roleInstance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Bits Received Per second**<br><br>Total Bits received on ExpressRoute Gateway per second |`ScalableExpressRouteGatewayBitsPerSecond` |BitsPerSecond |Average, Minimum, Maximum |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**CPU utilization**<br><br>CPU Utilization of the ExpressRoute Gateway |`ScalableExpressRouteGatewayCpuUtilization` |Percent |Average, Minimum, Maximum |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Packets received per second**<br><br>Total Packets received on ExpressRoute Gateway per second |`ScalableExpressRouteGatewayPacketsPerSecond` |CountPerSecond |Average, Minimum, Maximum |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|

### Category: Routing
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**BGP Peer Status**<br><br>Status of BGP peer |`BgpPeerStatus` |Count |Average |`BgpPeerAddress`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**BGP Routes Advertised**<br><br>Count of Bgp Routes Advertised through tunnel |`BgpRoutesAdvertised` |Count |Total (Sum) |`BgpPeerAddress`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**BGP Routes Learned**<br><br>Count of Bgp Routes Learned through tunnel |`BgpRoutesLearned` |Count |Total (Sum) |`BgpPeerAddress`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**User Vpn Route Count**<br><br>Count of P2S User Vpn routes learned by gateway |`UserVpnRouteCount` |Count |Total (Sum) |`RouteType`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**VNet Address Prefix Count**<br><br>Count of Vnet address prefixes behind gateway |`VnetAddressPrefixCount` |Count |Total (Sum) |`Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|

### Category: Scalability
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Active Flows**<br><br>Number of Active Flows on ExpressRoute Gateway |`ExpressRouteGatewayActiveFlows` |Count |Average, Minimum, Maximum |`roleInstance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Count Of Routes Advertised to Peer**<br><br>Count Of Routes Advertised To Peer by ExpressRoute Gateway |`ExpressRouteGatewayCountOfRoutesAdvertisedToPeer` |Count |Maximum |`roleInstance`, `BgpPeerAddress`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Count Of Routes Learned from Peer**<br><br>Count Of Routes Learned From Peer by ExpressRoute Gateway |`ExpressRouteGatewayCountOfRoutesLearnedFromPeer` |Count |Maximum |`roleInstance`, `BgpPeerAddress`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Frequency of Routes change**<br><br>Frequency of Routes change in ExpressRoute Gateway |`ExpressRouteGatewayFrequencyOfRoutesChanged` |Count |Total (Sum) |`roleInstance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Max Flows Created Per Second**<br><br>Maximum Number of Flows Created Per Second on ExpressRoute Gateway |`ExpressRouteGatewayMaxFlowsCreationRate` |CountPerSecond |Maximum |`roleInstance`, `direction`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Number of VMs in the Virtual Network**<br><br>Number of VMs in the Virtual Network |`ExpressRouteGatewayNumberOfVmInVnet` |Count |Maximum |`roleInstance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Active Flows**<br><br>Number of Active Flows on ExpressRoute Gateway |`ScalableExpressRouteGatewayActiveFlows` |Count |Average, Minimum, Maximum |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Count Of Routes Advertised to Peer**<br><br>Count Of Routes Advertised To Peer by ExpressRoute Gateway |`ScalableExpressRouteGatewayCountOfRoutesAdvertisedToPeer` |Count |Maximum |`BgpPeerAddress`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Count Of Routes Learned from Peer**<br><br>Count Of Routes Learned From Peer by ExpressRoute Gateway |`ScalableExpressRouteGatewayCountOfRoutesLearnedFromPeer` |Count |Maximum |`BgpPeerAddress`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Frequency of Routes change**<br><br>Frequency of Routes change in ExpressRoute Gateway |`ScalableExpressRouteGatewayFrequencyOfRoutesChanged` |Count |Total (Sum) |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Max Flows Created Per Second**<br><br>Maximum Number of Flows Created Per Second on ExpressRoute Gateway |`ScalableExpressRouteGatewayMaxFlowsCreationRate` |CountPerSecond |Maximum |`direction`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Number of VMs in the Virtual Network**<br><br>Number of VMs in the Virtual Network |`ScalableExpressRouteGatewayNumberOfVmInVnet` |Count |Maximum |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Scale Units**<br><br>Scale Unit metric for ExpressRouteGateway |`ScalableExpressRouteGatewayScaleUnit` |Count |Maximum, Minimum, Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|

### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Gateway S2S Bandwidth**<br><br>Site-to-site bandwidth of a gateway in bytes per second |`AverageBandwidth` |BytesPerSecond |Average |`Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Gateway Inbound Flows**<br><br>Number of 5-tuple flows entering into a VPN gateway |`InboundFlowsCount` |Count |Maximum, Minimum |`Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Gateway Outbound Flows**<br><br>Number of 5-tuple flows exiting a VPN gateway |`OutboundFlowsCount` |Count |Maximum, Minimum |`Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Gateway P2S Bandwidth**<br><br>Point-to-site bandwidth of a gateway in bytes per second |`P2SBandwidth` |BytesPerSecond |Average |`Instance`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**P2S Connection Count**<br><br>Point-to-site connection count of a gateway |`P2SConnectionCount` |Count |Total (Sum) |`Protocol`, `Instance`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Tunnel Bandwidth**<br><br>Average bandwidth of a tunnel in bytes per second |`TunnelAverageBandwidth` |BytesPerSecond |Average |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Tunnel Egress Bytes**<br><br>Outgoing bytes of a tunnel |`TunnelEgressBytes` |Bytes |Total (Sum) |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Tunnel Egress Packets**<br><br>Outgoing packet count of a tunnel |`TunnelEgressPackets` |Count |Total (Sum) |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Tunnel Ingress Bytes**<br><br>Incoming bytes of a tunnel |`TunnelIngressBytes` |Bytes |Total (Sum) |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Tunnel Ingress Packets**<br><br>Incoming packet count of a tunnel |`TunnelIngressPackets` |Count |Total (Sum) |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Tunnel NAT Allocations**<br><br>Count of allocations for a NAT rule on a tunnel |`TunnelNatAllocations` |Count |Total (Sum) |`NatRule`, `ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Tunnel NATed Bytes**<br><br>Number of bytes that were NATed on a tunnel by a NAT rule |`TunnelNatedBytes` |Bytes |Total (Sum) |`NatRule`, `ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Tunnel NATed Packets**<br><br>Number of packets that were NATed on a tunnel by a NAT rule |`TunnelNatedPackets` |Count |Total (Sum) |`NatRule`, `ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Tunnel NAT Flows**<br><br>Number of NAT flows on a tunnel by flow type and NAT rule |`TunnelNatFlowCount` |Count |Total (Sum) |`NatRule`, `FlowType`, `ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Tunnel Peak PPS**<br><br>Tunnel Peak Packets Per Second |`TunnelPeakPackets` |Count |Maximum |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Tunnel Reverse NATed Bytes**<br><br>Number of bytes that were reverse NATed on a tunnel by a NAT rule |`TunnelReverseNatedBytes` |Bytes |Total (Sum) |`NatRule`, `ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Tunnel Reverse NATed Packets**<br><br>Number of packets on a tunnel that were reverse NATed by a NAT rule |`TunnelReverseNatedPackets` |Count |Total (Sum) |`NatRule`, `ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Tunnel Total Flow Count**<br><br>Total flow count on a tunnel |`TunnelTotalFlowCount` |Count |Total (Sum) |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
