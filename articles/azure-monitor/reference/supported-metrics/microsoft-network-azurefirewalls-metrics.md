---
title: Supported metrics - Microsoft.Network/azureFirewalls
description: Reference for Microsoft.Network/azureFirewalls metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Network/azureFirewalls, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Network/azureFirewalls

The following table lists the metrics available for the Microsoft.Network/azureFirewalls resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.Network/azureFirewalls](../supported-logs/microsoft-network-azurefirewalls-logs.md)


|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Application rules hit count**<br><br>Number of times Application rules were hit |`ApplicationRuleHit` |Count |Total (Sum) |`Status`, `Reason`, `Protocol`|PT1M |Yes|
|**Data processed**<br><br>Total amount of data processed by this firewall |`DataProcessed` |Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**Firewall health state**<br><br>Indicates the overall health of this firewall |`FirewallHealth` |Percent |Average |`Status`, `Reason`|PT1M |Yes|
|**Latency Probe (Preview)**<br><br>Estimate of the average latency of the Firewall as measured by latency probe |`FirewallLatencyPng` |Milliseconds |Average |\<none\>|PT1M |Yes|
|**Network rules hit count**<br><br>Number of times Network rules were hit |`NetworkRuleHit` |Count |Total (Sum) |`Status`, `Reason`|PT1M |Yes|
|**Observed Capacity Units**<br><br>Reported number of capacity units for the Azure Firewall |`ObservedCapacity` |Unspecified |Average, Minimum, Maximum |\<none\>|PT1M |Yes|
|**SNAT port utilization**<br><br>Percentage of outbound SNAT ports currently in use |`SNATPortUtilization` |Percent |Average, Maximum |`Protocol`|PT1M |Yes|
|**Throughput**<br><br>Throughput processed by this firewall |`Throughput` |BitsPerSecond |Average |\<none\>|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
