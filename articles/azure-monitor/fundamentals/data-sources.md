---
title: Azure Monitor data sources and data collection methods
description: Describes the different types of data that can be collected in Azure Monitor and the method of data collection for each.
ms.topic: concept-article
ms.date: 08/07/2026
ms.reviewer: shseth
ai-usage: ai-assisted

# Customer intent: As an Azure Monitor user, I want to understand the different types of data that can be collected in Azure Monitor and the method of data collection for each so that I can configure my environment to collect the data that I need.
---

# Azure Monitor data sources and data collection methods

Azure Monitor is based on a [common monitoring data platform](data-platform.md) that you can use to analyze different types of data from multiple types of resources together by using a common set of tools. Currently, different sources of data for Azure Monitor use different methods to deliver their data, and each typically requires different types of configuration. This article describes common sources of monitoring data that Azure Monitor collects and their data collection methods. Use this article as a starting point to understand the options for collecting different types of data generated in your environment.


> [!IMPORTANT]
> There is a cost for collecting and retaining most types of data in Azure Monitor. To minimize your cost, ensure that you don't collect any more data than you require and that your environment is configured to optimize your costs. See [Cost optimization in Azure Monitor](best-practices-cost.md) for a summary of recommendations.

## Azure resources

Most resources in Azure generate a standard set of monitoring data described in the following table. Some services have more collectable data, described in other sections in this article. Regardless of the services that you're monitoring, start by understanding and configuring the collection of this core data.

Create diagnostic settings for each of the following data types to send them to a Log Analytics workspace, archive them to a storage account, or stream them to an event hub for ingestion by services outside of Azure. See [Create diagnostic settings in Azure Monitor](../platform/diagnostic-settings.md).

| Data type | Description | Data collection method |
|:----------|:------------|:-----------------------|
| Activity log | Provides insight into subscription-level events for Azure services, including service health records and configuration changes. | Collected automatically. View in the Azure portal or create a diagnostic setting to send it to other destinations. You can collect it in a Log Analytics workspace at no charge. See [Azure Monitor activity log](../platform/activity-log.md). |
| Platform metrics | Numerical values automatically collected at regular intervals for different aspects of a resource. Specific metrics vary for each type of resource. | Collected automatically and stored in [Azure Monitor Metrics](../metrics/data-platform-metrics.md). View in metrics explorer or create a diagnostic setting to send it to other destinations. See [Azure Monitor Metrics overview](../metrics/data-platform-metrics.md) and [Supported metrics with Azure Monitor](/azure/azure-monitor/reference/supported-metrics/metrics-index) for a list of metrics for different services. |
| Resource logs | Provides insight into operations that were performed within an Azure resource. The content of resource logs varies by the Azure service and resource type. | You must create a diagnostic setting to collect resource logs. See [Azure resource logs](../platform/resource-logs.md) and [Supported services, schemas, and categories for Azure resource logs](../platform/resource-logs-schema.md) for details on each service. |

## Log data from Microsoft Entra ID

Audit logs and sign in logs in Microsoft Entra ID are similar to the activity logs in Azure Monitor. Create diagnostic settings for each of the following data types to be sent to a Log Analytics workspace, archived to a storage account, or streamed to an event hub for ingestion by services outside of Azure. See [Configure Microsoft Entra diagnostic settings for activity logs](/entra/identity/monitoring-health/howto-configure-diagnostic-settings).

| Data type | Description | Data collection method |
|:----------|:------------|:-----------------------|
| Audit logs<br><br>Sign-in logs | Enable you to assess many aspects of your Microsoft Entra ID environment, including history of sign-in activity, audit trail of changes made within a particular tenant, and activities performed by the provisioning service. | Collected automatically with activity logs. View in the Azure portal or create a diagnostic setting to send it to other destinations. |

## Apps and workloads

### Application data

Application monitoring in Azure Monitor is done with [Application Insights](../app/app-insights-overview.md), which collects data from applications running on various platforms in Azure, another cloud, or on-premises. When you enable Application Insights for an application, it collects metrics and logs related to the performance and operation of the application and stores it in the same Azure Monitor data platform used by other data sources. 

For more information about the data that Application Insights collects and links to articles on onboarding your application, see [Application Insights overview](../app/app-insights-overview.md).

| Data type | Description | Data collection method |
|:----------|:------------|:-----------------------|
| Application logs | Operational data about your application, including page views, application requests, exceptions, and traces. Also includes dependency information between application components to support Application Map and data correlation. | Application logs are stored in a Log Analytics workspace that you select as part of the onboarding process. |
| Metrics | Numeric data measuring the performance of your application and user requests measured over intervals of time. | Metric data is stored in both Azure Monitor Metrics and the Log Analytics workspace. |
| Traces | Traces are a series of related events tracking end-to-end requests through the components of your application. | Traces are stored in the Log Analytics workspace for the app. |

## Infrastructure

### Virtual machine data

Azure virtual machines create the same activity logs and platform metrics as other Azure resources. In addition to this host data, you need to monitor the guest operating system and the workloads running on it. This monitoring requires the [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md) or [Azure Monitor SCOM Managed Instance](/azure/azure-monitor/scom-manage-instance/overview). The following table includes the most common data to collect from VMs. For a more complete description of the different kinds of data you can collect from virtual machines, see [Monitor virtual machines with Azure Monitor: Collect data](../vm/monitor-virtual-machine-data-collection.md).

