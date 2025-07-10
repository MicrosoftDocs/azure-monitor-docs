---
title: Disable monitoring in VM insights
description: This article describes how to stop monitoring your virtual machines in VM insights.
ms.topic: how-to
ms.date: 10/30/2024
---

# Disable monitoring of your VMs in VM insights

This article describes how to disable VM insights monitoring for your monitored virtual machines. 

## VM insights components
The following steps are completed when you enable VM insights on a virtual machine. Depending on how you [onboarded the machine](./vminsights-enable.md), you may have performed all of these steps individually or had them performed for you. Each of these steps needs to be reversed for complete removal of VM insights monitoring, but you may want to leave some in place depending on your requirements.

- The Azure Monitor agent is installed on the VM if it's not already installed.
- The Dependency agent is installed on the VM if you choose to collect processes and dependencies using the VM insights Map feature.
- A new VM insights DCR is created unless you specify an existing VM insights DCR.
- A DCR association is created between the VM and the DCR.

## Remove DCR association
You can disable VM insights for a single machine by simply removing the DCR association between that VM and the VM insights DCR. This leaves the agents installed on the VM and the VM insights DCR intact, but it stops the collection of all VM insights data from the VM.  While multiple machines can use a common DCR, they will each have a separate DCR association. 

### [Azure portal](#tab/portal)

### Remove DCR association with the Azure portal
If you disable VM insights monitoring from the Azure portal, it will remove the DCR association but leave the agents and VM insights DCR intact.

1. From the **Monitored** tab in VM insights, click **Enabled** next to the VM you want to disable.

    :::image type="content" source="media/vminsights-optout/monitored-vms.png" lightbox="media/vminsights-optout/monitored-vms.png" alt-text="Screenshot that shows the list of VMs monitored by VM insights with the enable option.":::

2. Select **Off** next to the **VM Insights** option and click **Configure**.

    :::image type="content" source="media/vminsights-optout/disable-vminsights.png" lightbox="media/vminsights-optout/disable-vminsights.png" alt-text="Screenshot that shows the option to disable VM insights.":::

### [CLI](#tab/cli)

### Remove DCR association with the CLI

Get the DCR association name with the `Get-AzDataCollectionRuleAssociation` cmdlet and then use it with the `Remove-AzDataCollectionRuleAssociation` cmdlet as in the following example.

```azurecli
dcrName=$(az monitor data-collection rule association list --resource "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Compute/virtualMachines/my-vm" --query "[?dataCollectionRuleId=='/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionRules/MSVMI-DefaultWorkspace'].name" -o tsv)
az monitor data-collection rule association delete --resource "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Compute/virtualMachines/my-vm" --name $dcrName
```

### [PowerShell](#tab/powershell)

### Remove DCR association with PowerShell

Get the DCR association name with the `Get-AzDataCollectionRuleAssociation` cmdlet and then use it with the `Remove-AzDataCollectionRuleAssociation` cmdlet as in the following example.

```powershell
$dcraName = (Get-AzDataCollectionRuleAssociation -TargetResourceId "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Compute/virtualMachines/my-vm" | where {$_.DataCollectionRuleId -eq "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionRules/MSVMI-DefaultWorkspace"}).Name
remove-AzDataCollectionRuleAssociation -TargetResourceId "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Compute/virtualMachines/my-vm" -AssociationName $dcraName   
```
---

## Remove VM insights DCR
If there are no associations with the VM insights DCR, then it doesn't need to be removed since it won't be affecting any VMs. Be careful to not remove this DCR if there are any existing associations, since that will cause those VMs to stop monitoring.

### [Azure portal](#tab/portal)

### Remove VM insights DCR association with the Azure portal

Select the **Delete** option from the DCR in the **Monitor** menu.

:::image type="content" source="media/vminsights-optout/dcr-delete.png" lightbox="media/vminsights-optout/dcr-delete.png" alt-text="Screenshot that shows dialog box to disable VM insights for a VM.":::

### [CLI](#tab/cli)

### Remove VM insights DCR association with CLI

Remove the VM insights DCR with the `az monitor data-collection rule delete` command as in the following example.

```azurecli
az monitor data-collection rule delete --name MSVI-DefaultWorkspace --resource-group my-resource-group
```

### [PowerShell](#tab/powershell)

### Remove VM insights DCR association with PowerShell

