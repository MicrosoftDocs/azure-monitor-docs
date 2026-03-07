---
title: OpenTelemetry on Azure
description: This article links to Application Insights and other Azure OpenTelemetry documentation.
ms.topic: overview
ms.date: 03/06/2026
---

# OpenTelemetry on Azure

Azure services and tools use OpenTelemetry for the following tasks:

> [!div class="checklist"]
> - Collect telemetry in a standard format
> - Analyze telemetry with Azure Monitor and local tools

This article links to product-specific guidance for Application Insights and other Azure services that use OpenTelemetry.

## Application Insights experiences

Use [Collect OpenTelemetry for Application Insights experiences](opentelemetry-overview.md) for Application Insights data collection by scenario:

- [Web apps](opentelemetry-overview.md?tabs=#web-apps)
- [Virtual machines](opentelemetry-overview.md?tabs=vm)
- [Azure Functions](opentelemetry-overview.md?tabs=functions)
- [Azure Kubernetes Service (AKS)](opentelemetry-overview.md?tabs=kubernetes)
- [Artificial intelligence (AI) agents](opentelemetry-overview.md?tabs=agents)

Use the following resources for Application Insights features, autoinstrumentation, and migration guidance:

- [Application Insights experiences](app-insights-overview.md#application-insights-experiences)
- [Application Insights autoinstrumentation](codeless-overview.md)
- [Migration from Application Insights classic SDKs to Azure Monitor OpenTelemetry](migrate-to-opentelemetry.md)
- [Python migration from OpenCensus to OpenTelemetry](opentelemetry-python-opencensus-migrate.md)

## Other OpenTelemetry integrations on Azure

Use the following resources for Azure services, software development kits (SDKs), and tools that use OpenTelemetry:

- [Azure SDK semantic conventions](https://github.com/Azure/azure-sdk/blob/main/docs/observability/opentelemetry-conventions.md)
- [Java tracing in the Azure SDK](/azure/developer/java/sdk/tracing)
- [Azure Cosmos DB SDK observability](/azure/cosmos-db/nosql/sdk-observability)
- [.NET observability with OpenTelemetry](/dotnet/core/diagnostics/observability-with-otel)
- [Azure Monitor pipeline at edge and multicloud configuration](.essentials/edge-pipeline-configure.md)
- [OpenTelemetry ingestion into Azure Data Explorer, Azure Synapse Data Explorer, and Real-Time Intelligence](/azure/data-explorer/open-telemetry-connector)
- [Azure Container Apps OpenTelemetry agent](/azure/container-apps/opentelemetry-agents)
- [Aspire dashboard overview](/dotnet/aspire/fundamentals/dashboard/overview)