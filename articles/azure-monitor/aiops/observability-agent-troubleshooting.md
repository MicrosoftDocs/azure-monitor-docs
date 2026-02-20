---
title: Troubleshooting guide - Azure Copilot observability agent (preview)
description: This article provides troubleshooting guidance for Azure Copilot observability agent. The article explains the causes of these problems and offers steps to address them. It also includes links to related Azure Monitor documentation for further reference.
ms.topic: troubleshooting-general
ms.servce: azure-monitor
ms.reviewer: ronitauber
ms.date: 02/19/2026
---

# Troubleshooting guide: Azure Copilot observability agent (preview)

This article provides troubleshooting guidance for Azure Monitor issues and investigations. It explains the causes of these problems and offers steps to address them. It also includes links to related Azure Monitor documentation for further reference.

## Lack of permissions to run observability agent investigations

You must have the *Issue Contributor, Monitoring Contributor, or Contributor* role assigned for the target resource.

If you don't have permission, you can't create an issue or run an observability agent investigation. Consult with your system administrator.

## Lack of associated Azure Monitor Workspace (AMW)

You must have an AMW associated to the subscription you're investigating. To create the association, consult with your system administrator. See [Associate an Azure Monitor Workspace with a subscription](aiops-issue-and-investigation-how-to.md#associate-an-amw-in-the-azure-portal).

## No findings

When you run an observability agent investigation, you might receive a *No findings* result. This result isn't a problem – it just means the observability agent didn't detect any anomalies in the metrics, logs, or other monitored data. Remember that this result doesn't necessarily indicate the absence of underlying problems, but rather that the current data doesn't reveal any obvious problems.

:::image type="content" source="media/troubleshooting-no-findings.png" alt-text="Screenshot of no findings message." lightbox="media/troubleshooting-no-findings.png":::

## OpenAI issue

The observability agent depends on OpenAI for the text generation to function correctly. Occasionally, OpenAI might experience problems. If you encounter a screen indicating a problem with OpenAI, try refreshing the page and running the observability agent investigation again from the beginning. In the meantime, you can still review the anomalies detected without the summary, which can help identify potential problems even if the summary functionality is unavailable.

## Related content

- [Azure Copilot observability agent overview](observability-agent-overview.md)
- [Azure Monitor issues and investigations (preview) overview](aiops-issue-and-investigation-overview.md)
- [Use Azure Monitor issues and investigations](aiops-issue-and-investigation-how-to.md)
- [Azure Copilot observability agent responsible use](observability-agent-responsible-use.md)
