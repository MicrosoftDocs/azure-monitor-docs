---
title: Azure Monitor enterprise monitoring architecture
description: Sample architecture for Azure Monitor in an enterprise environment.
ms.topic: conceptual
ms.date: 03/17/2025
ms.reviewer: bwren
---

# Azure Monitor enterprise monitoring architecture

Monitoring is the process of collecting, analyzing, and acting on metrics, logs, and transactions indicating the health of your platform, resources, and applications. An effective monitoring environment includes your entire cloud estate which may include resources across multiple clouds and on-premises. 

This architecture describes a flexible strategy for monitoring your enterprise environment using Azure Monitor. Use this architecture as a starting point for implementing a monitoring solution that meets your organization's variety of unique requirements.

## Architecture

:::image type="content" source="media/enterprise-monitoring-architecture/architecture-diagram.png" lightbox="media/enterprise-monitoring-architecture/architecture-diagram.png" alt-text="Diagram of enterprise monitoring with Azure Monitor." border="false":::


### Workflows

The following workflows correspond to the above diagram:

- Data collection. Data for Azure Monitor is stored in [Log Analytics workspace](/azure/azure-monitor/logs/log-analytics-workspace-overview) (logs and metrics), [Azure Monitor workspace](/azure/azure-monitor/essentials/azure-monitor-workspace-overview) (Prometheus metrics), and [Azure Monitor Metrics](/azure/azure-monitor/essentials/data-platform-metrics) (platform metrics). Data sources in different subscriptions send data to the Log Analytics workspaces and Azure Monitor workspaces in the management subscription. Platform metrics are stored in the same subscription as the Azure resource and are sent to the Log Analytics workspace so that they can be correlated with other data sources. 

- Alerting. Log query and Prometheus alert rules are created in the management subscription and access the Log Analytics workspace and Azure Monitor workspace. Each set of workspaces has its own set of alert rules created in the same resource group as the workspaces. Metric alert rules are created in the management subscription and access platform metrics in the resource subscriptions.

- Integrations. Microsoft Sentinel uses the same Log Analytics workspace and Azure Monitor agent (AMA) as Azure Monitor, so you can leverage this same architecture for SIEM capabilities. ITSM integration is performed in response to Azure Monitor alerts using the ITSM connector in Azure Monitor. When an alert is generated, a ticket is created in the ITSM system.

## Components

- [Azure Monitor](/azure/azure-monitor/overview) is the primary monitoring solution for Azure providing a comprehensive solution for collecting, analyzing, and acting on telemetry from your cloud and on-premises environments. In addition to providing a full stack monitoring solution for your applications and infrastructure, Azure Monitor includes a data platform and other core features leveraged by other services in the Azure observability ecosystem.
  - [Azure Monitor Logs](/azure/azure-monitor/logs/data-platform-logs) is a centralized platform for collecting, analyzing, and acting on telemetry collected by Azure Monitor.
  - [Azure Monitor managed service for Prometheus](/azure/azure-monitor/essentials/prometheus-metrics-overview) is a scalable and highly available Prometheus service that is built on Azure Monitor. It provides a fully managed, scalable, and secure service that ingests Prometheus metrics and stores them in an Azure Monitor workspace.
  - [Azure Monitor agent](/azure/azure-monitor/agents/azure-monitor-agent-overview) collects monitoring data from the guest operating system and workloads of virtual machines and sends it to Azure Monitor. It's also used by Kubernetes clusters to collect container logs and Prometheus metrics.
  - [Application Insights](/azure/azure-monitor/app/app-insights-overview) is an extensible Application Performance Management (APM) service for web applications on multiple platforms. It will automatically detect performance anomalies, and includes powerful analytics tools to help you diagnose issues and to understand what users actually do with your app. 
  - [Logs ingestion API](/azure/azure-monitor/logs/logs-ingestion-api-overview) lets you send data to a Log Analytics workspace using either a REST API call or client libraries. This is useful for sending data from custom applications or other solutions.
  - [Workbooks](/azure/azure-monitor/visualize/workbooks-overview) in Azure Monitor provide a flexible canvas for data analysis and the creation of rich visual reports within the Azure portal. They access data from the Azure Monitor data platform.
- [Azure Arc](/azure/azure-arc/overview) extends the Azure platform to manage and govern infrastructure and applications across on-premises, multicloud, and edge environments. It allows you to manage your hybrid resources together with your cloud resources from a single control plane. Use Azure Arc to make hybrid virtual machines and clusters available to Azure Monitor.
- [Microsoft Sentinel](/azure/sentinel/overview) is a cloud-native security information and event management (SIEM) that ingests telemetry from Azure services and other resources, including Microsoft Defender. It delivers an intelligent and comprehensive solution for SIEM and security orchestration, automation, and response (SOAR). It leverages the same Log Analytics workspace and Azure Monitor agent as Azure Monitor.
- [Microsoft Defender XDR](/defender-xdr/microsoft-365-defender) consists of a number of Defenders that are aimed a protecting various pieces of the digital estate. They correlate telemetry and use AI/ML to determine if investigations are necessary or to take action when known bad behaviors are taking place.  It leverages the same Log Analytics workspace and Azure Monitor agent as Azure Monitor.
- [Azure Managed Grafana](/azure/managed-grafana/overview) is fully managed Azure service that provides a data visualization platform built on top of the Grafana software by Grafana Labs.
- [Key Vault](/azure/key-vault/general/overview) is a cloud service for securely storing and accessing secrets. Use Key Vault to store secrets such as connection strings, passwords, and certificates that are used by your applications and services.


