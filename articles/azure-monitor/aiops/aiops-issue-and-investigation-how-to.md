---
title:  Use Azure Monitor issues and investigations (preview)
description: This article guides you through getting started with Azure Monitor issues and investigations. It shows how to trigger the observability agent to investigate issues and identify resource problems. It also explains why an alert fired and provides next steps to mitigate and resolve problems with Azure resources.
ms.topic: how-to
ms.service: azure-monitor
ms.collection: ce-skilling-ai-copilot
ms.reviewer: enauerman, yalavi
ms.date: 02/20/2026
---

# Use Azure Monitor issues and investigations (preview)

This article helps you get started with Azure Monitor issues and investigations. It shows how to trigger the [observability agent](observability-agent-overview.md) to investigate problems and identify resource issues. It also explains why an alert fired and provides next steps to mitigate and resolve problems with Azure resources.

## Prerequisites

- Read the [Azure Monitor issues and investigations (preview) overview](aiops-issue-and-investigation-overview.md).
- Learn about the [Azure Copilot observability agent](observability-agent-overview.md).
- Learn about the [responsible use](observability-agent-responsible-use.md) of Azure Monitor investigations.
- Ensure the subscription containing the investigated resource is associated with an Azure Monitor Workspace (AMW).
- Ensure you or the person investigating has either the *Contributor*, *Monitoring Contributor*, or *Issue Contributor* role on the AMW you're investigating. For more information about role management, see [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal).

### Associate an AMW in the Azure portal

> [!NOTE]
> You need to perform this setup once for each subscription you want to investigate. A user with the Contributor role on the subscription should perform this setup.

To create issues and run observability agent investigations, associate a subscription with an Azure Monitor Workspace:

1. If the alert's target resource subscription isn't already linked to an AMW, you see a message indicating that an Azure Monitor Workspace is required. The **Select an Azure Monitor workspace** screen appears.
1. Select an existing Azure Monitor Workspace or create a new one as needed.
1. After you confirm your selection, the **Issue** page reloads. The observability agent automatically starts an investigation.

### Associate an AMW through REST API

You can create, update, view, and delete an AMW association to a subscription by using the following REST API commands.

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

Use two methods to start an observability agent investigation on an alert:

### Start an investigation in the Azure portal

1. From the home page in the [Azure portal](https://portal.azure.com/), select **Monitor** > **Alerts**.
1. From the **Alerts** page, select the alert that you want to investigate.
1. In the alert details pane, select **Investigate (preview)**.  
    :::image type="content" source="media/issue-investigation-how-to/alert-start-investigation.png" alt-text="Screenshot of alerts screen with investigate an alert link." lightbox="media/issue-investigation-how-to/alert-start-investigation.png" :::
1. On the Investigation page, review the information from the observability agent. Interact in chat as needed, and then select **Start investigation**.
1. On the Investigation details page, you can interact with the observability agent in the chat pane, and review the findings in the findings pane. When you're ready to create an issue, select **Create Issue**.  
    :::image type="content" source="media/issue-investigation-how-to/investigation-details-page.png" alt-text="Screenshot of investigation page with chat pane and findings pane." lightbox="media/issue-investigation-how-to/investigation-details-page.png" :::
1.	In the Create issue box:
    1. Keep or replace the **Issue name**.
    1. Select or keep the **Issue severity**.
    1. Select or keep the **Impact time**.
    1. Optionally, change the **Azure Monitor Workspace** name where the issue data gets stored. If you have more than one workspace associated with the subscription, select the workspace that you want to use for this issue.
    1. Select the **I understand** box, and then select **Create**.  
        :::image type="content" source="media/issue-investigation-how-to/create-issue-box.png" alt-text="Screenshot of create issue box with issue name, severity, impact time, and workspace selection options." lightbox="media/issue-investigation-how-to/create-issue-box.png" :::
1. The **Issue details** page opens on the **Overview** tab. The observability agent begins investigating, and the findings are displayed in the **Investigation** tab as they come in.
1. The issue is also listed on the **Issues (preview)** page. There you can select it to return to the details page and review the findings, change issue parameters, and share a link to the issue. For next steps, see the following sections.

### Start an investigation from an alert email notification

Alternatively, you can select **Investigate** from the email notification about an alert. An issue is created, and the observability agent begins investigating.

When the observability agent completes its investigation, it displays a set of findings. For next steps, see the [Work with investigation findings](#work-with-investigation-findings) section of this article.

## Change the parameters of an issue

Change the parameters of an issue by using the dropdown lists on the **Overview** tab of the issue page.

- **Severity** - Set the severity of an issue to **Critical**, **Error**, **Warning**, **Informational**, or **Verbose**.
- **Status** - Set the status of an issue to **New**, **In Progress**, **Mitigated**, **Resolved**, **Closed**, **Canceled**, or **On-Hold**.
- **Impact time** - Change the impact time of the issue. Changing the impact time automatically initiates a new observability agent investigation by using the updated time.

## Share a link to the issue

Select **Copy link** to share a link to the issue. The link to the issue is copied to your clipboard. Make sure that recipients have permissions to view the issue.

## View the issue background

The issue background provides information about the alerts associated with the issue. Select **Issue background**.

## Work with investigation findings

The observability agent presents findings based on the data it analyzed. To review the findings:

1. On the **Issues (preview)** page, select an issue.
1. Select the **Investigation** tab.
1. Read the **What happened** section to quickly identify affected components and timestamps. The information can help you understand the scope of the issue.
1. Read the **Analysis** section to understand the likely cause of the issue, supported by evidence from the data.
1. Read the **What can be done next** section to see recommended next steps, such as mitigations, further investigations, or alerts to set up for monitoring.
1. Read the **Summary** section for a concise summary of the findings, including the likely cause, affected scope, key evidence, and recommended next steps.

For more information about issue findings, see [Investigation findings saved in an issue](aiops-issue-and-investigation-overview.md#investigation-findings-saved-in-an-issue).

## Scope the investigation

To adjust the scope of the investigation, use the information in the following sections.

### Change the impact time of the investigation

1. Select the **Overview** tab.
1. Select **Impact time** and adjust it. Changing the time automatically triggers the observability agent to start a new investigation.

### Change the resources included in the investigation

1. Select the **Resources** tab to view the resources included in the investigation.
1. Select **Edit resources**.
1. Select other resources that you want the observability agent to include in the investigation. A new investigation begins.

## Related content

- [Azure Copilot observability agent overview](observability-agent-overview.md)
- [Azure Monitor issues and investigations (preview) overview](aiops-issue-and-investigation-overview.md)
- [Azure Copilot observability agent responsible use](observability-agent-responsible-use.md)
- [Azure Copilot observability agent troubleshooting](observability-agent-troubleshooting.md)
