---
title: Create a transformation in Azure Monitor
description: Create a transformation in Azure Monitor and add it to a data collection rule (DCR).
ms.topic: how-to
ms.date: 12/06/2024
ms.reviwer: nikeist

---

# Create a transformation in Azure Monitor

[Transformations in Azure Monitor](data-collection-transformations.md) allow you to filter or modify incoming data before it's stored in a Log Analytics workspace. They're implemented as a Kusto Query Language (KQL) statement in a [data collection rule (DCR)](data-collection-rule-overview.md). This article provides guidance on creating and testing a transformation query and adding it to a DCR.

> [!NOTE]
> If you're not familiar with KQL or creating log queries for Azure Monitor data, start with [Overview of Log Analytics in Azure Monitor](../logs/log-analytics-overview.md) and [Log queries in Azure Monitor](../logs/log-query-overview.md).

## Basic query structure

All transformation queries start with `source`, which is a virtual table that represents the input stream. You can then use any supported KQL operators to filter, modify, or add columns to the data as you would with any other table. The query is applied individually to each entry sent by the data source. 

The output of the query must match the schema of the target table with the following considerations:

* You may omit any columns that shouldn't be populated. The column will be empty for the record in the target table.
* Make sure to exclude any columns that aren't included in the output table. The data will be accepted without error, but you'll be charged for the ingestion of the extra data even though it's not stored.
* The output of every transformation must contain a valid timestamp in a column called `TimeGenerated` of type `datetime`. If your data source doesn't include this property, you can add it in the transformation with `extend` or `project`.

Following is an example of a transformation that performs several functions:

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

> [!NOTE]
> See [Data collection rule (DCR) samples and scenarios in Azure Monitor](data-collection-rule-samples.md) for various samples for different scenarios.

## Create the transformation query

