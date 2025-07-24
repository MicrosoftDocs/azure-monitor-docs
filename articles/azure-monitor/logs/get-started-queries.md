---
title: Get started with log queries in Azure Monitor Logs
description: This article provides a tutorial for getting started writing log queries in Azure Monitor Logs.
ms.topic: tutorial
ms.reviewer: ilanawaitser
ms.date: 01/08/2025

---

# Get started with log queries in Azure Monitor Logs

This article explains the fundamentals of writing log queries in Azure Monitor Logs, including how to:

* [Structure a query](#structure-a-query).
* [Sort query results](#sort-results).
* [Filter query results](#filter-results).
* [Specify a time range](#specify-a-time-range).
* [Include or exclude columns in query results](#include-or-exclude-columns-in-query-results).
* [Define and use custom fields](#define-and-use-custom-fields).
* [Aggregate and group results](#aggregate-and-group-results).

Where applicable, the article provides examples of querying data using both Kusto Query Language (KQL) and [Log Analytics simple mode](log-analytics-simple-mode.md).

> [!NOTE]
> If you're collecting data from at least one virtual machine, you can work through this exercise in your own environment. For other scenarios, use our [demo environment](https://portal.azure.com/#blade/Microsoft_Azure_Monitoring_Logs/DemoLogsBlade), which includes plenty of sample data.

## Tutorial video

> [!NOTE]
> This video shows an earlier version of the user interface, but the screenshots throughout this article are up to date and reflect the current UI.

<br>

> [!VIDEO https://learn-video.azurefd.net/vod/player?id=ea873b8b-3e6e-4459-989b-26a2b664acae]

[!INCLUDE [log-analytics-query-permissions](includes/log-analytics-query-permissions.md)]

## Structure a query

Queries can start with either a table name or the `search` command. It's a good idea to start with a table name because it defines a clear scope for the query. It also improves query performance and the relevance of the results.

> [!NOTE]
> KQL, which is used by Azure Monitor, is case sensitive. Language keywords are usually written in lowercase. When you use names of tables or columns in a query, be sure to use the correct case, as shown on the schema pane.

### Table-based queries

Azure Monitor organizes log data in tables, each composed of multiple columns. All tables and columns are shown on the schema pane in Log Analytics in the Azure portal.

Identify a table that you're interested in, then take a look at a bit of data:

```Kusto
SecurityEvent
| take 10
```

The preceding query returns 10 results from the `SecurityEvent` table, in no specific order. This common way to get a glance at a table helps you to understand its structure and content. Let's examine how it's built:

* The query starts with the table name `SecurityEvent`, which defines the scope of the query.
* The pipe (|) character separates commands, so the output of the first command is the input of the next. You can add any number of piped elements.
* Following the pipe is the `take` operator. We could run the query even without adding `| take 10`. The command would still be valid, but it could return up to 30,000 results.

### Search queries

Search queries are less structured. They're best suited for finding records that include a specific value in any of the columns of a certain table.

### [KQL mode](#tab/kql)

This query searches the `SecurityEvent` table for records that contain the phrase "Cryptographic." Of those records, 10 records are returned and displayed:

```Kusto
search in (SecurityEvent) "Cryptographic"
| take 10
```

If you omit the `in (SecurityEvent)` part and run only `search "Cryptographic"`, the search goes over *all* tables. The process would then take longer and be less efficient.

> [!IMPORTANT]
> Search queries are ordinarily slower than table-based queries because they have to process more data.

### [Simple mode](#tab/simple)

To search for records that include a specific value in any of their columns:

1. **Select a table** and chose `SecurityEvent`. 

1. Open **Add** > **Search in table**.

    :::image type="content" source="media/get-started-queries/logs-simple-search-add.png" lightbox="media/get-started-queries/logs-simple-search-add.png" alt-text="Screenshot shows the Add dropdown in simple mode with 'Search in table' highlighted.":::

1. Enter *Cryptographic*, then select **Apply**.

    :::image type="content" source="media/get-started-queries/logs-simple-search-select.png" lightbox="media/get-started-queries/logs-simple-search-select.png" alt-text="Screenshot shows the Search field in simple mode.":::

1. To only show 10 results, see [Limit results](#limit-results).

> [!IMPORTANT]
> We recommend using **Filter** if you know which column holds the data you're searching for. The [search operator is substantially less performant](../logs/query-optimization.md#avoid-unnecessary-use-of-search-and-union-operators) than filtering, and might not function well on large volumes of data.

---

## Limit results

## [KQL mode](#tab/kql)

Use the `take` operator to view a small sample of records by returning up to the specified number of records. For example:

```Kusto
SecurityEvent
| take 10
```

The selected results are arbitrary and displayed in no particular order. If you need to return results in a particular order, use the `sort` and `top` operators.

## [Simple mode](#tab/simple)

To return up to a specific number of records, you can limit the results:

1. Select **Show** to open the **Show results** window.

1. Pick one of the preset limits or enter a custom limit, then select **Apply**.

:::image type="content" source="media/get-started-queries/logs-simple-limit.png" lightbox="media/get-started-queries/logs-simple-limit.png" alt-text="Screenshot shows the Show dropdown in simple mode.":::

---

## Sort results

This section describes the `sort` and `top` operators and their `desc` and `asc` arguments. Although `take` is useful for getting a few records, you can't select or sort the results in any particular order. To get an ordered view, use `sort` and `top`.

### Sort

### [KQL mode](#tab/kql)

You can use the [`sort` operator](/azure/data-explorer/kusto/query/sort-operator) to sort the query results by the column you specify. However, `sort` doesn't limit the number of records that are returned by the query.

For example, the following query returns all available records for the `SecurityEvent` table, which is up to a maximum of 30,000 records, and sorts them by the TimeGenerated column.

```Kusto
SecurityEvent	
| sort by TimeGenerated
```

The preceding query could return too many results. Also, it might also take some time to return the results. The query sorts the entire `SecurityEvent` table by the `TimeGenerated` column. The Analytics portal then limits the display to only 30,000 records. This approach isn't optimal. The best way to only get the latest records is to use the [`top` operator](#top).

#### Desc and asc

Use the `desc` argument to sort records in descending order. Descending is the default sorting order for `sort` and `top`, so you can usually omit the `desc` argument.

For example, the data returned by both of the following queries is sorted by the [TimeGenerated column](./log-standard-columns.md#timegenerated), in descending order:

* ```Kusto
  SecurityEvent	
  | sort by TimeGenerated desc
  ```

* ```Kusto
  SecurityEvent	
  | sort by TimeGenerated
  ```

To sort in ascending order, specify `asc`.

### [Simple mode](#tab/simple)

To sort your results:

1. Open **Add** > **Sort**.

    :::image type="content" source="media/get-started-queries/logs-simple-sort-add.png" lightbox="media/get-started-queries/logs-simple-sort-add.png" alt-text="Screenshot shows the Add dropdown in simple mode with Sort highlighted.":::

1. Pick a column to sort by.

1. Choose **Ascending** or **Descending**, then select **Apply**.

    :::image type="content" source="media/get-started-queries/logs-simple-sort-select.png" lightbox="media/get-started-queries/logs-simple-sort-select.png" alt-text="Screenshot shows the Sort field in simple mode.":::

1. Open **Add** > **Sort** again to sort by another column.

---

### Top

### [KQL mode](#tab/kql)

Use the [`top` operator](/azure/data-explorer/kusto/query/topoperator) to sort the entire table on the server side and then only return the top records. 

For example, the following query returns the latest 10 records:

```Kusto
SecurityEvent
| top 10 by TimeGenerated
```

The output looks like this example:

:::image type="content" source="media/get-started-queries/logs-kql-top.png" lightbox="media/get-started-queries/logs-kql-top.png" alt-text="Screenshot that shows the top 10 records sorted in descending order.":::

### [Simple mode](#tab/simple)

In simple mode, there's no direct equivalent to the `top` operator. Instead, you can sort a column and then limit the results.

---

## Filter results

Filtering is the most common way to limit query results to relevant information.

## [KQL mode](#tab/kql)

To add a filter to a query, use the [`where` operator](/azure/data-explorer/kusto/query/whereoperator) followed by one or more conditions. For example, the following query returns only `SecurityEvent` records where `Level equals _8`:

```Kusto
SecurityEvent
| where Level == 8
```

When you write filter conditions, you can use the following expressions:

| Expression  | Description                                          | Example                                                    |
|:------------|:-----------------------------------------------------|:-----------------------------------------------------------|
| ==          | Check equality<br>(case-sensitive)                   | `Level == 8`                                               |
| =~          | Check equality<br>(case-insensitive)                 | `EventSourceName =~ "microsoft-windows-security-auditing"` |
| !=, <>      | Check inequality<br>(both expressions are identical) | `Level != 4`                                               |
| `and`, `or` | Required between conditions                          | `Level == 16 or CommandLine != ""`                         |

## [Simple mode](#tab/simple)

To filter results in the `SecurityEvent` table to only show records where the `Level` equals `8`:

1. Open **Add** and choose the column `Level`.

    :::image type="content" source="media/get-started-queries/logs-simple-filter-add.png" lightbox="media/get-started-queries/logs-simple-filter-add.png" alt-text="Screenshot that shows the Add filters menu that opens when you select Add in Log Analytics simple mode.":::

1. In the **Operator** dropdown list, choose **Equals**. Enter the number `8` in the field below, then select **Apply**.
    
    :::image type="content" source="media/get-started-queries/logs-simple-filter-select.png" lightbox="media/get-started-queries/logs-simple-filter-select.png" alt-text="Screenshot that shows filter values for the OperationId column in Log Analytics simple mode.":::

---

### Filter by multiple conditions

## [KQL mode](#tab/kql)

To filter by multiple conditions, you can use either of the following approaches:

Use `and`, as shown here:

```Kusto
SecurityEvent
| where Level == 8 and EventID == 4672
```

Pipe multiple `where` elements, one after the other, as shown here:

```Kusto
SecurityEvent
| where Level == 8 
| where EventID == 4672
```

> [!NOTE]
> Values can have different types, so you might need to cast them to perform comparisons on the correct type. For example, the `SecurityEvent Level` column is of type String, so you must cast it to a numerical type, such as `int` or `long`, before you can use numerical operators on it, as shown here:
> `SecurityEvent | where toint(Level) >= 10`

## [Simple mode](#tab/simple)

To filter by multiple conditions, you can add additional filters:

1. Open **Add** and choose the column `EventID`.

1. In the **Operator** dropdown list, choose **Equals**. Enter the number `4672` in the field below, then select **Apply**.

---

---

## Specify a time range

## [KQL mode](#tab/kql)

You can specify a time range by using the time picker or a time filter.

> [!NOTE]
> If you include a time range in the query, the time picker automatically changes to **Set in query**. If you manually change the time picker to a different value, Log Analytics applies the smaller of the two time ranges.

### Use the time picker

The time picker is displayed next to the **Run** button and indicates that you're querying records from only the last 24 hours. This default time range is applied to all queries. To get records from only the last hour, select **Last hour** and then run the query again.

:::image type="content" source="media/get-started-queries/logs-kql-time.png" lightbox="media/get-started-queries/logs-kql-time.png" alt-text="Screenshot that shows the time picker and its list of time-range commands in KQL mode.":::

### Add a time filter to the query

You can also define your own time range by adding a time filter to the query.

It's best to place the time filter immediately after the table name:

```Kusto
SecurityEvent
| where TimeGenerated > ago(30m) 
| where toint(Level) >= 10
```

In the preceding time filter, `ago(30m)` means "30 minutes ago." This query returns records from only the last 30 minutes, which is expressed as, for example, 30m. Other units of time include days (for example, 2d) and seconds (for example, 10s).

## [Simple mode](#tab/simple)

The time picker is displayed next to the **Run** button and indicates that you're querying records from only the last 24 hours. This default time range is applied to all queries. To get records from only the last hour, select **Last hour** and then run the query again.

:::image type="content" source="media/get-started-queries/logs-simple-time.png" lightbox="media/get-started-queries/logs-simple-time.png" alt-text="Screenshot that shows the time picker and its list of time-range commands in simple mode.":::

---

## Include or exclude columns in query results

## [KQL mode](#tab/kql)

Use `project` to select specific columns to include in the results:

```Kusto
SecurityEvent 
| top 10 by TimeGenerated 
| project TimeGenerated, Computer, Activity
```

The preceding example generates the following output:

:::image type="content" source="media/get-started-queries/logs-kql-project.png" lightbox="media/get-started-queries/logs-kql-project.png" alt-text="Screenshot that shows the query 'project' results list.":::

You can also use `project` to rename columns and define new ones. The next example uses `project` to do the following:

* Select only the `Computer` and `TimeGenerated` original columns.
* Display the `Activity` column as `EventDetails`.
* Create a new column named `EventCode`. The `substring()` function is used to get only the first four characters from the `Activity` field.

```Kusto
SecurityEvent
| top 10 by TimeGenerated 
| project Computer, TimeGenerated, EventDetails=Activity, EventCode=substring(Activity, 0, 4)
```

## [Simple mode](#tab/simple)

You can manually select the columns you want to show in your results:

1. Open **Add** > **Show columns**.

    :::image type="content" source="media/get-started-queries/logs-simple-columns-add.png" lightbox="media/get-started-queries/logs-simple-columns-add.png" alt-text="Screenshot shows the Add dropdown in simple mode with 'Show columns' highlighted.":::

1. Deselect `All`, then select the columns `TimeGenerated`, `Computer`, and `Activity`.

    :::image type="content" source="media/get-started-queries/logs-simple-columns-select.png" lightbox="media/get-started-queries/logs-simple-columns-select.png" alt-text="Screenshot that shows the 'Show columns' selector.":::

1. Select **Apply**.

---

## Define and use custom fields

## [KQL mode](#tab/kql)

You can use `extend` to keep all original columns in the result set and define other ones. The following query uses `extend` to add the `EventCode` column. This column might not be displayed at the end of the table results. You would need to expand the details of a record to view it.

```Kusto
SecurityEvent
| top 10 by TimeGenerated
| extend EventCode=substring(Activity, 0, 4)
```

> [!NOTE]
> Use the `extend` operator for ad hoc computations in queries. Use [ingestion-time transformations](./../essentials/data-collection-transformations.md) or [summary rules](./summary-rules.md) to transform or aggregate data at ingestion time for more efficient queries.

## [Simple mode](#tab/simple)

In simple mode, there's no direct equivalent to the `extend` operator.

---

## Aggregate and group results

### Aggregate groups of rows

### [KQL mode](#tab/kql)

Use `summarize` to identify groups of records according to one or more columns and apply aggregations to them. The most common use of `summarize` is `count`, which returns the number of results in each group.

The following query reviews all `Perf` records from the last hour, groups them by `ObjectName`, and counts the records in each group:

```Kusto
Perf
| where TimeGenerated > ago(1h)
| summarize count() by ObjectName
```

### [Simple mode](#tab/simple)

To review all `Perf` records from the last, group them by `ObjectName`, and count the records in each group:

1. Open **Time range** and change it to **Last hour**.

1. Open **Add** > **Aggregate**, then make the following selection and select **Apply**:

    * **Select column:** ObjectName
    * **Operator:** count

:::image type="content" source="media/get-started-queries/logs-simple-aggregate.png" lightbox="media/get-started-queries/logs-simple-aggregate.png" alt-text="Screenshot that shows the selected values for aggregations in simple mode.":::

---

### Group unique combinations of values in multiple columns

### [KQL mode](#tab/kql)

Sometimes it makes sense to define groups by multiple dimensions. Each unique combination of these values defines a separate group:

```Kusto
Perf
| where TimeGenerated > ago(1h)
| summarize count() by ObjectName, CounterName
```

### [Simple mode](#tab/simple)

Currently, it's not possible to define groups by multiple dimensions in simple mode.

---

### Perform mathematical or statistical calculations

### [KQL mode](#tab/kql)

Another common use is to perform mathematical or statistical calculations on each group. The following example calculates the average `CounterValue` for each computer:

```Kusto
Perf
| where TimeGenerated > ago(1h)
| summarize avg(CounterValue) by Computer
```

Unfortunately, the results of this query are meaningless because we mixed together different performance counters. To make the results more meaningful, calculate the average separately for each combination of `CounterName` and `Computer`:

```Kusto
Perf
| where TimeGenerated > ago(1h)
| summarize avg(CounterValue) by Computer, CounterName
```

### [Simple mode](#tab/simple)

To calculate the average `CounterValue` for each computer:

1. Open **Time range** and change it to **Last hour**.

1. Open **Add** > **Aggregate**, then make the following selection and select **Apply**:

    * **Select column:** Computer
    * **Operator:** avg
    * **Average:** CounterValue

:::image type="content" source="media/get-started-queries/logs-simple-stat-calc.png" lightbox="media/get-started-queries/logs-simple-stat-calc.png" alt-text="Screenshot that shows the selected values for statistical calculations in simple mode.":::

Unfortunately, the results of this query are meaningless because we mixed together different performance counters. To make the results more meaningful, you could calculate the average separately for each combination of `CounterName` and `Computer`.

However, it's currently not possible to define groups by multiple dimensions in simple mode. Switch to the KQL mode tab to see how this can be done using a Kusto query.

---

### Summarize by a time column

Grouping results can also be based on a time column or another continuous value. Simply summarizing `by TimeGenerated`, though, would create groups for every single millisecond over the time range because these values are unique.

### [KQL mode](#tab/kql)

To create groups based on continuous values, it's best to break the range into manageable units by using `bin`. The following query analyzes `Perf` records that measure free memory (`Available MBytes`) on a specific computer. It calculates the average value of each 1-hour period over the last 7 days:

```Kusto
Perf 
| where TimeGenerated > ago(7d)
| where Computer == "DC01.na.contosohotels.com" 
| where CounterName == "Available MBytes" 
| summarize avg(CounterValue) by bin(TimeGenerated, 1h)
```

To make the output clearer, you can select to display it as a time chart, which shows the available memory over time. To do so, switch to **Chart** view, open the **Chart formatting** sidebar to the right and select **Line** for **Chart type**:

:::image type="content" source="media/get-started-queries/logs-kql-graph.png" lightbox="media/get-started-queries/logs-kql-graph.png" alt-text="Screenshot that shows the values of a query memory over time in KQL mode.":::

### [Simple mode](#tab/simple)

1. Select the `Perf` table.

1. Open **Time range** and change it to **Last 7 days**.

1. Open **Add**, select `Computer`, then check `DC01.na.contosohotels.com` and select **Apply**.

    > [!NOTE]
    > If `DC01.na.contosohotels.com` doesn't show, increase the shown results from 1000 (standard) to a higher number.

1. Open **Add** and select `CounterName`, then check `Available MBytes` and select **Apply**.

1. Open **Add** > **Aggregate** and make the following selection, then select **Apply**.

    * **Select column:** TimeGenerated
    * **Operator:** avg
    * **Average:** CounterValue

1. Switch to **Chart** view, open the **Chart formatting** sidebar to the right and select **Line** for **Chart type**:

    :::image type="content" source="media/get-started-queries/logs-simple-graph.png" lightbox="media/get-started-queries/logs-simple-graph.png" alt-text="Screenshot that shows the values of a query memory over time in simple mode.":::

---

## Frequently asked questions

This section provides answers to common questions.

### Why am I seeing duplicate records in Azure Monitor Logs?

Occasionally, you might notice duplicate records in Azure Monitor Logs. This duplication is typically from one of the following two conditions:
          
* Components in the pipeline have retries to ensure reliable delivery at the destination. Occasionally, this capability might result in duplicates for a small percentage of telemetry items.
* If the duplicate records come from a virtual machine, you might have both the Log Analytics agent and Azure Monitor Agent installed. If you still need the Log Analytics agent installed, configure the Log Analytics workspace to no longer collect data that's also being collected by the data collection rule used by Azure Monitor Agent.

## Next steps

* To learn more about using string data in a log query, see [Work with strings in Azure Monitor log queries](/azure/data-explorer/kusto/query/samples?&pivots=azuremonitor#string-operations).
* To learn more about aggregating data in a log query, see [Advanced aggregations in Azure Monitor log queries](/azure/data-explorer/write-queries#advanced-aggregations).
* To learn how to join data from multiple tables, see [Joins in Azure Monitor log queries](/azure/data-explorer/kusto/query/samples?&pivots=azuremonitor#joins).
* Get documentation on the entire Kusto Query Language in the [KQL language reference](/azure/kusto/query/).
