---
title: Create a transformation in Azure Monitor
description: Create a transformation in Azure Monitor and add it to a data collection rule (DCR).
ms.topic: how-to
ms.date: 05/15/2026
ms.reviewer: nikeist
ai-usage: ai-assisted

---

# Create a transformation in Azure Monitor

[Transformations in Azure Monitor](data-collection-transformations.md) filter or modify incoming data before storing it in a Log Analytics workspace. Implement transformations as a Kusto Query Language (KQL) statement in a [data collection rule (DCR)](data-collection-rule-overview.md). This article provides guidance on creating and testing a transformation query and adding it to a DCR.

## Basic query structure

All transformation queries start with `source`, which is a virtual table that represents the input stream. You can then use any supported KQL operators to filter, modify, or add columns to the data as you would with any other table. The query is applied individually to each entry sent by the data source. 

The output of the query must match the schema of the target table with the following considerations:

- Omit columns that you don't want to save costs. When you omit a column, that column is empty for each record in the target table.
- Exclude any columns that aren't in the output table. Extra columns are accepted without error, but you pay for ingesting data that isn't stored.
- Include a valid timestamp in a column called `TimeGenerated` of type `datetime`. If your data source doesn't include this property, add it by using `extend` or `project`.

The following transformation is an example that performs three functions:

* Filters the incoming data by using a [`where`](/azure/data-explorer/kusto/query/whereoperator) statement.
* Adds a new column `Properties` by using the [`extend`](/azure/data-explorer/kusto/query/extendoperator) operator with the `parse_json` function to parse JSON values from the incoming `properties` column.
* Formats the transformation output to exactly match the columns of the target table by using the [`project`](/azure/data-explorer/kusto/query/projectoperator) operator.

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

See [Data collection rule (DCR) samples and scenarios in Azure Monitor](data-collection-rule-samples.md) for various samples of different scenarios.

## Create the transformation query

