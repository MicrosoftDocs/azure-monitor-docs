---
title: Create diagnostic settings in Azure Monitor
description: Learn how to send Azure Monitor platform metrics and logs to Azure Monitor Logs, Azure Storage, or Azure Event Hubs with diagnostic settings.
ms.topic: how-to
ms.custom: devx-track-azurecli, devx-track-azurepowershell
ms.date: 08/11/2024
ms.reviewer: lualderm
---

# Create diagnostic settings in Azure Monitor

Create and edit diagnostic settings in Azure Monitor to send Azure platform metrics and logs to different destinations like Azure Monitor Logs, Azure Storage, or Azure Event Hubs. You can use different methods to work with the diagnostic settings, such as the Azure portal, the Azure CLI, PowerShell, and Azure Resource Manager.

## Prerequisites
- Any destinations used by the diagnostic setting must exist before the setting can be created. Any tables in a Log Analytics workspace are created automatically when the first data is sent to the workspace, so only the workspace itself must exist.


## [Azure portal](#tab/portal)


1. Where you configure diagnostic settings in the Azure portal depends on the resource:

    * For a single resource, select **Diagnostic settings** under **Monitoring** on the resource's menu.

        :::image type="content" source="media/diagnostic-settings/menu-resource.png" alt-text="Screenshot that shows the Monitoring section of a resource menu in the Azure portal with Diagnostic settings highlighted." border="false":::

    * For one or more resources, select **Diagnostic settings** under **Settings** on the Azure Monitor menu and then select the resource.

        :::image type="content" source="media/diagnostic-settings/menu-monitor.png" alt-text="Screenshot that shows the Settings section in the Azure Monitor menu with Diagnostic settings highlighted."border="false":::

    * For the activity log, select **Activity log** on the **Azure Monitor** menu and then select **Export Activity Logs**. Make sure you disable any legacy configuration for the activity log. For instructions, see [Disable existing settings](activity-log.md#legacy-collection-methods).

        :::image type="content" source="media/diagnostic-settings/menu-activity-log.png" alt-text="Screenshot that shows the Azure Monitor menu with Activity log selected and Export activity logs highlighted in the Monitor-Activity log menu bar.":::

1.  Select **Add diagnostic setting** to add a new setting or select **Edit setting** to edit an existing one. You may need multiple diagnostic settings for a resource if you want to send to multiple destinations of the same type.

    :::image type="Add diagnostic setting - existing settings" source="media/diagnostic-settings/edit-setting.png" alt-text="Screenshot that shows adding a diagnostic setting for existing settings.":::

1. Give your setting a name if it doesn't already have one.

    :::image type="Add diagnostic setting" source="media/diagnostic-settings/setting-new-blank.png" alt-text="Screenshot that shows Diagnostic setting name.":::

1. **Logs and metrics to route**: For logs, either choose a category group or select the individual checkboxes for each category of data you want to send to the destinations specified later. The list of categories varies for each Azure service. Select **AllMetrics** if you want to store metrics in Azure Monitor Logs too.

1. **Destination details**: Select the checkbox for each destination. Options appear so that you can add more information.

    :::image type="content" source="media/diagnostic-settings/send-to-log-analytics-event-hubs.png" alt-text="Screenshot that shows the available options under the Destination details section." border="false":::

    1. **Send to Log Analytics workspace**: Select your **Subscription** and the **Log Analytics workspace** where you want to send the data. If you don't have a workspace, you must [create one before you proceed](../logs/quick-create-workspace.md).

    1. **Archive to a storage account**: Select your **Subscription** and the **Storage account** where you want to store the data.

        :::image type="content" source="media/diagnostic-settings/storage-settings-new.png" alt-text="Screenshot that shows storage category and destination details." lightbox="media/diagnostic-settings/storage-settings-new.png":::
        
        > [!TIP]
        > Use the [Azure Storage Lifecycle Policy](/azure/storage/blobs/lifecycle-management-policy-configure?tabs=azure-portal) to manage the length of time that your logs are retained. The Retention Policy as set in the Diagnostic Setting settings is now deprecated.

    1. **Stream to an event hub**: Specify the following criteria:

        * **Subscription**: The subscription that the event hub is part of.
        * **Event hub namespace**: If you don't have one, you must [create one](/azure/event-hubs/event-hubs-create).
        * **Event hub name (optional)**: The name to send all data to. If you don't specify a name, an event hub is created for each log category. If you're sending to multiple categories, you might want to specify a name to limit the number of event hubs created. For more information, see [Azure Event Hubs quotas and limits](/azure/event-hubs/event-hubs-quotas).
        * **Event hub policy name** (also optional): A policy defines the permissions that the streaming mechanism has. For more information, see [Event Hubs features](/azure/event-hubs/event-hubs-features#publisher-policy).

    1. **Send to partner solution**: You must first install Azure Native ISV Services into your subscription. Configuration options vary by partner. For more information, see [Azure Native ISV Services overview](/azure/partner-solutions/overview).


## [PowerShell](#tab/powershell)

Use the [New-AzDiagnosticSetting](/powershell/module/az.monitor/new-azdiagnosticsetting) cmdlet to create a diagnostic setting with [Azure PowerShell](/powershell/module/az.monitor). See the documentation for this cmdlet for descriptions of its parameters.

> [!IMPORTANT]
> You can't use this method for an activity log. Instead, use [Create diagnostic setting in Azure Monitor by using an Azure Resource Manager template](resource-manager-diagnostic-settings.md) to create a Resource Manager template and deploy it with PowerShell.

The following example PowerShell script creates a diagnostic setting to send all logs and metrics for a key vault to a Log Analytics Workspace.

```powershell
$KV = Get-AzKeyVault -ResourceGroupName <resource group name> -VaultName <key vault name>
$Law = Get-AzOperationalInsightsWorkspace -ResourceGroupName <resource group name> -Name <workspace name>  # LAW name is case sensitive

$metric = New-AzDiagnosticSettingMetricSettingsObject -Enabled $true -Category AllMetrics
$log = New-AzDiagnosticSettingLogSettingsObject -Enabled $true -CategoryGroup allLogs  # use audit for only audit logs
New-AzDiagnosticSetting -Name 'KeyVault-Diagnostics' -ResourceId $KV.ResourceId -WorkspaceId $Law.ResourceId -Log $log -Metric $metric -Verbose
```

## [CLI](#tab/cli)

Use the [az monitor diagnostic-settings create](/cli/azure/monitor/diagnostic-settings#az-monitor-diagnostic-settings-create) command to create a diagnostic setting with the [Azure CLI](/cli/azure/monitor). See the documentation for this command for descriptions of its parameters.

> [!IMPORTANT]
> You can't use this method for an activity log. Instead, use [Create diagnostic setting in Azure Monitor by using a Resource Manager template](resource-manager-diagnostic-settings.md) to create a Resource Manager template and deploy it with the Azure CLI.

The following example script creates a diagnostic setting that sends data to all three destinations. To specify [resource-specific mode](resource-logs.md#resource-specific) if the service supports it, add the `export-to-resource-specific` parameter with a value of `true`.`

```azurecli
az monitor diagnostic-settings create  \
--name KeyVault-Diagnostics \
--resource /subscriptions/<subscription ID>/resourceGroups/<resource group name>/providers/Microsoft.KeyVault/vaults/mykeyvault \
--logs    '[{"category": "AuditEvent","enabled": true}]' \
--metrics '[{"category": "AllMetrics","enabled": true}]' \
--storage-account /subscriptions/<subscription ID>/resourceGroups/<resource group name>/providers/Microsoft.Storage/storageAccounts/<storage account name> \
--workspace /subscriptions/<subscription ID>/resourcegroups/<resource group name>/providers/microsoft.operationalinsights/workspaces/<log analytics workspace name> \
--event-hub-rule /subscriptions/<subscription ID>/resourceGroups/<resource group name>/providers/Microsoft.EventHub/namespaces/<event hub namespace>/authorizationrules/RootManageSharedAccessKey \
--event-hub <event hub name> \
--export-to-resource-specific true
```

## [ARM template](#tab/arm)

The following sample template creates a diagnostic setting to send all audit logs to a log analytics workspace. The `apiVersion` can change depending on the resource in the scope.

**Template file**

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "scope": {
        "type": "string"
    },
    "workspaceId": {
        "type": "string"
    },
    "settingName": {
        "type": "string"
    }
},
  "resources": [
    {
      "type": "Microsoft.Insights/diagnosticSettings",
      "apiVersion": "2021-05-01-preview",
      "scope": "[parameters('scope')]",
      "name": "[parameters('settingName')]",
      "properties": {
       "workspaceId": "[parameters('workspaceId')]",
      "logs": [
             {
            "category": null,
            "categoryGroup": "audit",
            "enabled": true
          }
        ]
      }
    }
  ]
  }
```

**Parameter file**

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "settingName": {
        "value": "audit3"
    },
    "workspaceId": {
      "value": "/subscriptions/<subscription id>/resourcegroups/<resourcegroup name>/providers/microsoft.operationalinsights/workspaces/<workspace name>"
    },
    "scope": {
      "value": "Microsoft.<resource type>/<resourceName>"
    }
  }
}
```



## [REST API](#tab/api)

To create or update diagnostic settings by using the [Azure Monitor REST API](/rest/api/monitor/), see [Diagnostic settings](/rest/api/monitor/diagnosticsettings).

---

## Troubleshooting

### Metric category isn't supported
You may receive an error message similar to *Metric category 'xxxx' is not supported* when using a Resource Manager template, REST API, Azure CLI, or Azure PowerShell. Metric categories other than `AllMetrics` aren't supported except for a limited number of Azure services. Remove any metric category names other than `AllMetrics` and repeat your deployment. 

### Setting disappears due to non-ASCII characters in resourceID
Diagnostic settings don't support resource IDs with non-ASCII characters (for example, Preproduccón). Since you can't rename resources in Azure, you must create a new resource without the non-ASCII characters. If the characters are in a resource group, you can move the resources to a new group.

### Inactive resources
When a resource is inactive and exporting zero-value metrics, the diagnostic settings export mechanism backs off incrementally to avoid unnecessary costs of exporting and storing zero values. This back-off may lead to a delay in the export of the next non-zero value. This behavior only applies to exported metrics and doesn't affect metrics-based alerts or autoscale.

When a resource is inactive for one hour, the export mechanism backs off to 15 minutes. This means that there is a potential latency of up to 15 minutes for the next nonzero value to be exported. The maximum backoff time of two hours is reached after seven days of inactivity. Once the resource starts exporting nonzero values, the export mechanism reverts to the original export latency of three minutes. 


### Duplicate data for Application Insights

When you create a diagnostic Settings to export workspace-based Application Insights data to any Log Analytics workspace—including the same one that already stores Application Insights data—queries return duplicate results. This duplication happens because both the default pipeline and Diagnostic Settings send the same data to the workspace.

To avoid duplicate telemetry, don't configure Diagnostic Settings to send data to the same workspace. If you need to export data to a different workspace, use a Data Collection Rule (DCR) with a transformation and a custom table. This setup filters the data before ingestion and prevents duplicate records in your queries.



## Next steps

* [Review how to work with diagnostic settings in Azure Monitor](diagnostic-settings.md)
* [Migrate diagnostic settings storage retention to Azure Storage lifecycle management](migrate-to-azure-storage-lifecycle-policy.md)
* [Read more about Azure Monitor data sources and data collection methods](../fundamentals/data-sources.md)