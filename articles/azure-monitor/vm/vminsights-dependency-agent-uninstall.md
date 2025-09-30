---
title:  Remove Dependency Agent from Azure Virtual Machines and Virtual Machine Scale Sets
description: Detailed process for safely uninstalling the Dependency Agent from both Windows and Linux-based Azure VMs and VMSS instances.
ms.topic: article
ms.date: 02/26/2025
---

# Remove Dependency Agent from Azure Virtual Machines and Virtual Machine Scale Sets
The [Dependency Agent](./vminsights-dependency-agent.md) is a required component for the map feature in VM insights. This feature is [being deprecated](./vminsights-maps-retirement.md) so the dependency agent will no longer be required. This article provides the steps for safely uninstalling the Dependency Agent from both Windows and Linux-based Azure VMs and VMSS instances.

> [!IMPORTANT]
> [VM insights](./vminsights-overview.md) isn't being retired, just the map feature and any components that rely on it, such as the dependency agent.

## Understand the Dependency Agent
The Dependency Agent collects data about machine processes, connections, and dependencies. Before proceeding with removal, consider how this may affect your monitoring, troubleshooting, or compliance workflows. Removing the agent stops data collection for the [map feature of Azure Monitor](./vminsights-maps.md) and any workbooks or other solutions you may have that depend on this data.

## Best practices

- Test removal on a nonproduction VM or VMSS instance before rolling out widely.
- Document the removal process and notify all affected teams before proceeding.
- Update your configuration management and automation scripts to prevent future unintended deployments of the Dependency Agent.
- Re-enable or replace any monitoring or security features that depended on the agent, if necessary.


## Prerequisites and considerations

