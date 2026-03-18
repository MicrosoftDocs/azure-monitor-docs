---
title: Monitor virtual machines in Azure
description: Start here to learn how to monitor Azure Virtual Machines and Virtual Machine Scale Sets.
ai-usage: ai-assisted
ms.date: 03/08/2026
ms.custom: horz-monitor
ms.topic: concept-article

#customer intent: As a cloud administrator, I want to understand how to monitor Azure virtual machines so that I can ensure the health and performance of my virtual machines and applications.
---

# Monitor virtual machines in Azure

Use Azure Monitor to track the health and performance of your virtual machines and the workloads that run on them. This article introduces the main monitoring options for virtual machines, from host metrics to guest-level telemetry.

## Related resources

| Resource type | Description |
|:--|:--|
| Hybrid machine | For virtual machines in other clouds and on-premises, use [Azure Arc-enabled servers](/azure/azure-arc/servers/overview) to connect them to Azure Monitor. After you install the Azure Connected Machine agent, you can monitor these machines by using the same methods as Azure VMs. |
| Virtual machine scale sets | Azure Virtual Machine Scale Sets (VMSS) support host metrics and guest performance data through Azure Monitor agent, similar to Azure VMs. VMSS doesn't support the new metrics experience. For setup guidance, see [Tutorial: Enable monitoring for an Azure virtual machine scale set](./tutorial-scale-set-enable-monitoring.md). |

