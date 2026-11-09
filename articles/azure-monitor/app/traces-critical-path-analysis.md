---
title: Investigate latency with Critical Path Analysis
description: Learn how to use Critical Path Analysis in Azure Monitor traces to find the spans that contribute active time to end-to-end latency across a group of traces.
ms.topic: how-to
ms.date: 10/16/2026
---

# Investigate latency with critical path analysis

Use critical path analysis in Trace Analytics to find which spans contribute to end-to-end trace duration across many traces. For each span that contributes to end-to-end trace duration, the analysis calculates active time versus wait time. It counts only the time a span spends doing latency-driving work, not the time it spends waiting on downstream dependencies.

This article shows you how to run the analysis, read the P50 and P99 results, and validate what you find in individual traces.

> [!IMPORTANT]
> Azure Monitor traces and Trace Analytics are in preview. Preview features are provided without a service-level agreement and aren't recommended for production workloads.

## Understand how critical path analysis works

Critical path analysis identifies the non-overlapping span segments that make up the end-to-end duration of each trace. It then combines the results across all traces in your trace set and groups them by the dimensions you choose.

The following rules determine what counts toward a span's contribution:

- A span contributes only while it owns the latency-driving path.
- Parent spans that are waiting on child operations aren't counted.
- When parallel branches overlap, the branch that finishes later owns the overlapping segment.
- Time with no active span is reported as idle time.

## Run critical path analysis

Run the analysis on a set of traces that represent one transaction type, so the results describe a consistent flow rather than being diluted by different causes of delay from different transaction types.

1. In Trace Explorer, filter the trace set to one transaction type and time range.
1. Select **Critical path analysis**.
1. Select the grouping dimensions. The default groups are service and operation.
1. Run the analysis.

:::image type="content" source="media/traces-critical-path-analysis/traces-critical-path.png" alt-text="Screenshot of Critical Path Analysis results." lightbox="media/traces-critical-path-analysis/traces-critical-path.png":::

For more information about filtering traces, see [Search and analyze traces with Trace Analytics](traces-search-analyze.md).

## Interpret P50 and P99 results

Review the groups that contribute the most to P50 and P99 critical-path duration.

| Percentile | What it represents |
|---|---|
| P50 | Typical latency |
| P99 | Tail latency and intermittent regressions |

Keep the following points in mind when you read the values:

- Percentiles are calculated independently for each group. Don't add them together to estimate end-to-end duration.
- A group contributes 0 for traces where it's absent or not on the critical path.
- P50 can be 0 when a group contributes to fewer than half of the traces. Review P99 for less frequent contributors.


## Interpret active time and wait time

Critical Path Analysis reports active time for a span, not its full duration. Parent spans that are waiting on child operations aren't counted.

When operations run in parallel, the branch that finishes later owns the overlapping segment. Time during which no span is active appears as idle time.

Because of these rules, a span with a long duration in Span Statistics in a trace doesn't necessarily rank high in Critical Path results. Use Critical Path results to find the services and operations that directly affect end-to-end duration.

## Validate findings with example traces

Confirm an aggregate finding by looking at an actual transaction.

1. In the results, find a span group that contributes significantly to P50 or P99.
1. Select **Example trace**. The trace opens at the contributing span, so you can validate the finding in context.

## Apply best practices and understand limitations

- Analyze traces from the same scenario or user flow.
- Use enough traces for meaningful percentile results.
- Validate aggregate findings in example traces.
- Treat results cautiously when traces have missing spans, incomplete parent-child relationships, or timing anomalies.
- Don't add percentiles across groups to estimate end-to-end duration.