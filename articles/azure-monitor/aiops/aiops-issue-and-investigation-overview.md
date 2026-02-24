---
title: Azure Monitor issues (preview)
description: Learn how Azure Monitor issues provide persistent context for troubleshooting investigations and help you analyze and retain troubleshooting data.
ms.topic: concept-article
ms.service: azure-monitor
ms.collection: ce-skilling-ai-copilot
ms.reviewer: enauerman, ronitauber
ms.date: 02/24/2026
# Customer intent: As an Azure Monitor user, I want to understand what Azure Monitor issues are, how they relate to investigations, and how to use them to retain troubleshooting insights over time.
---

# Azure Monitor issues (preview)

An issue helps your team manage and resolve operational problems by bringing together all relevant observability data into a single, structured workflow. It organizes the troubleshooting process, emphasizes the most important signals, and enables more focused investigation and action.

Issues combine AI-powered investigations from the Azure Copilot observability agent, correlated alerts, and enriched observability data to ensure clarity and alignment throughout the resolution process.

## Create issues

Issues are created when you choose to persist the results of an investigation. Each issue is saved under an Azure Monitor Workspace (AMW).
Creating an issue requires the *Contributor*, *Monitoring Contributor*, or *Issue Contributor* role on the Azure Monitor Workspace. For more information about role management, see [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal).

## View issues

You can view a list of issues in the following locations:

- **Azure Monitor** - Shows issues across all AMWs under the selected subscriptions.
- **Azure Monitor Workspace** - Shows issues that are stored within a specific AMW.

## Azure Monitor Workspace as an issue container

Azure Monitor Workspaces act as the container for issues.

You can configure an AMW as the default container for all issues in a subscription. When a default AMW is set, issues created while investigating alerts fired on resources in that subscription are saved in the same workspace. This helps ensure that all related issues are stored and managed in a consistent location.

:::image type="content" source="media/issue-investigation-overview/issue-details.png" alt-text="Screenshot of Azure Monitor issue overview with summary, supporting data, and related alerts." lightbox="media/issue-investigation-overview/issue-details.png":::

## Initial workflow example for an issue and investigation

1. An alert triggers in Azure Monitor. You can access the alert from an alert notification, such as an email, or directly from the Azure portal.
1. You select **Investigate** to open a chat-based troubleshooting session with the observability agent.
1. You invoke investigation capabilities within the conversation to analyze the detected problem.
1. The observability agent analyzes telemetry data and produces analysis based on anomaly detection and data correlation.
1. After the investigation is complete, you can optionally create an issue by selecting **Create Issue**.
    - When you create an issue, you save and retain the investigation in the context of the issue.
    - When you don't create an issue, the system temporarily makes the investigation available and later deletes it.
1. When you create an issue, the **Issue** page provides:
    - An overview summarizing the investigation results and key supporting data.
    - Detailed analysis, including summaries, suggested actions, and supporting evidence.
    - More context such as related alerts and affected resources.

## Related content

- [Azure Copilot observability agent](observability-agent-overview.md)
- [Use Azure Monitor issues and investigations](aiops-issue-and-investigation-how-to.md)
- [Azure Copilot observability agent responsible use](observability-agent-responsible-use.md)
- [Azure Copilot observability agent troubleshooting](observability-agent-troubleshooting.md)
