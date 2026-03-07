---
title: Overview of VM insights
description: Overview of VM insights, which monitors the health and performance of Azure VMs and automatically discovers and maps application components and their dependencies. 
ms.topic: concept-article
ms.date: 01/15/2025
---

# Overview of VM insights

This article describes VM insights which is the classic logs-based experience for VM monitoring in Azure Monitor. VM insights provides a quick and easy method for getting started monitoring the client workloads on your virtual machines and virtual machine scale sets. It displays an inventory of your existing VMs and provides a guided experience to enable base monitoring for them. 

The logs-based experience of VM insights is being transitioned to the OpenTelemetry experience (preview), which provides various advantages described in [Benefits of OpenTelemetry](./metrics-opentelemetry-guest.md#benefits-of-opentelemetry). See [OpenTelemetry Guest OS Metrics (preview)](./metrics-opentelemetry-guest.md) for guidance on selecting the right experience for your needs.

VM insights provides a set of predefined workbooks that allow you to view trending of collected performance data over time for multiple VMs. It also populates required data for the logs-based experience in the Azure portal for the VM.

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
- VM insights doesn't support any sampling frequency other than every 60 seconds for performance counters in the Microsoft-InsightsMetrics stream.
- For log based visualizations (Classic), data from VMs using Private Link is collected but will not surface in the VM Insights experience.



## Next steps

- [Enable and configure VM insights](./vminsights-enable-overview.md).

