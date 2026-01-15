---
title: Network Isolation for Azure Monitor Agent via Private Link
description: Learn how to enable network isolation for Azure Monitor Agent by using Azure Private Link.
ms.topic: how-to
ms.date: 11/14/2024
ms.custom: references_region
ms.reviewer: jeffwo

---

# Enable network isolation for Azure Monitor Agent by using Azure Private Link

By default, Azure Monitor Agent connects to a public endpoint to connect to your Azure Monitor environment. This article describes how to enable network isolation for your agents by using [Azure Private Link](/azure/private-link/private-link-overview).

## Prerequisites

* A [data collection rule (DCR)](../data-collection/data-collection-rule-create-edit.md), which defines the data Azure Monitor Agent collects and where the agent sends the data.

## Create a data collection endpoint

[Create a data collection endpoint (DCE)](../data-collection/data-collection-endpoint-overview.md#create-a-data-collection-endpoint) for each of your regions for agents to connect to instead of using the public endpoint. An agent can connect only to a DCE that's in the same region as the agent. If you have agents in multiple regions, create a DCE in each of the relevant regions.

## Configure a private link

[Configure your private link](../logs/private-link-configure.md) to connect your DCE to a set of Azure Monitor resources that define the boundaries of your monitoring network. This set is an instance of Azure Monitor Private Link Scope.

## Add DCEs to Azure Monitor Private Link Scope

[Add the DCEs to Azure Monitor Private Link Scope](../logs/private-link-configure.md#connect-resources-to-the-ampls) resource. This process adds the DCEs to your private Domain Name System (DNS) zone (see [how to validate](../logs/private-link-configure.md#validate-communication-over-ampls)) and allows communication via private links. You can do this task from the Azure Monitor Private Link Scope resource or on an existing DCE resource's **Network isolation** tab.

> [!IMPORTANT]
> Other Azure Monitor resources like Log Analytics workspaces and DCEs in your DCRs that you send data to must be included in this Azure Monitor Private Link Scope resource.

:::image type="content" source="media/azure-monitor-agent-dce/data-collection-endpoint-network-isolation.png" lightbox="media/azure-monitor-agent-dce/data-collection-endpoint-network-isolation.png" alt-text="Screenshot that shows configuring data collection endpoint network isolation.":::

## Associate DCEs to target resources

Associate the DCEs to the target resources by editing the DCR in the Azure portal. On the **Resources** tab, select **Enable Data Collection Endpoints**. Select a DCE for each virtual machine. For more information, see [Configure data collection for the Azure Monitor Agent](../vm/data-collection.md).

:::image type="content" source="media/azure-monitor-agent-dce/data-collection-rule-virtual-machines-with-endpoint.png" lightbox="media/azure-monitor-agent-dce/data-collection-rule-virtual-machines-with-endpoint.png" alt-text="Screenshot that shows configuring data collection endpoints for an agent.":::

## Related content

* Learn more about [best practices for monitoring virtual machines in Azure Monitor](../best-practices-vm.md).
