---
title: Diagnostic settings in Azure Monitor
description: Learn about working with diagnostic settings for Azure Monitor platform metrics and logs.
ms.topic: article
ms.custom:
ms.date: 01/16/2025
ms.reviewer: lualderm
---

# Diagnostic settings in Azure Monitor

Diagnostic settings in Azure Monitor allow you to collect [resource logs](./resource-logs.md) and to send [platform metrics](./metrics-supported.md) and the [activity log](./activity-log.md) to different destinations. Create a separate diagnostic setting for each resource you want to collect data from. Each setting defines the data from the resource to collect and the destinations to send that data to.


The following video walks through routing resource platform logs with diagnostic settings. The following changes were made to diagnostic settings since the video was recorded. 

- [Azure Monitor partners](#destinations)
- [Category groups](#category-groups)


> [!VIDEO https://learn-video.azurefd.net/vod/player?id=2e9e11cc-fc03-4caa-8fee-4386abf454bc]
> 
## Controlling costs
There may be a cost for data collected by diagnostic settings. The cost depends on the destination you choose and the volume of data collected. For more information, see [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/).
 
Only collect the categories you require for each service. You might also not want to collect platform metrics from Azure resources because this data is already being collected in Metrics. Only configure your diagnostic data to collect metrics if you need metric data in the workspace for more complex analysis with log queries.

Diagnostic settings don't allow granular filtering within a selected category. You can filter data for supported tables in a Log Analytics workspace using transformations. See [Transformations in Azure Monitor](../data-collection/data-collection-transformations.md) for details.

## Prerequisites

- Any destinations used by the diagnostic setting must exist before the setting can be created. The destination doesn't have to be in the same subscription as the resource sending logs if the user who configures the setting has appropriate Azure role-based access control access to both subscriptions. Use Azure Lighthouse to include destinations in another Microsoft Entra tenant. 
- See [Destinations](#destinations) for details on the requirements for each destination type.


## Sources

Diagnostic settings can collect data from the sources in the following table.

| Data source | Description |
|:---|:---|
| [Platform metrics](./metrics-supported.md) | Automatically collected without configuration. Use a diagnostic setting to sent platform metrics to other [destinations](#destinations). |
| [Activity log](./activity-log.md) | Automatically collected without configuration. Use a diagnostic setting to sent activity log entries to other [destinations](#destinations). |
| [Resource logs](./resource-logs.md) | Aren't collected by default. Create a diagnostic setting to collect resource logs. |

## Destinations

Diagnostic settings send data to the destinations in the following table.To ensure the security of data in transit, all destination endpoints are configured to support TLS 1.2. A single diagnostic setting can define no more than one of each of the destinations. If you want to send data to more than one of a particular destination type (for example, two different Log Analytics workspaces), create multiple settings. Each resource can have up to five diagnostic settings.

| Destination | Description | Requirements |
|:---|:---|:---|
| [Log Analytics workspace](../logs/workspace-design.md) | Retrieve data using [log queries](../logs/log-query-overview.md) and [workbooks](../visualize/workbooks-overview.md). Use [log alerts](../alerts/alerts-types.md#log-search-alerts) to proactively alert on data. See [Azure Monitor Resource log reference](/azure/azure-monitor/reference/tables-index) for the tables used by different Azure resources. | Any tables in a Log Analytics workspace are created automatically when the first data is sent to the workspace, so only the workspace itself must exist. |
| [Azure Storage account](/azure/storage/blobs/) | Store for audit, static analysis, or back up. Storage may be less expensive than other options and can be kept indefinitely. Send data to immutable storage to prevent its modification. Set the immutable policy for the storage account as described in [Set and manage immutability policies for Azure Blob Storage](/azure/storage/blobs/immutable-policy-configure-version-scope). | Storage accounts must be in the same region as the resource being monitored if the resource is regional. [Azure DNS zone endpoints (preview)](/azure/storage/common/storage-account-overview#azure-dns-zone-endpoints-preview) and any [Premium storage accounts](/azure/storage/common/storage-account-overview#types-of-storage-accounts) aren't supported as a destination. Any [Standard storage accounts](/azure/storage/common/storage-account-overview#types-of-storage-accounts) are supported.  | 
| [Azure Event Hubs](/azure/event-hubs/) | Stream data to external systems such as third-party SIEMs and other Log Analytics solutions. | Event hubs must to be in the same region as the resource being monitored if the resource is regional. The shared access policy for event hub namespace defines the permissions that the streaming mechanism has. Streaming to Event Hubs requires `Manage`, `Send`, and `Listen` permissions. To update the diagnostic setting to include streaming, you must have the `ListKey` permission on that Event Hubs authorization rule. |
| [Azure Monitor partner solutions](/azure/partner-solutions/partners#observability)| Specialized integrations can be made between Azure Monitor and other non-Microsoft monitoring platforms. The solutions vary by partner. | See [Azure Native ISV Services documentation](/azure/partner-solutions/overview) for details.|


- Diagnostic settings can't access storage accounts or event hubs when virtual networks are enabled. Enable **Allow trusted Microsoft services** to bypass this firewall setting in storage accounts and event hubs.

## Create a diagnostic setting

### [Azure portal](#tab/portal)


1. Where you configure diagnostic settings in the Azure portal depends on the resource:

    * For a single resource, select **Diagnostic settings** under **Monitoring** on the resource's menu.

        :::image type="content" source="media/diagnostic-settings/menu-resource.png" alt-text="Screenshot that shows the Monitoring section of a resource menu in the Azure portal with Diagnostic settings highlighted." border="false":::

    * For one or more resources, select **Diagnostic settings** under **Settings** on the Azure Monitor menu and then select the resource.

        :::image type="content" source="media/diagnostic-settings/menu-monitor.png" alt-text="Screenshot that shows the Settings section in the Azure Monitor menu with Diagnostic settings highlighted."border="false":::

    * For the activity log, select **Activity log** on the **Azure Monitor** menu and then select **Export Activity Logs**. Make sure you disable any legacy configuration for the activity log. For instructions, see [Disable existing settings](activity-log.md#legacy-collection-methods).

        :::image type="content" source="media/diagnostic-settings/menu-activity-log.png" alt-text="Screenshot that shows the Azure Monitor menu with Activity log selected and Export activity logs highlighted in the Monitor-Activity log menu bar.":::

1.  Select **Add diagnostic setting** to add a new setting or **Edit setting** to edit an existing one. You may need multiple diagnostic settings for a resource if you want to send to multiple destinations of the same type.

    :::image type="Add diagnostic setting - existing settings" source="media/diagnostic-settings/edit-setting.png" alt-text="Screenshot that shows adding a diagnostic setting for existing settings.":::

1. Give your setting a descriptive name if it doesn't already have one. 

    :::image type="Add diagnostic setting" source="media/diagnostic-settings/setting-new-blank.png" alt-text="Screenshot that shows Diagnostic setting name.":::

2. **Logs and metrics to route**: For logs, either choose a [category group](#category-group) or select the individual checkboxes for each category of data you want to send to the destinations specified later. The list of categories varies for each Azure service. Select **AllMetrics** if you want to collect platform metrics.

3. **Destination details**: Select the checkbox for each destination that should be included in the diagnostic settings and then provide the details for each. If you select Log Analytics workspace as a destination, then you may need to specify the collection mode. See [Collection mode](./resource-logs.md#collection-mode).


### [PowerShell](#tab/powershell)

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

### [CLI](#tab/cli)

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

### [ARM template](#tab/arm)

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


---

   
## Category groups

You can use *category groups* to collect resource logs based on predefined groupings instead of selecting individual log categories. Microsoft defines the groupings to help monitor common use cases. If the categories in the group are updated, your log collection is modified automatically. 

If you do use category groups in a diagnostic setting, you can't select individual category types. You also can't apply retention settings to any logs sent to Azure Storage.

Currently, there are two category groups:

- **allLogs**: all categories for the resource.
- **audit**: All resource logs that record customer interactions with data or the settings of the service. You don't need to select this category group if you select the **allLogs** category group.


> [!NOTE]
> - Not all Azure services use category groups. If category groups aren't available for a particular resource, then the option won't be available when create the diagnostic setting. 
> - Enabling the Audit category in the diagnostic settings for Azure SQL Database does not activate auditing for the database. To enable database auditing, you have to enable it from the auditing blade for Azure Database. 




> [!NOTE]
>
> Resource Logs aren't completely lossless. They're based on a store and forward architecture designed to affordably move petabytes of data per day at scale. This capability includes built-in redundancy and retries across the platform but doesn't provide transactional guarantees. Anytime a persistent source of data loss is identified, its resolution and future prevention is prioritized. Small data losses may still occur to temporary, non-repeating service issues distributed across Azure.


## Metrics limitations

Not all metrics can be sent to a Log Analytics workspace with diagnostic settings. See the **Exportable** column in the [list of supported metrics](./metrics-supported.md).

Diagnostic settings don't currently support multi-dimensional metrics. Metrics with dimensions are exported as flattened single-dimensional metrics and aggregated across dimension values. For example, the **IOReadBytes** metric on a blockchain can be explored and charted on a per-node level. When exported with diagnostic settings, the metric exported shows all read bytes for all nodes.

To work around the limitations for specific metrics, you can manually extract them by using the [Metrics REST API](/rest/api/monitor/metrics/list) and then import them into a Log Analytics workspace with the [Logs ingestion API](../logs/logs-ingestion-api-overview.md).





## Deleting diagnostic settings
Delete any diagnostic settings for a resource if you delete or rename that resource, or migrate it across resource groups or subscriptions. If you recreate this resource, any diagnostic settings for the deleted resource could be applied to the new one. This resumes the collection of resource logs as defined in the diagnostic setting. 

## Next steps

- [Create diagnostic settings for Azure Monitor platform metrics and logs](./create-diagnostic-settings.md)
- [Migrate diagnostic settings storage retention to Azure Storage lifecycle management](./migrate-to-azure-storage-lifecycle-policy.md)
- [Read more about Azure platform logs](./platform-logs-overview.md)