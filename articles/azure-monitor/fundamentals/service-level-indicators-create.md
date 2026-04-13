---
title: Create service level indicators in Azure Monitor (preview)
description: Learn how to create service level indicators in Azure Monitor, configure signals and baselines, and review SLI status for a service group.
ms.topic: how-to
ms.date: 04/10/2026
ai-usage: ai-assisted
---

# Service level indicators in Azure Monitor (preview)

Service level indicators (SLIs) in Azure Monitor provide measurements of reliability and performance for a [service group](/azure/governance/service-groups/overview). An SLI compares observed behavior with a baseline target over a compliance period so you can tell whether the service is meeting the expectation you set.

This article shows you how to create and manage an SLI in the Azure portal. It also explains the key design choices you make during setup, including SLI type, evaluation method, signal design, and how Azure Monitor tracks error budget and burn rate.

## Understand SLI basics

Each SLI combines several elements that determine what Azure Monitor measures and how it evaluates the result.

| Element | What it defines |
|:---|:---|
| Service group | The application or workload boundary that the SLI represents. |
| SLI type | Whether the SLI measures availability or latency. |
| Evaluation method | Whether Azure Monitor evaluates individual requests or time windows. |
| Signal design | The metrics, filters, aggregations, and formulas that define good and bad outcomes. |
| Baseline target | The service level objective (SLO) that the measured result is compared against. |
| Compliance period | The time horizon over which Azure Monitor evaluates performance against the target. |


## Prerequisites

- An existing service group. For details, see [Create a service group (preview) in the portal](/azure/governance/service-groups/create-service-group-portal).
- A source [Azure Monitor workspace](../metrics/azure-monitor-workspace-overview.md) that has the metrics you want to evaluate, and a destination Azure Monitor workspace where Azure Monitor stores the evaluated SLI results. You can use the same workspace for both source and destination.
- A user-assigned managed identity that can access the workspaces. For guidance, see [Manage user-assigned managed identities by using the Azure portal](/entra/identity/managed-identities-azure-resources/manage-user-assigned-managed-identities-azure-portal).
- Access to the source workspace, destination workspace, and destination workspace default data collection rule.

If you have **Contributor** access at the subscription level for both workspaces, you typically don't need any additional role assignments. Otherwise, assign the following minimum roles.

| Resource | Minimum role assignments |
|---|---|
| Source Azure Monitor workspace | **Monitoring Reader** |
| Destination Azure Monitor workspace | **Monitoring Reader** and **Monitoring Metrics Publisher** |
| Destination workspace default data collection rule | **Monitoring Reader** |

The default data collection rule for the destination workspace is stored in the managed resource group that's associated with the workspace. On the destination workspace **Overview** page, select the **Data Collection Rule** link to open that resource and verify access.

## Create an SLI in the portal

In the Azure portal, open your service group, select **Monitoring**, and then select **Create SLIs** in the **SLI** card.

:::image type="content" source="media/service-level-indicators-create/service-group-monitoring.png" alt-text="Screenshot of the Monitoring page for a service group with the SLI card and the Create SLIs button." lightbox="media/service-level-indicators-create/service-group-monitoring.png":::

## Configure the Basics tab

On the **Basics** tab, enter a name for the SLI, optionally enter a description, and then select the SLI type.

:::image type="content" source="media/service-level-indicators-create/create-service-level-indicator-entry.png" alt-text="Screenshot of the Basics tab when you create a new SLI, showing availability and latency options." lightbox="media/service-level-indicators-create/create-service-level-indicator-entry.png":::

The SLI type defines the reliability question you're asking. Availability asks whether the service is working. Latency asks whether the service is responding quickly enough.

| Type | Description | Example |
|:---|:---|:---|
| Availability | Measures the uptime of the service, whether requests or time windows satisfy a success condition. | 99.99% of read and write requests were successful during the measurement period. |
| Latency | Measures performance of the service. Whether requests or time windows stay within a latency threshold. | 95% of requests completed in less than 300 milliseconds during the measurement period. |

## Configure the SLI tab

On the **SLI** tab, select the evaluation method, choose the identity and workspaces, and define the signals that Azure Monitor uses to evaluate the SLI.

:::image type="content" source="media/service-level-indicators-create/service-level-indicator-tab-metrics-details-managed-identity.png" alt-text="Screenshot of the SLI tab showing evaluation method dropdown, managed identity selection, data source, and metric configuration fields." lightbox="media/service-level-indicators-create/service-level-indicator-tab-metrics-details-managed-identity.png":::

### Metrics details

The evaluation method determines how Azure Monitor interprets the telemetry for your SLI. Choose the method that best matches the way you want to measure reliability for the service.

| Evaluation method | How it works | Typical fit |
|:---|:---|:---|
| Request-based | Evaluates the ratio of good requests to total requests. A good outcome is when this ratio meets or exceeds the defined target during the compliance period. | Use when reliability should reflect per-request success or failure regardless of traffic spikes or uneven load distribution over time. This is the most common evaluation method. |
| Window-based | Measures reliability by using a custom condition over a metric time series. It evaluates the ratio of time intervals that meet a defined quality threshold to the total number of intervals in the compliance period. | Use when you want to smooth short bursts of poor performance because compliance is averaged over intervals. |

### Identity and workspaces

Azure Monitor uses the source workspace to read telemetry and the destination workspace to store the evaluated SLI results. You can use the same workspace for both source and destination, or you can use separate workspaces. Separate workspaces can help when you want to isolate raw telemetry from evaluated reliability data.

