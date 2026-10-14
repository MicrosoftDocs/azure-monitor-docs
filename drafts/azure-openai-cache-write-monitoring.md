---
ai-usage: ai-assisted
---

# Azure OpenAI prompt cache-write monitoring

> **Review draft - not published.** This document describes the proposed metric contract from the PM specification. It is not a list of currently supported metrics and does not announce preview or general availability.

## Overview

Prompt caching lets supported Azure OpenAI requests reuse computation for cached prompt content. Cache reads measure reuse of existing cached content. Cache writes measure prompt input tokens written to the cache.

The proposed **Cached Write Prompt Tokens** metric makes cache creation visible separately from cache reads in Azure Monitor. Use it to monitor cache-write volume over time and, where cache-read metrics are available, compare cache creation with subsequent reuse.

## Proposed reference entry

The following is a **review-only proposed row** for the `Microsoft.CognitiveServices/accounts` reference, under **Azure OpenAI - Usage**. It must not be added to the published supported-metrics table until the final registration and availability are confirmed.

| Metric | Name in REST API | Advanced platform metrics | Unit | Aggregation | Dimensions | Time Grains | DS Export |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **Cached Write Prompt Tokens**<br>Number of prompt input tokens written to the prompt cache by supported Azure OpenAI requests. | `AzureOpenAIContextTokensCachedWrite` (proposed; subject to naming approval) | Pending confirmation | Count | Total (Sum) | `Region`, `ModelDeploymentName`, `ModelName`, `ModelVersion` | PT1M | Pending confirmation |

The advanced-platform classification and Diagnostic Settings export value are intentionally left unconfirmed. Do not infer them from adjacent metrics or from billing/metering onboarding.

## Interpreting cache-write usage

The proposed metric uses one finalized, authoritative request-level cache-write total aligned with the API's `cache_write_tokens` value. The intended contract covers supported normal-context and long-context requests through the same customer-facing counter.

That single-total contract requires implementation alignment. Existing normal-context and long-context publishing counters must not be described as already normalized into one total without confirmation.

Use **Total (Sum)** to view cache-write token volume over the selected time range. The proposed time grain is **one minute (PT1M)**. Filter or split the metric by region, deployment, model, or model version.

**Cache-write tokens are already included in total input tokens.** Do not add cache-write tokens again when calculating overall input usage.

This metric measures token volume, not dollar charges. Azure Monitor metrics aggregate usage and do not replace detailed usage records for individual requests.

## Proposed coverage and missing-data behavior

Support is based on the capabilities of the approved model, version, and deployment configuration, rather than a fixed list of model names.

| Request or deployment condition | Proposed behavior |
| --- | --- |
| Supported request with cache writes | Emit the finalized cache-write token count once for the request. |
| Supported request with no cache writes | Emit an explicit zero. |
| Unsupported deployment | Emit no metric series. |
| Expected usage data is missing or invalid | Emit no data point; track the telemetry issue internally. |

These are proposed behaviors and require validation before publication. An absent series must not be interpreted as a zero count.

## Diagnostic logs and export

Request-level cache-write diagnostic logging is a separately implemented surface. This draft does not claim that `properties.cacheWriteTokens` is available in `AzureOpenAIRequestUsage` or `RequestResponse` logs.

Diagnostic Settings export of this metric also requires confirmation. If supported, **AllMetrics** export contains aggregated metric data, not individual request records.

## Required before publication

1. Confirm the final registered metric name, classification, unit, aggregation, dimensions, time grain, and DS Export value.
2. Confirm the single-total normal-context and long-context contract and reconcile the metric with finalized API usage.
3. Confirm approved configurations, customer visibility, rollout, and zero/no-series/no-point behavior.
4. Obtain the Azure Monitor documentation owner's source-backed refresh path. The target reference is generated from Azure API metadata; direct edits are overwritten.
5. Preserve existing input, output, cache-read, and cache-match-rate definitions and values.

This standalone review draft is intentionally outside the generated reference. No supported-metric row or service registration is changed by this document.

## References

- [Target Azure Monitor supported-metrics reference](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-metrics/microsoft-cognitiveservices-accounts-metrics)
- [Azure OpenAI prompt caching](https://learn.microsoft.com/en-us/azure/foundry/openai/how-to/prompt-caching)
- PM input: *Enabling Prompt Cache Write Metrics for and Diagnostic logs for Azure OpenAI*, 97-line draft in review.
- [Engineering PR 16756911: Onboard metering for Cache Write (Short and long context) for 5.6](https://dev.azure.com/msazure/Cognitive%20Services/_git/Platform-ResourceProvider/pullrequest/16756911). This is billing/metering evidence, not proof of Azure Monitor registration, rollout, or diagnostic-log availability.
