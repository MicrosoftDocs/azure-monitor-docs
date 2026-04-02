---
title: Azure Workbooks preview
description: Information about the Azure Workbooks preview functionality, including dashboards
services: azure-monitor
author: gardnerjr
ms.author: jgardner
ms.topic: conceptual
ms.date: 03/30/2026
---

# Azure Workbooks Preview

The workbooks preview includes new functionality, including a new dashboard mode.

## Dashboard mode

The workbooks preview supports a new layout mode that behaves like many dashboarding tools.

For more details about dashboards, see [Azure Workbook dashboard preview](workbooks-dashboard-preview.md).

In dashboard mode, you can use drag and drop to move items and resize panels, even in "read" mode.

When editing a workbook, this option appears in the pencil item in the toolbar:

:::image type="content" source="./media/workbooks-preview/dashboard-mode-selection.png" lightbox="./media/workbooks-preview/dashboard-mode-selection.png" alt-text="Screenshot that shows the dashboard mode selection setting." border="false":::

Changing this setting changes the top level layout of the workbook. You can freely switch back and forth between dashboard mode and workbook mode. Editing the layout, shape, and sizes of items in one mode might not carry over to the other mode.

This behavior is also available inside a Group item in a workbook. You can display any group in either workbook or dashboard layout.

## Updated visualizations

All of the visualizations in the workbooks preview use new technology, so everything looks a bit different.

New chart features include:

- New options and settings for tooltips.
- New options for location and sorting of metrics and legends.
- New pan and zoom functionality in maps, including zooming in by default to the area containing data.
- New data point click action in maps that shows merged data for a point as a table of individual items.
- New options for icons and coloring options in graph visualization, including colorized links.
- New layers feature where you can add line, icon, and rectangle annotations to a chart based on data in another query.
- New synchronized hover and zoom - hovering over charts shows a hover line in other charts at the same x coordinate. Zooming in on a chart zooms all charts to show the same region.

If you open a saved workbook in the legacy workbooks experience, new settings that you see in the workbooks preview might not work.

## New functionality

- New **Data Source** item - use the new item in the add menu to add a data source that you never see and has no visualization in view mode. You only see it in the workbook while in edit mode. In legacy workbooks, it's common to use a query item for this case, and then use conditional visibility to make it always hidden.

  Use data source items for things like queries that use the Merge data source, or to add annotations to charts by using the **Layers** feature.

- New **Visualization** item - use the new item to visualize the results of another query or data source item. In legacy workbooks, you can do this by using a query step and **merge** data source with the **duplicate** option, but it was hard to find.
- New **Data Repeater** item - use the new item to create a data source that repeats over the value of a parameter.
  For example, you could use a data repeater to repeat an Azure Resource Manager (ARM) data source for each selected value of a multiselect resource parameter,
  and union all the results.

- New **View Repeater** item - use the new item to repeat other items (steps) for each value of a parameter.
  For example, you could show the same metrics chart and grid of logs result for each value of a multiselect resource parameter.
  View repeaters allow the views to be repeated in various styles, like each repeated result is its own tab, or repeated inline with
  paging controls to show five at a time.

- New parameters features
  - **Filter** style - in Filter style, there's a new option in parameter settings that controls if a parameter is always shown. If not, parameters with no value, or set to **All** aren't shown by default. Users then use the **+ Add Filter** option to pick from other available parameters.

    :::image type="content" source="./media/workbooks-preview/filter-style.png" lightbox="./media/workbooks-preview/filter-style.png" alt-text="Screenshot that shows parameters in filter style." border="false":::

  - Quick create - new options when creating parameters to create time range and subscription parameters with common settings.

- Mermaid content in text steps - text steps in the workbook preview also allow embedding [Mermaid](https://mermaid.js.org/intro/) content,
  to embed flow chart, sequence, and other diagrams inline with other Markdown content.

- Prometheus data source editing includes completions for metrics, namespaces, and more.

- When editing various items in edit mode, you can choose to split the editor horizontally. You can also expand the editor to be full screen.

- Style options on items include new options for border styles, like dashed and rounded.
- New options in grid columns let you sort, resize, and move columns by using the context menu and keyboard.

## Preview limitations

> [!NOTE]
> The workbook preview doesn't have the full functionality of Workbooks. The product team is working to remove these limitations.

The product team adds many new features. The settings for new items and features are _preserved_ when saving. You can edit most workbooks by using the existing workbook view, then open them in the preview to get new functionality and features.

Dashboard mode has specific limitations that legacy workbooks don't have. To learn more, see [Azure Workbook dashboard preview](workbooks-dashboard-preview.md).

If you need help or have feedback, use the **Feedback** button in the Workbooks preview view.
