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
[Transformations in Azure Monitor](./data-collection-transformations.md) allow you to filter or modify incoming data before it's stored in a Log Analytics workspace. They're implemented as a Kusto Query Language (KQL) statement in a [data collection rule (DCR)](data-collection-rule-overview.md). This article provides guidance on creating and testing as transformation query and adding it to a DCR.

## Basic query structure
All transformation queries start with `source`, which is a virtual table that represents the input stream. You can then use any supported KQL operators to filter, modify, or add columns to the data as you would with any other table. The query is applied individually to each entry sent by the data source. 

The output of the query must match the schema of the target table with the following considerations:

- You may omit any columns that shouldn't be populated. The column will be empty for the record in the target table.
- Make sure to exclude any columns that are not included in the output table. The data will be accepted without error, but you'll be charged for the ingestion of the extra data even though it's not stored.
- The output of every transformation must contain a valid timestamp in a column called `TimeGenerated` of type `datetime`. If your data source doesn't include this property, you can add it in the transformation with `extend` or `project`.

Following is a typical example of a transformation. This example includes the following functionality:

* Filters the incoming data with a [`where`](/azure/data-explorer/kusto/query/whereoperator) statement.
* Adds a new column using the [`extend`](/azure/data-explorer/kusto/query/extendoperator) operator.
* Formats the output to match the columns of the target table using the [`project`](/azure/data-explorer/kusto/query/projectoperator) operator.

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

See [Sample transformations in Azure Monitor](./data-collection-rule-samples.md) for a more complete set of samples for different scenarios. 

## Create the transformation query
Before you create or edit the DCR that will include your transformation, you'll need to create and test the transformation query. You'll typically do this by running test queries against existing data or test data. When you get the results you want, you can replace the table name with source and paste it into your DCR as explained below in [Add transformation to DCR](#add-transformation-to-dcr).

You'll need some data to work with, so you'll typically use one of the following strategies.

- If you're already collecting the data that you want to transform, then you can use Log Analytics to write a query that filters or modifies the data as needed. Copy the query text and paste it into your DCR.
- Use Log Analytics to write your query using the [`datatable`](/kusto/query/datatable-operator) operator to create a sample data set that represents your incoming data. Copy the query text without the `datatable` operator and paste it into your DCR.
- Use the process to create a new table in the Azure portal and provide sample data. Use the included interface to create and test your transformation query. Either copy the query text and paste into your DCR, or complete the process and then edit the DCR to copy the transformation query. You can then delete the new table if you don't need it.

## Add transformation to DCR

> [!NOTE]
> Some data sources will provide a method using the Azure portal to add a transformation to a DCR. For example, [collecting a text from a virtual machine](../agents/data-collection-log-text.md) allows you to specify a transformation query in the Azure portal. Most data collection scenarios though currently require you to work directly with the DCR definition to add a transformation. That's the process described in this section.

The transformation query is specified in the `transformKql` property in the [Data Flows](./data-collection-rule-structure.md#data-flows) section of the DCR. This is the section that pairs a data source with a destination. The transformation is applied to the incoming stream of the data flow before it's sent to the destination. The transformation will only apply to that data flow even if the same stream or destination are used in other data flows. 

If the `transformKql` property is omitted, or if it's value is simply `source`, then no transformation is applied, and the incoming data is sent to the destination without modification.

> [!IMPORTANT]
> The transformation query must be on a single line the DCR. If you're creating the transformation in the Azure portal, you can use multiple lines for readability, and `\n` will be included in the query for each new line.

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



## Next steps

- [Create a data collection rule](../agents/azure-monitor-agent-data-collection.md) and an association to it from a virtual machine using the Azure Monitor agent.
