---
title: Visualize with Grafana
description: This article is an overview of how you can use Grafana with Azure Monitor.
ms.topic: conceptual
ms.date: 04/25/2025
---

# Visualize with Grafana

This article is an overview of how you can use Grafana with Azure Monitor. There are two main ways to use Grafana with Azure Monitor, Grafana dashboards and Managed Grafana.

## Grafana dashboards

Description of new content goes here.

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
- [Eanable monitoring for Kubernetes clusters, Enable Prometheus and Grafana](../containers/kubernetes-monitoring-enable.md?tabs=cli#enable-prometheus-and-grafana)
- [Default Grafana dashboard configuration for Prometheus](../containers/prometheus-metrics-scrape-default#dashboards)
- [Container insights log schema, Install Grafana dashboard](../containers/container-insights-logs-schema.md#install-grafana-dashboard)
- Importing specific Grafana dashboards
    - [Argo CD](../containers/prometheus-argo-cd-integration.md)
    - [Elastisearch](../containers/prometheus-elastisearch-integration.md)
    - [Istio](../containers/prometheus-istio-integration.md)
    - [Kafka](../containers/prometheus-kafka-integration.md)

### Metrics
- [Link to a Grafana dashboard in a an Azure Monitor workspace](../metrics/azure-monitor-workspace-manage.md?tabs=azure-portal#link-a-grafana-workspace)
 - [Connect Grafana to Azure Monitor Prometheus metrics](../metrics/prometheus-grafana.md?tabs=azure-managed-grafana)
 
### Sysetm Center Operations Manager(SCOM)
- [Dashboards on Azure Managed Grafana](../scom-manage-instance/dashboards-on-azure-managed-grafana.md)
- [Query Azure Monitor SCOM Managed Instance data from Azure Managed Grafana dashboards](../scom-manage-instance/query-scom-managed-instance-data-on-grafana.md)
