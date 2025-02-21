---
title: Monitoring virtual machines in Azure
description: This article discusses how to monitor Azure virtual machines.
ms.service: virtual-machines
ms.topic: article
ms.custom: subject-monitoring
ms.date: 02/09/2025
---

# Monitor virtual machines in Azure

This article provides an overview of how to monitor the health and performance of virtual machines in Azure. This includes Azure virtual machines (VM), virtual machine scale sets (VMSS), and Azure Arc-enabled servers. 

> [!TIP]
> This article is intended for users who are new to Azure or Azure Monitor or those with basic VM monitor requirements. It provides an overview of the core concepts of monitoring VMs, the features provided by Azure Monitor, and guidance for the most common processes. If you have more advanced requirements or need to plan monitoring for a large number of VMs supporting an enterprise environment, see [Azure Monitor virtual deployment guide](./monitor-virtual-machine.md).


## Distinguish between VM host and client

When monitoring the performance and availability of a VM in Azure, it's important to distinguish between monitoring the host VM and its client operating system. 

| | |
|:---|:---|
| Host VM | Cloud infrastructure that supports the machine. In addition to tracking basic information such as whether this VM is running, monitoring the host VM includes data on CPU usage, memory consumption, disk I/O, and network traffic. These metrics provide insights into the overall health and performance of the VM, helping to identify issues such as resource bottlenecks or service outages. Host-level monitoring is crucial for ensuring that the VM has the necessary resources to operate efficiently and for detecting any underlying infrastructure problems that could affect its performance.<br><br>- Activity log. Track any changes made to the VM configuration in addition to the running history of the VM.<br>- Host metrics. Collected automatically.<br>- Recommended alerts. |
| Client OS | Software environment running in the VM. Monitoring the client OS includes tracking the health and performance of applications, services, and processes, as well as monitoring system logs and events. Client OS monitoring provides a detailed view of how the workloads running on the VM are performing, allowing for the identification of issues such as application crashes, high memory usage by specific processes, or security vulnerabilities. Monitoring the client OS allows you to ensure that the applications and services hosted by the VM are running smoothly and to quickly address any software-related issues that may arise.<br><br>To collect data from the client OS, you must install the [Azure Monitor agent](../agents/azure-monitor-agent-overview.md).<br><br>- VM insights.<br>- Data collection rules<br>- Alerts |

## VM Overview page
To begin exploring Azure Monitor, go to the **Overview** page for your virtual machine, and then select the **Monitoring** tab. This includes an overview of the VMs health based on data that's either automatically collected or that you can quickly enable. 

| Section | Description |
|:---|:---|
| Health events | Resource Health |
| Azure outages | Service Health |
| Alerts | |
| Insights | |
| Performance and utilization | |
| Additional Azure Monitor tools | |




You can see the number of active alerts on the tab.

The **Alerts** pane shows you the alerts fired in the last 24 hours, along with important statistics about those alerts. If there are no alerts configured for your VM, there is a link to help you quickly create new alerts for your VM.

:::image type="content" source="media/monitor-vm/overview-alerts.png" alt-text="Screenshot of the Azure virtual machine 'Alerts' pane.":::

The **Key Metrics** pane includes charts that show key health metrics, such as average CPU and network utilization. At the top of the pane, you can select a duration to change the time range for the charts, or select a chart to open the **Metrics** pane to drill down further or to create an alert rule. 

:::image type="content" source="media/monitor-vm/overview-key-metrics.png" alt-text="Screenshot of the Azure virtual machine 'Key metrics' pane.":::

