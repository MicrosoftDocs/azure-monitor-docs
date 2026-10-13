---
title: Metrics Export Using Data Collection Rules
description: Learn how to create data collection rules for metrics.
ms.topic: how-to
ms.date: 05/29/2026
ms.custom: ai-assisted, cbo-v1.6
ai-usage: ai-assisted
---

# Metrics export using data collection rules

Platform metrics measure the performance of different aspects of your Azure resources. Platform telemetry [data collection rules (DCRs)](./data-collection-rule-overview.md) let you collect and export platform metrics from supported Azure resources. This article shows you how to create a DCR for metrics export.

> [!NOTE]
> While you can use DCRs and diagnostic settings at the same time, you should disable any diagnostic settings for metrics when using DCRs to avoid duplicate data collection.

## Compare to diagnostic settings

Before this feature, you could only export platform metrics by using [diagnostic settings](diagnostic-settings.md). Diagnostic settings are still required for resource types that don't yet support DCRs.

Platform telemetry DCRs provide several benefits over diagnostic settings:

* DCR configuration enables exporting metrics with dimensions.
* DCR configuration enables filtering based on metric name so you can export only the metrics that you need.
* DCRs are more flexible and scalable than diagnostic settings. Use a single DCR with multiple resources, while a separate diagnostic setting is required for each resource.
* End-to-end latency for DCRs is within three minutes, while diagnostic settings export latency is six to ten minutes.

> [!NOTE]
> Use metrics export with DCRs for continuous export of metrics data as it's created. To query historical data that's already been collected, use the [Data plane Metrics Batch API](/rest/api/monitor/metrics-batch/batch). See [Data plane Metrics Batch API query versus Metrics export](data-plane-versus-metrics-export.md) for a comparison of the two strategies.

## Export destinations

Metrics can be exported to the following destinations.

| Destination type | Details |
|------------------|---------|
| Log Analytics workspaces | Exporting to Log Analytics workspaces can be across regions. The Log Analytics workspace and the DCR must be in the same region but resources that are being monitored can be in any region. Metrics sent to a log analytics workspace are stored in the `AzureMetricsV2` table. |
| Azure storage accounts |  The storage account, the DCR, and the resources being monitored must all be in the same region. |
| Event Hubs | The Event Hubs, the DCR, and the resources being monitored must all be in the same region. |

> [!NOTE]
> Latency for exporting metrics is approximately 3 minutes. Allow up to 15 minutes for metrics to begin to appear in the destination after the initial setup.

## Limitations

DCRs for metrics export have the following limitations:

* Only one destination type can be specified per DCR. To send to multiple destinations, create multiple DCRs.
* A maximum of 5 DCRs can be associated with a single Azure resource.
* Metrics export with DCR doesn't support the export of hourly grain metrics.

## Supported resources and regions

For the current list of supported resources and supported regions, see [Metrics export supported resources and regions](metrics-export-reference.md).

## Create a data collection rule (DCR) for metrics export

Create a [data collection rule (DCR)](data-collection-rule-overview.md) for metrics export by using the Azure portal, Azure CLI, Azure PowerShell, REST API, Bicep, or an ARM template. The command-line examples use the currently selected subscription.

> [!IMPORTANT]
> To send Platform Telemetry data to Storage Accounts or Event Hubs, the resource, data collection rule, and the destination Storage Account or the Event Hubs must all be in the same region.

# [Portal](#tab/portal)

### Create a data collection rule using the Azure portal

1. On the Monitor menu in the Azure portal, select **Data Collection Rules** and then **Create**.

1. On the **Create Data Collection Rule** page, enter a rule name, select a **Subscription**, **Resource group**, and **Region** for the DCR.

1. Select *PlatformTelemetry* for the **Type of telemetry** and **Enable Managed Identity** if you want to send metrics to a Storage Account or Event Hubs.

    :::image type="content" source="media/metrics-export-create/create-data-collection-rule-metrics-basics.png" lightbox="media/metrics-export-create/create-data-collection-rule-metrics-basics.png" alt-text="A screenshot showing the basics tab of the create data collection rule page.":::

1. On the **Resources** page, select **Add resources** to add the resources you want to collect metrics from.

