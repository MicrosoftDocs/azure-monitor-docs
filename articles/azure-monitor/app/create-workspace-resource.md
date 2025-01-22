---
title: Create and configure workspace-based Application Insights resources
description: Learn how to create and configure workspace-based Application Insights resources programmatically and in the Azure portal
ms.topic: conceptual
ms.date: 01/31/2025
ms.reviewer: cogoodson
ms.custom: devx-track-azurepowershell, devx-track-azurecli
---

# Create and configure workspace-based Application Insights resources

Workspace-based [Application Insights](app-insights-overview.md#application-insights-overview) integrates with [Log Analytics](../logs/log-analytics-overview.md#overview-of-log-analytics-in-azure-monitor) and sends telemetry to a common Log Analytics workspace. This setup provides full access to Log Analytics features, consolidates logs in one location, and allows for unified [Azure role-based access control](../roles-permissions-security.md) which eliminates the need for cross-app/workspace queries.

Enhanced capabilities include:

* [Customer-managed keys](../logs/customer-managed-keys.md) encrypt your data at rest with keys only accessible to you.
* [Azure Private Link](../logs/private-link-security.md) securely connects Azure PaaS services to your virtual network using private endpoints.
* [Bring your own storage (BYOS)](./profiler-bring-your-own-storage.md) lets you manage data from [.NET Profiler](../profiler/profiler-overview.md) and [Snapshot Debugger](../snapshot-debugger/snapshot-debugger.md) with policies on encryption, lifetime, and network access.
* [Commitment tiers](../logs/cost-logs.md#commitment-tiers) offer up to a 30% saving over pay-as-you-go pricing.
* Log Analytics streaming processes data more quickly.

> [!NOTE]
> Data ingestion and retention for workspace-based Application Insights resources are billed through the Log Analytics workspace where the data is located. To learn more about billing for workspace-based Application Insights resources, see [Azure Monitor Logs pricing details](../logs/cost-logs.md).

This article shows you how to create and configure workspace-based [Application Insights](./app-insights-overview.md) resources. Along with the Application Insights resource itself and various configurations like setting the [daily](#set-the-daily-cap) cap and [pricing plan](#set-the-pricing-plan), you can create [availability web tests](#add-an-availability-test) and set up [alerts](#add-a-metric-alert), and automate the process using [Azure Resource Manager](https://resources.azure.com/).

<!--
### PowerShell

There's a rich set of [Application Insights PowerShell cmdlets](/powershell/module/az.applicationinsights). These cmdlets make it easy to configure Application Insights resources programatically. You can use the capabilities enabled by the cmdlets to:

* Create and delete Application Insights resources.
* Get lists of Application Insights resources and their properties.
* Create and manage continuous export.
* Create and manage application keys.
* Set the daily cap.
* Set the pricing plan.

### ARM

The key to creating these resources is Bicep or JSON templates for [Azure Resource Manager](/azure/azure-resource-manager/management/manage-resources-powershell). The basic procedure is:

* Download the Bicep pr JSON definitions of existing resources.
* Parameterize certain values, such as names.
* Run the template whenever you want to create a new resource.

You can package several resources together to create them all in one go. For example, you can create an app monitor with availability tests, alerts, and storage for continuous export. There are some subtleties to some of the parameterizations, which we explain here.
-->

## Prerequisites

> [!div class="checklist"]
> * An active Azure subscription.
> * The necessary permissions to create resources.

### Additional requirements

### [Portal](#tab/portal)

No additional prerequisites for the Azure portal.

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

> [!NOTE]
> All REST API examples in this document use the OSS tool [ARMClient](https://github.com/projectkudu/ARMClient), but you can also use other tools like cURL and Postman.

### [Bicep](#tab/bicep)

You can deploy Bicep templates via Azure CLI, Azure PowerShell, and in the Azure portal. Check the respective tabs for additional prerequisites.

### [JSON (ARM)](#tab/arm)

You can deploy JSON templates via Azure CLI, Azure PowerShell, and in the Azure portal. Check the respective tabs for additional prerequisites.

---

## Create a workspace-based resource

## [Portal](#tab/portal)

Sign in to the [Azure portal](https://portal.azure.com), and create an Application Insights resource.

> [!div class="mx-imgBorder"]
> :::image type="content" source="./media/create-workspace-resource/create-workspace-based.png" lightbox="./media/create-workspace-resource/create-workspace-based.png" alt-text="Screenshot that shows a workspace-based Application Insights resource.":::

If you don't have an existing Log Analytics workspace, see the [Log Analytics workspace creation documentation](../logs/quick-create-workspace.md).

After you create your resource, you'll see corresponding workspace information in the **Overview** pane.

:::image type="content" source="./media/create-workspace-resource/workspace-name.png" lightbox="./media/create-workspace-resource/workspace-name.png" alt-text="Screenshot that shows a workspace name.":::

Select the blue link text to go to the associated Log Analytics workspace where you can take advantage of the new unified workspace query environment.

> [!NOTE]
> We still provide full backward compatibility for your Application Insights classic resource queries, workbooks, and log-based alerts. To query or view the [new workspace-based table structure or schema](/previous-versions/azure/azure-monitor/app/convert-classic-resource#workspace-based-resource-changes), you must first go to your Log Analytics workspace. Select **Logs (Analytics)** in the **Application Insights** panes for access to the classic Application Insights query experience.

## [Azure CLI](#tab/cli)

To create an Application Insights resource, run the following Azure CLI command in your terminal:

```azurecli
az monitor app-insights component create --app
                                         --location
                                         --resource-group
                                         [--application-type]
                                         [--ingestion-access {Disabled, Enabled}]
                                         [--kind]
                                         [--query-access {Disabled, Enabled}]
                                         [--retention-time]
                                         [--tags]
                                         [--workspace]
```

> [!NOTE]
> Parameters in brackets are optional.

### Example

```azurecli
az monitor app-insights component create --app <application-insights-resource-name> --location <azure-region-name> --resouce-group <resource-group-name>
```

For more information about this command, see the [Azure CLI documentation](/cli/azure/monitor/app-insights/component#az-monitor-app-insights-component-create).

## [PowerShell](#tab/powershell)

To create an Application Insights resource using Azure PowerShell, run the following command in your terminal:

```azurepowershell
New-AzApplicationInsights -ResourceGroupName <String> -Name <String> -Location <String>
   [-SubscriptionId <String>]
   [-Kind <String>]
   [-ApplicationType <ApplicationType>]
   [-DisableIPMasking]
   [-DisableLocalAuth]
   [-Etag <String>]
   [-FlowType <FlowType>]
   [-ForceCustomerStorageForProfiler]
   [-HockeyAppId <String>]
   [-ImmediatePurgeDataOn30Day]
   [-IngestionMode <IngestionMode>]
   [-PublicNetworkAccessForIngestion <PublicNetworkAccessType>]
   [-PublicNetworkAccessForQuery <PublicNetworkAccessType>]
   [-RequestSource <RequestSource>]
   [-RetentionInDays <Int32>]
   [-SamplingPercentage <Double>]
   [-Tag <Hashtable>]
   [-WorkspaceResourceId <String>]
   [-DefaultProfile <PSObject>]
   [-WhatIf]
   [-Confirm]
   [<CommonParameters>]
```

> [!NOTE]
> Parameters in brackets are optional.

### Example

```azurepowershell
New-AzApplicationInsights -Kind java -ResourceGroupName testgroup -Name test1027 -Location eastus
```

For more information about this command, see the [Azure PowerShell documentation](/powershell/module/az.applicationinsights/new-azapplicationinsights).

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

To learn more about creating and updating Application Insights resources using the REST API, see the [REST API documentation](/rest/api/application-insights/components/create-or-update).

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
param workspaceResourceId string = '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourcegroups/testxxxx/providers/microsoft.operationalinsights/workspaces/testworkspace'
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

Here's how to create a new Application Insights resource using a JSON ARM template.

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
      "value": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourcegroups/testxxxx/providers/microsoft.operationalinsights/workspaces/testworkspace"
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

After creating a workspace-based Application Insights resource, you configure monitoring.

### Get the connection string

The [connection string](./connection-strings.md?tabs=net) identifies the resource that you want to associate your telemetry data with. You can also use it to modify the endpoints your resource uses as a destination for your telemetry. You must copy the connection string and add it to your application's code or to an environment variable.

### [Portal](#tab/portal)

To get the connection string of your Application Insights resource:

1. Open your Application Insights resource in the Azure portal.
1. On the Overview pane, look for the connection string under **Essentials**.
1. If you hover over the connection string, an icon will appear which allows you to copy it to your clipboard.

### [Azure CLI](#tab/cli)

To get the connection string, run the following Azure CLI command in your terminal and replace the placeholders `<application-insights-resource-name>` and `<resource-group-name>` with your specific values:

```azurecli
az monitor app-insights component show --app <application-insights-resource-name> --resource-group <resource-group-name> --query connectionString --output tsv
```

### [PowerShell](#tab/powershell)

To get the connection string, run the following code in your terminal:

```azurepowershell
Get-AzApplicationInsights -ResourceGroupName <your-resource-group> -Name <your-app-name> | Select-Object -ExpandProperty ConnectionString`
```

### [REST](#tab/rest)

To retrieve the details of your Application Insights resource, use armclient to send the following request and replace the placeholders `{subscription-id}`, and `{resource-group-name}`, `{application-insights-resource-name}`, and `{access-token}` with your specific values:

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

### Code-based application monitoring

For code-based application monitoring, you install the appropriate Application Insights SDK and point the connection string to your newly created resource.

For information on how to set up an Application Insights SDK for code-based monitoring, see the following documentation specific to the language or framework:

* [ASP.NET](./asp-net.md)
* [ASP.NET Core](./asp-net-core.md)
* [Background tasks and modern console applications (.NET/.NET Core)](./worker-service.md)
* [Classic console applications (.NET)](./console.md)
* [Java](./opentelemetry-enable.md?tabs=java)
* [JavaScript](./javascript.md)
* [Node.js](./nodejs.md)
* [Python](/previous-versions/azure/azure-monitor/app/opencensus-python)

### Codeless monitoring

For codeless monitoring of services like Azure Functions and Azure App Services, you can first create your workspace-based Application Insights resource. Then you point to that resource when you configure monitoring. Alternatively, you can create a new Application Insights resource as part of Application Insights enablement.



## Configure Application Insights resources

### Modify the associated workspace

After creating a workspace-based Application Insights resource, you can modify the associated Log Analytics workspace.

### [Portal](#tab/portal)

In the Application Insights resource pane, select **Properties** > **Change Workspace** > **Log Analytics Workspaces**.

### [Azure CLI](#tab/cli)

To change the Log Analytics workspace, run the following Azure CLI command in your terminal and replace the placeholders `<application-insights-resource-name>`, `<resource-group-name>`, and `<new-workspace-resource-id>` with your specific values:

```azurecli
az monitor app-insights component update --app <application-insights-resource-name> --resource-group <resource-group-name> --workspace <new-workspace-resource-id>
```

### [PowerShell](#tab/powershell)

To change the Log Analytics workspace, run the following PowerShell command in your terminal:

```azurepowershell
$resource = Get-AzResource -ResourceType "Microsoft.Insights/components" -ResourceGroupName "<your-resource-group>" -ResourceName "<your-app-name>"
$resource.Properties.WorkspaceResourceId = "<new-workspace-resource-id>"
Set-AzResource -ResourceId $resource.ResourceId -Properties $resource.Properties -Force
```

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

You can select all tables or a subset of tables to archive to a storage account. You can also stream to an [Azure Event Hub](/azure/event-hubs/event-hubs-about).

### [Azure CLI](#tab/cli)

To export telemetry using diagnostic settings, run the following Azure CLI command in your terminal and replace the placeholders `<diagnostic-setting-name>`, `<application-insights-resource-name>`, `<resource-group-name>`, and `<storage-account-name>` with your specific values:

```azurecli
az monitor diagnostic-settings create --name <diagnostic-setting-name> --resource <application-insights-resource-name> --resource-group <resource-group-name> --storage-account <storage-account-name>
```

This example code enables diagnostic settings and sends all metrics and logs of your Application Insights resource to the specified storage account.

For more information about enabling diagnostic settings using Azure CLI, see the [Azure CLI documentation](/azure/monitor/diagnostic-settings#az-monitor-diagnostic-settings-create).

### [PowerShell](#tab/powershell)

To export telemetry using diagnostic settings, run the following PowerShell command in your terminal:

```azurepowershell
Set-AzDiagnosticSetting -ResourceId <application-insights-resource-id> -Name <diagnostic-setting-name> -StorageAccountId <storage-account-id> -Enabled $True
```

This example code enables diagnostic settings and sends all metrics and logs of your Application Insights resource to the specified storage account.

For more information about enabling diagnostic settings using PowerShell, see the [Azure PowerShell documentation](/powershell/module/az.monitor/set-azdiagnosticsetting).

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

Data retention for workspace-based Application Insights resources can be set in the associated Log Analytics workspace.

For more information, see [Configure the default interactive retention period of Analytics tables](/azure/azure-monitor/logs/data-retention-configure?tabs=portal#configure-the-default-interactive-retention-period-of-analytics-tables).

### [Azure CLI](#tab/cli)

Data retention for workspace-based Application Insights resources can be set in the associated Log Analytics workspace.

For more information, see [Configure the default interactive retention period of Analytics tables](/azure/azure-monitor/logs/data-retention-configure?tabs=cli#configure-the-default-interactive-retention-period-of-analytics-tables).

### [PowerShell](#tab/powershell)

Data retention for workspace-based Application Insights resources can be set in the associated Log Analytics workspace.

For more information, see [Configure the default interactive retention period of Analytics tables](/azure/azure-monitor/logs/data-retention-configure?tabs=PowerShell#configure-the-default-interactive-retention-period-of-analytics-tables).

### [REST](#tab/rest)

Data retention for workspace-based Application Insights resources can be set in the associated Log Analytics workspace.

For more information, see [Configure the default interactive retention period of Analytics tables](/azure/azure-monitor/logs/data-retention-configure?tabs=api#configure-the-default-interactive-retention-period-of-analytics-tables).

### [Bicep](#tab/bicep)

```bicep
resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: '<your-app-name>'
  location: '<your-location>'
  properties: {
    Application_Type: 'web'
    RetentionInDays: <retention-period-in-days>
  }
}
```

### [JSON (ARM)](#tab/arm)

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Insights/components",
      "apiVersion": "2020-02-02-preview",
      "name": "<your-app-name>",
      "location": "<your-location>",
      "properties": {
        "Application_Type": "web",
        "RetentionInDays": <retention-period-in-days>
      }
    }
  ]
}
```

---

### Set the daily cap

For workspace-based Application Insights resource, the daily cap must be set independently for both Application Insights and the underlying Log Analytics workspace.

### [Portal](#tab/portal)

To learn how to set the daily cap in the Azure portal, see [Set daily cap on Log Analytics workspace](./../logs/daily-cap.md#application-insights).

### [Azure CLI](#tab/cli)

#### Setting the daily cap for Application Insights

To change the daily cap for Application Insights, run the following Azure CLI command in your terminal and replace the placeholders `<application-insights-resource-name>`, `<resource-group-name>`, and `<daily-cap-in-gb>` with your specific values:

```azurecli
az monitor app-insights component update --app <application-insights-resource-name> --resource-group <resource-group-name> --set dailyCapGB=<daily-cap-in-gb>
```

For more information about setting the daily cap using Azure CLI, see the [Azure CLI documentation](/azure/monitor/app-insights/component/billing#az-monitor-app-insights-component-billing-update).

#### Setting the daily cap for Log Analytics

...

### [PowerShell](#tab/powershell)

#### Setting the daily cap for Application Insights

To change the daily cap for Application Insights, run the following code in your terminal:

```azurepowershell
Set-AzApplicationInsightsDailyCap -ResourceGroupName <your-resource-group> -Name <your-app-name> -DailyCapGB <daily-cap-in-gb>
```

#### Setting the daily cap for Log Analytics

...

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

### [Portal](#tab/portal)

The pricing plan for workspace-based Application Insights resources can be set in the associated Log Analytics workspace. For more information, see [Application Insights billing](./../logs/cost-logs.md#application-insights-billing).

### [Azure CLI](#tab/cli)

To set the pricing plan, run the following Azure CLI command in your terminal and replace the placeholders `<application-insights-resource-name>`, `<resource-group-name>`, and `<pricing-plan>` with your specific values:

```azurecli
az monitor app-insights component billing update \
  --app <application-insights-resource-name> \
  --resource-group <resource-group-name> \
  --pricing-plan <pricing-plan>
```

For more information about setting the pricing placing using Azure CLI, see the [Azure CLI documentation](/azure/monitor/app-insights/component/billing#az-monitor-app-insights-component-billing-update).

### [PowerShell](#tab/powershell)

To set the pricing plan, run the following Azure PowerShell command in your terminal and replace the placeholders \<resource-group-name\>, \<resource-name\>, and \<pricing-plan\> with your specific values:

```azurepowershell
Set-AzApplicationInsightsPricingPlan -ResourceGroupName <resource-group-name> -Name <resource-name> -PricingPlan <pricing-plan>
```

For more information about setting the pricing placing using Azure PowerShell, see our [Azure PowerShell documentation]().

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
<!--
To get the current pricing plan, use the [Set-AzApplicationInsightsPricingPlan](/powershell/module/az.applicationinsights/set-azapplicationinsightspricingplan) cmdlet:

```PS
Set-AzApplicationInsightsPricingPlan -ResourceGroupName <resource group> -Name <resource name> | Format-List
```

To set the pricing plan, use the same cmdlet with the `-PricingPlan` specified:

```PS
Set-AzApplicationInsightsPricingPlan -ResourceGroupName <resource group> -Name <resource name> -PricingPlan Basic
```

You can also set the pricing plan on an existing Application Insights resource by using the preceding ARM template, omitting the "microsoft.insights/components" resource and the `dependsOn` node from the billing resource. For instance, to set it to the Per GB plan (formerly called the Basic plan), run:

```PS
        New-AzResourceGroupDeployment -ResourceGroupName "<resource group>" `
               -TemplateFile .\template1.json `
               -priceCode 1 `
               -appName myApp
```

The `priceCode` is defined as:

| priceCode | Plan                                         |
|-----------|----------------------------------------------|
| 1         | Per GB (formerly named the Basic plan)       |
| 2         | Per Node (formerly name the Enterprise plan) |

Finally, you can use [ARMClient](https://github.com/projectkudu/ARMClient) to get and set pricing plans and daily cap parameters. To get the current values, use:

```PS
armclient GET /subscriptions/00000000-0000-0000-0000-00000000000/resourceGroups/MyResourceGroupName/providers/microsoft.insights/components/MyResourceName/CurrentBillingFeatures?api-version=2018-05-01-preview
```

You can set all of these parameters by using:

```PS
armclient PUT /subscriptions/00000000-0000-0000-0000-00000000000/resourceGroups/MyResourceGroupName/providers/microsoft.insights/components/MyResourceName/CurrentBillingFeatures?api-version=2018-05-01-preview
"{'CurrentBillingFeatures':['Basic'],'DataVolumeCap':{'Cap':200,'ResetTime':12,'StopSendNotificationWhenHitCap':true,'WarningThreshold':90,'StopSendNotificationWhenHitThreshold':true}}"
```

This code sets the daily cap to 200 GB per day, configure the daily cap reset time to 12:00 UTC, send emails both when the cap is hit and the warning level is met, and set the warning threshold to 90% of the cap.
-->
### Add a metric alert

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

To learn how to add a metric alert using using an ARM template, see [Create a new alert rule using the CLI, PowerShell, or an ARM template](./../alerts/alerts-create-rule-cli-powershell-arm.md#create-a-new-alert-rule-using-an-arm-template).

---

To automate the creation of metric alerts, see the [Metric alerts template](../alerts/alerts-metric-create-templates.md#template-for-a-simple-static-threshold-metric-alert) article.

### Create an availability test

### [Portal](#tab/portal)

To learn how to create an availability test in the Azure portal, see [Application Insights availability tests](./availability.md#create-an-availability-test).

### [Azure CLI](#tab/cli)

To create an availability test, run the following Azure CLI command in your terminal and replace the placeholders `<resource-group-name>`, `<web-test-name>`, `<azure-region-name>`, and `<web-test-configuration>` with your specific values:

```azurecli
az monitor app-insights web-test create --resource-group <resource-group-name> \
                                        --name <web-test-name> \
                                        --location <azure-region-name> \
                                        --kind ping \
                                        --frequency 300 \
                                        --timeout 30 \
                                        --enabled true \
                                        --configuration "{\"WebTest\": \"<web-test-configuration>\"}" \
                                        --tags Environment=Production
```

For more information about creating an availability test using Azure CLI, see the [Azure CLI documentation](/cli/azure/monitor/app-insights/web-test#az-monitor-app-insights-web-test-create).

### [PowerShell](#tab/powershell)

To create an availability test, run the following Azure PowerShell command in your terminal and replace the placeholders `<resource-group-name>`, `<web-test-name>`, `<azure-region-name>`, and `<web-test-configuration>` with your specific values:

```azurepowershell
New-AzApplicationInsightsWebTest -ResourceGroupName <resource-group-name> `
                                 -Name <web-test-name> `
                                 -Location <azure-region-name> `
                                 -Kind ping `
                                 -Frequency 300 `
                                 -Timeout 30 `
                                 -Enabled $true `
                                 -Configuration "<web-test-configuration>" `
                                 -Tags @{ Environment = "Production" }
```

For more information about creating an availability test using Azure CLI, see the [Azure PowerShell documentation](/powershell/module/az.applicationinsights/new-azapplicationinsightswebtest).

### [REST](#tab/rest)

To create an availability test using the REST API, use the following request and replace the placeholder s `{subscription-id}`, `{resource-group-name}`, `{webtest-name}`, `{access-token}`, `{azure-location-name}`, and `{website}` with your specific values:

```rest
PUT https://management.azure.com/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Insights/webtests/{webtest-name}?api-version=2022-06-15
Authorization: Bearer {access-token}

{
  "location": "{azure-location-name}",
  "properties": {
    "Name": "{webtest-name}",
    "SyntheticMonitorId": "{webtest-name}",
    "Description": "Simple availability test for {website}",
    "Enabled": true,
    "Frequency": 300,
    "Timeout": 120,
    "Kind": "standard",
    "RetryEnabled": true,
    "Request": {
      "RequestUrl": "https://{website}.com",
      "HttpVerb": "GET"
    },
    "ValidationRules": {
      "SSLCheck": true
    },
    "Locations": [
      {
        "Id": "us-fl-mia-edge"
      }
    ]
  }
}
```

To learn more about creating and configuring web tests using the REST API, see our [REST API documentation](/rest/api/application-insights/web-tests/create-or-update).

### [Bicep](#tab/bicep)

To create an availability test using Bicep, add the following code to your template and replace the placeholders `<web-test-name>`, `<azure-region-name>`, and `<web-test-configuration>` with your specific values:

```bicep
resource availabilityTest 'Microsoft.Insights/webtests@2022-06-15' = {
  name: '<web-test-name>'
  location: '<azure-region-name>'
  kind: 'ping'
  properties: {
    Configuration: {
      WebTest: '<web-test-configuration>'
    }
    Description: 'Availability Test for API'
    Enabled: true
    Frequency: 300
    Timeout: 30
  }
  tags: {
    Environment: 'Production'
  }
}
```

For more information about creating availability tests using Bicep, see [Microsoft.Insights webtests](/azure/templates/microsoft.insights/webtests?pivots=deployment-language-bicep).

### [JSON (ARM)](#tab/arm)

To create an availability test using JSON (ARM), add the following code to your template and replace the placeholders `<web-test-name>`, `<azure-region-name>`, and `<web-test-configuration>` with your specific values:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Insights/webtests",
      "apiVersion": "2022-06-15",
      "name": "<web-test-name>",
      "location": "<azure-region-name>",
      "kind": "ping",
      "properties": {
        "Configuration": {
          "WebTest": "<web-test-configuration>"
        },
        "Description": "Availability Test for API",
        "Enabled": true,
        "Frequency": 300,
        "Timeout": 30
      },
      "tags": {
        "Environment": "Production"
      }
    }
  ]
}
```

For more information about creating availability tests using JSON (ARM), see [Microsoft.Insights webtests](/azure/templates/microsoft.insights/webtests?pivots=deployment-language-arm-template).

---

## How many Application Insights resources should I deploy?

When you're developing the next version of a web application, you don't want to mix up the [Application Insights](../../azure-monitor/app/app-insights-overview.md) telemetry from the new version and the already released version.

To avoid confusion, send the telemetry from different development stages to separate Application Insights resources with separate connection strings.

If your system is an instance of Azure Cloud Services, there's [another method of setting separate connection strings](../../azure-monitor/app/azure-web-apps-net-core.md).

### About resources and connection strings

When you set up Application Insights monitoring for your web app, you create an Application Insights resource in Azure. You open the resource in the Azure portal to see and analyze the telemetry collected from your app. A connection string identifies the resource. When you install the Application Insights package to monitor your app, you configure it with the connection string so that it knows where to send the telemetry.

Each Application Insights resource comes with metrics that are available out of the box. If separate components report to the same Application Insights resource, it might not make sense to alert on these metrics.

### When to use a single Application Insights resource

Use a single Application Insights resource for:

* Streamlining DevOps/ITOps management for applications deployed together, typically developed and managed by the same team.
* Centralizing key performance indicators, such as response times and failure rates, in a dashboard by default. Segment by role name in the metrics explorer if necessary.
* When there's no need for different Azure role-based access control management between application components.
* When identical metrics alert criteria, continuous exports, and billing/quotas management across components suffice.
* When it's acceptable for an API key to access data from all components equally, and 10 API keys meet the needs across all components.
* When the same smart detection and work item integration settings are suitable across all roles.

> [!NOTE]
> If you want to consolidate multiple Application Insights resources, you can point your existing application components to a new, consolidated Application Insights resource. The telemetry stored in your old resource won't be transferred to the new resource. Only delete the old resource when you have enough telemetry in the new resource for business continuity.

### Other considerations

To activate portal experiences, add custom code to assign meaningful values to the [Cloud_RoleName](./app-map.md?tabs=net#set-or-override-cloud-role-name) attribute. Without these values, portal features don't function.

For Azure Service Fabric applications and classic cloud services, the SDK automatically configures services by reading from the Azure Role Environment. For other app types, you typically need to set it explicitly.

Live Metrics can't split data by role name.

### Create more Application Insights resources

> [!WARNING]
> You might incur additional network costs if your Application Insights resource is monitoring an Azure resource (i.e., telemetry producer) in a different region. Costs vary depending on the region the telemetry is coming from and where it's going. Refer to [Azure bandwidth pricing](https://azure.microsoft.com/pricing/details/bandwidth/) for details.

To create an Applications Insights resource, see [Create an Application Insights resource](#create-a-workspace-based-resource).

To automate the creation of any other resource of any kind, create an example manually and then copy and parameterize its code from [Azure Resource Manager](https://resources.azure.com/).

1. Open [Azure Resource Manager](https://resources.azure.com/). Navigate down through `subscriptions/resourceGroups/<your resource group>/providers/Microsoft.Insights/components` to your application resource.

    :::image type="content" source="./media/powershell/01.png" lightbox="./media/powershell/01.png" alt-text="Screenshot that shows navigation in Azure Resource Explorer.":::

    *Components* are the basic Application Insights resources for displaying applications. There are separate resources for the associated alert rules and availability web tests.
1. Copy the JSON of the component into the appropriate place in `template1.json`.

1. Delete these properties:

   * `id`
   * `InstrumentationKey`
   * `CreationDate`
   * `TenantId`

1. Open the `webtests` and `alertrules` sections and copy the JSON for individual items into your template. Don't copy from the `webtests` or `alertrules` nodes. Go into the items under them.

    Each web test has an associated alert rule, so you have to copy both of them.

1. Insert this line in each resource:

    `"apiVersion": "2015-05-01",`

### Parameterize the template

Replace the specific names with parameters. To [parameterize a template](/azure/azure-resource-manager/templates/syntax), you write expressions using a [set of helper functions](/azure/azure-resource-manager/templates/template-functions).

You can't parameterize only part of a string, so use `concat()` to build strings.

Here are examples of the substitutions you want to make. There are several occurrences of each substitution. You might need others in your template. These examples use the parameters and variables we defined at the top of the template.

| Find                                                                            | Replace with                                                                                                                     |
|---------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| `"hidden-link:/subscriptions/.../../components/MyAppName"`                      | `"[concat('hidden-link:',`<br/>`resourceId('microsoft.insights/components',` <br/> `parameters('appName')))]"`                   |
| `"/subscriptions/.../../alertrules/myAlertName-myAppName-subsId",`              | `"[resourceId('Microsoft.Insights/alertrules', variables('alertRuleName'))]",`                                                   |
| `"/subscriptions/.../../webtests/myTestName-myAppName",`                        | `"[resourceId('Microsoft.Insights/webtests', parameters('webTestName'))]",`                                                      |
| `"myWebTest-myAppName"`                                                         | `"[variables(testName)]"'`                                                                                                       |
| `"myTestName-myAppName-subsId"`                                                 | `"[variables('alertRuleName')]"`                                                                                                 |
| `"myAppName"`                                                                   | `"[parameters('appName')]"`                                                                                                      |
| `"myappname"` (lower case)                                                      | `"[toLower(parameters('appName'))]"`                                                                                             |
| `"<WebTest Name=\"myWebTest\" ...`<br/>`Url=\"http://fabrikam.com/home\" ...>"` | `[concat('<WebTest Name=\"',` <br/> `parameters('webTestName'),` <br/> `'\" ... Url=\"', parameters('Url'),` <br/> `'\"...>')]"` |

### Set dependencies between the resources

Azure should set up the resources in strict order. To make sure one setup completes before the next begins, add dependency lines:

* In the availability test resource:
  
    `"dependsOn": ["[resourceId('Microsoft.Insights/components', parameters('appName'))]"],`

* In the alert resource for an availability test:
  
    `"dependsOn": ["[resourceId('Microsoft.Insights/webtests', variables('testName'))]"],`

#### Get the connection string

The connection string identifies the resource that you created.

You need the connection strings of all the resources to which your app sends data.

### Filter on the build number

When you publish a new version of your app, you want to be able to separate the telemetry from different builds.

You can set the **Application Version** property so that you can filter [search](../../azure-monitor/app/transaction-search-and-diagnostics.md?tabs=transaction-search) and [metric explorer](../../azure-monitor/essentials/metrics-charts.md) results.

There are several different methods of setting the **Application Version** property.

* Set directly:

    `telemetryClient.Context.Component.Version = typeof(MyProject.MyClass).Assembly.GetName().Version;`

* Wrap that line in a [telemetry initializer](../../azure-monitor/app/api-custom-events-metrics.md#defaults) to ensure that all `TelemetryClient` instances are set consistently.

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

## Frequently asked questions

This section provides answers to common questions.

### How do I move an Application Insights resource to a new region?

Transferring existing Application Insights resources between regions isn't supported, and you can't migrate historical data to a new region. The workaround involves:

* Creating a new workspace-based Application Insights resource in the desired region.
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
