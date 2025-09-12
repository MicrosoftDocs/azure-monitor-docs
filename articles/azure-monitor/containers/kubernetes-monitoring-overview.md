---
title: Kubernetes monitoring in Azure Monitor
description: Describes Container Insights and Managed Prometheus in Azure Monitor, which work together to monitor your Kubernetes clusters.
ms.topic: article
ms.custom: references_regions
ms.date: 08/26/2025
ms.reviewer: viviandiec
---

# Kubernetes monitoring in Azure Monitor

This article describes how to monitor the health and performance of your Kubernetes clusters and the workloads running on them using Azure Monitor and cloud native services. This includes clusters running in Azure Kubernetes Service (AKS) or other clouds such as [AWS](https://aws.amazon.com/kubernetes/) and [GCP](https://cloud.google.com/kubernetes-engine). Different sets of guidance are provided for the different roles that typically manage unique components that make up a Kubernetes environment. 

> [!NOTE]
> This article describes complete guidance on monitoring the different layers of your Kubernetes environment based on Azure Kubernetes Service (AKS) or Kubernetes clusters in other clouds. If you're just getting started with AKS or Azure Monitor, see [Quickstart monitoring a Kubernetes cluster in Azure Monitor](kubernetes-monitoring-quickstart.md) for basic information for getting started monitoring an AKS cluster.

## Azure services for Kubernetes monitoring
Azure provides a complete set of services based on [Azure Monitor](../fundamentals/overview.md) for monitoring the health and performance of different layers of your Kubernetes infrastructure and the applications that depend on it. These services work in conjunction with each other to provide a complete monitoring solution and are recommended both for [AKS](/azure/aks/intro-kubernetes) and your Kubernetes clusters running in other clouds. 

Following is an illustration of a common model of a typical Kubernetes environment, starting from the infrastructure layer up through applications. Each layer has distinct monitoring requirements that are addressed by different services.

:::image type="content" source="media/kubernetes-monitoring-overview/layers.png" alt-text="Diagram of layers of Kubernetes environment with related administrative roles." lightbox="media/kubernetes-monitoring-overview/layers.png"  border="false":::

### Application level
Application workloads running on your Kubernetes cluster are monitored with the following services.

| Service | Description |
|:---|:---|
| [Application insights](../app/app-insights-overview.md) |  Feature of Azure Monitor that provides application performance monitoring (APM) to monitor applications running on your Kubernetes cluster from development, through test, and into production. Quickly identify and mitigate latency and reliability issues using distributed traces. Supports [OpenTelemetry](../app/opentelemetry-overview.md#opentelemetry) for vendor-neutral instrumentation. |

### Container levels
The Container levels include Kubernetes objects such as deployments, containers, and replicasets, cluster control plane components including API servers, cloud controller, and kubelet, and virtual machine scale sets abstracted as nodes and node pools. These layers are monitored with the following services.

| Service | Description |
|:---|:---|
| [Platform metrics]() | Metrics automatically collected for the cluster at no cost. | 
| [Azure Monitor managed service for Prometheus](../essentials/prometheus-metrics-overview.md) | [Prometheus](https://prometheus.io) is a cloud-native metrics solution from the Cloud Native Compute Foundation and the most common tool used for collecting and analyzing metric data from Kubernetes clusters. Azure Monitor managed service for Prometheus is a fully managed solution that's compatible with the Prometheus query language (PromQL) and Prometheus alerts and integrates with Azure Managed Grafana for visualization. This service supports your investment in open source tools without the complexity of managing your own Prometheus environment. |
| [Container log collection](./kubernetes-monitoring-overview.md) | Azure service for AKS and Azure Arc-enabled Kubernetes clusters that use a containerized version of the [Azure Monitor agent](../agents/agents-overview.md) to collect stdout/stderr logs, performance metrics, and Kubernetes events from each node in your cluster. You can view the data in the Azure portal or query it using [Log Analytics](../logs/log-analytics-overview.md).   |
| Control plane log collection | Control plane logs are implemented as [resource logs](../platform/resource-logs.md) in Azure Monitor. Create a [diagnostic setting](../platform/diagnostic-settings.md) to collect these logs. | Yes |
| [Azure Arc-enabled Kubernetes](container-insights-enable-arc-enabled-clusters.md) | Allows you to attach to Kubernetes clusters running in other clouds so that you can manage and configure them in Azure. With the Arc agent installed, you can monitor AKS and hybrid clusters together using the same methods and tools, including Container insights and Prometheus. |

### Network level
Virtual network components supporting traffic to and from the Kubernetes cluster are monitored with the following services.

| Service | Description |
|:---|:---|
| [Network Watcher](/azure/network-watcher/network-watcher-monitoring-overview) | Suite of tools in Azure to monitor the virtual networks used by your Kubernetes clusters and diagnose detected issues. |
| [Traffic analytics](/azure/network-watcher/traffic-analytics) | Feature of Network Watcher that analyzes flow logs to provide insights into traffic flow. | 
| [Network insights](/azure/network-watcher/network-insights-overview) | Feature of Azure Monitor that includes a visual representation of the performance and health of different network components and provides access to the network monitoring tools that are part of Network Watcher. |


## Analysis
Azure Monitor provides multiple tools to analyze the data collected by the features. You can use interactive views for a single cluster or all the clusters in your environment. Or take advantage of a variety of available Grafana dashboards that combine different sets of Kubernetes telemetry. For proactive notification, enable a set of common alert rules based on Prometheus metrics.

| Service | Description |
|:---|:---|
| [Unified monitoring dashboard](./container-insights-analyze.md) | The unified monitoring dashboard in the Azure portal consolidates data gathered by the different services for interactive analysis in a single screen. Get a high level status of your different clusters and then drill down into the details of individual clusters and their components.  |
| [Azure Managed Grafana](/azure/managed-grafana/overview) | Fully managed implementation of [Grafana](https://grafana.com/), which is an open-source data visualization platform commonly used to present Prometheus and other data. Multiple predefined Grafana dashboards are available for monitoring Kubernetes and full-stack troubleshooting.|
| [Azure Monitor dashboards with Grafana (preview)](../visualize/visualize-grafana-overview.md) | Visualize metrics and logs with Grafana dashboards at no additional cost. | No |

> [!NOTE]
> [Azure Monitor dashboards with Grafana](../visualize/visualize-grafana-overview.md) is currently in public preview. This version of Grafana has no cost and requires no configuration. You can use it instead of Managed Grafana if you don't require dashboards across multiple data sources.

:::image type="content" source="media/kubernetes-monitoring-overview/containers-insights-experience.png" lightbox="media/kubernetes-monitoring-overview/containers-insights-experience.png" alt-text="Screenshots of Container insights single and multiple cluster views." border="false":::

## Integration with cloud native tools

You may have an existing investment in cloud native technologies endorsed by the [Cloud Native Computing Foundation](https://www.cncf.io/), in which case you may choose to integrate Azure tools into your existing environment. Your choice of which Azure tools to deploy and their configuration will depend on the requirements of your particular environment. 

For example, you may use the managed offerings in Azure for Prometheus and Grafana, or you may choose to use your existing installation of these tools with your Kubernetes clusters in Azure. Your organization may also use alternative tools to collect and analyze Kubernetes logs, such as Splunk or Datadog.





## Next steps

- See [Enable monitoring for Kubernetes clusters](kubernetes-monitoring-enable.md) to enable Managed Prometheus and log collection on your cluster.

<!-- LINKS - external -->
[aks-release-notes]: https://github.com/Azure/AKS/releases

