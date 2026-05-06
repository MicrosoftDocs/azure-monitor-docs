---
title: Supported metrics - Microsoft.CognitiveServices/accounts
description: Reference for Microsoft.CognitiveServices/accounts metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.CognitiveServices/accounts, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.CognitiveServices/accounts

The following table lists the metrics available for the Microsoft.CognitiveServices/accounts resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.CognitiveServices/accounts](../supported-logs/microsoft-cognitiveservices-accounts-logs.md)


### Category: Actions
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Action Occurences**<br><br>Number of times each action appears. |`ActionIdOccurrences` |Count |Total (Sum) |`ActionId`, `Mode`, `RunId`|PT1M |Yes|
|**Actions Per Event**<br><br>Number of actions per event. |`ActionsPerEvent` |Count |Average |`Mode`, `RunId`|PT1M |Yes|

### Category: Azure OpenAI - HTTP Requests
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Azure OpenAI AvailabilityRate**<br><br>Availability percentage with the following calculation: (Total Calls - Server Errors)/Total Calls. Server Errors include any HTTP responses >=500. |`AzureOpenAIAvailabilityRate` |Percent |Minimum, Maximum, Average |`ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |No|
|**Azure OpenAI Requests**<br><br>Number of calls made to the Azure OpenAI API over a period of time. Applies to PTU, PTU-Managed and Pay-as-you-go deployments. To breakdown API requests, you can add a filter or apply splitting by the following dimensions: ModelDeploymentName, ModelName, ModelVersion, StatusCode (successful, clienterrors, server errors), IsSpillover for spillover information, ServiceTier, StreamType (Streaming vs non-streaming requests) and operation. |`AzureOpenAIRequests` |Count |Total (Sum) |`ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `StatusCode`, `IsSpillover`, `ServiceTierRequest`, `ServiceTierResponse`|PT1M |Yes|