Before you create or edit the DCR that will include your transformation, you'll need to create and test the transformation query. You'll typically do this by running test queries against existing data or test data. When you get the results you want, you can replace the table name with `source` and paste it into your DCR as explained below in [Add transformation to DCR](#add-transformation-to-dcr).

> [!IMPORTANT]
> Transformations don't support all KQL features. See [Supported KQL features in Azure Monitor transformations](data-collection-transformations-kql.md) for supported features and limitations.

For example, if you're creating a transformation to filter Syslog events, you might start with the following query which you can run in Log Analytics.

```kusto
Syslog | where SeverityLevel != 'info'
```
You can paste this query into your DCR and then change the table name to `source`.

```kusto
source | where SeverityLevel != 'info'
```

Use one of the following strategies for data to use to test your query.

* If you're already collecting the data that you want to transform, then you can use Log Analytics to write a query that filters or modifies the data as needed. Copy the query text and paste it into your DCR.
* Use Log Analytics to write your query using the [`datatable`](/kusto/query/datatable-operator) operator to create a sample data set that represents your incoming data. Copy the query text without the `datatable` operator and paste it into your DCR.
* Use the process to [create a new table](../logs/create-custom-table.md) in the Azure portal and provide sample data. Use the included interface to create and test your transformation query. Either copy the query text and paste into your DCR, or complete the process and then edit the DCR to copy the transformation query. You can then delete the new table if you don't need it.

## Add transformation to DCR

Once you have your transformation query, you can add it to a DCR. Use the guidance in [Create and edit data collection rules (DCRs) in Azure Monitor](data-collection-rule-create-edit.md) to create or edit the DCR using the information in this section to include the transformation query in the DCR definition.

> [!NOTE]
> Some data sources will provide a method using the Azure portal to add a transformation to a DCR. For example, [collecting a text from a virtual machine](../agents/data-collection-log-text.md) allows you to specify a transformation query in the Azure portal. Most data collection scenarios though currently require you to work directly with the DCR definition to add a transformation. That's the process described in this section.

The transformation query is specified in the `transformKql` property in the [Data Flows](data-collection-rule-structure.md#data-flows) section of the DCR. This is the section that pairs a data source with a destination. The transformation is applied to the incoming stream of the data flow before it's sent to the destination. It will only apply to that data flow even if the same stream or destination is used in other data flows.

If the `transformKql` property is omitted, or if its value is simply `source`, then no transformation is applied, and the incoming data is sent to the destination without modification.

> [!IMPORTANT]
> The transformation query must be on a single line the DCR. If you're creating the transformation in the Azure portal, you can use multiple lines for readability, and `\n` will be included in the query for each new line.

In the following example, there's no `transformKql` property, so the incoming data is sent to the destination without modification.

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

In the following example, `transformKql` has a simple query of `source`, so the incoming data is sent to the destination without modification. Its functionality is identical to the previous example.

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
## Create workspace transformation DCR

The [workspace transformation data collection rule (DCR)](data-collection-transformations.md#workspace-transformation-dcr) is a special [DCR](data-collection-rule-overview.md) that's applied directly to a Log Analytics workspace. There can be only one workspace transformation DCR for each workspace, but it can include transformations for any number of tables.

Use one of the following methods to create a workspace transformation DCR for your workspace and add one or more transformations to it.

> [!NOTE]
> It may take up to 60 minutes for a new transformation query to be activated.


### [Azure portal](#tab/portal)

You can create a workspace transformation DCR in the Azure portal by adding a transformation to a supported table.

1. On the Log Analytics workspaces menu in the Azure portal, select **Tables**. Click to the right of the table you're interested in and select Create transformation.

    :::image type="content" source="media/data-collection-transformations-create/create-transformation-select.png" lightbox="media/data-collection-transformations-create/create-transformation-select.png" alt-text="Screenshot that shows the option to create a transformation for a table in the Azure portal.":::

1. If the workspace transformation DCR hasn't already been created for this workspace, select the option to create one. If it has already been created, then that DCR will already be selected. Each workspaces can only have one workspace transformation DCR.

    :::image type="content" source="media/data-collection-transformations-create/new-data-collection-rule.png" lightbox="media/data-collection-transformations-create/new-data-collection-rule.png" alt-text="Screenshot that shows creating a new data collection rule.":::

1. Select Next to view sample data from the table. Click **Transformation editor** to define the transformation query.

    :::image type="content" source="media/data-collection-transformations-create/sample-data.png" lightbox="media/data-collection-transformations-create/sample-data.png" alt-text="Screenshot that shows sample data from the log table.":::

1. You can then edit and run the transformation query to see the results against actual data from the table. Keep modifying and testing the query until you get the results you want.
1. When you're satisfied with the query, click **Apply** and then **Next** and **Create** to save the DCR with your new transformation.

    :::image type="content" source="media/data-collection-transformations-create/save-transformation.png" lightbox="media/data-collection-transformations-create/save-transformation.png" alt-text="Screenshot that shows saving the transformation.":::

### [JSON](#tab/json)

Workspace transformation DCRs are mostly like any other DCR. They use the same JSON structure for their definition, and you can create and edit them using the same commands and strategies described in [Create or edit a DCR using JSON](data-collection-rule-create-edit.md#create-or-edit-a-dcr-using-json). The differences are with the JSON definition:

* It must include the `kind` parameter with a value of `WorkspaceTransforms`.
* The `dataSources` section must be empty.
* The `destinations` section must include one and only one Log Analytics workspace destination. This is the workspace where the transformation will be applied.
* The `dataFlows` section should include a separate dataflow for each table that will have a transformation. Use a `where` clause in the query if only certain records should be transformed.

Following is a sample JSON definition for a workspace transformation DCR.

```json
{
    "kind": "WorkspaceTransforms",
    "location": "eastus",
    "properties": {
        "dataSources": {},
        "destinations": {
            "logAnalytics": [
                {
                    "workspaceResourceId": "/subscriptions/71b36fb6-4fe4-4664-9a7b-245dc62f2930/resourcegroups/my-resource-group/providers/microsoft.operationalinsights/workspaces/my-workspace",
                    "name": "MyWorkspace"
                }
            ]
        },
        "dataFlows": [
            {
                "streams": [
                    "Microsoft-Table-LAQueryLogs"
                ],
                "destinations": [
                    "MyWorkspace"
                ],
                "transformKql": "source | where QueryText !contains 'LAQueryLogs'"
            },
            {
                "streams": [
                    "Microsoft-Table-Event"
                ],
                "destinations": [
                    "MyWorkspace"
                ],
                "transformKql": "source | project-away ParameterXml"
            }
        ],
        "provisioningState": "Succeeded"
    }
}
```

---

## Optimize and monitor transformations

Transformations run a KQL query against every record collected with the DCR, so it's important that they run efficiently. Transformation execution time contributes to overall [data ingestion latency](../logs/data-ingestion-time.md), and transformations that take excessive time to run can impact the performance of data collection and result in data loss. Optimal transformations should take no more than 1 second to run. See [Optimize log queries in Azure Monitor](../logs/query-optimization.md) for guidance on testing your query before you implement it as a transformation and for recommendations on optimizing queries that don't run efficiently.

> [!IMPORTANT]
> You may experience data loss if a transformation takes more than 20 seconds.

Because transformations don't run interactively, it's important to continuously monitor them to ensure that they're running properly and not taking excessive time to process data. See [Monitor and troubleshoot DCR data collection in Azure Monitor](data-collection-monitor.md) for details on logs and metrics that monitor the health and performance of transformations. This includes identifying any errors that occur in the KQL and metrics to track their running duration.

The following metrics are automatically collected for transformations and should be reviewed regularly to verify that your transformations are still running as expected. Create [metric alert rules](../alerts/alerts-create-metric-alert-rule.md) to be automatically notified when one of these metrics exceeds a threshold.

* Logs Transformation Duration per Min
* Logs Transformation Errors per Min

[Enable DCR error logs](data-collection-monitor.md#enable-dcr-error-logs) to track any errors that occur in your transformations or other queries. Create a [log alert rule](../alerts/alerts-create-log-alert-rule.md) to be automatically notified when an entry is written to this table.

## Guidance

There are multiple methods to create transformations depending on the data collection method. The following table lists guidance for different methods for creating transformations.

| Data collection | Reference |
|:----------------|:----------|
| Logs ingestion API | [Send data to Azure Monitor Logs by using REST API (Azure portal)](../logs/tutorial-logs-ingestion-portal.md)<br>[Send data to Azure Monitor Logs by using REST API (Azure Resource Manager templates)](../logs/tutorial-logs-ingestion-api.md) |
| Virtual machine with Azure Monitor agent | [Add transformation to Azure Monitor Log](../agents/azure-monitor-agent-transformation.md) |
| Kubernetes cluster with Container insights | [Data transformations in Container insights](../containers/container-insights-transformations.md) |
| Azure Event Hubs | [Tutorial: Ingest events from Azure Event Hubs into Azure Monitor Logs (Public Preview)](../logs/ingest-logs-event-hub.md) |

## Limitations and considerations

* Not all tables in a Log Analytics workspace support transformations. See [Tables that support transformations in Azure Monitor Logs](../logs/tables-feature-support.md) for a list of supported tables.
* Not all KQL operators are supported in transformation queries. See [Supported KQL features in Azure Monitor transformations](/azure/azure-monitor/essentials/data-collection-transformations-kql).
* While a transformation can send a single data source to multiple tables, it can't send data to multiple workspaces. To send data from a single data source to multiple workspaces, create multiple DCRs.
* The workspace transformation DCR can't send a single data source to multiple tables since the transformation is applied to the table itself.
* Transformations in the workspace transformation DCR are applied to all data sent to the table, regardless of the data source. If you need to apply different transformations to different data sources, use a `where` statement in the transformation query to apply different logic to data from different sources.

## Next steps

* [Create a data collection rule](../vm/data-collection.md) and an association to it from a virtual machine using the Azure Monitor agent.
