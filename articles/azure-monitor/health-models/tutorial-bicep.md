---
title: Azure Monitor health model Bicep quickstart (preview)
description: In this quickstart, use Bicep to deploy and verify an Azure Monitor health model with entities, relationships, and metric signals.
ms.topic: quickstart-bicep
ms.custom:
  - subject-bicepqs
  - devx-track-bicep
  - cbo-v1.5
ms.date: 09/13/2026
ai-usage: ai-assisted
#customer intent: As an Azure user, I want to deploy a health model with Bicep so that I can automate a repeatable Health Models configuration.
---

# Quickstart: Create an Azure Monitor health model with Bicep (preview)

In this quickstart, you use Bicep to deploy a self-contained Azure Monitor health model. The model represents an application that depends on a storage account and key vault. Availability signals monitor both resources and propagate their health to the application.

[Bicep](/azure/azure-resource-manager/bicep/overview) is a declarative language for deploying Azure resources. Use Bicep instead of JSON to author Azure Resource Manager templates.

> [!IMPORTANT]
> Azure Monitor health models are in preview and might change. Microsoft provides limited support for preview features. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to features that are in preview or otherwise not yet released into general availability.

## Prerequisites

- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- The **Contributor** role to create a resource group and resources in the subscription.
- The **Role Based Access Control Administrator** role to assign the **Reader** role to the health model's managed identity.
- The latest version of the [Azure CLI](/cli/azure/install-azure-cli), or use [Azure Cloud Shell](/azure/cloud-shell/overview).

## Review the Bicep file

The Bicep file creates the following resources:

- A health model with a system-assigned managed identity.
- A storage account and key vault represented by resource entities.
- An abstract application entity connected to the model root and both resource entities.
- An `Availability` metric signal on each resource entity.
- A managed identity authentication setting and **Reader** role assignment that allow the health model to read resource metrics.

The Key Vault entity has `Limited` impact. This setting represents an application that caches certificates or secrets, so a temporary Key Vault outage has less effect on overall application health.

Create a file named `health-model.bicep`, and add the following content.

<details>
<summary>Create the health model and supporting resources</summary>

```bicep
@description('Azure region for the health model and supporting resources.')
param location string = resourceGroup().location

@description('Name of the health model to create.')
param healthModelName string = 'health-model-${uniqueString(resourceGroup().id)}'

var suffix = uniqueString(subscription().id, resourceGroup().id)
var readerRoleDefinitionId = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  'acdd72a7-3385-48ef-bd42-f606fba81ae7'
)

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: 'st${suffix}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: 'kv-${suffix}'
  location: location
  properties: {
    accessPolicies: []
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
  }
}

resource healthModel 'Microsoft.CloudHealth/healthmodels@2026-05-01-preview' = {
  name: healthModelName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {}
}

resource readerRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, healthModel.id, readerRoleDefinitionId)
  properties: {
    principalId: healthModel.identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: readerRoleDefinitionId
  }
}

resource authenticationSetting 'Microsoft.CloudHealth/healthmodels/authenticationsettings@2026-05-01-preview' = {
  parent: healthModel
  name: 'monitoring-identity'
  dependsOn: [
    readerRoleAssignment
  ]
  properties: {
    authenticationKind: 'ManagedIdentity'
    displayName: 'Monitoring identity'
    managedIdentityName: 'SystemAssigned'
  }
}

resource applicationEntity 'Microsoft.CloudHealth/healthmodels/entities@2026-05-01-preview' = {
  parent: healthModel
  name: 'application'
  properties: {
    canvasPosition: {
      x: 175
      y: 200
    }
    displayName: 'Application'
  }
}

resource storageEntity 'Microsoft.CloudHealth/healthmodels/entities@2026-05-01-preview' = {
  parent: healthModel
  name: 'storage'
  properties: {
    canvasPosition: {
      x: 0
      y: 400
    }
    displayName: 'Storage account'
    signalGroups: {
      azureResource: {
        authenticationSetting: authenticationSetting.name
        azureResourceId: storageAccount.id
        azureResourceKind: 'StorageV2'
        signals: [
          {
            aggregationType: 'Average'
            dataUnit: 'Percent'
            displayName: 'Storage availability (%)'
            evaluationRules: {
              degradedRule: {
                operator: 'LessThan'
                threshold: 100
              }
              unhealthyRule: {
                operator: 'LessThan'
                threshold: 99
              }
            }
            metricName: 'Availability'
            metricNamespace: 'Microsoft.Storage/storageAccounts'
            name: 'availability'
            refreshInterval: 'PT5M'
            signalKind: 'AzureResourceMetric'
            timeGrain: 'PT5M'
          }
        ]
      }
    }
  }
}

resource keyVaultEntity 'Microsoft.CloudHealth/healthmodels/entities@2026-05-01-preview' = {
  parent: healthModel
  name: 'key-vault'
  properties: {
    canvasPosition: {
      x: 350
      y: 400
    }
    displayName: 'Key Vault'
    impact: 'Limited'
    signalGroups: {
      azureResource: {
        authenticationSetting: authenticationSetting.name
        azureResourceId: keyVault.id
        azureResourceKind: ''
        signals: [
          {
            aggregationType: 'Average'
            dataUnit: 'Percent'
            displayName: 'Key Vault availability (%)'
            evaluationRules: {
              degradedRule: {
                operator: 'LessThan'
                threshold: 100
              }
              unhealthyRule: {
                operator: 'LessThan'
                threshold: 99
              }
            }
            metricName: 'Availability'
            metricNamespace: 'Microsoft.KeyVault/vaults'
            name: 'availability'
            refreshInterval: 'PT5M'
            signalKind: 'AzureResourceMetric'
            timeGrain: 'PT5M'
          }
        ]
      }
    }
  }
}

resource rootToApplication 'Microsoft.CloudHealth/healthmodels/relationships@2026-05-01-preview' = {
  parent: healthModel
  name: 'root-to-application'
  properties: {
    childEntityName: applicationEntity.name
    parentEntityName: healthModel.name
  }
}

resource applicationToStorage 'Microsoft.CloudHealth/healthmodels/relationships@2026-05-01-preview' = {
  parent: healthModel
  name: 'application-to-storage'
  properties: {
    childEntityName: storageEntity.name
    parentEntityName: applicationEntity.name
  }
}

resource applicationToKeyVault 'Microsoft.CloudHealth/healthmodels/relationships@2026-05-01-preview' = {
  parent: healthModel
  name: 'application-to-key-vault'
  properties: {
    childEntityName: keyVaultEntity.name
    parentEntityName: applicationEntity.name
  }
}

output healthModelName string = healthModel.name
output keyVaultName string = keyVault.name
output storageAccountName string = storageAccount.name
```