### Category: Azure OpenAI - Latency
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Time Between Token**<br><br>For streaming requests; model token generation rate, measured in milliseconds. Applies to PTU, PTU-managed and Pay-as-you-go deployments. |`AzureOpenAINormalizedTBTInMS` |MilliSeconds |Maximum, Minimum, Average |`Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |Yes|
|**Normalized Time to First Byte**<br><br>For streaming and non-streaming requests; time it takes for first byte of response data to be received after request is made by model, normalized by token. Applies to PTU, PTU-managed, and Pay-as-you-go deployments. |`AzureOpenAINormalizedTTFTInMS` |MilliSeconds |Maximum, Minimum, Average |`Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |Yes|
|**Time to Response**<br><br>Recommended latency (responsiveness) measure for streaming requests. Applies to PTU, PTU-managed and Pay-as-you-go deployments. Calculated as time taken for the first response to appear after a user sends a prompt, as measured by the API gateway. This number increases as the prompt size increases and/or cache hit size reduces. To breakdown time to response metric, you can add a filter or apply splitting by the following dimensions: ModelDeploymentName, ModelName, and ModelVersion. <br><br>Note: this metric is an approximation as measured latency is heavily dependent on multiple factors, including concurrent calls and overall workload pattern. In addition, it does not account for any client-side latency that may exist between your client and the API endpoint. Please refer to your own logging for optimal latency tracking. |`AzureOpenAITimeToResponse` |MilliSeconds |Minimum, Maximum, Average |`ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `StatusCode`|PT1M |Yes|
|**Tokens Per Second**<br><br>Enumerates the generation speed for a given Azure OpenAI model response. The total tokens generated is divided by the time to generate the tokens, in seconds. Applies to PTU, PTU-managed and Pay-as-you-go deployments. |`AzureOpenAITokenPerSecond` |Count |Maximum, Minimum, Average |`Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |Yes|
|**Time to Last Byte**<br><br>For streaming and non-streaming requests; time it takes for last byte of response data to be received after request is made by model. Applies to PTU, PTU-managed, and Pay-as-you-go deployments. |`AzureOpenAITTLTInMS` |MilliSeconds |Maximum, Minimum, Average |`Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |Yes|

### Category: Azure OpenAI - Usage
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Active Tokens**<br><br>Total tokens minus cached tokens over a period of time. Applies to PTU and PTU-managed deployments. Use this metric to understand your TPS or TPM based utilization for PTUs and compare to your benchmarks for target TPS or TPM for your scenarios. To breakdown API requests, you can add a filter or apply splitting by the following dimensions: ModelDeploymentName, ModelName, and ModelVersion. |`ActiveTokens` |Count |Minimum, Maximum, Average, Total (Sum) |`Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |Yes|
|**Audio Completion Tokens**<br><br>Number of audio prompt tokens generated (output) on an OpenAI model. Applies to PTU-managed and Pay-as-you-go model deployments. |`AudioCompletionTokens` |Count |Total (Sum) |`ModelDeploymentName`, `ModelName`, `ModelVersion`, `Region`|PT1M |Yes|
|**Audio Prompt Tokens**<br><br>Number of audio prompt tokens processed (input) on an OpenAI model. Applies to PTU-managed and Pay-as-you-go model deployments. |`AudioPromptTokens` |Count |Total (Sum) |`ModelDeploymentName`, `ModelName`, `ModelVersion`, `Region`|PT1M |Yes|
|**Prompt Token Cache Match Rate**<br><br>Percentage of prompt tokens that hit the cache. Applies to PTU and PTU-managed deployments. |`AzureOpenAIContextTokensCacheMatchRate` |Percent |Minimum, Maximum, Average |`Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |No|
|**Provisioned-managed Utilization (deprecated)**<br><br>Utilization % for a provisoned-managed deployment, calculated as (PTUs consumed / PTUs deployed) x 100. When utilization is greater than or equal to 100%, calls are throttled and error code 429 returned. To breakdown this metric, you can add a filter or apply splitting by the following dimensions: ModelDeploymentName, ModelName, ModelVersion and StreamType (Streaming vs non-streaming requests) |`AzureOpenAIProvisionedManagedUtilization` |Percent |Minimum, Maximum, Average |`Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |No|
|**Provisioned-managed Utilization V2**<br><br>Utilization % for a provisoned-managed deployment, calculated as (PTUs consumed / PTUs deployed) x 100. When utilization is greater than or equal to 100%, calls are throttled and error code 429 returned. To breakdown this metric, you can add a filter or apply splitting by the following dimensions: ModelDeploymentName, ModelName, ModelVersion and StreamType (Streaming vs non-streaming requests) |`AzureOpenAIProvisionedManagedUtilizationV2` |Percent |Minimum, Maximum, Average |`Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |No|
|**Processed FineTuned Training Hours**<br><br>Number of Training Hours Processed on an OpenAI FineTuned Model |`FineTunedTrainingHours` |Count |Total (Sum) |`ApiName`, `ModelDeploymentName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Generated Completion Tokens**<br><br>Number of tokens generated (output) from an OpenAI model. Applies to PTU, PTU-managed and Pay-as-you-go deployments. To breakdown this metric, you can add a filter or apply splitting by the following dimensions: ModelDeploymentName and ModelName. |`GeneratedTokens` |Count |Total (Sum) |`ApiName`, `ModelDeploymentName`, `FeatureName`, `UsageChannel`, `Region`, `ModelVersion`|PT1M |Yes|
|**Processed Prompt Tokens**<br><br>Number of prompt tokens processed (input) on an OpenAI model. Applies to PTU, PTU-managed and Pay-as-you-go deployments. To breakdown this metric, you can add a filter or apply splitting by the following dimensions: ModelDeploymentName and ModelName. |`ProcessedPromptTokens` |Count |Total (Sum) |`ApiName`, `ModelDeploymentName`, `FeatureName`, `UsageChannel`, `Region`, `ModelVersion`|PT1M |Yes|
|**Realtime API Seconds Used**<br><br>RealtimeAPI number of seconds used |`RealtimeUsageTime` |Count |Total (Sum) |`Region`, `ModelDeploymentName`|PT1M |Yes|
|**Processed Inference Tokens**<br><br>Number of inference tokens processed on an OpenAI model. Calculated as prompt tokens (input) plus generated tokens (output). Applies to PTU, PTU-managed and Pay-as-you-go deployments. To breakdown this metric, you can add a filter or apply splitting by the following dimensions: ModelDeploymentName and ModelName. |`TokenTransaction` |Count |Total (Sum) |`ApiName`, `ModelDeploymentName`, `FeatureName`, `UsageChannel`, `Region`, `ModelVersion`|PT1M |Yes|

