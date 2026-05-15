---
title: Supported metrics - Microsoft.CloudHealth/healthmodels
description: Reference for Microsoft.CloudHealth/healthmodels metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/28/2026
ms.custom: Microsoft.CloudHealth/healthmodels, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.CloudHealth/healthmodels

The following table lists the metrics available for the Microsoft.CloudHealth/healthmodels resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.CloudHealth/healthmodels](../supported-logs/microsoft-cloudhealth-healthmodels-logs.md)


### Category: Latency
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Discovery rule execution duration**<br><br>Duration of discovery rule execution in milliseconds. |`DiscoveryRuleExecutionDuration` |Milliseconds |Average, Minimum, Maximum |`discovery_rule.name`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|

### Category: Saturation
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Number of discovery rules in health model**<br><br>Current number of discovery rules in the health model. |`DiscoveryRuleCount` |Count |Minimum, Maximum, Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Number of entities in health model**<br><br>Current number of entities in the health model. |`EntityCount` |Count |Minimum, Maximum, Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Number of relationships in health model**<br><br>Current number of relationships in the health model. |`RelationshipCount` |Count |Minimum, Maximum, Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|

### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Discovery rule entities discovered count**<br><br>Number of entities discovered by a discovery rule execution. |`DiscoveryRuleEntitiesDiscoveredCount` |Count |Minimum, Maximum, Average |`discovery_rule.name`|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
