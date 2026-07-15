---
title: Supported metrics - Microsoft.ManagedNetworkFabric/l3IsolationDomains
description: Reference for Microsoft.ManagedNetworkFabric/l3IsolationDomains metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: Microsoft.ManagedNetworkFabric/l3IsolationDomains, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.ManagedNetworkFabric/l3IsolationDomains

The following table lists the metrics available for the Microsoft.ManagedNetworkFabric/l3IsolationDomains resource type.

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



### Category: External Network State Counters
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Ext NW In Broadcast Pkts**<br><br>The number of packets, delivered by this sub-layer to a higher (sub-)layer, that were addressed to a broadcast address at this sub-layer. |`IfSubIfInBroadcastPkts` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Ext NW In Discards**<br><br>The number of inbound packets that were chosen to be discarded even though no errors had been detected to prevent their being deliverable to a higher-layer protocol. |`IfSubIfInDiscards` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Ext NW In Errors**<br><br>For packet-oriented interfaces, the number of inbound packets that contained errors preventing them from being deliverable to a higher-layer protocol. |`IfSubIfInErrors` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Ext NW In FCS Errors**<br><br>Number of received packets which had errors in the frame check sequence (FCS), i.e., framing errors. |`IfSubIfInFcsErrors` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Ext NW In Multicast Pkts**<br><br>The number of packets, delivered by this sub-layer to a higher (sub-)layer, that were addressed to a multicast address at this sub-layer. For a MAC-layer protocol, this includes both Group and Functional addresses. |`IfSubIfInMulticastPkts` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Ext NW In Octets**<br><br>The total number of octets received on the interface, including framing characters. |`IfSubIfInOctets` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Ext NW In Pkts**<br><br>The total number of packets received on the interface, including all unicast, multicast, broadcast and bad packets etc. |`IfSubIfInPkts` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Ext NW In Unicast Pkts**<br><br>The number of packets, delivered by this sub-layer to a higher (sub-)layer, that were not addressed to a multicast or broadcast address at this sub-layer. |`IfSubIfInUnicastPkts` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Ext NW In Unknown Protocols**<br><br>For packet-oriented interfaces, the number of packets received via the interface that were discarded because of an unknown or unsupported protocol. |`IfSubIfInUnknownProtos` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Ext NW Out Broadcast Pkts**<br><br>The total number of packets that higher-level protocols requested be transmitted, and that were addressed to a broadcast address at this sub-layer, including those that were discarded or not sent. |`IfSubIfOutBroadcastPkts` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Ext NW Out Discards**<br><br>The number of outbound packets that were chosen to be discarded even though no errors had been detected to prevent their being transmitted. |`IfSubIfOutDiscards` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Ext NW Out Errors**<br><br>For packet-oriented interfaces, the number of outbound packets that could not be transmitted because of errors. |`IfSubIfOutErrors` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Ext NW Out MulticastPkts**<br><br>The total number of packets that higher-level protocols requested be transmitted, and that were addressed to a multicast address at this sub-layer, including those that were discarded or not sent. For a MAC-layer protocol, this includes both Group and Functional addresses. |`IfSubIfOutMulticastPkts` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Ext NW Out Octets**<br><br>The total number of octets transmitted out of the interface, including framing characters. |`IfSubIfOutOctets` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Ext NW Out Pkts**<br><br>The total number of packets transmitted out of the interface, including all unicast, multicast, broadcast, and bad packets etc. |`IfSubIfOutPkts` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Ext NW Out Unicast Pkts**<br><br>The total number of packets that higher-level requested be transmitted, and that were not addressed to a multicast or broadcast address at this sub-layer, including those that were discarded or not sent. |`IfSubIfOutUnicastPkts` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|