Remove the VM insights DCR with the `Remove-AzDataCollectionRule` command as in the following example.

```powershell
Remove-AzDataCollectionRule -Name MSVI-DefaultWorkspace -ResourceGroupName my-resource-group
```
---

## Remove agents
You should remove the Dependency agent from the VM if the VM is no longer using VM insights. Only remove the Azure Monitor agent if you're no longer using it for any other monitoring purposes. 

- See [Uninstall Azure Monitor Agent](../agents/azure-monitor-agent-manage.md#uninstall) for options to remove the Azure Monitor agent.
- See [Uninstall Dependency Agent](./vminsights-dependency-agent.md#uninstall-dependency-agent) for options to removing the Dependency agent.



## Remove VM insights with Log Analytics agent (legacy)

> [!IMPORTANT]
> This section describes how to disable monitoring of your virtual machines in VM insights if you enabled it using the deprecated [Log Analytics agent](../agents/log-analytics-agent.md). This required a solution being added to the Log Analytics workspace that's no longer required for Azure Monitor agent.

VM insights doesn't support selective disabling of VM monitoring with Log Analytics agent. Your Log Analytics workspace might support VM insights and other solutions. It might also collect other monitoring data. If your Log Analytics workspace provides these services, you need to understand the effect and methods of disabling monitoring before you start.

VM insights relies on the following components to deliver its experience:

* A Log Analytics workspace, which stores monitoring data from VMs and other sources.
* A collection of performance counters configured in the workspace. The collection updates the monitoring configuration on all VMs connected to the workspace.
* The `VMInsights` monitoring solution is configured in the workspace. This solution updates the monitoring configuration on all VMs connected to the workspace.
* Azure VM extensions `MicrosoftMonitoringAgent` (for Windows) or `OmsAgentForLinux` (for Linux) and `DependencyAgent`. These extensions collect and send data to the workspace.

As you prepare to disable monitoring of your VMs, keep these considerations in mind:

* If you evaluated with a single VM and used the preselected default Log Analytics workspace, you can disable monitoring by uninstalling the Dependency agent from the VM and disconnecting the Log Analytics agent from this workspace. This approach is appropriate if you intend to use the VM for other purposes and decide later to reconnect it to a different workspace.
* If you selected a preexisting Log Analytics workspace that supports other monitoring solutions and data collection from other sources, you can remove solution components from the workspace without interrupting or affecting your workspace.

>[!NOTE]
> After you remove the solution components from your workspace, you might continue to see performance and map data for your Azure VMs. Data eventually stops appearing in the **Performance** and **Map** views. The **Enable** option is available from the selected Azure VM so that you can reenable monitoring in the future.

## Remove VM insights completely

If you still need the Log Analytics workspace, you can remove the `VMInsights` solution from the workspace.

1. Sign in to the [Azure portal](https://portal.azure.com).
1. In the Azure portal, select **All services**. In the list of resources, enter **Log Analytics**. As you begin typing, the list filters suggestions based on your input. Select **Log Analytics**.
1. In your list of Log Analytics workspaces, select the workspace you chose when you enabled VM insights.
1. On the left, select **Legacy solutions**.
1. In the list of solutions, select **VMInsights(workspace name)**. On the **Overview** page for the solution, select **Delete**. When you're prompted to confirm, select **Yes**.

## Disable monitoring and keep the workspace

If your Log Analytics workspace still needs to support monitoring from other sources, you can disable monitoring on the VM that you used to evaluate VM insights. For Azure VMs, you remove the dependency agent VM extension and the Log Analytics agent VM extension for Windows or Linux directly from the VM.

>[!NOTE]
>Don't remove the Log Analytics agent if:
>
> * Azure Automation manages the VM to orchestrate processes or to manage configuration or updates.
> * Microsoft Defender for Cloud manages the VM for security and threat detection.
>
> If you do remove the Log Analytics agent, you'll prevent those services and solutions from proactively managing your VM.

1. Sign in to the [Azure portal](https://portal.azure.com).
1. In the Azure portal, select **Virtual Machines**.
1. From the list, select a VM.
1. On the left, select **Extensions**. On the **Extensions** page, select **DependencyAgent**.
1. On the extension properties page, select **Uninstall**.
1. On the **Extensions** page, select **MicrosoftMonitoringAgent**. On the extension properties page, select **Uninstall**.
