---
title: Supported metrics - Microsoft.Network/virtualnetworkappliances
description: Reference for Microsoft.Network/virtualnetworkappliances metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 05/29/2026
ms.custom: Microsoft.Network/virtualnetworkappliances, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Network/virtualnetworkappliances

The following table lists the metrics available for the Microsoft.Network/virtualnetworkappliances resource type.

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
|**Bytes Received**<br><br>Number of bytes the Network Interface received |`BytesReceived` |Bytes |Total (Sum) |\<none\>|PT1M |No|
|**Bytes Sent**<br><br>Number of bytes the Network Interface sent |`BytesSent` |Bytes |Total (Sum) |\<none\>|PT1M |No|
|**Inbound Flows Maximum Creation Rate**<br><br>The maximum creation rate of inbound flows (traffic going into the NIC) |`CreationRateMaxTotalFlowsIn` |CountPerSecond |Average |\<none\>|PT1M |No|
|**Outbound Flows Maximum Creation Rate**<br><br>The maximum creation rate of outbound flows (traffic going out of the NIC) |`CreationRateMaxTotalFlowsOut` |CountPerSecond |Average |\<none\>|PT1M |No|
|**Inbound Flows**<br><br>Inbound Flows are number of current flows in the inbound direction (traffic going into the NIC) |`CurrentTotalFlowsIn` |Count |Average |\<none\>|PT1M |No|
|**Outbound Flows**<br><br>Outbound Flows are number of current flows in the outbound direction (traffic going out of the NIC) |`CurrentTotalFlowsOut` |Count |Average |\<none\>|PT1M |No|
|**Packets Received**<br><br>Number of packets the Network Interface received |`PacketsReceived` |Count |Total (Sum) |\<none\>|PT1M |No|
|**Packets Sent**<br><br>Number of packets the Network Interface sent |`PacketsSent` |Count |Total (Sum) |\<none\>|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
