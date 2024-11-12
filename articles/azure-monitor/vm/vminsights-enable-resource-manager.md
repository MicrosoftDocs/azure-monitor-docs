---
title: Enable VM insights using Resource Manager templates
description: This article describes how you enable VM insights for one or more Azure virtual machines or Virtual Machine Scale Sets by using Azure PowerShell or Azure Resource Manager templates.
ms.topic: conceptual
ms.custom: devx-track-arm-template, devx-track-azurepowershell
author: guywi-ms
ms.author: guywild
ms.date: 10/03/2024
---

# Enable VM insights using ARM templates
This article describes how to enable VM insights for a virtual machine or Virtual Machine Scale Set using ARM templates.

## Supported machines

- Azure virtual machines
- Azure Virtual Machine Scale Sets
- Hybrid virtual machines connected with [Azure Arc](/azure/azure-arc/overview)

## Prerequisites

- See [Azure Monitor agent supported operating systems and environments](../agents/azure-monitor-agent-supported-operating-systems.md) to verify that your operating system is supported by Azure Monitor agent. 
- See [Dependency Agent requirements](./vminsights-dependency-agent-maintenance.md) to verify that your operating system is supported by Dependency agent.
- See [Manage the Azure Monitor agent](../agents/azure-monitor-agent-manage.md#prerequisites) for prerequisites related to Azure Monitor agent.

## Steps
The steps to install VM insights using ARM templates are as follows. Each of these steps in described in detail in the following sections.

1. [Deploy agents](#deploy-agents). VM insights requires the Azure Monitor agent to be installed on your virtual machines and Dependency agent if you want to enable the Map feature.
1. [Create data collection rule (DCR)](#create-data-collection-rule-dcr). DCR is used to specify what data to collect from the agent and how it should be processed. VM insights uses a specific data source type in the DCR, so you should only create a new DCR using the guidance in this article.
2. [Associate DCR with agents](#associate-dcr-with-agents). Associate the DCR with the Azure Monitor agent to enable VM insights.

## Deploy agents
Install the required agents on your machines using guidance in the following articles. Dependency agent is only required if you want to enable the Map feature.

- [Azure Monitor Agent for Linux or Windows](../agents/resource-manager-agent.md#azure-monitor-agent).
- [Dependency agent for Linux](/azure/virtual-machines/extensions/agent-dependency-linux) or [Dependency agent or Windows](/azure/virtual-machines/extensions/agent-dependency-windows) if you want to enable the Map feature. 
  
> [!NOTE]
> If your virtual machines scale sets have an upgrade policy set to manual, VM insights will not be enabled for instances by default after installing the template. You must manually upgrade the instances.

##  Create data collection rule (DCR)
Create a [data collection rule (DCR)](../essentials/data-collection-rule-overview.md), which specifies what data to collect from the agent and how it should be processed. VM insights uses a specific data source type, so you should only create a new DCR using the templates described in this section.

> [!NOTE]
> Instead of creating a new DCR, you can use one that was already created for VM insights. This could be a DCR created using an ARM template as described here or by [enabling VM insights in the Azure portal](./vminsights-enable-portal.md)

Download the [VM insights data collection rule templates](https://github.com/Azure/AzureMonitorForVMs-ArmTemplates/releases/download/vmi_ama_ga/DeployDcr.zip). The following table describes the templates available:

   | Folder | File | Description |
   |:---|:---|:---|
   | DeployDcr\\<br>PerfAndMapDcr | DeployDcrTemplate<br>DeployDcrParameters | Enable both Performance and Map experience of VM Insights. |
   | DeployDcr\\<br>PerfOnlyDcr | DeployDcrTemplate<br>DeployDcrParameters | Enable only Performance experience of VM Insights. |

- See [Deploy templates](#deploy-templates) if you aren't familiar with methods to deploy ARM templates.
- Deploy the template to the same resource group as your Log Analytics workspace.
- While not required, you should name the DCR `MSVMI-{WorkspaceName}` to match the naming convention used by the Azure portal.

## Associate DCR with agents
The final step in enabling VM insights is to associate the DCR with the Azure Monitor agent. You need to create an association between the DCR and the agent to enable using the following template which comes from [Create and edit data collection rules (DCRs) and associations in Azure Monitor](../essentials/data-collection-rule-create.md#create-a-dcr). To enable on multiple machines, you need to create an association using this template for each one.

- See [Deploy templates](#deploy-templates) if you aren't familiar with methods to deploy ARM templates.

**ARM template**

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "vmName": {
      "type": "string",
      "metadata": {
        "description": "Name of the virtual machine."
      }
    },
    "associationName": {
      "type": "string",
      "metadata": {
        "description": "Name of the association."
      }
    },
    "dataCollectionRuleId": {
      "type": "string",
      "metadata": {
        "description": "Resource ID of the data collection rule."
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
## Deploy templates
The ARM templates described above can be deployed using any method to install an [ARM template](/azure/azure-resource-manager/templates/overview). The following examples show how to deploy the templates using common methods.

### [Portal](#tab/portal)
See  [Quickstart: Create and deploy ARM templates by using the Azure portal](/azure/azure-resource-manager/resource-manager-quickstart-create-templates-use-the-portal) for details on deploying a template from the Azure portal.

### [PowerShell](#tab/powershell)
Use the following command to deploy the template with PowerShell.

```PowerShell
New-AzResourceGroupDeployment -Name EnableVMinsights -ResourceGroupName <ResourceGroupName> -TemplateFile <Template.json> -TemplateParameterFile <Parameters.json>
```

### [CLI](#tab/cli)
Use the following command to deploy the template with Azure CLI.

```sh
az deployment group create --resource-group <ResourceGroupName> --template-file <Template.json> --parameters <Parameters.json>
```
---

## Next steps

- To view discovered application dependencies, see [View VM insights Map](vminsights-maps.md).
- To identify bottlenecks and overall utilization with your VM's performance, see [View Azure VM Performance](vminsights-performance.md).
