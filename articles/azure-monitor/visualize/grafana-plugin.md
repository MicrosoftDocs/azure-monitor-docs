---
title: Monitor Azure services and applications by using Grafana
description: Route Azure Monitor and Application Insights data so that you can view it in Grafana.
ms.topic: conceptual
ms.date: 01/05/2025
---

# Monitor your Azure services in Grafana

You can monitor Azure services and applications by using [Grafana](https://grafana.com/) and the included [Azure Monitor data source plug-in](https://grafana.com/docs/grafana/latest/datasources/azuremonitor/). The plug-in retrieves data from these Azure services:

* [Azure Monitor Metrics](../essentials/data-platform-metrics.md) for numeric time series data from Azure resources.

* [Azure Monitor Logs](../logs/data-platform-logs.md) for log and performance data from Azure resources that enables you to query by using the powerful Kusto Query Language (KQL). You can use Application Insights log queries to retrieve Application Insights log-based metrics.

    * [Application Insights log-based metrics](../essentials/app-insights-metrics.md) to let you analyze the health of your monitored apps. You can use Application Insights log queries in Grafana to use the Application Insights log metrics data.

* [Azure Monitor Traces](./../app/distributed-trace-data.md) to query and visualize distributed tracing data from Application Insights.

* [Azure Resource Graph](/azure/governance/resource-graph/overview) to quickly query and identify Azure resources across subscriptions.

You can also use the plug-in to query and visualize data from Azure Monitor managed service for Prometheus. For more information, see [Connect Grafana to Azure Monitor Prometheus metrics](../essentials/prometheus-grafana.md).

You can then display this performance and availability data on your Grafana dashboard.

# Next steps

- [Use managed grafana](visualize-use-managed-grafana-how-to.md)