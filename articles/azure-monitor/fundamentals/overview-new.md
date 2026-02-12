---
title: Azure Monitor overview
description: Overview of Microsoft services and functionalities that contribute to a complete monitoring strategy for your Azure services and applications.
ms.topic: overview
ms.date: 08/26/2025
ai-usage: ai-assisted
---

# Azure Monitor overview
Azure Monitor is Microsoft’s unified observability service for collecting, analyzing, and acting on telemetry from cloud and hybrid environments. It enables you to understand the health, performance, and reliability of your Azure applications and infrastructure resources by bringing together metrics, logs, traces, and events into a single, scalable observability experience.

Azure Monitor includes a data platform that provides storage and retrieval for large data volumes supporting observability workloads and other services such as Defender for Cloud and Microsoft Sentinel. In addition to supporting Azure Monitor features, the Azure Monitor data platform also provides supports other services such as Defender for Cloud, Microsoft Sentinel, and Update Manager. This simplifies your management infrastructure and allows you to leverage your investment in query languages and analysis tools.


## Monitor your cloud resources

Azure Monitor collects logs and metrics from all the resources across the different Azure services that you use. Activity logs and platform metrics are collected automatically. Create a diagnostic setting to collect resource logs which describe detailed operations conducted by each Azure resource.

Most Azure services integrate Azure Monitor into their portal experience. The Overview page will include a Monitoring tab with prebuilt performance charts for common measurements. A Monitor section in each menu provides access to valuable insights based on more detailed analysis of the metrics and logs collected for the resource. Some services also provide dedicated monitoring experiences called Azure Monitor Insights that deliver deep visibility into the performance and operation of your cloud resources.


## Monitor your Infrastructure
Azure Monitor provides complete monitoring of your virtual machines and Kubernetes clusters that make up the infrastructure of many environments.  Install the Azure Monitor agent on your machines and clusters to collect logs and metrics from their client operating systems and internal workloads. Built in portal experiences allow you to drill down on different components to view their configuration, operation, and performance details. 

Azure Network Watcher provides a suite of tools to monitor the network health of your infrastructure resources. This tool is built on the Azure Monitor data platform giving you a consistent monitoring experience across your infrastructure.

## Monitor your Applications

Application Insights is a feature of Azure Monitor that delivers deep visibility into the performance, reliability, and usage of your applications across cloud and hybrid environments. It automatically collects telemetry such as requests, dependencies, exceptions, and traces to help you quickly diagnose issues and understand user behavior. With native support for OpenTelemetry, Application Insights enables you to instrument applications using open standards while unifying data across languages and platforms. It provides powerful analytics and integration with other Azure Monitor tools to help teams proactively detect anomalies, optimize performance, and improve application resilience.

## Monitor your agents
Application insights also provides a unified experience for monitoring AI agents across multiple sources including Azure AI Foundry, Copilot Studio, and third-party agents. This feature consolidates telemetry and diagnostics, enabling you to track agent performance, analyze token usage and costs, troubleshoot errors, and optimize your agent's behavior.

## Data platform
The Azure Monitor data platform is highly scalable and supports all of its features with powerful query languages for analysis and alerting. 

Log Analytics workspaces collect log and trace data which can then be analyzed with Kusto Query Language (KQL) queries. Optimize your costs by configuring tables in Log Analytics workspace for different pricing tiers based on your required functionality. Azure Monitor workspaces collect Promethus and OpenTelemetry metrics, which can then be analyzed using PromQL.

Log Analytics and Azure Monitor workspaces can be created in different regions allowing you to geolocate your data according to your requirements. Replicate data between workspaces to ensure high availability and disaster recovery. 


## Data collection
Azure Monitor is highly scalable, collecting data from even the largest of environments. Data collection rules can be centrally configured, providing a scalable method for defining and maintaining different data collection scenarios. 

Azure Monitor provides a variety of methods to onboard resources and customize data collection, whether using the Azure portal, a command line, or automating through policy. Refine data collection for your unique requirements using advanced features such as transformations that allow you preprocess your data to optimize your costs or fine tune your queries.

