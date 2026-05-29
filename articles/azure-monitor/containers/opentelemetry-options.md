---
title: OpenTelemetry with Azure Monitor (Preview)
description: Centralized guide to OpenTelemetry in Azure Monitor: native OTLP ingestion, the Microsoft OpenTelemetry Distro, and end-to-end observability experiences.
ms.topic: concept-article
ms.reviewer: kaprince
ms.date: 05/29/2026
ai-usage: ai-assisted

#customer intent: As a developer or cloud architect, I want to understand how Azure Monitor supports OpenTelemetry so that I can choose between native OTLP ingestion and the Microsoft OpenTelemetry Distro for my applications.

---

# OpenTelemetry with Azure Monitor (Preview)

> [!IMPORTANT]
> * This feature is in **preview**. Preview features are provided without a service-level agreement and aren't recommended for production workloads.
> * For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

Azure Monitor supports OpenTelemetry in two complementary approaches.

First, Azure Monitor now offers native OpenTelemetry Protocol (OTLP) ingestion paths so you can send standard OpenTelemetry logs, metrics, and traces into Azure Monitor using the open-source OpenTelemetry Collector, Azure Monitor Agent, or Azure Kubernetes Service (AKS)–integrated onboarding experiences for applications instrumented with open-source OpenTelemetry SDKs.

Second, Azure Monitor supports the Microsoft OpenTelemetry Distro, an OpenTelemetry client distribution that bundles all the open-source and Microsoft components required for a fully integrated experience with Azure Monitor for both AI agent and traditional applications. Together, these options let you choose a vendor-neutral OTLP path or a Microsoft-supported instrumentation path powered by OpenTelemetry components. Both approaches enable investigation, analytics, and visualization workflows in Azure Monitor.

Azure Monitor supports OpenTelemetry in two ways: native OTLP ingestion and the Microsoft OpenTelemetry Distro.

## Native OpenTelemetry support with OTLP ingestion

Azure Monitor supports direct ingestion of OpenTelemetry signals using OTLP, the open standard for transmitting logs, metrics, and traces. This path is available to teams that already use open-source OpenTelemetry SDKs, require vendor-neutral instrumentation, or are standardizing on open-source tooling across multiple environments. Azure Monitor can receive OTLP signals through AKS-integrated onboarding, the Azure Monitor Agent on virtual machines and Arc-enabled servers, or by directly receiving OTLP at Azure Monitor cloud ingestion endpoints from an open-source OpenTelemetry Collector.

- Supports vendor-neutral telemetry pipelines and portable instrumentation practices.
- Stores metrics in an Azure Monitor workspace, a Prometheus data store that you can query with PromQL and visualize in Grafana.
- Stores logs and traces in Azure Monitor Log Analytics using OpenTelemetry semantic conventions, making analysis more consistent across tools and environments.
- Works across AKS, Azure virtual machines, Virtual Machine Scale Sets, Azure Arc-enabled servers, and other environments through the open-source OpenTelemetry Collector.
- Routes all telemetry into Azure Monitor so you can use Application Insights, Log Analytics, Azure Monitor dashboards with Grafana (built into the Azure portal), and Azure Managed Grafana.

## Microsoft OpenTelemetry Distro

The Microsoft OpenTelemetry Distro includes open-source OpenTelemetry instrumentations and other components for .NET, Java, Node.js, and Python. It adds Microsoft-specific capabilities, integrations, and defaults for Microsoft's observability solutions. By using this Distro, you can adopt OpenTelemetry instrumentation while benefiting from a solution that's validated and officially supported by Microsoft. Microsoft contributes enhancements back to the upstream open-source SDKs when possible, but official support applies only to the Microsoft-published distros (.NET, Java, Node.js, and Python).

- Bundles instrumentation libraries and exporters for traces, metrics, logs, and exceptions.
- Includes additional Azure Monitor capabilities such as application profiling, live streaming of metrics, trace sampling, and advanced [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview) on ingested data.
- Simplifies setup and configuration for teams that want a Microsoft-supported and optimized path.

This path is especially relevant for teams that want to adopt modern OpenTelemetry instrumentation without giving up Azure Monitor capabilities. If you're using the Azure Monitor OpenTelemetry Distro, the APIs are nearly identical, so you can swap the packages for the new *Microsoft* OpenTelemetry Distro.

## Choose the right option

The Microsoft OpenTelemetry Distro is fully supported by Microsoft and ensures you get the most out of Azure Monitor. However, some teams need to use community components for vendor-neutral instrumentation and multicloud support. In these cases, direct OTLP ingestion is the right choice.

- **If you're an existing Application Insights customer:** The Microsoft OpenTelemetry Distro is the best fit when you want to move to OpenTelemetry while preserving rich Azure Monitor experiences and retain access to new capabilities like dedicated AI agent observability workflows.
- **If you're adopting vendor-neutral OpenTelemetry:** OTLP ingestion lets you keep open-source SDKs and standard pipelines while enabling you to send telemetry into Azure Monitor and take advantage of Application Insights workflows and ready-to-use dashboards for triage and troubleshooting.
- **If you run cloud-native workloads with Prometheus and Grafana:** Azure Monitor OTLP ingestion includes an Azure Monitor workspace for Prometheus metrics and supports visualization through built-in Azure Monitor dashboards with Grafana in the Azure portal or through Azure Managed Grafana, helping you stay aligned with open-source observability patterns while using Azure-managed services.

Azure Monitor's OpenTelemetry support spans instrumentation, ingestion, storage, and visualization. Pick the path that matches your team's open-source or Microsoft-supported preference.

## Related content

- [Enable Azure Monitor OpenTelemetry for .NET, Node.js, Python, and Java applications](../app/opentelemetry-enable.md)
- [Ingest OTLP data into Azure Monitor with OTel Collector](opentelemetry-protocol-ingestion.md)
- [Choose an OpenTelemetry onboarding path](collect-use-observability-data.md#choose-an-onboarding-path)
