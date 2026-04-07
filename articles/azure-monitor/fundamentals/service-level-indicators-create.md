---
title: Create service level indicators in Azure Monitor
description: Learn how to create service level indicators in Azure Monitor, configure signals and baselines, and review SLI status for a service group.
ms.topic: how-to
ms.date: 04/07/2026
ai-usage: ai-assisted
---

# Create service level indicators in Azure Monitor

Use this article to create a service level indicator (SLI) for a [service group](/azure/governance/service-groups/overview) in the Azure portal. You configure the source metrics, define how Azure Monitor evaluates good and bad outcomes, and store the evaluated results in a destination workspace.

For SLI concepts, including SLI type selection and metric details design, see [Service level indicator concepts in Azure Monitor](service-level-indicators.md).

## Prerequisites

* An existing service group.
* A source [Azure Monitor workspace](../metrics/azure-monitor-workspace-overview.md) that contains the metrics you want to evaluate.
* A destination [Azure Monitor workspace](../metrics/azure-monitor-workspace-overview.md) where Azure Monitor stores the evaluated SLI results.
* The source and destination can be the same workspace if that fits your design.
* A user-assigned managed identity. For guidance, see [Manage user-assigned managed identities using the Azure portal](/entra/identity/managed-identities-azure-resources/manage-user-assigned-managed-identities-azure-portal).
* Access to the source workspace, destination workspace, and destination workspace default data collection rule.

If you have **Contributor** access at the subscription level for both workspaces, you typically don't need any additional role assignments. Otherwise, assign the following minimum roles.

| Resource | Minimum role assignments |
|---|---|
| Source Azure Monitor workspace | **Monitoring Reader** |
| Destination Azure Monitor workspace | **Monitoring Reader** and **Monitoring Metrics Publisher** |
| Destination workspace default data collection rule | **Monitoring Reader** |

The default data collection rule for the destination workspace is stored in the managed resource group that's associated with the workspace. On the destination workspace **Overview** page, select the **Data Collection Rule** link to open that resource and verify access.

## Before you begin

Review [Service level indicator concepts in Azure Monitor](service-level-indicators.md) to choose your SLI type, signal design, and workspace strategy before you configure the portal flow.

## Create an SLI in the portal

After you decide the concept choices in the previous sections, complete the portal flow.

1. In the Azure portal, open your service group.
1. Select **Monitoring**.
1. In the **SLI** card, select **Create SLIs**.

:::image type="content" source="media/create-service-level-indicators/service-group-monitoring.png" alt-text="Screenshot of the Monitoring page for a service group with the SLI card and the Create SLIs button.":::

### Basics tab

1. Select an SLI type: **Availability** or **Latency**.
1. Enter an SLI name and description.
1. Select **Next**.

:::image type="content" source="media/create-service-level-indicators/create-sli-entry.png" alt-text="Screenshot of the Basics tab when you create a new SLI, showing availability and latency options.":::

### SLI tab

The **SLI** tab has three main sections: **Metric details**, **SLI details**, and **Identity and data storage location**.

1. Under **Metric details**, select **Request-based** or **Window-based**.
1. Select the user-assigned managed identity for metric reads, and then select the source workspace.
1. Configure the query logic for your evaluation model by selecting metrics, dimensions, filters, aggregations, and formulas as needed.
1. For request-based SLIs, configure **Good signal** and **Total signal**. For window-based SLIs, configure the signal, window duration, and threshold that determine whether a window is good or bad.
1. Select **Show Preview charts** to validate results.

Use these guidelines while you build the signal:

* For request-based SLIs, the good signal is the numerator and the total signal is the denominator.
* Use temporal and spatial aggregations that match how you want the signal to be evaluated.
* Add filters when you need to scope the signal to a specific workload slice, such as a status code or dimension value.
* Use formulas when you need to combine multiple metrics into one signal.

Request-based SLIs are usually the best choice when each request should contribute equally to the result. Window-based SLIs are useful when you want to evaluate whether each interval meets a threshold and smooth short bursts of poor performance.

:::image type="content" source="media/create-service-level-indicators/sli-tab-overview.png" alt-text="Screenshot of the SLI tab with metric details, signal configuration, and destination settings for a request-based SLI.":::

### Identity and data storage location

1. Select the user-assigned managed identity for writes.
1. Select the destination Azure Monitor workspace.
1. Confirm required access to the destination workspace and its default data collection rule.
1. Select **Next**.

You can use the same workspace for both source and destination, or use separate workspaces. Azure Monitor stores the evaluated SLI results in the destination workspace so you can review the SLI later.

:::image type="content" source="media/create-service-level-indicators/destination-workspace.png" alt-text="Screenshot of the identity and data storage location section for selecting a managed identity and destination workspace.":::

### Baseline tab

1. Enter the baseline target.
1. Select the lookback window.
1. Select the compliance period.
1. Review the configuration and create the SLI.

The baseline is your SLO target. Azure Monitor uses this value to calculate error budget and evaluate compliance over the lookback window and compliance period that you choose.

When alerting is enabled, use baseline-based alerts for static threshold checks and burn rate-based alerts for error-budget consumption velocity.

## View and manage SLIs

After you create an SLI, Azure Monitor displays it on the **Monitoring** page for the service group.

1. Open the service group, and then select **Monitoring**.
1. Select **View all SLIs** to open the management experience.
1. Review the SLI status and remaining error budget in the list.
1. Select an SLI to review trend, error budget, and burn rate charts.
1. Edit or delete the SLI as needed.

:::image type="content" source="media/create-service-level-indicators/manage-slis.png" alt-text="Screenshot of the Manage SLIs page listing SLIs with evaluation method, status, and remaining error budget.":::

## Next steps

* Review [Service level indicator concepts in Azure Monitor](service-level-indicators.md).
* Review [Azure Monitor overview](overview.md).
* Learn more about [Azure Monitor workspaces](../metrics/azure-monitor-workspace-overview.md).
* Create alert notifications by using [action groups in Azure Monitor](../alerts/action-groups.md).