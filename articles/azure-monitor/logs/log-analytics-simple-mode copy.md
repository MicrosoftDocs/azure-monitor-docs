---
title: Analyze data using Log Analytics Simple mode (Preview)
description: This article explains how to use Log Analytics Simple mode to explore and analyze data in Azure Monitor Logs.
ms.topic: conceptual
author: guywi-ms
ms.author: guywild
ms.reviewer: ilanawaitser
ms.date: 05/19/2024

# Customer intent: As an analyst or DevOps troubleshooter, I want to get insights from log data without using Kusto Query Language (KQL).

---

# Analyze data using Log Analytics Simple mode (Preview)

Log Analytics now offers two modes that make log data simpler to explore and analyze for both basic and advanced users:  

- **Simple mode** provides the most commonly used Azure Monitor Logs functionality in an intuitive, spreadsheet-like experience. Just point and click to filter, sort, and aggregate data to get to the insights you need 80% of the time. 
- **KQL mode** gives advanced users the full power of Kusto Query Language (KQL) to derive deeper insights from their logs using the [Log Analytics query editor](log-analytics-overview.md).

You can switch seamlessly between Simple and KQL modes, and advanced users can share complex queries that anyone can continue working with in Simple mode.

This article explains how to use Log Analytics Simple mode to explore and analyze data in Azure Monitor Logs.    

Here's a video that provides a quick overview of how to query logs in Log Analytics using both Simple and KQL modes:
<br>

