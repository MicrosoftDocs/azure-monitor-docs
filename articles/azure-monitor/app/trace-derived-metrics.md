---
title: Monitor applications with Azure Monitor trace-derived metrics
description: Learn how Azure Monitor trace-derived metrics summarize request count, end-to-end duration, and errors from your distributed traces, and how to move from a metric change to the traces behind it.
ms.topic: concept-article
ms.date: 10/16/2026
author: kayodeprinceMS
ms.author: kaprince
ms.reviewer: kaprince
---

# Monitor applications with trace-derived metrics

Trace-derived metrics are summary metrics that Azure Monitor automatically generates from the distributed traces you send to Azure Monitor traces. Use them for dashboards, alerts, and time-series analysis to watch transaction volume, latency, and errors. When a metric shows unexpected spikes or drops, you can drill down to the trace data for detailed transaction analysis.

> [!IMPORTANT]
> Azure Monitor traces and Trace Analytics are in preview. Preview features are provided without a service-level agreement and aren't recommended for production workloads.

## What trace-derived metrics are

Traces record individual transactions. Metrics can show you how a whole population of transactions behaves over time. Trace-derived metrics bridge the two: they summarize the traces that Azure Monitor ingests, so you can monitor transaction trends without querying trace data each time. Generally, querying metrics is faster than querying traces for the same time range and data set. Trace Metrics summarize trace data by dimensions and labels but don't contain individual span attributes and span durations. These metrics are stored in the same Azure Monitor workspace where your traces are ingested.

Use metrics to see that something changed, and use Trace Analytics to find out why. For an introduction to traces and Trace Analytics, see [Azure Monitor traces overview](traces-overview.md).

## Available metric categories

Trace-derived metrics can summarize the trace request count, end-to-end trace duration, and trace errors by using: 

### Metric names

- **trace.requests** (delta counter)
- **trace.errors** (delta counter)
- **trace.duration** (exponential histogram, seconds)

### Dimension names
- **trace.name** - this is the root span name of the transaction
- **trace.service.name** - this is the service name of the root span 
- **trace.status** - two possible values of 'ok' or 'error'

## Use metrics for monitoring trends

Use trace-derived metrics when you want to watch behavior over time rather than inspect one transaction. With them you can:

- Track transaction volume.
- Monitor transaction latency and error trends.
- Compare transaction metrics by services or operations.
- Create dashboards and visualizations for longer time ranges.
- Configure metric alerts for important changes.

## Open the Trace Metrics dashboard

In the Azure portal, open Trace Analytics from the **Traces** item in either your Application Insights resource or your Azure Monitor workspace. When you open it from Application Insights, a span filter is applied automatically so that only traces with at least one span emitted to that Application Insights resource are returned.

Select **Trace Metrics** on the command bar to open the prebuilt Trace Metrics dashboard. This dashboard is a Grafana dashboard that's available in the Azure portal. You can view service-health RED signals (rate, errors, duration) that Azure Monitor Workspace automatically derives from the distributed traces you send. 

:::image type="content" source="media/trace-derived-metrics/traces-to-metrics.png" alt-text="Screenshot of Traces blade in Application Insights with dashboard of trace-derived metrics open." lightbox="media/trace-derived-metrics/traces-to-metrics.png":::

Go to **Traces** to search and view details.

- For how to filter and analyze trace sets, see [Search and analyze traces with Trace Analytics](traces-search-analyze.md).

- To find which operations contribute most to latency, see [Investigate latency with Critical Path Analysis](traces-critical-path-analysis.md).

- To find attributes that distinguish affected traces from the rest, see [Compare trace groups with Attribute Analysis](traces-attribute-analysis.md).
