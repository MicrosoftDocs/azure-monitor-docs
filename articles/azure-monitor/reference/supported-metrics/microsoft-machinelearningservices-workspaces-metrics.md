---
title: Supported metrics - Microsoft.MachineLearningServices/workspaces
description: Reference for Microsoft.MachineLearningServices/workspaces metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.MachineLearningServices/workspaces, arm

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.MachineLearningServices/workspaces

The following table lists the metrics available for the Microsoft.MachineLearningServices/workspaces resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.MachineLearningServices/workspaces](../supported-logs/microsoft-machinelearningservices-workspaces-logs.md)


### Category: Agents
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Agents**<br><br>Number of events for AI Agents in this workspace |`Agents` |Count |Average, Maximum, Minimum, Total (Sum) |`EventType`|PT1M |No|
|**IndexedFiles**<br><br>Number of files indexed for file search in this workspace |`IndexedFiles` |Count |Average, Maximum, Minimum, Total (Sum) |`ErrorCode`, `Status`, `VectorStoreId`|PT1M |No|
|**Messages**<br><br>Number of events for AI Agent messages in this workspace |`Messages` |Count |Average, Maximum, Minimum, Total (Sum) |`EventType`, `ThreadId`|PT1M |No|
|**Runs**<br><br>Number of runs by AI Agents in this workspace |`Runs` |Count |Average, Maximum, Minimum, Total (Sum) |`AgentId`, `RunStatus`, `StatusCode`, `StreamType`|PT1M |No|
|**Threads**<br><br>Number of events for AI Agent threads in this workspace |`Threads` |Count |Average, Maximum, Minimum, Total (Sum) |`EventType`|PT1M |No|
|**Tokens**<br><br>Count of tokens by AI Agents in this workspace |`Tokens` |Count |Average, Maximum, Minimum, Total (Sum) |`AgentId`, `TokenType`|PT1M |No|
|**ToolCalls**<br><br>Tool calls made by AI Agents in this workspace |`ToolCalls` |Count |Average, Maximum, Minimum, Total (Sum) |`AgentId`, `ToolName`|PT1M |No|

### Category: Model
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Model Deploy Failed**<br><br>Number of model deployments that failed in this workspace |`Model Deploy Failed` |Count |Total (Sum), Average, Minimum, Maximum, Count |`Scenario`, `StatusCode`|PT1M |Yes|
|**Model Deploy Started**<br><br>Number of model deployments started in this workspace |`Model Deploy Started` |Count |Total (Sum), Average, Minimum, Maximum, Count |`Scenario`|PT1M |Yes|
|**Model Deploy Succeeded**<br><br>Number of model deployments that succeeded in this workspace |`Model Deploy Succeeded` |Count |Total (Sum), Average, Minimum, Maximum, Count |`Scenario`|PT1M |Yes|
|**Model Register Failed**<br><br>Number of model registrations that failed in this workspace |`Model Register Failed` |Count |Total (Sum), Average, Minimum, Maximum, Count |`Scenario`, `StatusCode`|PT1M |Yes|
|**Model Register Succeeded**<br><br>Number of model registrations that succeeded in this workspace |`Model Register Succeeded` |Count |Total (Sum), Average, Minimum, Maximum, Count |`Scenario`|PT1M |Yes|

