---
title: Enable monitoring with VM insights for an Azure virtual machine
description: Enable monitoring with VM insights in Azure Monitor to monitor an Azure virtual machine.
ms.topic: tutorial
ms.custom: subject-monitoring
ms.date: 03/09/2026
ms.reviewer: Xema Pathak
---

# Tutorial: Enable enhanced monitoring for an Azure virtual machine
Virtual machines in Azure automatically send host-level metrics to Azure Monitor, which provide insights into the overall performance and health of the virtual machine. For complete monitoring though, you also need to collect guest-level performance data from the virtual machine, which provides insights into the applications, components, and processes running on the machine and their performance and health.

This tutorial walks you through enabling enhanced monitoring to collect guest performance data from your virtual machines and fully enable monitoring views using the Azure portal.

In this tutorial, you learn how to:

> [!div class="checklist"]
> * Enable enhanced monitoring for a virtual machine, which installs Azure Monitor Agent and begins data collection.
> * Choose between OpenTelemetry-based metrics (preview) and Log Analytics workspace-based metrics (classic).
> * Inspect graphs analyzing performance data collected from the virtual machine.

## Prerequisites
To complete this tutorial, you need an Azure virtual machine to monitor.

> [!NOTE]
> As part of the Azure Monitor Agent installation process, Azure assigns a [system-assigned managed identity](/azure/app-service/overview-managed-identity?tabs=portal%2chttp#add-a-system-assigned-identity) to the machine if such an identity doesn't already exist.

## Enable enhanced monitoring
Select **Monitor** from your virtual machine's menu in the Azure portal. This shows common monitoring data collected for the machine. Host metrics showing CPU, network, and disk utilization are available by default. If enhanced monitoring hasn't been enabled, then several of the performance charts show no data, and you'll receive a message offering to enable it.

Click **Configure** to open the **Configure monitor** page. This page allows you to select between collecting OpenTelemetry-based metrics (preview) which are stored in an Azure Monitor workspaces or collecting log-based metrics (classic), which are stored in a Log Analytics workspace. For the purposes of this tutorial, select both options so you can compare the different experience between the two.

> [!NOTE]
> For a complete description of the differences between these two experiences, see [Compare OpenTelemetry and logs-based experiences](./metrics-opentelemetry-guest.md#compare-opentelemetry-and-logs-based-experiences).

A default Azure Monitor workspace and Log Analytics workspace are selected for you. If they don't already exist, then they'll be created for you in the same region as the virtual machine. If you already have existing workspaces that you want to use, then select **Customize infrastructure monitoring** and select the workspaces you want to use.

> [!NOTE]
> Metrics collected for OpenTelemetry-based metrics (preview) are listed in the **Customize configuration** page for information purposes only. This list can't be modified from this screen.


:::image type="content" source="media/tutorial-vm-enable-monitoring/configure-monitor.png" alt-text="Screenshot showing the customize configuration screen for a virtual machine." lightbox="media/tutorial-vm-enable-monitoring/configure-monitor.png":::

Select **Review + Enable** and then **Enable** After a few minutes, the Azure Monitor agent is installed on the virtual machine, and you start seeing all performance charts populate with data from the virtual machine.

## View performance data
It will take a few minutes after the agent is installed for enough data to be collected to populate the portal. When both experiences are enabled for a VM, you get a selector at the top to choose the experience you want to view. Select each experience to compare the different charts and insights that are available.

The OpenTelemetry-based metrics (preview) experience provides a set of charts focused on key performance indicators for the virtual machine. It also incorporates statues from [Service Health]() and [Resource Health]() to give you a quick view of the machine's overall health.

:::image type="content" source="media/tutorial-vm-enable-monitoring/metrics-experience.png" alt-text="Screenshot of metrics experience for VM monitoring." lightbox="media/tutorial-vm-enable-monitoring/metrics-experience.png":::

The logs-based experience uses summarized performance data collected in the Log Analytics workspace to populate a set of charts that allow you to analyze the performance of different components of the machine such as CPU, disk, and network over time.

:::image type="content" source="media/tutorial-vm-enable-monitoring/logs-experience.png" alt-text="Screenshot of logs experience for VM monitoring." lightbox="media/tutorial-vm-enable-monitoring/logs-experience.png":::

> [!NOTE]
> The **Maps** feature is available in both experiences but has been deprecated as described in [VM Insights Map and Dependency Agent retirement guidance](./vminsights-maps-retirement.md).

## View multi-VM performance data
The logs-based experience also provides the ability to view performance data across multiple virtual machines in a single chart. This allows you to compare the performance of different machines and identify any that might be under heavy load or experiencing performance issues. 


When the deployment is finished, you see views on the **Performance** tab in VM insights with performance data for the machine. This data shows you the values of key guest metrics over time.

:::image type="content" source="media/tutorial-monitor-vm/performance.png" lightbox="media/tutorial-monitor-vm/performance.png" alt-text="Screenshot that shows the VM insights Performance view.":::

## Next steps
Now that you have enabled enhanced monitoring for your virtual machine, you can enable recommended alerts based on the performance data being collected.

> [!div class="nextstepaction"]
> [Enable recommended alerts for an Azure virtual machine](./tutorial-vm-alerts.md)

You can also collect log data such as Windows event log or Syslog from your virtual machine.

> [!div class="nextstepaction"]
> [Collect guest logs and metrics from Azure virtual machine](tutorial-monitor-vm-guest.md)
