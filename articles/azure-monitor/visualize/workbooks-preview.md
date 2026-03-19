---
title: Azure Workbooks preview
description: Information about the Azure Workbooks preview functionality, including dashboards
services: azure-monitor
author: gardnerjr
ms.author: jgardner
ms.topic: conceptual
ms.date: 10/15/2024
---

# Azure Workbooks Preview

The workbooks preview includes new functionality, including a new dashboard mode.

## Dashboard Mode

The workbooks preview supports a new layout mode that behaves like many dashboarding tools.

For more details about dashboards, see [Azure Workbook dashboard preview](workbooks-dashboard-preview.md).

In dashboard mode, you can use drag and drop to move items and resize panels, even in "read" mode.

When editing a workbook, this option appears in the pencil item in the toolbar:

:::image type="content" source="./media/workbooks-preview/dashboard-mode-selection.png" lightbox="./media/workbooks-preview/dashboard-mode-selection.png" alt-text="Screenshot that shows the dashboard mode selection setting." border="false":::

Changing this setting changes the top level layout of the workbook. You can freely switch back and forth between dashboard mode and workbook mode. Editing the layout, shape, sizes of items in one mode may not carry over to the other mode.

This behavior is also available inside a Group item in a workbook; any group can be displayed in either workbook or dashboard layout.

## Updated Visualizations

All of the visualizations in the workbooks preview are built on new technology, so everything looks a bit different.

New chart features:

- New options and settings for tooltips.
- New options for location / sorting of metrics and legends.
- New pan and zoom functionality in maps, including zooming in by default to the area containing data.
- New data point click action in maps that shows merged data for a point as a table of individual items.
- New options for icons and coloring options in graph visualization, including colorized links.
- New layers feature where you can add line, icon, rectangle annotations to a chart based on data in another query.
- New synchronized hover, zoom - hovering over charts shows a hover line in other charts at the same x coordinate. Zooming in on a zooms all charts to show the same region.

Any new settings that might appear in the Workbooks preview may not work if you open a saved workbook in the legacy workbooks experience.

## New Functionality

- New "Data Source" item - this new item available in the add menu allows you to add a data source that is never visible and has no visualization in view mode. It is only visible in the workbook while in edit mode. In legacy workbooks, it would be common to use a query item for this case, and then use conditional visibility to make it always hidden.

  Data source items are commonly used for things like queries using the Merge data source, or to add annotations to charts using the "Layers" feature.

- New "Visualization" item - this new item lets you visualize the results of another query or data source item. In legacy workbooks, you can do this by using a query step and "merge" data source with the "duplicate" option, but was hard to find.
- New "Data Repeater" item - this new item allows you to create a data source that repeats over the value of a parameter.
  For example, you could use a data repeater to repeat an Azure Resource Manager (ARM) data source for each selected value of a multi-select resource parameter,
  and union all the results.

- New "View Repeater" item - this new item allows you to repeat other items (steps) for each value of a parameter.
  For example, you could show the same metrics chart and grid of logs result for each value of a multi-select resource parameter.
  View repeaters allow the views to be repeated in various styles, like each repeated result is its own tab, or repeated inline with
  paging controls to show 5 at a time

- New Parameters features
  - "Filter" Style - in Filter style, there's a new option in parameter settings that controls if a parameter is always shown. If not, parameters with no value, or set to "All" aren't shown by default. Users then use the **+ Add Filter** option to pick from other available parameters.

    :::image type="content" source="./media/workbooks-preview/filter-style.png" lightbox="./media/workbooks-preview/filter-style.png" alt-text="Screenshot that shows parameters in filter style." border="false":::

  - Quick create - new options when creating parameters to create time range and subscription parameters with common settings

- Mermaid content in text steps - Text steps in the workbook preview also allow embedding [Mermaid](https://mermaid.js.org/intro/) content,
  to embed flow chart, sequence, and other diagrams inline with other Markdown content.

- Prometheus Data source editing includes completions for metrics, namespaces, etc.

- When editing various items in edit mode, you can chose to split the editor horizontally. You can also expand the editor to be full screen.

- Style options on items include new options for border styles, like dashed, rounded.
- New options in grid columns let you sort / resize / move columns via context menu and keyboard

## Preview Limitations

> [!NOTE]
> The workbook preview doesn't have the full functionality of Workbooks. We're working every day to remove these limitations.

Many new features have been added, and the settings for new items and features are _preserved_ when saving. You should be able to edit most workbooks with the existing workbook view, then open them in the preview to get new functionality and features.

Dashboard mode has specific limitations that legacy workbooks don't have. See [Azure Workbook dashboard preview](workbooks-dashboard-preview.md) to learn more.

If you need help or have feedback, use the **Feedback** button in the Workbooks preview view.
