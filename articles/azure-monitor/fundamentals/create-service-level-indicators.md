---
title: Create service level indicators in Azure Monitor
description: Learn how to create service level indicators in Azure Monitor, define baselines, and track error budgets and burn rates for a service group.
ms.topic: how-to
ms.date: 03/19/2026
ai-usage: ai-assisted
---

# Create service level indicators in Azure Monitor

Use service level indicators (SLIs) in Azure Monitor to measure the reliability of a service group by tracking availability or latency against a target. After you create an SLI, you can evaluate current performance, monitor the remaining error budget, and understand how quickly that budget is being consumed.

This article shows you how to create an SLI in the Azure portal, choose the right evaluation model, store the evaluated results, and configure a baseline that Azure Monitor can use for compliance tracking.

## Prerequisites

* You have an existing service group.
* You have a source [Azure Monitor workspace](../metrics/azure-monitor-workspace-overview.md) that contains the metrics you want to evaluate.
* You have a destination [Azure Monitor workspace](../metrics/azure-monitor-workspace-overview.md) where Azure Monitor stores the evaluated SLI results.
* You have a user-assigned managed identity. For guidance, see [Manage user-assigned managed identities using the Azure portal](/entra/identity/managed-identities-azure-resources/manage-user-assigned-managed-identities-azure-portal).
* You have access to the source workspace, destination workspace, and destination workspace default data collection rule.

If you have **Contributor** access at the subscription level for both workspaces, you typically don't need any additional role assignments. Otherwise, assign the following minimum roles.

| Resource | Minimum role assignments |
|---|---|
| Source Azure Monitor workspace | **Monitoring Reader** |
| Destination Azure Monitor workspace | **Monitoring Reader** and **Monitoring Metrics Publisher** |
| Destination workspace default data collection rule | **Monitoring Reader** |

The default data collection rule for the destination workspace is stored in the managed resource group that's associated with the workspace. On the destination workspace **Overview** page, select the **Data Collection Rule** link to open that resource and verify access.

## Create an SLI

Create SLIs from the service group that represents the application or workload you want to monitor.

1. In the Azure portal, open your service group.
1. Select **Monitoring**.
1. In the **SLI** card, select **Create SLIs**.
1. On the **Basics** tab, select the SLI type.
1. Enter a name and description for the SLI.
1. Select **Next**.

:::image type="content" source="media/create-service-level-indicators/service-group-monitoring.png" alt-text="Screenshot of the Monitoring page for a service group with the SLI card and the Create SLIs button.":::

:::image type="content" source="media/create-service-level-indicators/create-sli-entry.png" alt-text="Screenshot of the Basics tab when you create a new SLI, showing availability and latency options.":::

Choose **Availability** when you want to measure whether requests or time windows meet a success condition. Choose **Latency** when you want to measure whether requests or time windows stay within a latency threshold.

## Choose the evaluation type

On the **SLI** tab, Azure Monitor asks you how to evaluate the metric and how to authenticate to the source workspace.

1. Under **Metric details**, select an evaluation type.
1. Select the user-assigned managed identity that Azure Monitor should use to read metrics.
1. Select the source Azure Monitor workspace.

:::image type="content" source="media/create-service-level-indicators/sli-tab-overview.png" alt-text="Screenshot of the SLI tab with metric details, signal configuration, and destination settings for a request-based SLI.":::

:::image type="content" source="media/create-service-level-indicators/metric-details.png" alt-text="Screenshot of the Metric details area on the SLI tab with evaluation method and source identity fields.":::

Choose the evaluation type that matches how you want to measure reliability.

### Request-based SLI

Use a request-based SLI when you want to compare successful requests with total requests over the compliance period. This model works well when traffic volume changes over time and you want every request to contribute to the final score.

Use a request-based SLI in scenarios like these:

* Response time is below 150 milliseconds for at least 97 percent of requests.
* Availability is at least 99 percent over the selected lookback period.

### Window-based SLI

Use a window-based SLI when you want to evaluate reliability over fixed time windows, such as 1-minute or 5-minute intervals. Azure Monitor marks each window as good or bad based on the threshold you define and then calculates the ratio of good windows to total windows.

Use a window-based SLI in scenarios like these:

* The 99th percentile latency stays below 120 milliseconds for at least 98 percent of 5-minute windows.
* Availability remains above the threshold for the required percentage of windows in the compliance period.

Choose this model when you want to smooth short spikes over time.

## Define the SLI query

After you choose the evaluation type, define the signals, filters, and formula that Azure Monitor should use for the calculation.

### Configure a request-based SLI

