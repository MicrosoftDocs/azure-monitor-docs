---
title: Service level indicator concepts in Azure Monitor
description: Learn core service level indicator concepts in Azure Monitor, including SLI types, metric details, baseline targets, error budgets, and burn rates.
ms.topic: concept
ms.date: 04/07/2026
ai-usage: ai-assisted
---

# Service level indicator concepts in Azure Monitor

Service level indicators (SLIs) in Azure Monitor quantify reliability and performance for a [service group](/azure/governance/service-groups/overview) against a defined baseline target. SLIs help you track compliance over time, understand how much failure you can still absorb, and see how quickly reliability risk is increasing.

A service group represents a collection of resources for a common application or workload. Azure Monitor creates SLIs for that service group so you can evaluate the reliability of the service as a whole instead of looking at individual signals in isolation.

## What an SLI measures

An SLI is a ratio of good outcomes to total outcomes across a measurement period.

In Azure Monitor:

* Request-based SLI: good requests divided by total requests.
* Window-based SLI: good windows divided by total windows.

An SLI on its own is a measured value. You compare that value to a target to determine whether reliability is acceptable.

Typical reliability requirements look like these examples:

* Latency can exceed 300 milliseconds in only 5 percent of requests during a rolling 30-day period.
* The service must maintain 99 percent availability during a calendar week.

## Baseline target, error budget, and burn rate

Use these concepts together:

* Baseline target (SLO): The reliability objective, such as 99.9%.
* Error budget: Allowable unreliability before you miss the target.
* Burn rate: How quickly the error budget is being consumed.

For a baseline target of 99.9%, the error budget is 0.1%:

`Error budget = 100% - baseline target`

A higher burn rate means your service is consuming allowable failure faster than planned.

Error budgets help you decide when to prioritize new feature work and when to focus on reliability improvements. As failures accumulate, the remaining error budget tells you how much room is left before the service misses its target.

## Use error budget alerts

When you configure alerting, you can use burn rate to detect whether the service is consuming its error budget too quickly.

Use these alert patterns:

* Fast-burn alert: Detects a sudden increase in failures that could exhaust the error budget soon if the condition persists.
* Slow-burn alert: Detects sustained error-budget consumption that is less urgent but still likely to miss the target before the end of the compliance period.

Together, these alerts help you respond to both sharp reliability regressions and slower trends that would otherwise be easy to miss.

## Choose the right SLI type

Select the SLI type that matches your reliability question.

### Request-based SLI

Use request-based SLIs when each request should contribute equally to the result.

This model is a good fit when:

* Traffic volume varies over time.
* Reliability should reflect per-request success or failure.
* You want direct numerator and denominator logic.

### Window-based SLI

Use window-based SLIs when each time interval should be evaluated as good or bad.

This model is a good fit when:

* You care about interval-level behavior, such as 1-minute or 5-minute windows.
* You want to smooth short spikes.
* Reliability is based on threshold compliance per interval.

## Understand metric details

The **Metric details** configuration determines how Azure Monitor evaluates your SLI.

Core elements include:

* Evaluation model: Request-based or window-based.
* Source identity and workspace: The managed identity and Azure Monitor workspace used for metric reads.
* Signal logic:
  * Request-based: define **Good signal** and **Total signal**.
  * Window-based: define a signal and window threshold criteria.
* Dimensions and filters: Scope the metric to the intended workload slice.
* Aggregation and formulas: Use consistent temporal and spatial aggregation and combine metrics when needed.
* Preview charts: Validate that your query returns expected behavior before saving the SLI.

If numerator and denominator aggregations are inconsistent in request-based SLIs, the resulting SLI can be misleading.

For request-based SLIs, the good signal acts as the numerator and the total signal acts as the denominator. For window-based SLIs, Azure Monitor evaluates whether each time window meets the threshold that you define.

## Source and destination workspace strategy

Azure Monitor reads input metrics from a source workspace and writes evaluated SLI results to a destination workspace.

You can use either of these approaches:

* Same workspace for source and destination: Simpler management and consolidated access.
* Separate workspaces: Separation of raw telemetry and evaluated SLI results.

Choose the approach that matches your operational and governance requirements.

## Plan your SLI definition

Before creating an SLI, decide:

1. Indicator type: **Availability** or **Latency**.
1. Evaluation model: **Request-based** or **Window-based**.
1. Signal design: good and total signals, or window threshold criteria.
1. Baseline target and compliance period.
1. Workspace strategy: same workspace or separate source and destination workspaces.
1. Alerting strategy: whether you need fast-burn, slow-burn, or both alert types.

## Next steps

* Create an SLI by using [Create service level indicators in Azure Monitor](service-level-indicators-create.md).
* Learn more about [Azure Monitor workspaces](../metrics/azure-monitor-workspace-overview.md).
* Review [Azure Monitor overview](overview.md).