- Identify machines or scale set instances where the Dependency Agent is installed. See [VM Insights Map and Dependency Agent retirement guidance](./vminsights-maps-retirement.md).
- Ensure you have Owner or Contributor permission, or equivalent administrative rights, on the target VM or VMSS.
- Ensure you have at least Reader access to the [VM insights Data Collection Rules (DCR)](./vminsights-enable.md#vm-insights-dcr).
- If you use [Azure Policy](./vminsights-enable-policy.md) to enable VM insights, you may require changes in policy assignments to prevent compliance issues or reinstallation of the Dependency Agent after it's removed. 
- Review any monitoring solutions that rely on the Dependency Agent and communicate with your IT or monitoring teams to avoid unintended disruptions. Any alert rules that use any of the [`VMComputer`](/azure/azure-monitor/reference/tables/vmcomputer), [`VMProcess`](/azure/azure-monitor/reference/tables/vmprocess), [`VMConnection`](/azure/azure-monitor/reference/tables/vmconnection), or [`VMBoundPort`](/azure/azure-monitor/reference/tables/vmboundport) tables from a Log Analytics Workspace are affected. The contents of the [`InsightsMetrics`](/azure/azure-monitor/reference/tables/insightsmetrics) table will change and may affect monitoring solutions.
- Removal doesn't require a VM reboot but follow your organization’s best practice to avoid adversely affecting production systems.
- For VMSS, changes need to be applied across all instances. 
- Previously collected data in workspaces isn't deleted but is retained according to existing data retention policies.

## Identify the Dependency Agent installation
The Dependency Agent is typically installed as an Azure extension. You can verify its installation using any of the methods below.

### [Azure portal](#tab/portal)

1. Open the menu for the VM or VMSS in the Azure portal.
2. Select **Extensions + applications** in the left menu.
3. Look for **DependencyAgentWindows** or **DependencyAgentLinux** in the list of installed extensions.

### [CLI](#tab/cli)

Run one of the following commands to list installed extensions. Look for `Microsoft.Azure.Monitoring.DependencyAgent` in the **Publisher** column. Note the value in the **Name** column since you need it later.

**VM**

```azurecli
az vm extension list --resource-group <resource-group-name> --vm-name <vm-name> --output table
```

**VMSS**

```azurecli
az vmss extension list --resource-group <resource-group-name> --vmss-name <vm-name> --output table
```


### [PowerShell](#tab/powershell)

Run one of the following commands to list installed extensions. Look for `Microsoft.Azure.Monitoring.DependencyAgent` in the **Publisher** column. Note the value in the **Name** column since you need it later.


**VM**

```powershell
Get-AzVMExtension -ResourceGroupName <resource-group-name> -VMName <vm-name> | Format-Table ExtensionType,Publisher,Name
```

**VMSS**

```powershell
(Get-AzVmss -ResourceGroupName <resource-group-name> -VMScaleSetName <vmss-name>).VirtualMachineProfile.ExtensionProfile.Extensions | Format-Table Type,Publisher,Name
```
---

## Update Data Collection Rule Assignments (DCRA)

This step disables sending process and connection data to the workspace. Prior to this step, verify that you removed or disabled any alerts and monitoring in your environment that depend upon this data.


#### [Azure portal](#tab/portal)
The portal can't make changes for all possible Data Collection Rule Associations (DCRA), since the VM/VMSS might be associated with multiple DCRs. Use the query below in the [Azure Resource Graph Explorer](https://portal.azure.com/#view/HubsExtension/ArgQueryBlade) to check if your VM/VMSS can use the Azure portal to update its DCRA. If it doesn't return *Ok to use portal*, you need to use PowerShell or CLI to update each DCRA.

```kusto
resources
| where id =~ '<resource-id>' // add VM/VMSS resource id here 
| project azureResourceId = tolower(id), 
          computeName = name 
| join kind = leftouter ( 
    insightsresources 
    | extend azureResourceId = tostring(split(tolower(id), '/providers/microsoft.insights/datacollectionruleassociations/')[0]) 
  ) on azureResourceId 
| project id, computeName, dcraName = name, 
          foundDcra = isnotempty(id),
          dataCollectionRulesId = tolower(properties.dataCollectionRuleId) 
| join kind=leftouter ( 
    resources 
    | where type == "microsoft.insights/datacollectionrules"  
    | project dataCollectionRulesId = tolower(id), properties  
  ) on dataCollectionRulesId 
| project id, computeName, dcraName, foundDcra,
          dataCollectionRulesId,
          flows = properties.dataFlows  
| mv-expand flows  
| summarize vmiFlowCount =
            countif(flows.streams contains "Microsoft-InsightsMetric" or 
                    flows.streams contains "Microsoft-ServiceMap")
            by id, computeName, dcraName, dataCollectionRulesId, foundDcra 
| extend isVmiDcra = vmiFlowCount > 0,
         nonconformingName = dcraName != strcat(computeName,'-VMInsights-Dcr-Association')
| summarize 
    Total = count(),
    TotalDcra = countif(foundDcra),
    TotalVmiDcra = countif(isVmiDcra),
    NonconformingNameCount = countif(isVmiDcra and nonconformingName) 
| project PortalCompatibility = 
          case(Total == 0, 'Check VM/VMSS id', 
               TotalVmiDcra == 0, 'No DCRA found',
               TotalVmiDcra > 1, 'More than one DCRA', 
               NonconformingNameCount > 0, 'Not using Portal style name', 
               'Ok to use portal')
```

If your VM/VMSS can use the portal, follow these steps:

1. Open the menu for the VM or VMSS in the Azure portal.
2. Select **Monitoring configuration** at the top of the screen.
3. The monitoring configuration should display the name of a Data Collection Rule (DCR) with **Processes and dependencies (Map)** enabled. If **Processes and dependencies (Map)** is disabled, then right DCR is already being used. You can skip to the next section to uninstall the Dependency Agent.
4. Click **Edit** at the bottom of the screen.
5. Select an existing DCR or create a new DCR that has **Processes and dependencies (Map)** disabled.
6. Click **Configure** and wait for the update to be completed.



### [CLI](#tab/cli)

```azurecli
# Find the current DCR
dcrid=$(az monitor data-collection rule show --subscription '<subscription-id>' --resource-group '<resource-group-name>' --data-collection-rule-name '<dcr-name>' --query 'id' --output tsv)

# Find the resource id of the VM/VMSS (uncomment VMSS line for a VMSS)
resourceid=$(az vm show --resource-group '<resource-group-name>' --name '<VmName>' --query 'id' --output tsv) 
# resourceid=$(az vmss show --resource-group '<resource-group-name>' --name '<VmssName>' --query 'id' --output tsv)

# Find the DCR Association
dcraName=$(az monitor data-collection rule association list --resource-uri "$resourceid" --query "[?dataCollectionRuleId == '$dcrid'].name" --output tsv)

# Find the new DCR that doesn't include processes and dependencies (Map)
replacementdcrid=$(az monitor data-collection rule show --subscription '<subscription-id>' --resource-group '<resource-group-name>' --data-collection-rule-name '<replacement-dcr-name>' --query 'id' --output tsv)

# Update the DCRA
az monitor data-collection rule association update --association-name "$dcraName" --resource-uri "$resourceid" --description 'No MAP' --data-collection-rule-id "$replacementdcrid"

```



### [PowerShell](#tab/powershell)

```powershell

# Find the current DCR
$dcr = Get-AzDataCollectionRule -SubscriptionId <subscription-id> -ResourceGroupName <resource-group-name> -DataCollectionRuleName <dcr-name>

# Find the resource id of the VM/VMSS (uncomment VMSS line for a VMSS)
$resource = Get-AzVM -ResourceGroupName <resource-group-name> -Name <VmName>
# $resource = Get-AzVMSS -ResourceGroupName <resource-group-name> -Name <VmssName>

# Find the DCR Association
$dcra = get-azdatacollectionruleassociation -ResourceUri $resource.id | Where { $_.DataCollectionRuleId -eq $dcr.id }
# Find the new DCR that doesn't include processes and dependencies (Map)

$replacement_dcr = Get-AzDataCollectionRule -SubscriptionId <subscription-id> -ResourceGroupName <resource-group-name> -DataCollectionRuleName <replacement-dcr-name>

# Update the DCRA
Update-AzDataCollectionRuleAssociation -ResourceUri $resource.id -AssociationName $dcra.Name -Description "No MAP" -DataCollectionRuleId $replacement_dcr.id
```
---

## Remove the Dependency Agent

### [Azure portal](#tab/portal)

1. Open the menu for the VM or VMSS in the Azure portal.
2. Select **Extensions + applications** in the left menu.
3. Select the extension with a **Type** of either **DependencyAgentWindows** or **DependencyAgentLinux**.
4. Click **Uninstall** and wait for the process to complete.

### [CLI](#tab/cli)

Use one of the following commands with the extension name from [Identify the Dependency Agent installation](#identify-the-dependency-agent-installation).

**VM**

```azurecli
az vm extension delete --resource-group <resource-group-name> --vm-name <vm-name> --name <extension-name>
```

**VMSS**

```azurecli
az vmss extension delete --resource-group <resource-group-name> --vm-name <vm-name> --name <extension-name>
```


### [PowerShell](#tab/powershell)

Use one of the following commands with the extension name from [Identify the Dependency Agent installation](#identify-the-dependency-agent-installation).

**VM**

```powershell
Remove-AzVMExtension -ResourceGroupName <resource-group-name> -VMName <vm-name> -Name <extension-name>
```

**VMSS**

```powershell
vmssExtensionName = '<extension-name>'
$rgName = '<resource-group-name>'
$vmssName = '<vmss-name>'
$vmss = Get-AzVmss -ResourceGroupName $rgName -VMScaleSetName $vmssName
Remove-AzVmssExtension -VirtualMachineScaleSet $vmss -Name $vmssExtensionName
Update-AzVmss -ResourceGroupName $rgName -Name $vmssName -VirtualMachineScaleSet $vmss
```

---

If the VMSS is configured with [manual upgrade mode](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-upgrade-policy), then an extra step is required to remove the extension from any currently running instances. See [Performing manual upgrades on Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-perform-manual-upgrades). 


## Verify removal

After removal, verify that the agent is fully uninstalled and no related processes are running.

- Check the **Extensions + applications** blade in the Azure portal. the Dependency Agent should no longer be listed.
- Review monitoring dashboards to ensure expected changes in data collection.
- After several days, check for unintentional reinstallation of the process and connection monitoring. The VM/VMSS’s Activity Log can be used to identify who and when the changes were made. After addressing the cause of the reinstallation, complete the steps above again.


## Troubleshooting

**Extension Removal Fails**<br>
If the uninstall fails, review the common issues below. The VM/VMSS’s Activity Log may provide more details.

- Linux
    - **Could not acquire package manager (yum or dpkg) lock.**
    This is typically a transient issue when some other process is interacting with the package manager. Try to uninstall the VM extension again.

- Windows
    - **The uninstall did not complete in time and was killed.**
    This is typically a transient issue when the VM is resource constrained. Try to uninstall the VM extension again when the VM has a lower CPU/Memory usage.
    - **C:\Program Files\Microsoft Dependency Agent\Uninstall_version.exe non-zero exit code n.**
    Log onto the system with administrator privileges and run the uninstaller interactively and address any reported issues. Do the VM extension uninstall again to complete the process.
    - **PowerShell Exit Status = n and there is no other error message.**
    Log onto the system with administrator privileges. Locate the program named `C:\Program Files\Microsoft Dependency Agent\Uninstall_version.exe`, where version is a four part version number. Run it interactively and address any reported issues. Do the VM extension uninstall again to complete the process.


**Agent reinstalls automatically**<br>
Review policies, automation pipelines, and ARM templates to ensure the Dependency Agent isn't included in deployment scripts.

**Permission Issues**<br>
Make sure your Azure account has sufficient rights to remove extensions from VMs or VMSS resources.


## Related content

* Learn more about the [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md).
* Learn more about [data collection rules](../data-collection/data-collection-rule-overview.md).

