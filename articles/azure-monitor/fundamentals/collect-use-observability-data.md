---
title: Collect and analyze OpenTelemetry data with Azure Monitor (preview)
description: Onboard OpenTelemetry Protocol (OTLP) signals to Azure Monitor for AKS and other environments. Learn the supported onboarding paths and how to use Dashboards with Grafana, Application Insights experiences, and Log Analytics with OpenTelemetry semantic conventions.
ms.topic: how-to
ms.date: 11/13/2025
---

# Use OpenTelemetry with Azure Monitor

Azure Monitor ingests OpenTelemetry Protocol (OTLP) **signals**—traces, metrics, and logs—from your applications and platforms. Use the OpenTelemetry Collector or Application Insights to export telemetry to Azure Monitor. After onboarding, use troubleshooting and exploration experiences in Application Insights, work with Prometheus metrics and **Dashboards with Grafana**, and analyze logs and traces in Log Analytics by using OpenTelemetry semantic conventions.

## Review capabilities

- Ingest OTLP **traces, metrics, and logs** into Azure Monitor with platform ingestion components such as Azure Monitor Agent (AMA), Data Collection Rules (DCRs), and Data Collection Endpoints (DCEs).
- Use the **OpenTelemetry Collector** to export to Azure Monitor ingestion endpoints that Application Insights or your own orchestration provides.
- Explore application signals in **Application Insights**, including distributed tracing and diagnostics experiences.
- Use **Dashboards with Grafana** in the Azure portal for Application Insights data, and start from Azure‑managed dashboards that focus on OpenTelemetry and common application scenarios.
- Query logs and traces in **Log Analytics** by using an **OpenTelemetry semantic conventions**–based schema.

## Choose an onboarding path

Select one of the following paths based on where your workloads run.

### Monitor AKS with OpenTelemetry

Enable application monitoring for Azure Kubernetes Service (AKS) and send OTLP telemetry to Application Insights.

- **Enable the AKS integration** in the cluster’s **Monitor** settings to add the required Azure Monitor components.
- **Create or select** an Application Insights resource with **Enable OTLP Support (Preview)** and **Use managed workspaces** set to **Yes**.
- **Onboard applications** per namespace or per deployment by using either:
  - **Autoinstrumentation** for **Java** and **Node.js**.
  - **Autoconfiguration** for apps already instrumented with OpenTelemetry Software Development Kits (SDKs).

For more information, see [Monitor AKS applications with OpenTelemetry Protocol (OTLP) Limited Preview](../app/kubernetes-open-protocol.md).

### Configure other environments

Use the OpenTelemetry Collector or AMA to send OTLP signals from compute resources outside AKS.

- **Use Application Insights to orchestrate ingestion.** Create an Application Insights resource and capture the **Data Collection Rule (DCR)** link and **endpoint URLs** for **traces**, **metrics**, and **logs** from the **Overview** page.
- **Orchestrate ingestion manually.** Create an Azure Monitor Workspace (AMW), Log Analytics workspace (LAW), DCEs, and DCRs, then build the three OTLP endpoint URLs for metrics, logs, and traces.
- **Export from the OpenTelemetry Collector.** Use the Collector `contrib` distribution and authenticate with Microsoft Entra ID or a managed identity where applicable.

For more information, see [OTLP signal ingestion in Azure Monitor](../agents/signal-ingestion.md) and [Use Application Insights with OTLP signals](../app/signal-integration.md).

> [!TIP]
> Endpoint URLs also appear on the Application Insights **Overview** page when OTLP support is enabled. Use these values in your Collector exporters or SDK configuration.

## Use Azure Monitor experiences

After onboarding, use the following experiences to investigate and visualize your telemetry.

### Use Application Insights troubleshooting and diagnostics

- Investigate **distributed traces** end‑to‑end and correlate requests, dependencies, and failures.
- Use **Search** and **Transaction details** to analyze events across services and drill into problem areas.
- For agentic workloads, use the **Agents (Preview)** experience to monitor AI agents that emit OpenTelemetry data.

> [!NOTE]
> Most **Application Insights** experiences work as expected with OpenTelemetry data (for example, **Performance**, **Failures**, **Trace Explorer**, end‑to‑end **Transaction details**). However, **Live Metrics** and **Metrics Explorer** don't currently support the OpenTelemetry ingestion path. For metrics scenarios, use **Dashboards with Grafana** with Prometheus queries.

For more information, see [OpenTelemetry on Azure](../app/opentelemetry.md) and [Monitor AI agents with Application Insights](../app/agents-view.md).

### Use Dashboards with Grafana for Prometheus metrics

- Start from **Azure‑managed dashboards** that cover OpenTelemetry and common Application Insights scenarios.
- Create, edit, and save dashboards as **Azure resources** and manage access with Azure role based access control (RBAC).
- Use **Grafana Explore** for ad‑hoc queries and add results to dashboards.

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

## Next steps

- Start with **Monitor AKS with OpenTelemetry** or **Configure other environments** and complete onboarding.
- Open **Dashboards with Grafana** or **Application Insights** to validate signals.
- Use **Log Analytics** to run Kusto query language (KQL) queries and confirm the data model meets your needs.

## Related resources

- [Monitor AKS with OpenTelemetry](../app/kubernetes-open-protocol.md)
- [OTLP signal ingestion in Azure Monitor](../agents/signal-ingestion.md)
- [Use Application Insights with OTLP signals](../app/signal-integration.md)
- [Dashboards with Grafana in Application Insights](../app/grafana-dashboards.md)
- [OpenTelemetry on Azure](../app/opentelemetry.md)
- [OpenTelemetry documentation](https://opentelemetry.io/docs/)
