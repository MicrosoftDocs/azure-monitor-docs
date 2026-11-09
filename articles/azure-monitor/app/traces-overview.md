---
title: Azure Monitor traces overview
description: Learn how Azure Monitor traces and Trace Analytics help Application Insights users search, analyze, and investigate distributed traces, and find out when to use each analysis experience.
ms.topic: overview
ms.date: 10/16/2026
ms.custom: references_regions
ai-usage: ai-assisted
---

# Azure Monitor traces overview

Azure Monitor traces (preview) provides a dedicated trace store for distributed traces. It assembles related spans into complete traces at ingestion time, so you can analyze end-to-end transactions across your services and dependencies.

Use Trace Analytics to search and analyze groups of traces. You can identify patterns in performance and failures, compare groups of transactions, and open individual traces for detailed investigation. This article introduces the key concepts, the analysis experiences, and where to find them in the Azure portal.

## How distributed tracing works

A distributed trace represents one transaction as it moves through an application. Each operation in the transaction creates a span. A span records information such as the service, operation, duration, status, and attributes.

Azure Monitor assembles related spans into a trace. The trace preserves the order of operations and the relationships between spans, including calls across services and dependencies.

## What you can do with Azure Monitor traces and Trace Analytics

Use Azure Monitor traces and Trace Analytics to:

- Search for traces that match trace or span criteria.
- Analyze latency and failures across many traces.
- Identify services and operations that contribute to end-to-end duration.
- Compare a selected trace group with a baseline.
- Compare a selected time range to another.
- Find attributes associated with performance or failure patterns by comparing healthy and unhealthy traces.
- Open an individual trace to review its spans and dependencies.
- Use trace-derived metrics to monitor transaction volume, duration, and errors.

Searches always run at the trace level. A search returns the set of traces that match your filters, and the results show the trace count with P50 and P99 durations. From a result set, you can view aggregated results, heatmaps, histograms, or raw records, and analyze spans with Span Statistics. Critical Path Analysis calculates active time versus wait time for each span, and Attribute Analysis ranks the attributes that best distinguish a selected group of traces from its baseline.

## Navigate to Trace Analytics

In the Azure portal, open Trace Analytics from the **Traces** item in either of these resources:

- Application Insights
- Azure Monitor workspace

Both entry points use trace data associated with the Azure Monitor workspace. When you open **Traces** from an Application Insights resource, a span filter is applied automatically. The filter matches only traces that have at least one span emitted to that Application Insights resource.

:::image type="content" source="media/traces-overview/app-insights-traces.png" alt-text="Screenshot of Traces blade in Application Insights." lightbox="media/traces-overview/app-insights-traces.png":::

To make an Application Insights resource's traces available in an Azure Monitor workspace, link the resource to the workspace. For details, see [Onboard Application Insights resources to Azure Monitor traces](traces-onboard-app-insights.md).

## When to use Trace Analytics

Use Trace Analytics when you need to understand trends and patterns across many transactions with at-scale analysis. Use an individual trace when you need to inspect a single transaction in detail.

| Goal | Start with |
|----|----|
| Monitor trends in volume, latency, or errors | [Trace-derived metrics](trace-derived-metrics.md) |
| Find transactions that match trace or span conditions | [Trace search](traces-search-analyze.md) |
| Identify top latency contributors | [Critical Path Analysis](traces-critical-path-analysis.md) |
| Compare healthy versus unhealthy transactions | [Attribute Analysis](traces-attribute-analysis.md) |
| View and compare spans | Span Statistics, described in [Search and analyze traces with Trace Analytics](traces-search-analyze.md) |
| Inspect operation order and span details for one trace | Individual trace view |

## Preview limitations

> [!IMPORTANT]
> Azure Monitor traces and Trace Analytics are in preview. Preview features are provided without a service-level agreement and aren't recommended for production workloads.

Keep these points in mind while the feature is in preview:


- Limited regional availability. You can onboard an Azure Monitor workspace only when the workspace is in `newzealandnorth`, `westeurope`, or `eastus2`.
- Application Insights onboarding is supported only for the following regions:

| Supported regions |  |  |
|---|---|---|
| australiacentral | australiasoutheast | austriaeast |
| brazilsouth | brazilsoutheast | canadacentral |
| canadaeast | centralindia | centralus |
| chilecentral | eastasia | eastus |
| eastus2 | francecentral | francesouth |
| germanynorth | germanywestcentral | indonesiacentral |
| israelcentral | japanwest | jioindiawest |
| koreacentral | koreasouth | malaysiawest |
| newzealandnorth | northcentralus | northeurope |
| norwayeast | norwaywest | polandcentral |
| southafricanorth | southafricawest | southcentralus |
| southeastasia | southindia | spaincentral |
| swedencentral | switzerlandnorth | switzerlandwest |
| taiwannorth | taiwannorthwest | uaecentral |
| uaenorth | uksouth | ukwest |
| westcentralus | westeurope | westus |
| westus2 | westus3 | |

## Next steps

- [Onboard Application Insights resources to Azure Monitor traces](traces-onboard-app-insights.md)
- [Search and analyze traces with Trace Analytics](traces-search-analyze.md)
- [Monitor applications with trace-derived metrics](trace-derived-metrics.md)