### Category: Cognitive Services - HTTP Requests
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Blocked Calls**<br><br>Number of calls that exceeded rate or quota limit. Do not use for Azure OpenAI service. |`BlockedCalls` |Count |Total (Sum) |`ApiName`, `OperationName`, `Region`, `RatelimitKey`|PT1M |Yes|
|**Client Errors**<br><br>Number of calls with client side error (HTTP response code 4xx). Do not use for Azure OpenAI service. |`ClientErrors` |Count |Total (Sum) |`ApiName`, `OperationName`, `Region`, `RatelimitKey`|PT1M |Yes|
|**Data In**<br><br>Size of incoming data in bytes. Do not use for Azure OpenAI service. |`DataIn` |Bytes |Total (Sum) |`ApiName`, `OperationName`, `Region`|PT1M |Yes|
|**Data Out**<br><br>Size of outgoing data in bytes. Do not use for Azure OpenAI service. |`DataOut` |Bytes |Total (Sum) |`ApiName`, `OperationName`, `Region`|PT1M |Yes|
|**Latency**<br><br>Latency in milliseconds. Do not use for Azure OpenAI service. |`Latency` |MilliSeconds |Average |`ApiName`, `OperationName`, `Region`, `RatelimitKey`|PT1M |Yes|
|**Ratelimit**<br><br>The current ratelimit of the ratelimit key. Do not use for Azure OpenAI service. |`Ratelimit` |Count |Total (Sum) |`Region`, `RatelimitKey`|PT1M |Yes|
|**Server Errors**<br><br>Number of calls with service internal error (HTTP response code 5xx). Do not use for Azure OpenAI service. |`ServerErrors` |Count |Total (Sum) |`ApiName`, `OperationName`, `Region`, `RatelimitKey`|PT1M |Yes|
|**Successful Calls**<br><br>Number of successful calls. Do not use for Azure OpenAI service. |`SuccessfulCalls` |Count |Total (Sum) |`ApiName`, `OperationName`, `Region`, `RatelimitKey`|PT1M |Yes|
|**Total Calls**<br><br>Total number of calls. Do not use for Azure OpenAI service. |`TotalCalls` |Count |Total (Sum) |`ApiName`, `OperationName`, `Region`, `RatelimitKey`|PT1M |Yes|
|**Total Errors**<br><br>Total number of calls with error response (HTTP response code 4xx or 5xx). Do not use for Azure OpenAI service. |`TotalErrors` |Count |Total (Sum) |`ApiName`, `OperationName`, `Region`, `RatelimitKey`|PT1M |Yes|
|**Total Token Calls**<br><br>Total number of token calls. |`TotalTokenCalls` |Count |Total (Sum) |`ApiName`, `OperationName`, `Region`|PT1M |Yes|

### Category: Cognitive Services - SLI
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**AvailabilityRate**<br><br>Availability percentage with the following calculation: (Total Calls - Server Errors)/Total Calls. Server Errors include any HTTP responses >=500. Do not use for Azure OpenAI service. |`SuccessRate` |Percent |Minimum, Maximum, Average |`ApiName`, `OperationName`, `Region`, `RatelimitKey`|PT1M |No|

### Category: Content Understanding - Usage
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Face Transactions**<br><br>Number of API calls made to Face service |`FaceApiTransactions` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Processed Audio Minutes**<br><br>Minutes of audio processed |`ProcessedAudioMinutes` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Processed Pages**<br><br>Number of document pages processed |`ProcessedDocumentPages` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Processed Images**<br><br>Number of images processed |`ProcessedImageCount` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Processed Video Minutes**<br><br>Minutes of video processed |`ProcessedVideoMinutes` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Tokens**<br><br>Number of tokens consumed |`Tokens` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|

