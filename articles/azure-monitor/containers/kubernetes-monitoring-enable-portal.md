---
title: Enable monitoring for Kubernetes clusters using Azure portal
description: Learn how to enable container logging and Managed Prometheus on an Azure Kubernetes Service (AKS) cluster using Azure portal.
ms.topic: how-to
ms.custom: devx-track-azurecli, linux-related-content
ms.reviewer: aul
ms.date: 08/25/2025
---

# Enable Kubernetes monitoring using the Azure portal

As described in [Kubernetes monitoring in Azure Monitor](./container-insights-overview.md), multiple features of Azure Monitor work together to provide complete monitoring of your Azure Kubernetes Service (AKS) or Azure Arc-enabled Kubernetes clusters. This article describes how to enable the following features using the Azure portal:

- Prometheus metrics
- Container logging
- Control plane logs

## Portal configuration options

There are multiple places in the Azure portal where you can launch the configuration for Prometheus metrics and container logging for your cluster. Each of these options will offer the same configuration options.

### Create a new AKS cluster
When you create a new AKS cluster in the portal, you can enable Prometheus and container logging from the **Monitoring** tab.

:::image type="content" source="media/kubernetes-monitoring-enable-portal/enable-new-cluster.png" lightbox="media/kubernetes-monitoring-enable-portal/enable-new-cluster.png" alt-text="Screenshot of Monitoring tab for new cluster.":::

### From an existing cluster
Select **Monitor** from the cluster in the Azure portal to view various performance measurements for the container. You'll be prompted to enable monitoring for any elements that require it. Alternatively, select **Monitor Settings** from the top of the screen to open the configuration view. This includes Prometheus for metrics, container logging for logs, and recommended alerts. The Nodes, Workloads, and Containers tabs will be completely disabled until Prometheus monitoring is enabled.

:::image type="content" source="media/kubernetes-monitoring-enable-portal/enable-existing-cluster.png" lightbox="media/kubernetes-monitoring-enable-portal/enable-existing-cluster.png" alt-text="Screenshot of enabling monitoring for an existing cluster.":::

To modify the configuration for an cluster that's already been onboarded, select **Monitor Settings**.

:::image type="content" source="media/kubernetes-monitoring-enable-portal/monitor-settings.png" lightbox="media/kubernetes-monitoring-enable-portal/monitor-settings.png" alt-text="Screenshot of monitor settings option for an existing cluster.":::

### From Container insights
Open Container insights from the **Containers** option in the **Monitor** menu. Existing clusters with no monitoring enabled will be listed in the **Unmonitored clusters** view. Existing clusters with monitoring enabled will be listed in the **Monitored clusters** view, but they may not have all features enabled.

You can select a cluster to enable monitoring or select **View All Clusters** to see all clusters, including those that are already monitored. For unmonitored clusters, click **Enable** next to a cluster to open configuration options. For monitored clusters, click the status in the **Capabilities enabled** column to modify the configuration options.

:::image type="content" source="media/kubernetes-monitoring-enable-portal/enable-unmonitored-clusters.png" lightbox="media/kubernetes-monitoring-enable-portal/enable-unmonitored-clusters.png" alt-text="Screenshot of unmonitored clusters view in Container insights.":::


## Configuration options
The configuration options are the same regardless of the option used to enable monitoring. Select the checkbox for each feature that you want to enable. When you enable a feature, the workspace where the data is collected will be displayed. You can change the configuration details for each selections by selecting **Advanced settings**. 

:::image type="content" source="media/kubernetes-monitoring-enable-portal/configuration-options.png" lightbox="media/kubernetes-monitoring-enable-portal/configuration-options.png" alt-text="Screenshot of configuration settings for a cluster.":::

