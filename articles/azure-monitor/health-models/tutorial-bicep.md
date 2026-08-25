---
title: Create an Azure Monitor health model by using Bicep (preview)
description: Learn how to create an Azure Monitor health model with Bicep, including signals, entities, and relationships that roll up health across a workload.
ms.topic: tutorial
ms.custom: devx-track-bicep
ms.date: 07/27/2026
ai-usage: ai-assisted
---

# Tutorial: Create an Azure Monitor health model by using Bicep (preview)

In this tutorial, you build a small but complete health model by using [Bicep](/azure/azure-resource-manager/bicep/overview). The model contains a simple user flow that depends on an Azure Storage account and a Service Bus namespace to update a user's information stored on a website. Signals watch the storage account's availability and the Service Bus namespace's error count. That health status propagates up through the health model, so a problem in either dependency is reflected all the way at the top.

In this tutorial, you:

> [!div class="checklist"]
> - Review the Bicep file.
> - Deploy the Bicep file.
> - Verify the deployment.
> - Clean up resources.

## Prerequisites

- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/free/).
- A **resource group** to deploy into.
- A **storage account** that you want to monitor. Note its resource ID.
- A **Service Bus namespace** that you want to monitor. The **Basic** tier is enough. Note its resource ID.
- A **user-assigned managed identity** that's granted the **Reader** role on the resources you want to monitor. Note its resource ID.
- The latest version of the [Azure CLI](/cli/azure/install-azure-cli), or use [Azure Cloud Shell](/azure/cloud-shell/overview).

## Review the Bicep file

The Bicep file creates one health model with five entities (including the root entity that represents the health model itself), four relationships, and two inline signals.

| Resource | Purpose |
| --- | --- |
| `healthmodels` | The health model itself. It carries the user-assigned identity used to query your resources. |
| `authenticationsettings` | Tells the model which managed identity to use when it reads metrics. |
| `entities` (`app-storage`) | A **child** entity that represents the storage account, with an inline **Availability** signal that has degraded and unhealthy thresholds. |
| `entities` (`app-servicebus`) | A second **child** entity that represents the Service Bus namespace, with an inline **UserErrors** signal that has degraded and unhealthy thresholds. |
| `entities` (`user-info-service`) | A mid-level entity that represents a system component of the workload. It has no signal of its own; its health is derived from its children. |
| `entities` (`update-user-info`) | The top-level **user-flow** entity. Its health rolls up from its children. |
| `relationships` | Connects the user flow to the system component, and the application to each resource, so health propagates upward. |

Create a file named *health-model.bicep* and copy in the following content:

