---
title: Diagnostic Settings in Azure Monitor
description: Learn about working with diagnostic settings for Azure Monitor platform metrics and logs.
ms.topic: article
ms.custom:
ms.date: 07/17/2025
ms.reviewer: lualderm
---

# Diagnostic settings in Azure Monitor

You can use diagnostic settings in Azure Monitor to collect [resource logs](./resource-logs.md) and to send [platform metrics](./metrics-supported.md) and the [activity log](./activity-log.md) to various destinations. Create a separate diagnostic setting for each resource that you want to collect data from. Each setting defines the data from the resource to collect and the destinations to send that data to. This article describes the details of diagnostic settings, including how to create them and the destinations available for sending data.

:::image type="content" source="media/diagnostic-settings/platform-logs-metrics.png" lightbox="media/diagnostic-settings/platform-logs-metrics.png" alt-text="Diagram that shows collection of activity logs, resource logs, and platform metrics." border="false":::

The following video walks through routing resource platform logs with diagnostic settings. The following changes were made to diagnostic settings since the video was recorded, but these topics are discussed in this article.

- [Azure Monitor partners](#destinations)
- [Category groups](#category-groups)

> [!VIDEO https://learn-video.azurefd.net/vod/player?id=2e9e11cc-fc03-4caa-8fee-4386abf454bc]

> [!WARNING]
> Delete any diagnostic settings for a resource if you delete or rename that resource, or if you migrate it across resource groups or subscriptions. If the diagnostic setting isn't removed and this resource is re-created, any diagnostic settings for the deleted resource could be applied to the new one. For some resource types, this situation would resume the collection of resource logs as defined in the diagnostic setting.

## Sources

Diagnostic settings can collect data from the sources in the following table. For details on the data that each source collects and its format in each destination, see the linked article.

| Data source | Description |
| :--- | :--- |
| [Platform metrics](./metrics-supported.md) | Automatically collected without configuration. Use a diagnostic setting to send platform metrics to other destinations. |
| [Activity log](./activity-log.md) | Automatically collected without configuration. Use a diagnostic setting to send activity log entries to other destinations. |
| [Resource logs](./resource-logs.md) | Aren't collected by default. Create a diagnostic setting to collect resource logs. |

## Destinations

Diagnostic settings send data to the destinations in the following table. To help ensure the security of data in transit, all destination endpoints are configured to support TLS 1.2.

A single diagnostic setting can define no more than one of each destination. If you want to send data to more than one of a particular destination type (for example, two Log Analytics workspaces), create multiple settings. Each resource can have up to five diagnostic settings.

Any destinations that a diagnostic setting uses must exist before you can create the setting. The destination doesn't have to be in the same subscription as the resource that's sending logs if the user who configures the setting has appropriate Azure role-based access control (RBAC) access to both subscriptions. Use Azure Lighthouse to include destinations in another Microsoft Entra tenant.

| Destination | Description | Requirements |
| :--- | :--- | :--- |
| [Log Analytics workspace](../logs/workspace-design.md) | Retrieve data by using [log queries](../logs/log-query-overview.md) and [workbooks](../visualize/workbooks-overview.md). Use [log alerts](../alerts/alerts-types.md#log-alerts) to proactively alert on data. For the tables that various Azure resources use, see the [Azure Monitor resource log reference](/azure/azure-monitor/reference/tables-index). | Any tables in a Log Analytics workspace are created automatically when the first data is sent to the workspace, so only the workspace itself must exist. |
| [Azure Storage account](/azure/storage/blobs/) | Store for audit, static analysis, or backup. Storage might be less expensive than other options and can be kept indefinitely. Send data to immutable storage to prevent its modification. Set the immutable policy for the storage account as described in [Configure immutability policies for blob versions](/azure/storage/blobs/immutable-policy-configure-version-scope). | Storage accounts must be in the same region as the resource that you're monitoring if the resource is regional.<br><br>Diagnostic settings can't access storage accounts when virtual networks are enabled. You must enable **Allow trusted Microsoft services** to bypass this firewall setting in storage accounts so that the Azure Monitor diagnostic settings service is granted access to your storage account.<br><br>[Azure DNS zone endpoints (preview)](/azure/storage/common/storage-account-overview#azure-dns-zone-endpoints-preview) and any [Premium storage accounts](/azure/storage/common/storage-account-overview#types-of-storage-accounts) aren't supported as destinations. Any [Standard storage accounts](/azure/storage/common/storage-account-overview#types-of-storage-accounts) are supported. |
| [Azure Event Hubs](/azure/event-hubs/) | Stream data to external systems such as non-Microsoft security information and event management (SIEM) solutions and other Log Analytics solutions. | Event hubs must be in the same region as the resource that you're monitoring if the resource is regional. You can't use a [compacted event hub](/azure/event-hubs/log-compaction) because it requires the message to have a partition key, which Azure Monitor doesn't include.<br><br>Diagnostic settings can't access event hubs when virtual networks are enabled. You must enable **Allow trusted Microsoft services** to bypass this firewall setting in event hubs so that the Azure Monitor diagnostic settings service is granted access to your event hub resources.<br><br>The shared access policy for an Event Hubs namespace defines the permissions that the streaming mechanism has. Streaming to event hubs requires `Manage`, `Send`, and `Listen` permissions. To update the diagnostic setting to include streaming, you must have the `ListKey` permission on that Event Hubs authorization rule. |
| [Azure Monitor partner solutions](/azure/partner-solutions/partners#observability) | Specialized integrations are possible between Azure Monitor and other non-Microsoft monitoring platforms. The solutions vary by partner. | For details, see [Azure Native ISV Services documentation](/azure/partner-solutions/overview). |

## Methods for creating a diagnostic setting

You can create a diagnostic setting by using any of the following methods.

To create a diagnostic setting for the activity log by using the Azure portal, see [Export activity log](./activity-log.md#export-activity-log). To create a diagnostic setting for a management group, see [Management Group Diagnostic Settings](/rest/api/monitor/management-group-diagnostic-settings).

### [Azure portal](#tab/portal)

Use the following steps to create a new diagnostic setting or to edit an existing one in the Azure portal:

1. On a resource's menu, in the **Monitoring** section, select **Diagnostic settings**. Or, on the Azure Monitor menu, select **Settings** > **Diagnostic settings**. Then select the resource.

2. Select **Add diagnostic setting** to add a new setting, or select **Edit setting** to edit an existing one.

    You might need multiple diagnostic settings for a resource if you want to send to multiple destinations of the same type. The following example shows the settings for a key vault resource, but the screen is similar for other resources.

    :::image type="Add diagnostic setting - existing settings" source="media/diagnostic-settings/edit-setting.png" lightbox="media/diagnostic-settings/edit-setting.png" alt-text="Screenshot that shows adding a diagnostic setting for existing settings.":::

3. Give your setting a descriptive name if it doesn't already have one.

    :::image type="Add diagnostic setting" source="media/diagnostic-settings/setting-new-blank.png" lightbox="media/diagnostic-settings/setting-new-blank.png" alt-text="Screenshot that shows Diagnostic setting details.":::

   This screenshot shows an example key vault. Other types of resources have different sets of categories.

4. For **Logs**, either choose a [category group](#category-groups) or select the individual checkboxes for each category of data that you want to send to the destinations. The list of categories varies for each Azure service.

5. For **Metrics**, select **AllMetrics** if you want to collect platform metrics.

6. For **Destination details**, select the checkbox for each destination that you want to include in the diagnostic settings. Then provide the details for each destination.

   If you select a Log Analytics workspace as a destination, you might need to specify the collection mode. For details, see [Collection mode](./resource-logs.md#collection-mode).

### [PowerShell](#tab/powershell)

Use the [New-AzDiagnosticSetting](/powershell/module/az.monitor/new-azdiagnosticsetting) cmdlet to create a diagnostic setting via [Azure PowerShell](/powershell/module/az.monitor). For descriptions of parameters, see the documentation for this cmdlet.

> [!IMPORTANT]
> You can't use this method for an activity log. Instead, create an [Azure Resource Manager template](resource-manager-diagnostic-settings.md) and deploy it by using PowerShell.

The following example PowerShell script creates a diagnostic setting to send all logs and metrics for a key vault to a Log Analytics workspace:

```powershell
$KV = Get-AzKeyVault -ResourceGroupName <resource group name> -VaultName <key vault name>
$Law = Get-AzOperationalInsightsWorkspace -ResourceGroupName <resource group name> -Name <workspace name>  # LAW name is case sensitive

$metric = New-AzDiagnosticSettingMetricSettingsObject -Enabled $true -Category AllMetrics
$log = New-AzDiagnosticSettingLogSettingsObject -Enabled $true -CategoryGroup allLogs  # use audit for only audit logs
New-AzDiagnosticSetting -Name 'KeyVault-Diagnostics' -ResourceId $KV.ResourceId -WorkspaceId $Law.ResourceId -Log $log -Metric $metric -Verbose
```

### [CLI](#tab/cli)

Use the [az monitor diagnostic-settings create](/cli/azure/monitor/diagnostic-settings#az-monitor-diagnostic-settings-create) command to create a diagnostic setting via the [Azure CLI](/cli/azure/monitor). For descriptions of parameters, see the documentation for this command.

> [!IMPORTANT]
> You can't use this method for an activity log. Instead, create an [Azure Resource Manager template](resource-manager-diagnostic-settings.md) and deploy it by using the Azure CLI.

The following example script creates a diagnostic setting that sends data to all three destinations. To specify [resource-specific mode](resource-logs.md#resource-specific) if the service supports it, add the `export-to-resource-specific` parameter with a value of `true`.

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

### [Resource Manager template](#tab/arm)

The following sample template creates a diagnostic setting to send all audit logs to a Log Analytics workspace. The `apiVersion` value can change depending on the resource in the scope. For sample templates for other resources, see [Resource Manager template samples for diagnostic settings in Azure Monitor](./resource-manager-diagnostic-settings.md).

Here's the template file:

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

Here's the parameter file:

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

### [REST API template](#tab/rest)

To create or edit a diagnostic setting by using the Azure Monitor REST API, see [Diagnostic Settings - Create Or Update](/rest/api/monitor/diagnostic-settings/create-or-update).

---

> [!WARNING]
> When you create or update diagnostic settings for a storage account or an Event Hubs namespace, you can't select that account or namespace a destination for the resource logs or metrics data. This limitation is by design. Sending resource logs or metrics from a resource to the same resource would generate an infinite loop of generating and writing data.
>
> This design applies only to the Azure portal UX layer. If there's truly a need to write data to the same resource and you're willing to accept the associated risks, you can create the diagnostic setting by using Azure PowerShell, the Azure CLI, the REST API, a Resource Manager template, or a supported Microsoft SDK.

## Category groups

You can use *category groups* to collect resource logs based on predefined groupings instead of selecting individual log categories. Microsoft defines the groupings to help monitor common use cases. If the categories in the group are updated, your log collection is modified automatically.

Not all Azure services use category groups. If category groups aren't available for a particular resource, the option won't be available when you create the diagnostic setting.

If you do use category groups in a diagnostic setting, you can't select individual category types. Currently, there are two category groups:

- `allLogs`: All categories for the resource.
- `audit`: All resource logs that record customer interactions with data or the settings of the service. You don't need to select this category group if you select the `allLogs` category group.

> [!NOTE]
> Enabling the `audit` category in the diagnostic settings for Azure SQL Database does not activate auditing for the database. To enable database auditing, you have to enable it from the auditing pane for Azure SQL Database.

## Metrics limitations

Not all metrics can be sent to a Log Analytics workspace with diagnostic settings. See the **Exportable** column in the [list of supported metrics](./metrics-supported.md).

Diagnostic settings don't currently support multidimensional metrics. Metrics with dimensions are exported as flattened single-dimensional metrics and aggregated across dimension values. For example, the `IOReadBytes` metric on a blockchain can be explored and charted on a per-node level. When the metric is exported with diagnostic settings, it shows all read bytes for all nodes.

To work around the limitations for specific metrics, you can manually extract them by using the [Metrics REST API](/rest/api/monitor/metrics/list). You can then import them into a Log Analytics workspace by using the [Logs Ingestion API](../logs/logs-ingestion-api-overview.md).

## Controlling costs

There might be a cost for data that diagnostic settings collect. The cost depends on the destination that you choose and the volume of collected data. For more information, see [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/).

Collect only the categories that you need for each service. You might also not want to collect platform metrics from Azure resources, because this data is already being collected in **Metrics**. Configure your diagnostic data to collect metrics only if you need metric data in the workspace for more complex analysis with log queries.

Diagnostic settings don't allow granular filtering within a selected category. You can filter data for supported tables in a Log Analytics workspace by using transformations. For details, see [Transformations in Azure Monitor](../data-collection/data-collection-transformations.md).

## Time before data gets to destinations

After you create a diagnostic setting, data should start flowing to your selected destinations within 90 minutes. When you're sending data to a Log Analytics workspace, the table is created automatically if it doesn't already exist. The table is created only when the destinations receive the first log records.

If you get no information within 24 hours, you might be experiencing one of the following problems:

- No logs are being generated.
- Something is wrong in the underlying routing mechanism.

Try disabling the configuration and then reenabling it. If the problem continues, contact Azure support through the Azure portal.

## Application Insights

Consider the following information for diagnostic settings for Application Insights applications:

- The destination can't be the same Log Analytics workspace that your Application Insights resource is based on.
- The Application Insights user can't have access to both workspaces. Set the Log Analytics [access control mode](/azure/azure-monitor/logs/log-analytics-workspace-overview) to **Requires workspace permissions**. Through [Azure RBAC](/azure/azure-monitor/app/resources-roles-access-control), ensure that the user has access to only the Log Analytics workspace that the Application Insights resource is based on.

These steps are necessary because Application Insights accesses data across resources to provide complete end-to-end transaction operations and accurate application maps. These resources include Log Analytics workspaces. Because diagnostic logs use the same table names, duplicate data can appear if the user has access to multiple resources that contain the same data.

## Troubleshooting

### Metric category isn't supported

You might receive an error message similar to "Metric category 'xxxx' is not supported" when you're using a Resource Manager template, the REST API, the Azure CLI, or Azure PowerShell. Metric categories other than `AllMetrics` aren't supported, except for a limited number of Azure services. Remove any metric category names other than `AllMetrics` and repeat your deployment.

### Setting disappears due to non-ASCII characters in a resource ID

Diagnostic settings don't support resource IDs with non-ASCII characters (for example, **Preproduccón**). Because you can't rename resources in Azure, you must create a new resource without the non-ASCII characters. If the characters are in a resource group, you can move the resources to a new group.

### Resource is inactive

When a resource is inactive and exporting zero-value metrics, the diagnostic settings' export mechanism backs off incrementally to avoid unnecessary costs of exporting and storing zero values. This back-off might lead to a delay in the export of the next nonzero value. This behavior applies only to exported metrics and doesn't affect metrics-based alerts or autoscale.

When a resource is inactive for one hour, the export mechanism backs off to 15 minutes. This situation means that there's a potential latency of up to 15 minutes for the next nonzero value to be exported. The resource reaches maximum backoff time of two hours after seven days of inactivity. After the resource starts exporting nonzero values, the export mechanism reverts to the original export latency of three minutes.

## Related content

- [Migrate from diagnostic settings storage retention to Azure Storage lifecycle management](./migrate-to-azure-storage-lifecycle-policy.md)
- [Azure Monitor data sources and data collection methods](./platform-logs-overview.md)
