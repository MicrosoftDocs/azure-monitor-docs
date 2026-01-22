---
title: Azure Monitor overview
description: Overview of Microsoft services and functionalities that contribute to a complete monitoring strategy for your Azure services and applications.
ms.topic: overview
ms.date: 08/26/2025
ai-usage: ai-assisted
---

# Azure Monitor overview
Azure Monitor is Microsoft’s unified observability platform for collecting, analyzing, and acting on telemetry from cloud and hybrid environments. It enables you to understand the health, performance, and reliability of your Azure applications and infrastructure resources by bringing together metrics, logs, traces, and events into a single, scalable observability experience.

## Monitor your cloud resources

Azure Monitor collects logs and metrics from all the resources across the different Azure services that you use. Activity logs and platform metrics are collected automatically. Create a diagnostic setting to collect resource logs which describe detailed operations conducted by each Azure resource.
Most Azure services integrate Azure Monitor into their portal experience. The Overview page will include a Monitoring tab with prebuilt performance charts for common measurements. A Monitor section in each menu provides access to valuable insights based on more detailed analysis of the metrics and logs collected for the resource.

## Monitor your Infrastructure
Azure Monitor provides complete monitoring of your virtual machines and Kubernetes clusters that make up the infrastructure of many environments.  Install the Azure Monitor agent on your machines and clusters to collect logs and metrics from their client operating systems and internal workloads. Built in portal experiences allow you to drill down on different components to view their configuration, operation, and performance details. 

Azure Network Watcher provides a suite of tools to monitor the network health of your infrastructure resources. This tool is built on the Azure Monitor data platform giving you a consistent monitoring experience across your infrastructure.

## Monitor your Applications

Application Insights is a feature of Azure Monitor that delivers deep visibility into the performance, reliability, and usage of your applications across cloud and hybrid environments. It automatically collects telemetry such as requests, dependencies, exceptions, and traces to help you quickly diagnose issues and understand user behavior. With native support for OpenTelemetry, Application Insights enables you to instrument applications using open standards while unifying data across languages and platforms. It provides powerful analytics and integration with other Azure Monitor tools to help teams proactively detect anomalies, optimize performance, and improve application resilience.

## Data platform
At the core of Azure Monitor is a highly scalable data platform that supports all of its features and provides powerful query languages for analysis and alerting. 

Log Analytics workspaces collect log and trace data which can then be analyzed with Kusto Query Language (KQL) queries. Optimize your costs by configuring tables in Log Analytics workspace for different pricing tiers based on your required functionality. Azure Monitor workspaces collect Promethus and OpenTelemetry metrics, which can then be analyzed using PromQL.

Log Analytics and Azure Monitor workspaces can be created in different regions allowing you to geolocate your data according to your requirements. Replicate data between workspaces to ensure high availability and disaster recovery. 

In addition to supporting Azure Monitor features, the Azure Monitor data platform also provides supports other services such as Defender for Cloud, Microsoft Sentinel, and Update Manager. This simplifies your management infrastructure and allows you to leverage your investment in query languages and analysis tools.

## Data collection
Azure Monitor is highly scalable, collecting data from even the largest of environments. Data collection rules can be centrally configured, providing a scalable method for defining and maintaining different data collection scenarios. 

Azure Monitor provides a variety of methods to onboard resources and customize data collection, whether using the Azure portal, a command line, or automating through policy. Refine data collection for your unique requirements using advanced features such as transformations that allow you preprocess your data to optimize your costs or fine tune your queries.

For particularly large data volumes and to support environments with intermittent connectivity, deploy the Azure Monitor pipeline. This feature extends the data collection capabilities of Azure Monitor into your own data center. Data is processed and potentially cached and filtered locally before being sent to the Azure cloud.

## Standards
Azure Monitor embraces open source standards allowing you to leverage your investment in different technologies and skills sets and also to integrate Azure Monitor into your existing hybrid environments. 

- OpenTelemetry is an open‑source observability framework for instrumenting and collecting telemetry data. Microsoft has embraced OpenTelemetry for monitoring applications and infrastructure, allowing you to standardize on a common, vendor‑neutral instrumentation and data model across Azure Monitor and other monitoring platforms.
- Prometheus is a popular open-source monitoring and alerting solution widely used in the cloud-native ecosystem. Use Azure Monitor managed service for Prometheus to monitor your Kubernetes clusters or integrate with your own self-managed Prometheus environment.
- Prometheus Query Language (PromQL) is a functional query language used to retrieve and aggregate time‑series metrics. Azure Monitor supports PromQL to query and analyze metrics from Prometheus‑based sources and OpenTelemetry‑collected metrics.
- Grafana is an open‑source visualization and analytics platform commonly used for observability dashboards. Azure Monitor dashboards with Grafana allow you to work with any Grafana dashboards  with Azure Monitor data in the Azure portal. Use Azure Managed Grafana to access other data sources and integrate with your existing environment.
- Kusto Query Language (KQL) is the primary query language used across Azure Monitor, Microsoft Sentinel, Azure Resource Graph and other Azure services. While not an open standard, KQL provides a consistent and powerful query experience across Microsoft observability and security services.

