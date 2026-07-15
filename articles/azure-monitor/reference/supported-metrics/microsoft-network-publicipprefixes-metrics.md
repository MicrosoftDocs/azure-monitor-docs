---
title: Supported metrics - Microsoft.Network/publicIPPrefixes
description: Reference for Microsoft.Network/publicIPPrefixes metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: Microsoft.Network/publicIPPrefixes, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Network/publicIPPrefixes

The following table lists the metrics available for the Microsoft.Network/publicIPPrefixes resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.Network/publicIPPrefixes](../supported-logs/microsoft-network-publicipprefixes-logs.md)


|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Inbound bytes dropped DDoS**<br><br>Inbound bytes dropped DDoS |`BytesDroppedDDoS` | No | BytesPerSecond |Maximum |`DestinationVIP`|PT1M |Yes|
|**Inbound bytes forwarded DDoS**<br><br>Inbound bytes forwarded DDoS |`BytesForwardedDDoS` | No | BytesPerSecond |Maximum |`DestinationVIP`|PT1M |Yes|
|**Inbound bytes DDoS**<br><br>Inbound bytes DDoS |`BytesInDDoS` | No | BytesPerSecond |Maximum |`DestinationVIP`|PT1M |Yes|
|**Inbound SYN packets to trigger DDoS mitigation**<br><br>Inbound SYN packets to trigger DDoS mitigation |`DDoSTriggerSYNPackets` | No | CountPerSecond |Maximum |`DestinationVIP`|PT1M |Yes|
|**Inbound TCP packets to trigger DDoS mitigation**<br><br>Inbound TCP packets to trigger DDoS mitigation |`DDoSTriggerTCPPackets` | No | CountPerSecond |Maximum |`DestinationVIP`|PT1M |Yes|
|**Inbound UDP packets to trigger DDoS mitigation**<br><br>Inbound UDP packets to trigger DDoS mitigation |`DDoSTriggerUDPPackets` | No | CountPerSecond |Maximum |`DestinationVIP`|PT1M |Yes|
|**Under DDoS attack or not**<br><br>Under DDoS attack or not |`IfUnderDDoSAttack` | No | Count |Maximum |`DestinationVIP`|PT1M |Yes|
|**Inbound packets dropped DDoS**<br><br>Inbound packets dropped DDoS |`PacketsDroppedDDoS` | No | CountPerSecond |Maximum |`DestinationVIP`|PT1M |Yes|
|**Inbound packets forwarded DDoS**<br><br>Inbound packets forwarded DDoS |`PacketsForwardedDDoS` | No | CountPerSecond |Maximum |`DestinationVIP`|PT1M |Yes|
|**Inbound packets DDoS**<br><br>Inbound packets DDoS |`PacketsInDDoS` | No | CountPerSecond |Maximum |`DestinationVIP`|PT1M |Yes|
|**Inbound TCP bytes dropped DDoS**<br><br>Inbound TCP bytes dropped DDoS |`TCPBytesDroppedDDoS` | No | BytesPerSecond |Maximum |`DestinationVIP`|PT1M |Yes|
|**Inbound TCP bytes forwarded DDoS**<br><br>Inbound TCP bytes forwarded DDoS |`TCPBytesForwardedDDoS` | No | BytesPerSecond |Maximum |`DestinationVIP`|PT1M |Yes|
|**Inbound TCP bytes DDoS**<br><br>Inbound TCP bytes DDoS |`TCPBytesInDDoS` | No | BytesPerSecond |Maximum |`DestinationVIP`|PT1M |Yes|
|**Inbound TCP packets dropped DDoS**<br><br>Inbound TCP packets dropped DDoS |`TCPPacketsDroppedDDoS` | No | CountPerSecond |Maximum |`DestinationVIP`|PT1M |Yes|
|**Inbound TCP packets forwarded DDoS**<br><br>Inbound TCP packets forwarded DDoS |`TCPPacketsForwardedDDoS` | No | CountPerSecond |Maximum |`DestinationVIP`|PT1M |Yes|
|**Inbound TCP packets DDoS**<br><br>Inbound TCP packets DDoS |`TCPPacketsInDDoS` | No | CountPerSecond |Maximum |`DestinationVIP`|PT1M |Yes|
|**Inbound UDP bytes dropped DDoS**<br><br>Inbound UDP bytes dropped DDoS |`UDPBytesDroppedDDoS` | No | BytesPerSecond |Maximum |`DestinationVIP`|PT1M |Yes|
|**Inbound UDP bytes forwarded DDoS**<br><br>Inbound UDP bytes forwarded DDoS |`UDPBytesForwardedDDoS` | No | BytesPerSecond |Maximum |`DestinationVIP`|PT1M |Yes|
|**Inbound UDP bytes DDoS**<br><br>Inbound UDP bytes DDoS |`UDPBytesInDDoS` | No | BytesPerSecond |Maximum |`DestinationVIP`|PT1M |Yes|
|**Inbound UDP packets dropped DDoS**<br><br>Inbound UDP packets dropped DDoS |`UDPPacketsDroppedDDoS` | No | CountPerSecond |Maximum |`DestinationVIP`|PT1M |Yes|
|**Inbound UDP packets forwarded DDoS**<br><br>Inbound UDP packets forwarded DDoS |`UDPPacketsForwardedDDoS` | No | CountPerSecond |Maximum |`DestinationVIP`|PT1M |Yes|
|**Inbound UDP packets DDoS**<br><br>Inbound UDP packets DDoS |`UDPPacketsInDDoS` | No | CountPerSecond |Maximum |`DestinationVIP`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
