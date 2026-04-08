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

* Existing service group.
* Source [Azure Monitor workspace](../metrics/azure-monitor-workspace-overview.md) that contains the metrics you want to evaluate and a destination Azure Monitor workspace where Azure Monitor stores the evaluated SLI results. You can use the same workspace for both source and destination.
* User-assigned managed identity that's used to access the workspaces. For guidance, see [Manage user-assigned managed identities using the Azure portal](/entra/identity/managed-identities-azure-resources/manage-user-assigned-managed-identities-azure-portal).
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

In the Azure portal, open your service group and select **Monitoring**. In the **SLI** card, select **Create SLIs**.

:::image type="content" source="media/create-service-level-indicators/service-group-monitoring.png" alt-text="Screenshot of the Monitoring page for a service group with the SLI card and the Create SLIs button.":::

### Basics tab
The **Basics** tab lets you provide a name and description for the SLI in addition to the SLI type. 

:::image type="content" source="media/create-service-level-indicators/create-sli-entry.png" alt-text="Screenshot of the Basics tab when you create a new SLI, showing availability and latency options.":::

The SLI type defines the reliability question that you're asking. Availability asks whether the service is working. Latency asks whether the service is responding quickly enough to satisfy the experience that you want to protect.

| Type | Description | Example |
|:---|:---|:---|
| Availability | Measures the uptime of the service, whether requests or time windows satisfy a success condition. | 99.99% of read and write requests were successful during the measurement period. |
| Latency | Measures performance of the service. Whether requests or time windows stay within a latency threshold. | 95% of requests completed in less than 300 milliseconds during the measurement period. |



### SLI tab
The **SLI** tab lets you define the metrics that are used for the SLI and how they're evaluated.

### Metrics details

| Evaluation method | How it works | Typical fit |
|:---|:---|:---|
| Request-based | Evaluates the ratio of good requests to total requests. received. A good outcome is when this ratio meets or exceeds the defined target during the compliance period. | Use when reliability should reflect per-request success or failure regardless of traffic spikes or uneven load distribution over time. This is the most common evaluation method. |
| Window-based | Measures reliability using a custom condition over a metric timeseries. Evaluates the ratio of time intervals meeting a defined quality threshold to the total number of intervals in the compliance period. | Use when you want to mask short bursts of poor performance since compliance is averaged over intervals. |

### Identity and data source

Select the Azure Monitor workspace that contains the metrics you want to use for the SLI and the user-assigned managed identity that has access to that workspace.

### SLI details

The SLI details define the metrics or formulas to use for the SLI evaluation. This will vary based on the SLI type.

**Request-based evaluation**

In a request-based SLI, Azure Monitor uses two queries:

* **Good signal** is the numerator. It represents the requests that met the success condition.
* **Total signal** is the denominator. It represents the full request volume that the SLI should evaluate.

This model is the most direct way to express outcomes such as successful requests, requests under a latency threshold, or requests that satisfy a specific dimension filter. You can combine multiple metrics with formulas when one metric alone doesn't represent the workload behavior that you want to measure.

In the following example, the good signal is defined as the count of requests with a 200 status code, and the total signal is defined as the count of all requests. The resulting SLI will measure the ratio of successful requests to total requests.

:::image type="content" source="media/create-service-level-indicators/request-based-sli.png" alt-text="Screenshot of the request-based SLI configuration showing separate Good signal and Total signal sections, each with options to add metrics and formulas.":::



Consistent aggregation matters in this model. If the good signal and total signal use incompatible aggregations or filters, the resulting ratio can misrepresent the true request experience.


### Identity and data storage location

Select the Azure Monitor workspace that will store the SLI metric values and the user-assigned managed identity that has access to that workspace.




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