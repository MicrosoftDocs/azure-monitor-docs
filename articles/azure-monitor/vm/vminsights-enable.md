---
title: Enable VM Insights
description: Describes different methods for enabling VM Insights on virtual machines and virtual machine scale sets.
ms.topic: how-to
ms.reviewer: xpathak
ms.date: 02/17/2026
ms.custom: references_regions

---

# Enable VM Insights

This article provides details on enabling [VM Insights](./vminsights-overview.md) in Azure Monitor using different methods including the Azure portal, ARM templates, and PowerShell script.

> [!WARNING]
> If your virtual machine already has VM insights enabled using the deprecated Log Analytics agent, see [Migrate to Azure Monitor Agent from Log Analytics agent in VM Insights](./vminsights-migrate-agent.md) for guidance on migrating to the Azure Monitor agent. Ensure that you remove the Log Analytics agent in order to prevent duplicate data collection with both agents installed. 

## Prerequisites

- [Azure Monitor workspace](../logs/quick-create-workspace.md) if you enable OpenTelemetry metrics (preview). You can create a new workspace if you enable using the Azure portal.
- [Log Analytics workspace](../logs/quick-create-workspace.md) if you enable log-based metrics. You can create a new workspace if you enable using the Azure portal.
- Permissions to create a data collection rule (DCR) and associate it with the Azure Monitor agent. See [Data Collection Rule permissions](../essentials/data-collection-rule-create-edit.md#permissions).
- See [Azure Monitor agent supported operating systems and environments](../agents/azure-monitor-agent-supported-operating-systems.md) to verify that your operating system is supported by Azure Monitor agent. 
- See [Manage the Azure Monitor agent](../agents/azure-monitor-agent-manage.md#prerequisites) for prerequisites related to Azure Monitor agent.
- See [Azure Monitor agent network configuration](../agents/azure-monitor-agent-network-configuration.md) for network requirements for the Azure Monitor agent.

> [!NOTE]
> The Maps feature of AM insights has been deprecated. This feature was enabled by 

## Enable VM insights with the Azure portal
Use the following procedure to enable VM insights on a single virtual machine or Virtual Machine Scale Set. This process doesn't require you to have any knowledge of individual components that enable VM insights, but you can only enable a single machine at a time.

> [!NOTE]
> As part of the Azure Monitor Agent installation process, Azure assigns a [system-assigned managed identity](/azure/app-service/overview-managed-identity?tabs=portal%2chttp#add-a-system-assigned-identity) to the machine if such an identity doesn't already exist.

From the **Monitor** menu in the Azure portal, select **Virtual Machines** > **Not Monitored**. This tab includes all machines that don't have VM insights enabled. Any machines have Azure Monitor agent installed. Select **Enable** next to any machine that you want to enable. If a machine is currently not running, you must start it to enable it.

:::image type="content" source="media/vminsights-enable-portal/enable-unmonitored.png" lightbox="media/vminsights-enable-portal/enable-unmonitored.png" alt-text="Screenshot with unmonitored machines in VM insights.":::

> [!NOTE]
> You can also enable VM insights from **Insights** in the portal for the virtual machine.
>
> :::image type="content" source="media/vminsights-enable-portal/enable-unmonitored-virtual-machine.png" lightbox="media/vminsights-enable-portal/enable-unmonitored-virtual-machine.png" alt-text="Screenshot showing VM insights onboarding option in virtual machine portal.":::

On the **Configure monitor** page, select whether you want to enable classic log-based metrics or preview OpenTemetry metrics. See [Metrics selection](#metrics-selection) for guidance on which type of metrics to enable.

Default Azure Monitor workspace and Log Analytics workspace are automatically selected. Select **Customize infrastructure monitoring** to select alternate workspaces or create new ones. See [Customize metric collection](./vminsights-opentelemetry.md#customize-metric-collection) for guidance on customizing the metrics collection that are collected by OpenTelemetry. You can't modify the metrics collected for log-based metrics.

:::image type="content" source="media/vminsights-enable-portal/monitoring-configuration.png" lightbox="media/vminsights-enable-portal/monitoring-configuration.png" alt-text="Screenshot of the VM insights configuration page.":::

When you save the configuration, it takes several minutes to install the agent and start collecting data.
 
If you use a manual upgrade model for your Virtual Machine Scale Set, upgrade the instances to complete the setup. You can start the upgrades from the **Instances** page, in the **Settings** section.


> [!NOTE]
> See []() for details about the Dependency agent which has been deprecated.





> [!NOTE]
> See []() for details on the DCR for the map feature.

## Enable at scale
Rather than enable each machine individually and have a separate DCR created for each, you can have a single DCR that is associated with multiple machines. This is especially useful if you have a large number of machines to enable that share the same configuration.

1. Create a VM insights DCR
1. Install the agent on each machine
1. Associate the DCR with the agent on each machine


### Create a VM insights DCR
Create a VM insights DCR by enabling monitoring for a single machine. This DCR can be used with any other machines in the same region. If you have machines in different regions, create a DCR for each region.

When you enable VM insights, [Data collection rules (DCRs)](../essentials/data-collection-rule-overview.md) are created and associated with the VM. DCRs are used by the Azure Monitor agent to specify which data to collect and how it should be processed. The DCRs that get created depend on the metrics that you enable. 

| Metrics | DCR Name | Description |
|:---|:---|:---|
| OpenTelemetry metrics (preview) | `MSVMOtel-<region>-<machine-name>` | Modify to collect additional OTel metrics as described in [](). |
| Log-based metrics | `MSVMI-<region>-<WorkspaceName>` | Don't modify this DCR. Create a separate DCR if you want to collect additional metrics as described in [](). |

> [!NOTE]
> Processes and dependencies DCR 

> [!NOTE]
> If you're only using log-based metrics, you can also download and install the [VM insights data collection rule templates](https://github.com/Azure/AzureMonitorForVMs-ArmTemplates/releases/download/vmi_ama_ga/DeployDcr.zip). The following table describes the templates available. See [Deploy templates](#deploy-arm-templates) if you aren't familiar with methods to deploy ARM templates.
>
>   | Folder | File | Description |
>   |:---|:---|:---|
>   | DeployDcr\\<br>PerfOnlyDcr | DeployDcrTemplate<br>DeployDcrParameters | Enable only Performance experience of VM Insights. |
>   | DeployDcr\\<br>PerfAndMapDcr | DeployDcrTemplate<br>DeployDcrParameters | Enable both Performance and Map experience of VM Insights. This feature has been deprecated. See [VM Insights Map and Dependency Agent retirement guidance](./vminsights-maps-retirement.md). |


### [CLI](#tab/cli)

#### Windows VM

```bash
az vm extension set \
  --resource-group <resource-group-name> \
  --vm-name <vm-name> \
  --name AzureMonitorWindowsAgent \
  --publisher Microsoft.Azure.Monitor \
  --enable-auto-upgrade true
```

#### Linux VM

```bash
az vm extension set \
  --resource-group <resource-group-name> \
  --vm-name <vm-name> \
  --name AzureMonitorLinuxAgent \
  --publisher Microsoft.Azure.Monitor \
  --enable-auto-upgrade true
```

#### Windows VMSS

```bash
az vmss extension set \
  --resource-group <resource-group-name> \
  --vmss-name <vmss-name> \
  --name AzureMonitorWindowsAgent \
  --publisher Microsoft.Azure.Monitor \
  --enable-auto-upgrade true
```

#### Linux VMSS

```bash
az vmss extension set \
  --resource-group <resource-group-name> \
  --vmss-name <vmss-name> \
  --name AzureMonitorLinuxAgent \
  --publisher Microsoft.Azure.Monitor \
  --enable-auto-upgrade true
```

#### Windows Arc-enabled server
```bash
az connectedmachine extension create \
  --name AzureMonitorWindowsAgent \
  --publisher Microsoft.Azure.Monitor \
  --type AzureMonitorWindowsAgent \
  --machine-name <arc-server-name> \
  --resource-group <resource-group-name> \
  --location <arc-server-location> \
  --enable-auto-upgrade true
```

#### Linux Arc-enabled server
```bash
az connectedmachine extension create \
  --name AzureMonitorLinuxAgent \
  --publisher Microsoft.Azure.Monitor \
  --type AzureMonitorLinuxAgent \
  --machine-name <arc-server-name> \
  --resource-group <resource-group-name> \
  --location <arc-server-location> \
  --enable-auto-upgrade true
```

### [PowerShell](#tab/powershell)

#### Windows VM

```powershell
Set-AzVMExtension \
  -Name AzureMonitorWindowsAgent \
  -ExtensionType AzureMonitorWindowsAgent \
  -Publisher Microsoft.Azure.Monitor \
  -ResourceGroupName <resource-group-name> \
  -VMName <vm-name> \
  -Location <location> \
  -EnableAutomaticUpgrade $true
```

#### Linux VM

```powershell
Set-AzVMExtension \
  -Name AzureMonitorLinuxAgent \
  -ExtensionType AzureMonitorLinuxAgent \
  -Publisher Microsoft.Azure.Monitor \
  -ResourceGroupName <resource-group-name> \
  -VMName <vm-name> \
  -Location <location> \
  -EnableAutomaticUpgrade $true
```

```powershell
$vmss = Get-AzVmss -ResourceGroupName <resource-group-name> -VMScaleSetName <vmss-name>

Add-AzVmssExtension \
  -VirtualMachineScaleSet $vmss \
  -Name AzureMonitorWindowsAgent \
  -Publisher Microsoft.Azure.Monitor \
  -Type AzureMonitorWindowsAgent \
  -AutoUpgradeMinorVersion $true \
  -EnableAutomaticUpgrade $true

Update-AzVmss -ResourceGroupName <resource-group-name> -Name <vmss-name> -VirtualMachineScaleSet $vmss
```
(`Add-AzVmssExtension` adds an extension to a VMSS model; `Update-AzVmss` applies the change.) citeturn3search39

#### Linux VMSS
```powershell
$vmss = Get-AzVmss -ResourceGroupName <resource-group-name> -VMScaleSetName <vmss-name>

Add-AzVmssExtension \
  -VirtualMachineScaleSet $vmss \
  -Name AzureMonitorLinuxAgent \
  -Publisher Microsoft.Azure.Monitor \
  -Type AzureMonitorLinuxAgent \
  -AutoUpgradeMinorVersion $true \
  -EnableAutomaticUpgrade $true

Update-AzVmss -ResourceGroupName <resource-group-name> -Name <vmss-name> -VirtualMachineScaleSet $vmss
```

#### Windows Arc-enabled server
```powershell
New-AzConnectedMachineExtension \
  -Name AMAWindows \
  -ExtensionType AzureMonitorWindowsAgent \
  -Publisher Microsoft.Azure.Monitor \
  -ResourceGroupName <resource-group-name> \
  -MachineName <arc-server-name> \
  -Location <arc-server-location>
```
(Install AMA on Arc-enabled servers using `New-AzConnectedMachineExtension`.) citeturn3search24

#### Linux Arc-enabled server
```powershell
New-AzConnectedMachineExtension \
  -Name AMALinux \
  -ExtensionType AzureMonitorLinuxAgent \
  -Publisher Microsoft.Azure.Monitor \
  -ResourceGroupName <resource-group-name> \
  -MachineName <arc-server-name> \
  -Location <arc-server-location>
```

---

### Deploy agents
The [Azure Monitor agent](../agents/azure-monitor-agent-overview.md) is responsible for collecting data from the guest operating system and delivering it to Azure Monitor. There are multiple methods to install the agent on your machines as described in [Installation options](../agents/azure-monitor-agent-manage.md#installation-options).

- [Azure Monitor Agent for Linux or Windows](../agents/resource-manager-agent.md#azure-monitor-agent).
 
  
> [!NOTE]
> If your virtual machines scale sets have an upgrade policy set to manual, VM insights will not be enabled for instances by default after installing the template. You must manually upgrade the instances.



## Enable network isolation

There are two methods for network isolation that VM insights supports as described in the following table.

| Method | Description |
|:---|:---|
| Private link | See [Enable network isolation for Azure Monitor Agent by using Private Link](../agents/azure-monitor-agent-private-link.md). |
| Network security perimeter | See [Configure Azure Monitor with Network Security Perimeter](../fundamentals/network-security-perimeter.md). |






## [ARM Template](#tab/arm)

### Enable VM insights using ARM templates

There are three steps to enabling VM insights using ARM templates. Each of these steps is described in detail in the following sections. 





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

## PowerShell script

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
