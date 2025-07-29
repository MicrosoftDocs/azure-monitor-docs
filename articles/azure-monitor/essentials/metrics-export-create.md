---
title: Create and edit data collection rules (DCRs) in Azure Monitor
description: Details on creating and editing data collection rules (DCRs) in Azure Monitor.
ms.topic: conceptual
ms.date: 09/15/2024
ms.reviewer: nikeist
ms.custom: references_regions
---

# Create a data collection rule (DCR) for metrics export 

This article describes how to create a [data collection rule (DCR)](./data-collection-rule-overview.md) for metrics export using the Azure portal, Azure CLI, PowerShell, API, or ARM templates.

> [!IMPORTANT]  
> To send Platform Telemetry data to Storage Accounts or Event Hubs, the resource, data collection rule, and the destination Storage Account or the Event Hubs must all be in the same region.


### [Portal](#tab/portal)

1. On the Monitor menu in the Azure portal, select **Data Collection Rules** then select **Create**.

1. To create a DCR to collect platform metrics data, select the link on the top of the page.
    :::image type="content" source="./media/metrics-export-create/create-data-collection-rule-metrics.png" lightbox="./media/metrics-export-create/create-data-collection-rule-metrics.png" alt-text="A screenshot showing the create data collection rule page.":::
1. On the **Create Data Collection Rule** page, enter a rule name, select a **Subscription**, **Resource group**, and **Region** for the DCR.
1. Select **Enable Managed Identity** if you want to send metrics to a Storage Account or Event Hubs. 
1. Select **Next**
   :::image type="content" source="./media/metrics-export-create/create-data-collection-rule-metrics-basics.png" lightbox="./media/metrics-export-create/create-data-collection-rule-metrics-basics.png" alt-text="A screenshot showing the basics tab of the create data collection rule page.":::
1. On the **Resources** page, select **Add resources**  to add the resources you want to collect metrics from. 
1. Select **Next** to move to the **Collect and deliver** tab.
   :::image type="content" source="./media/metrics-export-create/create-data-collection-rule-metrics-resources.png" lightbox="./media/metrics-export-create/create-data-collection-rule-metrics-resources.png" alt-text="A screenshot showing the resources tab of the create data collection rule page.":::
1. Select **Add new dataflow** 
1. The resource type of the resource that chose in the previous step is automatically selected. Add more resource types if you want to use this rule to collect metrics from multiple resource types in the future.
1. Select **Next Destinations** to move to the **Destinations** tab.
   :::image type="content" source="./media/metrics-export-create/create-data-collection-rule-metrics-data-source.png" lightbox="./media/metrics-export-create/create-data-collection-rule-metrics-data-source.png" alt-text="A screenshot showing the collect and deliver tab of the create data collection rule page."::: 

1. To send metrics to a Log Analytics workspace, select *Azure Monitor Logs* from the **Destination type** dropdown. 
    1. Select the **Subscription** and the Log Analytics workspace you want to send the metrics to.
1. To send metrics to Event Hubs, select *Event Hub* from the **Destination type** dropdown.  
    1. Select the **Subscription**, the **Event Hub namespace**, and the **Event Hub instance name**.
1. To send metrics to a Storage Account, select *Storage Account* from the **Destination type** dropdown. 
    1. Select the **Subscription**, the **Storage Account**, and the **Blob container** where you want to store the metrics.  
    > [!NOTE]
    > To sent metrics to a Storage Account or Event Hubs, the resource generating the metrics, the DCR, and the Storage Account or Event Hub, must all be in the same region.  
    > To send metrics to a Log Analytics workspace, the DCR must be in the same region as the Log Analytics workspace. The resource generating the metrics can be in any region.
 
    To select Storage Account or Event Hubs as the destination, you must enable managed identity for the DCR on the Basics tab.

1. Select **Save** , then select **Review + create**. 
   :::image type="content" source="./media/metrics-export-create/create-data-collection-rule-metrics-data-destination.png" lightbox="./media/metrics-export-create/create-data-collection-rule-metrics-data-destination.png" alt-text="A screenshot showing the destination tab of collect and deliver page."::: 

