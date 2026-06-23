---
title: Supported metrics - Microsoft.CognitiveServices/accounts/projects
description: Reference for Microsoft.CognitiveServices/accounts/projects metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 06/19/2026
ms.custom: Microsoft.CognitiveServices/accounts/projects, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.CognitiveServices/accounts/projects

The following table lists the metrics available for the Microsoft.CognitiveServices/accounts/projects resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.CognitiveServices/accounts/projects](../supported-logs/microsoft-cognitiveservices-accounts-projects-logs.md)


### Category: AI Agents
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Agent Events (Preview)**<br><br>Number of events for AI Agents in this project. |`AgentEvents` |Count |Count, Total (Sum), Average, Maximum, Minimum |`EventType`|PT1M |No|
|**Agent Input Tokens (Preview)**<br><br>Number of input tokens for AI Agents in this project. |`AgentInputTokens` |Count |Total (Sum), Average, Maximum, Minimum |`AgentId`, `ModelName`, `TokenType`|PT1M |No|
|**Agent User Messages (Preview)**<br><br>Number of events for AI Agent user messages in this project. |`AgentMessages` |Count |Count, Total (Sum), Average, Maximum, Minimum |`EventType`, `ThreadId`|PT1M |No|
|**Agent Output Tokens (Preview)**<br><br>Number of output tokens for AI Agents in this project. |`AgentOutputTokens` |Count |Total (Sum), Average, Maximum, Minimum |`AgentId`, `ModelName`, `TokenType`|PT1M |No|
|**Agent Responses (Preview)**<br><br>Number of responses by AI Agents in this project. |`AgentResponses` |Count |Count, Total (Sum), Average, Maximum, Minimum |`AgentId`, `ModelName`, `ResponseStatus`|PT1M |No|
|**Agent Runs (Preview)**<br><br>Number of runs by AI Agents in this project. |`AgentRuns` |Count |Count, Total (Sum), Average, Maximum, Minimum |`AgentId`, `ModelName`, `RunStatus`, `StatusCode`, `ThreadId`, `StreamType`|PT1M |No|
|**Hosted Agents Memory GiB Hours (Preview)**<br><br>Total GiB-hours of memory consumed by Foundry Hosted Agents in this project. |`AgentsHostedMemoryUsage` |Count |Total (Sum), Average, Maximum, Minimum |`AgentId`|PT1M |No|
|**Hosted Agents vCPU Hours (Preview)**<br><br>Total vCPU core-hours consumed by Foundry Hosted Agents in this project. |`AgentsHostedvCPUUsage` |Count |Total (Sum), Average, Maximum, Minimum |`AgentId`|PT1M |No|
|**Agent Threads (Preview)**<br><br>Number of events for AI Agent threads in this project. |`AgentThreads` |Count |Count, Total (Sum), Average, Maximum, Minimum |`EventType`|PT1M |No|
|**Agent Tool Calls (Preview)**<br><br>Number of tool calls made by AI Agents in this project. |`AgentToolCalls` |Count |Count, Total (Sum), Average, Maximum, Minimum |`AgentId`, `ModelName`, `ToolName`|PT1M |No|
|**Agent Usage Indexed Files (Preview)**<br><br>Number of files indexed for AI Agent usage like retrieval in this project. |`AgentUsageIndexedFiles` |Count |Count, Total (Sum), Average, Maximum, Minimum |`ErrorCode`, `Status`, `VectorStoreId`|PT1M |No|

