---
title: Troubleshooting guide - Azure Monitor issues and investigations (preview)
description: This article provides troubleshooting guidance for Azure Monitor issues and investigations. The article explains the causes of these problems and offers steps to address them. It also includes links to related Azure Monitor documentation for further reference.
ms.topic: troubleshooting-general
ms.servce: azure-monitor
ms.date: 05/08/2025
---

# Troubleshooting guide: Azure Monitor issues and investigations (preview)

This article provides troubleshooting guidance for Azure Monitor issues and investigations. The article explains the causes of these problems and offers steps to address them. It also includes links to related Azure Monitor documentation for further reference.

## Lack of permissions to run investigations

You must have the *Issue Contributor, Monitoring Contributor, or Contributor* role assigned for the target resource.

If you don't have permission, you won't be able to create an issue or run an investigation, and you should consult with your system administrator.

:::image type="content" source="media/diagnostics-and-troubleshooting-no-access.png" alt-text="Screenshot of no access." lightbox="media/diagnostics-and-troubleshooting-no-access.png":::

## Lack of associated Azure Monitor Workspace (AMW)
You must have an AMW associated to the subscription you are investigating. Consult with your system administrator to create the association. See [Associate an Azure Monitor Workspace with a subscription](aiops-issue-and-investigation-how-to.md#associate-an-amw-in-the-azure-portal).

:::image type="content" source="media/issues_investigations_error_message.png" alt-text="Azure Monitor Workspace is required for investigation error message displayed in the Azure portal. The screen shows a warning icon and the message Azure Monitor Workspace is required for an investigation. Below the message are buttons to set up a workspace or set as Default AMW. The environment is a web portal with a neutral and informative tone.":::

## No findings

When an investigation is run, you might receive a *No findings* result. This result isn't a problem – it just means the investigation didn't detect any anomalies in the metrics, logs, or other monitored data. It's important to remember that this result doesn't necessarily indicate the absence of underlying issues, but rather that the current data doesn't reveal any obvious problems.

:::image type="content" source="media/troubleshooting-no-findings.png" alt-text="Screenshot of no findings message." lightbox="media/troubleshooting-no-findings.png":::

## OpenAI issue

The feature depends on OpenAI for the text generation to function correctly. Occasionally, OpenAI might experience problems. If you encounter a screen indicating a problem with OpenAI, try refreshing the page and running the investigation again from the beginning. In the meantime, you can still review the anomalies detected without the summary, which can help identify potential issues even if the summary functionality is unavailable.

:::image type="content" source="media/troubleshooting-openai-failure.png" alt-text="Screenshot of openai failure." lightbox="media/troubleshooting-openai-failure.png":::

## Related content

- [Azure Monitor issues and investigations (preview) overview](aiops-issue-and-investigation-overview.md)
- [Use Azure Monitor issues and investigations](aiops-issue-and-investigation-how-to.md)
- [Azure Monitor issues and investigations responsible use](aiops-issue-and-investigation-responsible-use.md)
