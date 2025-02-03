---
title: Create and configure Application Insights resources
description: Learn how to create and configure Application Insights resources programmatically and in the Azure portal
ms.topic: conceptual
ms.date: 01/31/2025
ms.reviewer: cogoodson
ms.custom: devx-track-azurepowershell, devx-track-azurecli
---

# Create and configure Application Insights resources

> [!IMPORTANT]
> This article applies to *workspace-based* Application Insights resources. Classic Application Insights resources have been retired. [Transition to workspace-based Application Insights](/previous-versions/azure/azure-monitor/app/convert-classic-resource) to take advantage of new capabilities.

[Application Insights](app-insights-overview.md) integrates with [Log Analytics](../logs/log-analytics-overview.md) and sends telemetry to a common Log Analytics workspace. This setup provides full access to Log Analytics features, consolidates logs in one location, and allows for unified [Azure role-based access control](../roles-permissions-security.md) which eliminates the need for cross-app/workspace queries.

Enhanced capabilities include:

* [Customer-managed keys](../logs/customer-managed-keys.md) encrypt your data at rest with keys only accessible to you.
* [Azure Private Link](../logs/private-link-security.md) securely connects Azure PaaS services to your virtual network using private endpoints.
* [Bring your own storage (BYOS)](./profiler-bring-your-own-storage.md) lets you manage data from [.NET Profiler](../profiler/profiler-overview.md) and [Snapshot Debugger](../snapshot-debugger/snapshot-debugger.md) with policies on encryption, lifetime, and network access.
* [Commitment tiers](../logs/cost-logs.md#commitment-tiers) offer up to a 30% saving over pay-as-you-go pricing.
* Log Analytics streaming processes data more quickly.

This article shows you how to create and configure Application Insights resources. Along with the Application Insights resource itself, you can add various configurations like setting the [daily](#set-the-daily-cap) cap and [pricing plan](#set-the-pricing-plan). You can also create [availability tests](#create-an-availability-test), set up [metric alerts](#add-a-metric-alert), and automate the process using [Azure Resource Manager](/azure/azure-resource-manager/management/overview).

> [!NOTE]
> Data ingestion and retention for workspace-based Application Insights resources are billed through the Log Analytics workspace where the data is located. To learn more about billing for workspace-based Application Insights resources, see [Azure Monitor Logs pricing details](../logs/cost-logs.md).

## Prerequisites

> [!div class="checklist"]
> * An active Azure subscription.
> * The necessary permissions to create resources.

### Additional requirements

### [Portal](#tab/portal)

No additional requirements for the Azure portal.

### [Azure CLI](#tab/cli)

To access the preview Application Insights Azure CLI commands, you first need to run:

```azurecli
 az extension add -n application-insights
```

If you don't run the `az extension add` command, you see an error message that states `az : ERROR: az monitor: 'app-insights' is not in the 'az monitor' command group. See 'az monitor --help'`.

### [PowerShell](#tab/powershell)

If you haven't used PowerShell with your Azure subscription before, install the Azure PowerShell module on the machine where you want to run the scripts:

1. Install [Microsoft Web Platform Installer (v5 or higher)](https://www.microsoft.com/web/downloads/platform.aspx).
1. Use it to install Azure PowerShell.

[!INCLUDE [updated-for-az](~/reusable-content/ce-skilling/azure/includes/updated-for-az.md)]

### [REST](#tab/rest)

To make a REST API call to Azure, you first need to obtain an access token. 

For more information, see [Manage Azure resources by using the REST API](/azure/azure-resource-manager/management/manage-resources-rest#obtain-an-access-token).

### [Bicep](#tab/bicep)

You can deploy Bicep templates via the Azure CLI, Azure PowerShell, and in the Azure portal. Check the respective tabs for additional prerequisites.

### [JSON (ARM)](#tab/arm)

You can deploy JSON templates via the Azure CLI, Azure PowerShell, and in the Azure portal. Check the respective tabs for additional prerequisites.

---

## Create an Application Insights resource

## [Portal](#tab/portal)

Sign in to the [Azure portal](https://portal.azure.com), and create an Application Insights resource.

:::image type="content" source="./media/create-workspace-resource/create-resource.png" lightbox="./media/create-workspace-resource/create-resource.png" alt-text="Screenshot that shows an Application Insights resource.":::

> [!NOTE]
> If you don't connect to an existing Log Analytics workspace during resource creation, a new Log Analytics resource is created automatically along with your Application Insights resource.

After you create your resource, you'll see corresponding workspace information in the **Overview** pane.

:::image type="content" source="./media/create-workspace-resource/workspace-name.png" lightbox="./media/create-workspace-resource/workspace-name.png" alt-text="Screenshot that shows a workspace name.":::

Select the blue link text to go to the associated Log Analytics workspace where you can take advantage of the new unified workspace query environment.

> [!NOTE]
> We still provide full backward compatibility for your Application Insights classic resource queries, workbooks, and log-based alerts. To query or view the [new workspace-based table structure or schema](/previous-versions/azure/azure-monitor/app/convert-classic-resource#workspace-based-resource-changes), you must first go to your Log Analytics workspace. Select **Logs (Analytics)** in the **Application Insights** panes for access to the classic Application Insights query experience.

## [Azure CLI](#tab/cli)

To create a workspace-based Application Insights resource, a Log Analytics workspace is required. If you don't have one already, you can use the following Azure CLI command to create one:

```azurecli
az monitor log-analytics workspace create --resource-group <resource-group-name> --workspace-name <log-analytics-workspace-name> --location <azure-region-name>
```

To create an Application Insights resource, run the following Azure CLI command in your terminal and replace the placeholders `<application-insights-resource-name>`, `<azure-region-name>`, `<resource-group-name>`, and `<log-analytics-workspace-name>` with your specific values:

```azurecli
az monitor app-insights component create --app <application-insights-resource-name> --location <azure-region-name> --resource-group <resource-group-name> --workspace <log-analytics-workspace-name>
```

For more information about the `az monitor app-insights component create` command, refer to the [Azure CLI documentation](/cli/azure/monitor/app-insights/component#az-monitor-app-insights-component-create).

## [PowerShell](#tab/powershell)

To create a workspace-based Application Insights resource, a Log Analytics workspace is required. If you don't have one already, you can use the following Azure PowerShell command to create one:

```azurepowershell
New-AzApplicationInsights -ResourceGroupName <resource-group-name> -Name <log-analytics-workspace-name> -Location <azure-region-name>
```

To create an Application Insights resource, run the following Azure PowerShell command in your terminal and replace the placeholders `<resource-group-name>`, `<application-insights-resource-name>`, and `<azure-region-name>`, and `<subscription-id>`, and `<log-analytics-workspace-name>` with your specific values:

```azurepowershell
New-AzApplicationInsights -ResourceGroupName <resource-group-name> -Name <application-insights-resource-name> -Location <azure-region-name> -WorkspaceResourceId /subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.OperationalInsights/workspaces/<log-analytics-workspace-name>
```

For more information about the `New-AzApplicationInsights` command, refer to the [Azure PowerShell documentation](/powershell/module/az.applicationinsights/new-azapplicationinsights).

## [REST](#tab/rest)

To create an Application Insights resource using the REST API, use the following request and replace the placeholders `{subscription-id}`, `{resource-group-name}`, `{application-insights-resource-name}`, `{access-token}`, and `{azure-region-name}` with your specific values:

```http
PUT https://management.azure.com/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Insights/components/{application-insights-resource-name}?api-version=2015-05-01
Authorization: Bearer {access-token}
Content-Type: application/json


{
  "location": "{azure-region-name}",
  "kind": "web",
  "properties": {
    "Application_Type": "web",
    "Flow_Type": "Bluefield",
    "Request_Source": "rest"
  }
}
```

For more information about creating and updating Application Insights resources using the REST API, see the [REST API documentation](/rest/api/application-insights/components/create-or-update).

## [Bicep](#tab/bicep)

Here's how to create a new Application Insights resource using a Bicep (ARM) template.

### Create a template

Create a new *.bicep* file (for example, *template1.bicep*) and copy the following content into it:

```bicep
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  location: regionId
  tags: tagsArray
  kind: 'other'
  properties: {
    Application_Type: type
    Flow_Type: 'Bluefield'
    Request_Source: requestSource
    WorkspaceResourceId: workspaceResourceId
  }
}
```

### Create a parameter file

Create a new *.bicepparam* file (for example, *parameters1.bicepparam*), copy the following content into it, and replace all placeholders with your own values:

```bicep
param name string = 'my_workspace_based_resource'
param type string = 'web'
param regionId string = 'westus2'
param requestSource string = 'CustomDeployment'
param workspaceResourceId string = '/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/testxxxx/providers/microsoft.operationalinsights/workspaces/testworkspace'
```

### Use the template to create a new Application Insights resource

1. In PowerShell, sign in to Azure by using `$Connect-AzAccount`.
1. Set your context to a subscription with `Set-AzContext "<subscription ID>"`.
1. Run a new deployment to create a new Application Insights resource:

    ```azurepowershell
    New-AzResourceGroupDeployment -ResourceGroupName <your-resource-group> -TemplateFile template1.bicep -TemplateParameterFile parameters1.bicepparam
    ``` 

   * `-ResourceGroupName` is the group where you want to create the new resources.
   * `-TemplateFile` must occur before the custom parameters.
   * `-TemplateParameterFile` is the name of the parameter file.

You can add other parameters. You find their descriptions in the parameters section of the template.

## [JSON (ARM)](#tab/arm)

Here's how to create a new Application Insights resource using a JSON (ARM) template.

### Create a template

1. Create a new *.json* file (for example, *template1.json*) and copy the following content into it:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "name": {
      "type": "string",
      "metadata": {
        "description": "Name of Application Insights resource."
      }
    },
    "type": {
      "type": "string",
      "metadata": {
        "description": "Type of app you are deploying. This field is for legacy reasons and will not impact the type of Application Insights resource you deploy."
      }
    },
    "regionId": {
      "type": "string",
      "metadata": {
        "description": "Which Azure region to deploy the resource to. This must be a valid Azure regionId."
      }
    },
    "tagsArray": {
      "type": "object",
      "metadata": {
        "description": "See documentation on tags: https://learn.microsoft.com/azure/azure-resource-manager/management/tag-resources."
      }
    },
    "requestSource": {
      "type": "string",
      "metadata": {
        "description": "Source of Azure Resource Manager deployment"
      }
    },
    "workspaceResourceId": {
      "type": "string",
      "metadata": {
        "description": "Log Analytics workspace ID to associate with your Application Insights resource."
      }
    }
  },
  "resources": [
    {
      "type": "Microsoft.Insights/components",
      "apiVersion": "2020-02-02",
      "name": "[parameters('name')]",
      "location": "[parameters('regionId')]",
      "tags": "[parameters('tagsArray')]",
      "kind": "other",
      "properties": {
        "Application_Type": "[parameters('type')]",
        "Flow_Type": "Bluefield",
        "Request_Source": "[parameters('requestSource')]",
        "WorkspaceResourceId": "[parameters('workspaceResourceId')]"
      }
    }
  ]
}
```

> [!NOTE]
> For more information on resource properties, see [Property values](/azure/templates/microsoft.insights/components?tabs=bicep#property-values).
> `Flow_Type` and `Request_Source` aren't used but are included in this sample for completeness.

### Create a parameter file

Create a new *.json* file (for example, *parameters1.json*), copy the following content into it, and replace all placeholders with your own values:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "name": {
      "value": "my_workspace_based_resource"
    },
    "type": {
      "value": "web"
    },
    "regionId": {
      "value": "westus2"
    },
    "tagsArray": {
      "value": {}
    },
    "requestSource": {
      "value": "CustomDeployment"
    },
    "workspaceResourceId": {
      "value": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/testxxxx/providers/microsoft.operationalinsights/workspaces/testworkspace"
    }
  }
}
```

### Use the template to create a new Application Insights resource

1. In PowerShell, sign in to Azure by using `$Connect-AzAccount`.
1. Set your context to a subscription with `Set-AzContext "<subscription ID>"`.
1. Run a new deployment to create a new Application Insights resource:

    ```azurepowershell
    New-AzResourceGroupDeployment -ResourceGroupName <your-resource-group> -TemplateFile template1.json -TemplateParameterFile parameters1.json
    ```

   * `-ResourceGroupName` is the group where you want to create the new resources.
   * `-TemplateFile` must occur before the custom parameters.
   * `-TemplateParameterFile` is the name of the parameter file.

---

## Configure monitoring

After creating an Application Insights resource, you configure monitoring.

### Get the connection string

The [connection string](./connection-strings.md?tabs=net) identifies the resource that you want to associate your telemetry data with. You can also use it to modify the endpoints your resource uses as a destination for your telemetry. You must copy the connection string and add it to your application's code or to an environment variable.

### [Portal](#tab/portal)

To get the connection string of your Application Insights resource:

1. Open your Application Insights resource in the Azure portal.
1. On the Overview pane, look for the connection string under **Essentials**.
1. If you hover over the connection string, an icon appears which allows you to copy it to your clipboard.

### [Azure CLI](#tab/cli)

To get the connection string, run the following Azure CLI command in your terminal and replace the placeholders `<application-insights-resource-name>` and `<resource-group-name>` with your specific values:

```azurecli
az monitor app-insights component show --app <application-insights-resource-name> --resource-group <resource-group-name> --query connectionString --output tsv
```

For more information about the `az monitor app-insights component show` command, refer to the [Azure CLI documentation](/cli/azure/monitor/app-insights/component#az-monitor-app-insights-component-show).

### [PowerShell](#tab/powershell)

To get the connection string, run the following Azure PowerShell command in your terminal and replace the placeholders `<resource-group-name>` and `<application-insights-resource-name>` with your specific values:

```azurepowershell
Get-AzApplicationInsights -ResourceGroupName <resource-group-name> -Name <application-insights-resource-name> | Select-Object -ExpandProperty ConnectionString
```

For more information about the `Get-AzApplicationInsights` command, refer to the [Azure PowerShell documentation](/powershell/module/az.applicationinsights/get-azapplicationinsights).

### [REST](#tab/rest)

To retrieve the details of your Application Insights resource, use the following request and replace the placeholders `{subscription-id}`, and `{resource-group-name}`, `{application-insights-resource-name}`, and `{access-token}` with your specific values:

```http
GET https://management.azure.com/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Insights/components/{application-insights-resource-name}?api-version=2015-05-01
Authorization: Bearer {access-token}
```

Look for the `properties.connectionString` field in the JSON response.

### [Bicep](#tab/bicep)

Not applicable to Bicep templates.

### [JSON (ARM)](#tab/arm)

Not applicable to ARM templates.

---

### Application monitoring with OpenTelemetry

For application monitoring with OpenTelemetry, you install the appropriate Azure Monitor OpenTelemetry Distro and point the connection string to your newly created resource.

For information on how to set up application monitoring with OpenTelemetry, see the following documentation specific to the language:

* [ASP.NET Core](/azure/azure-monitor/app/opentelemetry-enable?tabs=aspnetcore#enable-opentelemetry-with-application-insights)
* [.NET](/azure/azure-monitor/app/opentelemetry-enable?tabs=net#enable-opentelemetry-with-application-insights)
* [Java](/azure/azure-monitor/app/opentelemetry-enable?tabs=java#enable-opentelemetry-with-application-insights)
* [Java native](/azure/azure-monitor/app/opentelemetry-enable?tabs=java-native#enable-opentelemetry-with-application-insights)
* [Node.js](/azure/azure-monitor/app/opentelemetry-enable?tabs=nodejs#enable-opentelemetry-with-application-insights)
* [Python](/azure/azure-monitor/app/opentelemetry-enable?tabs=python#enable-opentelemetry-with-application-insights)

> [!NOTE]
> For web apps targeting browsers, it's recommended to use the [Application Insights JavaScript SDK](javascript-sdk.md).

<!--
* [Background tasks and modern console applications (.NET/.NET Core)](./worker-service.md)
* [Classic console applications (.NET)](./console.md)
-->

### Automatic instrumentation

For monitoring services like [Azure Functions](/azure/azure-functions/functions-overview) and [Azure App Service](/azure/app-service/overview), you can first create your Application Insights resource, then point to it when you enable monitoring. Alternatively, you can create a new Application Insights resource during the enablement process.

## Configure Application Insights resources

### Modify the associated workspace

After creating an Application Insights resource, you can modify the associated Log Analytics workspace.

### [Portal](#tab/portal)

In the Application Insights resource pane, select **Properties** > **Change Workspace** > **Log Analytics Workspaces**.

### [Azure CLI](#tab/cli)

To change the Log Analytics workspace, run the following Azure CLI command in your terminal and replace the placeholders `<application-insights-resource-name>`, `<resource-group-name>`, and `<new-log-analytics-workspace-name>` with your specific values:

```azurecli
az monitor app-insights component update --app <application-insights-resource-name> --resource-group <resource-group-name> --workspace <new-log-analytics-workspace-name>
```

For more information about the `az monitor app-insights component update` command, refer to the [Azure CLI documentation](/cli/azure/monitor/app-insights/component#az-monitor-app-insights-component-update).

### [PowerShell](#tab/powershell)

To change the Log Analytics workspace, run the following Azure PowerShell command in your terminal and replace the placeholders `<resource-group-name>`, `<application-insights-resource-name>`, `<subscription-id>` and `<new-log-analytics-workspace-name>` with your specific values:

```azurepowershell
Update-AzApplicationInsights -ResourceGroupName <resource-group-name> -Name <application-insights-resource-name> -WorkspaceResourceId /subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.OperationalInsights/workspaces/<new-log-analytics-workspace-name>
```

For more information about the `Update-AzApplicationInsights` command, refer to the [Azure PowerShell documentation](/powershell/module/az.applicationinsights/update-azapplicationinsights).

### [REST](#tab/rest)

To change the Log Analytics workspace using REST API, use the following request and replace the placeholders `{subscription-id}`, `{resource-group-name}`, `{application-insights-resource-name}`, and `{new-workspace-name}` with your specific values:

```http
PATCH https://management.azure.com/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Insights/components/{application-insights-resource-name}?api-version=2015-05-01
Authorization: Bearer {access-token}
Content-Type: application/json

{
  "properties": {
    "WorkspaceResourceId": "/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.OperationalInsights/workspaces/{new-workspace-name}"
  }
}
```

### [Bicep](#tab/bicep)

To change the Log Analytics workspace, paste the following code into your template and replace the placeholders `<application-insights-resource-name>`, `<azure-region-name>`, `<application-type>`, and `<new-workspace-resource-id>` with your specific values:

```bicep
resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: '<application-insights-resource-name>'
  location: '<azure-region-name>'
  properties: {
    Application_Type: '<application-type>'
    WorkspaceResourceId: '<new-workspace-resource-id>'
  }
}
```

### [JSON (ARM)](#tab/arm)

To change the Log Analytics workspace, paste the following code into your template and replace the placeholders `<application-insights-resource-name>`, `<azure-region-name>`, `<application-type>`, and `<new-workspace-resource-id>` with your specific values:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Insights/components",
      "apiVersion": "2020-02-02-preview",
      "name": "<application-insights-resource-name>",
      "location": "<azure-region-name>",
      "properties": {
        "Application_Type": "<application-type>",
        "WorkspaceResourceId": "<new-workspace-resource-id>"
      }
    }
  ]
}
```

---

### Export telemetry

The legacy continuous export functionality isn't supported for workspace-based resources. Instead, use [Diagnostic settings](./../essentials/diagnostic-settings.md).

> [!NOTE]
> Diagnostic settings export might increase costs. For more information, see [Export telemetry from Application Insights](export-telemetry.md#diagnostic-settings-based-export).
> For pricing information for this feature, see the [Azure Monitor pricing page](https://azure.microsoft.com/pricing/details/monitor/). Before the start of billing, notifications are sent. If you continue to use telemetry export after the notice period, you'll be billed at the applicable rate.

### [Portal](#tab/portal)

Select **Diagnostic settings** > **Add diagnostic setting** in your Application Insights resource.

You can select all tables or a subset of tables to archive to a storage account. You can also stream to an [event hub](/azure/event-hubs/event-hubs-about).

### [Azure CLI](#tab/cli)

To export telemetry using diagnostic settings, run the following Azure CLI command in your terminal and replace the placeholders `<diagnostic-setting-name>`, `<application-insights-resource-name>`, `<resource-group-name>`, and `<storage-account-name>` with your specific values:

```azurecli
az monitor diagnostic-settings create --name <diagnostic-setting-name> --resource <application-insights-resource-name> --resource-group <resource-group-name> --resource-type Microsoft.Insights/components --storage-account <storage-account-name>
```

This example command enables diagnostic settings and sends all logs of your Application Insights resource to the specified storage account. To also send metrics, add `--metrics '[{"category": "AllMetrics", "enabled": true}]'` to the command.

For more information about the `az monitor diagnostic-settings create` command, refer to the [Azure CLI documentation](/cli/azure/monitor/diagnostic-settings#az-monitor-diagnostic-settings-create).

### [PowerShell](#tab/powershell)

To export telemetry using diagnostic settings, run the following Azure PowerShell command in your terminal and replace the placeholders `<application-insights-resource-id>`, `<diagnostic-setting-name>`, and `<storage-account-id>` with your specific values:

```azurepowershell
Set-AzDiagnosticSetting -ResourceId <application-insights-resource-id> -Name <diagnostic-setting-name> -StorageAccountId <storage-account-id> -Enabled $True
```

This example command enables diagnostic settings and sends all metrics and logs of your Application Insights resource to the specified storage account.

For more information about the `Set-AzDiagnosticSetting` command, refer to the [Azure PowerShell documentation](/powershell/module/az.monitor/set-azdiagnosticsetting).

### [REST](#tab/rest)

To export telemetry to an Azure storage account using a diagnostic setting, use the following request and replace the placeholders `{subscription-id}`, `{resource-group-name}`, `{application-insights-resource-name}`, `{setting-name}`, `{access-token}`, and `{storage-account-name}` with your specific values:

```http
PUT https://management.azure.com/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/microsoft.insights/components/{application-insights-resource-name}/diagnosticSettings/{setting-name}?api-version=2017-05-01-preview
Authorization: Bearer {access-token}
Content-Type: application/json

{
  "properties": {
    "storageAccountId": "/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Storage/storageAccounts/{storage-account-name}",
    "logs": [
      {
        "category": "Request",
        "enabled": true,
        "retentionPolicy": {
          "enabled": true,
          "days": 30
        }
      }
    ]
  }
}
```

### [Bicep](#tab/bicep)

To export telemetry using diagnostic settings, paste the following code into your template and replace the placeholders `<application-insights-resource-name>`, `<azure-region-name>`, `<application-type>`, and `<new-workspace-resource-id>` with your specific values:

```bicep
param location string = resourceGroup().location
param appInsightsName string = 'myAppInsights'
param storageAccountId string = '/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Storage/storageAccounts/<storage-account-name>'

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'myDiagnosticSetting'
  scope: appInsights
  properties: {
    storageAccountId: storageAccountId
    logs: [
      {
        category: 'Request'
        enabled: true
        retentionPolicy: {
          days: 30
          enabled: true
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          days: 30
          enabled: true
        }
      }
    ]
  }
}
```

### [JSON (ARM)](#tab/arm)

To export telemetry using diagnostic settings, paste the following code into your template and replace the placeholders `<application-insights-resource-name>`, `<azure-region-name>`, `<application-type>`, and `<new-workspace-resource-id>` with your specific values:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "appInsightsName": {
      "type": "string",
      "defaultValue": "myAppInsights"
    },
    "storageAccountId": {
      "type": "string",
      "defaultValue": "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Storage/storageAccounts/<storage-account-name>"
    }
  },
  "resources": [
    {
      "type": "Microsoft.Insights/components",
      "apiVersion": "2020-02-02",
      "name": "[parameters('appInsightsName')]",
      "location": "[resourceGroup().location]",
      "kind": "web",
      "properties": {
        "Application_Type": "web"
      }
    },
    {
      "type": "Microsoft.Insights/diagnosticSettings",
      "apiVersion": "2021-05-01-preview",
      "name": "myDiagnosticSetting",
      "dependsOn": [
        "[resourceId('Microsoft.Insights/components', parameters('appInsightsName'))]"
      ],
      "properties": {
        "storageAccountId": "[parameters('storageAccountId')]",
        "logs": [
          {
            "category": "Request",
            "enabled": true,
            "retentionPolicy": {
              "days": 30,
              "enabled": true
            }
          }
        ],
        "metrics": [
          {
            "category": "AllMetrics",
            "enabled": true,
            "retentionPolicy": {
              "days": 30,
              "enabled": true
            }
          }
        ]
      }
    }
  ]
}
```

---

### Set the data retention

### [Portal](#tab/portal)

Data retention for Application Insights resources can be set in the associated Log Analytics workspace.

For more information, see [Configure the default interactive retention period of Analytics tables](/azure/azure-monitor/logs/data-retention-configure?tabs=portal#configure-the-default-interactive-retention-period-of-analytics-tables).

### [Azure CLI](#tab/cli)

Data retention for Application Insights resources can be set in the associated Log Analytics workspace.

For more information, see [Configure the default interactive retention period of Analytics tables](/azure/azure-monitor/logs/data-retention-configure?tabs=cli#configure-the-default-interactive-retention-period-of-analytics-tables).

### [PowerShell](#tab/powershell)

Data retention for Application Insights resources can be set in the associated Log Analytics workspace.

For more information, see [Configure the default interactive retention period of Analytics tables](/azure/azure-monitor/logs/data-retention-configure?tabs=PowerShell#configure-the-default-interactive-retention-period-of-analytics-tables).

### [REST](#tab/rest)

Data retention for Application Insights resources can be set in the associated Log Analytics workspace.

For more information, see [Configure the default interactive retention period of Analytics tables](/azure/azure-monitor/logs/data-retention-configure?tabs=api#configure-the-default-interactive-retention-period-of-analytics-tables).

### [Bicep](#tab/bicep)

To set the data retention for the associated Log Analytics workspace, paste the following code into your template and replace the placeholders `<log-analytics-workspace-name>`, `<azure-region-name>`, `<retention-period-in-days>` with your specific values:

```bicep
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: '<log-analytics-workspace-name>'
  location: '<azure-region-name>'
  properties: {
    retentionInDays: <retention-period-in-days>
  }
}
```

### [JSON (ARM)](#tab/arm)

To set the data retention for the associated Log Analytics workspace, paste the following code into your template and replace the placeholders `<log-analytics-workspace-name>`, `<azure-region-name>`, `<retention-period-in-days>` with your specific values:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.OperationalInsights/workspaces",
      "apiVersion": "2020-08-01",
      "name": "<log-analytics-workspace-name>",
      "location": "<azure-region-name>",
      "properties": {
        "retentionInDays": <retention-period-in-days>
      }
    }
  ]
}
```

---

### Set the daily cap

The daily cap must be set independently for both Application Insights and the underlying Log Analytics workspace. The effective daily cap is the minimum of the two settings.

### [Portal](#tab/portal)

To learn how to set the daily cap in the Azure portal, see [Set daily cap on Log Analytics workspace](./../logs/daily-cap.md#application-insights).

### [Azure CLI](#tab/cli)

> [!NOTE]
> Currently, Azure doesn't provide a command to set a daily cap for Application Insights via the Azure CLI.

To change the daily cap for Log Analytics, run the following Azure CLI command in your terminal and replace the placeholders `<resource-group-name>`, `<log-analytics-workspace-name>`, and `<daily-cap-in-gb>` with your specific values.

```azurecli
az monitor log-analytics workspace update --resource-group <resource-group-name> --workspace-name <log-analytics-workspace-name> --set workspaceCapping.dailyQuotaGb=<daily-cap-in-gb>
```

For more information about the `az monitor log-analytics workspace update` command, refer to the [Azure CLI documentation](/cli/azure/monitor/log-analytics/workspace#az-monitor-log-analytics-workspace-update).

### [PowerShell](#tab/powershell)

To change the daily cap for Application Insights and Log Analytics, run the following Azure PowerShell commands in your terminal and replace the placeholders with your specific values.

**Application Insights**

Placeholders: `<resource-group-name>`, `<application-insights-resource-name>`, `<daily-cap-in-gb>` 

```azurepowershell
Set-AzApplicationInsightsDailyCap -ResourceGroupName <resource-group-name> -Name <application-insights-resource-name> -DailyCapGB <daily-cap-in-gb>
```

For more information about the `Set-AzApplicationInsightsDailyCap` command, refer to the [Azure PowerShell documentation](/powershell/module/az.applicationinsights/set-azapplicationinsightsdailycap).

**Log Analytics**

Placeholders: `<resource-group-name>`, `<log-analytics-workspace-name>`, `<daily-cap-in-gb>` 

```azurepowershell
Set-AzOperationalInsightsWorkspace -ResourceGroupName <resource-group-name> -Name <log-analytics-workspace-name> -DailyQuotaGb <daily-cap-in-gb>
```

For more information about the `Set-AzOperationalInsightsWorkspace` command, refer to the [Azure PowerShell documentation](/powershell/module/az.operationalinsights/set-azoperationalinsightsworkspace).

### [REST](#tab/rest)

To set the daily cap for both Application Insights and Log Analytics, use the following requests and replace the placeholders with your specific values:

**Application Insights**

Placeholders: `{subscription-id}`, `{resource-group-name}`, `{application-insights-resource-name}`, `{access-token}`, `<daily-cap-in-gb>`

```http
PATCH https://management.azure.com/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Insights/components/{application-insights-resource-name}?api-version=2015-05-01
Authorization: Bearer {access-token}
Content-Type: application/json

{
  "properties": {
    "DailyCap": <daily-cap-in-gb>
  }
}
```

**Log Analytics**

Placeholders: `{subscription-id}`, `{resource-group-name}`, `{log-analytics-workspace-name}`, `{access-token}`, `<daily-cap-in-gb>`

```http
PATCH https://management.azure.com/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.OperationalInsights/workspaces/{log-analytics-workspace-name}?api-version=2020-08-01
Authorization: Bearer {access-token}
Content-Type: application/json

{
  "properties": {
    "dailyQuotaGb": <daily-cap-in-gb>
  }
}
```

### [Bicep](#tab/bicep)

To set the daily cap for both Application Insights and Log Analytics, paste the following code into your template and replace the placeholders with your specific values:

**Application Insights**

Placeholders: `{application-insights-resource-name}`, `{azure-region-name}`, `<daily-cap-in-gb>`

```bicep
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: '{application-insights-resource-name}'
  location: '{azure-region-name}'
  properties: {
    Application_Type: 'web'
    DailyCap: <daily-cap-in-gb>
  }
}
```

**Log Analytics**

Placeholders: `{log-analytics-workspace-name}`, `{azure-region-name}`, `<daily-cap-in-gb>`

```bicep
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: '{log-analytics-workspace-name}'
  location: '{azure-region-name}'
  properties: {
    dailyQuotaGb: <daily-cap-in-gb>
  }
}
```

### [JSON (ARM)](#tab/arm)

To set the daily cap for both Application Insights and Log Analytics, paste the following code into your template and replace the placeholders with your specific values:

**Application Insights**

Placeholders: `{application-insights-resource-name}`, `{azure-region-name}`, `<daily-cap-in-gb>`

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Insights/components",
      "apiVersion": "2020-02-02",
      "name": "{application-insights-resource-name}",
      "location": "{azure-region-name}",
      "properties": {
        "Application_Type": "web",
        "DailyCap": <daily-cap-in-gb>
      }
    }
  ]
}
```

**Log Analytics**

Placeholders: `{log-analytics-workspace-name}`, `{azure-region-name}`, `<daily-cap-in-gb>`

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.OperationalInsights/workspaces",
      "apiVersion": "2020-08-01",
      "name": "{log-analytics-workspace-name}",
      "location": "{azure-region-name}",
      "properties": {
        "dailyQuotaGb": <daily-cap-in-gb>
      }
    }
  ]
}
```

---

### Set the pricing plan

The pricing plan for Application Insights resources can be set in the associated Log Analytics workspace.

### [Portal](#tab/portal)

The pricing plan for Application Insights resources can be set in the associated Log Analytics workspace. For more information, see [Application Insights billing](./../logs/cost-logs.md#application-insights-billing).

### [Azure CLI](#tab/cli)

To set the pricing plan, run the following Azure CLI command in your terminal and replace the placeholders `<resource-group-name>`, `<log-analytics-workspace-name>`, and `<pricing-plan>` with your specific values:

```azurecli
az monitor log-analytics workspace update --resource-group <resource-group-name> --workspace-name <log-analytics-workspace-name> --set <pricing-plan>
```

For more information about the `az monitor log-analytics workspace update` command, refer to the [Azure CLI documentation](/cli/azure/monitor/log-analytics/workspace#az-monitor-log-analytics-workspace-update).

### [PowerShell](#tab/powershell)

To set the pricing plan, run the following Azure PowerShell command in your terminal and replace the placeholders `<resource-group-name>`, `<log-analytics-workspace-name>`, and `<pricing-plan>` with your specific values:

```azurepowershell
Set-AzOperationalInsightsWorkspace -ResourceGroupName <resource-group-name> -Name <log-analytics-workspace-name> -Sku <pricing-plan>
```

For more information about the `Set-AzOperationalInsightsWorkspace` command, refer to the [Azure PowerShell documentation](/powershell/module/az.operationalinsights/set-azoperationalinsightsworkspace).

### [REST](#tab/rest)

To set the pricing plan using REST API, use the following request and replace the placeholders `{subscription-id}`, `{resource-group-name}`, `{application-insights-resource-name}`, and `{access-token}` with your specific values:

```http
PATCH https://management.azure.com/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Insights/components/{application-insights-resource-name}?api-version=2015-05-01
Authorization: Bearer {access-token}
Content-Type: application/json

{
  "properties": {
    "PricingPlan": "Basic"
  }
}
```

### [Bicep](#tab/bicep)

To set the pricing plan using Bicep, paste the following code into your template and replace the placeholders with your specific values:

```bicep
param location string = resourceGroup().location
param appInsightsName string = 'myAppInsights'
param pricingPlan string = 'Basic'

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

resource pricingPlan 'Microsoft.Insights/components/pricingPlans@2017-10-01' = {
  name: 'current'
  parent: appInsights
  properties: {
    planType: pricingPlan
  }
}
```

### [JSON (ARM)](#tab/arm)

To set the pricing plan using JSON (ARM), paste the following code into your template and replace the placeholders with your specific values:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "appInsightsName": {
      "type": "string",
      "defaultValue": "myAppInsights"
    },
    "pricingPlan": {
      "type": "string",
      "defaultValue": "Basic"
    }
  },
  "resources": [
    {
      "type": "Microsoft.Insights/components",
      "apiVersion": "2020-02-02",
      "name": "[parameters('appInsightsName')]",
      "location": "[resourceGroup().location]",
      "kind": "web",
      "properties": {
        "Application_Type": "web"
      }
    },
    {
      "type": "Microsoft.Insights/components/pricingPlans",
      "apiVersion": "2017-10-01",
      "name": "current",
      "dependsOn": [
        "[resourceId('Microsoft.Insights/components', parameters('appInsightsName'))]"
      ],
      "properties": {
        "planType": "[parameters('pricingPlan')]"
      }
    }
  ]
}
```

---

## Create additional resources

### Create an availability test

### [Portal](#tab/portal)

To learn how to create an availability test in the Azure portal, see [Application Insights availability tests](./availability.md#create-an-availability-test).

### [Azure CLI](#tab/cli)

To create a standard availability test with default settings, run the following Azure CLI command in your terminal and replace the placeholders `<resource-group-name>`, `<azure-region-name>`, `<web-test-name>`, `<url>`, `<subscription-id>`, and `<application-insights-resource-name>` with your specific values:

```azurecli
az monitor app-insights web-test create --resource-group <resource-group-name> \
                                        --location <azure-region-name> \
                                        --web-test-kind standard \
                                        --name <web-test-name> \
                                        --defined-web-test-name <web-test-name> \
                                        --request-url <url> \
                                        --retry-enabled true \
                                        --ssl-check true \
                                        --ssl-lifetime-check 7 \
                                        --frequency 300 \
                                        --locations Id="us-ca-sjc-azr" \
                                        --locations Id="apac-sg-sin-azr" \
                                        --locations Id="us-il-ch1-azr" \
                                        --locations Id="us-va-ash-azr" \
                                        --locations Id="emea-au-syd-edge" \
                                        --http-verb GET \
                                        --timeout 120 \
                                        --expected-status-code 200 \
                                        --enabled true \
                                        --tags hidden-link:/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/microsoft.insights/components/<application-insights-resource-name>=Resource
```

For more information about the `az monitor app-insights web-test create` command, refer to the [Azure CLI documentation](/cli/azure/monitor/app-insights/web-test#az-monitor-app-insights-web-test-create).

> [!NOTE]
> The web test region (`-location`) is different from geographic location (`-locations`) of which multiple can be selected. The `-location` refers to the Azure region where the web test is created and hosted, while `-locations` refers to geographic location or locations from which the web test is executed. For a full list of all geographic locations, see [Application Insights availability tests](availability.md#location-population-tags).

### [PowerShell](#tab/powershell)

To create a standard availability test with default settings, run the following Azure PowerShell command in your terminal and replace the placeholders `<resource-group-name>`, `<azure-region-name>`, `<web-test-name>`, `<url>`, `<subscription-id>`, and `<application-insights-resource-name>` with your specific values:

```azurepowershell
$geoLocation = @() 
$geoLocation += New-AzApplicationInsightsWebTestGeolocationObject -Location "us-ca-sjc-azr" 
$geoLocation += New-AzApplicationInsightsWebTestGeolocationObject -Location "apac-sg-sin-azr" 
$geoLocation += New-AzApplicationInsightsWebTestGeolocationObject -Location "us-il-ch1-azr" 
$geoLocation += New-AzApplicationInsightsWebTestGeolocationObject -Location "us-va-ash-azr" 
$geoLocation += New-AzApplicationInsightsWebTestGeolocationObject -Location "emea-au-syd-edge" 
New-AzApplicationInsightsWebTest -ResourceGroupName <resource-group-name> `
                                 -Location <azure-region-name> `
                                 -Name <web-test-name> `
                                 -TestName <web-test-name> `
                                 -Kind standard `
                                 -RequestUrl <url> `
                                 -RetryEnabled `
                                 -RuleSslCheck `
                                 -RuleSslCertRemainingLifetimeCheck 7 `
                                 -Frequency 300 `
                                 -GeoLocation $geoLocation `
                                 -RequestHttpVerb GET `
                                 -Timeout 120 `
                                 -RuleExpectedHttpStatusCode 200 ` 
                                 -Enabled `
                                 -Tag @{"hidden-link:/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/microsoft.insights/components/<application-insights-resource-name>" = "Resource"}
```

For more information about the `New-AzApplicationInsightsWebTest` command, refer to the [Azure PowerShell documentation](/powershell/module/az.applicationinsights/new-azapplicationinsightswebtest).

> [!NOTE]
> The web test region (`-Location`) is different from the geographic location (`-GeoLocation`) of which multiple can be selected. `-Location` refers to the Azure region where the web test is created and hosted, while `-GeoLocation` refers to the geographic location or locations from which the web test is executed. For a full list of all geographic locations, see [Application Insights availability tests](availability.md#location-population-tags).

### [REST](#tab/rest)

To create a standard availability test with default settings using the REST API, use the following request and replace the placeholders `<subscription-id>`, `<resource-group-name>`, `<application-insights-resource-name>`, `<web-test-name>`, `<access-token>`, `<azure-region-name>`, and `<url>` with your specific values:

```rest
PUT https://management.azure.com/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/microsoft.insights/components/<application-insights-resource-name>/webtests/<web-test-name>?api-version=2021-08-01

Content-Type: application/json
Authorization: Bearer <access-token>

{
  "location": "<azure-region-name>",
  "properties": {
    "Name": "<web-test-name>",
    "SyntheticMonitorId": "<web-test-name>",
    "Enabled": true,
    "Frequency": 300,
    "Timeout": 120,
    "Kind": "standard",
    "RetryEnabled": true,
    "Request": {
      "RequestUrl": "<url>",
      "HttpVerb": "GET"
    },
    "ValidationRules": {
      "ExpectedHttpStatusCode": 200,
      "SslCheck": true,
      "SslCertRemainingLifetimeCheck": 7
    },
    "Locations": [
      {
        "Id": "us-ca-sjc-azr"
      },
      {
        "Id": "apac-sg-sin-azr"
      },
      {
        "Id": "us-il-ch1-azr"
      },
      {
        "Id": "us-va-ash-azr"
      },
      {
        "Id": "emea-au-syd-edge"
      }
    ]
  },
  "Tags": {
    "hidden-link:/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/microsoft.insights/components/<application-insights-resource-name>": "Resource"
  }
}
```

To learn more about creating and configuring web tests using the REST API, see our [REST API documentation](/rest/api/application-insights/web-tests/create-or-update).

> [!NOTE]
> The web test region (`-location`) is different from the geographic location (`-Locations`) of which multiple can be selected. `-location` refers to the Azure region where the web test is created and hosted, while `-Locations` refers to the geographic location or locations from which the web test is executed. For a full list of all geographic locations, see [Application Insights availability tests](availability.md#location-population-tags).

### [Bicep](#tab/bicep)

To create a standard availability test with default settings using Bicep, add the following code to your template and replace the placeholders  `<web-test-name>`, `<azure-region-name>`, `<subscription-id>`, `<resource-group-name>`, `<application-insights-resource-name>`, and `<url>` with your specific values:

```bicep
resource webTest 'microsoft.insights/webtests@2022-06-15' = {
  name: '<web-test-name>'
  location: '<azure-region-name>'
  tags: {
    'hidden-link:/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/microsoft.insights/components/<application-insights-resource-name>': 'Resource'
  }
  properties: {
    SyntheticMonitorId: '<web-test-name>'
    Name: '<web-test-name>'
    Enabled: true
    Frequency: 300
    Timeout: 120
    Kind: 'standard'
    RetryEnabled: true
    Locations: [
      {
        Id: 'us-ca-sjc-azr'
      }
      {
        Id: 'apac-sg-sin-azr'
      }
      {
        Id: 'us-il-ch1-azr'
      }
      {
        Id: 'us-va-ash-azr'
      }
      {
        Id: 'emea-au-syd-edge'
      }
    ]
    Request: {
      RequestUrl: '<url>'
      HttpVerb: 'GET'
    }
    ValidationRules: {
      ExpectedHttpStatusCode: 200
      SSLCheck: true
      SSLCertRemainingLifetimeCheck: 7
    }
  }
}
```

> [!NOTE]
> The web test region (`location`) is different from the geographic location (`locations`) of which multiple can be selected. `location` refers to the Azure region where the web test is created and hosted, while `locations` refers to the geographic location or locations from which the web test is executed. For a full list of all geographic locations, see [Application Insights availability tests](availability.md#location-population-tags).

For more information about creating availability tests using Bicep, see [Microsoft.Insights webtests](/azure/templates/microsoft.insights/webtests?pivots=deployment-language-bicep).

### [JSON (ARM)](#tab/arm)

To create a standard availability test with default settings using JSON (ARM), add the following code to your template and replace the placeholders `<web-test-name>`, `<azure-region-name>`, `<subscription-id>`, `<resource-group-name>`, `<application-insights-resource-name>`, and `<url>` with your specific values:

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "resources": [
        {
            "type": "microsoft.insights/webtests",
            "apiVersion": "2022-06-15",
            "name": "<web-test-name>",
            "location": "<azure-region-name>",
            "tags": {
                "hidden-link:/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/microsoft.insights/components/<application-insights-resource-name>": "Resource"
            },
            "properties": {
                "SyntheticMonitorId": "<web-test-name>",
                "Name": "<web-test-name>",
                "Enabled": true,
                "Frequency": 300,
                "Timeout": 120,
                "Kind": "standard",
                "RetryEnabled": true,
                "Locations": [
                    {
                        "Id": "us-ca-sjc-azr"
                    },
                    {
                        "Id": "apac-sg-sin-azr"
                    },
                    {
                        "Id": "us-il-ch1-azr"
                    },
                    {
                        "Id": "us-va-ash-azr"
                    },
                    {
                        "Id": "emea-au-syd-edge"
                    }
                ],
                "Request": {
                    "RequestUrl": "<url>",
                    "HttpVerb": "GET"
                },
                "ValidationRules": {
                    "ExpectedHttpStatusCode": 200,
                    "SSLCheck": true,
                    "SSLCertRemainingLifetimeCheck": 7
                }
            }
        }
    ]
}
```

> [!NOTE]
> The web test region (`location`) is different from the geographic location (`locations`) of which multiple can be selected. `location` refers to the Azure region where the web test is created and hosted, while `locations` refers to the geographic location or locations from which the web test is executed. For a full list of all geographic locations, see [Application Insights availability tests](availability.md#location-population-tags).

For more information about creating availability tests using JSON (ARM), see [Microsoft.Insights webtests](/azure/templates/microsoft.insights/webtests?pivots=deployment-language-arm-template).

---

### Add a metric alert

> [!NOTE]
> Each Application Insights resource comes with metrics that are available out of the box. If separate components report to the same Application Insights resource, it might not make sense to alert on these metrics.

### [Portal](#tab/portal)

To learn how to create a metric alert in the Azure portal, see [Tutorial: Create a metric alert for an Azure resource](./../alerts/tutorial-metric-alert.md).

### [Azure CLI](#tab/cli)

To learn how to add a metric alert using Azure CLI, see [Create a new alert rule using the CLI, PowerShell, or an ARM template](./../alerts/alerts-create-rule-cli-powershell-arm.md#create-a-new-alert-rule-using-the-cli).

### [PowerShell](#tab/powershell)

To learn how to add a metric alert using PowerShell, see [Create a new alert rule using the CLI, PowerShell, or an ARM template](./../alerts/alerts-create-rule-cli-powershell-arm.md#create-a-new-alert-rule-using-powershell).

### [REST](#tab/rest)

To create a metric alert using the REST API, use the following request and replace the placeholders `{subscription-id}`, `{resource-group-name}`, `{alert-name}`, `{access-token}`, `{application-insights-resource-name}`, and `{action-group-name}`, with your specific values:

```rest
PUT https://management.azure.com/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Insights/metricAlerts/{alert-name}?api-version=2018-03-01
Authorization: Bearer {access-token}
Content-Type: application/json

{
  "properties": {
    "description": "Metric alert for high CPU usage",
    "severity": 3,
    "enabled": true,
    "scopes": [
      "/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Insights/components/{application-insights-resource-name}"
    ],
    "criteria": {
      "allOf": [
        {
          "metricName": "cpuPercentage",
          "metricNamespace": "Microsoft.Insights/components",
          "operator": "GreaterThan",
          "threshold": 80,
          "timeAggregation": "Average",
          "dimensions": [],
          "metricAlertCriteriaType": "StaticThresholdCriterion"
        }
      ]
    },
    "actions": [
      {
        "actionGroupId": "/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Insights/actionGroups/{action-group-name}"
      }
    ]
  }
}
```

### [Bicep](#tab/bicep)

To learn how to add a metric alert using an ARM template, see [Create a new alert rule using the CLI, PowerShell, or an ARM template](./../alerts/alerts-create-rule-cli-powershell-arm.md#create-a-new-alert-rule-using-an-arm-template).

### [JSON (ARM)](#tab/arm)

To learn how to add a metric alert using an ARM template, see [Create a new alert rule using the CLI, PowerShell, or an ARM template](./../alerts/alerts-create-rule-cli-powershell-arm.md#create-a-new-alert-rule-using-an-arm-template).

---

To automate the creation of metric alerts, see the [Metric alerts template](../alerts/alerts-metric-create-templates.md#template-for-a-simple-static-threshold-metric-alert) article.

### Create more Application Insights resources

#### How many Application Insights resources should I deploy?

When you're developing the next version of a web application, you don't want to mix up the [Application Insights](../../azure-monitor/app/app-insights-overview.md) telemetry from the new version and the already released version.

To avoid confusion, send the telemetry from different development stages to separate Application Insights resources with separate connection strings.

If your system is an instance of Azure Cloud Services, there's [another method of setting separate connection strings](../../azure-monitor/app/azure-web-apps-net-core.md).

#### When to use a single Application Insights resource

Use a single Application Insights resource for:

* Streamlining DevOps/ITOps management for applications deployed together, typically developed and managed by the same team.
* Centralizing key performance indicators, such as response times and failure rates, in a dashboard by default. Segment by role name in the metrics explorer if necessary.
* When there's no need for different Azure role-based access control management between application components.
* When identical metrics alert criteria, continuous exports, and billing/quotas management across components suffice.
* When it's acceptable for an API key to access data from all components equally, and 10 API keys meet the needs across all components.
* When the same smart detection and work item integration settings are suitable across all roles.

> [!NOTE]
> If you want to consolidate multiple Application Insights resources, you can point your existing application components to a new, consolidated Application Insights resource. The telemetry stored in your old resource won't be transferred to the new resource. Only delete the old resource when you have enough telemetry in the new resource for business continuity.

#### Other considerations

To activate portal experiences, add custom code to assign meaningful values to the [Cloud_RoleName](./app-map.md?tabs=net#set-or-override-cloud-role-name) attribute. Without these values, portal features don't function.

For Azure Service Fabric applications and classic cloud services, the SDK automatically configures services by reading from the Azure Role Environment. For other app types, you typically need to set it explicitly.

Live Metrics can't split data by role name.

### Filter on the build number

When you publish a new version of your application, you want to be able to separate the telemetry from different builds.

You can set the **Application Version** property so that you can filter [search](../../azure-monitor/app/transaction-search-and-diagnostics.md?tabs=transaction-search) and [metric explorer](../../azure-monitor/essentials/metrics-charts.md) results.

There are several different methods of setting the **Application Version** property.

* Set directly:

    `telemetryClient.Context.Component.Version = typeof(MyProject.MyClass).Assembly.GetName().Version;`

* To ensure that all `TelemetryClient` instances are set consistently, wrap that line in a [telemetry initializer](../../azure-monitor/app/api-custom-events-metrics.md#defaults).

* ASP.NET: Set the version in `BuildInfo.config`. The web module picks up the version from the `BuildLabel` node. Include this file in your project and remember to set the **Copy Always** property in Solution Explorer.

    ```xml
    <?xml version="1.0" encoding="utf-8"?>
    <DeploymentEvent xmlns:xsi="https://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="https://www.w3.org/2001/XMLSchema" xmlns="http://schemas.microsoft.com/VisualStudio/DeploymentEvent/2013/06">
      <ProjectName>AppVersionExpt</ProjectName>
      <Build type="MSBuild">
        <MSBuild>
          <BuildLabel kind="label">1.0.0.2</BuildLabel>
        </MSBuild>
      </Build>
    </DeploymentEvent>

    ```

* ASP.NET: Generate `BuildInfo.config` automatically in the Microsoft Build Engine. Add a few lines to your `.csproj` file:

    ```xml
    <PropertyGroup>
      <GenerateBuildInfoConfigFile>true</GenerateBuildInfoConfigFile>    <IncludeServerNameInBuildInfo>true</IncludeServerNameInBuildInfo>
    </PropertyGroup>
    ```

    This step generates a file called *yourProjectName*`.BuildInfo.config`. The Publish process renames it to `BuildInfo.config`.

    The build label contains a placeholder `(*AutoGen_...*)` when you build with Visual Studio. But when built with the Microsoft Build Engine, it's populated with the correct version number.

    To allow the Microsoft Build Engine to generate version numbers, set the version like `1.0.*` in `AssemblyReference.cs`.

### Version and release tracking

To track the application version, make sure your Microsoft Build Engine process generates `buildinfo.config`. In your `.csproj` file, add:

```xml
<PropertyGroup>
  <GenerateBuildInfoConfigFile>true</GenerateBuildInfoConfigFile>
  <IncludeServerNameInBuildInfo>true</IncludeServerNameInBuildInfo>
</PropertyGroup>
```

When the Application Insights web module has the build information, it automatically adds **Application Version** as a property to every item of telemetry. For this reason, you can filter by version when you perform [diagnostic searches](../../azure-monitor/app/transaction-search-and-diagnostics.md?tabs=transaction-search) or when you [explore metrics](../../azure-monitor/essentials/metrics-charts.md).

The Microsoft Build Engine exclusively generates the build version number, not the developer build from Visual Studio.

#### Release annotations

If you use Azure DevOps, you can [get an annotation marker](./release-and-work-item-insights.md?tabs=release-annotations) added to your charts whenever you release a new version.

## Automate the resource creation process

The resource creation process can be automated by using Bicep or JSON templates with [Azure Resource Manager](/azure/azure-resource-manager/management/overview). You can package several resources together to create them in one deployment. For example, you can create an Application Insights resource with availability tests, metric alerts, and a diagnostic setting to send telemetry to an Azure Storage account.

### Generate a template in the Azure portal

You can generate a template from existing resources.

#### Application Insights only

1. Go to the Application Insights resource in the Azure portal.
1. Open **Export template** listed under **Automation** in the left-hand navigation bar.
1. (Optional): To use your own parameters, uncheck **Include parameters**.
1. **Download** the template file or **Deploy** it directly in the Azure portal.

#### Multiple resources

1. Go to the resource group of your Application Insights resource.
1. On the **Overview** pane, mark all resources you want to be included in the template, then select **Export template** in the top navigation bar.
1. (Optional): To use your own parameters, uncheck **Include parameters**.
1. **Download** the template file or **Deploy** it directly in the Azure portal.

### Create a template from scratch

To learn how to create an ARM template from scratch, visit our [ARM template documentation](/azure/azure-resource-manager/templates/overview) which includes tutorials to [create a template](/azure/azure-resource-manager/templates/template-tutorial-create-first-template), [add resources](/azure/azure-resource-manager/templates/template-tutorial-add-resource), [add parameters](/azure/azure-resource-manager/templates/template-tutorial-add-parameters), and more.

Available properties for [Application Insights](/azure/templates/microsoft.insights/components), [availability tests](/azure/templates/microsoft.insights/webtests), [metric alerts](/azure/templates/microsoft.insights/metricalerts), [diagnostic settings](/azure/templates/microsoft.insights/diagnosticsettings), and other resources can be found in our [Azure resource reference](/azure/templates/) documentation under the **Reference** > **Monitor** > **Insights** node.

> [!TIP]
> You can also use quickstart templates, available towards the bottom of each Azure resource reference documentation page linked above. To learn how to use them, visit [Tutorial: Use Azure Quickstart Templates](/azure/azure-resource-manager/templates/template-tutorial-quickstart-template).

## Frequently asked questions

This section provides answers to common questions.

### How do I move an Application Insights resource to a new region?

Transferring existing Application Insights resources between regions isn't supported, and you can't migrate historical data to a new region. The workaround involves:

* Creating a new Application Insights resource in the desired region.
* Re-creating any unique customizations from the original resource in the new one.
* Updating your application with the new region resource's [connection string](./connection-strings.md).
* Testing to ensure everything works as expected with the new Application Insights resource.
* Decide to either keep or delete the original Application Insights resource. Deleting a classic resource means to lose all historical data. If the resource is workspace-based, the data remains in Log Analytics, enabling access to historical data until the retention period expires.

Unique customizations that commonly need to be manually re-created or updated for the resource in the new region include but aren't limited to:
          
* Re-create custom dashboards and workbooks.
* Re-create or update the scope of any custom log/metric alerts.
* Re-create availability alerts.
* Re-create any custom Azure role-based access control settings that are required for your users to access the new resource.
* Replicate settings involving ingestion sampling, data retention, daily cap, and custom metrics enablement. These settings are controlled via the **Usage and estimated costs** pane.
* Any integration that relies on API keys, such as [release annotations](./release-and-work-item-insights.md?tabs=release-annotations) and [live metrics secure control channel](./live-stream.md#secure-the-control-channel). You need to generate new API keys and update the associated integration.
* Continuous export in classic resources must be configured again.
* Diagnostic settings in workspace-based resources must be configured again.

### Can I use providers('Microsoft.Insights', 'components').apiVersions[0] in my Azure Resource Manager deployments?

We don't recommend using this method of populating the API version. The newest version can represent preview releases, which might contain breaking changes. Even with newer non-preview releases, the API versions aren't always backward compatible with existing templates. In some cases, the API version might not be available to all subscriptions.

## Next steps

* [Explore metrics](../essentials/metrics-charts.md)
* [Write Log Analytics queries](../logs/log-query-overview.md)
* [Shared resources for multiple roles](./app-map.md)
* [Send Azure Diagnostics to Application Insights](../agents/diagnostics-extension-to-application-insights.md).
* [Create release annotations](release-and-work-item-insights.md?tabs=release-annotations).