For particularly large data volumes and to support environments with intermittent connectivity, deploy the Azure Monitor pipeline. This feature extends the data collection capabilities of Azure Monitor into your own data center. Data is processed and potentially cached and filtered locally before being sent to the Azure cloud.

## Standards
Azure Monitor embraces open source standards allowing you to leverage your investment in different technologies and skills sets and also to integrate Azure Monitor into your existing hybrid environments. 

- **OpenTelemetry** is an open‑source observability framework for instrumenting and collecting telemetry data. Microsoft has embraced OpenTelemetry for monitoring applications and infrastructure, allowing you to standardize on a common, vendor‑neutral instrumentation and data model across Azure Monitor and other monitoring platforms.
- **Prometheus** is a popular open-source monitoring and alerting solution widely used in the cloud-native ecosystem. Use Azure Monitor managed service for Prometheus to monitor your Kubernetes clusters or integrate with your own self-managed Prometheus environment.
- **Prometheus Query Language (PromQL)** is a functional query language used to retrieve and aggregate time‑series metrics. Azure Monitor supports PromQL to query and analyze metrics from Prometheus‑based sources and OpenTelemetry‑collected metrics.
- **Grafana** is an open‑source visualization and analytics platform commonly used for observability dashboards. Azure Monitor dashboards with Grafana allow you to work with any Grafana dashboards  with Azure Monitor data in the Azure portal. Use Azure Managed Grafana to access other data sources and integrate with your existing environment.
- **Kusto Query Language (KQL)** is the primary query language used across Azure Monitor, Microsoft Sentinel, Azure Resource Graph and other Azure services. While not an open standard, KQL provides a consistent and powerful query experience across Microsoft observability and security services.

## Hybrid environments

Azure Monitor isn’t only designed to monitor Azure environments but can act as a centralized monitoring solution for your hybrid environments. Use Azure Arc to connect your resources in other clouds and on-premises to monitor them alongside your Azure resources.  Or send data to the Azure Monitor data platform from custom applications using log and metric APIs. For particularly large environments, Azure Monitor pipeline can assist in data collection from particularly large or disconnected environments.

You can also choose to centralize your monitoring on another platform and rely on Azure Monitor to provide telemetry for your Azure resources and applications. Use Azure Event Hubs to stream your data outside of Azure Monitor or integrate with observability partners such as Datadog and Dynatrace.

## Visualization
In addition to integrating monitoring data into the Azure portal experience for different services, there are multiple options to visualize your Azure Monitor data for analysis.

- **Azure Monitor dashboards with Grafana** are automatically available in the Azure portal at no cost. Use them to create rich visualizations using prebuilt Grafana dashboards or build your own custom dashboards.
- **Managed Grafana** is a fully managed Grafana service hosted in Azure. Use it to create Grafana dashboards that integrate data from Azure Monitor and other data sources.
- **Workbooks** - Interactive reports that combine text, analytics queries, and visualizations into rich interactive experiences. Use built-in templates or create your own custom workbooks to monitor your resources.
- **Ad hoc** - Use KQL and PromQL queries to analyze your data directly in the Azure portal or export the results to other tools such as Power BI for further analysis.

## Alerting
Alerts in Azure Monitor proactively notify you when issues occur so that you can respond to them before they affect your customers. Notify different teams using a variety of methods including email, SMS, push notifications, or integration with IT service management and incident management tools such as ServiceNow and PagerDuty.

An alert can be as simple as a metric value crossing a particular threshold or can be based on a complex log query written in KQL. For Prometheus and OpenTelemetry metrics, you can leverage alerts based on PromQL. Some services will provide recommended alerts that you can quickly enable, or you can customize your own alert rules to meet your particular requirements. 

Leverage AIOps capabilities to assist in alert configuration and response. Dynamic alert thresholds detect anomalous behavior of metrics, PromQL queries, or log query results with and automatically fine tune thresholds. Smart alerts for Application insights use machine learning to detect common application failures, response times, and dependency duration. Use the observability agent to leverage AI in the investigation of issues by automatically analyzing related telemetry and suggesting potential root causes.




## Next steps

* [Getting started with Azure Monitor](getting-started.md)
* [Sources of monitoring data for Azure Monitor](data-sources.md)
* [Data collection in Azure Monitor](../essentials/data-collection.md)
