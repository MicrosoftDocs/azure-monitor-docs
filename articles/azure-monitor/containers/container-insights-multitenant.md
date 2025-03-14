---
title: Multi-tenant managed logging in Container insights (Preview)
description: Concepts and onboarding steps for multi-tenant logging in Container insights.
ms.topic: conceptual
ms.custom: references_regions
ms.date: 02/05/2025
ms.reviewer: viviandiec
---

# Multi-tenant managed logging in Container insights (Preview)

Multi-tenant logging in Container insights is useful for customers who operate shared cluster platforms using AKS. You may need the ability to configure log collection in a way that segregates logs by different teams so that each has access to the logs of the containers running in k8s namespaces that they own and the ability to access the billing and management associated with the Azure Log analytics workspace. For example, logs from infrastructure namespaces such as kube-system can be directed to a specific Log Analytics workspace for the infrastructure team, while each application team's logs can be sent to their respective workspaces. 

This article describes how multi-tenant logging works in Container insights, the scenarios it supports, and how to onboard your cluster to use this feature.


## Scenarios
The multi-tenanct logging feature in Container insights supports the following scenarios:

- **Multi-tenancy.** Sends container logs (stdout & stderr) from each k8s namespaces to their own Log Analytics workspace.  

    :::image type="content" source="media/container-insights-multitenant/multitenancy.png" lightbox="media/container-insights-multitenant/multitenancy.png" alt-text="Diagram that illustrates multitenancy for Container insights." :::

- **Multi-homing:**  Sends the same set of container logs (stdout & stderr) from one or more k8s namespaces to multiple Log Analytics workspaces. 

    :::image type="content" source="media/container-insights-multitenant/multihoming.png" lightbox="media/container-insights-multitenant/multihoming.png" alt-text="Diagram that illustrates multihoming for Container insights." :::

## How it works

