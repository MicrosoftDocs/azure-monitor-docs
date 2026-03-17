---
title: Collect and analyze OpenTelemetry data with Azure Monitor (Preview)
description: Onboard OpenTelemetry Protocol (OTLP) signals to Azure Monitor for AKS and other environments. Learn the supported onboarding paths and how to use Dashboards with Grafana, Application Insights experiences, and Log Analytics with OpenTelemetry semantic conventions.
ms.topic: how-to
ms.date: 03/17/2026
---

# Use OpenTelemetry with Azure Monitor (Preview)

Azure Monitor ingests OpenTelemetry (OTel) **signals**—traces, metrics, and logs—from your applications and platforms. Application Insights orchestrates ingestion into Azure Monitor and provides experiences to explore the data. You can also use the OpenTelemetry Collector to export telemetry to Azure Monitor. After onboarding, use troubleshooting and exploration experiences in Application Insights, work with Prometheus metrics in **Dashboards with Grafana**, and analyze logs and traces in Log Analytics using OpenTelemetry semantic conventions.

> [!IMPORTANT]
> * This feature is a **preview**. Preview features are provided without a service-level agreement and aren't recommended for production workloads.
> * For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Review capabilities

- Ingest OTel **traces, metrics, and logs** into **Azure Monitor** by using **Application Insights** for data collection and orchestration.
- Ingest OTel **traces, metrics, and logs** into **Azure Monitor** with platform ingestion components such as **Azure Monitor Agent (AMA)**, **Data Collection Rules (DCRs)**, and **Data Collection Endpoints (DCEs)**.
- Use the **OpenTelemetry Collector** to export to Azure Monitor ingestion endpoints that Application Insights or your own orchestration provides.
- Explore application signals in **Application Insights**, including distributed tracing and diagnostics experiences. Use familiar blades such as **Performance**, **Failures**, **Search**, and **Transaction details** with OTel data.
- Use **Dashboards with Grafana** in the Azure portal for Application Insights data. Start from Azure‑managed dashboards that focus on OpenTelemetry and common application scenarios.
- Query logs and traces in **Log Analytics** by using an **OpenTelemetry semantic conventions**–based schema.

## Roles and responsibilities

Use the following guidance to separate platform (cluster) responsibilities from application development (workload) responsibilities. *Cluster administrator* refers to the team that's responsible for the AKS cluster and Azure Monitor telemetry pipeline. *Developer* refers to the team that owns the application code and its telemetry configuration.

| Cluster administrator responsibilities | Developer responsibilities |
|---|---|
| Enable and maintain the cluster-level monitoring integration (AKS Monitor settings / add-ons). | Instrument application code using OpenTelemetry SDKs (or adopt supported auto-instrumentation where applicable). |
| Create, configure, and govern shared Azure resources used for ingestion and storage (Application Insights, Azure Monitor workspace, Log Analytics workspace, DCR/DCE where applicable). | Configure application telemetry (resource attributes, sampling, log correlation, and exporter settings) and validate signal correctness. |
| Manage identities and permissions required for telemetry export (managed identities, Microsoft Entra app registrations/service principals, RBAC role assignments). | Onboard workloads at the namespace or deployment scope (labels/annotations/configuration resources) following the platform's supported pattern. |
| Define and enforce cluster governance (namespaces, network policy, admission controls, quotas/limits) that can impact telemetry collection. | Perform application rollout restarts when required to apply monitoring changes to pods/deployments. |
| Operate and troubleshoot platform components (Azure Monitor Agent/Managed Prometheus/collectors deployed as add-ons), including upgrades and rollback plans. | Troubleshoot application-level telemetry gaps (missing spans/metrics/logs, incorrect attributes, high cardinality, and noisy logs) and remediate in code/config. |
| Provide supported recommended baseline configurations (standard ports/endpoints, required temporality/aggregation expectations, approved exporters/processors). | Own SLOs/alerting for the application and use Azure Monitor / Application Insights experiences to investigate regressions. |

*Out of scope for cluster admins: changing application code, selecting libraries, and defining business-level telemetry semantics.*

*Out of scope for developers: changing cluster add-ons, platform RBAC, shared ingestion resource topology, or cluster networking.*

**Common collaboration points:**

- Agree on naming/labeling standards (`service.name`, `deployment.environment`, and namespace conventions) so data is queryable and dashboards work across teams.
- Align on performance and cost guardrails (sampling strategy, log verbosity, and metric cardinality) and who changes what when limits are exceeded.
- Define a support workflow for telemetry issues (what developers check first vs. when to escalate to the cluster admin team).
- Plan changes jointly when they span both layers (for example, switching ingestion method, changing endpoint/temporality expectations, or introducing a collector).

## Choose an onboarding path

Select one of the following paths based on where your workloads run.

### Monitor applications on Azure Kubernetes Service (AKS) with OpenTelemetry

Enable application monitoring for **Azure Kubernetes Service (AKS)** and send OTLP telemetry **to Azure Monitor**. Application Insights orchestrates ingestion and provides investigation experiences.

- **Enable the AKS integration** in the cluster’s **Monitor** settings to add the required Azure Monitor components.
- **Create or select** an Application Insights resource with **Enable OTLP Support (Preview)** and **Use managed workspaces** set to **Yes**.
- **Onboard applications** per namespace or per deployment by using either:
  - **Autoinstrumentation** for **Java** and **Node.js**.
  - **Autoconfiguration** for apps already instrumented with OpenTelemetry Software Development Kits (SDKs).

