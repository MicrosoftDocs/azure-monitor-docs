---
title: Tutorial - Editing Data Collection Rules
description: This article describes how to make changes in Data Collection Rule definition using command line tools and simple API calls.
ms.topic: tutorial
author: bwren
ms.author: bwren
ms.reviewer: ivankh
ms.date: 11/03/2023
---

# Edit a data collection rule (DCR)
There are multiple methods to create a DCR in Azure Monitor. You may need to make changes to the DCR after creation though, either to modify your data collection settings or to add configuration not available during the initial creation. This article describes different methods to edit an existing DCR.

- Modify data collection settings such as the DCE associated with the DCR. 
- Update data parsing or filtering logic for your data stream
- Change data destination such as changing the Log Analytics workspace or adding an Event Hub.
- Adding or testing a transformation to filter or customize the incoming data.



## Editing a DCR in the Azure portal

For those scenarios that allow you to create a DCR in the Azure portal, you can typically use the same method to modify settings that you made. For example, if you [create a DCR for Azure Monitor agent](../agents/azure-monitor-agent-data-collection.md), you can edit the DCR using the same dialog box to modify the settings available during creation.

There are some limitations to editing a DCR in the Azure portal. For example, you can't add a transformation to a DCR for most scenarios. You also can't maintain JSON in source control such as GitHub or Azure DevOps.

## View the DCR in the Azure portal
To edit the DCR directly, you need to understand its JSON structure. This is described in detail [Structure of a data collection rule in Azure Monitor](./data-collection-rule-structure.md). To view the JSON for the DCR, select **JSON view** in the Azure portal. You can't edit the JSON in this view, only view it.

> [!IMPORTANT]
> You may need to select the latest version of the API view all elements of the JSON. 

:::image type="content" source="media/data-collection-rule-edit/json-view.png" lightbox="media/data-collection-rule-edit/json-view.png" alt-text="Screenshot that shows the JSON view for a data collection rule in the Azure portal.":::

## Edit DCR using the command line
Using the command line, you save the JSON for the DCR to a file, edit the file, and then update the DCR with the new content. This allows you to use an editor such as VS Code to modify the JSON. You can also use the file as your source, using such version control tools as GitHub or Azure DevOps to manage the changes.

### [PowerShell](#tab/powershell)

**Retrieve the DCR and store in a local file**

```powershell
$ResourceId = "<ResourceId>" # Resource ID of the DCR to edit
$FilePath = "<FilePath>" # File to store DCR content
$DCR = Invoke-AzRestMethod -Path ("$ResourceId"+"?api-version=2023-03-11") -Method GET
$DCR.Content | ConvertFrom-Json | ConvertTo-Json -Depth 20 | Out-File -FilePath $FilePath
```

### [CLI](#tab/cli)

**Retrieve the DCR and store in a local file**

```azurecli
resourceId="<ResourceId>" # Resource ID of the DCR to edit
filePath="<FilePath>" # File to store DCR content
az rest --method get --uri "$resourceId?api-version=2023-03-11" > temp.json
cat temp.json | jq '.' > $filePath
```

---

## Edit a DCR

To edit a DCR, you can use any of the methods described in the previous section to create a DCR using a modified version of the JSON.

If you need to retrieve the JSON for an existing DCR, you can copy it from the **JSON View** for the DCR in the Azure portal. You can also retrieve it using an API call as shown in the following PowerShell example.

```powershell
$ResourceId = "<ResourceId>" # Resource ID of the DCR to edit
$FilePath = "<FilePath>" # Store DCR content in this file
$DCR = Invoke-AzRestMethod -Path ("$ResourceId"+"?api-version=2023-03-11") -Method GET
$DCR.Content | ConvertFrom-Json | ConvertTo-Json -Depth 20 | Out-File -FilePath $FilePath
```

For a tutorial that walks through the process of retrieving and then editing an existing DCR, see [Tutorial: Edit a data collection rule (DCR)](./data-collection-rule-edit.md).

See [Create data collection rules (DCRs) in Azure Monitor](data-collection-rule-create.md) for other methods.

Edit
Test
Troubleshoot


## Common edits

- Modify data collection settings such as the DCE associated with the DCR. 
- Update data parsing or filtering logic for your data stream
- Change data destination such as changing the Log Analytics workspace or adding an Event Hub.
- Adding or testing a transformation to filter or customize the incoming data.









## ARM
Using ARM templates, you can modify the JSON of any DCR in the Azure portal. You have Azure generate an ARM template for the DCR, modify the JSON, and then redeploy the template. This allows you to perform all the changes in the Azure portal without saving the JSON to a local file.

1. Select the DCR you want to modify in the Azure portal, and select **Export template**.
2. Click **Deploy** to redeploy the same template.
3. Click **Edit template** to open up an editable version of the JSON for the DCR.
4. Make any required changes to the DCR and then click **Save**.
6. If you want to save the DCR under a new name, change the DCR name parameter. Click **Review + create** to deploy the modified template and **Create** to create the new DCR.
7. If the DCR is valid with no errors, the deployment will succeed and the DCR will be updated with the new configuration. Click **Go to resource** to open the modified DCR.
8. If the DCR has compile errors, then you'll receive a message that your deployment failed. Click **Error details** and **Operation details** to view details of the error. 
   1. Click **Redeploy** and then **Edit template** to make the necessary changes to the DCR and then save and deploy it again.


