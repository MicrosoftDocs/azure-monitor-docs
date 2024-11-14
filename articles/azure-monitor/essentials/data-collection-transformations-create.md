---
title: Create a transformation in Azure Monitor
description: Create a transformation in Azure Monitor
author: bwren
ms.author: bwren
ms.topic: conceptual
ms.date: 10/15/2024
ms.reviwer: nikeist

---

# Create a transformation in Azure Monitor
[Transformations in Azure Monitor](./data-collection-transformations.md) allow you to filter or modify incoming data before it's stored in a Log Analytics workspace. They're implemented as a Kusto Query Language (KQL) statement in a [data collection rule (DCR)](data-collection-rule-overview.md). This article provides guidance on creating a transformation with a DCR or adding one to an existing DCR.

> [!NOTE]
> When you [create a new table](../logs/create-custom-table.md) in a Log Analytics workspace using the Azure portal, you're prompted to create a transformation using sample data that you provide. This transformation is included in the DCR created as part of the table creation process. 

## Transformation query
Regardless of the method you use to create or edit the DCR with your transformation, you'll need to create the KQL statement that filters or modifies the incoming data. This query is applied individually to each entry in the data source. It must understand the format of the incoming data and create output in the structure of the target table. 

There are multiple strategies you can use to create and test the transformation query before you add it to your DCR.

- If you're already collecting the data that you want to transform, then you can use Log Analytics to write a query that filters or modifies the data as needed. Copy the query text and paste it into your DCR.
- Use Log Analytics to write your query using the [`datatable`](/kusto/query/datatable-operator) operator to create a sample data set that represents your incoming data. Copy the query text without the `datatable` operator and paste it into your DCR.
- Use the process to create a new table in the Azure portal, providing sample data. Use the included interface to create and test your transformation query. Either copy the query text and paste into your DCR, or complete the process and then edit the DCR to copy the transformation query. You can then delete the new table if you don't need it.


### Source table

All transformation queries start with `source`, which is a virtual table that represents the input stream. The columns of the `source` table match the columns of the incoming data stream. 

The following query simply returns the incoming data without modification. This is the equivalent of using a table name in a log query that simply returns all records. It's also the equivalent of not including a transformation in the DCR.

```kusto
source
```

### Typical transformation queries
This section describes basic strategies with simple examples of common transformation queries. You can use these as a starting point to more complex queries that you may require to meet your specific requirements.

> [!IMPORTANT]
> Not all KQL operators are supported in transformation queries, and there are special operators only available in transformations. See [Supported KQL features in Azure Monitor transformations](./data-collection-transformations-kql.md) for a complete list of supported KQL features.

**Filter data**

Use a `where` statement to filter the incoming data. If the incoming record doesn't match the statement, then the record is not sent to the destination. In the following example, only records with a severity of "Critical" are sent to the destination.

```kusto
source | where severity == "Critical" 
```

**Modify schema**

Use commands such as `extend` and `project` to modify the schema of the incoming data to match the target table. In the following example, a new column called `TimeGenerated` is added to outgoing data using a KQL function to return the current time.

```kusto
source | extend TimeGenerated = now()
```

**Parse data**

Use the `split` or `parse` operator to parse data into multiple columns in the destination table. In the following example, the incoming data has a comma-delimited column named `RawData` that's split into individual columns for the destination table.

```kusto
source | project d = split(RawData,",") | project TimeGenerated=todatetime(d[0]), Code=toint(d[1]), Severity=tostring(d[2]), Module=tostring(d[3]), Message=tostring(d[4])
```

**Combine functions**

A transformation can include multiple functions to filter, modify, and format the incoming data. The following sample query does the following:

- Filters the incoming data with a [`where`](/azure/data-explorer/kusto/query/whereoperator) statement. This assumes that the incoming data has a column named `severity`.
- Adds a new column using the [`extend`](/azure/data-explorer/kusto/query/extendoperator) and `parse_json` operators. This assumes that the incoming data has a column named `properties` that contains a JSON object.
- Formats the output to match the columns of the target table using the [`project`](/azure/data-explorer/kusto/query/projectoperator) operator. This assumes that the incoming data has columns named `time`. `category`, `StatusDescription`, `name`, and a dynamic column named `Properties`. It also assumes that the target table has columns named `Category`, `StatusDescription`, `EventName`,  `EventId`. (All tables have a column named `TimeGenerated`.)

