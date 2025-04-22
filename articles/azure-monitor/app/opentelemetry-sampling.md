---
title: Sampling in Azure Application Insights with OpenTelemetry
description: Learn how OpenTelemetry sampling in Application Insights reduces telemetry volume, controls costs, and preserves key diagnostic data.
ms.topic: conceptual
ms.date: 03/26/2025
ms.reviewer: mmcc
---

# Sampling in Azure Monitor Application Insights with OpenTelemetry

[Application Insights](./app-insights-overview.md) includes a custom sampler and integrates with [OpenTelemetry](./opentelemetry-enable.md) to reduce telemetry volume, lower costs, and retain the diagnostic data you care about.

> [!NOTE]
> For information on sampling when using the Application Insights Classic API Software Development Kits (SDKs), see [Classic API Sampling](/previous-versions/azure/azure-monitor/app/sampling-classic-api).
> If you're seeing unexpected charges or high costs in Application Insights, this guide can help. It covers common causes like high telemetry volume, data ingestion spikes, and misconfigured sampling. It's especially useful if you're troubleshooting issues related to cost spikes, telemetry volume, sampling not working, data caps, high ingestion, or unexpected billing. To get started, see [Troubleshoot high data ingestion in Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-high-data-ingestion).

## Prerequisites

Before you continue, make sure you have:

