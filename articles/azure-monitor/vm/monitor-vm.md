---
title: Monitor virtual machines in Azure
description: Start here to learn how to monitor Azure Virtual Machines and Virtual Machine Scale Sets.
ms.date: 03/08/2026
ms.custom: horz-monitor
ms.topic: concept-article

#customer intent: As a cloud administrator, I want to understand how to monitor Azure virtual machines so that I can ensure the health and performance of my virtual machines and applications.
---

# Monitor Azure Virtual Machines and Virtual Machine Scale Sets

This article provides an overview of how to monitor the health and performance of Azure virtual machines (VM) and virtual machine scale sets (VMSS). Whether you're new to Azure or transitioning from on-premises infrastructure, understanding your monitoring options helps you maintain reliable, high-performing virtual machines.

## Supported machines and operating systems
This article applies to the following types of machines running any operating systems [supported by the Azure Monitor agent](../agents/azure-monitor-agent-supported-operating-systems.md).

- Azure virtual machines
- Azure Virtual Machine Scale Sets
- Arc-enabled servers

## Monitor a single VM
View the current health of a VM from the **Monitor** option for the VM in the Azure portal. This includes a summary of the most common metrics for the VM. The data that's available in this view is based on the monitoring that you've enabled for the VM. Host metrics, including availability, are available by default. Guest metrics and logs are only available when you enable enhanced monitoring as described in [Enable enhanced monitoring](#enable-enhanced-monitoring).

:::image type="content" source="media/monitor-vm/vm-monitor-view.png" lightbox="media/monitor-vm/vm-monitor-view.png" alt-text="Screenshot that shows the Monitor view for a virtual machine in the Azure portal.":::

## Monitor VM host and guest metrics and logs
Host-level VM data gives you an understanding of the VM's overall performance and load, while the guest-level data gives you visibility into the applications, components, and processes running on the machine and their performance and health. For example, if you’re troubleshooting a performance issue, you might start with host metrics to see which VM is under heavy load, and then use guest metrics to drill down into the details of the operating system and application performance.

Collecting guest data requires installing the [Azure Monitor agent](../agents/azure-monitor-agent-overview.md) on the VM. Once installed, the agent collects a default set of metrics, and you can create [data collection rules](../data-collection/data-collection-rule-overview.md) used by the agent to collect additional performance counters and logs.


## Enable enhanced monitoring
When you enable enhanced monitoring for a VM, the Azure Monitor agent is installed on it, and the agent starts sending guest metrics to Azure Monitor. This fully enables the **Monitor** view in the Azure portal. You can use this data to analyze the performance of the VM and its workloads and create alerts based on metrics. See [Tutorial: Enable enhanced monitoring for an Azure virtual machine](./tutorial-vm-collect-logs.md) for step-by-step guidance on enabling enhanced monitoring for a VM.

When you enable guest monitoring for a VM using the Azure portal, you choose between two experiences: the OpenTelemetry-based experience (preview) and the logs-based experience (classic). Both experiences provide robust monitoring capabilities, but they differ in how they store and process metrics. See [OpenTelemetry Guest OS Metrics (preview)](./metrics-opentelemetry-guest.md) for details on each experience and guidance on selecting the right one for your needs.

## Enable at scale
You can enable VM monitoring at scale using multiple methods including Azure CLI, PowerShell, Azure Policy, ARM templates, Bicep, and other infrastructure as code (IaC) tools that support automated and repeatable deployments across your VM fleet. See [Enable VM monitoring in Azure Monitor](./vm-enable-monitoring.md) for details on enabling monitoring at scale using these different methods.

## Logs
Azure Monitor collects several types of log data from your virtual machines that provide detailed information about events, operations, and system behavior.

### Activity logs
Activity logs record operations performed on a VM, such as when a VM is started or stopped, when configurations are changed, or when a VM is deleted. Activity logs are collected automatically for all Azure resources at no cost. 

View activity logs for a VM from its **Activity log** page in the Azure portal. This shows all operations for that specific VM. You can also view activity logs for all resources in a subscription from the **Activity log** page in the Azure Monitor menu. Send them to a Log Analytics workspace where you can query them with other log data. See [Azure Monitor activity log](../platform/activity-log.md) for details on viewing and analyzing activity logs.

### Guest logs
Guest logs are collected from the operating system and applications running inside a VM. Unlike activity logs, guest logs require configuration before they're collected. You must install the Azure Monitor agent and create one or more data collection rules that specify which logs to collect and where to send them. See [Collect data from virtual machine client with Azure Monitor](data-collection.md).

Common types of guest logs include:

- [Windows Event Logs](data-collection-windows-events.md)
- [Syslog](data-collection-syslog.md)
- [IIS Logs](data-collection-iis.md)
- [Custom text logs](data-collection-log-text.md)
- [Custom JSON logs](data-collection-log-text.md)
- [SNMP traps](./data-collection-snmp-data.md)
- [Windows Firewall logs](./data-collection-firewall-logs.md)

Once logs are collected in a Log Analytics workspace, you can analyze them using [Kusto Query Language (KQL)](/azure/data-explorer/kusto/query/) to gain insights into the operations and behavior of your VMs. For example,  query Windows Event Logs to identify common errors or security events, or analyze IIS logs to understand web traffic patterns. See [Log Analytics overview](../logs/log-analytics-overview.md) for details on analyzing log data with KQL.

## Alerts
Alerts in Azure Monitor proactively notify you when specific conditions are found in your monitoring data. Alerts allow you to identify and address issues in your system before your customers notice them. For example, you might create an alert to notify you when a VM is down or when its CPU usage exceeds a certain threshold.


### Recommended alert rules
Azure Monitor provides a set of recommended alert rules for VMs that you can quickly enable in the Azure portal. These are based on host metrics so you can enable them without enabling enhanced monitoring. Alert on common issues such as high CPU usage, low available memory, and disk performance problems. See [Enable recommended alert rules for Azure virtual machine](/azure/azure-monitor/vm/tutorial-monitor-vm-alert-recommended) for details on enabling recommended alerts.

### Additional alert rules
Beyond recommended alert rules, you can create custom alert rules based on any metric or log data collected from your VMs. Alert rules can notify you through email, SMS, or webhooks, and can trigger automated responses using Azure Automation runbooks or Azure Functions.

For guidance on creating custom alert rules for VMs, see:
- [Create metric alerts in Azure Monitor](../alerts/alerts-create-metric-alert-rule.md)
- [Create log query alerts in Azure Monitor](../alerts/alerts-create-log-alert-rule.md)

### Azure Monitor Baseline Alerts (AMBA) 
[Azure Monitor Baseline Alerts (AMBA)](https://azure.github.io/azure-monitor-baseline-alerts/welcome/) are a set of predefined, customizable alert rules optimized for Azure Monitor agent data. These rules cover a wide range of scenarios and can be easily enabled to monitor the performance and health of your VMs. For example, you can enable AMBA alert rules to monitor specific performance counters, such as available memory or disk queue length, and receive notifications when these metrics exceed defined thresholds.


## Performance Diagnostics

Performance Diagnostics is a troubleshooting tool that helps you identify and diagnose performance issues on your Azure VMs. Use Performance Diagnostics when you need to:

- Investigate ongoing performance issues such as high CPU, memory, or disk usage
- Collect comprehensive diagnostic data for Microsoft Support
- Run benchmark tests on VM disk performance
- Analyze Azure Files or SMB share performance
- Identify configuration issues or known problems affecting VM performance

See [Use Performance Diagnostics in Azure Monitor to troubleshoot VM performance issues](./performance-diagnostics.md) for details on using Performance Diagnostics.

## Related content

- [Tutorial: Enable monitoring for Azure virtual machine](tutorial-vm-enable-monitoring.md) - Get started with step-by-step guidance for enabling VM monitoring
- [Enable monitoring for Azure virtual machine](vm-enable-monitoring.md) - Comprehensive guide to enabling both OpenTelemetry and logs-based monitoring
- [Best practices for monitoring virtual machines in Azure Monitor](best-practices-vm.md) - Recommendations based on the Azure Well-Architected Framework
- [Collect data from virtual machine client with Azure Monitor](data-collection.md) - Configure data collection rules for custom performance counters, logs, and events
- [Overview of VM insights](vminsights-overview.md) - Learn about multi-VM monitoring with VM insights
- [Monitor your Azure virtual machines with Azure Monitor](/training/modules/monitor-azure-vm-using-diagnostic-data) - Interactive training module for VM monitoring
