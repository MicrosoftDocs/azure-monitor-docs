---
title: Multi-tenant managed logging in Container insights (Preview)
description: 
ms.topic: conceptual
ms.custom: references_regions
ms.date: 02/05/2025
ms.reviewer: viviandiec
---

# Multi-tenant managed logging in Container insights (Preview)

Multi-tenancy capability is useful for customers who operate shared cluster platforms using AKS. You need the ability to configure log collection in a way that segregates log by different teams so that each team has access to the logs of the containers running in k8s namespaces for which they own and ability to get the billing and management associated to the Azure Log analytics workspace.  

For instance, logs from infrastructure k8s namespaces such as kube-system, can be directed to a specific Azure Log Analytics workspace for the Infrastructure team, while each application team's logs can be sent to their respective Azure Log Analytics workspaces. 

This feature supports up to 50k logs/sec/node and if this doesn’t meet your log scale requirements, please reach out through Microsoft support channel. 



- **Multi-tenancy.** Allows the routing of container console (stdout & stderr) logs from one or more Kubernetes namespaces to their respective Azure Log Analytics workspace.  

    :::image type="content" source="media/container-insights-multitenant/multitenancy.png" lightbox="media/container-insights-multitenant/multitenancy.png" alt-text="Diagram that illustrates multitenancy for Container insights." :::

- **Multi-homing:**  Same set of logs from one or more Kubernetes namespaces to multiple Azure Log Analytics workspaces. 

    :::image type="content" source="media/container-insights-multitenant/multihoming.png" lightbox="media/container-insights-multitenant/multihoming.png" alt-text="Diagram that illustrates multihoming for Container insights." :::

Multi-tenancy capability is a common request from customers who operate shared cluster platforms utilizing AKS. These customers need the ability to configure log collection in a way that segregates log by different teams so that each team has access to the logs of the containers running in k8s namespaces for which they own and ability to get the billing and management associated to the Azure Log analytics workspace. 

For instance, logs from infrastructure k8s namespaces such as kube-system, can be directed to a specific Azure Log Analytics workspace for the Infrastructure team, while each application team's logs can be sent to their respective Azure Log Analytics workspaces.
This feature supports up to 50k logs/sec/node and if this doesn’t meet your log scale requirements, please reach out through Microsoft support channel.



## How does it work? 

Container Insights supports the default ContainerInsights Extension DCR, which is a singleton DCR. 

As part of this feature, Container Insights has introduced support for the **ContainerLogV2Extension** DCR, primarily for container logs, with Kubernetes namespaces as data collection settings and  transform KQL filter for advance filtering in the Azure Log Analytics Ingestion Pipeline. Multiple ContainerLogV2Extension DCRs can be created with different data collection settings, ingestion transformation KQL filters and destination, and associated all these DCRs to same AKS cluster. 

When the multi-tenancy feature is enabled through a config map, the Container Insights agent periodically fetches both the default ContainerInsights Extension DCR and the ContainerLogV2Extension DCR (during container startup and every 5 minutes). All configured streams in the ContainerInsights Extension DCR will be ingested into the Azure Log Analytics workspace destination defined in this default DCR as usual, except for container logs. 

The routing and ingestion of container logs operate as follows: 

- The Container Insights agent builds the Kubernetes namespaces to DCR map using the periodically (every 5 minutes) fetched ContainerLogV2Extension DCRs. This map gets periodically updated as new DCRs added or existing DCRs removed to keep the state of the DCRs. 

- For each log entry: 

    - If the Kubernetes namespace of the log entry is in the Kubernetes namespace DCR map, then this log entry will be ingested into all the Azure Log Analytics Workspace destinations specified in the corresponding DCRs. If the DCR has ingestion transformation KQL filter, then KQL filter is applied in the Azure Log Analytics ingestion pipeline.   
    - If the k8s namespace is not in the Kubernetes namespace to DCR map, the log entry will be ingested into the Azure Log Analytics workspace defined in the default ContainerInsights Extension DCR which is default behavior, and this behavior can be disabled through disable_fallback_ingestion config map setting  
    - If the Kubernetes Namespace DCR map has the _ALL_K8S_NAMESPACES_ then all log entries from across all the namespaces will be ingested to the Azure Log Analytics Workspace destinations specified in the corresponding DCRs. This is multi-homing behavior. 

## Prerequisites 

 - An Azure CLI version of 2.63.0 or higher 
- The AKS-preview CLI extension version must be 7.0.0b4 or higher if an AKS-preview CLI extension is installed. 
- The Container Log schema version MUST be v2, i.e., ContainerLogV2 and must be enabled in High log scale mode 
- Cluster meets Firewall requirements - https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-high-scale#network-firewall-requirements 


