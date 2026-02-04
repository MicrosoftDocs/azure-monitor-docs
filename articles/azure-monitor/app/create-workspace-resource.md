---
title: Create and configure Application Insights resources
description: Learn how to create and configure Application Insights resources programmatically and in the Azure portal
ms.topic: how-to
ms.date: 02/27/2026
ms.custom: devx-track-azurepowershell, devx-track-azurecli
---

# Create and configure Application Insights resources

> [!IMPORTANT]
> This article applies to *workspace-based* Application Insights resources. Classic Application Insights resources have been retired. [Transition to workspace-based Application Insights](/previous-versions/azure/azure-monitor/app/convert-classic-resource) to take advantage of new capabilities.

[Application Insights](app-insights-overview.md) integrates with [Log Analytics](../logs/log-analytics-overview.md) and sends telemetry to a common Log Analytics workspace. This setup provides full access to Log Analytics features, consolidates logs in one location, and allows for unified [Azure role-based access control](../roles-permissions-security.md) which eliminates the need for cross-app/workspace queries.

Enhanced capabilities include:

* **[Customer-managed keys](../logs/customer-managed-keys.md) -** Encrypt your data at rest with keys only accessible to you.
* **[Azure Private Link](../logs/private-link-security.md) -** Securely connect Azure PaaS services to your virtual network using private endpoints.
* **[Bring your own storage (BYOS)](./profiler-bring-your-own-storage.md) -** Manage data from [.NET Profiler](../profiler/profiler-overview.md) and [Snapshot Debugger](../snapshot-debugger/snapshot-debugger.md) with policies on encryption, lifetime, and network access.
* **[Commitment tiers](../logs/cost-logs.md#commitment-tiers) -** Save up to 30% over pay-as-you-go pricing.

This article shows you how to create and configure Application Insights resources. Along with the Application Insights resource itself, you can add various configurations like setting the [daily](#set-the-daily-cap) cap and [pricing plan](#set-the-pricing-plan). You can also create [availability tests](#create-an-availability-test), set up [metric alerts](#add-a-metric-alert), and automate the process using [Azure Resource Manager](/azure/azure-resource-manager/management/overview).

> [!NOTE]
> Data ingestion and retention for workspace-based Application Insights resources are billed through the Log Analytics workspace where the data is located. To learn more about billing, see [Azure Monitor Logs pricing details](../logs/cost-logs.md).

## Prerequisites

> [!div class="checklist"]
> * An active Azure subscription.
> * The necessary permissions to create resources.

### Additional requirements

### [Portal](#tab/portal)

No additional requirements.

### [Azure CLI](#tab/cli)

To access Application Insights Azure CLI commands, you first need to run:

```azurecli
 az extension add -n application-insights
```

If you don't run the `az extension add` command, you see an error message that states `az : ERROR: az monitor: 'app-insights' is not in the 'az monitor' command group. See 'az monitor --help'`.

### [PowerShell](#tab/powershell)

[!INCLUDE [updated-for-az](~/reusable-content/ce-skilling/azure/includes/updated-for-az.md)]

### [REST](#tab/rest)

To make a REST API call to Azure, you first need to obtain an access token. 

For more information, see [Manage Azure resources by using the REST API](/azure/azure-resource-manager/management/manage-resources-rest#obtain-an-access-token).

### [Bicep](#tab/bicep)

You can deploy Bicep templates via the Azure CLI, Azure PowerShell, and in the Azure portal. Check the respective tabs for additional requirements.

### [ARM (JSON)](#tab/arm)

You can deploy ARM templates via the Azure CLI, Azure PowerShell, and in the Azure portal. Check the respective tabs for additional requirements.

---

## Create an Application Insights resource

## [Portal](#tab/portal)

1. Sign in to the [Azure portal](https://portal.azure.com).
1. Select **Create a resource**.
1. Open the category **Monitoring & Diagnostics**, then select **Application Insights**.
1. Enter all relevant information, then **Review + create** your Application Insights resource.

:::image type="content" source="./media/create-workspace-resource/create-resource.png" lightbox="./media/create-workspace-resource/create-resource.png" alt-text="Screenshot that shows an Application Insights resource.":::

> [!NOTE]
> If you don't connect to an existing Log Analytics workspace during resource creation, a new Log Analytics resource is created automatically along with your Application Insights resource.

After creating your resource, you can find the corresponding workspace information in the Application Insights **Overview** pane.

:::image type="content" source="./media/create-workspace-resource/workspace-name.png" lightbox="./media/create-workspace-resource/workspace-name.png" alt-text="Screenshot that shows a workspace name.":::

Select the blue link text to go to the associated Log Analytics workspace where you can take advantage of the new unified workspace query environment.

> [!NOTE]
> We still provide full backward compatibility for your Application Insights classic resource queries, workbooks, and log-based alerts. To query or view the [new workspace-based table structure or schema](/previous-versions/azure/azure-monitor/app/convert-classic-resource#workspace-based-resource-changes), you must first go to your Log Analytics workspace. Select **Logs (Analytics)** in the **Application Insights** panes for access to the classic Application Insights query experience.

## [Azure CLI](#tab/cli)

To create a workspace-based Application Insights resource, a Log Analytics workspace is required. If you don't have one already, you can use the following Azure CLI command to create one.

Placeholders: `<resource-group-name>`, `<log-analytics-workspace-name>`, `<azure-region-name>`

```azurecli
az monitor log-analytics workspace create --resource-group <resource-group-name> --workspace-name <log-analytics-workspace-name> --location <azure-region-name>
```

To create an Application Insights resource, run the following Azure CLI command in your terminal.

Placeholders: `<application-insights-resource-name>`, `<azure-region-name>`, `<resource-group-name>`, `<log-analytics-workspace-name>`

```azurecli
az monitor app-insights component create --app <application-insights-resource-name> --location <azure-region-name> --resource-group <resource-group-name> --workspace <log-analytics-workspace-name>
```

For more information about creating Application Insights resources and Log Analytics workspaces using the Azure CLI, see the [Azure CLI documentation for Application Insights](/cli/azure/monitor/app-insights/component#az-monitor-app-insights-component-create) and [Log Analytics](/cli/azure/monitor/log-analytics/workspace#az-monitor-log-analytics-workspace-create).

## [PowerShell](#tab/powershell)

To create a workspace-based Application Insights resource, a Log Analytics workspace is required. If you don't have one already, you can use the following Azure PowerShell command to create one.

Placeholders: `<resource-group-name>`, `<log-analytics-workspace-name>`, `<azure-region-name>`

```azurepowershell
New-AzOperationalInsightsWorkspace -ResourceGroupName <resource-group-name> -Name <log-analytics-workspace-name> -Location <azure-region-name>
```

To create an Application Insights resource, run the following Azure PowerShell command in your terminal.

Placeholders: `<resource-group-name>`, `<application-insights-resource-name>`, `<azure-region-name>`,`<subscription-id>`, `<log-analytics-workspace-name>`

```azurepowershell
New-AzApplicationInsights -ResourceGroupName <resource-group-name> -Name <application-insights-resource-name> -Location <azure-region-name> -WorkspaceResourceId /subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.OperationalInsights/workspaces/<log-analytics-workspace-name>
```

For more information about creating Application Insights resources and Log Analytics workspaces using Azure PowerShell, see the [Azure PowerShell documentation for Application Insights](/powershell/module/az.applicationinsights/new-azapplicationinsights) and [Log Analytics](/powershell/module/az.operationalinsights/new-azoperationalinsightsworkspace).

## [REST](#tab/rest)

To create a workspace-based Application Insights resource, a Log Analytics workspace is required. If you don't have one already, you can use the following REST API call to create one.

Placeholders: `<subscription-id>`, `<resource-group-name>`, `<log-analytics-workspace-name>`, `<access-token>`, `<azure-region-name>`
 
```rest
PUT https://management.azure.com/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/Microsoft.OperationalInsights/workspaces/<log-analytics-workspace-name>?api-version=2023-09-01
Authorization: Bearer <access-token>
Content-Type: application/json

{
	"location": "<azure-region-name>"
}
```

To create an Application Insights resource using the REST API, use the following request.

Placeholders: `<subscription-id>`, `<resource-group-name>`, `<application-insights-resource-name>`, `<access-token>`, `<application-type>`, `<azure-region-name>`, `<log-analytics-workspace-name>`

```http
PUT https://management.azure.com/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.Insights/components/<application-insights-resource-name>?api-version=2020-02-02
Authorization: Bearer <access-token>
Content-Type: application/json

{
  "kind": "<application-type>",
  "location": "<azure-region-name>",
  "properties": {
    "Application_Type": "<application-type>",
    "WorkspaceResourceId": "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.OperationalInsights/workspaces/<log-analytics-workspace-name>"
  }
}
```

For more information about creating Application Insights resources and Log Analytics workspaces using the REST API, see the [REST API documentation for Application Insights](/rest/api/application-insights/components/create-or-update) and [Log Analytics](/rest/api/loganalytics/workspaces/create-or-update).

## [Bicep](#tab/bicep)

Here's how to create a new Application Insights resource using a Bicep template.

### Create a template

Create a new *.bicep* file (for example, *my-template.bicep*), copy the following content into it:

```bicep
param name string 
param type string 
param regionId string 
param requestSource string 
param workspaceResourceId string 

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  location: regionId
  tags: tagsArray
  kind: 'other'
  properties: {
    Application_Type: type
    Request_Source: requestSource
    WorkspaceResourceId: workspaceResourceId
  }
}
```

### Create a parameter file

Create a new *.bicepparam* file (for example, *my-parameters.bicepparam*), copy the following content into it, and replace the placeholders `<application-insights-resource-name>`, `<application-type>`, `<azure-region-name>`, `<subscription-id>`, `<resource-group-name>`, and `<log-analytics-workspace-name>` with your specific values:

```bicep
using 'my-template.bicep' 

param name string = '<application-insights-resource-name>'
param type string = '<application-type>'
param regionId string = '<azure-region-name>'
param requestSource string = 'CustomDeployment'
param workspaceResourceId string = '/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/microsoft.operationalinsights/workspaces/<log-analytics-workspace-name>'
```

### Use the template to create a new Application Insights resource

1. In PowerShell, sign in to Azure by using `$Connect-AzAccount`.
1. Set your context to a subscription with `Set-AzContext "<subscription ID>"`.
1. Run a new deployment to create a new Application Insights resource:

    ```azurepowershell
    New-AzResourceGroupDeployment -ResourceGroupName <your-resource-group> -TemplateFile my-template.bicep -TemplateParameterFile my-parameters.bicepparam
    ``` 

    * `-ResourceGroupName` is the group where you want to create the new resources.
    * `-TemplateFile` must occur before the custom parameters.
    * `-TemplateParameterFile` is the name of the parameter file.

You can add other parameters. You find their descriptions in the parameters section of the template.

> [!TIP]
> You can use the VS Code [Bicep extension by Microsoft](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep) to simplify the deployment process.
>
> Visit [publisher's GitHub repository](https://github.com/Azure/bicep/issues) for extension related questions.

## [ARM (JSON)](#tab/arm)

Here's how to create a new Application Insights resource using an ARM template.

### Create a template

Create a new *.json* file (for example, *my-template.json*) and copy the following content into it:

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

Create a new *.json* file (for example, *my-parameters.json*), copy the following content into it, and replace the placeholders `<application-insights-resource-name>`, `<application-type>`, `<azure-region-name>`, `<subscription-id>`, `<resource-group-name>`, and `<log-analytics-workspace-name>` with your specific values:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "name": {
      "value": "<application-insights-resource-name>"
    },
    "type": {
      "value": "<application-type>"
    },
    "regionId": {
      "value": "<azure-region-name>"
    },
    "tagsArray": {
      "value": {}
    },
    "requestSource": {
      "value": "CustomDeployment"
    },
    "workspaceResourceId": {
      "value": "/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/microsoft.operationalinsights/workspaces/<log-analytics-workspace-name>"
    }
  }
}
```

### Use the template to create a new Application Insights resource

1. In PowerShell, sign in to Azure by using `$Connect-AzAccount`.
1. Set your context to a subscription with `Set-AzContext "<subscription ID>"`.
1. Run a new deployment to create a new Application Insights resource:

    ```azurepowershell
    New-AzResourceGroupDeployment -ResourceGroupName <your-resource-group> -TemplateFile my-template.json -TemplateParameterFile my-parameters.json
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
1. On the **Overview** pane in the **Essentials** section, look for **Connection string**.
1. If you hover over the connection string, an icon appears which allows you to copy it to your clipboard.

### [Azure CLI](#tab/cli)

To get the connection string, run the following Azure CLI command in your terminal and replace the placeholders `<application-insights-resource-name>` and `<resource-group-name>` with your specific values:

```azurecli
az monitor app-insights component show --app <application-insights-resource-name> --resource-group <resource-group-name> --query connectionString --output tsv
```

For more information about the `az monitor app-insights component show` command, see the [Azure CLI documentation](/cli/azure/monitor/app-insights/component#az-monitor-app-insights-component-show).

### [PowerShell](#tab/powershell)

To get the connection string, run the following Azure PowerShell command in your terminal and replace the placeholders `<resource-group-name>` and `<application-insights-resource-name>` with your specific values:

```azurepowershell
Get-AzApplicationInsights -ResourceGroupName <resource-group-name> -Name <application-insights-resource-name> | Select-Object -ExpandProperty ConnectionString
```

For more information about the `Get-AzApplicationInsights` command, see the [Azure PowerShell documentation](/powershell/module/az.applicationinsights/get-azapplicationinsights).

### [REST](#tab/rest)

To retrieve the details of your Application Insights resource, use the following request and replace the placeholders `<subscription-id>`, `<resource-group-name>`, `<application-insights-resource-name>`, and `<access-token>` with your specific values:

```http
GET https://management.azure.com/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.Insights/components/<application-insights-resource-name>?api-version=2015-05-01
Authorization: Bearer <access-token>
```

Look for the `properties.connectionString` field in the JSON response.

For more information about retrieving information about Application Insights resources using the REST API, see the [REST API documentation](/rest/api/application-insights/components/get).

### [Bicep](#tab/bicep)

Not applicable to Bicep templates.

### [ARM (JSON)](#tab/arm)

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
> For web apps targeting browsers, we recommend using the [Application Insights JavaScript SDK](javascript-sdk.md).

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

In your Application Insights resource, select **Properties** > **Change workspace** > **Log Analytics Workspaces**.

### [Azure CLI](#tab/cli)

To change the Log Analytics workspace, run the following Azure CLI command in your terminal and replace the placeholders `<application-insights-resource-name>`, `<resource-group-name>`, and `<log-analytics-workspace-name>` with your specific values:

```azurecli
az monitor app-insights component update --app <application-insights-resource-name> --resource-group <resource-group-name> --workspace <log-analytics-workspace-name>
```

For more information about the `az monitor app-insights component update` command, see the [Azure CLI documentation](/cli/azure/monitor/app-insights/component#az-monitor-app-insights-component-update).

### [PowerShell](#tab/powershell)

To change the Log Analytics workspace, run the following Azure PowerShell command in your terminal and replace the placeholders `<resource-group-name>`, `<application-insights-resource-name>`, `<subscription-id>`, and `<log-analytics-workspace-name>` with your specific values:

```azurepowershell
Update-AzApplicationInsights -ResourceGroupName <resource-group-name> -Name <application-insights-resource-name> -WorkspaceResourceId /subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.OperationalInsights/workspaces/<log-analytics-workspace-name>
```

For more information about the `Update-AzApplicationInsights` command, see the [Azure PowerShell documentation](/powershell/module/az.applicationinsights/update-azapplicationinsights).

### [REST](#tab/rest)

To change the Log Analytics workspace using the REST API, use the following request and replace the placeholders `<subscription-id>`, `<resource-group-name>`, `<application-insights-resource-name>`, `<access-token>`, `<azure-region-name>`, and `<log-analytics-workspace-name>` with your specific values:

```http
PATCH https://management.azure.com/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.Insights/components/<application-insights-resource-name>?api-version=2020-02-02
Authorization: Bearer <access-token>
Content-Type: application/json

{
  "location": "<azure-region-name>",
  "properties": {
    "WorkspaceResourceId": "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.OperationalInsights/workspaces/<log-analytics-workspace-name>"
  }
}
```

For more information about modifying the associated workspace using the REST API, see the [REST API documentation](/rest/api/application-insights/components/create-or-update).

### [Bicep](#tab/bicep)

To change the Log Analytics workspace, paste the following code into your template and replace the placeholders `<application-insights-resource-name>`, `<azure-region-name>`, `<application-type>`, and `<log-analytics-workspace-name>` with your specific values:

```bicep
param workspaceResourceId string = '/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.OperationalInsights/workspaces/<log-analytics-workspace-name>' 

resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: '<application-insights-resource-name>'
  location: '<azure-region-name>'
  properties: {
    Application_Type: '<application-type>'
    WorkspaceResourceId: workspaceResourceId
  }
}
```

### [ARM (JSON)](#tab/arm)

To change the Log Analytics workspace, paste the following code into your template and replace the placeholders `<application-insights-resource-name>`, `<azure-region-name>`, `<application-type>`, and `<log-analytics-workspace-name>` with your specific values:

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
        "WorkspaceResourceId": "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.OperationalInsights/workspaces/<log-analytics-workspace-name>"
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

In your Application Insights resource, select **Diagnostic settings** > **Add diagnostic setting**.

You can select all tables or a subset of tables to archive to a storage account. You can also stream to an [event hub](/azure/event-hubs/event-hubs-about).

### [Azure CLI](#tab/cli)

To export telemetry using diagnostic settings, run the following Azure CLI command in your terminal and replace the placeholders `<diagnostic-setting-name>`, `<application-insights-resource-name>`, `<resource-group-name>`, and `<storage-account-name>` with your specific values:

```azurecli
az monitor diagnostic-settings create --name <diagnostic-setting-name> --resource <application-insights-resource-name> --resource-group <resource-group-name> --resource-type Microsoft.Insights/components --storage-account <storage-account-name>
```

This example command enables diagnostic settings and sends all logs of your Application Insights resource to the specified storage account. To also send metrics, add `--metrics '[{"category": "AllMetrics", "enabled": true}]'` to the command.

For more information about the `az monitor diagnostic-settings create` command, see the [Azure CLI documentation](/cli/azure/monitor/diagnostic-settings#az-monitor-diagnostic-settings-create).

### [PowerShell](#tab/powershell)

To export telemetry using diagnostic settings, run the following Azure PowerShell command in your terminal and replace the placeholders `<application-insights-resource-id>`, `<diagnostic-setting-name>`, and `<storage-account-id>` with your specific values:

```azurepowershell
Set-AzDiagnosticSetting -ResourceId <application-insights-resource-id> -Name <diagnostic-setting-name> -StorageAccountId <storage-account-id> -Enabled $True
```

This example command enables diagnostic settings and sends all metrics and logs of your Application Insights resource to the specified storage account.

For more information about the `Set-AzDiagnosticSetting` command, see the [Azure PowerShell documentation](/powershell/module/az.monitor/set-azdiagnosticsetting).

### [REST](#tab/rest)

To export telemetry to an Azure storage account using a diagnostic setting, use the following request and replace the placeholders `<subscription-id>`, `<resource-group-name>`, `<application-insights-resource-name>`, `<diagnostic-setting-name>`, `<access-token>`, and `<storage-account-name>` with your specific values:

```http
PUT https://management.azure.com//subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/microsoft.insights/components/<application-insights-resource-name>/providers/Microsoft.Insights/diagnosticSettings/<diagnostic-setting-name>?api-version=2021-05-01-preview
Authorization: Bearer <access-token>
Content-Type: application/json

{
  "properties": {
    "storageAccountId": "/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.Storage/storageAccounts/<storage-account-name>",
    "logs": [
      {
        "category": "AppRequests",
        "enabled": true
      }
    ],
    "metrics": [
      {
        "category": "AllMetrics",
        "enabled": true
      }
    ]
  }
}
```

This example call enables diagnostic settings and sends all metrics and logs of your Application Insights resource to the specified storage account.

For more information about creating a diagnostic setting using the REST API, see the [REST API documentation](/rest/api/monitor/diagnostic-settings/create-or-update).

### [Bicep](#tab/bicep)

To export telemetry using diagnostic settings, paste the following code into your template and replace the placeholders `<application-insights-resource-name>`, `<azure-region-name>`, `<application-type>`, `<diagnostic-setting-name>`, `<subscription-id>`, `<resource-group>`, and `<storage-account-name>` with your specific values:

```bicep
param appInsightsName string = '<application-insights-resource-name>'
param location string = '<azure-region-name>'
param applicationType string = '<application-type>'
param diagnosticSettingName string = '<diagnostic-setting-name>'
param storageAccountId string = '/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Storage/storageAccounts/<storage-account-name>'

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: applicationType
  properties: {
    Application_Type: applicationType
  }
}

resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: diagnosticSettingName
  scope: appInsights
  properties: {
    storageAccountId: storageAccountId
    logs: [
      {
        category: 'AppRequests'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}
```

### [ARM (JSON)](#tab/arm)

To export telemetry using diagnostic settings, paste the following code into your template and replace the placeholders `<application-insights-resource-name>`, `<azure-region-name>`, `<application-type>`, `<diagnostic-setting-name>`, `<subscription-id>`, `<resource-group>`, and `<storage-account-name>` with your specific values:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "appInsightsName": {
      "type": "string",
      "defaultValue": "<application-insights-resource-name>"
    },
    "location": {
      "type": "string",
      "defaultValue": "<azure-region-name>"
    },
    "applicationType": {
      "type": "string",
      "defaultValue": "<application-type>"
    },
    "diagnosticSettingName": {
      "type": "string",
      "defaultValue": "<diagnostic-setting-name>"
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
      "location": "[parameters('location')]",
      "kind": "[parameters('applicationType')]",
      "properties": {
        "Application_Type": "[parameters('applicationType')]"
      }
    },
    {
      "type": "Microsoft.Insights/diagnosticSettings",
      "apiVersion": "2021-05-01-preview",
      "name": "[parameters('diagnosticSettingName')]",
      "scope": "[resourceId('Microsoft.Insights/components', parameters('appInsightsName'))]",
      "properties": {
        "storageAccountId": "[parameters('storageAccountId')]",
        "logs": [
          {
            "category": "AppRequests",
            "enabled": true
          }
        ],
        "metrics": [
          {
            "category": "AllMetrics",
            "enabled": true
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

### [ARM (JSON)](#tab/arm)

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
> Currently, Azure doesn't provide a way to set the daily cap for Application Insights via the Azure CLI.

To change the daily cap for Log Analytics, run the following Azure CLI command in your terminal and replace the placeholders `<resource-group-name>`, `<log-analytics-workspace-name>`, and `<daily-cap-in-gb>` with your specific values.

```azurecli
az monitor log-analytics workspace update --resource-group <resource-group-name> --workspace-name <log-analytics-workspace-name> --set workspaceCapping.dailyQuotaGb=<daily-cap-in-gb>
```

For more information about the `az monitor log-analytics workspace update` command, see the [Azure CLI documentation](/cli/azure/monitor/log-analytics/workspace#az-monitor-log-analytics-workspace-update).

### [PowerShell](#tab/powershell)

To change the daily cap for Application Insights and Log Analytics, run the following Azure PowerShell commands in your terminal and replace the placeholders with your specific values.

**Application Insights**

Placeholders: `<resource-group-name>`, `<application-insights-resource-name>`, `<daily-cap-in-gb>` 

```azurepowershell
Set-AzApplicationInsightsDailyCap -ResourceGroupName <resource-group-name> -Name <application-insights-resource-name> -DailyCapGB <daily-cap-in-gb>
```

For more information about the `Set-AzApplicationInsightsDailyCap` command, see the [Azure PowerShell documentation](/powershell/module/az.applicationinsights/set-azapplicationinsightsdailycap).

**Log Analytics**

Placeholders: `<resource-group-name>`, `<log-analytics-workspace-name>`, `<daily-cap-in-gb>` 

```azurepowershell
Set-AzOperationalInsightsWorkspace -ResourceGroupName <resource-group-name> -Name <log-analytics-workspace-name> -DailyQuotaGb <daily-cap-in-gb>
```

For more information about the `Set-AzOperationalInsightsWorkspace` command, see the [Azure PowerShell documentation](/powershell/module/az.operationalinsights/set-azoperationalinsightsworkspace).

### [REST](#tab/rest)

> [!NOTE]
> Currently, Azure doesn't provide a way to set the daily cap for Application Insights with the Azure CLI.

To change the daily cap for Log Analytics, use the following request and replace the placeholders `<subscription-id>`, `<resource-group-name>`, `<log-analytics-workspace-name>`, `<access-token>`, `<azure-region-name>`, and `<daily-cap-in-gb>` with your specific values:

Placeholders: 

```http
PATCH https://management.azure.com/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.OperationalInsights/workspaces/<log-analytics-workspace-name>?api-version=2023-09-01
Authorization: Bearer <access-token>
Content-Type: application/json

{
  "location": '<azure-region-name>',
  "properties": {
    "workspaceCapping": {
      "dailyQuotaGb": <daily-cap-in-gb>,
    },
  }
}
```

For more information about the setting the Log Analytics daily cap, see the [REST API documentation](/rest/api/loganalytics/workspaces/create-or-update)

### [Bicep](#tab/bicep)

> [!NOTE]
> Currently, Azure doesn't provide a way to set the daily cap for Application Insights with a Bicep template.

To set the daily cap for Log Analytics, paste the following code into your template and replace the placeholders `<log-analytics-workspace-name>`, `<azure-region-name>`, and `<daily-cap-in-gb>` with your specific values:

```bicep
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: '<log-analytics-workspace-name>'
  location: '<azure-region-name>'
  properties: {
    dailyQuotaGb: <daily-cap-in-gb>
  }
}
```

### [ARM (JSON)](#tab/arm)

> [!NOTE]
> Currently, Azure doesn't provide a way to set the daily cap for Application Insights using an ARM template.

To set the daily cap for Log Analytics, paste the following code into your template and replace the placeholders `<log-analytics-workspace-name>`, `<azure-region-name>`, and `<daily-cap-in-gb>` with your specific values:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.OperationalInsights/workspaces",
      "apiVersion": "2023-09-01",
      "name": "<log-analytics-workspace-name>",
      "location": "<azure-region-name>",
      "properties": {
        "workspaceCapping": {
          "dailyQuotaGb": <daily-cap-in-gb>
        }
      }
    }
  ]
}
```

---

### Set the pricing plan

The pricing plan for Application Insights resources can be set in the associated Log Analytics workspace. For more information about available pricing plans, see [Azure Monitor Logs cost calculations and options](./../logs/cost-logs.md).

> [!NOTE]
> If you're seeing unexpected charges or high costs in Application Insights, this guide can help. It covers common causes like high telemetry volume, data ingestion spikes, and misconfigured sampling. It's especially useful if you're troubleshooting issues related to cost spikes, telemetry volume, sampling not working, data caps, high ingestion, or unexpected billing. To get started, see [Troubleshoot high data ingestion in Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-high-data-ingestion).

### [Portal](#tab/portal)

To learn how to set the pricing plan in the Azure portal, see [Application Insights billing](./../logs/cost-logs.md#application-insights-billing).

### [Azure CLI](#tab/cli)

To set the pricing plan, run one of the following Azure CLI commands in your terminal and replace the placeholders `<log-analytics-workspace-name>`, `<azure-region-name>`, and (if applicable) `<capacity-reservation-in-gb>` with your specific values:

**Pay-as-you-go**

```azurecli
az monitor log-analytics workspace update --resource-group <resource-group-name> --workspace-name <log-analytics-workspace-name> --set PerGB2018
```

**Commitment tier**

```azurecli
az monitor log-analytics workspace update --resource-group <resource-group-name> --workspace-name <log-analytics-workspace-name> --set CapacityReservation --level <capacity-reservation-in-gb>
```

For more information about the `az monitor log-analytics workspace update` command, see the [Azure CLI documentation](/cli/azure/monitor/log-analytics/workspace#az-monitor-log-analytics-workspace-update).

### [PowerShell](#tab/powershell)

To set the pricing plan, run one of the following Azure PowerShell commands in your terminal and replace the placeholders `<log-analytics-workspace-name>`, `<azure-region-name>`, and (if applicable) `<capacity-reservation-in-gb>` with your specific values:

**Pay-as-you-go**

```azurepowershell
Set-AzOperationalInsightsWorkspace -ResourceGroupName <resource-group-name> -Name <log-analytics-workspace-name> -Sku perb2018
```

**Commitment tier**

```azurepowershell
Set-AzOperationalInsightsWorkspace -ResourceGroupName <resource-group-name> -Name <log-analytics-workspace-name> -Sku capacityreservation -SkuCapacity <capacity-reservation-in-gb>
```

For more information about the `Set-AzOperationalInsightsWorkspace` command, see the [Azure PowerShell documentation](/powershell/module/az.operationalinsights/set-azoperationalinsightsworkspace).

### [REST](#tab/rest)

To set the pricing plan using the REST API, use one of the following requests and replace the placeholders `<subscription-id>`, `<resource-group-name>`, `<log-analytics-workspace-name>`, `<access-token>`, and (if applicable) `<capacity-reservation-in-gb>` with your specific values:

**Pay-as-you-go**

```http
PUT https://management.azure.com/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.OperationalInsights/workspaces/<log-analytics-workspace-name>/pricingPlans/current?api-version=2017-10-01
Content-Type: application/json
Authorization: Bearer <access-token>

{
  "properties": {
    "sku": {
      "name": "pergb2018"
    }
  }
}
```

**Commitment tier**

```http
PUT https://management.azure.com/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.OperationalInsights/workspaces/<log-analytics-workspace-name>/pricingPlans/current?api-version=2017-10-01
Content-Type: application/json
Authorization: Bearer <access-token>

{
  "properties": {
    "sku": {
      "name": "capacityreservation",
      "capacityReservationLevel": <capacity-reservation-in-gb>
    }
  }
}
```

For more information about setting the pricing plan using the REST API, see the [REST API documentation](/rest/api/loganalytics/workspaces/create-or-update#workspacesku).

### [Bicep](#tab/bicep)

To set the pricing plan using Bicep, paste the following code into your template and replace the placeholders `<log-analytics-workspace-name>`, `<azure-region-name>`, and for the commitment tier also `<capacity-reservation-in-gb>` with your specific values:

**Pay-as-you-go**

```bicep
param workspaceName string = '<log-analytics-workspace-name>'
param workspaceRegion string = '<azure-region-name>'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: workspaceName
  location: workspaceRegion
  properties: {
    sku: {
      name: 'pergb2018'
    }
  }
}
```

**Commitment tier**

```bicep
param workspaceName string = '<log-analytics-workspace-name>'
param workspaceRegion string = '<azure-region-name>'
param capacityReservationLevel int = '<capacity-reservation-in-gb>'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: workspaceName
  location: workspaceRegion
  properties: {
    sku: {
      name: 'capacityreservation'
      capacityReservationLevel: capacityReservationLevel
    }
  }
}
```

For more information about updating the `Microsoft.OperationalInsights/workspaces` resource using Bicep, see the [templates documentation](/azure/templates/microsoft.operationalinsights/workspaces?pivots=deployment-language-bicep#workspacesku).

### [ARM (JSON)](#tab/arm)

To set the pricing plan using an ARM template, paste the following code into your template and replace the placeholders `<log-analytics-workspace-name>`, `<azure-region-name>`, and for the commitment tier also `<capacity-reservation-in-gb>` with your specific values:

**Pay-as-you-go**

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "workspaceName": {
      "type": "string",
      "defaultValue": "<log-analytics-workspace-name>" 
    },
    "workspaceRegion": {
      "type": "string",
      "defaultValue": "<azure-region-name>" 
    }
  },
  "resources": [
    {
      "name": "[parameters('workspaceName')]",
      "type": "Microsoft.OperationalInsights/workspaces",
      "apiVersion": "2020-08-01",
      "location": "[parameters('workspaceRegion')]",
      "properties": {
        "sku": {
          "name": "pergb2018"
        }
      }
    }
  ]
}
```

**Commitment tier**

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "workspaceName": {
      "type": "string",
      "defaultValue": "<log-analytics-workspace-name>" 
    },
    "workspaceRegion": {
      "type": "string",
      "defaultValue": "<azure-region-name>" 
    },
    "capacityReservationLevel": {
      "type": "int",
      "defaultValue": <capacity-reservation-in-gb>
    }
  },
  "resources": [
    {
      "name": "[parameters('workspaceName')]",
      "type": "Microsoft.OperationalInsights/workspaces",
      "apiVersion": "2020-08-01",
      "location": "[parameters('workspaceRegion')]",
      "properties": {
        "sku": {
          "name": "capacityreservation",
          "capacityReservationLevel": "[parameters('capacityReservationLevel')]"
        }
      }
    }
  ]
}
```

For more information about updating the `Microsoft.OperationalInsights/workspaces` resource using an ARM template, see the [templates documentation](/azure/templates/microsoft.operationalinsights/workspaces?pivots=deployment-language-arm-template#workspacesku-1).

---

### Disable IP masking

By default, Application Insights doesn't store IP addresses. To learn how to disable IP masking, see [Geolocation and IP address handling](./ip-collection.md#disable-ip-masking).

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

For more information about the `az monitor app-insights web-test create` command, see the [Azure CLI documentation](/cli/azure/monitor/app-insights/web-test#az-monitor-app-insights-web-test-create).

> [!NOTE]
> The web test region (`-location`) is different from geographic location (`-locations`, notice the plural form) of which multiple can be selected. The `-location` refers to the Azure region where the web test is created and hosted, while `-locations` refers to geographic location or locations from which the web test is executed. For a full list of all geographic locations, see [Application Insights availability tests](availability.md#location-population-tags).

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

For more information about the `New-AzApplicationInsightsWebTest` command, see the [Azure PowerShell documentation](/powershell/module/az.applicationinsights/new-azapplicationinsightswebtest).

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

> [!NOTE]
> The web test region (`-location`) is different from the geographic location (`-Locations`, notice the plural form) of which multiple can be selected. `-location` refers to the Azure region where the web test is created and hosted, while `-Locations` refers to the geographic location or locations from which the web test is executed. For a full list of all geographic locations, see [Application Insights availability tests](availability.md#location-population-tags).

To learn more about creating and configuring web tests using the REST API, see our [REST API documentation](/rest/api/application-insights/web-tests/create-or-update).

### [Bicep](#tab/bicep)

To create a standard availability test with default settings using Bicep, add the following code to your template and replace the placeholders `<web-test-name>`, `<azure-region-name>`, `<subscription-id>`, `<resource-group-name>`, `<application-insights-resource-name>`, and `<url>` with your specific values:

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
> The web test region (`location`) is different from the geographic location (`Locations`) of which multiple can be selected. `location` refers to the Azure region where the web test is created and hosted, while `Locations` refers to the geographic location or locations from which the web test is executed. For a full list of all geographic locations, see [Application Insights availability tests](availability.md#location-population-tags).

For more information about creating availability tests using Bicep, see [Microsoft.Insights webtests](/azure/templates/microsoft.insights/webtests?pivots=deployment-language-bicep).

### [ARM (JSON)](#tab/arm)

To create a standard availability test with default settings using an ARM template, add the following code to your template and replace the placeholders `<web-test-name>`, `<azure-region-name>`, `<subscription-id>`, `<resource-group-name>`, `<application-insights-resource-name>`, and `<url>` with your specific values:

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
> The web test region (`location`) is different from the geographic location (`Locations`) of which multiple can be selected. `location` refers to the Azure region where the web test is created and hosted, while `Locations` refers to the geographic location or locations from which the web test is executed. For a full list of all geographic locations, see [Application Insights availability tests](availability.md#location-population-tags).

For more information about creating availability tests using an ARM template, see [Microsoft.Insights webtests](/azure/templates/microsoft.insights/webtests?pivots=deployment-language-arm-template).

---

### Add a metric alert

> [!TIP]
> Each Application Insights resource comes with metrics that are available out of the box. If separate components report to the same Application Insights resource, it might not make sense to alert on these metrics.

### [Portal](#tab/portal)

To learn how to create a metric alert in the Azure portal, see [Tutorial: Create a metric alert for an Azure resource](./../alerts/tutorial-metric-alert.md).

### [Azure CLI](#tab/cli)

To learn how to add a metric alert using the Azure CLI, see [Create a new alert rule using the CLI, PowerShell, or an ARM template](./../alerts/alerts-create-rule-cli-powershell-arm.md#create-a-new-alert-rule-using-the-cli).

### [PowerShell](#tab/powershell)

To learn how to add a metric alert using PowerShell, see [Create a new alert rule using the CLI, PowerShell, or an ARM template](./../alerts/alerts-create-rule-cli-powershell-arm.md#create-a-new-alert-rule-using-powershell).

### [REST](#tab/rest)

For a list of various REST API call examples to create a metric alert, see the [REST API documentation](/rest/api/monitor/metric-alerts/create-or-update).

### [Bicep](#tab/bicep)

To learn how to add a metric alert using an ARM template, see [Create a new alert rule using the CLI, PowerShell, or an ARM template](./../alerts/alerts-create-rule-cli-powershell-arm.md#create-a-new-alert-rule-using-an-arm-template).

### [ARM (JSON)](#tab/arm)

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
> If you want to consolidate multiple Application Insights resources, you can point your existing application components to a new, consolidated Application Insights resource. The telemetry stored in your old resource doesn't transfer to the new resource. Only delete the old resource when you have enough telemetry in the new resource for business continuity.

#### Other considerations

To activate portal experiences, add custom code to assign meaningful values to the [Cloud_RoleName](./app-map.md?tabs=net#set-or-override-cloud-role-name) attribute. Without these values, portal features don't function.

For Azure Service Fabric applications and classic cloud services, the SDK automatically configures services by reading from the Azure Role Environment. For other app types, you typically need to set it explicitly.

Live Metrics can't split data by role name.

### Version and release tracking

When you publish a new version of your application, you want to be able to separate the telemetry from different builds. You can set the **Application Version** property so you can filter [search](../../azure-monitor/app/failures-performance-transactions.md?tabs=search-view) and [metric explorer](../../azure-monitor/essentials/metrics-charts.md) results.

There are several different methods of setting the **Application Version** property.

* **Option 1:** Set the version directly

    Add the line `telemetryClient.Context.Component.Version = typeof(MyProject.MyClass).Assembly.GetName().Version;` to the initialization code of your application.

    To ensure that all `TelemetryClient` instances are set consistently, wrap that line in a [telemetry initializer](../../azure-monitor/app/api-custom-events-metrics.md#defaults).

* **Option 2:** Set the version in `BuildInfo.config` (ASP.NET only)

    The Application Insights web module picks up the version from the `BuildLabel` node. Include this file in your project and remember to set the **Copy Always** property in Solution Explorer.

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

    Generate `BuildInfo.config` automatically in the Microsoft Build Engine. Add the following lines to your `.csproj` file:

    ```xml
    <PropertyGroup>
      <GenerateBuildInfoConfigFile>true</GenerateBuildInfoConfigFile>
      <IncludeServerNameInBuildInfo>true</IncludeServerNameInBuildInfo>
    </PropertyGroup>
    ```

    This step generates a file called *yourProjectName*`.BuildInfo.config`. The Publish process renames it to `BuildInfo.config`.

    The build label contains a placeholder `(*AutoGen_...*)` when you build with Visual Studio. When built with the Microsoft Build Engine, the placeholder is populated with the correct version number.

    To allow the Microsoft Build Engine to generate version numbers, set the version like `1.0.*` in `AssemblyReference.cs`.

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
> You can also use quickstart templates, available towards the bottom of each Azure resource reference documentation page linked in this section. To learn how to use templates, visit [Tutorial: Use Azure Quickstart Templates](/azure/azure-resource-manager/templates/template-tutorial-quickstart-template).

## Next steps

* Review frequently asked questions (FAQ): [Creating and configuring Application Insights resources FAQ](application-insights-faq.yml#creating-and-configuring-application-insights-resources)
* [Explore metrics](../essentials/metrics-charts.md)
* [Write Log Analytics queries](../logs/log-query-overview.md)
* [Shared resources for multiple roles](./app-map.md)
* [Send Azure Diagnostics to Application Insights](../agents/diagnostics-extension-to-application-insights.md).
* [Create release annotations](release-and-work-item-insights.md?tabs=release-annotations).
