---
title: Configure Container insights data collection
description: Details on configuring data collection in Azure Monitor Container insights after you enable it on your Kubernetes cluster.
ms.topic: how-to
ms.date: 05/14/2024
ms.reviewer: aul
---

# Configure log collection in Container insights

This article provides details on how to configure data collection in [Container insights](./container-insights-overview.md) for your Kubernetes cluster once it's been onboarded. For guidance on enabling Container insights on your cluster, see [Enable monitoring for Kubernetes clusters](./kubernetes-monitoring-enable.md).

## Configuration methods
There are two methods use to configure and filter data being collected in Container insights. Depending on the setting, you may be able to choose between the two methods or you may be required to use one or the other. The two methods are described in the table below with detailed information in the following sections.

| Method | Description |
|:---|:---| 
| [Data collection rule (DCR)](#configure-data-collection-using-dcr) | [Data collection rules](../essentials/data-collection-rule-overview.md) are sets of instructions supporting data collection using the [Azure Monitor pipeline](../essentials/pipeline-overview.md). A DCR is created when you enable Container insights, and you can modify the settings in this DCR either using the Azure portal or other methods. | 
| [ConfigMap](#configure-data-collection-using-configmap) | [ConfigMaps](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/) are a Kubernetes mechanism that allows you to store non-confidential data such as a configuration file or environment variables. Container insights looks for a ConfigMap on each cluster with particular settings that define data that it should collect.|

## Configure data collection using DCR
The DCR created by Container insights is named *MSCI-\<cluster-region\>-\<cluster-name\>*. You can [view this DCR](../essentials/data-collection-rule-view.md) along with others in your subscription, and you can edit it using methods described in [Create and edit data collection rules (DCRs) in Azure Monitor](../essentials/data-collection-rule-create-edit.md). While you can directly modify the DCR for particular customizations, you can perform most required configuration using the methods described below. See [Data transformations in Container insights](./container-insights-transformations.md) for details on editing the DCR directly for more advanced configurations.

> [!IMPORTANT]
> AKS clusters must use either a system-assigned or user-assigned managed identity. If cluster is using a service principal, you must update the cluster to use a [system-assigned managed identity](/azure/aks/use-managed-identity#update-an-existing-aks-cluster-to-use-a-system-assigned-managed-identity) or a [user-assigned managed identity](/azure/aks/use-managed-identity#update-an-existing-cluster-to-use-a-user-assigned-managed-identity).




### [CLI](#tab/cli)

### Configure DCR with CLI



### AKS cluster

>[!IMPORTANT]
> In the commands in this section, when deploying on a Windows machine, the dataCollectionSettings field must be escaped. For example, dataCollectionSettings={\"interval\":\"1m\",\"namespaceFilteringMode\": \"Include\", \"namespaces\": [ \"kube-system\"]} instead of dataCollectionSettings='{"interval":"1m","namespaceFilteringMode": "Include", "namespaces": [ "kube-system"]}'




#### Existing AKS cluster


**Cluster with an existing monitoring addon**


### Arc-enabled Kubernetes cluster


### AKS hybrid cluster
Use the following command to add monitoring to an existing AKS hybrid cluster.

```azcli
az k8s-extension create --name azuremonitor-containers --cluster-name <cluster-name> --resource-group <resource-group> --cluster-type provisionedclusters --cluster-resource-provider "microsoft.hybridcontainerservice" --extension-type Microsoft.AzureMonitor.Containers --configuration-settings amalogs.useAADAuth=true dataCollectionSettings='{"interval":"1m","namespaceFilteringMode":"Include", "namespaces": ["kube-system"],"enableContainerLogV2": true,"streams": ["<streams to be collected>"]}'
```


### [ARM](#tab/arm)

### Configure DCR with ARM templates

The following template and parameter files are available for different cluster configurations.

**AKS cluster**
- Template: https://aka.ms/aks-enable-monitoring-costopt-onboarding-template-file
- Parameter: https://aka.ms/aks-enable-monitoring-costopt-onboarding-template-parameter-file 

**Arc-enabled Kubernetes**
- Template: https://aka.ms/arc-k8s-enable-monitoring-costopt-onboarding-template-file
- Parameter: https://aka.ms/arc-k8s-enable-monitoring-costopt-onboarding-template-parameter-file

**AKS hybrid cluster**
- Template: https://aka.ms/existingClusterOnboarding.json
- Parameter: https://aka.ms/existingClusterParam.json


---

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






## Share DCR with multiple clusters
When you enable Container insights on a Kubernetes cluster, a new DCR is created for that cluster, and the DCR for each cluster can be modified independently. If you have multiple clusters with custom monitoring configurations, you may want to share a single DCR with multiple clusters. You can then make changes to a single DCR that are automatically implemented for any clusters associated with it.

A DCR is associated with a cluster with a [data collection rule associates (DCRA)](../essentials/data-collection-rule-overview.md#data-collection-rule-associations-dcra). Use the [preview DCR experience](../essentials/data-collection-rule-view.md#preview-dcr-experience) to view and remove existing DCR associations for each cluster. You can then use this feature to add an association to a single DCR for multiple clusters.

## Configure data collection using ConfigMap

[ConfigMaps](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/) are a Kubernetes mechanism that allow you to store non-confidential data such as a configuration file or environment variables. Container insights looks for a ConfigMap on each cluster with particular settings that define data that it should collect. 

> [!IMPORTANT]
> ConfigMap is a global list and there can be only one ConfigMap applied to the agent for Container insights. Applying another ConfigMap will overrule the previous ConfigMap collection settings.

### Prerequisites 
- The minimum agent version supported to collect stdout, stderr, and environmental variables from container workloads is **ciprod06142019** or later. 

### Configure and deploy ConfigMap

Use the following procedure to configure and deploy your ConfigMap configuration file to your cluster:

1. If you don't already have a ConfigMap for Container insights, download the [template ConfigMap YAML file](https://aka.ms/container-azm-ms-agentconfig) and open it in an editor.

1. Edit the ConfigMap YAML file with your customizations. The template includes all valid settings with descriptions. To enable a setting, remove the comment character (#) and set its value. 

1. Create a ConfigMap by running the following kubectl command: 

    ```azurecli
    kubectl config set-context <cluster-name>
    kubectl apply -f <configmap_yaml_file.yaml>
    
    # Example: 
    kubectl config set-context my-cluster
    kubectl apply -f container-azm-ms-agentconfig.yaml
    ```


    The configuration change can take a few minutes to finish before taking effect. Then all Azure Monitor Agent pods in the cluster will restart. The restart is a rolling restart for all Azure Monitor Agent pods, so not all of them restart at the same time. When the restarts are finished, you'll receive a message similar to the following result: 
    
    ```output
    configmap "container-azm-ms-agentconfig" created`.
    ```

### Verify configuration

To verify the configuration was successfully applied to a cluster, use the following command to review the logs from an agent pod.

```azurecli
kubectl logs ama-logs-fdf58 -n kube-system -c ama-logs
```

If there are configuration errors from the Azure Monitor Agent pods, the output will show errors similar to the following:

```output 
***************Start Config Processing******************** 
config::unsupported/missing config schema version - 'v21' , using defaults
```

Use the following options to perform more troubleshooting of configuration changes:

- Use the same `kubectl logs` command from an agent pod.
- Review live logs for errors similar to the following:

    ```
    config::error::Exception while parsing config map for log collection/env variable settings: \nparse error on value \"$\" ($end), using defaults, please check config map for errors
    ```

- Data is sent to the `KubeMonAgentEvents` table in your Log Analytics workspace every hour with error severity for configuration errors. If there are no errors, the entry in the table will have data with severity info, which reports no errors. The `Tags` column contains more information about the pod and container ID on which the error occurred and also the first occurrence, last occurrence, and count in the last hour.

### Verify schema version

Supported config schema versions are available as pod annotation (schema-versions) on the Azure Monitor Agent pod. You can see them with the following kubectl command. 

```bash
kubectl describe pod ama-logs-fdf58 -n=kube-system.
```


## ConfigMap settings

The following table describes the settings you can configure to control data collection with ConfigMap.


| Setting | Data type | Value | Description |
|:---|:---|:---|:---|
| `schema-version` | String (case sensitive) | v1 | Used by the agent when parsing this ConfigMap. Currently supported schema-version is v1. Modifying this value isn't supported and will be rejected when the ConfigMap is evaluated. |
| `config-version` | String |  | Allows you to keep track of this config file's version in your source control system/repository. Maximum allowed characters are 10, and all other characters are truncated. |
| **[log_collection_settings]** | | | |
| `[stdout]`<br>`enabled` | Boolean | true<br>false | Controls whether stdout container log collection is enabled. When set to `true` and no namespaces are excluded for stdout log collection, stdout logs will be collected from all containers across all pods and nodes in the cluster. If not specified in the ConfigMap, the default value is `true`. |
| `[stdout]`<br>`exclude_namespaces` | String | Comma-separated array | Array of Kubernetes namespaces for which stdout logs won't be collected. This setting is effective only if `enabled` is set to `true`. If not specified in the ConfigMap, the default value is<br> `["kube-system","gatekeeper-system"]`. |
| `[stderr]`<br>`enabled` | Boolean | true<br>false | Controls whether stderr container log collection is enabled. When set to `true` and no namespaces are excluded for stderr log collection, stderr logs will be collected from all containers across all pods and nodes in the cluster. If not specified in the ConfigMap, the default value is `true`. |
| `[stderr]`<br>`exclude_namespaces` | String | Comma-separated array | Array of Kubernetes namespaces for which stderr logs won't be collected. This setting is effective only if `enabled` is set to `true`. If not specified in the ConfigMap, the default value is<br> `["kube-system","gatekeeper-system"]`. |
| `[env_var]`<br>`enabled` | Boolean | true<br>false | Controls environment variable collection across all pods and nodes in the cluster. If not specified in the ConfigMap, the default value is `true`.  |
| `[enrich_container_logs]`<br>`enabled` | Boolean | true<br>false | Controls container log enrichment to populate the `Name` and `Image` property values for every log record written to the **ContainerLog** table for all container logs in the cluster. If not specified in the ConfigMap, the default value is `false`. |
| `[collect_all_kube_events]`<br>`enabled` | Boolean | true<br>false| Controls whether Kube events of all types are collected. By default, the Kube events with type **Normal** aren't collected. When this setting is `true`, the **Normal** events are no longer filtered, and all events are collected. If not specified in the ConfigMap, the default value is `false`. |
| `[schema]`<br>`containerlog_schema_version` | String (case sensitive) | v2<br>v1 | Sets the log ingestion format. If `v2`, the **ContainerLogV2** table is used. If `v1`, the **ContainerLog** table is used (this table has been deprecated). For clusters enabling container insights using Azure CLI version 2.54.0 or greater, the default setting is `v2`. See [Container insights log schema](./container-insights-logs-schema.md) for details. |
| `[enable_multiline_logs]`<br>`enabled` | Boolean | true<br>false | Controls whether multiline container logs are enabled. See [Multi-line logging in Container Insights](./container-insights-logs-schema.md#multi-line-logging) for details. If not specified in the ConfigMap, the default value is `false`. This requires the `schema` setting to be `v2`. |
| `[metadata_collection]`<br>`enabled` | Boolean | true<br>false | Controls whether metadata is collected in the `KubernetesMetadata` column of the `ContainerLogV2` table. |
| `[metadata_collection]`<br>`include_fields` | String | Comma-separated array | List of metadata fields to include. If the setting isn't used then all fields are collected. Valid values are  `["podLabels","podAnnotations","podUid","image","imageID","imageRepo","imageTag"]` |
| `[log_collection_settings.multi_tenancy]`<br>`enabled` | Boolean | true<br>false | Controls whether multi-tenancy is enabled. See  [Multi-tenant managed logging](./container-insights-multitenant.md) for details. If not specified in the ConfigMap, the default value is `false`. |
| **[metric_collection_settings]** | | | |
| `[collect_kube_system_pv_metrics]`<br>`enabled` | Boolean | true<br>false | Allows persistent volume (PV) usage metrics to be collected in the kube-system namespace. By default, usage metrics for persistent volumes with persistent volume claims in the kube-system namespace aren't collected. When this setting is set to `true`, PV usage metrics for all namespaces are collected. If not specified in the ConfigMap, the default value is `false`. |
| **[agent_settings]** | | | |
| `[proxy_config]`<br>`ignore_proxy_settings` | Boolean | true<br>false | When `true`, proxy settings are ignored. For both AKS and Arc-enabled Kubernetes environments, if your cluster is configured with forward proxy, then proxy settings are automatically applied and used for the agent. For certain configurations, such as with AMPLS + Proxy, you might want the proxy configuration to be ignored. If not specified in the ConfigMap, the default value is `false`. |
| **[agent_settings.fbit_config]** | | | |
| `enable_internal_metrics` | Boolean | true<br>false | Controls whether collection of internal metrics are enabled. If not specified in the ConfigMap, the default value is `false`. |


## Next steps

- See [Filter log collection in Container insights](./container-insights-data-collection-filter.md) for details on saving costs by configuring Container insights to filter data that you don't require.

