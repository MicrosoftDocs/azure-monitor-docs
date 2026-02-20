---
title: Enable VM Insights
description: Describes different methods for enabling VM Insights on virtual machines and virtual machine scale sets.
ms.topic: how-to
ms.reviewer: xpathak
ms.date: 10/03/2024
ms.custom: references_regions

---

# Enable VM Insights

This article provides details on enabling [VM Insights](./vminsights-overview.md) in Azure Monitor using different methods including the Azure portal, ARM templates, and PowerShell script.

> [!WARNING]
> If your virtual machine already has VM insights enabled using the deprecated Log Analytics agent, see [Migrate to Azure Monitor Agent from Log Analytics agent in VM Insights](./vminsights-migrate-agent.md) for guidance on migrating to the Azure Monitor agent. Ensure that you remove the Log Analytics agent in order to prevent duplicate data collection with both agents installed. 

## Prerequisites

- You must have a [Log Analytics workspace](../logs/quick-create-workspace.md) to store data collected by VM insights. You can create a new workspace if you enable using the Azure portal.
- You require permissions to create a data collection rule (DCR) and associate it with the Azure Monitor agent. See [Data Collection Rule permissions](../essentials/data-collection-rule-create-edit.md#permissions) for details.
- See [Azure Monitor agent supported operating systems and environments](../agents/azure-monitor-agent-supported-operating-systems.md) to verify that your operating system is supported by Azure Monitor agent. 
- See [Manage the Azure Monitor agent](../agents/azure-monitor-agent-manage.md#prerequisites) for prerequisites related to Azure Monitor agent.
- See [Azure Monitor agent network configuration](../agents/azure-monitor-agent-network-configuration.md) for network requirements for the Azure Monitor agent.
- See [Dependency Agent requirements](./vminsights-dependency-agent-maintenance.md) to verify that your operating system is supported by Dependency agent and for network requirements for the Dependency agent.

> [!IMPORTANT]
> If your virtual machines are going to connect to the Log Analytics workspace using Azure private link, see [Enable private link for monitoring virtual machines and Kubernetes clusters in Azure Monitor](../fundamentals/private-link-vm-kubernetes.md).

## Agents

When you enable VM Insights for a machine, the following agents are installed. 

- [Azure Monitor agent](../agents/azure-monitor-agent-overview.md): Collects data from the machine and delivers it to a Log Analytics workspace.
- [Dependency agent](./vminsights-dependency-agent.md): Collects discovered data about processes running on the virtual machine and external process dependencies to support the [Map feature in VM Insights](../vm/vminsights-maps.md). This agent is not required for other VM insights functionality, so you don't need to install the dependency agent if you're not going to use the Map feature.

## VM insights DCR

[Data collection rules (DCRs)](../essentials/data-collection-rule-overview.md) are used by the Azure Monitor agent to specify which data to collect and how it should be processed. When you enable VM Insights, you create a DCR specifically for VM insights and associate it with the Azure Monitor agent on any machines to monitor.

The only configuration in a VM insights DCR is the Log Analytics workspace and whether or not to collect processes and dependencies data. Instead of creating a separate DCR for each machine, you should use a single DCR for each Log Analytics workspace you use for VM insights and associate that DCR with multiple machines. You may want to create separate DCRs if you want to collect processes and dependencies from some machines but not from others. 


> [!NOTE]
> You shouldn't modify the VM insights DCR. If you need to collect additional data from the monitored machines, such as event logs and security logs, create additional DCRs and associate them with the same machines. You can get guidance for creating these DCRs from [Collect data with Azure Monitor Agent](../vm/data-collection.md).


:::image type="content" source="media/vminsights-enable-portal/vminsights-dcr.png" lightbox="media/vminsights-enable-portal/vminsights-dcr.png" alt-text="Diagram showing the operation of VM insights DCR compared to other DCRs associated with the same agents.":::


### Create a VM insights DCR
There are two methods to create a VM insights DCR. Regardless of the method you choose, the DCR is identical and can be used with any process to enable VM insights on other machines. While not required, you should name the DCR `MSVMI-{WorkspaceName}` to match the naming convention used by the Azure portal.

- Create a VM insights DCR as part of the onboarding process using the Azure portal with the [process detailed below](#enable-vm-insights-using-the-azure-portal). 
- Download and install the [VM insights data collection rule templates](https://github.com/Azure/AzureMonitorForVMs-ArmTemplates/releases/download/vmi_ama_ga/DeployDcr.zip). The following table describes the templates available. See [Deploy templates](#deploy-arm-templates) if you aren't familiar with methods to deploy ARM templates.

   | Folder | File | Description |
   |:---|:---|:---|
   | DeployDcr\\<br>PerfAndMapDcr | DeployDcrTemplate<br>DeployDcrParameters | Enable both Performance and Map experience of VM Insights. |
   | DeployDcr\\<br>PerfOnlyDcr | DeployDcrTemplate<br>DeployDcrParameters | Enable only Performance experience of VM Insights. |



## Enable network isolation

There are two methods for network isolation that VM insights supports as described in the following table.

| Method | Description |
|:---|:---|
| Private link | By default, Azure Monitor Agent connects to a public endpoint to connect to your Azure Monitor environment. To have it connect with private link, associate your VM Insights DCR to a data collection endpoint (DCE) linked to an Azure Monitor Private Link Scope as described in [Enable network isolation for Azure Monitor Agent by using Private Link](../fundamentals/private-link-vm-kubernetes.md). |
| Network security perimeter | If your Log Analytics workspace is associated with a network security perimeter, using the guidance at [Configure Azure Monitor with Network Security Perimeter](../fundamentals/network-security-perimeter.md). |

## Enable VM insights

## [Portal](#tab/portal)

### Enable VM insights using the Azure portal

Use the following procedure to enable VM insights on an unmonitored virtual machine or Virtual Machine Scale Set. This process doesn't require you to deploy agents or create a VM insights DCR first since these tasks are performed by the portal.

> [!NOTE]
> As part of the Azure Monitor Agent installation process, Azure assigns a [system-assigned managed identity](/azure/app-service/overview-managed-identity?tabs=portal%2chttp#add-a-system-assigned-identity) to the machine if such an identity doesn't already exist.

1. From the **Monitor** menu in the Azure portal, select **Virtual Machines** > **Not Monitored**. This tab includes all machines that don't have VM insights enabled. Any machines have Azure Monitor agent installed. If a virtual machine has the Log Analytics agent installed but not the Dependency agent, it will be listed as not monitored. 
 
1. Select **Enable** next to any machine that you want to enable. If a machine is currently not running, you must start it to enable it.

    :::image type="content" source="media/vminsights-enable-portal/enable-unmonitored.png" lightbox="media/vminsights-enable-portal/enable-unmonitored.png" alt-text="Screenshot with unmonitored machines in V M insights.":::

1. On the **Insights Onboarding** page, select **Enable**. 
 
2. On the **Monitoring configuration** page, select **Azure Monitor agent** and select a [DCR](#vm-insights-dcr) from the **Data collection rule** dropdown. Only DCRs configured for VM insights are listed.
 
     :::image type="content" source="media/vminsights-enable-portal/enable-monitored-configure-azure-monitor-agent.png" lightbox="media/vminsights-enable-portal/enable-monitored-configure-azure-monitor-agent.png" alt-text="Screenshot of VM Insights Monitoring Configuration Page.":::
 
 1. If a DCR hasn't already been created for VM insights, Azure Monitor offers to create one with a default Log Analytics workspace and the following settings. You can either accept these defaults or click **Create New** to create a new DCR with different settings. This lets you select a workspace and specify whether to collect processes and dependencies using the [VM insights Map feature](vminsights-maps.md).

    - **Guest performance** enabled.
    - **Processes and dependencies** disabled.

    :::image type="content" source="media/vminsights-enable-portal/create-data-collection-rule.png" lightbox="media/vminsights-enable-portal/create-data-collection-rule.png" alt-text="Screenshot showing screen for creating new data collection rule.":::

    > [!NOTE]
    > If you select a DCR with Map enabled and your virtual machine is not [supported by the Dependency Agent](../vm/vminsights-dependency-agent-maintenance.md), Dependency Agent will be installed and  will run in degraded mode.

3. Select **Configure** to start the configuration process. It takes several minutes to install the agent and start collecting data. You'll receive status messages as the configuration is performed.
 
4. If you use a manual upgrade model for your Virtual Machine Scale Set, upgrade the instances to complete the setup. You can start the upgrades from the **Instances** page, in the **Settings** section.

## [ARM Template](#tab/arm)

### Enable VM insights using ARM templates

There are three steps to enabling VM insights using ARM templates. Each of these steps is described in detail in the following sections. 

### Deploy agents
Install the required agents on your machines using guidance in the following articles. Dependency agent is only required if you want to enable the Map feature.

- [Azure Monitor Agent for Linux or Windows](../agents/resource-manager-agent.md#azure-monitor-agent).
- [Dependency agent for Linux](/azure/virtual-machines/extensions/agent-dependency-linux) or [Dependency agent or Windows](/azure/virtual-machines/extensions/agent-dependency-windows) if you want to enable the Map feature. 
  
> [!NOTE]
> If your virtual machines scale sets have an upgrade policy set to manual, VM insights will not be enabled for instances by default after installing the template. You must manually upgrade the instances.

###  Create data collection rule (DCR)
If you don't already have a DCR for VM insights, create one using the details above in [VM insights DCR](#vm-insights-dcr).


### Associate DCR with agents
The final step in enabling VM insights is to associate the DCR with the Azure Monitor agent. Use the template below which comes from [Manage data collection rule associations in Azure Monitor](../essentials/data-collection-rule-associations.md#create-new-association). To enable on multiple machines, you need to create an association using this template for each one. See [Deploy templates](#deploy-arm-templates) if you aren't familiar with methods to deploy ARM templates.

> [!NOTE]
> If you associate a DCR with the Map feature enabled to a machine on which Dependency Agent isn't installed, the Map view won't be available. To enable the Map view, set `enableAMA property = true` in the Dependency Agent extension when you [install Dependency Agent](./vminsights-dependency-agent-maintenance.md).

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
### Deploy ARM templates

The ARM templates described in this section can be deployed using any method to install an [ARM template](/azure/azure-resource-manager/templates/overview). See  [Quickstart: Create and deploy ARM templates by using the Azure portal](/azure/azure-resource-manager/resource-manager-quickstart-create-templates-use-the-portal) for details on deploying a template from the Azure portal.

The following examples show how to deploy the templates from command line using common methods.

```PowerShell
New-AzResourceGroupDeployment -Name EnableVMinsights -ResourceGroupName <ResourceGroupName> -TemplateFile <Template.json> -TemplateParameterFile <Parameters.json>
```

```azurecli
az deployment group create --resource-group <ResourceGroupName> --template-file <Template.json> --parameters <Parameters.json>
```


## [PowerShell script](#tab/powershell)

### Enable VM insights for multiple VMs using PowerShell script

This section describes how to enable [VM insights](./vminsights-overview.md) using a PowerShell script that can enable multiple VMs. This process uses a script that installs VM extensions for Azure Monitoring agent (AMA) and, if necessary, the Dependency Agent to enable VM Insights. 

Before you use this script, you must create a VM insights DCR using the details above in [VM insights DCR](#vm-insights-dcr).

### PowerShell script

Use the PowerShell script [Install-VMInsights.ps1](https://www.powershellgallery.com/packages/Install-VMInsights) to enable VM insights for multiple VMs or virtual machine scale sets. This script iterates through the machines according to the parameters that you specify. The script can be used to enable VM insights for the following. Each of these parameters accepts wildcards.

- Every virtual machine and virtual machine scale set in your subscription.
- The scoped resource groups specified by `-ResourceGroup`.
- A VM or virtual machine scale set specified by `-Name`.

Verify that you're using Az PowerShell module version 1.0.0 or later with `Enable-AzureRM` compatibility aliases enabled. Run `Get-Module -ListAvailable Az` to find the version. To upgrade, see [Install Azure PowerShell module](/powershell/azure/install-azure-powershell). If you're running PowerShell locally, run `Connect-AzAccount` to create a connection with Azure.

For a list of the script's argument details and example usage, run `Get-Help`.

```powershell
Get-Help Install-VMInsights.ps1 -Detailed
```

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

```powershell
Install-VMInsights.ps1 -SubscriptionId 12345678-abcd-abcd-1234-12345678 `
-ResourceGroup rg-AMAPowershell  `
-ProcessAndDependencies  `
-Name vmAMAPowershellWindows `
-DcrResourceId /subscriptions/12345678-abcd-abcd-1234-12345678/resourceGroups/rg-AMAPowershell/providers/Microsoft.Insights/dataCollectionRules/MSVMI-ama-vmi-default-dcr `
-UserAssignedManagedIdentityName miamatest1  `
-UserAssignedManagedIdentityResourceGroup amapowershell
```

Check your machines in Azure portal to see if the extensions are installed or use the following command:

```powershell
az vm extension list --resource-group <resource group> --vm-name <VM name>  -o table 
```

---

## Edit VM insights configuration
To edit the VM insights configuration for a virtual machine after it's been onboarded, click on **Enabled** next to the VM on the VM insights **Overview** page. This will display the current configuration. Click **Edit** to open the configuration page as described in the previous section. You can select another DCR for the VM or create a new one. You can't modify the existing DCR from this page.

## Next steps

To learn how to use the Performance monitoring feature, see [View VM Insights Performance](../vm/vminsights-performance.md). To view discovered application dependencies, see [View VM Insights Map](../vm/vminsights-maps.md).
