---
title: Troubleshooting Azure Monitor metric charts
description: Troubleshoot the issues with creating, customizing, or interpreting metric charts
ms.reviewer: vitalyg
ms.topic: troubleshooting
ms.date: 08/07/2026
ai-usage: ai-assisted
---

# Troubleshooting metrics charts

Use this article if you run into problems with creating, customizing, or interpreting charts in Azure Monitor metrics explorer. If you're new to metrics, learn how to [Analyze metrics with Azure Monitor metrics explorer](analyze-metrics.md). See [examples](metric-chart-samples.md) of configured metric charts.

## Chart shows no data

Sometimes the charts might show no data after selecting correct resources and metrics. Several of the following reasons can cause this behavior:

### Microsoft.Insights resource provider isn't registered for your subscription

Exploring metrics requires *Microsoft.Insights* resource provider registered in your subscription. In many cases, it's registered automatically (that is, after you configure an alert rule, customize diagnostic settings for any resource, or configure an autoscale rule). If the Microsoft.Insights resource provider isn't registered, you must manually register it by following steps described in [Azure resource providers and types](/azure/azure-resource-manager/management/resource-providers-and-types).

**Solution:** Open **Subscriptions**, **Resource providers** tab, and verify that *Microsoft.Insights* is registered for your subscription.

### You don't have sufficient access rights to your resource

