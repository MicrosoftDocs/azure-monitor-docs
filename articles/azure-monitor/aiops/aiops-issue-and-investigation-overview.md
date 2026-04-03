---
title: Azure Monitor issues (preview)
description: Learn how Azure Monitor issues help you manage and resolve operational problems by consolidating observability data, investigations, and alerts in one workflow.
ms.topic: concept-article
ms.service: azure-monitor
ms.collection: ce-skilling-ai-copilot
ms.reviewer: enauerman, ronitauber
ms.date: 04/03/2026
# Customer intent: As an Azure Monitor user, I want to understand what Azure Monitor issues are, how they relate to investigations, and how to use them to retain troubleshooting insights over time.
---

# Azure Monitor issues (preview)

An issue helps your team manage and resolve operational problems by bringing together all relevant observability data into a single, structured workflow. It organizes the troubleshooting process, emphasizes the most important signals, and enables more focused investigation and action.

Issues combine AI-powered investigations from the Azure Copilot observability agent, correlated alerts, and enriched observability data to ensure clarity and alignment throughout the resolution process.

:::image type="content" source="media/issue-investigation-overview/issue-investigation-tab.png" alt-text="Screenshot of an Azure Monitor issue showing the Investigation tab with findings and supporting data." lightbox="media/issue-investigation-overview/issue-investigation-tab.png":::

## Create issues

Create an issue when you want to persist the results of an investigation. Each issue is saved under an Azure Monitor Workspace (AMW).

You need the *Contributor*, *Monitoring Contributor*, or *Issue Contributor* role on the Azure Monitor Workspace to create an issue. For more information about role management, see [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal).

## View issues

You can view a list of issues in the following locations:

- **Azure Monitor** — Shows issues across all Azure Monitor Workspaces (AMWs) under the selected subscriptions.
- **Azure Monitor Workspace** — Shows issues that are stored within a specific AMW.

## Azure Monitor Workspace as an issue container

Azure Monitor Workspaces (AMWs) act as containers for issues.

You can configure an AMW as the default container for all issues in a subscription. When you set a default AMW, the investigation process saves issues in the same workspace when alerts fire on resources in that subscription. Saving them in the same workspace helps ensure that all related issues are stored and managed in a consistent location.

:::image type="content" source="media/issue-investigation-overview/issue-details.png" alt-text="Screenshot of Azure Monitor issue overview with summary, supporting data, and related alerts." lightbox="media/issue-investigation-overview/issue-details.png":::

## Supported regions

Azure Monitor issues are currently available in the following Azure regions:

:::row:::
    :::column:::
        - Australia Central
        - Australia East
        - Australia Southeast
        - Brazil South
        - Canada Central
        - Canada East
        - Central India
        - Central US
        - Chile Central
        - East Asia
        - East US
    :::column-end:::
    :::column:::
        - East US 2
        - France Central
        - Germany West Central
        - Indonesia Central
        - Israel Central
        - Italy North
        - Japan East
        - Japan West
        - Korea Central
        - Korea South
        - Malaysia West
    :::column-end:::
    :::column:::
        - Mexico Central
        - New Zealand North
        - North Central US
        - North Europe
        - Norway East
        - Poland Central
        - South Africa North
        - South Central US
        - South India
        - Southeast Asia
        - Spain Central
    :::column-end:::
    :::column:::
        - Sweden Central
        - Sweden South
        - Switzerland North
        - UAE North
        - UK South
        - UK West
        - West Central US
        - West Europe
        - West US
        - West US 2
        - West US 3
    :::column-end:::
:::row-end:::

## Related content

- [Azure Copilot observability agent](observability-agent-overview.md)
- [Use Azure Monitor issues](aiops-issue-and-investigation-how-to.md)
- [Azure Copilot observability agent responsible use](observability-agent-responsible-use.md)
- [Azure Copilot observability agent troubleshooting](observability-agent-troubleshooting.md)
