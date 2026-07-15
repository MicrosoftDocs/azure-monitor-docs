---
title: Supported metrics - microsoft.kubernetesconfiguration/extensions
description: Reference for microsoft.kubernetesconfiguration/extensions metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: microsoft.kubernetesconfiguration/extensions, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for microsoft.kubernetesconfiguration/extensions

The following table lists the metrics available for the microsoft.kubernetesconfiguration/extensions resource type.

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



### Category: Errors
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**File Sync Errors**<br><br>Number of file sync errors |`FileSyncErrors` | No | Count |Total (Sum), Average, Count |`volume_name`, `subvolume_name`, `transfer_mode`, `status`|PT1M |No|

### Category: Latency
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Api Request Duration in Seconds**<br><br>Histogram of request durations |`ApiRequestDurationSeconds` | No | Seconds |Average |`AppName`, `GpuEnabled`, `Method`, `Route`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Ingestion Time**<br><br>Total ingestion time in minutes |`IngestionTimeMinutes` | No | Seconds |Average |`AppName`, `GpuEnabled`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Input Preprocessing Time (Milliseconds)**<br><br>Input preprocessing time in milliseconds |`InputPreprocessingTimeMilliseconds` | No | Milliseconds |Average |`GpuEnabled`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Call LLM Total Time in Seconds**<br><br>Total call_llm time in seconds |`TotalCallLLMTimeSeconds` | No | Seconds |Average |`AppName`, `GpuEnabled`, `LLMProvider`, `OutputLength`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Embedding Generation Total Time in Seconds**<br><br>Total time taken to generate embeddings from local model |`TotalGenerateEmbeddingsTimeSeconds` | No | Seconds |Average |`AppName`, `GpuEnabled`, `InputLength`, `OutputLength`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Hybrid Search Embedding Generation Total Time in Seconds**<br><br>Total time taken to generate Hybrid Search embeddings from local model |`TotalGenerateHybridSearchEmbeddingsTimeSeconds` | No | Seconds |Average |`AppName`, `GpuEnabled`, `InputLength`, `OutputLength`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Reranking Generation Total Time in Seconds**<br><br>Total time taken to generate Reranking |`TotalGenerateRerankingTimeSeconds` | No | Seconds |Average |`AppName`, `GpuEnabled`, `InputLength`, `OutputLength`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Get Chat History Summary Total Time in Milliseconds**<br><br>Total get_chat_history_summary time in milliseconds |`TotalGetChatHistorySummaryTimeMilliseconds` | No | Milliseconds |Average |`AppName`, `GpuEnabled`, `InputHistoryPairs`, `LLMProvider`, `MaxTokens`, `OutputLength`, `Temperature`, `TopP`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Get LLM Payload Total Time in Milliseconds**<br><br>Total get_llm_payload time in milliseconds |`TotalGetLLMPayloadTimeMilliseconds` | No | Milliseconds |Average |`AppName`, `DiversityPenalty`, `GpuEnabled`, `LengthPenalty`, `LLMProvider`, `MaxTokens`, `RepetitionPenalty`, `Temperature`, `TopP`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Get Hybrid Search Total Time in Milliseconds**<br><br>Total hybrid search time in milliseconds |`TotalHybridSearchTimeMilliseconds` | No | Milliseconds |Average |`AppName`, `ChunkMinScore`, `GpuEnabled`, `IndexType`, `InputLength`, `MetricType`, `TopK`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Inference Total Time in Seconds**<br><br>Total inference time in seconds |`TotalInferenceTimeSeconds` | No | Seconds |Average |`AppName`, `DiversityPenalty`, `GpuEnabled`, `InputLength`, `LLMProvider`, `MaxTokens`, `OutputLength`, `RepetitionPenalty`, `Temperature`, `TopK`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Chunks Search Total Time in Milliseconds**<br><br>Total search chunks time in milliseconds |`TotalSearchChunksTimeMilliseconds` | No | Milliseconds |Average |`AppName`, `EmbeddingIndexName`, `GpuEnabled`, `InputLength`, `OutputChunks`, `TopK`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Search Total Time in Milliseconds**<br><br>Total time taken to search |`TotalSearchTimeMilliseconds` | No | Milliseconds |Average |`AppName`, `ChunkMinScore`, `GpuEnabled`, `InputLength`, `QueryType`, `TopK`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Similarity Search Total Time in Milliseconds**<br><br>Total time taken to search for similar documents |`TotalSimilaritySearchTimeMilliseconds` | No | Milliseconds |Average |`AppName`, `GpuEnabled`, `InputLength`, `ChunkMinScore`, `IndexType`, `MetricType`, `TopK`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|

