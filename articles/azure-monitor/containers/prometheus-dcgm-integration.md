---
title: Collect GPU metrics from Nvidia DCGM exporter with Azure Managed Prometheus
description: Describes how to configure GPU monitoring using Prometheus metrics in Azure Monitor to Kubernetes cluster.
ms.topic: conceptual
ms.date: 3/24/2025
ms.reviewer: sunasing
---
# Collect GPU metrics from Nvidia DCGM exporter with Azure Managed Prometheus

**[Nvidia's DCGM exporter](https://docs.nvidia.com/datacenter/cloud-native/gpu-telemetry/latest/dcgm-exporter.html)** enables collecting and exporting Nvidia GPU metrics, such as utilization, memory usage, power consumption etc. You can use this exporter and enable GPU monitoring with Azure Managed Prometheus and Azure Managed Grafana. Follow the instructions in below link to deploy the exporter and set up metrics collection.

[Monitor GPU metrics from NVIDIA DCGM exporter with Azure Managed Prometheus and Azure Managed Grafana](/azure/aks/monitor-gpu-metrics)


## Query GPU metrics

The metrics scraped are stored in the Azure Monitor workspace that is associated with Managed Prometheus. You can query the metrics directly from the workspace or through the Azure managed Grafana instance connected to the workspace.

View Istio metrics in the Azure Monitor Workspace using the following steps:

1.	In the Azure portal, navigate to your AKS cluster.
2.	Under Monitoring, select Insights and then Monitor Settings.

:::image type="content" source="./media/monitor-kubernetes/amp-istio-query.png" lightbox="./media/monitor-kubernetes/amp-istio-query.png" alt-text="Diagram that shows how to view the Azure Monitor Workspace.":::

3. Click on the Azure Monitor Workspace instance and on the instance overview page, click on the **Metrics** section to query metrics to query for the metrics.
4. Alternatively, you can click on the Managed Grafana instance, and on the instance overview page, click on the Endpoint URL. This will navigate to the Grafana portal where you can query the Azure Container Storage metrics. The data source is automatically configured for you to query metrics from the associated Azure Monitor Workspace.

To learn more about querying Prometheus metrics from Azure Monitor Workspace, see [Query Prometheus metrics](../essentials/prometheus-grafana.md).

## Troubleshooting

To troubleshoot any issues, see [here](prometheus-metrics-troubleshoot.md#prometheus-interface).

