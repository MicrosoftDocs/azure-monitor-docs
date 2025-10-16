---
title: Azure Workbooks Dashboard preview
description: Information about the Azure Workbooks Dashboard preview functionality
ms.topic: concept-article
ms.date: 10/16/2025
---

# Azure Workbooks dashboard preview

This preview includes new dashboarding functionality in Azure Workbooks. The dashboard preview only applies to dashboard style workbooks. Opening other workbooks continues to open them in the non-preview view. To open the dashboard preview, use the "Dashboard (preview)" item in the Workbooks gallery.

> [!NOTE]
> The dashboard preview is slowly rolling out to all users. If you don't see the "Dashboard (preview)" item in the workbooks gallery yet, check back later.

## New layout mode
The workbooks dashboard preview supports a new layout mode that behaves like many dashboarding tools:

:::image type="content" source="./media/workbooks-dashboards/dashboard-preview.png" lightbox="./media/workbooks-dashboards/dashboard-preview.png" alt-text="Screenshot that shows an example dashboard." border="false":::

Dashboard features:
* Items can be dragged to be moved and resized;
  * If an item has a title, the title area allows dragging of that item.
  * If an item doesn't have a title, there's a drag icon in the floating toolbar that can be used to move the item.
* Any visualization in a dashboard can be expanded to full screen by using the **View** item in the item's dropdown menu in the toolbar.
* Only one item on the dashboard can be edited at a time, and editing takes place in a popup view.
* Items are added to dashboards via a new widget window, including by drag and drop;
  * Only a subset of items can currently be added in dashboards.

## Updated visualizations

All of the visualizations in the dashboard preview are built on new technology, so everything looks a bit different. 

New chart features:
* New options and settings for tooltips.
* New options for location / sorting of metrics and legends.
* New pan and zoom functionality in maps, including zooming in by default to the area containing data.
* New data point click action in maps that shows merged data for a point as a table of individual items.
* New options for icons and coloring options in graph visualization, including colorized links.
* New layers feature where you can add line, icon, rectangle annotations to a chart based on data in another query.
* New synchronized hover, zoom - hovering over charts shows a hover line in other charts at the same x coordinate. Zooming in on a zooms all charts to show the same region.

Any new settings that might appear in the preview may not work if you open a saved dashboard workbook in the standard, non-preview workbooks view.

## New functionality

* New Parameters features;
    * "Filter" Style - in Filter style, there's a new option in parameter settings that controls if a parameter is always shown. If not, parameters with no value, or set to "All" aren't shown by default. Users then use the **+ Add Filter** option to pick from other available parameters.

    * Quick create - new options when creating parameters to quickly create time range and subscription parameters with common settings.

* Mermaid content in text steps - Text steps in the dashboard preview also allow embedding [Mermaid](https://mermaid.js.org/intro/) content, to embed flow chart, sequence, and other diagrams inline with other Markdown content.

* Prometheus Data source editing includes completions for metrics, namespaces, etc.

* When editing various items in edit mode, you can choose to split the editor horizontally. You can also expand the editor to be full screen.

* Style options on items include new options for border styles, like dashed, rounded.

* New options in grid columns let you sort / resize / move columns via context menu and keyboard.

## Preview limitations

> [!NOTE]
> The dashboard preview doesn't have the full functionality of Workbooks. We're working every day to remove these limitations.

* A limited set of items can be added to dashboards at this time; Only text, parameters, and query items are currently supported.
* A limited set of data sources are supported in dashboards; only Logs, Azure Resource Graph, Azure Data Explorer, and Prometheus queries are currently supported.
* Saved dashboards opened in the non-preview dashboard view display a warning that it may not display accurately outside of the preview, with a link to open that item in the preview view.
* The updated version of Markdown used in workbooks is *less* forgiving and adheres to modern Markdown specifications, including supporting Git-flavored markdown (GFM). Some markdown that appears to display properly in standard workbooks but isn't correct in the preview need to be updated. The most common cases are in markdown tables that have mismatched columns. In most cases, fixing it to display properly in the preview *also* display properly in standard workbooks.
* As dashboards are based on the workbooks infrastructure, there's still an implicit order of items in the dashboard, which determines which parameters or exported data are available to other items on the dashboard. This order is determined by the order in which items are added to the dashboard. The  order of items can be changed by using the **Step Order** option in the edit menu toolbar. The layout of items on the dashboard itself isn't directly related to the order of items, so you can do things like move a parameters step to the right side of the dashboard instead of the top; but make sure the parameters step appears in the step order panel above any other items that need those parameters.

If you have feedback, or run into issues, use the **Feedback** item in toolbar the Workbooks dashboard preview view.
