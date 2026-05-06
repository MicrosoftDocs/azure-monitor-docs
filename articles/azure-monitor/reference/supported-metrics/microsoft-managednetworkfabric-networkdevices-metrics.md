---
title: Supported metrics - Microsoft.ManagedNetworkFabric/networkDevices
description: Reference for Microsoft.ManagedNetworkFabric/networkDevices metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.ManagedNetworkFabric/networkDevices, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.ManagedNetworkFabric/networkDevices

The following table lists the metrics available for the Microsoft.ManagedNetworkFabric/networkDevices resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.ManagedNetworkFabric/networkDevices](../supported-logs/microsoft-managednetworkfabric-networkdevices-logs.md)


### Category: ACL State Counters
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Acl Matched Packets**<br><br>Count of the number of packets matching the current ACL entry. |`AclMatchedPackets` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `AclSetName`, `AclEntrySequenceId`, `AclSetType`|PT1M |Yes|

### Category: BGP Status
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**BGP Peer Status**<br><br>Operational state of the BGP peer. State is represented in numerical form. Idle : 1, Connect : 2, Active : 3, Opensent : 4, Openconfirm : 5, Established : 6 |`BgpPeerStatus` |Unspecified |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `IpAddress`|PT1M |Yes|

### Category: Component Operational State
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Component Operational State**<br><br>The current operational status of the component. |`ComponentOperStatus` |Unspecified |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|

### Category: Disk Utilization
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Disk Available Size**<br><br>Current available size of the disk in bytes. |`DiskAvailableSize` |Bytes |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `MountPointName`|PT1M |Yes|
|**Disk Size**<br><br>Current size of the disk in bytes. |`DiskSize` |Bytes |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `MountPointName`|PT1M |Yes|
|**Disk Utilization Percent**<br><br>Percentage value of current utilized disk space compared to the total disk size. |`DiskUtilPercent` |Percent |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `MountPointName`|PT1M |Yes|
|**Disk Utilized Size**<br><br>Current utilized disk space in bytes. |`DiskUtilSize` |Bytes |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `MountPointName`|PT1M |Yes|

### Category: Interface QoS State Counters
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Interface Dropped Octets**<br><br>Number of octets dropped by the queue due to overrun, that is tail-drop or AMQ (RED, WRED, etc) induced drops as indicated by the attached queue-management-profile. |`IfDroppedOctets` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface Dropped Octets Rate**<br><br>The calculated drop rate of octets from the queue. |`IfDroppedOctetsRate` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface Dropped Pkts**<br><br>Number of packets dropped by the queue due to overrun, that is tail-drop or AMQ (RED, WRED, etc) induced drops as indicated by the attached queue-management-profile. |`IfDroppedPkts` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface Dropped Pkts Rate**<br><br>The calculated drop rate of packets from the queue. |`IfDroppedPktsRate` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|

### Category: Interface State
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Interface Admin Status**<br><br>Interface Admin Status of the device. Possible values are Up: 1, Down: 2, Testing: 3. |`InterfaceAdminStatus` |Unspecified |Average, Minimum, Maximum, Total (Sum), Count |`InterfaceName`|PT1M |Yes|
|**Interface Operational State**<br><br>The current operational state of the interface. State is represented in numerical form. Up: 0, Down: 1, Lower_layer_down: 2, Testing: 3, Unknown: 4, Dormant: 5, Not_present: 6. |`InterfaceOperStatus` |Unspecified |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|

