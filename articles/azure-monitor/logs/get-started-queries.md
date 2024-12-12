---
title: Get started with log queries in Azure Monitor | Microsoft Docs
description: This article provides a tutorial for getting started writing log queries in Azure Monitor.
ms.topic: tutorial
author: guywi-ms
ms.author: guywild
ms.reviewer: ilanawaitser
ms.date: 10/31/2023

---

# Get started with log queries in Azure Monitor

> [!NOTE]
> If you're collecting data from at least one virtual machine, you can work through this exercise in your own environment. For other scenarios, use our [demo environment](https://portal.azure.com/#blade/Microsoft_Azure_Monitoring_Logs/DemoLogsBlade), which includes plenty of sample data.
>
> If you already know how to query in Kusto Query Language (KQL) but need to quickly create useful queries based on resource types, see the saved example queries pane in [Use queries in Azure Monitor Log Analytics](../logs/queries.md).

In this tutorial, you learn to write log queries in Azure Monitor. The article shows you how to:

* Understand query structure.
* Sort query results.
* Filter query results.
* Specify a time range.
* Select which fields to include in the results.
* Define and use custom fields.
* Aggregate and group results.

For a tutorial on using Log Analytics in the Azure portal, see [Get started with Azure Monitor Log Analytics](./log-analytics-tutorial.md).

For more information about log queries in Azure Monitor, see [Overview of log queries in Azure Monitor](../logs/log-query-overview.md).

Here's a video version of this tutorial:

