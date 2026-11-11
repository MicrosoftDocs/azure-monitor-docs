---
title: Connect metrics to traces with exemplars
description: Connect metrics to traces with exemplars in Azure Monitor.
ms.topic: concept-article
ms.date: 10/22/2026
ai-usage: ai-assisted
---

# Connect metrics to traces with exemplars

Modern cloud-native applications generate enormous volumes of telemetry. Metrics help teams detect that something is wrong, but traces explain why. Exemplars bridge these two worlds by attaching trace references directly to metric data points, making it dramatically easier to pivot from a spike in latency or errors to the exact distributed trace responsible for the issue.

By using Azure Monitor, you can ingest metrics with exemplars and visualize them in Azure Managed Grafana. This capability enables seamless correlation between metrics and traces, helping engineering teams troubleshoot issues faster and reduce mean time to resolution (MTTR).


## Why exemplars matter

Traditional monitoring workflows often require you to manually correlate data across multiple systems. Exemplars simplify this workflow by embedding trace context directly into metric samples. For example, if a latency metric spikes at a specific timestamp, the exemplar associated with that data point can link directly to the distributed trace responsible for the outlier.

This capability provides several benefits:

- Faster root cause analysis
- Quicker transition from aggregate metrics to request-level details
- Simplified debugging workflows for SRE and platform teams
- Better observability experiences for microservices and distributed applications

## Unified observability with Azure Monitor

By using Azure Monitor and Azure Managed Grafana, you can now:

- Ingest OTLP or Prometheus metrics with exemplars into Azure Monitor Workspace
- Store and analyze traces in Azure Monitor Application Insights
- Visualize exemplar markers directly in Grafana charts
- Navigate from a metric spike to the exact distributed trace associated with that data point

By combining these signals in a single observability platform, you can correlate infrastructure health, application behavior, and request traces without context switching between tooling.

## How it works

Once Azure Monitor ingests metrics, exemplars, and traces, Azure Managed Grafana can consume exemplar information from the configured Prometheus data source. When you enable exemplars in Grafana dashboards, you see markers associated with individual metric data points. Selecting an exemplar opens the associated trace in Azure Monitor, providing end-to-end diagnostic context.

:::image type="content" source="./media/opentelemetry-protocol-ingestion/azure-monitor-exemplars-block.png" lightbox="./media/opentelemetry-protocol-ingestion/azure-monitor-exemplars-block.png" alt-text="Screenshot showing block diagram for exemplars and metrics and traces.":::

## Getting started

### Set up data ingestion

- Instrument your application to emit OpenTelemetry traces, OpenTelemetry or Prometheus metrics with exemplars, and enable ingestion of the same to Azure Monitor using OpenTelemetry Collector. Follow the instructions in [Ingest OTLP Data into Azure Monitor with OTel Collector](./opentelemetry-protocol-ingestion.md) After this step, you set up the Log Analytics workspace, Azure Monitor workspace, and Application Insights resources to store the telemetry data.
- [Create an Azure Managed Grafana instance](/azure/managed-grafana/quickstart-managed-grafana-portal) and connect it with the Azure Monitor workspace by navigating to your Azure Monitor workspace in the Azure portal and then selecting **Linked Grafana workspaces**. To learn more, see [Manage an Azure Monitor workspace](../metrics/azure-monitor-workspace-manage.md).
- Optionally, [enable Azure Managed Prometheus](./kubernetes-monitoring-tutorial.md) on your AKS cluster or use remote-write and configure it to use the same Azure Monitor workspace to centralize infrastructure and application metrics.

## Enable exemplars in Azure Managed Grafana

After setting up the data ingestion, ensure that logs and traces flow into the Log Analytics workspace, and metrics flow into the Azure Monitor workspace.

### Step 1: Enable exemplars on Prometheus data source in Azure Managed Grafana

1. In Azure Managed Grafana, select **Connections** > **Data Sources**. Since you connected Azure Managed Grafana to Azure Monitor workspace, you see the data source `Managed_Prometheus_<AMW-Name>` already configured. If the data source isn't configured, follow the steps in this article to add your Azure Monitor workspace as a data source.
1. Open the data source configuration.
1. Select **Add Exemplars** to enable exemplar support.

:::image type="content" source="./media/opentelemetry-protocol-ingestion/azure-monitor-exemplars-datasource-add.png" lightbox="./media/opentelemetry-protocol-ingestion/azure-monitor-exemplars-datasource-add.png" alt-text="Screenshot showing how to enable Add Exemplars in Grafana.":::

### Step 2: Configure Trace Linking with Azure Monitor

1. In the exemplar configuration section, toggle **Internal Link** to **On**.
2. Select **Azure Monitor** as the data source.
3. In the **Label Name** field, enter the name of the field in the labels object that Azure Monitor uses to get the trace ID, such as `trace_id`.
4. Select **Save & Test**.

:::image type="content" source="./media/opentelemetry-protocol-ingestion/azure-monitor-exemplars-configuration.png" lightbox="./media/opentelemetry-protocol-ingestion/azure-monitor-exemplars-configuration.png" alt-text="Screenshot showing data source configuration for Azure Monitor.":::

After you enable this feature, exemplar markers appear on supported metric visualizations. When you select the marker, you see exemplar details and an option to open the corresponding distributed trace in Azure Monitor.

:::image type="content" source="./media/opentelemetry-protocol-ingestion/azure-monitor-exemplars-marker.png" lightbox="./media/opentelemetry-protocol-ingestion/azure-monitor-exemplars-marker.png" alt-text="Screenshot showing how the exemplars can point to traces.":::

## Next steps

[Collect and Analyze OpenTelemetry data](./collect-use-observability-data.md)<br>
[Enable Prometheus metrics on Kubernetes](./kubernetes-monitoring-enable.md)<br>
[Learn more about Prometheus metrics](../metrics/prometheus-metrics-overview.md)

