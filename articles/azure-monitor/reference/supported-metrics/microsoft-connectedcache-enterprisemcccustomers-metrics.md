---
title: Supported metrics - Microsoft.ConnectedCache/enterpriseMccCustomers
description: Reference for Microsoft.ConnectedCache/enterpriseMccCustomers metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.ConnectedCache/enterpriseMccCustomers, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.ConnectedCache/enterpriseMccCustomers

The following table lists the metrics available for the Microsoft.ConnectedCache/enterpriseMccCustomers resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.ConnectedCache/enterpriseMccCustomers](../supported-logs/microsoft-connectedcache-enterprisemcccustomers-logs.md)


|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Egress Mbps**<br><br>Egress Throughput |`egressbps` |BitsPerSecond |Average |`cachenodeid`, `Hostname`|PT1M |Yes|
|**Egress Volume**<br><br>Volume of data egressed |`egressBytes` |Bytes |Average |`cachenodeid`, `Hostname`, `cachenodename`|PT1M |Yes|
|**Hit Ratio**<br><br>Cache hit ratio is a measurement of how many content requests a cache is able to fill successfully, compared to how many requests it receives. |`hitRatio` |Percent |Average |`cachenodeid`|PT1M |Yes|
|**Hits**<br><br>Count of hits |`hits` |Count |Count |`cachenodeid`|PT1M |Yes|
|**Hit Mbps**<br><br>Hit Throughput |`hitsbps` |BitsPerSecond |Average |`cachenodeid`|PT1M |Yes|
|**Inbound**<br><br>Inbound Throughput |`inboundbps` |BitsPerSecond |Average |`cachenodeid`|PT1M |Yes|
|**Misses**<br><br>Count of misses |`misses` |Count |Count |`cachenodeid`|PT1M |Yes|
|**Miss Mbps**<br><br>Miss Throughput |`missesbps` |BitsPerSecond |Average |`cachenodeid`|PT1M |Yes|
|**Outbound**<br><br>Outbound Throughput |`outboundbps` |BitsPerSecond |Average |`cachenodeid`, `cachenodename`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
