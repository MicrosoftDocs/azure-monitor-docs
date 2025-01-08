---
title: Enable network isolation for Azure Monitor Agent by using Private Link
description: Enable network isolation for Azure Monitor Agent.
ms.topic: conceptual
ms.date: 11/14/2024
ms.custom: references_region
ms.reviewer: jeffwo

---

# Enable network isolation for Azure Monitor Agent by using Private Link

By default, Azure Monitor Agent connects to a public endpoint to connect to your Azure Monitor environment. This article explains how to enable network isolation for your agents by using [Azure Private Link](/azure/private-link/private-link-overview).

## Prerequisites

- A [data collection rule](../essentials/data-collection-rule-create-edit.md), which defines the data Azure Monitor Agent collects and the destination to which the agent sends data.

## Create a data collection endpoint (DCE)

[Create a DCE](../essentials/data-collection-endpoint-overview.md#create-a-data-collection-endpoint) for each of your regions for agents to connect to instead of using the public endpoint. An agent can only connect to a data collection endpoint in the same region. If you have agents in multiple regions, create a data collection endpoint in each one.

## Configure private link

[Configure your private link](../logs/private-link-configure.md) to connect your DCE to a set of Azure Monitor resources that define the boundaries of your monitoring network. This set is called an Azure Monitor Private Link Scope.

## Add DCEs to Azure Monitor Private Link Scope (AMPLS)

[Add the DCEs to your AMPLS](../logs/private-link-configure.md#connect-resources-to-the-ampls) resource. This process adds the data collection endpoints to your private DNS zone (see [how to validate](../logs/private-link-configure.md#validate-communication-over-ampls)) and allows communication via private links. You can do this task from the AMPLS resource or on an existing data collection endpoint resource's **Network isolation** tab.

> [!IMPORTANT]
> Other Azure Monitor resources like the Log Analytics workspaces and data collection endpoint (DCE) configured in your data collection rules that you want to send data to must be part of this same AMPLS resource.

:::image type="content" source="media/azure-monitor-agent-dce/data-collection-endpoint-network-isolation.png" lightbox="media/azure-monitor-agent-dce/data-collection-endpoint-network-isolation.png" alt-text="Screenshot that shows configuring data collection endpoint network isolation." border="false":::

## Associate DCEs to target resources

Associate the data collection endpoints to the target resources by editing the data collection rule in the Azure portal. On the **Resources** tab, select **Enable Data Collection Endpoints**. Select a data collection endpoint for each virtual machine. See [Configure data collection for Azure Monitor Agent](../agents/azure-monitor-agent-data-collection.md).

:::image type="content" source="media/azure-monitor-agent-dce/data-collection-rule-virtual-machines-with-endpoint.png" lightbox="media/azure-monitor-agent-dce/data-collection-rule-virtual-machines-with-endpoint.png" alt-text="Screenshot that shows configuring data collection endpoints for an agent." border="false":::

## Related content

- Learn more about [Best practices for monitoring virtual machines in Azure Monitor](../best-practices-vm.md).
