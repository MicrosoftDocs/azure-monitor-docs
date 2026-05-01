---
title: Supported metrics - Microsoft.Network/virtualNetworks
description: Reference for Microsoft.Network/virtualNetworks metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Network/virtualNetworks, arm

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Network/virtualNetworks

The following table lists the metrics available for the Microsoft.Network/virtualNetworks resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.Network/virtualNetworks](../supported-logs/microsoft-network-virtualnetworks-logs.md)


|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Inbound bytes dropped DDoS**<br><br>Inbound bytes dropped DDoS |`BytesDroppedDDoS` |BytesPerSecond |Maximum |`ProtectedIPAddress`|PT1M |Yes|
|**Inbound bytes forwarded DDoS**<br><br>Inbound bytes forwarded DDoS |`BytesForwardedDDoS` |BytesPerSecond |Maximum |`ProtectedIPAddress`|PT1M |Yes|
|**Inbound bytes DDoS**<br><br>Inbound bytes DDoS |`BytesInDDoS` |BytesPerSecond |Maximum |`ProtectedIPAddress`|PT1M |Yes|
|**Inbound SYN packets to trigger DDoS mitigation**<br><br>Inbound SYN packets to trigger DDoS mitigation |`DDoSTriggerSYNPackets` |CountPerSecond |Maximum |`ProtectedIPAddress`|PT1M |Yes|
|**Inbound TCP packets to trigger DDoS mitigation**<br><br>Inbound TCP packets to trigger DDoS mitigation |`DDoSTriggerTCPPackets` |CountPerSecond |Maximum |`ProtectedIPAddress`|PT1M |Yes|
|**Inbound UDP packets to trigger DDoS mitigation**<br><br>Inbound UDP packets to trigger DDoS mitigation |`DDoSTriggerUDPPackets` |CountPerSecond |Maximum |`ProtectedIPAddress`|PT1M |Yes|
|**Under DDoS attack or not**<br><br>Under DDoS attack or not |`IfUnderDDoSAttack` |Count |Maximum |`ProtectedIPAddress`|PT1M |Yes|
|**Inbound packets dropped DDoS**<br><br>Inbound packets dropped DDoS |`PacketsDroppedDDoS` |CountPerSecond |Maximum |`ProtectedIPAddress`|PT1M |Yes|
|**Inbound packets forwarded DDoS**<br><br>Inbound packets forwarded DDoS |`PacketsForwardedDDoS` |CountPerSecond |Maximum |`ProtectedIPAddress`|PT1M |Yes|
|**Inbound packets DDoS**<br><br>Inbound packets DDoS |`PacketsInDDoS` |CountPerSecond |Maximum |`ProtectedIPAddress`|PT1M |Yes|
|**Round trip time for Pings to a VM**<br><br>Round trip time for Pings sent to a destination VM |`PingMeshAverageRoundtripMs` |MilliSeconds |Average |`SourceCustomerAddress`, `DestinationCustomerAddress`|PT1M, PT1H |Yes|
|**Failed Pings to a VM**<br><br>Percent of number of failed Pings to total sent Pings of a destination VM |`PingMeshProbesFailedPercent` |Percent |Average |`SourceCustomerAddress`, `DestinationCustomerAddress`|PT1M, PT1H |Yes|
|**Inbound TCP bytes dropped DDoS**<br><br>Inbound TCP bytes dropped DDoS |`TCPBytesDroppedDDoS` |BytesPerSecond |Maximum |`ProtectedIPAddress`|PT1M |Yes|
|**Inbound TCP bytes forwarded DDoS**<br><br>Inbound TCP bytes forwarded DDoS |`TCPBytesForwardedDDoS` |BytesPerSecond |Maximum |`ProtectedIPAddress`|PT1M |Yes|
|**Inbound TCP bytes DDoS**<br><br>Inbound TCP bytes DDoS |`TCPBytesInDDoS` |BytesPerSecond |Maximum |`ProtectedIPAddress`|PT1M |Yes|
|**Inbound TCP packets dropped DDoS**<br><br>Inbound TCP packets dropped DDoS |`TCPPacketsDroppedDDoS` |CountPerSecond |Maximum |`ProtectedIPAddress`|PT1M |Yes|
|**Inbound TCP packets forwarded DDoS**<br><br>Inbound TCP packets forwarded DDoS |`TCPPacketsForwardedDDoS` |CountPerSecond |Maximum |`ProtectedIPAddress`|PT1M |Yes|
|**Inbound TCP packets DDoS**<br><br>Inbound TCP packets DDoS |`TCPPacketsInDDoS` |CountPerSecond |Maximum |`ProtectedIPAddress`|PT1M |Yes|
|**Inbound UDP bytes dropped DDoS**<br><br>Inbound UDP bytes dropped DDoS |`UDPBytesDroppedDDoS` |BytesPerSecond |Maximum |`ProtectedIPAddress`|PT1M |Yes|
|**Inbound UDP bytes forwarded DDoS**<br><br>Inbound UDP bytes forwarded DDoS |`UDPBytesForwardedDDoS` |BytesPerSecond |Maximum |`ProtectedIPAddress`|PT1M |Yes|
|**Inbound UDP bytes DDoS**<br><br>Inbound UDP bytes DDoS |`UDPBytesInDDoS` |BytesPerSecond |Maximum |`ProtectedIPAddress`|PT1M |Yes|
|**Inbound UDP packets dropped DDoS**<br><br>Inbound UDP packets dropped DDoS |`UDPPacketsDroppedDDoS` |CountPerSecond |Maximum |`ProtectedIPAddress`|PT1M |Yes|
|**Inbound UDP packets forwarded DDoS**<br><br>Inbound UDP packets forwarded DDoS |`UDPPacketsForwardedDDoS` |CountPerSecond |Maximum |`ProtectedIPAddress`|PT1M |Yes|
|**Inbound UDP packets DDoS**<br><br>Inbound UDP packets DDoS |`UDPPacketsInDDoS` |CountPerSecond |Maximum |`ProtectedIPAddress`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
