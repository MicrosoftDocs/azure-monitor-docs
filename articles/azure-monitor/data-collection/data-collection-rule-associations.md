---
title: Manage data collection rule associations in Azure Monitor
description: Describes different options for viewing data collection rules (DCRs) and data collection rule associations (DCRA) in Azure Monitor.
ms.topic: how-to
ms.date: 12/02/2024
ms.reviewer: nikeist
---

# Manage data collection rule associations in Azure Monitor

Data collection rule associations (DCRAs) associate DCRs with monitored resources in Azure Monitor as described in [Using a DCR](data-collection-rule-overview.md#using-a-dcr). This article describes different methods for viewing and creating DCRAs and their related resources.

> [!IMPORTANT]
> Not all data collection scenarios with DCRs use DCRAs. See [Using a DCR](data-collection-rule-overview.md#using-a-dcr) for an explanation and comparison of how DCRs are specified in different data collection scenarios.

## View and modify associations for a DCR in the Azure portal

To view your DCRs in the Azure portal, select **Data Collection Rules** under **Settings** on the **Monitor** menu. Select a DCR to view its details.

:::image type="content" source="media/data-collection-rule-overview/view-data-collection-rules.png" lightbox="media/data-collection-rule-overview/view-data-collection-rules.png" alt-text="Screenshot that shows DCRs in the Azure portal.":::

Click the **Resources** tab to view the resources associated with the selected DCR. Click **Add** to add an association to a new resource. You can view and add resources using this feature whether or not you created the DCR in the Azure portal. 

:::image type="content" source="media/data-collection-rule-overview/view-data-collection-rules.png" lightbox="media/data-collection-rule-overview/view-data-collection-rules.png" alt-text="Screenshot that shows DCRs in the Azure portal.":::

> [!NOTE]
> Although this view shows all DCRs in the specified subscriptions, selecting the **Create** button creates a data collection for Azure Monitor Agent. Similarly, this page only allows you to modify DCRs for Azure Monitor Agent. For guidance on how to create and update DCRs for other workflows, see [Create and edit data collection rules (DCRs) in Azure Monitor](data-collection-rule-create-edit.md).

## Preview DCR experience

A preview of the new Azure portal experience for DCRs ties together DCRs and the resources they're associated with. You can either view the list by **Data collection rule**, which shows the number of resources associated with each DCR, or by **Resources**, which shows the count of DCRs associated with each resource.

Select the option on the displayed banner to enable this experience.

:::image type="content" source="media/data-collection-rule-view/preview-experience.png" alt-text="Screenshot of title bar to enable the preview experience for DCRs in the Azure portal." lightbox="media/data-collection-rule-view/preview-experience.png":::

### Data collection rule view

In the **Data collection rule** view, the **Resource count** represents the number of resources that have a [data collection rule association](data-collection-rule-overview.md#data-collection-rule-associations-dcras) with the DCR. Click this value to open the **Resources** view for that DCR.

:::image type="content" source="media/data-collection-rule-view/data-collection-rules-view.png" alt-text="Screenshot of data collection rules view in the preview experience for DCRs in the Azure portal." lightbox="media/data-collection-rule-view/data-collection-rules-view.png":::

### Resources view

The **Resources** view lists all Azure resources that match the selected filter, whether they have a DCR association or not. Tiles at the top of the view list the count of total resources listed, the number of resources not associated with a DCR, and the total number of DCRs matching the selected filter.

:::image type="content" source="media/data-collection-rule-view/resources-view.png" alt-text="Screenshot of resources view in the preview experience for DCRs in the Azure portal." lightbox="media/data-collection-rule-view/resources-view.png":::

**View DCRs for a resource**

The **Data collection rules** column represents the number of DCRs that are associated with each resource. Click this value to open a new pane listing the DCRs associated with the resource. 

:::image type="content" source="media/data-collection-rule-view/resources-view-associations.png" alt-text="Screenshot of the DCR associations for a resource in the resources view in the preview experience for DCRs in the Azure portal." lightbox="media/data-collection-rule-view/resources-view-associations.png":::

> [!IMPORTANT]
> Not all DCRs are associated with resources. For example, DCRs used with the [Logs ingestion API](../logs/logs-ingestion-api-overview.md) are specified in the API call and don't use associations. These DCRs still appear in the view, but have a **Resource Count** of 0.

**Create new DCR or associations with existing DCR**

Using the **Resources** view, you can create a new DCR for the selected resources or associate them with an existing DCR. Select the resources and then click one of the following options.

| Option | Description |
|:-------|:------------|
| Create a data collection rule | Launch the process to create a new DCR for the Azure Monitor agent. The selected resources are automatically added as resources for the new DCR. See [Collect data with Azure Monitor Agent](../vm/data-collection.md) for details on this process. |
| Associate with existing data collection rule | Associate the selected resources with one or more existing DCRs. This opens a list of DCRs that can be associated with the current resource. This list only includes DCRs that are valid for the particular resource. For example, if the resource is a VM with the Azure Monitor agent (AMA) installed, only DCRs that process AMA data are listed. |

:::image type="content" source="media/data-collection-rule-view/resources-view-associate.png" alt-text="Screenshot of the create association button in the resources view in the preview experience for DCRs in the Azure portal." lightbox="media/data-collection-rule-view/resources-view-associate.png":::

## Create new association

In addition to the preview Azure portal experience, you can create a new association using any of the following methods. The DCRA object that's created is a child of the target object and uses the resource ID of the DCR.

> [!NOTE]
> To associate DCRs with a virtual machine scale set with flexible orchestration, use a policy to deploy the agent and associate the DCR with each VM. The policy will install the agent and associate the DCR with VMs as during scale out.

### [CLI](#tab/cli)

### Create association with CLI

Use the [az monitor data-collection rule association create](/cli/azure/monitor/data-collection/rule/association) command to create an association between your DCR and resource.

```azurecli
az monitor data-collection rule association create --name "my-vm-dcr-association" --rule-id "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionRules/my-dcr" --resource "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Compute/virtualMachines/my-vm"
```

### [PowerShell](#tab/powershell)

### Create association with PowerShell

Use the [New-AzDataCollectionRuleAssociation](/powershell/module/az.monitor/new-azdatacollectionruleassociation) command to create an association between your DCR and resource.

```powershell
 New-AzDataCollectionRuleAssociation -TargetResourceId '/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Compute/virtualMachines/my-vm' -DataCollectionRuleId '/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/my-resource-group/providers/microsoft.insights/datacollectionrules/my-dcr' -AssociationName 'my-vm-dcr-association'
```

### [ARM template](#tab/arm)

### Create association with ARM templates

The ARM templates for associations differ for different target objects. Following are templates you can use for different types of objects.

#### Azure VM

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
      "value": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/my-resource-group/providers/microsoft.insights/datacollectionrules/my-dcr"
    }
   }
}
```
### Arc-enabled server

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
      "value": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/my-resource-group/providers/microsoft.insights/datacollectionrules/my-dcr"
    }
   }
}
```

