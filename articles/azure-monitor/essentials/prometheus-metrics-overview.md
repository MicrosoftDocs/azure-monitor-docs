---
title: Overview of Azure Monitor with Prometheus
description: Overview of Azure Monitor with Prometheus, which provides Azure Monitor Workspaces, a Prometheus-compatible interface for storing and retrieving metric data.
author: EdB-MSFT
ms.service: azure-monitor
ms-author: edbaynash
ms.topic: conceptual
ms.date: 10/06/2024
---

# Azure Monitor and Prometheus

Prometheus is a popular open-source monitoring and alerting solution that's widely used in the cloud-native ecosystem. Prometheus is used to monitor and alert on the performance of infrastructure and workloads and often used in Kubernetes environments. 

Use Prometheus as an Azure managed service, or as a self managed service to collect metrics. Prometheus metrics can be collected from your Azure Kubernetes Service (AKS) clusters, Azure Arc-enabled Kubernetes clusters, virtual machines, and virtual machine scale sets.

Prometheus metrics are stored in an Azure Monitor workspace, where you can analyze and visualize the data using [Metrics Explorer with PromQL](./metrics-explorer.md) and [Azure Managed Grafana](/azure/managed-grafana/overview).

> [!IMPORTANT] 
> Azure Monitor managed and hosted Prometheus is intended for storing information about service health of customer machines and applications. It is not intended for storing any data classified as Personal Identifiable Information (PII) or End User Identifiable Information (EUII). We strongly recommend that you do not send any sensitive information (usernames, credit card numbers etc.) into Azure Monitor hosted Prometheus fields like metric names, label names, or label values.


## Azure Monitor Managed Service for Prometheus

Azure Monitor Managed Service for Prometheus is a component of [Azure Monitor Metrics](data-platform-metrics.md) that provides a fully managed and scalable environment for running Prometheus. It simplifies the deployment, management, and scaling of Prometheus in an Azure Kubernetes Service, allowing you to focus on monitoring your applications and infrastructure.

As a fully managed service, Azure Monitor managed service for Prometheus automatically deploys Prometheus in AKS or ARC-enabled Kubernetes. The service provides high availability, SLA guarantees, and automatic software updates. The service provides a highly scalable metrics store, with data retention of up to 18 months.

Azure Monitor managed service for Prometheus provides preconfigured alerts, rules, and dashboards. With recommended dashboards from the Prometheus community and native Grafana integration, you can achieve comprehensive monitoring immediately.
Natively integrates with Azure Managed Grafana, and also works with self-managed Grafana.

Pricing is based on ingestion and query with no additional storage cost. For more information, see the **Metrics** tab in [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/).


### Enable Azure Monitor managed service for Prometheus

Azure Monitor managed service for Prometheus collects data from Azure Kubernetes services:

- Azure Kubernetes service (AKS)
- Azure Arc-enabled Kubernetes

To enable Azure Monitor managed service for Prometheus, you must create an [Azure Monitor workspace](azure-monitor-workspace-overview.md) to store the metrics. Once the workspace is created, you can onboard services that collect Prometheus metrics.

