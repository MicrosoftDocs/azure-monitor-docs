---
title: Kubernetes monitoring in Azure Monitor
description: Describes Container Insights and Managed Prometheus in Azure Monitor, which work together to monitor your Kubernetes clusters.
ms.topic: article
ms.custom: references_regions
ms.date: 02/05/2025
ms.reviewer: viviandiec
---

# Kubernetes monitoring in Azure Monitor

Multiple features of [Azure Monitor](../fundamentals/overview.md) work together to provide complete monitoring of your [Azure Kubernetes (AKS)](/azure/aks/intro-kubernetes) or [Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/overview) clusters. Container insights helps you onboard and configure each of these services and to view and analyze the data they collect in a consolidated view. This article provides an overview of Container insights and the other Azure Monitor features that it works with to monitor your Kubernetes clusters. See [Enable monitoring for Kubernetes clusters](kubernetes-monitoring-enable.md) to get started onboarding your cluster.

| Feature | Description |
|:---|:---|
| Container Insights | Collect container logs. Analyze collected metrics and logs in the Azure portal.  |
| [Azure Monitor managed service for Prometheus](../essentials/prometheus-metrics-overview.md) | Collect and analyze metrics for cluster nodes, workloads, and containers. |
| [Azure Monitor dashboards with Grafana](../visualize/visualize-grafana-overview.md) | Visualize metrics and logs with Grafana dashboards at no additional cost. |
| [Diagnostic settings](../platform/diagnostic-settings-overview.md) | Collect control plane logs. |
| [Azure Monitor metrics](../data-collection/data-collection-metrics.md) | Collect cluster level metrics (Automatically enabled). |

## Multiple clusters experience
When you open Container insights from the Monitor menu in the Azure portal, you get a quick summary of all your monitored clusters. This view also allows you to onboard unmonitored clusters and add functionality to clusters that are already onboarded. 

:::image type="content" source="media/container-insights-overview/container-insights-multiple.png" lightbox="media/container-insights-overview/container-insights-multiple.png" alt-text="Screenshot of Container insights multiple cluster experience." border="false":::



## Single cluster experience
When you drill down into a specific cluster, or select the **Monitor** option from the cluster page, you get a detailed summary of the cluster's health and performance. This view provides details for the performance and availability of the cluster's nodes, workloads, and containers.

:::image type="content" source="media/container-insights-overview/container-insights-single.png" lightbox="media/container-insights-overview/container-insights-single.png" alt-text="Screenshot of Container insights single cluster experience." border="false":::
 
## Data collected
Container Insights sends data to a [Log Analytics workspace](../logs/data-platform-logs.md) where you can analyze it using different features of Azure Monitor. Managed Prometheus sends data to an [Azure Monitor workspace](../essentials/azure-monitor-workspace-overview.md), allowing Managed Grafana to access it. See [Monitoring data](/azure/aks/monitor-aks#monitoring-data) for further details on this data.

:::image type="content" source="media/container-insights-overview/aks-monitor-data.png" lightbox="media/container-insights-overview/aks-monitor-data.png" alt-text="Diagram of collection of monitoring data from Kubernetes cluster using Container Insights and related services." border="false":::

## Supported configurations
Container Insights supports the following clusters:

- [Azure Kubernetes Service (AKS)](/azure/aks/)
- Following [Azure Arc-enabled Kubernetes cluster distributions](/azure/azure-arc/kubernetes/validation-program):
  - AKS on Azure Local
  - AKS Edge Essentials
  - Canonical
  - Cluster API Provider on Azure
  - K8s on Azure Stack Edge
  - Red Hat OpenShift version 4.x
  - SUSE Rancher (Rancher Kubernetes engine)
  - SUSE Rancher K3s
  - VMware (TKG)

> [!NOTE]
> Container Insights supports ARM64 nodes on AKS. See [Cluster requirements](/azure/azure-arc/kubernetes/system-requirements#cluster-requirements) for the details of Azure Arc-enabled clusters that support ARM64 nodes.
>
> Container Insights support for Windows Server 2022 operating system is in public preview.

## Security

- Container Insights supports FIPS enabled Linux and Windows node pools starting with Agent version 3.1.17 (Linux)  & Win-3.1.17 (Windows).
- Starting with Agent version 3.1.17 (Linux) and Win-3.1.17 (Windows), Container Insights agents images (both Linux and Windows) are signed and  for Windows agent,  binaries inside the container are signed as well

## Agent

Container Insights and Managed Prometheus rely on a containerized [Azure Monitor agent](../agents/agents-overview.md) for Linux. This specialized agent collects performance and event data from all nodes in the cluster. The agent is deployed and registered with the specified workspaces during deployment. When you enable Container Insights on a cluster, a [Data collection rule (DCR)](../essentials/data-collection-rule-overview.md) is created. This DCR, named `MSCI-<cluster-region>-<cluster-name>`, contains the definition of data that the Azure Monitor agent should collect. 

Since March 1, 2023 Container Insights uses a Semver compliant agent version. The agent version is *mcr.microsoft.com/azuremonitor/containerinsights/ciprod:3.1.4* or later. When a new version of the agent is released, it's automatically upgraded on your managed Kubernetes clusters that are hosted on AKS. To track which versions are released, see [Agent release announcements](https://github.com/microsoft/Docker-Provider/blob/ci_prod/ReleaseNotes.md). 




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
