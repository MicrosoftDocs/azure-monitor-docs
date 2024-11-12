---
title: Create data collection rules (DCRs) in Azure Monitor
description: Details on creating data collection rules (DCRs) in Azure Monitor.
ms.topic: conceptual
author: bwren
ms.author: bwren
ms.date: 09/15/2024
ms.reviewer: nikeist
ms.custom: references_regions
---

# Create data collection rules (DCRs) and associations in Azure Monitor

There are multiple methods for creating a [data collection rule (DCR)](./data-collection-rule-overview.md) in Azure Monitor. In some cases, Azure Monitor can create and manage the DCR according to settings that you configure in the Azure portal. In other cases, you need to create your own DCRs to customize particular scenarios.

This article describes the different methods for creating a DCR. For the contents of the DCR itself, see [Structure of a data collection rule in Azure Monitor](./data-collection-rule-structure.md).

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

:::image type="content" source="media/data-collection-rule-create/create-data-collection-rule.png" lightbox="media/data-collection-rule-create/create-data-collection-rule.png" alt-text="Screenshot that shows Create button for a new data collection rule.":::

The **Basic** page includes basic information about the DCR.

:::image type="content" source="media/data-collection-rule-create/basics-tab.png" lightbox="media/data-collection-rule-create/basics-tab.png" alt-text="Screenshot that shows the Basic tab for a new data collection rule.":::

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


:::image type="content" source="media/data-collection-rule-create/resources-tab.png" lightbox="media/data-collection-rule-create/resources-tab.png" alt-text="Screenshot that shows the Resources tab for a new data collection rule.":::

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
az monitor data-collection rule association create --name "my-vm-dcr-association" --rule-id "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionRules/my-dcr" --resource "subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Compute/virtualMachines/my-vm"
```

### [PowerShell](#tab/powershell)

### Create with PowerShell
Use the [New-AzDataCollectionRule](/powershell/module/az.monitor/new-azdatacollectionrule) cmdlet to create a DCR from your JSON file.

```powershell
New-AzDataCollectionRule -Name 'my-dcr' -ResourceGroupName 'my-resource-group' -JsonFilePath 'C:\MyNewDCR.json'
```

Use the [New-AzDataCollectionRuleAssociation](/powershell/module/az.monitor/new-azdatacollectionruleassociation) command to create an association between your DCR and resource.

```powershell
 New-AzDataCollectionRuleAssociation -TargetResourceId '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Compute/virtualMachines/my-vm' -DataCollectionRuleId '/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/my-resource-group/providers/microsoft.insights/datacollectionrules/my-dcr' -AssociationName 'my-vm-dcr-association'
```



### [API](#tab/api)

### Create with API
Use the [DCR create API](/rest/api/monitor/data-collection-rules/create) to create the DCR from your JSON file. You can use any method to call a REST API as shown in the following examples.

```powershell
$ResourceId = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionRules/my-dcr"
$FilePath = ".\my-dcr.json"
$DCRContent = Get-Content $FilePath -Raw 
Invoke-AzRestMethod -Path ("$ResourceId"+"?api-version=2022-06-01") -Method PUT -Payload $DCRContent
```

```azurecli
ResourceId="/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionRules/my-dcr"
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
      "value": "/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/my-resource-group/providers/microsoft.insights/datacollectionrules/my-dcr"
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
      "value": "/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/my-resource-group/providers/microsoft.insights/datacollectionrules/my-dcr"
    }
   }
}
```

---


## Verify data flows and troubleshooting

DCR metrics are collected automatically for all DCRs, and you can analyze them using metrics explorer like the platform metrics for other Azure resources. For more information, see [Monitor and troubleshoot DCR data collection in Azure Monitor](./data-collection-monitor.md#dcr-metrics)

Metrics sent to a Log Analytics workspace, are stored in the `AzureMetricsV2` table. Use the Log Analytics explorer to view the table and confirm that data is being ingested.
For more information, see [Overview of Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview).




## Next steps

* [Read about the detailed structure of a data collection rule](data-collection-rule-structure.md)
* [Get details on transformations in a data collection rule](data-collection-transformations.md)
