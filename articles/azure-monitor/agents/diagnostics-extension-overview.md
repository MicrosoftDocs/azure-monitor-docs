---
title: Azure Diagnostics extension overview
description: Use Azure Diagnostics for debugging, measuring performance, monitoring, and performing traffic analysis in cloud services, virtual machines, and service fabric.
ms.topic: conceptual
ms.date: 11/14/2024
ms.reviewer: luki

---

# Azure Diagnostics extension overview

Azure Diagnostics extension is an [agent in Azure Monitor](../agents/agents-overview.md) that collects monitoring data from the guest operating system of Azure compute resources including virtual machines. This article provides an overview of Azure Diagnostics extension, the specific functionality that it supports, and options for installation and configuration.

> [!NOTE]
> Azure Diagnostics extension will be deprecated on March 31, 2026. After this date, Microsoft will no longer provide support for the Azure Diagnostics extension.

## Migrate from Azure Diagnostic extensions for Linux (LAD) and Windows (WAD) to Azure Monitor Agent

- Azure Monitor Agent can collect and send data to multiple destinations, including Log Analytics workspaces, Azure Event Hubs, and Azure Storage.
- To check which extensions are installed on your VM, select **Extensions + applications** under **Settings** on your VM.
- Remove LAD or WAD after you set up Azure Monitor Agent to collect the same data to Event Hubs or Azure Storage to avoid duplicate data. 
- As an alternative to storage, we highly recommend you set up a table with the [Auxiliary plan](../logs/data-platform-logs.md#table-plans) in your Log Analytics workspace for cost-effective logging.

## Primary scenarios

Use Azure Diagnostics extension if you need to:

* Send data to Azure Storage for archiving or to analyze it with tools such as [Azure Storage Explorer](/azure/vs-azure-tools-storage-manage-with-storage-explorer).
* Send data to [Azure Monitor Metrics](../essentials/data-platform-metrics.md) to analyze it with [metrics explorer](../essentials/metrics-getting-started.md) and to take advantage of features such as near-real-time [metric alerts](../alerts/alerts-metric-overview.md) and [autoscale](../autoscale/autoscale-overview.md) (Windows only).
* Send data to third-party tools by using [Azure Event Hubs](./diagnostics-extension-stream-event-hubs.md).
* Collect [boot diagnostics](/troubleshoot/azure/virtual-machines/boot-diagnostics) to investigate VM boot issues.

Limitations of Azure Diagnostics extension:

* It can only be used with Azure resources.
* It has limited ability to send data to Azure Monitor Logs.

## Comparison to Log Analytics agent

The Log Analytics agent in Azure Monitor can also be used to collect monitoring data from the guest operating system of virtual machines. You can choose to use either or both depending on your requirements. For a comparison of the Azure Monitor agents, see [Overview of the Azure Monitor agents](../agents/agents-overview.md).

The key differences to consider are:

* Azure Diagnostics Extension can be used only with Azure virtual machines. The Log Analytics agent can be used with virtual machines in Azure, other clouds, and on-premises.
* Azure Diagnostics extension sends data to Azure Storage, [Azure Monitor Metrics](../essentials/data-platform-metrics.md) (Windows only) and Azure Event Hubs. The Log Analytics agent collects data to [Azure Monitor Logs](../logs/data-platform-logs.md).
* The Log Analytics agent is required for retired [solutions](/previous-versions/azure/azure-monitor/insights/solutions), [VM insights](../vm/vminsights-overview.md), and other services such as [Microsoft Defender for Cloud](/azure/security-center/).

## Costs

There's no cost for Azure Diagnostics extension, but you might incur charges for the data ingested. Check [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/) for the destination where you're collecting data.

## Data collected

The following tables list the data that can be collected by the Windows and Linux diagnostics extension.

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
| Application Insights  | Collect data from applications running in your VM to Application Insights to integrate with other application monitoring. See [Send diagnostic data to Application Insights](diagnostics-extension-to-application-insights.md). |

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

The following tables list the operating systems that are supported by WAD and LAD. See the documentation for each agent for unique considerations and for the installation process. See Telegraf documentation for its supported operating systems. All operating systems are assumed to be x64. x86 is not supported for any operating system.

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

See the following articles for more information.

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