### Category: Internal Network BGP Neighbor Updates
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Int NW BGP Neighbor AfiSafi Prefixes Installed**<br><br>The number of prefixes received from the neighbor that are installed in the network instance RIB and actively used for forwarding. |`IntNwBgpNeighborAfiSafiPrefixesInstalled` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `InternalNetworkName`, `NeighborAddress`, `AfiSafiAfiSafiName`|PT1M |Yes|
|**Int NW BGP Neighbor AfiSafi Prefixes Received**<br><br>The number of prefixes that are received from the neighbor before applying any policies. |`IntNwBgpNeighborAfiSafiPrefixesReceived` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `InternalNetworkName`, `NeighborAddress`, `AfiSafiAfiSafiName`|PT1M |Yes|
|**Int NW BGP Neighbor AfiSafi Prefixes Sent**<br><br>The number of prefixes that are advertised to the neighbor after applying any policies. |`IntNwBgpNeighborAfiSafiPrefixesSent` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `InternalNetworkName`, `NeighborAddress`, `AfiSafiAfiSafiName`|PT1M |Yes|
|**Int NW BGP Neighbor Established Transitions**<br><br>Number of transitions to the Established state for the neighbor session. |`IntNwBgpNeighborEstablishedTransitions` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `InternalNetworkName`, `NeighborAddress`|PT1M |Yes|
|**Int NW BGP Neighbor Received Notification**<br><br>Number of BGP NOTIFICATION messages received indicating an error condition has occurred exchanged. |`IntNwBgpNeighborReceivedNotification` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `InternalNetworkName`, `NeighborAddress`|PT1M |Yes|
|**Int NW BGP Neighbor Received Update**<br><br>Number of BGP UPDATE messages received announcing, withdrawing or modifying paths exchanged. |`IntNwBgpNeighborReceivedUpdate` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `InternalNetworkName`, `NeighborAddress`|PT1M |Yes|
|**Int NW BGP Neighbor Sent Notification**<br><br>Number of BGP NOTIFICATION messages sent indicating an error condition has occurred exchanged. |`IntNwBgpNeighborSentNotification` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `InternalNetworkName`, `NeighborAddress`|PT1M |Yes|
|**Int NW BGP Neighbor Sent Update**<br><br>Number of BGP UPDATE messages sent announcing, withdrawing or modifying paths exchanged. |`IntNwBgpNeighborSentUpdate` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `InternalNetworkName`, `NeighborAddress`|PT1M |Yes|

### Category: Internal Network State Counters
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Int NW In Bits Rate**<br><br>Calculated received bits rate of the interface. |`IntNwInBitsRate` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Int NW In Broadcast Pkts**<br><br>The number of packets, delivered by this sub-layer to a higher (sub-)layer, that were addressed to a broadcast address at this sub-layer. |`IntNwInBroadcastPkts` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Int NW In Discards**<br><br>The number of inbound packets that were chosen to be discarded even though no errors had been detected to prevent their being deliverable to a higher-layer protocol. |`IntNwInDiscards` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Int NW In Errors**<br><br>For packet-oriented interfaces, the number of inbound packets that contained errors preventing them from being deliverable to a higher-layer protocol. |`IntNwInErrors` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Int NW In Multicast Pkts**<br><br>The number of packets, delivered by this sub-layer to a higher (sub-)layer, that were addressed to a multicast address at this sub-layer. For a MAC-layer protocol, this includes both Group and Functional addresses. |`IntNwInMulticastPkts` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Int NW In Octets**<br><br>The total number of octets received on the interface, including framing characters. |`IntNwInOctets` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Int NW In Pkts Rate**<br><br>The rate of packets received on the interface, including all unicast, multicast, broadcast and bad packets etc. |`IntNwInPktsRate` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Int NW In Ucast Pkts**<br><br>The number of packets, delivered by this sub-layer to a higher (sub-)layer, that were not addressed to a multicast or broadcast address at this sub-layer. |`IntNwInUcastPkts` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Int NW Out Bits Rate**<br><br>Calculated transmitted bits rate of the interface. |`IntNwOutBitsRate` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Int NW Out Broadcast Pkts**<br><br>The total number of packets that higher-level protocols requested be transmitted, and that were addressed to a broadcast address at this sub-layer, including those that were discarded or not sent. |`IntNwOutBroadcastPkts` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Int NW Out Discards**<br><br>The number of outbound packets that were chosen to be discarded even though no errors had been detected to prevent their being transmitted. |`IntNwOutDiscards` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Int NW Out Errors**<br><br>For packet-oriented interfaces, the number of outbound packets that could not be transmitted because of errors. |`IntNwOutErrors` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Int NW Out Multicast Pkts**<br><br>The total number of packets that higher-level protocols requested be transmitted, and that were addressed to a multicast address at this sub-layer, including those that were discarded or not sent. For a MAC-layer protocol, this includes both Group and Functional addresses. |`IntNwOutMulticastPkts` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Int NW Out Octets**<br><br>The total number of octets transmitted out of the interface, including framing characters. |`IntNwOutOctets` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Int NW Out Pkts Rate**<br><br>The rate of packets transmitted out of the interface, including all unicast, multicast, broadcast, and bad packets etc. |`IntNwOutPktsRate` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|
|**Int NW Out Ucast Pkts**<br><br>The total number of packets that higher-level requested be transmitted, and that were not addressed to a multicast or broadcast address at this sub-layer, including those that were discarded or not sent. |`IntNwOutUcastPkts` | No | Count |Average, Minimum, Maximum, Total (Sum), Count |`DeviceId`, `FabricId`, `IsdResourceName`, `IsdNetworkArmId`, `IsdNetworkName`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
