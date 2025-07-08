---
title: Monitor your AKS cluster network with Azure Monitor 
description: Collect metrics and logs for network monitoring from your AKS cluster using Azure Monitor
ms.topic: how-to
ms.date: 05/21/2025
---

#  Monitor your AKS cluster network with Azure Monitor 

This article describes Azure Monitor features that customers can use for monitoring their AKS cluster network. 


## Collecting network metrics

[Azure Monitor managed service for Prometheus](https://learn.microsoft.com/azure/azure-monitor/metrics/prometheus-metrics-overview#azure-monitor-managed-service-for-prometheus) is Azure's recommended solution to collect metrics from your Azure Kubernetes Service (AKS) clusters. When metrics collection using managed Prometheus is enabled for a cluster, network monitoring metrics are collected by default. By default the metrics collected are at the node level. To collect pod level and other advanced metrics, customers need to enable the _Container Network Observability_ feature. Use the links following to explore more. 

**Managed Prometheus and default networking metrics collected**
* [Enable Managed Prometheus on your cluster](https://learn.microsoft.com/azure/azure-monitor/containers/kubernetes-monitoring-enable?tabs=cli#enable-prometheus-and-grafana)
* Read about the [default configuration in Managed Prometheus](https://learn.microsoft.com/azure/azure-monitor/containers/prometheus-metrics-scrape-default) and [metrics collected by default](https://learn.microsoft.com/azure/azure-monitor/containers/prometheus-metrics-scrape-default#metrics-collected-from-default-targets)

**Container Network Observability** 
* [Learn more about Container Network Observability](/azure/aks/container-network-observability-guide)
* [Enable Container Network Observability on your AKS cluster](https://learn.microsoft.com/azure/aks/container-network-observability-how-to?tabs=cilium)



## Collecting network logs


### Intra-cluster logs

To collect logs for network flows within your AKS cluster, customers can use the [Container Network Logs](https://aka.ms/ContainerNetworkLogsDoc) feature of [Advanced Container Networking Services](https://learn.microsoft.com/azure/aks/advanced-container-networking-services-overview). 

#### Onboarding to Container Network Logs

Onboarding steps by method are listed below. For the onboarding options for Container Insights, see the *[Enable Container insights](https://learn.microsoft.com/azure/azure-monitor/containers/kubernetes-monitoring-enable?tabs=cli#enable-container-insights)* article. 

##### [CLI](#tab/cli)

See the *[Set up Container Network Logs with Advanced Container Networking Services](https://learn.microsoft.com/azure/aks/how-to-configure-container-network-logs?tabs=cilium)* article for a tutorial on enabling Container Flow logs, which also covers pre-requisities and limitations. 


##### [Azure Resource Manager](#tab/arm)

> [!NOTE]
> Before proceeding, ensure your cluster meets the prerequisites mentioned in the *[Set up Container Network Logs with Advanced Container Networking Services](https://learn.microsoft.com/azure/aks/how-to-configure-container-network-logs?tabs=cilium)* article. 


1. Download the setup files:

* ARM Template: [https://aka.ms/aks-enable-monitoring-msi-onboarding-template-file](https://aka.ms/aks-enable-monitoring-msi-onboarding-template-file)
* Parameter file: [https://aka.ms/aks-enable-monitoring-msi-onboarding-template-parameter-file](https://aka.ms/aks-enable-monitoring-msi-onboarding-template-parameter-file) 

2. Use the table to configure the parameters

| Parameter Name                          |  Description                                                                                                           |
| --------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| aksResourceId                           | Azure Resource ID of the AKS cluster                                                                                   |
| aksResourceLocation                     | Azure Region of the AKS cluster                                                                                        |
| workspaceResourceId                     | Azure Resource ID of the Azure Log Analytics Workspace                                                                 |
| workspaceRegion                         | Azure Region of the Azure Log Analytics Workspace                                                                      |
| enableContainerLogV2                    | Flag to indicate whether to use ContainerLogV2 or not.                                                                 |
| enableRetinaNetworkFlowLogs             | Flag to indicate whether to enable Retina Network Flow Logs or not. This MUST be true                                  |
| enableSyslog                            | Flag to indicate to enable Syslog collection or not.                                                                   |
| syslogLevels                            | Log levels for Syslog collection                                                                                       |
| syslogFacilities                        | Facilities for Syslog collection                                                                                       |
| resourceTagValues                       | Azure Resource Tags to use on AKS, Azure Monitor Data Collection Rule, and Azure Monitor Data collection endpoint etc. |
| dataCollectionInterval                  | Data collection interval for applicable inventory and perf data collection. Default is 1m                              |
| namespaceFilteringModeForDataCollection | Data collection namespace filtering mode for applicable inventory and perf data collection. Default is off             |
| namespacesForDataCollection             | Namespaces for data collection for applicable for inventory and perf data collection.                                  |
| streams                                 | Streams for data collection.  For retina networkflow logs feature, include "Microsoft-RetinaNetworkFlowLogs"           |
| useAzureMonitorPrivateLinkScope         | Flag to indicate whether to configure Azure Monitor Private Link Scope or not.                                         |
| azureMonitorPrivateLinkScopeResourceId  |  Azure Resource ID of the Azure Monitor Private Link Scope.                                                            |

3. Deploy the ARM template

```azurecli
az deployment group create \ 
--name AzureMonitorDeployment \ 
--resource-group <aksClusterResourceGroup> \ 
--template-file  aks-enable-monitoring-msi-onboarding-template-file \ 
--parameters aks-enable-monitoring-msi-onboarding-template-parameter-file
```

##### [Bicep](#tab/bicep)

> [!NOTE]
> Before proceeding, ensure your cluster meets the prerequisites mentioned in the *[Set up Container Network Logs with Advanced Container Networking Services](https://learn.microsoft.com/azure/aks/how-to-configure-container-network-logs?tabs=cilium)* article. 


1. Download the setup files:

* [Bicep Template](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/onboarding-msi-bicep/existingClusterOnboarding.bicep)
* [Parameter file](https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/aks/onboarding-msi-bicep/existingClusterParam.json)

These are available in the [Bicep onboarding folder](https://github.com/microsoft/Docker-Provider/tree/ci_prod/scripts/onboarding/aks/onboarding-msi-bicep) the GitHub repository for the Container Insights Logs add-on. 

2. Use the table to configure the parameters:

| Parameter Name                          |  Description                                                                                                           |
| --------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| aksResourceId                           | Azure Resource ID of the AKS cluster                                                                                   |
| aksResourceLocation                     | Azure Region of the AKS cluster                                                                                        |
| workspaceResourceId                     | Azure Resource ID of the Azure Log Analytics Workspace                                                                 |
| workspaceRegion                         | Azure Region of the Azure Log Analytics Workspace                                                                      |
| enableContainerLogV2                    | Flag to indicate whether to use ContainerLogV2 or not.                                                                 |
| enableRetinaNetworkFlowLogs             | Flag to indicate whether to enable Retina Network Flow Logs or not. This MUST be true                                  |
| enableSyslog                            | Flag to indicate to enable Syslog collection or not.                                                                   |
| syslogLevels                            | Log levels for Syslog collection                                                                                       |
| syslogFacilities                        | Facilities for Syslog collection                                                                                       |
| resourceTagValues                       | Azure Resource Tags to use on AKS, Azure Monitor Data Collection Rule, and Azure Monitor Data collection endpoint etc. |
| dataCollectionInterval                  | Data collection interval for applicable inventory and perf data collection. Default is 1m                              |
| namespaceFilteringModeForDataCollection | Data collection namespace filtering mode for applicable inventory and perf data collection. Default is off             |
| namespacesForDataCollection             | Namespaces for data collection for applicable for inventory and perf data collection.                                  |
| streams                                 | Streams for data collection.  For retina networkflow logs feature, include "Microsoft-RetinaNetworkFlowLogs"           |
| useAzureMonitorPrivateLinkScope         | Flag to indicate whether to configure Azure Monitor Private Link Scope or not.                                         |
| azureMonitorPrivateLinkScopeResourceId  |  Azure Resource ID of the Azure Monitor Private Link Scope.                                                            |

3. Deploy the Bicep template:

```azurecli
az deployment group create \ 
--name AzureMonitorDeployment \ 
--resource-group <aksClusterResourceGroup> \ 
--template-file  existingClusterOnboarding.bicep \ 
--parameters existingClusterParam.json
```


---

#### High level data flow

Container Network Logs requires a Customer Resource Definition (CRD) to be applied on the cluster for enabling logging. Once enabled, the Cilium operator generates logs which are written to the node file system. These log files get ingested by the Logs add-on from Container Insights. The Logs-add-on then transmits these logs to a dedicated ingestion endpoint, from where they're processed and stored in Log Analytics. Once the logs are in Log Analytics, they are available for querying as needed.  

:::image type="content" source="./media/container-insights-network-monitoring/container-insights-container-network-logs-data-flow.png" alt-text="Diagram of how container network logs are ingested." lightbox="./media/container-insights-network-monitoring/container-insights-container-network-logs-data-flow.png":::

#### Change table plan

Container Flow Logs are ingested to the `RetinaNetworkFlowLogs` table in Log Analytics. The table currently supports the Analytics and Basic table plans. To change the table plan for the `RetinaNetworkFlowLogs`, see the [instructions here](https://learn.microsoft.com/azure/azure-monitor/logs/logs-table-plans?tabs=portal-1#set-the-table-plan).

#### Throttling  

As Container Network Logs captures every flow inside your AKS cluster, the volume of logs generated can be substantial leading to throttling and log loss. See the *[Configure throttling for Container Insights](https://learn.microsoft.com/azure/azure-monitor/containers/container-insights-throttling)* article for guidance on configuring throttling parameters and monitoring for log loss. 

#### Limitations

Container Flow Logs has the following limitations:
1. Onboarding using Terraform is currently not supported
2. If the table plan is set to Basic Logs, the pre-built Grafana dashboards do not work
3. The Auxiliary logs table plan is not supported
4. Only the Cilium dataplane is supported. Refer to the *[Prerequisites for Container Flow logs](https://learn.microsoft.com/azure/aks/how-to-configure-container-network-logs?tabs=cilium#prerequisites)* article for a full list of limitations. 



### Cluster egress logs / Outbound flow logs 

To track flows outside your cluster, customers can enable [Virtual network flow logs](https://learn.microsoft.com/azure/network-watcher/vnet-flow-logs-overview?tabs=Americas)
