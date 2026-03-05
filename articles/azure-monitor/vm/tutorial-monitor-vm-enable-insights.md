---
title: Enable monitoring with VM insights for an Azure virtual machine
description: Enable monitoring with VM insights in Azure Monitor to monitor an Azure virtual machine.
ms.topic: tutorial
ms.custom: subject-monitoring
ms.date: 05/21/2025
ms.reviewer: Xema Pathak
---

# Tutorial: Enable enhanced monitoring for an Azure virtual machine
Virtual machines in Azure automatically send host-level metrics to Azure Monitor, which provide insights into the overall performance and health of the virtual machine. For complete monitoring though, you also need to collect guest-level performance data from the virtual machine, which provides insights into the applications, components, and processes running on the machine and their performance and health.

This tutorial walks you through enabling enhanced monitoring to collect guest performance data from your virtual machines and fully enable monitoring views in the Azure portal. It also guides you through enabling recommended alerts based on the performance data collected from the virtual machine. 

In this tutorial, you learn how to:

> [!div class="checklist"]
> * Enable enhanced monitoring for a virtual machine, which installs Azure Monitor Agent and begins data collection.
> * Choose between OpenTelemetry-based metrics (preview) and Log Analytics workspace-based metrics (classic).
> * Inspect graphs analyzing performance data collected from the virtual machine.
> * Enable recommended alerts based on the performance data collected from the virtual machine.

## Prerequisites
To complete this tutorial, you need an Azure virtual machine to monitor.

## Enable enhanced monitoring
Select **Monitor** from your virtual machine's menu in the Azure portal. This shows common monitoring data collected for the machine. Host metrics showing CPU, network, and disk utilization are available by default. If enhanced monitoring hasn't been enabled, then several of the performance charts show no data, and you'll receive a message offering to enable it.

Click **Configure** to open the **Configure monitor** page. This page allows you to select between collecting OpenTelemetry-based metrics (preview) which are stored in an Azure Monitor workspaces or collecting log-based metrics (classic), which are stored in a Log Analytics workspace. For the purposes of this tutorial, select both options so you can compare the different experience between the two.

> [!NOTE]
For a complete description of the differences between these two experiences, see []().

A default Azure Monitor workspace and Log Analytics workspace are selected for you. If they don't already exist, then they'll be created for you in the same region as the virtual machine. If you already have existing workspaces that you want to use, then select **Customize infrastructure monitoring** and select the workspaces you want to use.

> [!NOTE]
> Metrics collected for OpenTelemetry-based metrics (preview) are listed in the **Customize configuration** page for information purposes only. This list can't be modified from this screen.

Select **Review + Enable** and then **Enable** After a few minutes, the Azure Monitor agent is installed on the virtual machine, and you start seeing all performance charts populate with data from the virtual machine.

## Inspect performance data

## View performance
When the deployment is finished, you see views on the **Performance** tab in VM insights with performance data for the machine. This data shows you the values of key guest metrics over time.

:::image type="content" source="media/tutorial-monitor-vm/performance.png" lightbox="media/tutorial-monitor-vm/performance.png" alt-text="Screenshot that shows the VM insights Performance view.":::


## Next steps
VM insights collects performance data from the VM guest operating system, but it doesn't collect log data such as Windows event log or Syslog. Now that you have the machine monitored with Azure Monitor Agent, you can create another data collection rule to perform this collection.

> [!div class="nextstepaction"]
> [Collect guest logs and metrics from Azure virtual machine](tutorial-monitor-vm-guest.md)
