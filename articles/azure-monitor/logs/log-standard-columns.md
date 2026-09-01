---
title: Standard columns in Azure Monitor log records
description: Describes columns that are common to multiple data types in Azure Monitor logs.
ms.topic: concept-article
ms.date: 08/24/2026
ai-usage: ai-assisted

---

# Standard columns in Azure Monitor Logs
Data in Azure Monitor Logs is [stored as a set of records in either a Log Analytics workspace or Application Insights application](../logs/data-platform-logs.md). Each data type has a unique set of columns. Many data types have standard columns that are common across multiple types. This article describes these columns and provides examples of how to use them in queries.

Workspace-based applications in Application Insights store their data in a Log Analytics workspace and use the same standard columns as other tables in the workspace. Classic applications store their data separately and have different standard columns as specified in this article.

The following table summarizes the standard columns. Classic Application Insights tables use different column names where noted.

| Column | Description | Applies to |
|--------|-------------|------------|
| `TenantId` | Workspace ID for the Log Analytics workspace. | Workspace |
| `TimeGenerated` | Date and time the record was created by the data source. Classic Application Insights tables use `Timestamp`. | Workspace and classic Application Insights |
| `_TimeReceived` | Date and time the record was received by the Azure Monitor ingestion point. | Workspace |
| `Type` | Name of the table the record was retrieved from. Classic Application Insights tables use `itemType`. | Workspace and classic Application Insights |
| `_ItemId` | Unique identifier for the record. | Workspace |
| `_ResourceId` | Unique identifier for the resource the record is associated with. | Workspace |
| `_SubscriptionId` | Subscription ID of the resource the record is associated with. | Workspace |
| `_IsBillable` | Whether the ingested data is billable. | Workspace |
| `_BilledSize` | Size in bytes of the billed data. | Workspace |

> [!NOTE]
> Some of the standard columns don't show in the schema view or IntelliSense in Log Analytics. They don't show in query results unless you explicitly specify the column in the output.

## TenantId column
The **TenantId** column holds the workspace ID for the Log Analytics workspace.

## TimeGenerated column
The **TimeGenerated** column contains the date and time when the data source created the record. For more information, see [Log data ingestion time in Azure Monitor](../logs/data-ingestion-time.md).

**TimeGenerated** provides a common column to use for filtering or summarizing by time. When you select a time range for a view or dashboard in the Azure portal, it uses **TimeGenerated** to filter the results.

Tables that support classic Application Insights resources use the **Timestamp** column instead of the **TimeGenerated** column. The **TimeGenerated** value can't be older than two days before the received time or more than a day in the future. If the value falls outside that range, Azure Monitor replaces it with the actual received time.

### Examples

The following query returns the number of error events created for each day in the previous week.

```Kusto
Event
| where EventLevelName == "Error" 
| where TimeGenerated between(startofweek(ago(7days))..endofweek(ago(7days))) 
| summarize count() by bin(TimeGenerated, 1day) 
| sort by TimeGenerated asc 
```
## \_TimeReceived column
The **\_TimeReceived** column contains the date and time that the record was received by the Azure Monitor ingestion point in the Azure cloud. This can be useful for identifying latency issues between the data source and the cloud. An example would be a networking issue causing a delay with data being sent from an agent. See [Log data ingestion time in Azure Monitor](../logs/data-ingestion-time.md) for more details.

> [!NOTE]
> The **\_TimeReceived** column is calculated each time it is used. This process is resource intensive. Refrain from using it to filter large number of records. Using this function recurrently can lead to increased query execution duration.


The following query gives the average latency by hour for event records from an agent. This includes the time from the agent to the cloud and the total time for the record to be available for log queries.

```Kusto
Event
| where TimeGenerated > ago(1d) 
| project TimeGenerated, TimeReceived = _TimeReceived, IngestionTime = ingestion_time() 
| extend AgentLatency = toreal(datetime_diff('Millisecond',TimeReceived,TimeGenerated)) / 1000
| extend TotalLatency = toreal(datetime_diff('Millisecond',IngestionTime,TimeGenerated)) / 1000
| summarize avg(AgentLatency), avg(TotalLatency) by bin(TimeGenerated,1hr)
``` 

## Type column
The **Type** column holds the name of the table that the record was retrieved from which can also be thought of as the record type. This column is useful in queries that combine records from multiple tables, such as those that use the `search` operator, to distinguish between records of different types. **$table** can be used in place of **Type** in some queries.

> [!NOTE]
> Tables supporting classic Application Insights resources use the **itemType** column instead of the **Type** column.

### Examples
The following query returns the count of records by type collected over the past hour.

```Kusto
search * 
| where TimeGenerated > ago(1h)
| summarize count() by Type

```
## \_ItemId column
The **\_ItemId** column holds a unique identifier for the record.


## \_ResourceId column
The **\_ResourceId** column holds a unique identifier for the resource that the record is associated with. This gives you a standard column to use to scope your query to only records from a particular resource, or to join related data across multiple tables.

For Azure resources, the value of **_ResourceId** is the [Azure resource ID URL](/azure/azure-resource-manager/templates/template-functions-resource). The column is limited to Azure resources, including [Azure Arc](/azure/azure-arc/overview) resources, or to custom logs that indicated the Resource ID during ingestion.

> [!NOTE]
> Some data types already have fields that contain Azure resource ID or at least parts of it like subscription ID. While these fields are kept for backward compatibility, it's recommended to use the _ResourceId to perform cross correlation since it's more consistent.

### Examples
The following query joins performance and event data for each computer. It shows all events with an ID of _101_ and processor utilization over 50%.

```Kusto
Perf 
| where CounterName == "% User Time" and CounterValue  > 50 and _ResourceId != "" 
| join kind=inner (     
    Event 
    | where EventID == 101 
) on _ResourceId
```