### Category: Quota
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Active Cores**<br><br>Number of active cores |`Active Cores` |Count |Average, Maximum, Minimum, Total (Sum) |`Scenario`, `ClusterName`|PT1M |Yes|
|**Active Nodes**<br><br>Number of Acitve nodes. These are the nodes which are actively running a job. |`Active Nodes` |Count |Average, Maximum, Minimum, Total (Sum) |`Scenario`, `ClusterName`|PT1M |Yes|
|**Idle Cores**<br><br>Number of idle cores |`Idle Cores` |Count |Average, Maximum, Minimum, Total (Sum) |`Scenario`, `ClusterName`|PT1M |Yes|
|**Idle Nodes**<br><br>Number of idle nodes. Idle nodes are the nodes which are not running any jobs but can accept new job if available. |`Idle Nodes` |Count |Average, Maximum, Minimum, Total (Sum) |`Scenario`, `ClusterName`|PT1M |Yes|
|**Leaving Cores**<br><br>Number of leaving cores |`Leaving Cores` |Count |Average, Maximum, Minimum, Total (Sum) |`Scenario`, `ClusterName`|PT1M |Yes|
|**Leaving Nodes**<br><br>Number of leaving nodes. Leaving nodes are the nodes which just finished processing a job and will go to Idle state. |`Leaving Nodes` |Count |Average, Maximum, Minimum, Total (Sum) |`Scenario`, `ClusterName`|PT1M |Yes|
|**Preempted Cores**<br><br>Number of preempted cores |`Preempted Cores` |Count |Average, Maximum, Minimum, Total (Sum) |`Scenario`, `ClusterName`|PT1M |Yes|
|**Preempted Nodes**<br><br>Number of preempted nodes. These nodes are the low priority nodes which are taken away from the available node pool. |`Preempted Nodes` |Count |Average, Maximum, Minimum, Total (Sum) |`Scenario`, `ClusterName`|PT1M |Yes|
|**Quota Utilization Percentage**<br><br>Percent of quota utilized |`Quota Utilization Percentage` |Count |Average, Maximum, Minimum, Total (Sum) |`Scenario`, `ClusterName`, `VmFamilyName`, `VmPriority`|PT1M |Yes|
|**Total Cores**<br><br>Number of total cores |`Total Cores` |Count |Average, Maximum, Minimum, Total (Sum) |`Scenario`, `ClusterName`|PT1M |Yes|
|**Total Nodes**<br><br>Number of total nodes. This total includes some of Active Nodes, Idle Nodes, Unusable Nodes, Premepted Nodes, Leaving Nodes |`Total Nodes` |Count |Average, Maximum, Minimum, Total (Sum) |`Scenario`, `ClusterName`|PT1M |Yes|
|**Unusable Cores**<br><br>Number of unusable cores |`Unusable Cores` |Count |Average, Maximum, Minimum, Total (Sum) |`Scenario`, `ClusterName`|PT1M |Yes|
|**Unusable Nodes**<br><br>Number of unusable nodes. Unusable nodes are not functional due to some unresolvable issue. Azure will recycle these nodes. |`Unusable Nodes` |Count |Average, Maximum, Minimum, Total (Sum) |`Scenario`, `ClusterName`|PT1M |Yes|

