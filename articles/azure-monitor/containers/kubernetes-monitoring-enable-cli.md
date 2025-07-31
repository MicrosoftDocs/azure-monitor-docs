---
title: Enable monitoring for Kubernetes clusters using CLI
description: Learn how to enable Container insights and Managed Prometheus on an Azure Kubernetes Service (AKS) cluster.
ms.topic: how-to
ms.custom: devx-track-azurecli, linux-related-content
ms.reviewer: aul
ms.date: 03/11/2024
---

# Enable monitoring for Kubernetes clusters using CLI

As described in [Kubernetes monitoring in Azure Monitor](./container-insights-overview.md), multiple features of Azure Monitor work together to provide complete monitoring of your Azure Kubernetes Service (AKS) or Azure Arc-enabled Kubernetes clusters. This article describes how to enable these features using the Azure portal.


If you don't specify an existing Azure Monitor workspace in the following commands, the default workspace for the resource group will be used. If a default workspace doesn't already exist in the cluster's region, one with a name in the format `DefaultAzureMonitorWorkspace-<mapped_region>` will be created in a resource group with the name `DefaultRG-<cluster_region>`.

#### Prerequisites

- Az CLI version of 2.49.0 or higher is required. 
- The aks-preview extension must be [uninstalled from AKS clusters](/cli/azure/azure-cli-extensions-overview) by using the command `az extension remove --name aks-preview`. 
- The k8s-extension extension must be installed using the command `az extension add --name k8s-extension`.
- The k8s-extension version 1.4.1 or higher is required. 

#### Optional parameters
Each of the commands for AKS and Arc-Enabled Kubernetes allow the following optional parameters. The parameter name is different for each, but their use is the same.

| Parameter | Name and Description |
|:---|:---|
| Annotation keys | AKS: `--ksm-metric-annotations-allow-list`<br>Arc: `--AzureMonitorMetrics.KubeStateMetrics.MetricAnnotationsAllowList`<br><br>Comma-separated list of Kubernetes annotations keys used in the resource's `kube_resource_annotations` metric. For example, kube_pod_annotations is the annotations metric for the pods resource. By default, this metric contains only name and namespace labels. To include more annotations, provide a list of resource names in their plural form and Kubernetes annotation keys that you want to allow for them. A single `*` can be provided for each resource to allow any annotations, but this has severe performance implications. For example, `pods=[kubernetes.io/team,...],namespaces=[kubernetes.io/team],...`. |
| Label keys | AKS: `--ksm-metric-labels-allow-list`<br>Arc: `--AzureMonitorMetrics.KubeStateMetrics.MetricLabelsAllowlist`<br><br>Comma-separated list of more Kubernetes label keys that is used in the resource's kube_resource_labels metric kube_resource_labels metric. For example, kube_pod_labels is the labels metric for the pods resource. By default this metric contains only name and namespace labels. To include more labels, provide a list of resource names in their plural form and Kubernetes label keys that you want to allow for them A single `*` can be provided for each resource to allow any labels, but i this has severe performance implications. For example, `pods=[app],namespaces=[k8s-label-1,k8s-label-n,...],...`. |
| Recording rules | AKS: `--enable-windows-recording-rules`<br><br>Lets you enable the recording rule groups required for proper functioning of the Windows dashboards. |

#### AKS cluster
Use the `-enable-azure-monitor-metrics` option `az aks create` or `az aks update` (depending whether you're creating a new cluster or updating an existing cluster) to install the metrics add-on that scrapes Prometheus metrics.

```azurecli
### Use default Azure Monitor workspace
az aks create/update --enable-azure-monitor-metrics --name <cluster-name> --resource-group <cluster-resource-group>

### Use existing Azure Monitor workspace
az aks create/update --enable-azure-monitor-metrics --name <cluster-name> --resource-group <cluster-resource-group> --azure-monitor-workspace-resource-id <workspace-name-resource-id>

### Use an existing Azure Monitor workspace and link with an existing Grafana workspace
az aks create/update --enable-azure-monitor-metrics --name <cluster-name> --resource-group <cluster-resource-group> --azure-monitor-workspace-resource-id <azure-monitor-workspace-name-resource-id> --grafana-resource-id  <grafana-workspace-name-resource-id>

### Use optional parameters
az aks create/update --enable-azure-monitor-metrics --name <cluster-name> --resource-group <cluster-resource-group> --ksm-metric-labels-allow-list "namespaces=[k8s-label-1,k8s-label-n]" --ksm-metric-annotations-allow-list "pods=[k8s-annotation-1,k8s-annotation-n]"
```


#### Arc-enabled cluster


```azurecli
### Use default Azure Monitor workspace
az k8s-extension create --name azuremonitor-metrics --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --extension-type Microsoft.AzureMonitor.Containers.Metrics

## Use existing Azure Monitor workspace
az k8s-extension create --name azuremonitor-metrics --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --extension-type Microsoft.AzureMonitor.Containers.Metrics --configuration-settings azure-monitor-workspace-resource-id=<workspace-name-resource-id>

### Use an existing Azure Monitor workspace and link with an existing Grafana workspace
az k8s-extension create --name azuremonitor-metrics --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --extension-type Microsoft.AzureMonitor.Containers.Metrics --configuration-settings azure-monitor-workspace-resource-id=<workspace-name-resource-id> grafana-resource-id=<grafana-workspace-name-resource-id>

### Use optional parameters
az k8s-extension create --name azuremonitor-metrics --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --extension-type Microsoft.AzureMonitor.Containers.Metrics --configuration-settings azure-monitor-workspace-resource-id=<workspace-name-resource-id> grafana-resource-id=<grafana-workspace-name-resource-id> AzureMonitorMetrics.KubeStateMetrics.MetricAnnotationsAllowList="pods=[k8s-annotation-1,k8s-annotation-n]" AzureMonitorMetrics.KubeStateMetrics.MetricLabelsAllowlist "namespaces=[k8s-label-1,k8s-label-n]"
```

The following additional optional parameters are available for Azure Arc-enabled clusters:

| Parameter | Description | Default | Upstream Arc cluster setting |
|:---|:---|:---|:---|
| `ClusterDistribution` | The distribution of the cluster. | `Azure.Cluster.Distribution` | yes |
| `CloudEnvironment` | The cloud environment for the cluster. | `Azure.Cluster.Cloud` | yes |
| `MountCATrustAnchorsDirectory` | Whether to mount CA trust anchors directory. | `true` | no |
| `MountUbuntuCACertDirectory` | Whether to mount Ubuntu CA certificate directory. | `true` unless an `aks_edge` distro. | no |


## Next steps

* If you experience issues while you attempt to onboard the solution, review the [Troubleshooting guide](container-insights-troubleshoot.md).
* With monitoring enabled to collect health and resource utilization of your AKS cluster and workloads running on them, learn [how to use](container-insights-analyze.md) Container insights.
