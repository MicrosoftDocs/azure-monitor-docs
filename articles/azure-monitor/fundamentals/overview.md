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
Azure Monitor collects logs and metrics from all the resources across the different Azure services that you use, including audit logs from Entra ID. This monitoring data is integrated into the [Azure portal experience](../platform/monitor-azure-resource.md) for each service. View a summary of the health and performance of your resources and then drill down into more detailed monitoring data and analysis tools to investigate and troubleshoot issues. Some services also provide dedicated monitoring experiences called Azure Monitor insights that deliver deep visibility into the performance and operation of your cloud resources.

See [Monitor Azure resources](../platform/monitor-azure-resource.md).

## Monitor your infrastructure
Azure Monitor monitors the health and performance of your virtual machines and Kubernetes clusters that make up the infrastructure of many environments. Collect event logs in addition to OpenTelemetry and Prometheus metrics and drill down on different components to view their configuration, operation, and performance details. Azure Network Watcher provides a suite of tools that use the Azure Monitor data platform to monitor the network health of your infrastructure resources.

See [Monitor Azure Virtual Machines](/azure/virtual-machines/monitor-vm), [Monitor Kubernetes](../containers/kubernetes-monitoring-overview.md), [Network Watcher](/azure/network-watcher/network-watcher-overview).

## Monitor your applications
Application Insights is an OpenTelemetry feature of Azure Monitor that offers application performance monitoring (APM) for live web applications. Integrating with OpenTelemetry (OTel) provides a vendor-neutral approach to collecting and analyzing telemetry data, enabling comprehensive observability of your applications.

See [Application Insights](../app/app-insights-overview.md).

## Monitor your agents
Application Insights provides a unified experience for monitoring AI agents across Microsoft Foundry, Copilot Studio, and third‑party agent frameworks. It consolidates telemetry and diagnostics, enabling developers and operators to track agent performance, analyze token usage and costs, troubleshoot errors, and optimize agent behavior. Through its integration with Microsoft Foundry, Application Insights delivers real‑time observability for generative AI workloads, with built‑in dashboards that surface key operational metrics such as token consumption, latency, error rates, and quality scores.

See [Monitor AI agents](../app/agents-view.md) and [Observability in generative AI](/azure/ai-foundry/concepts/observability).

## Data platform
Azure Monitor has a centralized data platform to support collection of data from multiple sources and support the different features for analysis and troubleshooting. Log Analytics workspaces in Azure Monitor collect log and trace data which can then be analyzed with Kusto Query Language (KQL) queries. Azure Monitor workspaces collect Prometheus and OpenTelemetry metrics, which can then be analyzed using PromQL queries.

See [Azure Monitor data platform](./data-platform.md).

## Data collection
Use a variety of onboarding scenarios 
Data collection rules in Azure Monitor define different scenarios including what should be collected and where it should be sent. Refine data collection for your unique requirements using advanced features such as [transformations](../data-collection/data-collection-transformations.md) that allow you preprocess your data to optimize your costs or fine tune your queries.

See [Data collection rules](../data-collection/data-collection-rule-overview.md) and .

## Analyze and visualize data
In addition to integrating monitoring data into the Azure portal experience for different services, Azure Monitor provides multiple options to visualize your monitoring data or perform ad-hoc analysis. Use prebuilt dashboards and workbooks in the Azure portal or create your own custom dashboards. For ad-hoc analysis and investigation, use Azure Monitor tools write KQL and PromQL queries.

See [Visualize data](../visualize/best-practices-visualize.md).

## Alerting
Alerts in Azure Monitor proactively notify you when issues are identified in collected data so that you can proactively respond to them before they affect your customers.  AIOps capabilities such as dynamic alert thresholds and smart alerts use machine learning to assist in alert configuration and response. 

See [Azure Monitor alerts](../alerts/alerts-overview.md) and [Smart alerts](../alerts/proactive-diagnostics.md).


## Troubleshooting and diagnostics
Use the 
Use the [Azure Copilot observability agent](../aiops/observability-agent-overview.md) to leverage AI in the investigation of issues by automatically analyzing related telemetry and suggesting potential root causes.

## Hybrid environments
Azure Monitor isn't only designed to monitor Azure environments but can act as a centralized monitoring solution for your hybrid environments. Use Azure Arc to connect your resources in other clouds and on-premises to monitor them alongside your Azure resources. For particularly large data volumes and to support environments with intermittent connectivity, deploy the Azure Monitor pipeline which extends the data collection capabilities of Azure Monitor into your own data center. 

See [Multicloud monitoring](./best-practices-multicloud.md and [Azure Monitor pipeline](../data-collection/pipeline-overview.md).



- **Grafana** is an open‑source visualization and analytics platform commonly used for observability dashboards. [Azure Monitor dashboards with Grafana](../visualize/visualize-grafana-overview.md) allow you to work with any Grafana dashboards  with Azure Monitor data in the Azure portal. Use Azure Managed Grafana to access other data sources and integrate with your existing environment.
- **Kusto Query Language (KQL)** is the primary query language used across Azure Monitor, Microsoft Sentinel, Azure Resource Graph, and other Azure services. While not an open standard, KQL provides a consistent and powerful query experience across Microsoft observability and security services.



## Next steps

* [Getting started with Azure Monitor](getting-started.md)
* [Sources of monitoring data for Azure Monitor](data-sources.md)
* [Data collection in Azure Monitor](../essentials/data-collection.md)