```bicep
@description('Azure region for the health model.')
param location string = resourceGroup().location

@description('Name of the health model to create.')
param healthModelName string = 'contoso-app-health'

@description('Resource ID of the storage account to monitor.')
param storageAccountId string

@description('Resource ID of the Service Bus namespace to monitor.')
param serviceBusNamespaceId string

@description('Resource ID of the user-assigned managed identity that already has the Reader role on the resources to monitor.')
param managedIdentityId string

resource healthModel 'Microsoft.CloudHealth/healthmodels@2026-05-01-preview' = {
  name: healthModelName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentityId}': {}
    }
  }
}

resource authenticationSetting 'Microsoft.CloudHealth/healthmodels/authenticationsettings@2026-05-01-preview' = {
  parent: healthModel
  name: 'monitoring-identity'
  properties: {
    displayName: 'Storage monitoring identity'
    authenticationKind: 'ManagedIdentity'
    managedIdentityName: managedIdentityId
  }
}

resource storageEntity 'Microsoft.CloudHealth/healthmodels/entities@2026-05-01-preview' = {
  parent: healthModel
  name: 'app-storage'
  properties: {
    displayName: 'User data storage'
    canvasPosition: {
      x: 0
      y: 550
    }
    signalGroups: {
      azureResource: {
        authenticationSetting: authenticationSetting.name
        azureResourceId: storageAccountId
        azureResourceKind: 'StorageV2'
        signals: [
          {
            name: 'availability'
            displayName: 'Storage availability (%)'
            signalKind: 'AzureResourceMetric'
            refreshInterval: 'PT5M'
            dataUnit: 'Percent'
            metricNamespace: 'Microsoft.Storage/storageAccounts'
            metricName: 'Availability'
            timeGrain: 'PT5M'
            aggregationType: 'Average'
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
          }
        ]
      }
    }
  }
}

resource serviceBusEntity 'Microsoft.CloudHealth/healthmodels/entities@2026-05-01-preview' = {
  parent: healthModel
  name: 'app-servicebus'
  properties: {
    displayName: 'Update user data message service'
    canvasPosition: {
      x: 350
      y: 550
    }
    signalGroups: {
      azureResource: {
        authenticationSetting: authenticationSetting.name
        azureResourceId: serviceBusNamespaceId
        azureResourceKind: ''
        signals: [
          {
            name: 'user-errors'
            displayName: 'Service Bus user errors'
            signalKind: 'AzureResourceMetric'
            refreshInterval: 'PT5M'
            dataUnit: 'Count'
            metricNamespace: 'Microsoft.ServiceBus/namespaces'
            metricName: 'UserErrors'
            timeGrain: 'PT5M'
            aggregationType: 'Total'
            evaluationRules: {
              degradedRule: {
                operator: 'GreaterThan'
                threshold: 10
              }
              unhealthyRule: {
                operator: 'GreaterThan'
                threshold: 50
              }
            }
          }
        ]
      }
    }
  }
}

resource applicationEntity 'Microsoft.CloudHealth/healthmodels/entities@2026-05-01-preview' = {
  parent: healthModel
  name: 'user-info-service'
  properties: {
    displayName: 'User info data service'
    canvasPosition: {
      x: 0
      y: 400
    }
  }
}

resource updateUserInfoEntity 'Microsoft.CloudHealth/healthmodels/entities@2026-05-01-preview' = {
  parent: healthModel
  name: 'update-user-info'
  properties: {
    displayName: 'Update user info'
    canvasPosition: {
      x: 0
      y: 200
    }
    icon: {
      iconName: 'UserFlow'
    }
  }
}

resource applicationDependsOnStorage 'Microsoft.CloudHealth/healthmodels/relationships@2026-05-01-preview' = {
  parent: healthModel
  name: 'user-data-service-to-app-storage'
  properties: {
    parentEntityName: applicationEntity.name
    childEntityName: storageEntity.name
  }
}

resource applicationDependsOnServiceBus 'Microsoft.CloudHealth/healthmodels/relationships@2026-05-01-preview' = {
  parent: healthModel
  name: 'user-data-service-to-app-servicebus'
  properties: {
    parentEntityName: applicationEntity.name
    childEntityName: serviceBusEntity.name
  }
}

resource userFlowDependsOnApplication 'Microsoft.CloudHealth/healthmodels/relationships@2026-05-01-preview' = {
  parent: healthModel
  name: 'update-user-info-to-user-data-service'
  properties: {
    parentEntityName: updateUserInfoEntity.name
    childEntityName: applicationEntity.name
  }
}

resource healthModelDependsOnUserFlow 'Microsoft.CloudHealth/healthmodels/relationships@2026-05-01-preview' = {
  parent: healthModel
  name: 'model-to-update-user-info'
  properties: {
    parentEntityName: healthModel.name
    childEntityName: updateUserInfoEntity.name
  }
}
```

### How the pieces fit together

- The **signal** is defined inline on the entity and describes *what* to measure and the thresholds that turn a raw number into a health state. Here, the storage account's average availability over five minutes is `Degraded` below 100% and `Unhealthy` below 99%.
- The **child entity** (`app-storage`) points at your real storage account (`azureResourceId`) and carries the signal directly in its `signals` array. This is the entity that's actually evaluated.
- The **second child entity** (`app-servicebus`) works the same way, but points at the Service Bus namespace and uses an inline `UserErrors` signal.
- The **parent entity** (`user-info-service`) has a `dependencies` signal group with `WorstOf` aggregation by default. Its health is the worst health of the entities it depends on.
- The **relationships** wire each parent to its children. When either the storage or the Service Bus signal degrades, the application entity degrades too, and that in turn degrades the **Update user info** user flow above it (worst-of aggregation at every level).
- The **user-flow entity** (`update-user-info`) exists to give the end-to-end journey a single health state that rolls up from everything beneath it.
- Each entity's `canvasPosition` gives it fixed `x` and `y` coordinates on the model's graph canvas.

## Deploy the Bicep file

Deploy the file to your resource group. Pass in the storage account, Service Bus namespace, and managed identity resource IDs from the prerequisites.

