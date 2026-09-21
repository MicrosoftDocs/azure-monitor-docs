---
title: Migrate from Diagnostic Settings Storage Retention to Azure Storage Lifecycle Management
description: Learn how to migrate from diagnostic settings storage retention to Azure Storage lifecycle management.
ms.topic: how-to
ms.custom: cbo-v1.4
ms.reviewer: lualderm
ms.date: 08/24/2026
ai-usage: ai-assisted

#Customer intent: As a dev-ops administrator I want to migrate my retention setting from diagnostic setting retention storage to Azure Storage lifecycle management so that it continues to work after the feature has been deprecated.

---

# Migrate from diagnostic settings storage retention to Azure Storage lifecycle management

The *diagnostic settings storage retention* feature is deprecated. All retention functionality for this feature was disabled across all environments on September 30, 2025.

This article walks through migrating from using diagnostic settings storage retention to using [Azure Storage lifecycle management](/azure/storage/blobs/lifecycle-management-policy-configure?tabs=azure-portal) for retention.

For logs sent to a Log Analytics workspace, retention is set for each table on the **Tables** page of your workspace. For more information, see [Manage data retention in a Log Analytics workspace](../logs/data-retention-configure.md).

## Prerequisites

To complete this migration, you need:

- An existing diagnostic setting that sends logs to an Azure Storage account.
- The [Storage Account Contributor](/azure/role-based-access-control/built-in-roles/storage#storage-account-contributor) role, or an equivalent role that grants the `Microsoft.Storage/storageAccounts/managementPolicies/*` permissions, on the target storage account.

## Migrate to an Azure Storage lifecycle management policy

The diagnostic settings storage retention feature stopped applying retention on September 30, 2025, so any retention value that remains on a diagnostic setting no longer has any effect. Recreate that retention behavior on the storage account with an Azure Storage lifecycle management policy by completing the following steps.

Keep the following behavior in mind when you change retention settings:

> [!NOTE]
>
> * When you change your retention settings, the new settings apply only to new logs ingested after the change. Existing logs are subject to the previous retention settings.
> * Deleting a diagnostic setting doesn't delete the logs in the storage account. The retention settings continue to apply to the logs created before the diagnostic settings were deleted.

### Check for a diagnostic setting that uses a storage account

The following Azure CLI example uses the [`az monitor diagnostic-settings list`](/cli/azure/monitor/diagnostic-settings#az-monitor-diagnostic-settings-list) command. It lists the diagnostic settings on a resource by using the `--resource` parameter.

```bash
# Set variables
resourceId="<ResourceId>"

# List the diagnostic settings on the resource
az monitor diagnostic-settings list --resource "$resourceId"
```

The output shows whether the diagnostic setting sends the data to a storage account. For example:

```json
[
  {
    "id": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/rg-001/providers/microsoft.insights/datacollectionrules/dcr-east2/providers/microsoft.insights/diagnosticSettings/dsetting-1",
    "logs": [
      {
        "categoryGroup": "allLogs",
        "enabled": true,
        "retentionPolicy": {
          "days": 0,
          "enabled": false
        }
      }
    ],
    "metrics": [
      {
        "category": "AllMetrics",
        "enabled": false,
        "retentionPolicy": {
          "days": 0,
          "enabled": false
        }
      }
    ],
    "name": "dsetting-1",
    "resourceGroup": "rg-001",
    "storageAccountId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/rg-DCR/providers/Microsoft.Storage/storageAccounts/logs001",
    "type": "Microsoft.Insights/diagnosticSettings"
  }
]
```

### Create the lifecycle management policy

Choose Azure CLI, Bicep, or an ARM template to create the policy. Because diagnostic settings storage retention was disabled on September 30, 2025, any retention value left on a diagnostic setting no longer applies, so you don't need to reset it to **0**.

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az storage account management-policy create`](/cli/azure/storage/account/management-policy#az-storage-account-management-policy-create) command. It creates the lifecycle management policy by using the `--policy` parameter to reference a local policy definition file.

```bash
# Set variables
storageAccountName="<StorageAccountName>"
resourceGroupName="<ResourceGroupName>"
policyFilePath="<PolicyDefinitionFilePath>"

# Create the lifecycle management policy
az storage account management-policy create \
  --account-name "$storageAccountName" \
  --resource-group "$resourceGroupName" \
  --policy "@$policyFilePath"
```

The following sample policy definition sets the retention for all blobs in the container `insights-activity-logs` for the subscription. For more information, see [Lifecycle management policy definition](/azure/storage/blobs/lifecycle-management-overview#lifecycle-management-policy-definition).

```json
{
  "rules": [
    {
      "enabled": true,
      "name": "Subscription level lifecycle rule",
      "type": "Lifecycle",
      "definition": {
        "actions": {
          "baseBlob": {
            "delete": {
              "daysAfterModificationGreaterThan": 120
            }
          }
        },
        "filters": {
          "blobTypes": [
            "appendBlob"
          ],
          "prefixMatch": [
            "insights-activity-logs/ResourceId=/SUBSCRIPTIONS/<SubscriptionId>"
          ]
        }
      }
    }
  ]
}
```

# [Bicep](#tab/bicep)

> [!NOTE]
> Template deployments are create-or-update operations, not partial updates. Deploying this template replaces any lifecycle management policy already on the storage account.

The following Bicep example uses the [`Microsoft.Storage/storageAccounts/managementPolicies`](/azure/templates/microsoft.storage/storageaccounts/managementpolicies?pivots=deployment-language-bicep) resource type. It sets the retention for all blobs in the container `insights-activity-logs` by using the `prefixMatch` filter.

<details>
<summary>Create a lifecycle rule that deletes blobs after the retention period</summary>

```bicep
param subscriptionId string = '<SubscriptionId>'
param storageAccountName string = '<StorageAccountName>'
param retentionInDays int = 120

resource lifecyclePolicy 'Microsoft.Storage/storageAccounts/managementPolicies@<ApiVersion>' = {
  name: '${storageAccountName}/default'
  properties: {
    policy: {
      rules: [
        {
          enabled: true
          name: 'Subscription level lifecycle rule'
          type: 'Lifecycle'
          definition: {
            actions: {
              baseBlob: {
                delete: {
                  daysAfterModificationGreaterThan: retentionInDays
                }
              }
            }
            filters: {
              blobTypes: [
                'appendBlob'
              ]
              prefixMatch: [
                'insights-activity-logs/ResourceId=/SUBSCRIPTIONS/${subscriptionId}'
              ]
            }
          }
        }
      ]
    }
  }
}
```

</details>

The following Azure CLI example uses the [`az deployment group create`](/cli/azure/deployment/group#az-deployment-group-create) command. It deploys the template by using the `--template-file` parameter.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
templateFilePath="<TemplateFilePath>"

# Deploy the template
az deployment group create \
  --resource-group "$resourceGroupName" \
  --template-file "$templateFilePath"
```

# [ARM template](#tab/arm)

> [!NOTE]
> Template deployments are create-or-update operations, not partial updates. Deploying this template replaces any lifecycle management policy already on the storage account.

The following ARM template example uses the [`Microsoft.Storage/storageAccounts/managementPolicies`](/azure/templates/microsoft.storage/storageaccounts/managementpolicies?pivots=deployment-language-arm-template) resource type. It sets the retention for all blobs in the container `insights-activity-logs` by using the `prefixMatch` filter.

<details>
<summary>Create a lifecycle rule that deletes blobs after the retention period</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "subscriptionId": {
      "type": "string",
      "defaultValue": "<SubscriptionId>"
    },
    "storageAccountName": {
      "type": "string",
      "defaultValue": "<StorageAccountName>"
    },
    "retentionInDays": {
      "type": "int",
      "defaultValue": 120
    }
  },
  "resources": [
    {
      "type": "Microsoft.Storage/storageAccounts/managementPolicies",
      "apiVersion": "<ApiVersion>",
      "name": "[format('{0}/default', parameters('storageAccountName'))]",
      "properties": {
        "policy": {
          "rules": [
            {
              "enabled": true,
              "name": "Subscription level lifecycle rule",
              "type": "Lifecycle",
              "definition": {
                "actions": {
                  "baseBlob": {
                    "delete": {
                      "daysAfterModificationGreaterThan": "[parameters('retentionInDays')]"
                    }
                  }
                },
                "filters": {
                  "blobTypes": [
                    "appendBlob"
                  ],
                  "prefixMatch": [
                    "[format('insights-activity-logs/ResourceId=/SUBSCRIPTIONS/{0}', parameters('subscriptionId'))]"
                  ]
                }
              }
            }
          ]
        }
      }
    }
  ]
}
```

</details>

The following Azure CLI example uses the [`az deployment group create`](/cli/azure/deployment/group#az-deployment-group-create) command. It deploys the template by using the `--template-file` parameter.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
templateFilePath="<TemplateFilePath>"

# Deploy the template
az deployment group create \
  --resource-group "$resourceGroupName" \
  --template-file "$templateFilePath"
```

---

### Verify the lifecycle management policy

The following Azure CLI example uses the [`az storage account management-policy show`](/cli/azure/storage/account/management-policy#az-storage-account-management-policy-show) command. It confirms that the policy exists on the storage account by using the `--account-name` parameter.

```bash
# Set variables
storageAccountName="<StorageAccountName>"
resourceGroupName="<ResourceGroupName>"

# Show the lifecycle management policy
az storage account management-policy show \
  --account-name "$storageAccountName" \
  --resource-group "$resourceGroupName"
```

The output shows the policy rules, including the `daysAfterModificationGreaterThan` value that sets the retention period in days.

## Related content

* [Configure a lifecycle management policy](/azure/storage/blobs/lifecycle-management-policy-configure?tabs=azure-portal)
