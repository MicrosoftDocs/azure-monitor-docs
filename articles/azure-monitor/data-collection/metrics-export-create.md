---
title: Metrics export using data collection rules (Preview)
description: Learn how to create data collection rules for metrics.
ms.topic: concept-article
ms.date: 01/20/2026
ms.custom: references_regions
---

# Metrics export using data collection rules (Preview)

Platform metrics measure the performance of different aspects of your Azure resources. [Diagnostic settings](../platform/diagnostic-settings.md) are used to collect and export platform metrics from all Azure resources that support them. [Data collection rules (DCRs)](./data-collection-rule-overview.md) can also be used to collect and export platform metrics from [supported Azure resources](#supported-resources-and-regions). This article describes how to use DCRs to export metrics.

> [!NOTE]
> While you can use DCRs and diagnostic settings at the same time, you should disable any diagnostic settings for metrics when using DCRs to avoid duplicate data collection.

Using DCRs to export metrics provides the following advantages over diagnostic settings:

* DCR configuration enables exporting metrics with dimensions.
* DCR configuration enables filtering based on metric name so you can export only the metrics that you need.
* DCRs are more flexible and scalable compared to diagnostic settings.
* End to end latency for DCRs is within 3 minutes, while diagnostic settings export latency is 6-10 minutes.


> [!NOTE]
> Use metrics export with DCRs for continuous export of metrics data as it's created. To query historical data that's already been collected, use the [Data plane Metrics Batch API](/rest/api/monitor/metrics-batch/batch). See [Data plane Metrics Batch API query versus Metrics export](data-plane-versus-metrics-export.md) for a comparison of the two strategies.


## Export destinations

Metrics can be exported to the following destinations.

| Destination type | Details |
|:---|:---|
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

The following resources currently support metrics export using data collection rules:

| Resource type | Stream specification |
|---------------|----------------------|
| Virtual Machine scale sets | Microsoft.compute/virtualmachinescalesets |
| Virtual machines | Microsoft.compute/virtualmachines |
| Redis cache | Microsoft.cache/redis |
| IOT hubs | Microsoft.devices/iothubs |
| Key vaults | Microsoft.keyvault/vaults |
| Storage accounts | Microsoft.storage/storageaccounts<br>Microsoft.storage/Storageaccounts/blobservices<br>Microsoft.storage/storageaccounts/fileservices<br>Microsoft.storage/storageaccounts/queueservices<br>Microsoft.storage/storageaccounts/tableservices |
| SQL Server | Microsoft.sql/servers<br>Microsoft.sql/servers/databases |
|Operational Insights | Microsoft.operationalinsights/workspaces |
| Data protection | Microsoft.dataprotection/backupvaults |
| Azure Kubernetes Service| Microsoft.ContainerService/managedClusters |

### Supported regions

You can create a DCR for metrics export in any region, but the resources that you want to export metrics from must be in one of the following regions:

* Australia East
* Central US
* CentralUsEuap
* South Central US
* East US
* East US 2
* Eastus2Euap
* West US
* West US 2
* North Europe
* West Europe
* UK South

## Create a data collection rule (DCR) for metrics export 

This article describes how to create a [data collection rule (DCR)](data-collection-rule-overview.md) for metrics export using the Azure portal, Azure CLI, PowerShell, API, or ARM templates.

> [!IMPORTANT]
> To send Platform Telemetry data to Storage Accounts or Event Hubs, the resource, data collection rule, and the destination Storage Account or the Event Hubs must all be in the same region.

### [Portal](#tab/portal)

### Create a data collection rule using the Azure portal

1. On the Monitor menu in the Azure portal, select **Data Collection Rules** and then **Create**.

1. Select the link on the top of the page to use the new DCR creation experience.

    :::image type="content" source="media/metrics-export-create/create-data-collection-rule-metrics.png" lightbox="media/metrics-export-create/create-data-collection-rule-metrics.png" alt-text="A screenshot showing the create data collection rule page.":::

1. On the **Create Data Collection Rule** page, enter a rule name, select a **Subscription**, **Resource group**, and **Region** for the DCR.

1. Select *PlatformTelemetry* for the **Type of telemetry** and **Enable Managed Identity** if you want to send metrics to a Storage Account or Event Hubs.

    :::image type="content" source="media/metrics-export-create/create-data-collection-rule-metrics-basics.png" lightbox="media/metrics-export-create/create-data-collection-rule-metrics-basics.png" alt-text="A screenshot showing the basics tab of the create data collection rule page.":::

1. On the **Resources** page, select **Add resources** to add the resources you want to collect metrics from.

1. Select **Next** to move to the **Collect and deliver** tab.

    :::image type="content" source="media/metrics-export-create/create-data-collection-rule-metrics-resources.png" lightbox="media/metrics-export-create/create-data-collection-rule-metrics-resources.png" alt-text="A screenshot showing the resources tab of the create data collection rule page.":::

1. Select **Add new datasource**.

1. The resource type of the resource specified in the previous step is automatically selected. Add more resource types if you want to use this rule to collect metrics from multiple resource types in the future. Select the **Actions** for a resource type if you want to remove some of the metrics collected for it. By default, all available metrics for the resource are collected.

    :::image type="content" source="media/metrics-export-create/create-data-collection-rule-metrics-data-source.png" lightbox="media/metrics-export-create/create-data-collection-rule-metrics-data-source.png" alt-text="A screenshot showing the collect and deliver tab of the create data collection rule page."::: 

1. Select **Next Destinations** to move to the **Destinations** tab.

1. Select **Add destination** and then the **Destination type** that you want to add. The required fields change based on the destination type you select.

    > [!NOTE]
    > To send metrics to a Storage Account or Event Hubs, the resource generating the metrics, the DCR, and the Storage Account or Event Hub, must all be in the same region. To send metrics to a Log Analytics workspace, the DCR must be in the same region as the Log Analytics workspace. The resource generating the metrics can be in any region.

    :::image type="content" source="media/metrics-export-create/create-data-collection-rule-metrics-data-destination.png" lightbox="media/metrics-export-create/create-data-collection-rule-metrics-data-destination.png" alt-text="A screenshot showing the destination tab of collect and deliver page.":::

1. Select **Save** , then select **Review + create**.

### [CLI](#tab/CLI)

### Create a data collection rule using Azure CLI

Create a JSON file containing the collection rule specification. For more information, see [Data collection rule (DCR) structure for metrics export](metrics-export-structure.md). For sample JSON files, see [Sample Metrics Export JSON objects](metrics-export-structure.md#metrics-export-samples).

> [!IMPORTANT] 
> The rule file has the same format as used for PowerShell and the REST API, however the file must not contain `identity`, the `location`, or `kind`. These parameters are specified in the `az monitor data-collection rule create` command.

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

**Example:**

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

The managed identity used by the DCR must have write permissions to the destination when the destination is a Storage Account or Event Hubs. To grant permissions for the rule's managed entity, assign the appropriate role to the entity. 

The following table shows the roles required for each destination type:

| Destination type | Role |
|------------------|------|
| Log Analytics workspace | not required |
| Azure storage account | `Storage Blob Data Contributor` |
| Event Hubs | `Azure Event Hubs Data Sender` |

For more information on assigning roles, see [Assign Azure roles to a managed identity](/azure/role-based-access-control/role-assignments-portal-managed-identity). 
To assign a role to a managed identity using CLI, use `az role assignment create`. For more information, see [Role Assignments - Create](/cli/azure/role/assignment).

Assign the appropriate role to the managed identity of the DCR.

```azurecli
az role assignment create --assignee <system assigned principal ID> \
                          --role <`Storage Blob Data Contributor` or `Azure Event Hubs Data Sender` \
                          --scope <storage account ID or eventhub ID>
```

The following example assigns the `Storage Blob Data Contributor` role to the managed identity of the DCR for a storage account.

```azurecli
az role assignment create --assignee eeeeeeee-ffff-aaaa-5555-666666666666 \
    --role "Storage Blob Data Contributor" \
    --scope /subscriptions/bbbb1b1b-cc2c-DD3D-ee4e-ffffff5f5f5f/resourceGroups/ed-rg-DCRTest/providers/Microsoft.Storage/storageAccounts/metricsexport001
```

## Create a data collection rule association

After you create the data collection rule, create a data collection rule association (DCRA) to associate the rule with the resource to be monitored. For more information, see [Data Collection Rule Associations - Create](/cli/azure/monitor/data-collection/rule/association).

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

### Create a data collection rule using PowerShell

Create a JSON file containing the collection rule specification. For more information, see [Data collection rule (DCR) structure for metrics export](metrics-export-structure.md). For sample JSON files, see [Sample Metrics Export JSON objects](metrics-export-structure.md#metrics-export-samples).

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
|------------------|------|
| Log Analytics workspace | not required |
| Azure storage account | `Storage Blob Data Contributor` |
| Event Hubs | `Azure Event Hubs Data Sender` |

For more information, see [Assign Azure roles to a managed identity](/azure/role-based-access-control/role-assignments-portal-managed-identity). To assign a role to a managed identity using PowerShell, see [New-AzRoleAssignment](/powershell/module/az.resources/new-azroleassignment).

Assign the appropriate role to the managed identity of the DCR using `New-AzRoleAssignment`.

```powershell
New-AzRoleAssignment -ObjectId <objectId> -RoleDefinitionName <roleName> -Scope /subscriptions/<subscriptionId>/resourcegroups/<resourceGroupName>/providers/<providerName>/<resourceType>/<resourceSubType>/<resourceName>
```

The following example assigns the `Azure Event Hubs Data Sender` role to the managed identity of the DCR at the subscription level.

```powershell
New-AzRoleAssignment -ObjectId eeeeeeee-ffff-aaaa-5555-666666666666 -RoleDefinitionName "Azure Event Hubs Data Sender" -Scope /subscriptions/bbbb1b1b-cc2c-DD3D-ee4e-ffffff5f5f5f
```

## Create a data collection rule association

After you create the data collection rule, create a data collection rule association (DCRA) to associate the rule with the resource to be monitored. Use `New-AzDataCollectionRuleAssociation` to create an association between a data collection rule and a resource. For more information, see [New-AzDataCollectionRuleAssociation](/powershell/module/az.monitor/new-azdatacollectionruleassociation).

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

### Create a data collection rule using the REST API

Creating a data collection rule for metrics requires the following steps:

1. Create the data collection rule.
1. Grant permissions for the rule's managed entity to write to the destination 
1. Create a data collection rule association.

### Create the data collection rule

To create a DCR using the REST API, you must make an authenticated request using a bearer token. For more information on authenticating with Azure Monitor, see [Authenticate Azure Monitor requests](/azure/azure-monitor/essentials/rest-api-walkthrough?tabs=portal#authenticate-azure-monitor-requests).

Use the following endpoint to create a data collection rule for metrics using the REST API. For more information, see [Data Collection Rules - Create](/rest/api/monitor/data-collection-rules/create).

```http
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Insights/dataCollectionRules/{dataCollectionRuleName}?api-version=2023-03-11
```

**Example:**

``` http
https://management.azure.com/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/rg-001/providers/Microsoft.Insights/dataCollectionRules/dcr-001?api-version=2023-03-11
```

The payload is a JSON object that defines a collection rule. The payload is sent in the body of the request. For more information on the JSON structure, see [Data collection rule (DCR) structure for metrics export](metrics-export-structure.md). For sample DCR JSON objects, see [Sample Metrics Export JSON objects](metrics-export-structure.md#metrics-export-samples).

### Grant write permissions to the managed entity

The managed identity used by the DCR must have write permissions to the destination when the destination is a Storage Account or Event Hubs.
To grant permissions for the rule's managed entity, assign the appropriate role to the entity. 

The following table shows the roles required for each destination type:

| Destination type | Role |
|------------------|------|
| Log Analytics workspace | not required |
| Azure storage account | `Storage Blob Data Contributor` |
| Event Hubs | `Azure Event Hubs Data Sender` |

For more information, see [Assign Azure roles to a managed identity](/azure/role-based-access-control/role-assignments-portal-managed-identity).

To assign a role to a managed identity using REST, see [Role Assignments - Create](/rest/api/authorization/role-assignments/create).

## Create a data collection rule association

### Create a data collection rule using an ARM template

After you create the data collection rule, create a data collection rule association (DCRA) to associate the rule with the resource to be monitored. For more information, see [Data Collection Rule Associations - Create](/rest/api/monitor/data-collection-rule-associations/create)

To create a DCRA using the REST API, use the following endpoint and payload:

```HTTP
PUT https://management.azure.com/{resourceUri}/providers/Microsoft.Insights/dataCollectionRuleAssociations/{associationName}?api-version=2022-06-0
```

**Body:**

```JSON
{ 
        "properties":
        { 
          "description": "<DCRA description>", 
          "dataCollectionRuleId": "/subscriptions/{subscriptionId}/resourceGroups/{resource group name}/providers/Microsoft.Insights/dataCollectionRules/{DCR name}" 
        } 
}
```

**Example:**

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

### Create a data collection rule using ARM templates


Use the following template to create a DCR. For more information, see [Microsoft.Insights dataCollectionRules](/azure/templates/microsoft.insights/datacollectionrules?pivots=deployment-language-arm-template#datacollectionruleresourceidentity-1).

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

### Sample DCR template

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



After creating the DCR, allow up to 30 minutes for the first platform metrics data to appear in the Log Analytics Workspace. Once data starts flowing, the latency for a platform metric time series flowing to a Log Analytics workspace, Storage Account, or Event Hubs is approximately 3 minutes, depending on the resource type.

## Exported data

The following examples show the data exported to each destination.

### Log analytics workspaces

Data exported to a Log Analytics workspace is stored in the `AzureMetricsV2` table in the Log Analytics workspace in the following format:

[!INCLUDE [Log Analytics data format](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/tables/azuremetricsv2-include.md)]

For example:

:::image type="content" source="media/data-collection-metrics/export-to-workspace.png" lightbox="media/data-collection-metrics/export-to-workspace.png" alt-text="A screenshot of a log analytics query of the AzureMetricsV2 table.":::

### Storage accounts

The following example shows data exported to a storage account:

```JSON
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