> [!VIDEO https://www.microsoft.com/videoplayer/embed/RE42pGX]

[!INCLUDE [log-analytics-query-permissions](../../../includes/log-analytics-query-permissions.md)]

## Write a new query

Queries can start with either a table name or the `search` command. It's a good idea to start with a table name because it defines a clear scope for the query. It also improves query performance and the relevance of the results.

> [!NOTE]
> KQL, which is used by Azure Monitor, is case sensitive. Language keywords are usually written in lowercase. When you use names of tables or columns in a query, be sure to use the correct case, as shown on the schema pane.

### Table-based queries

Azure Monitor organizes log data in tables, each composed of multiple columns. All tables and columns are shown on the schema pane in Log Analytics in the Analytics portal. Identify a table that you're interested in, and then take a look at a bit of data:

```Kusto
SecurityEvent
| take 10
```

The preceding query returns 10 results from the `SecurityEvent` table, in no specific order. This common way to get a glance at a table helps you to understand its structure and content. Let's examine how it's built:

* The query starts with the table name `SecurityEvent`, which defines the scope of the query.
* The pipe (|) character separates commands, so the output of the first command is the input of the next. You can add any number of piped elements.
* Following the pipe is the [`take` operator](#take).

   We could run the query even without adding `| take 10`. The command would still be valid, but it could return up to 30,000 results.

### Search queries

Search queries are less structured. They're better suited for finding records that include a specific value in any of their columns:

```Kusto
search in (SecurityEvent) "Cryptographic"
| take 10
```

This query searches the `SecurityEvent` table for records that contain the phrase "Cryptographic." Of those records, 10 records are returned and displayed. If you omit the `in (SecurityEvent)` part and run only `search "Cryptographic"`, the search goes over *all* tables. The process would then take longer and be less efficient.

> [!IMPORTANT]
> Search queries are ordinarily slower than table-based queries because they have to process more data.

## Limit results

## [KQL](#tab/kql)

#### Take

Use the [`take` operator](/azure/data-explorer/kusto/query/takeoperator) to view a small sample of records by returning up to the specified number of records. The selected results are arbitrary and displayed in no particular order. If you need to return results in a particular order, use the [`sort` and `top` operators](#sort-and-top).

## [Simple](#tab/simple)

To return up to a specific number of records in Simple Mode, you can limit the results:

1. Select **Limit** to open the **Limit results** window.

1. Select one of the preset limits, or enter a custom limit, then hit **Apply**.

    :::image type="content" source="media/log-analytics-explorer/log-analytics-result-limits.png" alt-text="Screenshot that shows the limit results window in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-result-limits.png":::

---

## Sort and top

## [KQL](#tab/kql)

This section describes the `sort` and `top` operators and their `desc` and `asc` arguments. Although [`take`](#take) is useful for getting a few records, you can't select or sort the results in any particular order. To get an ordered view, use `sort` and `top`.

### Desc and asc

#### Desc

Use the `desc` argument to sort records in descending order. Descending is the default sorting order for `sort` and `top`, so you can usually omit the `desc` argument. 

For example, the data returned by both of the following queries is sorted by the [TimeGenerated column](./log-standard-columns.md#timegenerated), in descending order:

- ```Kusto
  SecurityEvent	
  | sort by TimeGenerated desc
  ```

- ```Kusto
   SecurityEvent	
   | sort by TimeGenerated
   ```
   
#### Asc

To sort in ascending order, specify `asc`.

### Sort

You can use the [`sort` operator](/azure/data-explorer/kusto/query/sort-operator). `sort` sorts the query results by the column you specify. However, `sort` doesn't limit the number of records that are returned by the query.

For example, the following query returns all available records for the `SecurityEvent` table, which is up to a maximum of 30,000 records, and sorts them by the TimeGenerated column.

```Kusto
SecurityEvent	
| sort by TimeGenerated
```

The preceding query could return too many results. Also, it might also take some time to return the results. The query sorts the entire `SecurityEvent` table by the `TimeGenerated` column. The Analytics portal then limits the display to only 30,000 records. This approach isn't optimal. The best way to only get the latest records is to use the [`top` operator](#top).

### Top

Use the [`top` operator](/azure/data-explorer/kusto/query/topoperator) to sort the entire table on the server side and then only return the top records. 

For example, the following query returns the latest 10 records:

```Kusto
SecurityEvent
| top 10 by TimeGenerated
```

The output looks like this example.
<!-- convertborder later -->
:::image type="content" source="media/get-started-queries/top10.png" lightbox="media/get-started-queries/top10.png" alt-text="Screenshot that shows the top 10 records sorted in descending order." border="false":::

## [Simple](#tab/simple)

To sort in Simple Mode:

1. Select **Sort**.
1. Select a column to sort by.
1. Select **Ascending** or **Descending**, then select **Apply**.

    :::image type="content" source="media/log-analytics-explorer/log-analytics-sort.png" alt-text="Screenshot that shows the Sort by column window in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-sort.png":::

1. Select **Sort** again to sort by another column.

> [!NOTE]
> In Simple Mode, there's no direct equivalent to the Top operator. Instead, you can sort a column as described in this section, and then limit the results.

---

## Filter

Filters, as indicated by their name, filter the data by a specific condition. Filtering is the most common way to limit query results to relevant information.

## [KQL](#tab/kql)

### The where operator: Filter on a condition

To add a filter to a query, use the [`where` operator](/azure/data-explorer/kusto/query/whereoperator) followed by one or more conditions. For example, the following query returns only `SecurityEvent` records where `Level equals _8`:

```Kusto
SecurityEvent
| where Level == 8
```

When you write filter conditions, you can use the following expressions:

| Expression | Description | Example |
|:---|:---|:---|
| == | Check equality<br>(case-sensitive) | `Level == 8` |
| =~ | Check equality<br>(case-insensitive) | `EventSourceName =~ "microsoft-windows-security-auditing"` |
| !=, <> | Check inequality<br>(both expressions are identical) | `Level != 4` |
| `and`, `or` | Required between conditions| `Level == 16 or CommandLine != ""` |

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

## [Simple](#tab/simple)

Instead of using the [`where` operator](/azure/data-explorer/kusto/query/whereoperator), in Simple Mode you can add filters using the UI. For example,  followed by one or more conditions.

For example, to filter results in the `SecurityEvent` table to only show records where the `Level` equals `8`:

1. Select **Add** and choose the column `Level`.

    :::image type="content" source="media/log-analytics-explorer/log-analytics-add-filter.png" alt-text="Screenshot that shows the Add filters menu that opens when you select Add in Log Analytics Simple mode." lightbox="media/log-analytics-explorer/log-analytics-add-filter.png":::

1. In the **Operator** dropdown list, select **Equals**. Enter the number `8` in the field below, then hit **Apply**.
    
    :::image type="content" source="media/log-analytics-explorer/log-analytics-filter.png" alt-text="Screenshot that shows filter values for the OperationId column in Log Analytics Simple mode." lightbox="media/log-analytics-explorer/log-analytics-filter.png":::

To filter by multiple conditions, you can add additional filters.

1. Select **Add** and choose the column `EventID`.

1.  In the **Operator** dropdown list, select **Equals**. Enter the number `4672` in the field below, then hit **Apply**.

---

## Specify a time range

## [KQL](#tab/kql)

You can specify a time range by using the time picker or a time filter.

### Use the time picker

The time picker is displayed next to the **Run** button and indicates that you're querying records from only the last 24 hours. This default time range is applied to all queries. To get records from only the last hour, select **Last hour** and then run the query again.
<!-- convertborder later -->
:::image type="content" source="media/get-started-queries/timepicker.png" lightbox="media/get-started-queries/timepicker.png" alt-text="Screenshot that shows the time picker and its list of time-range commands." border="false":::

### Add a time filter to the query

You can also define your own time range by adding a time filter to the query. Adding a time filter overrides the time range selected in the [time picker](#use-the-time-picker).

It's best to place the time filter immediately after the table name:

```Kusto
SecurityEvent
| where TimeGenerated > ago(30m) 
| where toint(Level) >= 10
```

In the preceding time filter, `ago(30m)` means "30 minutes ago." This query returns records from only the last 30 minutes, which is expressed as, for example, 30m. Other units of time include days (for example, 2d) and seconds (for example, 10s).

## [Simple](#tab/simple)

The time picker is displayed next to the **Run** button and indicates that you're querying records from only the last 24 hours. This default time range is applied to all queries. To get records from only the last hour, select **Last hour** and then run the query again.
<!-- convertborder later -->
:::image type="content" source="media/get-started-queries/timepicker.png" lightbox="media/get-started-queries/timepicker.png" alt-text="Screenshot that shows the time picker and its list of time-range commands." border="false":::

---

## Use project and extend to select and compute columns

Use `project` to select specific columns to include in the results:

```Kusto
SecurityEvent 
| top 10 by TimeGenerated 
| project TimeGenerated, Computer, Activity
```

The preceding example generates the following output:
<!-- convertborder later -->
:::image type="content" source="media/get-started-queries/project.png" lightbox="media/get-started-queries/project.png" alt-text="Screenshot that shows the query 'project' results list." border="false":::

You can also use `project` to rename columns and define new ones. The next example uses `project` to do the following:

* Select only the `Computer` and `TimeGenerated` original columns.
* Display the `Activity` column as `EventDetails`.
* Create a new column named `EventCode`. The `substring()` function is used to get only the first four characters from the `Activity` field.

```Kusto
SecurityEvent
| top 10 by TimeGenerated 
| project Computer, TimeGenerated, EventDetails=Activity, EventCode=substring(Activity, 0, 4)
```

You can use `extend` to keep all original columns in the result set and define other ones. The following query uses `extend` to add the `EventCode` column. This column might not be displayed at the end of the table results. You would need to expand the details of a record to view it.

```Kusto
SecurityEvent
| top 10 by TimeGenerated
| extend EventCode=substring(Activity, 0, 4)
```

---

## Aggregation

## [KQL](#tab/kql)

### Use summarize to aggregate groups of rows

Use `summarize` to identify groups of records according to one or more columns and apply aggregations to them. The most common use of `summarize` is `count`, which returns the number of results in each group.

The following query reviews all `Perf` records from the last hour, groups them by `ObjectName`, and counts the records in each group:

```Kusto
Perf
| where TimeGenerated > ago(1h)
| summarize count() by ObjectName
```

Sometimes it makes sense to define groups by multiple dimensions. Each unique combination of these values defines a separate group:

```Kusto
Perf
| where TimeGenerated > ago(1h)
| summarize count() by ObjectName, CounterName
```

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

#### Summarize by a time column

Grouping results can also be based on a time column or another continuous value. Simply summarizing `by TimeGenerated`, though, would create groups for every single millisecond over the time range because these values are unique.

To create groups based on continuous values, it's best to break the range into manageable units by using `bin`. The following query analyzes `Perf` records that measure free memory (`Available MBytes`) on a specific computer. It calculates the average value of each 1-hour period over the last 7 days:

```Kusto
Perf 
| where TimeGenerated > ago(7d)
| where Computer == "ContosoAzADDS2" 
| where CounterName == "Available MBytes" 
| summarize avg(CounterValue) by bin(TimeGenerated, 1h)
```

To make the output clearer, you can select to display it as a time chart, which shows the available memory over time.
<!-- convertborder later -->
:::image type="content" source="media/get-started-queries/chart.png" lightbox="media/get-started-queries/chart.png" alt-text="Screenshot that shows the values of a query memory over time." border="false":::

## [Simple](#tab/simple)

### Aggregate data

1. Select **Aggregate**.
1. Select a column to aggregate by and select an operator to aggregate by, as described in [Use aggregation operators](#use-aggregation-operators).

    :::image type="content" source="media/log-analytics-explorer/log-analytics-aggregate.png" alt-text="Screenshot that shows the aggregation operators in the Aggregate table window in Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-aggregate.png":::

### Use aggregation operators

Use aggregation operators to summarize data from multiple rows, as described in this table.

| Operator | Description |
|:---|:---|
|[count](/azure/data-explorer/kusto/query/count-operator)|Counts the number of times each distinct value exists in the column.|
|[dcount](/azure/data-explorer/kusto/query/dcount-aggfunction)|For the `dcount` operator, you select two columns. The operator counts the total number of distinct values in the second column correlated to each value in the first column. For example, this shows the distinct number of result codes for successful and failed operations:<br/> :::image type="content" source="media/log-analytics-explorer/log-analytics-dcount.png" alt-text="Screenshot that shows the result of an aggregation using the dcount operator in Azure Monitor Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-dcount.png":::  |
|[sum](/azure/data-explorer/kusto/query/sum-aggregation-function)<br/>[avg](/azure/data-explorer/kusto/query/avg-aggregation-function)<br/>[max](/azure/data-explorer/kusto/query/max-aggregation-function)<br/>[min](/azure/data-explorer/kusto/query/min-aggregation-function)|For these operators, you select two columns. The operators calculate the sum, average, maximum, or minimum of all values in the second column for each value in the first column. For example, this shows the total duration of each operation in milliseconds for the past 24 hours:<br/>:::image type="content" source="media/log-analytics-explorer/log-analytics-sum.png" alt-text="Screenshot that shows the results of an aggregation using the sum operator in Azure Monitor Log Analytics." lightbox="media/log-analytics-explorer/log-analytics-sum.png":::  |

> [!IMPORTANT]
> Basic logs tables don't support aggregation using the `avg` and `sum` operators. 

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
