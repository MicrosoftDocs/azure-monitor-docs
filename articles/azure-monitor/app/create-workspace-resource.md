---
title: Create a new Azure Monitor Application Insights workspace-based resource
description: Learn about the steps required to enable the new Azure Monitor Application Insights workspace-based resources. 
ms.topic: conceptual
ms.date: 12/15/2023
ms.reviewer: cogoodson
ms.custom: devx-track-azurepowershell, devx-track-azurecli
zone_pivot_groups: manual-creation-and-at-scale-automation
---

# Create and manage Application Insights resources

Workspace-based [Application Insights](app-insights-overview.md#application-insights-overview) integrates with [Log Analytics](../logs/log-analytics-overview.md#overview-of-log-analytics-in-azure-monitor) and sends telemetry to a common Log Analytics workspace. This setup provides full access to Log Analytics features, consolidates logs in one location, and allows for unified [Azure role-based access control](../roles-permissions-security.md) which eliminates the need for cross-app/workspace queries.

Enhanced capabilities include:

* [Customer-managed keys](../logs/customer-managed-keys.md) encrypt your data at rest with keys only accessible to you.
* [Azure Private Link](../logs/private-link-security.md) securely connects Azure PaaS services to your virtual network using private endpoints.
* [Bring your own storage (BYOS)](./profiler-bring-your-own-storage.md) lets you manage data from [.NET Profiler](../profiler/profiler-overview.md) and [Snapshot Debugger](../snapshot-debugger/snapshot-debugger.md) with policies on encryption, lifetime, and network access.
* [Commitment tiers](../logs/cost-logs.md#commitment-tiers) offer up to a 30% saving over pay-as-you-go pricing.
* Log Analytics streaming processes data more quickly.

> [!NOTE]
> Data ingestion and retention for workspace-based Application Insights resources are billed through the Log Analytics workspace where the data is located. To learn more about billing for workspace-based Application Insights resources, see [Azure Monitor Logs pricing details](../logs/cost-logs.md).

:::zone pivot="auto"

## At-scale automation

[!INCLUDE [updated-for-az](~/reusable-content/ce-skilling/azure/includes/updated-for-az.md)]

This article shows you how to automate creating and updating [Application Insights](./app-insights-overview.md) resources. Along with the basic Application Insights resource, you can create [availability web tests](./availability-overview.md), set up [alerts](../alerts/alerts-log.md), set the [pricing scheme](../logs/cost-logs.md#application-insights-billing), and create other Azure resources.

### ARM templates

The key to creating these resources is Bicep or JSON templates for [Azure Resource Manager](/azure/azure-resource-manager/management/manage-resources-powershell). The basic procedure is:

* Download the Bicep pr JSON definitions of existing resources.
* Parameterize certain values, such as names.
* Run the template whenever you want to create a new resource.

You can package several resources together to create them all in one go. For example, you can create an app monitor with availability tests, alerts, and storage for continuous export. There are some subtleties to some of the parameterizations, which we explain here.

### PowerShell cmdlets

There's a rich set of [Application Insights PowerShell cmdlets](/powershell/module/az.applicationinsights). These cmdlets make it easy to configure Application Insights resources programatically. You can use the capabilities enabled by the cmdlets to:

* Create and delete Application Insights resources.
* Get lists of Application Insights resources and their properties.
* Create and manage continuous export.
* Create and manage application keys.
* Set the daily cap.
* Set the pricing plan.

## Prerequisites

### [Azure CLI](#tab/cli)

To access the preview Application Insights Azure CLI commands, you first need to run:

```azurecli
 az extension add -n application-insights
```

If you don't run the `az extension add` command, you see an error message that states `az : ERROR: az monitor: 'app-insights' is not in the 'az monitor' command group. See 'az monitor --help'`.

### [Azure PowerShell](#tab/powershell)

If you haven't used PowerShell with your Azure subscription before, install the Azure PowerShell module on the machine where you want to run the scripts:

1. Install [Microsoft Web Platform Installer (v5 or higher)](https://www.microsoft.com/web/downloads/platform.aspx).
1. Use it to install Azure PowerShell.

### [ARM templates](#tab/arm)

If you haven't used PowerShell with your Azure subscription before, install the Azure PowerShell module on the machine where you want to run the scripts:

1. Install [Microsoft Web Platform Installer (v5 or higher)](https://www.microsoft.com/web/downloads/platform.aspx).
1. Use it to install Azure PowerShell.

---

:::zone-end

## Create a workspace-based resource

:::zone pivot="manual"

Sign in to the [Azure portal](https://portal.azure.com), and create an Application Insights resource.

> [!div class="mx-imgBorder"]
> :::image type="content" source="./media/create-workspace-resource/create-workspace-based.png" lightbox="./media/create-workspace-resource/create-workspace-based.png" alt-text="Screenshot that shows a workspace-based Application Insights resource.":::

If you don't have an existing Log Analytics workspace, see the [Log Analytics workspace creation documentation](../logs/quick-create-workspace.md).

*Workspace-based resources are currently available in all commercial regions and Azure Government. Having Application Insights and Log Analytics in two different regions can impact latency and reduce overall reliability of the monitoring solution.*

After you create your resource, you'll see corresponding workspace information in the **Overview** pane.

:::image type="content" source="./media/create-workspace-resource/workspace-name.png" lightbox="./media/create-workspace-resource/workspace-name.png" alt-text="Screenshot that shows a workspace name.":::

Select the blue link text to go to the associated Log Analytics workspace where you can take advantage of the new unified workspace query environment.

> [!NOTE]
> We still provide full backward compatibility for your Application Insights classic resource queries, workbooks, and log-based alerts. To query or view the [new workspace-based table structure or schema](/previous-versions/azure/azure-monitor/app/convert-classic-resource#workspace-based-resource-changes), you must first go to your Log Analytics workspace. Select **Logs (Analytics)** in the **Application Insights** panes for access to the classic Application Insights query experience.

:::zone-end

:::zone pivot="auto"

### [Azure CLI](#tab/cli)

Run the following code to create your Application Insights resource:

```azurecli
az monitor app-insights component create --app
                                         --location
                                         --resource-group
                                         [--application-type]
                                         [--ingestion-access {Disabled, Enabled}]
                                         [--kind]
                                         [--only-show-errors]
                                         [--query-access {Disabled, Enabled}]
                                         [--tags]
                                         [--workspace]
```

#### Example

```azurecli
az monitor app-insights component create --app demoApp --location eastus --kind web -g my_resource_group --workspace "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/test1234/providers/microsoft.operationalinsights/workspaces/test1234555"
```

For the full Azure CLI documentation for this command, see the [Azure CLI documentation](/cli/azure/monitor/app-insights/component#az-monitor-app-insights-component-create).

### [Azure PowerShell](#tab/powershell)

Create a new Application Insights resource by using the [New-AzApplicationInsights](/powershell/module/az.applicationinsights/new-azapplicationinsights) cmdlet:

```powershell
New-AzApplicationInsights -Name <String> -ResourceGroupName <String> -Location <String> -WorkspaceResourceId <String>
   [-SubscriptionId <String>]
   [-ApplicationType <ApplicationType>]
   [-DisableIPMasking]
   [-DisableLocalAuth]
   [-Etag <String>]
   [-FlowType <FlowType>]
   [-ForceCustomerStorageForProfiler]
   [-HockeyAppId <String>]
   [-ImmediatePurgeDataOn30Day]
   [-IngestionMode <IngestionMode>]
   [-Kind <String>]
   [-PublicNetworkAccessForIngestion <PublicNetworkAccessType>]
   [-PublicNetworkAccessForQuery <PublicNetworkAccessType>]
   [-RequestSource <RequestSource>]
   [-RetentionInDays <Int32>]
   [-SamplingPercentage <Double>]
   [-Tag <Hashtable>]
   [-DefaultProfile <PSObject>]
   [-Confirm]
   [-WhatIf]
   [<CommonParameters>]
```

#### Example

```powershell
New-AzApplicationInsights -Kind java -ResourceGroupName testgroup -Name test1027 -location eastus -WorkspaceResourceId "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/test1234/providers/microsoft.operationalinsights/workspaces/test1234555"
```

For the full PowerShell documentation for this cmdlet, and to learn how to retrieve the connection string, see the [Azure PowerShell documentation](/powershell/module/az.applicationinsights/new-azapplicationinsights).

### [ARM templates](#tab/arm)

Here's how to create a new Application Insights resource by using an ARM template.

### Create a template

* **Option 1: Bicep**

    ```bicep
    @description('Name of Application Insights resource.')
    param name string
    
    @description('Type of app you are deploying. This field is for legacy reasons and will not impact the type of App Insights resource you deploy.')
    param type string
    
    @description('Which Azure Region to deploy the resource to. This must be a valid Azure regionId.')
    param regionId string
    
    @description('See documentation on tags: https://learn.microsoft.com/azure/azure-resource-manager/management/tag-resources.')
    param tagsArray object
    
    @description('Source of Azure Resource Manager deployment')
    param requestSource string
    
    @description('Log Analytics workspace ID to associate with your Application Insights resource.')
    param workspaceResourceId string
    
    resource component 'Microsoft.Insights/components@2020-02-02' = {
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

* **Option 2: JSON**

    Create a new .json file (for example, `template1.json`) and copy the following content into it:

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

#### Parameter file

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

    ```PS
        New-AzResourceGroupDeployment -ResourceGroupName Fabrikam `
               -TemplateFile .\template1.json `
               -appName myNewApp

    ``` 

   * `-ResourceGroupName` is the group where you want to create the new resources.
   * `-TemplateFile` must occur before the custom parameters.
   * `-appName` is the name of the resource to create.

You can add other parameters. You find their descriptions in the parameters section of the template.

---

:::zone-end

## Configure monitoring

After creating a workspace-based Application Insights resource, you configure monitoring.

### Get the connection string

The [connection string](./connection-strings.md?tabs=net) identifies the resource that you want to associate your telemetry data with. You can also use it to modify the endpoints your resource uses as a destination for your telemetry. You must copy the connection string and add it to your application's code or to an environment variable.

:::zone pivot="manual"

To get the connection string of your Application Insights resource:

1. Open your Application Insights resource in the Azure portal.
1. On the Overview pane, look for the connection string under **Essentials**.
1. If you hover over the connection string, an icon will apear which allows you to copy it to your clipboard.

:::zone-end

:::zone pivot="auto"

### [Azure CLI](#tab/cli)

Run the following code in your terminal to get the connection string:

```azurecli
az monitor app-insights component show --app <your-app-name> --resource-group <your-resource-group> --query connectionString --output tsv
```

### [Azure PowerShell](#tab/powershell)

Run the following code in your terminal to get the connection string:

```powershell
Get-AzApplicationInsights -ResourceGroupName <your-resource-group> -Name <your-app-name> | Select-Object -ExpandProperty ConnectionString`
```

To see a list of many other properties of your Application Insights resource, use:

```powershell
Get-AzApplicationInsights -ResourceGroupName <your-resource-group> -Name <your-app-name> | Format-List
```

More properties are available via the cmdlets:

* `Set-AzApplicationInsightsDailyCap`
* `Set-AzApplicationInsightsPricingPlan`
* `Get-AzApplicationInsightsApiKey`
* `Get-AzApplicationInsightsContinuousExport`

See the [detailed documentation](/powershell/module/az.applicationinsights) for the parameters for these cmdlets.  

### [ARM templates](#tab/arm)

Not applicable to ARM templates.

---

:::zone-end

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

## Modify the associated workspace

:::zone pivot="manual"

After creating a workspace-based Application Insights resource, you can modify the associated Log Analytics workspace.

In the Application Insights resource pane, select **Properties** > **Change Workspace** > **Log Analytics Workspaces**.

:::zone-end

:::zone pivot="auto"

### [Azure CLI](#tab/cli)

Run the following code in your terminal to change the Log Analytics workspace:

```azurecli
az monitor app-insights component update --app <your-app-name> --resource-group <your-resource-group> --workspace <new-workspace-resource-id>
```

### [Azure PowerShell](#tab/powershell)

Run the following code in your terminal to change the Log Analytics workspace:

```powershell
$resource = Get-AzResource -ResourceType "Microsoft.Insights/components" -ResourceGroupName "<your-resource-group>" -ResourceName "<your-app-name>"
$resource.Properties.WorkspaceResourceId = "<new-workspace-resource-id>"
Set-AzResource -ResourceId $resource.ResourceId -Properties $resource.Properties -Force
```

### [ARM templates](#tab/arm)

#### Option 1: Bicep

```bicep
resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: '<your-app-name>'
  location: '<your-location>'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: '<new-workspace-resource-id>'
  }
}
```

#### Option 2: JSON

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
        "WorkspaceResourceId": "<new-workspace-resource-id>"
      }
    }
  ]
}
```

---

:::zone-end

## Export telemetry

The legacy continuous export functionality isn't supported for workspace-based resources. Instead, select **Diagnostic settings** > **Add diagnostic setting** in your Application Insights resource. You can select all tables, or a subset of tables, to archive to a storage account. You can also stream to an Azure event hub.

> [!NOTE]
> Diagnostic settings export might increase costs. For more information, see [Export telemetry from Application Insights](export-telemetry.md#diagnostic-settings-based-export).
> For pricing information for this feature, see the [Azure Monitor pricing page](https://azure.microsoft.com/pricing/details/monitor/). Prior to the start of billing, notifications will be sent. If you continue to use telemetry export after the notice period, you'll be billed at the applicable rate.

## Update Application Insights resources

### Set the data retention

:::zone pivot="manual"

Data retention for workspace-based Application Insights resources can be set in the associated Log Analytics workspace. For more information, see [Configure the default interactive retention period of Analytics tables](./../logs/data-retention-configure.md#configure-the-default-interactive-retention-period-of-analytics-tables).

:::zone-end

:::zone pivot="auto"
<!--
You can use the following three methods to programmatically set the data retention on an Application Insights resource.

#### Set data retention by using PowerShell commands

Here's a simple set of PowerShell commands to set the data retention for your Application Insights resource:

```PS
$Resource = Get-AzResource -ResourceType Microsoft.Insights/components -ResourceGroupName MyResourceGroupName -ResourceName MyResourceName
$Resource.Properties.RetentionInDays = 365
$Resource | Set-AzResource -Force
```

#### Set data retention by using REST

To get the current data retention for your Application Insights resource, you can use the OSS tool [ARMClient](https://github.com/projectkudu/ARMClient). Learn more about ARMClient from articles by [David Ebbo](http://blog.davidebbo.com/2015/01/azure-resource-manager-client.html) and Daniel Bowbyes. Here's an example that uses `ARMClient` to get the current retention:

```PS
armclient GET /subscriptions/00000000-0000-0000-0000-00000000000/resourceGroups/MyResourceGroupName/providers/microsoft.insights/components/MyResourceName?api-version=2018-05-01-preview
```

To set the retention, the command is a similar PUT:

```PS
armclient PUT /subscriptions/00000000-0000-0000-0000-00000000000/resourceGroups/MyResourceGroupName/providers/microsoft.insights/components/MyResourceName?api-version=2018-05-01-preview "{location: 'eastus', properties: {'retentionInDays': 365}}"
```

To set the data retention to 365 days by using the preceding template, run:

```PS
New-AzResourceGroupDeployment -ResourceGroupName "<resource group>" `
       -TemplateFile .\template1.json `
       -retentionInDays 365 `
       -appName myApp
```

#### Set data retention by using a PowerShell script

The following script can also be used to change retention. Copy this script to save it as `Set-ApplicationInsightsRetention.ps1`.

```PS
Param(
    [Parameter(Mandatory = $True)]
    [string]$SubscriptionId,

    [Parameter(Mandatory = $True)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $True)]
    [string]$Name,

    [Parameter(Mandatory = $True)]
    [string]$RetentionInDays
)
$ErrorActionPreference = 'Stop'
if (-not (Get-Module Az.Accounts)) {
    Import-Module Az.Accounts
}
$azProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
if (-not $azProfile.Accounts.Count) {
    Write-Error "Ensure you have logged in before calling this function."    
}
$currentAzureContext = Get-AzContext
$profileClient = New-Object Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient($azProfile)
$token = $profileClient.AcquireAccessToken($currentAzureContext.Tenant.TenantId)
$UserToken = $token.AccessToken
$RequestUri = "https://management.azure.com/subscriptions/$($SubscriptionId)/resourceGroups/$($ResourceGroupName)/providers/Microsoft.Insights/components/$($Name)?api-version=2015-05-01"
$Headers = @{
    "Authorization"         = "Bearer $UserToken"
    "x-ms-client-tenant-id" = $currentAzureContext.Tenant.TenantId
}
## Get Component object via ARM
$GetResponse = Invoke-RestMethod -Method "GET" -Uri $RequestUri -Headers $Headers 

## Update RetentionInDays property
if($($GetResponse.properties | Get-Member "RetentionInDays"))
{
    $GetResponse.properties.RetentionInDays = $RetentionInDays
}
else
{
    $GetResponse.properties | Add-Member -Type NoteProperty -Name "RetentionInDays" -Value $RetentionInDays
}
## Upsert Component object via ARM
$PutResponse = Invoke-RestMethod -Method "PUT" -Uri "$($RequestUri)" -Headers $Headers -Body $($GetResponse | ConvertTo-Json) -ContentType "application/json"
$PutResponse
```

This script can then be used as:

```PS
Set-ApplicationInsightsRetention `
        [-SubscriptionId] <String> `
        [-ResourceGroupName] <String> `
        [-Name] <String> `
        [-RetentionInDays <Int>]
```
-->
### [Azure CLI](#tab/cli)

```azurecli
az monitor app-insights component update --app <your-app-name> --resource-group <your-resource-group> --set retentionInDays=<retention-period-in-days>
```


### [Azure PowerShell](#tab/powershell)

```powershell
$Resource = Get-AzResource -ResourceType "Microsoft.Insights/components" -ResourceGroupName "<your-resource-group>" -ResourceName "<your-app-name>"
$Resource.Properties.RetentionInDays = <retention-period-in-days>
Set-AzResource -ResourceId $Resource.ResourceId -Properties $Resource.Properties -Force
```

### [ARM templates](#tab/arm)

#### Option 1: Bicep

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

#### Option 2: JSON

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

:::zone-end

### Set the daily cap

:::zone pivot="manual"

For workspace-based Application Insights resource, the daily caps must be set independently for both Application Insights and the underlying Log Analytics workspace. For more information, see [Set daily cap on Log Analytics workspace](./../logs/daily-cap.md#application-insights).

:::zone-end

:::zone pivot="auto"
<!--
To get the daily cap properties, use the [Set-AzApplicationInsightsPricingPlan](/powershell/module/az.applicationinsights/set-azapplicationinsightspricingplan) cmdlet:

```PS
Set-AzApplicationInsightsDailyCap -ResourceGroupName <resource group> -Name <resource name> | Format-List
```

To set the daily cap properties, use the same cmdlet. For instance, to set the cap to 300 GB per day:

```PS
Set-AzApplicationInsightsDailyCap -ResourceGroupName <resource group> -Name <resource name> -DailyCapGB 300
```

You can also use [ARMClient](https://github.com/projectkudu/ARMClient) to get and set daily cap parameters.  To get the current values, use:

```PS
armclient GET /subscriptions/00000000-0000-0000-0000-00000000000/resourceGroups/MyResourceGroupName/providers/microsoft.insights/components/MyResourceName/CurrentBillingFeatures?api-version=2018-05-01-preview
```

#### Set the daily cap reset time

> [!IMPORTANT]
> The daily cap reset time can no longer be customized using the `ResetTime` attribute.
-->
### [Azure CLI](#tab/cli)

```azurecli
az monitor app-insights component update --app <your-app-name> --resource-group <your-resource-group> --set dailyCapGB=<daily-cap-in-gb>
```

### [Azure PowerShell](#tab/powershell)

```powershell
Set-AzApplicationInsightsDailyCap -ResourceGroupName <your-resource-group> -Name <your-app-name> -DailyCapGB <daily-cap-in-gb>
```

### [ARM templates](#tab/arm)

#### Option 1: Bicep

```bicep
resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: '<your-app-name>'
  location: '<your-location>'
  properties: {
    Application_Type: 'web'
    DailyQuotaGb: <daily-cap-in-gb>
  }
}
```

#### Option 2: JSON

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
        "DailyQuotaGb": <daily-cap-in-gb>
      }
    }
  ]
}
```

---

:::zone-end

### Set the pricing plan

:::zone pivot="manual"

The pricing plan for workspace-based Application Insights resources can be set in the associated Log Analytics workspace. For more information, see [Application Insights billing](./../logs/cost-logs.md#application-insights-billing).

:::zone-end

:::zone pivot="auto"

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

|priceCode|Plan|
|---|---|
|1|Per GB (formerly named the Basic plan)|
|2|Per Node (formerly name the Enterprise plan)|

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

:::zone-end

### Add a metric alert

:::zone pivot="manual"

...

:::zone-end

:::zone pivot="auto"

To automate the creation of metric alerts, see the [Metric alerts template](../alerts/alerts-metric-create-templates.md#template-for-a-simple-static-threshold-metric-alert) article.

:::zone-end

### Add an availability test

:::zone pivot="manual"

...

:::zone-end

:::zone pivot="auto"

To automate availability tests, see the [Metric alerts template](../alerts/alerts-metric-create-templates.md#template-for-an-availability-test-along-with-a-metric-alert) article.

:::zone-end

## Additional Application Insights resources

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
> You might incur additional network costs if your Application Insights resource is monitoring an Azure resource (i.e., telemetry producer) in a different region. Costs will vary depending on the region the telemetry is coming from and where it is going. Refer to [Azure bandwidth pricing](https://azure.microsoft.com/pricing/details/bandwidth/) for details.

:::zone pivot="manual"

To create an Applications Insights resource, see [Create an Application Insights resource](/azure/azure-monitor/app/create-workspace-resource&tabs=arm&pivots=manual#create-a-workspace-based-resource).

:::zone-end

:::zone pivot="auto"

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

Now you have to replace the specific names with parameters. To [parameterize a template](/azure/azure-resource-manager/templates/syntax), you write expressions using a [set of helper functions](/azure/azure-resource-manager/templates/template-functions).

You can't parameterize only part of a string, so use `concat()` to build strings.

Here are examples of the substitutions you want to make. There are several occurrences of each substitution. You might need others in your template. These examples use the parameters and variables we defined at the top of the template.

| Find | Replace with |
| --- | --- |
| `"hidden-link:/subscriptions/.../../components/MyAppName"` |`"[concat('hidden-link:',`<br/>`resourceId('microsoft.insights/components',` <br/> `parameters('appName')))]"` |
| `"/subscriptions/.../../alertrules/myAlertName-myAppName-subsId",` |`"[resourceId('Microsoft.Insights/alertrules', variables('alertRuleName'))]",` |
| `"/subscriptions/.../../webtests/myTestName-myAppName",` |`"[resourceId('Microsoft.Insights/webtests', parameters('webTestName'))]",` |
| `"myWebTest-myAppName"` |`"[variables(testName)]"'` |
| `"myTestName-myAppName-subsId"` |`"[variables('alertRuleName')]"` |
| `"myAppName"` |`"[parameters('appName')]"` |
| `"myappname"` (lower case) |`"[toLower(parameters('appName'))]"` |
| `"<WebTest Name=\"myWebTest\" ...`<br/>`Url=\"http://fabrikam.com/home\" ...>"` |`[concat('<WebTest Name=\"',` <br/> `parameters('webTestName'),` <br/> `'\" ... Url=\"', parameters('Url'),` <br/> `'\"...>')]"`|

### Set dependencies between the resources

Azure should set up the resources in strict order. To make sure one setup completes before the next begins, add dependency lines:

* In the availability test resource:
  
    `"dependsOn": ["[resourceId('Microsoft.Insights/components', parameters('appName'))]"],`
* In the alert resource for an availability test:
  
    `"dependsOn": ["[resourceId('Microsoft.Insights/webtests', variables('testName'))]"],`

:::zone-end

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

We don't recommend using this method of populating the API version. The newest version can represent preview releases, which might contain breaking changes. Even with newer nonpreview releases, the API versions aren't always backward compatible with existing templates. In some cases, the API version might not be available to all subscriptions.

## Next steps

:::zone pivot="manual"

* [Explore metrics](../essentials/metrics-charts.md)
* [Write Log Analytics queries](../logs/log-query-overview.md)
* [Shared resources for multiple roles](./app-map.md)
* [Create a Telemetry Initializer to distinguish A|B variants](./api-filtering-sampling.md#add-properties)

:::zone-end

:::zone pivot="auto"

See these other automation articles:

* [Create an Application Insights resource](./create-workspace-resource.md)
* [Create web tests](../alerts/resource-manager-alerts-metric.md#availability-test-with-metric-alert).
* [Send Azure Diagnostics to Application Insights](../agents/diagnostics-extension-to-application-insights.md).
* [Create release annotations](release-and-work-item-insights.md?tabs=release-annotations).

:::zone-end