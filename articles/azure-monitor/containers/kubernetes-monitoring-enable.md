---
title: Enable monitoring for Kubernetes clusters
description: Learn how to enable Container insights and Managed Prometheus on an Azure Kubernetes Service (AKS) cluster.
ms.topic: how-to
ms.custom: devx-track-azurecli, linux-related-content
ms.reviewer: aul
ms.date: 08/25/2025
---

# Enable Azure Monitor features for Kubernetes clusters

As described in [Kubernetes monitoring in Azure Monitor](./kubernetes-monitoring-overview.md), multiple features of Azure Monitor work together to provide complete monitoring of your Azure Kubernetes Service (AKS) or Azure Arc-enabled Kubernetes clusters. This article describes particular prerequisites and other considerations for enabling these features. 





## Security

- Container Insights supports FIPS enabled Linux and Windows node pools starting with Agent version 3.1.17 (Linux)  & Win-3.1.17 (Windows).
- Starting with Agent version 3.1.17 (Linux) and Win-3.1.17 (Windows), Container Insights agents images (both Linux and Windows) are signed and  for Windows agent,  binaries inside the container are signed as well

## Permissions required

- At least [Contributor](/azure/role-based-access-control/built-in-roles#contributor) access to the cluster for onboarding.
- [Monitoring Reader](../roles-permissions-security.md#monitoring-reader) or [Monitoring Contributor](../roles-permissions-security.md#monitoring-contributor) to view data after monitoring is enabled.




## Agent

Both container log collection and Managed Prometheus rely on a containerized [Azure Monitor agent](../agents/agents-overview.md) for Linux. This specialized agent collects performance and event data from all nodes in the cluster. This agent is deployed and registered with the specified workspaces when you enable these features. 

> [!NOTE]
> Since March 1, 2023 Container Insights uses a Semver compliant agent version. The agent version is *mcr.microsoft.com/azuremonitor/containerinsights/ciprod:3.1.4* or later. When a new version of the agent is released, it's automatically upgraded on your managed Kubernetes clusters that are hosted on AKS. To track which versions are released, see [Agent release announcements](https://github.com/microsoft/Docker-Provider/blob/ci_prod/ReleaseNotes.md). 


## Resources provisioned

When you enable monitoring, the following resources are created in your subscription. You may not need to interact with these resources directly, but you will need them to perform advanced configurations or if you want to implement strategies to deploy and manage your Kubernetes environment at scale.

**Managed Prometheus**

| Resource Name | Resource Type | Resource Group | Region/Location | Description |
|:---|:---|:---|:---|:---|
| `MSPROM-<aksclusterregion>-<clustername>` | [Data Collection Rule](../data-collection/data-collection-rule-overview.md) | Same as cluster | Same as Azure Monitor workspace | Associated with the AKS cluster resource, defines configuration of prometheus metrics collection by metrics addon. |
| `MSPROM-<aksclusterregion>-<clustername>` | [Data Collection endpoint](../data-collection/data-collection-endpoint-overview.md) | Same as cluster | Same as Azure Monitor workspace | Used by the DCR for ingesting Prometheus metrics from the metrics addon. |
    
When you create a new Azure Monitor workspace, the following additional resources are created.

| Resource Name | Resource Type | Resource Group | Region/Location | Description |
|:---|:---|:---|:---|:---|
| `<azuremonitor-workspace-name>` | [Data Collection Rule](../data-collection/data-collection-rule-overview.md) | MA_\<azuremonitor-workspace-name>_\<azuremonitor-workspace-region>_managed | Same as Azure Monitor Workspace | DCR to be used if you use Remote Write from a Prometheus server. |
| `<azuremonitor-workspace-name>` | [Data Collection endpoint](../data-collection/data-collection-endpoint-overview.md) | MA_\<azuremonitor-workspace-name>_\<azuremonitor-workspace-region>_managed | Same as Azure Monitor Workspace | DCE to be used if you use Remote Write from a Prometheus server. |

**Log collection**

| Resource Name | Resource Type | Resource Group | Region/Location | Description |
|:---|:---|:---|:---|:---|
| `MSCI-<aksclusterregion>-<clustername>` | [Data Collection Rule](../data-collection/data-collection-rule-overview.md) | Same as cluster | Same as Log Analytics workspace | Associated with the AKS cluster resource, defines configuration of logs collection by the Azure Monitor agent. |

## Differences between Windows and Linux clusters

There are some differences in monitoring a Windows Server cluster compared to a Linux cluster, which include:

- Windows doesn't have a Memory RSS metric, so it isn't available for Windows nodes and containers. The [Working Set](/windows/win32/memory/working-set) metric is available.
- Disk storage capacity information isn't available for Windows nodes.
- Only pod environments are monitored, not Docker environments.
- With the preview release, a maximum of 30 Windows Server containers are supported. This limitation doesn't apply to Linux containers.

>[!NOTE]
> Support for the Windows Server 2022 operating system is in preview.

The containerized Linux agent (replicaset pod) makes API calls to all the Windows nodes on Kubelet secure port (10250) within the cluster to collect node and container performance-related metrics. Kubelet secure port (:10250) should be opened in the cluster's virtual network for both inbound and outbound for Windows node and container performance-related metrics collection to work.

If you have a Kubernetes cluster with Windows nodes, review and configure the network security group and network policies to make sure the Kubelet secure port (:10250) is open for both inbound and outbound in the cluster's virtual network.

## Share DCR with multiple clusters
When you enable Container insights on a Kubernetes cluster, a new DCR is created for that cluster, and the DCR for each cluster can be modified independently. If you have multiple clusters with custom monitoring configurations, you may want to share a single DCR with multiple clusters. You can then make changes to a single DCR that are automatically implemented for any clusters associated with it.

A DCR is associated with a cluster with a [data collection rule associates (DCRA)](../essentials/data-collection-rule-overview.md#data-collection-rule-associations-dcra). Use the [preview DCR experience](../essentials/data-collection-rule-view.md#preview-dcr-experience) to view and remove existing DCR associations for each cluster. You can then use this feature to add an association to a single DCR for multiple clusters.

### Applicable tables and metrics for DCR
The settings for **collection frequency** and **namespace filtering** in the DCR don't apply to all Container insights data. The following tables list the tables in the Log Analytics workspace used by Container insights and the metrics it collects along with the settings that apply to each. 

| Table name | Interval? | Namespaces? | Remarks |
|:---|:---:|:---:|:---|
| ContainerInventory | Yes | Yes | |
| ContainerNodeInventory | Yes | No | Data collection setting for namespaces isn't applicable since Kubernetes Node isn't a namespace scoped resource |
| KubeNodeInventory | Yes | No | Data collection setting for namespaces isn't applicable Kubernetes Node isn't a namespace scoped resource |
| KubePodInventory | Yes | Yes ||
| KubePVInventory | Yes | Yes | |
| KubeServices | Yes | Yes | |
| KubeEvents | No | Yes | Data collection setting for interval isn't applicable for the Kubernetes Events |
| Perf | Yes | Yes | Data collection setting for namespaces isn't applicable for the Kubernetes Node related metrics since the Kubernetes Node isn't a namespace scoped object. |
| InsightsMetrics| Yes | Yes | Data collection settings are only applicable for the metrics collecting the following namespaces: container.azm.ms/kubestate, container.azm.ms/pv and container.azm.ms/gpu |

> [!NOTE]
> Namespace filtering does not apply to ama-logs agent records. As a result, even if the kube-system namespace is listed among excluded namespaces, records associated to ama-logs agent container will still be ingested. 

| Metric namespace | Interval? | Namespaces? | Remarks |
|:---|:---:|:---:|:---|
| Insights.container/nodes| Yes | No | Node isn't a namespace scoped resource |
|Insights.container/pods | Yes | Yes| |
| Insights.container/containers | Yes | Yes | |
| Insights.container/persistentvolumes | Yes | Yes | |





## Cost control
 Kubernetes clusters generate a lot of log data, which can result in significant costs if you aren't selective about the logs that you collect. Before you enable monitoring for your cluster, see the following articles to ensure that your environment is optimized for cost and that you limit your log collection to only the data that you require:
 
- [Configure data collection and cost optimization in Container insights using data collection rule](./container-insights-data-collection-dcr.md)<br>Details on customizing log collection once you've enabled monitoring, including using preset cost optimization configurations.
- [Best practices for monitoring Kubernetes with Azure Monitor](../best-practices-containers.md)<br>Best practices for monitoring Kubernetes clusters organized by the five pillars of the [Azure Well-Architected Framework](/azure/architecture/framework/), including cost optimization.
- [Cost optimization in Azure Monitor](../best-practices-cost.md)<br>Best practices for configuring all features of Azure Monitor to optimize your costs and limit the amount of data that you collect.


## Next steps

* If you experience issues while you attempt to onboard the solution, review the [Troubleshooting guide](container-insights-troubleshoot.md).
* With monitoring enabled to collect health and resource utilization of your AKS cluster and workloads running on them, learn [how to use](container-insights-analyze.md) Container insights.



## Extra

>[!IMPORTANT]
> In the commands in this section, when deploying on a Windows machine, the dataCollectionSettings field must be escaped. For example, dataCollectionSettings={\"interval\":\"1m\",\"namespaceFilteringMode\": \"Include\", \"namespaces\": [ \"kube-system\"]} instead of dataCollectionSettings='{"interval":"1m","namespaceFilteringMode": "Include", "namespaces": [ "kube-system"]}'



> [!IMPORTANT]
> AKS clusters must use either a system-assigned or user-assigned managed identity. If cluster is using a service principal, you must update the cluster to use a [system-assigned managed identity](/azure/aks/use-managed-identity#update-an-existing-aks-cluster-to-use-a-system-assigned-managed-identity) or a [user-assigned managed identity](/azure/aks/use-managed-identity#update-an-existing-cluster-to-use-a-user-assigned-managed-identity).



