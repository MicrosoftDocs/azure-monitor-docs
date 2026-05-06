---
title: Supported metrics - Microsoft.CognitiveServices/accounts/projects
description: Reference for Microsoft.CognitiveServices/accounts/projects metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 01/20/2026
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
|**Agent Threads (Preview)**<br><br>Number of events for AI Agent threads in this project. |`AgentThreads` |Count |Count, Total (Sum), Average, Maximum, Minimum |`EventType`|PT1M |No|
|**Agent Tool Calls (Preview)**<br><br>Number of tool calls made by AI Agents in this project. |`AgentToolCalls` |Count |Count, Total (Sum), Average, Maximum, Minimum |`AgentId`, `ModelName`, `ToolName`|PT1M |No|
|**Agent Usage Indexed Files (Preview)**<br><br>Number of files indexed for AI Agent usage like retrieval in this project. |`AgentUsageIndexedFiles` |Count |Count, Total (Sum), Average, Maximum, Minimum |`ErrorCode`, `Status`, `VectorStoreId`|PT1M |No|

### Category: Models - HTTP Requests
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Model Availability Rate**<br><br>Availability percentage with the following calculation: (Total Calls - Server Errors)/Total Calls. Server Errors include any HTTP responses >=500. |`ModelAvailabilityRate` |Percent |Minimum, Maximum, Average |`Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |No|
|**Model Requests**<br><br>Number of calls made to the model API over a period of time. Applies to PTU, PTU-Managed and Pay-as-you-go deployments. |`ModelRequests` |Count |Total (Sum) |`ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `StatusCode`|PT1M |Yes|

### Category: Models - Latency
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Time Between Tokens**<br><br>For streaming requests; Model token generation rate, measured in milliseconds. Applies to PTU and PTU-managed deployments. |`NormalizedTimeBetweenTokens` |MilliSeconds |Maximum, Minimum, Average |`ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |Yes|
|**Normalized Time to First Byte**<br><br>For streaming and non-streaming requests; time it takes for first byte of response data to be received after request is made by model, normalized by token. Applies to PTU, PTU-managed, and Pay-as-you-go deployments. |`NormalizedTimeToFirstToken` |MilliSeconds |Maximum, Minimum, Average |`ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |Yes|
|**Time to Last Byte**<br><br>For streaming and non-streaming requests; time it takes for last byte of response data to be received after request is made by model. Applies to PTU, PTU-managed, and Pay-as-you-go deployments. |`TimeToLastByte` |MilliSeconds |Maximum, Minimum, Average |`ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |Yes|
|**Time to Response**<br><br>Recommended latency (responsiveness) measure for streaming requests. Applies to PTU and PTU-managed deployments. Calculated as time taken for the first response to appear after a user sends a prompt, as measured by the API gateway. This number increases as the prompt size increases and/or cache hit size reduces. To breakdown time to response metric, you can add a filter or apply splitting by the following dimensions: ModelDeploymentName, ModelName, and ModelVersion. <br><br>Note: this metric is an approximation as measured latency is heavily dependent on multiple factors, including concurrent calls and overall workload pattern. In addition, it does not account for any client-side latency that may exist between your client and the API endpoint. Please refer to your own logging for optimal latency tracking. |`TimeToResponse` |MilliSeconds |Minimum, Maximum, Average |`ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `StatusCode`|PT1M |Yes|
|**Tokens Per Second**<br><br>Enumerates the generation speed for a given model response. The total tokens generated is divided by the time to generate the tokens, in seconds. Applies to PTU and PTU-managed deployments. |`TokensPerSecond` |Count |Maximum, Minimum, Average |`ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |Yes|

### Category: Models - Usage
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Audio Input Tokens**<br><br>Number of audio prompt tokens processed (input) on an OpenAI model. Applies to PTU-managed model deployments. |`AudioInputTokens` |Count |Total (Sum) |`ModelDeploymentName`, `ModelName`, `ModelVersion`, `Region`|PT1M |Yes|
|**Audio Output Tokens**<br><br>Number of audio prompt tokens generated (output) on an OpenAI model. Applies to PTU-managed model deployments. |`AudioOutputTokens` |Count |Total (Sum) |`ModelDeploymentName`, `ModelName`, `ModelVersion`, `Region`|PT1M |Yes|
|**Input Tokens**<br><br>Number of prompt tokens processed (input) on a model. Applies to PTU, PTU-Managed and Pay-as-you-go deployments. |`InputTokens` |Count |Total (Sum) |`ApiName`, `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |Yes|
|**Output Tokens**<br><br>Number of tokens generated (output) from an OpenAI model. Applies to PTU, PTU-Managed and Pay-as-you-go deployments. |`OutputTokens` |Count |Total (Sum) |`ApiName`, `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |Yes|
|**Provisioned Utilization**<br><br>Utilization % for a provisoned-managed deployment, calculated as (PTUs consumed / PTUs deployed) x 100. When utilization is greater than or equal to 100%, calls are throttled and error code 429 returned. |`ProvisionedUtilization` |Percent |Minimum, Maximum, Average |`Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |No|
|**Total Tokens**<br><br>Number of inference tokens processed on a model. Calculated as prompt tokens (input) plus generated tokens (output). Applies to PTU, PTU-Managed and Pay-as-you-go deployments. |`TotalTokens` |Count |Total (Sum) |`ApiName`, `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |Yes|

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