1. Select **Next** to move to the **Collect and deliver** tab.

    :::image type="content" source="media/metrics-export-create/create-data-collection-rule-metrics-resources.png" lightbox="media/metrics-export-create/create-data-collection-rule-metrics-resources.png" alt-text="A screenshot showing the resources tab of the create data collection rule page.":::

1. Select **Add new datasource**.

1. The resource type of the resource specified in the previous step is automatically selected. Add more resource types if you want to use this rule to collect metrics from multiple resource types in the future. Select the **Actions** for a resource type if you want to remove some of the metrics collected for it. By default, all available metrics for the resource are collected.

    :::image type="content" source="media/metrics-export-create/create-data-collection-rule-metrics-data-source.png" lightbox="media/metrics-export-create/create-data-collection-rule-metrics-data-source.png" alt-text="A screenshot showing the Data source tab of the Add new data source pane for a data collection rule.":::

1. Select **Next Destinations** to move to the **Destinations** tab.

1. Select **Add destination** and then the **Destination type** that you want to add. The required fields change based on the destination type you select.

    > [!NOTE]
    > To send metrics to a Storage Account or Event Hubs, the resource generating the metrics, the DCR, and the Storage Account or Event Hub, must all be in the same region. To send metrics to a Log Analytics workspace, the DCR must be in the same region as the Log Analytics workspace. The resource generating the metrics can be in any region.

    :::image type="content" source="media/metrics-export-create/create-data-collection-rule-metrics-data-destination.png" lightbox="media/metrics-export-create/create-data-collection-rule-metrics-data-destination.png" alt-text="A screenshot showing the Destination tab of the Add new data source pane for a data collection rule.":::

1. Select **Save** , then select **Review + create**.

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az monitor data-collection rule create`](/cli/azure/monitor/data-collection/rule#az-monitor-data-collection-rule-create) command.

### Create a data collection rule using Azure CLI

Create a JSON file containing the collection rule specification. For more information, see [Data collection rule (DCR) structure for metrics export](metrics-export-structure.md). For sample JSON files, see [Sample Metrics Export JSON objects](metrics-export-structure.md#metrics-export-samples).

> [!IMPORTANT]
> The rule file has the same format as used for PowerShell and the REST API, however the file must not contain `identity`, the `location`, or `kind`. These parameters are specified in the `az monitor data-collection rule create` command.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
dataCollectionRuleName="<DataCollectionRuleName>"
azureRegion="<AzureRegion>"
ruleFilePath="<RuleFilePath>"

# Create the data collection rule
az monitor data-collection rule create --name "$dataCollectionRuleName" \
  --resource-group "$resourceGroupName" \
  --location "$azureRegion" \
  --kind PlatformTelemetry \
  --identity "{type:'SystemAssigned'}" \
  --rule-file "$ruleFilePath"
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

For storage account and Event Hubs destinations, enable managed identity for the DCR by using `--identity "{type:'SystemAssigned'}"`. Identity isn't required for Log Analytics workspaces.

Use the DCR's `id` to create an association and its `principalId` to assign a role. The following output excerpt shows these properties.

**Output:**

```json
{
  "id": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/myResourceGroup/providers/Microsoft.Insights/dataCollectionRules/myDataCollectionRule",
  "identity": {
    "principalId": "eeeeeeee-ffff-aaaa-5555-666666666666",
    "tenantId": "aaaabbbb-0000-cccc-1111-dddd2222eeee",
    "type": "systemAssigned"
  }
}
```

### Grant write permissions to the managed identity

The managed identity used by the DCR must have write permissions to the destination when the destination is a Storage Account or Event Hubs. To grant permissions for the rule's managed identity, assign the appropriate role to the entity.

The following table shows the roles required for each destination type:

| Destination type | Role |
|------------------|------|
| Log Analytics workspace | not required |
| Azure storage account | `Storage Blob Data Contributor` |
| Event Hubs | `Azure Event Hubs Data Sender` |

For more information on assigning roles, see [Assign Azure roles to a managed identity](/azure/role-based-access-control/role-assignments-portal-managed-identity).

Assign the appropriate role to the managed identity of the DCR. The following example assigns the `Storage Blob Data Contributor` role to the managed identity of the DCR for a storage account.

The following Azure CLI example uses the [`az role assignment create`](/cli/azure/role/assignment#az-role-assignment-create) command.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
storageAccountName="<StorageAccountName>"
principalId="<PrincipalId>"
roleDefinitionName="Storage Blob Data Contributor"

# Get the subscription ID from the current Azure CLI context
subscriptionId=$(az account show --query id --output tsv)

# Build destination storage account resource ID
storagePath="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
storageProvider="Microsoft.Storage/storageAccounts/$storageAccountName"
storageAccountResourceId="$storagePath/providers/$storageProvider"

# Grant write access to the storage account
az role assignment create --assignee "$principalId" \
  --role "$roleDefinitionName" \
  --scope "$storageAccountResourceId"
```

