---
title: Sample data collection rules (DCRs) in Azure Monitor
description: Sample data collection rule for different Azure Monitor data collection scenarios.
author: bwren
ms.topic: sample
ms.date: 12/04/2024
ms.custom: references_region
ms.reviewer: jeffwo

---

# Data collection rule (DCR) samples in Azure Monitor
This article includes sample [data collection rules (DCRs)](./data-collection-rule-overview.md) for common data collection scenarios in Azure Monitor. You can modify these DCR definitions as required for your environment and create the DCR using the guidance in [Create or edit a data collection rule](./data-collection-rule-create-edit.md). You can also use and combine the basic strategies in these samples to create DCRs for other scenarios.

These samples require knowledge of the DCR structure as described in [Structure of a data collection rule in Azure Monitor](data-collection-rule-structure.md). Several may be configured using the Azure portal without any detailed knowledge of the DCR structure. Use these samples when you need to work with the DCR definition itself to perform more advanced configurations or to automate the creation of DCRs.

Each of these samples focuses on a particular data source, although you can combine multiple data sources of different types in a single DCR. Include a data flow for each to send the data to the appropriate destination. There is no functional difference between combining multiple data sources in a single DCR or creating separate DCRs for each data source. The choice depends on your requirements for managing and monitoring the data collection.

> [!NOTE]
> These samples show in this article provide the source JSON required to create the DCR. After creation, the DCR will have additional properties as described in [Structure of a data collection rule in Azure Monitor](data-collection-rule-structure.md).


## Logs ingestion API
DCRs for the Logs ingestion API must define the schema of the incoming stream in the `streamDeclarations` section of the DCR definition. The incoming data must be formatted in JSON with a schema matching the columns in this definition. No transformation is required if this schema matches the schema of the target table. If the schemas don't match, then you must add a transformation to the `dataFlows` property to format the data. See [Logs Ingestion API in Azure Monitor](../logs/logs-ingestion-api-overview.md) for more details.

The sample DCR below has the following details:

- Sends data to a table called `MyTable_CL` in a workspace called `my-workspace`. Before installing this DCR, you would need to create the table with the following columns:
  - TimeGenerated
  - Computer
  - AdditionalContext
  - ExtendedColumn (defined in the transformation)
- Applies a [transformation](../essentials/data-collection-transformations.md) to the incoming data to format the data for the target table.

