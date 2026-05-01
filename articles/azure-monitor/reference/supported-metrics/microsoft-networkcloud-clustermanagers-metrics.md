---
title: Supported metrics - Microsoft.NetworkCloud/clusterManagers
description: Reference for Microsoft.NetworkCloud/clusterManagers metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.NetworkCloud/clusterManagers, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.NetworkCloud/clusterManagers

The following table lists the metrics available for the Microsoft.NetworkCloud/clusterManagers resource type.

**Table headings**

**Metric** - The metric display name as it appears in the Azure portal.
**Name in Rest API** - Metric name as referred to in the [REST API](/azure/azure-monitor/essentials/rest-api-walkthrough).
**Unit** - Unit of measure.
**Aggregation** - The default [aggregation](/azure/azure-monitor/essentials/metrics-aggregation-explained) type. Valid values: Average, Minimum, Maximum, Total, Count.
**Dimensions** - [Dimensions](/azure/azure-monitor/essentials/metrics-aggregation-explained#dimensions-splitting-and-filtering) available for the metric.
**Time Grains** - [Intervals at which the metric is sampled](/azure/azure-monitor/essentials/metrics-aggregation-explained#granularity). For example, `PT1M` indicates that the metric is sampled every minute, `PT30M` every 30 minutes, `PT1H` every hour, and so on.
**DS Export**- Whether the metric is exportable to Azure Monitor Logs via Diagnostic Settings.

For information on exporting metrics, see - [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics) and [Create diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/create-diagnostic-settings?tabs=portal).

For information on metric retention, see [Azure Monitor Metrics overview](/azure/azure-monitor/essentials/data-platform-metrics#retention-of-metrics).


For a list of supported logs, see [Supported log categories - Microsoft.NetworkCloud/clusterManagers](../supported-logs/microsoft-networkcloud-clustermanagers-logs.md)


### Category: Nexus Cluster
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Cluster Connection Status**<br><br>Tracks changes in the connection status of the Cluster(s) managed by the Cluster Manager. The reason filter describes the connection status. In the absence of data, this metric will default to 0. |`NexusClusterConnectionStatus` |Count |Average |`clusterName`, `reason`|PT1M |No|
|**Cluster Deploy Requests (Deprecated)**<br><br>Number of cluster deploy requests. |`NexusClusterDeployClusterRequests` |Count |Average |`clusterVersion`|PT1M |No|
|**Cluster Deploy Requests**<br><br>Nexus cluster deployment requests. This metric is emitted only when there is a cluster deployment request, so an Aggregation type of 'Count' should be used. Note, filter on the property 'Result' to see if the deployment was successful or not. If using an aggregation type of 'Avg', please note 1 denotes unsuccessful 0 denotes successful. In the absence of data, this metric will default to 0. |`NexusClusterDeploymentClusterRequests` |Count |Average |`clusterName`, `clusterVersion`, `result`|PT1M |No|
|**Cluster Machine Upgrade**<br><br>Nexus machine upgrade request, successful will have a value of 0 while unsuccessful while have a value of 1. |`NexusClusterMachineUpgrade` |Count |Average |`clusterName`, `clusterVersion`, `result`, `upgradedFromVersion`, `upgradedToVersion`, `upgradeStrategy`|PT1M |No|
|**Cluster Management Bundle Upgrade**<br><br>Nexus Cluster management bundle upgrade, successful will have a value of 0 while unsuccessful while have a value of 1. |`NexusClusterManagementBundleUpgrade` |Count |Average |`clusterName`, `clusterVersion`, `result`, `upgradedFromVersion`, `upgradedToVersion`|PT1M |No|
|**Cluster Runtime Bundle Upgrade**<br><br>Nexus Cluster runtime bundle upgrade, successful will have a value of 0 while unsuccessful while have a value of 1. |`NexusClusterRuntimeBundleUpgrade` |Count |Average |`clusterName`, `clusterVersion`, `result`, `upgradedFromVersion`, `upgradedToVersion`|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