In Azure, [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview) controls access to metrics. You must be a member of [Monitoring Reader](/azure/role-based-access-control/built-in-roles#monitoring-reader) or [Monitoring Contributor](/azure/role-based-access-control/built-in-roles#monitoring-contributor) to explore metrics for any resource.

**Solution:** Ensure that you have sufficient permissions for the resource from which you're exploring metrics.

### You receive the error message "Access permission denied"

You may encounter this message when querying from an Azure Kubernetes Service (AKS) or Azure Monitor workspace. Since Prometheus metrics for your AKS are stored in Azure Monitor workspaces, this error can be caused by various reasons:

* You might not have permission to query the Azure Monitor workspace that contains the metrics.
* You might have ad blocker software enabled that blocks `monitor.azure.com` traffic.
* Your Azure Monitor workspace Networking settings don't support query access.

**Solution(s):** One or more of the following fixes may be required to fix the error.

* Check that you have sufficient permissions to perform microsoft.monitor/accounts/read assigned through Access Control (IAM) in your Azure Monitor workspace.
* Pause or disable your ad blocker to view data, or set your ad blocker to allow `monitor.azure.com` traffic.
* You might need to enable private access through your private endpoint or change settings to allow public access.

### Your resource didn't emit metrics during the selected time range

Some resources don't constantly emit their metrics. For example, Azure doesn't collect metrics for stopped virtual machines. Other resources might emit their metrics only when some condition occurs. For example, a metric showing processing time of a transaction requires at least one transaction. If there were no transactions in the selected time range, the chart is naturally empty. Additionally, while most of the metrics in Azure are collected every minute, there are some that are collected less frequently. See the metric documentation to get more details about the metric that you're trying to explore.

**Solution:** Change the time of the chart to a wider range. You may start from "Last 30 days" using a larger time granularity (or relying on the "Automatic time granularity" option).

### You specified a time range greater than 30 days

[Most metrics in Azure are stored for 93 days](data-platform-metrics.md#retention-of-metrics). However, any single chart displays no more than 30 days worth of data. This limitation doesn't apply to [log-based metrics](../app/metrics-overview.md#log-based-metrics).

**Solution:** If you see a blank chart or your chart only displays part of metric data, verify that the difference between start and end dates in the time picker doesn't exceed the 30-day interval. After you select a 30-day interval, [pan](analyze-metrics.md#pan-across-metrics-data) the chart to view the full retention window.

### You specified a time range more than 93 days ago

[Most metrics in Azure are stored for 93 days](data-platform-metrics.md#retention-of-metrics) so you can't query more than 93 days back. 

**Solution:** Export your metrics data to a [Log Analytics workspace](/azure/azure-monitor/logs/log-analytics-workspace-overview) and query from there. [Manage data retention](/azure/azure-monitor/logs/data-retention-configure) in your Log Analytics workspace. For more information on metrics export, see [Diagnostic settings in Azure Monitor](../platform/diagnostic-settings.md) and [Metrics export using data collection rules](../data-collection/metrics-export-create.md).

### All metric values were outside of the locked y-axis range

[Locking the boundaries of chart y-axis](analyze-metrics.md#lock-the-y-axis-range) can unintentionally make the chart display area not show the chart line. For example, if the y-axis is locked to a range between 0% and 50%, and the metric has a constant value of 100%, the line is always rendered outside of the visible area, making the chart appear blank.

**Solution:** Verify that the y-axis boundaries of the chart aren't locked outside of the range of the metric values. If the y-axis boundaries are locked, you may want to temporarily reset them to ensure that the metric values don't fall outside of the chart range. Locking the y-axis range isn't recommended with automatic granularity for the charts with **sum**, **min**, and **max** aggregation because their values will change with granularity by resizing browser window or going from one screen resolution to another. Switching granularity may leave the display area of your chart empty.

### You didn't enable OpenTelemetry guest metrics

Azure Monitor doesn't collect guest operating system metrics until you enable enhanced monitoring for the virtual machine. Enhanced monitoring installs Azure Monitor Agent and sends OpenTelemetry system metrics to an Azure Monitor workspace.

**Solution:** [Enable enhanced monitoring](../vm/tutorial-enable-monitoring.md#enable-enhanced-monitoring) and leave **OpenTelemetry metrics** selected. For details about data storage and query behavior, see [Metrics experience for virtual machines in Azure Monitor](../vm/metrics-opentelemetry-guest.md).

### Chart is segmented by a property that the metric doesn't define

If you segment a chart by a property that the metric doesn't define, the chart displays no content.

**Solution:** Clear the segmentation (splitting), or choose a different property.

### Filter on another chart excludes all data

Filters apply to all of the charts on the pane. If you set a filter on another chart, it could exclude all data from the current chart.

**Solution:** Check the filters for all the charts on the pane. If you want different filters on different charts, create the charts in different panes. Save the charts as separate favorites. If you want, pin the charts to the dashboard to see them together.

## "Error retrieving data" message on dashboard

This problem may happen when your dashboard was created with a metric that was later deprecated and removed from Azure. To verify that it's the case, open the **Metrics** tab of your resource, and check the available metrics in the metric picker. If the metric isn't shown, the metric has been removed from Azure. Usually, when a metric is deprecated, there's a better new metric that provides with a similar perspective on the resource health.

**Solution:** Update the failing tile by picking an alternative metric for your chart on dashboard. [Review a list of available metrics for Azure services](../reference/metrics-index.md).

## Chart shows dashed line

Azure metrics charts use dashed line style to indicate that there's a missing value (also known as "null value") between two known time grain data points. For example, if in the time selector you picked "1 minute" time granularity but the metric was reported at 07:26, 07:27, 07:29, and 07:30 (note a minute gap between second and third data points), then a dashed line connects 07:27 and 07:29 and a solid line connects all other data points. The dashed line drops down to zero when the metric uses **count** and **sum** aggregation. For the **avg**, **min** or **max** aggregations, the dashed line connects two nearest known data points. Also, when the data is missing on the rightmost or leftmost side of the chart, the dashed line expands to the direction of the missing data point.

:::image type="content" source="./media/metrics-troubleshoot/dashed-line.png" lightbox="./media/metrics-troubleshoot/dashed-line.png" alt-text="Screenshot that shows how when the data is missing on the rightmost or leftmost side of the chart, the dashed line expands to the direction of the missing data point.":::

**Solution:** This behavior is by design. It's useful for identifying missing data points. The line chart is a superior choice for visualizing trends of high-density metrics but might be difficult to interpret for the metrics with sparse values, especially when correlating values with time grain is important. The dashed line makes reading of these charts easier but if your chart is still unclear, consider viewing your metrics with a different chart type. For example, a scatter plot chart for the same metric clearly shows each time grain by only visualizing a dot when there's a value and skipping the data point altogether when the value is missing:
:::image type="content" source="./media/metrics-troubleshoot/scatter-plot.png" lightbox="./media/metrics-troubleshoot/scatter-plot.png" alt-text="Screenshot that highlights the Scatter chart menu option." border="false":::

> [!NOTE]
> If you still prefer a line chart for your metric, moving mouse over the chart may help to assess the time granularity by highlighting the data point at the location of the mouse pointer.

## Units of measure in metrics charts

Azure Monitor metrics uses SI based prefixes. Metrics only use IEC prefixes if the resource provider chooses an appropriate unit for a metric.
For example: The resource provider Network interface (resource name: contoso-vm) has no metric unit defined for "Packets Sent". The prefix used for the metric value is k, representing kilo (1000), an SI prefix.
:::image type="content" source="./media/metrics-troubleshoot/prefix-si.png" lightbox="./media/metrics-troubleshoot/prefix-si.png" alt-text="Screenshot that shows metric value with prefix kilo.":::

The resource provider Storage account (resource name: contoso-storage) has metric unit defined for "Blob Capacity" as bytes. Hence, the prefix used is mebi (1024^2), an IEC prefix.
:::image type="content" source="./media/metrics-troubleshoot/prefix-iec.png" lightbox="./media/metrics-troubleshoot/prefix-iec.png" alt-text="Screenshot that shows metric value with prefix mebi.":::

SI uses decimal:

| Value  | abbreviation | SI    |
|:------:|:------------:|:-----:|
| 1000   | k            | kilo  |
| 1000^2 | M            | mega  |
| 1000^3 | G            | giga  |
| 1000^4 | T            | tera  |
| 1000^5 | P            | peta  |
| 1000^6 | E            | exa   |
| 1000^7 | Z            | zetta |
| 1000^8 | Y            | yotta |

IEC uses binary:

| Value  | abbreviation | IEC  | Legacy | SI   |
|:------:|:------------:|:----:|:------:|:----:|
| 1024   | Ki           | kibi | K      | kilo |
| 1024^2 | Mi           | mebi | M      | mega |
| 1024^3 | Gi           | gibi | G      | giga |
| 1024^4 | Ti           | tebi | T      | tera |
| 1024^5 | Pi           | pebi | -      |      |
| 1024^6 | Ei           | exbi | -      |      |
| 1024^7 | Zi           | zebi | -      |      |
| 1024^8 | Yi           | yobi | -      |      |


## Chart shows unexpected drop in values

In many cases, the perceived drop in the metric values is a misunderstanding of the data shown on the chart. A drop in sums or counts can mislead you when the chart shows the most-recent minutes because Azure hasn't received or processed the last metric data points yet. Depending on the service, the latency of processing metrics can be within a couple minutes range. For charts showing a recent time range with a 1- or 5- minute granularity, a drop of the value over the last few minutes becomes more noticeable:

:::image type="content" source="media/metrics-troubleshoot/unexpected-dip.png" lightbox="media/metrics-troubleshoot/unexpected-dip.png" alt-text="Screenshot that shows a drop of the value over the last few minutes." border="false":::

**Solution:** This behavior is by design. Displaying data as soon as receiving it is beneficial even when the data is *partial* or *incomplete*. Doing so lets you draw conclusions sooner and start investigating right away. For example, for a metric that shows the number of failures, seeing a partial value X tells you that there were at least X failures on a given minute. Start investigating the problem right away, rather than waiting to see the exact count of failures that happened on this minute, which might not be as important. The chart updates after the entire set of data is received, but at that time it might also show new incomplete data points from more recent minutes.

## Guest (classic) namespace isn't available

The **Guest (classic)** metric namespace uses the retired Azure Diagnostics extension and isn't the current path for guest operating system metrics. For new virtual machine monitoring, use OpenTelemetry system metrics. Azure Monitor Agent collects these metrics and stores them in an Azure Monitor workspace, where you query them by using PromQL.

If OpenTelemetry guest metrics aren't collected yet, metrics explorer shows only the **Virtual Machine Host** metric namespace:

:::image type="content" source="media/metrics-troubleshoot/vm-metrics.png" lightbox="media/metrics-troubleshoot/vm-metrics.png" alt-text="Screenshot that shows only the Virtual Machine Host metric namespace available in metrics explorer.":::

**Solution:** If you don't see guest operating system metrics in metrics explorer:

1. [Enable enhanced monitoring](../vm/tutorial-enable-monitoring.md#enable-enhanced-monitoring) for the virtual machine.

1. Ensure that **Microsoft.Insights** resource provider is [registered for your subscription](#microsoftinsights-resource-provider-isnt-registered-for-your-subscription).

1. On the **Configure monitor** page, leave **OpenTelemetry metrics** selected and select an Azure Monitor workspace. For expected behavior and limitations, see [Metrics experience for virtual machines in Azure Monitor](../vm/metrics-opentelemetry-guest.md).

## Log and queries are disabled for Drill into Logs

To view recommended logs and queries, you must route your diagnostic logs to Log Analytics.

**Solution:** To route your diagnostic logs to Log Analytics, see [Diagnostic settings in Azure Monitor](../platform/diagnostic-settings.md).

## Only the Activity logs appear in Drill into Logs

The Drill into Logs feature is only available for select resource providers. By default, activity logs are provided.

**Solution:** This behavior is expected for some resource providers.

## Next steps

* [Learn about the Azure Monitor metrics explorer](analyze-metrics.md)
* [See a list of available metrics for Azure services](../reference/metrics-index.md)
* [See examples of configured charts](metric-chart-samples.md)
