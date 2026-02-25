---
title: Overview of VM insights
description: Overview of VM insights, which monitors the health and performance of Azure VMs and automatically discovers and maps application components and their dependencies. 
ms.topic: concept-article
ms.date: 02/16/2026
---

# Overview of VM insights

VM insights provides a quick and easy method for getting started monitoring the client workloads on your virtual machines and virtual machine scale sets. It displays an inventory of your existing VMs and provides a guided experience to enable base monitoring for them. 

VM insights provides a set of predefined workbooks that allow you to view trending of collected performance data over time. You can view this data in a single VM from the virtual machine directly, or you can use Azure Monitor to deliver an aggregated view of multiple VMs.

:::image type="content" source="media/vminsights-overview/vminsights-performance-view.png" lightbox="media/vminsights-overview/vminsights-performance-view.png" alt-text="Screenshot tof the Performance view in VM insights.":::


## Pricing

There's no direct cost for VM insights, but you're charged for its activity in the Log Analytics workspace. Based on the pricing that's published on the [Azure Monitor pricing page](https://azure.microsoft.com/pricing/details/monitor/).

## Supported machines and operating systems

VM insights supports the following machines:

- Azure virtual machines
- Azure Virtual Machine Scale Sets
- Hybrid virtual machines connected with Azure Arc
  - VM Insights is available for Azure Arc-enabled servers in regions where the Arc extension service is available. You must be running version 0.9 or above of the Azure Arc agent.
- On-premises virtual machines.
- Virtual machines hosted in another cloud environment.


VM insights supports the following operating systems:

- All operating systems supported by the Azure Monitor agent for guest performance. See [Azure Monitor agent supported operating systems](../agents/azure-monitor-agent-supported-operating-systems.md).
- All operating systems supported by the Dependency agent for processes and dependencies. See [Dependency agent supported operating systems](../vm/vminsights-dependency-agent.md#supported-operating-systems).

## Metrics selection
When you enable VM insights, you need to determine which metrics experience to enable. Azure Monitor continues to support collection of guest OS metrics in a Log Analytics workspace. OpenTelemetry guest OS metrics is currently in preview and is an additional option that offers richer insights, faster query performance, and lower cost. It's the right solution when you want a modern, standards‑based pipeline with deeper system visibility.

Benefits of the new OTel-based collection pipeline include the following:

- Unified data model. Consistent metric names and schema across Windows and Linux for easier reusable queries and dashboards.
- Richer, simplified counters. More system and process metrics, including per‑process CPU, memory, disk I/O, and consolidation of legacy counters into clearer OTel metrics.
- Cost‑efficient performance. Otel metrics are stored in an Azure Monitor workspace instead of Log Analytics ingestion for lower cost and faster queries using PromQL.
- Customize metrics collected. Both types of metrics initially collect a default set of metrics. You can modify OTel 

Evaluate your requirements to determine which configuration best fits your needs. Log Analytics workspace-based metrics remain the foundation for customers who need advanced analytics and correlation, while OTel-based metrics open new possibilities for modern VM observability.

| Feature | Log Analytics workspace | OTel-based metrics (Preview) |
|:---|:---|:---|
| Stored | Log Analytics workspace | Azure Monitor workspace |
| Query language | KQL | PromQL |
| Customization | Can't modify collected metrics | Add custom OpenTelemetry metrics and dimensions |

## Data collected

### OpenTelemetry metrics
If you collect OTel-based metrics, a default set of metrics are collected by default 

, and you can choose to add [additional OpenTelemetry metrics and dimensions](../vm/vminsights-opentelemetry.md#add-custom-opentelemetry-metrics). These metrics support alerts and dashboards and are typically sufficient for your monitoring requirements.

### Log Analytics workspace-based metrics
If you collect Log Analytics workspace-based metrics, a default set of summarized performance metrics are collected from the guest OS to support the VM insights dashboards.


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

