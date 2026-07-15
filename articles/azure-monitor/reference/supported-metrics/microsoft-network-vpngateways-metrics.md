---
title: Supported metrics - microsoft.network/vpngateways
description: Reference for microsoft.network/vpngateways metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: microsoft.network/vpngateways, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for microsoft.network/vpngateways

The following table lists the metrics available for the microsoft.network/vpngateways resource type.

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


For a list of supported logs, see [Supported log categories - microsoft.network/vpngateways](../supported-logs/microsoft-network-vpngateways-logs.md)


### Category: Errors
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Tunnel Egress Packet Drop Count**<br><br>Count of outgoing packets dropped by tunnel |`TunnelEgressPacketDropCount` | No | Count |Total (Sum) |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Tunnel Egress TS Mismatch Packet Drop**<br><br>Outgoing packet drop count from traffic selector mismatch of a tunnel |`TunnelEgressPacketDropTSMismatch` | No | Count |Total (Sum) |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Tunnel Ingress Packet Drop Count**<br><br>Count of incoming packets dropped by tunnel |`TunnelIngressPacketDropCount` | No | Count |Total (Sum) |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Tunnel Ingress TS Mismatch Packet Drop**<br><br>Incoming packet drop count from traffic selector mismatch of a tunnel |`TunnelIngressPacketDropTSMismatch` | No | Count |Total (Sum) |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Tunnel NAT Packet Drops**<br><br>Number of NATed packets on a tunnel that dropped by drop type and NAT rule |`TunnelNatPacketDrop` | No | Count |Total (Sum) |`NatRule`, `DropType`, `ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|

### Category: Ipsec
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Tunnel MMSA Count**<br><br>MMSA Count |`MmsaCount` | No | Count |Total (Sum) |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Tunnel QMSA Count**<br><br>QMSA Count |`QmsaCount` | No | Count |Total (Sum) |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|

### Category: Routing
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**BGP Peer Status**<br><br>Status of BGP peer |`BgpPeerStatus` | No | Count |Average |`BgpPeerAddress`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**BGP Routes Advertised**<br><br>Count of Bgp Routes Advertised through tunnel |`BgpRoutesAdvertised` | No | Count |Total (Sum) |`BgpPeerAddress`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**BGP Routes Learned**<br><br>Count of Bgp Routes Learned through tunnel |`BgpRoutesLearned` | No | Count |Total (Sum) |`BgpPeerAddress`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**VNet Address Prefix Count**<br><br>Count of Vnet address prefixes behind gateway |`VnetAddressPrefixCount` | No | Count |Total (Sum) |`Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|

### Category: Traffic
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Gateway S2S Bandwidth**<br><br>Site-to-site bandwidth of a gateway in bytes per second |`AverageBandwidth` | No | BytesPerSecond |Average |`Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Gateway Inbound Flows**<br><br>Number of 5-tuple flows entering into a VPN gateway |`InboundFlowsCount` | No | Count |Maximum, Minimum |`Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Gateway Outbound Flows**<br><br>Number of 5-tuple flows exiting a VPN gateway |`OutboundFlowsCount` | No | Count |Maximum, Minimum |`Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Tunnel Bandwidth**<br><br>Average bandwidth of a tunnel in bytes per second |`TunnelAverageBandwidth` | No | BytesPerSecond |Average |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Tunnel Egress Bytes**<br><br>Outgoing bytes of a tunnel |`TunnelEgressBytes` | No | Bytes |Total (Sum) |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Tunnel Egress Packets**<br><br>Outgoing packet count of a tunnel |`TunnelEgressPackets` | No | Count |Total (Sum) |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Tunnel Ingress Bytes**<br><br>Incoming bytes of a tunnel |`TunnelIngressBytes` | No | Bytes |Total (Sum) |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Tunnel Ingress Packets**<br><br>Incoming packet count of a tunnel |`TunnelIngressPackets` | No | Count |Total (Sum) |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Tunnel NAT Allocations**<br><br>Count of allocations for a NAT rule on a tunnel |`TunnelNatAllocations` | No | Count |Total (Sum) |`NatRule`, `ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Tunnel NATed Bytes**<br><br>Number of bytes that were NATed on a tunnel by a NAT rule |`TunnelNatedBytes` | No | Bytes |Total (Sum) |`NatRule`, `ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Tunnel NATed Packets**<br><br>Number of packets that were NATed on a tunnel by a NAT rule |`TunnelNatedPackets` | No | Count |Total (Sum) |`NatRule`, `ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Tunnel NAT Flows**<br><br>Number of NAT flows on a tunnel by flow type and NAT rule |`TunnelNatFlowCount` | No | Count |Total (Sum) |`NatRule`, `FlowType`, `ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Tunnel Peak PPS**<br><br>Tunnel Peak Packets Per Second |`TunnelPeakPackets` | No | Count |Maximum |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Tunnel Reverse NATed Bytes**<br><br>Number of bytes that were reverse NATed on a tunnel by a NAT rule |`TunnelReverseNatedBytes` | No | Bytes |Total (Sum) |`NatRule`, `ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Tunnel Reverse NATed Packets**<br><br>Number of packets on a tunnel that were reverse NATed by a NAT rule |`TunnelReverseNatedPackets` | No | Count |Total (Sum) |`NatRule`, `ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Tunnel Total Flow Count**<br><br>Total flow count on a tunnel |`TunnelTotalFlowCount` | No | Count |Total (Sum) |`ConnectionName`, `RemoteIP`, `Instance`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
