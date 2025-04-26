---
title: Visualize with Grafana
description: This document provides an overview of using Grafana with Azure Monitor, highlighting two approaches - Azure Monitor dashboards with Grafana for free, integrated visualization of Azure data in the Azure portal, and Managed Grafana for advanced features like external data sources, alerts, reports, and private networking. It includes a comparison table of features, pricing, and use cases, helping users choose the best solution for their needs.
ms.topic: conceptual
ms.date: 04/25/2025
---

# Visualize with Grafana

This document provides an overview of using Grafana with Azure Monitor, highlighting two approaches: Azure Monitor dashboards with Grafana for free, integrated visualization of Azure data in the Azure portal, and Managed Grafana for advanced features like external data sources, alerts, reports, and private networking. It includes a comparison table of features, pricing, and use cases, helping you choose the best solution for your needs.

## Dashboards with Grafana

Azure Monitor dashboards with [Grafana](https://grafana.com/docs/grafana/latest/dashboards/build-dashboards/manage-library-panels/) enable you to use Grafana's query, transformation, and visualization capability of Azure Monitor metrics, logs, traces, Azure Managed Prometheus, and Azure Resource Graph in the Azure portal. You can:

- Create and edit dashboards directly in the Azure portal for free and without administrative overhead.
- Import dashboards from thousands of publicly available [Grafana community dashboards](https://grafana.com/grafana/dashboards/?dataSource=prometheus).
- Apply a wide range of Grafana [visualizations](https://grafana.com/docs/grafana/latest/panels-visualizations/visualizations/) and client-side [transformations](https://grafana.com/docs/grafana/latest/panels-visualizations/query-transform-data/transform-data/) to Azure monitoring data.
- Manage Grafana dashboards as native Azure resources, including using Azure [RBAC](/azure/role-based-access-control/overview) and automation via ARM template and Bicep templates. 

You can access Azure Monitor dashboards with Grafana through the Azure portal, or from Azure Kubernetes Services.

You can create and edit dashboards and create your own copy to modify them without directly editing the original. You can also tag the dashboards.

### Limitations

- **Preview limitations**. Support for Grafana Explore, Dashboard links and Exemplars isn't yet available.
- **Unsupported features**. Grafana evaluated alerts, reports, library panels, snapshots, playlists, app plugins, and copying panels across different dashboards.  

## Managed Grafana

You can monitor Azure services and applications by using [Grafana](https://grafana.com/) and the included [Azure Monitor data source plug-in](https://grafana.com/docs/grafana/latest/datasources/azuremonitor/). The plug-in retrieves data from these Azure services:

- [Azure Monitor Metrics](../essentials/data-platform-metrics.md) for numeric time series data from Azure resources.
- [Azure Monitor Logs](../logs/data-platform-logs.md) for log and performance data from Azure resources that enables you to query by using the powerful Kusto Query Language (KQL). You can use Application Insights log queries to retrieve Application Insights log-based metrics.
    - [Application Insights log-based metrics](../essentials/app-insights-metrics.md) to let you analyze the health of your monitored apps. You can use Application Insights log queries in Grafana to use the Application Insights log metrics data.
- [Azure Monitor Traces](./../app/distributed-trace-data.md) to query and visualize distributed tracing data from Application Insights.
- [Azure Resource Graph](/azure/governance/resource-graph/overview) to quickly query and identify Azure resources across subscriptions.

You can also use the plug-in to query and visualize data from Azure Monitor managed service for Prometheus. For more information, see [Connect Grafana to Azure Monitor Prometheus metrics](../essentials/prometheus-grafana.md).

You can then display this performance and availability data on your Grafana dashboard.

The following is a list of managed Grafana related articles.

## Managed Grafana related content

The following is a list of related managed Grafana documentation.

### Containers
- [Monitor Kubernetes](../containers/monitor-kubernetes.md)
- [Enable monitoring for Kubernetes clusters, Enable Prometheus, and Grafana](../containers/kubernetes-monitoring-enable.md?tabs=cli#enable-prometheus-and-grafana)
- [Default Grafana dashboard configuration for Prometheus](../containers/prometheus-metrics-scrape-default.md#dashboards)
- [Container insights log schema, Install Grafana dashboard](../containers/container-insights-logs-schema.md#install-grafana-dashboard)
- Importing specific Grafana dashboards
    - [Argo CD](../containers/prometheus-argo-cd-integration.md)
    - [Elastisearch](../containers/prometheus-elasticsearch-integration.md)
    - [Istio](../containers/prometheus-istio-integration.md)
    - [Kafka](../containers/prometheus-kafka-integration.md)

### Metrics
- [Link to a Grafana dashboard in a an Azure Monitor workspace](../metrics/azure-monitor-workspace-manage.md?tabs=azure-portal#link-a-grafana-workspace)
 - [Connect Grafana to Azure Monitor Prometheus metrics](../metrics/prometheus-grafana.md?tabs=azure-managed-grafana)
 
### System Center Operations Manager(SCOM)
- [Dashboards on Azure Managed Grafana](../scom-manage-instance/dashboards-on-azure-managed-grafana.md)
- [Query Azure Monitor SCOM Managed Instance data from Azure Managed Grafana dashboards](../scom-manage-instance/query-scom-managed-instance-data-on-grafana.md)

## When to use

Choose Azure Monitor dashboards with Grafana if you store observability and telemetry data exclusively in Azure. 

Choose managed Grafana if you need access to external data sources and automation, including open-source and Grafana enterprise data sources, Grafana alerts, scheduled reports, and the ability to share access to dashboards without sharing access to the underlying data store.

## Solution comparison

|  | **Azure Monitor dashboards with Grafana** | **Azure Managed Grafana** |
|--|--|--|
| Access | Azure portal | Grafana Web Interface |
| Pricing | No cost | [Per user pricing](https://azure.microsoft.com/pricing/details/managed-grafana/?msockid=01a84dc8ec106f122df65931ed6b6e5d) plus compute costs for Standard SKU |
| Data Sources | Azure Monitor and Azure Prometheus | Azure Monitor, Azure Prometheus, Azure Data Explorer, [OSS data sources](/azure/managed-grafana/how-to-data-source-plugins-managed-identity?tabs=azure-portal), [Enterprise data sources](/azure/managed-grafana/how-to-grafana-enterprise) available with license |
| Data source authentication | Current-user only | User-configurable: Current-user, Managed Identity, App registration |
| Data source administration | N/A – depends on user RBAC roles | User-managed data sources |
| Compute resources | Shared | Dedicated |
| Grafana Enterprise | Not supported | Available with [license](/azure/managed-grafana/how-to-grafana-enterprise#update-a-grafana-enterprise-plan) |
| Additional Plugins | Azure-managed only | Azure-managed, open-source, and optional third-party with Enterprise |
| Grafana Alerts | Not supported | Supported |
| Grafana Email Notification | Not supported | Supported |
| Reporting | Not supported | Supported |
| Private networking | Not supported | Private link and managed private endpoint |
| Deterministic outbound IP | Not supported | Supported |
| Zone redundancy | Enabled by default | Supported |
| SLA | Not yet available | 99.9% availability |

## Next steps

- [Use Azure Monitor dashboards with Grafana](visualize-use-grafana-dashboards.md)
- [Use Manged Grafana](visualize-use-managed-grafana-how-to.md)
 