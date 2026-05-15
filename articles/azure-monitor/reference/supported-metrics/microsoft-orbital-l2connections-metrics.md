---
title: Supported metrics - Microsoft.Orbital/l2Connections
description: Reference for Microsoft.Orbital/l2Connections metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Orbital/l2Connections, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Orbital/l2Connections

The following table lists the metrics available for the Microsoft.Orbital/l2Connections resource type.

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



### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**In Edge Site Bit Rate**<br><br>Ingress Edge Site Bit Rate for the L2 connection |`InEdgeSiteBitsRate` |BitsPerSecond |Average, Minimum, Maximum, Total (Sum) |\<none\>|PT1M |Yes|
|**In Edge Site Broadcast Packet Count**<br><br>Ingress Edge Site Broadcast Packet Count for the L2 connection |`InEdgeSiteBroadcastPkts` |Count |Total (Sum), Average |\<none\>|PT1M |Yes|
|**In Edge Site Byte Count**<br><br>Ingress Edge Site Byte Count for the L2 connection |`InEdgeSiteBytes` |Count |Total (Sum), Average |\<none\>|PT1M |Yes|
|**In Edge Site Packet Discard Count**<br><br>Ingress Edge Site Packet Discard Count for the L2 connection |`InEdgeSiteDiscards` |Count |Total (Sum), Average |\<none\>|PT1M |Yes|
|**In Edge Site Multicast Packet Count**<br><br>Ingress Edge Site Multicast Packet Count for the L2 connection |`InEdgeSiteMulticastPkts` |Count |Total (Sum), Average |\<none\>|PT1M |Yes|
|**In Edge Site Packet Error Count**<br><br>Ingress Edge Site Packet Error Count for the L2 connection |`InEdgeSitePktErrors` |Count |Total (Sum), Average |\<none\>|PT1M |Yes|
|**In Edge Site Packet Rate**<br><br>Ingress Edge Site Packet Rate for the L2 connection |`InEdgeSitePktsRate` |CountPerSecond |Average, Minimum, Maximum, Total (Sum) |\<none\>|PT1M |Yes|
|**In Edge Site Unicast Packet Count**<br><br>Ingress Edge Site Unicast Packet Count for the L2 connection |`InEdgeSiteUnicastPkts` |Count |Total (Sum), Average |\<none\>|PT1M |Yes|
|**In Ground Station Bit Rate**<br><br>Ingress Ground Station Bit Rate for the L2 connection |`InGroundStationBitsRate` |BitsPerSecond |Average, Minimum, Maximum, Total (Sum) |\<none\>|PT1M |Yes|
|**In Ground Station Broadcast Packet Count**<br><br>Ingress Ground Station Broadcast Packet Count for the L2 connection |`InGroundStationBroadcastPkts` |Count |Total (Sum), Average |\<none\>|PT1M |Yes|
|**In Ground Station Byte Count**<br><br>Ingress Ground Station Byte Count for the L2 connection |`InGroundStationBytes` |Count |Total (Sum), Average |\<none\>|PT1M |Yes|
|**In Ground Station Packet Discard Count**<br><br>Ingress Ground Station Packet Discard Count for the L2 connection |`InGroundStationDiscards` |Count |Total (Sum), Average |\<none\>|PT1M |Yes|
|**In Ground Station Multicast Packet Count**<br><br>Ingress Ground Station Multicast Packet Count for the L2 connection |`InGroundStationMulticastPkts` |Count |Total (Sum), Average |\<none\>|PT1M |Yes|
|**In Ground Station Packet Error Count**<br><br>Ingress Ground Station Packet Error Count for the L2 connection |`InGroundStationPktErrors` |Count |Total (Sum), Average |\<none\>|PT1M |Yes|
|**In Ground Station Packet Rate**<br><br>Ingress Ground Station Packet Rate for the L2 connection |`InGroundStationPktsRate` |CountPerSecond |Average, Minimum, Maximum, Total (Sum) |\<none\>|PT1M |Yes|
|**In Ground Station Unicast Packet Count**<br><br>Ingress Ground Station Unicast Packet Count for the L2 connection |`InGroundStationUnicastPkts` |Count |Total (Sum), Average |\<none\>|PT1M |Yes|
|**Out Edge Site Bit Rate**<br><br>Egress Edge Site Bit Rate for the L2 connection |`OutEdgeSiteBitsRate` |BitsPerSecond |Average, Minimum, Maximum, Total (Sum) |\<none\>|PT1M |Yes|
|**Out Edge Site Broadcast Packet Count**<br><br>Egress Edge Site Broadcast Packet Count for the L2 connection |`OutEdgeSiteBroadcastPkts` |Count |Total (Sum), Average |\<none\>|PT1M |Yes|
|**Out Edge Site Byte Count**<br><br>Egress Edge Site Byte Count for the L2 connection |`OutEdgeSiteBytes` |Count |Total (Sum), Average |\<none\>|PT1M |Yes|
|**Out Edge Site Packet Discard Count**<br><br>Egress Edge Site Packet Discard Count for the L2 connection |`OutEdgeSiteDiscards` |Count |Total (Sum), Average |\<none\>|PT1M |Yes|
|**Out Edge Site Multicast Packet Count**<br><br>Egress Edge Site Multicast Packet Count for the L2 connection |`OutEdgeSiteMulticastPkts` |Count |Total (Sum), Average |\<none\>|PT1M |Yes|
|**Out Edge Site Packet Error Count**<br><br>Egress Edge Site Packet Error Count for the L2 connection |`OutEdgeSitePktErrors` |Count |Total (Sum), Average |\<none\>|PT1M |Yes|
|**Out Edge Site Packet Rate**<br><br>Egress Edge Site Packet Rate for the L2 connection |`OutEdgeSitePktsRate` |CountPerSecond |Average, Minimum, Maximum, Total (Sum) |\<none\>|PT1M |Yes|
|**Out Edge Site Unicast Packet Count**<br><br>Egress Edge Site Unicast Packet Count for the L2 connection |`OutEdgeSiteUnicastPkts` |Count |Total (Sum), Average |\<none\>|PT1M |Yes|
|**Out Ground Station Bit Rate**<br><br>Egress Ground Station Bit Rate for the L2 connection |`OutGroundStationBitsRate` |BitsPerSecond |Average, Minimum, Maximum, Total (Sum) |\<none\>|PT1M |Yes|
|**Out Ground Station Broadcast Packet Count**<br><br>Egress Ground Station Broadcast Packet Count for the L2 connection |`OutGroundStationBroadcastPkts` |Count |Total (Sum), Average |\<none\>|PT1M |Yes|
|**Out Ground Station Byte Count**<br><br>Egress Ground Station Byte Count for the L2 connection |`OutGroundStationBytes` |Count |Total (Sum), Average |\<none\>|PT1M |Yes|
|**Out Ground Station Packet Discard Count**<br><br>Egress Ground Station Packet Discard Count for the L2 connection |`OutGroundStationDiscards` |Count |Total (Sum), Average |\<none\>|PT1M |Yes|
|**Out Ground Station Multicast Packet Count**<br><br>Egress Ground Station Multicast Packet Count for the L2 connection |`OutGroundStationMulticastPkts` |Count |Total (Sum), Average |\<none\>|PT1M |Yes|
|**Out Ground Station Packet Error Count**<br><br>Egress Ground Station Packet Error Count for the L2 connection |`OutGroundStationPktErrors` |Count |Total (Sum), Average |\<none\>|PT1M |Yes|
|**Out Ground Station Packet Rate**<br><br>Egress Ground Station Packet Rate for the L2 connection |`OutGroundStationPktsRate` |CountPerSecond |Average, Minimum, Maximum, Total (Sum) |\<none\>|PT1M |Yes|
|**Out Ground Station Unicast Packet Count**<br><br>Egress Ground Station Unicast Packet Count for the L2 connection |`OutGroundStationUnicastPkts` |Count |Total (Sum), Average |\<none\>|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
