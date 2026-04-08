---
title: Service level indicator concepts in Azure Monitor
description: Learn core service level indicator concepts in Azure Monitor, including SLI types, metric details, baseline targets, error budgets, and burn rates.
ms.topic: concept
ms.date: 04/07/2026
ai-usage: ai-assisted
---

# Service level indicator concepts in Azure Monitor

Service level indicators (SLIs) in Azure Monitor are measurements of reliability and performance for a [service group](/azure/governance/service-groups/overview). An SLI compares observed behavior with a baseline target over a defined compliance period. This helps you evaluate the reliability of the application or workload represented by the service group, track remaining error budget, and understand whether current conditions are consuming that budget too quickly.

The service group monitoring experience shows each SLI as a tracked reliability object with its own status, evaluation method, type, and remaining error budget. 

:::image type="content" source="media/create-service-level-indicators/manage-slis.png" lightbox="media/create-service-level-indicators/manage-slis.png" alt-text="Screenshot of the service group Monitoring experience listing multiple SLIs with status, evaluation method, SLI type, and error budget remaining.":::

Drill into a single SLI to see details about the SLI design, the measured performance, and the error budget burn rate.

:::image type="content" source="media/create-service-level-indicators/sli-details.png" lightbox="media/create-service-level-indicators/sli-detail.png" alt-text="Screenshot of the service group Monitoring experience listing multiple SLIs with status, evaluation method, SLI type, and error budget remaining.":::



## Element of an SLI

Each SLI in Azure Monitor is defined by the following elements.