## View VM health
Open **Monitor** for any virtual machine in the Azure portal to see its current health. This view shows a summary of common metrics, although the available data depends on your monitoring configuration. Host metrics, including availability, are collected by default. Guest metrics and logs require the enhanced monitoring configuration described in [Enable enhanced monitoring](#enable-enhanced-monitoring).

## Enable enhanced monitoring
Azure Monitor collects two types of metrics from virtual machines:

- **Host metrics** provide visibility into overall performance and load (CPU usage, network traffic, disk I/O). These are collected automatically at no cost.
- **Guest metrics** provide detailed insights into applications, components, and processes running inside the machine. For example, when troubleshooting performance issues, you might start with host metrics to identify which machines are under load, then use guest data to drill down into specific operating system and application behavior.

Enable enhanced monitoring to collect guest data and fully light up the **Monitor** view in the Azure portal. This process installs [Azure Monitor agent](../agents/azure-monitor-agent-overview.md) on the virtual machine and starts collecting a default set of metrics.

If you enable guest monitoring in the Azure portal, choose between two experiences. Both provide guest monitoring, but they differ in how they store and process metrics. See [OpenTelemetry Guest OS Metrics (preview)](./metrics-opentelemetry-guest.md) for guidance on choosing the right option.

For step-by-step guidance on enabling enhanced monitoring, start with [Tutorial: Enable enhanced monitoring for an Azure virtual machine](./tutorial-vm-enable-monitoring.md).


## Enable at scale
You can enable VM monitoring at scale by using Azure CLI, PowerShell, Azure Policy, ARM templates, Bicep, and other infrastructure as code (IaC) tools. For implementation guidance, see [Enable VM monitoring in Azure Monitor](./vm-enable-monitoring.md).

## Collect logs
Azure Monitor collects several types of log data from your virtual machines that provide detailed information about events, operations, and system behavior.

### Activity logs
Activity logs record operations performed on a VM, such as when a VM is started or stopped, when configurations are changed, or when a VM is deleted. They're collected automatically for all Azure resources at no cost. View activity logs for a VM from its **Activity log** page in the Azure portal. This shows all operations for that specific VM. You can also view activity logs for all resources in a subscription from the **Activity log** page in the Azure Monitor menu. Send them to a Log Analytics workspace where you can query them with other log data. See [Azure Monitor activity log](../platform/activity-log.md) for details on viewing and analyzing activity logs.

### Guest logs
Guest logs come from the operating system and applications running inside a VM. Unlike activity logs, you must configure guest logs before Azure Monitor can collect them, and ingestion and storage charges apply. Create data collection rules to define which logs to collect and where to send them. See [Collect data from virtual machine client with Azure Monitor](data-collection.md).

Common types of guest logs include:

- [Windows Event Logs](data-collection-windows-events.md)
- [Syslog](data-collection-syslog.md)
- [IIS Logs](data-collection-iis.md)
- [Custom text logs](data-collection-log-text.md)
- [Custom JSON logs](data-collection-log-json.md)
- [SNMP traps](./data-collection-snmp-data.md)
- [Windows Firewall logs](./data-collection-firewall-logs.md)

After Azure Monitor sends logs to a Log Analytics workspace, you can analyze them with [Kusto Query Language (KQL)](/azure/data-explorer/kusto/query/). For example, you can query Windows Event Logs to identify common errors or security events, or analyze IIS logs to understand web traffic patterns. See [Log Analytics overview](../logs/log-analytics-overview.md) for more information.

## Alerts
Alerts in Azure Monitor proactively notify you when specific conditions are found in your monitoring data. Alerts allow you to identify and address issues in your system before your customers notice them. For example, you might create an alert to notify you when a VM is down, when its CPU usage exceeds a certain threshold, or when error events are discovered.

### Recommended alert rules
Azure Monitor provides recommended alert rules for VMs and virtual machine scale sets that you can enable quickly in the Azure portal. These rules use host metrics, so you can enable them without enhanced monitoring. They cover common conditions such as high CPU usage, low available memory, and disk performance issues.

For step-by-step guidance on enabling recommended alerts, see:
- [Enable recommended alert rules for Azure virtual machine](tutorial-vm-alerts.md)
- [Enable recommended alert rules for Azure virtual machine scale set](tutorial-scale-set-alerts.md)

### Additional alert rules
Beyond recommended alert rules, you can create custom alert rules based on any metric or log data collected from your VMs. Alert rules can notify you through email, SMS, or webhooks, and can trigger automated responses using Azure Automation runbooks or Azure Functions.

For guidance on creating custom alert rules for VMs, see:
- [Create metric alerts in Azure Monitor](../alerts/alerts-create-metric-alert-rule.md)
- [Create log query alerts in Azure Monitor](../alerts/alerts-create-log-alert-rule.md)

### Azure Monitor Baseline Alerts (AMBA) 
[Azure Monitor Baseline Alerts (AMBA)](https://azure.github.io/azure-monitor-baseline-alerts) provide a predefined alert baseline that you can customize for Azure Monitor agent data. You can use AMBA to monitor VM performance and health by enabling alert rules for metrics such as available memory or disk queue length.


## Performance Diagnostics

Performance Diagnostics is a troubleshooting tool that helps you identify and diagnose performance issues on your Azure VMs. Use Performance Diagnostics when you need to:

- Investigate ongoing performance issues such as high CPU, memory, or disk usage
- Collect comprehensive diagnostic data for Microsoft Support
- Run benchmark tests on VM disk performance
- Analyze Azure Files or SMB share performance
- Identify configuration issues or known problems affecting VM performance

See [Use Performance Diagnostics in Azure Monitor to troubleshoot VM performance issues](./performance-diagnostics.md) for details on using Performance Diagnostics.

## Related content

- [Tutorial: Enable monitoring for Azure virtual machine](tutorial-vm-enable-monitoring.md) - Enable monitoring for a single VM.
- [Tutorial: Enable monitoring for Azure virtual machine scale set](tutorial-scale-set-enable-monitoring.md) - Enable monitoring for a scale set.
- [Tutorial: Enable recommended alerts for Azure virtual machine](tutorial-vm-alerts.md) - Turn on recommended alert rules for a VM.
- [Tutorial: Enable recommended alerts for Azure virtual machine scale set](tutorial-scale-set-alerts.md) - Turn on recommended alert rules for a scale set.
- [Enable monitoring for Azure virtual machine](vm-enable-monitoring.md) - Configure monitoring at scale.
- [Migrate from logs-based to OpenTelemetry metrics](./vm-opentelemetry-migrate.md) - Move to the OpenTelemetry-based metrics experience.
- [Best practices for monitoring virtual machines in Azure Monitor](best-practices-vm.md) - Review architecture and operational recommendations.
- [Collect data from virtual machine client with Azure Monitor](data-collection.md) - Configure custom performance counters, logs, and events.
- [Overview of VM insights](vminsights-overview.md) - Learn about multi-VM monitoring with VM insights.
- [Monitor your Azure virtual machines with Azure Monitor](/training/modules/monitor-azure-vm-using-diagnostic-data) - Complete the training module for VM monitoring.
