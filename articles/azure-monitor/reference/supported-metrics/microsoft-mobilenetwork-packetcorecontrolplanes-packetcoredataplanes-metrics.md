---
title: Supported metrics - Microsoft.MobileNetwork/packetcorecontrolplanes/packetcoredataplanes
description: Reference for Microsoft.MobileNetwork/packetcorecontrolplanes/packetcoredataplanes metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: Microsoft.MobileNetwork/packetcorecontrolplanes/packetcoredataplanes, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.MobileNetwork/packetcorecontrolplanes/packetcoredataplanes

The following table lists the metrics available for the Microsoft.MobileNetwork/packetcorecontrolplanes/packetcoredataplanes resource type.

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



### Category: Traffic
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Data Plane Bandwidth**<br><br>Data plane bandwidth for all traffic types (bits/second). |`DataPlaneBandwidth` | No | BitsPerSecond |Total (Sum) |`SiteId`, `Direction`, `Interface`|PT1M |No|
|**Data Plane Packet Drop Rate**<br><br>Data plane packet drop rate for all traffic types (packets/sec). |`DataPlanePacketDropRate` | No | CountPerSecond |Total (Sum) |`SiteId`, `Cause`, `Direction`, `Interface`|PT1M |No|
|**Data Plane Packet Rate**<br><br>Data plane packet rate for all traffic types (packets/sec). |`DataPlanePacketRate` | No | CountPerSecond |Total (Sum) |`SiteId`, `Direction`, `Interface`, `Result`|PT1M |No|
|**ICMP Pinhole Packet Count**<br><br>The number of ICMP packets that have created a pinhole, been forwarded upstream or forwarded downstream. |`ICMPPinholePacketCount` | No | Count |Total (Sum) |`SiteId`, `type`, `Dnn`|PT1M |No|
|**N3 Bandwidth**<br><br>N3 bandwidth for all traffic types (bits/second) per RanId. |`N3Bandwidth` | No | BitsPerSecond |Total (Sum) |`SiteId`, `Direction`, `RanId`|PT1M |No|
|**N3 Packet Rate**<br><br>N3 packet rate for all traffic types (packets/sec). |`N3PacketRate` | No | CountPerSecond |Total (Sum) |`SiteId`, `Direction`|PT1M |No|
|**N6 Bandwidth**<br><br>N6 bandwidth for all traffic types (bits/second). |`N6Bandwidth` | No | BitsPerSecond |Total (Sum) |`SiteId`, `Direction`, `Dnn`|PT1M |No|
|**N6 Packet Rate**<br><br>N6 packet rate for all traffic types (packets/sec). |`N6PacketRate` | No | CountPerSecond |Total (Sum) |`SiteId`, `Direction`, `Dnn`|PT1M |No|
|**Pinholes protocol limit exceeded**<br><br>The number of pinholes rejected due to the per-interface per-protocol limit. |`PinholeProtocolLimitExceeded` | No | Count |Total (Sum) |`SiteId`, `Type`|PT1M |No|
|**Pinholes Active**<br><br>The current number of dynamic match actions created. TCP and UDP pinholes consist of 3 dynamic match actions, ICMP echo pinholes consist of 2 |`PinholesActive` | No | Count |Total (Sum) |`SiteId`, `Type`, `Interface`|PT1M |No|
|**Pinhole Creation Rate**<br><br>The total number of dynamic match actions created. TCP and UDP pinholes consist of 3 dynamic match actions, ICMP echo pinholes consist of 2. |`PinholesCreationRate` | No | Count |Total (Sum) |`SiteId`, `Type`, `Interface`|PT1M |No|
|**Pinholes failures**<br><br>The number of times learning has failed for each learn action. |`PinholesFailures` | No | Count |Total (Sum) |`SiteId`, `Type`, `Interface`|PT1M |No|
|**Pinholes Timeout Rate**<br><br>The number of dynamic match actions that have timed out due to inactivity. TCP and UDP pinholes consist of 3 dynamic match actions, ICMP echo pinholes consist of 2. |`PinholesTimeoutRate` | No | Count |Total (Sum) |`SiteId`, `Type`, `Interface`|PT1M |No|
|**Pinhole UE limit exceeded**<br><br>The number of pinholes rejected due to the per-source IP address limit. |`PinholesUELimitExceeded` | No | Count |Total (Sum) |`SiteId`, `Type`|PT1M |No|
|**Tcp Pinhole Packet Count**<br><br>The number of TCP packets that have created a pinhole, been forwarded upstream or forwarded downstream. |`TcpPinholePacketCount` | No | Count |Total (Sum) |`SiteId`, `type`, `Dnn`|PT1M |No|
|**Total N3 Bandwidth**<br><br>Total N3 bandwidth for all traffic types (bits/second) per interface. |`TotalN3Bandwidth` | No | BitsPerSecond |Total (Sum) |`SiteId`, `Direction`|PT1M |No|
|**UDP Pinhole Packet Count**<br><br>The number of UDP packets that have created a pinhole, been forwarded upstream or forwarded downstream. |`UdpPinholePacketCount` | No | Count |Total (Sum) |`SiteId`, `type`, `Dnn`|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