## Alternatives
This architecture follows the guiding principles from the [Cloud Adoption Framework for Azure](/azure/cloud-adoption-framework). See [Azure landing zone design principles](/azure/cloud-adoption-framework/ready/landing-zone/design-principles) for details on each.

- Subscriptions. Following the design principle of subscription democratization, a separate subscription is created for management components. This includes Log Analytics workspaces, Azure Monitor workspaces, storage accounts supporting diagnostics and auditing, and alert rules.

- Workspaces. Log Analytics workspaces and Azure Monitor workspaces provide the data platform for Azure Monitor. Log Analytics workspaces store log and trace data, while Azure Monitor workspaces store Prometheus metrics. Platform metrics are stored in Azure Monitor at the subscription level, so there's minimal design requirement for this data. The number and regions for each of the workspaces will depend on your particular requirements. See [Design a Log Analytics workspace architecture](/azure/azure-monitor/logs/workspace-design) and [Azure Monitor workspace](/azure/azure-monitor/essentials/azure-monitor-workspace-overview) for specific design criteria. If you generate enough data across Log Analytics workspaces in a particular region, then link them to a dedicated cluster to take advantage of cost incentives and additional functionality as described in [Create and manage a dedicated cluster in Azure Monitor Logs](/azure/azure-monitor/logs/logs-dedicated-clusters).

- Visualization. Visualization of data collected by Azure Monitor can be performed using workbooks in Azure Monitor or by using Azure Managed Grafana. Both are included in this architecture although you may choose to use one or the other. Since there are no additional components to install and no additional cost, workbooks are always available as a visualization option. Azure Managed Grafana has additional cost, so use it if you have an existing investment in Grafana. 


## Scenario details
Enterprise environments have different workloads such as web applications, virtual machines, data services, identity-based workloads, and containers. These workloads can be running in Azure, other cloud providers, or on-premises, making cloud-based monitoring complex. Monitoring is required for you to understand the health and performance of your workloads, and to be notified of issues as they arrive. A solution based on Azure Monitor provides these requirements in addition to supporting security monitoring, auditing, and cost management. 

### Potential use cases

This solution can help with the following use cases:

- Consolidated monitoring of health and performance for different cloud and on-premises workloads with Azure Monitor.
- Platform for security monitoring and threat detection using Microsoft Sentinel and Microsoft Defender XDR.
- Integration of your monitoring environment with ITSM systems.
- Centralized visualization with data filtered by resource based access control.

## Recommendations
The following recommendations apply for most scenarios. Follow these recommendations unless you have a specific requirement that overrides them.

- Use Azure Policy to disable workspace creation for most users in order to maintain the workspace strategy. This will prevent data from being accidentally fragmented and potentially incurring increased monitoring costs.
- Use Azure Policy to configure diagnostic settings for infrastructure resources (e.g. Network, PIP, Express route circuits) to always send resource logs to centralized Log Analytics workspace.
- Limit Log Analytics workspace permissions to the monitoring solution administrator. All the other roles should use Resource Based Access Control.
- Periodic review of governance policy around central enterprise monitoring architecture is crucial to adapt to evolving technology landscape.


## Considerations

These considerations implement the pillars of the Azure Well-Architected Framework, which is a set of guiding tenets that can be used to improve the quality of a workload. For more information about these tenents, see [Microsoft Azure Well-Architected Framework](/azure/architecture/framework).

For specific considerations for implementing Azure Monitor, see the following best practices articles:

- [Reliability](/azure/azure-monitor/best-practices-reliability) - Ensures your application can meet the commitments you make to your customers.
- [Security](/azure/azure-monitor/best-practices-reliability) - Provides assurances against deliberate attacks and the abuse of your valuable data and systems. 
- [Cost optimization](/azure/azure-monitor/best-practices-cost) - Looks at ways to reduce unnecessary expenses and improve operational efficiencies.
- [Operational excellence](/azure/azure-monitor/best-practices-operation) - Covers the operations processes that deploy an application and keep it running in production.
- [Performance efficiency](/azure/azure-monitor/best-practices-performance) - The ability of your workload to scale to meet the demands placed on it by users in an efficient manner.




## Next steps

* [Azure Monitor overview](/azure/azure-monitor/overview)
* [Design a Log Analytics workspace architecture](/azure/azure-monitor/logs/workspace-design)
* [Azure Monitor data sources and data collection methods](/azure/azure-monitor/data-sources)