### Category: Resource
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**CpuCapacityMillicores**<br><br>Maximum capacity of a CPU node in millicores. Capacity is aggregated in one minute intervals. |`CpuCapacityMillicores` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`|PT1M |Yes|
|**CpuMemoryCapacityMegabytes**<br><br>Maximum memory utilization of a CPU node in megabytes. Utilization is aggregated in one minute intervals. |`CpuMemoryCapacityMegabytes` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`|PT1M |Yes|
|**CpuMemoryUtilizationMegabytes**<br><br>Memory utilization of a CPU node in megabytes. Utilization is aggregated in one minute intervals. |`CpuMemoryUtilizationMegabytes` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`|PT1M |Yes|
|**CpuMemoryUtilizationPercentage**<br><br>Memory utilization percentage of a CPU node. Utilization is aggregated in one minute intervals. |`CpuMemoryUtilizationPercentage` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`|PT1M |Yes|
|**CpuUtilization**<br><br>Percentage of utilization on a CPU node. Utilization is reported at one minute intervals. |`CpuUtilization` |Count |Average, Maximum, Minimum, Total (Sum) |`Scenario`, `runId`, `NodeId`, `ClusterName`|PT1M |Yes|
|**CpuUtilizationMillicores**<br><br>Utilization of a CPU node in millicores. Utilization is aggregated in one minute intervals. |`CpuUtilizationMillicores` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`|PT1M |Yes|
|**CpuUtilizationPercentage**<br><br>Utilization percentage of a CPU node. Utilization is aggregated in one minute intervals. |`CpuUtilizationPercentage` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`|PT1M |Yes|
|**DiskAvailMegabytes**<br><br>Available disk space in megabytes. Metrics are aggregated in one minute intervals. |`DiskAvailMegabytes` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`|PT1M |Yes|
|**DiskReadMegabytes**<br><br>Data read from disk in megabytes. Metrics are aggregated in one minute intervals. |`DiskReadMegabytes` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`|PT1M |Yes|
|**DiskUsedMegabytes**<br><br>Used disk space in megabytes. Metrics are aggregated in one minute intervals. |`DiskUsedMegabytes` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`|PT1M |Yes|
|**DiskWriteMegabytes**<br><br>Data written into disk in megabytes. Metrics are aggregated in one minute intervals. |`DiskWriteMegabytes` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`|PT1M |Yes|
|**GpuCapacityMilliGPUs**<br><br>Maximum capacity of a GPU device in milli-GPUs. Capacity is aggregated in one minute intervals. |`GpuCapacityMilliGPUs` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `DeviceId`, `ComputeName`|PT1M |Yes|
|**GpuEnergyJoules**<br><br>Interval energy in Joules on a GPU node. Energy is reported at one minute intervals. |`GpuEnergyJoules` |Count |Average, Maximum, Minimum, Total (Sum) |`Scenario`, `runId`, `rootRunId`, `InstanceId`, `DeviceId`, `ComputeName`|PT1M |Yes|
|**GpuMemoryCapacityMegabytes**<br><br>Maximum memory capacity of a GPU device in megabytes. Capacity aggregated in at one minute intervals. |`GpuMemoryCapacityMegabytes` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `DeviceId`, `ComputeName`|PT1M |Yes|
|**GpuMemoryUtilization**<br><br>Percentage of memory utilization on a GPU node. Utilization is reported at one minute intervals. |`GpuMemoryUtilization` |Count |Average, Maximum, Minimum, Total (Sum) |`Scenario`, `runId`, `NodeId`, `DeviceId`, `ClusterName`|PT1M |Yes|
|**GpuMemoryUtilizationMegabytes**<br><br>Memory utilization of a GPU device in megabytes. Utilization aggregated in at one minute intervals. |`GpuMemoryUtilizationMegabytes` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `DeviceId`, `ComputeName`|PT1M |Yes|
|**GpuMemoryUtilizationPercentage**<br><br>Memory utilization percentage of a GPU device. Utilization aggregated in at one minute intervals. |`GpuMemoryUtilizationPercentage` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `DeviceId`, `ComputeName`|PT1M |Yes|
|**GpuUtilization**<br><br>Percentage of utilization on a GPU node. Utilization is reported at one minute intervals. |`GpuUtilization` |Count |Average, Maximum, Minimum, Total (Sum) |`Scenario`, `runId`, `NodeId`, `DeviceId`, `ClusterName`|PT1M |Yes|
|**GpuUtilizationMilliGPUs**<br><br>Utilization of a GPU device in milli-GPUs. Utilization is aggregated in one minute intervals. |`GpuUtilizationMilliGPUs` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `DeviceId`, `ComputeName`|PT1M |Yes|
|**GpuUtilizationPercentage**<br><br>Utilization percentage of a GPU device. Utilization is aggregated in one minute intervals. |`GpuUtilizationPercentage` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `DeviceId`, `ComputeName`|PT1M |Yes|
|**IBReceiveMegabytes**<br><br>Network data received over InfiniBand in megabytes. Metrics are aggregated in one minute intervals. |`IBReceiveMegabytes` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`, `DeviceId`|PT1M |Yes|
|**IBTransmitMegabytes**<br><br>Network data sent over InfiniBand in megabytes. Metrics are aggregated in one minute intervals. |`IBTransmitMegabytes` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`, `DeviceId`|PT1M |Yes|
|**NetworkInputMegabytes**<br><br>Network data received in megabytes. Metrics are aggregated in one minute intervals. |`NetworkInputMegabytes` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`, `DeviceId`|PT1M |Yes|
|**NetworkOutputMegabytes**<br><br>Network data sent in megabytes. Metrics are aggregated in one minute intervals. |`NetworkOutputMegabytes` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`, `DeviceId`|PT1M |Yes|
|**StorageAPIFailureCount**<br><br>Azure Blob Storage API calls failure count. |`StorageAPIFailureCount` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`|PT1M |Yes|
|**StorageAPISuccessCount**<br><br>Azure Blob Storage API calls success count. |`StorageAPISuccessCount` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`|PT1M |Yes|

