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

To be added. Roughly: CRD -> NetObs add-on -> Log files on node -> Container Insights add-on aka ama-logs pods -> LA endpoint -> Log Analytics backend 

:::image type="content" source="./media/container-insights-network-monitoring/container-insights-container-network-logs-data-flow.png" alt-text="Diagram of how container network logs are ingested" lightbox="./media/container-insights-network-monitoring/container-insights-container-network-logs-data-flow.png":::

#### Throttling  

As Container Network Logs captures every flow inside your AKS cluster, the volume of logs generated can be very high leading to throttling and log loss. In this section, we cover the default throttling limits and how you can modify them. The next section covers how you can monitor for potential throttling issues with our Quality-of-Service (QoS) Grafana dashboard.

Throttling is enabled by default with the values below: 

| ConfigMap setting | Default value | Description |
| --- | --- | --- |
| throttle_enabled | true | By default is true and adjust this value to control whether to enable or disable network flow log messages. |
| throttle_rate | 5000 | By default is 5000 and range from 1 to 25,000 and adjust this value to control the number of log records during a time window. |
| throttle_window | 300 | By default is 300 and adjust this value to control the number of intervals to calculate average over. |
| throttle_interval | 1s | By default is 1s and adjust this value to control time interval, expressed in "sleep" format. Examples: 3s, 1.5m, 0.5h etc. |
| throttle_print | false | By default is false and adjust this value to control whether to print status messages with current rate and the limits to information logs. |


To modify the default values, download ConfigMap and modify below settings to downloaded ConfigMap: 

```yaml 
throttle_enabled = true # By default is true and adjust this value to control whether to enable or disable network flow log messages. 
throttle_rate = 5000 # By default is 5000 and range from 1 to 25,000 and adjust this value to control the amount of messages for the time. 
throttle_window = 300 # By default is 300 and adjust this value to control the amount of intervals to calculate average over. 
throttle_interval = "1s" # By default is 1s and adjust this value to control time interval, expressed in "sleep" format. Examples: 3s, 1.5m, 0.5h etc. 
throttle_print = false # By default is false and adjust this value to control whether to print status messages with current rate and the limits to information logs. 
```
	 
Once you apply the configmap via kubectl apply command, the pods shall get restarted within a few minutes.  
 
 ```console
     kubectl apply -f agent_settings.networkflow_logs_config.yaml
 ```

#### Monitor QoS with Prometheus and Grafana 

The Logs add-on that collects Container Network logs publishes QoS metrics that can be used to monitor for throttling and log loss. In this section, we cover how can customers can use Azure Monitor managed service for Prometheus to collect these metrics and then visualize them with Grafana.   

**Pre-requisites** 

* [Azure Monitor managed service for Prometheus](https://learn.microsoft.com/azure/azure-monitor/metrics/prometheus-metrics-overview#azure-monitor-managed-service-for-prometheus): The QoS metrics generated are sent to the managed Prometheus service. Enable by following the [these instructions](https://learn.microsoft.com/azure/azure-monitor/containers/kubernetes-monitoring-enable?tabs=cli#enable-prometheus-and-grafana)
* A Grafana instance to import the dashboard. This Grafana instance can be an instance of [Azure managed Grafana](https://learn.microsoft.com/azure/managed-grafana/overview), [Azure Monitor Dashboards with Grafana](https://learn.microsoft.com/azure/azure-monitor/visualize/visualize-use-grafana-dashboards) or any other Grafana instance linked with the Prometheus service mentioned previously.  

**Configuration steps** 


 1. Download the ama-metrics-prometheus-config-node ConfigMap 

```console
     curl -LO https://aka.ms/ama-metrics-prometheus-config-node
```

 2. Check if you already have an existing ama-metrics-prometheus-config-node ConfigMap via 
 
```console
kubectl get cm -n kube-system | grep ama-metrics-prometheus-config-node
```

If there's an existing ConfigMap, then you can add the _ama-logs-daemonset scrape_ job to the existing ConfigMap else you can apply this ConfigMap  through 

```console
 kubectl apply -f ama-metrics-prometheus-config-node.yaml 
```

3. Import (Grafana dashboard JSON file)[https://aka.ms/AzureMonitorContainers_NetworkFlow_Grafana] to the Azure Managed Grafana Instance 

4. Configure the enable_internal_metrics = true in ConfigMap https://github.com/microsoft/Docker-Provider/blob/ci_prod/kubernetes/container-azm-ms-agentconfig.yaml#L220 

Apply the configmap with: 

```console
kubectl apply -f container-azm-ms-agentconfig.yaml 
```

**Final dashboard** 

:::image type="content" source="./media/container-insights-network-monitoring/container-insights-network-qos-grafana-dashboard.png" alt-text="Image showing the final result setting up QoS monitoring for Container Insights" lightbox="./media/container-insights-network-monitoring/container-insights-network-qos-grafana-dashboard.png":::


### Cluster egress logs / Outbound flow logs 

To track flows outside your cluster, customers can enable [Virtual network flow logs](https://learn.microsoft.com/azure/network-watcher/vnet-flow-logs-overview?tabs=Americas)
