---
title: Supported metrics - Microsoft.MachineLearningServices/workspaces/onlineEndpoints/deployments
description: Reference for Microsoft.MachineLearningServices/workspaces/onlineEndpoints/deployments metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.MachineLearningServices/workspaces/onlineEndpoints/deployments, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.MachineLearningServices/workspaces/onlineEndpoints/deployments

The following table lists the metrics available for the Microsoft.MachineLearningServices/workspaces/onlineEndpoints/deployments resource type.

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



### Category: Resource
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**CPU Memory Utilization Percentage**<br><br>Percentage of memory utilization on an instance. Utilization is reported at one minute intervals. |`CpuMemoryUtilizationPercentage` |Percent |Minimum, Maximum, Average |`instanceId`|PT1M |Yes|
|**CPU Utilization Percentage**<br><br>Percentage of CPU utilization on an instance. Utilization is reported at one minute intervals. |`CpuUtilizationPercentage` |Percent |Minimum, Maximum, Average |`instanceId`|PT1M |Yes|
|**Data Collection Errors Per Minute**<br><br>The number of data collection events dropped per minute. |`DataCollectionErrorsPerMinute` |Count |Minimum, Maximum, Average |`instanceId`, `reason`, `type`|PT1M |No|
|**Data Collection Events Per Minute**<br><br>The number of data collection events processed per minute. |`DataCollectionEventsPerMinute` |Count |Minimum, Maximum, Average |`instanceId`, `type`|PT1M |No|
|**Deployment Capacity**<br><br>The number of instances in the deployment. |`DeploymentCapacity` |Count |Minimum, Maximum, Average |`instanceId`, `State`|PT1M |No|
|**Disk Utilization**<br><br>Percentage of disk utilization on an instance. Utilization is reported at one minute intervals. |`DiskUtilization` |Percent |Minimum, Maximum, Average |`instanceId`, `disk`|PT1M |Yes|
|**GPU Energy in Joules**<br><br>Interval energy in Joules on a GPU node. Energy is reported at one minute intervals. |`GpuEnergyJoules` |Count |Minimum, Maximum, Average |`instanceId`|PT1M |No|
|**GPU Memory Utilization Percentage**<br><br>Percentage of GPU memory utilization on an instance. Utilization is reported at one minute intervals. |`GpuMemoryUtilizationPercentage` |Percent |Minimum, Maximum, Average |`instanceId`|PT1M |Yes|
|**GPU Utilization Percentage**<br><br>Percentage of GPU utilization on an instance. Utilization is reported at one minute intervals. |`GpuUtilizationPercentage` |Percent |Minimum, Maximum, Average |`instanceId`|PT1M |Yes|

### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Request Latency P50**<br><br>The average P50 request latency aggregated by all request latency values collected over the selected time period |`RequestLatency_P50` |Milliseconds |Average |\<none\>|PT1M |Yes|
|**Request Latency P90**<br><br>The average P90 request latency aggregated by all request latency values collected over the selected time period |`RequestLatency_P90` |Milliseconds |Average |\<none\>|PT1M |Yes|
|**Request Latency P95**<br><br>The average P95 request latency aggregated by all request latency values collected over the selected time period |`RequestLatency_P95` |Milliseconds |Average |\<none\>|PT1M |Yes|
|**Request Latency P99**<br><br>The average P99 request latency aggregated by all request latency values collected over the selected time period |`RequestLatency_P99` |Milliseconds |Average |\<none\>|PT1M |Yes|
|**Requests Per Minute**<br><br>The number of requests sent to online deployment within a minute |`RequestsPerMinute` |Count |Average |`envoy_response_code`|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
