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

This tutorial walks you through enabling enhanced monitoring to collect guest performance data from your virtual machines and fully enable monitoring views using the Azure portal. It also guides you through enabling recommended alerts based on the performance data collected from the virtual machine. 

In this tutorial, you learn how to:

> [!div class="checklist"]
> * Enable enhanced monitoring for a virtual machine, which installs Azure Monitor Agent and begins data collection.
> * Choose between OpenTelemetry-based metrics (preview) and Log Analytics workspace-based metrics (classic).
> * Inspect graphs analyzing performance data collected from the virtual machine.
> * Enable recommended alerts based on the performance data collected from the virtual machine.

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
> The **Maps** feature is available in both experiences but has been deprecated as described in []().

## View multi-VM performance data
The logs-based experience also provides the ability to view performance data across multiple virtual machines in a single chart. This allows you to compare the performance of different machines and identify any that might be under heavy load or experiencing performance issues. 


When the deployment is finished, you see views on the **Performance** tab in VM insights with performance data for the machine. This data shows you the values of key guest metrics over time.

:::image type="content" source="media/tutorial-monitor-vm/performance.png" lightbox="media/tutorial-monitor-vm/performance.png" alt-text="Screenshot that shows the VM insights Performance view.":::

## Create recommended alert rules

1. From the menu for the VM, select **Alerts** in the **Monitoring** section. Select **View + set up**.

    :::image type="content" source="media/tutorial-monitor-vm/enable-recommended-alerts.png" alt-text="Screenshot of option to enable recommended alerts for a virtual machine." lightbox="media/tutorial-monitor-vm/enable-recommended-alerts.png":::

    A list of recommended alert rules is displayed. You can select which rules to create. You can also change the recommended threshold. Ensure that **Email** is enabled and provide an email address to be notified when any of the alerts fire. An [action group](../alerts/action-groups.md) will be created with this address. If you already have an action group that you want to use, you can specify it instead.

    :::image type="content" source="media/tutorial-monitor-vm/set-up-recommended-alerts.png" alt-text="Screenshot of recommended alert rule configuration." lightbox="media/tutorial-monitor-vm/set-up-recommended-alerts.png":::
1. Expand each of the alert rules to see its details. By default, the severity for each is **Informational**. You might want to change to another severity such as **Error**.

    :::image type="content" source="media/tutorial-monitor-vm/configure-alert-severity.png" alt-text="Screenshot of recommended alert rule severity configuration." lightbox="media/tutorial-monitor-vm/configure-alert-severity.png":::

1. Select **Save** to create the alert rules.

## View created alert rules

When the alert rule creation is complete, you'll see the alerts screen for the VM. 

:::image type="content" source="media/tutorial-monitor-vm/recommended-alerts-complete.png" alt-text="Screenshot of alert screen for a VM." lightbox="media/tutorial-monitor-vm/recommended-alerts-complete.png":::

Click **Alert rules** to view the rules you just created. You can click on any of the rules to view their details and to modify their threshold if you want.

:::image type="content" source="media/tutorial-monitor-vm/recommended-alerts-rules.png" alt-text="Screenshot of list of created alert rules." lightbox="media/tutorial-monitor-vm/recommended-alerts-rules.png":::

## Next steps
VM insights collects performance data from the VM guest operating system, but it doesn't collect log data such as Windows event log or Syslog. Now that you have the machine monitored with Azure Monitor Agent, you can create another data collection rule to perform this collection.

> [!div class="nextstepaction"]
> [Collect guest logs and metrics from Azure virtual machine](tutorial-monitor-vm-guest.md)
