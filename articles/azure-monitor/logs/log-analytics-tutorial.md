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

Log Analytics is a tool in the Azure portal for querying and analyzing data collected by [Azure Monitor Logs](data-platform-logs.md). When you need to troubleshoot an issue, investigate a performance trend, or understand how your Azure resources behave, you use Log Analytics to write and run [log queries](log-query-overview.md).

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
> Log Analytics has two modes: Simple and KQL. *This tutorial uses KQL mode.* If you prefer a point-and-select interface instead of writing KQL queries, see [Analyze data using Log Analytics Simple mode](log-analytics-simple-mode.md).

> [!IMPORTANT]
> This tutorial uses Log Analytics features to build one query and use another example query. When you're ready to learn the syntax of queries and start directly editing the query itself, read the [Kusto Query Language (KQL) tutorial](/azure/data-explorer/kusto/query/tutorial?pivots=azuremonitor). That tutorial walks you through example queries that you can edit and run in Log Analytics. It uses several of the features that you learn in this tutorial.

## Open Log Analytics

Open the [Log Analytics demo environment](https://portal.azure.com/#blade/Microsoft_Azure_Monitoring_Logs/DemoLogsBlade), or select **Logs** from the Azure Monitor menu in your subscription. This step sets the initial scope to a Log Analytics workspace so that your query selects from all data in that workspace. If you select **Logs** from an Azure resource's menu, the scope is set to only records from that resource. For more information, see [Log query scope](./scope.md).

The scope appears in the upper-left corner of the Logs experience, below the name of your active query tab. If you're using your own environment, you see an option to select a different scope. This option isn't available in the demo environment.

:::image type="content" source="media/log-analytics-tutorial/log-analytics-query-scope.png" alt-text="Screenshot that shows the Log Analytics scope for the demo." lightbox="media/log-analytics-tutorial/log-analytics-query-scope.png":::

> [!TIP]
> **CLI alternative:** Query a Log Analytics workspace by using the Azure CLI. Replace `<workspace-id>` with your workspace GUID:
>
> ```azurecli
> az monitor log-analytics query --workspace "<workspace-id>" --analytics-query "AppRequests | take 5" --timespan "P1D" -o table
> ```

**Verification:** Confirm the query editor is visible and the scope displays your workspace name or "Demo-Workspace" in the upper-left corner.

## View table information

The left side of the screen includes the **Tables** tab, where you inspect the tables available in the current scope. These tables are grouped by **Solution** by default, but you can change their grouping or filter them.

1. Expand the **Log Management** solution and locate the **AppRequests** table. Expand the table to view its schema, or hover over its name to show more information about it.

    :::image type="content" source="media/log-analytics-tutorial/table-details.png" alt-text="Screenshot that shows the Tables view in Log Analytics." lightbox="media/log-analytics-tutorial/table-details.png":::

1. Select the link below **Useful links** (in this example, [AppRequests](/azure/azure-monitor/reference/tables/AppRequests)) to go to the table reference that documents each table and its columns.

1. Select **Preview data** to see a few recent records in the table. This preview helps you verify the data before you run a query.

    :::image type="content" source="media/log-analytics-tutorial/preview-data.png" alt-text="Screenshot that shows preview data for the AppRequests table." lightbox="media/log-analytics-tutorial/preview-data.png":::

**Verification:** The preview pane shows records with columns like **Name**, **Url**, **DurationMs**, **ResultCode**, and **ClientCity**. If the AppRequests table doesn't appear under **Log Management**, your workspace might not have Application Insights data configured.

> [!TIP]
> **CLI alternative:** To view the schema of the AppRequests table via the Azure CLI:
>
> ```azurecli
> az monitor log-analytics query --workspace "<workspace-id>" --analytics-query "AppRequests | getschema | project ColumnName, DataType" --timespan "P1D" -o table
> ```

## Write a query

Write a query by using the **AppRequests** table:

1. Double-click the table name, or hover over it and select **Use in editor** to add it to the query window. Alternatively, type `AppRequests` directly in the window. IntelliSense helps complete the names of tables in the current scope and KQL commands.

1. Select the **Run** button or press **Shift+Enter** with the cursor positioned anywhere in the query text. This is the simplest possible query — it returns all records in the table.

    :::image type="content" source="media/log-analytics-tutorial/query-results.png" alt-text="Screenshot that shows query results in Log Analytics." lightbox="media/log-analytics-tutorial/query-results.png":::

**Verification:** Check the lower-right corner of the results pane. You should see a record count greater than zero. For information about the maximum number of results, see [Configure query result limit](./log-analytics-simple-mode.md#configure-query-result-limit).

> [!TIP]
> To learn how to author your own queries, see [Get started with log queries in Azure Monitor Logs](get-started-queries.md).

### Set the query time range

All queries return records generated within a set time range. By default, the time picker is set to the last 24 hours. Set a different time range by using the **Time range** dropdown at the top of the screen, or add a [where operator](/azure/data-explorer/kusto/query/tutorial?pivots=azuremonitor#filter-by-condition) to the query. If you use both, Log Analytics applies the smaller of the two time ranges. For details, see [Specify a time range](get-started-queries.md#specify-a-time-range).

Change the time range by selecting **Last 12 hours** from the **Time range** dropdown. Select **Run** to return the results.

> [!NOTE]
> Changing the time range by using the **Time range** dropdown doesn't change the query in the query editor. The time range is applied as a separate filter outside the query text.

:::image type="content" source="media/log-analytics-tutorial/query-time-range.png" alt-text="Screenshot that shows the time range selector in Log Analytics." lightbox="media/log-analytics-tutorial/query-time-range.png":::

**Verification:** The record count in the lower-right corner should be smaller than the previous 24-hour result. If it's the same, the workspace might have limited data.

> [!TIP]
> **CLI alternative:** Specify the time range with the `--timespan` parameter using ISO 8601 duration format:
>
> ```azurecli
> az monitor log-analytics query --workspace "<workspace-id>" --analytics-query "AppRequests" --timespan "PT12H" -o table
> ```

### Apply multiple query filters

Reduce the results further by adding a filter condition. A query can include any number of filters to target exactly the records that you want.

1. On the left side of the screen, select the **Filter** tab (next to the **Tables** tab). If you don't see it, select the ellipsis (**...**) to view more tabs.

1. On the **Filter** tab, select **Add filter** or the refresh option to load the available filter values.

    :::image type="content" source="media/log-analytics-tutorial/load-old-filters.png" alt-text="Screenshot that shows the query tab with filter options." lightbox="media/log-analytics-tutorial/load-old-filters.png":::

1. Select **GET Home/Index** under **Name**, then select **Apply & Run**.

    :::image type="content" source="media/log-analytics-tutorial/query-multiple-filters.png" alt-text="Screenshot that shows query results with multiple filters." lightbox="media/log-analytics-tutorial/query-multiple-filters.png":::

**Verification:** The record count should decrease compared to the unfiltered query. All visible records in the **Name** column should show **GET Home/Index**.

> [!TIP]
> **CLI alternative:** Add a `where` clause in KQL for the same filter result:
>
> ```kusto
> AppRequests
> | where Name == "GET Home/Index"
> ```

## Analyze query results

Log Analytics provides features for working with the results beyond running queries.

### Expand and sort records

1. Expand a record to view the values for all of its columns by selecting the chevron (**>**) on the left side of the row.

    :::image type="content" source="media/log-analytics-tutorial/expand-query-search-result.png" alt-text="Screenshot that shows a record expanded in the search results." lightbox="media/log-analytics-tutorial/expand-query-search-result.png":::

1. Select any column header to sort the results by that column. Select the filter icon next to it to set a filter condition. This filter clears when you rerun the query. Use this method for quick interactive analysis.

1. Set a filter on the **DurationMs** column to limit the records to those that took more than **150** milliseconds.

**Verification:** After applying the DurationMs filter, all visible records should show a **DurationMs** value greater than 150. The record count decreases.

### Filter from column headers

The results table supports Excel-like filtering from column headers:

1. Select the ellipsis (**...**) in the **Name** column header.

1. Clear **Select All**, then search for **GET Home/Index** and select it. The filter applies automatically.

:::image type="content" source="media/log-analytics-tutorial/query-results-filter.png" alt-text="Screenshot that shows a query results filter." lightbox="media/log-analytics-tutorial/query-results-filter.png":::

**Verification:** Only rows with the **Name** value **GET Home/Index** appear in the results. The column header shows a filter icon.

### Search through query results

Search through the query results by using the search box at the top right of the results pane.

1. Enter **Chicago** in the query results search box.

1. Select the arrows to find all instances of this string in your search results.

:::image type="content" source="media/log-analytics-tutorial/search-query-results.png" alt-text="Screenshot that shows the search box at the top right of the result pane." lightbox="media/log-analytics-tutorial/search-query-results.png":::

**Verification:** Matching text is highlighted in the results. The arrow navigation indicates the total number of matches (for example, "1 of 5").

> [!NOTE]
> The search box filters the displayed results in the browser — it doesn't modify the KQL query or re-fetch data from the server.

### Reorganize and summarize data

Reorganize and summarize the data in the query results to improve visualization.

1. Select **Columns** to the right of the results pane to open the **Columns** sidebar.

    :::image type="content" source="media/log-analytics-tutorial/query-results-columns.png" alt-text="Screenshot that shows the Column link to the right of the results pane, which you select to open the Columns sidebar." lightbox="media/log-analytics-tutorial/query-results-columns.png":::

1. Drag the **Url** column into the **Row Groups** section. Results are now organized by that column, and you can collapse each group.

    This action processes the data your original query returned — it doesn't re-fetch data from the server. When you rerun the query, Log Analytics retrieves data based on your original query.

    :::image type="content" source="media/log-analytics-tutorial/query-results-grouped.png" alt-text="Screenshot that shows query results grouped by URL." lightbox="media/log-analytics-tutorial/query-results-grouped.png":::

**Verification:** Results appear in collapsible groups with a URL header for each group. Select a group header to expand or collapse it.

> [!TIP]
> **KQL equivalent:** Achieve similar grouping directly in KQL:
>
> ```kusto
> AppRequests
> | summarize count() by Url
> ```

### Create a pivot table

To analyze the performance of your pages, create a pivot table:

1. In the **Columns** sidebar, select **Pivot Mode**.

1. Select **Url** and **DurationMs** to show the total duration of all calls to each URL.

1. To view the maximum call duration to each URL, select **sum(DurationMs)** and then select **max**.

    :::image type="content" source="media/log-analytics-tutorial/log-analytics-pivot-table.png" alt-text="Screenshot that shows how to turn on Pivot Mode and configure a pivot table based on the URL and DurationMS values." lightbox="media/log-analytics-tutorial/log-analytics-pivot-table.png":::

1. Sort the results by the longest maximum call duration by selecting the **max(DurationMs)** column header in the results pane.

    :::image type="content" source="media/log-analytics-tutorial/sort-pivot-table.png" alt-text="Screenshot that shows the query results pane being sorted by the maximum DurationMS values." lightbox="media/log-analytics-tutorial/sort-pivot-table.png":::

**Verification:** The pivot table shows one row per URL with a **max(DurationMs)** value. Results are sorted with the highest duration at the top.

> [!TIP]
> **KQL equivalent:** Create the same pivot table result in KQL:
>
> ```kusto
> AppRequests
> | summarize max(DurationMs) by Url
> | order by max_DurationMs desc
> ```

## Visualize query results as charts

View a query that uses numerical data as a chart. Instead of building a query, use an example query from the built-in query library.

1. Select **Queries** on the left pane. This pane includes example queries that you can add to the query window. If you're using your own workspace, you should have various queries in multiple categories.

1. Find the **Response time trend** query in the **Applications** category. To load it, double-click the query or hover over the query name to show more information and then select **Load to editor**.

    :::image type="content" source="media/log-analytics-tutorial/query-info.png" alt-text="Screenshot that shows info about the query." lightbox="media/log-analytics-tutorial/query-info.png":::

    The query is similar to the following KQL:

    ```kusto
    AppRequests
    | summarize avg(DurationMs) by bin(TimeGenerated, 1h)
    | order by TimeGenerated asc
    ```

1. The new query is separated from any previous query by a blank line. A query in KQL ends when it encounters a blank line, making them separate queries. Place your cursor anywhere in the new query and select **Run**.

1. To view the results as a graph, select **Chart** on the results pane. Change the chart type or configure other options as needed.

    :::image type="content" source="media/log-analytics-tutorial/example-query-output-chart.png" alt-text="Screenshot that shows the query results chart." lightbox="media/log-analytics-tutorial/example-query-output-chart.png":::

**Verification:** The chart displays a time-series line graph with hourly data points. The Y-axis shows the average response duration in milliseconds. If you see a spike in the data, investigate further by adjusting the time range.

To get notified when spikes occur, create an alert rule by opening the context menu (**...**) in the action bar and selecting **+ New alert rule**. For more information, see [Tutorial: Create a log search alert for an Azure resource](../alerts/tutorial-log-alert.md).

> [!NOTE]
> Creating an alert rule is not supported in the demo environment.

## Export and copy results

After you run a query, export or copy the results for use outside Log Analytics:

- **Export to CSV:** Select **Export** in the results toolbar, then select **Export to CSV - all columns** or **Export to CSV - displayed columns** to download the data.
- **Copy results:** Select rows in the results pane, then right-click and select **Copy** or use **Ctrl+C**. You can paste the data into a spreadsheet or text editor.
- **Copy query:** Select the query text in the editor and press **Ctrl+C** to copy it. You can share the query with colleagues or save it for later use.
- **Pin to dashboard:** Select **Pin to dashboard** in the action bar to add the results visual to an Azure dashboard.

> [!TIP]
> To learn how to pin visuals to a shared dashboard, see [Create and share dashboards that visualize data in Azure Monitor Logs](../visualize/tutorial-logs-dashboards.md).

**Verification:** After exporting to CSV, a file downloads to your browser's default download location. Open the file to verify it contains the query results.

## Troubleshoot common issues

| Problem | Possible cause | Solution |
|---|---|---|
| Demo environment doesn't load | Browser blocks pop-ups or third-party cookies. | Allow pop-ups for `portal.azure.com`. Try a private/incognito browser window. |
| AppRequests table not visible | The workspace doesn't have Application Insights data. | Use the demo environment, or [connect an Application Insights resource](../app/create-workspace-resource.md) to your workspace. |
| Query returns zero results | The selected time range has no data, or the filter is too narrow. | Expand the time range (for example, **Last 7 days**). Remove filters to verify data exists. |
| "No access" error on workspace | Your account doesn't have read permissions on the workspace. | Ask your administrator to assign the **Log Analytics Reader** role. See [Manage access to log data and workspaces](./manage-access.md). |
| Chart tab shows "No chart available" | The query doesn't return time-series or numerical data suitable for charting. | Ensure your query includes a `summarize` operator with a `bin(TimeGenerated, ...)` clause. |
| Filter tab is empty | Filters haven't been loaded for the current query results. | Run a query first. Then select the **Filter** tab and choose the refresh or reload option to populate filter values. |
| DurationMs filter shows no results with > 150 ms | Your workspace data has uniformly low response times. | Lower the threshold (for example, try **> 5** ms) or use the demo environment, which has varied response times. |
| Pivot Mode option not visible | The **Columns** sidebar isn't open. | Select **Columns** to the right of the results pane to open the sidebar, then select **Pivot Mode**. |

## Next step

Now that you know how to use Log Analytics, complete the tutorial on using log queries:
> [!div class="nextstepaction"]
> [Write Azure Monitor log queries](get-started-queries.md)