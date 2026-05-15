---
title: Troubleshoot Azure Copilot observability agent (preview)
description: Troubleshoot common problems with the Azure Copilot observability agent, including steps to resolve issues caused by OpenAI service disruptions.
ms.topic: troubleshooting-general
ms.service: azure-monitor
ms.collection: ce-skilling-ai-copilot
ms.reviewer: ronitauber
ms.date: 04/03/2026
---

# Troubleshooting guide: Azure Copilot observability agent (preview)

This article provides troubleshooting guidance for the Azure Copilot observability agent.

## OpenAI issue

The observability agent depends on OpenAI for the text generation to function correctly. Occasionally, OpenAI might experience problems. If you encounter a screen indicating a problem with OpenAI, try refreshing the page and running the observability agent investigation again from the beginning. In the meantime, you can still review the anomalies detected without the summary, which can help identify potential problems even if the summary functionality is unavailable.

## Related content

- [Azure Copilot observability agent overview](observability-agent-overview.md)
- [Azure Monitor issues overview](aiops-issue-and-investigation-overview.md)
- [Use Azure Monitor issues](aiops-issue-and-investigation-how-to.md)
- [Azure Copilot observability agent responsible use](observability-agent-responsible-use.md)
- [Governance, privacy, and AI model FAQ](observability-agent-governance-faq.md)
