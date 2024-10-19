---
title: Enable VM Insights overview
description: Learn how to deploy and configure VM Insights and find out about the system requirements.
ms.topic: conceptual
author: guywi-ms
ms.author: guywild
ms.reviewer: xpathak
ms.date: 10/03/2024
ms.custom: references_regions

---

# Enable VM Insights overview

This article provides an overview of how to enable VM Insights in Azure Monitor. See [Installation options](#installation-options) for the different methods available to enable VM Insights on supported machines.

## Supported machines

- Azure virtual machines
- Azure Virtual Machine Scale Sets
- Hybrid virtual machines connected with Azure Arc
  - VM Insights is available for Azure Arc-enabled servers in regions where the Arc extension service is available. You must be running version 0.9 or above of the Azure Arc agent.

## Supported operating systems

- VM Insights supports all operating systems supported by the Azure Monitor Agent. See [Azure Monitor Agent supported operating systems and environments](../agents/azure-monitor-agent-supported-operating-systems.md).
- The Dependency Agent currently supports the same [Windows versions that Azure Monitor Agent supports](../agents/azure-monitor-agent-supported-operating-systems.md) up to Windows Server 2019, except Windows Server 2008 SP2 and Azure Stack HCI.
- For Dependency Agent Linux support, see [Dependency Agent Linux support](../vm/vminsights-dependency-agent-maintenance.md#dependency-agent-requirements) and [Linux considerations](./vminsights-dependency-agent-maintenance.md#linux-considerations).

> [!IMPORTANT]
> If the Ethernet device for your virtual machine has more than nine characters, it won't be recognized by VM Insights and data won't be sent to the InsightsMetrics table. The agent will collect data from [other sources](../agents/agent-data-sources.md).

## Installation options

The following table shows the installation methods available for enabling VM Insights on supported machines.

| Method | Scope |
|:---|:---|
| [Azure portal](vminsights-enable-portal.md) | Enable individual machines with the Azure portal. |
| [Azure Policy](vminsights-enable-policy.md) | Create policy to automatically enable when a supported machine is created. |
| [Azure Resource Manager templates](../vm/vminsights-enable-resource-manager.md) | Enable multiple machines by using any of the supported methods to deploy a Resource Manager template, such as the Azure CLI and PowerShell. |
| [PowerShell](vminsights-enable-powershell.md) | Use a PowerShell script to enable multiple machines. |
| [Manual install](vminsights-enable-hybrid.md) | Virtual machines or physical computers on-premises with other cloud environments.|

## VM insights DCR

> [!IMPORTANT]
> VM Insights automatically creates a DCR that includes a special data stream required for its operation. Do not modify the VM Insights data collection rule or create your own data collection rule to support VM Insights. To collect additional data, such as Windows and Syslog events, create separate data collection rules and associate them with your machines.

[Data collection rules (DCRs)](../essentials/data-collection-rule-overview.md) are used by the Azure Monitor agent to specify which data to collect and how it should be processed. To enable VM Insights on a machine with Azure Monitor Agent, associate a VM insights DCR with the agent. When you enable VM Insights using the Azure portal, a DCR can be created for you. You can either use this DCR or a downloadable template when you use other installation methods. 

If you associate a data collection rule with the Map feature enabled to a machine on which Dependency Agent isn't installed, the Map view won't be available. To enable the Map view, set `enableAMA property = true` in the Dependency Agent extension when you install Dependency Agent.



## Agents

When you enable VM Insights for a machine, the following agents are installed. 

> [!IMPORTANT]
> Azure Monitor Agent has several advantages over the legacy Log Analytics agent, which will be deprecated by August 2024. After this date, Microsoft will no longer provide any support for the Log Analytics agent. [Migrate to Azure Monitor agent](../agents/azure-monitor-agent-migration.md) before August 2024 to continue ingesting data.


- [Azure Monitor agent](../agents/azure-monitor-agent-overview.md): Collects data from the machine and delivers it to a Log Analytics workspace.
- [Dependency agent](./vminsights-dependency-agent-maintenance.md): Collects discovered data about processes running on the virtual machine and external process dependencies, which are used by the [Map feature in VM Insights](../vm/vminsights-maps.md). The Dependency agent relies on the Azure Monitor Agent agent to deliver its data to Azure Monitor. If you don't need the map feature, you don't need to install the Dependency agent.

## Network requirements

- The Azure Monitor agent requires the machine to have access to the following HTTPS endpoints. For more details, see [Define Azure Monitor Agent network settings](../agents/azure-monitor-agent-data-collection-endpoint.md).
	- global.handler.control.monitor.azure.com
	- `<virtual-machine-region-name>`.handler.control.monitor.azure.com (example: westus.handler.control.azure.com)
	- `<log-analytics-workspace-id>`.ods.opinsights.azure.com (example: 12345a01-b1cd-1234-e1f2-1234567g8h99.ods.opinsights.azure.com)
    (If using private links on the agent, you must also add the [data collection endpoints](../essentials/data-collection-endpoint-overview.md#components-of-a-dce))

- The Dependency agent requires a connection from the virtual machine to the address 169.254.169.254. This address identifies the Azure metadata service endpoint. Ensure that firewall settings allow connections to this endpoint.

## Enable network isolation using Private Link

By default, Azure Monitor Agent connects to a public endpoint to connect to your Azure Monitor environment. To enable network isolation for VM Insights, associate your VM Insights data collection rule to a data collection endpoint linked to an Azure Monitor Private Link Scope, as described in [Enable network isolation for Azure Monitor Agent by using Private Link](../agents/azure-monitor-agent-private-link.md).


## Diagnostic and usage data

Microsoft automatically collects usage and performance data through your use of Azure Monitor. Microsoft uses this data to improve the quality, security, and integrity of the service.

To provide accurate and efficient troubleshooting capabilities, the Map feature includes data about the configuration of your software. The data provides information such as the operating system and version, IP address, DNS name, and workstation name. Microsoft doesn't collect names, addresses, or other contact information.

For more information about data collection and usage, see the [Microsoft Online Services Privacy Statement](https://go.microsoft.com/fwlink/?LinkId=512132).

[!INCLUDE [GDPR-related guidance](~/reusable-content/ce-skilling/azure/includes/gdpr-dsr-and-stp-note.md)]

## Next steps

To learn how to use the Performance monitoring feature, see [View VM Insights Performance](../vm/vminsights-performance.md). To view discovered application dependencies, see [View VM Insights Map](../vm/vminsights-maps.md).
