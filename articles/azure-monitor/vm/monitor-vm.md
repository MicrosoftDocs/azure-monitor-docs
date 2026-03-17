---
title: Monitor virtual machines in Azure
description: Start here to learn how to monitor Azure Virtual Machines and Virtual Machine Scale Sets.
ms.date: 03/08/2026
ms.custom: horz-monitor
ms.topic: concept-article

#customer intent: As a cloud administrator, I want to understand how to monitor Azure virtual machines so that I can ensure the health and performance of my virtual machines and applications.
---

# Monitor virtual machines in Azure

Azure Monitor provides comprehensive capabilities for tracking the health and performance of your virtual machines and the workloads they run. This article helps you understand the complete range of monitoring options available—from basic host metrics to advanced guest-level telemetry—so you can maintain reliable, high-performing infrastructure whether your workloads run in Azure or on-premises.

## Related resources

### Hybrid machine
For virtual machines in other clouds and on-premises, use [Azure Arc-enabled servers](https://azure.microsoft.com/azure-arc/servers/) to connect them to Azure Monitor. Once the Azure Connected Machine agent has been installed, you can monitor the machine using the same methods as an Azure VM. 

### Virtual machine scale sets
Azure virtual machine scale sets (VMSS) monitoring capabilities are similar to Azure VMs, with support for host metrics and guest performance data using the Azure Monitor agent. They do not support the new metrics experience though. See [Tutorial: Enable monitoring for an Azure virtual machine scale set](./tutorial-scale-set-enable-monitoring.md) for details on enabling monitoring for scale sets.

## View VM health
View the current health of any virtual machine from the **Monitor** option in the Azure portal. This view provides a summary of the most common metrics, with available data varying based on your monitoring configuration. Host metrics, including availability, are collected by default. Guest metrics and logs require enhanced monitoring as described in [Enable enhanced monitoring](#enable-enhanced-monitoring).

## Enable enhanced monitoring
Azure Monitor collects two types of metric data from virtual machines:

- **Host metrics** provide visibility into overall performance and load (CPU usage, network traffic, disk I/O). These are collected automatically at no cost.
- **Guest metrics** provide detailed insights into applications, components, and processes running inside the machine. For example, when troubleshooting performance issues, you might start with host metrics to identify which machines are under load, then use guest data to drill down into specific operating system and application behavior.

Enable enhanced monitoring to collect guest data and fully enable the **Monitor** view in the Azure portal. This installs the [Azure Monitor agent](../agents/azure-monitor-agent-overview.md) on your virtual machine and starts collecting a default set of metrics. 

When you enable guest monitoring using the Azure portal, choose between two experiences. Both experiences provide robust monitoring capabilities but differ in how they store and process metrics. See [OpenTelemetry Guest OS Metrics (preview)](./metrics-opentelemetry-guest.md) for details on each experience and guidance on selecting the right one for your needs.

For step-by-step guidance on enabling enhanced monitoring, start with [Tutorial: Enable enhanced monitoring for an Azure virtual machine](./tutorial-vm-enable-monitoring.md).


## Enable at scale
You can enable VM monitoring at scale using multiple methods including Azure CLI, PowerShell, Azure Policy, ARM templates, Bicep, and other infrastructure as code (IaC) tools that support automated and repeatable deployments across your VM fleet. See [Enable VM monitoring in Azure Monitor](./vm-enable-monitoring.md) for details on enabling monitoring at scale using these different methods.

## Collect logs
Azure Monitor collects several types of log data from your virtual machines that provide detailed information about events, operations, and system behavior.

### Activity logs
Activity logs record operations performed on a VM, such as when a VM is started or stopped, when configurations are changed, or when a VM is deleted. They're collected automatically for all Azure resources at no cost. View activity logs for a VM from its **Activity log** page in the Azure portal. This shows all operations for that specific VM. You can also view activity logs for all resources in a subscription from the **Activity log** page in the Azure Monitor menu. Send them to a Log Analytics workspace where you can query them with other log data. See [Azure Monitor activity log](../platform/activity-log.md) for details on viewing and analyzing activity logs.

### Guest logs
Guest logs are collected from the operating system and applications running inside a VM. Unlike activity logs, guest logs require configuration before they're collected and there is a charge for their ingestion and storage. Create data collection rules to specify which logs to collect and where to send them. See [Collect data from virtual machine client with Azure Monitor](data-collection.md).

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
Alerts in Azure Monitor proactively notify you when specific conditions are found in your monitoring data. Alerts allow you to identify and address issues in your system before your customers notice them. For example, you might create an alert to notify you when a VM is down, when its CPU usage exceeds a certain threshold, or when error events are discovered.

### Recommended alert rules
Azure Monitor provides a set of recommended alert rules for VMs and virtual machine scale sets that you can quickly enable in the Azure portal. These are based on host metrics so you can enable them without enabling enhanced monitoring. Alert on common issues such as high CPU usage, low available memory, and disk performance problems.

For step-by-step guidance on enabling recommended alerts, see:
- [Enable recommended alert rules for Azure virtual machine](tutorial-vm-alerts.md)
- [Enable recommended alert rules for Azure virtual machine scale set](tutorial-scale-set-alerts.md)

### Additional alert rules
Beyond recommended alert rules, you can create custom alert rules based on any metric or log data collected from your VMs. Alert rules can notify you through email, SMS, or webhooks, and can trigger automated responses using Azure Automation runbooks or Azure Functions.

For guidance on creating custom alert rules for VMs, see:
- [Create metric alerts in Azure Monitor](../alerts/alerts-create-metric-alert-rule.md)
- [Create log query alerts in Azure Monitor](../alerts/alerts-create-log-alert-rule.md)

### Azure Monitor Baseline Alerts (AMBA) 
[Azure Monitor Baseline Alerts (AMBA)](https://azure.github.io/azure-monitor-baseline-alerts) are a set of predefined, customizable alert rules optimized for Azure Monitor agent data. These rules cover a wide range of scenarios and can be easily enabled to monitor the performance and health of your VMs. For example, you can enable AMBA alert rules to monitor specific performance counters, such as available memory or disk queue length, and receive notifications when these metrics exceed defined thresholds.


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
- [Tutorial: Enable monitoring for Azure virtual machine scale set](tutorial-scale-set-enable-monitoring.md) - Step-by-step guidance for enabling monitoring for scale sets
- [Tutorial: Enable recommended alerts for Azure virtual machine](tutorial-vm-alerts.md) - Enable alerts to get notified about VM issues
- [Tutorial: Enable recommended alerts for Azure virtual machine scale set](tutorial-scale-set-alerts.md) - Enable alerts to get notified about scale set issues
- [Enable monitoring for Azure virtual machine](vm-enable-monitoring.md) - Comprehensive guide to enabling both OpenTelemetry and logs-based monitoring
- [Migrate from logs-based to OpenTelemetry metrics](./vm-opentelemetry-migrate.md) - Switch from logs-based to OpenTelemetry experience
- [Best practices for monitoring virtual machines in Azure Monitor](best-practices-vm.md) - Recommendations based on the Azure Well-Architected Framework
- [Collect data from virtual machine client with Azure Monitor](data-collection.md) - Configure data collection rules for custom performance counters, logs, and events
- [Overview of VM insights](vminsights-overview.md) - Learn about multi-VM monitoring with VM insights
- [Monitor your Azure virtual machines with Azure Monitor](/training/modules/monitor-azure-vm-using-diagnostic-data) - Interactive training module for VM monitoring
