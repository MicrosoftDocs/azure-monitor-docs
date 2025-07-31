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

**Creating a new AKS cluster.**
When you create a new AKS cluster in the portal, you can enable Container insights and Prometheus from the **Monitoring** tab.

:::image type="content" source="media/container-insights-enable-portal/enable-new-cluster.png" lightbox="media/container-insights-enable-portal/enable-new-cluster.png" alt-text="Screenshot of Monitoring tab for new cluster." border="false":::

**From Container insights**
Open Container insights from the **Containers** option in the **Monitor** menu. Click **Enable** next to a cluster to open configuration options.

:::image type="content" source="media/container-insights-enable-portal/enable-unmonitored-clusters.png" lightbox="media/container-insights-enable-portal/enable-unmonitored-clusters.png" alt-text="Screenshot of unmonitored clusters view in Container insights." border="false":::

**From the cluster**
Select **Monitor** from the cluster in the Azure portal to view various performance measurements for the container. You'll be prompted to enable monitoring for any elements that require it. This includes Prometheus for metrics, container logging for logs, and recommended alerts. The Nodes, Workloads, and Containers tabs will be completely disabled until Prometheus monitoring is enabled.

:::image type="content" source="media/container-insights-enable-portal/enable-existing-cluster.png" lightbox="media/container-insights-enable-portal/enable-existing-cluster.png" alt-text="Screenshot of enabling monitoring for an existing cluster." border="false":::

To modify the configuration for an cluster that's already been onboarded, select **Monitor Settings**.

:::image type="content" source="media/container-insights-enable-portal/monitor-settings.png" lightbox="media/container-insights-enable-portal/monitor-settings.png" alt-text="Screenshot of monitor settings option for an existing cluster." border="false":::

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

You also must select 


## Next steps

* If you experience issues while you attempt to onboard the solution, review the [Troubleshooting guide](container-insights-troubleshoot.md).
* With monitoring enabled to collect health and resource utilization of your AKS cluster and workloads running on them, learn [how to use](container-insights-analyze.md) Container insights.
