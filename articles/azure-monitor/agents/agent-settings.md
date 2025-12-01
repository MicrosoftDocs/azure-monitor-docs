---
title: Azure Monitor Agent Configuration
description: Learn options for changing Azure Monitor Agent configurations.
ms.topic: install-set-up-deploy
ms.date: 11/11/2025
ms.custom: devx-track-azurepowershell, devx-track-azurecli
ms.reviewer: jeffwo

---

# Configure agents with Azure Monitor Agent settings

This article describes how to configure the [Azure Monitor Agent](azure-monitor-agent-overview.md) on Azure Virtual Machines (VM), Virtual Machine Scale Sets, and Azure Arc-enabled servers. Many of your applications and services log telemetry by using the Azure Monitor Agent. You can configure Azure Monitor Agents by using the central control plane and creating the Agent Settings Data Collection Rule (DCR).

## Prerequisites

Prerequisites are listed in [Collect data from virtual machine client with Azure Monitor](../vm/data-collection.md#prerequisites).

## Considerations

When you work with the Agent Settings DCR:

* Currently, an Azure Resource Manager template is the only way to create Agent Settings.
* Agent Settings is a standalone DCR with no other collection sources.
* The virtual machine and the Agent Settings DCR must be in the same region.
* The most recent Agent Settings DCR applied to the VM overrides all other Agent Settings DCRs.

### Supported parameters

The Agent Settings DCR supports the following parameters:

| Parameter | Description | Valid values |
| --------- | ----------- | ----------- |
| MaxDiskQuotaInMB | Disk space (in MB) used by the Azure Monitor Agent's local cache. The cache grows if cloud connectivity is lost, and data is sent once reconnected. Data exceeding the cache limit is lost. | 4,000 to 1,000,000 <br> Default is 10,000|
| UseTimeReceivedForForwardedEvents | Control the behavior of the TimeGenerated column in the Microsoft Sentinel Windows Event Forwarding (WEF) table. | 0 = TimeGenerated <br> 1 = TimeReceived |

### Create an Agent Settings DCR

#### [Azure portal](#tab/azure-portal)

Currently not supported.

#### [Azure PowerShell](#tab/azure-powershell)

Currently not supported.

#### [Azure CLI](#tab/azure-cli)

Currently not supported.

#### [Resource Manager template](#tab/azure-resource-manager)

1. Prepare the environment by installing the Azure Monitor Agent on your VM.

1. Create the Agent Settings DCR.

The following example steps set the maximum amount of disk space used by the Azure Monitor Agent cache to 5 GB.

**Step 1** - Use the search bar to find the **Deploy a custom template** option.

:::image type="content" source="./media/agent-settings/azure-monitor-agent-deploy-template-portal.png" Lightbox="./media/agent-settings/azure-monitor-agent-deploy-template-portal.png" alt-text="Screenshot that shows the custom template in the search bar in the Azure portal.":::
 
**Step 2** – Select **Build your own template in the editor**.

:::image type="content" source="./media/agent-settings/azure-monitor-agent-data-collection-rule-edit-template-portal.png" lightbox="./media/agent-settings/azure-monitor-agent-data-collection-rule-edit-template-portal.png" alt-text="Screenshot that shows how to open the template editor in the Azure portal.":::
 
 **Step 3** – Delete the existing JSON in the template editor and copy the JSON code into the editor. Make sure that you modify the parameters in the JSON in the editor to meet your needs.

:::image type="content" source="./media/agent-settings/azure-monitor-agent-data-collection-rule-paste-template-portal.png" lightbox="./media/agent-settings/azure-monitor-agent-data-collection-rule-paste-template-portal.png" alt-text="Screenshot that shows how to open the custom template editor in the Azure portal.":::

Here's example JSON code to create the Agent Settings DCR:

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "region": {
            "defaultValue": "eastus",
            "type": "string"
        },
        "dcrName": {
            "defaultValue": "myDcrName",
            "type": "string"
        },
        "maxDiskQuota": {
            "defaultValue": "5000",
            "type": "string"
        }
    },
    "resources": [

        {
            "type": "Microsoft.Insights/dataCollectionRules",
            "kind": "AgentSettings",
            "location": "[parameters('region')]",
            "name": "[parameters('dcrName')]",
            "apiVersion": "2023-03-11",
            "properties": {
                "description": "Simple agent settings",
                "agentSettings": {
                    "logs": [
                        {
                            "name": "MaxDiskQuotaInMB",
                            "value": "[parameters('maxDiskQuota')]"
                        }
                    ]
                }
            }
        }
    ]
}
```

Validate and deploy the template. Make sure that you don't get any errors.

**Step 4** - Associate the DCR with a virtual machine go to the **Deploy a custom template in the editor** option again. Delete the existing JSON in the template editor and copy the JSON code into the editor. To meet your VM name and DCR resource, make sure you modify the items in the parameters section. You can copy the resource ID by going to the DCR and selecting the JSON View in the upper right corner. Use the **Copy to clipboard** option and then paste it into the template. For the `vmName`, use the string name of the VM.

:::image type="content" source="./media/agent-settings/azure-monitor-agent-data-collection-rule-resource-portal.png" lightbox="./media/agent-settings/azure-monitor-agent-data-collection-rule-resource-portal.png" alt-text="Screenshot that shows how to copy the DCR resource ID from the DCR json in the Azure portal.":::

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "vmName": {
      "type": "string",
      "defaultValue":"WindowsM1",
      "metadata": {
        "description": "The name of the virtual machine."
      }
    },
    "dataCollectionResourceId": {
      "type": "string",
      "defaultValue": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/ContosoAdmin/providers/Microsoft.Insights/dataCollectionRules/myDcrName",
      "metadata": {
        "description": "The resource ID of the data collection rule."
      }
    }
  },
  "resources": [
    {
      "type": "Microsoft.Insights/dataCollectionRuleAssociations",
      "apiVersion": "2021-09-01-preview",
      "scope": "[format('Microsoft.Compute/virtualMachines/{0}', parameters('vmResourceId'))]",
      "name": "agentSettings",
      "properties": {
        "description": "Association of data collection rule. Deleting this association will break the data collection for this virtual machine."
        "dataCollectionRuleId": "[parameters('dataCollectionResourceId')]"
      }
    }
  ]
}
```

Validate and deploy the template. Make sure that you don't get any errors.

**Step 5** – Apply the changes and restart AMA on the VM.

---

## Related content

[Create a data collection rule](../vm/data-collection.md) to collect data from the agent and send it to Azure Monitor.