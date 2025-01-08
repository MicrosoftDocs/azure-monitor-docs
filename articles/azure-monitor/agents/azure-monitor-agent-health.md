---
title: View Azure Monitor agent health
description: Learn how to view agent health at scale and troubleshoot issues related to data collection via agents.
ms.topic: conceptual
author: guywi-ms
ms.author: guywild
ms.date: 11/14/2024
ms.reviewer: shseth
---

# Azure Monitor agent health

Use the Azure Monitor Agent Health workbook in the Azure portal for a summary of the details and health of agents deployed across your organization.

The workbook gives you the following information:

- Distribution of your agents across environments and resource types
- Health trend and details of agents, including their last heartbeat
- Agent processes footprint for both processor and memory for a selected agent
- Summary of data collection rules and their associated agents

:::image type="content" source="media/azure-monitor-agent/azure-monitor-agent-health.png" lightbox="media/azure-monitor-agent/azure-monitor-agent-health.png" alt-text="Screenshot of the Azure Monitor agent health workbook. The screenshot highlights the various default charts and scope of information.":::

To access the workbook, in the Azure portal, go to **Azure Monitor** > **Workbooks** or go directly to [Workbooks in the Gallery](https://ms.portal.azure.com/#blade/AppInsightsExtension/UsageNotebookBlade/ComponentId/Azure%20Monitor/ConfigurationId/community-Workbooks%2FAzure%20Monitor%20-%20Agents%2FAMA%20Health/Type/workbook/WorkbookTemplateName/AMA%20Health%20(Preview)). Try it out and [share your feedback](mailto:obs-agent-pms@microsoft.com) with us.
