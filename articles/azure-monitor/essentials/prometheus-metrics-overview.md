---
title: Overview of Azure Monitor Managed Service for Prometheus
description: Overview of Azure Monitor managed service for Prometheus, which provides a Prometheus-compatible interface for storing and retrieving metric data.
author: EdB-MSFT
ms.service: azure-monitor
ms-author: edbaynash
ms.topic: conceptual
ms.date: 09/16/2024
---

# Azure Monitor managed service for Prometheus

Azure Monitor managed service for Prometheus is a component of [Azure Monitor Metrics](data-platform-metrics.md), providing more flexibility in the types of metric data that you can collect and analyze with Azure Monitor. Prometheus metrics are supported by analysis tools like  [Azure Monitor Metrics Explorer with PromQL](./metrics-explorer.md) and open source tools such as [PromQL](https://aka.ms/azureprometheus-promio-promql) and [Grafana](/azure/managed-grafana/overview).

Azure Monitor managed service for Prometheus allows you to collect and analyze metrics at scale using a Prometheus-compatible monitoring solution, based on the [Prometheus](https://aka.ms/azureprometheus-promio) project from the Cloud Native Computing Foundation. This fully managed service allows you to use the [Prometheus query language (PromQL)](https://aka.ms/azureprometheus-promio-promql) to analyze and alert on the performance of monitored infrastructure and workloads without having to operate the underlying infrastructure.

> [!IMPORTANT] 
> Azure Monitor managed service for Prometheus is intended for storing information about service health of customer machines and applications. It is not intended for storing any data classified as Personal Identifiable Information (PII) or End User Identifiable Information (EUII). We strongly recommend that you do not send any sensitive information (usernames, credit card numbers etc.) into Azure Monitor managed service for Prometheus fields like metric names, label names, or label values.

## Data sources
Azure Monitor managed service for Prometheus can currently collect data from any of the following data sources:

- Azure Kubernetes service (AKS)
- Azure Arc-enabled Kubernetes

## Enable
The only requirement to enable Azure Monitor managed service for Prometheus is to create an [Azure Monitor workspace](azure-monitor-workspace-overview.md), which is where Prometheus metrics are stored. Once this workspace is created, you can onboard services that collect Prometheus metrics.

- To collect Prometheus metrics from your Kubernetes cluster, see [Enable monitoring for Kubernetes clusters](../containers/kubernetes-monitoring-enable.md#enable-prometheus-and-grafana).
- To configure remote-write to collect data from your self-managed Prometheus server, see [Azure Monitor managed service for Prometheus remote write](./remote-write-prometheus.md).

## Remote write

In addition to the managed service for Prometheus, you can also use self-managed prometheus and remote-write to collect metrics and store them in an Azure Monitor workspace.

### Kubernetes services

Send metrics from self-managed Prometheus on Kubernetes clusters. For more information on remote-write to Azure Monitor workspaces for Kubernetes services, see the following articles:

- [Send Prometheus data from AKS to Azure Monitor by using managed identity authentication](/azure/azure-monitor/containers/prometheus-remote-write-managed-identity)
- [Send Prometheus data from AKS to Azure Monitor by using Microsoft Entra ID authentication](/azure/azure-monitor/containers/prometheus-remote-write-active-directory)
- [Send Prometheus data to Azure Monitor by using Microsoft Entra ID pod-managed identity (preview) authentication](/azure/azure-monitor/containers/prometheus-remote-write-azure-ad-pod-identity)
- [Send Prometheus data to Azure Monitor by using Microsoft Entra ID Workload ID (preview) authentication](/azure/azure-monitor/containers/prometheus-remote-write-azure-workload-identity)

### Virtual Machines and Virtual Machine Scale sets

Send data from self-managed Prometheus on virtual machines and virtual machine scale sets. Servers can be in an Azure-managed environment or on-premises. Fro more information, see [Send Prometheus metrics from Virtual Machines to an Azure Monitor workspace](/azure/azure-monitor/essentials/prometheus-remote-write-virtual-machines).

## Azure Monitor Metrics Explorer with PromQL

Metrics Explorer with PromQL allows you to analyze and visualize platform metrics, and use Prometheus query language (PromQL) to query Prometheus and other metrics stored in an Azure Monitor workspace. Metrics Explorer with PromQL is available from the **Metrics** menu item of any Azure Monitor workspace in the Azure portal. See [Metrics Explorer with PromQL](./metrics-explorer.md) for more information.

## Grafana integration

The primary method for visualizing Prometheus metrics is [Azure Managed Grafana](/azure/managed-grafana/overview). [Connect your Azure Monitor workspace to a Grafana workspace](./azure-monitor-workspace-manage.md#link-a-grafana-workspace) so that it can be used as a data source in a Grafana dashboard. You then have access to multiple prebuilt dashboards that use Prometheus metrics and the ability to create any number of custom dashboards.

## Rules and alerts
Azure Monitor managed service for Prometheus supports recording rules and alert rules using PromQL queries. Metrics recorded by recording rules are stored back in the Azure Monitor workspace and can be queried by dashboard or by other rules. Alert rules and recording rules can be created and managed using [Azure Managed Prometheus rule groups](prometheus-rule-groups.md). For your AKS cluster, a set of [predefined Prometheus alert rules](../containers/container-insights-metric-alerts.md) and [recording rules](./prometheus-metrics-scrape-default.md#recording-rules) is provided to allow easy quick start.

Alerts fired by alert rules can trigger actions or notifications, as defined in the [action groups](../alerts/action-groups.md) configured for the alert rule. You can also view fired and resolved Prometheus alerts in the Azure portal along with other alert types. 

## Service limits and quotas

Azure Monitor Managed service for Prometheus has default limits and quotas for ingestion. When you reach the ingestion limits throttling can occur. You can request an increase in these limits. For more information on throttling and requesting increased limits, see [Monitoring metrics limits](#how-can-i-monitor-the-service-limits-and-quota). For information on Prometheus metrics limits, see [Azure Monitor service limits](../service-limits.md#prometheus-metrics).

## Limitations/Known issues - Azure Monitor managed Service for Prometheus

- Scraping and storing metrics at frequencies less than 1 second isn't supported.
- Support in Microsoft Azure operated by Air gapped clouds is enabled through support. Please contact support to onboard Azure Monitor managed service for Prometheus for Air gapped clouds.
- To monitor Windows nodes & pods in your clusters, see [Enable monitoring for Azure Kubernetes Service (AKS) cluster](../containers/kubernetes-monitoring-enable.md#enable-windows-metrics-collection-preview).
- Azure Managed Grafana isn't currently available in the Azure US Government cloud.
- Usage metrics (metrics under `Metrics` menu for the Azure Monitor workspace) - Ingestion quota limits and current usage for any Azure monitor Workspace aren't available yet in US Government cloud.
- During node updates, you might experience gaps lasting 1 to 2 minutes in some metric collections from our cluster level collector. This gap is due to a regular action from Azure Kubernetes Service to update the nodes in your cluster. This behavior is expected and occurs due to the node it runs on being updated. None of our recommended alert rules are affected by this behavior. 

[!INCLUDE [case sensitivity](../includes/prometheus-case-sensitivity.md)] 

## Prometheus references

Following are links to Prometheus documentation.

- [PromQL](https://aka.ms/azureprometheus-promio-promql)
- [Grafana](https://aka.ms/azureprometheus-promio-grafana)
- [Recording rules](https://aka.ms/azureprometheus-promio-recrules)
- [Alerting rules](https://aka.ms/azureprometheus-promio-alertrules)
- [Writing Exporters](https://aka.ms/azureprometheus-promio-exporters)


## Frequently asked questions

This section provides answers to common questions.

### How do I retrieve Prometheus metrics?

All data is retrieved from an Azure Monitor workspace by using queries that are written in Prometheus Query Language (PromQL). You can write your own queries, use queries from the open source community, and use Grafana dashboards that include PromQL queries. See the [Prometheus project](https://prometheus.io/docs/prometheus/latest/querying/basics/). 

[!INCLUDE [prometheus-faq-can-i-view-prometheus-metrics-in-metrics-explorer](../includes/prometheus-faq-can-i-view-prometheus-metrics-in-metrics-explorer.md)]

### When I use managed service for Prometheus, can I store data for more than one cluster in an Azure Monitor workspace?

Yes. Managed service for Prometheus is intended to enable scenarios where you can store data from several Azure Kubernetes Service clusters in a single Azure Monitor workspace. See [Azure Monitor workspace overview](./azure-monitor-workspace-overview.md?#azure-monitor-workspace-architecture).

### What types of resources can send Prometheus metrics to managed service for Prometheus?

Our agent can be used on Azure Kubernetes Service clusters and Azure Arc-enabled Kubernetes clusters. It's installed as a managed add-on for AKS clusters and an extension for Azure Arc-enabled Kubernetes clusters and you can configure it to collect the data you want. You can also configure remote write on Kubernetes clusters running in Azure, another cloud, or on-premises by following our instructions for enabling remote write.

If you use the Azure portal to enable Prometheus metrics collection and install the AKS add-on or Azure Arc-enabled Kubernetes extension from the Insights page of your cluster, it enables logs collection into Log Analytics and Prometheus metrics collection into managed service for Prometheus. For more information, see [Data sources](#data-sources).

### How can I monitor the service limits and quota?

Azure Monitor Managed service for Prometheus has default limits and quotas for ingestion. For information on Prometheus metrics limits, see [Azure Monitor service limits](../service-limits.md#prometheus-metrics). When you reach the ingestion limits throttling can occur. In order to avoid throttling, you can monitor and set up an alert on Azure Monitor Workspace ingestion limits.

1. In the Azure portal, navigate to your Azure Monitor Workspace and select **Metrics** under the **Monitoring** section.
2. Select the Azure Monitor Workspace as scope. In the **Metric** dropdown, select **View standard metrics with the builder**.
3. In the **Metric** drop-down, select **Active Time Series % Utilization** and **Events Per Minute Ingested % Utilization** and verify that they are below 100%.

:::image type="content" source="media/azure-monitor-workspace-overview/azure-monitor-workspace-limits-metrics.png" alt-text="Screenshot that shows how to create an alert rule for Azure Monitor Workspace ingestion limits." lightbox="media/azure-monitor-workspace-overview/azure-monitor-workspace-limits-metrics.png":::

4. You can set an Azure Alert to monitor the utilization and fire an alert when the utilization is greater than a certain threshold. Select **New alert rule** to create an Azure alert.

:::image type="content" source="media/azure-monitor-workspace-overview/alert-azure-monitor-workspace.png" alt-text="Screenshot that shows how to create an alert for Azure Monitor Workspace limits." lightbox="media/azure-monitor-workspace-overview/alert-azure-monitor-workspace.png":::

If the alert is fired i.e. the ingestion utilization is more than the threshold, you can request an increase in these limits by creating a support ticket.

1. In the Azure portal, navigate to your Azure Monitor Workspace, click on **Support + Troubleshooting**.
2. Type the issue, e.g., "Service and subscription limits (quotas)", then select **Service and subscription limits (quotas)** and select **Next**.

:::image type="content" source="media/azure-monitor-workspace-overview/azure-monitor-workspace-support-ticket.png" alt-text="Screenshot that shows how to create a support ticket for limit increase." lightbox="media/azure-monitor-workspace-overview/azure-monitor-workspace-support-ticket.png":::

3. In the next screen, select your subscription and then select **Managed Prometheus** as the **Quota type**.
4. Provide additional details to create the support ticket.


## Next steps

- [Enable Azure Monitor managed service for Prometheus on your Kubernetes clusters](../containers/kubernetes-monitoring-enable.md).
- [Configure Prometheus alerting and recording rules groups](prometheus-rule-groups.md).
- [Customize scraping of Prometheus metrics](prometheus-metrics-scrape-configuration.md).
