---
title: Visualize with Grafana
description: This article is an overview of how you can use Grafana with Azure Monitor.
ms.topic: conceptual
ms.date: 04/25/2025
---

# Visualize with Grafana

This article is an overview of how you can use Grafana with Azure Monitor.

## Grafana dashboards

Description of new conten goes here.

## Managed Grafana

You can monitor Azure services and applications by using [Grafana](https://grafana.com/) and the included [Azure Monitor data source plug-in](https://grafana.com/docs/grafana/latest/datasources/azuremonitor/). The plug-in retrieves data from these Azure services:

* [Azure Monitor Metrics](../essentials/data-platform-metrics.md) for numeric time series data from Azure resources.

* [Azure Monitor Logs](../logs/data-platform-logs.md) for log and performance data from Azure resources that enables you to query by using the powerful Kusto Query Language (KQL). You can use Application Insights log queries to retrieve Application Insights log-based metrics.

    * [Application Insights log-based metrics](../essentials/app-insights-metrics.md) to let you analyze the health of your monitored apps. You can use Application Insights log queries in Grafana to use the Application Insights log metrics data.

* [Azure Monitor Traces](./../app/distributed-trace-data.md) to query and visualize distributed tracing data from Application Insights.

* [Azure Resource Graph](/azure/governance/resource-graph/overview) to quickly query and identify Azure resources across subscriptions.

You can also use the plug-in to query and visualize data from Azure Monitor managed service for Prometheus. For more information, see [Connect Grafana to Azure Monitor Prometheus metrics](../essentials/prometheus-grafana.md).

You can then display this performance and availability data on your Grafana dashboard.

Use the following steps to set up a Grafana server and build dashboards for metrics and logs from Azure Monitor.

## Related content

- [Tutorial]()
- [Tutorial]()
- 