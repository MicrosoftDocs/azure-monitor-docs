---
title: Supported metrics - Microsoft.App/jobs
description: Reference for Microsoft.App/jobs metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.App/jobs, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.App/jobs

The following table lists the metrics available for the Microsoft.App/jobs resource type.

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



### Category: Basic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Job Executions**<br><br>Executions run by the Container Apps Job |`Executions` |Count |Average, Total (Sum), Maximum, Minimum |`state`, `jobName`, `executionName`|PT1M |Yes|
|**Requested Bytes**<br><br>Container App Job memory requests of customer containers in bytes. |`RequestedBytes` |Bytes |Total (Sum), Average, Maximum, Minimum |`state`, `jobName`, `executionName`|PT1M |Yes|
|**Requested Cores**<br><br>Container App Job requested cpu in cores. |`RequestedCores` |Cores |Total (Sum), Average, Maximum, Minimum |`state`, `jobName`, `executionName`|PT1M |Yes|
|**Total Job Execution Restart Count**<br><br>The cumulative number of times container app job execution has restarted since it was created. |`RestartCount` |Count |Average, Total (Sum), Maximum, Minimum |`state`, `jobName`, `executionName`|PT1M |Yes|
|**Network In Bytes**<br><br>Network received bytes |`RxBytes` |Bytes |Average, Total (Sum), Maximum, Minimum |`state`, `jobName`, `executionName`|PT1M |Yes|
|**Network Out Bytes**<br><br>Network transmitted bytes |`TxBytes` |Bytes |Average, Total (Sum), Maximum, Minimum |`state`, `jobName`, `executionName`|PT1M |Yes|
|**Usage Bytes**<br><br>Container App Job memory used in bytes. |`UsageBytes` |Bytes |Total (Sum), Average, Maximum, Minimum |`state`, `jobName`, `executionName`|PT1M |Yes|
|**CPU Usage**<br><br>CPU consumed by the container app job, in nano cores. 1,000,000,000 nano cores = 1 core |`UsageNanoCores` |NanoCores |Total (Sum), Average, Maximum, Minimum |`state`, `jobName`, `executionName`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
