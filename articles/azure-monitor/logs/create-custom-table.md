---
title: Add or Delete Tables and Columns in Azure Monitor Logs
description: Create a table with a custom schema to collect logs from any data source. 
ms.reviewer: adi.biran
ms.custom: devx-track-azurepowershell, devx-track-azurecli, devx-track-arm-template, devx-track-bicep
ms.topic: how-to 
ms.date: 05/25/2026
ai-usage: ai-assisted
# Customer intent: As a Log Analytics workspace administrator, I want to manage table schemas and be able to create a table with a custom schema to store logs from an Azure or non-Azure data source.
---

# Add or delete tables and columns in Azure Monitor Logs

This article explains how to create a custom table by using an example data collection rule (DCR) and how to manage table schemas with custom columns. 

[Data collection rules (DCRs)](../data-collection/data-collection-rule-overview.md) control how Azure Monitor collects data. They let you filter and [transform](../data-collection/data-collection-transformations.md) log data before it reaches an [Azure or custom table](../logs/logs-table-overview.md#table-types). 

Custom columns extend the schema of a table to accommodate changes in the data source or your organization's analysis requirements. When you update a table schema, update any DCRs that send data to that table.


## Prerequisites

| Action | Permission required |
|---|---|
| Manage a table | `Microsoft.OperationalInsights/workspaces/*` permission at the Log Analytics workspace scope or higher. <br>For example, as provided by the privileged built-in role, [Log Analytics contributor](../logs/manage-access.md#log-analytics-contributor). |

To ingest data into the table, you might need the following items:
* Data collection endpoint (DCE). For more information, see [DCE](../data-collection/data-collection-endpoint-overview.md).
* A sample of at least one record of the source data in a JSON file. Use this sample to create custom tables in the portal, such as when you collect [text and JSON data sources from VMs](../vm/data-collection.md#add-data-sources).


Consider these additional requirements:
* All tables in a Log Analytics workspace must have a `TimeGenerated` column, which identifies the ingestion time of the record. If the column is missing, Azure Monitor automatically adds it to the transformation in your DCR for the table. For more information, see [supported datetime formats](/azure/data-explorer/kusto/query/scalar-data-types/datetime#supported-formats).
* Auxiliary / Lake table plans only support the `TimeGenerated` column in the ISO 8601 format with six decimal places for precision (microseconds). For more information, see [supported ISO 8601 datetime format](/azure/data-explorer/kusto/query/scalar-data-types/datetime#iso-8601).

## Create a custom table

Azure tables have predefined schemas. To store log data in a different schema, use data collection rules to define how to collect, transform, and send the data to a custom table in your Log Analytics workspace. When you create a custom table, choose a [table plan](data-platform-logs.md#table-plans) (**Analytics** (default), **Basic**, or **Auxiliary / Lake**) based on your data usage and cost requirements.

Custom tables have a suffix of **_CL**; for example, *tablename_CL*. The Azure portal adds the **_CL** suffix to the table name automatically. When you create a custom table by using a different method, you need to add the **_CL** suffix yourself. The *tablename_CL* in the [DataFlows Streams](../data-collection/data-collection-rule-structure.md#data-flows) properties in your data collection rules must match the *tablename_CL* name in the Log Analytics workspace.

> [!WARNING]
> Azure uses table names for billing, so don't include sensitive information in the name.

# [Portal](#tab/azure-portal)

To create a custom table by using the Azure portal:

1. From the **Log Analytics workspaces** menu, select **Tables**.

1. Select **Create**.

1. Enter a name and, optionally, a description for the table. You don't need to add the *_CL* suffix to the custom table's name. The portal adds the suffix automatically to the name you specify.

1. Under **Table plan**, select **Analytics** (default), **Basic**, or **Auxiliary / Lake**.

1. Select an existing data collection rule from the **Data collection rule** dropdown, or select **Create a new data collection rule** and specify the **Subscription**, **Resource group**, and **Name** for the new data collection rule. 

    :::image type="content" source="media/tutorial-logs-ingestion-portal/create-custom-table-portal.png" lightbox="media/tutorial-logs-ingestion-portal/create-custom-table-portal.png" alt-text="Screenshot showing new data collection rule.":::

1. Select a [data collection endpoint](../data-collection/data-collection-endpoint-overview.md#create-a-data-collection-endpoint) and select **Next**. If you selected a DCR that's already associated with a DCE, this dropdown is unavailable.

1. Select **Browse for files** and locate the JSON file with the sample data for your new table. The following screenshot uses a sample JSON file from the script in the [Tutorial: Send data to Azure Monitor Logs](../logs/tutorial-logs-ingestion-portal.md#generate-sample-data).

    :::image type="content" source="media/tutorial-logs-ingestion-portal/custom-log-browse-files.png" lightbox="media/tutorial-logs-ingestion-portal/custom-log-browse-files.png" alt-text="Screenshot showing custom log browse for files.":::

    If your sample data doesn't include a `TimeGenerated` column, you receive a message that the portal creates a transformation with this column.

1. If you want to [transform log data before ingestion](../data-collection/data-collection-transformations.md) into your table:

    1. Select **Transformation editor**.

        The transformation editor lets you create a transformation for the incoming data stream. The transformation is a Kusto Query Language (KQL) query that runs against each incoming record. Azure Monitor Logs stores the results of the query in the destination table.

        :::image type="content" source="media/tutorial-logs-ingestion-portal/custom-log-data-preview.png" lightbox="media/tutorial-logs-ingestion-portal/custom-log-data-preview.png" alt-text="Screenshot showing custom log data preview.":::

    1. Select **Run** to view the results.

        :::image type="content" source="media/tutorial-logs-ingestion-portal/custom-log-query-01.png" lightbox="media/tutorial-logs-ingestion-portal/custom-log-query-01.png" alt-text="Screenshot showing initial custom log data query.":::

1. Select **Apply** to save the transformation and view the schema of the new table. Select **Next**.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/custom-log-final-schema.png" lightbox="media/tutorial-logs-ingestion-portal/custom-log-final-schema.png" alt-text="Screenshot showing custom log final schema.":::

1. Verify the final details and select **Create** to save the custom log.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/custom-log-create.png" lightbox="media/tutorial-logs-ingestion-portal/custom-log-create.png" alt-text="Screenshot showing custom log create.":::

# [Azure CLI](#tab/cli)

1. Create the custom table. This example creates a custom table with the `Analytics` plan by using the `az monitor log-analytics workspace table create` command. Then it creates a DCR that defines how to collect data from your data source and send it to the custom table.

```azurecli
subscriptionId="aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
resourceGroupName="myResourceGroup"
workspaceName="myWorkspace"
tableName_CL="myTable_CL"

az account set --subscription "$subscriptionId"

az monitor log-analytics workspace table create \
  --resource-group "$resourceGroupName" \
  --workspace-name "$workspaceName" \
  --name "$tableName_CL" \
  --plan Analytics \
  --columns TimeGenerated=datetime RawData=string
```

To create a custom table with the `Auxiliary` plan, use the `az rest` command to send a `PUT` request to the Logs management REST API. The request body specifies the table schema and the table plan.

```azurecli
subscriptionId="aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
resourceGroupName="myResourceGroup"
workspaceName="myWorkspace"
tableName_CL="myTable_CL"
apiVersion="2025-07-01"
providers="Microsoft.OperationalInsights/workspaces/$workspaceName/tables/$tableName_CL"
resourceId="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/$providers"
payloadFile="./my-table.json"

az account set --subscription $subscriptionId

az rest \
  --method put \
  --uri "$resourceId?api-version=$apiVersion" \
  --body @"$payloadFile"
```

> [!NOTE]
> This sample lists all the supported column data types except `guid`. GUIDs are stored and queried as `string` types even if the table column is defined as `guid`.
<br>
<details>
<summary>Expand to view the my-table.json file.</summary>

```json
{
  "properties": {
    "schema": {
      "name": "myTable_CL",
      "columns": [
        {
          "name": "TimeGenerated",
          "type": "dateTime"
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
          "name": "DateTimeProperty",
          "type": "dateTime"
        },
        {
          "name": "DynamicProperty",
          "type": "dynamic"
        }
      ]
    },
    "totalRetentionInDays": 365,
    "plan": "Auxiliary"
  }
}
```

</details>

2. Create a data collection rule that collects data from your data source and sends it to the custom table. This example uses the [az monitor data-collection rule](/cli/azure/monitor/data-collection/rule) command group to create a DCR that collects data from a Syslog source and sends it to the custom table you created in the previous step.

    ```azurecli
    subscriptionId="aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
    resourceGroupName="myResourceGroup"
    dataCollectionRuleName="myDataCollectionRule"
    ruleFile="./my-dcr.json"
    
    az account set --subscription "$subscriptionId"
    az extension add --name monitor-control-service
    
    az monitor data-collection rule create \
      --resource-group "$resourceGroupName" \
      --name "$dataCollectionRuleName" \
      --rule-file "$ruleFile"
    ```

    [!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

    <br>
    <details>
    <summary>Expand to view the my-dcr.json file.</summary>

    ```json
    {
      "location": "eastus",
      "kind": "Direct",
      "properties": {
        "streamDeclarations": {
          "myTable": {
            "columns": [
              {
                "name": "TimeGenerated",
                "type": "dateTime"
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
                "name": "DateTimeProperty",
                "type": "dateTime"
              },
              {
                "name": "DynamicProperty",
                "type": "dynamic"
              }
            ]
          }
        },
        "destinations": {
          "logAnalytics": [
            {
              "workspaceResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/myResourceGroup/providers/Microsoft.OperationalInsights/workspaces/myWorkspace",
              "name": "myWorkspace"
            }
          ]
        },
        "dataFlows": [
          {
            "streams": [
              "myTable"
            ],
            "transformKql": "source",
            "destinations": [
              "myWorkspace"
            ],
            "outputStream": "Custom-myTable_CL"
          }
        ]
      }
    }
    ```

    </details>

# [REST](#tab/rest)

1. Create the table. This example creates a custom table with `"plan": "Auxiliary"` in the request payload.

> [!NOTE]
> This sample lists all the supported column data types except `guid`. GUIDs are stored and queried as `string` types even if the table column is defined as `guid`.

```REST
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/tables/{tableName_CL}?api-version={apiVersion}
Authorization: Bearer {token}
Content-Type: application/json

{
  "properties": {
    "schema": {
      "name": "{tableName_CL}",
      "columns": [
        {"name": "TimeGenerated",
          "type": "dateTime"},
        {"name": "StringProperty",
          "type": "string"},
        {"name": "IntProperty",
          "type": "int"},
        {"name": "LongProperty",
          "type": "long"},
        {"name": "RealProperty",
          "type": "real"},
        {"name": "BooleanProperty",
          "type": "boolean"},
        {"name": "DateTimeProperty",
          "type": "dateTime"},
        {"name": "DynamicProperty",
          "type": "dynamic"}
      ]
    },
    "totalRetentionInDays": 365,
    "plan": "Auxiliary"
  }
}
```

2. [Create a data collection rule](tutorial-logs-ingestion-api.md#create-data-collection-rule). Here's a sample with `kind` set to `Direct`. This DCR type doesn't require a data collection endpoint (DCE) because it creates its own `logsIngestion` endpoint.

    * `myWorkspace` is the name of your Log Analytics workspace.
    * `myTable_CL` is the name of your table.
    * `columns` includes the same columns you defined when you created the table.

    ```REST
    PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/dataCollectionRules/{dataCollectionRuleName}?api-version={apiVersion}
    Authorization: Bearer {token}
    Content-Type: application/json

    {
      "location": "eastus",
      "kind": "Direct",
      "properties": {
        "streamDeclarations": {
          "myTable": {
            "columns": [
              {
                "name": "TimeGenerated",
                "type": "dateTime"
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
                "name": "DateTimeProperty",
                "type": "dateTime"
              },
              {
                "name": "DynamicProperty",
                "type": "dynamic"
              }
            ]
          }
        },
        "destinations": {
          "logAnalytics": [
            {
              "workspaceResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/myResourceGroup/providers/Microsoft.OperationalInsights/workspaces/myWorkspace",
              "name": "myWorkspace"
            }
          ]
        },
        "dataFlows": [
          {
            "streams": [
              "myTable"
            ],
            "transformKql": "source",
            "destinations": [
              "myWorkspace"
            ],
            "outputStream": "Custom-myTable_CL"
          }
        ]
      }
    }
    ```


# [PowerShell](#tab/powershell)

1. Create the table by using the `New-AzOperationalInsightsTable` command or `Invoke-AzRestMethod`. This example uses the `New-AzOperationalInsightsTable` command to create a custom table with the `Analytics` plan.

```azurepowershell
$subscriptionId = "aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
$resourceGroupName = "myResourceGroup"
$workspaceName = "myWorkspace"
$tableName_CL = "myTable_CL"
$payloadFile = ".\my-table.json"

Set-AzContext -Subscription $subscriptionId

$tableParams = @{
    ResourceGroupName = $resourceGroupName
    WorkspaceName = $workspaceName
    TableName = $tableName_CL
    RetentionInDays = 31
    TotalRetentionInDays = 365
    Plan = 'Analytics'
    Description = 'My custom table created with PowerShell'
    Payload = Get-Content -Raw -Path $payloadFile
    Column = @{'TimeGenerated'='DateTime'; 'RawData'='String'}
}

New-AzOperationalInsightsTable @tableParams
```

To create a custom table with the `Auxiliary` plan, use the `Invoke-AzRestMethod` command to send a `PUT` request to the Logs management REST API. The request body specifies the table schema and the table plan.

```azurepowershell
$subscriptionId = "aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
$resourceGroupName = "myResourceGroup"
$workspaceName = "myWorkspace"
$tableName_CL = "myTable_CL"
$apiVersion = "2025-07-01"
$providers = "Microsoft.OperationalInsights/workspaces/$workspaceName/tables/$tableName_CL"
$resourceId = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/$providers"
$payloadFile = ".\my-table.json"

Set-AzContext -Subscription $subscriptionId

$restParams = @{
    Method  = "PUT"
    Path    = "$resourceId?api-version=$apiVersion"
    Payload = Get-Content -Raw -Path $payloadFile
}

Invoke-AzRestMethod @restParams
```

> [!NOTE]
> This sample lists all the supported column data types except `guid`. GUIDs are stored and queried as `string` types even if the table column is defined as `guid`.
<br>
<details>
<summary>Expand to view the my-table.json file.</summary>

```json
{
  "properties": {
    "schema": {
      "name": "myTable_CL",
      "columns": [
        {
          "name": "TimeGenerated",
          "type": "dateTime"
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
          "name": "DateTimeProperty",
          "type": "dateTime"
        },
        {
          "name": "DynamicProperty",
          "type": "dynamic"
        }
      ]
    },
    "totalRetentionInDays": 365,
    "plan": "Auxiliary"
  }
}
```

</details>

2. Create a data collection rule that collects data from your data source and sends it to the custom table. This PowerShell example uses the [New-AzDataCollectionRule](/powershell/module/az.monitor/new-azdatacollectionrule) cmdlet to create a DCR that collects data from a Syslog source and sends it to the custom table you created in the previous step.

    ```azurepowershell
    $subscriptionId = "aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
    $resourceGroupName = "myResourceGroup"
    $dataCollectionRuleName = "myDataCollectionRule"
    $jsonFilePath = ".\my-dcr.json"
    
    Select-AzSubscription -SubscriptionId $subscriptionId
    
    $dataCollectionRuleParams = @{
        Name              = $dataCollectionRuleName
        ResourceGroupName = $resourceGroupName
        JsonFilePath      = $jsonFilePath
    }
    
    New-AzDataCollectionRule @dataCollectionRuleParams
    ```

    [!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

    <br>
    <details>
    <summary>Expand to view the my-dcr.json file.</summary>

    ```json
    {
      "location": "eastus",
      "kind": "Direct",
      "properties": {
        "streamDeclarations": {
          "myTable": {
            "columns": [
              {
                "name": "TimeGenerated",
                "type": "dateTime"
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
                "name": "DateTimeProperty",
                "type": "dateTime"
              },
              {
                "name": "DynamicProperty",
                "type": "dynamic"
              }
            ]
          }
        },
        "destinations": {
          "logAnalytics": [
            {
              "workspaceResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/myResourceGroup/providers/Microsoft.OperationalInsights/workspaces/myWorkspace",
              "name": "myWorkspace"
            }
          ]
        },
        "dataFlows": [
          {
            "streams": [
              "myTable"
            ],
            "transformKql": "source",
            "destinations": [
              "myWorkspace"
            ],
            "outputStream": "Custom-myTable_CL"
          }
        ]
      }
    }
    ```

    </details>

# [ARM template](#tab/arm)

1. Create the table by using the following example Azure Resource Manager template (ARM template). This JSON example uses the [Microsoft.OperationalInsights workspaces/tables](/azure/templates/microsoft.operationalinsights/workspaces/tables?pivots=deployment-language-arm-template) resource type to create an **Auxiliary / Lake** table with a custom schema.

> [!NOTE]
> This sample lists all the supported column data types except `guid`. GUIDs are stored and queried as `string` types even if the table column is defined as `guid`.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "workspaceName": {
      "type": "string",
      "defaultValue": "myWorkspace"
    },
    "tableName_CL": {
      "type": "string",
      "defaultValue": "myTable_CL"
    }
  },
  "resources": [
    {
      "type": "Microsoft.OperationalInsights/workspaces/tables",
      "apiVersion": "2025-07-01",
      "name": "[format('{0}/{1}', parameters('workspaceName'), parameters('tableName_CL'))]",
      "properties": {
        "schema": {
          "name": "[parameters('tableName_CL')]",
          "columns": [
            {
              "name": "TimeGenerated",
              "type": "dateTime"
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
              "name": "DateTimeProperty",
              "type": "dateTime"
            },
            {
              "name": "DynamicProperty",
              "type": "dynamic"
            }
          ]
        },
        "totalRetentionInDays": 365,
        "plan": "Auxiliary"
      }
    }
  ]
}
```

2. Create a data collection rule that collects data from your data source and sends it to the custom table. The following ARM template example uses the [Microsoft.Insights dataCollectionRules](/azure/templates/microsoft.insights/datacollectionrules?pivots=deployment-language-arm-template) resource type.

    ```json
    {
      "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
      "contentVersion": "1.0.0.0",
      "parameters": {
        "dataCollectionRuleName": {
          "type": "string",
          "defaultValue": "myDataCollectionRule",
          "metadata": {
            "description": "Specifies the name of the data collection rule to create."
          }
        },
        "location": {
          "type": "string",
          "defaultValue": "eastus",
          "metadata": {
            "description": "Specifies the region in which to create the data collection rule. It must be the same region as the destination Log Analytics workspace."
          }
        },
        "workspaceResourceId": {
          "type": "string",
          "defaultValue": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/myResourceGroup/providers/Microsoft.OperationalInsights/workspaces/myWorkspace",
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
          "apiVersion": "2025-07-01",
          "kind": "Direct",
          "properties": {
            "streamDeclarations": {
              "myTable": {
                "columns": [
                  {
                    "name": "TimeGenerated",
                    "type": "dateTime"
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
                    "name": "DateTimeProperty",
                    "type": "dateTime"
                  },
                  {
                    "name": "DynamicProperty",
                    "type": "dynamic"
                  }
                ]
              }
            },
            "destinations": {
              "logAnalytics": [
                {
                  "workspaceResourceId": "[parameters('workspaceResourceId')]",
                  "name": "myWorkspace"
                }
              ]
            },
            "dataFlows": [
              {
                "streams": [
                  "myTable"
                ],
                "transformKql": "source",
                "destinations": [
                  "myWorkspace"
                ],
                "outputStream": "Custom-myTable_CL"
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

# [Bicep](#tab/bicep)

1. Create the table by using the following Bicep example. The example uses the [Microsoft.OperationalInsights workspaces/tables](/azure/templates/microsoft.operationalinsights/workspaces/tables?pivots=deployment-language-bicep) resource type to create an Auxiliary table with a custom schema.

    The sample lists all supported column data types except `guid`. Log Analytics stores and queries GUIDs as `string` types even if you define the column as `guid`.

```bicep
param workspaceName string = 'myWorkspace'
param tableName_CL string = 'myTable_CL'

resource workspace 'Microsoft.OperationalInsights/workspaces@2025-07-01' existing = {
  name: workspaceName
}

resource table 'Microsoft.OperationalInsights/workspaces/tables@2025-07-01' = {
  parent: workspace
  name: tableName_CL
  properties: {
    schema: {
      name: tableName_CL
      columns: [
        {
          name: 'TimeGenerated'
          type: 'dateTime'
        }
        {
          name: 'StringProperty'
          type: 'string'
        }
        {
          name: 'IntProperty'
          type: 'int'
        }
        {
          name: 'LongProperty'
          type: 'long'
        }
        {
          name: 'RealProperty'
          type: 'real'
        }
        {
          name: 'BooleanProperty'
          type: 'boolean'
        }
        {
          name: 'DateTimeProperty'
          type: 'dateTime'
        }
        {
          name: 'DynamicProperty'
          type: 'dynamic'
        }
      ]
    }
    totalRetentionInDays: 365
    plan: 'Auxiliary'
  }
}
```

2. Create a DCR by using the following Bicep example, which uses the [Microsoft.Insights dataCollectionRules](/azure/templates/microsoft.insights/datacollectionrules?pivots=deployment-language-bicep) resource type.

    ```bicep
    @description('Specifies the name of the data collection rule to create.')
    param dataCollectionRuleName string = 'myDataCollectionRule'
    
    @description('Specifies the region in which to create the data collection rule. It must be the same region as the destination Log Analytics workspace.')
    param location string = 'eastus'
    
    @description('The Azure resource ID of the Log Analytics workspace in which you created a custom table with the Auxiliary plan.')
    param workspaceResourceId string = '/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/myResourceGroup/providers/Microsoft.OperationalInsights/workspaces/myWorkspace'
    
    resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2025-07-01' = {
      name: dataCollectionRuleName
      location: location
      kind: 'Direct'
      properties: {
        streamDeclarations: {
          'myTable': {
            columns: [
              {
                name: 'TimeGenerated'
                type: 'dateTime'
              }
              {
                name: 'StringProperty'
                type: 'string'
              }
              {
                name: 'IntProperty'
                type: 'int'
              }
              {
                name: 'LongProperty'
                type: 'long'
              }
              {
                name: 'RealProperty'
                type: 'real'
              }
              {
                name: 'BooleanProperty'
                type: 'boolean'
              }
              {
                name: 'DateTimeProperty'
                type: 'dateTime'
              }
              {
                name: 'DynamicProperty'
                type: 'dynamic'
              }
            ]
          }
        }
        destinations: {
          logAnalytics: [
            {
              workspaceResourceId: workspaceResourceId
              name: 'myWorkspace'
            }
          ]
        }
        dataFlows: [
          {
            streams: [
              'myTable'
            ]
            transformKql: 'source'
            destinations: [
              'myWorkspace'
            ]
            outputStream: 'Custom-myTable_CL'
          }
        ]
      }
    }
    
    output dataCollectionRuleId string = dataCollectionRule.id
    ```


---

| Variable | Example value | Purpose |
|----------|---------------|---------|
| host | *management.azure.com* | Implicit Azure Resource Manager endpoint |
| subscriptionId | aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e | User input |
| resourceGroupName | myResourceGroup | User input |
| workspaceName | myWorkspace | User input |
| tableName_CL | myTable_CL | User input |
| plan | Auxiliary | Valid values: `Analytics` (default), `Basic`, `Auxiliary`. See [table plans](data-platform-logs.md#table-plans). |
| apiVersion | 2025-07-01 | [Reference](../fundamentals/azure-monitor-rest-api-index.md) |

## Delete a table

You can't delete Azure tables. How Azure removes data when you delete any other table depends on the table type.

For more information, see [What happens to data when you delete a table in a Log Analytics workspace](../logs/data-retention-configure.md#what-happens-to-data-when-you-delete-a-table-in-a-log-analytics-workspace).

# [Portal](#tab/azure-portal-1)

To delete a table from the Azure portal:

1. From the Log Analytics workspace menu, select **Tables**.

1. Search for the tables you want to delete by name, or by selecting **Search results** in the **Type** field.

    :::image type="content" source="media/search-job/search-results-on-log-analytics-tables-screen.png" alt-text="Screenshot that shows the Tables screen for a Log Analytics workspace with the Filter by name and Type fields highlighted." lightbox="media/search-job/search-results-on-log-analytics-tables-screen.png":::

1. Select the table you want to delete, select the ellipsis ( **...** ) to the right of the table, select **Delete**, and confirm the deletion by typing **yes**.

    :::image type="content" source="media/search-job/delete-table.png" lightbox="media/search-job/delete-table.png" alt-text="Screenshot that shows the Delete Table screen for a table in a Log Analytics workspace.":::

# [Azure CLI](#tab/cli-1)

```azurecli
subscriptionId="aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
resourceGroupName="myResourceGroup"
workspaceName="myWorkspace"
tableName_CL="myTable_CL"

az account set --subscription "$subscriptionId"

az monitor log-analytics workspace table delete \
  --resource-group "$resourceGroupName" \
  --workspace-name "$workspaceName" \
  --name "$tableName_CL" \
  --yes
```

# [REST](#tab/rest-1)

```REST
DELETE https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/tables/{tableName_CL}?api-version={apiVersion}
Authorization: Bearer {token}
```

# [PowerShell](#tab/powershell-1)

[!INCLUDE [Azure PowerShell using REST](../includes/powershell-using-rest.md)]

```azurepowershell
$subscriptionId = "aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
$resourceGroupName = "myResourceGroup"
$workspaceName = "myWorkspace"
$tableName_CL = "myTable_CL"
$apiVersion = "2025-07-01"
$providers = "Microsoft.OperationalInsights/workspaces/$workspaceName/tables/$tableName_CL"
$resourceId = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/$providers"

Set-AzContext -Subscription $subscriptionId

$restParams = @{
    Method = "DELETE"
    Path   = "$resourceId?api-version=$apiVersion"
}

Invoke-AzRestMethod @restParams
```

---

| Variable | Example value | Purpose |
|----------|---------------|---------|
| host | *management.azure.com* | Implicit Azure Resource Manager endpoint |
| subscriptionId | aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e | User input |
| resourceGroupName | myResourceGroup | User input |
| workspaceName | myWorkspace | User input |
| tableName_CL | myTable_CL | User input |
| apiVersion | 2025-07-01 | [Reference](../fundamentals/azure-monitor-rest-api-index.md) |

## Add or delete a custom column

Custom tables let you modify the schema by adding or deleting columns after you create the table. In Azure tables, you can only add and delete custom columns.

> [!IMPORTANT]
> Whenever you update a table schema, be sure to [update any data collection rules](../data-collection/data-collection-rule-overview.md) that send data to the table. The table schema you define in your data collection rule determines how Azure Monitor streams data to the destination table. Azure Monitor doesn't update data collection rules automatically when you make table schema changes. 

Use these rules when defining column names for custom tables:
 
* Column names must start with a letter (A-Z or a-z).
* After the first character, use only letters, digits, or underscores.
* Don't use spaces, dots, dashes, or other punctuation in column names.
* Non-ASCII letters (for example, Æ, É, Ö) aren't supported in column names.
* Column names are only case sensitive for Analytics and Basic tables. Auxiliary log table ingestion drops data with duplicate column names when the only difference is case.
* Column names must be 2 to 45 characters long.
* Custom column names in Azure tables must end in `_CF`.
* The **GUID** type is a logical annotation, but the values are stored and queried as strings. For more information, see [Column data types in Azure Monitor Logs](logs-table-overview.md#column-data-types).
* Don't use names that conflict with system or reserved columns, including `id`, `BilledSize`, `IsBillable`, `InvalidTimeGenerated`, `TenantId`, `Title`, `Type`, `UniqueId`, `_ItemId`, `_ResourceGroup`, `_ResourceId`, `_SubscriptionId`, `_TimeReceived`.

These schema rules are stricter than [general Kusto identifier rules](/kusto/query/schema-entities/entity-names). Kusto can reference unusual property names with quoting in queries, but the custom table schema accepts only letters, digits, and underscores for column names.

# [Portal](#tab/azure-portal-1)

To add a custom column to a table in your Log Analytics workspace, or delete a column:

1. From the **Log Analytics workspaces** menu, select **Tables**.

1. Select the ellipsis ( **...** ) to the right of the table you want to edit and select **Edit schema**.

    This action opens the **Schema Editor** screen.

1. Scroll down to the **Custom Columns** section of the **Schema Editor** screen.
 
    :::image type="content" source="media/create-custom-table/add-or-delete-column-azure-monitor-logs.png" lightbox="media/create-custom-table/add-or-delete-column-azure-monitor-logs.png" alt-text="Screenshot showing the Schema Editor screen with the Add a column and Delete buttons highlighted.":::

1. To add a new column:

    1. Select **Add a column**.
    1. Set the column name and description (optional), and select the expected value type from the **Type** dropdown.
    1. Select **Save** to save the new column.

1. To delete a column, select the **Delete** icon to the left of the column you want to delete.

# [Azure CLI](#tab/cli-1)

To add a custom column:

```azurecli
subscriptionId="aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
resourceGroupName="myResourceGroup"
workspaceName="myWorkspace"
tableName="Heartbeat"

az account set --subscription "$subscriptionId"

az monitor log-analytics workspace table update \
  --resource-group "$resourceGroupName" \
  --workspace-name "$workspaceName" \
  --name "$tableName" \
  --columns Custom1_CF=string
```

To delete a custom column, use the REST API or PowerShell approach. The CLI `update` command adds columns but doesn't support column deletion.

# [REST](#tab/rest-1)

To add a custom column, send a `PUT` request with the updated schema. Include the new column in the `columns` array. The request returns the updated table properties.

To delete a custom column, send the same `PUT` request but omit the column from the `columns` array. To delete all custom columns, send an empty `columns` array.

```REST
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/tables/{tableName}?api-version={apiVersion}
Authorization: Bearer {token}
Content-Type: application/json

{
  "properties": {
    "schema": {
      "name": "{tableName}",
      "columns": [
        {"name": "{columnName}",
          "type": "string",
          "description": "Custom column description"}
      ]
    }
  }
}
```

# [PowerShell](#tab/powershell-1)

[!INCLUDE [Azure PowerShell using REST](../includes/powershell-using-rest.md)]

**Add a custom column**

```azurepowershell
$subscriptionId = "aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
$resourceGroupName = "myResourceGroup"
$workspaceName = "myWorkspace"
$tableName = "Heartbeat"
$apiVersion = "2025-07-01"
$providers = "Microsoft.OperationalInsights/workspaces/$workspaceName/tables/$tableName"
$resourceId = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/$providers"
$payloadFile = ".\add-column.json"

Set-AzContext -Subscription $subscriptionId

$restParams = @{
    Method  = "PUT"
    Path    = "$resourceId?api-version=$apiVersion"
    Payload = Get-Content -Raw -Path $payloadFile
}

Invoke-AzRestMethod @restParams
```

<br>
<details>
<summary>Expand to view the add-column.json file.</summary>

```json
{
  "properties": {
    "schema": {
      "name": "Heartbeat",
      "columns": [
        {
          "name": "Custom1_CF",
          "type": "string",
          "description": "First custom column"
        }
      ]
    }
  }
}
```

</details>

The `PUT` call returns the updated table properties, which include the newly added column.

**Replace a custom column**

To delete a column and add another one, send a `PUT` request that includes only the columns you want to keep. The following example replaces `Custom1_CF` with `Custom2_CF`:

<br>
<details>
<summary>Expand to view the replace-column.json file.</summary>

```json
{
  "properties": {
    "schema": {
      "name": "Heartbeat",
      "columns": [
        {
          "name": "Custom2_CF",
          "type": "datetime",
          "description": "Replacement custom column"
        }
      ]
    }
  }
}
```

</details>

**Delete all custom columns**

To delete all custom columns from a table, send a `PUT` request with an empty `columns` array:

<br>
<details>
<summary>Expand to view the delete-all-columns.json file.</summary>

```json
{
  "properties": {
    "schema": {
      "name": "Heartbeat",
      "columns": []
    }
  }
}
```

</details>

---

| Variable | Example value | Purpose |
|----------|---------------|---------|
| host | *management.azure.com* | Implicit Azure Resource Manager endpoint |
| subscriptionId | aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e | User input |
| resourceGroupName | myResourceGroup | User input |
| workspaceName | myWorkspace | User input |
| tableName | Heartbeat | User input |
| columnName | Custom1_CF | User input |
| apiVersion | 2025-07-01 | [Reference](../fundamentals/azure-monitor-rest-api-index.md) |

## Related content

* [Collecting logs with the Log Ingestion API](../logs/logs-ingestion-api-overview.md)
* [Collecting logs with Azure Monitor Agent](../agents/agents-overview.md)
* [Collect data from virtual machines](../vm/data-collection.md)