```kusto
source  
| where severity == "Critical" 
| extend Properties = parse_json(properties)
| project
    TimeGenerated = todatetime(["time"]),
    Category = category,
    StatusDescription = StatusDescription,
    EventName = name,
    EventId = tostring(Properties.EventId)
```

> [!IMPORTANT]
> The transformation query must be on a single line the DCR. If you're creating the transformation in the Azure portal, you can use multiple lines for readability, and `\n` will be included in the query for each new line.

## Add transformation to DCR

> [!NOTE]
> Some data sources will provide a method using the Azure portal to add a transformation to a DCR. For example, 

The transformation query is specified in the `transformKql` property in the [Data Flows](./data-collection-rule-structure.md#data-flows) section of the DCR. The transformation is applied to the incoming stream of the data flow before it's sent to the destination. The transformation will only apply to that data flow even if the same stream or destination are used in other data flows. 

If the `transformKql` property is omitted, or if it's value is simply `source`, then no transformation is applied, and the incoming data is sent to the destination without modification.

In the following example, there is no `transformKql` property, so the incoming data is sent to the destination without modification.

```json
"dataFlows": [ 
    { 
        "streams": [ 
        "Microsoft-Syslog" 
        ], 
        "destinations": [ 
        "centralWorkspace" 
        ] 
    } 
] 
```

In the following example, `transformKql` has a simple query of `source`, so the incoming data is sent to the destination without modification. It's functionality is identical to the previous example. 

```json
"dataFlows": [ 
    { 
        "streams": [ 
        "Microsoft-Syslog" 
        ], 
        "transformKql": "source", 
        "destinations": [ 
        "centralWorkspace" 
        ] 
    } 
] 
```

In the following example, `transformKql` has a query that filters data, so only error messages are sent to the destination.

```json
"dataFlows": [ 
    { 
        "streams": [ 
        "Microsoft-Syslog" 
        ], 
        "transformKql": "source | where message has 'error'", 
        "destinations": [ 
        "centralWorkspace" 
        ] 
    } 
] 
```


## Guidance
There are multiple methods to create transformations depending on the data collection method. The following table lists guidance for different methods for creating transformations.

| Data collection | Reference |
|:---|:---|
| Logs ingestion API | [Send data to Azure Monitor Logs by using REST API (Azure portal)](../logs/tutorial-logs-ingestion-portal.md)<br>[Send data to Azure Monitor Logs by using REST API (Azure Resource Manager templates)](../logs/tutorial-logs-ingestion-api.md) |
| Virtual machine with Azure Monitor agent | [Add transformation to Azure Monitor Log](../agents/azure-monitor-agent-transformation.md) |
| Kubernetes cluster with Container insights | [Data transformations in Container insights](../containers/container-insights-transformations.md) |
| Azure Event Hubs | [Tutorial: Ingest events from Azure Event Hubs into Azure Monitor Logs (Public Preview)](../logs/ingest-logs-event-hub.md) |


## Send data to multiple destinations

With transformations, you can send data to multiple destinations in a Log Analytics workspace by using a single DCR. You provide a KQL query for each destination, and the results of each query are sent to their corresponding location. You can send different sets of data to different tables or use multiple queries to send different sets of data to the same table. To use multiple destinations, you must currently either manually create a new DCR or [edit an existing one](data-collection-rule-edit.md). 

For example, you might send event data into Azure Monitor by using the Logs Ingestion API. Most of the events should be sent an analytics table where it could be queried regularly, while audit events should be sent to a custom table configured for [basic logs](../logs/logs-table-plans.md) to reduce your cost.

> [!IMPORTANT]
> Currently, the tables in the DCR must be in the same Log Analytics workspace. To send to multiple workspaces from a single data source, use multiple DCRs and configure your application to send the data to each.

:::image type="content" source="media/data-collection-transformations/transformation-multiple-destinations.png" lightbox="media/data-collection-transformations/transformation-multiple-destinations.png" alt-text="Diagram that shows transformation sending data to multiple tables." border="false":::



## Parse data
A common use of transformations is to parse incoming data into multiple columns to match the schema of the destination table. For example, you may collect entries from a log file that isn't in a structured format and need to parse the data into columns for the table. 


## Next steps

- [Create a data collection rule](../agents/azure-monitor-agent-data-collection.md) and an association to it from a virtual machine using the Azure Monitor agent.