| Element | What it defines |
|:---|:---|
| Service group | The application or workload boundary that the SLI represents. |
| SLI type | Specifies whether the metric in the SLI will measure availability or latency as described in [SLI types](#sli-types). |
| Evaluation method | Specifies whether the SLI evaluates individual requests or time windows as described in [](). |
| Signal design | The metrics, filters, aggregations, and formulas that define good and bad outcomes. |
| Baseline target | The service level objective (SLO) that the measured result is compared against. |
| Compliance period | The time horizon over which Azure Monitor evaluates performance against the target. |

Taken together, these elements define both the measured value and the reliability target. An SLI is useful because it connects raw telemetry to an explicit expectation for the service.

## SLI types

Azure Monitor supports two SLI types.

| Type | What it measures | Example |
|:---|:---|:---|
| Availability | Whether requests or time windows satisfy a success condition. | 99.99% of read and write requests were successful during the measurement period. |
| Latency | Whether requests or time windows stay within a latency threshold. | 95% of requests completed in less than 300 milliseconds during the measurement period. |

The SLI type defines the reliability question that you're asking. Availability asks whether the service is working. Latency asks whether the service is responding quickly enough to satisfy the experience that you want to protect.

## How Azure Monitor evaluates an SLI

The **Metric details** area in the portal captures the evaluation method, the identity used to read metrics, and the source workspace that provides the input data.

:::image type="content" source="media/create-service-level-indicators/metric-details.png" alt-text="Screenshot of the Metric details and Identity and data source sections showing the evaluation method selector, managed identity selection, and source workspace selection.":::

Azure Monitor provides two evaluation methods.

| Evaluation method | How it works | Typical fit |
|:---|:---|:---|
| Request-based | Evaluates the ratio of good requests to total requests. received. A good outcome is when this ratio meets or exceeds the defined target during the compliance period. | Use when reliability should reflect per-request success or failure regardless of traffic spikes or uneven load distribution over time. This is the most common evaluation method. |
| Window-based | Measures reliability using a custom condition over a metric timeseries. Evaluates the ratio of time intervals meeting a defined quality threshold to the total number of intervals in the compliance period. | Use when you want to mask short bursts of poor performance since compliance is averaged over intervals. |

The choice between these models changes how you interpret reliability. A request-based SLI emphasizes the experience of individual requests. A window-based SLI emphasizes whether the service stayed within an acceptable operating envelope for each interval.

## How signal design works

Signal design is the part of the SLI that turns telemetry into a reliability measurement. In Azure Monitor, that design can include metrics, dimensions, filters, temporal aggregation, spatial aggregation, and formulas.



### Request-based evaluation

In a request-based SLI, Azure Monitor uses two queries:

* **Good signal** is the numerator. It represents the requests that met the success condition.
* **Total signal** is the denominator. It represents the full request volume that the SLI should evaluate.

:::image type="content" source="media/create-service-level-indicators/request-based-sli.png" alt-text="Screenshot of the request-based SLI configuration showing separate Good signal and Total signal sections, each with options to add metrics and formulas.":::

This model is the most direct way to express outcomes such as successful requests, requests under a latency threshold, or requests that satisfy a specific dimension filter. You can combine multiple metrics with formulas when one metric alone doesn't represent the workload behavior that you want to measure.

Consistent aggregation matters in this model. If the good signal and total signal use incompatible aggregations or filters, the resulting ratio can misrepresent the true request experience.

### Window-based evaluation

In a window-based SLI, Azure Monitor evaluates one or more signals against a threshold for each window. Instead of explicitly defining numerator and denominator queries, you define what a good window looks like.

:::image type="content" source="media/create-service-level-indicators/window-based-sli.png" alt-text="Screenshot of the window-based SLI configuration showing a signal section, SLI evaluation criteria, and identity and data storage location settings.":::

This model is useful when uptime is better represented as threshold compliance per interval. For example, a 5-minute window might be considered good only when 99th percentile latency stays below a target. Short spikes can still matter, but the service is judged at the level of the defined window rather than at the level of each request.

In both evaluation methods, preview charts help validate that the selected metrics, filters, and formulas represent the intended workload slice before the SLI is created.

## Identities, data sources, and storage location

Azure Monitor uses managed identities and workspaces for two distinct purposes in the SLI model.

* A managed identity and source Azure Monitor workspace are used to read the telemetry that feeds the SLI.
* A managed identity and destination Azure Monitor workspace are used to store the evaluated SLI results.

:::image type="content" source="media/create-service-level-indicators/destination-workspace.png" alt-text="Screenshot of the Identity and data storage location section showing managed identity and destination workspace selection.":::

You can use the same workspace for both source telemetry and evaluated SLI results, or you can separate them. A single workspace simplifies access and operations. Separate workspaces can help when you want to isolate raw telemetry from evaluated reliability data for governance or operational reasons.

This separation is also visible on the SLI details page, where Azure Monitor shows both the data source and the storage location as part of the SLI metadata.

## Baseline targets, error budget, and burn rate

An SLI is a measured value. A baseline target defines whether that value is acceptable. In reliability engineering terms, this target is your service level objective (SLO).

Examples of baseline targets include the following scenarios:

* Latency can exceed 300 milliseconds in only 5% of requests during a rolling 30-day period.
* The service must maintain 99% availability during a calendar week.

Once you define the target, Azure Monitor can calculate the remaining margin for failure.

* **Error budget** is the amount of unreliability that the service can still absorb before it misses the baseline target.
* **Burn rate** is the speed at which the service is consuming that error budget.

For a baseline target of 99.9%, the error budget is 0.1%:

`Error budget = 100% - baseline target`

Error budget helps you reason about tradeoffs between feature velocity and reliability work. Burn rate adds urgency by showing whether recent conditions are consuming the budget at a sustainable pace or at a rate that is likely to cause a miss before the end of the compliance period.

The SLI details view brings these concepts together by showing the measured SLI trend, error budget remaining, and burn rate alongside metadata such as the evaluation method, baseline, SLI type, data source, and storage location.

:::image type="content" source="media/create-service-level-indicators/sli-details.png" alt-text="Screenshot of an SLI details page showing metadata for the SLI and charts for SLI performance, error budget remaining, and burn rate.":::

When you alert on SLIs, burn rate is especially useful because it highlights both sudden regressions and slower reliability erosion. Fast-burn conditions show that the service is consuming budget much faster than planned. Slow-burn conditions show sustained degradation that might still cause the service to miss its target over time.

## Next steps

* Create an SLI by using [Create service level indicators in Azure Monitor](service-level-indicators-create.md).
* Learn more about [Azure Monitor workspaces](../metrics/azure-monitor-workspace-overview.md).
* Review [Azure Monitor overview](overview.md).