### Category: Saturation
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Edgevolume Percentage Space Available**<br><br>Percentage of available space on Edgevolume |`EdgevolumePercentageSpaceAvailable` | No | Percent |Average, Minimum, Maximum |`edgevolume_name`|PT1M |No|
|**Edgevolume Space Available**<br><br>Bytes of available space on Edgevolume |`EdgevolumeSpaceAvailable` | No | Bytes |Total (Sum), Average, Minimum, Maximum |`edgevolume_name`|PT1M |No|
|**Edgevolume Space Total**<br><br>Bytes of total space on Edgevolume |`EdgevolumeSpaceTotal` | No | Bytes |Total (Sum), Average, Minimum, Maximum |`edgevolume_name`|PT1M |No|

### Category: Traffic
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Active PDU Sessions**<br><br>Number of Active PDU Sessions |`ActiveSessionCount` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |No|
|**API Failure Count**<br><br>Count of failed API requests |`ApiFailureCount` | No | Count |Count |`EndpointName`, `GpuEnabled`, `StatusCode`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**API Request Count**<br><br>Total number of API requests |`ApiRequestCount` | No | Count |Count |`AppName`, `GpuEnabled`, `Method`, `Route`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**API Success Count**<br><br>Count of successful API requests |`ApiSuccessCount` | No | Count |Count |`EndpointName`, `GpuEnabled`, `StatusCode`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Authentication Attempts**<br><br>Authentication attempts rate (per minute) |`AuthAttempt` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Authentication Failures**<br><br>Authentication failure rate (per minute) |`AuthFailure` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`, `Result`|PT1M |Yes|
|**Authentication Successes**<br><br>Authentication success rate (per minute) |`AuthSuccess` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Connected NodeBs**<br><br>Number of connected gNodeBs or eNodeBs |`ConnectedNodebs` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**DeRegistration Attempts**<br><br>UE deregistration attempts rate (per minute) |`DeRegistrationAttempt` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**DeRegistration Successes**<br><br>UE deregistration success rate (per minute) |`DeRegistrationSuccess` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Evaluation API Request Count**<br><br>Total number of Evaluation API requests |`EvaluationApiRequestCount` | No | Count |Count |`AppName`, `Method`, `Route`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Failed Skipped Count**<br><br>Count of failed or skipped files |`FailedSkippedCount` | No | Count |Count |`Category`, `GpuEnabled`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**File Ingestion Rate**<br><br>Total files ingested per Job |`FileIngestionRate` | No | Count |Total (Sum) |`AppName`, `GpuEnabled`, `FileType`, `JobID`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**File Sync Count**<br><br>Number of files successfully synchronized |`FileSyncCount` | No | Count |Total (Sum), Average, Count |`volume_name`, `subvolume_name`, `transfer_mode`|PT1M |No|
|**Hybrid Search Model API Request Count**<br><br>Total number of Hybrid Search Model API requests |`HybridSearchModelApiRequestCount` | No | Count |Count |`AppName`, `Method`, `Route`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Inference Answer Feedback**<br><br>Inference Answer Feedback |`InferenceAnswerFeedback` | No | Count |Count |`AppName`, `ChunkMinScore`, `ChunkScores`, `GpuEnabled`, `LLMProvider`, `RunId`, `Thumb`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Inference API Request Count**<br><br>Number of Inference API requests |`InferenceApiRequestCount` | No | Count |Count |`AppName`, `Method`, `Route`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Ingestion API Request Count**<br><br>Number of Ingestion API requests |`IngestionApiRequestCount` | No | Count |Count |`AppName`, `Method`, `Route`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Number of Evaluations**<br><br>Number of Evaluations |`NumberOfEvaluations` | No | Count |Count |`AppName`, `GpuEnabled`, `Method`, `Route`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Number of Jobs**<br><br>Number of jobs |`NumberOfJobs` | No | Count |Count |`AppName`, `GpuEnabled`, `Method`, `Route`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Paging Attempts**<br><br>Paging attempts rate (per minute) |`PagingAttempt` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Paging Failures**<br><br>Paging failure rate (per minute) |`PagingFailure` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Provisioned Subscribers**<br><br>Number of provisioned subscribers |`ProvisionedSubscribers` | No | Count |Total (Sum) |`PccpId`, `SiteId`|PT1M |No|
|**RAN Setup Failures**<br><br>RAN setup failure rate (per minute) |`RanSetupFailure` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`, `Cause`|PT1M |Yes|
|**RAN Setup Requests**<br><br>RAN setup reuests rate (per minute) |`RanSetupRequest` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**RAN Setup Responses**<br><br>RAN setup response rate (per minute) |`RanSetupResponse` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Registered Subscribers**<br><br>Number of registered subscribers |`RegisteredSubscribers` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Registered Subscribers Connected**<br><br>Number of registered and connected subscribers |`RegisteredSubscribersConnected` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Registered Subscribers Idle**<br><br>Number of registered and idle subscribers |`RegisteredSubscribersIdle` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Registration Attempts**<br><br>Registration attempts rate (per minute) |`RegistrationAttempt` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Registration Failures**<br><br>Registration failure rate (per minute) |`RegistrationFailure` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`, `Result`|PT1M |Yes|
|**Registration Successes**<br><br>Registration success rate (per minute) |`RegistrationSuccess` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Service Request Attempts**<br><br>Service request attempts rate (per minute) |`ServiceRequestAttempt` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Service Request Failures**<br><br>Service request failure rate (per minute) |`ServiceRequestFailure` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`, `Result`, `Tai`|PT1M |Yes|
|**Service Request Successes**<br><br>Service request success rate (per minute) |`ServiceRequestSuccess` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Session Establishment Attempts**<br><br>PDU session establishment attempts rate (per minute) |`SessionEstablishmentAttempt` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`, `Dnn`|PT1M |Yes|
|**Session Establishment Failures**<br><br>PDU session establishment failure rate (per minute) |`SessionEstablishmentFailure` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`, `Dnn`|PT1M |Yes|
|**Session Establishment Successes**<br><br>PDU session establishment success rate (per minute) |`SessionEstablishmentSuccess` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`, `Dnn`|PT1M |Yes|
|**Session Releases**<br><br>Session release rate (per minute) |`SessionRelease` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**UE Context Release Commands**<br><br>UE context release command message rate (per minute) |`UeContextReleaseCommand` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**UE Context Release Completes**<br><br>UE context release complete message rate (per minute) |`UeContextReleaseComplete` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**UE Context Release Requests**<br><br>UE context release request message rate (per minute) |`UeContextReleaseRequest` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**User Plane Bandwidth**<br><br>User plane bandwidth in bits/second. |`UserPlaneBandwidth` | No | BitsPerSecond |Total (Sum) |`PcdpId`, `SiteId`, `Direction`, `Interface`|PT1M |No|
|**User Plane Packet Drop Rate**<br><br>User plane packet drop rate (packets/sec) |`UserPlanePacketDropRate` | No | CountPerSecond |Total (Sum) |`PcdpId`, `SiteId`, `Cause`, `Direction`, `Interface`|PT1M |No|
|**User Plane Packet Rate**<br><br>User plane packet rate (packets/sec) |`UserPlanePacketRate` | No | CountPerSecond |Total (Sum) |`PcdpId`, `SiteId`, `Direction`, `Interface`|PT1M |No|
|**VectorDB API Request Count**<br><br>Total number of API requests to VectorDB |`VectorDbApiRequestCount` | No | Count |Count |`AppName`, `Method`, `Route`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Xn Handover Attempts**<br><br>Handover attempts rate (per minute) |`XnHandoverAttempt` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Xn Handover Failures**<br><br>Handover failure rate (per minute) |`XnHandoverFailure` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|
|**Xn Handover Successes**<br><br>Handover success rate (per minute) |`XnHandoverSuccess` | No | Count |Total (Sum) |`3gppGen`, `PccpId`, `SiteId`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
