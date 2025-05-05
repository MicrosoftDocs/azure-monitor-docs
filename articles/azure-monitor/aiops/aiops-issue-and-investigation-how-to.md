---
title:  Use Azure Monitor issue and investigation (preview)
description: This article shows you how to use Azure Monitor issue and investigation to trigger an investigation to identify resource issues, and to explain why an alert was fired, and provide next steps to mitigate and resolve problems with Azure resources.
ms.topic: conceptual
ms.servce: azure-monitor
ms.reviewer: enauerman
ms.date: 05/05/2025
---

# Use Azure Monitor issue and investigation (preview)

This article shows you how to use Azure Monitor issues and investigations (preview) to trigger an investigation to identify resource issues, and to explain why an alert was fired, and provide next steps to mitigate and resolve problems with Azure resources.

> [!NOTE]
> For preview, the only alert supported is an Application Insights resource alert.

## Prerequisites

- Read the [Azure Monitor issue and investigation (preview) overview](aiops-issue-and-investigation-overview.md).
- Learn about the [responsible use](aiops-issue-and-investigation-responsible-use.md) of Azure Monitor investigation.
- Assign either the *Contributor*, *Monitoring Contributor, or Issue Contributor* role to the resource you’re investigating.
- Trigger an alert.

## Ways to start an investigation on an alert

There are two ways to start an investigation on an alert:

1.  From the home page in the Azure portal:
    1.  From the home page in the [Azure portal](https://portal.azure.com/), select **Monitor** \> **Alerts**.
    2.  From the **Alerts** page, select the alert that you want to investigate.
    3.  In the alert details pane, select **Investigate (preview)**.
2.  From the alert email notification: Alternatively, you can select **Investigate (preview)** from the email notification about an alert. An issue is created, and the investigation begins.

When the investigation is complete, a set of findings is displayed. For next steps, see the [Working with investigations](#work-with-investigation-findings) section of this article.

## Change the settings of an issue

You can change the settings of an issue using the dropdowns on the overview tab of the issue page.

- **Severity.** The severity of an issue can be verbose, informational, error, warning or critical.
- **Status.** The status of an issue can be New, In-Progress, Mitigated, Resolved, Closed, Canceled or On-Hold.
- **Impact time.** You can change the impact time of the issue. Changing the impact time automatically initiates a new investigation using the updated time.

## Share a link to the issue

You can share a link to the issue by selecting Share link. The link to the issue is copied to your clipboard. Make sure that permissions for viewing the issue are given to the recipients.

## View the issue background

The issue background provides information about the alert associated with the issue. Select Issue background.

## Work with investigation findings

An investigation will present findings based on the evidence it analyzed.

1. Select the **Investigation tab** of the issue page.
1. Select the finding. Every finding has an AI summary.
1. Read the **AI summary**. The AI summary includes a *What happened* section and 1. *What can be done next* section.
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

- [Azure Monitor issue and investigation (preview) overview](aiops-issue-and-investigation-overview.md)
- [Azure Monitor issue and investigation (preview) responsible use](aiops-issue-and-investigation-responsible-use.md)
