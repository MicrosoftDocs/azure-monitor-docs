---
title: Use Azure issue and investigation (preview)
description: This article shows you how to use Azure Monitor issue and investigation to trigger an investigation to identify resource issues, and to explain why an alert was fired, and provide next steps to mitigate and resolve problems with Azure resources.
ms.topic: how-to
ms.date: 04/25/2025
ms.servce: azure-monitor
---

# Use Azure Monitor issue and investigation (preview)

This article shows you how to use Azure Monitor issue and investigation to trigger an investigation to identify resource issues, and to explain why an alert was fired, and provide next steps to mitigate and resolve problems with Azure resources.

> [!NOTE:]
> For preview, the only alert supported is an Application Insights resource alert.

## Prerequisites

-   Read the [Azure Monitor issue and investigation (preview) overview](aiops-issue-and-investigation_overview.md).
-   Learn about the [responsible use](aiops-issue-and-investigation-responsible-use.md) of Azure Monitor investigation.
-   Assign either the *Contributor*, *Monitoring Contributor, or Issue Contributor* role to the resource you’re investigating.
-   Trigger an alert.

## Ways to start an investigation on an alert

1.  From the home page in the [Azure portal](https://portal.azure.com/), select **Monitor** \> **Alerts**.
2.  From the **Alerts** page, select the alert that you want to investigate.
3.  In the alert details pane, select **Investigate**.
4.  Alternatively, you can select **Investigate** from the email notification about an alert. An issue is created, and the investigation begins.
5.  When the investigation is complete, a summary of the incident is displayed with recommendations for how to mitigate the issue.

## Change the settings of an issue

You can change the settings of an issue using the dropdowns on the overview tab of the issue page.

-   **Severity.** The severity of an issue can be verbose, informational, error, warning or critical.
-   **Status.** The status of an issue can be New, In-Progress, Mitigated, Resolved, Closed, Canceled or On-Hold.
-   **Impact time.** You can change the impact time of the issue.

## Share a link to the issue

You can share a link to the issue by selecting Share link. The link to the issue is copied to your clipboard. Make sure that permissions for viewing the issue are given to the recipients.

## View the issue background

The issue background provides information about the alert associated with the issue. Select Issue background.

## Work with investigation findings

An investigation will present findings based on the evidence it analyzed.

1.  Select the **Investigation tab** of the issue page.
2.  Select an issue.
3.  Read the **AI summary**. The AI summary includes a *What happened* section and a *What can be done next* section.
4.  Select **Click to expand** for the anomalies presented in the Evidence for summary section of the investigation.
    1.  Select **Metric anomalies** to view all the metric anomalies included in the analysis. To see more details about the metrics, select **View in Metrics**.
    2.  Select **Application anomalies** to view anomalies related to the logs for application. Select **View in logs** to be taken to the Log analytics page.

## Scope the investigation

\<Instructions for scoping the investigation go here\>

## Related content

-   [Azure Monitor issue (preview) and investigation overview](aiops-issue-and-investigation-overview.md)
