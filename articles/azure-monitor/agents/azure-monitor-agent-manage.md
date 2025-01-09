---
title: Install and Manage the Azure Monitor Agent
description: Options for installing and managing the Azure Monitor Agent on Azure virtual machines and Azure Arc-enabled servers.
ms.topic: conceptual
author: guywi-ms
ms.author: guywild
ms.date: 11/14/2024
ms.custom: devx-track-azurepowershell, devx-track-azurecli
ms.reviewer: jeffwo

---

# Install and manage the Azure Monitor Agent

This article details the different methods to install, uninstall, update, and configure [Azure Monitor Agent](azure-monitor-agent-overview.md) on Azure virtual machines, scale sets, and Azure Arc-enabled servers.

> [!IMPORTANT]
> The Azure Monitor Agent requires at least one data collection rule (DCR) to begin collecting data after it's installed on the client machine. Your installation method determines whether a DCR is automatically created. If it isn't automatically created, configure data collection by following the guidance in [Collect data with the Azure Monitor Agent](./azure-monitor-agent-data-collection.md).

## Prerequisites

See the following articles for prerequisites and other requirements for the Azure Monitor Agent:

* [Azure Monitor Agent supported operating systems and environments](./azure-monitor-agent-supported-operating-systems.md)
* [Azure Monitor Agent requirements](./azure-monitor-agent-requirements.md)
* [Azure Monitor Agent network configuration](./azure-monitor-agent-network-configuration.md)

> [!IMPORTANT]
> Installing, upgrading, or uninstalling the Azure Monitor Agent doesn't require a machine restart.

## Installation options

The following table lists the different options for installing the Azure Monitor Agent on Azure VMs and Azure Arc-enabled servers. The [Azure Arc agent](/azure/azure-arc/servers/deployment-options) must be installed on any machines not in Azure before the Azure Monitor Agent can be installed.

