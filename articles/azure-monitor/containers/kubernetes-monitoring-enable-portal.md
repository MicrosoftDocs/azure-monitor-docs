---
title: Enable monitoring for Kubernetes clusters
description: Learn how to enable Container insights and Managed Prometheus on an Azure Kubernetes Service (AKS) cluster.
ms.topic: how-to
ms.custom: devx-track-azurecli, linux-related-content
ms.reviewer: aul
ms.date: 03/11/2024
---

# Enable Kubernetes monitoring using the Azure portal

As described in [Kubernetes monitoring in Azure Monitor](./container-insights-overview.md), multiple features of Azure Monitor work together to provide complete monitoring of your Azure Kubernetes Service (AKS) or Azure Arc-enabled Kubernetes clusters. This article describes how to enable these features using the Azure portal.

> [!IMPORTANT]
> Kubernetes clusters generate a lot of log data, which can result in significant costs if you aren't selective about the logs that you collect. Before you enable monitoring for your cluster, see the following articles to ensure that your environment is optimized for cost and that you limit your log collection to only the data that you require:
> 
>- [Configure data collection and cost optimization in Container insights using data collection rule](./container-insights-data-collection-dcr.md)<br>Details on customizing log collection once you've enabled monitoring, including using preset cost optimization configurations.
>- [Best practices for monitoring Kubernetes with Azure Monitor](../best-practices-containers.md)<br>Best practices for monitoring Kubernetes clusters organized by the five pillars of the [Azure Well-Architected Framework](/azure/architecture/framework/), including cost optimization.
>- [Cost optimization in Azure Monitor](../best-practices-cost.md)<br>Best practices for configuring all features of Azure Monitor to optimize your costs and limit the amount of data that you collect.

## Enabling methods

There are multiple methods to onboard your cluster to Azure Monitor and to modify different features for enabled clusters.

### Creating a new AKS cluster
When you create a new AKS cluster in the portal, you can enable Container insights and Prometheus from the **Monitoring** tab.

:::image type="content" source="media/kubernetes-monitoring-enable-portal/enable-new-cluster.png" lightbox="media/kubernetes-monitoring-enable-portal/enable-new-cluster.png" alt-text="Screenshot of Monitoring tab for new cluster.":::

### From Container insights
Open Container insights from the **Containers** option in the **Monitor** menu. Click **Enable** next to a cluster to open configuration options.

:::image type="content" source="media/kubernetes-monitoring-enable-portal/enable-unmonitored-clusters.png" lightbox="media/kubernetes-monitoring-enable-portal/enable-unmonitored-clusters.png" alt-text="Screenshot of unmonitored clusters view in Container insights.":::

### From the cluster
Select **Monitor** from the cluster in the Azure portal to view various performance measurements for the container. You'll be prompted to enable monitoring for any elements that require it. This includes Prometheus for metrics, container logging for logs, and recommended alerts. The Nodes, Workloads, and Containers tabs will be completely disabled until Prometheus monitoring is enabled.

:::image type="content" source="media/kubernetes-monitoring-enable-portal/enable-existing-cluster.png" lightbox="media/kubernetes-monitoring-enable-portal/enable-existing-cluster.png" alt-text="Screenshot of enabling monitoring for an existing cluster.":::

To modify the configuration for an cluster that's already been onboarded, select **Monitor Settings**.

:::image type="content" source="media/kubernetes-monitoring-enable-portal/monitor-settings.png" lightbox="media/kubernetes-monitoring-enable-portal/monitor-settings.png" alt-text="Screenshot of monitor settings option for an existing cluster.":::

## Configuration options
Select the checkbox for each feature that you want to enable. When you enable a feature, the workspace where the data is collected will be displayed. You can change these selections by select **Advanced settings**. 

## Managed Prometheus options
The only option available for Managed Prometheus is the [Azure Monitor workspace](../metrics/azure-monitor-workspace-overview.md) where the metrics are stored. You can select an existing workspace or create a new one. See [Design criteria](../metrics/azure-monitor-workspace-overview.md#design-criteria) for decision criteria on creating multiple workspaces.

## Managed Grafana options
When you enable Managed Grafana, you can select an existing [Managed Grafana workspace](/azure/managed-grafana/quickstart-managed-grafana-portal) or create a new one.

> [!IMPORTANT]
> [Azure Monitor Dashboards with Grafana](../visualize/visualize-grafana-overview.md) is now in public preview and can use the same dashboards using Azure Monitor data sources as Managed Grafana. Unlike Managed Grafana, this feature doesn't require a separate workspace and can be used at no additional cost. If you want to use Azure Monitor Dashboards with Grafana, simply unselect the **Enable Managed Grafana** option.

## Container log options
For container logs, you must first select the [Log Analytics workspace](../logs/log-analytics-workspace-overview.md) where the metrics are stored. You can select an existing workspace or create a new one. See [Design a Log Analytics workspace architecture](../logs/workspace-design.md) for decision criteria on creating multiple workspaces.

You also must select a logging profile, which defines which logs will be collected and at what frequency. The available profiles are listed in the following table. 

    :::image type="content" source="media/container-insights-cost-config/cost-settings-onboarding.png" alt-text="Screenshot that shows the onboarding options." lightbox="media/container-insights-cost-config/cost-settings-onboarding.png" :::

    | Cost preset | Collection frequency | Namespace filters | Syslog collection | Collected data |
    | --- | --- | --- | --- | --- |
    | Logs and Events (Default) | 1 m | None | Not enabled | ContainerLogV2<br>KubeEvents<br>KubePodInventory |
    | Syslog | 1 m | None | Enabled by default | All standard container insights tables |
    | Standard | 1 m | None | Not enabled | All standard container insights tables |
    | Cost-optimized | 5 m | Excludes kube-system, gatekeeper-system, azure-arc | Not enabled | All standard container insights tables |

If you want to customize the settings, click **Edit collection settings**.

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
    



## Next steps

* If you experience issues while you attempt to onboard the solution, review the [Troubleshooting guide](container-insights-troubleshoot.md).
* With monitoring enabled to collect health and resource utilization of your AKS cluster and workloads running on them, learn [how to use](container-insights-analyze.md) Container insights.
