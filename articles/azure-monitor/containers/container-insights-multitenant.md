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
- **Multi-homing:**  Same set of logs from one or more Kubernetes namespaces to multiple Azure Log Analytics workspaces. 


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


## Next steps


