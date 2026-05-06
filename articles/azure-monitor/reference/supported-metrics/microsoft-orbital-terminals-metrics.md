---
title: Supported metrics - Microsoft.Orbital/terminals
description: Reference for Microsoft.Orbital/terminals metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Orbital/terminals, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Orbital/terminals

The following table lists the metrics available for the Microsoft.Orbital/terminals resource type.

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



### Category: Error
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**SDWAN alarms**<br><br>SDWAN alarms |`JuniperAlarm` |Count |Total (Sum), Count |`category`, `id`, `message`, `node`, `number`, `process`, `router`, `severity`, `shelvedReason`, `source`, `time`|PT1M |Yes|

### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Satcom SDWAN bandwidth**<br><br>Satcom SDWAN bandwidth in bytes per second |`JuniperSsrBandwidthBytesPerSecond` |BytesPerSecond |Average |\<none\>|PT1M |Yes|
|**Satcom SDWAN bytes**<br><br>Satcom SDWAN total bytes |`JuniperSsrBytes` |Bytes |Average |\<none\>|PT1M |Yes|
|**Satcom SDWAN packet loss**<br><br>Satcom SDWAN total packets lost |`JuniperSsrPacketLoss` |Count |Average |\<none\>|PT1M |Yes|
|**Satcom VPN gateway incoming bytes**<br><br>Satcom VPN gateway total incoming bytes |`TunnelIncomingTotalBytes` |Bytes |Average |\<none\>|PT1M |Yes|
|**Satcom VPN gateway outgoing bytes**<br><br>Satcom VPN gateway total outgoing bytes |`TunnelOutgoingTotalBytes` |Bytes |Average |\<none\>|PT1M |Yes|
|**Satcom VPN gateway bandwidth**<br><br>Satcom VPN gateway bandwidth in bytes per second |`TunnelTotalBandwidthBytesPerSecond` |BytesPerSecond |Average |\<none\>|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
