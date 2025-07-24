---
title:  Use Azure Monitor issues and investigations (preview)
description: This article helps guide you through getting started with Azure Monitor issues and investigations. It includes how to trigger an investigation in order to identify resource issues, explain why an alert was fired, provide next steps to mitigate and resolve problems with Azure resources.
ms.topic: how-to
ms.servce: azure-monitor
ms.reviewer: enauerman
ms.date: 05/05/2025
---

# Use Azure Monitor issues and investigations (preview)

This article helps guide you through getting started with Azure Monitor issues and investigations. It includes how to trigger an investigation in order to identify resource issues, explain why an alert was fired, provide next steps to mitigate and resolve problems with Azure resources.

> [!NOTE]
> For preview, investigation only supports Application Insights resource alert. 

## Prerequisites

- Read the [Azure Monitor issues and investigations (preview) overview](aiops-issue-and-investigation-overview.md).
- Learn about the [responsible use](aiops-issue-and-investigation-responsible-use.md) of Azure Monitor investigations.
- Identify an alert fired on an Application Insights resource to investigate.
- Be sure that you or the person investigating has either the *Contributor*, *Monitoring Contributor, or Issue Contributor* role on the resource you’re investigating. For more information about role management, see [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal).

## Ways to start an investigation on an alert

There are two ways to start an investigation on an alert:

1.  From the home page in the Azure portal:
    1.  From the home page in the [Azure portal](https://portal.azure.com/), select **Monitor** \> **Alerts**.
    2.  From the **Alerts** page, select the alert that you want to investigate.
    3.  In the alert details pane, select **Investigate (preview)**.
    
    :::image type="content" source="media/investigate-an-alert.png" alt-text="Screenshot of alerts screen with investigate an alert link." lightbox="media/investigate-an-alert.png":::

1.  From the alert email notification: Alternatively, you can select **Investigate** from the email notification about an alert. An issue is created, and the investigation begins.

When the investigation is complete, a set of findings is displayed. For next steps, see the [Working with investigations](#work-with-investigation-findings) section of this article.

## Change the parameters of an issue

You can change the parameters of an issue using the dropdowns on the overview tab of the issue page.

- **Severity.** The severity of an issue can be verbose, informational, error, warning or critical.
- **Status.** The status of an issue can be New, In-Progress, Mitigated, Resolved, Closed, Canceled or On-Hold.
- **Impact time.** You can change the impact time of the issue. Changing the impact time automatically initiates a new investigation using the updated time.

## Share a link to the issue

You can share a link to the issue by selecting Share link. The link to the issue is copied to your clipboard. Make sure that permissions for viewing the issue are given to the recipients.

## View the issue background

The issue background provides information about the alerts associated with the issue. Select Issue background.

## Work with investigation findings

An investigation will present findings based on the evidence it analyzed. To investigate the findings:

1. Select the **Investigation tab** of the issue page.
1. Select the finding. Every finding has an AI summary.
1. Read the **AI summary**. The AI summary includes a *What happened* section, a *Possible cause* section and a *What can be done next* section.
1. Select the **See cause + next steps** button to see the full summary.
1. Select **Click to expand** to view more details about the data presented in the Evidence for summary section of the investigation. To understand the evidence types used in an investigation, see [Evidence types](link to overview goes here) in the Issues and investigation overview article.

## Scope the investigation

### Change the impact time of the investigation

1.  Select the **Overview** tab.
2.  Select **impact time** and adjust it. Changing the time of the investigation will automatically start a new investigation.

### Change the resources included in the investigation

1.  Select the **Resources** tab.
2.  Select **Edit resources**.
3.  Select the additional resources you want to include in the investigation. A new investigation will begin.

## Related content

- [Azure Monitor issues and investigations (preview) overview](aiops-issue-and-investigation-overview.md)
- [Azure Monitor issues and investigations (preview) responsible use](aiops-issue-and-investigation-responsible-use.md)
- [Azure Monitor issues and investigations (preview) troubleshooting](aiops-issue-and-investigation-troubleshooting.md)
