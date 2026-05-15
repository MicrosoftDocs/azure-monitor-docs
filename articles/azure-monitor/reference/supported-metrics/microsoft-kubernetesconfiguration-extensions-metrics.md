---
title: Supported metrics - microsoft.kubernetesconfiguration/extensions
description: Reference for microsoft.kubernetesconfiguration/extensions metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 05/14/2026
ms.custom: microsoft.kubernetesconfiguration/extensions, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for microsoft.kubernetesconfiguration/extensions

The following table lists the metrics available for the microsoft.kubernetesconfiguration/extensions resource type.

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



### Category: Errors
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**File Sync Errors**<br><br>Number of file sync errors |`FileSyncErrors` |Count |Total (Sum), Average, Count |`volume_name`, `subvolume_name`, `transfer_mode`, `status`|PT1M |No|

### Category: Latency
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Api Request Duration in Seconds**<br><br>Histogram of request durations |`ApiRequestDurationSeconds` |Seconds |Average |`AppName`, `GpuEnabled`, `Method`, `Route`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Ingestion Time**<br><br>Total ingestion time in minutes |`IngestionTimeMinutes` |Seconds |Average |`AppName`, `GpuEnabled`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Input Preprocessing Time (Milliseconds)**<br><br>Input preprocessing time in milliseconds |`InputPreprocessingTimeMilliseconds` |Milliseconds |Average |`GpuEnabled`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Call LLM Total Time in Seconds**<br><br>Total call_llm time in seconds |`TotalCallLLMTimeSeconds` |Seconds |Average |`AppName`, `GpuEnabled`, `LLMProvider`, `OutputLength`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Embedding Generation Total Time in Seconds**<br><br>Total time taken to generate embeddings from local model |`TotalGenerateEmbeddingsTimeSeconds` |Seconds |Average |`AppName`, `GpuEnabled`, `InputLength`, `OutputLength`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Hybrid Search Embedding Generation Total Time in Seconds**<br><br>Total time taken to generate Hybrid Search embeddings from local model |`TotalGenerateHybridSearchEmbeddingsTimeSeconds` |Seconds |Average |`AppName`, `GpuEnabled`, `InputLength`, `OutputLength`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Reranking Generation Total Time in Seconds**<br><br>Total time taken to generate Reranking |`TotalGenerateRerankingTimeSeconds` |Seconds |Average |`AppName`, `GpuEnabled`, `InputLength`, `OutputLength`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Get Chat History Summary Total Time in Milliseconds**<br><br>Total get_chat_history_summary time in milliseconds |`TotalGetChatHistorySummaryTimeMilliseconds` |Milliseconds |Average |`AppName`, `GpuEnabled`, `InputHistoryPairs`, `LLMProvider`, `MaxTokens`, `OutputLength`, `Temperature`, `TopP`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Get LLM Payload Total Time in Milliseconds**<br><br>Total get_llm_payload time in milliseconds |`TotalGetLLMPayloadTimeMilliseconds` |Milliseconds |Average |`AppName`, `DiversityPenalty`, `GpuEnabled`, `LengthPenalty`, `LLMProvider`, `MaxTokens`, `RepetitionPenalty`, `Temperature`, `TopP`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Get Hybrid Search Total Time in Milliseconds**<br><br>Total hybrid search time in milliseconds |`TotalHybridSearchTimeMilliseconds` |Milliseconds |Average |`AppName`, `ChunkMinScore`, `GpuEnabled`, `IndexType`, `InputLength`, `MetricType`, `TopK`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Inference Total Time in Seconds**<br><br>Total inference time in seconds |`TotalInferenceTimeSeconds` |Seconds |Average |`AppName`, `DiversityPenalty`, `GpuEnabled`, `InputLength`, `LLMProvider`, `MaxTokens`, `OutputLength`, `RepetitionPenalty`, `Temperature`, `TopK`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Chunks Search Total Time in Milliseconds**<br><br>Total search chunks time in milliseconds |`TotalSearchChunksTimeMilliseconds` |Milliseconds |Average |`AppName`, `EmbeddingIndexName`, `GpuEnabled`, `InputLength`, `OutputChunks`, `TopK`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Search Total Time in Milliseconds**<br><br>Total time taken to search |`TotalSearchTimeMilliseconds` |Milliseconds |Average |`AppName`, `ChunkMinScore`, `GpuEnabled`, `InputLength`, `QueryType`, `TopK`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Similarity Search Total Time in Milliseconds**<br><br>Total time taken to search for similar documents |`TotalSimilaritySearchTimeMilliseconds` |Milliseconds |Average |`AppName`, `GpuEnabled`, `InputLength`, `ChunkMinScore`, `IndexType`, `MetricType`, `TopK`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|

