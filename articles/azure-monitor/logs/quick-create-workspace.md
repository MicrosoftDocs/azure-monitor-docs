---
title: Create Log Analytics workspaces
description: Learn how to create a Log Analytics workspace to enable management solutions and data collection from your cloud and on-premises environments.
ms.topic: conceptual
ms.date: 08/12/2024
ms.reviewer: yossiy

# Customer intent: As a DevOps engineer or IT expert, I want to set up a workspace to collect logs from multiple data sources from Azure, on-premises, and third-party cloud deployments.
---
# Create a Log Analytics workspace

A Log Analytics workspace is a data store into which you can collect any type of log data from all of your Azure and non-Azure resources and applications. We recommend that you send all log data to one Log Analytics workspace, unless you have specific business needs that require you to create multiple workspaces, as described in [Design a Log Analytics workspace architecture](./workspace-design.md).  

This article explains how to create a Log Analytics workspace. 

## Prerequisites

To create a Log Analytics workspace, you need an Azure account with an active subscription. You can [create an account for free](https://azure.microsoft.com/free).

## Permissions required

You need `Microsoft.OperationalInsights/workspaces/write` permissions to the resource group where you want to create the Log Analytics workspace, as provided by the [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor), for example.

## Create a workspace

## [Portal](#tab/azure-portal)

Use the **Log Analytics workspaces** menu to create a workspace.

1. In the [Azure portal](https://portal.azure.com), enter **Log Analytics** in the search box. As you begin typing, the list filters based on your input. Select **Log Analytics workspaces**.

    :::image type="content" source="media/quick-create-workspace/azure-portal-01.png" alt-text="Screenshot that shows the search bar at the top of the Azure home screen. As you begin typing, the list of search results filters based on your input.":::

1. Select **Create**.

1. Select a **Subscription** from the dropdown.
1. Use an existing **Resource Group** or create a new one.
1. Provide a name for the new **Log Analytics workspace**, such as *DefaultLAWorkspace*. This name must be unique per resource group.
1. Select an available **Region**. For more information, see which [regions Log Analytics is available in](https://azure.microsoft.com/regions/services/). Search for Azure Monitor in the **Search for a product** box.

   :::image type="content" source="media/quick-create-workspace/create-workspace.png" alt-text="Screenshot that shows the boxes that need to be populated on the Basics tab of the Create Log Analytics workspace screen.":::

1. Select **Review + Create** to review the settings. Then select **Create** to create the workspace. A default pricing tier of pay-as-you-go is applied. No charges will be incurred until you start collecting enough data. For more information about other pricing tiers, see [Log Analytics pricing details](https://azure.microsoft.com/pricing/details/log-analytics/).

## [PowerShell](#tab/azure-powershell)

The following sample script creates a workspace with no data source configuration.

```powershell
$ResourceGroup = <"my-resource-group">
$WorkspaceName = <"log-analytics-workspace-name">
$Location = <"westeurope">

# Create the resource group if needed
try {
    Get-AzResourceGroup -Name $ResourceGroup -ErrorAction Stop
} catch {
    New-AzResourceGroup -Name $ResourceGroup -Location $Location
}

# Create the workspace
New-AzOperationalInsightsWorkspace -Location $Location -Name $WorkspaceName -ResourceGroupName $ResourceGroup
```  

> [!NOTE]
> Log Analytics was previously called Operational Insights. The PowerShell cmdlets use Operational Insights in Log Analytics commands.
  
After you've created a workspace, [configure a Log Analytics workspace in Azure Monitor by using PowerShell](./powershell-workspace-configuration.md).

## [Azure CLI](#tab/azure-cli)

Run the [az group create](/cli/azure/group#az-group-create) command to create a resource group or use an existing resource group. To create a workspace, use the [az monitor log-analytics workspace create](/cli/azure/monitor/log-analytics/workspace#az-monitor-log-analytics-workspace-create) command.

```Azure CLI
    az group create --name <myGroup> --location <myLocation>
    az monitor log-analytics workspace create --resource-group <myGroup> \
       --workspace-name <myWorkspace>
```

For more information about Azure Monitor Logs in Azure CLI, see [Managing Azure Monitor Logs in Azure CLI](./azure-cli-log-analytics-workspace-sample.md).

## [Bicep](#tab/bicep)

The following sample uses [Microsoft.OperationalInsights workspaces](/azure/templates/microsoft.operationalinsights/workspaces?tabs=bicep&pivots=deployment-language-bicep) to create a Log Analytics workspace in Azure Monitor. For more information about Bicep, see [Bicep overview](/azure/azure-resource-manager/bicep/overview).

[!INCLUDE [azure-monitor-samples](../../../includes/azure-monitor-resource-manager-samples.md)]

### Bicep file

```bicep
@description('Name of the workspace.')
param workspaceName string

@description('Pricing tier: PerGB2018 or legacy tiers (Free, Standalone, PerNode, Standard or Premium) which are not available to all customers.')
@allowed([
  'pergb2018'
  'Free'
  'Standalone'
  'PerNode'
  'Standard'
  'Premium'
])
param sku string = 'pergb2018'

@description('Specifies the location for the workspace.')
param location string

@description('Number of days to retain data.')
param retentionInDays int = 120

@description('true to use resource or workspace permissions. false to require workspace permissions.')
param resourcePermissions bool

@description('Number of days to retain data in Heartbeat table.')
param heartbeatTableRetention int

resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  location: location
  properties: {
    sku: {
      name: sku
    }
    retentionInDays: retentionInDays
    features: {
      enableLogAccessUsingOnlyResourcePermissions: resourcePermissions
    }
  }
}

resource workspaceName_Heartbeat 'Microsoft.OperationalInsights/workspaces/tables@2022-10-01' = {
  parent: workspace
  name: 'Heartbeat'
  properties: {
    retentionInDays: heartbeatTableRetention
  }
}
```

> [!NOTE]
> If you specify a pricing tier of **Free**, then remove the **retentionInDays** element.

### Parameter file

```bicepparam
using './main.bicep'

param workspaceName = 'MyWorkspace'
param sku = 'pergb2018'
param location = 'eastus'
param retentionInDays = 120
param resourcePermissions = true
param heartbeatTableRetention = 30
```

## [Resource Manager template](#tab/azure-resource-manager)

The following sample uses the [Microsoft.OperationalInsights workspaces](/azure/templates/microsoft.operationalinsights/workspaces?tabs=bicep) template to create a Log Analytics workspace in Azure Monitor.
For more information about Azure Resource Manager templates, see [Azure Resource Manager templates](/azure/azure-resource-manager/templates/syntax).

[!INCLUDE [azure-monitor-samples](../../../includes/azure-monitor-resource-manager-samples.md)]

### Template file

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "workspaceName": {
      "type": "string",
      "metadata": {
        "description": "Name of the workspace."
      }
    },
    "sku": {
      "type": "string",
      "defaultValue": "pergb2018",
      "allowedValues": [
        "pergb2018",
        "Free",
        "Standalone",
        "PerNode",
        "Standard",
        "Premium"
      ],
      "metadata": {
        "description": "Pricing tier: PerGB2018 or legacy tiers (Free, Standalone, PerNode, Standard or Premium) which are not available to all customers."
      }
    },
    "location": {
      "type": "string",
      "metadata": {
        "description": "Specifies the location for the workspace."
      }
    },
    "retentionInDays": {
      "type": "int",
      "defaultValue": 120,
      "metadata": {
        "description": "Number of days to retain data."
      }
    },
    "resourcePermissions": {
      "type": "bool",
      "metadata": {
        "description": "true to use resource or workspace permissions. false to require workspace permissions."
      }
    },
    "heartbeatTableRetention": {
      "type": "int",
      "metadata": {
        "description": "Number of days to retain data in Heartbeat table."
      }
    }
  },
  "resources": [
    {
      "type": "Microsoft.OperationalInsights/workspaces",
      "apiVersion": "2023-09-01",
      "name": "[parameters('workspaceName')]",
      "location": "[parameters('location')]",
      "properties": {
        "sku": {
          "name": "[parameters('sku')]"
        },
        "retentionInDays": "[parameters('retentionInDays')]",
        "features": {
          "enableLogAccessUsingOnlyResourcePermissions": "[parameters('resourcePermissions')]"
        }
      }
    },
    {
      "type": "Microsoft.OperationalInsights/workspaces/tables",
      "apiVersion": "2022-10-01",
      "name": "[format('{0}/{1}', parameters('workspaceName'), 'Heartbeat')]",
      "properties": {
        "retentionInDays": "[parameters('heartbeatTableRetention')]"
      },
      "dependsOn": [
        "workspace"
      ]
    }
  ]
}
```

> [!NOTE]
> If you specify a pricing tier of **Free**, then remove the **retentionInDays** element.

### Parameter file

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-08-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "workspaceName": {
      "value": "MyWorkspace"
    },
    "sku": {
      "value": "pergb2018"
    },
    "location": {
      "value": "eastus"
    },
    "resourcePermissions": {
      "value": true
    },
    "heartbeatTableRetention": {
      "value": 30
    }
  }
}
```

---

## Troubleshooting

When you create a workspace that was deleted in the last 14 days and in [soft-delete state](../logs/delete-workspace.md#delete-a-workspace-into-a-soft-delete-state), the operation could have a different outcome depending on your workspace configuration:

1. If you provide the same workspace name, resource group, subscription, and region as in the deleted workspace, your workspace will be recovered including its data, configuration, and connected agents.
1. Workspace names must be unique for a resource group. If you use a workspace name that already exists, or is soft deleted, an error is returned. To permanently delete your soft-deleted name and create a new workspace with the same name, follow these steps:

   1. [Recover](../logs/delete-workspace.md#recover-a-workspace-in-a-soft-delete-state) your workspace.
   1. [Permanently delete](../logs/delete-workspace.md#delete-a-workspace-permanently) your workspace.
   1. Create a new workspace by using the same workspace name.
  
## Next steps

Now that you have a workspace available, you can configure collection of monitoring telemetry, run log searches to analyze that data, and add a management solution to provide more data and analytic insights. To learn more:

* See [Monitor health of Log Analytics workspace in Azure Monitor](../logs/monitor-workspace.md) to create alert rules to monitor the health of your workspace.
* See [Collect Azure service logs and metrics for use in Log Analytics](../essentials/resource-logs.md#send-to-log-analytics-workspace) to enable data collection from Azure resources with Azure Diagnostics or Azure Storage.
