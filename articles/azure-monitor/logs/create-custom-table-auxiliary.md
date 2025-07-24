---
title: Set up a table with the Auxiliary plan for low-cost data ingestion and retention in your Log Analytics workspace 
description: Create a custom table with the Auxiliary table plan in your Log Analytics workspace for low-cost ingestion and retention of log data. 
ms.reviewer: adi.biran
ms.custom: references_regions
ms.topic: how-to 
ms.date: 06/16/2025
# Customer intent: As a Log Analytics workspace administrator, I want to create a custom table with the Auxiliary table plan, so that I can ingest and retain data at a low cost for auditing and compliance.
---

# Set up a table with the Auxiliary plan in your Log Analytics workspace

The [Auxiliary table plan](data-platform-logs.md#table-plans) lets you ingest and retain data in your Log Analytics workspace at a low cost.

Here's a video that explains some of the uses and benefits of the Auxiliary table plan:

> [!VIDEO https://www.youtube.com/embed/GbD2Q3K_6Vo?cc_load_policy=1&cc_lang_pref=auto]

Azure Monitor Logs currently supports the Auxiliary table plan on [data collection rule (DCR)-based custom tables](manage-logs-tables.md#table-type-and-schema) to which you send data you collect using [Azure Monitor Agent](../agents/agents-overview.md) or the [Logs ingestion API](logs-ingestion-api-overview.md).

This article explains how to create a new custom table with the Auxiliary plan in your Log Analytics workspace and set up a data collection rule that sends data to this table. For more information about Auxiliary plan concepts, see [Azure Monitor Logs table plans](data-platform-logs.md#table-plans).

## Prerequisites

To create a custom table and collect log data, you need:

* A Log Analytics workspace where you have at least [contributor rights](manage-access.md#azure-rbac).
* A [data collection endpoint (DCE)](../data-collection/data-collection-endpoint-overview.md).
* Setting up a table with the Auxiliary plan is only supported on new tables. After you create a table with an Auxiliary plan, you can't switch the table's plan.

>[!NOTE]
> Auxiliary logs are generally available (GA) for all public cloud regions, but not available for Azure Government or China clouds.

## Create a custom table with the Auxiliary plan

To create a custom table, call the [Tables - Create API](/rest/api/loganalytics/tables/create-or-update) by using this command:

```http
PUT https://management.azure.com/subscriptions/{subscription_id}/resourceGroups/{resource_group}/providers/Microsoft.OperationalInsights/workspaces/{workspace_name}/tables/{table name_CL}?api-version=2023-01-01-preview
```

> [!NOTE]
> Only version `2023-01-01-preview` of the API currently lets you set the Auxiliary table plan.

Provide this payload as the body of your request. Update the table name and adjust the columns based on your table schema. This sample lists all the supported column data types.

```json
 {
    "properties": {
        "schema": {
            "name": "table_name_CL",
            "columns": [
                {
                    "name": "TimeGenerated",
                    "type": "datetime"
                },
                {
                    "name": "StringProperty",
                    "type": "string"
                },
                {
                    "name": "IntProperty",
                    "type": "int"
                },
                 {
                    "name": "LongProperty",
                    "type": "long"
                },
                 {
                    "name": "RealProperty",
                    "type": "real"
                },
                 {
                    "name": "BooleanProperty",
                    "type": "boolean"
                },
                 {
                    "name": "GuidProperty",
                    "type": "guid"
                },
                 {
                    "name": "DateTimeProperty",
                    "type": "datetime"
                }
            ]
        },
        "totalRetentionInDays": 365,
        "plan": "Auxiliary"
    }
}
```

> [!NOTE]
> * The `TimeGenerated` column only supports the ISO 8601 format with 6 decimal places for precision (nanoseconds). For more information, see [supported ISO 8601 datetime format](/azure/data-explorer/kusto/query/scalar-data-types/datetime#iso-8601).
> * Tables with the Auxiliary plan don't support columns with dynamic data.

## Send data to a table with the Auxiliary plan

There are currently two ways to ingest data to a custom table with the Auxiliary plan:

* [Collect logs from a text file with Azure Monitor Agent](../agents/data-collection-log-text.md) / [Collect logs from a JSON file with Azure Monitor Agent](../agents/data-collection-log-json.md).

    If you use this method, your custom table must only have two columns - `TimeGenerated` and `RawData` (of type `string`). The data collection rule sends the entirety of each log entry you collect to the `RawData` column, and Azure Monitor Logs automatically populates the `TimeGenerated` column with the time the log is ingested.

* Send data to Azure Monitor using Logs ingestion API.

    To use this method:

    1. [Create a custom table with the Auxiliary plan](#create-a-custom-table-with-the-auxiliary-plan) as described in this article.

    1. Follow the steps described in [Tutorial: Send data to Azure Monitor using Logs ingestion API](tutorial-logs-ingestion-api.md) to:

        1. [Create a Microsoft Entra application](tutorial-logs-ingestion-api.md#create-microsoft-entra-application).

        1. [Create a data collection rule](tutorial-logs-ingestion-api.md#create-data-collection-rule) using this ARM template.

        ```json
        {
            "$schema": "https://schema.management.azure.com/schemas/2019-08-01/deploymentTemplate.json#",
            "contentVersion": "1.0.0.0",
            "parameters": {
                "dataCollectionRuleName": {
                    "type": "string",
                    "metadata": {
                        "description": "Specifies the name of the data collection rule to create."
                    }
                },
                "location": {
                    "type": "string",
                    "metadata": {
                        "description": "Specifies the region in which to create the data collection rule. The must be the same region as the destination Log Analytics workspace."
                    }
                },
                "workspaceResourceId": {
                    "type": "string",
                    "metadata": {
                        "description": "The Azure resource ID of the Log Analytics workspace in which you created a custom table with the Auxiliary plan."
                    }
                }
            },
            "resources": [
                {
                    "type": "Microsoft.Insights/dataCollectionRules",
                    "name": "[parameters('dataCollectionRuleName')]",
                    "location": "[parameters('location')]",
                    "apiVersion": "2023-03-11",
                    "kind": "Direct",
                    "properties": {
                        "streamDeclarations": {
                            "Custom-table_name_CL": {
                                "columns": [
                                    {
                                        "name": "TimeGenerated",
                                        "type": "datetime"
                                    },
                                    {
                                        "name": "StringProperty",
                                        "type": "string"
                                    },
                                    {
                                        "name": "IntProperty",
                                        "type": "int"
                                    },
                                    {
                                        "name": "LongProperty",
                                        "type": "long"
                                    },
                                    {
                                        "name": "RealProperty",
                                        "type": "real"
                                    },
                                    {
                                        "name": "BooleanProperty",
                                        "type": "boolean"
                                    },
                                    {
                                        "name": "GuidProperty",
                                        "type": "guid"
                                    },
                                    {
                                        "name": "DateTimeProperty",
                                        "type": "datetime"
                                    }
                                        ]
                                        }
                                    },
                        "destinations": {
                            "logAnalytics": [
                                {
                                    "workspaceResourceId": "[parameters('workspaceResourceId')]",
                                    "name": "myworkspace"
                                }
                            ]
                        },
                        "dataFlows": [
                            {
                                "streams": [
                                    "Custom-table_name_CL"
                                ],
                                "destinations": [
                                    "myworkspace"
                                ]
                            }
                        ]
                    }
                }
            ],
            "outputs": {
                "dataCollectionRuleId": {
                    "type": "string",
                    "value": "[resourceId('Microsoft.Insights/dataCollectionRules', parameters('dataCollectionRuleName'))]"
                }
            }
        }
        ```

        Where:

        * `myworkspace` is the name of your Log Analytics workspace.
        * `table_name_CL` is the name of your table.
        * `columns` includes the same columns you set in [Create a custom table with the Auxiliary plan](#create-a-custom-table-with-the-auxiliary-plan).
    
    1. [Grant your application permission to use your DCR](tutorial-logs-ingestion-api.md#assign-permissions-to-a-dcr).



## Next steps

Learn more about:

* [Azure Monitor Logs table plans](data-platform-logs.md#table-plans)
* [Collecting logs with the Log Ingestion API](logs-ingestion-api-overview.md)
* [Data collection rules](../data-collection/data-collection-endpoint-overview.md)
