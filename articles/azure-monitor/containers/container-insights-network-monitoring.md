---
title: Monitor your AKS cluster network with Azure Monitor 
description: Collect metrics and logs for network monitoring from your AKS cluster using Azure Monitor
ms.topic: conceptual
ms.date: 05/21/2025
---

#  Monitor your AKS cluster network with Azure Monitor 

This article describes Azure Monitor features that customers can use for monitoring their AKS cluster network. 


## Collecting network metrics

[Azure Monitor managed service for Prometheus](https://learn.microsoft.com/azure/azure-monitor/metrics/prometheus-metrics-overview#azure-monitor-managed-service-for-prometheus) is Azure's recommended solution to collect metrics from your Azure Kubernetes Service (AKS) clusters. When metrics collection using managed Prometheus is enabled for a cluster, network monitoring metrics are collected by default. By default the metrics collected are at the node level. To collect pod level and other advanced metrics, customers need to enable the _Container Network Observability_ feature. Use the links below to explore more. 

**Managed Prometheus and default networking metrics collected**
* [Enable Managed Prometheus on your cluster](https://learn.microsoft.com/azure/azure-monitor/containers/kubernetes-monitoring-enable?tabs=cli#enable-prometheus-and-grafana)
* Read about the [default configuration in Managed Prometheus](https://learn.microsoft.com/azure/azure-monitor/containers/prometheus-metrics-scrape-default) and [metrics collected by default](https://learn.microsoft.com/azure/azure-monitor/containers/prometheus-metrics-scrape-default#metrics-collected-from-default-targets)

**Container Network Observability** 
* [Learn more about Container Network Observability](https://learn.microsoft.com/azure/aks/container-network-observability-concepts?tabs=cilium)
* [Enable Container Network Observability on your AKS cluster](https://learn.microsoft.com/azure/aks/container-network-observability-how-to?tabs=cilium)



## Collecting network logs


### Intra-cluster logs

To collect logs for network flows within your AKS cluster, customers can use the [Container Network Logs](https://aka.ms/ContainerNetworkLogsDoc) feature of [Advanced Container Networking Services](https://learn.microsoft.com/azure/aks/advanced-container-networking-services-overview). 

To get started with enabling Container Flow Logs, visit: [https://aka.ms/ContainerNetworkLogsDoc](https://aka.ms/ContainerNetworkLogsDoc) 

#### High level data flow

To be added. Roughly: The 

Container Network Logs requires a Customer Resource Definition (CRD) to be applied on the cluster for enabling logging. Once enabled, logs are written by the Cilium operator to the node file system. Theese log files are ingested by the Logs add-on from Container Insights. The Logs-add-on then transmits these logs to a dedicated ingestion endpoint, from where they are processed and stored in the Log Analytics. Once the logs are in Log Analytics, they can accessed and queried as needed.  

:::image type="content" source="./media/container-insights-network-monitoring/container-insights-container-network-logs-data-flow.png" alt-text="Diagram of how container network logs are ingested" lightbox="./media/container-insights-network-monitoring/container-insights-container-network-logs-data-flow.png":::

#### Throttling  

As Container Network Logs captures every flow inside your AKS cluster, the volume of logs generated can be substantial leading to throttling and log loss. See the *[Configure throttling for Container Insights](https://learn.microsoft.com/azure/aks/container-network-observability-concepts?tabs=cilium)* article for guidance on configuring throttling parameters and monitoring for log loss. 


### Cluster egress logs / Outbound flow logs 

To track flows outside your cluster, customers can enable [Virtual network flow logs](https://learn.microsoft.com/azure/network-watcher/vnet-flow-logs-overview?tabs=Americas)
