---
title: Azure Monitor overview
description: Overview of Microsoft services and functionalities that contribute to a complete monitoring strategy for your Azure services and applications.
ms.topic: overview
ms.date: 02/19/2026
ai-usage: ai-assisted
---

# Azure Monitor overview
Azure Monitor is Microsoft's unified observability service for collecting, analyzing, and acting on telemetry from cloud and hybrid environments. It enables you to understand the health, performance, and reliability of your Azure applications and infrastructure resources by bringing together metrics, logs, traces, and events into a single observability experience.

In addition to supporting Azure Monitor features, the Azure Monitor data platform also supports other services such as Defender for Cloud and Microsoft Sentinel. This simplifies your management infrastructure allowing you to leverage your investment in a common set of query languages and analysis tools.

:::image type="content" source="media/overview/overview.png" alt-text="Diagram that shows an overview of Azure Monitor with data sources sending data, and Azure Monitor features using the collected data." border="false" lightbox="media/overview/overview.png":::

## Monitor your cloud resources
Azure Monitor collects logs and metrics from all the resources across the different Azure services that you use, including audit logs from Entra ID. This monitoring data is integrated into the Azure portal experience for each service. View a summary of the health and performance of your resources and then drill down into more detailed monitoring data and analysis tools to investigate and troubleshoot issues. Some services also provide dedicated monitoring experiences called Azure Monitor insights that deliver deep visibility into the performance and operation of your cloud resources.

See [Monitor Azure resources](../platform/monitor-azure-resource.md).

## Monitor your infrastructure
Azure Monitor monitors the health and performance of your virtual machines and Kubernetes clusters that make up the infrastructure of many environments. Collect event logs in addition to OpenTelemetry and Prometheus metrics and drill down on different components to view their configuration, operation, and performance details. Azure Network Watcher provides a suite of tools that use the Azure Monitor data platform to monitor the network health of your infrastructure resources.

See [Monitor Azure Virtual Machines](/azure/virtual-machines/monitor-vm), [Monitor Kubernetes](../containers/kubernetes-monitoring-overview.md), [Network Watcher](/azure/network-watcher/network-watcher-overview).

## Monitor your applications
Application Insights is an OpenTelemetry feature of Azure Monitor that offers application performance monitoring (APM) for live web applications. Integrating with OpenTelemetry (OTel) provides a vendor-neutral approach to collecting and analyzing telemetry data, enabling comprehensive observability of your applications.

See [Application Insights](../app/app-insights-overview.md).

## Monitor your agents
Application Insights provides a unified experience for monitoring AI agents across Microsoft Foundry, Copilot Studio, and third‑party agent frameworks. It consolidates telemetry and diagnostics, enabling developers to track agent performance, troubleshoot errors, and optimize agent behavior. Through its integration with Microsoft Foundry, Application Insights delivers real‑time observability for operators of generative AI workloads, with built‑in dashboards that surface key operational metrics such as token consumption, latency, error rates, and quality scores.

See [Monitor AI agents](../app/agents-view.md) and [Observability in generative AI](/azure/ai-foundry/concepts/observability).

## Azure Monitor data platform
Azure Monitor has a centralized data platform to support collection of telemetry from a variety of sources and support the different features for analysis and troubleshooting. Log Analytics workspaces collect log and trace data which can be analyzed with Kusto Query Language (KQL). Azure Monitor workspaces collect Prometheus and OpenTelemetry metrics, which can be analyzed using Prometheus Query Language (PromQL).

See [Azure Monitor data platform](./data-platform.md).

## Analyze and visualize data
In addition to integrating monitoring data into the Azure portal experience for different services, Azure Monitor provides multiple options to visualize your monitoring data or perform ad-hoc analysis. Use prebuilt workbooks and Grafana dashboards in the Azure portal or create your own custom dashboards. 

See [Visualize data](../visualize/best-practices-visualize.md).

## Troubleshooting and diagnostics
Use interactive analysis tools such as metrics explorer and Log Analytics to investigate failures, correlate events, and identify performance bottlenecks across applications and resources. For an agentic troubletooting experience, use the observability agent to help analyze telemetry, detect anomalies, and correlate signals across data sources.

See [Azure Copilot observability agent](../aiops/observability-agent-overview.md).

## Respond to issues
Alerts in Azure Monitor proactively notify you when issues are identified in collected data so that you can proactively respond to them before they affect your customers.  AIOps capabilities such as dynamic alert thresholds and smart alerts use machine learning to assist in alert configuration and response. Autoscale is an Azure Monitor feature that automatically adds and removes resources according to the load on your application.

See [Azure Monitor alerts](../alerts/alerts-overview.md), [Smart alerts](../alerts/proactive-diagnostics.md), [Autoscale](../autoscale/autoscale-overview.md).


## Hybrid environments
Azure Monitor isn't only designed to monitor Azure environments but can act as a centralized monitoring solution for your hybrid environments. Use Azure Arc to connect your resources in other clouds and on-premises to monitor them alongside your Azure resources. For particularly large data volumes and to support environments with intermittent connectivity, deploy the Azure Monitor pipeline which extends the data collection capabilities of Azure Monitor into your own data center and other cloud providers. 

See [Multicloud monitoring](./best-practices-multicloud.md) and [Azure Monitor pipeline](../data-collection/pipeline-overview.md).

## Onboarding 
Onboard resources to Azure Monitor using a variety of methods including the Azure portal, command line, or infrastructure as code (IaC) templates. Use data collection rules to customize and filter the data that should be collected from different sources. 

See [Azure Monitor data sources and data collection methods](./data-sources.md).


## Next steps

* [Data collection in Azure Monitor](../essentials/data-collection.md)
* [Cost optimization in Azure Monitor](./best-practices-cost.md)
* [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor)

