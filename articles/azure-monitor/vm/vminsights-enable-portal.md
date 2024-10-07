---
title: Enable VM insights in the Azure portal
description: Learn how to enable VM insights on a single Azure virtual machine or Virtual Machine Scale Set using the Azure portal.
ms.topic: conceptual
author: guywi-ms
ms.author: guywild
ms.reviewer: xpathak
ms.date: 10/03/2024

---

# Enable VM insights using the Azure portal
This article describes how to enable [VM insights](./vminsights-overview.md) using the Azure portal.

> [!NOTE]
> Azure portal no longer supports enabling VM insights using the legacy Log Analytics agent. See [Migrate to Azure Monitor Agent from Log Analytics agent in VM Insights](./vminsights-migrate-agent.md) for information on migrating to the Azure Monitor agent.

## Supported machines

- Azure virtual machines
- Azure Virtual Machine Scale Sets
- Hybrid virtual machines connected with [Azure Arc](/azure/azure-arc/overview)


## Prerequisites

- [Log Analytics workspace](../logs/quick-create-workspace.md).
- See [Azure Monitor agent supported operating systems and environments](../agents/azure-monitor-agent-supported-operating-systems.md) to verify that your operating system is supported by Azure Monitor agent. 
- See [Dependency Agent requirements](./vminsights-dependency-agent-maintenance.md) to verify that your operating system is supported by Dependency agent. .
- See [Manage the Azure Monitor agent](../agents/azure-monitor-agent-manage.md#prerequisites) for prerequisites related to Azure Monitor agent.

## Enable VM insights
Use the following procedure to enable VM insights on an unmonitored virtual machine or Virtual Machine Scale Set.

> [!NOTE]
> As part of the Azure Monitor Agent installation process, Azure assigns a [system-assigned managed identity](/azure/app-service/overview-managed-identity?tabs=portal%2chttp#add-a-system-assigned-identity) to the machine if such an identity doesn't already exist.

1. From the **Monitor** menu in the Azure portal, select **Virtual Machines** > **Not Monitored**. This tab includes all machines that don't have VM insights enabled, even if the machines have Azure Monitor Agent or Log Analytics agent installed. If a virtual machine has the Log Analytics agent installed but not the Dependency agent, it will be listed as not monitored. 
 
1. Select **Enable** next to any machine that you want to enable. If a machine is currently not running, you must start it to enable it.

    :::image type="content" source="media/vminsights-enable-portal/enable-unmonitored.png" lightbox="media/vminsights-enable-portal/enable-unmonitored.png" alt-text="Screenshot with unmonitored machines in V M insights.":::

1. On the **Insights Onboarding** page, select **Enable**. 
 
2. On the **Monitoring configuration** page, select **Azure Monitor agent** and select a [DCR](vminsights-enable-overview.md#vm-insights-dcr) from the **Data collection rule** dropdown. Only rules configured for VM insights are listed. If a DCR hasn't already been created for VM insights, Azure Monitor creates one with the following settings.

    - **Guest performance** enabled.
    - **Processes and dependencies** disabled.
 
    :::image type="content" source="media/vminsights-enable-portal/enable-monitored-configure-azure-monitor-agent.png" lightbox="media/vminsights-enable-portal/enable-monitored-configure-azure-monitor-agent.png" alt-text="Screenshot of VM Insights Monitoring Configuration Page.":::
 
2.  Select **Create new** to create a new data collection rule. This lets you select a workspace and specify whether to collect processes and dependencies using the [VM insights Map feature](vminsights-maps.md).

    :::image type="content" source="media/vminsights-enable-portal/create-data-collection-rule.png" lightbox="media/vminsights-enable-portal/create-data-collection-rule.png" alt-text="Screenshot showing screen for creating new data collection rule.":::

    > [!NOTE]
    > If you select a DCR with Map enabled and your virtual machine is not [supported by the Dependency Agent](../vm/vminsights-dependency-agent-maintenance.md), Dependency Agent will be installed and  will run in degraded mode.

3. Select **Configure** to start the configuration process. It takes several minutes to install the agent and start collecting data. You'll receive status messages as the configuration is performed.
 
4. If you use a manual upgrade model for your Virtual Machine Scale Set, upgrade the instances to complete the setup. You can start the upgrades from the **Instances** page, in the **Settings** section.



## Next steps

* See [Use VM insights Map](vminsights-maps.md) to view discovered application dependencies. 
* See [View Azure VM performance](vminsights-performance.md) to identify bottlenecks, overall utilization, and your VM's performance.

