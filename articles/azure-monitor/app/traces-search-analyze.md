---
title: Search and analyze traces with Trace Analytics
description: Learn how to filter traces, review results, analyze trace groups, and investigate slow or failed transactions with Trace Analytics in Azure Monitor traces (preview).
ms.topic: how-to
ms.date: 10/16/2026
---

# Search and analyze traces with Trace Analytics

Use Trace Analytics to find a set of traces, review the results, analyze traces, and summarize spans with Span Statistics. Searches always run at the trace level and return the traces that match your filter criteria. You can view aggregate results of the trace counts, durations, and errors or open individual traces to view transaction details.

This article describes the core Trace Analytics workflow, from filtering through aggregate analysis and individual-trace validation. It also walks through how to investigate slow and failed transactions.

> [!IMPORTANT]
> Azure Monitor traces and Trace Analytics are in preview. Preview features are provided without a service-level agreement and aren't recommended for production workloads.

## Prerequisites

- An Application Insights resource linked to an Azure Monitor workspace. For more information, see [Onboard Application Insights resources to Azure Monitor traces](traces-onboard-app-insights.md).
- Trace data sent from an instrumented application.

In the Azure portal, open Trace Analytics from the **Traces** item in either your Application Insights resource or your Azure Monitor workspace. When you open it from Application Insights, a span filter is applied automatically so that only traces with at least one span emitted to that Application Insights resource are returned.

## Filter traces by trace-level conditions

Use **Trace Filters** to scope the search by time range and by conditions that apply to the whole trace.

1. In **Trace Filters**, select the time range.
1. Select **Add** to define trace-level conditions, such as duration or span count.

## Filter by spans

Expand **Span Filters** when each result must contain a span with specific properties.

- Select **Add** next to a condition to require another field on the same span.
- Select **Add** below the rows to match a different span in the trace.

For example, use separate rows to find traces that contain a span with `name=Checkout` and a span with `service.name=product-catalog`. Select **Search** to apply the filters and run the search.

:::image type="content" source="media/traces-search-analyze/trace-span-filters.png" alt-text="Screenshot of Trace search with trace and span filters defined." lightbox="media/traces-search-analyze/trace-span-filters.png":::

## Review trace results

Use **Results** to view the trace count returned by the search and the P50 and P99 durations.

## Select and analyze trace groups

Use **Selection** to view the matching traces as aggregated results, heatmaps, histograms, or raw records.

:::image type="content" source="media/traces-search-analyze/traces-selection.png" alt-text="Screenshot of selection options." lightbox="media/traces-search-analyze/traces-selection.png":::

For example, on a duration heatmap, select an area to compare those traces with the unselected baseline. Turn on **Selection zoom** to zoom to the selected time range.

For a ranked comparison of attributes in a selected set against its baseline (traces not in the selected set), see [Compare trace groups with Attribute Analysis](traces-attribute-analysis.md).

## Handle partial results

When a query's result set exceeds the 10,000-trace limit, **Partial results** appears. You can narrow your filters or select a smaller time range to reduce the result set.

## Review the trace list and open an individual trace

The trace list shows the traces in your result set.

:::image type="content" source="media/traces-search-analyze/traces-selection-set.png" alt-text="Screenshot of subset of trace results selected." lightbox="media/traces-search-analyze/traces-selection-set.png":::

- Use **Search by keywords** to filter the displayed traces.
- Select a column heading to sort the list.
- Select a root span name to open the end-to-end transaction view.

In the End-to-end Transaction Details view, you can review the trace's operations, spans, dependencies, duration, status, and attributes. Use this view to drill into the details of a single transaction at a time.


:::image type="content" source="media/traces-search-analyze/traces-end-to-end-view.png" alt-text="Screenshot of end-to-end transaction view." lightbox="media/traces-search-analyze/traces-end-to-end-view.png":::

## Analyze spans with Span Statistics

Use Span Statistics to summarize spans across the trace set. You can use the default analysis or create a custom one.

### Use the default analysis

1. On the **Default** tab, review request rate, duration, and errors grouped by `service.name`.
1. Select **Run**.

### Create a custom analysis

1. Select **Custom**.
1. Under **Dimensions**, select one or more fields to group by.
1. Under **Aggregations**, select one or more measures, such as request rate, duration percentiles, or error count.
1. Select **Run**.

For critical-path results, see [Investigate latency with Critical Path Analysis](traces-critical-path-analysis.md).


:::image type="content" source="media/traces-search-analyze/span-statistics.png" alt-text="Screenshot of Span Statistics with Default tab selected." lightbox="media/traces-search-analyze/span-statistics.png":::

## Investigate slow transactions

Use Trace Analytics to find slow transactions and identify the services and operations that contribute to end-to-end duration.

### Find slow transactions

1. Open **Traces**.
1. Select the investigation time range.
1. Add criteria for the root operation or business transaction.
1. Add a duration threshold that represents your performance objective.
1. Run the search.

### Analyze latency contributors

Review the services, operations, and dependencies that appear in the slow traces. Focus on operations that repeatedly contribute to duration across the selected trace group.

Use **Critical Path Analysis** to identify the work that directly affects end-to-end duration. This analysis isolates active time in each operation and avoids adding overlapping operation durations that run in parallel. For details, see [Investigate latency with Critical Path Analysis](traces-critical-path-analysis.md).

### Compare with a baseline

In the **Selection** heatmap for duration, select a set of slow traces to compare with the broader transaction population. Open **Top Attributes** to look for differences in service, operation, deployment, region, version, or custom attributes. For details, see [Compare trace groups with Attribute Analysis](traces-attribute-analysis.md).

### Validate the finding

1. Open several representative traces.
1. Review the operation sequence and span durations.
1. Use this individual transaction as an example of the earlier aggregate performance analysis.

## Investigate failed transactions

Use trace-level analysis to identify the complete transactions affected by an error. Then segment the results by service, operation, region, deployment, or business attribute.

### Find transactions with a failure

1. Open **Traces**.
1. Select the time range.
1. Add span criteria for the failing service or operation.
1. Add a status, exception, or dependency condition.
1. Run the search.

The results include complete transactions that contain the matching span.  Use **Selection** to view traces with errors using Histogram or Heatmap by error count.

### Analyze the affected population

Review the operations and attributes of the matching transactions. This analysis can show which transaction types, regions, deployments, or customer journeys include errors.

### Review a representative transaction

1. Open a matching trace.
1. Review the root operation and span sequence.
1. Find the failed spans.
1. Review its status, exception information, dependencies, and attributes.
1. Use this individual transaction as an example of the earlier aggregate failure analysis.

## Next steps

- [Investigate latency with Critical Path Analysis](traces-critical-path-analysis.md)
- [Compare trace groups with Attribute Analysis](traces-attribute-analysis.md)
- [Monitor applications with trace-derived metrics](trace-derived-metrics.md)