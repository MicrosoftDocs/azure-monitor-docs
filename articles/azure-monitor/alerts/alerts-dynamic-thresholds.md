---
title: Create an Azure Monitor metric alert with dynamic thresholds
description: Get information about creating metric alerts with dynamic thresholds that are based on machine learning.
ms.reviewer: harelbr
ms.topic: article
ms.date: 11/18/2025
---

# Alert rules with dynamic thresholds overview

For occasions when you're unsure of the best values to use as the thresholds for your alert rules, dynamic thresholds apply advanced machine learning and use a set of algorithms and methods to:

- Learn the historical behavior of metrics.
- Analyze metrics over time and identify patterns such as hourly, daily, or weekly patterns.
- Recognize anomalies that indicate possible service issues.
- Calculate the most appropriate thresholds for metrics.

When you use dynamic thresholds, you don't have to know the right threshold for each metric. Dynamic thresholds calculate the most appropriate thresholds for you.

Dynamic thresholds help you:

- Create scalable alerts for hundreds of metric series with one alert rule. If you have fewer alert rules, you spend less time creating and managing them. Scalable alerts are especially useful for multiple dimensions or for multiple resources, such as all resources in a subscription.
- Create rules without having to know what threshold to configure.
- Configure metric alerts by using high-level concepts without needing extensive domain knowledge about the metric.
- Prevent noisy (low precision) or wide (low recall) thresholds that don't have an expected pattern.

You can use dynamic thresholds on:

- Most Azure Monitor platform and custom metrics.
- Common application and infrastructure metrics.
- Noisy metrics, such as machine CPU or memory.
- Metrics with low dispersion, such as availability and error rate.

You can configure dynamic thresholds by using:

- The [Azure portal](https://portal.azure.com/).
- [Metric alert templates](./alerts-metric-create-templates.md).
- PowerShell, CLI, or Azure Resource Manager templates for [Metric alert rules](./alerts-create-rule-cli-powershell-arm.md).
- Azure Resource Manager templates for [Log search alert rules](./resource-manager-alerts-log.md). PowerShell and CLI are not yet supported.


## Alert threshold calculation and preview

When an alert rule is created, dynamic thresholds use 10 days of historical data to calculate hourly or daily seasonal patterns. The chart that you see in the alert preview reflects that data.

Dynamic thresholds continually use all available historical data to learn, and they make adjustments to be more accurate. After three weeks, dynamic thresholds have enough data to identify weekly patterns, and the model is adjusted to include weekly seasonality.

This ensures that once the outage ends, thresholds remain consistent with normal behavior rather than adapting to the outage as the new normal. Short spikes or flapping values are handled differently: dynamic thresholds apply seasonality and trend detection, along with minimum violation duration, to reduce false positives from brief anomalies.

## Considerations for using dynamic thresholds

- To help ensure accurate threshold calculation, alert rules that use dynamic thresholds don't trigger an alert before collecting three days and at least 30 samples of metric data. New resources or resources that are missing metric data don't trigger an alert until enough data is available.
- Dynamic thresholds need at least three weeks of historical data to detect weekly seasonality. Some detailed patterns, such as bihourly or semiweekly patterns, might not be detected.
- Changes in data behavior – If the behavior of a metric changed recently, the changes aren't immediately reflected in the dynamic threshold's upper and lower bounds. The borders are calculated based on metric data from the last 10 days.
- Dynamic thresholds are good for detecting significant deviations, as opposed to slowly evolving issues. Slow behavior changes probably won't trigger an alert.
- You can't use dynamic thresholds in alert rules that monitor multiple conditions.
- You can't use dynamic thresholds in Log search alert rules with 1-minute frequency.

## Create a metric alert rule with dynamic thresholds

To configure dynamic thresholds, follow the [procedure for creating an alert rule](alerts-create-new-alert-rule.md#create-or-edit-an-alert-rule-in-the-azure-portal). Use these settings on the **Condition** tab:

- For **Threshold**, select **Dynamic**.
- For **Aggregation type**, we recommend that you don't select **Maximum**.
- For **Operator**, select **Greater than** unless the behavior represents the application usage.
- For **Threshold sensitivity**, select **Medium** or **Low** to reduce alert noise.
- For **Check every**, select how often the alert rule checks if the condition is met. To minimize the business impact of the alert, consider using a lower frequency. Make sure that this value is less than or equal to the **Lookback period** value.
- For **Lookback period**, set the time period to look back at each time that the data is checked. Make sure that this value is greater than or equal to the **Check every** value.
- For **Advanced options**, choose how many violations will trigger the alert within a specific time period. Optionally, set the date from which to start learning the metric historical data and calculate the dynamic thresholds.

> [!NOTE]
> Metric alert rules that you create through the portal are created in the same resource group as the target resource.

## Dynamic threshold chart

The following chart shows a metric, its dynamic threshold limits, and some alerts that fired when the value was outside the allowed thresholds.

:::image type="content" source="media/alerts-dynamic-thresholds/threshold-picture-8bit.png" lightbox="media/alerts-dynamic-thresholds/threshold-picture-8bit.png" alt-text="Screenshot of a chart that shows a metric, its dynamic threshold limits, and some alerts that fired.":::

Use the following information to interpret the chart:

- **Blue line**: The metric measured over time.
- **Blue shaded area**: The allowed range for the metric. If the metric values stay within this range, no alert is triggered.
- **Blue dots**: Aggregated metric values. If you select part of the chart and then hover over the blue line, a blue dot appears under your cursor to indicate an individual aggregated metric value.
- **Pop-up box with blue dot**: The measured metric value (blue dot) and the upper and lower values of the allowed range.  
- **Red dot with a black circle**: The first metric value outside the allowed range. This value fires a metric alert and puts it in an active state.
- **Red dots**: Other measured values outside the allowed range. They don't trigger more metric alerts, but the alert stays in the active state.
- **Red area**: The time when the metric value was outside the allowed range. The alert remains in the active state as long as subsequent measured values are outside the allowed range, but no new alerts are fired.
- **End of red area**: A return to allowed values. When the blue line is back inside the allowed values, the red area stops and the measured value line turns blue. The status of the metric alert fired at the time of the red dot with a black circle is set to resolved.

## Known issues with dynamic threshold sensitivity

- If an alert rule that uses dynamic thresholds is too noisy or fires too much, you might need to reduce its sensitivity. Use one of the following options:

  - **Threshold sensitivity**: Set the sensitivity to **Low** to be more tolerant of deviations.
  - **Lookback period** (for Metric alert rules) or **Aggregation granularity** (for Log search alert rules) - Increasing the data window makes the rule less susceptible to transient deviations.
  - **Number of violations** (under **Advanced settings**): Configure the alert rule to trigger only if several deviations occur within a certain period of time. This setting makes the rule less susceptible to transient deviations.

- You might find that an alert rule that uses dynamic thresholds doesn't fire or isn't sensitive enough, even though the rule is configured with high sensitivity. This scenario can happen when the metric's distribution is highly irregular. Consider one of the following solutions:

  - Move to monitoring a complementary metric that's suitable for your scenario, if applicable. For example, check for changes in success rate rather than failure rate.
  - Try selecting a different value for **Aggregation granularity (Period)**.
  - Check if a drastic change happened in the metric behavior in the last 10 days, such as an outage. An abrupt change can affect the upper and lower thresholds calculated for the metric and make them broader. Wait a few days until the outage is no longer included in the threshold calculation. You can also edit the alert rule to use the **Ignore data before** option in **Advanced settings**.
  - If your data has weekly seasonality, but not enough history is available for the metric, the calculated thresholds can result in broad upper and lower bounds. For example, the calculation can treat weekdays and weekends in the same way and build wide borders that don't always fit the data. This issue should resolve itself after enough results from metric or log query history is available. Then, the Azure Monitor detects the correct seasonality and updates the calculated thresholds accordingly.

- When data exhibits large fluctuations, dynamic thresholds might build a wide model around the data values, which can result in a lower or higher boundary than expected. This scenario can happen when:

  - The sensitivity is set to low.
  - The metric or query result exhibits an irregular behavior with high variance, which appears as spikes or dips in the data.

  Consider making the model less sensitive by choosing a higher sensitivity or selecting a larger **Lookback period** value. You can also use the **Ignore data before** option to exclude a recent irregularity from the historical data that's used to build the model.

## Metrics not supported by dynamic thresholds

Dynamic thresholds support most metrics, but the following metrics can't use dynamic thresholds:

| Resource type | Metric name |
| --- | --- |
| Microsoft.ClassicStorage/storageAccounts | UsedCapacity |
| Microsoft.ClassicStorage/storageAccounts/blobServices | BlobCapacity |
| Microsoft.ClassicStorage/storageAccounts/blobServices | BlobCount |
| Microsoft.ClassicStorage/storageAccounts/blobServices | IndexCapacity |
| Microsoft.ClassicStorage/storageAccounts/fileServices | FileCapacity |
| Microsoft.ClassicStorage/storageAccounts/fileServices | FileCount |
| Microsoft.ClassicStorage/storageAccounts/fileServices | FileShareCount |
| Microsoft.ClassicStorage/storageAccounts/fileServices | FileShareSnapshotCount |
| Microsoft.ClassicStorage/storageAccounts/fileServices | FileShareSnapshotSize |
| Microsoft.ClassicStorage/storageAccounts/fileServices | FileShareQuota |
| Microsoft.Compute/disks | Composite Disk Read Bytes/sec |
| Microsoft.Compute/disks | Composite Disk Read Operations/sec |
| Microsoft.Compute/disks | Composite Disk Write Bytes/sec |
| Microsoft.Compute/disks | Composite Disk Write Operations/sec |
| Microsoft.ContainerService/managedClusters | NodesCount |
| Microsoft.ContainerService/managedClusters | PodCount |
| Microsoft.ContainerService/managedClusters | CompletedJobsCount |
| Microsoft.ContainerService/managedClusters | RestartingContainerCount |
| Microsoft.ContainerService/managedClusters | OomKilledContainerCount |
| Microsoft.Devices/IotHubs | TotalDeviceCount |
| Microsoft.Devices/IotHubs | ConnectedDeviceCount |
| Microsoft.DocumentDB/databaseAccounts | CassandraConnectionClosures |
| Microsoft.EventHub/clusters | Size |
| Microsoft.EventHub/namespaces | CPU |
| Microsoft.EventHub/namespaces | Memory Usage |
| Microsoft.EventHub/namespaces | ReplicationLagCount |
| Microsoft.EventHub/namespaces | Size |
| Microsoft.IoTCentral/IoTApps | connectedDeviceCount |
| Microsoft.IoTCentral/IoTApps | provisionedDeviceCount |
| Microsoft.Kubernetes/connectedClusters | NodesCount |
| Microsoft.Kubernetes/connectedClusters | PodCount |
| Microsoft.Kubernetes/connectedClusters | CompletedJobsCount |
| Microsoft.Kubernetes/connectedClusters | RestartingContainerCount |
| Microsoft.Kubernetes/connectedClusters | OomKilledContainerCount |
| Microsoft.MachineLearningServices/workspaces/onlineEndpoints | RequestsPerMinute |
| Microsoft.MachineLearningServices/workspaces/onlineEndpoints/deployments | DeploymentCapacity |
| Microsoft.Maps/accounts | CreatorUsage |
| Microsoft.Media/mediaservices/streamingEndpoints | EgressBandwidth |
| Microsoft.Network/applicationGateways | Throughput |
| Microsoft.Network/azureFirewalls | Throughput |
| Microsoft.Network/expressRouteGateways | ExpressRouteGatewayPacketsPerSecond |
| Microsoft.Network/expressRouteGateways | ExpressRouteGatewayNumberOfVmInVnet |
| Microsoft.Network/expressRouteGateways | ExpressRouteGatewayFrequencyOfRoutesChanged |
| Microsoft.Network/virtualNetworkGateways | ExpressRouteGatewayBitsPerSecond |
| Microsoft.Network/virtualNetworkGateways | ExpressRouteGatewayPacketsPerSecond |
| Microsoft.Network/virtualNetworkGateways | ExpressRouteGatewayNumberOfVmInVnet |
| Microsoft.Network/virtualNetworkGateways | ExpressRouteGatewayFrequencyOfRoutesChanged |
| Microsoft.ServiceBus/namespaces | Count of active messages in a Queue/Topic. (ActiveMessages)|
| Microsoft.ServiceBus/namespaces | Count of dead-lettered messages in a Queue/Topic (DeadletteredMessages) |
| Microsoft.ServiceBus/namespaces | Count of messages in a Queue/Topic (Messages) |
| Microsoft.ServiceBus/namespaces | Count of scheduled messages in a Queue/Topic (ScheduledMessages) |
| Microsoft.ServiceBus/namespaces | CPU (NamespaceCpuUsage) |
| Microsoft.ServiceBus/namespaces | Memory Usage (NamespaceMemoryUsage) |
| Microsoft.ServiceBus/namespaces | Size |
| Microsoft.ServiceFabricMesh/applications | AllocatedCpu |
| Microsoft.ServiceFabricMesh/applications | AllocatedMemory |
| Microsoft.ServiceFabricMesh/applications | ActualCpu |
| Microsoft.ServiceFabricMesh/applications | ActualMemory |
| Microsoft.ServiceFabricMesh/applications | ApplicationStatus |
| Microsoft.ServiceFabricMesh/applications | ServiceStatus |
| Microsoft.ServiceFabricMesh/applications | ServiceReplicaStatus |
| Microsoft.ServiceFabricMesh/applications | ContainerStatus |
| Microsoft.ServiceFabricMesh/applications | RestartCount |
| Microsoft.Storage/storageAccounts | UsedCapacity |
| Microsoft.Storage/storageAccounts/blobServices | BlobCapacity |
| Microsoft.Storage/storageAccounts/blobServices | BlobCount |
| Microsoft.Storage/storageAccounts/blobServices | BlobProvisionedSize |
| Microsoft.Storage/storageAccounts/blobServices | IndexCapacity |
| Microsoft.Storage/storageAccounts/fileServices | FileCapacity |
| Microsoft.Storage/storageAccounts/fileServices | FileCount |
| Microsoft.Storage/storageAccounts/fileServices | FileShareCount |
| Microsoft.Storage/storageAccounts/fileServices | FileShareSnapshotCount |
| Microsoft.Storage/storageAccounts/fileServices | FileShareSnapshotSize |
| Microsoft.Storage/storageAccounts/fileServices | FileShareCapacityQuota |
| Microsoft.Storage/storageAccounts/fileServices | FileShareProvisionedIOPS |

## Create a Log search alert rule with dynamic threshold (Preview)

To configure dynamic thresholds, follow the procedure for creating an alert rule. Use these settings on the Condition tab:

- Configure your query, measurement, and dimensions the same way as with static threshold. 
- For Threshold, select Dynamic.
- Select Preview Chart to see historical query results alongside the calculated dynamic threshold, helping you visualize how the threshold adapts to normal patterns and where potential alerts would fire.
- After any change is made in the condition tab, select Refresh Chart to see the updated preview. 

:::image type="content" source="media/alerts-dynamic-thresholds/alerts-threshold-refresh-chart.png" lightbox="media/alerts-dynamic-thresholds/alerts-threshold-refresh-chart.png" alt-text="Screenshot of the UI that shows the location of the Refresh chart link."::: 

> [!NOTE]
> 1-minute frequency is not supported in Log search alert rules with dynamic threshold.

### Dynamic threshold preview chart

The following chart shows the value of a log alert rule query result, its dynamic threshold limits, threshold violations, and alerts that fired when the value was outside the allowed thresholds. In this scenario, the number of violations required to fire an alert is 2.

:::image type="content" source="media/alerts-dynamic-thresholds/alerts-threshold-dynamic-threshold-preview-chart.png" lightbox="media/alerts-dynamic-thresholds/alerts-threshold-dynamic-threshold-preview-chart.png" alt-text="Screenshot of a log alert rule query result, its dynamic threshold limits, threshold violations and alerts that fired when the value was outside the allowed thresholds."::: 
 
•	Blue line: The query result measured value over time.
•	Purple shaded area: The calculated Dynamic threshold range. Allowed value range for the query result. If the values stay within this range, no alert is triggered.
•	Red dots: Red dots represent violations - evaluations that resulted in the threshold being met. 
•	Pink bars: Represent a fired Log search alert. 

> [!NOTE]
> To ensure the preview chart performance, we enforce a limitation on the number of data points returned and, consequently, the allowed time range displayed, depending on alert rule frequency. A 5-minute frequency supports 6 hours. A 10–15-minute frequency supports 6 and 12 hours. A 30-minute frequency supports 6 and 12 hours and 1 day. Frequency of 1 hour or more supports 6 and 12 hours as well as 1 and 2 days.


## Related content

- [Manage your alert rules](alerts-manage-alert-rules.md)

If you have feedback about dynamic thresholds, [email us](mailto:azurealertsfeedback@microsoft.com).