### Category: Run
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Cancel Requested Runs**<br><br>Number of runs where cancel was requested for this workspace. Count is updated when cancellation request has been received for a run. |`Cancel Requested Runs` |Count |Total (Sum), Average, Minimum, Maximum, Count |`Scenario`, `RunType`, `PublishedPipelineId`, `ComputeType`, `PipelineStepType`, `ExperimentName`|PT1M |Yes|
|**Cancelled Runs**<br><br>Number of runs cancelled for this workspace. Count is updated when a run is successfully cancelled. |`Cancelled Runs` |Count |Total (Sum), Average, Minimum, Maximum, Count |`Scenario`, `RunType`, `PublishedPipelineId`, `ComputeType`, `PipelineStepType`, `ExperimentName`|PT1M |Yes|
|**Completed Runs**<br><br>Number of runs completed successfully for this workspace. Count is updated when a run has completed and output has been collected. |`Completed Runs` |Count |Total (Sum), Average, Minimum, Maximum, Count |`Scenario`, `RunType`, `PublishedPipelineId`, `ComputeType`, `PipelineStepType`, `ExperimentName`|PT1M |Yes|
|**Errors**<br><br>Number of run errors in this workspace. Count is updated whenever run encounters an error. |`Errors` |Count |Total (Sum), Average, Minimum, Maximum, Count |`Scenario`|PT1M |Yes|
|**Failed Runs**<br><br>Number of runs failed for this workspace. Count is updated when a run fails. |`Failed Runs` |Count |Total (Sum), Average, Minimum, Maximum, Count |`Scenario`, `RunType`, `PublishedPipelineId`, `ComputeType`, `PipelineStepType`, `ExperimentName`|PT1M |Yes|
|**Finalizing Runs**<br><br>Number of runs entered finalizing state for this workspace. Count is updated when a run has completed but output collection still in progress. |`Finalizing Runs` |Count |Total (Sum), Average, Minimum, Maximum, Count |`Scenario`, `RunType`, `PublishedPipelineId`, `ComputeType`, `PipelineStepType`, `ExperimentName`|PT1M |Yes|
|**Not Responding Runs**<br><br>Number of runs not responding for this workspace. Count is updated when a run enters Not Responding state. |`Not Responding Runs` |Count |Total (Sum), Average, Minimum, Maximum, Count |`Scenario`, `RunType`, `PublishedPipelineId`, `ComputeType`, `PipelineStepType`, `ExperimentName`|PT1M |Yes|
|**Not Started Runs**<br><br>Number of runs in Not Started state for this workspace. Count is updated when a request is received to create a run but run information has not yet been populated. |`Not Started Runs` |Count |Total (Sum), Average, Minimum, Maximum, Count |`Scenario`, `RunType`, `PublishedPipelineId`, `ComputeType`, `PipelineStepType`, `ExperimentName`|PT1M |Yes|
|**Preparing Runs**<br><br>Number of runs that are preparing for this workspace. Count is updated when a run enters Preparing state while the run environment is being prepared. |`Preparing Runs` |Count |Total (Sum), Average, Minimum, Maximum, Count |`Scenario`, `RunType`, `PublishedPipelineId`, `ComputeType`, `PipelineStepType`, `ExperimentName`|PT1M |Yes|
|**Provisioning Runs**<br><br>Number of runs that are provisioning for this workspace. Count is updated when a run is waiting on compute target creation or provisioning. |`Provisioning Runs` |Count |Total (Sum), Average, Minimum, Maximum, Count |`Scenario`, `RunType`, `PublishedPipelineId`, `ComputeType`, `PipelineStepType`, `ExperimentName`|PT1M |Yes|
|**Queued Runs**<br><br>Number of runs that are queued for this workspace. Count is updated when a run is queued in compute target. Can occure when waiting for required compute nodes to be ready. |`Queued Runs` |Count |Total (Sum), Average, Minimum, Maximum, Count |`Scenario`, `RunType`, `PublishedPipelineId`, `ComputeType`, `PipelineStepType`, `ExperimentName`|PT1M |Yes|
|**Started Runs**<br><br>Number of runs running for this workspace. Count is updated when run starts running on required resources. |`Started Runs` |Count |Total (Sum), Average, Minimum, Maximum, Count |`Scenario`, `RunType`, `PublishedPipelineId`, `ComputeType`, `PipelineStepType`, `ExperimentName`|PT1M |Yes|
|**Starting Runs**<br><br>Number of runs started for this workspace. Count is updated after request to create run and run info, such as the Run Id, has been populated |`Starting Runs` |Count |Total (Sum), Average, Minimum, Maximum, Count |`Scenario`, `RunType`, `PublishedPipelineId`, `ComputeType`, `PipelineStepType`, `ExperimentName`|PT1M |Yes|
|**Warnings**<br><br>Number of run warnings in this workspace. Count is updated whenever a run encounters a warning. |`Warnings` |Count |Total (Sum), Average, Minimum, Maximum, Count |`Scenario`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
