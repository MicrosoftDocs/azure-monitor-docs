---
title: Monitor your AKS cluster network with Azure Monitor 
description: Collect metrics and logs for network monitoring from your AKS cluster using Azure Monitor
ms.topic: conceptual
ms.date: 05/21/2025
---

#  Monitor your AKS cluster network with Azure Monitor 

This article explains how to monitor your AKS cluster network using Azure Monitor. 


## Collecting metrics

Azure Monitor managed service for Prometheus is Azure's recommended solution to collect metrics from your AKS clusters. Network monitoring metrics are collected by default when a metrics collection is enabled for a cluster. By default the metrics collected are at the node level. To collect pod level and other advanced metrics like DNS, customers need to enable ACNS.

* [Enable Managed Prometheus on your cluster](https://learn.microsoft.com/azure/azure-monitor/containers/kubernetes-monitoring-enable?tabs=cli#enable-prometheus-and-grafana)
* Read about the [default configuration in Managed Prometheus](https://learn.microsoft.com/azure/azure-monitor/containers/prometheus-metrics-scrape-default) and [metrics collected by default](https://learn.microsoft.com/azure/azure-monitor/containers/prometheus-metrics-scrape-default#metrics-collected-from-default-targets)
* [Learn more about Container Network Observability](https://learn.microsoft.com/azure/aks/container-network-observability-concepts?tabs=cilium)
* [Enable Container Network Observability on your AKS cluster](https://learn.microsoft.com/azure/aks/container-network-observability-how-to?tabs=cilium)



## Collecting logs


### Intra-cluster logs

To collect logs for network flows with the AKS cluster, customers can use Container Flow Logs.  For enabling Container Flow Logs, please visit. 

Below we discuss how to monitor throttling of log collection when Container Flow Logs is enabled. 

#### Configures throttling  

Throttling is enabled by default with the values below: 

| ConfigMap setting | Default value | Description |
| --- | --- | --- |
| throttle_enabled | true | By default is true and adjust this to control whether to enable or disable network flow log messages. |
| throttle_rate | 5000 | By default is 5000 and range from 1 to 25,000 and adjust this to control the amount of messages for the time. |
| throttle_window | 300 | By default is 300 and adjust this to control the amount of intervals to calculate average over. |
| throttle_interval | 1s | By default is 1s and adjust this to control time interval, expressed in "sleep" format. e.g 3s, 1.5m, 0.5h etc.. |
| throttle_print | false | By default is false and adjust this to control whether to print status messages with current rate and the limits to information logs. |


To modify the default values, download ConfigMap and modify below settings to downloaded ConfigMap: 

     ```yaml 
      throttle_enabled = true # By default is true and adjust this to control whether to enable or disable network flow log messages. 
      throttle_rate = 5000 # By default is 5000 and range from 1 to 25,000 and adjust this to control the amount of messages for the time. 
      throttle_window = 300 # By default is 300 and adjust this to control the amount of intervals to calculate average over. 
      throttle_interval = "1s" # By default is 1s and adjust this to control time interval, expressed in "sleep" format. e.g 3s, 1.5m, 0.5h etc.. 
      throttle_print = false # By default is false and adjust this to control whether to print status messages with current rate and the limits to information logs. 
     ```
	 
 Apply the configmap via kubectl apply command and you will see pods getting restarted within few minutes.  
 
 ```console
     kubectl apply -f agent_settings.networkflow_logs_config.yaml
     ```

#### Monitor QoS with Grafana dashboards

**Pre-requisite** Enable Azure Managed Prometheus by following the instructions https://learn.microsoft.com/en-us/azure/azure-monitor/containers/kubernetes-monitoring-enable?tabs=cli#enable-prometheus-and-grafana 


 1. Download the ama-metrics-prometheus-config-node ConfigMap 

```console
     curl -LO https://raw.githubusercontent.com/microsoft/Docker-Provider/refs/heads/ci_prod/Documentation/MultiTenancyLogging/BasicMode/ama-metrics-prometheus-config-node.yaml
```

 2. Check if you already have an existing ama-metrics-prometheus-config-node ConfigMap via 
 
```console
kubectl get cm -n kube-system | grep ama-metrics-prometheus-config-node
```

If there is an existing ConfigMap, then you can add the _ama-logs-daemonset scrape_ job to the existing ConfigMap else you can apply this ConfigMap  through 

```console
 kubectl apply -f ama-metrics-prometheus-config-node.yaml 
```

3. Import Grafana dashboard JSON file to the Azure Managed Grafana Instance - raw.githubusercontent.com/microsoft/Docker-Provider/refs/heads/ci_prod/Documentation/NetworkFlowLogging/AzureMonitorContainers_NetworkFlow_Grafana.json 

4. Configure the enable_internal_metrics = true in ConfigMap https://github.com/microsoft/Docker-Provider/blob/ci_prod/kubernetes/container-azm-ms-agentconfig.yaml#L220 

Apply the configmap with: 

```console
kubectl apply -f container-azm-ms-agentconfig.yaml 
```

### Out of cluster logs

To log flow outside your cluster, please enable [Virtual network flow logs](https://learn.microsoft.com/azure/network-watcher/vnet-flow-logs-overview?tabs=Americas)