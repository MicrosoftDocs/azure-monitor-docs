---
title: Collect GPU Metrics from the NVIDIA DCGM Exporter with Managed Service for Prometheus
description: This article describes how to configure GPU monitoring by using Prometheus metrics in Azure Monitor to a Kubernetes cluster.
ms.topic: how-to
ms.date: 3/24/2025
ms.reviewer: sunasing
---
# Collect GPU metrics from NVIDIA DCGM Exporter by using managed service for Prometheus

[NVIDIA DCGM Exporter](https://docs.nvidia.com/datacenter/cloud-native/gpu-telemetry/latest/dcgm-exporter.html) enables collecting and exporting NVIDIA GPU metrics, such as utilization, memory usage, and power consumption. You can use this exporter and enable GPU monitoring through the Azure Monitor *managed service for Prometheus* feature and through Azure Managed Grafana.

## Deploy NVIDIA DCGM Exporter

Deploy the exporter and set up the collection of metrics by following the instructions in [Monitor GPU metrics from NVIDIA DCGM Exporter with managed service for Prometheus and Azure Managed Grafana on AKS](/azure/aks/monitor-gpu-metrics).

## Query GPU metrics

The scraped metrics are stored in the Azure Monitor workspace that's associated with managed service for Prometheus. You can query the metrics directly from the workspace or through the Azure Managed Grafana instance that's connected to the workspace.

To view NVIDIA GPU metrics in the Azure Monitor workspace:

1. In the Azure portal, go to your Azure Kubernetes Service cluster.

2. Under **Monitoring**, select **Insights** > **Monitor Settings**.

   :::image type="content" source="./media/monitor-kubernetes/amp-istio-query.png" lightbox="./media/monitor-kubernetes/amp-istio-query.png" alt-text="Diagram that shows selections for viewing the Azure Monitor workspace.":::

3. Select the Azure Monitor workspace instance. On the instance overview page, select the **Metrics** section to query metrics.

   Alternatively, you can select the Azure Managed Grafana instance. Then, on the instance overview page, select the endpoint URL. This action opens to the Grafana portal, where you can query the Azure Container Storage metrics. The data source is automatically configured for you to query metrics from the associated Azure Monitor workspace.

To learn more about querying Prometheus metrics from an Azure Monitor workspace, see [Connect Grafana to Azure Monitor Prometheus metrics](../essentials/prometheus-grafana.md).

## Troubleshoot

If you have any problems, see the [troubleshooting information for the Prometheus interface](prometheus-metrics-troubleshoot.md#prometheus-interface).