A user-assigned managed identity is required for Azure Monitor to read the source metrics and store the evaluated SLI results. See [Prerequisites](#prerequisites) for details on the required permissions for the managed identity.

### SLI details

The SLI details define the metrics or formulas that Azure Monitor uses for the SLI evaluation. The configuration depends on the evaluation method you selected.

#### Request-based evaluation

In a request-based SLI, Azure Monitor uses two values to evaluate availability:

- **Good signal** is the numerator. It represents the requests that met the success condition.
- **Total signal** is the denominator. It represents the full request volume that the SLI should evaluate.

If one metric is enough for your SLI, select that metric and then select how to aggregate the value over time. This setting is the *temporal aggregation*. For example, you might use the average value over time, the maximum measured value, or a count of the requests that meet a condition.

Add filters such as a status code or dimension value to limit the values used for the calculation. For example, you can filter the good signal to count only requests with a `200` status code, and filter the total signal to count all requests regardless of status code. You'll usually apply more filters to the good signal than to the total signal.

Optionally specify an aggregation across multiple time series after temporal aggregation. This setting is the *spatial aggregation*.

:::image type="content" source="media/service-level-indicators-create/request-based-service-level-indicator-good-total-signal-configuration.png" alt-text="Screenshot of request-based SLI setup showing Good signal and Total signal sections with metric selection, filters, and Add Metric buttons." lightbox="media/service-level-indicators-create/request-based-service-level-indicator-good-total-signal-configuration.png":::


If you need more than one metric to define a signal, select **Add Metric** for each metric you need, and then select **Formula** to combine them. For example, you can use a formula such as `MetricA + MetricB`. You can also use a formula for a single metric, such as `MetricA * MetricA`.

#### Window-based evaluation

With this model, you don't explicitly provide good and total signals. For each window, Azure Monitor compares the metric value with a defined threshold to determine whether the window is good or bad.

Use metrics, filters, and formulas in the same way as the request-based model to define the signal that you want to evaluate. Then define the evaluation criteria that determines uptime.

:::image type="content" source="media/service-level-indicators-create/window-based-service-level-indicator.png" alt-text="Screenshot of the window-based SLI configuration showing a signal section, SLI evaluation criteria, and identity and data storage location settings." lightbox="media/service-level-indicators-create/window-based-service-level-indicator.png":::

Preview charts help you validate that the selected metrics, filters, and formulas represent the intended workload before you create the SLI.


## Baseline and alerts

On the **Baseline + Alert** tab, set the target that the SLI should meet, choose how Azure Monitor evaluates compliance, and optionally configure alert notifications. An SLI is a measured value. The baseline target defines whether that value is acceptable. In reliability engineering terms, this target is your service level objective.

:::image type="content" source="media/service-level-indicators-create/baseline-alert.png" alt-text="Screenshot of the Baseline + Alert tab for creating an SLI, showing baseline, evaluation period, alert options, and action group selection." lightbox="media/service-level-indicators-create/baseline-alert.png":::

In **Baseline (SLO)**, enter the target percentage that the SLI should meet, and in **Evaluation period**, select the time window that Azure Monitor uses to evaluate compliance. 

If you want Azure Monitor to create [alerts](../alerts/alerts-overview.md) for this SLI, turn on **Enable Alert**. You can keep **Baseline alert** selected to be notified when the SLI falls below the target for the selected evaluation period, configure **Fast burn rate** to detect rapid error budget consumption over a short lookback period, and configure **Slow burn rate** to detect sustained error budget consumption over a longer lookback period. In **Action groups**, select one or more [action groups](../alerts/action-groups.md) to define who gets notified and what actions run when an alert fires.

Use the baseline alert when you want to know that the SLI is out of compliance. Use burn-rate alerts when you want earlier warning that current conditions are consuming the error budget too quickly.


## View and manage SLIs

After you create an SLI, Azure Monitor displays it on the **Monitoring** page for the service group.

Open the service group and select **Monitoring**. Then select **View all SLIs** to open the management experience, review the SLI status and remaining error budget in the list, and select an SLI to review trend, error budget, and burn rate charts. Edit or delete the SLI as needed.

:::image type="content" source="media/service-level-indicators-create/manage-service-level-indicators.png" alt-text="Screenshot of the Manage SLIs page listing SLIs with evaluation method, status, and remaining error budget." lightbox="media/service-level-indicators-create/manage-service-level-indicators.png":::

When you drill into a single SLI, Azure Monitor opens a detailed view that shows its current status, measured trend, remaining error budget, and burn rate over time. Use this view to investigate whether the SLI is tracking toward its target and to understand how quickly current conditions are consuming the error budget.

:::image type="content" source="media/service-level-indicators-create/service-level-indicator-details.png" alt-text="Screenshot of the SLI details view showing status, trend, remaining error budget, and burn rate charts for a single service level indicator.":::



## Understand baseline target, error budget, and burn rate


Azure Monitor uses the baseline target to calculate the remaining margin for failure.

- **Error budget** is the amount of unreliability that the service can still absorb before it misses the baseline target.
- **Burn rate** is the speed at which the service is consuming that error budget.

For example, the error budget for a baseline target of 99.9% is 0.1%: `Error budget = 100% - baseline target`

Use error budget to understand how much room for failure remains. Use burn rate to see whether current conditions are consuming that budget at a sustainable pace or at a rate that's likely to cause a miss before the end of the compliance period.

Fast-burn conditions usually indicate sudden regressions. Slow-burn conditions indicate sustained degradation that can still cause the service to miss its target over time.


## Next steps

- Review [Azure Monitor overview](overview.md).
- Learn more about [Azure Monitor workspaces](../metrics/azure-monitor-workspace-overview.md).
- Create alert notifications by using [action groups in Azure Monitor](../alerts/action-groups.md).