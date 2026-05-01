---
title: Set Up a Table with the Auxiliary Plan for Low-Cost Data Ingestion and Retention in Your Log Analytics Workspace
description: Create a custom table with the Auxiliary table plan in your Log Analytics workspace for low-cost ingestion and retention of log data.
ms.topic: how-to
ms.reviewer: adi.biran
ms.date: 03/05/2026
ms.custom: ai-assisted

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
> Auxiliary logs are generally available (GA) for all public cloud regions except for Qatar Central, and not available for Azure Government or China clouds.

## Create a custom table with the Auxiliary plan

# [Portal](#tab/azure-portal-1)

To create a custom table with the Auxiliary plan in the Azure portal:

1. From the **Log Analytics workspaces** menu, select **Tables**.

1. Select **Create**.

1. On the **Basics** tab, specify a name and, optionally, a description for the table. The portal automatically adds the *_CL* suffix to the table name.

1. Under **Table plan**, select **Auxiliary / Lake**.

1. Select **Next** and complete the remaining steps to configure the schema and data collection. For detailed instructions on the remaining steps, see [Add or delete tables and columns in Azure Monitor Logs](create-custom-table.md#create-a-custom-table).

> [!NOTE]
> This sample lists all the supported column data types.

# [REST](#tab/rest-1)

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
                {"name": "GuidProperty",
                 "type": "guid"},
                {"name": "DateTimeProperty",
                 "type": "dateTime"}
            ]
        },
        "totalRetentionInDays": 365,
        "plan": "Auxiliary"
    }
}
```

> [!NOTE]
> * The `TimeGenerated` column only supports the ISO 8601 format with 6 decimal places for precision (microseconds). For more information, see [supported ISO 8601 datetime format](/azure/data-explorer/kusto/query/scalar-data-types/datetime#iso-8601).
> * Tables with the Auxiliary plan don't support columns with dynamic data.

# [Azure CLI](#tab/cli-1)

[!INCLUDE [Azure CLI using REST](../includes/cli-using-rest.md)]

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
          "name": "GuidProperty",
          "type": "guid"
        },
        {
          "name": "DateTimeProperty",
          "type": "dateTime"
        }
      ]
    },
    "totalRetentionInDays": 365,
    "plan": "Auxiliary"
  }
}
```

</details>

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
$payloadFile = ".\my-table.json"

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
          "name": "GuidProperty",
          "type": "guid"
        },
        {
          "name": "DateTimeProperty",
          "type": "dateTime"
        }
      ]
    },
    "totalRetentionInDays": 365,
    "plan": "Auxiliary"
  }
}
```

</details>

# [ARM (JSON)](#tab/arm-1)

The following ARM (JSON) example uses the [Microsoft.OperationalInsights workspaces/tables](/azure/templates/microsoft.operationalinsights/workspaces/tables?pivots=deployment-language-arm-template) resource type.

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
              "name": "GuidProperty",
              "type": "guid"
            },
            {
              "name": "DateTimeProperty",
              "type": "dateTime"
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

# [Bicep](#tab/bicep-1)

The following Bicep example uses the [Microsoft.OperationalInsights workspaces/tables](/azure/templates/microsoft.operationalinsights/workspaces/tables?pivots=deployment-language-bicep) resource type.

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
          name: 'GuidProperty'
          type: 'guid'
        }
        {
          name: 'DateTimeProperty'
          type: 'dateTime'
        }
      ]
    }
    totalRetentionInDays: 365
    plan: 'Auxiliary'
  }
}
```

---

| Variable | Example value | Purpose |
|----------|---------------|---------|
| host | *management.azure.com* | Implicit ARM endpoint |
| subscriptionId | aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e | User input |
| resourceGroupName | myResourceGroup | User input |
| workspaceName | myWorkspace | User input |
| tableName_CL | myTable_CL | User input |
| apiVersion | 2025-07-01 | [Reference](../fundamentals/azure-monitor-rest-api-index.md) |

## Send data to a table with the Auxiliary plan

There are multiple ways to ingest data to a custom table with the Auxiliary plan:

* Azure Monitor Agent (AMA)
* Logs ingestion API
* Workspace transformation

### Use the AMA

If you use this method, your custom table must only have two columns - `TimeGenerated` (type `datetime`) and `RawData` (of type `string`). The data collection rule sends the entirety of each log entry you collect to the `RawData` column, and Azure Monitor Logs automatically populates the `TimeGenerated` column with the time the log is ingested.

For more information on how to use the AMA, see the following articles:

* [Collect logs from a text file with Azure Monitor Agent](../agents/data-collection-log-text.md)
* [Collect logs from a JSON file with Azure Monitor Agent](../agents/data-collection-log-json.md).

### Use the logs ingestion API

This method closely follows the steps described in [Tutorial: Send data to Azure Monitor using Logs ingestion API](tutorial-logs-ingestion-api.md).