For more information, see [Monitor AKS applications with OpenTelemetry Protocol (OTLP) Preview](../app/kubernetes-open-protocol.md).

### Use the Azure Monitor Agent to send OTLP signals from compute resources outside AKS into Azure Monitor

- **Use Application Insights to orchestrate ingestion into Azure Monitor.** Create an Application Insights resource to automatically create the required workspaces (**AMW** and **LAW**), and capture the **Data Collection Rule (DCR)** link and **OTLP endpoint URLs** for **traces**, **metrics**, and **logs** from the **Overview** page. Alternatively, orchestrate ingestion manually by creating all required resources.
- Configure the OTLP exporter to use gRPC on port 4317 for metrics and port 4319 for traces and logs, using Delta temporality and Exponential histogram aggregation for metrics.

For more information, see [Ingest OpenTelemetry Protocol signals into Azure Monitor with the Azure Monitor Agent (Preview)](../fundamentals/opentelemetry-protocol-ingestion.md).

### Use the OpenTelemetry Collector to send OTLP signals from compute resources outside AKS into Azure Monitor

- **Use Application Insights to orchestrate ingestion into Azure Monitor.** Create an Application Insights resource to automatically create the required workspaces (**AMW** and **LAW**), and capture the **Data Collection Rule (DCR)** link and **OTLP endpoint URLs** for **traces**, **metrics**, and **logs** from the **Overview** page. Alternatively, orchestrate ingestion manually by creating all required resources.
- **Export from the OpenTelemetry Collector.** Use the Collector `contrib` distribution and authenticate with Microsoft Entra ID or a managed identity. Use the Collector's **Azure Auth extension** to authenticate with Microsoft Entra. For details, see the extension README: https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/extension/azureauthextension#readme Configure export to HTTP/Protobuf and set delta temporality and exponential histogram aggregation for metrics.

For more information, see [Ingest OpenTelemetry Protocol signals into Azure Monitor with the OpenTelemetry Collector (Preview)](../fundamentals/opentelemetry-protocol-ingestion.md).

> [!TIP]
> Endpoint URLs also appear on the Application Insights **Overview** page when OTLP support is enabled. Use these values in your Collector exporters or SDK configuration.

## Use Azure Monitor experiences

After onboarding, use the following experiences to investigate and visualize your telemetry.

### Use Application Insights troubleshooting and diagnostics

- [Investigate **distributed traces** end‑to‑end and correlate requests, dependencies, and failures](../app/failures-performance-transactions.md). Most Application Insights experiences continue to work with OTel data (for example, **Performance**, **Failures**, **Search**, and **end‑to‑end transaction** views).
- Use **Search** and **Transaction details** to analyze events across services and drill into problem areas.
- For agentic workloads, use the [**Agents details (Preview)**](../app/agents-view.md) experience to monitor AI agents that emit OpenTelemetry data.
- For OpenTelemetry metrics scenarios, prefer [**Dashboards with Grafana**](../app/grafana-dashboards.md). **Metrics Explorer** on OTel metrics can require manual PromQL authoring, and **Live Metrics** isn't available with the OTel path today.

### Use Dashboards with Grafana for OpenTelemetry metrics

- Start from **Azure‑managed dashboards** that cover OpenTelemetry and common Application Insights scenarios. You can customize, copy, or use them as a reference for your own dashboards.
- Create, edit, and save dashboards as **Azure resources** and manage access with Azure role‑based access control (RBAC). Use Azure Resource Manager (ARM) or Bicep to automate deployments.
- Use **Grafana Explore** for ad‑hoc queries and add results to dashboards. Prometheus metrics queried here complement the Application Insights experiences.

For more information, see [Dashboards with Grafana in Application Insights](../app/grafana-dashboards.md).

> [!IMPORTANT]
> Application Insights experiences including pre-built dashboards and queries expect and require OTLP metrics with delta temporality and exponential histogram aggregation.

### Query logs and traces with OpenTelemetry semantic conventions

- Use **Kusto Query Language (KQL)** in **Log Analytics** to query logs and traces stored with an **OpenTelemetry semantic conventions–based schema**.
- Filter and aggregate with familiar OpenTelemetry attributes and span kinds.
- Join metrics, logs, and traces for correlated analysis.

For more information, see [OpenTelemetry semantic conventions](https://opentelemetry.io/docs/specs/semconv/) and [Application Insights telemetry data model](../app/data-model-complete.md).

## Limitations

Here are some known limitations to be aware of when using OpenTelemetry with Azure Monitor:

### Known limitations in AKS auto-instrumentation and auto-configuration

- Unsupported node pools: **Windows** and **Linux Arm64**.
- OTLP **HTTP/protobuf** only; JSON payloads and **OTLP/gRPC** aren't supported.
- Selected networking scenarios such as Istio mTLS aren't supported.

### Known limitations for AMA-based ingestion

- AMA path: Application-to-agent communication over **gRPC** on local ports.
- **4317** (gRPC) for metrics
- **4319** (gRPC) for logs and traces
- **Host:** `localhost`

### Known limitations for OpenTelemetry collector ingestion

- Export OTLP over **HTTP/protobuf**.

## Next steps

- [OpenTelemetry on Azure](../app/opentelemetry.md)
- [Monitor AKS with OpenTelemetry](../app/kubernetes-open-protocol.md)
- [Dashboards with Grafana in Application Insights](../app/grafana-dashboards.md)
- [OpenTelemetry documentation](https://opentelemetry.io/docs/)
