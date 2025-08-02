---
title: Enable monitoring for Kubernetes clusters using CLI
description: Learn how to enable container logging and Managed Prometheus on an Azure Kubernetes Service (AKS) cluster using CLI.
ms.topic: how-to
ms.custom: devx-track-azurecli, linux-related-content
ms.reviewer: aul
ms.date: 03/11/2024
---

# Enable monitoring for Kubernetes clusters using CLI

As described in [Kubernetes monitoring in Azure Monitor](./container-insights-overview.md), multiple features of Azure Monitor work together to provide complete monitoring of your Azure Kubernetes Service (AKS) or Azure Arc-enabled Kubernetes clusters. This article describes how to enable these features using the Azure portal.



## Prerequisites

- Az CLI version of 2.51.0 or higher is required.
- The k8s-extension version 1.4.3 or higher is required. 
- The aks-preview extension must be [uninstalled from AKS clusters](/cli/azure/azure-cli-extensions-overview) by using the command `az extension remove --name aks-preview`. 
- Managed identity authentication is not supported for Arc-enabled Kubernetes clusters with ARO (Azure Red Hat Openshift) or Windows nodes. Use [legacy authentication]().
  
## Prometheus

Use one of the following commands to enable collection of Prometheus metrics from your AKS and Arc-enabled clusters. If you don't specify an existing Azure Monitor workspace in the following commands, the default workspace for the resource group will be used. If a default workspace doesn't already exist in the cluster's region, one with a name in the format `DefaultAzureMonitorWorkspace-<mapped_region>` will be created in a resource group with the name `DefaultRG-<cluster_region>`.


### [AKS cluster](#tab/aks)
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

### [Arc-enabled cluster](#tab/arc)

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

---

Each of the commands for AKS and Arc-Enabled Kubernetes allow the following optional parameters. The parameter name is different for each, but their use is the same.

| Parameter | Name and Description |
|:---|:---|
| Annotation keys | AKS: `--ksm-metric-annotations-allow-list`<br>Arc: `--AzureMonitorMetrics.KubeStateMetrics.MetricAnnotationsAllowList`<br><br>Comma-separated list of Kubernetes annotations keys used in the resource's `kube_resource_annotations` metric. For example, kube_pod_annotations is the annotations metric for the pods resource. By default, this metric contains only name and namespace labels. To include more annotations, provide a list of resource names in their plural form and Kubernetes annotation keys that you want to allow for them. A single `*` can be provided for each resource to allow any annotations, but this has severe performance implications. For example, `pods=[kubernetes.io/team,...],namespaces=[kubernetes.io/team],...`. |
| Label keys | AKS: `--ksm-metric-labels-allow-list`<br>Arc: `--AzureMonitorMetrics.KubeStateMetrics.MetricLabelsAllowlist`<br><br>Comma-separated list of more Kubernetes label keys that is used in the resource's kube_resource_labels metric kube_resource_labels metric. For example, kube_pod_labels is the labels metric for the pods resource. By default this metric contains only name and namespace labels. To include more labels, provide a list of resource names in their plural form and Kubernetes label keys that you want to allow for them A single `*` can be provided for each resource to allow any labels, but i this has severe performance implications. For example, `pods=[app],namespaces=[k8s-label-1,k8s-label-n,...],...`. |
| Recording rules | AKS: `--enable-windows-recording-rules`<br><br>Lets you enable the recording rule groups required for proper functioning of the Windows dashboards. |



## Container logs

Use one of the following commands to enable collection of container logs from your AKS and Arc-enabled clusters. If you don't specify an existing Log Analytics workspace, the default workspace for the resource group will be used. If a default workspace doesn't already exist in the cluster's region, one will be created with a name in the format `DefaultWorkspace-<GUID>-<Region>`.

> [!NOTE]
> You can enable the **ContainerLogV2** schema for a cluster either using the cluster's Data Collection Rule (DCR) or ConfigMap. If both settings are enabled, the ConfigMap will take precedence. Stdout and stderr logs will only be ingested to the ContainerLog table when both the DCR and ConfigMap are explicitly set to off.