## PowerShell
Editing the DCR with PowerShell or CLI allows you to use an editor to modify the JSON of the DCR. You may retrieve the DCR content and then save it to a file before working with it. Or you may use the file as your source, using such version control tools as GitHub or Azure DevOps to manage the changes.




is a two-step process. First, you retrieve the DCR content, save it to a file, and then edit the file. After editing, you update the DCR with the new content.






## Retrieve DCR content

In order to update DCR, we're going to retrieve its content and save it as a file, which can be further edited.

1. Click the **Cloud Shell** button in the Azure portal and ensure the environment is set to **PowerShell**.

    :::image type="content" source="../logs/media/tutorial-workspace-transformations-api/open-cloud-shell.png" lightbox="../logs/media/tutorial-workspace-transformations-api/open-cloud-shell.png" alt-text="Screenshot of opening cloud shell":::

1. Execute the following commands to retrieve DCR content and save it to a file. Replace `<ResourceId>` with DCR ResourceID and `<FilePath>` with the name of the file to store DCR.

    ```PowerShell
    $ResourceId = "<ResourceId>" # Resource ID of the DCR to edit
    $FilePath = "<FilePath>" # Store DCR content in this file
    $DCR = Invoke-AzRestMethod -Path ("$ResourceId"+"?api-version=2022-06-01") -Method GET
    $DCR.Content | ConvertFrom-Json | ConvertTo-Json -Depth 20 | Out-File -FilePath $FilePath
    ```

## Edit DCR

Now, when DCR content is stored as a JSON file, you can use an editor of your choice to make changes in the DCR. You may [prefer to download the file from the Cloud Shell environment](/azure/cloud-shell/using-the-shell-window#upload-and-download-files), if you're using one. 

Alternatively you can use code editors supplied with the environment. For example, if you saved your DCR in a file named `temp.dcr` on your Cloud Drive, you could use the following command to open DCR for editing right in the Cloud Shell window:

```PowerShell
code "temp.dcr"
```

Let’s modify the KQL transformation within DCR to drop rows where RequestType is anything, but `GET`.

1. Open the file created in the previous part for editing using an editor of your choice.

1. Locate the line containing `”transformKql”` attribute, which, if you followed the tutorial for custom log creation, should look similar to this:

    ```json
    "transformKql": "  source\n    | extend TimeGenerated = todatetime(Time)\n    | parse RawData with \n    ClientIP:string\n    ' ' *\n    ' ' *\n    ' [' * '] \"' RequestType:string\n    \" \" Resource:string\n    \" \" *\n    '\" ' ResponseCode:int\n    \" \" *\n    | where ResponseCode != 200\n    | project-away Time, RawData\n"
    ```
1. Modify KQL transformation to include additional filter by RequestType

    ```json
    "transformKql": "  source\n    | where RawData contains \"GET\"\n     | extend TimeGenerated = todatetime(Time)\n    | parse RawData with \n    ClientIP:string\n    ' ' *\n    ' ' *\n    ' [' * '] \"' RequestType:string\n    \" \" Resource:string\n    \" \" *\n    '\" ' ResponseCode:int\n    \" \" *\n    | where ResponseCode != 200\n    | project-away Time, RawData\n"
    ```

1. Save the file with modified DCR content.

## Apply changes

Our final step is to update DCR back in the system. This is accomplished by `PUT` HTTP call to ARM API, with updated DCR content sent in the HTTP request body.

1. If you're using Azure Cloud Shell, save the file and close the embedded editor, or [upload modified DCR file back to the Cloud Shell environment](/azure/cloud-shell/using-the-shell-window#upload-and-download-files).

1. Execute the following commands to load DCR content from the file and place HTTP call to update the DCR in the system. Replace `<ResourceId>` with DCR ResourceID and `<FilePath>` with the name of the file modified in the previous part of the tutorial. You can omit first two lines if you read and write to the DCR within the same PowerShell session.

    ```PowerShell
    $ResourceId = "<ResourceId>" # Resource ID of the DCR to edit
    $FilePath = "<FilePath>" # Store DCR content in this file
    $DCRContent = Get-Content $FilePath -Raw 
    Invoke-AzRestMethod -Path ("$ResourceId"+"?api-version=2022-06-01") -Method PUT -Payload $DCRContent 
    ```

1. Upon successful call, you should get the response with status code `200`, indicating that your DCR is now updated.

1. You can now navigate to your DCR and examine its content on the portal via **JSON View** function, or you could repeat the first part of the tutorial to retrieve DCR content into a file.

## Putting everything together

Now, when we know how to read and update the content of a DCR, let’s put everything together into utility script, which can be used to perform both operations together.

```PowerShell
param ([Parameter(Mandatory=$true)] $ResourceId)

# get DCR content and put into a file
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

### How to use this utility

Assuming you saved the script as a file, named `DCREditor.ps1` and need to modify a Data Collection Rule with resource ID of `/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/foo/providers/Microsoft.Insights/dataCollectionRules/bar`, this could be accomplished by running the following command:

```PowerShell
.\DCREditor.ps1 "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/foo/providers/Microsoft.Insights/dataCollectionRules/bar"
```

DCR content opens in embedded code editor. Once editing is complete, entering "Y" on script prompt applies changes back to the DCR.

## Next steps

* [Read more about data collection rules and options for creating them.](data-collection-rule-overview.md)