Before you add a transformation to a DCR, create and test the query in Log Analytics. When your query returns the expected results, replace the table name with `source` and add it to your DCR as described in [Add transformation to DCR](#add-transformation-to-dcr).

> [!IMPORTANT]
> Transformations don't support all KQL features. See [Supported KQL features in Azure Monitor transformations](data-collection-transformations-kql.md) for supported features and limitations.

| Transformation test strategy | Description |
|:-----------------|:------------|
| **Query existing data.**  | If you're already collecting the data you want to transform, write a query against that table in Log Analytics. Verify that the output shows the expected filtering or modifications, then copy the query text. |
| **Use sample data with `datatable`.** | Write a query using the [`datatable`](/kusto/query/datatable-operator) operator to create a sample dataset that represents your incoming data. Verify the query output, then copy the query text without the `datatable` operator. |
| **Create a test table in the portal.** | [Create a new table](../logs/create-custom-table.md) in the Azure portal and provide sample data. Use the built-in transformation editor to write and test your query. Copy the query text when you're satisfied with the results. |

For example, to filter Syslog events, start with this query in Log Analytics:

```kusto
Syslog | where SeverityLevel != 'info'
```
Then replace the table name with `source` in your DCR:

```kusto
source | where SeverityLevel != 'info'
```

## Add transformation to DCR

After you have your transformation query, add it to a DCR by following these steps:

1. Get the current DCR definition. Either open your DCR definition in the UI and select the JSON view, or export the the JSON using the Azure CLI:

    ```azurecli
    az monitor data-collection rule show --name {dcrName} --resource-group {resourceGroupName} > dcr.json
    ```

    For more information, see [Create and edit data collection rules (DCRs) in Azure Monitor](data-collection-rule-create-edit.md).

1. Locate the `dataFlows` section of the DCR. This section pairs a data source with a destination.
1. Add the `transformKql` JSON property to the data flow you want to transform. Set its value to your transformation query on a single line. The transformation is applied to the incoming stream before it's sent to the destination and only applies to that data flow, even if the same stream or destination is used in other data flows.
1. Save and deploy the updated DCR:

    ```azurecli
    az monitor data-collection rule update --name {dcrName} --resource-group {resourceGroupName} --body @dcr.json
    ```

    For other methods, see [Create and edit data collection rules (DCRs) in Azure Monitor](data-collection-rule-create-edit.md).

> [!NOTE]
> Some data sources provide a method using the Azure portal to add a transformation to a DCR. For example, [collecting a text from a virtual machine](../agents/data-collection-log-text.md) allows you to specify a transformation query in the Azure portal. Most data collection scenarios though currently require you to work directly with the DCR definition.

If the `transformKql` property is omitted, or if its value is simply `source`, then no transformation is applied, and the incoming data is sent to the destination without modification.

> [!IMPORTANT]
> The transformation query must be on a single line in the DCR. If you're creating the transformation in the Azure portal, you can use multiple lines for readability, and `\n` will be included in the query for each new line.

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

## Create a multi-stage transformation (preview)

> [!IMPORTANT]
> Multi-stage transformations are currently in public preview. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

Multi-stage transformations use the `transformations` section in a DCR to define processor-based pipelines that are referenced by data sources and data flows using the `transform` property. Unlike single-stage transformations that use `transformKql`, multi-stage transformations run on the client side (before data leaves the agent) or the ingestion side (before data reaches the workspace), or both.

- **Client-side transformations** — run on the agent before data is sent. These transformations reduce data volume at the source and can filter, parse, or enrich data before transmission.
- **Ingestion-side transformations** — run on the service after data arrives but before storage. These transformations can apply KQL expressions and further enrich data.

In a multi-stage pipeline, a *processor* is a named processing step — such as filtering, parsing, enriching, or applying KQL — that runs in sequence. The *header processor* declares the input format for the pipeline (for example, `header.Syslog` for syslog data).

See [Multi-stage transformations](data-collection-transformations.md#multi-stage-transformations-preview) for conceptual details and [DCR structure - Transformations](data-collection-rule-structure.md#transformations) for the complete schema reference.

### Create a multi-stage transformation

Create a multi-stage transformation using the Azure portal or programmatically.

The following example creates a DCR with a client-side transformation that filters syslog data to keep only auth events, and an ingestion-side transformation that applies KQL to the stream before it's stored.

The DCR definition includes these key sections:

- **`streamDeclarations`** — defines the schema for custom streams used between processing stages.
- **`dataSources`** — configures the data source with a `transform` property referencing the client-side transformation by name.
- **`dataFlows`** — maps streams to destinations with an optional `transform` property for ingestion-side processing.
- **`transformations`** — defines the named processor pipelines referenced by data sources and data flows.

#### [REST API](#tab/rest-api)

To create a multi-stage transformation using the REST API:

1. Create a JSON file with your DCR definition. The DCR must include:
    - A `transformations` section that defines one or more named processor pipelines.
    - A `transform` property on data sources (for client-side) or data flows (for ingestion-side) that references the named transformation.

1. Submit the DCR using the REST API with API version `2025-05-11` or later:

    ```http
    PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/dataCollectionRules/{dcrName}?api-version=2025-05-11
    Content-Type: application/json
    ```

    Replace `{subscriptionId}`, `{resourceGroupName}`, and `{dcrName}` with your values. To find your subscription ID and resource group, go to the resource group in the Azure portal or run `az group show --name {resourceGroupName}`.


    ```azurecli
    az rest --method put --url "https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/dataCollectionRules/{dcrName}?api-version=2025-05-11" --body @dcr.json
    ```

1. Verify the DCR was created successfully by checking the response status code (200 or 201). DCRs also appear in the Azure portal under **Monitor** > **Data Collection Rules**.

<details>
<summary>Example DCR JSON</summary>

```json
{
    "location": "eastus",
    "properties": {
        "streamDeclarations": {
            "Custom-FilteredSyslog": {
                "columns": [
                    { "name": "TimeGenerated", "type": "datetime" },
                    { "name": "Facility", "type": "string" },
                    { "name": "Message", "type": "string" },
                    { "name": "Host", "type": "string" },
                    { "name": "SeverityNumber", "type": "int" }
                ]
            }
        },
        "dataSources": {
            "syslog": [
                {
                    "name": "syslogAuth",
                    "facilityNames": ["auth", "authpriv"],
                    "logLevels": ["*"],
                    "transform": "client_filter_auth",
                    "streams": ["Custom-FilteredSyslog"]
                }
            ]
        },
        "destinations": {
            "logAnalytics": [
                {
                    "name": "myWorkspace",
                    "workspaceResourceId": "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}",
                    "workspaceId": "{workspaceId}"
                }
            ]
        },
        "dataFlows": [
            {
                "streams": ["Custom-FilteredSyslog"],
                "transform": "ingestion_enrich_syslog",
                "destinations": ["myWorkspace"],
                "outputStream": "Microsoft-Syslog"
            }
        ],
        "transformations": [
            {
                "name": "client_filter_auth",
                "headerProcessor": {
                    "processor": "header.Syslog",
                    "configuration": {}
                },
                "processors": [
                    {
                        "processor": "filter.Basic",
                        "configuration": {
                            "any": [
                                {
                                    "all": [
                                        {
                                            "columnName": "Facility",
                                            "operator": "==",
                                            "value": "auth"
                                        }
                                    ]
                                }
                            ]
                        }
                    }
                ]
            },
            {
                "name": "ingestion_enrich_syslog",
                "headerProcessor": {
                    "processor": "header.CustomStream",
                    "configuration": {
                        "streamId": "Custom-FilteredSyslog"
                    }
                },
                "processors": [
                    {
                        "processor": "transform.KQL",
                        "configuration": {
                            "expression": "source | extend EnrichedMsg = strcat(Host, ': ', Message)"
                        }
                    }
                ]
            }
        ]
    }
}
```

> [!NOTE]
> This example demonstrates the `transform.KQL` processor capability. Because `outputStream` maps to the standard `Microsoft-Syslog` table, the `EnrichedMsg` column isn't stored — standard tables have fixed schemas and silently drop extra columns. To persist custom columns, set `outputStream` to a custom table (for example, `Custom-EnrichedSyslog`) with `EnrichedMsg` declared in `streamDeclarations`.

You can also use PowerShell with `Invoke-AzRestMethod`:

```powershell
$dcr = Get-Content -Path "dcr.json" -Raw
Invoke-AzRestMethod `
    -Path "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/dataCollectionRules/{dcrName}?api-version=2025-05-11" `
    -Method PUT `
    -Payload $dcr
```

</details>

#### [Portal](#tab/portal)

1. Go to **Monitor** > **Data Collection Rules** and select **Create**.
1. On the **Basics** tab, provide the rule name, subscription, resource group, and region. Select the appropriate **Platform Type** (Windows, Linux, or Custom).
1. On the **Resources** tab, select **Add resources** and choose the virtual machines or other resources to associate with this DCR.
1. On the **Collect and deliver** tab, select **Add data source**. Choose the data source type and configure collection settings on the **Data source** tab.
1. Select the **Destination** tab. Select **Log Analytics Workspaces** as the destination type and choose your Log Analytics workspace. You must configure the destination before authoring a transformation.
1. Select the **Transform (optional)** tab. The tab displays a pipeline visualization showing the flow from **Data source** to **Transform** to **Destination**, along with a **Schema preview** at the bottom.

    :::image type="content" source="media/data-collection-transformations-create/multi-stage-transform-template.png" alt-text="Screenshot that shows the multi-stage transform template section of the DCR creation.":::

1. Select **+ Add** in the **Transform** section to start adding processors. Each processor runs in the order defined.

    > [!NOTE]
    > Not all processors have a dedicated UI form during the preview. For processors without UI support, use the **Unknown processor** option to paste the processor JSON configuration directly. See [DCR structure - Processor types](data-collection-rule-structure.md#processor-types) for the JSON structure of each processor.

1. Select **Add data source** to save the data source with its transformation and destination.
1. Select **Review + create** to validate and deploy the DCR.

## Create workspace transformation DCR

The [workspace transformation data collection rule (DCR)](data-collection-transformations.md#workspace-transformation-dcr) is a special [DCR](data-collection-rule-overview.md) that's applied directly to a Log Analytics workspace. There can be only one workspace transformation DCR for each workspace, but it can include transformations for any number of tables.

Use one of the following methods to create a workspace transformation DCR for your workspace and add one or more transformations to it.

> [!NOTE]
> It might take up to 60 minutes for a new transformation query to be activated.


### [Azure portal](#tab/portal)

You can create a workspace transformation DCR in the Azure portal by adding a transformation to a supported table.

1. On the Log Analytics workspaces menu in the Azure portal, select **Tables**. Select the ellipsis (**...**) to the right of the table you want to transform, and then select **Create transformation**.

    :::image type="content" source="media/data-collection-transformations-create/create-transformation-select.png" lightbox="media/data-collection-transformations-create/create-transformation-select.png" alt-text="Screenshot that shows the option to create a transformation for a table in the Azure portal.":::

1. If the workspace transformation DCR hasn't already been created for this workspace, select the option to create one. If it has already been created, then that DCR will already be selected. Each workspace can only have one workspace transformation DCR.

    :::image type="content" source="media/data-collection-transformations-create/new-data-collection-rule.png" lightbox="media/data-collection-transformations-create/new-data-collection-rule.png" alt-text="Screenshot that shows creating a new data collection rule.":::

1. Select **Next** to view sample data from the table. Select **Transformation editor** to define the transformation query.

    :::image type="content" source="media/data-collection-transformations-create/sample-data.png" lightbox="media/data-collection-transformations-create/sample-data.png" alt-text="Screenshot that shows sample data from the log table.":::

1. You can then edit and run the transformation query to see the results against actual data from the table. Keep modifying and testing the query until you get the results you want.
1. When you're satisfied with the query, select **Apply** and then **Next** and **Create** to save the DCR with your new transformation.

    :::image type="content" source="media/data-collection-transformations-create/save-transformation.png" lightbox="media/data-collection-transformations-create/save-transformation.png" alt-text="Screenshot that shows saving the transformation.":::

1. To verify the transformation is active, go to **Monitor** > **Data Collection Rules** and confirm the workspace transformation DCR appears with status **Succeeded**. Then query the target table after the next ingestion cycle to confirm transformations are applied.

### [JSON](#tab/json)

Workspace transformation DCRs are mostly like any other DCR. They use the same JSON structure for their definition, and you can create and edit them using the same commands and strategies described in [Create or edit a DCR using JSON](data-collection-rule-create-edit.md). The differences are with the JSON definition:

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
        ]
    }
}
```

Deploy the workspace transformation DCR using Azure CLI:

```azurecli
az monitor data-collection rule create \
    --name {dcrName} \
    --resource-group {resourceGroupName} \
    --body @dcr.json
```

---

## Optimize and monitor transformations

Transformations run a KQL query against every record collected with the DCR, so it's important that they run efficiently. Transformation execution time contributes to overall [data ingestion latency](../logs/data-ingestion-time.md), and transformations that take excessive time to run can impact the performance of data collection and result in data loss. Optimal transformations should take no more than 1 second to run. See [Optimize log queries in Azure Monitor](../logs/query-optimization.md) for guidance on testing your query before you implement it as a transformation and for recommendations on optimizing queries that don't run efficiently.

> [!IMPORTANT]
> You might experience data loss if a transformation takes more than 20 seconds.

Because transformations don't run interactively, it's important to continuously monitor them to ensure that they're running properly and not taking excessive time to process data. See [Monitor and troubleshoot DCR data collection in Azure Monitor](data-collection-monitor.md) for details on logs and metrics that monitor the health and performance of transformations. This includes identifying any errors that occur in the KQL and metrics to track their running duration.

The following metrics are automatically collected for transformations and should be reviewed regularly to verify that your transformations are still running as expected. Create [metric alert rules](../alerts/alerts-create-metric-alert-rule.md) to be automatically notified when one of these metrics exceeds a threshold.

* Logs Transformation Duration per Min
* Logs Transformation Errors per Min

[Enable DCR error logs](data-collection-monitor.md#enable-dcr-error-logs) to track any errors that occur in your transformations or other queries. Create a [log alert rule](../alerts/alerts-create-log-alert-rule.md) to be automatically notified when an entry is written to this table.

## Troubleshoot transformations

The following tables list common transformation errors and their resolutions.

| Error | Cause | Resolution |
|:------|:------|:-----------|
| Schema mismatch | Transformation output doesn't match the target table columns. | Verify that the `project` or `extend` output matches the destination table schema. See the [data reference](/azure/azure-monitor/reference/) for column names and types. |
| Unsupported KQL operator | Using an operator not available in transformations (for example, `join`). | See [Supported KQL features](data-collection-transformations-kql.md) for the list of supported operators. |
| Query works in Log Analytics but fails in transformation | Some KQL operators supported in Log Analytics aren't supported in transformations. | See [Supported KQL features](data-collection-transformations-kql.md) for the subset of operators available in transformations. Test queries with only supported operators before adding to the DCR. |
| Data loss after transformation | Transformation takes more than 20 seconds to run. | Simplify the KQL query. See [Optimize log queries](../logs/query-optimization.md) for recommendations. |
| Transformation not applied | Both `transformKql` and `transform` specified on the same data flow. | These properties are mutually exclusive. Use one or the other per data flow. |
| Errors in DCR error logs | Invalid KQL syntax or runtime errors. | [Enable DCR error logs](data-collection-monitor.md#enable-dcr-error-logs) and review the `DCRLogErrors` table. |
| Permission denied | Insufficient permissions to create or edit the DCR. | Verify that you have [Monitoring Contributor](/azure/role-based-access-control/built-in-roles#monitoring-contributor) role on the resource group or subscription. |
| Processor not recognized | Invalid processor type name (for example, `filter.basic` instead of `filter.Basic`). | Processor names are case-sensitive. See [Processor types](data-collection-rule-structure.md#processor-types) for valid names. |
| Named transformation not found | The `transform` property references a name that doesn't exist in the `transformations` section. | Verify the `transform` value on the data source or data flow matches a `name` in the `transformations` array exactly. |
| Client-side transformation not applied | Agent version doesn't support multi-stage transformations. | Update Azure Monitor Agent to the latest version. Multi-stage transformations require API version `2025-05-11` or later. |

## Transformation guides by data source

There are multiple methods to create transformations depending on the data collection method. The following table lists guidance for different methods for creating transformations.

| Data collection | Reference |
|:----------------|:----------|
| Logs ingestion API | [Send data to Azure Monitor Logs by using REST API (Azure portal)](../logs/tutorial-logs-ingestion-portal.md)<br>[Send data to Azure Monitor Logs by using REST API (Azure Resource Manager templates)](../logs/tutorial-logs-ingestion-api.md) |
| Virtual machine with Azure Monitor agent | [Add transformation to Azure Monitor Log](../agents/azure-monitor-agent-transformation.md) |
| Kubernetes cluster with Container insights | [Data transformations in Container insights](../containers/container-insights-transformations.md) |
| Azure Event Hubs | [Tutorial: Ingest events from Azure Event Hubs into Azure Monitor Logs (Public Preview)](../logs/ingest-logs-event-hub.md) |

## Limitations and considerations

* Transformations run at ingestion time and contribute to data processing costs. However, filtering data with transformations can reduce ingestion volume and storage costs. See [Cost optimization and Azure Monitor](../fundamentals/best-practices-cost.md) for details.
* Not all tables in a Log Analytics workspace support transformations. See [Tables that support transformations in Azure Monitor Logs](../logs/tables-feature-support.md) for a list of supported tables.
* Not all KQL operators are supported in transformation queries. See [Supported KQL features in Azure Monitor transformations](data-collection-transformations-kql.md).
* While a transformation can send a single data source to multiple tables, it can't send data to multiple workspaces. To send data from a single data source to multiple workspaces, create multiple DCRs.
* The workspace transformation DCR can't send a single data source to multiple tables since the transformation is applied to the table itself.
* Transformations in the workspace transformation DCR are applied to all data sent to the table, regardless of the data source. If you need to apply different transformations to different data sources, use a `where` statement in the transformation query to apply different logic to data from different sources.
* For multi-stage transformations, `transform` and `transformKql` are mutually exclusive per data flow. A DCR can mix old-style (`transformKql`) and new-style (`transform`) data flows across different streams.
* Multi-stage transformations require API version `2025-05-11` or later.
* Performance counter data requires separate DCRs for Windows and Linux machines when using multi-stage transformations. A DCR of kind `All` can't use both `header.WindowsPerformanceCounters` and `header.LinuxPerformanceCounters` in a single client-side transformation.

## Related content

- [Monitor and troubleshoot DCR data collection in Azure Monitor](data-collection-monitor.md) - Track transformation performance and diagnose errors.
- [Supported KQL features in Azure Monitor transformations](data-collection-transformations-kql.md) - Verify which KQL operators work in transformations.
- [Structure of a data collection rule (DCR) in Azure Monitor](data-collection-rule-structure.md) - Full JSON schema reference for DCR definitions.
- [Transformation samples for Azure Monitor](data-collection-transformations-samples.md) - Example transformation queries for common scenarios.
- [Create a data collection rule](../vm/data-collection.md) and an association to it from a virtual machine using the Azure Monitor agent.
- [Cost optimization and Azure Monitor](../fundamentals/best-practices-cost.md) - Understand how transformations affect ingestion costs.
