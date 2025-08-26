---
title: Kubernetes monitoring in Azure Monitor
description: Describes Container Insights and Managed Prometheus in Azure Monitor, which work together to monitor your Kubernetes clusters.
ms.topic: article
ms.custom: references_regions
ms.date: 02/05/2025
ms.reviewer: viviandiec
---

# Kubernetes monitoring in Azure Monitor

Multiple features of [Azure Monitor](../fundamentals/overview.md) work together to provide complete monitoring of your [Azure Kubernetes (AKS)](/azure/aks/intro-kubernetes) or [Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/overview) clusters.  This article provides an overview of these features and how you can leverage them to ensure the health and performance of your Kubernetes environment.

> [!TIP]
> To quickly get started monitoring your cluster, see [Quickstart monitoring a Kubernetes cluster in Azure Monitor](kubernetes-monitoring-quickstart.md). This article provides more details about the different features that you enable to provide a complete monitoring solution.


The following diagram illustrates the value provided by the different Azure Monitor features, while the table below describes each in more detail. Container insights ties the different features together to provide a unified monitoring experience for your Kubernetes clusters.

Some of these features require configuration while others are enabled automatically. You can quickly enable these features using the Azure portal or enable them at scale and perform advanced configuration using a variety of other methods. See [Enable monitoring for Kubernetes clusters in Azure Monitor](kubernetes-monitoring-enable.md) for onboarding and configuration options for those features that require it.

:::image type="content" source="media/container-insights-overview/kubernetes-monitoring-services.png" lightbox="media/container-insights-overview/kubernetes-monitoring-services.png" alt-text="Diagram of the different services that work together to monitor Kubernetes clusters." border="false":::


| Feature | Description | Configuration<br>required |
|:---|:---|:---:|
| [Container Insights](#container-insights) | Enable and configure different monitoring features for all of your Kubernetes clusters. | No |
| [Platform metrics]() | Metrics automatically collected for the cluster at no cost. | No |
| [Azure Monitor managed service for Prometheus](../essentials/prometheus-metrics-overview.md) | Collect and analyze metrics for cluster nodes, workloads, and containers.  | Yes |
| Container log collection | Collect logs from containers and workloads. | Yes |
| Control plane log collection | Control plane logs are implemented as [resource logs](../platform/resource-logs.md) in Azure Monitor. Create a [diagnostic setting](../platform/diagnostic-settings.md) to collect these logs. | Yes |
| [Azure Monitor dashboards with Grafana](../visualize/visualize-grafana-overview.md) | Visualize metrics and logs with Grafana dashboards at no additional cost. | No |


## Onboarding


## Other analysis and customization options
Since Kubernetes monitoring features leverage the same data platform as other Azure Monitor features, you can use a variety of tools to perform advanced analysis and customization of your monitor data. Logs are collected in a [Log Analytics workspace](../logs/data-platform-logs.md) where you can analyze it using different features of Azure Monitor including [Log Analytics](../logs/log-analytics-overview.md) and [log alerts](../alerts/tutorial-log-alert.md). Managed Prometheus sends data to an [Azure Monitor workspace](../essentials/azure-monitor-workspace-overview.md) where it can be analyzed with [PromQL queries](../metrics/metrics-explorer.md#azure-monitor-metrics-explorer-with-promql) or [Prometheus alerts](../alerts/prometheus-alerts.md). [Dashboards with Grafana](../visualize/visualize-grafana-overview.md) access all of this data together to visualize it using a variety of prebuilt or custom dashboards.

:::image type="content" source="media/container-insights-overview/aks-monitor-data.png" lightbox="media/container-insights-overview/aks-monitor-data.png" alt-text="Diagram of collection of monitoring data from Kubernetes cluster using Container Insights and related services." border="false":::




> [!NOTE]
> Container Insights supports ARM64 nodes on AKS. See [Cluster requirements](/azure/azure-arc/kubernetes/system-requirements#cluster-requirements) for the details of Azure Arc-enabled clusters that support ARM64 nodes.
>
> Container Insights support for Windows Server 2022 operating system is in public preview.

## Security

- Container Insights supports FIPS enabled Linux and Windows node pools starting with Agent version 3.1.17 (Linux)  & Win-3.1.17 (Windows).
- Starting with Agent version 3.1.17 (Linux) and Win-3.1.17 (Windows), Container Insights agents images (both Linux and Windows) are signed and  for Windows agent,  binaries inside the container are signed as well




## Frequently asked questions

This section provides answers to common questions.

**Is there support for collecting Kubernetes audit logs for ARO clusters?**
No. Container Insights don't support collection of Kubernetes audit logs.

**Does Container Insights support pod sandboxing?**
Yes, Container Insights supports pod sandboxing through support for Kata Containers. See [Pod Sandboxing (preview) with Azure Kubernetes Service (AKS)](/azure/aks/use-pod-sandboxing).


## Next steps

- See [Enable monitoring for Kubernetes clusters](kubernetes-monitoring-enable.md) to enable Managed Prometheus and Container Insights on your cluster.

<!-- LINKS - external -->
[aks-release-notes]: https://github.com/Azure/AKS/releases




## Container insights
Access Container insights from the **Monitor** menu in the Azure portal or by selecting **View All Clusters** from the top of any cluster monitor view. This feature helps you onboard and configure the other features to collect data for your Kubernetes cluster. It provides a quick summary of all your monitored clusters and allows you to onboard unmonitored clusters and add functionality to clusters that are already onboarded. 

:::image type="content" source="media/container-insights-overview/container-insights-multiple.png" lightbox="media/container-insights-overview/container-insights-multiple.png" alt-text="Screenshot of Container insights multiple cluster experience.":::
