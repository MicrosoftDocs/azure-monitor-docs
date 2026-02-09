---
title: Use Copilot with Azure Workbooks (preview)
description: Learn how to use Copilot in Azure to create, analyze, and modify Azure Workbooks using natural language.
ms.topic: concept-article
ms.date: 02/09/2026
ms.reviewer: gardnerjr
ai-usage: ai-assisted
---

# Use Copilot with Azure Workbooks (preview)

Copilot in Azure can help you create, inspect, and modify Azure Workbooks using natural language. Instead of manually configuring queries, visualizations, and parameters, you can describe what you want, and Copilot generates the workbook components for you.

> [!IMPORTANT]
> Copilot for Azure Workbooks is currently in public preview. Preview features are provided without a service level agreement and aren't recommended for production workloads. For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Prerequisites

- Access to [Copilot in Azure](/azure/copilot/overview). Copilot in Azure must be enabled for your tenant.
- [Azure Workbooks Preview](workbooks-preview.md) or **Dashboards** experience. Copilot isn't available in the legacy Azure Workbooks experience.
- To create, modify, or remove workbook items, the workbook must be in edit mode.
- To browse and open workbooks, you can use Copilot directly from the **Workbooks** gallery without opening a workbook first.

## What you can do with Copilot in Azure Workbooks

Copilot supports the following scenarios:

| Scenario                        | Description                                                                                                       |
| ------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| Browse and open workbooks       | From the Workbooks gallery, ask Copilot to list your recent workbooks and open one. No workbook needs to be open. |
| Describe the workbook canvas    | Ask Copilot to summarize all items in a workbook, including queries, charts, parameters, and text blocks.         |
| Analyze a chart for anomalies   | Ask Copilot to analyze a specific chart and identify patterns, spikes, or anomalies in the data.                  |
| Create a new workbook           | Ask Copilot to generate a workbook with specific visualizations, queries, and parameters.                         |
| Add a chart or query step       | Ask Copilot to add a new visualization or query to an existing workbook.                                          |
| Modify an existing step         | Ask Copilot to update a parameter, query, or visualization in a workbook.                                         |
| Remove a step                   | Ask Copilot to remove one or more items from the workbook canvas.                                                 |
| Improve titles and descriptions | Ask Copilot to rewrite titles and text blocks for clarity and readability.                                        |

## Supported step types

Copilot can create and modify the following workbook step types:

| Step type            | Description                                                                           |
| -------------------- | ------------------------------------------------------------------------------------- |
| Text                 | Markdown text blocks.                                                                 |
| Metrics              | Azure Monitor metrics visualizations.                                                 |
| Azure Resource Graph | Azure Resource Graph queries.                                                         |
| Logs                 | Log Analytics and Application Insights KQL queries.                                   |
| Parameters           | Parameter pickers such as time range, resource, subscription, and dropdown selectors. |

## Get started

You can start using Copilot from the Workbooks gallery or from within an open workbook.

**From the gallery:**

1. In the Azure portal, go to **Monitor** > **Workbooks (preview)**.
1. Open the Copilot sidecar by selecting the **Copilot** button.
1. Ask Copilot to list your recent workbooks or open a specific one. For example, _"Show me my recent workbooks"_ or _"Open the VM performance workbook."_

**From an open workbook:**

1. Open a workbook and select **Edit** in the toolbar to enter edit mode.
1. Open the Copilot sidecar by selecting the **Copilot** button.
1. Type a question or instruction in natural language and review the response.

> [!NOTE]
> Creating, modifying, or removing workbook items requires edit mode. If you're viewing a workbook in read-only mode, select **Edit** first.

The following sections describe each workflow in detail.

## Describe and analyze a workbook

Ask Copilot to summarize the workbook canvas or analyze a specific chart.

1. Open an existing workbook in edit mode.
1. Open the Copilot sidecar.
1. Ask Copilot to describe or analyze the workbook. For example:
   - _"What's on my canvas?"_
   - _"Summarize the items in this workbook."_
   - _"Analyze the CPU usage chart for anomalies."_
   - _"Are there any spikes in the memory usage data?"_

1. Copilot returns a summary of the workbook items or an analysis of the chart data, including item types, names, visualizations, and any patterns or anomalies it identifies.