>[!VIDEO https://www.youtube.com/embed/85Xxj5FhTk0?cc_load_policy=1&cc_lang_pref=auto]

## Try Log Analytics Simple mode

Simple Mode is now the default view for some users. If it’s not enabled by default for you, simply select **Try the new Log Analytics** at the top-right corner of the query editor. You can switch back to the classic Log Analytics experience at any time. 

:::image type="content" source="media/log-analytics-explorer/try-new-log-analytics.png" alt-text="A screenshot showing the Try the new Log Analytics button." lightbox="media/log-analytics-explorer/try-new-log-analytics.png":::

## How Simple mode works

Simple mode lets you [get started quickly by retrieving data from one or more tables with one click](#get-started-in-simple-mode). You then use a set of intuitive controls to [explore and analyze the retrieved data](#explore-and-analyze-data-in-simple-mode).  

This section orients you with the controls available in Log Analytics Simple mode.

:::image type="content" source="media/log-analytics-explorer/log-analytics-simple-mode-user-interface.png" alt-text="Screenshot that shows Log Analytics Simple mode." lightbox="media/log-analytics-explorer/log-analytics-simple-mode-user-interface.png":::

### Top query bar

In Simple mode, the top bar has controls for working with data and switching to KQL mode.

:::image type="content" source="media/log-analytics-explorer/log-analytics-top-query-bar.png" alt-text="Screenshot that shows the top query bar in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-top-query-bar.png":::

| Option | Description |
|:---|:---|
| **Time range** | Select the [time range](./scope.md) for the data available to the query. In KQL mode, if you set a different time range in your query, the time range you set in the time picker is overridden. |
|**Limit**|Configure the number of entries Log Analytics retrieves in Simple mode. The default limit is 1000. For more information on query limits, see [Configure query results limit](#configure-query-result-limit).|
|**Add**|Add filters, and apply Simple mode operators, as described in [Explore and analyze data in Simple mode](#explore-and-analyze-data-in-simple-mode).|
|**Simple/KQL mode**|Switch between Simple and KQL mode.|

### Left pane

The collapsible left pane gives you access to tables, example and saved queries, functions, and query history.

Pin the left pane to keep it open while you work, or maximize your query window by selecting an icon from the left pane only when you need it.

:::image type="content" source="media/log-analytics-explorer/log-analytics-left-sidebar.png" alt-text="Screenshot that shows the left sidebar in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-left-sidebar.png":::

| Option | Description |
|:---|:---|
| **Tables** | Lists the tables that are part of the selected scope. Select **Group by** to change the grouping of the tables. Hover over a table name to view the table's description and a link to its documentation. Expand a table to view its columns. Select a table to run a query on it. |
| **Queries** | Lists example and saved queries. This is the same list that's in the Queries Hub. Select **Group by** to change the grouping of the queries. Hover over a query to view the query's description. Select a query to run it.|
|**Functions**|Lists [functions](../logs/functions.md), which allow you to reuse predefined query logic in your log queries. |
|**Query history**|Lists your query history. Select a query to rerun it.|

### More tools

This section describes more tools available above the query area of the screen, as shown in this screenshot, from left to right.

:::image type="content" source="media/log-analytics-explorer/log-analytics-more-tools.png" alt-text="Screenshot that shows the More tools window in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-more-tools.png":::

| Option | Description |
|:---|:---|
| **Tab context menu**|[Change query scope](scope.md) or rename, duplicate, or close tab. |
| **Save** | [Save a query to a query pack](../logs/save-query.md) or as a [function](functions.md), or pin your query to a [workbook](../visualize/workbooks-overview.md), an [Azure dashboard](../visualize/tutorial-logs-dashboards.md), or [Grafana dashboard](../visualize/grafana-plugin.md#pin-charts-from-the-azure-portal-to-azure-managed-grafana). |
| **Share** | Copy a link to your query, the query text, or query results, or [export data to Excel](../logs/log-excel.md), CSV, or [Power BI](../logs/log-powerbi.md). |
| **New alert rule** | [Create a new alert rule](../alerts/alerts-create-new-alert-rule.md#create-or-edit-an-alert-rule-in-the-azure-portal). |
| **Search job mode** | [Run a search job](../logs/search-jobs.md). |
| **Log Analytics settings**| Define default Log Analytics settings, including time zone, whether Log Analytics first opens in Simple or KQL mode, and whether to display tables with no data.|
| **Switch back to classic Logs** | Switch back to the [classic Log Analytics user interface](../logs/log-analytics-overview.md). |
| **Queries Hub** | Open the example queries dialog that appears when you first open Log Analytics. |

## Get started in Simple mode

When you select a table or a predefined query or function in Simple mode, Log Analytics automatically retrieves the relevant data for you to explore and analyze. 

This lets you retrieve logs with one click whether you open Log Analytics in resource or workspace context.

To get started, you can:

- Click **Select a table** and select a table from the **Tables** tab to view table data.

    :::image type="content" source="media/log-analytics-explorer/log-analytics-select-table.png" alt-text="Screenshot that shows the Select a table button in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-select-table.png":::

    Alternatively, select **Tables** from the left pane to view the list of tables in the workspace.

    :::image type="content" source="media/log-analytics-explorer/log-analytics-tables.png" alt-text="Screenshot that shows the Tables tab in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-tables.png":::

- Use an existing query, such as a shared or [saved query](../logs/save-query.md), or an example query.

    :::image type="content" source="media/log-analytics-explorer/log-analytics-simple-mode-example-query.png" alt-text="Screenshot that shows an example query in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-simple-mode-example-query.png":::

- Select a query from your query history.

    :::image type="content" source="media/log-analytics-explorer/log-analytics-query-history.png" alt-text="Screenshot that shows the query history in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-query-history.png":::

- Select a [function](../logs/functions.md).

    :::image type="content" source="media/log-analytics-explorer/log-analytics-functions.png" alt-text="Screenshot that shows the functions tab in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-functions.png"::: 

    > [!IMPORTANT]
    > Functions let you reuse query logic and often require input parameters or additional context. In such cases, the function won't run until you switch to KQL mode and provide the required input.  
  
## Explore and analyze data in Simple mode 

After you [get started in Simple mode](#get-started-in-simple-mode), you can explore and analyze data using the [top query bar](#top-query-bar). 

> [!NOTE]
> The order in which you apply filters and operators affects your query and results. For example, if you apply a filter and then aggregate, Log Analytics applies the aggregation to the filtered data. If you aggregate and then filter, the aggregation is applied to the unfiltered data.

#### Show or hide columns

1. Select **Show columns**.
1. Select or clear columns to show or hide them, then select **Apply**.

    :::image type="content" source="media/log-analytics-explorer/log-analytics-show-column.png" alt-text="Screenshot that shows the Show columns window in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-show-column.png":::

## Switch modes

To switch modes, select **Simple mode** or **KQL mode** from the dropdown in the top right corner of the query editor.

:::image type="content" source="media/log-analytics-explorer/log-analytics-switch-modes-Simple.png" alt-text="Screenshot that shows how to toggle between Simple mode and KQL mode in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-switch-modes-simple.png":::

When you begin to query logs in Simple mode and then switch to KQL mode, the query editor is prepopulated with the KQL query related to your Simple mode analysis. You can then edit and continue working with the query.

:::image type="content" source="media/log-analytics-explorer/log-analytics-switch-modes-kql.png" alt-text="Screenshot that shows a query in Log Analytics KQL mode." lightbox="media/log-analytics-explorer/log-analytics-switch-modes-kql.png":::

For straightforward queries on a single table, Log Analytics displays the table name at the right of the top query bar in Simple mode. For more complex queries, Log Analytics displays **User Query** at the left of the top query bar. Select **User Query** to return to the query editor and modify your query at any time.

:::image type="content" source="media/log-analytics-explorer/log-analytics-switch-modes-user-query.png" alt-text="Screenshot that shows the User Query button, which lets you return to the query editor when you're in Simple mode." lightbox="media/log-analytics-explorer/log-analytics-switch-modes-user-query.png":::


## Next steps
- Walk through a [tutorial on using KQL mode in Log Analytics](../logs/log-analytics-tutorial.md).
- Access the complete [reference documentation for KQL](/azure/kusto/query/).
