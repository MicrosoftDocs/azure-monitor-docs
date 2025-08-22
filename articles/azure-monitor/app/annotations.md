---
title: Release annotations for Application Insights
description: Configure automatic and script-driven release annotations, view annotations across Application Insights experiences, and transition from API keys.
ms.topic: how-to
ms.custom: devx-track-azurecli
ms.date: 08/21/2025
---

# Release annotations

Release annotations mark deployments and other significant events on Application Insights charts, allowing correlation of changes with performance, failures, and usage.

## Automatic annotations with Azure Pipelines

[Azure Pipelines](/azure/devops/pipelines) creates a release annotation during deployment when all the following conditions are true:

> [!div class="checklist"]
> - Link the target resource to Application Insights by using the `APPINSIGHTS_INSTRUMENTATIONKEY` app setting.
> - Keep the Application Insights resource in the same subscription as the target resource.
> - Use one of the following Azure DevOps tasks:

  | Task code                 | Task name                     | Versions     |
  |---------------------------|-------------------------------|--------------|
  | AzureAppServiceSettings   | Azure App Service Settings    | Any          |
  | AzureRmWebAppDeployment   | Azure App Service             | V3+          |
  | AzureFunctionApp          | Azure Functions               | Any          |
  | AzureFunctionAppContainer | Azure Functions for container | Any          |
  | AzureWebAppContainer      | Azure Web App for Containers  | Any          |
  | AzureWebApp               | Azure Web App                 | Any          |

> [!NOTE]
> If you still use the older Application Insights annotation deployment task, delete it.

## Configure annotations in a pipeline by using an inline script

If you don't use the tasks in the previous section, add an inline script in the deployment stage.

1. Open an existing pipeline or create a new one, and select a task under **Stages**.
1. Add a new **Azure CLI** task.
1. Select the Azure subscription. Set **Script Type** to **PowerShell**, and set **Script Location** to **Inline**.
1. Add the PowerShell script from step 2 in [Create release annotations with the Azure CLI](#create-release-annotations-with-the-azure-cli) to **Inline Script**.
1. Add script arguments. Replace placeholders in angle brackets.

   ```powershell
   -aiResourceId "<aiResourceId>" `
   -releaseName "<releaseName>" `
   -releaseProperties @{"ReleaseDescription"="<a description>";
        "TriggerBy"="<Your name>" }
   ```

   The following example shows metadata you can set in the optional `releaseProperties` argument by using build and release variables. Select **Save**.

   ```powershell
   -releaseProperties @{
    "BuildNumber"="$(Build.BuildNumber)";
    "BuildRepositoryName"="$(Build.Repository.Name)";
    "BuildRepositoryProvider"="$(Build.Repository.Provider)";
    "ReleaseDefinitionName"="$(Build.DefinitionName)";
    "ReleaseDescription"="Triggered by $(Build.DefinitionName) $(Build.BuildNumber)";
    "ReleaseEnvironmentName"="$(Release.EnvironmentName)";
    "ReleaseId"="$(Release.ReleaseId)";
    "ReleaseName"="$(Release.ReleaseName)";
    "ReleaseRequestedFor"="$(Release.RequestedFor)";
    "ReleaseWebUrl"="$(Release.ReleaseWebUrl)";
    "SourceBranch"="$(Build.SourceBranch)";
    "TeamFoundationCollectionUri"="$(System.TeamFoundationCollectionUri)" }
   ```

## Create release annotations with the Azure CLI

Use the following PowerShell script to create a release annotation from any process, without Azure DevOps.

1. Sign in to the [Azure CLI](/cli/azure/authenticate-azure-cli).
1. Save the following script as `CreateReleaseAnnotation.ps1`.

   ```powershell
   param(
       [parameter(Mandatory = $true)][string]$aiResourceId,
       [parameter(Mandatory = $true)][string]$releaseName,
       [parameter(Mandatory = $false)]$releaseProperties = @()
   )

   # Function to ensure all Unicode characters in a JSON string are properly escaped
   function Convert-UnicodeToEscapeHex {
     param (
       [parameter(Mandatory = $true)][string]$JsonString
     )
     $JsonObject = ConvertFrom-Json -InputObject $JsonString
     foreach ($property in $JsonObject.PSObject.Properties) {
       $name = $property.Name
       $value = $property.Value
       if ($value -is [string]) {
         $value = [regex]::Unescape($value)
         $OutputString = ""
         foreach ($char in $value.ToCharArray()) {
           $dec = [int]$char
           if ($dec -gt 127) {
             $hex = [convert]::ToString($dec, 16)
             $hex = $hex.PadLeft(4, '0')
             $OutputString += "\u$hex"
           }
           else {
             $OutputString += $char
           }
         }
         $JsonObject.$name = $OutputString
       }
     }
     return ConvertTo-Json -InputObject $JsonObject -Compress
   }
   
   $annotation = @{
       Id = [GUID]::NewGuid();
       AnnotationName = $releaseName;
       EventTime = (Get-Date).ToUniversalTime().GetDateTimeFormats("s")[0];
       Category = "Deployment"; #Application Insights only displays annotations from the "Deployment" Category
       Properties = ConvertTo-Json $releaseProperties -Compress
   }
   
   $annotation = ConvertTo-Json $annotation -Compress
   $annotation = Convert-UnicodeToEscapeHex -JsonString $annotation  
 
   $accessToken = (az account get-access-token | ConvertFrom-Json).accessToken
   $headers = @{
       "Authorization" = "Bearer $accessToken"
       "Accept"        = "application/json"
       "Content-Type"  = "application/json"
   }
   $params = @{
       Headers = $headers
       Method  = "Put"
       Uri     = "https://management.azure.com$($aiResourceId)/Annotations?api-version=2015-05-01"
       Body    = $annotation
   }
   Invoke-RestMethod @params
   ```

> [!NOTE]
> Set **Category** to **Deployment** or annotations don't appear in the Azure portal.

Call the script and pass values for the parameters. The `-releaseProperties` parameter is optional.

```powershell
.\CreateReleaseAnnotation.ps1 `
 -aiResourceId "<aiResourceId>" `
 -releaseName "<releaseName>" `
 -releaseProperties @{"ReleaseDescription"="<a description>";
     "TriggerBy"="<Your name>" }
```

| Argument            | Definition                                                   | Note |
|---------------------|--------------------------------------------------------------|------|
| `aiResourceId`      | Resource ID of the target Application Insights resource.     | Example: `/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/MyRGName/providers/microsoft.insights/components/MyResourceName` |
| `releaseName`       | Name of the new release annotation.                          |      |
| `releaseProperties` | Custom metadata to attach to the annotation.                 | Optional |

## View annotations

> [!NOTE]
> Release annotations aren't available in the **Metrics** pane.

Application Insights displays release annotations in the following experiences:

[Investigate failures, performance, and transactions with Application Insights](failures-performance-transactions.md&tabs=performance-view)

- [**Performance**](failures-performance-transactions.md&tabs=performance-view)
- [**Failures**](failures-performance-transactions.md&tabs=failures-view)
- [**Usage**](usage.md)
- [**Workbooks**](../visualize/best-practices-visualize.md) (for any time-series visualization)

The annotations markers at the top of charts provide more information.

:::image type="content" source="media/annotations/annotation-marker.png" alt-text="A screenshot of a blue arrow pointing upwards towards a solid blue line":::

To enable annotations in a workbook, open **Advanced Settings** and then select **Show annotations**. Select any annotation marker to open release details such as requestor, source control branch, release pipeline, and environment.