> [!TIP]
> For large workbooks, ask Copilot to focus on a specific section or chart rather than the entire canvas. Workbooks with more than approximately 50 items might be truncated in analysis.

## Create a workbook

Ask Copilot to scaffold a new workbook with the visualizations and queries you need.

1. Open a new or existing workbook in edit mode, or ask Copilot from the gallery to create one.
1. Open the Copilot sidecar.
1. Describe the workbook you want to create. For example:
   - _"Create a workbook to monitor my VM performance."_
   - _"Build a dashboard with CPU, memory, and disk metrics for my virtual machines."_
   - _"Create a workbook that shows failed sign-ins from Microsoft Entra ID logs."_

1. Copilot generates workbook items—queries, charts, parameters, and text blocks—and adds them to the canvas in edit mode.
1. Review the generated items. Adjust queries or visualization settings as needed.
1. Select **Save** to keep the workbook.

> [!NOTE]
> Generated KQL queries are a starting point and might require manual refinement. Verify that queries return expected results by selecting **Run Query** on each step.

## Add a chart or query step

Ask Copilot to extend an existing workbook with new steps.

1. Open an existing workbook in edit mode.
1. Open the Copilot sidecar.
1. Ask Copilot to add a specific item. For example:
   - _"Add a line chart showing memory usage over time."_
   - _"Add a parameter for subscription selection."_
   - _"Add a table of the top 10 most expensive resources from Azure Resource Graph."_
   - _"Add a text block with a summary section header."_

1. Copilot scaffolds the new item with the appropriate query and visualization settings and adds it to the workbook canvas.

> [!NOTE]
> New items are added to the end of the workbook. After Copilot adds the item, you can manually reorder it by using the workbook editor controls.

## Modify an existing step

Ask Copilot to update an item that's already on the workbook canvas.

1. Open the workbook in edit mode.
1. Open the Copilot sidecar.
1. Reference the item you want to change and describe the modification. For example:
   - _"Update the time range parameter to default to the last 7 days."_
   - _"Change the query to filter by the East US region."_
   - _"Improve the titles in this workbook to be more descriptive."_
   - _"Switch the bar chart to a line chart."_

1. Copilot retrieves the current item state, generates the updated configuration, and applies the change in place.

> [!TIP]
> If Copilot can't find the item you're referencing, ask _"What's in this workbook?"_ first to refresh its understanding of the canvas, then retry the update.

## Remove items from a workbook

Ask Copilot to delete one or more items from the workbook canvas.

1. Open the workbook in edit mode.
1. Open the Copilot sidecar.
1. Ask Copilot to remove specific items. For example:
   - _"Remove the last chart from this workbook."_
   - _"Delete the text block at the top."_

1. Copilot identifies the items and removes them from the canvas.

> [!NOTE]
> Copilot can remove and update items in a single request. For example, you can ask _"Remove the pie chart and change the bar chart to a line chart"_ in one step.

## Best practices

- **Start simple.** Begin with a focused request like a single chart or query, then build up incrementally.
- **Be specific with metrics.** Include the resource type and metric name when asking for metrics visualizations. For example, _"Add a CPU percentage chart for my virtual machines"_ produces better results than _"Add a chart."_
- **Review generated queries.** Always run and verify Copilot-generated KQL queries before saving the workbook. Adjust time ranges, filters, and aggregations as needed.
- **Use describe before modify.** Ask Copilot to describe the workbook canvas before requesting updates. This ensures Copilot has accurate context about the current items.
- **Set resource context.** Make sure the correct resource or resource group is selected in the workbook before asking Copilot to generate queries. Queries execute against the current resource context.

## Supported data sources

Copilot can generate queries for the following data sources:

| Data source           | Query language | Operations     |
| --------------------- | -------------- | -------------- |
| Azure Monitor Metrics | Metric picker  | Create, update |
| Log Analytics         | KQL            | Create, update |
| Application Insights  | KQL            | Create, update |
| Azure Resource Graph  | KQL (ARG)      | Create, update |

## Related content

- [Azure Workbooks overview](workbooks-overview.md)
- [Create or edit an Azure Workbook](workbooks-create-workbook.md)
- [Troubleshoot Copilot for Azure Workbooks](workbooks-copilot-troubleshoot.md)
- [Copilot in Azure overview](/azure/copilot/overview)
