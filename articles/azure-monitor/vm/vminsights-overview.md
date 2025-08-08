---
title: Overview of VM insights
description: Overview of VM insights, which monitors the health and performance of Azure VMs and automatically discovers and maps application components and their dependencies. 
ms.topic: concept-article
ms.date: 01/15/2025
---

# Overview of VM insights

VM insights provides a quick and easy method for getting started monitoring the client workloads on your virtual machines and virtual machine scale sets. It displays an inventory of your existing VMs and provides a guided experience to enable base monitoring for them. It also monitors the performance of your virtual machines and virtual machine scale sets by collecting data on their running processes and dependencies on other resources. 

VM insights supports Windows and Linux operating systems on:

- Azure virtual machines.
- Azure virtual machine scale sets.
- Hybrid virtual machines connected with Azure Arc.
- On-premises virtual machines.
- Virtual machines hosted in another cloud environment.

VM insights provides a set of predefined workbooks that allow you to view trending of collected performance data over time. You can view this data in a single VM from the virtual machine directly, or you can use Azure Monitor to deliver an aggregated view of multiple VMs.

:::image type="content" source="media/vminsights-overview/vminsights-azmon-directvm.png" lightbox="media/vminsights-overview/vminsights-azmon-directvm.png" alt-text="Screenshot that shows the VM insights perspective in the Azure portal.":::


## Pricing

There's no direct cost for VM insights, but you're charged for its activity in the Log Analytics workspace. Based on the pricing that's published on the [Azure Monitor pricing page](https://azure.microsoft.com/pricing/details/monitor/), VM insights is billed for:

- Data ingested from agents and stored in the workspace.
- Alert rules based on log data.
- Notifications sent from alert rules.

The log size varies by the string lengths of performance counters. It can increase with the number of logical disks and network adapters allocated to the VM. If you're already using Service Map, the only change you'll see is the extra performance data that's sent to the Azure Monitor `InsightsMetrics` data type.​

## Supported machines and operating systems

VM insights supports the following machines:

- Azure virtual machines
- Azure Virtual Machine Scale Sets
- Hybrid virtual machines connected with Azure Arc
  - VM Insights is available for Azure Arc-enabled servers in regions where the Arc extension service is available. You must be running version 0.9 or above of the Azure Arc agent.

VM insights supports the following operating systems:

- All operating systems supported by the Azure Monitor agent for guest performance. See [Azure Monitor agent supported operating systems](../agents/azure-monitor-agent-supported-operating-systems.md).
- All operating systems supported by the Dependency agent for processes and dependencies. See [Dependency agent supported operating systems](../vm/vminsights-dependency-agent.md#supported-operating-systems).



## Limitations

- VM insights collects a predefined set of metrics from the VM client and doesn't collect any event data. You can use the Azure portal to [create data collection rules](../vm/data-collection.md) to collect events and additional performance counters using the same Azure Monitor agent used by VM insights.
- VM insights doesn't support sending data to multiple Log Analytics workspaces (multi-homing).

## Diagnostic and usage data

Microsoft automatically collects usage and performance data through your use of Azure Monitor. Microsoft uses this data to improve the quality, security, and integrity of the service.

To provide accurate and efficient troubleshooting capabilities, the Map feature includes data about the configuration of your software. The data provides information such as the operating system and version, IP address, DNS name, and workstation name. Microsoft doesn't collect names, addresses, or other contact information.

For more information about data collection and usage, see the [Microsoft Online Services Privacy Statement](https://go.microsoft.com/fwlink/?LinkId=512132).

[!INCLUDE [GDPR-related guidance](~/reusable-content/ce-skilling/azure/includes/gdpr-dsr-and-stp-note.md)]

## Next steps

- [Enable and configure VM insights](./vminsights-enable-overview.md).

