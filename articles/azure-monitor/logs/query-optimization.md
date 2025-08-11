---
title: Optimize log queries in Azure Monitor
description: Best practices for optimizing log queries in Azure Monitor.
ms.topic: how-to
ms.reviewer: MeirMen
ms.date: 10/11/2024


---

# Optimize log queries in Azure Monitor
Azure Monitor Logs uses [Azure Data Explorer](/azure/data-explorer/) to store log data and run queries for analyzing that data. It creates, manages, and maintains the Azure Data Explorer clusters for you, and optimizes them for your log analysis workload. When you run a query, it's optimized and routed to the appropriate Azure Data Explorer cluster that stores the workspace data.

Azure Monitor Logs and Azure Data Explorer use many automatic query optimization mechanisms. Automatic optimizations provide significant boost, but there are some cases where you can dramatically improve your query performance. This article explains the performance considerations and several techniques to fix them.

Most of the techniques are common to queries that are run directly on Azure Data Explorer and Azure Monitor Logs. Several unique Azure Monitor Logs considerations are also discussed. For more Azure Data Explorer optimization tips, see [Query best practices](/azure/kusto/query/best-practices).

Optimized queries will:

- Run faster and reduce overall duration of the query execution.
- Have smaller chance of being throttled or rejected.

Pay particular attention to queries that are used for recurrent and simultaneous usage, such as dashboards, alerts, Azure Logic Apps, and Power BI. The impact of an ineffective query in these cases is substantial.

Here's a detailed video walkthrough on optimizing queries.

