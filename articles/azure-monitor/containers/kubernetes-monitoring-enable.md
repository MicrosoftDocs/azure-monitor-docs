---
title: Enable monitoring for Kubernetes clusters
description: Learn how to enable Container insights and Managed Prometheus on an Azure Kubernetes Service (AKS) cluster.
ms.topic: how-to
ms.custom: devx-track-azurecli, linux-related-content
ms.reviewer: aul
ms.date: 03/11/2024
---

# Enable monitoring for Kubernetes clusters using CLI and templates

As described in [Kubernetes monitoring in Azure Monitor](./container-insights-overview.md), multiple features of Azure Monitor work together to provide complete monitoring of your Azure Kubernetes Service (AKS) or Azure Arc-enabled Kubernetes clusters. 

> [!IMPORTANT]
> Kubernetes clusters generate a lot of log data, which can result in significant costs if you aren't selective about the logs that you collect. Before you enable monitoring for your cluster, see the following articles to ensure that your environment is optimized for cost and that you limit your log collection to only the data that you require:
> 
>- [Configure data collection and cost optimization in Container insights using data collection rule](./container-insights-data-collection-dcr.md)<br>Details on customizing log collection once you've enabled monitoring, including using preset cost optimization configurations.
>- [Best practices for monitoring Kubernetes with Azure Monitor](../best-practices-containers.md)<br>Best practices for monitoring Kubernetes clusters organized by the five pillars of the [Azure Well-Architected Framework](/azure/architecture/framework/), including cost optimization.
>- [Cost optimization in Azure Monitor](../best-practices-cost.md)<br>Best practices for configuring all features of Azure Monitor to optimize your costs and limit the amount of data that you collect.


## Onboarding options






## Supported clusters

This article provides onboarding guidance for the following types of clusters. Any differences in the process for each type are noted in the relevant sections.

- [Azure Kubernetes clusters (AKS)](/azure/aks/intro-kubernetes)
- [Arc-enabled Kubernetes clusters](/azure/azure-arc/kubernetes/overview)

## Prerequisites

**Permissions**

