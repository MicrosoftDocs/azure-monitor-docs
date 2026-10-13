---
title: Azure Monitor health model CLI quickstart (preview)
description: In this quickstart, use Azure CLI to create and verify an Azure Monitor health model while the extension remains in preview.
ms.topic: quickstart
ms.reviewer: anbossar
ms.date: 08/26/2026
ai-usage: ai-assisted
ms.custom:
  - devx-track-azurecli
#customer intent: As an Azure user, I want to create my first health model with Azure CLI so that I can automate Health Models deployment.
---

# Quickstart: Create a health model with Azure CLI (preview)

In this quickstart, you use Azure CLI to create an Azure Monitor health model with a system-assigned managed identity, verify the deployment, and delete the resources.

> [!IMPORTANT]
> The `health-models` Azure CLI extension is in preview and might change. Microsoft provides limited support for this feature. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to features that are in preview or otherwise not yet released into general availability.

## Prerequisites

- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- Permission to create resources in the target subscription.
- Azure CLI 2.75.0 or later. Run `az login` to sign in.

## Install the Health Models extension

Install or update the `health-models` Azure CLI extension.

```azurecli
az extension add --name health-models --upgrade
```

## Create a health model

Set values that the remaining commands reuse, create a resource group, and create a health model with a system-assigned managed identity.

# [Bash](#tab/bash)

```azurecli
suffix="$(date -u +%m%d%H%M%S)-$RANDOM"
location="swedencentral"
resourceGroupName="msdocs-health-model-rg-$suffix"
modelName="msdocs-health-model-$suffix"

az group create \
    --name "$resourceGroupName" \
    --location "$location" \
    --output table

az monitor health-models create \
    --resource-group "$resourceGroupName" \
    --name "$modelName" \
    --mi-system-assigned \
    --location "$location" \
    --query "{name:name,provisioningState:properties.provisioningState,identity:identity.type}" \
    --output table
```

# [PowerShell](#tab/powershell)

```azurecli
$suffix = [DateTime]::UtcNow.ToString("MMddHHmmss") + "-" + (Get-Random)
$location = "swedencentral"
$resourceGroupName = "msdocs-health-model-rg-$suffix"
$modelName = "msdocs-health-model-$suffix"

az group create `
    --name $resourceGroupName `
    --location $location `
    --output table

az monitor health-models create `
    --resource-group $resourceGroupName `
    --name $modelName `
    --mi-system-assigned `
    --location $location `
    --query "{name:name,provisioningState:properties.provisioningState,identity:identity.type}" `
    --output table
```

---

The deployment typically finishes in less than a minute. The output shows a provisioning state of `Succeeded` and an identity type of `SystemAssigned`.

## Verify the health model

Show the health model and confirm its provisioning state and managed identity.

# [Bash](#tab/bash)

```azurecli
az monitor health-models show \
    --resource-group "$resourceGroupName" \
    --name "$modelName" \
    --query "{name:name,provisioningState:properties.provisioningState,identity:identity.type}" \
    --output table
```

# [PowerShell](#tab/powershell)

```azurecli
az monitor health-models show `
    --resource-group $resourceGroupName `
    --name $modelName `
    --query "{name:name,provisioningState:properties.provisioningState,identity:identity.type}" `
    --output table
```

---

The health model is ready for entities, relationships, and signals.

## Clean up resources

Delete the resource group when you no longer need the health model.

# [Bash](#tab/bash)

```azurecli
az group delete --name "$resourceGroupName" --yes
```

# [PowerShell](#tab/powershell)

```azurecli
az group delete --name $resourceGroupName --yes
```

---

## Next step

The commands create an empty health model. Before the model can evaluate health, add entities and signals, and grant the model's managed identity the **Reader** role on the Azure resources it represents and the **Monitoring Reader** role on any workspaces its signals query. See [Permissions required](./create.md#permissions-required).

> [!div class="nextstepaction"]
> [Build and operate a health model with Azure CLI](./cli.md)