| Data type | Description | Data collection method |
|:----------|:------------|:-----------------------|
| Windows Events | Logs for the client operating system and different applications on Windows VMs. | Deploy the Azure Monitor Agent (AMA) and create a data collection rule (DCR) to send data to Log Analytics workspace. See [Collect data with Azure Monitor Agent](../vm/data-collection.md). |
| Syslog | Logs for the client operating system and different applications on Linux VMs. | Deploy the Azure Monitor Agent (AMA) and create a data collection rule (DCR) to send data to Log Analytics workspace. See [Collect Syslog events with Azure Monitor Agent](../vm/data-collection-syslog.md). To use the VM as a Syslog forwarder, see [Tutorial: Forward Syslog data to a Log Analytics workspace with Microsoft Sentinel by using Azure Monitor Agent](/azure/sentinel/forward-syslog-monitor-agent). |
| Client Performance data | Performance counter values for the operating system and applications running on the virtual machine. | Deploy the Azure Monitor Agent (AMA) and create a data collection rule (DCR) to send data to Azure Monitor Metrics and/or Log Analytics workspace. See [Collect data with Azure Monitor Agent](../vm/data-collection.md).<br><br>Enable VM Insights to send predefined aggregated performance data to Log Analytics workspace. See [Enable VM Insights overview](/azure/azure-monitor/vm/vminsights-enable) for installation options. |
| Processes and dependencies | Details about processes running on the machine and their dependencies on other machines and external services. Enables the [map feature in VM Insights](../vm/vminsights-maps.md). | Enable VM Insights on the machine with the *processes and dependencies* option. See [Enable VM Insights overview](/azure/azure-monitor/vm/vminsights-enable) for installation options. |
| Text logs | Application logs written to a text file. | Deploy the Azure Monitor Agent (AMA) and create a data collection rule (DCR) to send data to Log Analytics workspace. See [Collect logs from a text or JSON file with Azure Monitor Agent](../vm/data-collection-log-text.md). |
| IIS logs | Logs created by Internet Information Service (IIS). | Deploy the Azure Monitor Agent (AMA) and create a data collection rule (DCR) to send data to Log Analytics workspace. See [Collect IIS logs with Azure Monitor Agent](../vm/data-collection-iis.md). |
| SNMP traps | Widely deployed management protocol for monitoring and configuring Linux devices and appliances. | See [Collect SNMP trap data with Azure Monitor Agent](../vm/data-collection-snmp-data.md). |
| Management pack data | If you have an existing investment in System Center Operations Manager, you can migrate to the cloud while retaining your investment in existing management packs by using [Azure Monitor SCOM Managed Instance](/azure/azure-monitor/scom-manage-instance/overview). | Azure Monitor SCOM Managed Instance stores data collected by management packs in an instance of SQL MI. See [Configure Log Analytics for Azure Monitor SCOM Managed Instance](/system-center/scom/configure-log-analytics-for-scom-managed-instance) to send this data to a Log Analytics workspace. |

### Kubernetes cluster data

Azure Kubernetes Service (AKS) clusters create the same activity logs and platform metrics as other Azure resources. In addition to this host data though, they generate a common set of cluster logs and metrics that you can collect from your AKS clusters and Arc-enabled Kubernetes clusters.

| Data type | Description | Data collection method |
|:----------|:------------|:-----------------------|
| Cluster Metrics | Usage and performance data for the cluster, nodes, deployments, and workloads. | Enable managed Prometheus for the cluster to send cluster metrics to an [Azure Monitor workspace](../metrics/azure-monitor-workspace-overview.md). See [Enable Prometheus and Grafana](../containers/kubernetes-monitoring-enable.md) for onboarding and [Default Prometheus metrics configuration in Azure Monitor](../containers/prometheus-metrics-scrape-default.md) for a list of metrics that are collected by default. |
| Kubernetes logs | Standard Kubernetes logs including events for the cluster, nodes, deployments, and workloads. | Enable Container Insights for the cluster to send container logs to a Log Analytics workspace. See [Enable Container Insights](../containers/kubernetes-monitoring-enable.md) for onboarding and [Configure data collection in Container Insights using data collection rule](/azure/azure-monitor/containers/container-insights-data-collection-configure#configure-data-collection-using-dcr) to configure which logs are collected. |

## Custom sources

Custom data sources, especially those outside of Azure, require custom data collection methods. Refer to the following table to understand the options.

| Data type | Description | Data collection method |
|:----------|:------------|:-----------------------|
| Event Hubs logs | Collect data from Azure Event Hubs. | Create a data collection rule to define destination workspace and structure of incoming data. See [Ingest events from Azure Event Hubs into Azure Monitor Logs (preview)](../logs/ingest-logs-event-hub.md). |
| REST API logs | Collect log data from any REST client and store in Log Analytics workspace. | Create a data collection rule to define destination workspace and any data transformations. See [Logs ingestion API in Azure Monitor](../logs/logs-ingestion-api-overview.md). |
| Metrics | Collect custom metrics for Azure resources from any REST client. | See [Send custom metrics for an Azure resource to the Azure Monitor metric store by using a REST API](../metrics/metrics-store-custom-rest-api.md). |

## Next steps

* Learn more about the [types of monitoring data collected by Azure Monitor](data-platform.md) and how to view and analyze this data.
* Review [Cost optimization in Azure Monitor](best-practices-cost.md) to control what you collect and retain.
* Create [diagnostic settings in Azure Monitor](../platform/diagnostic-settings.md) to route platform logs and metrics to your destinations.
