---
title: Compare trace groups with Attribute Analysis
description: Learn how to select an anomaly in Azure Monitor traces, compare it with a baseline, and use ranked attributes to find what distinguishes unhealthy transactions. For Application Insights users.
ms.topic: how-to
ms.date: 10/16/2026
---

# Compare trace groups with Attribute Analysis

Attribute Analysis compares a group of traces that you select with the baseline of remaining traces. It ranks the attributes that best distinguish the two groups. Use it to investigate latency, error, or throughput anomalies and to decide where to look next.

This article covers how to select anomalous traces from a heatmap or histogram and review the top attributes, narrow the trace set with span filters, and confirm the pattern in a representative trace.

> [!IMPORTANT]
> Azure Monitor traces and Trace Analytics are in preview. Preview features are provided without a service-level agreement and aren't recommended for production workloads.

## Prerequisites

- An Application Insights resource that's onboarded to Azure Monitor traces. For more information, see [Onboard Application Insights resources to Azure Monitor traces](traces-onboard-app-insights.md).
- Trace data from an instrumented application.

## How Attribute Analysis works

Attribute Analysis splits your trace set into two groups:

- **Selection**: the traces in the area you select on a heatmap, typically an anomaly.
- **Baseline**: all the other traces.

Attributes are ranked by how strongly their value distributions differ between the selection and the baseline. Examples of attributes that can appear in the ranking are **service.name**, **span.name**, and **service.version**.

If you don't make a selection, the **Top Attributes** tab shows attribute distributions for all traces in view.

For help choosing between Attribute Analysis and other tools, see [Azure Monitor traces overview](traces-overview.md).

## Select an anomaly on a heatmap or histogram

Define the selection by dragging across the anomaly on a heatmap or histogram.

1. Open **Traces** from your Application Insights resource, and open Trace Explorer.
1. Select a **Duration**, **Errors**, or **Count** heatmap or histogram.
1. Filter the trace set until the anomaly is visible. For help with filters, see [Search and analyze traces with Trace Analytics](traces-search-analyze.md).
1. Drag across the anomaly to define the selection. The remaining traces become the baseline.
1. Open **Top Attributes**.

> [!NOTE]
> If **Partial results** appears because the query exceeds the 10,000-trace limit, narrow the filters or select a smaller area.

## Review top attributes

Open **Top Attributes** to see the attributes ranked by how much their value distributions differ between the selection and the baseline.

Review the highest-ranked attributes and their values.

:::image type="content" source="media/traces-attribute-analysis/traces-top-attributes.png" alt-text="Screenshot of Top Attributes results." lightbox="media/traces-attribute-analysis/traces-top-attributes.png":::

Treat the ranking as a set of hypotheses to test, not as proof of what caused the anomaly.

## Refine the investigation with span filters

After you find a promising attribute, use it to narrow the trace set.

1. Select a top attribute value to add it as a span filter.
1. Add other distinguishing values to narrow the trace set further.

## Validate the pattern in a representative trace

Open a representative trace from the narrowed trace set to validate the pattern.

To open a trace from the trace list, select a root span name.

## Best practices and data considerations

- Use enough traces in both the selection and the baseline for meaningful comparisons.
- Treat ranked attributes as hypotheses, not proof of causation.
- Capture useful, non-sensitive attributes in your telemetry, and onboard any custom attributes that you want analyzed.
-  Never record credentials, customer content, or other sensitive data in attributes.