- You require at least [Contributor](/azure/role-based-access-control/built-in-roles#contributor) access to the cluster for onboarding.
- You require [Monitoring Reader](../roles-permissions-security.md#monitoring-reader) or [Monitoring Contributor](../roles-permissions-security.md#monitoring-contributor) to view data after monitoring is enabled.

**Managed Prometheus prerequisites**

- The cluster must use [managed identity authentication](/azure/aks/use-managed-identity).
- The following resource providers must be registered in the subscription of the cluster and the Azure Monitor workspace:
    - Microsoft.ContainerService
    - Microsoft.Insights
    - Microsoft.AlertsManagement
    - Microsoft.Monitor
    - The following resource providers must be registered in the subscription of the Grafana workspace subscription:
        - Microsoft.Dashboard

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


## Workspaces

The following table describes the workspaces that are required to support Managed Prometheus and Container insights. You can create each workspace as part of the onboarding process or use an existing workspace. See [Design a Log Analytics workspace architecture](../logs/workspace-design.md) for guidance on how many workspaces to create and where they should be placed. 

| Feature | Workspace | Notes |
|:---|:---|:---|
| Managed Prometheus | [Azure Monitor workspace](../essentials/azure-monitor-workspace-overview.md) | `Contributor` permission is enough for enabling the addon to send data to the Azure Monitor workspace. You will need `Owner` level permission to link your Azure Monitor Workspace to view metrics in Azure Managed Grafana. This is required because the user executing the onboarding step, needs to be able to give the Azure Managed Grafana System Identity `Monitoring Reader` role on the Azure Monitor Workspace to query the metrics. |
| Container insights | [Log Analytics workspace](../logs/log-analytics-workspace-overview.md) | You can attach a cluster to a Log Analytics workspace in a different Azure subscription in the same Microsoft Entra tenant, but you must use the Azure CLI or an Azure Resource Manager template. You can't currently perform this configuration with the Azure portal.<br><br>If you're connecting an existing cluster to a Log Analytics workspace in another subscription, the *Microsoft.ContainerService* resource provider must be registered in the subscription with the Log Analytics workspace. For more information, see [Register resource provider](/azure/azure-resource-manager/management/resource-providers-and-types#register-resource-provider).<br><br>For a list of the supported mapping pairs to use for the default workspace, see [Region mappings supported by Container insights](container-insights-region-mapping.md). See [Configure Azure Monitor with Network Security Perimeter](../fundamentals/network-security-perimeter.md) for guidance on how to configure the workspace with network security perimeter. |
| Managed Grafana | [Azure Managed Grafana workspace](/azure/managed-grafana/quickstart-managed-grafana-portal#create-an-azure-managed-grafana-workspace) | [Link your Grafana workspace to your Azure Monitor workspace](/azure/managed-grafana/how-to-connect-azure-monitor-workspace) to make the Prometheus metrics collected from your cluster available to Grafana dashboards. |



## Enable Windows metrics collection (preview)

> [!NOTE]
> There is no CPU/Memory limit in windows-exporter-daemonset.yaml so it may over-provision the Windows nodes  
> For more details see [Resource reservation](https://kubernetes.io/docs/concepts/configuration/windows-resource-management/#resource-reservation)
>   
> As you deploy workloads, set resource memory and CPU limits on containers. This also subtracts from NodeAllocatable and helps the cluster-wide scheduler in determining which pods to place on which nodes.
> Scheduling pods without limits may over-provision the Windows nodes and in extreme cases can cause the nodes to become unhealthy.


As of version 6.4.0-main-02-22-2023-3ee44b9e of the Managed Prometheus addon container (prometheus_collector), Windows metric collection has been enabled for AKS clusters. Onboarding to the Azure Monitor Metrics add-on enables the Windows DaemonSet pods to start running on your node pools. Both Windows Server 2019 and Windows Server 2022 are supported. Follow these steps to enable the pods to collect metrics from your Windows node pools.

1. Manually install windows-exporter on AKS nodes to access Windows metrics by deploying the [windows-exporter-daemonset YAML](https://github.com/prometheus-community/windows_exporter/blob/master/kubernetes/windows-exporter-daemonset.yaml) file. Enable the following collectors:

   * `[defaults]`
   * `container`
   * `memory`
   * `process`
   * `cpu_info`
   
   For more collectors, please see [Prometheus exporter for Windows metrics](https://github.com/prometheus-community/windows_exporter#windows_exporter).

   Deploy the [windows-exporter-daemonset YAML](https://github.com/prometheus-community/windows_exporter/blob/master/kubernetes/windows-exporter-daemonset.yaml) file. Note that if there are any taints applied in the node, you will need to apply the appropriate tolerations.

   ```
       kubectl apply -f windows-exporter-daemonset.yaml
   ```

1. Apply the [ama-metrics-settings-configmap](https://github.com/Azure/prometheus-collector/blob/main/otelcollector/configmaps/ama-metrics-settings-configmap.yaml) to your cluster. Set the `windowsexporter` and `windowskubeproxy` Booleans to `true`. For more information, see [Metrics add-on settings configmap](./prometheus-metrics-scrape-configuration.md#metrics-add-on-settings-configmap).
1. Enable the recording rules that are required for the out-of-the-box dashboards:

   * If onboarding using the CLI, include the option `--enable-windows-recording-rules`.
   * If onboarding using an ARM template, Bicep, or Azure Policy, set `enableWindowsRecordingRules` to `true` in the parameters file.
   * If the cluster is already onboarded, use [this ARM template](https://github.com/Azure/prometheus-collector/blob/main/AddonArmTemplate/WindowsRecordingRuleGroupTemplate/WindowsRecordingRules.json) and [this parameter file](https://github.com/Azure/prometheus-collector/blob/main/AddonArmTemplate/WindowsRecordingRuleGroupTemplate/WindowsRecordingRulesParameters.json) to create the rule groups. This will add the required recording rules and is not an ARM operation on the cluster and does not impact current monitoring state of the cluster.

1. [Only for Windows nodes in ARC-enabled clusters] If you are enabling Managed Prometheus for an ARC-enabled cluster, you can configure Managed Prometheus that is running on a Linux node within the cluster to scrape metrics from endpoints running on the Windows nodes. Add the following scrape job to [ama-metrics-prometheus-config-configmap.yaml](https://aka.ms/ama-metrics-prometheus-config-configmap) and apply the configmap to your cluster.

```yaml
  scrape_configs:
    - job_name: windows-exporter
      scheme: http
      scrape_interval: 30s
      label_limit: 63
      label_name_length_limit: 511
      label_value_length_limit: 1023
      tls_config:
        ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        insecure_skip_verify: true
      bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
      kubernetes_sd_configs:
      - role: node
      relabel_configs:
      - source_labels: [__meta_kubernetes_node_name]
        target_label: instance
      - action: keep
        source_labels: [__meta_kubernetes_node_label_kubernetes_io_os]
        regex: windows
      - source_labels:
        - __address__
        action: replace
        target_label: __address__
        regex: (.+?)(\:\d+)?
        replacement: $$1:9182
```

```AzureCLI
kubectl apply -f ama-metrics-prometheus-config-configmap.yaml
```

## Verify deployment
Use the [kubectl command line tool](/azure/aks/learn/quick-kubernetes-deploy-cli#connect-to-the-cluster) to verify that the agent is deployed properly.

### Managed Prometheus

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


### Container insights

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



## Next steps

* If you experience issues while you attempt to onboard the solution, review the [Troubleshooting guide](container-insights-troubleshoot.md).
* With monitoring enabled to collect health and resource utilization of your AKS cluster and workloads running on them, learn [how to use](container-insights-analyze.md) Container insights.
