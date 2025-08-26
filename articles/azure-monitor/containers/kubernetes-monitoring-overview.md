---
title: Kubernetes monitoring in Azure Monitor
description: Describes Container Insights and Managed Prometheus in Azure Monitor, which work together to monitor your Kubernetes clusters.
ms.topic: article
ms.custom: references_regions
ms.date: 08/26/2025
ms.reviewer: viviandiec
---

# Kubernetes monitoring in Azure Monitor

Multiple features of [Azure Monitor](../fundamentals/overview.md) work together to provide complete monitoring of your [Azure Kubernetes (AKS)](/azure/aks/intro-kubernetes) or [Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/overview) clusters.  This article provides an overview of these features and how you can leverage them to ensure the health and performance of your Kubernetes environment.

> [!TIP]
> To quickly get started monitoring your cluster, see [Quickstart monitoring a Kubernetes cluster in Azure Monitor](kubernetes-monitoring-quickstart.md). This article provides more details about the different features that you enable to provide a complete monitoring solution.


The following diagram illustrates the value provided by the different Azure Monitor features, while the table below describes each in more detail. Container insights ties the different features together to provide a unified monitoring experience for your Kubernetes clusters.

:::image type="content" source="media/container-insights-overview/kubernetes-monitoring-services.png" lightbox="media/container-insights-overview/kubernetes-monitoring-services.png" alt-text="Diagram of the different services that work together to monitor Kubernetes clusters." border="false":::


| Feature | Description | Configuration<br>required |
|:---|:---|:---:|
| [Container Insights](#container-insights) | View and analyze collected data in the Azure portal. Enable and configure different monitoring features for all of your Kubernetes clusters. | No |
| [Platform metrics]() | Metrics automatically collected for the cluster at no cost. | No |
| [Azure Monitor managed service for Prometheus](../essentials/prometheus-metrics-overview.md) | Collect and analyze metrics for cluster nodes, workloads, and containers.  | Yes |
| Container log collection | Collect logs from containers and workloads. | Yes |
| Control plane log collection | Control plane logs are implemented as [resource logs](../platform/resource-logs.md) in Azure Monitor. Create a [diagnostic setting](../platform/diagnostic-settings.md) to collect these logs. | Yes |
| [Azure Monitor dashboards with Grafana (preview)](../visualize/visualize-grafana-overview.md) | Visualize metrics and logs with Grafana dashboards at no additional cost. | No |

> [!NOTE]
> Managed Grafana was previously recommended for visualization of Kubernetes data in Azure Monitor, but this is being replaced as the default visualization experience by [Dashboards with Grafana](../visualize/visualize-grafana-overview.md). This new experience requires no configuration and has no additional charge. Some configuration options in Container insights still include Managed Grafana, but you can disable this option if you want to use the new experience.


## Analysis
Container insights provides a variety of built-in views to analyze the data collected by the features. You can use interactive views for a single cluster or all the clusters in your environment. Or take advantage of a variety of available Grafana dashboards that combine different sets of Kubernetes telemetry. For proactive notification, Container insights will help you quickly enable a set of common alert rules based on Prometheus metrics.

:::image type="content" source="media/container-insights-overview/kubernetes-monitoring-services.png" lightbox="media/container-insights-overview/kubernetes-monitoring-services.png" alt-text="Diagram of the different services that work together to monitor Kubernetes clusters." border="false":::


## Onboarding
Some of the monitoring features require configuration while others are enabled automatically. Container insights will guide you through enabling different features, or you can enable them at scale and perform advanced configuration using a variety of other methods. See [Enable monitoring for Kubernetes clusters in Azure Monitor](kubernetes-monitoring-enable.md) for onboarding and configuration options for those features that require it.


:::image type="content" source="media/container-insights-overview/kubernetes-monitoring-services.png" lightbox="media/container-insights-overview/kubernetes-monitoring-services.png" alt-text="Diagram of the different services that work together to monitor Kubernetes clusters." border="false":::



## Integration with other Azure Monitor features
Since Kubernetes monitoring features leverage the same data platform as other Azure Monitor features, you can use a variety of tools to perform advanced analysis and customization of your monitor data. Logs are collected in a [Log Analytics workspace](../logs/data-platform-logs.md) where you can analyze it using different features of Azure Monitor including [Log Analytics](../logs/log-analytics-overview.md) and [log alerts](../alerts/tutorial-log-alert.md). Managed Prometheus sends data to an [Azure Monitor workspace](../essentials/azure-monitor-workspace-overview.md) where it can be analyzed with [PromQL queries](../metrics/metrics-explorer.md#azure-monitor-metrics-explorer-with-promql) or [Prometheus alerts](../alerts/prometheus-alerts.md). [Dashboards with Grafana](../visualize/visualize-grafana-overview.md) access all of this data together to visualize it using a variety of prebuilt or custom dashboards.

:::image type="content" source="media/container-insights-overview/aks-monitor-data.png" lightbox="media/container-insights-overview/aks-monitor-data.png" alt-text="Diagram of collection of monitoring data from Kubernetes cluster using Container Insights and related services." border="false":::




## Next steps

- See [Enable monitoring for Kubernetes clusters](kubernetes-monitoring-enable.md) to enable Managed Prometheus and log collection on your cluster.

<!-- LINKS - external -->
[aks-release-notes]: https://github.com/Azure/AKS/releases

