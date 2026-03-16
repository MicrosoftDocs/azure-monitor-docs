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
* New options and settings for tooltips.
* New options for location / sorting of metrics and legends.
* New pan and zoom functionality in maps, including zooming in by default to the area containing data.
* New data point click action in maps that shows merged data for a point as a table of individual items.
* New options for icons and coloring options in graph visualization, including colorized links.
* New layers feature where you can add line, icon, rectangle annotations to a chart based on data in another query.
* New synchronized hover, zoom - hovering over charts shows a hover line in other charts at the same x coordinate. Zooming in on a zooms all charts to show the same region.

Any new settings that might appear in the preview may not work if you open a saved dashboard workbook in the standard, non-preview workbooks view.

## New Functionality

* New "Data Source" item - this new item available in the add menu allows you to add a data source that is never visible and has no visualization in view mode. It is only visible in the workbook while in edit mode. In standard workbooks, it would be common to use a query item for this case, and then use conditional visibility to make it always hidden.
 
  Data source items are commonly used for things like queries using the Merge data source, or to add annotations to charts using the "Layers" feature.

* New "Visualization" item - this new item lets you visualize the results of another query or data source item. In standard workbooks, you can do this by using a query step and "merge" data source with the "duplicate" option, but was hard to find.
  
* New "Data Repeater" item - this new item allows you to create a data source that repeats over the value of a parameter.
  For example, you could use a data repeater to repeat an Azure Resource Manager (ARM) data source for each selected value of a multi-select resource parameter,
  and union all the results.

* New "View Repeater" item - this new item allows you to repeat other items (steps) for each value of a parameter.
  For example, you could show the same metrics chart and grid of logs result for each value of a multi-select resource parameter.
  View repeaters allow the views to be repeated in various styles, like each repeated result is its own tab, or repeated inline with
  paging controls to show 5 at a time

* New Parameters features
    * "Filter" Style - in Filter style, there's a new option in parameter settings that controls if a parameter is always shown. If not, parameters with no value, or set to "All" aren't shown by default. Users then use the **+ Add Filter** option to pick from other available parameters.
      
      :::image type="content" source="./media/workbooks-preview/filter-style.png" lightbox="./media/workbooks-preview/filter-style.png" alt-text="Screenshot that shows parameters in filter style." border="false":::

    * Quick create - new options when creating parameters to create time range and subscription parameters with common settings


* Mermaid content in text steps - Text steps in the workbook preview also allow embedding [Mermaid](https://mermaid.js.org/intro/) content,
  to embed flow chart, sequence, and other diagrams inline with other Markdown content.

* Prometheus Data source editing includes completions for metrics, namespaces, etc.

* When editing various items in edit mode, you can chose to split the editor horizontally. You can also expand the editor to be full screen.

* Style options on items include new options for border styles, like dashed, rounded.
* New options in grid columns let you sort / resize / move columns via context menu and keyboard 

## Preview Limitations

> [!NOTE]
> The workbook preview doesn't have the full functionality of Workbooks. We're working every day to remove these limitations.

Many new features have been added, and the settings for new items and features are *preserved* when saving. You should be able to edit most workbooks with the existing workbook view, then open them in the preview to get new functionality and features.

In dashboard mode:
* A limited set of items can be added to dashboards at this time; Only text, parameters, and query items are currently supported.
* Most data sources are supported in dashboards. The exceptions are Custom Provider and Azure Role Based Access Control (RBAC), which aren't yet supported in dashboards.
* Saved dashboards opened in the non-preview dashboard view display a warning that it may not display accurately outside of the preview, with a link to open that item in the preview view.
* Any items with conditional visibility set are never visible in dashboard mode.
* As dashboards are based on the workbooks infrastructure, there's still an implicit order of items in the dashboard, which determines which parameters or exported data are available to other items on the dashboard. This order is determined by the order in which items are added to the dashboard. The  order of items can be changed by using the **Step Order** option in the edit menu toolbar. The layout of items on the dashboard itself isn't directly related to the order of items, so you can do things like move a parameters step to the right side of the dashboard instead of the top; but make sure the parameters step appears in the step order panel above any other items that need those parameters.

Other limitations / known issues:
* Pins - all pinned items from the workbooks preview pin the existing standard items to Azure Dashboards. No new visualization functionality/settings are currently available in pinned dashboard parts.
* Opening workbook content from URLs, or with `NewNotebookData` isn't currently supported.
* "Show query when not editing" functionality was removed. If you were a fan of this feature, let us know via feedback from the preview view in the Azure portal.
* "Send to Workbooks" from other views always sends to the non-preview workbooks.
* Metrics limitations:
  * Time brushing / selection isn't yet supported.
  * Alert rule options don't yet appear in metrics toolbar.
* Data sources not yet supported:
  * Azure Role Based Access Control (RBAC)
  * Custom Provider
* The updated version of Markdown used in workbooks is *less* forgiving and adheres to modern Markdown specifications, including supporting Git-flavored markdown (GFM). Some markdown that appears to display properly in standard workbooks but isn't correct in the preview needs to be updated. The most common cases are in markdown tables that have mismatched columns. In most cases, fixing it to display properly in the preview *also* displays properly in standard workbooks. Additionally, some elements that were previously blocked in standard workbooks (such as custom fonts and other formatting that was sanitized by the portal) are no longer blocked in the preview. As a result, some formatting that didn't apply before might suddenly appear and look unexpected.

If you need help or have feedback, use the **Feedback** button in the Workbooks preview view.