The following query joins _AzureActivity_ records with _SecurityEvent_ records. It shows all activity operations with users that were logged in to these machines.

```Kusto
AzureActivity 
| where  
    OperationName in ("Restart Virtual Machine", "Create or Update Virtual Machine", "Delete Virtual Machine")  
    and ActivityStatus == "Succeeded"  
| join kind= leftouter (    
   SecurityEvent 
   | where EventID == 4624  
   | summarize LoggedOnAccounts = makeset(Account) by _ResourceId 
) on _ResourceId  
```

The following query parses **_ResourceId** and aggregates billed data volumes per Azure Resource Group.

```Kusto
union withsource = tt * 
| where _IsBillable == true 
| parse tolower(_ResourceId) with "/subscriptions/" subscriptionId "/resourcegroups/" 
    resourceGroup "/providers/" provider "/" resourceType "/" resourceName   
| summarize Bytes=sum(_BilledSize) by resourceGroup | sort by Bytes nulls last 
```

Use these `union withsource=tt *` queries sparingly because scans across data types are expensive to execute.

It is always more efficient to use the \_SubscriptionId column than extracting it by parsing the \_ResourceId column.

## \_SubscriptionId column
The **\_SubscriptionId** column holds the subscription ID of the resource that the record is associated with. This gives you a standard column to use to scope your query to only records from a particular subscription, or to compare different subscriptions.

For Azure resources, the value of **\_SubscriptionId** is the subscription part of the [Azure resource ID URL](/azure/azure-resource-manager/templates/template-functions-resource). This column is limited to Azure resources, including [Azure Arc](/azure/azure-arc/overview) resources, or to custom logs that indicate the subscription ID during ingestion.

> [!NOTE]
> Some data types already have fields that contain Azure subscription ID . While these fields are kept for backward compatibility, it's recommended to use the \_SubscriptionId column to perform cross correlation since it's more consistent.
### Examples
The following query examines performance data for computers of a specific subscription. 

```Kusto
Perf 
| where TimeGenerated > ago(24h) and CounterName == "memoryAllocatableBytes"
| where _SubscriptionId == "ebb79bc0-aa86-44a7-8111-cabbe0c43993"
| summarize avgMemoryAllocatableBytes = avg(CounterValue) by Computer
```

The following query parses **_ResourceId** and aggregates billed data volumes per Azure subscription.

```Kusto
union withsource = tt * 
| where _IsBillable == true 
| summarize Bytes=sum(_BilledSize) by _SubscriptionId | sort by Bytes nulls last 
```

As noted for the [_ResourceId column](#_resourceid-column), use `union withsource = tt *` queries sparingly because scans across data types are expensive to execute.


## \_IsBillable column
The **\_IsBillable** column specifies whether ingested data is considered billable. Data with **\_IsBillable** equal to `false` does not incur data ingestion, retention, workspace replication, or archive charges. 

### Examples
To get a list of computers sending billed data types, use the following query. As noted for the [_ResourceId column](#_resourceid-column), use `union withsource = tt *` queries sparingly because scans across data types are expensive to execute.

```Kusto
union withsource = tt * 
| where _IsBillable == true 
| extend computerName = tolower(tostring(split(Computer, '.')[0]))
| where computerName != ""
| summarize TotalVolumeBytes=sum(_BilledSize) by computerName
```

This can be extended to return the count of computers per hour that are sending billed data types:

```Kusto
union withsource = tt * 
| where _IsBillable == true 
| extend computerName = tolower(tostring(split(Computer, '.')[0]))
| where computerName != ""
| summarize dcount(computerName) by bin(TimeGenerated, 1h) | sort by TimeGenerated asc
```

## \_BilledSize column
The **\_BilledSize** column specifies the size in bytes of data that's billed to your Azure account if **\_IsBillable** is true. See [Data size calculation](cost-logs.md#data-size-calculation) to learn more about the details of how the billed size is calculated. 


### Examples
To see the size of billable events ingested per computer, use the `_BilledSize` column, which provides the size in bytes:

```Kusto
union withsource = tt * 
| where _IsBillable == true 
| summarize Bytes=sum(_BilledSize) by  Computer | sort by Bytes nulls last 
```

To see the size of billable events ingested per subscription, use the following query:

```Kusto
union withsource = tt * 
| where _IsBillable == true 
| summarize Bytes=sum(_BilledSize) by  _SubscriptionId | sort by Bytes nulls last 
```

To see the size of billable events ingested per resource group, use the following query:

```Kusto
union withsource = tt * 
| where _IsBillable == true 
| parse _ResourceId with "/subscriptions/" SubscriptionId "/resourcegroups/" ResourceGroupName "/" *
| summarize Bytes=sum(_BilledSize) by  _SubscriptionId, ResourceGroupName | sort by Bytes nulls last 

```


To see the count of events ingested per computer, use the following query:

```Kusto
union withsource = tt *
| summarize count() by Computer | sort by count_ nulls last
```

To see the count of billable events ingested per computer, use the following query: 

```Kusto
union withsource = tt * 
| where _IsBillable == true 
| summarize count() by Computer  | sort by count_ nulls last
```

To see the count of billable data types from a specific computer, use the following query:

```Kusto
union withsource = tt *
| where Computer == "computer name"
| where _IsBillable == true 
| summarize count() by tt | sort by count_ nulls last 
```

## Next steps

- Read more about how [Azure Monitor log data is stored](./log-query-overview.md).
- Get a lesson on [writing log queries](./get-started-queries.md).
- Get a lesson on [joining tables in log queries](/azure/data-explorer/kusto/query/samples?&pivots=azuremonitor#joins).
