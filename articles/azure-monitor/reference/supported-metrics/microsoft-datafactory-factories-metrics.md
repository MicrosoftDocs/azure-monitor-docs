---
title: Supported metrics - Microsoft.DataFactory/factories
description: Reference for Microsoft.DataFactory/factories metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.DataFactory/factories, arm

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.DataFactory/factories

The following table lists the metrics available for the Microsoft.DataFactory/factories resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.DataFactory/factories](../supported-logs/microsoft-datafactory-factories-logs.md)


|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Cancelled activity runs metrics**<br><br>Cancelled activity runs metrics |`ActivityCancelledRuns` |Count |Total (Sum) |`ActivityType`, `PipelineName`, `FailureType`, `Name`|PT1M |Yes|
|**Failed activity runs metrics**<br><br>Failed activity runs metrics |`ActivityFailedRuns` |Count |Total (Sum) |`ActivityType`, `PipelineName`, `FailureType`, `Name`|PT1M |Yes|
|**Succeeded activity runs metrics**<br><br>Succeeded activity runs metrics |`ActivitySucceededRuns` |Count |Total (Sum) |`ActivityType`, `PipelineName`, `FailureType`, `Name`|PT1M |Yes|
|**Airflow Integration Runtime Celery Task Timeout Error**<br><br>Airflow Integration Runtime Celery Task Timeout Error |`AirflowIntegrationRuntimeCeleryTaskTimeoutError` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Collect DB Dags**<br><br>Airflow Integration Runtime Collect DB Dags |`AirflowIntegrationRuntimeCollectDBDags` |Milliseconds |Average |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Cpu Percentage**<br><br>Airflow Integration Runtime Cpu Percentage |`AirflowIntegrationRuntimeCpuPercentage` |Percent |Average |`IntegrationRuntimeName`, `ContainerName`|PT1M |Yes|
|**Airflow Integration Runtime Cpu Usage**<br><br>Airflow Integration Runtime Cpu Usage |`AirflowIntegrationRuntimeCpuUsage` |Millicores |Average |`IntegrationRuntimeName`, `ContainerName`|PT1M |Yes|
|**Airflow Integration Runtime Dag Bag Size**<br><br>Airflow Integration Runtime Dag Bag Size |`AirflowIntegrationRuntimeDagBagSize` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Dag Callback Exceptions**<br><br>Airflow Integration Runtime Dag Callback Exceptions |`AirflowIntegrationRuntimeDagCallbackExceptions` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime DAG File Refresh Error**<br><br>Airflow Integration Runtime DAG File Refresh Error |`AirflowIntegrationRuntimeDAGFileRefreshError` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime DAG Processing Import Errors**<br><br>Airflow Integration Runtime DAG Processing Import Errors |`AirflowIntegrationRuntimeDAGProcessingImportErrors` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime DAG Processing Last Duration**<br><br>Airflow Integration Runtime DAG Processing Last Duration |`AirflowIntegrationRuntimeDAGProcessingLastDuration` |Milliseconds |Average |`IntegrationRuntimeName`, `DagFile`|PT1M |No|
|**Airflow Integration Runtime DAG Processing Last Run Seconds Ago**<br><br>Airflow Integration Runtime DAG Processing Last Run Seconds Ago |`AirflowIntegrationRuntimeDAGProcessingLastRunSecondsAgo` |Seconds |Average |`IntegrationRuntimeName`, `DagFile`|PT1M |No|
|**Airflow Integration Runtime DAG ProcessingManager Stalls**<br><br>Airflow Integration Runtime DAG ProcessingManager Stalls |`AirflowIntegrationRuntimeDAGProcessingManagerStalls` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime DAG Processing Processes**<br><br>Airflow Integration Runtime DAG Processing Processes |`AirflowIntegrationRuntimeDAGProcessingProcesses` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime DAG Processing Processor Timeouts**<br><br>Airflow Integration Runtime DAG Processing Processor Timeouts |`AirflowIntegrationRuntimeDAGProcessingProcessorTimeouts` |Seconds |Average |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime DAG Processing Total Parse Time**<br><br>Airflow Integration Runtime DAG Processing Total Parse Time |`AirflowIntegrationRuntimeDAGProcessingTotalParseTime` |Seconds |Average |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime DAG Run Dependency Check**<br><br>Airflow Integration Runtime DAG Run Dependency Check |`AirflowIntegrationRuntimeDAGRunDependencyCheck` |Milliseconds |Average |`IntegrationRuntimeName`, `DagId`|PT1M |No|
|**Airflow Integration Runtime DAG Run Duration Failed**<br><br>Airflow Integration Runtime DAG Run Duration Failed |`AirflowIntegrationRuntimeDAGRunDurationFailed` |Milliseconds |Average |`IntegrationRuntimeName`, `DagId`|PT1M |No|
|**Airflow Integration Runtime DAG Run Duration Success**<br><br>Airflow Integration Runtime DAG Run Duration Success |`AirflowIntegrationRuntimeDAGRunDurationSuccess` |Milliseconds |Average |`IntegrationRuntimeName`, `DagId`|PT1M |No|
|**Airflow Integration Runtime DAG Run First Task Scheduling Delay**<br><br>Airflow Integration Runtime DAG Run First Task Scheduling Delay |`AirflowIntegrationRuntimeDAGRunFirstTaskSchedulingDelay` |Milliseconds |Average |`IntegrationRuntimeName`, `DagId`|PT1M |No|
|**Airflow Integration Runtime DAG Run Schedule Delay**<br><br>Airflow Integration Runtime DAG Run Schedule Delay |`AirflowIntegrationRuntimeDAGRunScheduleDelay` |Milliseconds |Average |`IntegrationRuntimeName`, `DagId`|PT1M |No|
|**Airflow Integration Runtime Executor Open Slots**<br><br>Airflow Integration Runtime Executor Open Slots |`AirflowIntegrationRuntimeExecutorOpenSlots` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Executor Queued Tasks**<br><br>Airflow Integration Runtime Executor Queued Tasks |`AirflowIntegrationRuntimeExecutorQueuedTasks` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Executor Running Tasks**<br><br>Airflow Integration Runtime Executor Running Tasks |`AirflowIntegrationRuntimeExecutorRunningTasks` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Job End**<br><br>Airflow Integration Runtime Job End |`AirflowIntegrationRuntimeJobEnd` |Count |Total (Sum) |`IntegrationRuntimeName`, `Job`|PT1M |No|
|**Airflow Integration Runtime Heartbeat Failure**<br><br>Airflow Integration Runtime Heartbeat Failure |`AirflowIntegrationRuntimeJobHeartbeatFailure` |Count |Total (Sum) |`IntegrationRuntimeName`, `Job`|PT1M |No|
|**Airflow Integration Runtime Job Start**<br><br>Airflow Integration Runtime Job Start |`AirflowIntegrationRuntimeJobStart` |Count |Total (Sum) |`IntegrationRuntimeName`, `Job`|PT1M |No|
|**Airflow Integration Runtime Memory Percentage**<br><br>Airflow Integration Runtime Memory Percentage |`AirflowIntegrationRuntimeMemoryPercentage` |Percent |Average |`IntegrationRuntimeName`, `ContainerName`|PT1M |Yes|
|**Airflow Integration Runtime Memory Usage**<br><br>Airflow Integration Runtime Memory Usage |`AirflowIntegrationRuntimeMemoryUsage` |Bytes |Average |`IntegrationRuntimeName`, `ContainerName`|PT1M |Yes|
|**Airflow Integration Runtime Node Count**<br><br>Airflow Integration Runtime Node Count |`AirflowIntegrationRuntimeNodeCount` |Count |Average |`IntegrationRuntimeName`, `ComputeNodeSize`|PT1M |Yes|
|**Airflow Integration Runtime Operator Failures**<br><br>Airflow Integration Runtime Operator Failures |`AirflowIntegrationRuntimeOperatorFailures` |Count |Total (Sum) |`IntegrationRuntimeName`, `Operator`|PT1M |No|
|**Airflow Integration Runtime Operator Successes**<br><br>Airflow Integration Runtime Operator Successes |`AirflowIntegrationRuntimeOperatorSuccesses` |Count |Total (Sum) |`IntegrationRuntimeName`, `Operator`|PT1M |No|
|**Airflow Integration Runtime Pool Open Slots**<br><br>Airflow Integration Runtime Pool Open Slots |`AirflowIntegrationRuntimePoolOpenSlots` |Count |Total (Sum) |`IntegrationRuntimeName`, `Pool`|PT1M |No|
|**Airflow Integration Runtime Pool Queued Slots**<br><br>Airflow Integration Runtime Pool Queued Slots |`AirflowIntegrationRuntimePoolQueuedSlots` |Count |Total (Sum) |`IntegrationRuntimeName`, `Pool`|PT1M |No|
|**Airflow Integration Runtime Pool Running Slots**<br><br>Airflow Integration Runtime Pool Running Slots |`AirflowIntegrationRuntimePoolRunningSlots` |Count |Total (Sum) |`IntegrationRuntimeName`, `Pool`|PT1M |No|
|**Airflow Integration Runtime Pool Starving Tasks**<br><br>Airflow Integration Runtime Pool Starving Tasks |`AirflowIntegrationRuntimePoolStarvingTasks` |Count |Total (Sum) |`IntegrationRuntimeName`, `Pool`|PT1M |No|
|**Airflow Integration Runtime Scheduler Critical Section Busy**<br><br>Airflow Integration Runtime Scheduler Critical Section Busy |`AirflowIntegrationRuntimeSchedulerCriticalSectionBusy` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Scheduler Critical Section Duration**<br><br>Airflow Integration Runtime Scheduler Critical Section Duration |`AirflowIntegrationRuntimeSchedulerCriticalSectionDuration` |Milliseconds |Average |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Scheduler Failed SLA Email Attempts**<br><br>Airflow Integration Runtime Scheduler Failed SLA Email Attempts |`AirflowIntegrationRuntimeSchedulerFailedSLAEmailAttempts` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Scheduler Heartbeats**<br><br>Airflow Integration Runtime Scheduler Heartbeats |`AirflowIntegrationRuntimeSchedulerHeartbeat` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Scheduler Orphaned Tasks Adopted**<br><br>Airflow Integration Runtime Scheduler Orphaned Tasks Adopted |`AirflowIntegrationRuntimeSchedulerOrphanedTasksAdopted` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Scheduler Orphaned Tasks Cleared**<br><br>Airflow Integration Runtime Scheduler Orphaned Tasks Cleared |`AirflowIntegrationRuntimeSchedulerOrphanedTasksCleared` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Scheduler Tasks Executable**<br><br>Airflow Integration Runtime Scheduler Tasks Executable |`AirflowIntegrationRuntimeSchedulerTasksExecutable` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Scheduler Tasks Killed Externally**<br><br>Airflow Integration Runtime Scheduler Tasks Killed Externally |`AirflowIntegrationRuntimeSchedulerTasksKilledExternally` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Scheduler Tasks Running**<br><br>Airflow Integration Runtime Scheduler Tasks Running |`AirflowIntegrationRuntimeSchedulerTasksRunning` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Scheduler Tasks Starving**<br><br>Airflow Integration Runtime Scheduler Tasks Starving |`AirflowIntegrationRuntimeSchedulerTasksStarving` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Started Task Instances**<br><br>Airflow Integration Runtime Started Task Instances |`AirflowIntegrationRuntimeStartedTaskInstances` |Count |Total (Sum) |`IntegrationRuntimeName`, `DagId`, `TaskId`|PT1M |No|
|**Airflow Integration Runtime Task Instance Created Using Operator**<br><br>Airflow Integration Runtime Task Instance Created Using Operator |`AirflowIntegrationRuntimeTaskInstanceCreatedUsingOperator` |Count |Total (Sum) |`IntegrationRuntimeName`, `Operator`|PT1M |No|
|**Airflow Integration Runtime Task Instance Duration**<br><br>Airflow Integration Runtime Task Instance Duration |`AirflowIntegrationRuntimeTaskInstanceDuration` |Milliseconds |Average |`IntegrationRuntimeName`, `DagId`, `TaskID`|PT1M |No|
|**Airflow Integration Runtime Task Instance Failures**<br><br>Airflow Integration Runtime Task Instance Failures |`AirflowIntegrationRuntimeTaskInstanceFailures` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Task Instance Finished**<br><br>Airflow Integration Runtime Task Instance Finished |`AirflowIntegrationRuntimeTaskInstanceFinished` |Count |Total (Sum) |`IntegrationRuntimeName`, `DagId`, `TaskId`, `State`|PT1M |No|
|**Airflow Integration Runtime Task Instance Previously Succeeded**<br><br>Airflow Integration Runtime Task Instance Previously Succeeded |`AirflowIntegrationRuntimeTaskInstancePreviouslySucceeded` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Task Instance Successes**<br><br>Airflow Integration Runtime Task Instance Successes |`AirflowIntegrationRuntimeTaskInstanceSuccesses` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Task Removed From DAG**<br><br>Airflow Integration Runtime Task Removed From DAG |`AirflowIntegrationRuntimeTaskRemovedFromDAG` |Count |Total (Sum) |`IntegrationRuntimeName`, `DagId`|PT1M |No|
|**Airflow Integration Runtime Task Restored To DAG**<br><br>Airflow Integration Runtime Task Restored To DAG |`AirflowIntegrationRuntimeTaskRestoredToDAG` |Count |Total (Sum) |`IntegrationRuntimeName`, `DagId`|PT1M |No|
|**Airflow Integration Runtime Triggers Blocked Main Thread**<br><br>Airflow Integration Runtime Triggers Blocked Main Thread |`AirflowIntegrationRuntimeTriggersBlockedMainThread` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Triggers Failed**<br><br>Airflow Integration Runtime Triggers Failed |`AirflowIntegrationRuntimeTriggersFailed` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Triggers Running**<br><br>Airflow Integration Runtime Triggers Running |`AirflowIntegrationRuntimeTriggersRunning` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Triggers Succeeded**<br><br>Airflow Integration Runtime Triggers Succeeded |`AirflowIntegrationRuntimeTriggersSucceeded` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Airflow Integration Runtime Zombie Tasks Killed**<br><br>Airflow Integration Runtime Zombie Tasks Killed |`AirflowIntegrationRuntimeZombiesKilled` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |No|
|**Total factory size (GB unit)**<br><br>Total factory size (GB unit) |`FactorySizeInGbUnits` |Count |Maximum |\<none\>|PT1M |Yes|
|**Integration runtime available memory**<br><br>Integration runtime available memory |`IntegrationRuntimeAvailableMemory` |Bytes |Average |`IntegrationRuntimeName`, `NodeName`|PT1M |Yes|
|**Integration runtime available node count**<br><br>Integration runtime available node count |`IntegrationRuntimeAvailableNodeNumber` |Count |Average |`IntegrationRuntimeName`|PT1M |Yes|
|**Integration runtime queue duration**<br><br>Integration runtime queue duration |`IntegrationRuntimeAverageTaskPickupDelay` |Seconds |Average |`IntegrationRuntimeName`|PT1M |Yes|
|**Integration runtime CPU utilization**<br><br>Integration runtime CPU utilization |`IntegrationRuntimeCpuPercentage` |Percent |Average |`IntegrationRuntimeName`, `NodeName`|PT1M |Yes|
|**Integration runtime queue length**<br><br>Integration runtime queue length |`IntegrationRuntimeQueueLength` |Count |Average |`IntegrationRuntimeName`|PT1M |Yes|
|**Maximum allowed factory size (GB unit)**<br><br>Maximum allowed factory size (GB unit) |`MaxAllowedFactorySizeInGbUnits` |Count |Maximum |\<none\>|PT1M |Yes|
|**Maximum allowed entities count**<br><br>Maximum allowed entities count |`MaxAllowedResourceCount` |Count |Maximum |\<none\>|PT1M |Yes|
|**Copy available capacity percentage of MVNet integration runtime**<br><br>Copy available capacity percentage of MVNet integration runtime |`MVNetIRCopyAvailableCapacityPCT` |Percent |Maximum |`IntegrationRuntimeName`|PT1M |Yes|
|**Copy capacity utilization of MVNet integration runtime**<br><br>Copy capacity utilization of MVNet integration runtime |`MVNetIRCopyCapacityUtilization` |Percent |Maximum |`IntegrationRuntimeName`|PT1M |Yes|
|**Copy waiting queue length of MVNet integration runtime**<br><br>Copy waiting queue length of MVNet integration runtime |`MVNetIRCopyWaitingQueueLength` |Count |Average |`IntegrationRuntimeName`|PT1M |Yes|
|**External available capacity percentage of MVNet integration runtime**<br><br>External available capacity percentage of MVNet integration runtime |`MVNetIRExternalAvailableCapacityPCT` |Percent |Maximum |`IntegrationRuntimeName`|PT1M |Yes|
|**External capacity utilization of MVNet integration runtime**<br><br>External capacity utilization of MVNet integration runtime |`MVNetIRExternalCapacityUtilization` |Percent |Maximum |`IntegrationRuntimeName`|PT1M |Yes|
|**External waiting queue length of MVNet integration runtime**<br><br>External waiting queue length of MVNet integration runtime |`MVNetIRExternalWaitingQueueLength` |Count |Average |`IntegrationRuntimeName`|PT1M |Yes|
|**Pipeline available capacity percentage of MVNet integration runtime**<br><br>Pipeline available capacity percentage of MVNet integration runtime |`MVNetIRPipelineAvailableCapacityPCT` |Percent |Maximum |`IntegrationRuntimeName`|PT1M |Yes|
|**Pipeline capacity utilization of MVNet integration runtime**<br><br>Pipeline capacity utilization of MVNet integration runtime |`MVNetIRPipelineCapacityUtilization` |Percent |Maximum |`IntegrationRuntimeName`|PT1M |Yes|
|**Pipeline waiting queue length of MVNet integration runtime**<br><br>Pipeline waiting queue length of MVNet integration runtime |`MVNetIRPipelineWaitingQueueLength` |Count |Average |`IntegrationRuntimeName`|PT1M |Yes|
|**Cancelled pipeline runs metrics**<br><br>Cancelled pipeline runs metrics |`PipelineCancelledRuns` |Count |Total (Sum) |`FailureType`, `CancelledBy`, `Name`|PT1M |Yes|
|**Elapsed Time Pipeline Runs Metrics**<br><br>Elapsed Time Pipeline Runs Metrics |`PipelineElapsedTimeRuns` |Count |Total (Sum) |`RunId`, `Name`|PT1M |Yes|
|**Failed pipeline runs metrics**<br><br>Failed pipeline runs metrics |`PipelineFailedRuns` |Count |Total (Sum) |`FailureType`, `Name`|PT1M |Yes|
|**Succeeded pipeline runs metrics**<br><br>Succeeded pipeline runs metrics |`PipelineSucceededRuns` |Count |Total (Sum) |`FailureType`, `Name`|PT1M |Yes|
|**Total entities count**<br><br>Total entities count |`ResourceCount` |Count |Maximum |\<none\>|PT1M |Yes|
|**Cancelled SSIS integration runtime start metrics**<br><br>Cancelled SSIS integration runtime start metrics |`SSISIntegrationRuntimeStartCancel` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |Yes|
|**Failed SSIS integration runtime start metrics**<br><br>Failed SSIS integration runtime start metrics |`SSISIntegrationRuntimeStartFailed` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |Yes|
|**Succeeded SSIS integration runtime start metrics**<br><br>Succeeded SSIS integration runtime start metrics |`SSISIntegrationRuntimeStartSucceeded` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |Yes|
|**Stuck SSIS integration runtime stop metrics**<br><br>Stuck SSIS integration runtime stop metrics |`SSISIntegrationRuntimeStopStuck` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |Yes|
|**Succeeded SSIS integration runtime stop metrics**<br><br>Succeeded SSIS integration runtime stop metrics |`SSISIntegrationRuntimeStopSucceeded` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |Yes|
|**Cancelled SSIS package execution metrics**<br><br>Cancelled SSIS package execution metrics |`SSISPackageExecutionCancel` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |Yes|
|**Failed SSIS package execution metrics**<br><br>Failed SSIS package execution metrics |`SSISPackageExecutionFailed` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |Yes|
|**Succeeded SSIS package execution metrics**<br><br>Succeeded SSIS package execution metrics |`SSISPackageExecutionSucceeded` |Count |Total (Sum) |`IntegrationRuntimeName`|PT1M |Yes|
|**Cancelled trigger runs metrics**<br><br>Cancelled trigger runs metrics |`TriggerCancelledRuns` |Count |Total (Sum) |`Name`, `FailureType`|PT1M |Yes|
|**Failed trigger runs metrics**<br><br>Failed trigger runs metrics |`TriggerFailedRuns` |Count |Total (Sum) |`Name`, `FailureType`|PT1M |Yes|
|**Succeeded trigger runs metrics**<br><br>Succeeded trigger runs metrics |`TriggerSucceededRuns` |Count |Total (Sum) |`Name`, `FailureType`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
