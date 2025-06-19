---
title: Migrate to Azure Monitor agent in VM Insights
description: Learn how to migrate from Log Analytics agent to Azure Monitor agent for VM insights.
ms.topic: upgrade-and-migration-article
ms.reviewer: xpathak
ms.date: 10/03/2024
ms.custom: references_regions

---

# Migrate to Azure Monitor Agent from Log Analytics agent in VM Insights
This article describes how to migrate to Azure Monitor agent for machines that you previously onboarded to VM insights using Log Analytics agent. Log Analytics agent for Azure Monitor was retired on August 31, 2024 and replaced with Azure Monitor agent.

- Get full details about the Azure Monitor agent from [Azure Monitor Agent overview](../agents/azure-monitor-agent-overview.md).
- Get additional migration details including the advantages of the new agent at [Migrate to Azure Monitor Agent from Log Analytics agent](../agents/azure-monitor-agent-migration.md).

## Differences between agents

Notable differences between using VM insights with the Azure Monitor agent and the Log Analytics agent include the following:

- Azure Monitor agent requires [Data Collection Rules (DCRs)](../essentials/data-collection-rule-overview.md) to specify which data to collect and how it should be processed. This DCR is either created or downloaded as part of the process of enabling VM insights.
- Dependency agent is no longer a requirement for VM insights. It's only required if you choose the option to collect processes and dependencies using the [VM insights Map feature](vminsights-maps.md). If you don't choose this option then Dependency agent isn't installed.

## Prerequisites

- See [Prerequisites](./vminsights-enable.md?#prerequisites) for prerequisites for enabling VM insights using the Azure Monitor agent.

## Data collection rules
Azure Monitor agent requires [Data Collection Rules (DCRs)](../essentials/data-collection-rule-overview.md) to specify which data to collect and how it should be processed. If you use the Azure portal to migrate VM insights, a DCR will be created for you. If you use other methods to enable VM insights, then you first need to create a DCR either by enabling a machine with the Azure portal or by downloading and installing the [VM insights DCR templates](./vminsights-enable-resource-manager.md#create-data-collection-rule-dcr).

## Enable Azure Monitor agent
Enable the Azure Monitor agent using any of the [available methods](./vminsights-enable-overview.md) while the Log Analytics agent is still installed. The two agents can coexist on the same machine. Ensure that the Azure Monitor agent is configured properly and is collecting data before removing the Log Analytics agent.

## Remove Log Analytics agent

> [!WARNING]
> Collecting duplicate data from a single machine with both the Azure Monitor agent and Log Analytics agent can result in:
> - Additional cost of ingestion duplicate data to the Log Analytics workspace.
> - The map feature of VM insights may be inaccurate since it does not check for duplicate data.

Once you've verified that the Azure Monitor agent has been enabled, remove the Log Analytics agent from the machine to prevent duplicate data collection. See [MMA/OMS Discovery and Removal Utility](../agents/azure-monitor-agent-mma-removal-tool.md) for details on the tool for removing multiple agents.

## Migrate with Azure portal
Use the following procedure to enable VM insights using the Azure Monitor agent on a machine that was previously enabled using Log Analytics agent. This method creates the required DCR or lets you select an existing one. It doesn't remove the Log Analytics agent from the machine though, so you still must perform this task after enabling the machine.

1. From the **Monitor** menu in the Azure portal, select **Virtual Machines** > **Overview** > **Monitored**.
 
1. Select **Configure using Azure Monitor agent** next to any machine that you want to enable. If a machine is currently running, you must start it to enable it.

    :::image type="content" source="media/vminsights-enable-portal/add-azure-monitor-agent.png" lightbox="media/vminsights-enable-portal/add-azure-monitor-agent.png" alt-text="Screenshot showing monitoring configuration to Azure Monitor agent to monitored machine.":::

1. On the **Monitoring configuration** page, select **Azure Monitor agent** and select a rule from the **Data collection rule** dropdown. 

    :::image type="content" source="media/vminsights-enable-portal/enable-monitored-configure-azure-monitor-agent.png" lightbox="media/vminsights-enable-portal/enable-monitored-configure-azure-monitor-agent.png" alt-text="Screenshot of VM Insights Agent Configuration Page.":::


2. The **Data collection rule** dropdown lists only rules configured for VM insights. If a data collection rule hasn't already been created for VM insights, Azure Monitor creates a rule with: 

   - **Guest performance** enabled.
   - **Processes and dependencies** enabled for backward compatibility with the Log Analytics agent.
   1.  Select **Create new** to create a new data collection rule. This lets you select a workspace and specify whether to collect processes and dependencies using the [VM insights Map feature](vminsights-maps.md).

       > [!NOTE]
       > Selecting a data collection rule that does not use the Map feature does not uninstall Dependency Agent from the machine. If you do not need the Map feature, [uninstall Dependency Agent manually](../vm/vminsights-dependency-agent-maintenance.md#uninstall-dependency-agent).
   2.  With both agents installed, Azure Monitor displays a warning that you may be collecting duplicate data.

       :::image type="content" source="media/vminsights-enable-portal/both-agents-installed.png" lightbox="media/vminsights-enable-portal/both-agents-installed.png" alt-text="Screenshot showing warning message for both agents installed.":::

