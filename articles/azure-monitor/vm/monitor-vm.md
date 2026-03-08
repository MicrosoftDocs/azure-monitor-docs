---
title: Monitor Azure Virtual Machines
description: Start here to learn how to monitor Azure Virtual Machines and Virtual Machine Scale Sets.
ms.date: 03/08/2026
ms.custom: horz-monitor
ms.topic: concept-article
ms.service: azure-virtual-machines

#customer intent: As a cloud administrator, I want to understand how to monitor Azure virtual machines so that I can ensure the health and performance of my virtual machines and applications.
---

# Monitor Azure Virtual Machines and Virtual Machine Scale Sets

This article provides an overview of how to monitor the health and performance of Azure virtual machines (VM) and virtual machine scale sets (VMSS). Whether you're new to Azure or transitioning from on-premises infrastructure, understanding your monitoring options helps you maintain reliable, high-performing virtual machines.

## Monitor a single VM
View the current health of a VM from the **Monitor** option for the VM in the Azure portal. This view shows a quick summary of the most common metrics for the VM. The data that's available in this view is based on the monitoring that you've enabled for the VM. Host metrics, including availability, are available by default. Guest metrics and logs are only available when you enable enhanced monitoring as described in [Enable enhanced monitoring](#enable-enhanced-monitoring).

:::image type="content" source="media/monitor-vm/vm-monitor-view.png" lightbox="media/monitor-vm/vm-monitor-view.png" alt-text="Screenshot that shows the Monitor view for a virtual machine in the Azure portal.":::



## Monitor VM host and guest metrics and logs
Host-level VM data gives you an understanding of the VM's overall performance and load, while the guest-level data gives you visibility into the applications, components, and processes running on the machine and their performance and health. For example, if you’re troubleshooting a performance issue, you might start with host metrics to see which VM is under heavy load, and then use guest metrics to drill down into the details of the operating system and application performance.

| Data | Description |
|:---|:---|
| Host data | Comes from the Hyper-V session that manages the guest operating systems. This data includes CPU, network, and disk utilization metrics. You can use host data to monitor the stability, health, and efficiency of the physical host running your VM. Azure provides host metrics by default at no additional cost. |
| Guest data | Comes from the operating system and applications running inside the virtual machine. This data includes performance counters, event logs, and application-specific telemetry. You can use guest data to monitor the performance and health of your applications and workloads, and troubleshoot issues related to application performance, resource usage, and operating system events.<br><br>Collecting guest data requires installing the [Azure Monitor agent](../agents/azure-monitor-agent-overview.md) on the VM. Once installed, the agent collects a default set of metrics, and you can create [data collection rules](../data-collection/data-collection-rule-overview.md) used by the agent to collect additional performance counters and logs. |


## Enable enhanced monitoring
When you enable enhanced monitoring for a VM, the Azure Monitor agent is installed on the VM, and it starts sending guest metrics and logs to Azure Monitor. This fully enables the **Monitor** view in the Azure portal. You can use this data to analyze the performance of the VM and its workloads and create alerts based on metrics and log queries.

When you enable guest monitoring for a VM using the Azure portal, you choose between two experiences: the OpenTelemetry-based experience (preview) and the logs-based experience (classic). Both experiences provide robust monitoring capabilities, but they differ in how they store and process metrics.

### Compare OpenTelemetry and logs-based experiences

| Feature | OpenTelemetry-based (preview) | Logs-based (classic) |
|:---|:---|:---|
| **Data storage** | Azure Monitor workspace (metrics) | Log Analytics workspace (logs) |
| **Applies to** | Azure VMs | Azure VMs and VM Scale Sets |
| **Data model** | OpenTelemetry system metrics with consistent cross-platform naming | Platform-specific performance counters (Windows and Linux have different counter names) |
| **Latency** | Near real-time with low latency | Typically 1-3 minutes |
| **Query language** | PromQL (Prometheus Query Language) | KQL (Kusto Query Language) |
| **Cost** | Optimized for metrics storage and retrieval | Standard Log Analytics ingestion and retention costs |
| **Multi-VM views** | Limited (portal improvements in progress) | Full VM insights multi-VM dashboards and workbooks |
| **Dependencies mapping** | Not available | Available with Dependency agent |
| **Process-level data** | Available through additional metrics | Available through Map feature |
| **Correlation with logs** | Requires separate queries (metrics in Azure Monitor workspace, logs in Log Analytics) | Single workspace for metrics and logs enables correlation in one query |

### When to choose each experience

**Choose OpenTelemetry-based (preview) if:**
- You're monitoring individual VMs and want the fastest, most cost-effective metrics solution
- You're building new monitoring solutions and want to use open standards
- You need cross-platform consistency with the same metric names for Windows and Linux
- You need per-process metrics for deep performance analysis

**Choose logs-based (classic) if:**
- You need to monitor VM Scale Sets
- You want multi-VM dashboards and trending views across your entire VM fleet
- You need dependency mapping to understand application component relationships
- You want to correlate metrics and logs in a single query
- You have existing queries, dashboards, and alerts that use the `InsightsMetrics` table

You can enable either or both experiences on a VM. For step-by-step guidance, see [Enable monitoring for Azure virtual machine](vm-enable-monitoring.md).

## Logs
Azure Monitor collects several types of log data from your virtual machines that provide detailed information about events, operations, and system behavior.

### Activity logs
Activity logs are platform logs that provide insight into subscription-level events. Activity logs are collected automatically for all Azure resources at no cost. They record operations performed on a VM, such as when a VM is started or stopped, when configurations are changed, or when a VM is deleted.

You can view activity logs for a VM from its **Activity log** page in the Azure portal. This shows all operations for that specific VM. You can also view activity logs for all resources in a subscription from the **Activity log** page in the Azure Monitor menu.

For detailed analysis of activity logs, you can send them to a Log Analytics workspace where you can query them with other log data. See [Azure Monitor activity log](../essentials/activity-log.md) for details on viewing and analyzing activity logs.

### Guest logs
Guest logs are collected from the operating system and applications running inside a VM. Unlike activity logs, guest logs require configuration before they're collected. You must install the Azure Monitor agent and create a data collection rule that specifies which logs to collect and where to send them.

Common types of guest logs include:

- **Windows Event Logs**: System, Application, and Security events from Windows VMs. See [Collect Windows events with Azure Monitor Agent](data-collection-windows-events.md).
- **Syslog**: System logs from Linux VMs. See [Collect Syslog events with Azure Monitor Agent](data-collection-syslog.md).
- **IIS Logs**: Web server logs from Internet Information Services. See [Collect IIS logs with Azure Monitor Agent](data-collection-iis.md).
- **Custom text and JSON logs**: Application logs and custom log files. See [Collect logs from a text or JSON file with Azure Monitor Agent](data-collection-log-text.md).

For more information about collecting guest logs, see [Collect data from virtual machine client with Azure Monitor](data-collection.md).

## Additional data collection
Beyond the standard performance metrics and logs, Azure Monitor Agent can collect specialized data types from your VMs:

- **SNMP traps**: Collect Simple Network Management Protocol (SNMP) traps from network devices and appliances running on your VMs. See [Collect SNMP trap data with Azure Monitor Agent](data-collection-snmp-data.md).
- **Firewall logs**: Collect firewall logs from Windows VMs. See [Collect firewall logs with Azure Monitor Agent](data-collection-firewall-logs.md).
- **Send data to other destinations**: Send monitoring data from your VMs to Azure Event Hubs for streaming analysis or to Azure Storage for long-term retention. You can also send data to Microsoft Fabric for advanced analytics. See [Send monitoring data to Azure Event Hubs and Storage](send-event-hubs-storage.md) and [Send monitoring data to Microsoft Fabric](send-fabric-destination.md).

These specialized data sources require creating custom data collection rules. For detailed guidance, see the individual articles linked above.


## Alerts
Alerts in Azure Monitor proactively notify you when specific conditions are found in your monitoring data. Alerts allow you to identify and address issues in your system before your customers notice them. For example, you might create an alert to notify you when a VM is down or when its CPU usage exceeds a certain threshold.


### Recommended alert rules
Azure Monitor provides a set of recommended alert rules for VMs that you can quickly enable in the Azure portal. These are based on host metrics so you can enable them without enabling enhanced monitoring. Alert on common issues such as high CPU usage, low available memory, and disk performance problems. See [Enable recommended alert rules for Azure virtual machine](/azure/azure-monitor/vm/tutorial-monitor-vm-alert-recommended) for details on enabling recommended alerts.

### Additional alert rules
Beyond recommended alert rules, you can create custom alert rules based on any metric or log data collected from your VMs. Alert rules can notify you through email, SMS, or webhooks, and can trigger automated responses using Azure Automation runbooks or Azure Functions.

For guidance on creating custom alert rules for VMs, see:
- [Create metric alerts in Azure Monitor](../alerts/alerts-create-metric-alert-rule.yml)
- [Create log query alerts in Azure Monitor](../alerts/alerts-create-log-alert-rule.md)

### Azure Monitor Baseline Alerts (AMBA) 
[Azure Monitor Baseline Alerts](https://azure.github.io/azure-monitor-baseline-alerts/welcome/) (AMBA) are a set of predefined, customizable alert rules optimized for Azure Monitor agent data. These rules cover a wide range of scenarios and can be easily enabled to monitor the performance and health of your VMs. For example, you can enable AMBA alert rules to monitor specific performance counters, such as available memory or disk queue length, and receive notifications when these metrics exceed defined thresholds.

AMBA provides alert rules for:
- [Virtual machines](https://azure.github.io/azure-monitor-baseline-alerts/services/Compute/virtualMachines/)
- [Virtual machine scale sets](https://azure.github.io/azure-monitor-baseline-alerts/services/Compute/virtualMachineScaleSets/)

## VM insights for multi-VM monitoring
While the **Monitor** view provides monitoring for individual VMs, VM insights provides a comprehensive multi-VM monitoring experience designed for managing fleets of virtual machines. VM insights is part of the logs-based (classic) experience and provides predefined dashboards, workbooks, and dependency mapping capabilities.

### What VM insights provides

VM insights offers the following capabilities for monitoring multiple VMs:

- **Simplified onboarding**: Automated installation of Azure Monitor agent with predefined data collection rules that collect the most common performance counters for Windows and Linux.
- **Multi-VM dashboards**: View performance trends across all your VMs in a single interface. Identify outliers and VMs experiencing performance issues.
- **Predefined workbooks**: Analyze core performance metrics including CPU, memory, disk, and network performance with preconfigured visualizations.
- **Dependency mapping**: Visualize application components and their dependencies across VMs. Understand how your VMs communicate with each other and with external services. Requires the Dependency agent.
- **At-scale management**: Deploy monitoring to multiple VMs simultaneously using Azure Policy or the Azure portal.

### Performance views

VM insights provides several performance views to help you understand VM performance across your environment:

:::image type="content" source="media/monitor-vm/vminsights-01.png" lightbox="media/monitor-vm/vminsights-01.png" alt-text="Screenshot of the VM insights Logical Disk Performance view showing performance metrics across multiple VMs.":::

These views show trending performance data over time, helping you identify long-term patterns and performance degradation. For more information, see [Monitor performance with VM insights](vminsights-performance.md).

### Dependency mapping

The Map feature of VM insights displays the processes running on each VM and the network connections between VMs and external systems. This visualization helps you:

- Understand application architecture and component relationships
- Identify unexpected connections or dependencies
- Plan for VM migrations or decommissioning
- Troubleshoot connectivity issues

The Map feature requires installing the Dependency agent on your VMs in addition to the Azure Monitor agent. For more information, see [Map dependencies with VM insights](vminsights-maps.md).

> [!NOTE]
> The Map feature is scheduled for retirement. While it remains available, Microsoft is developing alternative solutions for dependency visualization. See [VM insights Map feature retirement guidance](vminsights-maps-retirement.md) for more information.

### Get started with VM insights

To enable VM insights for your VMs:

1. Go to the **VM insights** page in the Azure portal from the **Monitor** menu.
2. Select **Configure insights** to view VMs that aren't yet monitored.
3. Select the VMs you want to monitor and follow the configuration wizard.

For detailed guidance, see:
- [Tutorial: Enable monitoring with VM insights](tutorial-vm-enable-monitoring.md)
- [Enable VM insights overview](vminsights-overview.md)
- [Enable VM insights using Azure Policy](vminsights-enable-policy.md) for at-scale deployment

## Performance Diagnostics

Performance Diagnostics is a troubleshooting tool that helps you identify and diagnose performance issues on your Azure VMs. Unlike continuous monitoring with Azure Monitor agent, Performance Diagnostics runs on-demand analysis when you're actively troubleshooting a problem.

### When to use Performance Diagnostics

Use Performance Diagnostics when you need to:

- Investigate ongoing performance issues such as high CPU, memory, or disk usage
- Collect comprehensive diagnostic data for Microsoft Support
- Run benchmark tests on VM disk performance
- Analyze Azure Files or SMB share performance
- Identify configuration issues or known problems affecting VM performance

### How Performance Diagnostics works

Performance Diagnostics operates in two modes:

**Continuous diagnostics**: Monitors your VM at five-second intervals and provides actionable insights about high resource usage every five minutes. Continuous diagnostics helps you catch intermittent performance issues.

**On-demand diagnostics**: Runs a single point-in-time analysis with multiple report options:
- **Quick performance analysis**: Provides a basic overview of VM configuration and performance
- **Performance analysis**: Comprehensive analysis of resource consumption, known issues, and best practices
- **Benchmarking**: Tests disk IOPS and throughput for all attached disks
- **Azure Files analysis**: Specialized analysis for Azure Files performance including SMB counters

Performance Diagnostics stores all reports and insights in an Azure Storage account that you specify. This allows you to review results later or share them with Microsoft Support.

### Run Performance Diagnostics

You can run Performance Diagnostics directly from your VM's page in the Azure portal:

1. Navigate to your VM in the Azure portal
2. Select **Performance Diagnostics** under **Help**
3. Choose your diagnostics mode (Continuous or On-demand)
4. Select the report type and duration
5. Specify a storage account for results
6. Select **Run diagnostics**

For detailed guidance and information about interpreting results, see:
- [Performance Diagnostics overview](performance-diagnostics.md)
- [Run Performance Diagnostics](performance-diagnostics-run.md)
- [Analyze Performance Diagnostics results](performance-diagnostics-analyze.md)


## Related content

- [Tutorial: Enable monitoring for Azure virtual machine](tutorial-vm-enable-monitoring.md) - Get started with step-by-step guidance for enabling VM monitoring
- [Enable monitoring for Azure virtual machine](vm-enable-monitoring.md) - Comprehensive guide to enabling both OpenTelemetry and logs-based monitoring
- [Best practices for monitoring virtual machines in Azure Monitor](best-practices-vm.md) - Recommendations based on the Azure Well-Architected Framework
- [Collect data from virtual machine client with Azure Monitor](data-collection.md) - Configure data collection rules for custom performance counters, logs, and events
- [Overview of VM insights](vminsights-overview.md) - Learn about multi-VM monitoring with VM insights
- [Monitor your Azure virtual machines with Azure Monitor](/training/modules/monitor-azure-vm-using-diagnostic-data) - Interactive training module for VM monitoring