Container insights use a [data collection rule (DCR)](../essentials/data-collection-rules-overview.md) to define the data collection settings for your AKS cluster. This DCR is created automatically when you [enable Container insights](./kubernetes-monitoring-enable.md#container-insights).

For multi-tenanct logging, Container Insights adds support for **ContainerLogV2Extension** DCRs, which are used to define collection of container logs for k8s namespaces. Multiple **ContainerLogV2Extension** DCRs can be created with different settings for different namespaces and all associated with the same AKS cluster. 

When you enable the multi-tenancy feature through a ConfigMap, the Container Insights agent periodically fetches both the default DCR and the ContainerLogV2Extension DCR. This fetch is performed every 5 minutes beginning when the container is started. If any additional **ContainerLogV2Extension** DCRs are added, they will be recognized the next time the fetch is performed. All configured streams in the default DCR aside from container logs continue to be sent to the Log Analytics workspace as usual. 

- If there is an extension DCR for the namespace of the log entry, that DCR is used to process the entry. This includes the Log Analytics workspace destination and any ingestion-time transformation.
- If there isn't an extension DCR for the namespace of the log entry, the default DCR is used to process the entry. You can disable this behavior by setting the `disable_fallback_ingestion` setting in the ConfigMap to `true`. In this case, the log entry will not be collected.

## Limitations

This feature supports up to 50k logs/sec/node. If this doesn’t meet your log scale requirements, please reach out through Microsoft support channel. 

## Prerequisites 

- An Azure CLI version of 2.63.0 or higher 
- The AKS-preview CLI extension version must be 7.0.0b4 or higher if an AKS-preview CLI extension is installed. 
- The Container Log schema version  be v2, i.e., ContainerLogV2 and must be enabled in High log scale mode 
- Cluster meets Firewall requirements - https://learn.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-high-scale#network-firewall-requirements 


## Onboarding steps

### Disable Container Insights
If Container Insights is already enabled on your cluster, then you must first [disable it](./kubernetes-monitoring-disable.md) before you can enable the multi-tenancy feature. You can use the following command to disable the monitoring add-on.

```azurecli
az aks disable-addons -a monitoring -g <clusterRGName> -n <clusterName> 
```


### Enable multi-tenancy feature in ConfigMap
Start by enabling high log scale mode and multi-tenancy in the ConfigMap for the cluster. Ths setting will be used when Container insights is enabled.

1. If you don't already have a ConfigMap for Container insights, download the [template ConfigMap YAML file](https://aka.ms/container-azm-ms-agentconfig) and open it in an editor.

2. Enable the high log scale by changing the `enabled` setting in `agent_settings.high_log_scale` as follows:

    ```yaml
    agent-settings: |-
      [agent_settings.high_log_scale]
        enabled = true
    ```
    
3.  Enable multi-tenancy by changing the `enabled` setting in `log_collection_settings.multi_tenancy` as follows. Also set a value for `disable_fallback_ingestion`. If this value is `false` then logs for any Kubernetes namespaces that do not have a corresponding ContainerLogV2 extension DCR will be sent  to the destination configured in the default ContainerInsights Extension DCR. If set to `true`, this behavior is disabled.

    ```yaml
    log-data-collection-settings: |-
        [log_collection_settings]
           [log_collection_settings.multi_tenancy]
            enabled = true 
            disable_fallback_ingestion = false 
    ```

4. Enable collection of internal metrics to populate the Grafana dashboard described below. You can do this by removing the comment character (#) for the lines shown below.

    ```yaml
    [agent_settings.fbit_config]
    #   log_flush_interval_secs = "1"
    #   tail_mem_buf_limit_megabytes = "10"
    #   tail_buf_chunksize_megabytes = "1"
    #   tail_buf_maxsize_megabytes = "1"
      enable_internal_metrics = "true"
    #   tail_ignore_older = "5m"      
    ```

5. Apply the ConfigMap to the cluster with the following commands. 

    ```bash
    kubectl config set-context <cluster-name>
    kubectl apply -f <configmap_yaml_file.yaml>
    ```

### Enable monitoring add-on
Once the ConfigMap for the cluster has been updated, you can enable Container insights by enabling the monitoring add-on. This will use the settings in the ConfigMap to enable high log scale mode and multi-tenancy. For additional onboarding commands, see [Enable Container insights](./kubernetes-monitoring-enable.md#enable-container-insights).

```azurecli
### Existing AKS cluster
az aks enable-addons -a monitoring -g <clusterRGName> -n <clusterName> --enable-high-log-scale-mode

### New AKS cluster
az aks create -g <clusterRGName> -n <clusterName> enable-addons -a monitoring --enable-high-log-scale-mode 

### Existing private AKS Cluster
az aks enable-addons -a monitoring -g <clusterRGName> -n <clusterName> --enable-high-log-scale-mode --ampls-resource-id <Azure Monitor Private Link Resource Id>
```

For a new private AKS cluster, see [Create a private Azure Kubernetes Service (AKS) cluster](/azure/aks/private-clusters?tabs=azure-portal). Use the additional parameters `--enable-high-scale-mode` and `--ampls-resource-id` to configure high log scale mode with Azure Monitor Private Link Scope Resource ID.


### Create default DCR
Once the cluster has been enabled for monitoring with high log scale mode and multi-tenancy, you can create the DCR which enables monitoring for the cluster and serves as the default for any k8s namespaces that don't have a corresponding DCR.

1. Retrieve the following ARM template and parameter file.

    Template file: [https://aka.ms/aks-enable-monitoring-msi-onboarding-template-file](https://aka.ms/aks-enable-monitoring-msi-onboarding-template-file)
    Parameter file: [https://aka.ms/aks-enable-monitoring-msi-onboarding-template-parameter-file](https://aka.ms/aks-enable-monitoring-msi-onboarding-template-parameter-file)

2. Edit the parameter file with values for the following parameters. 

    | Parameter Name | Description |
    |:---|:---|
    | `aksResourceId` | Azure Resource ID of the AKS cluster |
    | `aksResourceLocation` | Azure Region of the AKS cluster |
    | `workspaceResourceId` | Azure Resource ID of the Azure Log Analytics Workspace |
    | `workspaceRegion` | 	Azure Region of the Azure Log Analytics Workspace |
    | `enableContainerLogV2` | Indicates whether to use ContainerLogV2. Must be `true`. |
    | `enableSyslog` | Indicates whether enable Syslog collection or not. |
    | `syslogLevels` | Syslog log levels to collect. |
    | `syslogFacilities` | Syslog facilities to collect. |
    | `resourceTagValues` | Azure Resource Tags to use on AKS, data collection rule (DCR), and data collection endpoint (DCE). |
    | `dataCollectionInterval` | Data collection interval for applicable inventory and perf data collection. Default is 1m. |
    | `namespaceFilteringModeForDataCollection` | Data collection namespace filtering mode for applicable inventory and performance data collection. Default is `Off`. |
    | `namespacesForDataCollection` | Namespaces for data collection for applicable for inventory and perf data collection. |
    | `streams` | Streams for data collection.  For high scale mode, use `Microsoft-ContainerLogV2-HighScale` instead of `Microsoft-ContainerLogV2`.  Ensure that you don't have both streams, or you'll cause duplicate logs. |
    | `useAzureMonitorPrivateLinkScope` | Indicates whether to configure Azure Monitor Private Link Scope.  |
    | `azureMonitorPrivateLinkScopeResourceId` | Azure Resource ID of the Azure Monitor Private Link Scope. |

3. Deploy the template using the parameter file with the following command. 

    ```azurecli
    az deployment group create --name AzureMonitorDeployment --resource-group <aksClusterResourceGroup> --template-file  aks-enable-monitoring-msi-onboarding-template-file --parameters aks-enable-monitoring-msi-onboarding-template-parameter-file
    ```

### Create DCR for each application or infrastructure team
Repeat the following steps to create a separate DCR for application or infrastructure team. Each will include a set of k8s namespaces and a Log Analytics workspace destination.

1. Retrieve the following ARM template and parameter file.

    Template: [https://aka.ms/aks-enable-monitoring-multitenancy-onboarding-template-file](https://aka.ms/aks-enable-monitoring-multitenancy-onboarding-template-file)
    Parameter: [https://aka.ms/aks-enable-monitoring-multitenancy-onboarding-template-parameter-file](https://aka.ms/aks-enable-monitoring-multitenancy-onboarding-template-parameter-file)

2. Edit the parameter file with values for the following parameters. 

    | Parameter Name | Description |
    |:---|:---|
    | `aksResourceId` | Azure Resource ID of the AKS cluster |
    | `aksResourceLocation` | Azure Region of the AKS cluster |
    | `workspaceResourceId` | Azure Resource ID of the Log Analytics workspace |
    | `workspaceRegion` | Azure Region of the Log Analytics workspace  |
    | `k8sNamespaces` | List of k8s namespaces for logs to be sent to the Log Analytics workspace defined in this parameter file. |
    | `resourceTagValues` | Azure Resource Tags to use on AKS, data collection rule (DCR), and data collection endpoint (DCE). |
    | `transformKql` | KQL filter for advance filtering using ingestion-time transformation. For example, to exclude the logs for a specific pod, use `source | where PodName != '<podName>'`. See [Transformations in Azure Monitor](../essentials/data-collection-transformations.md) for details. |
    | `useAzureMonitorPrivateLinkScope` | Indicates whether to configure Azure Monitor Private Link Scope. |
    | `azureMonitorPrivateLinkScopeResourceId` |  Azure Resource ID of the Azure Monitor Private Link Scope. |
    
3. Deploy the template using the parameter file with the following command. 

    ```azurecli
    az deployment group create --name AzureMonitorDeployment --resource-group <aksClusterResourceGroup> --template-file  template-file  aks-enable-monitoring-multitenancy-onboarding-template-file --parameters aks-enable-monitoring-multitenancy-onboarding-template-parameter-file
    ```

## QoS Grafana Dashboards
The QoS Grafana dashboard reports on the health and performance of your multi-tenancy clusters. 

1. Ensure that Azure Managed Prometheus and Azure Managed Grafana are enabled for the cluster using the guidance at  [Enable Prometheus and Grafana](./kubernetes-monitoring-enable.md#enable-prometheus-and-grafana). 

3. Download the [`ama-metrics-prometheus-config-node` ConfigMap](https://raw.githubusercontent.com/microsoft/Docker-Provider/refs/heads/ci_prod/Documentation/MultiTenancyLogging/BasicMode/ama-metrics-prometheus-config-node.yaml).

4. Use the following command to determine if you already have an existing `ama-metrics-prometheus-config-node` ConfigMap.

    `kubectl get cm -n kube-system | grep ama-metrics-prometheus-config-node`

5. If you have an existing ConfigMap, then add the `ama-logs-daemonset` scrape config from the downloaded ConfigMap to the existing one.

6. Apply either the downloaded or updated ConfigMap with the following command:

    `kubectl apply -f ama-metrics-prometheus-config-node.yaml`

5.	Download the [Grafana dashboard JSON file](https://raw.githubusercontent.com/microsoft/Docker-Provider/refs/heads/ci_prod/Documentation/MultiTenancyLogging/BasicMode/AzureMonitorContainers_BasicMode_Grafana.json) and import into to the Azure Managed Grafana Instance.



## Disabling multi-tenanct logging

Use the following steps to disable multi-tenant logging on a cluster.

> [!NOTE]
> See [Disable monitoring of your Kubernetes cluster](./kubernetes-monitoring-disable.md) if you want to completely disable Container insights for the cluster.

1. Use the following command to list all the DCR associations for the cluster.
    
    ```azurecli
    az monitor data-collection rule association list-by-resource --resource /subscriptions/<subId>/resourcegroups/<rgName>/providers/Microsoft.ContainerService/managedClusters/<clusterName>
    ```

2. Use the following command to delete all DCR associations for ContainerLogV2 extension.
    
    ```azurecli
    az monitor data-collection rule association delete --association-name <ContainerLogV2ExtensionDCRA> --resource /subscriptions/<subId>/resourcegroups/<rgName>/providers/Microsoft.ContainerService/managedClusters/<clusterName>
    ```
    
3. Delete the ContainerLogV2Extension DCR.
    
    ```azurecli
    az monitor data-collection rule delete --name <ContainerLogV2Extension DCR> --resource-group <rgName>
    ``````

4. Edit `container-azm-ms-agentconfig` and change the value for `enabled` under `[log_collection_settings.multi_tenancy]` from `true` to `false`.

    ```bash
    kubectl edit cm container-azm-ms-agentconfig -n kube-system -o yaml 
    ```


## Network and Firewall requirements
In addition to the requirements described in [Network firewall requirements for monitoring Kubernetes cluster](./kubernetes-monitoring-firewall.md), multi-tenancy requires access for the logs ingestion endpoint to port 443. Retrieve this from the **Overview** page of the data collectiong endpoint (DCE) resource in the Azure portal. The endpoint should be in the format `<data-collection-endpoint>-<suffix>.<cluster-region-name>-<suffix>.ingest.monitor.azure.com`.

:::image type="content" source="media/container-insights-multitenant/logs-ingestion-endpoint.png" lightbox="media/container-insights-multitenant/logs-ingestion-endpoint.png" alt-text="Screenshot to show the logs ingestion endpoint retrieved from the overview page for the DCE." :::


## Next steps