| Installation method | Description |
|:---|:---|
| VM extension | Use any of the methods below to use the Azure extension framework to install the agent. This method does not create a DCR, so you must create at least one DCR and associate it with the agent before data collection begins. |
| [Create a DCR](./azure-monitor-agent-data-collection.md) | When you create a DCR in the Azure portal, the Azure Monitor Agent is installed on any machines that are added as resources for the DCR. The agent will begin collecting data defined in the DCR immediately.
| [VM insights](../vm/vminsights-enable-overview.md) | When you enable VM insights on a machine, the Azure Monitor Agent is installed, and a DCR is created that collects a predefined set of data. You shouldn't modify this DCR, but you can create additional DCRs to collect other data. |
| [Container insights](../containers/kubernetes-monitoring-enable.md#container-insights) | When you enable Container insights on a Kubernetes cluster, a containerized version of the Azure Monitor Agent is installed in the cluster, and a DCR is created that immediately begins collecting data. You can modify this DCR by using guidance at [Configure data collection and cost optimization in Container insights by using data collection rule](../containers/container-insights-data-collection-dcr.md).
| [Client installer](./azure-monitor-agent-windows-client.md) | Installs the agent by using a Windows MSI installer for Windows 10 and Windows 11 clients. |
| [Azure Policy](./azure-monitor-agent-policy.md) | Use Azure Policy to automatically install the agent on Azure virtual machines and Azure Arc-enabled servers, and to automatically associate them with required DCRs. |

> [!NOTE]
>
> * To send data across tenants, you must first enable [Azure Lighthouse](/azure/lighthouse/overview).
>
> * Cloning a machine with Azure Monitor Agent installed is not supported. The best practice for these situations is to use [Azure Policy](/azure/azure-arc/servers/deploy-ama-policy) or an Infrastructure as a code tool to deploy AMA at scale.

## Install agent extension

This section provides details on installing the Azure Monitor Agent by using the VM extension.

### [Azure portal](#tab/azure-portal)

Use the guidance at [Collect data with the Azure Monitor Agent](./azure-monitor-agent-data-collection.md) to install the agent by using the Azure portal and create a DCR to collect data.

### [Azure PowerShell](#tab/azure-powershell)

You can install the Azure Monitor Agent on an Azure virtual machine and on an Azure Arc-enabled server by using the PowerShell command for adding a virtual machine extension.

### Azure virtual machines

Use the following PowerShell commands to install the Azure Monitor Agent on an Azure virtual machine. Choose the appropriate command based on your chosen authentication method.

* Windows

    ```powershell
    ## User-assigned managed identity
    Set-AzVMExtension -Name AzureMonitorWindowsAgent -ExtensionType AzureMonitorWindowsAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName <resource-group-name> -VMName <virtual-machine-name> -Location <location> -TypeHandlerVersion <version-number> -EnableAutomaticUpgrade $true -SettingString '{"authentication":{"managedIdentity":{"identifier-name":"mi_res_id","identifier-value":"/subscriptions/<my-subscription-id>/resourceGroups/<my-resource-group>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<my-user-assigned-identity>"}}}'
    
    ## System-assigned managed identity
    Set-AzVMExtension -Name AzureMonitorWindowsAgent -ExtensionType AzureMonitorWindowsAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName <resource-group-name> -VMName <virtual-machine-name> -Location <location> -TypeHandlerVersion <version-number> -EnableAutomaticUpgrade $true
    ```

* Linux

    ```powershell
    ## User-assigned managed identity
    Set-AzVMExtension -Name AzureMonitorLinuxAgent -ExtensionType AzureMonitorLinuxAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName <resource-group-name> -VMName <virtual-machine-name> -Location <location> -TypeHandlerVersion <version-number> -EnableAutomaticUpgrade $true -SettingString '{"authentication":{"managedIdentity":{"identifier-name":"mi_res_id","identifier-value":/subscriptions/<my-subscription-id>/resourceGroups/<my-resource-group>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<my-user-assigned-identity>"}}}'
    
    ## System-assigned managed identity
    Set-AzVMExtension -Name AzureMonitorLinuxAgent -ExtensionType AzureMonitorLinuxAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName <resource-group-name> -VMName <virtual-machine-name> -Location <location> -TypeHandlerVersion <version-number> -EnableAutomaticUpgrade $true
    ```

### Azure virtual machines scale set

Use the [Add-AzVmssExtension](/powershell/module/az.compute/add-azvmssextension) PowerShell cmdlet to install the Azure Monitor Agent on an Azure virtual machines scale set.

### Azure Arc-enabled servers

Use the following PowerShell commands to install the Azure Monitor Agent on an Azure Arc-enabled server.

* Windows

    ```powershell
    New-AzConnectedMachineExtension -Name AzureMonitorWindowsAgent -ExtensionType AzureMonitorWindowsAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName <resource-group-name> -MachineName <arc-server-name> -Location <arc-server-location> -EnableAutomaticUpgrade
    ```

* Linux

    ```powershell
    New-AzConnectedMachineExtension -Name AzureMonitorLinuxAgent -ExtensionType AzureMonitorLinuxAgent -Publisher Microsoft.Azure.Monitor -ResourceGroupName <resource-group-name> -MachineName <arc-server-name> -Location <arc-server-location> -EnableAutomaticUpgrade
    ```

#### [Azure CLI](#tab/azure-cli)

You can install the Azure Monitor Agent on an Azure virtual machine and on an Azure Arc-enabled server by using the Azure CLI command for adding a virtual machine extension.

### Azure virtual machines

Use the following Azure CLI commands to install the Azure Monitor Agent on an Azure virtual machine. Choose the appropriate command based on your chosen authentication method.

#### User-assigned managed identity

* Windows

    ```azurecli
    az vm extension set --name AzureMonitorWindowsAgent --publisher Microsoft.Azure.Monitor --ids <vm-resource-id> --enable-auto-upgrade true --settings '{"authentication":{"managedIdentity":{"identifier-name":"mi_res_id","identifier-value":"/subscriptions/<my-subscription-id>/resourceGroups/<my-resource-group>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<my-user-assigned-identity>"}}}'
    ```

* Linux

    ```azurecli
    az vm extension set --name AzureMonitorLinuxAgent --publisher Microsoft.Azure.Monitor --ids <vm-resource-id> --enable-auto-upgrade true --settings '{"authentication":{"managedIdentity":{"identifier-name":"mi_res_id","identifier-value":"/subscriptions/<my-subscription-id>/resourceGroups/<my-resource-group>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<my-user-assigned-identity>"}}}'
    ```

#### System-assigned managed identity

* Windows

    ```azurecli
    az vm extension set --name AzureMonitorWindowsAgent --publisher Microsoft.Azure.Monitor --ids <vm-resource-id> --enable-auto-upgrade true
    ```

* Linux

    ```azurecli
    az vm extension set --name AzureMonitorLinuxAgent --publisher Microsoft.Azure.Monitor --ids <vm-resource-id> --enable-auto-upgrade true
    ```

### Azure virtual machines scale set

Use the [az vmss extension set](/cli/azure/vmss/extension) Azure CLI cmdlet to install the Azure Monitor Agent on an Azure virtual machines scale set.

### Azure Arc-enabled servers

Use the following CLI commands to install the Azure Monitor Agent on an Azure Arc-enabled server.

* Windows

    ```azurecli
    az connectedmachine extension create --name AzureMonitorWindowsAgent --publisher Microsoft.Azure.Monitor --type AzureMonitorWindowsAgent --machine-name <arc-server-name> --resource-group <resource-group-name> --location <arc-server-location> --enable-auto-upgrade true
    ```

* Linux

    ```azurecli
    az connectedmachine extension create --name AzureMonitorLinuxAgent --publisher Microsoft.Azure.Monitor --type AzureMonitorLinuxAgent --machine-name <arc-server-name> --resource-group <resource-group-name> --location <arc-server-location> --enable-auto-upgrade true
    ```

#### [Resource Manager template](#tab/azure-resource-manager)

You can use Resource Manager templates to install the Azure Monitor Agent on Azure virtual machines and Azure Arc-enabled servers, and to create an association with data collection rules. You must create any data collection rule before you create the association.

Get sample templates for installing the agent and for creating the association from the following resources:

* [Template to install the Azure Monitor Agent (Azure and Azure Arc)](../agents/resource-manager-agent.md#azure-monitor-agent)
* [Template to create association with data collection rule](../essentials/data-collection-rule-associations.md#create-new-association)

Install the templates by using [any deployment method for Resource Manager templates](/azure/azure-resource-manager/templates/deploy-powershell), such as the following commands.

* PowerShell

    ```powershell
    New-AzResourceGroupDeployment -ResourceGroupName "<resource-group-name>" -TemplateFile "<template-filename.json>" -TemplateParameterFile "<parameter-filename.json>"
    ```

* Azure CLI

    ```azurecli
    az deployment group create --resource-group "<resource-group-name>" --template-file "<path-to-template>" --parameters "@<parameter-filename.json>"
    ```

---

## Uninstall

#### [Azure portal](#tab/azure-portal)

To uninstall the Azure Monitor Agent by using the Azure portal, go to your virtual machine, scale set or your Azure Arc-enabled server. Select the **Extensions** tab, and then select **AzureMonitorWindowsAgent** or **AzureMonitorLinuxAgent**. In the dialog that opens, select **Uninstall**.

#### [Azure PowerShell](#tab/azure-powershell)

### Uninstall on an Azure virtual machine

Use the following PowerShell commands to uninstall the Azure Monitor Agent on an Azure virtual machine.

* Windows

    ```powershell
    Remove-AzVMExtension -Name AzureMonitorWindowsAgent -ResourceGroupName <resource-group-name> -VMName <virtual-machine-name> 
    ```

* Linux

    ```powershell
    Remove-AzVMExtension -Name AzureMonitorLinuxAgent -ResourceGroupName <resource-group-name> -VMName <virtual-machine-name> 
    ```

### Uninstall on an Azure virtual machines scale set

Use the [Remove-AzVmssExtension](/powershell/module/az.compute/remove-azvmssextension) PowerShell cmdlet to uninstall the Azure Monitor Agent on an Azure virtual machine scale set.

### Uninstall on an Azure Arc-enabled server

Use the following PowerShell commands to uninstall the Azure Monitor Agent on an Azure Arc-enabled server.

* Windows

    ```powershell
    Remove-AzConnectedMachineExtension -MachineName <arc-server-name> -ResourceGroupName <resource-group-name> -Name AzureMonitorWindowsAgent
    ```

* Linux

    ```powershell
    Remove-AzConnectedMachineExtension -MachineName <arc-server-name> -ResourceGroupName <resource-group-name> -Name AzureMonitorLinuxAgent
    ```

#### [Azure CLI](#tab/azure-cli)

### Uninstall on an Azure virtual machine

Use the following CLI commands to uninstall the Azure Monitor Agent on an Azure virtual machine.

* Windows

    ```azurecli
    az vm extension delete --resource-group <resource-group-name> --vm-name <virtual-machine-name> --name AzureMonitorWindowsAgent
    ```

* Linux

    ```azurecli
    az vm extension delete --resource-group <resource-group-name> --vm-name <virtual-machine-name> --name AzureMonitorLinuxAgent
    ```

### Uninstall on an Azure virtual machine scale set

Use the [az vmss extension delete](/cli/azure/vmss/extension) Azure CLI cmdlet to uninstall the Azure Monitor Agent on a Azure virtual machine scale set.

### Uninstall on an Azure Arc-enabled server

Use the following CLI commands to uninstall the Azure Monitor Agent on an Azure Arc-enabled server.

* Windows

    ```azurecli
    az connectedmachine extension delete --name AzureMonitorWindowsAgent --machine-name <arc-server-name> --resource-group <resource-group-name>
    ```

* Linux

    ```azurecli
    az connectedmachine extension delete --name AzureMonitorLinuxAgent --machine-name <arc-server-name> --resource-group <resource-group-name>
    ```

#### [Resource Manager template](#tab/azure-resource-manager)

N/A

---

## Update

> [!NOTE]
> We strongly recommend that you always update to the latest version or opt in to [automatic extension upgrade](/azure/virtual-machines/automatic-extension-upgrade).
>
> Automatic extension rollout follows standard Azure deployment practices to safely deploy the latest version of the agent. You should expect automatic updates to take weeks to roll out the latest version.
>
> Upgrades are issued in batches, so some of your virtual machines, virtual machine scale sets, or Azure Arc-enabled servers might be upgraded before others.
>
> If you need to upgrade an extension immediately, you can use the manual instructions that are described in this article. Only agents released in the last year are supported.

#### [Portal](#tab/azure-portal)

To do a one-time update of the agent, you must first uninstall the existing agent version. Then install the new version as described.

We recommend that you enable automatic update of the agent by enabling [automatic extension upgrade](/azure/virtual-machines/automatic-extension-upgrade). Go to your virtual machine or scale set, select the **Extensions** tab, and then select **AzureMonitorWindowsAgent** or **AzureMonitorLinuxAgent**. In the dialog that opens, select **Enable automatic upgrade**.

#### [PowerShell](#tab/azure-powershell)

### Update on Azure virtual machines

To do a one-time update of the agent, you must first uninstall the existing agent version. Then install the new version as described.

We recommend that you enable automatic update of the agent by enabling [automatic extension upgrade](/azure/virtual-machines/automatic-extension-upgrade). Use the following PowerShell commands.

* Windows

    ```powershell
    Set-AzVMExtension -ExtensionName AzureMonitorWindowsAgent -ResourceGroupName <resource-group-name> -VMName <virtual-machine-name> -Publisher Microsoft.Azure.Monitor -ExtensionType AzureMonitorWindowsAgent -TypeHandlerVersion <version-number> -Location <location> -EnableAutomaticUpgrade $true
    ```

* Linux

    ```powershell
    Set-AzVMExtension -ExtensionName AzureMonitorLinuxAgent -ResourceGroupName <resource-group-name> -VMName <virtual-machine-name> -Publisher Microsoft.Azure.Monitor -ExtensionType AzureMonitorLinuxAgent -TypeHandlerVersion <version-number> -Location <location> -EnableAutomaticUpgrade $true
    ```

### Update on Azure Arc-enabled servers

To do a one-time upgrade of the agent, use the following PowerShell commands.

* Windows

    ```powershell
    $target = @{"Microsoft.Azure.Monitor.AzureMonitorWindowsAgent" = @{"targetVersion"=<target-version-number>}}
    Update-AzConnectedExtension -ResourceGroupName $env.ResourceGroupName -MachineName <arc-server-name> -ExtensionTarget $target
    ```

* Linux

    ```powershell
    $target = @{"Microsoft.Azure.Monitor.AzureMonitorLinuxAgent" = @{"targetVersion"=<target-version-number>}}
    Update-AzConnectedExtension -ResourceGroupName $env.ResourceGroupName -MachineName <arc-server-name> -ExtensionTarget $target
    ```

We recommend that you enable automatic update of the agent by enabling the [automatic extension upgrade](/azure/azure-arc/servers/manage-automatic-vm-extension-upgrade#manage-automatic-extension-upgrade). Use the following PowerShell commands.

* Windows

    ```powershell
    Update-AzConnectedMachineExtension -ResourceGroup <resource-group-name> -MachineName <arc-server-name> -Name AzureMonitorWindowsAgent -EnableAutomaticUpgrade
    ```

* Linux

    ```powershell
    Update-AzConnectedMachineExtension -ResourceGroup <resource-group-name> -MachineName <arc-server-name> -Name AzureMonitorLinuxAgent -EnableAutomaticUpgrade
    ```

#### [Azure CLI](#tab/azure-cli)

### Update on Azure virtual machines

To do a one-time update of the agent, you must first uninstall the existing agent version. Then install the new version as described.
  
We recommend that you enable automatic update of the agent by enabling the [automatic extension upgrade](/azure/virtual-machines/automatic-extension-upgrade) feature by using the following Azure CLI commands.

* Windows

    ```azurecli
    az vm extension set --name AzureMonitorWindowsAgent --publisher Microsoft.Azure.Monitor --vm-name <virtual-machine-name> --resource-group <resource-group-name> --enable-auto-upgrade true
    ```

* Linux

    ```azurecli
    az vm extension set --name AzureMonitorLinuxAgent --publisher Microsoft.Azure.Monitor --vm-name <virtual-machine-name> --resource-group <resource-group-name> --enable-auto-upgrade true
    ```

### Update on Azure Arc-enabled servers

To do a one-time upgrade of the agent, use the following Azure CLI commands.

* Windows

    ```azurecli
    az connectedmachine upgrade-extension --extension-targets "{\"Microsoft.Azure.Monitor.AzureMonitorWindowsAgent\":{\"targetVersion\":\"<target-version-number>\"}}" --machine-name <arc-server-name> --resource-group <resource-group-name>
    ```

* Linux

    ```azurecli
    az connectedmachine upgrade-extension --extension-targets "{\"Microsoft.Azure.Monitor.AzureMonitorLinuxAgent\":{\"targetVersion\":\"<target-version-number>\"}}" --machine-name <arc-server-name> --resource-group <resource-group-name>
    ```
  
 We recommend that you enable automatic update of the agent by enabling the [automatic extension upgrade](/azure/azure-arc/servers/manage-automatic-vm-extension-upgrade#manage-automatic-extension-upgrade). Use the following PowerShell commands.

* Windows

    ```azurecli
    az connectedmachine extension update --name AzureMonitorWindowsAgent --machine-name <arc-server-name> --resource-group <resource-group-name> --enable-auto-upgrade true
    ```

* Linux

    ```azurecli
    az connectedmachine extension update --name AzureMonitorLinuxAgent --machine-name <arc-server-name> --resource-group <resource-group-name> --enable-auto-upgrade true
    ```

#### [Resource Manager template](#tab/azure-resource-manager)

N/A

---

## Configure (preview)

[Data collection rules (DCRs)](../essentials/data-collection-rule-overview.md) serve as a management tool for the Azure Monitor Agent on your machine. The AgentSettings DCR can be used to configure certain Azure Monitor Agent parameters to configure the agent to your specific monitoring needs.

> [!NOTE]
> Important considerations to keep in mind when you work with the AgentSettings DCR:
>
> * The AgentSettings DCR can currently be configured only by using ARM templates.
> * AgentSettings must be a single DCR with no other settings.
> * The virtual machine and the AgentSettings DCR must be located in the same region.

### Supported parameters

The AgentSettings DCR currently supports setting the following parameters:

| Parameter | Description | Valid values |
| --------- | ----------- | ----------- |
| `MaxDiskQuotaInMB` | To provide resiliency, the agent collects data in a local cache when the agent can't send data. The agent sends the data in the cache after the connection is restored. This parameter is the amount of disk space used (in MB) by the Azure Monitor Agent log files and cache. | Linux: `1025` to `51199`<br>Windows: `4000` to `51199` |
| `UseTimeReceivedForForwardedEvents` | Changes the **WEF** column in the Microsoft Sentinel Windows Event Forwarding (WEF) table to use `TimeReceived` instead of `TimeGenerated` data | `0` or `1` |

### Set up the AgentSettings DCR

#### [Azure portal](#tab/azure-portal)

Currently not supported.

#### Azure PowerShell](#tab/azure-powershell)

Currently not supported.

#### [Azure CLI](#tab/azure-cli)

Currently not supported.

#### [Resource Manager template](#tab/azure-resource-manager)

1. **Prepare the environment**.

    [Install the Azure Monitor Agent](#installation-options) on your VM.

1. **Create a DCR**.

    This example sets the maximum amount of disk space used by the Azure Monitor Agent cache to 5,000 MB.

    ```json
    {
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {},
    "resources": [
        {
        "type": "Microsoft.Insights/dataCollectionRules",
        "name": "dcr-contoso-01",
        "apiVersion": "2023-03-11",
        "properties": 
            {
            "description": "A simple agent settings",
            "agentSettings": 
                {
                "logs": [
                    {
                    "name": "MaxDiskQuotaInMB",
                    "value": "5000"
                    }
                ]
                }
            },
        "kind": "AgentSettings",
        "location": "eastus"
        }
    ]
    }
    ```

1. **Associate the DCR with your machine**.

   Use these ARM template and parameter files.

    *ARM template file*

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
          "name": "agentSettings",
          "properties": {
            "description": "Association of data collection rule. Deleting this association will break the data collection for this virtual machine.",
            "dataCollectionRuleId": "[parameters('dataCollectionRuleId')]"
          }
        }
      ]
    }
    ```

    *Parameter file*

    ```json
    {
      "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
      "contentVersion": "1.0.0.0",
      "parameters": {
        "vmName": {
          "value": "my-azure-vm"
        },
        "dataCollectionRuleId": {
          "value": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/my-resource-group/providers/microsoft.insights/datacollectionrules/my-dcr"
        }
       }
    }
    ```

1. **Activate the settings**.

    Restart the Azure Monitor Agent to apply the changes.

---

## Related content

[Create a data collection rule](./azure-monitor-agent-data-collection.md) to collect data from the agent and send it to Azure Monitor.