</details>

## Deploy the Bicep file

Create a dedicated resource group, and deploy the Bicep file to it.

# [Azure CLI bash](#tab/cli-bash)

The following Azure CLI example uses the [`az deployment group create`](/cli/azure/deployment/group#az-deployment-group-create) command.

```bash
# Set variables
location="swedencentral"
resourceGroupName="rg-health-model-bicep-$RANDOM"

# Create the resource group
az group create \
  --name "$resourceGroupName" \
  --location "$location"

# Deploy the Bicep file
az deployment group create \
  --name "health-model-deployment" \
  --resource-group "$resourceGroupName" \
  --template-file "health-model.bicep"
```

# [Azure CLI PowerShell](#tab/cli-powershell)

The following Azure CLI example uses the [`az deployment group create`](/cli/azure/deployment/group#az-deployment-group-create) command.

```powershell
# Set variables
$location = "swedencentral"
$resourceGroupName = "rg-health-model-bicep-$(Get-Random)"

# Create the resource group
az group create `
  --name $resourceGroupName `
  --location $location

# Deploy the Bicep file
az deployment group create `
  --name "health-model-deployment" `
  --resource-group $resourceGroupName `
  --template-file "health-model.bicep"
```

---

## Verify the deployment

Verify that Azure created the health model with its system-assigned managed identity.

# [Azure CLI bash](#tab/cli-bash)

The following Azure CLI example uses the [`az resource show`](/cli/azure/resource#az-resource-show) command.

```bash
healthModelName=$(az deployment group show \
  --name "health-model-deployment" \
  --resource-group "$resourceGroupName" \
  --query "properties.outputs.healthModelName.value" \
  --output tsv)

az resource show \
  --resource-group "$resourceGroupName" \
  --name "$healthModelName" \
  --resource-type "Microsoft.CloudHealth/healthmodels" \
  --query "{name:name,state:properties.provisioningState,identity:identity.type}" \
  --output table
```

# [Azure CLI PowerShell](#tab/cli-powershell)

The following Azure CLI example uses the [`az resource show`](/cli/azure/resource#az-resource-show) command.

```powershell
$healthModelName = az deployment group show `
  --name "health-model-deployment" `
  --resource-group $resourceGroupName `
  --query "properties.outputs.healthModelName.value" `
  --output tsv

az resource show `
  --resource-group $resourceGroupName `
  --name $healthModelName `
  --resource-type "Microsoft.CloudHealth/healthmodels" `
  --query "{name:name,state:properties.provisioningState,identity:identity.type}" `
  --output table
```

---

In the Azure portal, open the health model to inspect its entities, signals, and relationships. The root entity connects to the application entity, which connects to the Storage and Key Vault entities.

## Clean up resources

Delete the dedicated resource group when you no longer need the quickstart resources.

> [!CAUTION]
> This command deletes all resources in the resource group. Check that the group contains only resources you want to delete.

# [Azure CLI bash](#tab/cli-bash)

The following Azure CLI example uses the [`az group delete`](/cli/azure/group#az-group-delete) command.

```bash
az group delete --name "$resourceGroupName" --yes
```

# [Azure CLI PowerShell](#tab/cli-powershell)

The following Azure CLI example uses the [`az group delete`](/cli/azure/group#az-group-delete) command.

```powershell
az group delete --name $resourceGroupName --yes
```

---

Deleting the resource group soft-deletes the key vault. The vault name remains reserved during the seven-day retention period.

## Next step

> [!div class="nextstepaction"]
> [Configure signals in a health model](tutorial-signals.md)
