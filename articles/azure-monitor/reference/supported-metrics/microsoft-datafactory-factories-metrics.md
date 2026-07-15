---
title: Supported metrics - Microsoft.DataFactory/factories
description: Reference for Microsoft.DataFactory/factories metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: Microsoft.DataFactory/factories, arm

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.DataFactory/factories

The following table lists the metrics available for the Microsoft.DataFactory/factories resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.DataFactory/factories](../supported-logs/microsoft-datafactory-factories-logs.md)


|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Cancelled activity runs metrics**<br><br>Cancelled activity runs metrics |`ActivityCancelledRuns` | No | Count |Total (Sum) |`ActivityType`, `PipelineName`, `FailureType`, `Name`|PT1M |Yes|
|**Failed activity runs metrics**<br><br>Failed activity runs metrics |`ActivityFailedRuns` | No | Count |Total (Sum) |`ActivityType`, `PipelineName`, `FailureType`, `Name`|PT1M |Yes|
|**Succeeded activity runs metrics**<br><br>Succeeded activity runs metrics |`ActivitySucceededRuns` | No | Count |Total (Sum) |`ActivityType`, `PipelineName`, `FailureType`, `Name`|PT1M |Yes|
|**Airflow Integration Runtime Celery Task Timeout Error**<br><br>Airflow Integration Runtime Celery Task Timeout Error |`AirflowIntegrationRuntimeCeleryTaskTimeoutError` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Collect DB Dags**<br><br>Airflow Integration Runtime Collect DB Dags |`AirflowIntegrationRuntimeCollectDBDags` | No | Milliseconds |Average |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Cpu Percentage**<br><br>Airflow Integration Runtime Cpu Percentage |`AirflowIntegrationRuntimeCpuPercentage` | No | Percent |Average |`IntegrationRuntimeName`, `ContainerName`|PT1M |Yes|
|**Airflow Integration Runtime Cpu Usage**<br><br>Airflow Integration Runtime Cpu Usage |`AirflowIntegrationRuntimeCpuUsage` | No | Millicores |Average |`IntegrationRuntimeName`, `ContainerName`|PT1M |Yes|
|**Airflow Integration Runtime Dag Bag Size**<br><br>Airflow Integration Runtime Dag Bag Size |`AirflowIntegrationRuntimeDagBagSize` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Dag Callback Exceptions**<br><br>Airflow Integration Runtime Dag Callback Exceptions |`AirflowIntegrationRuntimeDagCallbackExceptions` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime DAG File Refresh Error**<br><br>Airflow Integration Runtime DAG File Refresh Error |`AirflowIntegrationRuntimeDAGFileRefreshError` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime DAG Processing Import Errors**<br><br>Airflow Integration Runtime DAG Processing Import Errors |`AirflowIntegrationRuntimeDAGProcessingImportErrors` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime DAG Processing Last Duration**<br><br>Airflow Integration Runtime DAG Processing Last Duration |`AirflowIntegrationRuntimeDAGProcessingLastDuration` | No | Milliseconds |Average |`IntegrationRuntimeName`, `DagFile`|PT1M |No|
|**Airflow Integration Runtime DAG Processing Last Run Seconds Ago**<br><br>Airflow Integration Runtime DAG Processing Last Run Seconds Ago |`AirflowIntegrationRuntimeDAGProcessingLastRunSecondsAgo` | No | Seconds |Average |`IntegrationRuntimeName`, `DagFile`|PT1M |No|
|**Airflow Integration Runtime DAG ProcessingManager Stalls**<br><br>Airflow Integration Runtime DAG ProcessingManager Stalls |`AirflowIntegrationRuntimeDAGProcessingManagerStalls` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime DAG Processing Processes**<br><br>Airflow Integration Runtime DAG Processing Processes |`AirflowIntegrationRuntimeDAGProcessingProcesses` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime DAG Processing Processor Timeouts**<br><br>Airflow Integration Runtime DAG Processing Processor Timeouts |`AirflowIntegrationRuntimeDAGProcessingProcessorTimeouts` | No | Seconds |Average |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime DAG Processing Total Parse Time**<br><br>Airflow Integration Runtime DAG Processing Total Parse Time |`AirflowIntegrationRuntimeDAGProcessingTotalParseTime` | No | Seconds |Average |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime DAG Run Dependency Check**<br><br>Airflow Integration Runtime DAG Run Dependency Check |`AirflowIntegrationRuntimeDAGRunDependencyCheck` | No | Milliseconds |Average |`IntegrationRuntimeName`, `DagId`|PT1M |No|
|**Airflow Integration Runtime DAG Run Duration Failed**<br><br>Airflow Integration Runtime DAG Run Duration Failed |`AirflowIntegrationRuntimeDAGRunDurationFailed` | No | Milliseconds |Average |`IntegrationRuntimeName`, `DagId`|PT1M |No|
|**Airflow Integration Runtime DAG Run Duration Success**<br><br>Airflow Integration Runtime DAG Run Duration Success |`AirflowIntegrationRuntimeDAGRunDurationSuccess` | No | Milliseconds |Average |`IntegrationRuntimeName`, `DagId`|PT1M |No|
|**Airflow Integration Runtime DAG Run First Task Scheduling Delay**<br><br>Airflow Integration Runtime DAG Run First Task Scheduling Delay |`AirflowIntegrationRuntimeDAGRunFirstTaskSchedulingDelay` | No | Milliseconds |Average |`IntegrationRuntimeName`, `DagId`|PT1M |No|
|**Airflow Integration Runtime DAG Run Schedule Delay**<br><br>Airflow Integration Runtime DAG Run Schedule Delay |`AirflowIntegrationRuntimeDAGRunScheduleDelay` | No | Milliseconds |Average |`IntegrationRuntimeName`, `DagId`|PT1M |No|
|**Airflow Integration Runtime Executor Open Slots**<br><br>Airflow Integration Runtime Executor Open Slots |`AirflowIntegrationRuntimeExecutorOpenSlots` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Executor Queued Tasks**<br><br>Airflow Integration Runtime Executor Queued Tasks |`AirflowIntegrationRuntimeExecutorQueuedTasks` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Executor Running Tasks**<br><br>Airflow Integration Runtime Executor Running Tasks |`AirflowIntegrationRuntimeExecutorRunningTasks` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Job End**<br><br>Airflow Integration Runtime Job End |`AirflowIntegrationRuntimeJobEnd` | No | Count |Total (Sum) |`IntegrationRuntimeName`, `Job`|PT1M |No|
|**Airflow Integration Runtime Heartbeat Failure**<br><br>Airflow Integration Runtime Heartbeat Failure |`AirflowIntegrationRuntimeJobHeartbeatFailure` | No | Count |Total (Sum) |`IntegrationRuntimeName`, `Job`|PT1M |No|
|**Airflow Integration Runtime Job Start**<br><br>Airflow Integration Runtime Job Start |`AirflowIntegrationRuntimeJobStart` | No | Count |Total (Sum) |`IntegrationRuntimeName`, `Job`|PT1M |No|
|**Airflow Integration Runtime Memory Percentage**<br><br>Airflow Integration Runtime Memory Percentage |`AirflowIntegrationRuntimeMemoryPercentage` | No | Percent |Average |`IntegrationRuntimeName`, `ContainerName`|PT1M |Yes|
|**Airflow Integration Runtime Memory Usage**<br><br>Airflow Integration Runtime Memory Usage |`AirflowIntegrationRuntimeMemoryUsage` | No | Bytes |Average |`IntegrationRuntimeName`, `ContainerName`|PT1M |Yes|
|**Airflow Integration Runtime Node Count**<br><br>Airflow Integration Runtime Node Count |`AirflowIntegrationRuntimeNodeCount` | No | Count |Average |`IntegrationRuntimeName`, `ComputeNodeSize`|PT1M |Yes|
|**Airflow Integration Runtime Operator Failures**<br><br>Airflow Integration Runtime Operator Failures |`AirflowIntegrationRuntimeOperatorFailures` | No | Count |Total (Sum) |`IntegrationRuntimeName`, `Operator`|PT1M |No|
|**Airflow Integration Runtime Operator Successes**<br><br>Airflow Integration Runtime Operator Successes |`AirflowIntegrationRuntimeOperatorSuccesses` | No | Count |Total (Sum) |`IntegrationRuntimeName`, `Operator`|PT1M |No|
|**Airflow Integration Runtime Pool Open Slots**<br><br>Airflow Integration Runtime Pool Open Slots |`AirflowIntegrationRuntimePoolOpenSlots` | No | Count |Total (Sum) |`IntegrationRuntimeName`, `Pool`|PT1M |No|
|**Airflow Integration Runtime Pool Queued Slots**<br><br>Airflow Integration Runtime Pool Queued Slots |`AirflowIntegrationRuntimePoolQueuedSlots` | No | Count |Total (Sum) |`IntegrationRuntimeName`, `Pool`|PT1M |No|
|**Airflow Integration Runtime Pool Running Slots**<br><br>Airflow Integration Runtime Pool Running Slots |`AirflowIntegrationRuntimePoolRunningSlots` | No | Count |Total (Sum) |`IntegrationRuntimeName`, `Pool`|PT1M |No|
|**Airflow Integration Runtime Pool Starving Tasks**<br><br>Airflow Integration Runtime Pool Starving Tasks |`AirflowIntegrationRuntimePoolStarvingTasks` | No | Count |Total (Sum) |`IntegrationRuntimeName`, `Pool`|PT1M |No|
|**Airflow Integration Runtime Scheduler Critical Section Busy**<br><br>Airflow Integration Runtime Scheduler Critical Section Busy |`AirflowIntegrationRuntimeSchedulerCriticalSectionBusy` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Scheduler Critical Section Duration**<br><br>Airflow Integration Runtime Scheduler Critical Section Duration |`AirflowIntegrationRuntimeSchedulerCriticalSectionDuration` | No | Milliseconds |Average |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Scheduler Failed SLA Email Attempts**<br><br>Airflow Integration Runtime Scheduler Failed SLA Email Attempts |`AirflowIntegrationRuntimeSchedulerFailedSLAEmailAttempts` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Scheduler Heartbeats**<br><br>Airflow Integration Runtime Scheduler Heartbeats |`AirflowIntegrationRuntimeSchedulerHeartbeat` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Scheduler Orphaned Tasks Adopted**<br><br>Airflow Integration Runtime Scheduler Orphaned Tasks Adopted |`AirflowIntegrationRuntimeSchedulerOrphanedTasksAdopted` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Scheduler Orphaned Tasks Cleared**<br><br>Airflow Integration Runtime Scheduler Orphaned Tasks Cleared |`AirflowIntegrationRuntimeSchedulerOrphanedTasksCleared` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Scheduler Tasks Executable**<br><br>Airflow Integration Runtime Scheduler Tasks Executable |`AirflowIntegrationRuntimeSchedulerTasksExecutable` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Scheduler Tasks Killed Externally**<br><br>Airflow Integration Runtime Scheduler Tasks Killed Externally |`AirflowIntegrationRuntimeSchedulerTasksKilledExternally` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Scheduler Tasks Running**<br><br>Airflow Integration Runtime Scheduler Tasks Running |`AirflowIntegrationRuntimeSchedulerTasksRunning` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Scheduler Tasks Starving**<br><br>Airflow Integration Runtime Scheduler Tasks Starving |`AirflowIntegrationRuntimeSchedulerTasksStarving` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Started Task Instances**<br><br>Airflow Integration Runtime Started Task Instances |`AirflowIntegrationRuntimeStartedTaskInstances` | No | Count |Total (Sum) |`IntegrationRuntimeName`, `DagId`, `TaskId`|PT1M |No|
|**Airflow Integration Runtime Task Instance Created Using Operator**<br><br>Airflow Integration Runtime Task Instance Created Using Operator |`AirflowIntegrationRuntimeTaskInstanceCreatedUsingOperator` | No | Count |Total (Sum) |`IntegrationRuntimeName`, `Operator`|PT1M |No|
|**Airflow Integration Runtime Task Instance Duration**<br><br>Airflow Integration Runtime Task Instance Duration |`AirflowIntegrationRuntimeTaskInstanceDuration` | No | Milliseconds |Average |`IntegrationRuntimeName`, `DagId`, `TaskID`|PT1M |No|
|**Airflow Integration Runtime Task Instance Failures**<br><br>Airflow Integration Runtime Task Instance Failures |`AirflowIntegrationRuntimeTaskInstanceFailures` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Task Instance Finished**<br><br>Airflow Integration Runtime Task Instance Finished |`AirflowIntegrationRuntimeTaskInstanceFinished` | No | Count |Total (Sum) |`IntegrationRuntimeName`, `DagId`, `TaskId`, `State`|PT1M |No|
|**Airflow Integration Runtime Task Instance Previously Succeeded**<br><br>Airflow Integration Runtime Task Instance Previously Succeeded |`AirflowIntegrationRuntimeTaskInstancePreviouslySucceeded` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Task Instance Successes**<br><br>Airflow Integration Runtime Task Instance Successes |`AirflowIntegrationRuntimeTaskInstanceSuccesses` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Task Removed From DAG**<br><br>Airflow Integration Runtime Task Removed From DAG |`AirflowIntegrationRuntimeTaskRemovedFromDAG` | No | Count |Total (Sum) |`IntegrationRuntimeName`, `DagId`|PT1M |No|
|**Airflow Integration Runtime Task Restored To DAG**<br><br>Airflow Integration Runtime Task Restored To DAG |`AirflowIntegrationRuntimeTaskRestoredToDAG` | No | Count |Total (Sum) |`IntegrationRuntimeName`, `DagId`|PT1M |No|
|**Airflow Integration Runtime Triggers Blocked Main Thread**<br><br>Airflow Integration Runtime Triggers Blocked Main Thread |`AirflowIntegrationRuntimeTriggersBlockedMainThread` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Triggers Failed**<br><br>Airflow Integration Runtime Triggers Failed |`AirflowIntegrationRuntimeTriggersFailed` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Triggers Running**<br><br>Airflow Integration Runtime Triggers Running |`AirflowIntegrationRuntimeTriggersRunning` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Triggers Succeeded**<br><br>Airflow Integration Runtime Triggers Succeeded |`AirflowIntegrationRuntimeTriggersSucceeded` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Zombie Tasks Killed**<br><br>Airflow Integration Runtime Zombie Tasks Killed |`AirflowIntegrationRuntimeZombiesKilled` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Total factory size (GB unit)**<br><br>Total factory size (GB unit) |`FactorySizeInGbUnits` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Integration runtime available memory**<br><br>Integration runtime available memory |`IntegrationRuntimeAvailableMemory` | No | Bytes |Average |`IntegrationRuntimeName`, `NodeName`|PT1M |Yes|
|**Integration runtime available node count**<br><br>Integration runtime available node count |`IntegrationRuntimeAvailableNodeNumber` | No | Count |Average |`IntegrationRuntimeName`|PT1M |Yes|
|**Integration runtime queue duration**<br><br>Integration runtime queue duration |`IntegrationRuntimeAverageTaskPickupDelay` | No | Seconds |Average |`IntegrationRuntimeName`|PT1M |Yes|
|**Integration runtime CPU utilization**<br><br>Integration runtime CPU utilization |`IntegrationRuntimeCpuPercentage` | No | Percent |Average |`IntegrationRuntimeName`, `NodeName`|PT1M |Yes|
|**Integration runtime queue length**<br><br>Integration runtime queue length |`IntegrationRuntimeQueueLength` | No | Count |Average |`IntegrationRuntimeName`|PT1M |Yes|
|**Maximum allowed factory size (GB unit)**<br><br>Maximum allowed factory size (GB unit) |`MaxAllowedFactorySizeInGbUnits` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Maximum allowed entities count**<br><br>Maximum allowed entities count |`MaxAllowedResourceCount` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Copy available capacity percentage of MVNet integration runtime**<br><br>Copy available capacity percentage of MVNet integration runtime |`MVNetIRCopyAvailableCapacityPCT` | No | Percent |Maximum |`IntegrationRuntimeName`|PT1M |Yes|
|**Copy capacity utilization of MVNet integration runtime**<br><br>Copy capacity utilization of MVNet integration runtime |`MVNetIRCopyCapacityUtilization` | No | Percent |Maximum |`IntegrationRuntimeName`|PT1M |Yes|
|**Copy waiting queue length of MVNet integration runtime**<br><br>Copy waiting queue length of MVNet integration runtime |`MVNetIRCopyWaitingQueueLength` | No | Count |Average |`IntegrationRuntimeName`|PT1M |Yes|
|**External available capacity percentage of MVNet integration runtime**<br><br>External available capacity percentage of MVNet integration runtime |`MVNetIRExternalAvailableCapacityPCT` | No | Percent |Maximum |`IntegrationRuntimeName`|PT1M |Yes|
|**External capacity utilization of MVNet integration runtime**<br><br>External capacity utilization of MVNet integration runtime |`MVNetIRExternalCapacityUtilization` | No | Percent |Maximum |`IntegrationRuntimeName`|PT1M |Yes|
|**External waiting queue length of MVNet integration runtime**<br><br>External waiting queue length of MVNet integration runtime |`MVNetIRExternalWaitingQueueLength` | No | Count |Average |`IntegrationRuntimeName`|PT1M |Yes|
|**Pipeline available capacity percentage of MVNet integration runtime**<br><br>Pipeline available capacity percentage of MVNet integration runtime |`MVNetIRPipelineAvailableCapacityPCT` | No | Percent |Maximum |`IntegrationRuntimeName`|PT1M |Yes|
|**Pipeline capacity utilization of MVNet integration runtime**<br><br>Pipeline capacity utilization of MVNet integration runtime |`MVNetIRPipelineCapacityUtilization` | No | Percent |Maximum |`IntegrationRuntimeName`|PT1M |Yes|
|**Pipeline waiting queue length of MVNet integration runtime**<br><br>Pipeline waiting queue length of MVNet integration runtime |`MVNetIRPipelineWaitingQueueLength` | No | Count |Average |`IntegrationRuntimeName`|PT1M |Yes|
|**Cancelled pipeline runs metrics**<br><br>Cancelled pipeline runs metrics |`PipelineCancelledRuns` | No | Count |Total (Sum) |`FailureType`, `CancelledBy`, `Name`|PT1M |Yes|
|**Elapsed Time Pipeline Runs Metrics**<br><br>Elapsed Time Pipeline Runs Metrics |`PipelineElapsedTimeRuns` | No | Count |Total (Sum) |`RunId`, `Name`|PT1M |Yes|
|**Failed pipeline runs metrics**<br><br>Failed pipeline runs metrics |`PipelineFailedRuns` | No | Count |Total (Sum) |`FailureType`, `Name`|PT1M |Yes|
|**Succeeded pipeline runs metrics**<br><br>Succeeded pipeline runs metrics |`PipelineSucceededRuns` | No | Count |Total (Sum) |`FailureType`, `Name`|PT1M |Yes|
|**Total entities count**<br><br>Total entities count |`ResourceCount` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Cancelled SSIS integration runtime start metrics**<br><br>Cancelled SSIS integration runtime start metrics |`SSISIntegrationRuntimeStartCancel` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |Yes|
|**Failed SSIS integration runtime start metrics**<br><br>Failed SSIS integration runtime start metrics |`SSISIntegrationRuntimeStartFailed` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |Yes|
|**Succeeded SSIS integration runtime start metrics**<br><br>Succeeded SSIS integration runtime start metrics |`SSISIntegrationRuntimeStartSucceeded` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |Yes|
|**Stuck SSIS integration runtime stop metrics**<br><br>Stuck SSIS integration runtime stop metrics |`SSISIntegrationRuntimeStopStuck` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |Yes|
|**Succeeded SSIS integration runtime stop metrics**<br><br>Succeeded SSIS integration runtime stop metrics |`SSISIntegrationRuntimeStopSucceeded` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |Yes|
|**Cancelled SSIS package execution metrics**<br><br>Cancelled SSIS package execution metrics |`SSISPackageExecutionCancel` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |Yes|
|**Failed SSIS package execution metrics**<br><br>Failed SSIS package execution metrics |`SSISPackageExecutionFailed` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |Yes|
|**Succeeded SSIS package execution metrics**<br><br>Succeeded SSIS package execution metrics |`SSISPackageExecutionSucceeded` | No | Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |Yes|
|**Cancelled trigger runs metrics**<br><br>Cancelled trigger runs metrics |`TriggerCancelledRuns` | No | Count |Total (Sum) |`Name`, `FailureType`|PT1M |Yes|
|**Failed trigger runs metrics**<br><br>Failed trigger runs metrics |`TriggerFailedRuns` | No | Count |Total (Sum) |`Name`, `FailureType`|PT1M |Yes|
|**Succeeded trigger runs metrics**<br><br>Succeeded trigger runs metrics |`TriggerSucceededRuns` | No | Count |Total (Sum) |`Name`, `FailureType`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
