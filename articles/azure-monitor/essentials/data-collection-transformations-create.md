---
title: Structure of transformation in Azure Monitor
description: Structure of transformation in Azure Monitor including limitations of KQL allowed in a transformation.
author: bwren
ms.author: bwren
ms.topic: conceptual
ms.date: 10/15/2024
ms.reviwer: nikeist

---

# Create a transformation in Azure Monitor
[Transformations in Azure Monitor](./data-collection-transformations.md) allow you to filter or modify incoming data before it's stored in a Log Analytics workspace. They're implemented as a Kusto Query Language (KQL) statement in a [data collection rule (DCR)](data-collection-rule-overview.md). This article provides guidance on creating a transformation with a DCR or adding one to an existing DCR.

## Transformation query
Regardless of the method you use to create the transformation, you'll need to create the KQL statement that filters or modifies the incoming data. This query is applied individually to each entry in the data source. It must understand the format of the incoming data and create output in the structure of the target table. 

> [!IMPORTANT]
> Not all KQL operators are supported in transformation queries, and there are special operators only available in transformations. See [Supported KQL features in Azure Monitor transformations](./data-collection-transformations-kql.md) for a complete list of supported KQL features.

A virtual table named `source` represents the input stream. The columns of the `source` table match the columns of the incoming data stream. 

**No transformation**
The following query simply returns the incoming data without modification. This is the equivalent of using a table name in a log query that simply returns all records.

```kusto
source
```

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
A transformation can include multiple functions to filter, modify, and format the incoming data. Following is an:

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

## DCR
The transformation is specified in the `transformKql` property in the [Data FLows](./data-collection-rule-structure.md#data-flows) section of the DCR. The transformation is applied to the data source of the data flow before it's sent to the destination. 

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

In the following example, `transformKql` has a simple query of `source`, so the incoming data is sent to the destination without modification.

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
