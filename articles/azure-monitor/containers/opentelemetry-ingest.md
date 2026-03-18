---
title: OpenTelemetry Protocol Ingestion in Azure Monitor (Preview)
description: Understand the available methods for ingesting OpenTelemetry Protocol signals into Azure Monitor, including AKS monitoring, OTel Collector, and Azure Monitor Agent.
ms.topic: concept-article
ms.date: 03/18/2026
ai-usage: ai-assisted
---

# OpenTelemetry Protocol ingestion in Azure Monitor (Preview)

Azure Monitor supports native ingestion of OpenTelemetry Protocol (OTLP) traces, metrics, and logs. You can send telemetry from OpenTelemetry-instrumented applications to Azure Monitor and then explore that data through Application Insights, Dashboards with Grafana, and Log Analytics. Choose an ingestion method based on your compute environment, instrumentation strategy, and operational requirements.

> [!IMPORTANT]
> OTLP ingestion in Azure Monitor is currently in **preview**. For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Collect and analyze OpenTelemetry data

Use this guide when you need an end-to-end overview of OTLP capabilities in Azure Monitor. It covers onboarding paths, supported experiences such as Application Insights and Dashboards with Grafana, and how to query telemetry with OpenTelemetry semantic conventions in Log Analytics.

For more information, see [Use OpenTelemetry with Azure Monitor](collect-use-observability-data.md).

## Monitor AKS applications with OTLP

Use the information at [Monitor AKS applications with OTLP and Azure Monitor](kubernetes-open-protocol.md) when your workloads run on Azure Kubernetes Service. It walks through enabling cluster-level monitoring, creating an OTLP-enabled Application Insights resource, and onboarding applications with autoinstrumentation or autoconfiguration at the namespace or deployment scope.

## Ingest OTLP data with Azure Monitor Agent

Use the information at [Ingest OTLP data into Azure Monitor with AMA](opentelemetry-ingest-agent.md) when your applications run on Azure VMs, Virtual Machine Scale Sets, or Azure Arc-enabled servers. The Azure Monitor Agent provides a simplified ingestion path that handles authentication and routing to Azure Monitor endpoints locally on the host.

## Ingest OTLP data with the OpenTelemetry Collector

Use the information at [Ingest OTLP data into Azure Monitor with OTel Collector](opentelemetry-protocol-ingestion.md) when you need maximum flexibility or operate in non-Azure environments. The OpenTelemetry Collector sends data directly to Azure Monitor cloud ingestion endpoints using Microsoft Entra authentication and supports any environment where the Collector can run.

## Related content

- [OpenTelemetry on Azure](../app/opentelemetry-overview.md)
- [Dashboards with Grafana in Application Insights](../app/grafana-dashboards.md)
- [OpenTelemetry documentation](https://opentelemetry.io/docs/)
