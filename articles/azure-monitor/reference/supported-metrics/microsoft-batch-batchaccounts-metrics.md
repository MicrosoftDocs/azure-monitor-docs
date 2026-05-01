---
title: Supported metrics - Microsoft.Batch/batchaccounts
description: Reference for Microsoft.Batch/batchaccounts metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Batch/batchaccounts, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Batch/batchaccounts

The following table lists the metrics available for the Microsoft.Batch/batchaccounts resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.Batch/batchaccounts](../supported-logs/microsoft-batch-batchaccounts-logs.md)


|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Dedicated Core Count**<br><br>Total number of dedicated cores in the batch account |`CoreCount` |Count |Total (Sum) |\<none\>|PT1M |No|
|**Creating Node Count**<br><br>Number of nodes being created |`CreatingNodeCount` |Count |Total (Sum) |\<none\>|PT1M |No|
|**Idle Node Count**<br><br>Number of idle nodes |`IdleNodeCount` |Count |Total (Sum) |\<none\>|PT1M |No|
|**Job Delete Complete Events**<br><br>Total number of jobs that have been successfully deleted. |`JobDeleteCompleteEvent` |Count |Total (Sum) |`jobId`|PT1M |Yes|
|**Job Delete Start Events**<br><br>Total number of jobs that have been requested to be deleted. |`JobDeleteStartEvent` |Count |Total (Sum) |`jobId`|PT1M |Yes|
|**Job Disable Complete Events**<br><br>Total number of jobs that have been successfully disabled. |`JobDisableCompleteEvent` |Count |Total (Sum) |`jobId`|PT1M |Yes|
|**Job Disable Start Events**<br><br>Total number of jobs that have been requested to be disabled. |`JobDisableStartEvent` |Count |Total (Sum) |`jobId`|PT1M |Yes|
|**Job Start Events**<br><br>Total number of jobs that have been successfully started. |`JobStartEvent` |Count |Total (Sum) |`jobId`|PT1M |Yes|
|**Job Terminate Complete Events**<br><br>Total number of jobs that have been successfully terminated. |`JobTerminateCompleteEvent` |Count |Total (Sum) |`jobId`|PT1M |Yes|
|**Job Terminate Start Events**<br><br>Total number of jobs that have been requested to be terminated. |`JobTerminateStartEvent` |Count |Total (Sum) |`jobId`|PT1M |Yes|
|**Leaving Pool Node Count**<br><br>Number of nodes leaving the Pool |`LeavingPoolNodeCount` |Count |Total (Sum) |\<none\>|PT1M |No|
|**LowPriority Core Count**<br><br>Total number of low-priority cores in the batch account |`LowPriorityCoreCount` |Count |Total (Sum) |\<none\>|PT1M |No|
|**Offline Node Count**<br><br>Number of offline nodes |`OfflineNodeCount` |Count |Total (Sum) |\<none\>|PT1M |No|
|**Pool Create Events**<br><br>Total number of pools that have been created |`PoolCreateEvent` |Count |Total (Sum) |`poolId`|PT1M |Yes|
|**Pool Delete Complete Events**<br><br>Total number of pool deletes that have completed |`PoolDeleteCompleteEvent` |Count |Total (Sum) |`poolId`|PT1M |Yes|
|**Pool Delete Start Events**<br><br>Total number of pool deletes that have started |`PoolDeleteStartEvent` |Count |Total (Sum) |`poolId`|PT1M |Yes|
|**Pool Resize Complete Events**<br><br>Total number of pool resizes that have completed |`PoolResizeCompleteEvent` |Count |Total (Sum) |`poolId`|PT1M |Yes|
|**Pool Resize Start Events**<br><br>Total number of pool resizes that have started |`PoolResizeStartEvent` |Count |Total (Sum) |`poolId`|PT1M |Yes|
|**Preempted Node Count**<br><br>Number of preempted nodes |`PreemptedNodeCount` |Count |Total (Sum) |\<none\>|PT1M |No|
|**Rebooting Node Count**<br><br>Number of rebooting nodes |`RebootingNodeCount` |Count |Total (Sum) |\<none\>|PT1M |No|
|**Reimaging Node Count**<br><br>Number of reimaging nodes |`ReimagingNodeCount` |Count |Total (Sum) |\<none\>|PT1M |No|
|**Running Node Count**<br><br>Number of running nodes |`RunningNodeCount` |Count |Total (Sum) |\<none\>|PT1M |No|
|**Starting Node Count**<br><br>Number of nodes starting |`StartingNodeCount` |Count |Total (Sum) |\<none\>|PT1M |No|
|**Start Task Failed Node Count**<br><br>Number of nodes where the Start Task has failed |`StartTaskFailedNodeCount` |Count |Total (Sum) |\<none\>|PT1M |No|
|**Task Complete Events**<br><br>Total number of tasks that have completed |`TaskCompleteEvent` |Count |Total (Sum) |`poolId`, `jobId`|PT1M |Yes|
|**Task Fail Events**<br><br>Total number of tasks that have completed in a failed state |`TaskFailEvent` |Count |Total (Sum) |`poolId`, `jobId`|PT1M |Yes|
|**Task Start Events**<br><br>Total number of tasks that have started |`TaskStartEvent` |Count |Total (Sum) |`poolId`, `jobId`|PT1M |Yes|
|**Low-Priority Node Count**<br><br>Total number of low-priority nodes in the batch account |`TotalLowPriorityNodeCount` |Count |Total (Sum) |\<none\>|PT1M |No|
|**Dedicated Node Count**<br><br>Total number of dedicated nodes in the batch account |`TotalNodeCount` |Count |Total (Sum) |\<none\>|PT1M |No|
|**Unusable Node Count**<br><br>Number of unusable nodes |`UnusableNodeCount` |Count |Total (Sum) |\<none\>|PT1M |No|
|**Waiting For Start Task Node Count**<br><br>Number of nodes waiting for the Start Task to complete |`WaitingForStartTaskNodeCount` |Count |Total (Sum) |\<none\>|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
