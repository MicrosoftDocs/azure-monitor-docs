---
title: Create and edit data collection rules (DCRs) in Azure Monitor
description: Details on creating and editing data collection rules (DCRs) in Azure Monitor.
ms.topic: conceptual
author: bwren
ms.author: bwren
ms.date: 09/15/2024
ms.reviewer: nikeist
ms.custom: references_regions
---

# Create and edit data collection rules (DCRs) and associations in Azure Monitor

There are multiple methods for creating a [data collection rule (DCR)](./data-collection-rule-overview.md) in Azure Monitor. In some cases, Azure Monitor can create and manage the DCR according to settings that you configure in the Azure portal. In other cases, you need to create your own DCRs to customize particular scenarios.

This article describes the different methods for creating and editing a DCR. For the contents of the DCR itself, see [Structure of a data collection rule in Azure Monitor](./data-collection-rule-structure.md).

## Permissions

 You require the following permissions to create DCRs and associations:

| Built-in role | Scopes | Reason |
|:---|:---|:---|
| [Monitoring Contributor](/azure/role-based-access-control/built-in-roles#monitoring-contributor) | <ul><li>Subscription and/or</li><li>Resource group and/or </li><li>An existing DCR</li></ul> | Create or edit DCRs, assign rules to the machine, deploy associations. |
| [Virtual Machine Contributor](/azure/role-based-access-control/built-in-roles#virtual-machine-contributor)<br>[Azure Connected Machine Resource Administrator](/azure/role-based-access-control/built-in-roles#azure-connected-machine-resource-administrator)</li></ul> | <ul><li>Virtual machines, virtual machine scale sets</li><li>Azure Arc-enabled servers</li></ul> | Deploy agent extensions on the VM (virtual machine). |
| Any role that includes the action *Microsoft.Resources/deployments/** | <ul><li>Subscription and/or</li><li>Resource group and/or </li><li>An existing DCR</li></ul> | Deploy Azure Resource Manager templates. |

## Automated methods to create a DCR

The following table lists methods to create data collection scenarios using the Azure portal where the DCR is created for you. In these cases, you don't need to interact directly with the DCR itself.

| Scenario | Resources | Description |
|:---|:---|:---|
| Monitor a virtual machine | [Enable VM Insights overview](../vm/vminsights-enable-overview.md) | When you enable VM Insights on a VM, the Azure Monitor agent is installed and a DCR is created and associated with the VM. This DCR collects a predefined set of performance counters and shouldn't be modified. |
| Container insights | [Enable Container Insights](../containers/kubernetes-monitoring-enable.md#enable-prometheus-and-grafana) | When you enable Container Insights on a Kubernetes cluster, a containerized version of the Azure Monitor agent is installed, and a DCR with association to the cluster is created that collects data according to the configuration you selected. You may need to modify this DCR to add a transformation. |
| Workspace transformation | [Add a transformation in a workspace data collection rule using the Azure portal](../logs/tutorial-workspace-transformations-portal.md) | Create a transformation for any supported table in a Log Analytics workspace. This transformation is specified within a DCR, which is linked to the workspace. The transformation is then applied to any data sent to that table from any legacy workloads that don't yet utilize DCR. |

## Create a DCR

To create a data collection rule using the Azure CLI, PowerShell, API, or ARM templates, create a JSON file, starting with one of the [sample DCRs](./data-collection-rule-samples.md). Use information in [Structure of a data collection rule in Azure Monitor](./data-collection-rule-structure.md) to modify the JSON file for your particular environment and requirements.

> [!IMPORTANT]
> Create your data collection rule in the same region as your destination Log Analytics workspace or Azure Monitor workspace. You can associate the data collection rule to machines or containers from any subscription or resource group in the tenant. To send data across tenants, you must first enable [Azure Lighthouse](/azure/lighthouse/overview).

### [Portal](#tab/portal)

### Create with Azure portal
The Azure portal provides a simplified experience for creating a DCR for virtual machines and virtual machine scale sets. Using this method, you don't need to understand the structure of a DCR unless you want to implement an advanced feature such as a transformation. The process for creating this DCR with various data sources is described in [Collect data with Azure Monitor Agent](../agents/azure-monitor-agent-data-collection.md).


> [!IMPORTANT]
> Create your data collection rule in the same region as your destination Log Analytics workspace or Azure Monitor workspace. You can associate the data collection rule to machines or containers from any subscription or resource group in the tenant. To send data across tenants, you must first enable [Azure Lighthouse](/azure/lighthouse/overview).


On the **Monitor** menu in the Azure portal, select **Data Collection Rules** > **Create** to open the DCR creation page.

:::image type="content" source="media/data-collection-rule-create-edit/create-data-collection-rule.png" lightbox="media/data-collection-rule-create-edit/create-data-collection-rule.png" alt-text="Screenshot that shows Create button for a new data collection rule.":::

The **Basic** page includes basic information about the DCR.

:::image type="content" source="media/data-collection-rule-create-edit/basics-tab.png" lightbox="media/data-collection-rule-create-edit/basics-tab.png" alt-text="Screenshot that shows the Basic tab for a new data collection rule.":::

| Setting | Description |
|:---|:---|
| Rule Name | Name for the DCR. The name should be something descriptive that helps you identify the rule. |
| Subscription | Subscription to store the DCR. The subscription doesn't need to be the same subscription as the virtual machines. |
| Resource group | Resource group to store the DCR. The resource group doesn't need to be the same resource group as the virtual machines. |
| Region | Region to store the DCR. The region must be the same region as any Log Analytics workspace or Azure Monitor workspace used in a destination of the DCR. If you have workspaces in different regions, then create multiple DCRs associated with the same set of machines. |
| Platform Type | Specifies the type of data sources that will be available for the DCR, either **Windows** or **Linux**. **None** allows for both. <sup>1</sup> |
| Data Collection Endpoint | Specifies the data collection endpoint (DCE) used to collect data. The DCE is only required if you're using Azure Monitor Private Links. This DCE must be in the same region as the DCR. For more information, see [How to set up data collection endpoints based on your deployment](../essentials/data-collection-endpoint-overview.md). |

<sup>1</sup> This option sets the `kind` attribute in the DCR. There are other values that can be set for this attribute, but they aren't available in the portal.


## Add resources
The **Resources** page allows you to add resources to be associated with the DCR. Select **+ Add resources** to select resources. The Azure Monitor agent will automatically be installed on any resources that don't already have it.

> [!IMPORTANT] 
> The portal enables system-assigned managed identity on the target resources, along with existing user-assigned identities, if there are any. For existing applications, unless you specify the user-assigned identity in the request, the machine defaults to using system-assigned identity instead.


:::image type="content" source="media/data-collection-rule-create-edit/resources-tab.png" lightbox="media/data-collection-rule-create-edit/resources-tab.png" alt-text="Screenshot that shows the Resources tab for a new data collection rule.":::

 If the machine you're monitoring isn't in the same region as your destination Log Analytics workspace and you're collecting data types that require a DCE, select **Enable Data Collection Endpoints** and select an endpoint in the region of each monitored machine. If the monitored machine is in the same region as your destination Log Analytics workspace, or if you don't require a DCE, don't select a data collection endpoint on the **Resources** tab.
 

## Add data sources
The **Collect and deliver** page allows you to add and configure data sources for the DCR and a destination for each.

| Screen element | Description |
|:---|:---|
| **Data source** | Select a **Data source type** and define related fields based on the data source type you select. See the articles in [Data sources](/azure/azure-monitor/agents/azure-monitor-agent-data-collection#data-sources) for details on configuring each type of data source. |
| **Destination** | Add one or more destinations for each data source. You can select multiple destinations of the same or different types. For instance, you can select multiple Log Analytics workspaces, which is also known as multihoming. See the details for each data type for the different destinations they support. |

A DCR can contain multiple different data sources up to a limit of 10 data sources in a single DCR. You can combine different data sources in the same DCR, but you will typically want to create different DCRs for different data collection scenarios. See [Best practices for data collection rule creation and management in Azure Monitor](../essentials/data-collection-rule-best-practices.md) for recommendations on how to organize your DCRs.

> [!NOTE]
> It can take up to 5 minutes for data to be sent to the destinations when you create a data collection rule using the data collection rule wizard.



### [CLI](#tab/CLI)

### Create with CLI
Use the [az monitor data-collection rule create](/cli/azure/monitor/data-collection/rule) command to create a DCR from your JSON file.

```azurecli
az monitor data-collection rule create --location 'eastus' --resource-group 'my-resource-group' --name 'my-dcr' --rule-file 'C:\MyNewDCR.json' --description 'This is my new DCR'
```

Use the [az monitor data-collection rule association create](/cli/azure/monitor/data-collection/rule/association) command to create an association between your DCR and resource.

```azurecli
az monitor data-collection rule association create --name "my-vm-dcr-association" --rule-id "/subscriptions/ffffffff-eeee-dddd-cccc-bbbbbbbbbbb0/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionRules/my-dcr" --resource "subscriptions/ffffffff-eeee-dddd-cccc-bbbbbbbbbbb0/resourceGroups/my-resource-group/providers/Microsoft.Compute/virtualMachines/my-vm"
```

### [PowerShell](#tab/powershell)

### Create with PowerShell
Use the [New-AzDataCollectionRule](/powershell/module/az.monitor/new-azdatacollectionrule) cmdlet to create a DCR from your JSON file.

```powershell
New-AzDataCollectionRule -Name 'my-dcr' -ResourceGroupName 'my-resource-group' -JsonFilePath 'C:\MyNewDCR.json'
```

Use the [New-AzDataCollectionRuleAssociation](/powershell/module/az.monitor/new-azdatacollectionruleassociation) command to create an association between your DCR and resource.

```powershell
 New-AzDataCollectionRuleAssociation -TargetResourceId '/subscriptions/ffffffff-eeee-dddd-cccc-bbbbbbbbbbb0/resourceGroups/my-resource-group/providers/Microsoft.Compute/virtualMachines/my-vm' -DataCollectionRuleId '/subscriptions/ffffffff-eeee-dddd-cccc-bbbbbbbbbbb0/resourcegroups/my-resource-group/providers/microsoft.insights/datacollectionrules/my-dcr' -AssociationName 'my-vm-dcr-association'
```



### [API](#tab/api)

### Create with API
Use the [DCR create API](/rest/api/monitor/data-collection-rules/create) to create the DCR from your JSON file. You can use any method to call a REST API as shown in the following examples.

```powershell
$ResourceId = "/subscriptions/ffffffff-eeee-dddd-cccc-bbbbbbbbbbb0/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionRules/my-dcr"
$FilePath = ".\my-dcr.json"
$DCRContent = Get-Content $FilePath -Raw 
Invoke-AzRestMethod -Path ("$ResourceId"+"?api-version=2022-06-01") -Method PUT -Payload $DCRContent
```

```azurecli
ResourceId="/subscriptions/ffffffff-eeee-dddd-cccc-bbbbbbbbbbb0/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionRules/my-dcr"
FilePath="my-dcr.json"
az rest --method put --url $ResourceId"?api-version=2022-06-01" --body @$FilePath
```

### [ARM template](#tab/arm)


### Create with ARM template
See the following references for defining DCRs and associations in a template.
* [Data collection rules](/azure/templates/microsoft.insights/datacollectionrules)
* [Data collection rule associations](/azure/templates/microsoft.insights/datacollectionruleassociations)

#### DCR

Use the following template to create a DCR using information from [Structure of a data collection rule in Azure Monitor](./data-collection-rule-structure.md) and [Sample data collection rules (DCRs) in Azure Monitor](./data-collection-rule-samples.md) to define the `dcr-properties`.

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
            "location": "[parameters('location')]",
            "apiVersion": "2021-09-01-preview",
            "properties": {
                "<dcr-properties>"
            }
        }
    ]
}

```


#### DCR Association -Azure VM
The following sample creates an association between an Azure virtual machine and a data collection rule.

**Bicep template file**

```bicep
@description('The name of the virtual machine.')
param vmName string

@description('The name of the association.')
param associationName string

@description('The resource ID of the data collection rule.')
param dataCollectionRuleId string

resource vm 'Microsoft.Compute/virtualMachines@2021-11-01' existing = {
  name: vmName
}

resource association 'Microsoft.Insights/dataCollectionRuleAssociations@2021-09-01-preview' = {
  name: associationName
  scope: vm
  properties: {
    description: 'Association of data collection rule. Deleting this association will break the data collection for this virtual machine.'
    dataCollectionRuleId: dataCollectionRuleId
  }
}
```

**ARM template file**

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "vmName": {
      "type": "string",
      "metadata": {
        "description": "The name of the virtual machine."
      }
    },
    "associationName": {
      "type": "string",
      "metadata": {
        "description": "The name of the association."
      }
    },
    "dataCollectionRuleId": {
      "type": "string",
      "metadata": {
        "description": "The resource ID of the data collection rule."
      }
    }
  },
  "resources": [
    {
      "type": "Microsoft.Insights/dataCollectionRuleAssociations",
      "apiVersion": "2021-09-01-preview",
      "scope": "[format('Microsoft.Compute/virtualMachines/{0}', parameters('vmName'))]",
      "name": "[parameters('associationName')]",
      "properties": {
        "description": "Association of data collection rule. Deleting this association will break the data collection for this virtual machine.",
        "dataCollectionRuleId": "[parameters('dataCollectionRuleId')]"
      }
    }
  ]
}
```

**Parameter file**

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "vmName": {
      "value": "my-azure-vm"
    },
    "associationName": {
      "value": "my-windows-vm-my-dcr"
    },
    "dataCollectionRuleId": {
      "value": "/subscriptions/ffffffff-eeee-dddd-cccc-bbbbbbbbbbb0/resourcegroups/my-resource-group/providers/microsoft.insights/datacollectionrules/my-dcr"
    }
   }
}
```
### DCR Association -Arc-enabled server
The following sample creates an association between an Azure Arc-enabled server and a data collection rule.

**Bicep template file**

```bicep
@description('The name of the virtual machine.')
param vmName string

@description('The name of the association.')
param associationName string

@description('The resource ID of the data collection rule.')
param dataCollectionRuleId string

resource vm 'Microsoft.HybridCompute/machines@2021-11-01' existing = {
  name: vmName
}

resource association 'Microsoft.Insights/dataCollectionRuleAssociations@2021-09-01-preview' = {
  name: associationName
  scope: vm
  properties: {
    description: 'Association of data collection rule. Deleting this association will break the data collection for this Arc server.'
    dataCollectionRuleId: dataCollectionRuleId
  }
}
```

**ARM template file**

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "vmName": {
      "type": "string",
      "metadata": {
        "description": "The name of the virtual machine."
      }
    },
    "associationName": {
      "type": "string",
      "metadata": {
        "description": "The name of the association."
      }
    },
    "dataCollectionRuleId": {
      "type": "string",
      "metadata": {
        "description": "The resource ID of the data collection rule."
      }
    }
  },
  "resources": [
    {
      "type": "Microsoft.Insights/dataCollectionRuleAssociations",
      "apiVersion": "2021-09-01-preview",
      "scope": "[format('Microsoft.HybridCompute/machines/{0}', parameters('vmName'))]",
      "name": "[parameters('associationName')]",
      "properties": {
        "description": "Association of data collection rule. Deleting this association will break the data collection for this Arc server.",
        "dataCollectionRuleId": "[parameters('dataCollectionRuleId')]"
      }
    }
  ]
}
```

**Parameter file**

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "vmName": {
      "value": "my-hybrid-vm"
    },
    "associationName": {
      "value": "my-windows-vm-my-dcr"
    },
    "dataCollectionRuleId": {
      "value": "/subscriptions/ffffffff-eeee-dddd-cccc-bbbbbbbbbbb0/resourcegroups/my-resource-group/providers/microsoft.insights/datacollectionrules/my-dcr"
    }
   }
}
```

---

## Edit a DCR

To edit a DCR, you can use any of the methods described in the previous section to create a DCR using a modified version of the JSON.

If you need to retrieve the JSON for an existing DCR, you can copy it from the **JSON View** for the DCR in the Azure portal. You can also retrieve it using an API call as shown in the following PowerShell example.

```powershell
$ResourceId = "<ResourceId>" # Resource ID of the DCR to edit
$FilePath = "<FilePath>" # Store DCR content in this file
$DCR = Invoke-AzRestMethod -Path ("$ResourceId"+"?api-version=2022-06-01") -Method GET
$DCR.Content | ConvertFrom-Json | ConvertTo-Json -Depth 20 | Out-File -FilePath $FilePath
```

For a tutorial that walks through the process of retrieving and then editing an existing DCR, see [Tutorial: Edit a data collection rule (DCR)](./data-collection-rule-edit.md).


## Create a DCR for metrics export 

To create a data collection rule for metrics export use the Azure portal, Azure CLI, PowerShell, API, or ARM templates.

> [!IMPORTANT]  
> To send Platform Telemetry data to Storage Accounts or Event Hubs, the resource, data collection rule, and the destination Storage Account or the Event Hubs must all be in the same region.


### [Portal](#tab/portal)

1. On the Monitor menu in the Azure portal, select **Data Collection Rules** then select **Create**.

1. To create a DCR to collect platform metrics data, select the link on the top of the page.
    :::image type="content" source="./media/data-collection-rule-create-edit/create-data-collection-rule-metrics.png" lightbox="./media/data-collection-rule-create-edit/create-data-collection-rule-metrics.png" alt-text="A screenshot showing the create data collection rule page.":::
1. On the **Create Data Collection Rule** page, enter a rule name, select a **Subscription**, **Resource group**, and **Region** for the DCR.
1. Select **Enable Managed Identity** if you want to send metrics to a Storage Account or Event Hubs. 
1. Select **Next**
   :::image type="content" source="./media/data-collection-rule-create-edit/create-data-collection-rule-metrics-basics.png" lightbox="./media/data-collection-rule-create-edit/create-data-collection-rule-metrics-basics.png" alt-text="A screenshot showing the basics tab of the create data collection rule page.":::
1. On the **Resources** page, select **Add resources**  to add the resources you want to collect metrics from. 
1. Select **Next** to move to the **Collect and deliver** tab.
   :::image type="content" source="./media/data-collection-rule-create-edit/create-data-collection-rule-metrics-resources.png" lightbox="./media/data-collection-rule-create-edit/create-data-collection-rule-metrics-resources.png" alt-text="A screenshot showing the resources tab of the create data collection rule page.":::
1. Select **Add new dataflow** 
1. The resource type of the resource that chose in the previous step is automatically selected. Add more resource types if you want to use this rule to collect metrics from multiple resource types in the future.
1. Select **Next Destinations** to move to the **Destinations** tab.
   :::image type="content" source="./media/data-collection-rule-create-edit/create-data-collection-rule-metrics-data-source.png" lightbox="./media/data-collection-rule-create-edit/create-data-collection-rule-metrics-data-source.png" alt-text="A screenshot showing the collect and deliver tab of the create data collection rule page."::: 

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
   :::image type="content" source="./media/data-collection-rule-create-edit/create-data-collection-rule-metrics-data-destination.png" lightbox="./media/data-collection-rule-create-edit/create-data-collection-rule-metrics-data-destination.png" alt-text="A screenshot showing the destination tab of collect and deliver page."::: 

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
New-AzRoleAssignment -ObjectId ffffffff-eeee-dddd-cccc-bbbbbbbbbbb0 -RoleDefinitionName "Azure Event Hubs Data Sender" -Scope /subscriptions/bbbb1b1b-cc2c-DD3D-ee4e-ffffff5f5f5f
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


## Verify data flows and troubleshooting

DCR metrics are collected automatically for all DCRs, and you can analyze them using metrics explorer like the platform metrics for other Azure resources. For more information, see [Monitor and troubleshoot DCR data collection in Azure Monitor](./data-collection-monitor.md#dcr-metrics)

Metrics sent to a Log Analytics workspace, are stored in the `AzureMetricsV2` table. Use the Log Analytics explorer to view the table and confirm that data is being ingested.
For more information, see [Overview of Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview).




## Next steps

* [Read about the detailed structure of a data collection rule](data-collection-rule-structure.md)
* [Get details on transformations in a data collection rule](data-collection-transformations.md)