### Category: Resource
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**CpuCapacityMillicores**<br><br>Maximum capacity of a CPU node in millicores. Capacity is aggregated in one minute intervals. |`CpuCapacityMillicores` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `Region`, `InstanceId`, `ComputeName`|PT1M |Yes|
|**CpuMemoryCapacityMegabytes**<br><br>Maximum memory capacity of a CPU node in megabytes. Capacity is aggregated in one minute intervals. |`CpuMemoryCapacityMegabytes` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `Region`, `InstanceId`, `ComputeName`|PT1M |Yes|
|**CpuMemoryUtilizationMegabytes**<br><br>Memory utilization of a CPU node in megabytes. Utilization is aggregated in one minute intervals. |`CpuMemoryUtilizationMegabytes` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `Region`, `InstanceId`, `ComputeName`|PT1M |Yes|
|**CpuMemoryUtilizationPercentage**<br><br>Memory utilization percentage of a CPU node. Utilization is aggregated in one minute intervals. |`CpuMemoryUtilizationPercentage` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `Region`, `InstanceId`, `ComputeName`|PT1M |Yes|
|**CpuUtilization**<br><br>Percentage of utilization on a CPU node. Utilization is reported at one minute intervals. |`CpuUtilization` |Count |Average, Maximum, Minimum, Total (Sum) |`Scenario`, `runId`, `Region`, `NodeId`, `ClusterName`|PT1M |Yes|
|**CpuUtilizationMillicores**<br><br>Utilization of a CPU node in millicores. Utilization is aggregated in one minute intervals. |`CpuUtilizationMillicores` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `Region`, `ComputeName`|PT1M |Yes|
|**CpuUtilizationPercentage**<br><br>Utilization percentage of a CPU node. Utilization is aggregated in one minute intervals. |`CpuUtilizationPercentage` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `Region`, `InstanceId`, `ComputeName`|PT1M |Yes|
|**DiskAvailMegabytes**<br><br>Available disk space in megabytes. Metrics are aggregated in one minute intervals. |`DiskAvailMegabytes` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`|PT1M |Yes|
|**DiskReadMegabytes**<br><br>Data read from disk in megabytes. Metrics are aggregated in one minute intervals. |`DiskReadMegabytes` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`|PT1M |Yes|
|**DiskUsedMegabytes**<br><br>Used disk space in megabytes. Metrics are aggregated in one minute intervals. |`DiskUsedMegabytes` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`|PT1M |Yes|
|**DiskWriteMegabytes**<br><br>Data written into disk in megabytes. Metrics are aggregated in one minute intervals. |`DiskWriteMegabytes` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`|PT1M |Yes|
|**GpuCapacityMilliGPUs**<br><br>Maximum capacity of a GPU device in milli-GPUs. Capacity is aggregated in one minute intervals. |`GpuCapacityMilliGPUs` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `Region`, `InstanceId`, `DeviceId`, `ComputeName`|PT1M |Yes|
|**GpuEnergyJoules**<br><br>Interval energy in Joules on a GPU node. Energy is reported at one minute intervals. |`GpuEnergyJoules` |Count |Average, Maximum, Minimum, Total (Sum) |`Scenario`, `runId`, `rootRunId`, `InstanceId`, `DeviceId`, `ComputeName`|PT1M |Yes|
|**GpuMemoryCapacityMegabytes**<br><br>Maximum memory capacity of a GPU device in megabytes. Capacity aggregated in one minute intervals. |`GpuMemoryCapacityMegabytes` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `Region`, `InstanceId`, `DeviceId`, `ComputeName`|PT1M |Yes|
|**GpuMemoryUtilization**<br><br>Percentage of memory utilization on a GPU node. Utilization is reported at one minute intervals. |`GpuMemoryUtilization` |Count |Average, Maximum, Minimum, Total (Sum) |`Scenario`, `runId`, `NodeId`, `DeviceId`, `ClusterName`|PT1M |Yes|
|**GpuMemoryUtilizationMegabytes**<br><br>Memory utilization of a GPU device in megabytes. Utilization aggregated in one minute intervals. |`GpuMemoryUtilizationMegabytes` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `Region`, `InstanceId`, `DeviceId`, `ComputeName`|PT1M |Yes|
|**GpuMemoryUtilizationPercentage**<br><br>Memory utilization percentage of a GPU device. Utilization aggregated in one minute intervals. |`GpuMemoryUtilizationPercentage` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `Region`, `InstanceId`, `DeviceId`, `ComputeName`|PT1M |Yes|
|**GpuUtilization**<br><br>Percentage of utilization on a GPU node. Utilization is reported at one minute intervals. |`GpuUtilization` |Count |Average, Maximum, Minimum, Total (Sum) |`Scenario`, `runId`, `NodeId`, `DeviceId`, `ClusterName`|PT1M |Yes|
|**GpuUtilizationMilliGPUs**<br><br>Utilization of a GPU device in milli-GPUs. Utilization is aggregated in one minute intervals. |`GpuUtilizationMilliGPUs` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `Region`, `InstanceId`, `DeviceId`, `ComputeName`|PT1M |Yes|
|**GpuUtilizationPercentage**<br><br>Utilization percentage of a GPU device. Utilization is aggregated in one minute intervals. |`GpuUtilizationPercentage` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `Region`, `InstanceId`, `DeviceId`, `ComputeName`|PT1M |Yes|
|**IBReceiveMegabytes**<br><br>Network data received over InfiniBand in megabytes. Metrics are aggregated in one minute intervals. |`IBReceiveMegabytes` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`, `DeviceId`|PT1M |Yes|
|**IBTransmitMegabytes**<br><br>Network data sent over InfiniBand in megabytes. Metrics are aggregated in one minute intervals. |`IBTransmitMegabytes` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`, `DeviceId`|PT1M |Yes|
|**NetworkInputMegabytes**<br><br>Network data received in megabytes. Metrics are aggregated in one minute intervals. |`NetworkInputMegabytes` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`, `DeviceId`|PT1M |Yes|
|**NetworkOutputMegabytes**<br><br>Network data sent in megabytes. Metrics are aggregated in one minute intervals. |`NetworkOutputMegabytes` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`, `DeviceId`|PT1M |Yes|
|**StorageAPIFailureCount**<br><br>Azure Blob Storage API calls failure count. |`StorageAPIFailureCount` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`|PT1M |Yes|
|**StorageAPISuccessCount**<br><br>Azure Blob Storage API calls success count. |`StorageAPISuccessCount` |Count |Average, Maximum, Minimum, Total (Sum) |`RunId`, `InstanceId`, `ComputeName`|PT1M |Yes|

### Category: Shared Resources
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Cosmos DB Request Units Consumed (Preview)**<br><br>Total Request Units (RU) consumed against Cosmos DB per project. RU is the billing unit for Cosmos DB throughput - maps to 70-90% of Cosmos DB costs. |`CosmosDbRequestUnits` |Count |Total (Sum), Average, Maximum, Minimum |`DatabaseName`, `ContainerName`|PT1M |No|
|**Cosmos DB Throttled Requests (Preview)**<br><br>Number of Cosmos DB requests throttled (HTTP 429) per project. Indicates contention on shared throughput for capacity planning. |`CosmosDbThrottledRequests` |Count |Count, Total (Sum), Average, Maximum, Minimum |`DatabaseName`, `ContainerName`|PT1M |No|
|**Search Retrieval Requests (Preview)**<br><br>Number of search retrieval requests made against Azure AI Search per knowledge base in this project. Proxy for search compute utilization (replica usage). |`SearchRetrievalRequests` |Count |Count, Total (Sum), Average, Maximum, Minimum |`ResourceType`, `IndexName`|PT1M |No|
|**Search Storage per Knowledge Base (Preview)**<br><br>Storage consumed by each knowledge base in the shared Azure AI Search index. Primary billing dimension - partition utilization drives cost. |`SearchStoragePerKnowledgeBase` |Bytes |Average, Maximum, Minimum |`IndexName`|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