### Create a data collection rule association

After you create the data collection rule, create a data collection rule association (DCRA) to associate the rule with the resource to monitor.

The following Azure CLI example uses the [`az monitor data-collection rule association create`](/cli/azure/monitor/data-collection/rule/association#az-monitor-data-collection-rule-association-create) command. It associates the DCR with a key vault.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
associationName="<AssociationName>"
dataCollectionRuleName="<DataCollectionRuleName>"
keyVaultName="<KeyVaultName>"

# Get the subscription ID from the current Azure CLI context
subscriptionId=$(az account show --query id --output tsv)

# Build data collection rule resource ID
rulePath="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
ruleProvider="Microsoft.Insights/dataCollectionRules/$dataCollectionRuleName"
dataCollectionRuleId="$rulePath/providers/$ruleProvider"

# Build Key Vault resource ID
keyVaultPath="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
keyVaultProvider="Microsoft.KeyVault/vaults/$keyVaultName"
keyVaultResourceId="$keyVaultPath/providers/$keyVaultProvider"

# Create the data collection rule association
az monitor data-collection rule association create --name "$associationName" \
  --rule-id "$dataCollectionRuleId" \
  --resource "$keyVaultResourceId"
```

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`New-AzDataCollectionRule`](/powershell/module/az.monitor/new-azdatacollectionrule) cmdlet.

### Create a data collection rule using Azure PowerShell

Create a JSON file containing the collection rule specification. For more information, see [Data collection rule (DCR) structure for metrics export](metrics-export-structure.md). For sample JSON files, see [Sample Metrics Export JSON objects](metrics-export-structure.md#metrics-export-samples).

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$dataCollectionRuleName = "<DataCollectionRuleName>"
$ruleFilePath = "<RuleFilePath>"

# Define parameters for New-AzDataCollectionRule
$newAzDataCollectionRuleParams = @{
    Name              = $dataCollectionRuleName
    ResourceGroupName = $resourceGroupName
    JsonFilePath      = $ruleFilePath
}

# Create the data collection rule
New-AzDataCollectionRule @newAzDataCollectionRuleParams
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

Use the DCR's `Id` to create an association and its `IdentityPrincipalId` to assign a role. The following output excerpt shows these properties.

**Output:**

```output
Id                                        : /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/myResourceGroup/providers/Microsoft.Insights/dataCollectionRules/myDataCollectionRule
IdentityPrincipalId                       : eeeeeeee-ffff-aaaa-5555-666666666666
IdentityTenantId                          : aaaabbbb-0000-cccc-1111-dddd2222eeee
IdentityType                              : systemAssigned
IdentityUserAssignedIdentity              : {
                                            }
```

### Grant write permissions to the managed identity

The managed identity used by the DCR must have write permissions to the destination when the destination is a Storage Account or Event Hubs.
To grant permissions for the rule's managed identity, assign the appropriate role to the entity.

The following table shows the roles required for each destination type:

| Destination type | Role |
|------------------|------|
| Log Analytics workspace | not required |
| Azure storage account | `Storage Blob Data Contributor` |
| Event Hubs | `Azure Event Hubs Data Sender` |

For more information, see [Assign Azure roles to a managed identity](/azure/role-based-access-control/role-assignments-portal-managed-identity).

Assign the appropriate role to the managed identity of the DCR using `New-AzRoleAssignment`. The following example assigns the `Azure Event Hubs Data Sender` role to the managed identity of the DCR at the subscription level.

The following Azure PowerShell example uses the [`New-AzRoleAssignment`](/powershell/module/az.resources/new-azroleassignment) cmdlet.

```powershell
# Set variables
$principalId = "<PrincipalId>"
$roleDefinitionName = "Azure Event Hubs Data Sender"

# Get the subscription ID from the current Azure PowerShell context
$subscriptionId = (Get-AzContext).Subscription.Id
$scope = "/subscriptions/$subscriptionId"

# Define parameters for New-AzRoleAssignment
$newAzRoleAssignmentParams = @{
  ObjectId           = $principalId
    RoleDefinitionName = $roleDefinitionName
    Scope              = $scope
}

# Grant write access to Event Hubs
New-AzRoleAssignment @newAzRoleAssignmentParams
```

### Create a data collection rule association

After you create the data collection rule, create a data collection rule association (DCRA) to associate the rule with the resource to monitor.

The following Azure PowerShell example uses the [`New-AzDataCollectionRuleAssociation`](/powershell/module/az.monitor/new-azdatacollectionruleassociation) cmdlet. It associates the DCR with a key vault.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$associationName = "<AssociationName>"
$keyVaultName = "<KeyVaultName>"
$dataCollectionRuleName = "<DataCollectionRuleName>"

# Get the subscription ID from the current Azure PowerShell context
$subscriptionId = (Get-AzContext).Subscription.Id

# Build data collection rule resource ID
$rulePath = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
$ruleProvider = "Microsoft.Insights/dataCollectionRules/$dataCollectionRuleName"
$dataCollectionRuleId = "$rulePath/providers/$ruleProvider"

# Build Key Vault resource ID
$keyVaultPath = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
$keyVaultProvider = "Microsoft.KeyVault/vaults/$keyVaultName"
$keyVaultResourceId = "$keyVaultPath/providers/$keyVaultProvider"

# Define parameters for New-AzDataCollectionRuleAssociation
$newAzDataCollectionRuleAssociationParams = @{
  AssociationName      = $associationName
  ResourceUri          = $keyVaultResourceId
    DataCollectionRuleId = $dataCollectionRuleId
}

# Create the data collection rule association
New-AzDataCollectionRuleAssociation @newAzDataCollectionRuleAssociationParams
```

# [REST](#tab/rest)

The following REST example uses the [`Data Collection Rules - Create`](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-data-collection-rules) REST API operation.

Creating a data collection rule for metrics requires the following steps:

1. Create the data collection rule.
1. Grant permissions for the rule's managed identity to write to the destination.
1. Create a data collection rule association.

### Create the data collection rule

To create a DCR using the REST API, you must make an authenticated request using a bearer token. For more information on authenticating with Azure Monitor, see [Authenticate Azure Monitor requests](/azure/azure-monitor/essentials/rest-api-walkthrough?tabs=portal#authenticate-azure-monitor-requests).

Send the DCR JSON object as the request body to the following endpoint.

```REST
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/dataCollectionRules/{dataCollectionRuleName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
Content-Type: application/json
```

The payload is a JSON object that defines a collection rule. The payload is sent in the body of the request. For more information on the JSON structure, see [Data collection rule (DCR) structure for metrics export](metrics-export-structure.md). For sample DCR JSON objects, see [Sample Metrics Export JSON objects](metrics-export-structure.md#metrics-export-samples).

### Grant write permissions to the managed identity

The managed identity used by the DCR must have write permissions to the destination when the destination is a Storage Account or Event Hubs. To grant permissions for the rule's managed identity, assign the appropriate role to the entity.

The following table shows the roles required for each destination type:

| Destination type | Role |
|------------------|------|
| Log Analytics workspace | not required |
| Azure storage account | `Storage Blob Data Contributor` |
| Event Hubs | `Azure Event Hubs Data Sender` |

For more information, see [Assign Azure roles to a managed identity](/azure/role-based-access-control/role-assignments-portal-managed-identity).

To assign a role to a managed identity using REST, see [Role Assignments - Create](/rest/api/authorization/role-assignments/create).

### Create a data collection rule association

After you create the data collection rule, create a data collection rule association (DCRA) to associate the rule with the resource to monitor.

The following REST example uses the [`Data Collection Rule Associations - Create`](../fundamentals/azure-monitor-rest-api-index.md#op-monitor-data-collection-rule-associations) REST API operation. It associates the DCR with a virtual machine.

```REST
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/{virtualMachineName}/providers/Microsoft.Insights/dataCollectionRuleAssociations/{associationName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
Content-Type: application/json

{
  "properties": {
    "description": "<AssociationDescription>",
    "dataCollectionRuleId": "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.Insights/dataCollectionRules/<DataCollectionRuleName>"
  }
}
```

# [Bicep](#tab/bicep)

The following Bicep example uses the [`Microsoft.Insights/dataCollectionRules`](/azure/templates/microsoft.insights/datacollectionrules?pivots=deployment-language-bicep) resource type.

### Create a data collection rule using Bicep templates

Save the template as `metrics-export.bicep`. It sends metrics to an existing Log Analytics workspace. The subscription, resource group, and workspace name identify that workspace. For `metricName`, use `Metrics-Group-All` to collect all metrics for the resource type, or use an individual metric name.

<br>
<details>
<summary>Create a rule to export selected metrics to a workspace</summary>

```bicep
param subscriptionId string = '<SubscriptionId>'
param resourceGroupName string = '<ResourceGroupName>'
param dataCollectionRuleName string = '<DataCollectionRuleName>'
param azureRegion string = '<AzureRegion>'
param workspaceName string = '<WorkspaceName>'
param resourceType string = '<ResourceType>'
param metricName string = '<MetricName>'
param dataSourceName string = '<DataSourceName>'
param destinationName string = '<DestinationName>'

var workspaceResourceId = resourceId(
  subscriptionId,
  resourceGroupName,
  'Microsoft.OperationalInsights/workspaces',
  workspaceName
)
var metricStream = '${resourceType}:${metricName}'

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@<ApiVersion>' = {
  name: dataCollectionRuleName
  location: azureRegion
  kind: 'PlatformTelemetry'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dataSources: {
      platformTelemetry: [
        {
          streams: [
            metricStream
          ]
          name: dataSourceName
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: workspaceResourceId
          name: destinationName
        }
      ]
    }
    dataFlows: [
      {
        streams: [
          metricStream
        ]
        destinations: [
          destinationName
        ]
      }
    ]
  }
}
```

</details>

### Parameters file

Save the following parameters as `metrics-export.bicepparam` beside `metrics-export.bicep`.

```bicep
using './metrics-export.bicep'

param subscriptionId = '<SubscriptionId>'
param resourceGroupName = '<ResourceGroupName>'
param dataCollectionRuleName = '<DataCollectionRuleName>'
param azureRegion = '<AzureRegion>'
param workspaceName = '<WorkspaceName>'
param resourceType = '<ResourceType>'
param metricName = '<MetricName>'
param dataSourceName = '<DataSourceName>'
param destinationName = '<DestinationName>'
```

### Sample DCR template

This template exports all metrics from virtual machines, virtual machine scale sets, Redis caches, and key vaults to a Log Analytics workspace.

<br>
<details>
<summary>Create a rule to export all metrics from four resource types</summary>

```bicep
param subscriptionId string = '<SubscriptionId>'
param resourceGroupName string = '<ResourceGroupName>'
param dataCollectionRuleName string = '<DataCollectionRuleName>'
param azureRegion string = '<AzureRegion>'
param workspaceName string = '<WorkspaceName>'
param dataSourceName string = '<DataSourceName>'
param destinationName string = '<DestinationName>'

var workspaceResourceId = resourceId(
  subscriptionId,
  resourceGroupName,
  'Microsoft.OperationalInsights/workspaces',
  workspaceName
)
var metricStreams = [
  'Microsoft.Compute/virtualMachines:Metrics-Group-All'
  'Microsoft.Compute/virtualMachineScaleSets:Metrics-Group-All'
  'Microsoft.Cache/redis:Metrics-Group-All'
  'Microsoft.KeyVault/vaults:Metrics-Group-All'
]

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@<ApiVersion>' = {
  name: dataCollectionRuleName
  location: azureRegion
  kind: 'PlatformTelemetry'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dataSources: {
      platformTelemetry: [
        {
          streams: metricStreams
          name: dataSourceName
        }
      ]
    }
    destinations: {
      logAnalytics: [
        {
          workspaceResourceId: workspaceResourceId
          name: destinationName
        }
      ]
    }
    dataFlows: [
      {
        streams: metricStreams
        destinations: [
          destinationName
        ]
      }
    ]
  }
}
```

</details>

# [ARM template](#tab/arm)

The following ARM template example uses the [`Microsoft.Insights/dataCollectionRules`](/azure/templates/microsoft.insights/datacollectionrules?pivots=deployment-language-arm-template) resource type.

### Create a data collection rule using ARM templates

Save the template as `metrics-export.json`. It sends metrics to an existing Log Analytics workspace. The subscription, resource group, and workspace name identify that workspace. For `metricName`, use `Metrics-Group-All` to collect all metrics for the resource type, or use an individual metric name.

<br>
<details>
<summary>Create a rule to export selected metrics to a workspace</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "subscriptionId": {
      "type": "string",
      "defaultValue": "<SubscriptionId>"
    },
    "resourceGroupName": {
      "type": "string",
      "defaultValue": "<ResourceGroupName>"
    },
    "dataCollectionRuleName": {
      "type": "string",
      "defaultValue": "<DataCollectionRuleName>"
    },
    "azureRegion": {
      "type": "string",
      "defaultValue": "<AzureRegion>"
    },
    "workspaceName": {
      "type": "string",
      "defaultValue": "<WorkspaceName>"
    },
    "resourceType": {
      "type": "string",
      "defaultValue": "<ResourceType>"
    },
    "metricName": {
      "type": "string",
      "defaultValue": "<MetricName>"
    },
    "dataSourceName": {
      "type": "string",
      "defaultValue": "<DataSourceName>"
    },
    "destinationName": {
      "type": "string",
      "defaultValue": "<DestinationName>"
    }
  },
  "variables": {
    "workspaceResourceId": "[resourceId(parameters('subscriptionId'), parameters('resourceGroupName'), 'Microsoft.OperationalInsights/workspaces', parameters('workspaceName'))]",
    "metricStream": "[concat(parameters('resourceType'), ':', parameters('metricName'))]"
  },
  "resources": [
    {
      "type": "Microsoft.Insights/dataCollectionRules",
      "apiVersion": "<ApiVersion>",
      "name": "[parameters('dataCollectionRuleName')]",
      "location": "[parameters('azureRegion')]",
      "kind": "PlatformTelemetry",
      "identity": {
        "type": "SystemAssigned"
      },
      "properties": {
        "dataSources": {
          "platformTelemetry": [
            {
              "streams": [
                "[variables('metricStream')]"
              ],
              "name": "[parameters('dataSourceName')]"
            }
          ]
        },
        "destinations": {
          "logAnalytics": [
            {
              "workspaceResourceId": "[variables('workspaceResourceId')]",
              "name": "[parameters('destinationName')]"
            }
          ]
        },
        "dataFlows": [
          {
            "streams": [
              "[variables('metricStream')]"
            ],
            "destinations": [
              "[parameters('destinationName')]"
            ]
          }
        ]
      }
    }
  ]
}
```

</details>

### Parameters file

Save the following parameters as `metrics-export.parameters.json` for `metrics-export.json`.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "subscriptionId": {
      "value": "<SubscriptionId>"
    },
    "resourceGroupName": {
      "value": "<ResourceGroupName>"
    },
    "dataCollectionRuleName": {
      "value": "<DataCollectionRuleName>"
    },
    "azureRegion": {
      "value": "<AzureRegion>"
    },
    "workspaceName": {
      "value": "<WorkspaceName>"
    },
    "resourceType": {
      "value": "<ResourceType>"
    },
    "metricName": {
      "value": "<MetricName>"
    },
    "dataSourceName": {
      "value": "<DataSourceName>"
    },
    "destinationName": {
      "value": "<DestinationName>"
    }
  }
}
```

### Sample DCR template

This template exports all metrics from virtual machines, virtual machine scale sets, Redis caches, and key vaults to a Log Analytics workspace.

<br>
<details>
<summary>Create a rule to export all metrics from four resource types</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "subscriptionId": {
      "type": "string",
      "defaultValue": "<SubscriptionId>"
    },
    "resourceGroupName": {
      "type": "string",
      "defaultValue": "<ResourceGroupName>"
    },
    "dataCollectionRuleName": {
      "type": "string",
      "defaultValue": "<DataCollectionRuleName>"
    },
    "azureRegion": {
      "type": "string",
      "defaultValue": "<AzureRegion>"
    },
    "workspaceName": {
      "type": "string",
      "defaultValue": "<WorkspaceName>"
    },
    "dataSourceName": {
      "type": "string",
      "defaultValue": "<DataSourceName>"
    },
    "destinationName": {
      "type": "string",
      "defaultValue": "<DestinationName>"
    }
  },
  "variables": {
    "workspaceResourceId": "[resourceId(parameters('subscriptionId'), parameters('resourceGroupName'), 'Microsoft.OperationalInsights/workspaces', parameters('workspaceName'))]",
    "metricStreams": [
      "Microsoft.Compute/virtualMachines:Metrics-Group-All",
      "Microsoft.Compute/virtualMachineScaleSets:Metrics-Group-All",
      "Microsoft.Cache/redis:Metrics-Group-All",
      "Microsoft.KeyVault/vaults:Metrics-Group-All"
    ]
  },
  "resources": [
    {
      "type": "Microsoft.Insights/dataCollectionRules",
      "apiVersion": "<ApiVersion>",
      "name": "[parameters('dataCollectionRuleName')]",
      "location": "[parameters('azureRegion')]",
      "kind": "PlatformTelemetry",
      "identity": {
        "type": "SystemAssigned"
      },
      "properties": {
        "dataSources": {
          "platformTelemetry": [
            {
              "streams": "[variables('metricStreams')]",
              "name": "[parameters('dataSourceName')]"
            }
          ]
        },
        "destinations": {
          "logAnalytics": [
            {
              "workspaceResourceId": "[variables('workspaceResourceId')]",
              "name": "[parameters('destinationName')]"
            }
          ]
        },
        "dataFlows": [
          {
            "streams": "[variables('metricStreams')]",
            "destinations": [
              "[parameters('destinationName')]"
            ]
          }
        ]
      }
    }
  ]
}
```

</details>

---

## Verify data collection

After creating the DCR, allow up to 30 minutes for the first platform metrics data to appear in the Log Analytics workspace. Once data starts flowing, the latency for a platform metric time series flowing to a Log Analytics workspace, storage account, or Event Hubs is approximately three minutes, depending on the resource type.

## Exported data

The following examples show the data exported to each destination.

### Log Analytics workspace

Data exported to a Log Analytics workspace is stored in the `AzureMetricsV2` table in the Log Analytics workspace in the following format:

[!INCLUDE [Log Analytics data format](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/azuremetricsv2-include.md)]

**Example:**

:::image type="content" source="media/data-collection-metrics/export-to-workspace.png" lightbox="media/data-collection-metrics/export-to-workspace.png" alt-text="A screenshot of a log analytics query of the AzureMetricsV2 table.":::

### Storage accounts

The following example shows data exported to a storage account:

```json
{
  "Average": "31.5",
  "Count": "2",
  "Maximum": "52",
  "Minimum": "11",
  "Total": "63",
  "resourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/rg-dcrs/providers/microsoft.keyvault/vaults/dcr-vault",
  "time": "2024-08-20T14:13:00.0000000Z",
  "unit": "MilliSeconds",
  "metricName": "ServiceApiLatency",
  "timeGrain": "PT1M",
  "dimension": {
    "ActivityName": "vaultget",
    "ActivityType": "vault",
    "StatusCode": "200",
    "StatusCodeClass": "2xx"
  }
}
```

### Event Hubs

The following example shows a metric exported to Event Hubs.

```json
{
  "Average": "1",
  "Count": "1",
  "Maximum": "1",
  "Minimum": "1",
  "Total": "1",
  "resourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/rg-dcrs/providers/microsoft.keyvault/vaults/dcr-vault",
  "time": "2024-08-22T13:43:00.0000000Z",
  "unit": "Count",
  "metricName": "ServiceApiHit",
  "timeGrain": "PT1M",
  "dimension": {
    "ActivityName": "keycreate",
    "ActivityType": "key"
  },
  "EventProcessedUtcTime": "2024-08-22T13:49:17.1233030Z",
  "PartitionId": 0,
  "EventEnqueuedUtcTime": "2024-08-22T13:46:04.5570000Z"
}
```

[!INCLUDE [data-collection-rule-troubleshoot](includes/data-collection-rule-troubleshoot.md)]

## Next steps

* [Read about the detailed structure of a data collection rule](data-collection-rule-structure.md).
* [Get details on transformations in a data collection rule](data-collection-transformations.md).
* [Collect platform logs using data collection rules](platform-logs-collect.md).
* [Review supported platform logs resource types and categories](platform-logs-reference.md).
