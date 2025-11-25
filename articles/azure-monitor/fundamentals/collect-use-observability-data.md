---
title: Collect and analyze OpenTelemetry data with Azure Monitor (Limited Preview)
description: Onboard OpenTelemetry Protocol (OTLP) signals to Azure Monitor for AKS and other environments. Learn the supported onboarding paths and how to use Dashboards with Grafana, Application Insights experiences, and Log Analytics with OpenTelemetry semantic conventions.
ms.topic: how-to
ms.date: 11/13/2025
ROBOTS: NOINDEX
---

# Use OpenTelemetry with Azure Monitor (Limited Preview)

Azure Monitor ingests OpenTelemetry (OTel) **signals**—traces, metrics, and logs—from your applications and platforms. Application Insights orchestrates ingestion into Azure Monitor and provides experiences to explore the data. You can also use the OpenTelemetry Collector to export telemetry to Azure Monitor. After onboarding, use troubleshooting and exploration experiences in Application Insights, work with Prometheus metrics in **Dashboards with Grafana**, and analyze logs and traces in Log Analytics using OpenTelemetry semantic conventions.

> [!IMPORTANT]
> * This feature is a **limited preview**. Preview features are provided without a service-level agreement and aren't recommended for production workloads.
> * For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

> [!NOTE]
> * [Support](#support) for this feature is limited to enrolled subscriptions.
> * [Submit a request](https://aka.ms/azuremonitorotelpreview) to participate.

## Review capabilities

- Ingest OTel **traces, metrics, and logs** into **Azure Monitor** by using **Application Insights** for data collection and orchestration.
- Ingest OTel **traces, metrics, and logs** into **Azure Monitor** with platform ingestion components such as **Azure Monitor Agent (AMA)**, **Data Collection Rules (DCRs)**, and **Data Collection Endpoints (DCEs)**.
- Use the **OpenTelemetry Collector** to export to Azure Monitor ingestion endpoints that Application Insights or your own orchestration provides.
- Explore application signals in **Application Insights**, including distributed tracing and diagnostics experiences. Use familiar blades such as **Performance**, **Failures**, **Search**, and **Transaction details** with OTel data.
- Use **Dashboards with Grafana** in the Azure portal for Application Insights data. Start from Azure‑managed dashboards that focus on OpenTelemetry and common application scenarios.
- Query logs and traces in **Log Analytics** by using an **OpenTelemetry semantic conventions**–based schema.

## Choose an onboarding path

Select one of the following paths based on where your workloads run.

### Monitor applications on Azure Kubernetes Service (AKS) with OpenTelemetry

Enable application monitoring for **Azure Kubernetes Service (AKS)** and send OTLP telemetry **to Azure Monitor**. Application Insights orchestrates ingestion and provides investigation experiences.

- **Enable the AKS integration** in the cluster’s **Monitor** settings to add the required Azure Monitor components.
- **Create or select** an Application Insights resource with **Enable OTLP Support (Preview)** and **Use managed workspaces** set to **Yes**.
- **Onboard applications** per namespace or per deployment by using either:
  - **Autoinstrumentation** for **Java** and **Node.js**.
  - **Autoconfiguration** for apps already instrumented with OpenTelemetry Software Development Kits (SDKs).

For more information, see [Monitor AKS applications with OpenTelemetry Protocol (OTLP) Limited Preview](../app/kubernetes-open-protocol.md).

### Configure other environments

Use the **Azure Monitor Agent** or **OpenTelemetry Collector** to send OTLP signals from compute resources outside AKS **into Azure Monitor**.

- **Use Application Insights to orchestrate ingestion into Azure Monitor.** Create an Application Insights resource to automatically create the required workspaces (**AMW** and **LAW**), and capture the **Data Collection Rule (DCR)** link and **OTLP endpoint URLs** for **traces**, **metrics**, and **logs** from the **Overview** page.
- **Orchestrate ingestion manually.** Create an Azure Monitor Workspace (AMW), Log Analytics workspace (LAW), Data Collection Endpoints (DCEs), and Data Collection Rules (DCRs), then build the three OTLP endpoint URLs for metrics, logs, and traces.
- **Export from the OpenTelemetry Collector.** Use the Collector `contrib` distribution and authenticate with Microsoft Entra ID or a managed identity. Use the Collector’s **Azure Auth extension** to authenticate with Microsoft Entra. For details, see the extension README: https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/extension/azureauthextension#readme

For more information, see [Ingest OpenTelemetry Protocol signals into Azure Monitor (Limited Preview)](opentelemetry-protocol-ingestion.md).

> [!TIP]
> Endpoint URLs also appear on the Application Insights **Overview** page when OTLP support is enabled. Use these values in your Collector exporters or SDK configuration.

## Use Azure Monitor experiences

After onboarding, use the following experiences to investigate and visualize your telemetry.

### Use Application Insights troubleshooting and diagnostics

- [Investigate **distributed traces** end‑to‑end and correlate requests, dependencies, and failures](../app/failures-performance-transactions.md). Most Application Insights experiences continue to work with OTel data (for example, **Performance**, **Failures**, **Search**, and **end‑to‑end transaction** views).
- Use **Search** and **Transaction details** to analyze events across services and drill into problem areas.
- For agentic workloads, use the [**Agents details (Preview)**](../app/agents-view.md) experience to monitor AI agents that emit OpenTelemetry data.
- For OpenTelemetry metrics scenarios, prefer [**Dashboards with Grafana**](../app/grafana-dashboards.md). **Metrics Explorer** on OTel metrics can require manual PromQL authoring, and **Live Metrics** isn't available with the OTel path today.

For more information, see [Monitor AI agents with Application Insights](../app/agents-view.md).

### Use Dashboards with Grafana for Prometheus metrics

- Start from **Azure‑managed dashboards** that cover OpenTelemetry and common Application Insights scenarios. You can customize, copy, or use them as a reference for your own dashboards.
- Create, edit, and save dashboards as **Azure resources** and manage access with Azure role‑based access control (RBAC). Use Azure Resource Manager (ARM) or Bicep to automate deployments.
- Use **Grafana Explore** for ad‑hoc queries and add results to dashboards. Prometheus metrics queried here complement the Application Insights experiences.

For more information, see [Dashboards with Grafana in Application Insights](../app/grafana-dashboards.md).

### Query logs and traces with OpenTelemetry semantic conventions

- Use **Kusto Query Language (KQL)** in **Log Analytics** to query logs and traces stored with an **OpenTelemetry semantic conventions–based schema**.
- Filter and aggregate with familiar OpenTelemetry attributes and span kinds.
- Join metrics, logs, and traces for correlated analysis.

For more information, see [OpenTelemetry semantic conventions](https://opentelemetry.io/docs/specs/semconv/) and [Application Insights telemetry data model](../app/data-model-complete.md).

## Reference

- **Supported protocol (preview):**
  - Collector path: OTLP over **HTTP/protobuf**.
  - AMA path: Application‑to‑agent communication over **gRPC** on local ports.
- **Ports for AMA‑based ingestion (preview):**
  - **4317** (gRPC) for metrics
  - **4319** (gRPC) for logs and traces
  - **Host:** `localhost`
- **Known limitations (AKS preview excerpt):**
  - Unsupported node pools: **Windows** and **Linux Arm64**.
  - OTLP **HTTP/protobuf** only; JSON payloads and **OTLP/gRPC** aren't supported.
  - Selected networking scenarios such as Istio mTLS aren't supported.

## Support

Assistance for enrolled subscriptions is available only through `otel@microsoft.com`.

## Next steps

- [OpenTelemetry on Azure](../app/opentelemetry.md)
- [Monitor AKS with OpenTelemetry](../app/kubernetes-open-protocol.md)
- [Dashboards with Grafana in Application Insights](../app/grafana-dashboards.md)
- [OpenTelemetry documentation](https://opentelemetry.io/docs/)
