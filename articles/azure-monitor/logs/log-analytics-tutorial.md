---
title: "Log Analytics Tutorial: Query and Analyze Log Data"
description: Learn how to use Log Analytics in Azure Monitor to build and run KQL log queries, filter and analyze results, and create charts in the Azure portal.
ms.topic: tutorial
ms.reviewer: ilanawaitser
ms.date: 05/12/2026
ai-usage: ai-assisted

#customer intent: As a cloud engineer, I want to learn how to use Log Analytics in Azure Monitor so that I can query and analyze log data in my environment.

---

# Tutorial: Use Log Analytics

Log Analytics is a tool in the Azure portal for querying and analyzing data collected by [Azure Monitor Logs](data-platform-logs.md). When you need to troubleshoot an issue, investigate a performance trend, or understand how your Azure resources behave, use Log Analytics to write and run [log queries](log-query-overview.md).

This tutorial walks you through the Log Analytics interface using sample data. You explore the table schema, write and run basic queries, and work with the results.

In this tutorial, you:

> [!div class="checklist"]
> * Understand the log data schema.
> * Write and run simple queries, and modify the time range for queries.
> * Filter, sort, and group query results.
> * View, modify, and share visuals of query results.
> * Load, export, and copy queries and results.

## Prerequisites

* A Microsoft account or Microsoft Entra ID identity with access to the [Azure portal](https://portal.azure.com).
* The [Log Analytics demo environment](https://portal.azure.com/#blade/Microsoft_Azure_Monitoring_Logs/DemoLogsBlade) (recommended). The demo environment includes sample data that supports the queries in this tutorial. No Azure subscription required.
* If you use your own subscription instead of the demo environment, you need a Log Analytics workspace with data. Your tables might not match the demo data.

> [!NOTE]
> Log Analytics has two modes: Simple and Kusto Query Language (KQL). *This tutorial primarily uses KQL mode.* If you prefer a point-and-select interface instead of writing KQL queries, see [Analyze data using Log Analytics Simple mode](log-analytics-simple-mode.md).

This tutorial uses Log Analytics features to build queries and use example queries. When you're ready to learn the syntax of queries and start directly editing the query itself, try the [Kusto Query Language (KQL) tutorial](/azure/data-explorer/kusto/query/tutorial?pivots=azuremonitor). That tutorial walks you through example queries that you can edit and run in Log Analytics. It uses several of the features that you learn in this tutorial.

## Open Log Analytics

Open the [Log Analytics demo environment](https://portal.azure.com/#blade/Microsoft_Azure_Monitoring_Logs/DemoLogsBlade), or select **Logs** from the Azure Monitor menu in your subscription. This step sets the initial scope to a Log Analytics workspace so that your query selects from all data in that workspace. If you select **Logs** from an Azure resource's menu, the scope narrows to only records from that resource. For more information, see [Log query scope](./scope.md).

Find the current scope by selecting the ellipsis of the current query. If you're using your own environment, you see an option to select a different scope. This option isn't available in the demo environment.

:::image type="content" source="media/log-analytics-tutorial/log-analytics-query-scope.png" alt-text="Screenshot that shows the Log Analytics scope for the demo." lightbox="media/log-analytics-tutorial/log-analytics-query-scope.png":::

**Verification:** Confirm the query editor is visible and the scope displays your workspace name or "Demo" in the upper-left corner.

## View table information

The left side of the screen includes the **Tables** tab, where you inspect the tables available in the current scope. These tables are grouped by **Solution** by default, but you can change their grouping or filter them.

1. Expand the **Log Management** solution and locate the **AppRequests** table. Expand the table to view its schema, or hover over its name to show more information about it.

1. Select the link under **Useful links** (in this example, [AppRequests](/azure/azure-monitor/reference/tables/AppRequests)) to view the reference that documents the table and its columns.

1. Hover over the **AppRequests** table and select **Run** to see records from the last 24 hours in the table. This preview helps you verify the data before you run a more extensive query.

    :::image type="content" source="media/log-analytics-tutorial/preview-data.png" alt-text="Screenshot that shows preview data for the AppRequests table." lightbox="media/log-analytics-tutorial/preview-data.png":::

**Verification:** The preview pane shows records with columns like **Name**, **Url**, **DurationMs**, **ResultCode**, and **ClientCity**. If the AppRequests table doesn't appear under **Log Management**, your workspace might not have Application Insights data configured.

## Write a query

Write a query by using the **AppRequests** table:

1. Double-click the table name, or hover over it and select **Use in editor** to add it to the query window. Alternatively, type `AppRequests` directly in the window. IntelliSense helps complete the names of tables in the current scope and KQL commands.

1. Select the **Run** button or press **Shift+Enter** with the cursor positioned anywhere in the query text. This query is the simplest possible and returns all records in the table up to the **Show results** limit.

**Verification:** Check the lower-right corner of the results pane. You should see a record count greater than zero. For information about the maximum number of results, see [Configure query result limit](./log-analytics-simple-mode.md#configure-query-result-limit).

To learn how to author your own queries, see [Get started with log queries in Azure Monitor Logs](get-started-queries.md).

### Set the query time range

All queries return records generated within a set time range. By default, the time picker is set to **Last 24 hours**. After the preview run, the query explicitly set the time range to 24 hours.Set a different time range by using the **Time range** dropdown at the top of the screen, or edit the [where operator](/azure/data-explorer/kusto/query/tutorial?pivots=azuremonitor#filter-by-condition) in the query. If you use both methods, Log Analytics applies the union of the two time ranges. For details, see [Specify a time range](get-started-queries.md#specify-a-time-range).

1. Change the time range by selecting **Last 12 hours** from the **Time range** dropdown. 

1. Remove the `where` operator from the query if it exists. 

1. Select **Run** to return the results.

:::image type="content" source="media/log-analytics-tutorial/query-time-range.png" alt-text="Screenshot that shows the time range selector sin Log Analytics." lightbox="media/log-analytics-tutorial/query-time-range.png":::

**Verification:** The records count in the lower-right corner might not be smaller than the previous 24-hour result because of the **Show** limit configured. 

### Apply multiple query filters

Reduce the results further by adding a filter condition. A query can include any number of filters to target exactly the records that you want.

1. Toggle from **KQL mode** to **Simple mode** by selecting the mode dropdown at the top right of the query editor. In Simple mode, add filters without writing KQL syntax.

1. Select the **Add** filters icon to the right of the **Show** limit.

1. Select the **Name** filter. The default operator is **Select from list** which shows values based on the records in your current results. 

1. Select **GET Home/Index**. If you don't see expected values, try expanding the time range, increasing the show limit or removing other filters to ensure those records are included in the results.

    :::image type="content" source="media/log-analytics-tutorial/query-multiple-filters.png" alt-text="Screenshot that shows query results with multiple filters." lightbox="media/log-analytics-tutorial/query-multiple-filters.png":::

1. Toggle back to **KQL mode** and view the KQL syntax for the filters you applied. The query should now include a `where` operator with conditions for the `Name` column.

**Verification:** The record count decreases compared to the unfiltered query. All visible records in the **Name** column show **GET Home/Index**.

## Analyze query results

Log Analytics provides features for working with the results beyond running queries.

### Expand and sort records

1. Expand a record to view the values for all of its columns by selecting the chevron (**>**) on the left side of the row.

1. Select any column header to sort the results by that column. Select the same header again to toggle between ascending, descending and default order.

    :::image type="content" source="media/log-analytics-tutorial/sort-query-results.png" alt-text="Screenshot that shows query results being sorted by the TimeGenerated column and a record expanded." lightbox="media/log-analytics-tutorial/sort-query-results.png":::

### Filter from column headers

The results table supports Excel-like filtering from column headers. Use this method for quick interactive analysis.

1. Select the ellipse (**...**) next to the **DurationMs** column header. This selection displays a filter tab and column options tab. Filters configured here clear when you rerun the query. 

1. Set the filter there to limit the records to application requests that took more than **150** milliseconds.

    :::image type="content" source="media/log-analytics-tutorial/expand-query-search-result.png" alt-text="Screenshot that shows a record expanded in the search results." lightbox="media/log-analytics-tutorial/expand-query-search-result.png":::

**Verification:** After applying the DurationMs filter, all visible records show a **DurationMs** value greater than 150. The record count decreases.

### Search through query results

Search through the query results by using the search box at the top right of the results pane.

1. Enter **Texas** in the query results search box.

1. Select the down arrow to find the next instance of this string in your search results.

:::image type="content" source="media/log-analytics-tutorial/search-query-results.png" alt-text="Screenshot that shows the search box at the top right of the result pane." lightbox="media/log-analytics-tutorial/search-query-results.png":::

**Verification:** Matching text is highlighted in the results. The arrow navigation indicates the total number of matches (for example, "2/12").

> [!NOTE]
> The search box only filters the displayed results in the browser and doesn't modify the KQL query or re-fetch data from the server.

### Reorganize and summarize data

Reorganize and summarize the data in the query results to improve visualization.

1. Select **Columns** to the right of the results pane to open the **Columns** sidebar.

1. Drag the **Url** column into the **Row Groups** section. Results are now organized by that column, and you can collapse each group.

    This action processes the data your original query returned - it doesn't re-fetch data from the server. When you rerun the query, Log Analytics retrieves data based on your original query.

    :::image type="content" source="media/log-analytics-tutorial/query-results-grouped.png" alt-text="Screenshot that shows query results grouped by URL." lightbox="media/log-analytics-tutorial/query-results-grouped.png":::

**Verification:** Results appear in collapsible groups with a URL header for each group. Select a group header to expand or collapse it.

### Create a pivot table

To analyze the performance of your pages, create a pivot table:

1. In the **Columns** sidebar, select **Pivot Mode**.

1. Select **Url** and **DurationMs** to show the total duration of all calls to each URL.

1. To view the maximum call duration to each URL, select **sum(DurationMs)** and then select **max**.

    :::image type="content" source="media/log-analytics-tutorial/log-analytics-pivot-table.png" alt-text="Screenshot that shows how to turn on Pivot Mode and configure a pivot table based on the URL and DurationMS values." lightbox="media/log-analytics-tutorial/log-analytics-pivot-table.png":::

1. Sort the results by the longest maximum call duration by selecting the **max(DurationMs)** column header in the results pane.

**Verification:** The pivot table shows one row per URL with a **max(DurationMs)** value. Results are sorted with the highest duration at the top.

## Visualize query results as charts

View a query that uses numerical data as a chart. Instead of building a query, use an example query from the built-in query library.

1. Clear the query editor of any existing text or open a new query tab by selecting the plus icon next to the current query tab.

1. Select **Queries** on the left pane. This pane includes example queries to load to the query editor. If you're using your own workspace, you'll find various queries in multiple categories.

1. Find the **Response time trend** query in the **Applications** category. To load it, double-click the query or hover over the query name to show more information and then select **Load to editor**. A blank line separates the new query from any previous query. In KQL, a blank line marks the end of a query, so each query in the editor runs independently. 

1. Place your cursor anywhere in the new query and select **Run**.

    :::image type="content" source="media/log-analytics-tutorial/example-query-output-chart.png" alt-text="Screenshot that shows the query results chart." lightbox="media/log-analytics-tutorial/example-query-output-chart.png":::

1. Toggle the **Results** tab or change the **Chart formatting** to explore other options.

**Verification:** The chart displays a time-series line graph with hourly data points. The Y-axis shows the average response duration in milliseconds. If you see a spike in the data, investigate further by adjusting the time range.

To get notified when spikes occur, create an alert rule. Open the (**...**) next to **Queries hub** in the action bar and select **+ New alert rule**. For more information, see [Tutorial: Create a log search alert for an Azure resource](../alerts/tutorial-log-alert.md). Creating an alert rule isn't supported in the demo environment, but you can still explore the option to see how it works.

## Export and copy results

After running a query, export or copy the results for use outside Log Analytics. From the **Share** menu in the action bar:

- **Copy link to query:** Creates a link to the current query that you can share with others who have access to the same workspace.
- **Copy query text:** Selects the query text in the editor to your clipboard. 

These features don't work in the demo environment because the demo doesn't have a unique URL or save queries, but you can try them in your own environment.

- **Copy results:** Select rows in the results pane, right-click, and select **Copy** or use **Ctrl+C**. Paste the data into a spreadsheet or text editor.
- **Export to CSV - all columns** or **Export to CSV - displayed columns** to download the data.
- **Export to Power BI (as an M query)** or **Export to Power BI (new Dataset)** to open the data in Power BI for further analysis and visualization.
- **Open in Excel:** Exports the data and opens it in Excel. This option is only available if you have Excel installed on your machine.

From the **Save** menu in the action bar are options to save the query or pin a visual to a dashboard. To learn how to pin visuals to a shared dashboard, see [Create and share dashboards that visualize data in Azure Monitor Logs](../visualize/tutorial-logs-dashboards.md).

## Troubleshoot common issues

| Problem | Possible cause | Solution |
|---|---|---|
| Demo environment doesn't load | Browser blocks pop-ups or third-party cookies. | Allow pop-ups for `portal.azure.com`. Try a private or incognito browser window. |
| AppRequests table not visible | The workspace doesn't have Application Insights data. | Use the demo environment, or [connect an Application Insights resource](../app/create-workspace-resource.md) to your workspace. |
| Query returns zero results | The selected time range has no data, or the filter is too narrow. | Expand the time range (for example, **Last 7 days**). Remove filters to verify data exists. |
| "No access" error on workspace | Your account doesn't have read permissions on the workspace. | Ask your administrator to assign the **Log Analytics Reader** role. See [Manage access to log data and workspaces](./manage-access.md). |
| Chart tab shows "No chart available" | The query doesn't return time-series or numerical data suitable for charting. | Ensure your query includes a `summarize` operator with a `bin(TimeGenerated, ...)` clause. |
| Filter tab is empty | Filters aren't loaded for the current query results. | Run a query first. Then select the **Filter** tab and choose the refresh or reload option to populate filter values. |
| DurationMs filter shows no results with > 150 ms | Your workspace data has uniformly low response times. | Lower the threshold (for example, try **> 5** ms) or use the demo environment, which has varied response times. |
| Pivot Mode option not visible | The **Columns** sidebar isn't open. | Select **Columns** to the right of the results pane to open the sidebar > select **Pivot Mode**. |

## Next step

Now that you know how to use Log Analytics, complete the tutorial on using log queries:
> [!div class="nextstepaction"]
> [Write Azure Monitor log queries](get-started-queries.md)
