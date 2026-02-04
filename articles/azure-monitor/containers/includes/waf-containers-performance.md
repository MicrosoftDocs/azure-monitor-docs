---
ms.topic: include
ms.date: 05/21/2025
---

### Design checklist

> [!div class="checklist"]
> * Enable collection of Prometheus metrics for your cluster.
> * Enable Container insights to track performance of your cluster.
> * Enable recommended Prometheus alerts.

### Configuration recommendations

| Recommendation | Benefit |
|:---------------|:--------|
| Enable collection of Prometheus metrics for your cluster. | [Prometheus](https://prometheus.io) is a cloud-native metrics solution from the Cloud Native Compute Foundation and the most common tool used for collecting and analyzing metric data from Kubernetes clusters. [Enable Prometheus](../kubernetes-monitoring-enable.md) on your cluster with [Azure Monitor managed service for Prometheus](../../essentials/prometheus-metrics-overview.md) if you don't already have a Prometheus environment. Use [Azure Managed Grafana](/azure/managed-grafana/overview) to analyze the Prometheus data collected.<br><br>See [Customize scraping of Prometheus metrics in Azure Monitor managed service for Prometheus](../prometheus-metrics-scrape-configuration.md) to collect additional metrics beyond the [default configuration](../prometheus-metrics-scrape-default.md). |
| Enable Container insights to track performance of your cluster. | When you [enable Container insights](../kubernetes-monitoring-enable.md#) for your Kubernetes cluster, you can use [views](../container-insights-analyze.md) and [workbooks](../kubernetes-workbooks.md) to track the performance of the components of your cluster. This data may overlap with data collected by Prometheus. See [Cost optimization](../best-practices-containers.md#cost-optimization) for recommendations regarding cost. |
| Enable recommended Prometheus alerts. | [Alerts](../../alerts/alerts-overview.md) in Azure Monitor proactively notify you when issues are detected.  Start with a set of [recommended Prometheus alert rules](../container-insights-metric-alerts.md#enable-prometheus-alert-rules) that detect the most common availability and performance issues with your cluster. Potentially add [log search alerts](../container-insights-log-alerts.md) using data collected by Container insights. |