---

## Azure Policy

Using [Azure Policy](/azure/governance/policy/overview), you can associate a DCR with multiple resources at scale. When you create an assignment between a resource group and a built-in policy or initiative, associations are created between the DCR and each resource of the assigned type in the resource group, including any new resources as they're created. Azure Monitor provides a simplified user experience to create an assignment for a policy or initiative for a particular DCR, which is an alternate method to creating the assignment using Azure Policy directly.

> [!NOTE]
> A **policy** in Azure Policy is a single rule or condition that resources in Azure must comply with. For example, there's a built-in policy called **Configure Windows Machines to be associated with a Data Collection Rule or a Data Collection Endpoint**.
> 
> An **initiative** is a collection of policies that are grouped together to achieve a specific goal or purpose. For example, there's an initiative called **Configure Windows machines to run Azure Monitor Agent and associate them to a Data Collection Rule** that includes multiple policies to install and configure the Azure Monitor agent.

From the DCR in the Azure portal, select **Policies (Preview)**. This opens a page that lists any assignments with the current DCR and the compliance state of included resources. Tiles across the top provide compliance metrics for all resources and assignments.

:::image type="content" source="media/data-collection-rule-view/data-collection-rule-policies.png" alt-text="Screenshot of DCR policies view." lightbox="media/data-collection-rule-view/data-collection-rule-policies.png":::

To create a new assignment, click either **Assign Policy** or **Assign Initiative**. 

:::image type="content" source="media/data-collection-rule-view/data-collection-rule-new-policy.png" alt-text="Screenshot of new policy assignment blade." lightbox="media/data-collection-rule-view/data-collection-rule-new-policy.png":::

| Setting | Description |
|:--------|:------------|
| Subscription | The subscription with the resource group to use as the scope. |
| Resource group | The resource group to use as the scope. The DCR gets assigned to all resource in this resource group, depending on the resource group managed by the definition. |
| Policy/Initiative definition | The definition to assign. The dropdown includes all definitions in the subscription that accept DCR as a parameter. |
| Assignment Name | A name for the assignment. Must be unique in the subscription. |
| Description | Optional description of the assignment. |
| Policy Enforcement | The policy is only applied if enforcement is enabled. If disabled, only assessments for the policy are performed. |

Once an assignment is created, you can view its details by clicking on it. This allows you to edit the details of the assignment and also to create a remediation task.

:::image type="content" source="media/data-collection-rule-view/data-collection-rule-assignment-details.png" alt-text="Screenshot of assignment details." lightbox="media/data-collection-rule-view/data-collection-rule-assignment-details.png":::

> [!IMPORTANT]
> The assignment won't be applied to existing resources until you create a remediation task. For more information, see [Remediate noncompliant resources with Azure Policy](/azure/governance/policy/how-to/remediate-resources).

## Next steps

See the following articles for additional information on how to work with DCRs.

* [Data collection rule structure](data-collection-rule-structure.md) for a description of the JSON structure of DCRs and the different elements used for different workflows.
* [Sample data collection rules (DCRs)](data-collection-rule-samples.md) for sample DCRs for different data collection scenarios.
* [Create and edit data collection rules (DCRs) in Azure Monitor](data-collection-rule-create-edit.md) for different methods to create DCRs for different data collection scenarios.
* [Azure Monitor service limits](../fundamentals/service-limits.md#data-collection-rules) for limits that apply to each DCR.