### Category: Saturation
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Edgevolume Percentage Space Available**<br><br>Percentage of available space on Edgevolume |`EdgevolumePercentageSpaceAvailable` |Percent |Average, Minimum, Maximum |`edgevolume_name`|PT1M |No|
|**Edgevolume Space Available**<br><br>Bytes of available space on Edgevolume |`EdgevolumeSpaceAvailable` |Bytes |Total (Sum), Average, Minimum, Maximum |`edgevolume_name`|PT1M |No|
|**Edgevolume Space Total**<br><br>Bytes of total space on Edgevolume |`EdgevolumeSpaceTotal` |Bytes |Total (Sum), Average, Minimum, Maximum |`edgevolume_name`|PT1M |No|

### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Active PDU Sessions**<br><br>Number of Active PDU Sessions |`ActiveSessionCount` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |No|
|**API Failure Count**<br><br>Count of failed API requests |`ApiFailureCount` |Count |Count |`EndpointName`, `GpuEnabled`, `StatusCode`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**API Request Count**<br><br>Total number of API requests |`ApiRequestCount` |Count |Count |`AppName`, `GpuEnabled`, `Method`, `Route`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**API Success Count**<br><br>Count of successful API requests |`ApiSuccessCount` |Count |Count |`EndpointName`, `GpuEnabled`, `StatusCode`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Authentication Attempts**<br><br>Authentication attempts rate (per minute) |`AuthAttempt` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Authentication Failures**<br><br>Authentication failure rate (per minute) |`AuthFailure` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`, `Result`|PT1M |Yes|
|**Authentication Successes**<br><br>Authentication success rate (per minute) |`AuthSuccess` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Connected NodeBs**<br><br>Number of connected gNodeBs or eNodeBs |`ConnectedNodebs` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**DeRegistration Attempts**<br><br>UE deregistration attempts rate (per minute) |`DeRegistrationAttempt` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**DeRegistration Successes**<br><br>UE deregistration success rate (per minute) |`DeRegistrationSuccess` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Evaluation API Request Count**<br><br>Total number of Evaluation API requests |`EvaluationApiRequestCount` |Count |Count |`AppName`, `Method`, `Route`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Failed Skipped Count**<br><br>Count of failed or skipped files |`FailedSkippedCount` |Count |Count |`Category`, `GpuEnabled`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**File Ingestion Rate**<br><br>Total files ingested per Job |`FileIngestionRate` |Count |Total (Sum) |`AppName`, `GpuEnabled`, `FileType`, `JobID`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**File Sync Count**<br><br>Number of files successfully synchronized |`FileSyncCount` |Count |Total (Sum), Average, Count |`volume_name`, `subvolume_name`, `transfer_mode`|PT1M |No|
|**Hybrid Search Model API Request Count**<br><br>Total number of Hybrid Search Model API requests |`HybridSearchModelApiRequestCount` |Count |Count |`AppName`, `Method`, `Route`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Inference Answer Feedback**<br><br>Inference Answer Feedback |`InferenceAnswerFeedback` |Count |Count |`AppName`, `ChunkMinScore`, `ChunkScores`, `GpuEnabled`, `LLMProvider`, `RunId`, `Thumb`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Inference API Request Count**<br><br>Number of Inference API requests |`InferenceApiRequestCount` |Count |Count |`AppName`, `Method`, `Route`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Ingestion API Request Count**<br><br>Number of Ingestion API requests |`IngestionApiRequestCount` |Count |Count |`AppName`, `Method`, `Route`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Number of Evaluations**<br><br>Number of Evaluations |`NumberOfEvaluations` |Count |Count |`AppName`, `GpuEnabled`, `Method`, `Route`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Number of Jobs**<br><br>Number of jobs |`NumberOfJobs` |Count |Count |`AppName`, `GpuEnabled`, `Method`, `Route`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Paging Attempts**<br><br>Paging attempts rate (per minute) |`PagingAttempt` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Paging Failures**<br><br>Paging failure rate (per minute) |`PagingFailure` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Provisioned Subscribers**<br><br>Number of provisioned subscribers |`ProvisionedSubscribers` |Count |Total (Sum) |`PccpId`, `SiteId`|PT1M |No|
|**RAN Setup Failures**<br><br>RAN setup failure rate (per minute) |`RanSetupFailure` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`, `Cause`|PT1M |Yes|
|**RAN Setup Requests**<br><br>RAN setup reuests rate (per minute) |`RanSetupRequest` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**RAN Setup Responses**<br><br>RAN setup response rate (per minute) |`RanSetupResponse` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Registered Subscribers**<br><br>Number of registered subscribers |`RegisteredSubscribers` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Registered Subscribers Connected**<br><br>Number of registered and connected subscribers |`RegisteredSubscribersConnected` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Registered Subscribers Idle**<br><br>Number of registered and idle subscribers |`RegisteredSubscribersIdle` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Registration Attempts**<br><br>Registration attempts rate (per minute) |`RegistrationAttempt` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Registration Failures**<br><br>Registration failure rate (per minute) |`RegistrationFailure` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`, `Result`|PT1M |Yes|
|**Registration Successes**<br><br>Registration success rate (per minute) |`RegistrationSuccess` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Service Request Attempts**<br><br>Service request attempts rate (per minute) |`ServiceRequestAttempt` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Service Request Failures**<br><br>Service request failure rate (per minute) |`ServiceRequestFailure` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`, `Result`, `Tai`|PT1M |Yes|
|**Service Request Successes**<br><br>Service request success rate (per minute) |`ServiceRequestSuccess` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Session Establishment Attempts**<br><br>PDU session establishment attempts rate (per minute) |`SessionEstablishmentAttempt` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`, `Dnn`|PT1M |Yes|
|**Session Establishment Failures**<br><br>PDU session establishment failure rate (per minute) |`SessionEstablishmentFailure` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`, `Dnn`|PT1M |Yes|
|**Session Establishment Successes**<br><br>PDU session establishment success rate (per minute) |`SessionEstablishmentSuccess` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`, `Dnn`|PT1M |Yes|
|**Session Releases**<br><br>Session release rate (per minute) |`SessionRelease` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**UE Context Release Commands**<br><br>UE context release command message rate (per minute) |`UeContextReleaseCommand` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**UE Context Release Completes**<br><br>UE context release complete message rate (per minute) |`UeContextReleaseComplete` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**UE Context Release Requests**<br><br>UE context release request message rate (per minute) |`UeContextReleaseRequest` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**User Plane Bandwidth**<br><br>User plane bandwidth in bits/second. |`UserPlaneBandwidth` |BitsPerSecond |Total (Sum) |`PcdpId`, `SiteId`, `Direction`, `Interface`|PT1M |No|
|**User Plane Packet Drop Rate**<br><br>User plane packet drop rate (packets/sec) |`UserPlanePacketDropRate` |CountPerSecond |Total (Sum) |`PcdpId`, `SiteId`, `Cause`, `Direction`, `Interface`|PT1M |No|
|**User Plane Packet Rate**<br><br>User plane packet rate (packets/sec) |`UserPlanePacketRate` |CountPerSecond |Total (Sum) |`PcdpId`, `SiteId`, `Direction`, `Interface`|PT1M |No|
|**VectorDB API Request Count**<br><br>Total number of API requests to VectorDB |`VectorDbApiRequestCount` |Count |Count |`AppName`, `Method`, `Route`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Xn Handover Attempts**<br><br>Handover attempts rate (per minute) |`XnHandoverAttempt` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Xn Handover Failures**<br><br>Handover failure rate (per minute) |`XnHandoverFailure` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Xn Handover Successes**<br><br>Handover success rate (per minute) |`XnHandoverSuccess` |Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
