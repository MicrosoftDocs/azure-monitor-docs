---
title: Supported metrics - Microsoft.Peering/peerings
description: Reference for Microsoft.Peering/peerings metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Peering/peerings, arm

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Peering/peerings

The following table lists the metrics available for the Microsoft.Peering/peerings resource type.

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



|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Average Customer Prefix Latency**<br><br>Average of median Customer prefix latency |`AverageCustomerPrefixLatency` |Milliseconds |Average |`RegisteredAsnName`|PT1H |Yes|
|**Average Connectivity Probe Availability**<br><br>Average of connectivity probe availability |`ConnectivityProbeAvailability` |Percent |Average |`Protocol`|PT1M, PT5M, PT30M, PT1H, PT6H, P1D |Yes|
|**Average Connectivity Probe Jitter**<br><br>Average of connectivity probe jitter |`ConnectivityProbeJitter` |Milliseconds |Average |`Protocol`|PT1M, PT5M, PT30M, PT1H, PT6H, P1D |Yes|
|**Average Connectivity Probe Latency**<br><br>Average of connectivity probe latency |`ConnectivityProbeLatency` |Milliseconds |Average |`Protocol`|PT1M, PT5M, PT30M, PT1H, PT6H, P1D |Yes|
|**Egress Traffic Rate**<br><br>Egress traffic rate in bits per second |`EgressTrafficRate` |BitsPerSecond |Average |`ConnectionId`, `SessionIp`, `TrafficClass`|PT1M, PT5M, PT1H |Yes|
|**Connection Flap Events Count**<br><br>Flap Events Count in all the connection |`FlapCounts` |Count |Sum |`ConnectionId`, `SessionIp`|PT1M, PT5M, PT1H |Yes|
|**Ingress Traffic Rate**<br><br>Ingress traffic rate in bits per second |`IngressTrafficRate` |BitsPerSecond |Average |`ConnectionId`, `SessionIp`, `TrafficClass`|PT1M, PT5M, PT1H |Yes|
|**Packets Drop Rate**<br><br>Packets Drop rate in bits per second |`PacketDropRate` |BitsPerSecond |Average |`ConnectionId`, `SessionIp`, `TrafficClass`|PT1M, PT5M, PT1H |Yes|
|**Prefix Latency**<br><br>Median prefix latency |`RegisteredPrefixLatency` |Milliseconds |Average |`RegisteredPrefixName`|PT1H |Yes|
|**Session Availability**<br><br>Availability of the peering session |`SessionAvailability` |Count |Average |`ConnectionId`, `SessionIp`|PT5M, PT1H |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
