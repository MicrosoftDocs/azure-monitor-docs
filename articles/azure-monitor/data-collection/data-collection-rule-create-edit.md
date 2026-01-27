---
title: Create data collection rules (DCRs) in Azure Monitor
description: Details on creating data collection rules (DCRs) in Azure Monitor.
ms.topic: how-to
ms.date: 01/20/2026
ms.reviewer: nikeist
ms.custom: references_regions
---

# Create data collection rules (DCRs) in Azure Monitor

There are multiple methods for creating a [data collection rule (DCR)](data-collection-rule-overview.md) in Azure Monitor. In some cases, Azure Monitor will create and manage the DCR according to settings that you configure in the Azure portal. You may not even realize that you're working with a DCR in some of these cases. For other scenarios though, you may need to create your own DCRs or edit existing ones by directly working with their definition in JSON. This article describes the different methods for creating a DCR and recommendations on editing and troubleshooting them.

> [!NOTE]
> This article describes how to create and edit the DCR itself. To create and edit data collection rule associations, see [Create and manage data collection rule associations](data-collection-rule-associations.md).

## Permissions

You require the following permissions to create DCRs and [DCR associations](data-collection-rule-associations.md):

| Built-in role | Scopes | Reason |
|:--------------|:-------|:-------|
| [Monitoring Contributor](/azure/role-based-access-control/built-in-roles#monitoring-contributor) | <ul><li>Subscription and/or</li><li>Resource group and/or </li><li>An existing DCR</li></ul> | Create or edit DCRs, assign rules to the machine, deploy associations. |
| [Virtual Machine Contributor](/azure/role-based-access-control/built-in-roles#virtual-machine-contributor)<br>[Azure Connected Machine Resource Administrator](/azure/role-based-access-control/built-in-roles#azure-connected-machine-resource-administrator)</li></ul> | <ul><li>Virtual machines, virtual machine scale sets</li><li>Azure Arc-enabled servers</li></ul> | Deploy agent extensions on the VM (virtual machine). |
| Any role that includes the action *Microsoft.Resources/deployments/** | <ul><li>Subscription and/or</li><li>Resource group and/or </li><li>An existing DCR</li></ul> | Deploy Azure Resource Manager templates. |

> [!IMPORTANT]
> Create your DCR in the same region as your destination Log Analytics workspace or Azure Monitor workspace. You can associate the DCR to machines or containers from any subscription or resource group in the tenant. To send data across tenants, you must first enable [Azure Lighthouse](/azure/lighthouse/overview).

## Create or edit a DCR using the Azure portal

The Azure portal provides a simplified experience for creating a DCR for particular scenarios. Using this method, you don't need to understand the structure of a DCR, although you may be limited in the configuration you can perform and may need to later edit the DCR definition to implement an advanced feature such as a transformation. The experience will vary for each scenario, so refer to the documentation for the specific scenario you're working with as described in the following table.

| Scenario | Description |
|:---------|:------------|
| Enable VM insights | When you enable VM Insights on a VM, the Azure Monitor agent is installed and a DCR is created and associated with the virtual machine. This DCR collects a predefined set of performance counters and shouldn't be modified. See [Enable VM Insights](../vm/vminsights-enable-overview.md). |
| Collect client data from VM | Create a DCR in the Azure portal using a guided interface to select different data sources from the client operating system of a VM. Examples include Windows events, Syslog events, and text logs. The Azure Monitor agent is automatically installed if necessary, and an association is created between the DCR and each VM you select. See [Collect data with Azure Monitor Agent](../vm/data-collection.md). |
| Metrics export | Create a DCR in the Azure portal using a guided interface to select metrics of different resource types to collect. An association is created between the DCR and each resource you select. See [Create a data collection rule (DCR) for metrics export](metrics-export-create.md). |
| Table creation | When you create a new table in a Log Analytics workspace using the Azure portal, you upload sample data that Azure Monitor uses to create a DCR, including a transformation, that can be used with the [Logs Ingestion API](../logs/logs-ingestion-api-overview.md). You can't modify this DCR in the Azure portal but can modify it using any of the methods described in this article. See [Create a custom table](../logs/create-custom-table.md?tabs=azure-portal-1%2Cazure-portal-2%2Cazure-portal-3#create-a-custom-table). |
| Kubernetes monitoring | To monitor a Kubernetes cluster, you enable Container Insights for logs and Prometheus for metrics. A DCR for each is created and associated with the containerized version of Azure Monitor agent in the cluster. You may need to modify the Container insights DCR to add a transformation. See [Enable monitoring for Kubernetes clusters](../containers/kubernetes-monitoring-enable.md) and [Data transformations in Container insights](../containers/container-insights-transformations.md). |
| Workspace transformation DCR | Workspace transformation DCRs provide transformations for data collection scenarios that don't yet use DCRs. You can create this DCR by using the Azure portal to create a transformation for a particular table. See [Create workspace transformation DCR](data-collection-transformations-create.md#create-workspace-transformation-dcr). |

## Create or edit a DCR using JSON

In addition to editing an existing DCR, you can create a new one using one of the [sample DCRs](data-collection-rule-samples.md) which provide the JSON for several common scenarios. Use information in [Structure of a data collection rule in Azure Monitor](data-collection-rule-structure.md) to modify the JSON file for your particular environment and requirements.

[!INCLUDE [data-collection-rule-edit-warning](./includes/data-collection-rule-edit-warning.md)]

Once you have the definition of your DCR, you can deploy it to Azure Monitor using the Azure portal, CLI, PowerShell, API, or ARM templates. 

> [!TIP]
> To view the JSON definition of a DCR, see [View DCR definition](./data-collection-rule-view.md#view-dcr-definition).

### [CLI](#tab/cli)

### Create or edit DCR with CLI

Use the [az monitor data-collection rule create](/cli/azure/monitor/data-collection/rule) command to create a DCR from your JSON file. You can use this same command to update an existing DCR.

```azurecli
az monitor data-collection rule create --location 'eastus' --resource-group 'my-resource-group' --name 'my-dcr' --rule-file 'C:\MyNewDCR.json' --description 'This is my new DCR'
```

### [PowerShell](#tab/powershell)

### Create or edit DCR with PowerShell

Use the [New-AzDataCollectionRule](/powershell/module/az.monitor/new-azdatacollectionrule) cmdlet to create a DCR from your JSON file. You can use this same command to update an existing DCR.

```powershell
New-AzDataCollectionRule -Name 'my-dcr' -ResourceGroupName 'my-resource-group' -JsonFilePath 'C:\MyNewDCR.json'
```

### [API](#tab/api)

### Create or edit DCR with API

Use the [DCR create API](/rest/api/monitor/data-collection-rules/create) to create the DCR from your JSON file. You can use any method to call a REST API as shown in the following examples. You can use these same commands to update an existing DCR.

```powershell
$ResourceId = "/subscriptions/ffffffff-eeee-dddd-cccc-bbbbbbbbbbb0/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionRules/my-dcr"
$FilePath = ".\my-dcr.json"
$DCRContent = Get-Content $FilePath -Raw 
Invoke-AzRestMethod -Path ("$ResourceId"+"?api-version=2022-06-01") -Method PUT -Payload $DCRContent
```

```azurecli
ResourceId="/subscriptions/ffffffff-eeee-dddd-cccc-bbbbbbbbbbb0/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionRules/my-dcr"
FilePath="my-dcr.json"
az rest --method put --url $ResourceId"?api-version=2022-06-01" --body @$FilePath
```

### [ARM template](#tab/arm)

Use the following template to create a DCR, replacing `<dcr-properties>` with the properties for your DCR. You can use this template to create a new DCR or update an existing one.

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "dataCollectionRuleName": {
            "type": "string",
            "metadata": {
                "description": "Specifies the name of the Data Collection Rule to create."
            }
        },
        "location": {
            "type": "string",
            "metadata": {
                "description": "Specifies the location in which to create the Data Collection Rule."
            }
        }
    },
    "resources": [
        {
            "type": "Microsoft.Insights/dataCollectionRules",
            "name": "[parameters('dataCollectionRuleName')]",
            "location": "[parameters('location')]",
            "apiVersion": "2021-09-01-preview",
            "properties": {
                "<dcr-properties>"
            }
        }
    ]
}

```

---

> [!NOTE]
> While you may choose to use the PowerShell or CLI commands to create and edit a DCR, the API and ARM methods will provide more detailed error messages if there are compile errors.
> 
> In the following example, the DCR specifies a table name that doesn't exist in the destination Log Analytics workspace. The PowerShell command returns a generic error message, but the API call will return a detailed error message that specifies the exact error.
> 
> :::image type="content" source="media/data-collection-rule-create-edit/dcr-error-powershell.png" lightbox="media/data-collection-rule-create-edit/dcr-error-powershell.png" alt-text="Screenshot that shows an error message for a DCR when using a PowerShell command.":::
> 
> :::image type="content" source="media/data-collection-rule-create-edit/dcr-error-api.png" lightbox="media/data-collection-rule-create-edit/dcr-error-api.png" alt-text="Screenshot that shows an error message for a DCR when using the API.":::

## Strategies to edit and test a DCR

When you create or edit a DCR using its JSON definition, you'll often need to make multiple updates to achieve the functionality you want. You need an efficient method to update the DCR, troubleshoot it if you don't get the results you expect, and then make additional updates. This is especially true if you're adding a [transformation](data-collection-transformations.md) to the DCR since you'll need to validate that the query is working as expected. Since you can't edit the JSON directly in the Azure portal, following are some strategies that you can use.

### Use local file as source of DCR

If you use a local JSON file as the source of the DCRs that you create and edit, you're assured that you always have access to the latest version of the DCR definition. This is ideal if you want to use version control tools such as GitHub or Azure DevOps to manage your changes. You can also use an editor such as VS Code to make changes to the DCR and then use command line tools to update the DCR in Azure Monitor as described above.

Following is a sample PowerShell script you can use to push changes to a DCR from a source file. This validates that the source file is valid JSON before sending it to Azure Monitor.

```powershell
param (
    [Parameter(Mandatory = $true)][string]$ResourceId,  # Resource ID of the DCR
    [Parameter(Mandatory = $true)][string]$FilePath  # Path to the DCR JSON file to upload
)

# Read the DCR content from the file
Write-Host "Reading new DCR content from: $FilePath" -ForegroundColor Green
$DCRContent = Get-Content $FilePath -Raw

# Ensure the DCR content is valid JSON
try {
    $ParsedDCRContent = $DCRContent | ConvertFrom-Json
} catch {
    Write-Host "Invalid JSON content in file: $FilePath" -ForegroundColor Red
    exit 1
}

# Create or update the DCR in the specified resource group
Write-Host "Deploying DCR $ResourceId ..." -ForegroundColor Green
Invoke-AzRestMethod -Path ("$ResourceId"+"?api-version=2023-03-11") -Method PUT -Payload $DCRContent
```

### Save DCR content to temporary file

If you don't have the DCR definition in a local file, you can retrieve the definition from Azure Monitor and save it to a temporary file. You can then edit the file using an editor such as VS Code before pushing the updates to Azure Monitor.

Following is a sample PowerShell script you can use to edit an existing DCR in Azure Monitor. The script will retrieve the DCR definition and save it to a temporary file before launching VS Code. Once you indicate to the script that you've saved your changes, the DCR is updated with the new content and the temporary file is deleted.

```powershell
param ([Parameter(Mandatory=$true)] $ResourceId)

# Get DCR content and save it to a local file
$FilePath = "temp.dcr"
$DCR = Invoke-AzRestMethod -Path ("$ResourceId"+"?api-version=2023-03-11") -Method GET
$DCR.Content | ConvertFrom-Json | ConvertTo-Json -Depth 20 | Out-File $FilePath

# Open DCR in code editor
code $FilePath | Wait-Process

{ 
	#write DCR content back from the file
	$DCRContent = Get-Content $FilePath -Raw
	Invoke-AzRestMethod -Path ("$ResourceId"+"?api-version=2023-03-11") -Method PUT -Payload $DCRContent		
}

#Delete temporary file
Remove-Item $FilePath
```

### Use ARM template to edit a DCR in place

If you want to perform your edits completely in the Azure portal, you can use the [Export template](/azure/azure-resource-manager/templates/export-template-portal) feature to retrieve the ARM template for a DCR. You can then modify the definition in JSON and redeploy it in the Azure portal.

1. Select the DCR you want to modify in the Azure portal, and select **Export template**. Then click **Deploy** to redeploy the same template.

    :::image type="content" source="media/data-collection-rule-create-edit/export-template.png" lightbox="media/data-collection-rule-create-edit/export-template.png" alt-text="Screenshot that shows the Export template option for a data collection rule in the Azure portal.":::

1. Click **Edit template** to open up an editable version of the JSON for the DCR. Don't change the parameter values.

    :::image type="content" source="media/data-collection-rule-create-edit/edit-template-option.png" lightbox="media/data-collection-rule-create-edit/edit-template-option.png" alt-text="Screenshot that shows the Edit template option for a data collection rule in the Azure portal.":::

1. Make any required changes to the DCR and then click **Save**.

    :::image type="content" source="media/data-collection-rule-create-edit/edit-template.png" lightbox="media/data-collection-rule-create-edit/edit-template.png" alt-text="Screenshot that shows the editable JSON for a data collection rule in the Azure portal.":::

1. If you want to create a new DCR, then change the name parameter. Otherwise, leave the parameters unchanged. Click **Review + create** to deploy the modified template and **Create** to create the new DCR.
 
    :::image type="content" source="media/data-collection-rule-create-edit/review-create-option.png" lightbox="media/data-collection-rule-create-edit/review-create-option.png" alt-text="Screenshot that shows the review + create option for a data collection rule in the Azure portal.":::

1. If the DCR is valid with no errors, the deployment will succeed and the DCR will be updated with the new configuration. Click **Go to resource** to open the modified DCR.

    :::image type="content" source="media/data-collection-rule-create-edit/deployment-complete.png" lightbox="media/data-collection-rule-create-edit/deployment-complete.png" alt-text="Screenshot that shows a successful deployment for a data collection rule in the Azure portal.":::

1. If the DCR has compile errors, then you'll receive a message that your deployment failed. Click **Error details** and **Operation details** to view details of the error. Click **Redeploy** and then **Edit template** again to make the necessary changes to the DCR and then save and deploy it again.

    :::image type="content" source="media/data-collection-rule-create-edit/deployment-error.png" lightbox="media/data-collection-rule-create-edit/deployment-error.png" alt-text="Screenshot that shows a failed deployment for a data collection rule in the Azure portal.":::

[!INCLUDE [data-collection-rule-troubleshoot](includes/data-collection-rule-troubleshoot.md)]

## Next steps

* [Read about the detailed structure of a data collection rule](data-collection-rule-structure.md)
* [Get details on transformations in a data collection rule](data-collection-transformations.md)
