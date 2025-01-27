---
title: "Migrate diagnostic settings storage retention to Azure Storage lifecycle management"
description: "How to Migrate from diagnostic settings storage retention to Azure Storage lifecycle management"
author: EdB-MSFT
ms.author: edbaynash
ms.service: azure-monitor
ms.topic: how-to
ms.reviewer: lualderm
ms.date: 11/07/2024

#Customer intent: As a dev-ops administrator I want to migrate my retention setting from diagnostic setting retention storage to Azure Storage lifecycle management so that it continues to work after the feature has been deprecated.
---

# Migrate from diagnostic settings storage retention to Azure Storage lifecycle management

The Diagnostic Settings Storage Retention feature is being deprecated. To configure retention for logs and metrics sent to an Azure Storage account, use Azure Storage Lifecycle Management.  

This guide walks you through migrating from using Azure diagnostic settings storage retention to using [Azure Storage lifecycle management](/azure/storage/blobs/lifecycle-management-policy-configure?tabs=azure-portal) for retention.
For logs sent to a Log Analytics workspace, retention is set for each table on the **Tables** page of your workspace. For more information on Log Analytics workspace retention, see [Manage data retention in a Log Analytics workspace](../logs/data-retention-configure.md).

> [!IMPORTANT]
> **Deprecation Timeline.**
> - March 31, 2023 –  The Diagnostic Settings Storage Retention feature will no longer be available to configure new retention rules for log data. This includes using the portal, CLI PowerShell, and ARM and Bicep templates.  If you have configured retention settings, you'll still be able to see and change them in the portal. 
> - September 30, 2025 –  All retention functionality for the Diagnostic Settings Storage Retention feature will be disabled across all environments.

## Prerequisites

An existing diagnostic setting logging to a storage account.

## Migration procedures

> [!NOTE]   
> + When you change your retention settings, the new settings only apply to new logs ingested after the change. Existing logs are subject to the previous retention settings.
> + Deleting a diagnostic setting doesn't delete the logs in the storage account. The retention settings will continue to apply to the logs created before the diagnostic settings were deleted.


Use the following CLI command to check if a resource has a diagnostic setting:

```azurecli
 az monitor diagnostic-settings list --resource <resource Id>
```
The output shows whether the diagnostic setting sends the data to a storage account, for example:

```JSON
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

## [Azure portal](#tab/portal)

To migrate your diagnostics settings retention rules, follow the steps below:

1. Go to the Diagnostic Settings page for your logging resource and locate the diagnostic setting you wish to migrate
1. Set the retention for your logged categories to *0*
1. Select **Save**
 :::image type="content" source="./media/retention-migration/diagnostics-setting.png"  lightbox="./media/retention-migration/diagnostics-setting.png" alt-text="A screenshot showing a diagnostics setting page.":::

1. Navigate to the storage account you're logging to
1. Under **Data management**, select **Lifecycle Management** to view or change lifecycle management policies
1. Select List View, and select **Add a rule**
:::image type="content" source="./media/retention-migration/lifecycle-management.png" lightbox="./media/retention-migration/lifecycle-management.png" alt-text="A screenshot showing the lifecycle management screen for a storage account.":::
1. Enter a **Rule name**
1. Under **Rule Scope**, select **Limit blobs with filters**
1. Under **Blob Type**, select  **Append Blobs** and **Base blobs** under **Blob subtype**.
1. Select **Next**
:::image type="content" source="./media/retention-migration/lifecycle-management-add-rule-details.png" lightbox="./media/retention-migration/lifecycle-management-add-rule-details.png" alt-text="A screenshot showing the details tab for adding a lifecycle rule.":::

1. Set your retention time, then select **Next**
:::image type="content" source="./media/retention-migration/lifecycle-management-add-rule-base-blobs.png" lightbox="./media/retention-migration/lifecycle-management-add-rule-base-blobs.png" alt-text="A screenshot showing the Base blobs tab for adding a lifecycle rule.":::

1. On the **Filters** tab, under **Blob prefix** set path or prefix to the container or logs you want the retention rule to apply to.   The path or prefix can be at any level within the container and will apply to all blobs under that path or prefix.
For example, for *all* insight activity logs, use the container *insights-activity-logs* to set the retention for all of the logs in that container.  
To set the rule for a specific webapp app, use *insights-activity-logs/ResourceId=/SUBSCRIPTIONS/\<your subscription Id\>/RESOURCEGROUPS/\<your resource group\>/PROVIDERS/MICROSOFT.WEB/SITES/\<your webapp name\>*. 

    Use the Storage browser to help you find the path or prefix.   
    The example below shows the prefix for a specific web app: **insights-activity-logs/ResourceId=/SUBSCRIPTIONS/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/RESOURCEGROUPS/rg-001/PROVIDERS/MICROSOFT.WEB/SITES/appfromdocker1*.  
    To set the rule for all resources in the resource group, use *insights-activity-logs/ResourceId=/SUBSCRIPTIONS/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e7/RESOURCEGROUPS/rg-001*.
    :::image type="content" source="./media/retention-migration/blob-prefix.png" alt-text="A screenshot showing the Storage browser and resource path." lightbox="./media/retention-migration/blob-prefix.png":::

1. Select **Add** to save the rule.
:::image type="content" source="./media/retention-migration/lifecycle-management-add-rule-filter-set.png" lightbox="./media/retention-migration/lifecycle-management-add-rule-filter-set.png" alt-text="A screenshot showing the filters tab for adding a lifecycle rule.":::


## [CLI](#tab/cli)

Use the [az storage account management-policy create](/cli/azure/storage/account/management-policy#az-storage-account-management-policy-create) command to create a lifecycle management policy. You must still set the retention in your diagnostic settings to *0*. For more information, see the migration procedures for the Azure portal.



```azurecli

az storage account management-policy create   --account-name <storage account name> --resource-group <resource group name> --policy @<policy definition file>
```

The sample policy definition file below sets the retention for all blobs in the container *insights-activity-logs* for the given subscription ID. For more information, see [Lifecycle management policy definition](/azure/storage/blobs/lifecycle-management-overview#lifecycle-management-policy-definition).

```json
{
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




```

## [Templates](#tab/templates)

Apply the following template to create a lifecycle management policy. You must still set the retention in your diagnostic settings to *0*. For more information, see the migration procedures for the Azure portal.

```azurecli

az deployment group create  --resource-group <resource group name> --template-file <template file>

```

The following template sets the retention for storage account *azmonstorageaccount001* for all blobs in the container *insights-activity-logs* for all resources for the subscription ID *aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e*.

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

## Next steps

[Configure a lifecycle management policy](/azure/storage/blobs/lifecycle-management-policy-configure?tabs=azure-portal).