## Managed Prometheus options
The only option available for Managed Prometheus is the [Azure Monitor workspace](../metrics/azure-monitor-workspace-overview.md) where the metrics are stored. You can select an existing workspace or create a new one. See [Workspaces](./kubernetes-monitoring-enable.md#workspaces) for more details about the Azure Monitor workspace.

For advanced configuration of Prometheus metrics, see []().

## Container log options
For container logs, you must first select the [Log Analytics workspace](../logs/log-analytics-workspace-overview.md) where the metrics are stored. You can select an existing workspace or create a new one. See [Workspaces](./kubernetes-monitoring-enable.md#workspaces) for more details about the Log Analytics workspace.

You also must select a logging profile, which defines which logs will be collected and at what frequency. The available profiles are listed in the following table. 

:::image type="content" source="media/container-insights-cost-config/cost-settings-onboarding.png" alt-text="Screenshot that shows the onboarding options." lightbox="media/container-insights-cost-config/cost-settings-onboarding.png" :::

| Cost preset | Collection frequency | Namespace filters | Syslog collection | Collected data |
| --- | --- | --- | --- | --- |
| Logs and Events (Default) | 1 m | None | Not enabled | ContainerLogV2<br>KubeEvents<br>KubePodInventory |
| Syslog | 1 m | None | Enabled by default | All standard container insights tables |
| Standard | 1 m | None | Not enabled | All standard container insights tables |
| Cost-optimized | 5 m | Excludes kube-system, gatekeeper-system, azure-arc | Not enabled | All standard container insights tables |

If you want to customize the settings, click **Edit collection settings**. Each of these settings is described in the following table.

:::image type="content" source="media/container-insights-cost-config/advanced-collection-settings.png" alt-text="Screenshot that shows the collection settings options." lightbox="media/container-insights-cost-config/advanced-collection-settings.png" :::

| Name | Description |
|:---|:---|
| Collection frequency | Determines how often the agent collects data.  Valid values are 1m - 30m in 1m intervals The default value is 1m. This option can't be configured through the ConfigMap.|
| Namespace filtering | *Off*: Collects data on all namespaces.<br>*Include*: Collects only data from the values in the *namespaces* field.<br>*Exclude*: Collects data from all namespaces except for the values in the *namespaces* field.<br><br>Array of comma separated Kubernetes namespaces to collect inventory and perf data based on the _namespaceFilteringMode_. For example, *namespaces = ["kube-system", "default"]* with an _Include_ setting collects only these two namespaces. With an _Exclude_ setting, the agent collects data from all other namespaces except for _kube-system_ and _default_.  |
| Collected Data | Defines which Container insights tables to collect. See below for a description of each grouping.  |
| Enable ContainerLogV2 | Boolean flag to enable [ContainerLogV2 schema](./container-insights-logs-schema.md). If set to true, the stdout/stderr Logs are ingested to [ContainerLogV2](container-insights-logs-schema.md) table. If not, the container logs are ingested to **ContainerLog** table, unless otherwise specified in the ConfigMap. When specifying the individual streams, you must include the corresponding table for ContainerLog or ContainerLogV2. |
| Enable Syslog collection | Enables Syslog collection from the cluster. |


The **Collected data** option allows you to select the tables that are populated for the cluster. The tables are grouped by the most common scenarios. To specify individual tables, you must modify the DCR using another method.

:::image type="content" source="media/container-insights-cost-config/collected-data-options.png" alt-text="Screenshot that shows the collected data options." lightbox="media/container-insights-cost-config/collected-data-options.png" :::

| Grouping | Tables | Notes |
| --- | --- | --- |
| All (Default) | All standard container insights tables | Required for enabling the default Container insights visualizations |
| Performance | Perf, InsightsMetrics | |
| Logs and events | ContainerLog or ContainerLogV2, KubeEvents, KubePodInventory | Recommended if you have enabled managed Prometheus metrics |
| Workloads, Deployments, and HPAs | InsightsMetrics, KubePodInventory, KubeEvents, ContainerInventory, ContainerNodeInventory, KubeNodeInventory, KubeServices | |
| Persistent Volumes | InsightsMetrics, KubePVInventory | |

## Enable control plane logs
Control plane logs must be enabled separately from Prometheus metrics and container logging. You can send these logs to the same Log Analytics workspace as your container logs, but they aren't accessible from the **Monitor** menu for the cluster. Instead, you can access them using queries in [Log Analytics](../logs/log-analytics-overview.md) and use them for [log alerts](../alerts/alerts-log-query.md).

Control plan logs are implemented as [resource logs](../platform/resource-logs.md) in Azure Monitor. To collect these logs, create a [diagnostic setting](../platform/diagnostic-settings-overview.md) for the cluster. 

Select **Diagnostic settings** from the **Monitoring** section of the menu for the cluster. Then select **+ Add diagnostic setting**.

:::image type="content" source="media/container-insights-cost-config/collected-data-options.png" alt-text="Screenshot that shows the collected data options." lightbox="media/container-insights-cost-config/collected-data-options.png" :::

Select **Send to Log Analytics workspace** and select the same workspace where you send your container logs. Then select the different **Categories** that you want to collect. Give the **Diagnostic setting name** a descriptive name such as *Collect Control Plane Logs*.

:::image type="content" source="media/container-insights-cost-config/collected-data-options.png" alt-text="Screenshot that shows the collected data options." lightbox="media/container-insights-cost-config/collected-data-options.png" :::

## Verify deployment
Within a few minutes after enabling monitoring, you should be able to use the following methods to verify that the monitoring features are enabled.

- The cluster should move from the **Unmonitored clusters** view to the **Monitored clusters** view in Container insights.
- The **Monitor** view for the cluster should start to populate with data and no longer provide an option to enable monitoring. This includes the Nodes, Workloads, and Containers tabs.
- For further validation, see [Verify deployment](./kubernetes-monitoring-enable.md#verify-deployment).


## Next steps

* If you experience issues while you attempt to onboard the solution, review the [Troubleshooting guide](container-insights-troubleshoot.md).
* With monitoring enabled to collect health and resource utilization of your AKS cluster and workloads running on them, learn [how to use](container-insights-analyze.md) Container insights.