### Category: Interface State Counters
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Eth Interface In CRC Errors**<br><br>The total number of frames received that had a length (excluding framing bits, but including FCS octets) of between 64 and 1518 octets, inclusive, but had either a bad Frame Check Sequence (FCS) with an integral number of octets (FCS Error) or a bad FCS with a non-integral number of octets (Alignment Error) |`IfEthInCrcErrors` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Eth Interface In Fragment Frames**<br><br>The total number of frames received that were less than 64 octets in length (excluding framing bits but including FCS octets) and had either a bad Frame Check Sequence (FCS) with an integral number of octets (FCS Error) or a bad FCS with a non-integral number of octets (Alignment Error). |`IfEthInFragmentFrames` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Eth Interface In Jabber Frames**<br><br>Number of jabber frames received on the interface. Jabber frames are typically defined as oversize frames which also have a bad CRC. |`IfEthInJabberFrames` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Eth Interface In MAC Control Frames**<br><br>MAC layer control frames received on the interface |`IfEthInMacControlFrames` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Eth Interface In MAC Pause Frames**<br><br>MAC layer PAUSE frames received on the interface |`IfEthInMacPauseFrames` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Eth Interface In Maxsize Exceeded**<br><br>The total number frames received that are well-formed dropped due to exceeding the maximum frame size on the interface. |`IfEthInMaxsizeExceeded` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Eth Interface In Oversize Frames**<br><br>The total number of frames received that were longer than 1518 octets (excluding framing bits, but including FCS octets) and were otherwise well formed. |`IfEthInOversizeFrames` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Eth Interface Out MAC Control Frames**<br><br>MAC layer control frames sent on the interface. |`IfEthOutMacControlFrames` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Eth Interface Out MAC Pause Frames**<br><br>MAC layer PAUSE frames sent on the interface. |`IfEthOutMacPauseFrames` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface In Broadcast Pkts**<br><br>The number of packets, delivered by this sub-layer to a higher (sub-)layer, that were addressed to a broadcast address at this sub-layer. |`IfInBroadcastPkts` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface In Discards**<br><br>The number of inbound packets that were chosen to be discarded even though no errors had been detected to prevent their being deliverable to a higher-layer protocol. |`IfInDiscards` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface In Errors**<br><br>For packet-oriented interfaces, the number of inbound packets that contained errors preventing them from being deliverable to a higher-layer protocol. |`IfInErrors` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface In Errors Rate**<br><br>For packet-oriented interfaces, the rate of inbound packets that contained errors preventing them from being deliverable to a higher-layer protocol. |`IfInErrorsRate` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface In FCS Errors**<br><br>Number of received packets which had errors in the frame check sequence (FCS), i.e., framing errors. |`IfInFcsErrors` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface In Multicast Pkts**<br><br>The number of packets, delivered by this sub-layer to a higher (sub-)layer, that were addressed to a multicast address at this sub-layer. For a MAC-layer protocol, this includes both Group and Functional addresses. |`IfInMulticastPkts` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface In Octets**<br><br>The total number of octets received on the interface, including framing characters. |`IfInOctets` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface In Pkts**<br><br>The total number of packets received on the interface, including all unicast, multicast, broadcast and bad packets etc. |`IfInPkts` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface In Unicast Pkts**<br><br>The number of packets, delivered by this sub-layer to a higher (sub-)layer, that were not addressed to a multicast or broadcast address at this sub-layer. |`IfInUnicastPkts` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface Out Broadcast Pkts**<br><br>The total number of packets that higher-level protocols requested be transmitted, and that were addressed to a broadcast address at this sub-layer, including those that were discarded or not sent. |`IfOutBroadcastPkts` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface Out Discards**<br><br>The number of outbound packets that were chosen to be discarded even though no errors had been detected to prevent their being transmitted. |`IfOutDiscards` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface Out Errors**<br><br>For packet-oriented interfaces, the number of outbound packets that could not be transmitted because of errors. |`IfOutErrors` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface Out Errors Rate**<br><br>For packet-oriented interfaces, the rate of outbound packets that could not be transmitted because of errors. |`IfOutErrorsRate` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface Out Multicast Pkts**<br><br>The total number of packets that higher-level protocols requested be transmitted, and that were addressed to a multicast address at this sub-layer, including those that were discarded or not sent. For a MAC-layer protocol, this includes both Group and Functional addresses. |`IfOutMulticastPkts` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface Out Octets**<br><br>The total number of octets transmitted out of the interface, including framing characters. |`IfOutOctets` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface Out Pkts**<br><br>The total number of packets transmitted out of the interface, including all unicast, multicast, broadcast, and bad packets etc. |`IfOutPkts` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface Out Unicast Pkts**<br><br>The total number of packets that higher-level requested be transmitted, and that were not addressed to a multicast or broadcast address at this sub-layer, including those that were discarded or not sent. |`IfOutUnicastPkts` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|

