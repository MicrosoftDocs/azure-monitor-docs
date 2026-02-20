---
title: Azure Monitor issues (preview)
description: Learn how Azure Monitor issues provide persistent context for troubleshooting investigations and help you analyze and retain troubleshooting data.
ms.topic: concept-article
ms.service: azure-monitor
ms.collection: ce-skilling-ai-copilot
ms.reviewer: enauerman, ronitauber
ms.date: 02/20/2026
# Customer intent: As an Azure Monitor user, I want to understand what Azure Monitor issues are, how they relate to investigations, and how to use them to retain troubleshooting insights over time.
---

# Azure Monitor issues (preview)

Azure Monitor issue is an AIOps capability that helps you analyze and troubleshoot problems detected by Azure Monitor alerts. This article describes the capabilities available in issues, and how you use them to analyze and retain troubleshooting insights.

## Issues and investigations concepts

The observability agent provides two main concepts for analyzing and retaining troubleshooting insights: investigations and issues.

An issue provides a persistent context for investigation results and related troubleshooting data. Use issues to retain investigation results, supporting data, and related alerts over time.

### Investigation findings saved in an issue

When you create an issue, the observability agent saves the findings (investigation data). The findings appear in the issue's Investigation tab. This data includes:

#### What happened

The **What happened** section is a summary that states when the incident occurred, the primary symptom (errors, latency, or failures), and the affected component with headline counts or severity. A compact chart under Supporting data shows the primary signal. The chart has a caption describing what the chart shows.

#### Analysis

The **Analysis** section summarizes the investigation findings with concise bullet points that link observed telemetry to likely causes, showing patterns (spikes, correlated dependency failures, exception types) and counts. It also notes important negatives (what was checked and found normal) and might include a focused visual to illustrate correlation or distribution.

#### What can be done next

The **What can be done next** area lists concise, prioritized, and actionable steps (investigations, mitigations, or alerts) that engineers should take to validate, remediate, or monitor the issue.

#### Summary

The **Summary** section provides a concise conclusion consisting of the confirmed root cause or the primary finding, the affected scope, and the key supporting evidence (timestamps, counts, exception types). It ends with immediate, prioritized next steps or mitigations for you to consider. It might also include a short statement of remaining unknowns if any.

#### Supporting data

The **Supporting data** section presents raw telemetry excerpts, exact Kusto queries, counts, and representative `operation_Id` samples. Occasionally, it might also show targeted charts that substantiate the analysis.

## Issue capabilities

Issues provide persistence and context for troubleshooting efforts. When you save investigation results as an issue, the issue includes:

- An overview that summarizes the latest investigation results.
- Persisted investigations and supporting data.
- Related alerts and affected resources.
- Configurable properties such as severity, status, and impact time.

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
