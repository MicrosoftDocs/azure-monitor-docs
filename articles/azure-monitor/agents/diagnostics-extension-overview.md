---
title: Azure Diagnostics extension overview
description: Use Azure Diagnostics for debugging, measuring performance, monitoring, and performing traffic analysis in cloud services, virtual machines, and service fabric.
ms.topic: concept-article
ms.date: 11/17/2025
ms.reviewer: shseth

---

# Azure Diagnostics extension overview

Azure Diagnostics extension is an [agent in Azure Monitor](../agents/agents-overview.md) that collects monitoring data from the guest operating system of Azure compute resources including virtual machines. This article provides an overview of Azure Diagnostics extension, the specific functionality that it supports, and options for installation and configuration.

> [!IMPORTANT]
> ### Migrate from Azure Diagnostic extension
> 
> Azure Diagnostics extension will be deprecated on **March 31, 2026**. After this date, Microsoft will no longer provide support for the Azure Diagnostics extension. 
> 
> To ensure continued support and access to new features, you should migrate from Azure Diagnostics extensions for Linux (LAD) and Windows (WAD) to alternative solutions following the [following migration guidance](#migration-guidance). Remove LAD or WAD after you configure Azure Monitor Agent to avoid duplicate data.
> 
> To check which extensions are installed on a single VM, select **Extensions + applications** under **Settings** on your VM. To review the extensions installed on all virtual machines in subscriptions where you have access, use the following query in [Azure Resource Graph](/azure/governance/resource-graph/first-query-portal):
>
> ``` kql
> resources
> | where type contains "extension"
> | extend parsedProperties = parse_json(properties)
> | extend publisher = tostring(parsedProperties.publisher)
> | project-away parsedProperties
> | where publisher == "Microsoft.Azure.Diagnostics"
> | distinct id
> ```
>
> It produces results similar to the following example:
> 
> :::image type="content" source="media/diagnostics-extension-overview/query-results.png" lightbox="media/diagnostics-extension-overview/query-results.png" alt-text="Screenshot showing the results of a sample Azure Resource Graph Query.":::

## Migration Guidance

To ensure continued support after March 31, 2026 and access to new features, migrate using the following options based on the data destination: 
 
| Destination | Migration Options |   
|-------------|----------------------------------------------------------------------|
| Azure Storage blobs | If you're using WAD/LAD agents to send data to storage for longer term storage and/or lower costs, migrate to [Azure Monitor Agent](./azure-monitor-agent-migration-wad-lad.md). Then you can send data to custom tables with low-cost [Auxiliary plan](../logs/create-custom-table-auxiliary.md) for cost-effective logging and added benefits of Log Analytics | 
| Azure Event Hubs | If you're using WAD/LAD agents to send data to Event Hubs as a way to land it in your final destination or third party products, consider the following methods now available natively using Azure Monitor: <ul><li> [Configure Event Hubs using VM watch](/azure/virtual-machines/configure-eventhub-vm-watch) A native offering for virtual machines (VMs) and scale sets that send data Azure, including Event Hubs. **Note**: VM Watch doesn't collect application logs </li><li> **Event Hub -> Azure Data Explorer**: If your final data destination is ADX, migrate to [Azure Monitor Agent](./azure-monitor-agent-migration-wad-lad.md) to send data [directly to ADX and Fabric eventhouses](../vm/send-fabric-destination.md) as a simpler, more reliable solution </li> <!--li> **Event Hub -> OTLP destinations**: Migrate to [Azure Monitor Agent](./azure-monitor-agent-overview.md) and [Azure Monitor pipeline](../data-collection/edge-pipeline-configure.md) to send data to OTLP compliant external destinations Splunk, Grafana, Datadog, etc. </li--><li> **Event Hub -> Other destination(s)**: [Contact Azure Monitor team](mailto:obs-agent-pms@microsoft.com) for quick assistance regarding other destinations not listed here </li></ul> |
| Azure Monitor metrics | For VM Guest OS Perf Counter scenarios, migrate to using AMW as a destination for [OpenTelemetry performance counters](../metrics/metrics-opentelemetry-guest.md). For custom metric scenarios, migrate to using AMW as a destination for [OpenTelemetry metrics](../app/opentelemetry.md). |

## Primary scenarios

Use Azure Diagnostics extension if you need to:

* Send data to Azure Storage for archiving or to analyze it with tools such as [Azure Storage Explorer](/azure/vs-azure-tools-storage-manage-with-storage-explorer).
* Send data to [Azure Monitor Metrics](../essentials/data-platform-metrics.md) to analyze it with [metrics explorer](../essentials/metrics-getting-started.md) and to take advantage of features such as near-real-time [metric alerts](../alerts/alerts-metric-overview.md) and [autoscale](../autoscale/autoscale-overview.md) (Windows only).
* Send data to third-party tools by using [Azure Event Hubs](./diagnostics-extension-stream-event-hubs.md).
* Collect [boot diagnostics](/troubleshoot/azure/virtual-machines/boot-diagnostics) to investigate VM boot issues.

Limitations of Azure Diagnostics extension:

* It will be deprecated on March 31, 2026.
* It can only be used with Azure resources.
* It has limited ability to send data to Azure Monitor Logs.

## Costs

There's no cost for Azure Diagnostics extension, but you might incur charges for the data ingested. Check [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/) for the destination where you're collecting data.

## Data collected

The following tables list the data that can get collected by the Windows and Linux diagnostics extension.

### Windows diagnostics extension (WAD)

| Data source                                                         | Description                                                                                                 |
|---------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------|
| Windows event logs                                                  | Events from Windows event log.                                                                              |
| Performance counters                                                | Numerical values measuring performance of different aspects of operating system and workloads.              |
| IIS logs                                                            | Usage information for IIS websites running on the guest operating system.                                   |
| Application logs                                                    | Trace messages written by your application.                                                                 |
| .NET EventSource logs                                               | Code writing events using the .NET [EventSource](/dotnet/api/system.diagnostics.tracing.eventsource) class. |
| [Manifest-based ETW logs](/windows/desktop/etw/about-event-tracing) | Event tracing for Windows events generated by any process.                                                  |
| Crash dumps (logs)                                                  | Information about the state of the process if an application crashes.                                       |
| File-based logs                                                     | Logs created by your application or service.                                                                |
| Agent diagnostic logs                                               | Information about Azure Diagnostics itself.                                                                 |

### Linux diagnostics extension (LAD)

| Data source          | Description                                                                                   |
|----------------------|-----------------------------------------------------------------------------------------------|
| Syslog               | Events sent to the Linux event logging system                                                 |
| Performance counters | Numerical values measuring performance of different aspects of operating system and workloads |
| Log files            | Entries sent to a file-based log                                                              |

## Data destinations

The Azure Diagnostics extension for both Windows and Linux always collects data into an Azure Storage account. For a list of specific tables and blobs where this data is collected, see [Install and configure Azure Diagnostics extension for Windows](diagnostics-extension-windows-install.md) and [Use Azure Diagnostics extension for Linux to monitor metrics and logs](/azure/virtual-machines/extensions/diagnostics-linux).

Configure one or more *data sinks* to send data to other destinations. The following sections list the sinks available for the Windows and Linux diagnostics extension.

### Windows diagnostics extension (WAD)

| Destination           | Description                                                                                                                                                                                                                     |
|:----------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Azure Monitor Metrics | Collect performance data to Azure Monitor Metrics. See [Send Guest OS metrics to the Azure Monitor metric database](../essentials/collect-custom-metrics-guestos-resource-manager-vm.md).                                       |
| Event hubs            | Use Azure Event Hubs to send data outside of Azure. See [Streaming Azure Diagnostics data to Azure Event Hubs](diagnostics-extension-stream-event-hubs.md).                                                                     |
| Azure Storage blobs   | Write data to blobs in Azure Storage in addition to tables.                                                                                                                                                                     |
| Application Insights  | To integrate with other application monitoring, collect data from applications running in your VM to Application Insights. See [Send diagnostic data to Application Insights](diagnostics-extension-to-application-insights.md). |

You can also collect WAD data from storage into a Log Analytics workspace to analyze it with Azure Monitor Logs, although the Log Analytics agent is typically used for this functionality. It can send data directly to a Log Analytics workspace and supports solutions and insights that provide more functionality. See [Collect Azure diagnostic logs from Azure Storage](diagnostics-extension-logs.md).

### Linux diagnostics extension (LAD)

LAD writes data to tables in Azure Storage. It supports the sinks in the following table.

| Destination           | Description                                                                                                                                                                            |
|:----------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Event hubs            | Use Azure Event Hubs to send data outside of Azure.                                                                                                                                    |
| Azure Storage blobs   | Write data to blobs in Azure Storage in addition to tables.                                                                                                                            |
| Azure Monitor Metrics | Install the Telegraf agent in addition to LAD. See [Collect custom metrics for a Linux VM with the InfluxData Telegraf agent](../essentials/collect-custom-metrics-linux-telegraf.md). |

## Installation and configuration

The diagnostics extension is implemented as a [virtual machine extension](/azure/virtual-machines/extensions/overview) in Azure, so it supports the same installation options using Azure Resource Manager templates, PowerShell, and the Azure CLI. For information on installing and maintaining virtual machine extensions, see [Virtual machine extensions and features for Windows](/azure/virtual-machines/extensions/features-windows) and [Virtual machine extensions and features for Linux](/azure/virtual-machines/extensions/features-linux).

You can also install and configure both the Windows and Linux diagnostics extension in the Azure portal under **Diagnostic settings** in the **Monitoring** section of the virtual machine's menu.

See the following articles for information on installing and configuring the diagnostics extension for Windows and Linux:

* [Install and configure Azure Diagnostics extension for Windows](diagnostics-extension-windows-install.md)
* [Use Linux diagnostics extension to monitor metrics and logs](/azure/virtual-machines/extensions/diagnostics-linux)

## Supported operating systems

The following tables list the operating systems supported by WAD and LAD. See the documentation for each agent for unique considerations and for the installation process. See Telegraf documentation for its supported operating systems. All operating systems are assumed to be x64. x86 isn't supported for any operating system.

### Windows

| Operating system                                                                             | Support |
|:---------------------------------------------------------------------------------------------|:-------:|
| Windows Server 2022                                                                          | ❌      |
| Windows Server 2022 Core                                                                     | ❌      |
| Windows Server 2019                                                                          | ✅      |
| Windows Server 2019 Core                                                                     | ❌      |
| Windows Server 2016                                                                          | ✅      |
| Windows Server 2016 Core                                                                     | ✅      |
| Windows Server 2012 R2                                                                       | ✅      |
| Windows Server 2012                                                                          | ✅      |
| Windows 11 Client & Pro                                                                      | ❌      |
| Windows 11 Enterprise (including multi-session)                                              | ❌      |
| Windows 10 1803 (RS4) and higher                                                             | ❌      |
| Windows 10 Enterprise (including multi-session) and Pro (Server scenarios only)              | ✅      |

### Linux

| Operating system                                       | Support |
|:-------------------------------------------------------|:-------:|
| CentOS Linux 9                                         | ❌      |
| CentOS Linux 8                                         | ❌      |
| CentOS Linux 7                                         | ✅      |
| Debian 12                                              | ❌      |
| Debian 11                                              | ❌      |
| Debian 10                                              | ❌      |
| Debian 9                                               | ✅      |
| Debian 8                                               | ❌      |
| Oracle Linux 9                                         | ❌      |
| Oracle Linux 8                                         | ❌      |
| Oracle Linux 7                                         | ✅      |
| Oracle Linux 6.4+                                      | ✅      |
| Red Hat Enterprise Linux Server 9                      | ❌      |
| Red Hat Enterprise Linux Server 8\*                    | ✅      |
| Red Hat Enterprise Linux Server 7                      | ✅      |
| SUSE Linux Enterprise Server 15                        | ❌      |
| SUSE Linux Enterprise Server 12                        | ✅      |
| Ubuntu 22.04 LTS                                       | ❌      |
| Ubuntu 20.04 LTS                                       | ✅      |
| Ubuntu 18.04 LTS                                       | ✅      |
| Ubuntu 16.04 LTS                                       | ✅      |
| Ubuntu 14.04 LTS                                       | ✅      |

\* Requires Python 2 to be installed on the machine and aliased to the python command.

## Other documentation

For more information, see the following articles.

### Azure Cloud Services (classic) web and worker roles

* [Introduction to Azure Cloud Services monitoring](/azure/cloud-services/cloud-services-how-to-monitor)
* [Enabling Azure Diagnostics in Azure Cloud Services](/azure/cloud-services/cloud-services-dotnet-diagnostics)
* [Application Insights for Azure Cloud Services](../app/azure-web-apps-net-core.md)
* [Trace the flow of an Azure Cloud Services application with Azure Diagnostics](/azure/cloud-services/cloud-services-dotnet-diagnostics-trace-flow)

### Azure Service Fabric

[Monitor and diagnose services in a local machine development setup](/azure/service-fabric/service-fabric-diagnostics-how-to-monitor-and-diagnose-services-locally)

## Next steps

* Learn to [use performance counters in Azure Diagnostics](/azure/cloud-services/diagnostics-performance-counters).
* If you have trouble with diagnostics starting or finding your data in Azure Storage tables, see [Troubleshooting Azure Diagnostics](diagnostics-extension-troubleshooting.md).