Health models are available only in certain regions. The `location` parameter defaults to the resource group's region, so if your resource group is in an unsupported region, set `location` to a supported one. The health model can be in a different region from the resources it monitors. To see the current list of supported regions, check [Azure products by region](https://azure.microsoft.com/explore/global-infrastructure/products-by-region/) or the error returned if you deploy to an unsupported region.

# [Azure CLI (Bash)](#tab/azure-cli-bash)

> [!NOTE]
> If deployment validation fails because Git Bash on Windows converts Azure resource IDs to Windows file paths, run `export MSYS_NO_PATHCONV=1`, and then retry the deployment.

```azurecli
az deployment group create \
  --resource-group "<resource-group>" \
  --template-file health-model.bicep \
  --parameters \
      storageAccountId='<storage-account-resource-id>' \
      serviceBusNamespaceId='<service-bus-namespace-resource-id>' \
      managedIdentityId='<managed-identity-resource-id>'
```

# [Azure CLI (PowerShell)](#tab/azure-cli-powershell)

```azurepowershell
az deployment group create `
  --resource-group "<resource-group>" `
  --template-file health-model.bicep `
  --parameters `
      storageAccountId='<storage-account-resource-id>' `
      serviceBusNamespaceId='<service-bus-namespace-resource-id>' `
      managedIdentityId='<managed-identity-resource-id>'
```

---

The deployment takes less than a minute. When it finishes, the health model begins evaluating the signals on their refresh interval (every five minutes).

## Verify the deployment

After deployment, the health model doesn't evaluate signals instantly. It typically takes a minute or two (occasionally longer) for the first evaluation cycle to run and populate values. During this window, every entity reports a health state of `Unknown`, and the metric signal shows no value yet. This behavior is expected. Wait a few minutes and recheck before you assume something is misconfigured.

### Check the health state with the Azure CLI

Read the application entity and inspect its `healthState`:

# [Azure CLI (Bash)](#tab/azure-cli-bash)

```azurecli
az monitor health-models entity show \
  --resource-group "<resource-group>" \
  --health-model-name contoso-app-health \
  --entity-name user-info-service \
  --query "properties.healthState"
```

# [Azure CLI (PowerShell)](#tab/azure-cli-powershell)

```azurepowershell
az monitor health-models entity show `
  --resource-group "<resource-group>" `
  --health-model-name contoso-app-health `
  --entity-name user-info-service `
  --query "properties.healthState"
```

---

You can inspect any other entity the same way by replacing `user-info-service` with `update-user-info`, `app-storage`, or `app-servicebus`. On healthy resources, all four entities report `Healthy` after the first evaluation completes, and the `update-user-info` user flow reflects the worst state anywhere beneath it.

### View the model in the Azure portal

1. In the [Azure portal](https://portal.azure.com), go to your resource group and open the **contoso-app-health** health model.
1. Select **Graph** under **Health** in the service menu. The visualization shows the **Update user info** user flow at the top, connected down to **User info data service**, which in turn connects to its two dependencies, **User data storage** and **Update user data message service**. Each node is colored by its current health state.
1. Select an entity to see its signals and the values behind its health state.

:::image type="content" source="media/tutorial-bicep/health-model-graph.png" lightbox="media/tutorial-bicep/health-model-graph.png" alt-text="Screenshot of the health model Graph view in the Azure portal that shows the Update user info user flow connected down through User info data service to User data storage and Update user data message service, with each entity reporting a healthy state.":::

## Clean up resources

When you no longer need the health model, delete it. Deleting the health model also removes its entities, signals, and relationships. It doesn't delete the real Azure resources.

# [Azure CLI (Bash)](#tab/azure-cli-bash)

```azurecli
az resource delete \
  --resource-group "<resource-group>" \
  --name contoso-app-health \
  --resource-type Microsoft.CloudHealth/healthmodels \
  --api-version 2026-05-01-preview
```

# [Azure CLI (PowerShell)](#tab/azure-cli-powershell)

```azurepowershell
az resource delete `
  --resource-group "<resource-group>" `
  --name contoso-app-health `
  --resource-type Microsoft.CloudHealth/healthmodels `
  --api-version 2026-05-01-preview
```

---

To remove everything you created for this tutorial, delete the resource group.

## Next step

> [!div class="nextstepaction"]
> [Configure signals in a health model](tutorial-signals.md)