Request-based SLIs require two signals:

* A **good signal** that represents successful requests.
* A **total signal** that represents all eligible requests.

1. Under **Good Signal**, select the metric that represents successful requests.
1. Add any dimensions, filters, and temporal aggregations that are required for the metric.
1. If needed, add a spatial aggregation to combine multiple time series after temporal aggregation.
1. Repeat the process under **Total Signal** to select the metric that represents all requests.
1. If either signal requires multiple metrics, use **Formula** to combine them.
1. Select **Show Preview charts** to confirm that the query returns the expected results.

:::image type="content" source="media/create-service-level-indicators/request-based-sli.png" alt-text="Screenshot of the request-based SLI details area with separate Good signal and Total signal sections.":::

:::image type="content" source="media/create-service-level-indicators/formula-builder.png" alt-text="Screenshot of a request-based SLI query with metric filters, aggregations, and signal formulas configured.":::

Use aggregation functions that match the scenario, such as count- or rate-based calculations. If your numerator and denominator use inconsistent aggregations, the SLI can produce misleading results.

### Configure a window-based SLI

Window-based SLIs evaluate one or more signals against a threshold for each window.

1. Select the signal to measure.
1. Add any required dimensions, filters, and aggregations.
1. If needed, use **Formula** to combine multiple metrics into a single signal.
1. Define the goodness criteria for the window, including the window duration and threshold.
1. Select **Show Preview charts** to validate the signal before you continue.

:::image type="content" source="media/create-service-level-indicators/window-based-sli.png" alt-text="Screenshot of a window-based SLI configuration with signal inputs and window evaluation criteria.":::

Use this model when uptime depends on whether each interval meets a condition.

## Select the destination workspace

Azure Monitor stores the evaluated SLI results in a destination workspace so you can query them later and use them in dashboards or alerts.

1. In **Identity and data storage location**, select the user-assigned managed identity that Azure Monitor should use to write the evaluated results.
1. Select the destination Azure Monitor workspace.
1. Verify that the selected identity has the required access to the destination workspace and its default data collection rule.
1. Select **Next**.

:::image type="content" source="media/create-service-level-indicators/destination-workspace.png" alt-text="Screenshot of the identity and data storage location section for selecting a managed identity and destination workspace.":::

## Set the baseline

On the **Baseline** tab, define the target and lookback period that Azure Monitor should use to evaluate compliance.

1. Enter the baseline target for the SLI.
1. Select the evaluation lookback window.
1. Choose the compliance period that fits your reporting model, such as a calendar-based window or a rolling window.
1. Review the configuration, and then create the SLI.

The baseline is the service level objective (SLO) for the SLI. Azure Monitor uses it to determine whether current performance is within the allowed error budget.

## View and manage SLIs

After you create an SLI, Azure Monitor displays it on the **Monitoring** page for the service group.

1. Open the service group, and then select **Monitoring**.
1. To view all SLIs for the service group, open the SLI management page.
1. Select an SLI to view its trend, error budget, and burn rate charts.
1. Edit or delete the SLI if you need to adjust the definition.

:::image type="content" source="media/create-service-level-indicators/service-group-sli-list.png" alt-text="Screenshot of the service group Monitoring page showing the SLI card after several SLIs have been created.":::

:::image type="content" source="media/create-service-level-indicators/manage-slis.png" alt-text="Screenshot of the Manage SLIs page listing SLIs with evaluation method, status, and remaining error budget.":::

:::image type="content" source="media/create-service-level-indicators/sli-details.png" alt-text="Screenshot of an SLI details page with charts for SLI performance, error budget remaining, and burn rate.":::

The SLI status represents the current value of the indicator based on your selected evaluation model:

* For request-based SLIs, the value is based on good requests divided by total requests.
* For window-based SLIs, the value is based on good windows divided by total windows.

## Interpret error budget and burn rate

After the SLI starts evaluating, use the error budget and burn rate to understand risk.

* **Error budget** is the amount of failure that remains before the baseline is violated. It starts at `1 - baseline` and decreases as bad events or bad windows accumulate.
* **Burn rate** shows how quickly the error budget is being consumed over the selected period.

Use fast-burn alerts when you want to detect sudden degradation quickly. Use slow-burn alerts when you want to identify a persistent trend that could exhaust the error budget before the end of the compliance period.

## Next steps

* Review [Azure Monitor overview](overview.md).
* Learn more about [Azure Monitor workspaces](../metrics/azure-monitor-workspace-overview.md).
* Create alert notifications by using [action groups in Azure Monitor](../alerts/action-groups.md).
