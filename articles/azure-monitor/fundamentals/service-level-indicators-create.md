---
title: Create service level indicators in Azure Monitor
description: Learn how to create service level indicators in Azure Monitor, configure signals and baselines, and review SLI status for a service group.
ms.topic: how-to
ms.date: 04/07/2026
ai-usage: ai-assisted
---

# Create service level indicators in Azure Monitor

Use this article to create a service level indicator (SLI) for a [service group](/azure/governance/service-groups/overview) in the Azure portal. You select the source metrics, define how Azure Monitor evaluates good and bad outcomes, and choose where to store the evaluated SLI results.

Before you start, review [Service level indicator concepts in Azure Monitor](service-level-indicators.md) for guidance on SLI types, evaluation methods, and signal design.

## Prerequisites

- An existing service group.
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

1. In the Azure portal, open your service group.
1. Select **Monitoring**.
1. In the **SLI** card, select **Create SLIs**.

:::image type="content" source="media/create-service-level-indicators/service-group-monitoring.png" alt-text="Screenshot of the Monitoring page for a service group with the SLI card and the Create SLIs button.":::

## Configure the Basics tab

On the **Basics** tab, enter the SLI identity and select the SLI type.

1. Enter a name for the SLI.
1. Optional: Enter a description.
1. Select the SLI type.

:::image type="content" source="media/create-service-level-indicators/create-sli-entry.png" alt-text="Screenshot of the Basics tab when you create a new SLI, showing availability and latency options.":::

The SLI type defines the reliability question you're asking. Availability asks whether the service is working. Latency asks whether the service is responding quickly enough to protect the experience you want to measure.

| Type | Description | Example |
|:---|:---|:---|
| Availability | Measures the uptime of the service, whether requests or time windows satisfy a success condition. | 99.99% of read and write requests were successful during the measurement period. |
| Latency | Measures performance of the service. Whether requests or time windows stay within a latency threshold. | 95% of requests completed in less than 300 milliseconds during the measurement period. |

## Configure the SLI tab

On the **SLI** tab, select the evaluation method, choose the identity and workspaces, and define the signals that Azure Monitor uses to evaluate the SLI.

:::image type="content" source="media/create-service-level-indicators/metric-details.png" alt-text="Screenshot of the Metric details and Identity and data source sections showing the evaluation method selector, managed identity selection, and source workspace selection.":::

### Metrics details

| Evaluation method | How it works | Typical fit |
|:---|:---|:---|
| Request-based | Evaluates the ratio of good requests to total requests. A good outcome is when this ratio meets or exceeds the defined target during the compliance period. | Use when reliability should reflect per-request success or failure regardless of traffic spikes or uneven load distribution over time. This is the most common evaluation method. |
| Window-based | Measures reliability by using a custom condition over a metric time series. It evaluates the ratio of time intervals that meet a defined quality threshold to the total number of intervals in the compliance period. | Use when you want to smooth short bursts of poor performance because compliance is averaged over intervals. |

### Identity and workspaces

1. Select the user-assigned managed identity that Azure Monitor uses to read the source metrics.
1. Select the source Azure Monitor workspace that contains the metrics you want to evaluate.
1. Select the destination Azure Monitor workspace where Azure Monitor stores the evaluated SLI results.

You can use the same workspace for both source and destination, or you can use separate workspaces.

:::image type="content" source="media/create-service-level-indicators/destination-workspace.png" alt-text="Screenshot of the Identity and data storage location section showing managed identity and destination workspace selection.":::


### SLI details

The SLI details define the metrics or formulas that Azure Monitor uses for the SLI evaluation. The configuration depends on the evaluation method you selected.

**Request-based evaluation**

Use this model to measure outcomes such as successful requests, requests under a latency threshold, or requests that satisfy a specific dimension filter.

In a request-based SLI, Azure Monitor uses two values to evaluate reliability:

- **Good signal** is the numerator. It represents the requests that met the success condition.
- **Total signal** is the denominator. It represents the full request volume that the SLI should evaluate.

If one metric is enough for your SLI, select that metric and then select how to aggregate the value over time. This setting is the temporal aggregation. For example, you might use the average value over time, the maximum measured value, or a count of the requests that meet a condition.

Add filters such as a status code or dimension value to limit the values used for the calculation. For example, you can filter the good signal to count only requests with a `200` status code, and filter the total signal to count all requests regardless of status code. You'll usually apply more filters to the good signal than to the total signal.

Optional: Specify an aggregation across multiple time series after temporal aggregation. This setting is the spatial aggregation.

In the following example, the good signal is defined as the count of requests with a 200 status code, and the total signal is defined as the count of all requests. The resulting SLI will measure the ratio of successful requests to total requests.

:::image type="content" source="media/create-service-level-indicators/request-based-sli.png" alt-text="Screenshot of the request-based SLI configuration showing separate Good signal and Total signal sections, each with options to add metrics and formulas.":::


If you need more than one metric to define a signal, select **Add Metric** for each metric you need, and then select **Formula** to combine them. For example, you can use a formula such as `MetricA + MetricB`. You can also use a formula for a single metric, such as `MetricA * MetricA`.

**Window-based evaluation**

With this model, you don't explicitly provide good and total signals. For each window, Azure Monitor compares the metric value with a defined threshold to determine whether the window is good or bad.

Use metrics, filters, and formulas in the same way as the request-based model to define the signal that you want to evaluate. Then define the evaluation criteria that determines uptime.

:::image type="content" source="media/create-service-level-indicators/window-based-sli.png" alt-text="Screenshot of the window-based SLI configuration showing a signal section, SLI evaluation criteria, and identity and data storage location settings.":::

After you finish the configuration on the **SLI** tab, select **Create**.


## View and manage SLIs

After you create an SLI, Azure Monitor displays it on the **Monitoring** page for the service group.

1. Open the service group, and then select **Monitoring**.
1. Select **View all SLIs** to open the management experience.
1. Review the SLI status and remaining error budget in the list.
1. Select an SLI to review trend, error budget, and burn rate charts. To learn how Azure Monitor calculates these values, see [Service level indicator concepts in Azure Monitor](service-level-indicators.md#baseline-targets-error-budget-and-burn-rate).
1. Edit or delete the SLI as needed.

:::image type="content" source="media/create-service-level-indicators/manage-slis.png" alt-text="Screenshot of the Manage SLIs page listing SLIs with evaluation method, status, and remaining error budget.":::


## Next steps

- Review [Service level indicator concepts in Azure Monitor](service-level-indicators.md).
- Review [Azure Monitor overview](overview.md).
- Learn more about [Azure Monitor workspaces](../metrics/azure-monitor-workspace-overview.md).
- Create alert notifications by using [action groups in Azure Monitor](../alerts/action-groups.md).