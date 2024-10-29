---
title: Enable VM Insights
description: Learn how to deploy and configure VM Insights and find out about the system requirements.
ms.topic: conceptual
author: guywi-ms
ms.author: guywild
ms.reviewer: xpathak
ms.date: 10/03/2024
ms.custom: references_regions

---

# Enable VM Insights

This article provides details on enabling VM Insights in Azure Monitor using different methods including the Azure portal, ARM templates, and PowerShell script.

## Prerequisites

- You must have a [Log Analytics workspace](../logs/quick-create-workspace.md) to store data collected by VM insights. You can create a new workspace if you enable using the Azure portal.
- See [Azure Monitor agent supported operating systems and environments](../agents/azure-monitor-agent-supported-operating-systems.md) to verify that your operating system is supported by Azure Monitor agent. 
- See [Manage the Azure Monitor agent](../agents/azure-monitor-agent-manage.md#prerequisites) for prerequisites related to Azure Monitor agent.
- See [Azure Monitor agent network configuration](../agents/azure-monitor-agent-network-configuration.md) for network requirements for the Azure Monitor agent.
- See [Dependency Agent requirements](./vminsights-dependency-agent-maintenance.md) to verify that your operating system is supported by Dependency agent and for network requirements for the Dependency agent.

## VM insights DCR

[Data collection rules (DCRs)](../essentials/data-collection-rule-overview.md) are used by the Azure Monitor agent to specify which data to collect and how it should be processed. To enable VM Insights on a machine with Azure Monitor Agent, you associate a VM insights DCR with the agent. When you enable VM Insights using the Azure portal, a DCR can be created for you. You can either use this DCR or a downloadable template when you use other installation methods. 

> [!IMPORTANT]
> VM Insights automatically creates a DCR that includes a special data stream required for its operation. Do not modify the VM Insights data collection rule or create your own data collection rule to support VM Insights. To collect additional data, such as Windows and Syslog events, create separate data collection rules and associate them with your machines.

If you associate a DCR with the Map feature enabled to a machine on which Dependency Agent isn't installed, the Map view won't be available. To enable the Map view, set `enableAMA property = true` in the Dependency Agent extension when you [install Dependency Agent](./vminsights-dependency-agent-maintenance.md).

- RBAC permissions
- Reasons to create other DCRs 


## Agents

When you enable VM Insights for a machine, the following agents are installed. 

> [!IMPORTANT]
> Azure Monitor Agent has several advantages over the legacy Log Analytics agent, which will be deprecated by August 2024. After this date, Microsoft will no longer provide any support for the Log Analytics agent. [Migrate to Azure Monitor agent](../agents/azure-monitor-agent-migration.md) before August 2024 to continue ingesting data.


- [Azure Monitor agent](../agents/azure-monitor-agent-overview.md): Collects data from the machine and delivers it to a Log Analytics workspace.
- [Dependency agent](./vminsights-dependency-agent-maintenance.md): Collects discovered data about processes running on the virtual machine and external process dependencies, which are used by the [Map feature in VM Insights](../vm/vminsights-maps.md). The Dependency agent relies on the Azure Monitor Agent agent to deliver its data to Azure Monitor. If you don't need the map feature, you don't need to install the Dependency agent.


## Enable network isolation using Private Link

By default, Azure Monitor Agent connects to a public endpoint to connect to your Azure Monitor environment. To enable network isolation for VM Insights, associate your VM Insights data collection rule to a data collection endpoint linked to an Azure Monitor Private Link Scope, as described in [Enable network isolation for Azure Monitor Agent by using Private Link](../agents/azure-monitor-agent-private-link.md).

## Enable VM insights

## [Portal](#tab/portal)

### Enable VM insights using the Azure portal

Use the following procedure to enable VM insights on an unmonitored virtual machine or Virtual Machine Scale Set.

> [!NOTE]
> As part of the Azure Monitor Agent installation process, Azure assigns a [system-assigned managed identity](/azure/app-service/overview-managed-identity?tabs=portal%2chttp#add-a-system-assigned-identity) to the machine if such an identity doesn't already exist.

1. From the **Monitor** menu in the Azure portal, select **Virtual Machines** > **Not Monitored**. This tab includes all machines that don't have VM insights enabled, even if the machines have Azure Monitor Agent or Log Analytics agent installed. If a virtual machine has the Log Analytics agent installed but not the Dependency agent, it will be listed as not monitored. 
 
1. Select **Enable** next to any machine that you want to enable. If a machine is currently not running, you must start it to enable it.

    :::image type="content" source="media/vminsights-enable-portal/enable-unmonitored.png" lightbox="media/vminsights-enable-portal/enable-unmonitored.png" alt-text="Screenshot with unmonitored machines in V M insights.":::

1. On the **Insights Onboarding** page, select **Enable**. 
 
2. On the **Monitoring configuration** page, select **Azure Monitor agent** and select a [DCR](vminsights-enable-overview.md#vm-insights-dcr) from the **Data collection rule** dropdown. Only rules configured for VM insights are listed. If a DCR hasn't already been created for VM insights, Azure Monitor creates one with the following settings.

    - **Guest performance** enabled.
    - **Processes and dependencies** disabled.
 
    :::image type="content" source="media/vminsights-enable-portal/enable-monitored-configure-azure-monitor-agent.png" lightbox="media/vminsights-enable-portal/enable-monitored-configure-azure-monitor-agent.png" alt-text="Screenshot of VM Insights Monitoring Configuration Page.":::
 
2.  Select **Create new** to create a new data collection rule. This lets you select a workspace and specify whether to collect processes and dependencies using the [VM insights Map feature](vminsights-maps.md).

    :::image type="content" source="media/vminsights-enable-portal/create-data-collection-rule.png" lightbox="media/vminsights-enable-portal/create-data-collection-rule.png" alt-text="Screenshot showing screen for creating new data collection rule.":::

    > [!NOTE]
    > If you select a DCR with Map enabled and your virtual machine is not [supported by the Dependency Agent](../vm/vminsights-dependency-agent-maintenance.md), Dependency Agent will be installed and  will run in degraded mode.

3. Select **Configure** to start the configuration process. It takes several minutes to install the agent and start collecting data. You'll receive status messages as the configuration is performed.
 
4. If you use a manual upgrade model for your Virtual Machine Scale Set, upgrade the instances to complete the setup. You can start the upgrades from the **Instances** page, in the **Settings** section.

## [ARM Template](#tab/arm)

### Enable VM insights using ARM templates

The ARM templates described in this section can be deployed using any method to install an [ARM template](/azure/azure-resource-manager/templates/overview). See  [Quickstart: Create and deploy ARM templates by using the Azure portal](/azure/azure-resource-manager/resource-manager-quickstart-create-templates-use-the-portal) for details on deploying a template from the Azure portal.

The following examples show how to deploy the templates using common methods.

```PowerShell
New-AzResourceGroupDeployment -Name EnableVMinsights -ResourceGroupName <ResourceGroupName> -TemplateFile <Template.json> -TemplateParameterFile <Parameters.json>
```

```azurecli
az deployment group create --resource-group <ResourceGroupName> --template-file <Template.json> --parameters <Parameters.json>
```


### Deploy agents
Install the required agents on your machines using guidance in the following articles. Dependency agent is only required if you want to enable the Map feature.

- [Azure Monitor Agent for Linux or Windows](../agents/resource-manager-agent.md#azure-monitor-agent).
- [Dependency agent for Linux](/azure/virtual-machines/extensions/agent-dependency-linux) or [Dependency agent or Windows](/azure/virtual-machines/extensions/agent-dependency-windows) if you want to enable the Map feature. 
  
> [!NOTE]
> If your virtual machines scale sets have an upgrade policy set to manual, VM insights will not be enabled for instances by default after installing the template. You must manually upgrade the instances.

###  Create data collection rule (DCR)
A [data collection rule (DCR)](../essentials/data-collection-rule-overview.md) is used to specify what data to collect from the agent and how it should be processed. VM insights uses a specific data source type, so you should only create a new DCR using the templates described in this section.

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

### Associate DCR with agents
The final step in enabling VM insights is to associate the DCR with the Azure Monitor agent. You need to create an association between the DCR and the agent to enable using the following template which comes from [Create and edit data collection rules (DCRs) and associations in Azure Monitor](../essentials/data-collection-rule-create-edit.md#create-a-dcr). To enable on multiple machines, you need to create an association using this template for each one.

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

## [PowerShell script](#tab/powershell)

### Enable VM insights for multiple VMs using PowerShell script

This section describes how to enable [VM insights](./vminsights-overview.md) using a PowerShell script that can enable multiple VMs. This process uses a script installs VM extensions for Azure Monitoring Agent (AMA) and, if necessary, the Dependency Agent to enable VM Insights. If AMA is onboarded, a Data Collection Rule (DCR) and a User Assigned Managed Identity (UAMI) is also associated with the virtual machines and virtual machine scale sets.

### PowerShell script

Use the PowerShell script [Install-VMInsights.ps1](https://www.powershellgallery.com/packages/Install-VMInsights) to enable VM insights for multiple VMs or virtual machine scale sets. This script iterates through the virtual machines or virtual machine scale sets according to the parameters that you specify. The script can be used to enable VM insights for:

- Every virtual machine and virtual machine scale set in your subscription.
- The scoped resource groups specified by `-ResourceGroup`.
- A VM or virtual machine scale set specified by `-Name`.
 You can specify multiple resource groups, VMs, or scale sets by using wildcards.


Verify that you're using Az PowerShell module version 1.0.0 or later with `Enable-AzureRM` compatibility aliases enabled. Run `Get-Module -ListAvailable Az` to find the version. To upgrade, see [Install Azure PowerShell module](/powershell/azure/install-azure-powershell). If you're running PowerShell locally, run `Connect-AzAccount` to create a connection with Azure.

For a list of the script's argument details and example usage, run `Get-Help`.

```powershell
Get-Help Install-VMInsights.ps1 -Detailed
```

Use the script to enable VM insights using Azure Monitoring Agent and Dependency Agent.

When you enable VM insights using Azure Monitor Agent, the script associates a Data Collection Rule (DCR) and a User Assigned Managed Identity (UAMI) to the VM/Virtual Machine Scale Set. The UAMI settings are passed to the Azure Monitor Agent extension.   

```powershell
Install-VMInsights.ps1 -SubscriptionId <SubscriptionId> `
[-ResourceGroup <ResourceGroup>] `
[-ProcessAndDependencies ] `
[-Name <VM or Virtual Machine Scale Set name>] `
-DcrResourceId <DataCollectionRuleResourceId> `
-UserAssignedManagedIdentityName <UserAssignedIdentityName> `
-UserAssignedManagedIdentityResourceGroup <UserAssignedIdentityResourceGroup> 

```

Required Arguments:   
+  `-SubscriptionId <String>`  Azure subscription ID.  
+  `-DcrResourceId <String> `  Data Collection Rule (DCR) Azure resource ID identifier. You can specify DCRs from different subscriptions to the VMs or virtual machine scale sets being enabled with Vm-Insights.
+  `-UserAssignedManagedIdentityResourceGroup <String> `  Name of User Assigned Managed Identity (UAMI) resource group.   
+  `-UserAssignedManagedIdentityName <String> `  Name of User Assigned Managed Identity (UAMI).  


Optional Arguments:   
+ `-ProcessAndDependencies` Set this flag to onboard the Dependency Agent with Azure Monitoring Agent (AMA) settings.  If not specified, only the Azure Monitoring Agent (AMA)  is onboarded.  
+ `-Name <String>` Name of the VM or Virtual Machine Scale Set to be onboarded. If not specified, all VMs and Virtual Machine Scale Set in the subscription or resource group are onboarded. Use wildcards to specify multiple VMs or Virtual Machine Scale Sets.
+ `-ResourceGroup <String>` Name of the resource group containing the VM or Virtual Machine Scale Set to be onboarded. If not specified, all VMs and Virtual Machine Scale Set in the subscription are onboarded. Use wildcards to specify multiple resource groups.
+ `-PolicyAssignmentName <String>` Only include VMs associated with this policy.   When the PolicyAssignmentName parameter is specified, the VMs part of the parameter SubscriptionId are considered. 
+ `-TriggerVmssManualVMUpdate [<SwitchParameter>]` Trigger the update of VM instances in a scale set whose upgrade policy is set to Manual. 
+ `-WhatIf [<SwitchParameter>]` Get info about expected effect of the commands in the script.         
+ `-Confirm [<SwitchParameter>]` Confirm each action in the script. 
+ `-Approve [<SwitchParameter>]` Provide the approval for the installation to start with no confirmation prompt for the listed VM's/Virtual Machine Scale Sets. 
 
The script supports wildcards for `-Name` and `-ResourceGroup`. For example, `-Name vm*` enables VM insights for all VMs and Virtual Machine Scale Sets that start with "vm". For more information, see [Wildcards in Windows PowerShell](/powershell/module/microsoft.powershell.core/about/about_wildcards). 

Example:
```azurepowershell
Install-VMInsights.ps1 -SubscriptionId 12345678-abcd-abcd-1234-12345678 `
-ResourceGroup rg-AMAPowershell  `
-ProcessAndDependencies  `
-Name vmAMAPowershellWindows `
-DcrResourceId /subscriptions/12345678-abcd-abcd-1234-12345678/resourceGroups/rg-AMAPowershell/providers/Microsoft.Insights/dataCollectionRules/MSVMI-ama-vmi-default-dcr `
-UserAssignedManagedIdentityName miamatest1  `
-UserAssignedManagedIdentityResourceGroup amapowershell
```

The output has the following format:

```powershell
Name                                     Account                               SubscriptionName                      Environment                          TenantId
----                                     -------                               ----------------                      -----------                          --------
AzMon001 12345678-abcd-123…              MSI@9876                              AzMon001                              AzureCloud                           abcd1234-9876-abcd-1234-1234abcd5648

Getting list of VMs or VM Scale Sets matching specified criteria.
VMs and Virtual Machine Scale Sets matching selection criteria :

ResourceGroup : rg-AMAPowershell
  vmAMAPowershellWindows


Confirm
Continue?
[Y] Yes  [N] No  [S] Suspend  [?] Help (default is "Y"): 

(rg-AMAPowershell) : Assigning roles

(rg-AMAPowershell) vmAMAPowershellWindows : Assigning User Assigned Managed Identity edsMIAMATest
(rg-AMAPowershell) vmAMAPowershellWindows : Successfully assigned User Assigned Managed Identity edsMIAMATest
(rg-AMAPowershell) vmAMAPowershellWindows : Data Collection Rule Id /subscriptions/12345678-abcd-abcd-1234-12345678/resourceGroups/rg-AMAPowershell/providers/Microsoft.Insights/dataCollectionRules/MSVMI-ama-vmi-default-dcr already associated with the VM.
(rg-AMAPowershell) vmAMAPowershellWindows : Extension AzureMonitorWindowsAgent, type = Microsoft.Azure.Monitor.AzureMonitorWindowsAgent already installed. Provisioning State : Succeeded
(rg-AMAPowershell) vmAMAPowershellWindows : Installing/Updating extension AzureMonitorWindowsAgent, type = Microsoft.Azure.Monitor.AzureMonitorWindowsAgent
(rg-AMAPowershell) vmAMAPowershellWindows : Successfully installed/updated extension AzureMonitorWindowsAgent, type = Microsoft.Azure.Monitor.AzureMonitorWindowsAgent
(rg-AMAPowershell) vmAMAPowershellWindows : Installing/Updating extension DA-Extension, type = Microsoft.Azure.Monitoring.DependencyAgent.DependencyAgentWindows
(rg-AMAPowershell) vmAMAPowershellWindows : Successfully installed/updated extension DA-Extension, type = Microsoft.Azure.Monitoring.DependencyAgent.DependencyAgentWindows
(rg-AMAPowershell) vmAMAPowershellWindows : Successfully onboarded VM insights

Summary :
Total VM/VMSS to be processed : 1
Succeeded : 1
Skipped : 0
Failed : 0
VMSS Instance Upgrade Failures : 0
```    

Check your VM/Virtual Machine Scale Set in Azure portal to see if the extensions are installed or use the following command:

```powershell

az vm extension list --resource-group <resource group> --vm-name <VM name>  -o table 


Name                      ProvisioningState    Publisher                                   Version    AutoUpgradeMinorVersion
------------------------  -------------------  ------------------------------------------  ---------  -------------------------
AzureMonitorWindowsAgent  Succeeded            Microsoft.Azure.Monitor                     1.16       True
DA-Extension              Succeeded            Microsoft.Azure.Monitoring.DependencyAgent  9.10       True
```

---


## Next steps

To learn how to use the Performance monitoring feature, see [View VM Insights Performance](../vm/vminsights-performance.md). To view discovered application dependencies, see [View VM Insights Map](../vm/vminsights-maps.md).
