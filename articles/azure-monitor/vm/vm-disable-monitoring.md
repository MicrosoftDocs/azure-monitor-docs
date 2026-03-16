---
title: Disable VM monitoring in Azure Monitor
description: This article describes how to stop monitoring your virtual machines in Azure Monitor.
ms.topic: how-to
ms.date: 03/12/2026
---

# Disable monitoring of your VMs in Azure Monitor

This article describes how to disable monitoring for a virtual machine in Azure Monitor, whether to remove monitoring entirely or to disable collection of certain data.

## Remove DCR associations
As described in [Enable VM monitoring in Azure Monitor](./vm-enable-monitoring.md#overview), data collection is enabled by an association between the VM and a data collection rule (DCR). You can stop data collection from one or more DCRs by removing their association with the VM. While multiple machines can use a common DCR, each has a separate DCR association. 

### [Azure portal](#tab/portal)

See [View and modify associations for a DCR in the Azure portal](../data-collection/data-collection-rule-associations.md#view-and-modify-associations-for-a-dcr-in-the-azure-portal) for details on how to remove a DCR association with the Azure portal. Use the preview DCR experience to list the DCR associations for the VM and remove the association for any DCRs that you want to disable for the VM.

### [CLI](#tab/cli)

Get the DCR association name with the `az monitor data-collection rule association list` command and then use it with the `az monitor data-collection rule association delete` as in the following example.

```azurecli
dcraName=$(az monitor data-collection rule association list \
    --resource "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>" \
    --query "[?dataCollectionRuleId=='/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/microsoft.insights/datacollectionrules/<dcr-name>'].name | [0]" -o tsv)
az monitor data-collection rule association delete \
    --resource "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>" \
    --name $dcraName
```

### [PowerShell](#tab/powershell)

Get the DCR association name with the `Get-AzDataCollectionRuleAssociation` cmdlet and then use it with the `Remove-AzDataCollectionRuleAssociation` cmdlet as in the following example.

```powershell
$dcraName = (Get-AzDataCollectionRuleAssociation -TargetResourceId "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>" | where {$_.DataCollectionRuleId -eq "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/microsoft.insights/datacollectionrules/<dcr-name>"}).Name
remove-AzDataCollectionRuleAssociation -TargetResourceId "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Compute/virtualMachines/<vm-name>" -AssociationName $dcraName   
```
---

## Remove agents
Only remove the Azure Monitor agent if you're no longer using it for any other monitoring purposes. Removing the agent completely disables all monitoring of the client operating system and workloads. Remove the Dependency agent from the VM if you're no longer using the deprecated Map feature.

- See [Uninstall Azure Monitor Agent](../agents/azure-monitor-agent-manage.md#uninstall).
- See [Uninstall Dependency Agent](./vminsights-dependency-agent.md#uninstall-dependency-agent).


## Remove VM insights solution
VM insights using the Log Analytics agent (deprecated) required a solution added to the Log Analytics workspace. This solution is no longer required for Azure Monitor agent. Remove this solution if you no longer use the deprecated agent. If you never used the Log Analytics agent, this solution won't exist in your workspace.

1. From your Log Analytics workspace in the Azure portal, select **Legacy solutions** from the left menu.
2. In the list of solutions, select **VMInsights(workspace name)**. On the **Overview** page for the solution, select **Delete**.

## Related content

- [Enable VM monitoring in Azure Monitor](vm-enable-monitoring.md) - Re-enable monitoring when needed
- [Monitor virtual machines in Azure](monitor-vm.md) - Overview of VM monitoring capabilities
- [Data collection rules in Azure Monitor](../data-collection/data-collection-rule-overview.md) - Understand data collection rules and associations
- [Azure Monitor Agent overview](../agents/azure-monitor-agent-overview.md) - Learn about the Azure Monitor agent


