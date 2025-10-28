---
title: Troubleshooting guide - Azure Monitor Observability Agent (preview)
description: This article provides troubleshooting guidance for Azure Monitor Observability Agent. The article explains the causes of these problems and offers steps to address them. It also includes links to related Azure Monitor documentation for further reference.
ms.topic: troubleshooting-general
ms.servce: azure-monitor
ms.date: 09/04/2025
---

# Troubleshooting guide: Azure Monitor Observability Agent (preview)

This article provides troubleshooting guidance for Azure Monitor issues and investigations. The article explains the causes of these problems and offers steps to address them. It also includes links to related Azure Monitor documentation for further reference.

## Lack of permissions to run Observability Agent investigations

You must have the *Issue Contributor, Monitoring Contributor, or Contributor* role assigned for the target resource.

If you don't have permission, you can't create an issue or run an Observability Agent investigation, and you should consult with your system administrator.

## Lack of associated Azure Monitor Workspace (AMW)
You must have an AMW associated to the subscription you're investigating. To create the association, consult with your system administrator. See [Associate an Azure Monitor Workspace with a subscription](aiops-issue-and-investigation-how-to.md#associate-an-amw-in-the-azure-portal).

## No findings

When an Observability Agent investigation is run, you might receive a *No findings* result. This result isn't a problem – it just means Observability Agent didn't detect any anomalies in the metrics, logs, or other monitored data. It's important to remember that this result doesn't necessarily indicate the absence of underlying issues, but rather that the current data doesn't reveal any obvious problems.

:::image type="content" source="media/troubleshooting-no-findings.png" alt-text="Screenshot of no findings message." lightbox="media/troubleshooting-no-findings.png":::

## OpenAI issue

Observability Agent depends on OpenAI for the text generation to function correctly. Occasionally, OpenAI might experience problems. If you encounter a screen indicating a problem with OpenAI, try refreshing the page and running the Observability Agent investigation again from the beginning. In the meantime, you can still review the anomalies detected without the summary, which can help identify potential issues even if the summary functionality is unavailable.

## Related content

- [Azure Monitor Observability Agent overview](observability-agent-overview.md)
- [Azure Monitor issues and investigations (preview) overview](aiops-issue-and-investigation-overview.md)
- [Use Azure Monitor issues and investigations](aiops-issue-and-investigation-how-to.md)
- [Azure Monitor Observability Agent responsible use](observability-agent-responsible-use.md)