### Category: ContentSafety - Risks&Safety
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Potentially Abusive User Count**<br><br>Number of potentially abusive user that detected over a period of time. You can add a filter or apply splitting by the following dimension: ModelDeploymentName. |`RAIAbusiveUsersCount` |Count |Total (Sum) |`Region`, `ModelDeploymentName`|PT1M |Yes|
|**Harmful Volume Detected**<br><br>Number of calls made to Azure OpenAI API and detected as harmful(both block model and annotate mode) by content filter applied over a period of time. You can add a filter or apply splitting by the following dimensions: ModelDeploymentName, ModelName and TextType. |`RAIHarmfulRequests` |Count |Total (Sum) |`Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `ApiName`, `TextType`, `Category`, `Severity`|PT1M |Yes|
|**Blocked Volume**<br><br>Number of calls made to Azure OpenAI API and rejected by content filter applied over a period of time. You can add a filter or apply splitting by the following dimensions: ModelDeploymentName, ModelName and TextType. |`RAIRejectedRequests` |Count |Total (Sum) |`Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `ApiName`, `TextType`, `Category`|PT1M |Yes|
|**Safety System Event**<br><br>System event for risks & safety monitoring. You can add a filter or apply splitting by the following dimension: EventType. |`RAISystemEvent` |Count |Average |`Region`, `EventType`|PT1M |Yes|
|**Total Volume Sent For Safety Check**<br><br>Number of calls made to Azure OpenAI API and detected by content filter applied over a period of time. You can add a filter or apply splitting by the following dimensions: ModelDeploymentName, ModelName. |`RAITotalRequests` |Count |Total (Sum) |`Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `ApiName`|PT1M |Yes|

### Category: ContentSafety - Usage
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Call Count for Image Moderation**<br><br>Number of calls for image moderation. |`ContentSafetyImageAnalyzeRequestCount` |Count |Total (Sum) |`ApiVersion`|PT1M |Yes|
|**Call Count for Text Moderation**<br><br>Number of calls for text moderation. |`ContentSafetyTextAnalyzeRequestCount` |Count |Total (Sum) |`ApiVersion`|PT1M |Yes|

### Category: Estimations
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Baseline Random Event count**<br><br>Estimation for baseline random event count. |`BaselineRandomEventCount` |Count |Total (Sum) |`Mode`, `RunId`|PT1M |Yes|
|**Baseline Random Reward**<br><br>Estimation for baseline random reward. |`BaselineRandomReward` |Count |Total (Sum) |`Mode`, `RunId`|PT1M |Yes|
|**Online Event Count**<br><br>Estimation for online event count. |`OnlineEventCount` |Count |Total (Sum) |`Mode`, `RunId`|PT1M |Yes|
|**Online Reward**<br><br>Estimation for online reward. |`OnlineReward` |Count |Total (Sum) |`Mode`, `RunId`|PT1M |Yes|
|**User Baseline Event Count**<br><br>Estimation for user defined baseline event count. |`UserBaselineEventCount` |Count |Total (Sum) |`Mode`, `RunId`|PT1M |Yes|
|**User Baseline Reward**<br><br>Estimation for user defined baseline reward. |`UserBaselineReward` |Count |Total (Sum) |`Mode`, `RunId`|PT1M |Yes|

### Category: Feature Occurences
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Action Feature Occurrences**<br><br>Number of times each action feature appears. |`ActionFeatureIdOccurrences` |Count |Total (Sum) |`FeatureId`, `Mode`, `RunId`|PT1M |Yes|
|**Context Feature Occurrences**<br><br>Number of times each context feature appears. |`ContextFeatureIdOccurrences` |Count |Total (Sum) |`FeatureId`, `Mode`, `RunId`|PT1M |Yes|
|**Slot Feature Occurrences**<br><br>Number of times each slot feature appears. |`SlotFeatureIdOccurrences` |Count |Total (Sum) |`FeatureId`, `Mode`, `RunId`|PT1M |Yes|

### Category: FeatureCardinality
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Feature Cardinality by Action**<br><br>Feature Cardinality based on Action. |`FeatureCardinality_Action` |Count |Average |`FeatureId`, `Mode`, `RunId`|PT1M |Yes|
|**Feature Cardinality by Context**<br><br>Feature Cardinality based on Context. |`FeatureCardinality_Context` |Count |Average |`FeatureId`, `Mode`, `RunId`|PT1M |Yes|
|**Feature Cardinality by Slot**<br><br>Feature Cardinality based on Slot. |`FeatureCardinality_Slot` |Count |Average |`FeatureId`, `Mode`, `RunId`|PT1M |Yes|

### Category: Features Per Event
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Action Features Per Event**<br><br>Average number of action features per event. |`ActionFeaturesPerEvent` |Count |Average |`Mode`, `RunId`|PT1M |Yes|
|**Context Features Per Event**<br><br>Number of context features per event. |`ContextFeaturesPerEvent` |Count |Average |`Mode`, `RunId`|PT1M |Yes|
|**Slot Features Per Event**<br><br>Average number of slot features per event. |`SlotFeaturesPerEvent` |Count |Average |`Mode`, `RunId`|PT1M |Yes|

### Category: Language - Jobs
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Job Duration (Preview)**<br><br>Note: this value depends heavily on the input size, number of documents and task's complexity. This is an aggregate value across all job tasks. |`JobDuration` |MilliSeconds |Minimum, Maximum, Average |`JobStatus`, `JobType`|PT1M |Yes|

### Category: Models - HTTP Requests
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Model Availability Rate**<br><br>Availability percentage with the following calculation: (Total Calls - Server Errors)/Total Calls. Server Errors include any HTTP responses >=500. |`ModelAvailabilityRate` |Percent |Minimum, Maximum, Average |`Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |No|
|**Model Requests**<br><br>Number of calls made to the model API over a period of time. Applies to PTU, PTU-Managed and Pay-as-you-go deployments. |`ModelRequests` |Count |Total (Sum) |`ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `StatusCode`, `IsSpillover`, `ServiceTierRequest`, `ServiceTierResponse`|PT1M |Yes|

### Category: Models - Latency
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Time Between Tokens**<br><br>Model token generation rate, measured in milliseconds. Applies to PTU and PTU-managed deployments. For non-streaming requests, this value is an estimate. |`NormalizedTimeBetweenTokens` |MilliSeconds |Maximum, Minimum, Average |`ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |Yes|
|**Normalized Time to First Byte**<br><br>Time it takes for first byte of response data to be received after request is made by model, normalized by token. Applies to PTU, PTU-managed, and Pay-as-you-go deployments. For non-streaming requests, this value is an estimate. |`NormalizedTimeToFirstToken` |MilliSeconds |Maximum, Minimum, Average |`ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |Yes|
|**Time to Last Byte**<br><br>Time it takes for last byte of response data to be received after request is made by model. Applies to PTU, PTU-managed, and Pay-as-you-go deployments. For non-streaming requests, this value is an estimate. |`TimeToLastByte` |MilliSeconds |Maximum, Minimum, Average |`ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |Yes|
|**Time to Response**<br><br>Recommended latency (responsiveness) measure. Applies to PTU and PTU-managed deployments. Calculated as time taken for the first response to appear after a user sends a prompt, as measured by the API gateway. This number increases as the prompt size increases and/or cache hit size reduces. To breakdown time to response metric, you can add a filter or apply splitting by the following dimensions: ModelDeploymentName, ModelName, and ModelVersion. <br><br>Note: this metric is an approximation as measured latency is heavily dependent on multiple factors, including concurrent calls and overall workload pattern. In addition, it does not account for any client-side latency that may exist between your client and the API endpoint. For non-streaming requests, this value is an estimate. Please refer to your own logging for optimal latency tracking. |`TimeToResponse` |MilliSeconds |Minimum, Maximum, Average |`ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `StatusCode`|PT1M |Yes|
|**Tokens Per Second**<br><br>Enumerates the generation speed for a given model response. The total tokens generated is divided by the time to generate the tokens, in seconds. Applies to PTU and PTU-managed deployments. For non-streaming requests, this value is an estimate. |`TokensPerSecond` |Count |Maximum, Minimum, Average |`ApiName`, `OperationName`, `Region`, `StreamType`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |Yes|

### Category: Models - Usage
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Annotated Pages**<br><br>Total number of pages processed with annotations. Applies to PTU, PTU-Managed and Pay-as-you-go deployments. |`AnnotatedPages` |Count |Total (Sum) |`ApiName`, `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |Yes|
|**Audio Input Tokens**<br><br>Number of audio prompt tokens processed (input) on an OpenAI model. Applies to PTU-managed model deployments. |`AudioInputTokens` |Count |Total (Sum) |`ModelDeploymentName`, `ModelName`, `ModelVersion`, `Region`|PT1M |Yes|
|**Audio Output Tokens**<br><br>Number of audio prompt tokens generated (output) on an OpenAI model. Applies to PTU-managed model deployments. |`AudioOutputTokens` |Count |Total (Sum) |`ModelDeploymentName`, `ModelName`, `ModelVersion`, `Region`|PT1M |Yes|
|**Prompt tokens read from cache**<br><br>Total number of tokens read from the cache. Applies to Anthropic model deployments. Surfaced in response usage section as `cache_read_input_tokens` |`cacheReadInputTokens` |Count |Total (Sum) |`ApiName`, `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `ContextLength`|PT1M |Yes|
|**Prompt tokens written to cache (1 hour TTL)**<br><br>The number of prompt tokens used to create the 1 hour entry. Applies to Anthropic model deployments. Surfaced in response usage section as `cache_creation.ephemeral_1h_input_tokens` |`ephemeral1hInputTokens` |Count |Total (Sum) |`ApiName`, `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `ContextLength`|PT1M |Yes|
|**Prompt tokens written to cache (5 minute TTL)**<br><br>The number of prompt tokens used to create the 5 minute cache entry. Applies to Anthropic model deployments. Surfaced in response usage section as `cache_creation.ephemeral_5m_input_tokens` |`ephemeral5mInputTokens` |Count |Total (Sum) |`ApiName`, `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`, `ContextLength`|PT1M |Yes|
|**Generated Images**<br><br>Total number of images generated. Applies to PTU, PTU-Managed and Pay-as-you-go deployments. |`GeneratedImages` |Count |Total (Sum) |`ApiName`, `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |Yes|
|**Input Tokens**<br><br>Number of prompt tokens processed (input) on a model. Applies to PTU, PTU-Managed and Pay-as-you-go deployments. |`InputTokens` |Count |Total (Sum) |`ApiName`, `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |Yes|
|**Output Tokens**<br><br>Number of tokens generated (output) from an OpenAI model. Applies to PTU, PTU-Managed and Pay-as-you-go deployments. |`OutputTokens` |Count |Total (Sum) |`ApiName`, `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |Yes|
|**Provisioned Utilization**<br><br>Utilization % for a provisoned-managed deployment, calculated as (PTUs consumed / PTUs deployed) x 100. When utilization is greater than or equal to 100%, calls are throttled and error code 429 returned. |`ProvisionedUtilization` |Percent |Minimum, Maximum, Average |`Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |No|
|**Total Pages**<br><br>Total number of pages processed. Applies to PTU, PTU-Managed and Pay-as-you-go deployments. |`TotalPages` |Count |Total (Sum) |`ApiName`, `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |Yes|
|**Total Tokens**<br><br>Number of inference tokens processed on a model. Calculated as prompt tokens (input) plus generated tokens (output). Applies to PTU, PTU-Managed and Pay-as-you-go deployments. |`TotalTokens` |Count |Total (Sum) |`ApiName`, `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion`|PT1M |Yes|

### Category: Namespaces Per Event
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Action Namespaces Per Event**<br><br>Average number of action namespaces per event. |`ActionNamespacesPerEvent` |Count |Average |`Mode`, `RunId`|PT1M |Yes|
|**Context Namespaces Per Event**<br><br>Number of context namespaces per event. |`ContextNamespacesPerEvent` |Count |Average |`Mode`, `RunId`|PT1M |Yes|
|**Slot Namespaces Per Event**<br><br>Average number of slot namespaces per event. |`SlotNamespacesPerEvent` |Count |Average |`Mode`, `RunId`|PT1M |Yes|

### Category: Rewards
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Average Reward Per Event**<br><br>Average reward per event. |`Reward` |Count |Average |`BaselineAction`, `ChosenActionId`, `MatchesBaseline`, `NonDefaultReward`, `Mode`, `RunId`|PT1M |Yes|
|**Slot Reward**<br><br>Reward per slot. |`SlotReward` |Count |Average |`BaselineActionId`, `ChosenActionId`, `MatchesBaseline`, `NonDefaultReward`, `SlotId`, `SlotIndex`, `Mode`, `RunId`|PT1M |Yes|

### Category: Slots
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Baseline Estimator Overall Reward**<br><br>Baseline Estimator Overall Reward. |`BaselineEstimatorOverallReward` |Count |Average |`Mode`, `RunId`|PT1M |Yes|
|**Baseline Estimator Slot Reward**<br><br>Baseline Estimator Reward by slot. |`BaselineEstimatorSlotReward` |Count |Average |`SlotId`, `SlotIndex`, `Mode`, `RunId`|PT1M |Yes|
|**Baseline Random Estimator Overall Reward**<br><br>Baseline Random Estimator Overall Reward. |`BaselineRandomEstimatorOverallReward` |Count |Average |`Mode`, `RunId`|PT1M |Yes|
|**Baseline Random Estimator Slot Reward**<br><br>Baseline Random Estimator Reward by slot. |`BaselineRandomEstimatorSlotReward` |Count |Average |`SlotId`, `SlotIndex`, `Mode`, `RunId`|PT1M |Yes|
|**Slots**<br><br>Number of slots per event. |`NumberOfSlots` |Count |Average |`Mode`, `RunId`|PT1M |Yes|
|**Online Estimator Overall Reward**<br><br>Online Estimator Overall Reward. |`OnlineEstimatorOverallReward` |Count |Average |`Mode`, `RunId`|PT1M |Yes|
|**Online Estimator Slot Reward**<br><br>Online Estimator Reward by slot. |`OnlineEstimatorSlotReward` |Count |Average |`SlotId`, `SlotIndex`, `Mode`, `RunId`|PT1M |Yes|
|**Slot Occurrences**<br><br>Number of times each slot appears. |`SlotIdOccurrences` |Count |Total (Sum) |`SlotId`, `SlotIndex`, `Mode`, `RunId`|PT1M |Yes|

### Category: SpeechServices - Usage
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Audio Seconds Batch Transcribed**<br><br>Batch number of seconds transcribed |`AudioSecondsBatchTranscribed` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Audio Seconds Batch Whisper Transcribed**<br><br>Batch whisper number of seconds transcribed |`AudioSecondsBatchWhisperTranscribed` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Audio Seconds Fast Transcribed**<br><br>Fast number of seconds transcribed |`AudioSecondsFastTranscribed` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Audio Seconds Fast Whisper Transcribed**<br><br>Fast whisper number of seconds transcribed |`AudioSecondsFastWhisperTranscribed` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Audio Seconds Transcribed**<br><br>Number of seconds transcribed |`AudioSecondsTranscribed` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Audio Seconds Translated**<br><br>Number of seconds translated |`AudioSecondsTranslated` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Avatar Model Hosting Seconds**<br><br>Number of Seconds. |`AvatarModelHostingSeconds` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Avatar Model Training Seconds**<br><br>Number of Seconds. |`AvatarModelTrainingSeconds` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Number of Speaker Profiles**<br><br>Number of speaker profiles enrolled. Prorated hourly. |`NumberofSpeakerProfiles` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Speaker Recognition Transactions**<br><br>Number of speaker recognition transactions |`SpeakerRecognitionTransactions` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Speech Model Hosting Hours**<br><br>Number of speech model hosting hours |`SpeechModelHostingHours` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Synthesized Characters**<br><br>Number of Characters. |`SynthesizedCharacters` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Video Seconds Synthesized**<br><br>Number of seconds synthesized |`VideoSecondsSynthesized` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Voice Live Audio Input Tokens**<br><br>Number of audio input tokens, excluding cached tokens. |`VoiceLiveAudioInputTokens` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Voice Live Audio Output Tokens**<br><br>Number of audio output tokens. |`VoiceLiveAudioOutputTokens` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Voice Live Cached Audio Input Tokens**<br><br>Number of cached audio input tokens. |`VoiceLiveCachedAudioInputTokens` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Voice Live Cached Text Input Tokens**<br><br>Number of cached text input tokens. |`VoiceLiveCachedTextInputTokens` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Voice Live Text Input Tokens**<br><br>Number of text input tokens, excluding cached tokens. |`VoiceLiveTextInputTokens` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Voice Live Text Output Tokens**<br><br>Number of text output tokens. |`VoiceLiveTextOutputTokens` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Voice Model Hosting Hours**<br><br>Number of Hours. |`VoiceModelHostingHours` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Voice Model Training Minutes**<br><br>Number of Minutes. |`VoiceModelTrainingMinutes` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|

### Category: Translator Services - Usage
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Characters Trained (Deprecated)**<br><br>Total number of characters trained. |`CharactersTrained` |Count |Total (Sum) |`ApiName`, `OperationName`, `Region`|PT1M |Yes|
|**Characters Translated (Deprecated)**<br><br>Total number of characters in incoming text request. |`CharactersTranslated` |Count |Total (Sum) |`ApiName`, `OperationName`, `Region`|PT1M |Yes|
|**Document Characters Translated**<br><br>Number of characters in document translation request. |`DocumentCharactersTranslated` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Document Custom Characters Translated**<br><br>Number of characters in custom document translation request. |`DocumentCustomCharactersTranslated` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Document Sync Characters Translated**<br><br>Number of characters in document translation (synchronous) request. |`OneDocumentCharactersTranslated` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Document Sync Custom Characters Translated**<br><br>Number of characters in custom document translation (synchronous) request. |`OneDocumentCustomCharactersTranslated` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Text Characters Translated**<br><br>Number of characters in incoming text translation request. |`TextCharactersTranslated` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Text Custom Characters Translated**<br><br>Number of characters in incoming custom text translation request. |`TextCustomCharactersTranslated` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Text Trained Characters**<br><br>Number of characters trained using text translation. |`TextTrainedCharacters` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Translator Pro App Seconds**<br><br>Number of seconds of Translator Pro App usage. |`TranslatorProAppSeconds` |Seconds |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|

### Category: Usage
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Inference Count**<br><br>Inference Count of Carnegie Frontdoor Service |`CarnegieInferenceCount` |Count |Total (Sum) |`Region`, `Modality`, `Category`, `Language`, `SeverityLevel`, `UseCustomList`|PT1M |Yes|
|**Computer Vision Transactions**<br><br>Number of Computer Vision Transactions |`ComputerVisionTransactions` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Custom Vision Training Time**<br><br>Custom Vision training time |`CustomVisionTrainingTime` |Seconds |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Custom Vision Transactions**<br><br>Number of Custom Vision prediction transactions |`CustomVisionTransactions` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Face Images Trained**<br><br>Number of images trained. 1,000 images trained per transaction. |`FaceImagesTrained` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Faces Stored**<br><br>Number of faces stored, prorated daily. The number of faces stored is reported daily. |`FacesStored` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Face Transactions**<br><br>Number of API calls made to Face service |`FaceTransactions` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Images Stored**<br><br>Number of Custom Vision images stored. |`ImagesStored` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Learned Events**<br><br>Number of Learned Events. |`LearnedEvents` |Count |Total (Sum) |`IsMatchBaseline`, `Mode`, `RunId`|PT1M |Yes|
|**LUIS Speech Requests**<br><br>Number of LUIS speech to intent understanding requests |`LUISSpeechRequests` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**LUIS Text Requests**<br><br>Number of LUIS text requests |`LUISTextRequests` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Matched Rewards**<br><br>Number of Matched Rewards. |`MatchedRewards` |Count |Total (Sum) |`Mode`, `RunId`|PT1M |Yes|
|**Non Activated Events**<br><br>Number of skipped events. |`NonActivatedEvents` |Count |Total (Sum) |`Mode`, `RunId`|PT1M |Yes|
|**Observed Rewards**<br><br>Number of Observed Rewards. |`ObservedRewards` |Count |Total (Sum) |`Mode`, `RunId`|PT1M |Yes|
|**Processed Characters**<br><br>Number of Characters processed by Immersive Reader. |`ProcessedCharacters` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Processed Health Text Records**<br><br>Number of health text records processed |`ProcessedHealthTextRecords` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Processed Images**<br><br>Number of images processed |`ProcessedImages` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Processed Pages**<br><br>Number of pages processed |`ProcessedPages` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Processed Text Records**<br><br>Count of Text Records. |`ProcessedTextRecords` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**QA Text Records**<br><br>Number of text records processed |`QuestionAnsweringTextRecords` |Count |Total (Sum) |`ApiName`, `FeatureName`, `UsageChannel`, `Region`|PT1M |Yes|
|**Speech Session Duration (Deprecated)**<br><br>Total duration of speech session in seconds. |`SpeechSessionDuration` |Seconds |Total (Sum) |`ApiName`, `OperationName`, `Region`|PT1M |Yes|
|**Total Events**<br><br>Number of events. |`TotalEvents` |Count |Total (Sum) |`Mode`, `RunId`|PT1M |Yes|
|**Total Transactions (Deprecated)**<br><br>Total number of transactions. |`TotalTransactions` |Count |Total (Sum) |\<none\>|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
