---
title: Sampling in Azure Application Insights with OpenTelemetry
description: Learn how OpenTelemetry sampling in Application Insights reduces telemetry volume, controls costs, and preserves key diagnostic data.
ms.topic: how-to
ms.date: 12/10/2025
---

# Sampling in Azure Monitor Application Insights with OpenTelemetry

[Application Insights](./app-insights-overview.md) includes a custom sampler and integrates with [OpenTelemetry](./opentelemetry-enable.md) to reduce telemetry volume, lower costs, and retain the diagnostic data you care about.

> [!IMPORTANT]
> For information on sampling when using the Application Insights Classic API Software Development Kits (SDKs), see [Classic API Sampling](/previous-versions/azure/azure-monitor/app/sampling-classic-api).

## Prerequisites

> [!div class="checklist"]
> Before you continue, make sure you have:
> * A basic understanding of [data collection](./opentelemetry-overview.md) methods.
> * A basic understanding of [OpenTelemetry sampling concepts](https://opentelemetry.io/docs/concepts/sampling/).
> * An application instrumented with [OpenTelemetry](./opentelemetry-enable.md).

## Why sampling matters

Sampling is essential for applications generating large amounts of telemetry. Without sampling, excessive data ingestion can increase storage and processing costs, and cause Application Insights to throttle telemetry. Effective sampling keeps enough data for meaningful diagnostics while controlling cost.

Sampling is **not enabled by default** in Application Insights OpenTelemetry distros. You must explicitly enable and configure sampling to manage your telemetry volume.

> [!NOTE]
> If you're seeing unexpected charges or high costs in Application Insights, this guide can help. It covers common causes like high telemetry volume, data ingestion spikes, and misconfigured sampling. It's especially useful if you're troubleshooting issues related to cost spikes, telemetry volume, sampling not working, data caps, high ingestion, or unexpected billing. To get started, see [Troubleshoot high data ingestion in Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-high-data-ingestion).

## Application Insights custom sampler

The Azure Monitor OpenTelemetry-based distro includes a custom sampler.

* The sampler is disabled by default. You must explicitly enable and configure sampling to use the sampler.
* Application Insights relies on this sampler to show you complete traces and avoid broken ones.
* Live Metrics and the Application Insights classic API SDKs require this sampler for compatibility.

### Sampling options

Application Insights supports two sampling strategies:

* **Fixed-rate (percentage):** Set a sampling ratio between 0 and 1.

    Example: `0.1` sends about 10% of traces to Azure Monitor.

* **Rate-limited:** Set a maximum number of traces per second.

    Example: `0.5` ≈ one trace every two seconds; `5.0` = five traces per second.

An optional [trace‑based sampling for logs](opentelemetry-configuration.md#configure-tracebased-sampling-for-logs) feature is available for supported languages, which drops logs tied to unsampled traces. This feature is on by default if sampling is enabled.

To configure sampling, refer to [Enable Sampling in Application Insights with OpenTelemetry](./opentelemetry-configuration.md#enable-sampling).

### Custom sampler benefits

* Reduces broken traces and helps provide consistent sampling decisions
* Maintains compatibility with [Live Metrics](./live-stream.md) and can be used alongside classic SDKs

For more detailed information and sampling edge cases, see [Frequently Asked Questions](application-insights-faq.yml#opentelemetry-sampling).

## General sampling guidance

Use the following general guidance if you’re unsure where to start.

- **Metrics:** [Metrics](metrics-overview.md) aren’t sampled. Use them to reliably [alert](../alerts/alerts-overview.md) on key signals for your services and dependencies.

- **Logs:** Configure app logging to export only ERROR logs. Add WARN only when actionable. [Trace‑based sampling for logs](opentelemetry-configuration.md#configure-tracebased-sampling-for-logs) is on by default and drops logs tied to unsampled traces.

- **Traces:** Sample traces as shown in our [default samples](opentelemetry-configuration.md#enable-sampling). If [Failures and Performance experiences](failures-performance-transactions.md) look incomplete, increase the rate.

## Ingestion sampling (not recommended)

Ingestion sampling is a fallback when source-level control isn't possible. It drops data at the Azure Monitor ingestion point and offers no control over which traces and spans are retained. This increases the likelihood of encountering broken traces.

Scenarios where it's the only viable or most practical option include:

* You can't modify the application source code.
* You need to reduce telemetry volume immediately without redeploying applications.
* You receive telemetry from multiple sources with inconsistent or unknown sampling configurations.

To configure ingestion sampling:

1. Go to **Application Insights** > **Usage and estimated costs**.
1. Select **Data Sampling**.
1. Choose the percentage of data to retain.

## Set a daily cap

Set a daily cap to prevent unexpected costs. This limit stops telemetry ingestion when it reaches the threshold.

Use this cap as a last-resort control, not a replacement for sampling. A sudden increase in data volume can trigger the cap, creating a gap in telemetry until it resets the next day.

To configure the cap, see [Set a daily cap for Azure Monitor](../logs/daily-cap.md).

## Next steps

* To review frequently asked questions (FAQ), see [OpenTelemetry sampling FAQ](application-insights-faq.yml#opentelemetry-sampling)
* [OpenTelemetry Sampling Concepts](https://opentelemetry.io/docs/concepts/sampling/).
* [Enable Sampling in Application Insights](./opentelemetry-configuration.md#enable-sampling)
* [Application Insights Overview](./app-insights-overview.md)
* [Troubleshoot high data ingestion in Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-high-data-ingestion)