## Activity log
The [Activity log](../essentials/activity-log.md) displays recent activity by the virtual machine, including any configuration changes and when it was stopped and started. View the Activity log in the Azure portal, or create a [diagnostic setting to send it to a Log Analytics workspace](../essentials/activity-log.md#send-to-log-analytics-workspace), where you can view events over time or analyze them with other collected data.

:::image type="content" source="media/monitor-vm/activity-log.png" lightbox="media/monitor-vm/activity-log.png" alt-text="Screenshot of the 'Activity log' pane.":::

## Recommended alerts
Start by enabling recommended alerts. These are a predefined set of alert rules based on host metrics for the VM. You can quickly enable and customize each of these rules with a few clicks in the Azure portal. See [Tutorial: Enable recommended alert rules for Azure virtual machine](./vm/tutorial-monitor-vm-alert-recommended.md). This includes the [VM availability metric](monitor-vm-reference.md#vm-availability-metric-preview) which alerts when the VM stops running.

## Azure Monitor agent
Azure Monitor starts automatically collecting metric data for your virtual machine host when you create the VM. To collect logs and performance data from the guest operating system of the virtual machine, though, you must install the [Azure Monitor agent](../agents/azure-monitor-agent-overview.md). You can install the agent and configure collection using either [VM insights](#vm-insights) or by [creating a data collection rule](#create-data-collection-rule) as described below.

## VM insights
VM insights is designed to monitor your Azure and hybrid virtual machines in a single interface. VM insights provides the following benefits beyond other features for monitoring VMs in Azure Monitor:

- Simplified onboarding of the Azure Monitor agent, so that you can monitor a virtual machine guest operating system and workloads.
- Pre-defined data collection rules that collect the most common set of performance data.
- Pre-defined trending performance charts and workbooks, so that you can analyze core performance metrics from the virtual machine's guest operating system.
- The Dependency map, which displays processes that run on each virtual machine and the interconnected components with other machines and external sources.

:::image type="content" source="media/monitor-vm/vminsights-01.png" lightbox="media/monitor-vm/vminsights-01.png" alt-text="Screenshot of the VM insights 'Logical Disk Performance' view.":::

:::image type="content" source="media/monitor-vm/vminsights-02.png" lightbox="media/monitor-vm/vminsights-02.png" alt-text="Screenshot of the VM insights 'Map' view.":::

For a tutorial on enabling VM insights for a virtual machine, see [Enable monitoring with VM insights for Azure virtual machine](./tutorial-monitor-vm-enable-insights.md). For general information about enabling insights and a variety of methods for onboarding virtual machines, see [Enable VM insights overview](./vminsights-enable-overview.md).



## Create data collection rule
If you enable [VM insights](#vm-insights), the Azure Monitor agent is installed and starts sending a predefined set of performance data to Azure Monitor Logs. You can create additional data collection rules to collect events and other performance data. To learn how to install the Azure Monitor agent and create a data collection rule that defines the data to collect, see [Tutorial: Collect guest logs and metrics from an Azure virtual machine](./tutorial-monitor-vm-guest.md).


## Analyze metrics
Metrics are numerical values that describe some aspect of a system at a particular point in time. Although platform metrics for the virtual machine host are collected automatically, you must install the Azure Monitor agent and [create a data collection rule](#create-data-collection-rule) to collect guest metrics.

The **Overview** pane includes the most common host metrics, and you can access others by using the **Metrics** pane. With this tool, you can create charts from metric values and visually correlate trends. You can also create a metric alert rule or pin a chart to an Azure dashboard. For a tutorial on using this tool, see [Analyze metrics for an Azure resource](../essentials/tutorial-metrics.md).

:::image type="content" source="media/monitor-vm/metrics-explorer.png" lightbox="media/monitor-vm/metrics-explorer.png" alt-text="Screenshot of the 'Metrics' pane in Azure Monitor.":::

For a list of the available metrics, see [Reference: Monitoring Azure virtual machine data](monitor-vm-reference.md#metrics). 

## Analyze logs
Event data in Azure Monitor Logs is stored in a Log Analytics workspace, where it's separated into tables, each with its own set of unique properties.

VM insights stores the data it collects in Logs, and the insights provide performance and map views that you can use to interactively analyze the data. You can work directly with this data to drill down further or perform custom analyses. For more information and to get sample queries for this data, see [How to query logs from VM insights](./vminsights-log-query.md).

To analyze other log data that you collect from your virtual machines, use [log queries](../logs/get-started-queries.md) in [Log Analytics](../logs/log-analytics-tutorial.md). Several [built-in queries](../logs/queries.md) for virtual machines are available to use, or you can create your own. You can interactively work with the results of these queries, include them in a workbook to make them available to other users, or generate alerts based on their results.

:::image type="content" source="media/monitor-vm/log-analytics-query.png" lightbox="media/monitor-vm/log-analytics-query.png" alt-text="Screenshot of the 'Logs' pane displaying Log Analytics query results.":::

## Alerts
Azure Monitor alerts proactively notify you when important conditions are found in your monitoring data. These alerts can help you identify and address issues in your system before your customers notice them. You can set alerts on [metrics](/azure/azure-monitor/platform/alerts-metric-overview), [logs](/azure/azure-monitor/platform/alerts-unified-log), and the [activity log](/azure/azure-monitor/platform/activity-log-alerts).



### Multi-resource metric alerts
Using recommended alerts, a separate alert rule is created for each VM. You can choose to instead use a [multi-resource alert rule](../alerts/alerts-types.md#monitor-multiple-resources) to use a single alert rule that applies to all VMs in a particular resource group or subscription (within the same region). See [Create availability alert rule for Azure virtual machine (preview)](./tutorial-monitor-vm-alert-availability.md) for a tutorial using the availability metric.

### Other alert rules
For more information about the various alerts for Azure virtual machines, see the following resources:

- See [Monitor virtual machines with Azure Monitor: Alerts](./monitor-virtual-machine-alerts.md) for common alert rules for virtual machines. 
- See [Create a log query alert for an Azure resource](../alerts/tutorial-log-alert.md) for a tutorial on creating a log query alert rule.
- For common log alert rules, go to the **Queries** pane in Log Analytics. For **Resource type**, enter **Virtual machines**, and for **Type**, enter **Alerts**.



## Next steps

For documentation about the logs and metrics that are generated by Azure virtual machines, see [Reference: Monitoring Azure virtual machine data](monitor-vm-reference.md).



> [!NOTE]
> This article provides basic information to help you get started with monitoring your VMs. For a complete guide to monitoring your entire environment of Azure and hybrid virtual machines, see [Monitor virtual machines with Azure Monitor](./monitor-virtual-machine.md).
