---
title: Azure Monitor health models with Azure PowerShell (preview)
description: In this quickstart, use Azure PowerShell and an ARM template to create, verify, and delete an Azure Monitor health model.
ms.topic: quickstart
ms.date: 08/26/2026
ai-usage: ai-assisted
ms.custom: devx-track-azurepowershell
#customer intent: As an Azure user, I want to deploy my first health model with Azure PowerShell so that I can automate Health Models deployment.
---

# Quickstart: Create a health model with Azure PowerShell (preview)

In this quickstart, you use Azure PowerShell and an Azure Resource Manager template (ARM template) to create an Azure Monitor health model with a system-assigned managed identity, verify the deployment, and delete the resources.

> [!IMPORTANT]
> Azure Monitor health models are in preview and might change. Microsoft provides limited support for preview features. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to features that are in preview or otherwise not yet released into general availability.

## Prerequisites

- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- At least the **Contributor** role on the target subscription or resource group.
- PowerShell 7.x or Windows PowerShell 5.1.
- The latest [Az PowerShell module](/powershell/azure/install-azure-powershell).

Connect to Azure with [Connect-AzAccount](/powershell/module/az.accounts/connect-azaccount), and select the subscription for the deployment.

```azurepowershell
Connect-AzAccount
Set-AzContext -SubscriptionId "<subscription-id>"
```

## Create the ARM template

Create a file named `health-model.json`, and add the following ARM template. The template creates a health model with a system-assigned managed identity.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "healthModelName": {
      "type": "string"
    },
    "location": {
      "type": "string",
      "defaultValue": "[resourceGroup().location]"
    }
  },
  "resources": [
    {
      "type": "Microsoft.CloudHealth/healthmodels",
      "apiVersion": "2026-05-01-preview",
      "name": "[parameters('healthModelName')]",
      "location": "[parameters('location')]",
      "identity": {
        "type": "SystemAssigned"
      }
    }
  ]
}
```

## Create a resource group

Set values that the remaining commands reuse. Create a resource group with [New-AzResourceGroup](/powershell/module/az.resources/new-azresourcegroup).

```azurepowershell
$suffix = [DateTime]::UtcNow.ToString("MMddHHmmss") + "-" + (Get-Random)
$location = "swedencentral"
$resourceGroupName = "msdocs-health-model-rg-$suffix"
$healthModelName = "msdocs-health-model-$suffix"

New-AzResourceGroup `
    -Name $resourceGroupName `
    -Location $location
```

## Deploy the health model

Deploy the template with [New-AzResourceGroupDeployment](/powershell/module/az.resources/new-azresourcegroupdeployment). Pass the health model name through a template parameter object.

```azurepowershell
$templateParameters = @{
    healthModelName = $healthModelName
}

New-AzResourceGroupDeployment `
    -Name "health-model-deployment" `
    -ResourceGroupName $resourceGroupName `
    -TemplateFile ./health-model.json `
    -TemplateParameterObject $templateParameters
```

The deployment typically finishes in less than a minute and returns a provisioning state of `Succeeded`.

## Verify the health model

Use [Get-AzResource](/powershell/module/az.resources/get-azresource) to verify that Azure created the Health Models resource.

```azurepowershell
Get-AzResource `
    -ResourceGroupName $resourceGroupName `
    -ResourceType "Microsoft.CloudHealth/healthmodels" `
    -Name $healthModelName |
    Select-Object Name, ResourceType, Location
```

The output identifies the health model, its `Microsoft.CloudHealth/healthmodels` resource type, and its Azure region.

## Clean up resources

If you don't plan to continue configuring the health model, delete the resource group and all its resources with [Remove-AzResourceGroup](/powershell/module/az.resources/remove-azresourcegroup).

```azurepowershell
Remove-AzResourceGroup -Name $resourceGroupName -Force
```

## Next step

The template creates an empty health model. Before the model can evaluate health, add entities and signals, and grant the model's managed identity the **Reader** role on the Azure resources it represents and the **Monitoring Reader** role on any workspaces its signals query. See [Permissions required](./create.md#permissions-required).

> [!div class="nextstepaction"]
> [Configure a health model using the designer](./designer.md)