### Category: Interface State Rate
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Interface In Bits Rate**<br><br>The calculated received rate of the interface, measured in bits per second. |`IfInBitsRate` |BitsPerSecond |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface In Bits Rate Percent**<br><br>Percentage value of current input bits rate on the interface compared to the port speed. |`IfInBitsRatePercent` |Percent |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface In Discards Rate**<br><br>The rate of inbound packets that were chosen to be discarded even though no errors had been detected to prevent their being deliverable to a higher-layer protocol. |`IfInDiscardsRate` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface In Pkts Rate**<br><br>The calculated received rate of the interface, measured in packets per second. |`IfInPktsRate` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface Out Bits Rate**<br><br>The calculated transmitted rate of the interface, measured in bits per second. |`IfOutBitsRate` |BitsPerSecond |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface Out Bits Rate Percent**<br><br>Percentage value of current output bits rate on the interface compared to the port speed. |`IfOutBitsRatePercent` |Percent |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface Out Discards Rate**<br><br>The rate of outbound packets that were chosen to be discarded even though no errors had been detected to prevent their being transmitted. |`IfOutDiscardsRate` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Interface Out Pkts Rate**<br><br>The calculated transmitted rate of the interface, measured in packets per second. |`IfOutPktsRate` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|

### Category: LACP State Counters
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Lacp Errors**<br><br>Number of LACPDU illegal packet errors. |`LacpErrors` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Lacp In Pkts**<br><br>Number of LACPDUs received. |`LacpInPkts` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Lacp Out Pkts**<br><br>Number of LACPDUs transmitted. |`LacpOutPkts` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Lacp Rx Errors**<br><br>Number of LACPDU receive packet errors. |`LacpRxErrors` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Lacp Tx Errors**<br><br>Number of LACPDU transmit packet errors. |`LacpTxErrors` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Lacp Unknown Errors**<br><br>Number of LACPDU unknown packet errors. |`LacpUnknownErrors` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|

### Category: Layer 1 Metrics
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**L1 - Interface FEC Corrected Codewords**<br><br>FEC Corrected Codewords on the interface. |`IfEthPhyIngFecCCW` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**L1 - Interface FEC Pre-FEC BER**<br><br>FEC Pre-FEC Bit Error Rate on the interface. |`IfEthPhyIngFecPreFecBer` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**L1 - Interface FEC Uncorrected Codewords**<br><br>FEC Uncorrected Codewords on the interface. |`IfEthPhyIngFecUCW` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**L1 - Interface PCS Error Blocks**<br><br>PCS Error Blocks on the interface. |`IfEthPhyIngPcsErrBlcks` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**L1 - Lane Fault Rx CDR LoL**<br><br>lane fault reception CDR LoL (Clock and Data Recovery - Loss of Lock). Possible values are 0 (no fault), 1 (fault). |`LaneFaultRxCdrLol` |Unspecified |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|
|**L1 - Lane Fault Rx LoS**<br><br>lane fault reception LoS (Loss of Signal). Possible values are 0 (no fault), 1 (fault). |`LaneFaultRxLos` |Unspecified |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|
|**L1 - Lane Fault Tx CDR LoL**<br><br>lane fault transmission CDR LoL (Clock and Data Recovery - Loss of Lock). Possible values are 0 (no fault), 1 (fault). |`LaneFaultTxCdrLol` |Unspecified |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|
|**L1 - Lane Fault Tx Failure**<br><br>lane fault transmission failures. Possible values are 0 (no fault), 1 (fault). |`LaneFaultTxFailure` |Unspecified |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|
|**L1 - Lane Fault Tx LoS**<br><br>lane fault transmission LoS (Loss of Signal). Possible values are 0 (no fault), 1 (fault). |`LaneFaultTxLos` |Unspecified |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|
|**L1 - Transceiver Input Power Instant**<br><br>Instantaneous value of the input power for the transceiver (watts). |`TransceiverInputPowerInstant` |Unspecified |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|
|**L1 - Transceiver Laser Bias Current Instant**<br><br>Instantaneous value of the laser bias current for the transceiver (amps). |`TransceiverLaserBiasCurrentInstant` |Unspecified |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|
|**L1 - Transceiver Output Power Instant**<br><br>Instantaneous value of the output power for the transceiver (watts). |`TransceiverOutputPowerInstant` |Unspecified |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|
|**L1 - Transceiver Supply Voltage**<br><br>Instantaneous value of the supply voltage for the transceiver (volts). |`TransceiverSupplyVoltage` |Unspecified |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|