- A basic understanding of [data collection](./opentelemetry-overview.md) methods
- A basic understanding of [OpenTelemetry sampling concepts](https://opentelemetry.io/docs/concepts/sampling/)
- An application instrumented with [OpenTelemetry](./opentelemetry-enable.md)

## Why sampling matters

Sampling is essential for applications generating large amounts of telemetry.

Without sampling, excessive data ingestion can:

- Increase storage and processing costs
- Cause Application Insights to throttle telemetry

Effective sampling keeps enough data for meaningful diagnostics while controlling cost.

Sampling is **not enabled by default** in Application Insights OpenTelemetry distros. You must explicitly enable and configure sampling to manage your telemetry volume.

## Application Insights custom sampler

The Azure Monitor OpenTelemetry-based distro includes a custom sampler.

- Live Metrics and the Application Insights classic API SDKs require this sampler for compatibility.
- The sampler is disabled by default. You must explicitly enable and configure sampling to use the sampler.
- It uses a fixed-rate algorithm. For example, a rate of 10% sends about 10% of traces to Azure Monitor.
- The Azure Monitor Application Insights service relies on this sampler to show you complete traces and avoid broken ones.

<u> **Benefits** </u>

- Consistent sampling decisions during interoperability with applications using the Application Insights Classic API Software Development Kits (SDKs).
- Full compatibility with [Live Metrics](./live-stream.md) because the sampler is aware of Live Metrics requirements.

To configure the sampling percentage, refer to [Enable Sampling in Application Insights with OpenTelemetry](./opentelemetry-configuration.md#enable-sampling).

For more detailed information and sampling edge cases, see [Frequently Asked Questions](#frequently-asked-questions).

## Ingestion sampling (not recommended)

Ingestion sampling is a fallback when source-level control isn't possible. It drops data at the Azure Monitor ingestion point and offers no control over which traces and spans are retained. This increases the likelihood of encountering broken traces.

Scenarios where it's the only viable or most practical option include:

- You can't modify the application source code.
- You need to reduce telemetry volume immediately without redeploying applications.
- You receive telemetry from multiple sources with inconsistent or unknown sampling configurations.

To configure ingestion sampling:

1. Go to **Application Insights** > **Usage and estimated costs**.
2. Select **Data Sampling**.
3. Choose the percentage of data to retain.

## Set a daily cap

Set a daily cap to prevent unexpected costs. This limit stops telemetry ingestion when it reaches the threshold.

Use this cap as a last-resort control, not a replacement for sampling. A sudden increase in data volume can trigger the cap, creating a gap in telemetry until it resets the next day.

To configure the cap, see [Set a daily cap for Azure Monitor](../logs/daily-cap.md).

## Frequently Asked Questions

### Is the Application Insights custom sampler tail-based?

The Application Insights custom sampler makes sampling decisions after span creation, rather than before, so it doesn't follow a traditional head-based approach. Instead, it applies sampling decisions at the end of span generation—after the span is complete but before export.

Although this behavior resembles tail-based sampling in some ways, the sampler doesn't wait to collect multiple spans from the same trace before deciding. Instead, it uses a hash of the Trace ID to help ensure trace completeness.

This approach balances trace completeness and efficiency, and avoids the higher cost associated with full tail-based sampling.

To make sampling decisions based on the outcome of an entire trace (for example, determining if any span within the trace failed), full tail-based sampling is required in a downstream Agent or Collector. This capability isn't currently supported, but you can request it as a new feature through the [Feedback Hub](https://feedback.azure.com/d365community/forum/3887dc70-2025-ec11-b6e6-000d3a4f09d0).

### How does the Application Insights custom sampler compare to OpenTelemetry head-based or tail-based sampling?

| Sampling Method             | Point of decision              | Strengths                                   | Weaknesses                                                 |
|-----------------------------|--------------------------------|---------------------------------------------|------------------------------------------------------------|
| Head-based                  | Before a span starts           | Low latency, minimal overhead               | Can result in broken traces                                |
| Tail-based                  | After spans are buffered based on time or volume thresholds | Ensures complete traces | Higher cost and added processing delay            |
| App Insights custom sampler | End of span generation         | Balances trace completeness with efficiency | Required for Live Metrics and Classic API compatibility    |

### Can I sample dependencies, requests, or other telemetry types at different rates?

No, the sampler applies a fixed rate across all telemetry types in a trace. Requests, dependencies, and other spans follow the same sampling percentage. To apply different rates per telemetry type, consider using OpenTelemetry span processors or (ingestion-time transformations)[opentelemetry-overview.md#telemetry-routing].

### How does the Application Insights custom sampler propagate sampling decisions?

The Application Insights custom sampler propagates sampling decisions using the W3C Trace Context standard by default. This standard enables sampling decisions to flow between services. However, because the sampler makes sampling decisions at the end of span generation—after the call to downstream services—the propagation carries incomplete sampling information. This limitation complies with the [W3C Trace Context specification](https://www.w3.org/TR/trace-context/#sampled-flag), but downstream services can't reliably use this propagated sampling decision.

### Does the Application Insights custom sampler respect sampling decisions from upstream services?

No, the Application Insights custom sampler always makes an independent sampling decision, even if the upstream service uses the same sampling algorithm. Sampling decisions from upstream services, including those using W3C Trace Context headers, don't influence the downstream service's decision. However, it does sample based on a hash of the Trace ID to ensure trace completeness. To improve consistency and reduce the chance of broken traces, configure all components in the system to use the same sampler and sampling rate.

### Why do some traces appear incomplete even when using the Application Insights custom sampler?

There are several reasons traces can appear incomplete:
- Different nodes in a distributed system use different sampling approaches that don't coordinate decisions. For example, one node applies OpenTelemetry head-based sampling, and another node applies sampling via the Azure Monitor Custom Sampler.
- Different nodes are set to different sampling rates, even if they both use the same sampling approach.
- You set filtering, sampling, or rate caps in the service-side pipeline, and this configuration randomly samples out spans without considering trace completeness.

If one component applies head-based sampling without propagating the sampling decision (via W3C Trace Context headers), downstream services sample the trace independently, which can result in discarded spans. As a result, some parts of the trace aren't always available when viewed in Application Insights.

## Next Steps

- [OpenTelemetry Sampling Concepts](https://opentelemetry.io/docs/concepts/sampling/).
- [Enable Sampling in Application Insights](./opentelemetry-configuration.md#enable-sampling)
- [Application Insights Overview](./app-insights-overview.md)
- [Troubleshoot high data ingestion in Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-high-data-ingestion)