### Log configuration file





### [AKS cluster](#tab/aks)

#### New AKS cluster

Use the following command to create a new AKS cluster with monitoring enabled. This assumes a configuration file named **dataCollectionSettings.json**.

```azcli
az aks create -g <clusterResourceGroup> -n <clusterName> --enable-managed-identity --node-count 1 --enable-addons monitoring --data-collection-settings dataCollectionSettings.json --generate-ssh-keys 
```

#### Existing AKS cluster

```azurecli
### Use default Log Analytics workspace
az aks enable-addons --addon monitoring --name <cluster-name> --resource-group <cluster-resource-group-name> --data-collection-settings <settings-file>

### Use existing Log Analytics workspace
az aks enable-addons --addon monitoring --name <cluster-name> --resource-group <cluster-resource-group-name> --workspace-resource-id <workspace-resource-id> --data-collection-settings <settings-file>

### Use legacy authentication
az aks enable-addons --addon monitoring --name <cluster-name> --resource-group <cluster-resource-group-name> --workspace-resource-id <workspace-resource-id> --enable-msi-auth-for-monitoring false --data-collection-settings <settings-file> 
```

**Example**

```azurecli
az aks enable-addons --addon monitoring --name "my-cluster" --resource-group "my-resource-group" --workspace-resource-id "/subscriptions/my-subscription/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace" --data-collection-settings dataCollectionSettings.json 
```

#### Modify configuration settings

Use the following command to add a new configuration to an existing cluster with Container insights enabled. This assumes a configuration file named **dataCollectionSettings.json**.

```azcli    
# get the configured log analytics workspace resource id
az aks show -g <clusterResourceGroup> -n <clusterName> | grep -i "logAnalyticsWorkspaceResourceID"

# disable monitoring 
az aks disable-addons -a monitoring -g <clusterResourceGroup> -n <clusterName>

# enable monitoring with data collection settings
az aks enable-addons -a monitoring -g <clusterResourceGroup> -n <clusterName> --workspace-resource-id <logAnalyticsWorkspaceResourceId> --data-collection-settings dataCollectionSettings.json
```

### [Arc-enabled cluster](#tab/arc)

```azurecli
### Use default Log Analytics workspace
az k8s-extension create --name azuremonitor-containers --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --extension-type Microsoft.AzureMonitor.Containers

### Use existing Log Analytics workspace
az k8s-extension create --name azuremonitor-containers --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --extension-type Microsoft.AzureMonitor.Containers --configuration-settings logAnalyticsWorkspaceResourceID=<workspace-resource-id>

### Use managed identity authentication (default as k8s-extension version 1.43.0)
az k8s-extension create --name azuremonitor-containers --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --extension-type Microsoft.AzureMonitor.Containers --configuration-settings amalogs.useAADAuth=true

### Use advanced configuration settings
az k8s-extension create --name azuremonitor-containers --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --extension-type Microsoft.AzureMonitor.Containers --configuration-settings  amalogs.resources.daemonset.limits.cpu=150m amalogs.resources.daemonset.limits.memory=600Mi amalogs.resources.deployment.limits.cpu=1 amalogs.resources.deployment.limits.memory=750Mi

### With custom mount path for container stdout & stderr logs
### Custom mount path not required for Azure Stack Edge version > 2318. Custom mount path must be /home/data/docker for Azure Stack Edge cluster with version <= 2318
az k8s-extension create --name azuremonitor-containers --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --extension-type Microsoft.AzureMonitor.Containers --configuration-settings amalogs.logsettings.custommountpath=<customMountPath>

### Customize log collection settings
az k8s-extension create --name azuremonitor-containers --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --extension-type Microsoft.AzureMonitor.Containers --configuration-settings amalogs.useAADAuth=true dataCollectionSettings='{"interval":"1m","namespaceFilteringMode": "Include", "namespaces": [ "kube-system"],"enableContainerLogV2": true,"streams": ["<streams to be collected>"]}'

```