> [!IMPORTANT]
> This sample doesn't include the [`dataCollectionEndpointId`](../logs/logs-ingestion-api-overview.md#endpoint) property since this is created automatically when the DCR is created. You need the value of this property since it's the URL that the application will send data to. The DCR must have `kind:Direct` for this property to be created. See [Properties](../essentials/data-collection-rule-structure.md#properties) for more details.

```json
{
    "location": "eastus",
    "kind": "Direct",
    "properties": {
        "streamDeclarations": {
            "Custom-MyTable": {
                "columns": [
                    {
                        "name": "Time",
                        "type": "datetime"
                    },
                    {
                        "name": "Computer",
                        "type": "string"
                    },
                    {
                        "name": "AdditionalContext",
                        "type": "string"
                    }
                ]
            }
        },
        "destinations": {
            "logAnalytics": [
                {
                    "workspaceResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/cefingestion/providers/microsoft.operationalinsights/workspaces/my-workspace",
                    "name": "LogAnalyticsDest"
                }
            ]
        },
        "dataFlows": [
            {
                "streams": [
                    "Custom-MyTable"
                ],
                "destinations": [
                    "LogAnalyticsDest"
                ],
                "transformKql": "source | extend jsonContext = parse_json(AdditionalContext) | project TimeGenerated = Time, Computer, AdditionalContext = jsonContext, ExtendedColumn=tostring(jsonContext.CounterName)",
                "outputStream": "Custom-MyTable_CL"
            }
        ]
    }
}
```

## Workspace transformation DCR
Workspace transformation DCRs have an empty `datasources` section since the transformations are applied to any data sent to supported tables in the workspace. It must include one and only entry for `workspaceResourceId` and an entry in `dataFlows` for each table with a transformation. It also must have `"kind": "WorkspaceTransforms"`.

The sample DCR below has the following details:
- Transformation for the `LAQueryLogs` table that filters out queries of the table itself and adds a column with the workspace name.
- Transformation for the `Event` table that filters out Information events and removes the `ParameterXml` column. This will only apply to data coming from the deprecated Log Analytics agent and not the Azure Monitor agent as explained in [Workspace transformation DCR](./data-collection-transformations.md#workspace-transformation-dcr).

```json
{
    "kind": "WorkspaceTransforms",
    "location": "eastus",
    "properties": {
        "dataSources": {},
        "destinations": {
            "logAnalytics": [
                {
                    "workspaceResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace",
                    "name": "clv2ws1"
                }
            ]
        },
        "dataFlows": [
            {
                "streams": [
                    "Microsoft-Table-LAQueryLogs"
                ],
                "destinations": [
                    "clv2ws1"
                ],
                "transformKql": "source | where QueryText !contains 'LAQueryLogs' | extend Context = parse_json(RequestContext) | extend Workspace_CF = tostring(Context['workspaces'][0]) | project-away RequestContext, Context"
            },
            {
                "streams": [
                    "Microsoft-Table-Event"
                ],
                "destinations": [
                    "clv2ws1"
                ],
                "transformKql": "source | where EventLevelName in ('Error', 'Critical', 'Warning') | project-away ParameterXml"
            }
        ]
    }
}
```


## Send data to multiple tables
There are multiple reasons why you might want to send data from a single data source to multiple tables in the same Log Analytics workspace, including the following:

- Save ingestion costs by sending records used for occasional troubleshooting to a [basic logs table](../logs/basic-logs-azure-tables.md). 
- Send records or columns with sensitive data to a table with different permissions or retention settings.

To send data from a single data source to multiple tables, create multiple data flows in the DCR with a unique transformation query and output table for each as shown in the following diagram.

> [!IMPORTANT]
> Currently, the tables in the DCR must be in the same Log Analytics workspace. To send to multiple workspaces from a single data source, use multiple DCRs and configure your application to send the data to each.

:::image type="content" source="media/data-collection-rule-samples/multiple-destinations.png" lightbox="media/data-collection-rule-samples/multiple-destinations.png" alt-text="Diagram that shows transformation sending data to multiple tables." border="false":::

The following sample filters records sent to the Event table by the Azure Monitor agent. Only warning and error events are sent to the Event table. Other events are sent to a copy of the event table named Event_CL which is configured for basic logs.

> [!NOTE]
> This sample requires a copy of the Event table created in the same workspace named Event_CL. 

```json
{
    "location": "eastus",
    "properties": {
        "dataSources": {
            "windowsEventLogs": [
              {
                "name": "eventLogsDataSource",
                "streams": [
                  "Microsoft-Event"
                ],
                "xPathQueries": [
                  "System!*[System[(Level = 1 or Level = 2 or Level = 3)]]",
                  "Application!*[System[(Level = 1 or Level = 2 or Level = 3)]]"
                ]
              }
            ]
        },
        "destinations": {
            "logAnalytics": [
                {
                    "workspaceResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace",
                    "name": "MyDestination"
                }
            ]
        },
        "dataFlows": [
            {
                "streams": [
                    "Microsoft-Event"
                ],
                "destinations": [
                    "MyDestination"
                ],
                "transformKql": "source | where EventLevelName in ('Error', 'Warning')",
                "outputStream": "Microsoft-Event"
            },
            {
                "streams": [
                    "Microsoft-Event"
                ],
                "destinations": [
                    "MyDestination"
                ],
                "transformKql": "source | where EventLevelName !in ('Error', 'Warning')",
                "outputStream": "Custom-Event_CL"
            }
        ]
    }
}
```



## Next steps

- [Get details for the different properties in a DCR](../essentials/data-collection-rule-structure.md)
- [See different methods for creating a DCR](../essentials/data-collection-rule-create-edit.md)
