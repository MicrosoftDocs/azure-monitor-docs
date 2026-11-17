---
title: Supported metrics - Microsoft.DurableTask/schedulers
description: Reference for Microsoft.DurableTask/schedulers metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 11/16/2026
ms.custom: Microsoft.DurableTask/schedulers, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.DurableTask/schedulers

The following table lists the metrics available for the Microsoft.DurableTask/schedulers resource type.

**Table headings**

- **Metric** - The metric display name as it appears in the Azure portal.
- **Name in Rest API** - Metric name as referred to in the [REST API](/azure/azure-monitor/essentials/rest-api-walkthrough).
- **Advanced platform metrics** - A premium, [paid tier of platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform) in Azure Monitor that provide more granular observability for Azure resources.
- **Unit** - Unit of measure.
- **Aggregation** - The default [aggregation](/azure/azure-monitor/essentials/metrics-aggregation-explained) type. Valid values: Average, Minimum, Maximum, Total, Count.
- **Dimensions** - [Dimensions](/azure/azure-monitor/essentials/metrics-aggregation-explained#dimensions-splitting-and-filtering) available for the metric.
- **Time Grains** - [Intervals at which the metric is sampled](/azure/azure-monitor/essentials/metrics-aggregation-explained#granularity). For example, `PT1M` indicates that the metric is sampled every minute, `PT30M` every 30 minutes, `PT1H` every hour, and so on.
- **DS Export** - Shows whether the metric is exportable to Azure Monitor Logs via Diagnostic Settings.

For information on exporting metrics, see - [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics) and [Create diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/create-diagnostic-settings?tabs=portal).

For information on metric retention, see [Azure Monitor Metrics overview](/azure/azure-monitor/essentials/data-platform-metrics#retention-of-metrics).


For a list of supported logs, see [Supported log categories - Microsoft.DurableTask/schedulers](../supported-logs/microsoft-durabletask-schedulers-logs.md)


### Category: Basic
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Activity Actions**<br><br>Number of activity actions |`ActivityActions` | No | Count |Total (Sum), Average, Maximum, Minimum |`TaskHubName`|PT1M |Yes|
|**Activity Active Items**<br><br>Number of active work items being actively processed |`ActivityActiveItems` | No | Count |Total (Sum), Average, Maximum, Minimum |`TaskHubName`|PT1M |Yes|
|**Activity Completion Latency**<br><br>Time in milliseconds from scheduling an activity until its result is accepted. |`ActivityCompletionLatencyMs` | No | Milliseconds |Count, Total (Sum), Average, Maximum, Minimum |`TaskHubName`, `ActivityName`, `ActivityVersion`, `OrchestrationName`, `OrchestrationVersion`, `Outcome`|PT1M |Yes|
|**Activity Pending Items**<br><br>Number of activity work items ready to be processed |`ActivityPendingItems` | No | Count |Total (Sum), Average, Maximum, Minimum |`TaskHubName`|PT1M |Yes|
|**Client Fault Requests**<br><br>Number of requests that failed due to a client error |`ClientFaultRequests` | No | Count |Total (Sum), Average, Maximum, Minimum |`TaskHubName`|PT1M |Yes|
|**Completed Work Items**<br><br>Number of work items with an accepted result, including failed results. |`CompletedWorkItems` | No | Count |Total (Sum) |`TaskHubName`, `WorkItemType`|PT1M |Yes|
|**Connected Workers**<br><br>Number of connected workers to a task hub |`ConnectedWorkers` | No | Count |Total (Sum), Average, Maximum, Minimum |`TaskHubName`|PT1M |Yes|
|**Data Used In Bytes**<br><br>Size of payloads table in bytes |`DataUsedInBytes` | No | Bytes |Total (Sum), Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Dispatched Work Items**<br><br>Number of work items successfully sent to a worker. |`DispatchedWorkItems` | No | Count |Total (Sum) |`TaskHubName`, `WorkItemType`|PT1M |Yes|
|**Entity Actions**<br><br>Number of entity actions |`EntityActions` | No | Count |Total (Sum), Average, Maximum, Minimum |`TaskHubName`|PT1M |Yes|
|**Entity Active Items**<br><br>Number of entity work items being actively processed |`EntityActiveItems` | No | Count |Total (Sum), Average, Maximum, Minimum |`TaskHubName`|PT1M |Yes|
|**Entity Pending Items**<br><br>Number of entity work items ready to be processed |`EntityPendingItems` | No | Count |Total (Sum), Average, Maximum, Minimum |`TaskHubName`|PT1M |Yes|
|**In-Flight Work Items**<br><br>Number of work items assigned to local workers that are currently in flight. |`InflightWorkItems` | No | Count |Average, Maximum, Minimum |`TaskHubName`, `WorkItemType`|PT1M |Yes|
|**Orchestration Actions**<br><br>Number of orchestration actions |`OrchestrationActions` | No | Count |Total (Sum), Average, Maximum, Minimum |`TaskHubName`|PT1M |Yes|
|**Orchestrator Active Items**<br><br>Number of orchestrator work items being actively processed |`OrchestratorActiveItems` | No | Count |Total (Sum), Average, Maximum, Minimum |`TaskHubName`|PT1M |Yes|
|**Orchestrator Pending Items**<br><br>Number of orchestrator work items ready to be processed |`OrchestratorPendingItems` | No | Count |Total (Sum), Average, Maximum, Minimum |`TaskHubName`|PT1M |Yes|
|**Permission Denied Requests**<br><br>Number of requests that failed due to insufficient permissions |`PermissionDeniedRequests` | No | Count |Total (Sum), Average, Maximum, Minimum |`TaskHubName`|PT1M |Yes|
|**Request Duration**<br><br>Duration of requests in milliseconds |`RequestDurationMs` | No | Milliseconds |Total (Sum), Average, Maximum, Minimum |`TaskHubName`|PT1M |Yes|
|**Requests**<br><br>Total number of requests processed by the scheduler |`Requests` | No | Count |Total (Sum), Average, Maximum, Minimum |`TaskHubName`|PT1M |Yes|
|**Server Fault Requests**<br><br>Number of requests that failed due to a server error |`ServerFaultRequests` | No | Count |Total (Sum), Average, Maximum, Minimum |`TaskHubName`|PT1M |Yes|
|**Successful Requests**<br><br>Number of requests that completed successfully |`SuccessfulRequests` | No | Count |Total (Sum), Average, Maximum, Minimum |`TaskHubName`|PT1M |Yes|
|**Timer Actions**<br><br>Number of timer actions |`TimerActions` | No | Count |Total (Sum), Average, Maximum, Minimum |`TaskHubName`|PT1M |Yes|
|**Total Actions**<br><br>Total number of actions across orchestration, activity, timer, and entity work |`TotalActions` | No | Count |Total (Sum), Average, Maximum, Minimum |`TaskHubName`|PT1M |Yes|
|**Unauthenticated Requests**<br><br>Number of requests that failed due to missing or invalid authentication |`UnauthenticatedRequests` | No | Count |Total (Sum), Average, Maximum, Minimum |`TaskHubName`|PT1M |Yes|
|**Work Items Capacity**<br><br>Maximum number of work items that can be assigned to local workers at a time; draining or disconnecting workers contribute zero. |`WorkItemsCapacity` | No | Count |Average, Maximum, Minimum |`TaskHubName`, `WorkItemType`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
