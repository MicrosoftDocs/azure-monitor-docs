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

> [!NOTE]
> - To enable monitoring using command line tools such as CLI and PowerShell, see [Enable VM monitoring in Azure Monitor](./vm-enable-monitoring.md).
> - For virtual machine scale sets, see [Tutorial: Enable monitoring for an Azure virtual machine scale set](./tutorial-scale-set-enable-monitoring.md).

In this tutorial, you learn how to:

> [!div class="checklist"]
> * Enable enhanced monitoring for a virtual machine, which installs Azure Monitor Agent and begins data collection.
> * Choose between metrics-based (preview) and logs-based (classic) experiences.
> * Inspect graphs analyzing performance data collected from the virtual machine.

## Prerequisites
To complete this tutorial, you need an Azure virtual machine to monitor.

> [!NOTE]
> As part of the Azure Monitor Agent installation process, Azure assigns a [system-assigned managed identity](/azure/app-service/overview-managed-identity?tabs=portal%2chttp#add-a-system-assigned-identity) to the machine if such an identity doesn't already exist.

## Enable enhanced monitoring
Select **Monitor** from your virtual machine's menu in the Azure portal. This shows common monitoring data collected for the machine. Host metrics showing CPU, network, and disk utilization are available by default. If enhanced monitoring hasn't been enabled, then several of the performance charts show no data, and you'll receive a message offering to enable it. Click **Configure** to open the **Configure monitor** page. 

:::image type="content" source="media/tutorial-vm-enable-monitoring/enable-monitoring.png" alt-text="Screenshot showing the Monitor page for a virtual machine with the option to enable monitoring." lightbox="media/tutorial-vm-enable-monitoring/enable-monitoring.png":::

Leave **[Preview] OpenTelemetry metrics** selected since this experience is available at no cost. You can choose to also select the logs-based option so you can compare the different experience between the two. For a complete description of the differences between these two experiences, see [Compare metrics-based and logs-based experiences](./metrics-opentelemetry-guest.md#compare-experiences).

A default Azure Monitor workspace and Log Analytics workspace are selected for you. If they don't already exist, then they'll be created for you in the same region as the virtual machine. If you already have existing workspaces that you want to use, then select **Customize infrastructure monitoring** and select the workspaces you want to use.

:::image type="content" source="media/tutorial-vm-enable-monitoring/configure-monitor.png" alt-text="Screenshot showing the customize configuration screen for a virtual machine." lightbox="media/tutorial-vm-enable-monitoring/configure-monitor.png":::

> [!NOTE]
> Metrics collected for metrics-based experience (preview) are listed in the **Customize configuration** page for information purposes only. This list can't be modified from this screen.

Select **Review + Enable** and then **Enable** After a few minutes, the Azure Monitor agent is installed on the virtual machine, and data will start being collected.

## View performance data
It will take a few minutes after the agent is installed for enough data to be collected to populate the portal. When both experiences are enabled for a VM, you get a selector at the top to choose the experience you want to view. Select each experience to compare the different charts and insights that are available.

The metrics-based (preview) experience provides a set of charts focused on key performance indicators for the virtual machine. It also incorporates statues from [Service Health](../../service-health/overview.md) and [Resource Health](../../service-health/resource-health-overview.md) to give you a quick view of the machine's overall health.

:::image type="content" source="media/tutorial-vm-enable-monitoring/metrics-experience.png" alt-text="Screenshot of metrics experience for VM monitoring." lightbox="media/tutorial-vm-enable-monitoring/metrics-experience.png":::

The logs-based experience uses summarized performance data collected in the Log Analytics workspace to populate a set of charts that allow you to analyze the performance of different components of the machine such as CPU, disk, and network over time.

:::image type="content" source="media/tutorial-vm-enable-monitoring/logs-experience.png" alt-text="Screenshot of logs experience for VM monitoring." lightbox="media/tutorial-vm-enable-monitoring/logs-experience.png":::

> [!NOTE]
> The **Maps** feature is displayed in both experiences but has been deprecated as described in [VM Insights Map and Dependency Agent retirement guidance](./vminsights-maps-retirement.md).

## View multi-VM performance data
The logs-based experience also provides the ability to view performance data across multiple virtual machines in a single chart. This allows you to compare the performance of different machines and identify any that might be under heavy load or experiencing performance issues. 


When the deployment is finished, you see views on the **Performance** tab in VM insights with performance data for the machine. This data shows you the values of key guest metrics over time.

:::image type="content" source="media/tutorial-vm-enable-monitoring/multiple-machine-view.png" lightbox="media/tutorial-vm-enable-monitoring/multiple-machine-view.png" alt-text="Screenshot that shows the VM insights Performance view.":::

## Next steps
Now that you have enabled enhanced monitoring for your virtual machine, collect log data such as Windows event log or Syslog from your virtual machine.

> [!div class="nextstepaction"]
> [Collect guest logs and metrics from Azure virtual machine](tutorial-monitor-vm-guest.md)
