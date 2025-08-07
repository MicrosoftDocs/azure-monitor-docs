---
title: Enable monitoring for Kubernetes clusters
description: Learn how to enable Container insights and Managed Prometheus on an Azure Kubernetes Service (AKS) cluster.
ms.topic: how-to
ms.custom: devx-track-azurecli, linux-related-content
ms.reviewer: aul
ms.date: 03/11/2024
---

# Enable Azure Monitor features for Kubernetes clusters

As described in [Kubernetes monitoring in Azure Monitor](./container-insights-overview.md), multiple features of Azure Monitor work together to provide complete monitoring of your Azure Kubernetes Service (AKS) or Azure Arc-enabled Kubernetes clusters. This article describes prerequisites and other considerations for enabling different features. For the detailed process of onboarding and configuring these features, see one the following articles depending on the technology you want to use to enable monitoring for your cluster.

- [Azure portal](kubernetes-monitoring-enable-portal.md)
- [Azure CLI](kubernetes-monitoring-enable-cli.md)
- [Azure Resource Manager templates](kubernetes-monitoring-enable-arm.md)
- [Azure Policy](kubernetes-monitoring-enable-policy.md)
- [Terraform](kubernetes-monitoring-enable-terraform.md)

> [!IMPORTANT]
> Kubernetes clusters generate
>  a lot of log data, which can result in significant costs if you aren't selective about the logs that you collect. Before you enable monitoring for your cluster, see the following articles to ensure that your environment is optimized for cost and that you limit your log collection to only the data that you require:
> 
>- [Configure data collection and cost optimization in Container insights using data collection rule](./container-insights-data-collection-dcr.md)<br>Details on customizing log collection once you've enabled monitoring, including using preset cost optimization configurations.
>- [Best practices for monitoring Kubernetes with Azure Monitor](../best-practices-containers.md)<br>Best practices for monitoring Kubernetes clusters organized by the five pillars of the [Azure Well-Architected Framework](/azure/architecture/framework/), including cost optimization.
>- [Cost optimization in Azure Monitor](../best-practices-cost.md)<br>Best practices for configuring all features of Azure Monitor to optimize your costs and limit the amount of data that you collect.

## Supported clusters

The onboarding and configuration processes described in these articles support the following clusters. Any differences in the process for each type are noted in the relevant sections.

- [Azure Kubernetes clusters (AKS)](/azure/aks/intro-kubernetes)
- [Arc-enabled Kubernetes clusters](/azure/azure-arc/kubernetes/validation-program)
  - AKS on Azure Local
  - AKS Edge Essentials
  - Canonical
  - Cluster API Provider on Azure
  - K8s on Azure Stack Edge
  - Red Hat OpenShift version 4.x
  - SUSE Rancher (Rancher Kubernetes engine)
  - SUSE Rancher K3s
  - VMware (TKG)



## Permissions required

