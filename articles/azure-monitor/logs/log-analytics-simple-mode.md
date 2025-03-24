---
title: Analyze data using Log Analytics simple mode
description: This article explains how to use Log Analytics simple mode to explore and analyze data in Azure Monitor Logs.
ms.topic: conceptual
ms.reviewer: noyablanga
ms.date: 02/02/2025

# Customer intent: As an analyst or DevOps troubleshooter, I want to get insights from log data without using Kusto Query Language (KQL).

---

# Analyze data using Log Analytics simple mode

Log Analytics simple mode offers an intuitive point-and-click interface for analyzing and visualizing log data. You can effortlessly [switch between simple and KQL modes](#switch-modes), and set Log Analytics to [open in simple mode by default](./log-analytics-overview.md#more-tools).

This article explains how to use Log Analytics simple mode to explore and analyze data in Azure Monitor Logs.

## Tutorial video

> [!NOTE]
> This video shows an earlier version of the user interface, but the screenshots throughout this article are up to date and reflect the current UI.

<br>

>[!VIDEO https://www.youtube.com/embed/85Xxj5FhTk0?cc_load_policy=1&cc_lang_pref=auto]

## How simple mode works

Simple mode lets you [get started quickly by retrieving data from one or more tables with one click](#get-started-in-simple-mode). You then use a set of intuitive controls to [explore and analyze the retrieved data](#explore-and-analyze-data-in-simple-mode).

## Get started in simple mode

In simple mode, you can retrieve logs with one click whether you open Log Analytics in resource or workspace context.

When you select a table or a predefined query or function in simple mode, Log Analytics automatically retrieves the relevant data for you to explore and analyze.

To get started, you can:

* Click **Select a table** and select a table from the **Tables** tab to view table data.

    :::image type="content" source="media/log-analytics-explorer/log-analytics-select-table.png" alt-text="Screenshot that shows the Select a table button in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-select-table.png":::

    Alternatively, select **Tables** from the left pane to view the list of tables in the workspace.

    :::image type="content" source="media/log-analytics-explorer/log-analytics-tables.png" alt-text="Screenshot that shows the Tables tab in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-tables.png":::

* Use an existing query, such as a shared or [saved query](../logs/save-query.md), or an example query.

    :::image type="content" source="media/log-analytics-explorer/log-analytics-simple-mode-example-query.png" alt-text="Screenshot that shows an example query in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-simple-mode-example-query.png":::

* Select a query from your query history.

    :::image type="content" source="media/log-analytics-explorer/log-analytics-query-history.png" alt-text="Screenshot that shows the query history in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-query-history.png":::

* Select a [function](../logs/functions.md).

    :::image type="content" source="media/log-analytics-explorer/log-analytics-functions.png" alt-text="Screenshot that shows the functions tab in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-functions.png":::

    > [!IMPORTANT]
    > Functions let you reuse query logic and often require input parameters or additional context. In such cases, the function won't run until you switch to KQL mode and provide the required input.
  
## Explore and analyze data in simple mode

After you [get started in simple mode](#get-started-in-simple-mode), you can explore and analyze data using the [top query bar](./log-analytics-overview.md#top-action-bar).

> [!NOTE]
> The order in which you apply filters and operators affects your query and results. For example, if you apply a filter and then aggregate, Log Analytics applies the aggregation to the filtered data. If you aggregate and then filter, the aggregation is applied to the unfiltered data.

#### Change time range and number of records displayed

By default, simple mode lists the latest 1,000 entries in the table from the last 24 hours.

To change the time range and number of records displayed, use the **Time range** and **Show** selectors. For more information about result limit, see [Configure query result limit](#configure-query-result-limit).
    
:::image type="content" source="media/log-analytics-explorer/log-analytics-time-range-limit.png" alt-text="Screenshot that shows the time range and limit selectors in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-time-range-limit.png":::

> [!NOTE]
> The time range you set is applied at the end of the query and doesn't change the amount of data being queried.

#### Filter by column

1. Select **Add** and choose a column.

    :::image type="content" source="media/log-analytics-explorer/log-analytics-add-filter.png" alt-text="Screenshot that shows the Add filters menu that opens when you select Add in Log Analytics simple mode." lightbox="media/log-analytics-explorer/log-analytics-add-filter.png":::

1. Select a value to filter by, or enter text or numbers in the **Search** box.

    If you filter by selecting values from a list, you can select multiple values. If the list is long, you see a **Not all results are shown** message. Scroll to the bottom of the list and select **Load more results** to retrieve more values.
    
    :::image type="content" source="media/log-analytics-explorer/log-analytics-filter.png" alt-text="Screenshot that shows filter values for the OperationId column in Log Analytics simple mode." lightbox="media/log-analytics-explorer/log-analytics-filter.png":::

#### Search for entries that have a specific value in the table

1. Select **Add** > **Search in table**.

    :::image type="content" source="media/log-analytics-explorer/log-analytics-search.png" alt-text="Screenshot that shows the Search option in Log Analytics simple mode." lightbox="media/log-analytics-explorer/log-analytics-search.png":::

1. Enter a string in the **Search this table** box and select **Apply**.

    Log Analytics filters the table to show only entries that contain the string you entered.

> [!IMPORTANT]
> We recommend using **Filter** if you know which column holds the data you're searching for. The [search operator is substantially less performant](../logs/query-optimization.md#avoid-unnecessary-use-of-search-and-union-operators) than filtering, and might not function well on large volumes of data.

#### Aggregate data

1. Select **Add** > **Aggregate**.

1. Select a column to aggregate by and select an operator to aggregate by, as described in [Use aggregation operators](#use-aggregation-operators).

    :::image type="content" source="media/log-analytics-explorer/log-analytics-aggregate.png" alt-text="Screenshot that shows the aggregation operators in the Aggregate table window in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-aggregate.png":::

#### Show or hide columns

1. Select **Add** > **Show columns**.

1. Select or clear columns to show or hide them, then select **Apply**.

    :::image type="content" source="media/log-analytics-explorer/log-analytics-show-column.png" alt-text="Screenshot that shows the Show columns window in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-show-column.png":::

#### Sort by column

1. Select **Add** > **Sort**.

1. Select a column to sort by.

1. Select **Ascending** or **Descending**, then select **Apply**.

    :::image type="content" source="media/log-analytics-explorer/log-analytics-sort.png" alt-text="Screenshot that shows the Sort by column window in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-sort.png":::

1. Select **Sort** again to sort by another column.

### Use aggregation operators

Use aggregation operators to summarize data from multiple rows, as described in this table.

| Operator | Description |
|:---------|:------------|
| [count](/azure/data-explorer/kusto/query/count-operator) | Counts the number of times each distinct value exists in the column. |
| [dcount](/azure/data-explorer/kusto/query/dcount-aggfunction) | For the `dcount` operator, you select two columns. The operator counts the total number of distinct values in the second column correlated to each value in the first column. For example, this shows the distinct number of result codes for successful and failed operations:<br/> :::image type="content" source="media/log-analytics-explorer/log-analytics-dcount.png" alt-text="Screenshot that shows the result of an aggregation using the dcount operator in Azure Monitor Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-dcount.png"::: |
| [sum](/azure/data-explorer/kusto/query/sum-aggregation-function)<br/>[avg](/azure/data-explorer/kusto/query/avg-aggregation-function)<br/>[max](/azure/data-explorer/kusto/query/max-aggregation-function)<br/>[min](/azure/data-explorer/kusto/query/min-aggregation-function) | For these operators, you select two columns. The operators calculate the sum, average, maximum, or minimum of all values in the second column for each value in the first column. For example, this shows the total duration of each operation in milliseconds for the past 24 hours:<br/>:::image type="content" source="media/log-analytics-explorer/log-analytics-sum.png" alt-text="Screenshot that shows the results of an aggregation using the sum operator in Azure Monitor Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-sum.png"::: |
| [stdev](/kusto/query/stdev-aggregation-function) | Calculates the standard deviation of a set of values. |

> [!IMPORTANT]
> Basic logs tables don't support aggregation using the `avg` and `sum` operators.

## Switch modes

To switch modes, select **Simple mode** or **KQL mode** from the dropdown in the top right corner of the query editor.

:::image type="content" source="media/log-analytics-explorer/log-analytics-switch-modes-Simple.png" alt-text="Screenshot that shows how to toggle between simple mode and KQL mode in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-switch-modes-simple.png":::

When you begin to query logs in simple mode and then switch to KQL mode, the query editor is prepopulated with the KQL query related to your simple mode analysis. You can then edit and continue working with the query.

:::image type="content" source="media/log-analytics-explorer/log-analytics-switch-modes-kql.png" alt-text="Screenshot that shows a query in Log Analytics KQL mode." lightbox="media/log-analytics-explorer/log-analytics-switch-modes-kql.png":::

For straightforward queries on a single table, Log Analytics displays the table name at the right of the top query bar in simple mode. For more complex queries, Log Analytics displays **User Query** at the left of the top query bar. Select **User Query** to return to the query editor and modify your query at any time.

:::image type="content" source="media/log-analytics-explorer/log-analytics-switch-modes-user-query.png" alt-text="Screenshot that shows the User Query button, which lets you return to the query editor when you're in simple mode." lightbox="media/log-analytics-explorer/log-analytics-switch-modes-user-query.png":::

## Configure query result limit

1. Select **Show** to open the **Show results** window.

    :::image type="content" source="media/log-analytics-explorer/log-analytics-result-limits.png" alt-text="Screenshot that shows the limit results window in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-result-limits.png":::

1. Select one of the preset limits, or enter a custom limit.
 
    The maximum number of results that you can retrieve in the Log Analytics portal experience, in both simple mode and KQL mode, is 30,000. However, when you [share a Log Analytics query](./log-analytics-overview.md#more-tools) with an integrated tool, or use the query in a [search job](search-jobs.md), the query limit is set based on the tools you choose.

    Select **Max. limit** to return the maximum number of results provided by any of the tools available on the **Share** window or using a search job.

    :::image type="content" source="media/log-analytics-explorer/log-analytics-share-query.png" alt-text="Screenshot that shows the Share window in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-share-query.png":::

    This table lists the maximum result limits of Azure Monitor log queries using the various tools:

| Tool | Description | Max. limit |
|------|-------------|------------|
| Log Analytics | Queries you run in the Azure portal. | 30,000 |
| [Excel](../logs/log-excel.md), [Power BI](../logs/log-powerbi.md), [Log Analytics Query API](../logs/api/overview.md) | Queries you use in Excel and Power BI, which are integrated with Log Analytics, and queries you run using the API. |500,000 |
| [Search job](search-jobs.md) | Azure Monitor reingests the results of a query your run in search job mode into a new table in your Log Analytics. |1,000,000 |

## Next steps

* Walk through a [tutorial on using KQL mode in Log Analytics](../logs/log-analytics-tutorial.md).
* Access the complete [reference documentation for KQL](/azure/kusto/query/).