See the [resource requests and limits section of Helm chart](https://github.com/microsoft/Docker-Provider/blob/ci_prod/charts/azuremonitor-containers/values.yaml) for the available configuration settings.


**Example**

```azurecli
az k8s-extension create --name azuremonitor-containers --cluster-name "my-cluster" --resource-group "my-resource-group" --cluster-type connectedClusters --extension-type Microsoft.AzureMonitor.Containers --configuration-settings logAnalyticsWorkspaceResourceID="/subscriptions/my-subscription/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace"
```

**Arc-enabled cluster with forward proxy**

If the cluster is configured with a forward proxy, then proxy settings are automatically applied to the extension. In the case of a cluster with AMPLS + proxy, proxy config should be ignored. Onboard the extension with the configuration setting `amalogs.ignoreExtensionProxySettings=true`.

```azurecli
az k8s-extension create --name azuremonitor-containers --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --extension-type Microsoft.AzureMonitor.Containers --configuration-settings amalogs.ignoreExtensionProxySettings=true
```

**Arc-enabled cluster with ARO or OpenShift or Windows nodes**

Managed identity authentication is not supported for Arc-enabled Kubernetes clusters with ARO (Azure Red Hat OpenShift) or OpenShift or Windows nodes. Use legacy authentication by specifying `amalogs.useAADAuth=false` as in the following example.

```azurecli
az k8s-extension create --name azuremonitor-containers --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type connectedClusters --extension-type Microsoft.AzureMonitor.Containers --configuration-settings amalogs.useAADAuth=false
```

**Delete extension instance**

The following command only deletes the extension instance, but doesn't delete the Log Analytics workspace. The data in the Log Analytics resource is left intact.

```azurecli
az k8s-extension delete --name azuremonitor-containers --cluster-type connectedClusters --cluster-name <cluster-name> --resource-group <resource-group>
```

---

To customize log collection settings for the cluster, you can provide the configuration as a JSON file using the following format. If you don't provide a configuration file, the default [Logs and events](../containers/kubernetes-monitoring-enable-portal.md#container-log-options) profile is used.

```json
{
  "interval": "1m",
  "namespaceFilteringMode": "Include",
  "namespaces": ["kube-system"],
  "enableContainerLogV2": true, 
  "streams": ["Microsoft-Perf", "Microsoft-ContainerLogV2"]
}
```

Each of the settings in the configuration is described in the following table.

| Name | Description |
|:---|:---|
| `interval` | Determines how often the agent collects data.  Valid values are 1m - 30m in 1m intervals The default value is 1m. If the value is outside the allowed range, then it defaults to *1 m*. |
| `namespaceFilteringMode` | *Include*: Collects only data from the values in the *namespaces* field.<br>*Exclude*: Collects data from all namespaces except for the values in the *namespaces* field.<br>*Off*: Ignores any *namespace* selections and collect data on all namespaces.
| `namespaces` | Array of comma separated Kubernetes namespaces to collect inventory and perf data based on the _namespaceFilteringMode_.<br>For example, *namespaces = ["kube-system", "default"]* with an _Include_ setting collects only these two namespaces. With an _Exclude_ setting, the agent collects data from all other namespaces except for _kube-system_ and _default_. With an _Off_ setting, the agent collects data from all namespaces including _kube-system_ and _default_. Invalid and unrecognized namespaces are ignored. |
|  `enableContainerLogV2` | Boolean flag to enable ContainerLogV2 schema. If set to true, the stdout/stderr Logs are ingested to [ContainerLogV2](container-insights-logs-schema.md) table. If not, the container logs are ingested to **ContainerLog** table, unless otherwise specified in the ConfigMap. When specifying the individual streams, you must include the corresponding table for ContainerLog or ContainerLogV2. |
| `streams` | An array of container insights table streams. See [Stream values in DCR](#stream-values-in-dcr) for a list of the valid streams and their corresponding tables. |



## Next steps

* If you experience issues while you attempt to onboard the solution, review the [Troubleshooting guide](container-insights-troubleshoot.md).
* With monitoring enabled to collect health and resource utilization of your AKS cluster and workloads running on them, learn [how to use](container-insights-analyze.md) Container insights.