1. [Create a custom table with the Auxiliary plan](#create-a-custom-table-with-the-auxiliary-plan) as described in this article.

1. [Create a Microsoft Entra application](tutorial-logs-ingestion-api.md#create-microsoft-entra-application).

1. [Create a data collection rule](tutorial-logs-ingestion-api.md#create-data-collection-rule). Here's a sample ARM template for `kind`: `Direct`. This type of DCR doesn't require a DCE since it includes a `logsIngestion` endpoint.

    * `myWorkspace` is the name of your Log Analytics workspace.
    * `myTable_CL` is the name of your table.
    * `columns` includes the same columns you set in the creation of the table.

    # [REST](#tab/rest-2)

    > [!NOTE]
    > The following REST call uses example values.

    ```REST
    PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/dataCollectionRules/{dataCollectionRuleName}?api-version={apiVersion}
    Authorization: Bearer {token}
    Content-Type: application/json

    {
      "location": "<location>",
      "kind": "Direct",
      "properties": {
        "streamDeclarations": {
          "<Custom-tableName>": {
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
                "name": "GuidProperty",
                "type": "guid"
              },
              {
                "name": "DateTimeProperty",
                "type": "dateTime"
              }
            ]
          }
        },
        "destinations": {
          "logAnalytics": [
            {
              "workspaceResourceId": "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.OperationalInsights/workspaces/<workspaceName>",
              "name": "<workspaceName>"
            }
          ]
        },
        "dataFlows": [
          {
            "streams": [
              "<Custom-tableName>"
            ],
            "transformKql": "source",
            "destinations": [
              "myWorkspace"
            ],
            "outputStream": "<Custom-tableName_CL>"
          }
        ]
      }
    }
    ```

    # [Azure CLI](#tab/cli-2)

    The following Azure CLI example uses the [az monitor data-collection rule](/cli/azure/monitor/data-collection/rule) command group.

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
          "Custom-myTable": {
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
                "name": "GuidProperty",
                "type": "guid"
              },
              {
                "name": "DateTimeProperty",
                "type": "dateTime"
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
              "Custom-myTable"
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

    # [PowerShell](#tab/powershell-2)

    The following PowerShell example uses the [New-AzDataCollectionRule](/powershell/module/az.monitor/new-azdatacollectionrule) cmdlet.

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
          "Custom-myTable": {
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
                "name": "GuidProperty",
                "type": "guid"
              },
              {
                "name": "DateTimeProperty",
                "type": "dateTime"
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
              "Custom-myTable"
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

    # [ARM (JSON)](#tab/arm-2)

    The following ARM (JSON) example uses the [Microsoft.Insights dataCollectionRules](/azure/templates/microsoft.insights/datacollectionrules?pivots=deployment-language-arm-template) resource type.

    ```json
    {
      "$schema": "https://schema.management.azure.com/schemas/2019-08-01/deploymentTemplate.json#",
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
            "description": "Specifies the region in which to create the data collection rule. The must be the same region as the destination Log Analytics workspace."
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
              "Custom-myTable": {
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
                    "name": "GuidProperty",
                    "type": "guid"
                  },
                  {
                    "name": "DateTimeProperty",
                    "type": "dateTime"
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
                  "Custom-myTable"
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

    # [Bicep](#tab/bicep-2)

    The following Bicep example uses the [Microsoft.Insights dataCollectionRules](/azure/templates/microsoft.insights/datacollectionrules?pivots=deployment-language-bicep) resource type.

    ```bicep
    @description('Specifies the name of the data collection rule to create.')
    param dataCollectionRuleName string = 'myDataCollectionRule'

    @description('Specifies the region in which to create the data collection rule. The must be the same region as the destination Log Analytics workspace.')
    param location string = 'eastus'

    @description('The Azure resource ID of the Log Analytics workspace in which you created a custom table with the Auxiliary plan.')
    param workspaceResourceId string = '/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/myResourceGroup/providers/Microsoft.OperationalInsights/workspaces/myWorkspace'

    resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2025-07-01' = {
      name: dataCollectionRuleName
      location: location
      kind: 'Direct'
      properties: {
        streamDeclarations: {
          'Custom-myTable': {
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
                name: 'GuidProperty'
                type: 'guid'
              }
              {
                name: 'DateTimeProperty'
                type: 'dateTime'
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
              'Custom-myTable'
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
    | host | *management.azure.com* | Implicit ARM endpoint |
    | subscriptionId | aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e | User input |
    | resourceGroupName | myResourceGroup | User input |
    | dataCollectionRuleName | myDataCollectionRule | User input |
    | streams | Custom-myTable | User input |
    | outputStream | Custom-myTable_CL | User input |
    | apiVersion | 2025-07-01 | [Reference](../fundamentals/azure-monitor-rest-api-index.md) |

1. [Grant your application permission to use your DCR](tutorial-logs-ingestion-api.md#assign-permissions-to-a-dcr).

1. Send data using [sample code](tutorial-logs-ingestion-code.md).

> [!WARNING]
> When ingesting logs into the Auxiliary tier of Azure Monitor, avoid submitting a single payload that contains TimeGenerated timestamps that span more than 30 minutes in one API call. This API call might lead to the following ingestion error code `RecordsTimeRangeIsMoreThan30Minutes`. This is a [known limitation](../fundamentals/service-limits.md#logs-ingestion-api) that's getting removed.
>
> This restriction does not apply to Auxiliary logs that use [transformations](../data-collection/data-collection-transformations.md).

### Use a workspace transformation

For more information, see the following articles:

* [Overview of workspace transformation DCRs](../data-collection/data-collection-transformations.md#workspace-transformation-dcr)
* [How-to create a workspace transformation](../data-collection/data-collection-transformations-create.md#create-workspace-transformation-dcr)

## Related content

* [Azure Monitor Logs table plans](data-platform-logs.md#table-plans)
* [Collecting logs with the Log Ingestion API](logs-ingestion-api-overview.md)
* [Data collection rules](../data-collection/data-collection-endpoint-overview.md)
