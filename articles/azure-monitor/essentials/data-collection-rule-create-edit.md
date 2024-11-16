---
title: Create data collection rules (DCRs) in Azure Monitor
description: Details on creating data collection rules (DCRs) in Azure Monitor.
ms.topic: conceptual
author: bwren
ms.author: bwren
ms.date: 09/15/2024
ms.reviewer: nikeist
ms.custom: references_regions
---

# Create data collection rules (DCRs) and associations in Azure Monitor

There are multiple methods for creating a [data collection rule (DCR)](./data-collection-rule-overview.md) in Azure Monitor. In some cases, Azure Monitor can create and manage the DCR according to settings that you configure in the Azure portal. You may not even realize that you're working with a DCR in some of these cases. For other scenarios, you may need to create your own DCRs or edit existing ones using a text editor.

This article describes the different methods for creating a DCR. For the contents of the DCR itself, see [Structure of a data collection rule in Azure Monitor](./data-collection-rule-structure.md).

## Permissions

 You require the following permissions to create DCRs and associations:

| Built-in role | Scopes | Reason |
|:---|:---|:---|
| [Monitoring Contributor](/azure/role-based-access-control/built-in-roles#monitoring-contributor) | <ul><li>Subscription and/or</li><li>Resource group and/or </li><li>An existing DCR</li></ul> | Create or edit DCRs, assign rules to the machine, deploy associations. |
| [Virtual Machine Contributor](/azure/role-based-access-control/built-in-roles#virtual-machine-contributor)<br>[Azure Connected Machine Resource Administrator](/azure/role-based-access-control/built-in-roles#azure-connected-machine-resource-administrator)</li></ul> | <ul><li>Virtual machines, virtual machine scale sets</li><li>Azure Arc-enabled servers</li></ul> | Deploy agent extensions on the VM (virtual machine). |
| Any role that includes the action *Microsoft.Resources/deployments/** | <ul><li>Subscription and/or</li><li>Resource group and/or </li><li>An existing DCR</li></ul> | Deploy Azure Resource Manager templates. |

## Azure regions
Create your DCR in the same region as your destination Log Analytics workspace or Azure Monitor workspace. You can associate the DCR to machines or containers from any subscription or resource group in the tenant. To send data across tenants, you must first enable [Azure Lighthouse](/azure/lighthouse/overview).


## Create or edit a DCR using Azure portal

The Azure portal provides a simplified experience for creating a DCR for particular scenarios. Using this method, you don't need to understand the structure of a DCR unless you want to later modify it to implement an advanced feature such as a transformation. The experience will vary for each scenario, so refer to the documentation for the specific scenario you're working with as described in the following table:

| Scenario | Description |
|:---|:---|
| Enable VM insights | When you enable VM Insights on a VM, the Azure Monitor agent is installed and a DCR is created and associated with the VM. This DCR collects a predefined set of performance counters and shouldn't be modified.<br>See [Enable VM Insights overview](../vm/vminsights-enable-overview.md). |
| Collect client data from VM | Create a DCR in the Azure portal using a guided interface to select different data sources from VM clients. The Azure Monitor agent is automatically installed if necessary, and an association is created with each VM. See [Collect data with Azure Monitor Agent](../agents/azure-monitor-agent-data-collection.md) for details. |
| Metrics export | Create a DCR in the Azure portal using a guided interface to select metrics of different resource types to collect. An association is created with each resource you select. See [Create a data collection rule (DCR) for metrics export](./metrics-export-create.md). |
| Table creation | When you create a new table in a Log Analytics workspace using the Azure portal, you upload sample data that Azure Monitor uses to create a DCR, including a transformation, that can be used with the [Logs Ingestion API](../logs/logs-ingestion-api-overview.md). You can't modify this DCR in the Azure portal but can modify it using any other valid methods for working with DCRs. See [Create a custom table](../logs/create-custom-table.md?tabs=azure-portal-1%2Cazure-portal-2%2Cazure-portal-3#create-a-custom-table). |
| Kubernetes monitoring | To monitor a Kubernetes cluster, you enable Container Insights for logs and Prometheus for metrics. A DCR for each is created and associated with the containerized version of Azure Monitor agent in the cluster. You may need to modify the Container insights DCR to add a transformation. See [Enable monitoring for Kubernetes clusters](../containers/kubernetes-monitoring-enable.md) and [Data transformations in Container insights](../containers/container-insights-transformations.md). |

## Create or edit a DCR using JSON
To create a DCR using the Azure CLI, PowerShell, API, or ARM templates, you need to define the details of the DCR in JSON and then deploy this definition to Azure Monitor. You can start with one of the [sample DCRs](./data-collection-rule-samples.md) which provide the JSON for several common scenarios, or you may use a DCR that you created in the portal as a starting point. Use information in [Structure of a data collection rule in Azure Monitor](./data-collection-rule-structure.md) to modify the JSON file for your particular environment and requirements.

### [CLI](#tab/cli)

### Create with CLI
Use the [az monitor data-collection rule create](/cli/azure/monitor/data-collection/rule) command to create a DCR from your JSON file. You can use this same command to update an existing DCR.

```azurecli
az monitor data-collection rule create --location 'eastus' --resource-group 'my-resource-group' --name 'my-dcr' --rule-file 'C:\MyNewDCR.json' --description 'This is my new DCR'
```

Use the [az monitor data-collection rule association create](/cli/azure/monitor/data-collection/rule/association) command to create an association between your DCR and resource.

```azurecli
az monitor data-collection rule association create --name "my-vm-dcr-association" --rule-id "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionRules/my-dcr" --resource "subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Compute/virtualMachines/my-vm"
```

### [PowerShell](#tab/powershell)

### Create with PowerShell
Use the [New-AzDataCollectionRule](/powershell/module/az.monitor/new-azdatacollectionrule) cmdlet to create a DCR from your JSON file. You can use this same command to update an existing DCR.

```powershell
New-AzDataCollectionRule -Name 'my-dcr' -ResourceGroupName 'my-resource-group' -JsonFilePath 'C:\MyNewDCR.json'
```

Use the [New-AzDataCollectionRuleAssociation](/powershell/module/az.monitor/new-azdatacollectionruleassociation) command to create an association between your DCR and resource.

```powershell
 New-AzDataCollectionRuleAssociation -TargetResourceId '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Compute/virtualMachines/my-vm' -DataCollectionRuleId '/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/my-resource-group/providers/microsoft.insights/datacollectionrules/my-dcr' -AssociationName 'my-vm-dcr-association'
```

### [API](#tab/api)

### Create with API
Use the [DCR create API](/rest/api/monitor/data-collection-rules/create) to create the DCR from your JSON file. You can use any method to call a REST API as shown in the following examples. You can use these same commands to update an existing DCR.

```powershell
$ResourceId = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionRules/my-dcr"
$FilePath = ".\my-dcr.json"
$DCRContent = Get-Content $FilePath -Raw 
Invoke-AzRestMethod -Path ("$ResourceId"+"?api-version=2022-06-01") -Method PUT -Payload $DCRContent
```

```azurecli
ResourceId="/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionRules/my-dcr"
FilePath="my-dcr.json"
az rest --method put --url $ResourceId"?api-version=2022-06-01" --body @$FilePath
```

### [ARM template](#tab/arm)

Use the following template to create a DCR using information from [Structure of a data collection rule in Azure Monitor](./data-collection-rule-structure.md) and [Sample data collection rules (DCRs) in Azure Monitor](./data-collection-rule-samples.md) to define the `dcr-properties`. 

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

## Methods to edit an existing DCR

When you create or edit a DCR using its JSON, you'll often need to make multiple updates to achieve the functionality you want. You need an efficient method to update the DCR, troubleshoot it if you don't get the results you expect, and then make additional updates. Since you can't edit the JSON directly in the Azure portal, following are some strategies that you can use.

### Use local file as source of DCR
If you use a local file as the source of the DCRs that you create and edit, you're assured that you always have access to the latest version of the DCR definition. This is ideal if you want to use version control tools such as GitHub or Azure DevOps to manage the changes. You can also use an editor such as VS Code to make changes to the DCR and then use command line tools to update the DCR in Azure Monitor as described in [Create or edit a DCR using JSON](#create-or-edit-a-dcr-using-json). 


### Script to edit a DCR
Following is a sample PowerShell script you can use to edit a DCR in Azure Monitor. If you provide a path to a JSON file, then that file will be used to update or create the DCR. If you don't provide a path, then the script will open the DCR in VS Code for you to edit. The script will retrieve the DCR definition and save it to a file before launching VS Code. Once you edit the file using VS Code or the editor in Cloud Shell, you the DCR is updated with the new content.

1. Execute the following commands to retrieve DCR content and save it to a file. Replace `<ResourceId>` with DCR ResourceID and `<FilePath>` with the name of the file to store DCR.

```PowerShell
param ([Parameter(Mandatory=$true)] $ResourceId)

# Get DCR content and save it to a local file
$FilePath = "temp.dcr"
$DCR = Invoke-AzRestMethod -Path ("$ResourceId"+"?api-version=2022-06-01") -Method GET
$DCR.Content | ConvertFrom-Json | ConvertTo-Json -Depth 20 | Out-File $FilePath

# Open DCR in code editor
code $FilePath | Wait-Process

#Wait for confirmation to apply changes
$Output = Read-Host "Apply changes to DCR (Y/N)? "
if ("Y" -eq $Output.toupper())
{ 
	#write DCR content back from the file
	$DCRContent = Get-Content $FilePath -Raw
	Invoke-AzRestMethod -Path ("$ResourceId"+"?api-version=2023-03-11") -Method PUT -Payload $DCRContent		
}

#Delete temporary file
Remove-Item $FilePath
```

Save the script as a file, named `DCREditor.ps1` so you can edit a DCR by running the script with the DCR ResourceID as a parameter. For example:

```PowerShell
.\DCREditor.ps1 "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/foo/providers/Microsoft.Insights/dataCollectionRules/myDCR"
```
The editor is launched with the DCR. Once you save the DCR with your changes, enter "Y" on the script prompt to update the DCR in Azure Monitor.

### ARM template
You can use the [Export template](/azure/azure-resource-manager/templates/export-template-portal) feature in the Azure portal to retrieve the ARM template for a DCR. You can then modify the JSON of the DCR and redeploy it in the Azure portal. 

1. Select the DCR you want to modify in the Azure portal, and select **Export template**. Click **Deploy** to redeploy the same template.

    :::image type="content" source="media/data-collection-rule-edit/export-template.png" lightbox="media/data-collection-rule-edit/export-template.png" alt-text="Screenshot that shows the Export template option for a data collection rule in the Azure portal.":::

2. Click **Edit template** to open up an editable version of the JSON for the DCR. Don't change the parameter values since you can still modify them after you save your changes.

    :::image type="content" source="media/data-collection-rule-edit/edit-template-option.png" lightbox="media/data-collection-rule-edit/edit-template-option.png" alt-text="Screenshot that shows the Edit template option for a data collection rule in the Azure portal.":::

3. Make any required changes to the DCR and then click **Save**.

    :::image type="content" source="media/data-collection-rule-edit/edit-template.png" lightbox="media/data-collection-rule-edit/edit-template.png" alt-text="Screenshot that shows the editable JSON for a data collection rule in the Azure portal.":::

4. Change any parameters you want although you want to simply modify the existing DCR, leave the parameters unchanged. Click **Review + create** to deploy the modified template and **Create** to create the new DCR.
 
    :::image type="content" source="media/data-collection-rule-edit/review-create-option.png" lightbox="media/data-collection-rule-edit/review-create-option.png" alt-text="Screenshot that shows the review + create option for a data collection rule in the Azure portal.":::

5. If the DCR is valid with no errors, the deployment will succeed and the DCR will be updated with the new configuration. Click **Go to resource** to open the modified DCR.

    :::image type="content" source="media/data-collection-rule-edit/deployment-complete.png" lightbox="media/data-collection-rule-edit/deployment-complete.png" alt-text="Screenshot that shows a successful deployment for a data collection rule in the Azure portal.":::

6. If the DCR has compile errors, then you'll receive a message that your deployment failed. Click **Error details** and **Operation details** to view details of the error. Click **Redeploy** and then **Edit template** again to make the necessary changes to the DCR and then save and deploy it again.

    :::image type="content" source="media/data-collection-rule-edit/deployment-error.png" lightbox="media/data-collection-rule-edit/deployment-error.png" alt-text="Screenshot that shows a failed deployment for a data collection rule in the Azure portal.":::

## Troubleshooting

Once you install the DCR, it may take several minutes for the changes to take effect. If you don't get expected results, you can use the [DCR monitoring](data-collection-monitor.md) features to troubleshoot the issue. This includes metrics and logs that can help you identify the root cause of the issue.


## Retrieve the JSON for a DCR
To edit an existing DCR using using any of the methods in [Create or edit a DCR using JSON](#create-or-edit-a-dcr-using-json), you need to retrieve the JSON for the DCR unless you used it as your source.

You can view the JSON for the DCR in the Azure portal so you can copy and paste it into a file for editing and deployment with a command line tool.

1. In the Azure portal, navigate to the DCR that you want to edit and click **JSON view** in the **Overview** menu.

    :::image type="content" source="media/data-collection-rule-create-edit/json-view-option.png" lightbox="media/data-collection-rule-create-edit/json-view-option.png" alt-text="Screenshot that shows the option to view the JSON for a DCR in the Azure portal.":::

2. Verify that the latest version of the API is selected in the **API version** dropdown. If not, some of the JSON may not be displayed.

    :::image type="content" source="media/data-collection-rule-create-edit/json-view.png" lightbox="media/data-collection-rule-create-edit/json-view.png" alt-text="Screenshot that shows the JSON for a DCR in the Azure portal.":::

You can also retrieve the JSON for the DCR by calling the REST API. For example, the following PowerShell script retrieves the JSON for a DCR and saves it to a file.

```powershell
$ResourceId = "<ResourceId>" # Resource ID of the DCR to edit
$FilePath = "<FilePath>" # File to store DCR content
$DCR = Invoke-AzRestMethod -Path ("$ResourceId"+"?api-version=2023-03-11") -Method GET
$DCR.Content | ConvertFrom-Json | ConvertTo-Json -Depth 20 | Out-File -FilePath $FilePath
```

> [!NOTE]
> You can get the details for a DCR using `Get-AzDataCollectionRule` cmdlet in PowerShell or `az monitor data-collection rule show` command in Azure CLI, but they don't provide the JSON in the format that you require. Instead, use PowerShell or CLI to call the REST API as shown in the example.

## Verify data flows and troubleshooting

DCR metrics are collected automatically for all DCRs, and you can analyze them using metrics explorer like the platform metrics for other Azure resources. For more information, see [Monitor and troubleshoot DCR data collection in Azure Monitor](./data-collection-monitor.md#dcr-metrics)

Metrics sent to a Log Analytics workspace, are stored in the `AzureMetricsV2` table. Use the Log Analytics explorer to view the table and confirm that data is being ingested.
For more information, see [Overview of Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview).

## Troubleshooting common issues
If you're missing expected data in your Log Analytics workspace, follow these basic steps to troubleshoot the issue. This assumes that you enabled DCR logging as described above.

- Check metrics such as `Logs Ingestion Bytes per Min` and `Logs Rows Received per Min` to ensure that the data is reaching Azure Monitor. If not, then check your data source to ensure that it's sending data as expected.
- Check `Logs Rows Dropped per Min` to see if any rows are being dropped. This may not indicate an error since the rows could be dropped by a transformation. If the rows dropped is the same as `Logs Rows Dropped per Min` though, then no data will be ingested in the workspace. Examine the `Logs Transformation Errors per Min` to see if there are any transformation errors.
- Check `Logs Transformation Errors per Min` to determine if there are any errors from transformations applied to the incoming data. This could be due to changes in the data structure or the transformation itself.
- Check `DCRLogErrors` for any ingestion errors that may have been logged. This can provide additional detail in identifying the root cause of the issue.




## Next steps

* [Read about the detailed structure of a data collection rule](data-collection-rule-structure.md)
* [Get details on transformations in a data collection rule](data-collection-transformations.md)