### Category: LLDP State Counters
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Lldp Frame In**<br><br>The number of lldp frames received. |`LldpFrameIn` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Lldp Frame Out**<br><br>The number of frames transmitted out. |`LldpFrameOut` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|
|**Lldp Tlv Discards**<br><br>Lldp Tlv Discards |`LldpTlvDiscard` |Count |Average, Minimum, Maximum, Total (Sum), Count |`InterfaceName`, `FabricId`|PT1M |Yes|
|**Lldp Tlv Unknown**<br><br>The number of frames received with unknown TLV. |`LldpTlvUnknown` |Count |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `InterfaceName`|PT1M |Yes|

### Category: Resource Utilization
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Cpu Utilization Avg**<br><br>Avg cpu utilization. The Avg value of the percentage measure of the statistic over the time interval. |`CpuUtilizationAvg` |Percent |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|
|**Cpu Utilization Instant**<br><br>Instantaneous Cpu utilization. The instantaneous value of the percentage measure of the statistic over the time interval. |`CpuUtilizationInstant` |Percent |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|
|**Cpu Utilization Max**<br><br>Max cpu utilization. The maximum value of the percentage measure of the statistic over the time interval. |`CpuUtilizationMax` |Percent |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|
|**Cpu Utilization Min**<br><br>Min cpu utilization. The minimum value of the percentage measure of the statistic over the time interval. |`CpuUtilizationMin` |Percent |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|
|**Fan Speed**<br><br>Current fan speed. |`FanSpeed` |Unspecified |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|
|**Memory Available**<br><br>The available memory physically installed, or logically allocated to the component. |`MemoryAvailable` |Bytes |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|
|**Memory Free**<br><br>Memory that is not used and is available for allocation. |`MemoryFree` |Bytes |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|
|**Memory Utilization Percentage**<br><br>The percentage of memory currently in use by processes running on the component, not considering reserved memory that is not available for use. |`MemoryUtilizationPercentage` |Percent |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|
|**Memory Utilized**<br><br>The memory currently in use by processes running on the component, not considering reserved memory that is not available for use. |`MemoryUtilized` |Bytes |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|
|**Power Supply Max Power Capacity**<br><br>Maximum power capacity of the power supply (watts). |`PowerSupplyCapacity` |Unspecified |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|
|**Power Supply Input Current**<br><br>The input current draw of the power supply (amps). |`PowerSupplyInputCurrent` |Unspecified |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|
|**Power Supply Input Voltage**<br><br>Input voltage to the power supply (volts). |`PowerSupplyInputVoltage` |Unspecified |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|
|**Power Supply Output Current**<br><br>The output current supplied by the power supply (amps) |`PowerSupplyOutputCurrent` |Unspecified |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|
|**Power Supply Output Power**<br><br>Output power supplied by the power supply (watts) |`PowerSupplyOutputPower` |Unspecified |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|
|**Power Supply Output Voltage**<br><br>Output voltage supplied by the power supply (volts). |`PowerSupplyOutputVoltage` |Unspecified |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|
|**Temperature Instantaneous**<br><br>The instantaneous value of temperature in degrees Celsius of the component. |`TemperatureInstant` |Unspecified |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|
|**Temperature Max**<br><br>Max temperature in degrees Celsius of the component. The maximum value of the statistic over the sampling period. |`TemperatureMax` |Unspecified |Average, Minimum, Maximum, Total (Sum), Count |`FabricId`, `ComponentName`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
