---
title: Azure Monitor overview
description: Overview of Microsoft services and functionalities that contribute to a complete monitoring strategy for your Azure services and applications.
ms.topic: overview
ms.date: 08/26/2025
ai-usage: ai-assisted
---

# Azure Monitor overview
Azure Monitor is Microsoft's unified observability service for collecting, analyzing, and acting on telemetry from cloud and hybrid environments. It enables you to understand the health, performance, and reliability of your Azure applications and infrastructure resources by bringing together metrics, logs, traces, and events into a single, scalable observability experience.

Azure Monitor includes a data platform that provides storage and retrieval for large data volumes supporting observability workloads and other services such as Defender for Cloud and Microsoft Sentinel. In addition to supporting Azure Monitor features, the Azure Monitor data platform also provides supports other services such as Defender for Cloud and Microsoft Sentinel. This simplifies your management infrastructure and allows you to leverage your investment in query languages and analysis tools.

:::image type="content" source="media/overview/overview-simple-20230707-opt.svg" alt-text="Diagram that shows an overview of Azure Monitor with data sources sending data, and Azure Monitor features using the collected data." border="false" lightbox="media/overview/overview-simple-20230707-opt.svg":::

## Monitor your cloud resources
Azure Monitor collects logs and metrics from all the resources across the different Azure services that you use, including audit logs from Entra ID. This monitoring data is integrated into the [Azure portal experience](../platform/monitor-azure-resource.md) for each service. View a summary of the health and performance of your resources and then drill down into more detailed monitoring data and analysis tools to investigate and troubleshoot issues. Some services also provide dedicated monitoring experiences called Azure Monitor insights that deliver deep visibility into the performance and operation of your cloud resources.

## Monitor your Infrastructure
Azure Monitor provides complete monitoring of your [virtual machines](../vm/vminsights-overview.md) and [Kubernetes clusters](../containers/kubernetes-monitoring-overview.md) that make up the infrastructure of many environments. Built in portal experiences allow you to drill down on different components to view their configuration, operation, and performance details. 

[Azure Network Watcher](network-watcher/network-watcher-overview) provides a suite of tools to monitor the network health of your infrastructure resources. This tool is built on the Azure Monitor data platform giving you a consistent monitoring experience across your infrastructure.

## Monitor your Applications
[Application Insights](../app/app-insights-overview.md) in Azure Monitor delivers deep visibility into the performance, reliability, and usage of your applications across cloud and hybrid environments. It automatically collects telemetry such as requests, dependencies, exceptions, and traces to help you quickly diagnose issues and understand user behavior.

## Monitor your agents
Application insights provides a unified experience for [monitoring AI agents](../app/agents-view.md) across multiple sources including Azure AI Foundry, Copilot Studio, and third-party agents. This feature consolidates telemetry and diagnostics, enabling you to track agent performance, analyze token usage and costs, troubleshoot errors, and optimize your agent's behavior.

## Data collection
Azure Monitor provides a variety of methods to onboard resources and customize data collection, whether using the Azure portal, a command line, or automating through policy. [Data collection rules](../data-collection/data-collection-rule-overview.md) define different scenarios including what should be collected and where it should be sent. Refine data collection for your unique requirements using advanced features such as [transformations](../data-collection/data-collection-transformations.md) that allow you preprocess your data to optimize your costs or fine tune your queries.

For particularly large data volumes and to support environments with intermittent connectivity, deploy the [Azure Monitor pipeline](../data-collection/pipeline-overview.md). This feature extends the data collection capabilities of Azure Monitor into your own data center. Data is processed and potentially cached and filtered locally before being sent to the Azure cloud.

## Data platform
[Log Analytics workspaces](../logs/log-analytics-workspace-overview.md) in Azure Monitor collect log and trace data which can then be analyzed with Kusto Query Language (KQL) queries. Optimize your costs by configuring tables in Log Analytics workspace for different pricing tiers based on your required functionality. [Azure Monitor workspaces](../metrics/azure-monitor-workspace-overview.md) collect Prometheus and OpenTelemetry metrics, which can then be analyzed using PromQL.


## Analyze and visualize data
In addition to integrating monitoring data into the Azure portal experience for different services, Azure Monitor provides multiple options to [visualize your monitoring data](../visualize/best-practices-visualize.md) for analysis. Use prebuilt dashboards and workbooks in the Azure portal or create your own custom dashboards. For ad-hoc analysis and investigation, use Azure Monitor tools write KQL and PromQL queries.

## Alerting
[Alerts in Azure Monitor](../alerts/alerts-overview.md) proactively notify you when issues occur so that you can respond to them before they affect your customers. AIOps capabilities such as [dynamic alert thresholds](../alerts/alerts-dynamic-thresholds.md) and [smart alerts](../alerts/proactive-diagnostics.md) use machine learning to assist in alert configuration and response. Use the [Azure Copilot observability agent](../aiops/observability-agent-overview.md) to leverage AI in the investigation of issues by automatically analyzing related telemetry and suggesting potential root causes.

## Hybrid environments
Azure Monitor isn't only designed to monitor Azure environments but can act as a [centralized monitoring solution](./best-practices-multicloud.md) for your hybrid environments. Use [Azure Arc](/azure/azure-arc/overview) to connect your resources in other clouds and on-premises to monitor them alongside your Azure resources. 

You can also choose to centralize your monitoring on another platform and rely on Azure Monitor to provide telemetry for your Azure resources and applications. Use [Azure Event Hubs](../platform/stream-monitoring-data-event-hubs.md) to stream your data outside of Azure Monitor or integrate with [observability partners](/azure/partner-solutions/partners#observability-partners).

## Standards
Azure Monitor embraces open source standards allowing you to leverage your investment in different technologies and skills sets and also to integrate Azure Monitor into your existing hybrid environments. 

- **OpenTelemetry** is an open‑source observability framework for instrumenting and collecting telemetry data. [Azure Monitor leverages OpenTelemetry](../app/opentelemetry.md) for monitoring applications and infrastructure, allowing you to standardize on a common, vendor‑neutral instrumentation and data model across Azure Monitor and other monitoring platforms.
- **Prometheus** is a popular open-source monitoring and alerting solution widely used in the cloud-native ecosystem. Use [Azure Monitor managed service for Prometheus](../metrics/prometheus-metrics-overview.md) to monitor your Kubernetes clusters or integrate with your own self-managed Prometheus environment.
- **Prometheus Query Language (PromQL)** is a functional query language used to retrieve and aggregate time‑series metrics. [Azure Monitor supports PromQL](../metrics/metrics-explorer.md) to query and analyze metrics from Prometheus‑based sources and OpenTelemetry‑collected metrics.
- **Grafana** is an open‑source visualization and analytics platform commonly used for observability dashboards. [Azure Monitor dashboards with Grafana](../visualize/visualize-grafana-overview.md) allow you to work with any Grafana dashboards  with Azure Monitor data in the Azure portal. Use Azure Managed Grafana to access other data sources and integrate with your existing environment.
- **Kusto Query Language (KQL)** is the primary query language used across Azure Monitor, Microsoft Sentinel, Azure Resource Graph, and other Azure services. While not an open standard, KQL provides a consistent and powerful query experience across Microsoft observability and security services.



## Next steps

* [Getting started with Azure Monitor](getting-started.md)
* [Sources of monitoring data for Azure Monitor](data-sources.md)
* [Data collection in Azure Monitor](../essentials/data-collection.md)
