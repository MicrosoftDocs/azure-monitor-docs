---
title: Azure Monitor health model ARM template quickstart (preview)
description: In this quickstart, use an ARM template to deploy, verify, and delete an Azure Monitor health model with a managed identity.
ms.topic: quickstart-arm
ms.date: 08/26/2026
ai-usage: ai-assisted
ms.custom: subject-armqs
#customer intent: As an Azure user, I want to deploy my first health model with an ARM template so that I can automate Health Models deployment.
---

# Quickstart: Create a health model with an ARM template (preview)

In this quickstart, you use an Azure Resource Manager template (ARM template) to create an Azure Monitor health model with a system-assigned managed identity, verify the deployment, and delete the resources.

An ARM template is a JavaScript Object Notation (JSON) file that defines the infrastructure and configuration for your project. Declarative syntax states what to deploy without specifying the sequence of programming commands that creates it.

> [!IMPORTANT]
> Azure Monitor health models are in preview and might change. Microsoft provides limited support for preview features. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to features that are in preview or otherwise not yet released into general availability.

## Prerequisites

- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- At least the **Contributor** role on the target subscription or resource group.
- The latest version of either [Azure CLI](/cli/azure/install-azure-cli) or the [Az PowerShell module](/powershell/azure/install-azure-powershell).

Sign in with [az login](/cli/azure/reference-index#az-login) or [Connect-AzAccount](/powershell/module/az.accounts/connect-azaccount), and select the subscription for the deployment.

## Review the template

Create a file named `health-model.json`, and add the following ARM template. The template defines a health model with a system-assigned managed identity.

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

The template defines one resource:

- [Microsoft.CloudHealth/healthmodels](/azure/templates/microsoft.cloudhealth/healthmodels): Creates an Azure Monitor health model.

## Deploy the template

Create a resource group and deploy the template by using Azure CLI or Azure PowerShell.

# [Azure CLI](#tab/azure-cli)

```azurecli
suffix="$(date -u +%m%d%H%M%S)-$RANDOM"
location="swedencentral"
resourceGroupName="msdocs-health-model-rg-$suffix"
healthModelName="msdocs-health-model-$suffix"

az group create \
    --name "$resourceGroupName" \
    --location "$location"

az deployment group create \
    --name "health-model-deployment" \
    --resource-group "$resourceGroupName" \
    --template-file ./health-model.json \
    --parameters healthModelName="$healthModelName"
```

# [Azure PowerShell](#tab/azure-powershell)

```azurepowershell
$suffix = [DateTime]::UtcNow.ToString("MMddHHmmss") + "-" + (Get-Random)
$location = "swedencentral"
$resourceGroupName = "msdocs-health-model-rg-$suffix"
$healthModelName = "msdocs-health-model-$suffix"

New-AzResourceGroup `
    -Name $resourceGroupName `
    -Location $location

$templateParameters = @{
    healthModelName = $healthModelName
}

New-AzResourceGroupDeployment `
    -Name "health-model-deployment" `
    -ResourceGroupName $resourceGroupName `
    -TemplateFile ./health-model.json `
    -TemplateParameterObject $templateParameters
```

---

The deployment typically finishes in less than a minute and returns a provisioning state of `Succeeded`.

## Review the deployed resource

Verify that Azure created the Health Models resource.

# [Azure CLI](#tab/azure-cli)

```azurecli
az resource show \
    --resource-group "$resourceGroupName" \
    --name "$healthModelName" \
    --resource-type "Microsoft.CloudHealth/healthmodels" \
    --query "{name:name,type:type,location:location}" \
    --output table
```

# [Azure PowerShell](#tab/azure-powershell)

```azurepowershell
Get-AzResource `
    -ResourceGroupName $resourceGroupName `
    -ResourceType "Microsoft.CloudHealth/healthmodels" `
    -Name $healthModelName |
    Select-Object Name, ResourceType, Location
```

---

The output identifies the health model, its `Microsoft.CloudHealth/healthmodels` resource type, and its Azure region.

## Clean up resources

If you don't plan to continue configuring the health model, delete the resource group and all its resources.

# [Azure CLI](#tab/azure-cli)

```azurecli
az group delete --name "$resourceGroupName" --yes
```

# [Azure PowerShell](#tab/azure-powershell)

```azurepowershell
Remove-AzResourceGroup -Name $resourceGroupName -Force
```

---

## Next step

The template creates an empty health model. Before the model can evaluate health, add entities and signals, and grant the model's managed identity the **Reader** role on the Azure resources it represents and the **Monitoring Reader** role on any workspaces its signals query. See [Permissions required](./create.md#permissions-required).

> [!div class="nextstepaction"]
> [Configure a health model using the designer](./designer.md)