## Hybrid environments

Azure Monitor isn’t only designed to monitor Azure environments but can act as a centralized monitoring solution for your hybrid environments. Use Azure Arc to include your resources from other clouds and on-premises. Or send data to the Azure Monitor data platform from custom applications using log and metric APIs. You can also choose to centralize your monitoring on another platform and rely on Azure Monitor to provide telemetry for your Azure resources and applications. 

## Visualization
There are multiple options to analyze data collected by Azure Monitor
•	Portal
•	Insights
•	**Azure Monitor dashboards with Grafana** 
•	Managed Grafana
•	Workbooks
•	Ad hoc

## Grafana
Grafana is an open source web application that provides rich visualizations on your observability data. Libraries of prebuilt Grafana dashboards are publicly available for monitoring various common cloud resources such as Kubernetes clusters and virtual machines.
Azure Monitor dashboards with Grafana integrates Grafana dashboard into the Azure portal for no additional cost. It includes prebuilt dashboards for various Azure services, and you can build your own dashboards or install others that use data stored in Azure Monitor.
If you have an existing investment in a Grafana environment or if you want to use Grafana dashboards to access data outside of Azure Monitor, then use Azure Managed Grafana which provides a fully managed version of Grafana hosted in Azure.

## Alerting
Alerts in Azure Monitor proactively notify you when issues occur so that you can respond to them before they affect your customers. An alert can be a simple as a metric value crossing a particular threshold or can be based on a complex log query written in KQL. For Prometheus and OpenTelemetry metrics, you can leverage alerts based on PromQL.
Some services will provide recommended alerts that you can quickly enable, or you can customize your own alert rules to meet your particular requirements.
Data Analysis

 

Features of Azure Monitor
1. Data Collection
Azure Monitor collects telemetry data from a wide range of sources, including Azure resources, virtual machines, containers, and applications. Data types collected include metrics (numerical values over time), logs (structured and unstructured events), traces (distributed transaction data), and changes (resource configuration history). Data collection is agent-based or agentless, and integrates natively with Azure services to ensure comprehensive coverage.
2. Data Platform
All collected telemetry is ingested into a scalable data platform. Azure Monitor leverages Azure Log Analytics Workspace as its main repository, offering powerful indexing, querying, and retention capabilities. The platform supports high-volume ingestion, secure storage, and data management, enabling organizations to retain historical data for compliance and trend analysis. It also enables data enrichment and correlation across multiple sources.
3. Ad Hoc Analysis
Azure Monitor provides robust tools for ad hoc analysis of collected data. Users can query logs and metrics using Kusto Query Language (KQL) within the Azure portal or via APIs. These capabilities enable deep investigation into incidents, performance bottlenecks, and security events. Advanced analytics features, such as anomaly detection and machine learning integration, empower users to proactively identify issues and uncover patterns.
4. Visualization of Data
Data visualization is core to Azure Monitor's value proposition. Users can create interactive dashboards using Azure Workbooks, which allow for custom charts, tables, and narrative text. The platform also provides built-in views for common scenarios, such as application performance, infrastructure health, and security monitoring. Alerts and notifications can be configured based on thresholds or query results, ensuring timely response to critical events.
Support for Open Source Standards
Azure Monitor is committed to interoperability with open source observability standards and tools:
•	OpenTelemetry: Azure Monitor supports OpenTelemetry, enabling users to instrument their applications with standardized APIs and SDKs for metrics, logs, and traces. This facilitates seamless integration with multi-cloud and hybrid environments.
•	Prometheus: Native integration with Prometheus allows users to collect and query metrics from Kubernetes clusters and other workloads. Azure Monitor can scrape Prometheus endpoints and store metrics for analysis and alerting.
•	Grafana: Azure Monitor offers a dedicated data source plugin for Grafana, enabling users to visualize Azure telemetry data in Grafana dashboards. This supports organizations leveraging Grafana for unified monitoring across cloud and on-premises resources.
Reference: Azure Cloud Adoption Framework
The Azure Cloud Adoption Framework provides best practices for monitoring and observability in the cloud. It emphasizes establishing a monitoring strategy aligned with business objectives, selecting appropriate tools (such as Azure Monitor), and leveraging automation for alerting and remediation. For more details, refer to the official Cloud Adoption Framework monitoring documentation.



## Next steps

* [Getting started with Azure Monitor](getting-started.md)
* [Sources of monitoring data for Azure Monitor](data-sources.md)
* [Data collection in Azure Monitor](../essentials/data-collection.md)
