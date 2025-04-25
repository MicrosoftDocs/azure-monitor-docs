---
title: Azure Monitor issue and investigation (preview)
description: This article explains what Azure Monitor issue and investigation is and how it is used to triage and mitigate problems with an Azure resource.
ms.topic: conceptual
ms.date: 04/25/2025
ms.servce: azure-monitor
---
<!-- goodbye -->
# Azure Monitor issue and investigation (preview)

This article explains what Azure Monitor issue and investigation is and how it is used to triage and mitigate problems with an Azure resource.

## What is Azure Monitor issue and investigation?

Azure Monitor issue and investigation is an AIOPs feature of Azure Monitor that can be triggered by an Azure Monitor alert.

> [!NOTE:]
> For preview, the only alert supported is an Application Insights resource alert.

## What is an issue?

An issue contains all observability related data and processes for troubleshooting a service health degradation. It allows for keeping track of the mitigation of problems with resources. It can be shared and used by multiple people.

An issue presents an overview, the investigation, details about the alerts, and the resources involved.

You can set the severity, status and impact time of an issue.

## What is an investigation?

An investigation is an analysis of a set of findings within the context of an issue. The analysis uses AI-based triage and diagnostic processes.

### Findings

Findings identify anomalous behavior that could explain an issue. They summarize the analysis of multiple anomalies (e.g., 'VM performance is low due to possible memory leak’) based on relevant signals (metrics, logs, etc.) and may suggest further investigation steps and potential mitigations.​

A finding contains a summary that can include:

-   A hypotheses
-   Suggested actions to take
-   A transaction pattern with dependency mapping
-   A possible root cause

Every finding presents supporting evidence such as anomalies, insights, and data you define such as through a query.

### Evidence

Evidence is the data supporting the finding, such as anomalies, diagnostics insights, health data, resource changes, and related resources, related alerts and so on.​

## Configurable scope

Azure Monitor investigation makes suggestions for which resources to analyze based on the scope of the investigation. The default scope of an investigation includes all metrics of the resource. You can change the scope to include up to five resources. See Scope the investigation in [Use issue and investigation](link to anchor in how to).

## Issue and investigation initial workflow example

1.  An alert email from Azure Monitor is received.
2.  A click on the investigate button in the email creates an issue and starts an investigation. The issue page on the Azure portal opens in your browser.
3.  On the Issue page, you are presented with:
    1.  The issue overview where the findings are presented as well as the evidence.
    2.  The investigation which contains the AI analysis summary, suggested actions to take and the evidence used for the analysis.
    3.  Alerts associated with the issue
    4.  Resources associated with the issue.

        ![A screenshot of the issue page in the Azure portal](media/dce6122928de06e8b346a1d87914e86b.png)

4.  Every finding in an investigation presents more details on the cause and present next steps to choose from.

    ![A screenshot of the investigation tab of the issue page in the Azure portal.](media/c21e9b9d0d9afc8536419f56cf170b1f.png)

## Application Insights alerts investigation

For preview, issues and investigation supports Application Insights alerts. The following is a description of an Application Insights alert investigation.

The investigation scans the application data for anomalies. The top three failure events, dependencies, requests, and exceptions are analyzed. For each event, the system generates:

-   **An explanation**: What happened that generated the failure.
-   **Transaction examples**: A list of example transactions where the specific failure event exists. Selecting the example displays the end-to-end transaction in Application Insights.
-   **Exceptions:** If there are specific exception problem IDs correlated with the failure, they're displayed with a count of appearances in the logs. The problem IDs are explained in natural language and an example is provided.
-   **Transaction patterns:** Specific transaction patterns for the failure are displayed. The display helps to explain the issue and shows the root cause. If there are multiple transaction patterns, no pattern is displayed.
-   **Trace message patterns:** If there are specific trace message patterns that correlate with failure, they're displayed with the count of appearances in the logs. The patterns are explained in natural language and an example is provided.

### Application Insights smart scoping

Azure Monitor investigation also offers smart scoping for *Application Insights* resources. It automatically identifies potentially related resources by analyzing dependencies in Application Insights and runs analysis on them as well.

## Next steps

-   [Use Azure Monitor issue (preview) and investigation](aiops-issue-and-investigation-how-to.md)
