---
title: OpenTelemetry ingestion options (preview)
description: Compare OpenTelemetry Protocol (OTLP) ingestion options in Azure Monitor, including AKS monitoring, Azure Monitor Agent, and the OpenTelemetry Collector.
ms.topic: concept-article
ms.date: 03/30/2026
ms.reviewer: kaprince
ai-usage: ai-assisted

#customer intent: As a cloud engineer, I want to understand the OpenTelemetry ingestion options in Azure Monitor so that I can choose the right approach for my environment.

---

# OpenTelemetry ingestion options for Azure Monitor (preview)

OpenTelemetry Protocol (OTLP) is an open standard for transmitting traces, metrics, and logs from applications and infrastructure to observability backends. Azure Monitor supports OTLP ingestion so you can collect telemetry from your workloads without proprietary instrumentation.

Different compute environments—Azure Kubernetes Service (AKS), virtual machines, Azure Arc-enabled servers, hybrid clouds—call for different ingestion approaches. Choosing the wrong path can mean extra infrastructure to manage or gaps in the telemetry you collect.

This article describes each ingestion option and when to use it, so you can pick the approach that matches your environment and operational requirements.

> [!IMPORTANT]
> OTLP ingestion in Azure Monitor is currently in preview.
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

## End-to-end onboarding with OpenTelemetry and Azure Monitor

Use this approach when you need a comprehensive view of the available onboarding paths, supported experiences, and data exploration options across Application Insights, Dashboards with Grafana, and Log Analytics. It's the best starting point if you're evaluating OpenTelemetry support in Azure Monitor for the first time and want to understand the full scope of capabilities before you choose a specific ingestion method.

For more information, see [Use OpenTelemetry with Azure Monitor](collect-use-observability-data.md).

## AKS application monitoring with OpenTelemetry Protocol (OTLP)

Use this approach when your applications run on Azure Kubernetes Service (AKS) and you want cluster-integrated monitoring with autoinstrumentation or autoconfiguration for traces, metrics, and logs. It provides a managed experience that handles agent deployment, identity management, and telemetry routing at the namespace or deployment scope. You can onboard workloads without managing collector infrastructure separately.

For more information, see [Monitor AKS applications with OTLP and Azure Monitor](kubernetes-open-protocol.md).

## OpenTelemetry Protocol (OTLP) ingestion with Azure Monitor Agent

Use this approach when your applications run on Azure virtual machines, Virtual Machine Scale Sets, or Azure Arc-enabled servers and you want a host-level agent that handles authentication and routing to Azure Monitor endpoints. Azure Monitor Agent simplifies the ingestion pipeline by receiving OTLP traces, metrics, and logs locally and forwarding them to the appropriate destinations without requiring you to manage a separate collector deployment.

For more information, see [Ingest OTLP data into Azure Monitor with AMA](opentelemetry-ingest-agent.md).

## OTLP ingestion with the OpenTelemetry Collector

Use this approach when you need maximum deployment flexibility or operate in environments outside Azure where the Azure Monitor Agent isn't available. The OpenTelemetry Collector sends data directly to Azure Monitor cloud endpoints by using Microsoft Entra authentication. It supports any platform where the Collector can run, making it the most versatile option for hybrid and multicloud scenarios.

For more information, see [Ingest OTLP data into Azure Monitor with OTel Collector](opentelemetry-protocol-ingestion.md).

## Related content

- [Enable OpenTelemetry in Application Insights](../app/opentelemetry-enable.md)
- [Dashboards with Grafana in Application Insights](../app/grafana-dashboards.md)
- [OpenTelemetry documentation](https://opentelemetry.io/docs/)
