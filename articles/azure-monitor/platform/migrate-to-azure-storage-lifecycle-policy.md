---
title: Migrate Diagnostic Settings Storage Retention to Azure Storage Lifecycle Management
description: Learn how to migrate from diagnostic settings storage retention to Azure Storage lifecycle management.
ms.topic: how-to
ms.reviewer: lualderm
ms.date: 11/07/2024

#Customer intent: As a dev-ops administrator I want to migrate my retention setting from diagnostic setting retention storage to Azure Storage lifecycle management so that it continues to work after the feature has been deprecated.

---

# Migrate from diagnostic settings storage retention to Azure Storage lifecycle management

The *diagnostic settings storage retention* feature is deprecated. All retention functionality for this feature were disabled across all environments on September 30, 2025.

This article walks through migrating from using diagnostic settings storage retention to using [Azure Storage lifecycle management](/azure/storage/blobs/lifecycle-management-policy-configure?tabs=azure-portal) for retention.

For logs sent to a Log Analytics workspace, retention is set for each table on the **Tables** page of your workspace. For more information about retention in Log Analytics workspaces, see [Manage data retention in a Log Analytics workspace](../logs/data-retention-configure.md).

## Prerequisites

You need an existing diagnostic setting that's logging to a storage account.

## Migration procedures

> [!NOTE]
>
> * When you change your retention settings, the new settings apply only to new logs ingested after the change. Existing logs are subject to the previous retention settings.
> * Deleting a diagnostic setting doesn't delete the logs in the storage account. The retention settings continue to apply to the logs created before the diagnostic settings were deleted.

Use the following Azure CLI command to check if a resource has a diagnostic setting:

```azurecli
 az monitor diagnostic-settings list --resource <resource Id>
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

### [CLI](#tab/cli)

Use the [az storage account management-policy create](/cli/azure/storage/account/management-policy#az-storage-account-management-policy-create) command to create a lifecycle management policy. You must still set the retention in your diagnostic settings to **0**. For more information, see the migration procedures for the Azure portal.

```azurecli

az storage account management-policy create --account-name <storage account name> --resource-group <resource group name> --policy @<policy definition file>
```

The following sample policy definition sets the retention for all blobs in the container `insights-activity-logs` for the subscription ID. For more information, see [Lifecycle management policy definition](/azure/storage/blobs/lifecycle-management-overview#lifecycle-management-policy-definition).

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
            "insights-activity-logs/ResourceId=/SUBSCRIPTIONS/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
          ]
        }
      }
    }
  ]
}
```

### [Templates](#tab/templates)

Apply the following template to create a lifecycle management policy. You must still set the retention in your diagnostic settings to **0**. For more information, see the migration procedures for the Azure portal.

```azurecli

az deployment group create --resource-group <resource group name> --template-file <template file>

```

The following template sets the retention for storage account `azmonstorageaccount001` for all blobs in the container `insights-activity-logs` for all resources that have the subscription ID `aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e`.

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "resources": [
        {
            "type": "Microsoft.Storage/storageAccounts/managementPolicies",
            "apiVersion": "2021-02-01",
            "name": "azmonstorageaccount001/default",
            "properties": {
                "policy": {
                    "rules": [
                        {
                            "enabled": true,
                            "name": "Susbcription level lifecycle rule",
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
                                        "insights-activity-logs/ResourceId=/SUBSCRIPTIONS/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
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

---

## Related content

* [Configure a lifecycle management policy](/azure/storage/blobs/lifecycle-management-policy-configure?tabs=azure-portal)
