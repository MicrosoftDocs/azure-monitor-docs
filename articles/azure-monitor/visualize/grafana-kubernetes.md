---
title: Use dashboards with Grafana with Azure Kubernetes Service (AKS)
description: This article explains how to use Azure Monitor dashboards with Grafana with Azure Kubernetes Service (AKS).
ms.topic: how-to
ms.reviewer: kayodeprinceMS
ms.date: 11/03/2025
---

# Use dashboards with Grafana with Azure Kubernetes Service (AKS)

[Azure Monitor panel with Grafana](./visualize-grafana-overview.md) allow you to view and create [Grafana](https://grafana.com/) panel directly in the Azure portal. This article describes the dashboards that are available for Kubernetes clusters enabled for monitoring with Azure Monitor and also how to create your own dashboards.

## Prerequisites

- The Kubernetes cluster must be enabled for Azure Monitor. See [Enable monitoring for AKS clusters](../containers/kubernetes-monitoring-enable.md).
- To open the dashboards, you must have read access to the logs and Azure Monitor workspace holding the log and metric data. [Analytics tier logs](/azure/azure-monitor/logs/data-platform-logs#table-plans) can be queried using the Kubernetes cluster as its [scope](/azure/azure-monitor/logs/scope), so direct access to the Log Analytics workspace is not required. [Basic logs](/azure/azure-monitor/logs/data-platform-logs#table-plans) only support workspace scoped queries so access to the Log Analytics workspace is required.

## Open a Kubernetes dashboard
Dashboards included with Azure Monitor dashboards with Grafana related to Kubernetes clusters include the following:

- Cluster metrics collected by Azure Monitor managed service for Prometheus.
- Container logs collected by Azure Monitor Logs.
- Control Plane scenarios, such as Kubernetes API and ETCD.
- Advanced Container Networking and flow logs
- HPC dashboards for GPU monitoring

Open dashboards for a particular cluster from **Dashboards with Grafana** in its **Monitoring** section in the Azure portal. Only dashboards relevant to that cluster are listed.

:::image type="content" source="./media/visualizations-grafana/default-dashboards-kubernetes.png" lightbox="./media/visualizations-grafana/default-dashboards-kubernetes.png" alt-text="Screenshot of dashboards with grafana default dashboards for Kubernetes clusters.":::

> [!NOTE]
> The same dashboards are also available from the **Dashboards with Grafana** section in Azure Monitor, but you must select the cluster after you open the dashboard.


## Create a new Kubernetes dashboard
Follow the guidance at [Use Azure Monitor dashboards with Grafana](./visualize-use-grafana-dashboards.md) to create a new Grafana dashboard or edit an existing one. When you add a new visualization to the dashboard, you need to specify one of the following data sources.

For Prometheus metrics, select the Azure Monitor workspace used to collect the Prometheus metrics for the cluster.

:::image type="content" source="./media/grafana-kubernetes/prometheus-data-source.png" lightbox="./media/grafana-kubernetes/prometheus-data-source.png" alt-text="Screenshot of selecting Prometheus data source.":::

For Container logs, select **Azure Monitor**. Then select **Logs** for the **Service**. Click **Select a resource** and select the Log Analytics workspace used to collect the container logs for the cluster.

:::image type="content" source="./media/grafana-kubernetes/logs-data-source.png" lightbox="./media/grafana-kubernetes/logs-data-source.png" alt-text="Screenshot of selecting Log Analytics workspace data source.":::


## Related content

- [Azure Monitor Grafana overview](visualize-grafana-overview.md)
- [Use Managed Grafana](visualize-use-managed-grafana-how-to.md)
