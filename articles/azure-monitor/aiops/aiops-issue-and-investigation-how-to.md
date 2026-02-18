---
title:  Use Azure Monitor issues and investigations (preview)
description: This article guides you through getting started with Azure Monitor issues and investigations. It shows how to trigger the observability agent to investigate issues, identify resource problems, explain why an alert fired, and provide next steps to mitigate and resolve problems with Azure resources.
ms.topic: how-to
ms.servce: azure-monitor
ms.reviewer: enauerman, yalavi
ms.date: 02/18/2026
---

# Use Azure Monitor issues and investigations (preview)

This article guides you through getting started with Azure Monitor issues and investigations. It shows how to trigger the [observability agent](observability-agent-overview.md) to investigate issues, identify resource problems, explain why an alert fired, and provide next steps to mitigate and resolve problems with Azure resources.

## Prerequisites

- Read the [Azure Monitor issues and investigations (preview) overview](aiops-issue-and-investigation-overview.md).
- Learn about the [Azure Copilot observability agent](observability-agent-overview.md).
- Learn about the [responsible use](observability-agent-responsible-use.md) of Azure Monitor investigations.
- Be sure that the subscription containing the investigated resource is associated with an Azure Monitor Workspace (AMW).
- Be sure that you or the person investigating has either the *Contributor*, *Monitoring Contributor*, or *Issue Contributor* role on the AMW you're investigating. For more information about role management, see [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal).

### Associate an AMW in the Azure portal
> [!NOTE]
> This setup is required once for each subscription you want to investigate. A user with the Contributor role on the subscription should perform this setup.

Associating a subscription with an Azure Monitor Workspace is required to create issues and run observability agent investigations:

1. If the alert's target resource subscription isn't already linked to an AMW, you see a message indicating that an Azure Monitor Workspace is required. The **Select an Azure Monitor workspace** screen appears.
1. Select an existing Azure Monitor Workspace or create a new one as needed.
1. After confirming your selection, the Issue page reloads and the observability agent automatically starts investigating.

### Associate an AMW via REST API

You can create, update, view, and delete an AMW association to a subscription using the following REST API commands.

#### Create or update an association

```
PUT https://management.azure.com/subscriptions/<subscription_id>/providers/microsoft.monitor/settings/default?api-version=2025-06-03-preview
Host: management.azure.com
Content-Type: application/json
Authorization: Bearer <bearerToken>

{
  "properties": {
    "defaultAzureMonitorWorkspace": "<amw_id>"
  }
}

```

#### View an association

```
GET https://management.azure.com/subscriptions/<subscription_id>/providers/microsoft.monitor/settings/default?api-version=2025-06-03-preview
Host: management.azure.com
Authorization: Bearer <bearerToken>
```

#### Delete an association

```
DELETE https://management.azure.com/subscriptions/<subscription_id>/providers/microsoft.monitor/settings/default?api-version=2025-06-03-preview
Host: management.azure.com
Authorization: Bearer <bearerToken>
```

## Ways to start an observability agent investigation on an alert

There are two ways to start an observability agent investigation on an alert:

### Start an investigation in the Azure portal

1. From the home page in the [Azure portal](https://portal.azure.com/), select **Monitor** \> **Alerts**.
1. From the **Alerts** page, select the alert that you want to investigate.
1. In the alert details pane, select **Investigate (preview)**.  
    :::image type="content" source="media/issue-investigation-how-to/alert-start-investigation.png" alt-text="Screenshot of alerts screen with investigate an alert link." lightbox="media/issue-investigation-how-to/alert-start-investigation.png" :::
1. On the Investigation page, review the information from the observability agent. Interact in chat as needed, then select **Start investigation**.
1. On the Investigation details page, you can interact with the observability agent in the chat pane, and review the findings in the findings pane. When you're ready to create an issue, select **Create Issue**.  
    :::image type="content" source="media/issue-investigation-how-to/investigation-details-page.png" alt-text="Screenshot of investigation page with chat pane and findings pane." lightbox="media/issue-investigation-how-to/investigation-details-page.png" :::
1.	In the Create issue box:
    1. Keep or replace the **Issue name**.
    1. Select or keep the **Issue severity**.
    1. Select or keep the Impact time.
    1. Optionally, change the **Azure Monitor Workspace** name where the issue data gets stored. If you have more than one workspace associated with the subscription, select the workspace that you want to use for this issue.
    1. Select the **I understand** box, then select **Create**.  
        :::image type="content" source="media/issue-investigation-how-to/create-issue-box.png" alt-text="Screenshot of create issue box with issue name, severity, impact time, and workspace selection options." lightbox="media/issue-investigation-how-to/create-issue-box.png" :::
1. The Issue details page opens on the Overview tab. The observability agent begins investigating, and the findings are displayed in the Investigation tab as they come in.
1. The issue is also listed on the Issues (preview) page. There you can select it to return to the details page and review the findings, change issue parameters, and share a link to the issue. For next steps, see the following sections.

### Start an investigation from an alert email notification

Alternatively, you can select **Investigate** from the email notification about an alert. An issue is created, and the observability agent begins investigating.

When the observability agent completes its investigation, a set of findings is displayed. For next steps, see the [Work with investigation findings](#work-with-investigation-findings) section of this article.

## Change the parameters of an issue

You can change the parameters of an issue using the dropdowns on the Overview tab of the issue page.

- **Severity** - The severity of an issue can be verbose, informational, error, warning or critical.
- **Status** - The status of an issue can be New, In-Progress, Mitigated, Resolved, Closed, Canceled or On-Hold.
- **Impact time** - You can change the impact time of the issue. Changing the impact time automatically initiates a new observability agent investigation using the updated time.

## Share a link to the issue

You can share a link to the issue by selecting **Copy link**. The link to the issue is copied to your clipboard. Make sure that permissions to view the issue are given to the recipients.

## View the issue background

The issue background provides information about the alerts associated with the issue. Select **Issue background**.

## Work with investigation findings

The observability agent presents findings based on the data it analyzed. To review the findings:

1. Select the **Investigation** tab of the issue page.
1. Select the finding. Every finding has an observability agent summary.
1. Read the **observability agent summary**. The summary includes a *What happened* section, a *Possible cause* section and a *What can be done next* section.
1. Select the **See cause + next steps** button to see the full summary.
1. Select **Click to expand** to view more details about the data presented in the Evidence for summary section of the investigation. To understand the evidence types used in an investigation, see [Evidence types](link to overview goes here) in the Issues and investigation overview article.

## Scope the investigation

### Change the impact time of the investigation

1. Select the **Overview** tab.
1. Select **impact time** and adjust it. Changing the time automatically triggers the observability agent to start a new investigation.

### Change the resources included in the investigation

1. Select the **Resources** tab.
1. Select **Edit resources**.
1. Select the other resources you want the observability agent to include in the investigation. A new investigation begins.

## Related content

- [Azure Copilot observability agent overview](observability-agent-overview.md)
- [Azure Monitor issues and investigations (preview) overview](aiops-issue-and-investigation-overview.md)
- [Azure Copilot observability agent responsible use](observability-agent-responsible-use.md)
- [Azure Copilot observability agent troubleshooting](observability-agent-troubleshooting.md)
