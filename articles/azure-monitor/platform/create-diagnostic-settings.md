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



> [!NOTE]
> Allow up to 90 minutes for data to start arriving at destinations after a diagnostic setting is created. 


## [Azure portal](#tab/portal)


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


---

## Troubleshooting

**Metric category isn't supported**<br>
You may receive an error message similar to *Metric category 'xxxx' is not supported* when using a Resource Manager template, REST API, Azure CLI, or Azure PowerShell. Metric categories other than `AllMetrics` aren't supported except for a limited number of Azure services. Remove any metric category names other than `AllMetrics` and repeat your deployment. 

**Setting disappears due to non-ASCII characters in resourceID**<br>
Diagnostic settings don't support resource IDs with non-ASCII characters (for example, Preproduccón). Since you can't rename resources in Azure, you must create a new resource without the non-ASCII characters. If the characters are in a resource group, you can move the resources to a new group.

**Inactive resources**<br>
When a resource is inactive and exporting zero-value metrics, the diagnostic settings export mechanism backs off incrementally to avoid unnecessary costs of exporting and storing zero values. This back-off may lead to a delay in the export of the next non-zero value. This behavior only applies to exported metrics and doesn't affect metrics-based alerts or autoscale.

When a resource is inactive for one hour, the export mechanism backs off to 15 minutes. This means that there is a potential latency of up to 15 minutes for the next nonzero value to be exported. The maximum backoff time of two hours is reached after seven days of inactivity. Once the resource starts exporting nonzero values, the export mechanism reverts to the original export latency of three minutes. 

**Duplicate data for Application Insights**<br>
Diagnostic settings for workspace-based Application insights applications collect the same data as Application insights itself. This results in duplicate data being collected if the destination is the same Log Analytics workspace that the application is using. Create a diagnostic setting for Application insights to send data to a different Log Analytics workspace or another destination. 


## Next steps

* [Review how to work with diagnostic settings in Azure Monitor](diagnostic-settings.md)
* [Migrate diagnostic settings storage retention to Azure Storage lifecycle management](migrate-to-azure-storage-lifecycle-policy.md)
* [Read more about Azure Monitor data sources and data collection methods](../fundamentals/data-sources.md)