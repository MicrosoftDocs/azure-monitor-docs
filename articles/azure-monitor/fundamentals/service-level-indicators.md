---
title: Service level indicator concepts in Azure Monitor
description: Learn core service level indicator concepts in Azure Monitor, including SLI types, metric details, baseline targets, error budgets, and burn rates.
ms.topic: concept
ms.date: 04/06/2026
ai-usage: ai-assisted
---

# Service level indicator concepts in Azure Monitor

Service level indicators (SLIs) in Azure Monitor quantify reliability for a [service group](/azure/governance/service-groups/overview). An SLI tracks whether your service behavior meets a defined reliability expectation over time.

Use SLIs to move from reactive incident response to objective reliability management. Instead of only checking whether an alert fired, you can evaluate compliance against a target and track how quickly reliability risk is increasing.

## What an SLI measures

An SLI is a ratio of good outcomes to total outcomes across a measurement period.

In Azure Monitor:

* Request-based SLI: good requests divided by total requests.
* Window-based SLI: good windows divided by total windows.

An SLI on its own is a measured value. You compare that value to a target to determine whether reliability is acceptable.

## Baseline target, error budget, and burn rate

Use these concepts together:

* Baseline target (SLO): The reliability objective, such as 99.9%.
* Error budget: Allowable unreliability before you miss the target.
* Burn rate: How quickly the error budget is being consumed.

For a baseline target of 99.9%, the error budget is 0.1%:

`Error budget = 100% - baseline target`

A higher burn rate means your service is consuming allowable failure faster than planned.

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

## Next steps

* Create an SLI by using [Create service level indicators in Azure Monitor](service-level-indicators-create.md).
* Learn more about [Azure Monitor workspaces](../metrics/azure-monitor-workspace-overview.md).
* Review [Azure Monitor overview](overview.md).