- You require at least [Contributor](/azure/role-based-access-control/built-in-roles#contributor) access to the cluster for onboarding.
- You require [Monitoring Reader](../roles-permissions-security.md#monitoring-reader) or [Monitoring Contributor](../roles-permissions-security.md#monitoring-contributor) to view data after monitoring is enabled.

## Prerequisites




**Arc-Enabled Kubernetes clusters prerequisites**

- Verify the [firewall requirements](kubernetes-monitoring-firewall.md) in addition to the [Azure Arc-enabled Kubernetes network requirements](/azure/azure-arc/kubernetes/network-requirements).
- If you previously installed monitoring for AKS, ensure that you have [disabled monitoring](kubernetes-monitoring-disable.md) before proceeding to avoid issues during the extension install.
- If you previously installed monitoring on a cluster using a script without cluster extensions, follow the instructions at [Disable monitoring of your Kubernetes cluster](kubernetes-monitoring-disable.md) to delete this Helm chart.

> [!NOTE]
> The Managed Prometheus Arc-Enabled Kubernetes extension does not support the following configurations:
> * Red Hat Openshift distributions, including Azure Red Hat OpenShift (ARO)
> * Windows nodes*
>
> *For ARC-enabled clusters with Windows nodes, you can setup Azure Managed Prometheus on a Linux node within the cluster, and configure scraping metrics from metrics endpoints running on the Windows nodes.

## Managed Prometheus 

### Prerequisites

- The cluster must use [managed identity authentication](/azure/aks/use-managed-identity).
- The following resource providers must be registered in the subscription of the cluster and the Azure Monitor workspace:
    - Microsoft.ContainerService
    - Microsoft.Insights
    - Microsoft.AlertsManagement
    - Microsoft.Monitor
    - The following resource providers must be registered in the subscription of the Grafana workspace subscription:
        - Microsoft.Dashboard

### Azure Monitor workspace

 `Contributor` permission is enough for enabling the addon to send data to the Azure Monitor workspace. You will need `Owner` level permission to link your Azure Monitor Workspace to view metrics in Azure Managed Grafana. This is required because the user executing the onboarding step, needs to be able to give the Azure Managed Grafana System Identity `Monitoring Reader` role on the Azure Monitor Workspace to query the metrics.

### Resources provisioned

When you enable Managed Prometheus, the following resources are created in your subscription:

| Resource Name | Resource Type | Resource Group | Region/Location | Description |
|:---|:---|:---|:---|:---|
| `MSPROM-<aksclusterregion>-<clustername>` | **Data Collection Rule** | Same as cluster | Same as Azure Monitor workspace | This data collection rule is for prometheus metrics collection by metrics addon, which has the chosen Azure monitor workspace as destination, and also it is associated to the AKS cluster resource. |
| `MSPROM-<aksclusterregion>-<clustername>` | **Data Collection endpoint** | Same as cluster | Same as Azure Monitor workspace | This data collection endpoint is used by the above data collection rule for ingesting Prometheus metrics from the metrics addon|
| `<azuremonitor-workspace-name>` | **Data Collection Rule** | MA_\<azuremonitor-workspace-name>_\<azuremonitor-workspace-region>_managed | Same as Azure Monitor Workspace | DCR created when you use OSS Prometheus server to Remote Write to Azure Monitor Workspace. |
| `<azuremonitor-workspace-name>` | **Data Collection Endpoint** | MA_\<azuremonitor-workspace-name>_\<azuremonitor-workspace-region>_managed | Same as Azure Monitor Workspace | DCE created when you use OSS Prometheus server to Remote Write to Azure Monitor Workspace.|


## Container log collection



The following table describes the workspaces that are required to support Managed Prometheus and container logging. You can create each workspace as part of the onboarding process or use an existing workspace. See [Design a Log Analytics workspace architecture](../logs/workspace-design.md) for guidance on how many workspaces to create and where they should be placed. 

| Feature | Workspace | Notes |
|:---|:---|:---|
| Managed Prometheus |  |
| container logging | [Log Analytics workspace](../logs/log-analytics-workspace-overview.md) | You can attach a cluster to a Log Analytics workspace in a different Azure subscription in the same Microsoft Entra tenant, but you must use the Azure CLI or an Azure Resource Manager template. You can't currently perform this configuration with the Azure portal.<br><br>If you're connecting an existing cluster to a Log Analytics workspace in another subscription, the *Microsoft.ContainerService* resource provider must be registered in the subscription with the Log Analytics workspace. For more information, see [Register resource provider](/azure/azure-resource-manager/management/resource-providers-and-types#register-resource-provider).<br><br>For a list of the supported mapping pairs to use for the default workspace, see [Region mappings supported by Container insights](container-insights-region-mapping.md). See [Configure Azure Monitor with Network Security Perimeter](../fundamentals/network-security-perimeter.md) for guidance on how to configure the workspace with network security perimeter. |
| Managed Grafana | [Azure Managed Grafana workspace](/azure/managed-grafana/quickstart-managed-grafana-portal#create-an-azure-managed-grafana-workspace) | [Link your Grafana workspace to your Azure Monitor workspace](/azure/managed-grafana/how-to-connect-azure-monitor-workspace) to make the Prometheus metrics collected from your cluster available to Grafana dashboards. |

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

## Resources provisioned

When you enable monitoring, the following resources are created in your subscription:

| Resource Name | Resource Type | Resource Group | Region/Location | Description |
|:---|:---|:---|:---|:---|
| `MSCI-<aksclusterregion>-<clustername>` | **Data Collection Rule** | Same as cluster | Same as Log Analytics workspace | This data collection rule is for log collection by Azure Monitor agent, which uses the Log Analytics workspace as destination, and is associated to the AKS cluster resource. |
| `MSPROM-<aksclusterregion>-<clustername>` | **Data Collection Rule** | Same as cluster | Same as Azure Monitor workspace | This data collection rule is for prometheus metrics collection by metrics addon, which has the chosen Azure monitor workspace as destination, and also it is associated to the AKS cluster resource |
| `MSPROM-<aksclusterregion>-<clustername>` | **Data Collection endpoint** | Same as cluster | Same as Azure Monitor workspace | This data collection endpoint is used by the above data collection rule for ingesting Prometheus metrics from the metrics addon|
    
When you create a new Azure Monitor workspace, the following additional resources are created as part of it

| Resource Name | Resource Type | Resource Group | Region/Location | Description |
|:---|:---|:---|:---|:---|
| `<azuremonitor-workspace-name>` | **Data Collection Rule** | MA_\<azuremonitor-workspace-name>_\<azuremonitor-workspace-region>_managed | Same as Azure Monitor Workspace | DCR created when you use OSS Prometheus server to Remote Write to Azure Monitor Workspace. |
| `<azuremonitor-workspace-name>` | **Data Collection Endpoint** | MA_\<azuremonitor-workspace-name>_\<azuremonitor-workspace-region>_managed | Same as Azure Monitor Workspace | DCE created when you use OSS Prometheus server to Remote Write to Azure Monitor Workspace.|


The DCR created by Container insights is named *MSCI-\<cluster-region\>-\<cluster-name\>*. You can [view this DCR](../essentials/data-collection-rule-view.md) along with others in your subscription, and you can edit it using methods described in [Create and edit data collection rules (DCRs) in Azure Monitor](../essentials/data-collection-rule-create-edit.md). While you can directly modify the DCR for particular customizations, you can perform most required configuration using the methods described below. See [Data transformations in Container insights](./container-insights-transformations.md) for details on editing the DCR directly for more advanced configurations.



## Differences between Windows and Linux clusters

The main differences in monitoring a Windows Server cluster compared to a Linux cluster include:

- Windows doesn't have a Memory RSS metric. As a result, it isn't available for Windows nodes and containers. The [Working Set](/windows/win32/memory/working-set) metric is available.
- Disk storage capacity information isn't available for Windows nodes.
- Only pod environments are monitored, not Docker environments.
- With the preview release, a maximum of 30 Windows Server containers are supported. This limitation doesn't apply to Linux containers.

>[!NOTE]
> Container insights support for the Windows Server 2022 operating system is in preview.


The containerized Linux agent (replicaset pod) makes API calls to all the Windows nodes on Kubelet secure port (10250) within the cluster to collect node and container performance-related metrics. Kubelet secure port (:10250) should be opened in the cluster's virtual network for both inbound and outbound for Windows node and container performance-related metrics collection to work.

If you have a Kubernetes cluster with Windows nodes, review and configure the network security group and network policies to make sure the Kubelet secure port (:10250) is open for both inbound and outbound in the cluster's virtual network.



## Verify deployment
Use the [kubectl command line tool](/azure/aks/learn/quick-kubernetes-deploy-cli#connect-to-the-cluster) to verify that the agent is deployed properly.

### [Prometheus](#prometheus)

**Verify that the DaemonSet was deployed properly on the Linux node pools**

```AzureCLI
kubectl get ds ama-metrics-node --namespace=kube-system
```

The number of pods should be equal to the number of Linux nodes on the cluster. The output should resemble the following example:

```output
User@aksuser:~$ kubectl get ds ama-metrics-node --namespace=kube-system
NAME               DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
ama-metrics-node   1         1         1       1            1           <none>          10h
```

**Verify that Windows nodes were deployed properly**

```AzureCLI
kubectl get ds ama-metrics-win-node --namespace=kube-system
```

The number of pods should be equal to the number of Windows nodes on the cluster. The output should resemble the following example:

```output
User@aksuser:~$ kubectl get ds ama-metrics-node --namespace=kube-system
NAME                   DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
ama-metrics-win-node   3         3         3       3            3           <none>          10h
```

**Verify that the two ReplicaSets were deployed for Prometheus**

```AzureCLI
kubectl get rs --namespace=kube-system
```

The output should resemble the following example:

```output
User@aksuser:~$kubectl get rs --namespace=kube-system
NAME                            DESIRED   CURRENT   READY   AGE
ama-metrics-5c974985b8          1         1         1       11h
ama-metrics-ksm-5fcf8dffcd      1         1         1       11h
```


### [Container logs](#container-logs)

**Verify that the DaemonSets were deployed properly on the Linux node pools**

```AzureCLI
kubectl get ds ama-logs --namespace=kube-system
```

The number of pods should be equal to the number of Linux nodes on the cluster. The output should resemble the following example:

```output
User@aksuser:~$ kubectl get ds ama-logs --namespace=kube-system
NAME       DESIRED   CURRENT   READY     UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
ama-logs   2         2         2         2            2           <none>          1d
```

**Verify that Windows nodes were deployed properly**

```
kubectl get ds ama-logs-windows --namespace=kube-system
```

The number of pods should be equal to the number of Windows nodes on the cluster. The output should resemble the following example:

```output
User@aksuser:~$ kubectl get ds ama-logs-windows --namespace=kube-system
NAME                   DESIRED   CURRENT   READY     UP-TO-DATE   AVAILABLE   NODE SELECTOR     AGE
ama-logs-windows           2         2         2         2            2       <none>            1d
```


**Verify deployment of the Container insights solution**

```
kubectl get deployment ama-logs-rs --namespace=kube-system
```

The output should resemble the following example:

```output
User@aksuser:~$ kubectl get deployment ama-logs-rs --namespace=kube-system
NAME          READY   UP-TO-DATE   AVAILABLE   AGE
ama-logs-rs   1/1     1            1           24d
```

**View configuration with CLI**

Use the `aks show` command to find out whether the solution is enabled, the Log Analytics workspace resource ID, and summary information about the cluster.

```azurecli
az aks show --resource-group <resourceGroupofAKSCluster> --name <nameofAksCluster>
```

The command will return JSON-formatted information about the solution. The `addonProfiles` section should include information on the `omsagent` as in the following example:

```output
"addonProfiles": {
    "omsagent": {
        "config": {
            "logAnalyticsWorkspaceResourceID": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/my-resource-group/providers/microsoft.operationalinsights/workspaces/my-workspace",
            "useAADAuth": "true"
        },
        "enabled": true,
        "identity": null
    },
}
```

---




## Next steps

* If you experience issues while you attempt to onboard the solution, review the [Troubleshooting guide](container-insights-troubleshoot.md).
* With monitoring enabled to collect health and resource utilization of your AKS cluster and workloads running on them, learn [how to use](container-insights-analyze.md) Container insights.



## Extra

>[!IMPORTANT]
> In the commands in this section, when deploying on a Windows machine, the dataCollectionSettings field must be escaped. For example, dataCollectionSettings={\"interval\":\"1m\",\"namespaceFilteringMode\": \"Include\", \"namespaces\": [ \"kube-system\"]} instead of dataCollectionSettings='{"interval":"1m","namespaceFilteringMode": "Include", "namespaces": [ "kube-system"]}'



> [!IMPORTANT]
> AKS clusters must use either a system-assigned or user-assigned managed identity. If cluster is using a service principal, you must update the cluster to use a [system-assigned managed identity](/azure/aks/use-managed-identity#update-an-existing-aks-cluster-to-use-a-system-assigned-managed-identity) or a [user-assigned managed identity](/azure/aks/use-managed-identity#update-an-existing-cluster-to-use-a-user-assigned-managed-identity).




## Share DCR with multiple clusters
When you enable Container insights on a Kubernetes cluster, a new DCR is created for that cluster, and the DCR for each cluster can be modified independently. If you have multiple clusters with custom monitoring configurations, you may want to share a single DCR with multiple clusters. You can then make changes to a single DCR that are automatically implemented for any clusters associated with it.

A DCR is associated with a cluster with a [data collection rule associates (DCRA)](../essentials/data-collection-rule-overview.md#data-collection-rule-associations-dcra). Use the [preview DCR experience](../essentials/data-collection-rule-view.md#preview-dcr-experience) to view and remove existing DCR associations for each cluster. You can then use this feature to add an association to a single DCR for multiple clusters.