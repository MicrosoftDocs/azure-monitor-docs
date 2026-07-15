---
title: Supported metrics - Microsoft.Batch/batchaccounts
description: Reference for Microsoft.Batch/batchaccounts metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: Microsoft.Batch/batchaccounts, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Batch/batchaccounts

The following table lists the metrics available for the Microsoft.Batch/batchaccounts resource type.

**Table headings**

- **Metric** - The metric display name as it appears in the Azure portal.
- **Name in Rest API** - Metric name as referred to in the [REST API](/azure/azure-monitor/essentials/rest-api-walkthrough).
- **Advanced platform metrics** - A premium, [paid tier of platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform) in Azure Monitor that provide more granular observability for Azure resources.
- **Unit** - Unit of measure.
- **Aggregation** - The default [aggregation](/azure/azure-monitor/essentials/metrics-aggregation-explained) type. Valid values: Average, Minimum, Maximum, Total, Count.
- **Dimensions** - [Dimensions](/azure/azure-monitor/essentials/metrics-aggregation-explained#dimensions-splitting-and-filtering) available for the metric.
- **Time Grains** - [Intervals at which the metric is sampled](/azure/azure-monitor/essentials/metrics-aggregation-explained#granularity). For example, `PT1M` indicates that the metric is sampled every minute, `PT30M` every 30 minutes, `PT1H` every hour, and so on.
- **DS Export** -S Whether the metric is exportable to Azure Monitor Logs via Diagnostic Settings.

For information on exporting metrics, see - [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics) and [Create diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/create-diagnostic-settings?tabs=portal).

For information on metric retention, see [Azure Monitor Metrics overview](/azure/azure-monitor/essentials/data-platform-metrics#retention-of-metrics).


For a list of supported logs, see [Supported log categories - Microsoft.Batch/batchaccounts](../supported-logs/microsoft-batch-batchaccounts-logs.md)


### Category: API
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**API Request Count**<br><br>Number of API requests made to the service |`ApiCount` | No | Count |Total (Sum) |`operation`, `result`|PT1M |Yes|
|**API Request Duration**<br><br>Duration the server spends handling an API request in milliseconds - measured from the time a request is received to the time a response is sent |`ApiDuration` | No | MilliSeconds |Average |`operation`, `result`|PT1M |Yes|

### Category: Resource Allocation
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Dedicated Core Count**<br><br>Total number of dedicated cores in the batch account |`CoreCount` | No | Count |Total (Sum) |\<none\>|PT1M |No|
|**Creating Node Count**<br><br>Number of nodes being created |`CreatingNodeCount` | No | Count |Total (Sum) |\<none\>|PT1M |No|
|**Idle Node Count**<br><br>Number of idle nodes |`IdleNodeCount` | No | Count |Total (Sum) |\<none\>|PT1M |No|
|**Leaving Pool Node Count**<br><br>Number of nodes leaving the Pool |`LeavingPoolNodeCount` | No | Count |Total (Sum) |\<none\>|PT1M |No|
|**LowPriority Core Count**<br><br>Total number of low-priority cores in the batch account |`LowPriorityCoreCount` | No | Count |Total (Sum) |\<none\>|PT1M |No|
|**Offline Node Count**<br><br>Number of offline nodes |`OfflineNodeCount` | No | Count |Total (Sum) |\<none\>|PT1M |No|
|**Pool Create Events**<br><br>Total number of pools that have been created |`PoolCreateEvent` | No | Count |Total (Sum) |`poolId`|PT1M |Yes|
|**Pool Delete Complete Events**<br><br>Total number of pool deletes that have completed |`PoolDeleteCompleteEvent` | No | Count |Total (Sum) |`poolId`|PT1M |Yes|
|**Pool Delete Start Events**<br><br>Total number of pool deletes that have started |`PoolDeleteStartEvent` | No | Count |Total (Sum) |`poolId`|PT1M |Yes|
|**Pool Resize Complete Events**<br><br>Total number of pool resizes that have completed |`PoolResizeCompleteEvent` | No | Count |Total (Sum) |`poolId`|PT1M |Yes|
|**Pool Resize Start Events**<br><br>Total number of pool resizes that have started |`PoolResizeStartEvent` | No | Count |Total (Sum) |`poolId`|PT1M |Yes|
|**Preempted Node Count**<br><br>Number of preempted nodes |`PreemptedNodeCount` | No | Count |Total (Sum) |\<none\>|PT1M |No|
|**Rebooting Node Count**<br><br>Number of rebooting nodes |`RebootingNodeCount` | No | Count |Total (Sum) |\<none\>|PT1M |No|
|**Reimaging Node Count**<br><br>Number of reimaging nodes |`ReimagingNodeCount` | No | Count |Total (Sum) |\<none\>|PT1M |No|
|**Running Node Count**<br><br>Number of running nodes |`RunningNodeCount` | No | Count |Total (Sum) |\<none\>|PT1M |No|
|**Starting Node Count**<br><br>Number of nodes starting |`StartingNodeCount` | No | Count |Total (Sum) |\<none\>|PT1M |No|
|**Start Task Failed Node Count**<br><br>Number of nodes where the Start Task has failed |`StartTaskFailedNodeCount` | No | Count |Total (Sum) |\<none\>|PT1M |No|
|**Low-Priority Node Count**<br><br>Total number of low-priority nodes in the batch account |`TotalLowPriorityNodeCount` | No | Count |Total (Sum) |\<none\>|PT1M |No|
|**Dedicated Node Count**<br><br>Total number of dedicated nodes in the batch account |`TotalNodeCount` | No | Count |Total (Sum) |\<none\>|PT1M |No|
|**Unknown State Node Count**<br><br>Number of unknown state nodes |`UnknownStateNodeCount` | No | Count |Total (Sum) |\<none\>|PT1M |No|
|**Unusable Node Count**<br><br>Number of unusable nodes |`UnusableNodeCount` | No | Count |Total (Sum) |\<none\>|PT1M |No|
|**Waiting For Start Task Node Count**<br><br>Number of nodes waiting for the Start Task to complete |`WaitingForStartTaskNodeCount` | No | Count |Total (Sum) |\<none\>|PT1M |No|

### Category: Scheduling
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Job Delete Complete Events**<br><br>Total number of jobs that have been successfully deleted. |`JobDeleteCompleteEvent` | No | Count |Total (Sum) |`jobId`|PT1M |Yes|
|**Job Delete Start Events**<br><br>Total number of jobs that have been requested to be deleted. |`JobDeleteStartEvent` | No | Count |Total (Sum) |`jobId`|PT1M |Yes|
|**Job Disable Complete Events**<br><br>Total number of jobs that have been successfully disabled. |`JobDisableCompleteEvent` | No | Count |Total (Sum) |`jobId`|PT1M |Yes|
|**Job Disable Start Events**<br><br>Total number of jobs that have been requested to be disabled. |`JobDisableStartEvent` | No | Count |Total (Sum) |`jobId`|PT1M |Yes|
|**Job Start Events**<br><br>Total number of jobs that have been successfully started. |`JobStartEvent` | No | Count |Total (Sum) |`jobId`|PT1M |Yes|
|**Job Terminate Complete Events**<br><br>Total number of jobs that have been successfully terminated. |`JobTerminateCompleteEvent` | No | Count |Total (Sum) |`jobId`|PT1M |Yes|
|**Job Terminate Start Events**<br><br>Total number of jobs that have been requested to be terminated. |`JobTerminateStartEvent` | No | Count |Total (Sum) |`jobId`|PT1M |Yes|
|**Task Complete Events**<br><br>Total number of tasks that have completed |`TaskCompleteEvent` | No | Count |Total (Sum) |`poolId`, `jobId`|PT1M |Yes|
|**Task Fail Events**<br><br>Total number of tasks that have completed in a failed state |`TaskFailEvent` | No | Count |Total (Sum) |`poolId`, `jobId`|PT1M |Yes|
|**Task Requeue Events**<br><br>Total number of tasks that got requeued |`TaskRequeueEvent` | No | Count |Total (Sum) |`poolId`, `jobId`|PT1M |Yes|
|**Task Schedule Fail Events**<br><br>Total number of tasks failed to schedule |`TaskScheduleFailEvent` | No | Count |Total (Sum) |`poolId`, `jobId`|PT1M |Yes|
|**Task Start Events**<br><br>Total number of tasks that have started |`TaskStartEvent` | No | Count |Total (Sum) |`poolId`, `jobId`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