- To collect Prometheus metrics from your Kubernetes cluster, see [Enable monitoring for Kubernetes clusters](../containers/kubernetes-monitoring-enable.md#enable-prometheus-and-grafana).
- To configure remote-write to collect data from a self-managed Prometheus server, see [Azure Monitor managed service for Prometheus remote write](./remote-write-prometheus.md).

To enable Managed Prometheus for Microsoft Azure air-gapped clouds, contact support. 



## Azure hosted self-managed Prometheus

In addition to the managed service for Prometheus, you can install and manage your own Prometheus instance and use remote-write to store metrics in an Azure Monitor workspace.

Using remote-write, you can collect data from self-managed Prometheus servers running in the following environments:

- Azure virtual machines
- Azure virtual machine scale sets
- Arc-enabled servers
- Self manged Azure-hosted or arc-enabled Kubernetes clusters.


### Self-managed Kubernetes services

Send metrics from self-managed Prometheus on Kubernetes clusters. For more information on remote-write to Azure Monitor workspaces for Kubernetes services, see the following articles:

- [Send Prometheus data from AKS to Azure Monitor by using managed identity authentication](/azure/azure-monitor/containers/prometheus-remote-write-managed-identity)
- [Send Prometheus data from AKS to Azure Monitor by using Microsoft Entra ID authentication](/azure/azure-monitor/containers/prometheus-remote-write-active-directory)
- [Send Prometheus data to Azure Monitor by using Microsoft Entra ID pod-managed identity (preview) authentication](/azure/azure-monitor/containers/prometheus-remote-write-azure-ad-pod-identity)
- [Send Prometheus data to Azure Monitor by using Microsoft Entra ID Workload ID (preview) authentication](/azure/azure-monitor/containers/prometheus-remote-write-azure-workload-identity)

### Virtual Machines and Virtual Machine Scale sets

Send data from self-managed Prometheus on virtual machines and virtual machine scale sets. The virtual machines can be in an Azure-managed environment or on-premises. Fro more information, see [Send Prometheus metrics from Virtual Machines to an Azure Monitor workspace](/azure/azure-monitor/essentials/prometheus-remote-write-virtual-machines).

## Data storage 

Prometheus metrics are stored in an Azure Monitor workspace. The data is stored in a time-series database that can be queried using Prometheus Query Language (PromQL). You can store data from several Prometheus data sources in a single Azure Monitor workspace. For more information, see [Azure Monitor workspace overview](./azure-monitor-workspace-overview.md?#azure-monitor-workspace-architecture).  

Data is retained in Azure Monitor workspaces for 18 months.

## Query and analyze Prometheus metrics

Prometheus data is retrieved using Prometheus Query Language (PromQL). You can write your own queries, use queries from the open source community, and use Grafana dashboards that include PromQL queries. See the [Prometheus project](https://prometheus.io/docs/prometheus/latest/querying/basics/). 


The following Azure services support querying Prometheus metrics from an Azure Monitor workspace:

- [Azure Monitor Metrics Explorer with PromQL](./metrics-explorer.md)
- [Azure Managed Grafana](/azure/managed-grafana/overview)
- [Azure Monitor Workbooks](../visualize/workbooks-overview.md)
- [Prometheus query APIs](prometheus-api-promql.md)


### Azure Monitor Metrics explorer with PromQL

Metrics Explorer with PromQL allows you to analyze and visualize platform and Prometheus metrics. Metrics explorer supports PromQL for Prometheus metrics. Metrics Explorer with PromQL (preview) is available from the **Metrics** menu item of the Azure Monitor workspace where your Prometheus metrics are stored. For more information, see [Metrics Explorer with PromQL](./metrics-explorer.md).  
  
:::image type="content" source="./media/prometheus-metrics-overview/metrics-explorer.png" alt-text="A screenshot showing a PromQL query in the Metrics explorer." lightbox="./media/prometheus-metrics-overview/metrics-explorer.png":::


### Azure workbooks

Create charts and dashboards powered by Azure Monitor managed service for Prometheus using Azure Workbooks and PromQL queries. For more information, see [Query Prometheus metrics using Azure workbooks](prometheus-workbooks.md) 

### Grafana integration

VisualizE Prometheus metrics using [Azure Managed Grafana](/azure/managed-grafana/overview). Connect your Azure Monitor workspace to a Grafana workspace so that it can be used as a data source in a Grafana dashboard. You then have access to multiple prebuilt dashboards that use Prometheus metrics and the ability to create any number of custom dashboards. For more information, see [Link a Grafana workspace to an Azure Monitor workspace](./azure-monitor-workspace-manage.md#link-a-grafana-workspace)


### Prometheus query API

Use PromQL via the REST API to query Prometheus metrics stored in an Azure Monitor workspace. For more information, see [Prometheus query API](prometheus-api-promql.md).

## Rules and alerts

Prometheus supports recording rules and alert rules using PromQL queries. Rules and alerts are automatically deployed Azure Monitor managed service for Prometheus. Metrics recorded by recording rules are stored in the Azure Monitor workspace and can be queried by dashboards or by other rules. Alert rules and recording rules can be created and managed using [Azure Managed Prometheus rule groups](prometheus-rule-groups.md). For your AKS cluster, a set of [predefined Prometheus alert rules](../containers/container-insights-metric-alerts.md) and [recording rules](./prometheus-metrics-scrape-default.md#recording-rules) is provided to allow easy quick start.

Alerts fired by alert rules can trigger actions or notifications, as defined in the [action groups](../alerts/action-groups.md) configured for the alert rule. You can also view fired and resolved Prometheus alerts in the Azure portal along with other alert types. 

## Service limits and quotas

Azure Monitor Managed service for Prometheus has default limits and quotas for ingestion. When you reach the ingestion limits throttling can occur. You can request an increase in these limits. For information on Prometheus metrics limits, see [Azure Monitor service limits](../service-limits.md#prometheus-metrics).

To monitor and alert on your ingestion metrics, see [Monitor Azure Monitor workspace metrics ingestion](./azure-monitor-workspace-monitor-ingest-limits.md). 

## Limitations/Known issues - Azure Monitor managed Service for Prometheus

- The minimum frequency for scraping and storing metrics is 1 second.
- During node updates, you might experience gaps lasting 1 to 2 minutes in some metric collections from our cluster level collector. This gap is due to a regular action from Azure Kubernetes Service to update the nodes in your cluster. This behavior is expected and occurs due to the node it runs on being updated. Recommended alert rules are not affected by this behavior. 
- Managed Prometheus for Windows nodes isn't automatically enabled. To enable monitoring for Windows nodes & pods in your clusters, see [Monitor Windows nodes & pods in your clusters](../containers/kubernetes-monitoring-enable.md#enable-windows-metrics-collection-preview).

[!INCLUDE [case sensitivity](../includes/prometheus-case-sensitivity.md)] 


## Prometheus references

Following are links to Prometheus documentation.

- [Querying Prometheus](https://aka.ms/azureprometheus-promio-promql)
- [Grafana support for Prometheus](https://aka.ms/azureprometheus-promio-grafana)
- [Defining recording rules](https://aka.ms/azureprometheus-promio-recrules)
- [Alerting rules](https://aka.ms/azureprometheus-promio-alertrules)
- [Writing Exporters](https://aka.ms/azureprometheus-promio-exporters)


## Next steps
- [Enable Azure Monitor managed service for Prometheus on your Kubernetes clusters](../containers/kubernetes-monitoring-enable.md).
- [Send Prometheus metrics from Virtual Machines to an Azure Monitor workspace](./prometheus-remote-write-virtual-machines.md).
- - [Monitor Windows nodes & pods in your clusters](../containers/kubernetes-monitoring-enable.md#enable-windows-metrics-collection-preview).
- [Configure Prometheus alerting and recording rules groups](./prometheus-rule-groups.md).
- [Customize scraping of Prometheus metrics](../containers/prometheus-metrics-scrape-configuration.md).
- [Troubleshoot Prometheus metrics collection](../containers/prometheus-metrics-troubleshoot.md).