### [CLI](#tab/CLI)

 Create a JSON file containing the collection rule specification. For more information, see [DCR specifications](./data-collection-metrics.md#dcr-specifications). For sample JSON files, see [Sample Metrics Export JSON objects](./data-collection-metrics.md#sample-metrics-export-json-objects).

> [!IMPORTANT] 
> The rule file has the same format as used for PowerShell and the REST API, however the file must not contain `identity`, the `location`, or `kind`.  These parameters are specified in the `az monitor data-collection rule create` command.

Use the following command to create a data collection rule for metrics using the Azure CLI.

```azurecli
az monitor data-collection rule create 
        --name 
        --resource-group 
        --location
        --kind PlatformTelemetry 
        --rule-file
        [--identity "{type:'SystemAssigned'}" ]
```
For storage account and Event Hubs destinations, you must enable managed identity for the DCR using `--identity "{type:'SystemAssigned'}"`. Identity isn't required for Log Analytics workspaces.

For example,
```azurecli
 az monitor data-collection rule create
    --name cli-dcr-001 
    --resource-group rg-001 
    --location centralus 
    --kind PlatformTelemetry 
    --identity "{type:'SystemAssigned'}" 
    --rule-file cli-dcr.json
```

Copy the `id` and the `principalId` of the DCR to use in assigning the role to create an association between the DCR and a resource.

```json
  "id": "/subscriptions/bbbb1b1b-cc2c-dd3d-ee4e-ffffff5f5f5f/resourceGroups/rg-001/providers/Microsoft.Insights/dataCollectionRules/cli-dcr-001",
  "identity": {
    "principalId": "eeeeeeee-ffff-aaaa-5555-666666666666",
    "tenantId": "aaaabbbb-0000-cccc-1111-dddd2222eeee",
    "type": "systemAssigned"
  },
```

### Grant write permissions to the managed entity

The managed identity used by the DCR must have write permissions to the destination when the destination is a Storage Account or Event Hubs.
To grant permissions for the rule's managed entity, assign the appropriate role to the entity. 

The following table shows the roles required for each destination type:

| Destination type | Role |
|---|---|
| Log Analytics workspace | not required |
| Azure storage account | `Storage Blob Data Contributor` |
| Event Hubs | `Azure Event Hubs Data Sender` |

For more information on assigning roles, see [Assign Azure roles to a managed identity](/azure/role-based-access-control/role-assignments-portal-managed-identity). 
To assign a role to a managed identity using CLI, use `az role assignment create`. For more information, see [Role Assignments - Create](/cli/azure/role/assignment)


Assign the appropriate role to the managed identity of the DCR.

```azurecli

az role assignment create --assignee <system assigned principal ID> \
                          --role <`Storage Blob Data Contributor` or `Azure Event Hubs Data Sender`  \
                          --scope <storage account ID or eventhub ID>
```

The following example assigns the `Storage Blob Data Contributor` role to the managed identity of the DCR for a storage account.

```azurecli

az role assignment create --assignee eeeeeeee-ffff-aaaa-5555-666666666666 \
    --role "Storage Blob Data Contributor" \
    --scope /subscriptions/bbbb1b1b-cc2c-DD3D-ee4e-ffffff5f5f5f/resourceGroups/ed-rg-DCRTest/providers/Microsoft.Storage/storageAccounts/metricsexport001
```


## Create a data collection rule association

After you create the data collection rule, create a data collection rule association (DCRA) to associate the rule with the resource to be monitored. For more information, see [Data Collection Rule Associations - Create](/cli/azure/monitor/data-collection/rule/association)

Use `az monitor data-collection rule association create` to create an association between a data collection rule and a resource.

```azurecli
az monitor data-collection rule association create --name 
                                                  --rule-id 
                                                  --resource 
```

The following example creates an association between a data collection rule and a Key Vault.

```azurecli
az monitor data-collection rule association create --name "keyValut-001" \
    --rule-id "/subscriptions/bbbb1b1b-cc2c-DD3D-ee4e-ffffff5f5f5f/resourceGroups/rg-dcr/providers/Microsoft.Insights/dataCollectionRules/dcr-cli-001" \
    --resource "/subscriptions/bbbb1b1b-cc2c-DD3D-ee4e-ffffff5f5f5f/resourceGroups/rg-dcr/providers/Microsoft.KeyVault/vaults/keyVault-001"
```


### [PowerShell](#tab/powershell)

 Create a JSON file containing the collection rule specification. For more information, see [DCR specifications](./data-collection-metrics.md#dcr-specifications). For sample JSON files, see [Sample Metrics Export JSON objects](./data-collection-metrics.md#sample-metrics-export-json-objects).

Use the `New-AzDataCollectionRule` command to create a data collection rule for metrics using PowerShell. For more information, see [New-AzDataCollectionRule](/powershell/module/az.monitor/new-azdatacollectionrule).
 
```powershell
New-AzDataCollectionRule -Name 
                         -ResourceGroupName 
                         -JsonFilePath 
```
For example,
```powershell
 New-AzDataCollectionRule -Name dcr-powershell-hub -ResourceGroupName rg-001 -JsonFilePath dcr-storage-account.json 
```

Copy the `id` and the `IdentityPrincipalId` of the DCR to use in assigning the role to create an association between the DCR and a resource.resource.

```powershell
Id                                        : /subscriptions/bbbb1b1b-cc2c-DD3D-ee4e-ffffff5f5f5f/resourceGroups/rg-001/providers/Microsoft.Insights/dataCollectionRules/dcr-powershell-hub
IdentityPrincipalId                       : eeeeeeee-ffff-aaaa-5555-666666666666
IdentityTenantId                          : 0000aaaa-11bb-cccc-dd22-eeeeee333333
IdentityType                              : systemAssigned
IdentityUserAssignedIdentity              : {
                                            }
```

### Grant write permissions to the managed entity

The managed identity used by the DCR must have write permissions to the destination when the destination is a Storage Account or Event Hubs.
To grant permissions for the rule's managed entity, assign the appropriate role to the entity. 

The following table shows the roles required for each destination type:

| Destination type | Role |
|---|---|
| Log Analytics workspace | not required |
| Azure storage account | `Storage Blob Data Contributor` |
| Event Hubs | `Azure Event Hubs Data Sender` |

For more information, see [Assign Azure roles to a managed identity](/azure/role-based-access-control/role-assignments-portal-managed-identity). 
To assign a role to a managed identity using PowerShell, see [New-AzRoleAssignment](/powershell/module/az.resources/new-azroleassignment)


Assign the appropriate role to the managed identity of the DCR using `New-AzRoleAssignment`.
  
```powershell
New-AzRoleAssignment -ObjectId <objectId> -RoleDefinitionName <roleName> -Scope /subscriptions/<subscriptionId>/resourcegroups/<resourceGroupName>/providers/<providerName>/<resourceType>/<resourceSubType>/<resourceName>
```

The following example assigns the `Azure Event Hubs Data Sender` role to the managed identity of the DCR at the subscription level.

```powershell
New-AzRoleAssignment -ObjectId eeeeeeee-ffff-aaaa-5555-666666666666 -RoleDefinitionName "Azure Event Hubs Data Sender" -Scope /subscriptions/bbbb1b1b-cc2c-DD3D-ee4e-ffffff5f5f5f
```

## Create a data collection rule association

After you create the data collection rule, create a data collection rule association (DCRA) to associate the rule with the resource to be monitored. Use `New-AzDataCollectionRuleAssociation` to create an association between a data collection rule and a resource. For more information, see [New-AzDataCollectionRuleAssociation](/powershell/module/az.monitor/new-azdatacollectionruleassociation)


```powershell
New-AzDataCollectionRuleAssociation
   -AssociationName <String>
   -ResourceUri <String>
   -DataCollectionRuleId <String>
```

The following example creates an association between a data collection rule and a Key Vault.

```powershell
New-AzDataCollectionRuleAssociation 
        -AssociationName keyVault-001-association
        -ResourceUri /subscriptions/bbbb1b1b-cc2c-DD3D-ee4e-ffffff5f5f5f/resourceGroups/rg-dcr/providers/Microsoft.KeyVault/vaults/keyVault-001 
        -DataCollectionRuleId /subscriptions/bbbb1b1b-cc2c-DD3D-ee4e-ffffff5f5f5f/resourceGroups/rg-dcr/providers/Microsoft.Insights/dataCollectionRules/vaultsDCR001
```

### [API](#tab/api)

## Create a data collection rule using the REST API

Creating a data collection rule for metrics requires the following steps:

1. Create the data collection rule.
1. Grant permissions for the rule's managed entity to write to the destination 
1. Create a data collection rule association.

### Create the data collection rule

To create a DCR using the REST API, you must make an authenticated request using a bearer token.  For more information on authenticating with Azure Monitor, see [Authenticate Azure Monitor requests](/azure/azure-monitor/essentials/rest-api-walkthrough?tabs=portal#authenticate-azure-monitor-requests).

Use the following endpoint to create a data collection rule for metrics using the REST API.
For more information, see [Data Collection Rules - Create](/rest/api/monitor/data-collection-rules/create).

```http
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/dataCollectionRules/{dataCollectionRuleName}?api-version=2023-03-11
```

For example
``` http
https://management.azure.com/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/rg-001/providers/Microsoft.Insights/dataCollectionRules/dcr-001?api-version=2023-03-11
```

The payload is a JSON object that defines a collection rule. The payload is sent in the body of the request. For more information on the JSON structure, see [DCR specifications](./data-collection-metrics.md#dcr-specifications). For sample DCR JSON objects, see [Sample Metrics Export JSON objects](./data-collection-metrics.md#sample-metrics-export-json-objects)


### Grant write permissions to the managed entity

The managed identity used by the DCR must have write permissions to the destination when the destination is a Storage Account or Event Hubs.
To grant permissions for the rule's managed entity, assign the appropriate role to the entity. 

The following table shows the roles required for each destination type:

| Destination type | Role |
|---|---|
| Log Analytics workspace | not required |
| Azure storage account | `Storage Blob Data Contributor` |
| Event Hubs | `Azure Event Hubs Data Sender` |

For more information, see [Assign Azure roles to a managed identity](/azure/role-based-access-control/role-assignments-portal-managed-identity). 
To assign a role to a managed identity using REST, see [Role Assignments - Create](/rest/api/authorization/role-assignments/create)


## Create a data collection rule association

After you create the data collection rule, create a data collection rule association (DCRA) to associate the rule with the resource to be monitored. For more information, see [Data Collection Rule Associations - Create](/rest/api/monitor/data-collection-rule-associations/create)

To create a DCRA using the REST API, use the following endpoint and payload:

```HTTP
PUT https://management.azure.com/{resourceUri}/providers/Microsoft.Insights/dataCollectionRuleAssociations/{associationName}?api-version=2022-06-0
```
Body:
```JSON
{ 
        "properties":  
        { 
          "description": "<DCRA description>", 
          "dataCollectionRuleId": "/subscriptions/{subscriptionId}/resourceGroups/{resource group name}/providers/Microsoft.Insights/dataCollectionRules/{DCR name}" 
        } 
}
```


For example,

```HTTP
https://management.azure.com//subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/rg-001/providers/Microsoft.Compute/virtualMachines/vm002/providers/Microsoft.Insights/dataCollectionRuleAssociations/dcr-la-ws-vm002?api-version=2023-03-11

{ 
        "properties":  
        { 
          "description": "Association of platform telemetry DCR with VM vm002", 
          "dataCollectionRuleId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/rg-001/providers/Microsoft.Insights/dataCollectionRules/dcr-la-ws" 
        } 
} 

```
### [ARM template](#tab/arm)


Use the following template to create a DCR. For more information, see [Microsoft.Insights dataCollectionRules](/azure/templates/microsoft.insights/datacollectionrules?pivots=deployment-language-arm-template#datacollectionruleresourceidentity-1)

### Template file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "dataCollectionRuleName": {
            "type": "string",
            "metadata": {
                "description": "Specifies the name of the Data Collection Rule to create."
            }
        },
        "location": {
            "type": "string",
            "metadata": {
                "description": "Specifies the location in which to create the Data Collection Rule."
            }
        }
    },
    "resources": [
        {
            "type": "Microsoft.Insights/dataCollectionRules",
            "name": "[parameters('dataCollectionRuleName')]",
            "kind": "PlatformTelemetry",
              "identity": {
                 "type": "userassigned" | "systemAssigned", 
                 "userAssignedIdentities": { 
		        			 "type": "string"
                   }    
                 },
            "location": "[parameters('location')]",
            "apiVersion": "2023-03-11",
            "properties": {
                "dataSources": {
                    "platformTelemetry": [
                        {
                            "streams": [
                                 "<resourcetype>:<metric name> | Metrics-Group-All"
                            ],
                            "name": "myPlatformTelemetryDataSource"
                        }
                    ]
                },
                "destinations": {
                    "logAnalytics": [
                        {
                            "workspaceResourceId": "[parameters('workspaceId')]",
                            "name": "myDestination"
                        }
                    ]
                },
                "dataFlows": [
                    {
                        "streams": [
                            "<resourcetype>:<metric name> | Metrics-Group-All"
                        ],
                        "destinations": [
                            "myDestination"
                        ]
                    }
                ]
            }
        }
    ]
}
```

### Parameters file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "dataCollectionRuleName": {
            "value": "metrics-dcr-001"
        },
        "workspaceId": {
            "value": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/azuremonitorworkspaceinsights/providers/microsoft.operationalinsights/workspaces/amw-insight-ws"
        },
        "location": {
            "value": "eastus"
        }    
    }
}

```

### Sample DCR template:

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "resources": [
        {
            "type": "Microsoft.Insights/dataCollectionRules",
            "apiVersion": "2023-03-11",
            "name": "[parameters('dataCollectionRuleName')]",
            "location": "[parameters('location')]",
            "kind": "PlatformTelemetry",
            "identity": {
                "type": "SystemAssigned"
            },
            "properties": {
                "dataSources": {
                    "platformTelemetry": [
                        {
                            "streams": [
                                "Microsoft.Compute/virtualMachines:Metrics-Group-All",
                                "Microsoft.Compute/virtualMachineScaleSets:Metrics-Group-All",
                                "Microsoft.Cache/redis:Metrics-Group-All",
                                "Microsoft.keyvault/vaults:Metrics-Group-All"
                            ],
                            "name": "myPlatformTelemetryDataSource"
                        }
                    ]
                },
                "destinations": {
                    "logAnalytics": [
                        {
                            "workspaceResourceId": "[parameters('workspaceId')]",
                            "name": "myDestination"
                        }
                    ]
                },
                "dataFlows": [
                    {
                        "streams": [
                            "Microsoft.Compute/virtualMachines:Metrics-Group-All",
                            "Microsoft.Compute/virtualMachineScaleSets:Metrics-Group-All",
                            "Microsoft.Cache/redis:Metrics-Group-All",
                            "Microsoft.keyvault/vaults:Metrics-Group-All"
                        ],
                        "destinations": [
                            "myDestination"
                        ]
                    }
                ]
            }
        }
    ]
}
```

---

After creating the DCR and DCRA, allow up to 30 minutes for the first platform metrics data to appear in the Log Analytics Workspace. Once data starts flowing, the latency for a platform metric time series flowing to a Log Analytics workspace, Storage Account, or Event Hubs is approximately 3 minutes, depending on the resource type. 


[!INCLUDE [data-collection-rule-troubleshoot](../includes/data-collection-rule-troubleshoot.md)]


## Next steps

* [Read about the detailed structure of a data collection rule](data-collection-rule-structure.md)
* [Get details on transformations in a data collection rule](data-collection-transformations.md)
