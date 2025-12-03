---
title: Visualize Azure Monitor data with Grafana
description: This article explains how to use Grafana with Azure Monitor. It covers free Azure dashboards for integrated data and Managed Grafana for advanced features.
ms.topic: article
ms.reviewer: kayodeprinceMS
ms.date: 10/29/2025
---

# Visualize Azure Monitor data with Grafana
[Grafana](https://grafana.com/) is an open-source analytics and visualization platform that enables you to query, monitor, and create interactive dashboards for metrics, logs, and traces from multiple data sources. This article describes the different options that Azure provides for using Grafana to visualize Azure Monitor data.

Azure provides the following two options for using Grafana. The rest of the article describes each option in detail and provides guidance for the scenarios when each should be used.

[Azure Monitor dashboards with Grafana](#azure-monitor-dashboards-with-grafana). Delivers Grafana dashboards for data collected in Azure Monitor directly in the Azure portal with no cost and no configuration requirements.
[Azure Managed Grafana](#azure-managed-grafana). Fully managed Grafana service that supports dashboards using a variety of data sources.


## Azure Monitor dashboards with Grafana

Azure Monitor dashboards with Grafana delivers Grafana dashboards directly in the Azure portal. It's automatically available at no cost and with no configuration requirements. 

Azure Monitor dashboards with Grafana enables the following capabilities:

- Use a set of prebuilt dashboards to visualize monitoring data for your Azure resources.
- Import thousands of publicly available [Grafana community dashboards](https://grafana.com/grafana/dashboards/?dataSource=prometheus) for supported resources.
- Create your own dashboards in the Azure portal and apply a wide range of Grafana [visualizations](https://grafana.com/docs/grafana/latest/panels-visualizations/visualizations/) and client-side [transformations](https://grafana.com/docs/grafana/latest/panels-visualizations/query-transform-data/transform-data/) to Azure monitoring data.
- Manage Grafana dashboards as native Azure resources, including using [Azure RBAC](/azure/role-based-access-control/overview) and automation via ARM template and Bicep templates. 



### How to access

Navigate to **Azure Monitor** in the Azure portal, and then select **Dashboards with Grafana** for Prometheus metrics scraped from Kubernetes clusters or ingested into Azure Monitor..

:::image type="content" source="./media/visualizations-grafana/default-dashboards.png" lightbox="./media/visualizations-grafana/default-dashboards.png" alt-text="Screenshot of dashboards with grafana default dashboards.":::


### Data sources
Azure Monitor dashboards with Grafana supports the following data sources. If you require other data sources, then see [Azure Managed Grafana](#azure-managed-grafana).

- [Azure Monitor Metrics](../essentials/data-platform-metrics.md) for numeric time series data from Azure resources.
- [Azure Monitor managed service for Prometheus](../essentials/prometheus-metrics-overview.md) for Prometheus metrics scraped from Kubernetes clusters.
- [Azure Monitor Logs](../logs/data-platform-logs.md) for log and performance data from Azure resources that enables you to query by using the powerful Kusto Query Language (KQL).
- [Azure Monitor Traces](./../app/distributed-trace-data.md) to query and visualize distributed tracing data from Application Insights.
- [Azure Resource Graph](/azure/governance/resource-graph/overview) to quickly query and identify Azure resources across subscriptions.
- [Azure Data Explorer](/azure/data-explorer/data-explorer-overview) to query data directly from your ADX clusters using Kusto Query Language (KQL).

### Limitations

Azure Monitor dashboards with Grafana doesn't support the following Grafana features. If you require these features, then see [Azure Managed Grafana](#azure-managed-grafana).

- Alerts
- Reports
- Library panels
- Snapshots
- Playlists
- App plugins

## Azure Managed Grafana
[Azure Managed Grafana](/azure/managed-grafana/overview) is a fully managed Grafana service that supports dashboards using a variety of data sources. Access the Grafana dashboard through the same browser experience as other Grafana deployments. 

The included [Azure Monitor data source plug-in](https://grafana.com/docs/grafana/latest/datasources/azuremonitor/) gives you access to the same data sources as [Azure Monitor dashboards with Grafana](#data-sources). Add the Prometheus plugin to query and visualize data from Azure Monitor managed service for Prometheus. See [Connect Grafana to Azure Monitor Prometheus metrics](../essentials/prometheus-grafana.md).

### Managed Grafana related content

See [Azure Managed Grafana overview](/azure/managed-grafana/overview) for full details on the service. The following table provides links to related articles that describe how to use Azure Managed Grafana with Azure Monitor data.

| Product area | Documentation |
|:--|:--|
| Containers | [Monitor Kubernetes](../containers/monitor-kubernetes.md)<br>[Enable monitoring for AKS clusters](../containers/kubernetes-monitoring-enable.md)<br>[Default Grafana dashboards](../containers/prometheus-metrics-scrape-default.md#dashboards)<br>[Log level dashboard](../containers/container-insights-logs-schema.md#install-grafana-dashboard)<br>[Argo CD dashboard](../containers/prometheus-argo-cd-integration.md)<br>[Elastisearch dashboard](../containers/prometheus-elasticsearch-integration.md)<br>[Istio dashboard](../containers/prometheus-istio-integration.md)<br>[Kafka dashboard](../containers/prometheus-kafka-integration.md)
| Metrics | [Link to a Grafana dashboard in an Azure Monitor workspace](../metrics/azure-monitor-workspace-manage.md?tabs=azure-portal#link-a-grafana-workspace)<br>[Connect Grafana to Azure Monitor Prometheus metrics](../metrics/prometheus-grafana.md?tabs=azure-managed-grafana)


## Solution comparison

Since **Azure Monitor dashboards with Grafana** is available in the Azure portal at no cost and with no configuration, it should be your first choice if you only want to use Azure Monitor data.

Choose **Azure Managed Grafana** if you require any of the following:

- Access to external data sources and automation, including open-source and Grafana enterprise data sources
- Grafana alerts
- Scheduled reports
- Ability to share access to dashboards without sharing access to the underlying data store



The following table provides a complete comparison of the two solutions.

| Feature | Azure Monitor<br>dashboards with Grafana | <br>Azure Managed Grafana |
|:---|:---|:---|
| Access | Azure portal | Grafana Web Interface |
| Pricing | No cost | [Per user pricing](https://azure.microsoft.com/pricing/details/managed-grafana/?msockid=01a84dc8ec106f122df65931ed6b6e5d) plus compute costs for Standard SKU |
| Data Sources | Azure Monitor<br>Azure Managed Prometheus<br>Azure Resource Graph | Azure Monitor, Azure Prometheus, Azure Data Explorer, [OSS data sources](/azure/managed-grafana/how-to-data-source-plugins-managed-identity?tabs=azure-portal), [Enterprise data sources](/azure/managed-grafana/how-to-grafana-enterprise) available with license |
| Data source authentication | Current user only | User-configurable: Current user, Managed Identity, App registration |
| Data source administration | N/A – depends on user RBAC roles | User-managed data sources |
| Compute resources | SaaS | Dedicated virtual machine scale sets |
| Grafana Enterprise | Not supported | Available with [license](/azure/managed-grafana/how-to-grafana-enterprise#update-a-grafana-enterprise-plan) |
| Additional Plugins | Azure-managed only | Azure-managed, open-source, and optional third-party with Enterprise |
| Grafana Alerts | Not supported | Supported |
| Grafana Email Notification | Not supported | Supported |
| Reporting | Not supported | Supported |
| Private networking | Not supported | Private link and managed private endpoint |
| Deterministic outbound IP | Not supported | Supported |
| Zone redundancy | Enabled by default | Supported |


## Next steps

- [Use Azure Monitor Dashboards with Grafana](visualize-use-grafana-dashboards.md)
- [Use Managed Grafana](visualize-use-managed-grafana-how-to.md)
 