> [!VIDEO https://learn-video.azurefd.net/vod/player?id=e498f85b-a3c6-4f77-95ce-cdd0a1a9d466]

## Query Details pane
After you run a query in Log Analytics, select **Query details** at the bottom right corner of the screen to open the **Query Details** pane. 
The Query Details pane includes three tabs:
- **Overview** - A curated set of key performance indicators
- **Raw statistics** - All detailed execution stats, referenced workspaces and queries, and other technical data
- **Errors** - Lists any errors encountered during query execution

This **Overview** tab shows the results of several performance indicators for the query. These performance indicators are described in the following section.

:::image type="content" source="media/query-optimization/query-details-pane.png" alt-text="Screenshot that shows the Query Details pane in Azure Monitor Log Analytics." lightbox="media/query-optimization/query-details-pane.png":::

## Query Execution Time Breakdown

When analyzing query performance in Azure Monitor Logs, the Query Details pane provides an **Execution time** that reflects the overall duration of the query from end-to-end. This stats is broken down into three distinct components to help identify performance bottlenecks:

1.	**Engine Execution Time**
This is the time spent executing the query within the underlying data engine, such as Azure Data Explorer or other components. If this value is the primary contributor to the overall execution time, it may indicate that the query itself can be optimized. Refer to the optimization techniques described in this document to improve performance.

2.	**Service Execution Time**
This represents the time spent within the Azure Monitor Logs service itself, outside of the data engine. It includes internal processing and orchestration.

3.	**Service Queue Time**
This is the time the query spent waiting in the Azure Monitor Logs service queue before execution. If this value is populated (for example, not the default value of N/A), it suggests that the user has reached concurrency limits due to multiple simultaneous queries. A high queue time indicates that other concurrent queries may be resource-intensive and should be reviewed and optimized to reduce contention. See Azure Monitor service limits - Azure Monitor | Microsoft Learn.
[Azure Monitor service limits - User query throttling](../fundamentals/service-limits.md#user-query-throttling)


## Query performance indicators

The following query performance indicators are available for every query that's executed:

- [Total CPU](#total-cpu): Overall compute used to process the query across all compute nodes. It represents time used for computing, parsing, and data fetching.
- [Time span of the processed query](#time-span-of-the-processed-query): The gap between the newest and the oldest data that was accessed to process the query. Influenced by the explicit time range specified for the query.
- [Age of processed data](#age-of-processed-data): The gap between now and the oldest data that was accessed to process the query. It highly influences the efficiency of data fetching.
- [Number of workspaces](#number-of-workspaces): How many workspaces were accessed during the query processing based on implicit or explicit selection.
- [Number of regions](#number-of-regions): How many regions were accessed during the query processing based on implicit or explicit selection of workspaces. Multi-region queries are much less efficient, and performance indicators present partial coverage.
- [Parallelism](#parallelism): Indicates how much the system was able to execute this query on multiple nodes. Relevant only to queries that have high CPU consumption. Influenced by usage of specific functions and operators.
- [Memory peak](#memory-peak): The maximum amount of memory used by the system while executing this query. This includes memory consumed by data loading, processing and temporary storage during execution.

## Total CPU
The actual compute CPU that was invested to process this query across all the query processing nodes. Because most queries are executed on large numbers of nodes, this total will usually be much larger than the duration the query took to execute.

A query that uses more than 100 seconds of CPU is considered a query that consumes excessive resources. A query that uses more than 1,000 seconds of CPU is considered an abusive query and might be throttled.

Query processing time is spent on:

- **Data retrieval**: Retrieval of old data will consume more time than retrieval of recent data.
- **Data processing**: Logic and evaluation of the data.

In addition to the time spent in the query processing nodes, Azure Monitor Logs spends time in:

- Authenticating the user and verifying they're permitted to access this data.
- Locating the data store.
- Parsing the query.
- Allocating the query processing nodes.

This time isn't included in the query total CPU time.

### Early filtering of records prior to using high CPU functions

Some of the query commands and functions are heavy in their CPU consumption. This case is especially true for commands that parse JSON and XML or extract complex regular expressions. Such parsing can happen explicitly via [parse_json()](/azure/kusto/query/parsejsonfunction) or [parse_xml()](/azure/kusto/query/parse-xmlfunction) functions or implicitly when it refers to dynamic columns.

These functions consume CPU in proportion to the number of rows they're processing. The most efficient optimization is to add `where` conditions early in the query. In this way, they can filter out as many records as possible before the CPU-intensive function is executed.

For example, the following queries produce exactly the same result. But the second one is the most efficient because the [where](/azure/kusto/query/whereoperator) condition before parsing excludes many records:

```Kusto
//less efficient
SecurityEvent
| extend Details = parse_xml(EventData)
| extend FilePath = tostring(Details.UserData.RuleAndFileData.FilePath)
| extend FileHash = tostring(Details.UserData.RuleAndFileData.FileHash)
| where FileHash != "" and FilePath !startswith "%SYSTEM32"  // Problem: irrelevant results are filtered after all processing and parsing is done
| summarize count() by FileHash, FilePath
```
```Kusto
//more efficient
SecurityEvent
| where EventID == 8002 //Only this event have FileHash
| where EventData !has "%SYSTEM32" //Early removal of unwanted records
| extend Details = parse_xml(EventData)
| extend FilePath = tostring(Details.UserData.RuleAndFileData.FilePath)
| extend FileHash = tostring(Details.UserData.RuleAndFileData.FileHash)
| where FileHash != "" and FilePath !startswith "%SYSTEM32"  // exact removal of results. Early filter is not accurate enough
| summarize count() by FileHash, FilePath
| where FileHash != "" // No need to filter out %SYSTEM32 here as it was removed before
```

### Avoid using evaluated where clauses

Queries that contain [where](/azure/kusto/query/whereoperator) clauses on an evaluated column rather than on columns that are physically present in the dataset lose efficiency. Filtering on evaluated columns prevents some system optimizations when large sets of data are handled.

For example, the following queries produce exactly the same result. But the second one is more efficient because the [where](/azure/kusto/query/whereoperator) condition refers to a built-in column:

```Kusto
//less efficient
Syslog
| extend Msg = strcat("Syslog: ",SyslogMessage)
| where  Msg  has "Error"
| count 
```
```Kusto
//more efficient
Syslog
| where  SyslogMessage  has "Error"
| count 
```

In some cases, the evaluated column is created implicitly by the query processing engine because the filtering is done not just on the field:

```Kusto
//less efficient
SecurityEvent
| where tolower(Process) == "conhost.exe"
| count 
```
```Kusto
//more efficient
SecurityEvent
| where Process =~ "conhost.exe"
| count 
```

### Use effective aggregation commands and dimensions in summarize and join

Some aggregation commands like [max()](/azure/kusto/query/max-aggfunction), [sum()](/azure/kusto/query/sum-aggfunction), [count()](/azure/kusto/query/count-aggfunction), and [avg()](/azure/kusto/query/avg-aggfunction) have low CPU impact because of their logic. Other commands are more complex and include heuristics and estimations that allow them to be executed efficiently. For example, [dcount()](/azure/kusto/query/dcount-aggfunction) uses the HyperLogLog algorithm to provide close estimation to a distinct count of large sets of data without actually counting each value.

The percentile functions are doing similar approximations by using the nearest rank percentile algorithm. Several of the commands include optional parameters to reduce their impact. For example, the [makeset()](/azure/kusto/query/makeset-aggfunction) function has an optional parameter to define the maximum set size, which significantly affects the CPU and memory.

[Join](/azure/kusto/query/joinoperator?pivots=azuremonitor) and [summarize](/azure/kusto/query/summarizeoperator) commands might cause high CPU utilization when they're processing a large set of data. Their complexity is directly related to the number of possible values, referred to as *cardinality*, of the columns that are used as the `by` in `summarize` or as the `join` attributes. For explanation and optimization of `join` and `summarize`, see their documentation articles and optimization tips.

For example, the following queries produce exactly the same result because `CounterPath` is always one-to-one mapped to `CounterName` and `ObjectName`. The second one is more efficient because the aggregation dimension is smaller:

```Kusto
//less efficient
Perf
| summarize avg(CounterValue) 
by CounterName, CounterPath, ObjectName
```
```Kusto
//make the group expression more compact improve the performance
Perf
| summarize avg(CounterValue), any(CounterName), any(ObjectName) 
by CounterPath
```

CPU consumption might also be affected by `where` conditions or extended columns that require intensive computing. All trivial string comparisons, such as [equal ==](/azure/kusto/query/datatypes-string-operators) and [startswith](/azure/kusto/query/datatypes-string-operators), have roughly the same CPU impact. Advanced text matches have more impact. Specifically, the [has](/azure/kusto/query/datatypes-string-operators) operator is more efficient than the [contains](/azure/kusto/query/datatypes-string-operators) operator. Because of string handling techniques, it's more efficient to look for strings that are longer than four characters than short strings.

For example, the following queries produce similar results, depending on `Computer` naming policy. But the second one is more efficient:

```Kusto
//less efficient – due to filter based on contains
Heartbeat
| where Computer contains "Production" 
| summarize count() by ComputerIP 
```
```Kusto
//less efficient – due to filter based on extend
Heartbeat
| extend MyComputer = Computer
| where MyComputer startswith "Production" 
| summarize count() by ComputerIP 
```
```Kusto
//more efficient
Heartbeat
| where Computer startswith "Production" 
| summarize count() by ComputerIP 
```

> [!NOTE]
> This indicator presents only CPU from the immediate cluster. In a multi-region query, it would represent only one of the regions. In a multi-workspace query, it might not include all workspaces.

### Avoid full XML and JSON parsing when string parsing works
Full parsing of an XML or JSON object might consume high CPU and memory resources. In many cases, when only one or two parameters are needed and the XML or JSON objects are simple, it's easier to parse them as strings. Use the [parse operator](/azure/kusto/query/parseoperator) or other [text parsing techniques](./parse-text.md). The performance boost will be more significant because the number of records in the XML or JSON object increases. It's essential when the number of records reaches tens of millions.

For example, the following query returns exactly the same results as the preceding queries without performing full XML parsing. The query makes some assumptions about the XML file structure, like the `FilePath` element comes after `FileHash` and none of them has attributes:

```Kusto
//even more efficient
SecurityEvent
| where EventID == 8002 //Only this event have FileHash
| where EventData !has "%SYSTEM32" //Early removal of unwanted records
| parse EventData with * "<FilePath>" FilePath "</FilePath>" * "<FileHash>" FileHash "</FileHash>" *
| summarize count() by FileHash, FilePath
| where FileHash != "" // No need to filter out %SYSTEM32 here as it was removed before
```

### Break up large parse commands
When using the `parse` operator, limit to five the number of columns you extract in a single statement. An excessive number of extractions in a single statement can result in significantly increased processing time. Instead, break the extractions into multiple `parse` statements.

> [!NOTE]
> In transformations, the `parse` operator is limited to 10 extractions in a single statement.

For example, the following queries produce the same results, but the second is significantly more efficient because it breaks the parse operation into multiple smaller commands.

 ```kql 
//less efficient
LogData
| parse Message with
    * "field1=" Field1: string
    " field2=" Field2: string
    " field3=" Field3: string
    " field4=" Field4: string
    " field5=" Field5: string
    " field6=" Field6: string
    " field7=" Field7: string
    " field8=" Field8: string
    " field9=" Field9: string
    " field10=" Field10: string *
```


 ```kql 
//more efficient
LogData
| parse Message with
    * "field1=" Field1: string
    " field2=" Field2: string
    " field3=" Field3: string
    " field4=" Field4: string
    " field5=" Field5: string *
| parse Message with
    * " field6=" Field6: string
    " field7=" Field7: string
    " field8=" Field8: string
    " field9=" Field9: string
    " field10=" Field10: string *
```

### Avoid unnecessary use of search and union operators

A factor that increases the data that's processed is the use of a large number of tables. This scenario usually happens when `search *` and `union *` commands are used. These commands force the system to evaluate and scan data from all tables in the workspace. In some cases, there might be hundreds of tables in the workspace. Try to avoid using `search *` or any search without scoping it to a specific table.

For example, the following queries produce exactly the same result, but the last one is the most efficient:

```Kusto
// This version scans all tables though only Perf has this kind of data
search "Processor Time" 
| summarize count(), avg(CounterValue)  by Computer
```
```Kusto
// This version scans all strings in Perf tables – much more efficient
Perf
| search "Processor Time" 
| summarize count(), avg(CounterValue)  by Computer
```
```Kusto
// This is the most efficient version 
Perf 
| where CounterName == "% Processor Time"  
| summarize count(), avg(CounterValue)  by Computer
```

### Add early filters to the query

Another method to reduce the data volume is to have [where](/azure/kusto/query/whereoperator) conditions early in the query. The Azure Data Explorer platform includes a cache that lets it know which partitions include data that's relevant for a specific `where` condition. For example, if a query contains `where EventID == 4624`, then it would distribute the query only to nodes that handle partitions with matching events.

The following example queries produce exactly the same result, but the second one is more efficient:

```Kusto
//less efficient
SecurityEvent
| summarize LoginSessions = dcount(LogonGuid) by Account
```
```Kusto
//more efficient
SecurityEvent
| where EventID == 4624 //Logon GUID is relevant only for logon event
| summarize LoginSessions = dcount(LogonGuid) by Account
```

### Avoid multiple scans of the same source data by using conditional aggregation functions and the materialize function
When a query has several subqueries that are merged by using join or union operators, each subquery scans the entire source separately. Then it merges the results. This action multiplies the number of times that data is scanned, which is a critical factor in large datasets.

A technique to avoid this scenario is by using the conditional aggregation functions. Most of the [aggregation functions](/azure/data-explorer/kusto/query/summarizeoperator#list-of-aggregation-functions) that are used in a summary operator have a conditioned version that you can use for a single summarize operator with multiple conditions.

For example, the following queries show the number of login events and the number of process execution events for each account. They return the same results, but the first query scans the data twice. The second query scans it only once:

```Kusto
//Scans the SecurityEvent table twice and perform expensive join
SecurityEvent
| where EventID == 4624 //Login event
| summarize LoginCount = count() by Account
| join 
(
    SecurityEvent
    | where EventID == 4688 //Process execution event
    | summarize ExecutionCount = count(), ExecutedProcesses = make_set(Process) by Account
) on Account
```

```Kusto
//Scan only once with no join
SecurityEvent
| where EventID == 4624 or EventID == 4688 //early filter
| summarize LoginCount = countif(EventID == 4624), ExecutionCount = countif(EventID == 4688), ExecutedProcesses = make_set_if(Process,EventID == 4688)  by Account
```

Another case where subqueries are unnecessary is pre-filtering for a [parse operator](/azure/data-explorer/kusto/query/parseoperator?pivots=azuremonitor) to make sure that it processes only records that match a specific pattern. They're unnecessary because the parse operator and other similar operators return empty results when the pattern doesn't match. The following two queries return exactly the same results, but the second query scans the data only once. In the second query, each parse command is relevant only for its events. The `extend` operator afterward shows how to refer to an empty data situation:

```Kusto
//Scan SecurityEvent table twice
union(
SecurityEvent
| where EventID == 8002 
| parse EventData with * "<FilePath>" FilePath "</FilePath>" * "<FileHash>" FileHash "</FileHash>" *
| distinct FilePath
),(
SecurityEvent
| where EventID == 4799
| parse EventData with * "CallerProcessName\">" CallerProcessName1 "</Data>" * 
| distinct CallerProcessName1
)
```

```Kusto
//Single scan of the SecurityEvent table
SecurityEvent
| where EventID == 8002 or EventID == 4799
| parse EventData with * "<FilePath>" FilePath "</FilePath>" * "<FileHash>" FileHash "</FileHash>" * //Relevant only for event 8002
| parse EventData with * "CallerProcessName\">" CallerProcessName1 "</Data>" *  //Relevant only for event 4799
| extend FilePath = iif(isempty(CallerProcessName1),FilePath,"")
| distinct FilePath, CallerProcessName1
```

When the preceding query doesn't allow you to avoid using subqueries, another technique is to hint to the query engine that there's a single source of data used in each one of them by using the [materialize() function](/azure/data-explorer/kusto/query/materializefunction?pivots=azuremonitor). This technique is useful when the source data is coming from a function that's used several times within the query. `Materialize` is effective when the output of the subquery is much smaller than the input. The query engine will cache and reuse the output in all occurrences.

### Reduce the number of columns that's retrieved

Because Azure Data Explorer is a columnar data store, retrieval of every column is independent of the others. The number of columns that are retrieved directly influences the overall data volume. You should only include the columns in the output that are needed by [summarizing](/azure/kusto/query/summarizeoperator) the results or [projecting](/azure/kusto/query/projectoperator) the specific columns.

Azure Data Explorer has several optimizations to reduce the number of retrieved columns. If it determines that a column isn't needed, for example, if it's not referenced in the [summarize](/azure/kusto/query/summarizeoperator) command, it won't retrieve it.

For example, the second query might process three times more data because it needs to fetch not one column but three:

```Kusto
//Less columns --> Less data
SecurityEvent
| summarize count() by Computer  
```
```Kusto
//More columns --> More data
SecurityEvent
| summarize count(), dcount(EventID), avg(Level) by Computer  
```

## Time span of the processed query

All logs in Azure Monitor Logs are partitioned according to the `TimeGenerated` column. The number of partitions that are accessed are directly related to the time span. Reducing the time range is the most efficient way of assuring a prompt query execution.

A query with a time span of more than 15 days is considered a query that consumes excessive resources. A query with a time span of more than 90 days is considered an abusive query and might be throttled.

You can set the time range by using the time range selector in the Log Analytics screen as described in [Log query scope and time range in Azure Monitor Log Analytics](./scope.md#time-range). This method is recommended because the selected time range is passed to the back end by using the query metadata.

An alternative method is to explicitly include a [where](/azure/kusto/query/whereoperator) condition on `TimeGenerated` in the query. Use this method because it assures that the time span is fixed, even when the query is used from a different interface.

Make sure that all parts of the query have `TimeGenerated` filters. When a query has subqueries fetching data from various tables or the same table, each query has to include its own [where](/azure/kusto/query/whereoperator) condition.

### Make sure all subqueries have the TimeGenerated filter

For example, in the following query, the `Perf` table will be scanned only for the last day. The `Heartbeat` table will be scanned for all of its history, which might be up to two years:

```Kusto
Perf
| where TimeGenerated > ago(1d)
| summarize avg(CounterValue) by Computer, CounterName
| join kind=leftouter (
    Heartbeat
    //No time span filter in this part of the query
    | summarize IPs = makeset(ComputerIP, 10) by  Computer
) on Computer
```

A common case where such a mistake occurs is when [arg_max()](/azure/kusto/query/arg-max-aggfunction) is used to find the most recent occurrence. For example:

```Kusto
Perf
| where TimeGenerated > ago(1d)
| summarize avg(CounterValue) by Computer, CounterName
| join kind=leftouter (
    Heartbeat
    //No time span filter in this part of the query
    | summarize arg_max(TimeGenerated, *), min(TimeGenerated)   
by Computer
) on Computer
```

You can easily correct this situation by adding a time filter in the inner query:

```Kusto
Perf
| where TimeGenerated > ago(1d)
| summarize avg(CounterValue) by Computer, CounterName
| join kind=leftouter (
    Heartbeat
    | where TimeGenerated > ago(1d) //filter for this part
    | summarize arg_max(TimeGenerated, *), min(TimeGenerated)   
by Computer
) on Computer
```

Another example of this fault is when you perform the time scope filtering just after a [union](/azure/kusto/query/unionoperator?pivots=azuremonitor) over several tables. When you perform the union, each subquery should be scoped. You can use a [let](/azure/kusto/query/letstatement) statement to ensure scoping consistency.

For example, the following query will scan all the data in the `Heartbeat` and `Perf` tables, not just the last day:

```Kusto
Heartbeat 
| summarize arg_min(TimeGenerated,*) by Computer
| union (
    Perf 
    | summarize arg_min(TimeGenerated,*) by Computer) 
| where TimeGenerated > ago(1d)
| summarize min(TimeGenerated) by Computer
```

To fix the query:

```Kusto
let MinTime = ago(1d);
Heartbeat 
| where TimeGenerated > MinTime
| summarize arg_min(TimeGenerated,*) by Computer
| union (
    Perf 
    | where TimeGenerated > MinTime
    | summarize arg_min(TimeGenerated,*) by Computer) 
| summarize min(TimeGenerated) by Computer
```

### Time span measurement limitations

The measurement is always larger than the actual time specified. For example, if the filter on the query is 7 days, the system might scan 7.5 or 8.1 days. This variance is because the system is partitioning the data into chunks of variable sizes. To ensure that all relevant records are scanned, the system scans the entire partition. This process might cover several hours and even more than a day.

There are several cases where the system can't provide an accurate measurement of the time range. This situation happens in most cases where the query's span is less than a day or in multi-workspace queries.

> [!IMPORTANT]
> This indicator presents only data processed in the immediate cluster. In a multi-region query, it would represent only one of the regions. In a multi-workspace query, it might not include all workspaces.

## Age of processed data
Azure Data Explorer uses several storage tiers: in-memory, local SSD disks, and much slower Azure Blobs. The newer the data, the higher the chance that it's stored in a more performant tier with smaller latency, which reduces the query duration and CPU. Other than the data itself, the system also has a cache for metadata. The older the data, the less chance its metadata will be in a cache.

A query that processes data that's more than 14 days old is considered a query that consumes excessive resources.

Some queries require the use of old data, but there are also cases where old data is used by mistake. This scenario happens when queries are executed without providing a time range in their metadata and not all table references include a filter on the `TimeGenerated` column. In these cases, the system will scan all the data that's stored in the table. When the data retention is long, it can cover long time ranges. As a result, data that's as old as the data retention period is scanned.

Such cases can be, for example:

- Not setting the time range in Log Analytics with a subquery that isn't limited. See the preceding example.
- Using the API without the time range optional parameters.
- Using a client that doesn't force a time range, for example, like the Power BI connector.

See examples and notes in the previous section because they're also relevant in this case.

## Number of regions
There are situations where a single query might be executed across different regions. For example:

- When several workspaces are explicitly listed and they're located in different regions.
- When a resource-scoped query is fetching data and the data is stored in multiple workspaces that are located in different regions.

Cross-region query execution requires the system to serialize and transfer in the back end large chunks of intermediate data that are usually much larger than the query final results. It also limits the system's ability to perform optimizations and heuristics and use caches.

If there's no reason to scan all these regions, adjust the scope so that it covers fewer regions. If the resource scope is minimized but many regions are still used, it might happen because of misconfiguration. For example, audit logs and diagnostic settings might be sent to different workspaces in different regions or there might be multiple diagnostic settings configurations.

A query that spans more than three regions is considered a query that consumes excessive resources. A query that spans more than six regions is considered an abusive query and might be throttled.

> [!IMPORTANT]
> When a query is run across several regions, the CPU and data measurements won't be accurate and will represent the measurement of only one of the regions.

## Number of workspaces
Workspaces are logical containers that are used to segregate and administer logs data. The back end optimizes workspace placements on physical clusters within the selected region.

Use of multiple workspaces can result from instances when:

- Several workspaces are explicitly listed.
- A resource-scoped query is fetching data and the data is stored in multiple workspaces.

Cross-region and cross-cluster execution of queries requires the system to serialize and transfer in the back end large chunks of intermediate data that are usually much larger than the query final results. It also limits the system's ability to perform optimizations and heuristics and use caches.

A query that spans more than five workspaces is considered a query that consumes excessive resources. Queries can't span more than 100 workspaces.

> [!IMPORTANT]
> - In some multi-workspace scenarios, the CPU and data measurements won't be accurate and will represent the measurement of only a few of the workspaces.
> - Cross workspace queries having an explicit identifier: workspace ID, or workspace Azure Resource ID, consume less resources and are more performant. 

## Parallelism
Azure Monitor Logs uses large clusters of Azure Data Explorer to run queries. These clusters vary in scale and potentially get up to dozens of compute nodes. The system automatically scales the clusters according to workspace placement logic and capacity.

To efficiently execute a query, it's partitioned and distributed to compute nodes based on the data that's required for its processing. In some situations, the system can't do this step efficiently, which can lead to a long duration of the query.

Query behaviors that can reduce parallelism include:

- In many cases, operators such as [join](/azure/kusto/query/joinoperator?pivots=azuremonitor) and [summarize](/azure/kusto/query/summarizeoperator?pivots=azuremonitor) lower overall parallelism. Consider using [shuffle](/azure/kusto/query/shufflequery?pivots=azuremonitor) when performance is problematic. Use shuffle when a key (in other words, a column being joined or summarized by) has high cardinality. For example, use shuffle when a column contains public IP addresses. Avoid using shuffle for keys with low cardinality (such as the severity level of an event).
- Use of serialization and window functions, such as the [serialize operator](/azure/kusto/query/serializeoperator), [next()](/azure/kusto/query/nextfunction), [prev()](/azure/kusto/query/prevfunction), and the [row](/azure/kusto/query/rowcumsumfunction) functions. Time series and user analytics functions can be used in some of these cases. Inefficient serialization might also happen if the following operators aren't used at the end of the query: [range](/azure/kusto/query/rangeoperator), [sort](/azure/data-explorer/kusto/query/sort-operator), [order](/azure/kusto/query/orderoperator), [top](/azure/kusto/query/topoperator), [top-hitters](/azure/kusto/query/tophittersoperator), and [getschema](/azure/kusto/query/getschemaoperator).
- Use of the [dcount()](/azure/kusto/query/dcount-aggfunction) aggregation function forces the system to have a central copy of the distinct values. When the scale of data is high, consider using the `dcount` function optional parameters to reduce accuracy.
- In resource-scope queries, the pre-execution Kubernetes role-based access control (RBAC) or Azure RBAC checks might linger in situations where there's a large number of Azure role assignments. This situation might lead to longer checks that would result in lower parallelism. For example, a query might be executed on a subscription where there are thousands of resources and each resource has many role assignments on the resource level, not on the subscription or resource group.
- If a query is processing small chunks of data, its parallelism will be low because the system won't spread it across many compute nodes.

## Memory peak
Memory peak is the maximum amount of RAM that the Azure Data Explorer engine observed while executing a query. It covers memory used for data loading (cache/hot reads), operator processing (for example, join, summarize, make-series), and temporary working sets. 
It's a leading indicator for runaway memory conditions that trigger protections such as runaway queries (E_RUNAWAY_QUERY, operator exceeded memory budget) and E_LOW_MEMORY_CONDITION. Monitoring memory peak helps you catch these patterns early and tune queries before they hit related hard limits.

### How to reduce Memory Peak
- Follow the same practices as desribed for [Total CPU](#total-cpu). Specifically, for each table of the query, apply early filtering of records and projection of columns.
- In many cases, operators such as [join](/azure/kusto/query/joinoperator?pivots=azuremonitor) and [summarize](/azure/kusto/query/summarizeoperator?pivots=azuremonitor) lead to high memory usage and can result in a runaway query. Consider using [shuffle](/azure/kusto/query/shufflequery?pivots=azuremonitor) when performance is problematic. The rule of thumb should be using shuffle when key (i.e. column being joined or summarized by) has high cardinality (An example is a column of public IP addresses), and avoid using it for keys with low cardinality (Such as a severity level of an event).
- If using [join](/azure/kusto/query/joinoperator?pivots=azuremonitor), use best practices where applicable. See [Query best practices](/azure/kusto/query/best-practices).
- Consider using sampling

## Next steps

[Reference documentation for the Kusto Query Language](/azure/kusto/query/)
