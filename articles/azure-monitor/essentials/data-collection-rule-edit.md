---
title: Troubleshoot a data collection rule (DCR) in Azure Monitor
description: This article describes how to test and troubleshoot a data collection rule (DCR) in Azure Monitor.
ms.topic: tutorial
author: bwren
ms.author: bwren
ms.reviewer: ivankh
ms.date: 11/13/2024
---

# Edit a data collection rule (DCR) in Azure Monitor



## Editing a DCR in the Azure portal

For those scenarios that allow you to create a DCR in the Azure portal, you can typically use the same method to modify settings that you made. For example, if you [create a DCR for Azure Monitor agent](../agents/azure-monitor-agent-data-collection.md), you can edit the DCR using the same dialog box to modify the settings available during creation.

There are some limitations to editing a DCR in the Azure portal. For example, you can't add a transformation to a DCR for most scenarios. You also can't maintain JSON in source control such as GitHub or Azure DevOps.

## Common edits

- Modify data collection settings such as the DCE associated with the DCR. 
- Update data parsing or filtering logic for your data stream
- Change data destination such as changing the Log Analytics workspace or adding an Event Hub.
- Adding or testing a transformation to filter or customize the incoming data.

When you're editing a DCR, you might need to make multiple changes and test each one to arrive at your desired configuration. This is most commonly when you're adding or modifying a transformation in a DCR where you need to test the transformation to ensure it's working as expected. Not only do you need a method to make multiple updates to the DCR in an efficient manner, but you also need a method to troubleshoot issues if you're not receiving the results you're expecting.


## Use local file as source of DCR
If you use a local file as the source of the DCR, you can use version control tools such as GitHub or Azure DevOps to manage the changes. You can also use an editor such as VS Code to make changes to the DCR and then use command line tools to update the DCR in Azure Monitor. This is also a good method to manage updates against duplicate DCRs in different regions.


## View the DCR in the Azure portal
To edit the DCR directly, you need to understand its JSON structure. This is described in detail [Structure of a data collection rule in Azure Monitor](./data-collection-rule-structure.md). A good method to familiarize yourself with the JSON structure is to create a DCR using the Azure portal and then viewing the resulting JSON.

To view the JSON for the DCR, select **JSON view** in the Azure portal. You can't edit the JSON in this view, only view it. But you can copy and paste it into a text editor such as VS Code.

> [!IMPORTANT]
> You may need to select the latest version of the API view all elements of the JSON. 

:::image type="content" source="media/data-collection-rule-edit/json-view.png" lightbox="media/data-collection-rule-edit/json-view.png" alt-text="Screenshot that shows the JSON view for a data collection rule in the Azure portal.":::

## Retrieve DCR content
To retrieve the content of a DCR from a command line such as PowerShell or CLI, you should call the REST API for the DCR rather than using `Get-AzDataCollectionRule` or `az monitor datacollection rule show`. This is because the REST API returns the JSON in the format you need to edit and update the DCR, while you must perform significant formatting with the information returned by the other commands.

```PowerShell
$ResourceId = "<ResourceId>" # Resource ID of the DCR to edit
$FilePath = "<FilePath>" # Store DCR content in this file
$DCR = Invoke-AzRestMethod -Path ("$ResourceId"+"?api-version=2022-06-01") -Method GET
$DCR.Content | ConvertFrom-Json | ConvertTo-Json -Depth 20 | Out-File -FilePath $FilePath
```




See [Create data collection rules (DCRs) in Azure Monitor](data-collection-rule-create-edit.md) for other methods.


## Script
Following is a sample script you can use to edit a DCR in Azure Monitor. This is a two-step process. First, you retrieve the DCR content, save it to a file, and then edit the file using VS Code or the editor in Cloud Shell. After editing, you the DCR is updated with the new content.

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
	Invoke-AzRestMethod -Path ("$ResourceId"+"?api-version=2022-06-01") -Method PUT -Payload $DCRContent		
}

#Delete temporary file
Remove-Item $FilePath
```

Save the script as a file, named `DCREditor.ps1` so you can edit a DCR by running the script with the DCR ResourceID as a parameter. For example:

```PowerShell
.\DCREditor.ps1 "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/foo/providers/Microsoft.Insights/dataCollectionRules/myDCR"
```
The editor is launched with the DCR. Once you save the DCR with your changes, enter "Y" on the script prompt to update the DCR in Azure Monitor.

## ARM template
If you want to edit the DCR in the Azure portal, you can generate an ARM template for the DCR and then do your editing and deployment completely in the Azure console.

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

## Troubleshooting common issues
If you're missing expected data in your Log Analytics workspace, follow these basic steps to troubleshoot the issue. This assumes that you enabled DCR logging as described above.

- Check metrics such as `Logs Ingestion Bytes per Min` and `Logs Rows Received per Min` to ensure that the data is reaching Azure Monitor. If not, then check your data source to ensure that it's sending data as expected.
- Check `Logs Rows Dropped per Min` to see if any rows are being dropped. This may not indicate an error since the rows could be dropped by a transformation. If the rows dropped is the same as `Logs Rows Dropped per Min` though, then no data will be ingested in the workspace. Examine the `Logs Transformation Errors per Min` to see if there are any transformation errors.
- Check `Logs Transformation Errors per Min` to determine if there are any errors from transformations applied to the incoming data. This could be due to changes in the data structure or the transformation itself.
- Check `DCRLogErrors` for any ingestion errors that may have been logged. This can provide additional detail in identifying the root cause of the issue.


## Next steps

* [Read more about data collection rules and options for creating them.](data-collection-rule-overview.md)