## Migration steps
If Container Insights is already enabled on your cluster, then disable it with the following command:   

```azurecli
az aks disable-addons -a monitoring -g <clusterRGName> -n <clusterName> 
```

And then proceed onto the onboarding steps.  

If you prefer to use the ARM template disable monitoring, you can refer to this article  https://learn.microsoft.com/en-us/azure/azure-monitor/containers/kubernetes-monitoring-disable#aks-cluster 

## Onboarding steps

1.	Download [ConfigMap](https://raw.githubusercontent.com/microsoft/Docker-Provider/ci_prod/kubernetes/container-azm-ms-agentconfig.yaml) and add below settings to downloaded ConfigMap

    a. Add below setting under agent-settings: |-
         [agent_settings.high_log_scale]
              enabled = true
    b.  Add below setting under [log_collection_settings.multi_tenancy] Under  log-data-collection-settings: |-

### Enable monitoring add-on

### [CLI](#tab/cli)

#### Existing AKS cluster

```azurecli
az aks enable-addons -a monitoring -g <clusterRGName> -n <clusterName> --enable-high-log-scale-mode
```

#### New AKS cluster

```azurecli
az aks create -g <clusterRGName> -n <clusterName> enable-addons -a monitoring --enable-high-log-scale-mode 
```

#### Existing private AKS cluster

```azurecli
az aks enable-addons -a monitoring -g <clusterRGName> -n <clusterName> --enable-high-log-scale-mode --ampls-resource-id <Azure Monitor Private Link Resource Id>
```

#### New private AKS cluster

Refer to [Create a private Azure Kubernetes Service (AKS) cluster](/azure/aks/private-clusters) for details on creating AKS Private cluster and use the additional parameters `--enable-high-scale-mode` and `--ampls-resource-id` to configure high log scale mode with Azure Monitor Private Link Scope Resource ID. The Azure Monitor Private Link Resource Id format will be `/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/microsoft.insights/privatelinkscopes/<resourceName>`.

### [ARM](#tab/arm)

Template: [https://aka.ms/aks-enable-monitoring-msi-onboarding-template-file](https://aka.ms/aks-enable-monitoring-msi-onboarding-template-file)
Parameter: [https://aka.ms/aks-enable-monitoring-msi-onboarding-template-parameter-file](https://aka.ms/aks-enable-monitoring-msi-onboarding-template-parameter-file)


| Parameter Name | Description |
|:---|:---|
| `aksResourceId` | Azure Resource ID of the AKS cluster |
| `aksResourceLocation` | Azure Region of the AKS cluster |
| `workspaceResourceId` | Azure Resource ID of the Azure Log Analytics Workspace |
| `workspaceRegion` | 	Azure Region of the Azure Log Analytics Workspace |
| `enableContainerLogV2` | Flag to indicate whether to use ContainerLogV2 or not. This must be true. |
| `enableSyslog` | Flag to indicate to enable Syslog collection or not. |
| `syslogLevels` | Log levels for Syslog collection |
| `syslogFacilities` | Facilities for Syslog collection |
| `resourceTagValues` | Azure Resource Tags to use on AKS, Azure Monitor Data Collection Rule, and Azure Monitor Data collection endpoint etc. |
| `dataCollectionInterval` | Data collection interval for applicable inventory and perf data collection. Default is 1m. |
| `namespaceFilteringModeForDataCollection` | Data collection namespace filtering mode for applicable inventory and perf data collection. Default is off. |
| `namespacesForDataCollection` | Namespaces for data collection for applicable for inventory and perf data collection. |
| `streams` | Streams for data collection.  For high scale mode, instead of `Microsoft-ContainerLogV2`, use `Microsoft-ContainerLogV2-HighScale`.  Please note, having both `Microsoft-ContainerLogV2` and `Microsoft-ContainerLogV2-HighScale` will cause duplicate logs. |
| `useAzureMonitorPrivateLinkScope` | Flag to indicate whether to configure Azure Monitor Private Link Scope or not.  |
| `azureMonitorPrivateLinkScopeResourceId` | Azure Resource ID of the Azure Monitor Private Link Scope. |


Template: [https://aka.ms/aks-enable-monitoring-multitenancy-onboarding-template-file](https://aka.ms/aks-enable-monitoring-multitenancy-onboarding-template-file)
Parameter: [https://aka.ms/aks-enable-monitoring-multitenancy-onboarding-template-parameter-file](https://aka.ms/aks-enable-monitoring-multitenancy-onboarding-template-parameter-file)

| Parameter Name | Description |
|:---|:---|
| `aksResourceId` | Azure Resource ID of the AKS cluster |
| `aksResourceLocation` | Azure Region of the AKS cluster |
| `workspaceResourceId` | Azure Resource ID of the Azure Log Analytics Workspace |
| `workspaceRegion` | Azure Region of the Azure Log Analytics Workspace  |
| `k8sNamespaces` | List of k8s namespaces for which logs need to be ingested to the Azure Log Analytics Workspace defined in this parameter file |
| `resourceTagValues` | Azure Resource Tags to attach on Azure Monitor Data Collection Rule and Azure Monitor Data Collection Endpoint resources  |
| `transformKql` | KQL filter for advance filtering using ingestion-time transformation. For example, to exclude the logs for specific pod, use `source | where PodName != '<podName>'` which will be applied in Azure Log Analytics Pipeline and this drops all the logs for specified pod.<br>See [Transformations in Azure Monitor](../essentials/data-collection-transformations.md) for details. |
| `useAzureMonitorPrivateLinkScope` | Flag to indicate whether to configure Azure Monitor Private Link Scope or not. |
| `azureMonitorPrivateLinkScopeResourceId` |  Azure Resource ID of the Azure Monitor Private Link Scope. |

---

## QoS Grafana Dashboards

### Prerequisites

- Enable Azure Managed Prometheus using the guidance at [Enable Prometheus and Grafana](./kubernetes-monitoring-enable.md#enable-prometheus-and-grafana).


1. Download the `ama-metrics-prometheus-config-node` ConfigMap at [https://raw.githubusercontent.com/microsoft/Docker-Provider/refs/heads/ci_prod/Documentation/MultiTenancyLogging/BasicMode/ama-metrics-prometheus-config-node.yaml](https://raw.githubusercontent.com/microsoft/Docker-Provider/refs/heads/ci_prod/Documentation/MultiTenancyLogging/BasicMode/ama-metrics-prometheus-config-node.yaml)

2. Use the following command to determine if you already have an existing `ama-metrics-prometheus-config-node` ConfigMap.

    `kubectl get cm -n kube-system | grep ama-metrics-prometheus-config-node`

3. If there is an existing ConfigMap, then you can add the `ama-logs-daemonset` scrape job to the existing ConfigMap. Otherwise, you can apply this ConfigMap with the following command:

    `kubectl apply -f ama-metrics-prometheus-config-node.yaml`

5.	Import the Grafana dashboard JSON file to the Azure Managed Grafana Instance - [https://raw.githubusercontent.com/microsoft/Docker-Provider/refs/heads/ci_prod/Documentation/MultiTenancyLogging/BasicMode/AzureMonitorContainers_BasicMode_Grafana.json](https://raw.githubusercontent.com/microsoft/Docker-Provider/refs/heads/ci_prod/Documentation/MultiTenancyLogging/BasicMode/AzureMonitorContainers_BasicMode_Grafana.json)

5.	Configure the enable_internal_metrics = true in ConfigMap https://github.com/microsoft/Docker-Provider/blob/ci_prod/kubernetes/container-azm-ms-agentconfig.yaml#L218

## Offboarding

Use the following steps to disable the multi-tenancy feature.

1.	Remove the ContainerLogV2 Extension DCR association 

    a. List all the DCR associations.
    
    ```azurecli
    az monitor data-collection rule association list-by-resource --resource /subscriptions/<subId>/resourcegroups/<rgName>/providers/Microsoft.ContainerService/managedClusters/<clusterName>
    ```
    b. Delete all DCR associations for ContainerLogV2 extension.
    
    ```azurecli
    az monitor data-collection rule association delete --association-name <ContainerLogV2ExtensionDCRA> --resource /subscriptions/<subId>/resourcegroups/<rgName>/providers/Microsoft.ContainerService/managedClusters/<clusterName>
    ```
    
    c. Delete the ContainerLogV2Extension DCR.
    
    ```azurecli
    az monitor data-collection rule delete --name <ContainerLogV2Extension DCR> --resource-group <rgName>
    ``````

2. Use the following command to edit `container-azm-ms-agentconfig` and change the value for `enabled` under [log_collection_settings.multi_tenancy] from `true` to `false`.

    ```bash
    kubectl edit cm container-azm-ms-agentconfig -n kube-system -o yaml 
    ```

3.	If you want to disable container insights completely, then you can disable with the following command:

    ```azurecli 
    az aks disable-addons -a monitoring -g  <clusterResourceGroup> -n <clusterName>
    ```

## Next steps


