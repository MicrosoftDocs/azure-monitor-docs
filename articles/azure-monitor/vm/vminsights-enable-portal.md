---
title: Enable VM insights in the Azure portal
description: Learn how to enable VM insights on a single Azure virtual machine or Virtual Machine Scale Set using the Azure portal.
ms.topic: conceptual
author: guywi-ms
ms.author: guywild
ms.reviewer: xpathak
ms.date: 09/28/2023

---

# Enable VM insights using the Azure portal
This article describes how to enable [VM insights](./vminsights-overview.md) using the Azure portal.

> [!NOTE]
> Azure portal no longer supports enabling VM insights using the legacy Log Analytics agent. 

## Supported machines

- Azure virtual machines
- Azure Virtual Machine Scale Sets
- Hybrid virtual machines connected with [Azure Arc](/azure/azure-arc/overview)


## Prerequisites

- [Log Analytics workspace](../logs/quick-create-workspace.md).
- See [Azure Monitor agent supported operating systems and environments](../agents/azure-monitor-agent-supported-operating-systems.md) to verify that your operating system is supported by Azure Monitor agent. See [Dependency Agent requirements](./vminsights-dependency-agent-maintenance.
- See [Manage the Azure Monitor agent](../agents/azure-monitor-agent-manage.md#prerequisites) for prerequisites related to Azure Monitor agent.
- To enable network isolation for Azure Monitor Agent, see [Enable network isolation for Azure Monitor Agent by using Private Link](../agents/azure-monitor-agent-private-link.md).

## View monitored and unmonitored machines

To see which virtual machines in your directory are monitored using VM insights:

1. From the **Monitor** menu in the Azure portal, select **Virtual Machines** > **Overview**. 

    The **Overview** page lists all of the virtual machines and Virtual Machine Scale Sets in the selected subscriptions. 

1. Select the **Monitored** tab for the list of machines that have VM insights enabled.
    
1. Select the **Not monitored** tab for the list of machines that don't have VM insights enabled. 

    The **Not monitored** tab includes all machines that don't have VM insights enabled, even if the machines have Azure Monitor Agent or Log Analytics agent installed. If a virtual machine has the Log Analytics agent installed but not the Dependency agent, it will be listed as not monitored. In this case, Azure Monitor Agent will be started without being given the option for the Log Analytics agent.

## Enable VM insights
> [!NOTE]
> As part of the Azure Monitor Agent installation process, Azure assigns a [system-assigned managed identity](/azure/app-service/overview-managed-identity?tabs=portal%2chttp#add-a-system-assigned-identity) to the machine if such an identity doesn't already exist.

To enable VM insights on an unmonitored virtual machine or Virtual Machine Scale Set using Azure Monitor Agent:

1. From the **Monitor** menu in the Azure portal, select **Virtual Machines** > **Not Monitored**. 
 
1. Select **Enable** next to any machine that you want to enable. If a machine is currently not running, you must start it to enable it.

    :::image type="content" source="media/vminsights-enable-portal/enable-unmonitored.png" lightbox="media/vminsights-enable-portal/enable-unmonitored.png" alt-text="Screenshot with unmonitored machines in V M insights.":::

1. On the **Insights Onboarding** page, select **Enable**. 
 
1. On the **Monitoring configuration** page, select **Azure Monitor agent** and select a [data collection rule](vminsights-enable-overview.md#vm-insights-data-collection-rule) from the **Data collection rule** dropdown. 
![Screenshot of VM Insights Monitoring Configuration Page.](media/vminsights-enable-portal/vm-insights-monitoring-configuration.png)

1.  The **Data collection rule** dropdown lists only rules configured for VM insights. If a data collection rule hasn't already been created for VM insights, Azure Monitor creates a rule with: 

    - **Guest performance** enabled.
    - **Processes and dependencies** disabled.
   1.  Select **Create new** to create a new data collection rule. This lets you select a workspace and specify whether to collect processes and dependencies using the [VM insights Map feature](vminsights-maps.md).

       :::image type="content" source="media/vminsights-enable-portal/create-data-collection-rule.png" lightbox="media/vminsights-enable-portal/create-data-collection-rule.png" alt-text="Screenshot showing screen for creating new data collection rule.":::

       > [!NOTE]
       > If you select a data collection rule with Map enabled and your virtual machine is not [supported by the Dependency Agent](../vm/vminsights-dependency-agent-maintenance.md), Dependency Agent will be installed and  will run in degraded mode.

1. Select **Configure** to start the configuration process. It takes several minutes to install the agent and start collecting data. You'll receive status messages as the configuration is performed.
 
1. If you use a manual upgrade model for your Virtual Machine Scale Set, upgrade the instances to complete the setup. You can start the upgrades from the **Instances** page, in the **Settings** section.



## Next steps

* See [Use VM insights Map](vminsights-maps.md) to view discovered application dependencies. 
* See [View Azure VM performance](vminsights-performance.md) to identify bottlenecks, overall utilization, and your VM's performance.

