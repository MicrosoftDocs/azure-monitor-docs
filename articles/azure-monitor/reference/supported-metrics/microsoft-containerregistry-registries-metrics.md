---
title: Supported metrics - Microsoft.ContainerRegistry/registries
description: Reference for Microsoft.ContainerRegistry/registries metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.ContainerRegistry/registries, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.ContainerRegistry/registries

The following table lists the metrics available for the Microsoft.ContainerRegistry/registries resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.ContainerRegistry/registries](../supported-logs/microsoft-containerregistry-registries-logs.md)


|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**AgentPool CPU Time**<br><br>AgentPool CPU Time in seconds |`AgentPoolCPUTime` |Seconds |Total (Sum) |\<none\>|PT1M |Yes|
|**Run Duration**<br><br>Run Duration in milliseconds |`RunDuration` |MilliSeconds |Total (Sum) |\<none\>|PT1M |Yes|
|**Storage used**<br><br>The amount of storage used by the container registry. For a registry account, it's the sum of capacity used by all the repositories within a registry. It's sum of capacity used by shared layers, manifest files, and replica copies in each of its repositories. |`StorageUsed` |Bytes |Average |`Geolocation`|PT1H |Yes|
|**Successful Pull Count**<br><br>Number of successful image pulls |`SuccessfulPullCount` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Successful Push Count**<br><br>Number of successful image pushes |`SuccessfulPushCount` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Total Pull Count**<br><br>Number of image pulls in total |`TotalPullCount` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Total Push Count**<br><br>Number of image pushes in total |`TotalPushCount` |Count |Total (Sum) |\<none\>|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
