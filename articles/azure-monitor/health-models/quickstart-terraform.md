---
title: Azure Monitor health model Terraform quickstart (preview)
description: Use Terraform and the AzAPI provider to deploy and verify an Azure Monitor health model with resource entities and metric signals.
ms.topic: quickstart
ms.date: 09/10/2026
ai-usage: ai-assisted
ms.custom:
    - devx-track-terraform
    - cbo-v1.5
#customer intent: As an Azure user, I want to deploy a health model with Terraform so that I can automate Health Models deployment.
---

# Quickstart: Create a health model with Terraform (preview)

In this quickstart, you use Terraform to create an Azure Monitor health model that represents an application and two Azure resources. The model uses the `Availability` metric from a storage account and key vault to evaluate their health and propagate it to the application.

The sample uses the [AzAPI Terraform provider](https://registry.terraform.io/providers/Azure/azapi/latest/docs) for Health Models resources because the AzureRM provider doesn't currently provide a native Health Models resource.

> [!IMPORTANT]
> Azure Monitor health models are in preview and might change. Microsoft provides limited support for preview features. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to features that are in preview or otherwise not yet released into general availability.

## Prerequisites

- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- Permissions to create a resource group and assign Azure roles in the target subscription. For example, use the **Contributor** and **Role Based Access Control Administrator** roles.
- Terraform configured for Azure. If you haven't already done so, use one of the following options:

    - [Configure Terraform in Azure Cloud Shell with Bash](/azure/developer/terraform/get-started-cloud-shell-bash)
    - [Configure Terraform in Azure Cloud Shell with Azure PowerShell](/azure/developer/terraform/get-started-cloud-shell-powershell)
    - [Install Terraform on Windows with Bash](/azure/developer/terraform/get-started-windows-bash)
    - [Install Terraform on Windows with Azure PowerShell](/azure/developer/terraform/get-started-windows-powershell)

## Review the Terraform code

The sample creates these resources in a new resource group:

- A health model with a system-assigned managed identity.
- A storage account and key vault represented by resource entities.
- An abstract application entity connected to both resource entities.
- An `Availability` metric signal on each resource entity.
- A managed identity authentication setting and **Reader** role assignment that allow the health model to read resource metrics.

The Key Vault entity has `Limited` impact. This setting represents an application that caches certificates or secrets, so a temporary Key Vault outage has less effect on overall application health.

> [!NOTE]
> The complete sample is available in the [`Azure/terraform` repository](https://github.com/Azure/terraform/tree/master/quickstart/101-health-model).

1. Create a directory for the Terraform files, and make it the current directory.

1. Create a file named `providers.tf`, and add the following code:

    [!code-terraform[master](~/terraform_samples/quickstart/101-health-model/providers.tf)]

1. Create a file named `variables.tf`, and add the following code:

    [!code-terraform[master](~/terraform_samples/quickstart/101-health-model/variables.tf)]

1. Create a file named `main.tf`, and add the following code:

    [!code-terraform[master](~/terraform_samples/quickstart/101-health-model/main.tf)]

1. Create a file named `outputs.tf`, and add the following code:

    [!code-terraform[master](~/terraform_samples/quickstart/101-health-model/outputs.tf)]

## Initialize Terraform

[!INCLUDE [Initialize Terraform](~/azure-dev-docs-pr/articles/terraform/includes/terraform-init.md)]

## Create a Terraform execution plan

[!INCLUDE [Create a Terraform execution plan](~/azure-dev-docs-pr/articles/terraform/includes/terraform-plan.md)]

## Apply the Terraform execution plan

[!INCLUDE [Apply a Terraform execution plan](~/azure-dev-docs-pr/articles/terraform/includes/terraform-apply-plan.md)]

## Verify the health model

Verify that Terraform created the health model with a system-assigned managed identity. The Terraform outputs also identify the storage account and key vault represented in the model.

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az resource show`](/cli/azure/resource#az-resource-show) command.

```bash
# Set variables
resourceGroupName=$(terraform output -raw resource_group_name)
healthModelName=$(terraform output -raw health_model_name)

# Verify the health model
az resource show \
    --resource-group "$resourceGroupName" \
    --name "$healthModelName" \
    --resource-type "Microsoft.CloudHealth/healthmodels" \
    --query "{name:name,state:properties.provisioningState,identity:identity.type}" \
    --output table
```

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`Get-AzResource`](/powershell/module/az.resources/get-azresource) cmdlet.

```powershell
# Set variables
$resourceGroupName = terraform output -raw resource_group_name
$healthModelName = terraform output -raw health_model_name

# Define parameters for Get-AzResource
$getAzResourceParams = @{
    ResourceGroupName = $resourceGroupName
    ResourceType      = "Microsoft.CloudHealth/healthmodels"
    Name              = $healthModelName
}

# Verify the health model
Get-AzResource @getAzResourceParams |
    Select-Object Name, ResourceType, Location
```

---

The command returns the health model name, resource type, and Azure region. In the Azure portal, open the health model to inspect its entities, signals, and relationships. The root entity connects to the application entity, which connects to the Storage and Key Vault entities.

## Clean up resources

[!INCLUDE [Clean up Terraform resources](~/azure-dev-docs-pr/articles/terraform/includes/terraform-plan-destroy.md)]

## Next step

> [!div class="nextstepaction"]
> [Monitor a health model](./monitoring.md)