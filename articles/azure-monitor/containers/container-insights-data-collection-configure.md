---
title: Customize data collection in Container insights
description: Details on configuring data collection in Azure Monitor Container insights after you enable it on your Kubernetes cluster.
ms.topic: how-to
ms.date: 08/29/2025
ms.reviewer: aul
---

# Customize data collection in Container insights

When you enable Container insights to collect Prometheus metrics and container logs from your Kubernetes cluster, it starts with a default configuration. You have some options using standard configuration methods to customize this collection such as [selecting a logging profile](./kubernetes-monitoring-enable-portal.md#container-log-options). This article describes advanced configuration options that allow you to further tailor data collection for monitoring your Kubernetes cluster to match your particular requirements.

## Concepts
There are two configuration methods for Container insights that work together to define your metric and log data collection. When you enable monitoring using the guidance in [Enable monitoring on your Kubernetes cluster with Azure Monitor](./kubernetes-monitoring-enable.md), both of these methods are being configured, although you aren't working with them directly. By understanding what aspects of the collection that each define and how to customize them, you can tailor your data collection to meet your exact needs. The two methods are described in the table below with detailed information in the following sections.

| Method | Description |
|:---|:---| 
| [ConfigMap](#configure-data-collection-using-configmap) | [ConfigMaps](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/) are a Kubernetes mechanism that allows you to store non-confidential data such as a configuration file or environment variables. Container insights provides different ConfigMaps that, when applied to your Kubernetes cluster, define the data that the agent will collect from your cluster and send to Azure Monitor. |
| [Data collection rule (DCR)](#configure-data-collection-using-dcr) | [Data collection rules](../essentials/data-collection-rule-overview.md) are sets of instructions supporting data collection in Azure Monitor. They define where data from your cluster is sent and potentially filters and modifies the format of that. Two DCRs are created for your cluster when you enable Container insights, one for Prometheus metrics and the other for log collection. By modifying these . | 

The following diagram illustrates how these two configuration methods work together to define the data collection from a cluster. ConfigMaps define the data that the agent collects from your cluster and delivers to Azure Monitor. The DCRs define how Azure Monitor processes that data once its received.

:::image type="content" source="media/container-insights-data-collection-configure/custom-data-collection.png" alt-text="Diagram showing how ConfigMap and DCRs work together for custom data collection from Kubernetes." lightbox="media/container-insights-data-collection-configure/custom-data-collection.png" :::

**Prometheus metrics**

| Configuration Method | Defines |
|:---|:---|
| ConfigMap |  |
| DCR |  |

**Container logs**

| Configuration Method | Reference |
|:---|:---|
| ConfigMap | What container logs are collected from the cluster. |
| DCR | Where the collected container logs are sent in Azure Monitor. |



### Configure and deploy ConfigMap

Use the following procedure to configure and deploy your ConfigMap configuration file to your cluster:


1. Apply the ConfiigMap to the cluster by running the following kubectl command: 

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


## Container insights DCRs

When you enable monitoring, the following resources are created in your subscription. 

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


## Share DCR with multiple clusters
When you enable Container insights on a Kubernetes cluster, a new DCR is created for that cluster, and the DCR for each cluster can be modified independently. If you have multiple clusters with custom monitoring configurations, you may want to share a single DCR with multiple clusters. You can then make changes to a single DCR that are automatically implemented for any clusters associated with it.

A DCR is associated with a cluster with a [data collection rule associates (DCRA)](../essentials/data-collection-rule-overview.md#data-collection-rule-associations-dcra). Use the [preview DCR experience](../essentials/data-collection-rule-view.md#preview-dcr-experience) to view and remove existing DCR associations for each cluster. You can then use this feature to add an association to a single DCR for multiple clusters.

## Configure data collection using DCR
The DCR created by Container insights is named *MSCI-\<cluster-region\>-\<cluster-name\>*. You can [view this DCR](../essentials/data-collection-rule-view.md) along with others in your subscription, and you can edit it using methods described in [Create and edit data collection rules (DCRs) in Azure Monitor](../essentials/data-collection-rule-create-edit.md). While you can directly modify the DCR for particular customizations, you can perform most required configuration using the methods described below. See [Data transformations in Container insights](./container-insights-transformations.md) for details on editing the DCR directly for more advanced configurations.

> [!IMPORTANT]
> AKS clusters must use either a system-assigned or user-assigned managed identity. If cluster is using a service principal, you must update the cluster to use a [system-assigned managed identity](/azure/aks/use-managed-identity#update-an-existing-aks-cluster-to-use-a-system-assigned-managed-identity) or a [user-assigned managed identity](/azure/aks/use-managed-identity#update-an-existing-cluster-to-use-a-user-assigned-managed-identity).


## Next steps

- See [Filter log collection in Container insights](./container-insights-data-collection-filter.md) for details on saving costs by configuring Container insights to filter data that you don't require.

