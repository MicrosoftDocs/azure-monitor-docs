---
title: Disable VM monitoring in Azure Monitor
description: This article describes how to stop monitoring your virtual machines in Azure Monitor.
ms.topic: how-to
ms.date: 03/12/2026
---

# Disable monitoring of your VMs in Azure Monitor

This article describes how to disable monitoring for a virtual machine in Azure Monitor. This may be to remove monitoring entirely or to disable collection of certain data.

## Remove DCR associations
As described in [Enable VM monitoring in Azure Monitor](./vm-enable-monitoring.md#overview), data collection is enabled by an association between the VM and a DCR. You can stop data collection from one or more DCRs by removing their association with the VM. While multiple machines can use a common DCR, they will each have a separate DCR association. 

### [Azure portal](#tab/portal)

### Remove DCR association with the Azure portal
See [View and modify associations for a DCR in the Azure portal](../data-collection/data-collection-rule-associations.md#view-and-modify-associations-for-a-dcr-in-the-azure-portal) for details on how to remove a DCR association with the Azure portal. Use the preview DCR experience to list the DCR associations for the VM and remove the association for any DCRs that you want to disable for the VM.

### [CLI](#tab/cli)

### Remove DCR association with CLI

Get the DCR association name with the `Get-AzDataCollectionRuleAssociation` cmdlet and then use it with the `Remove-AzDataCollectionRuleAssociation` cmdlet as in the following example.

```azurecli
dcraName=$(az monitor data-collection rule association list --resource "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Compute/virtualMachines/my-vm" --query "[?dataCollectionRuleId=='/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionRules/MSVMI-DefaultWorkspace'].name" -o tsv)
az monitor data-collection rule association delete --resource "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Compute/virtualMachines/my-vm" --name $dcraName
```

### [PowerShell](#tab/powershell)

### Remove DCR association with PowerShell

Get the DCR association name with the `Get-AzDataCollectionRuleAssociation` cmdlet and then use it with the `Remove-AzDataCollectionRuleAssociation` cmdlet as in the following example.

```powershell
$dcraName = (Get-AzDataCollectionRuleAssociation -TargetResourceId "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Compute/virtualMachines/my-vm" | where {$_.DataCollectionRuleId -eq "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionRules/MSVMI-DefaultWorkspace"}).Name
remove-AzDataCollectionRuleAssociation -TargetResourceId "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Compute/virtualMachines/my-vm" -AssociationName $dcraName   
```
---

## Remove agents
Only remove the Azure Monitor agent if you're no longer using it for any other monitoring purposes. This will completely disable all monitoring of the client operating system and workloads. Remove the Dependency agent from the VM if your no longer using the deprecated Map feature. 

- See [Uninstall Azure Monitor Agent](../agents/azure-monitor-agent-manage.md#uninstall).
- See [Uninstall Dependency Agent](./vminsights-dependency-agent.md#uninstall-dependency-agent).


## Remove VM insights solution
VM insights using the Log Analytics agent (deprecated) required a solution added to the Log Analytics workspace that's no longer required for Azure Monitor agent. You can remove this solution if you no longer use the deprecated agent. 

1. From your Log Analytics workspace in the Azure portal, select **Legacy solutions** from the left menu.
1. In the list of solutions, select **VMInsights(workspace name)**. On the **Overview** page for the solution, select **Delete**.


