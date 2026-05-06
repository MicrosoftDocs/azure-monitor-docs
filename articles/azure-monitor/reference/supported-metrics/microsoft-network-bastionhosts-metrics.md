---
title: Supported metrics - microsoft.network/bastionHosts
description: Reference for microsoft.network/bastionHosts metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: microsoft.network/bastionHosts, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for microsoft.network/bastionHosts

The following table lists the metrics available for the microsoft.network/bastionHosts resource type.

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


For a list of supported logs, see [Supported log categories - microsoft.network/bastionHosts](../supported-logs/microsoft-network-bastionhosts-logs.md)


### Category: Availability
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Bastion Communication Status**<br><br>Communication status shows 1 if all communication is good and 0 if its bad. |`pingmesh` |Count |Average |\<none\>|PT1M |No|

### Category: Saturation
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Total Memory**<br><br>Total memory stats. |`total` |Count |Average |`host`|PT1M |Yes|
|**CPU Usage**<br><br>CPU Usage stats. |`usage_user` |Count |Average |`cpu`, `host`|PT1M |No|
|**Memory Usage**<br><br>Memory Usage stats. |`used` |Count |Average |`host`|PT1M |Yes|

### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Session Count**<br><br>Sessions Count for the Bastion. View in sum and per instance. |`sessions` |Count |Total (Sum), Average |`host`|PT5M, PT15M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
