---
title: 'Tutorial: Send data to Azure Monitor Logs with Logs ingestion API (Azure portal)'
description: Tutorial on how sending data to a Log Analytics workspace in Azure Monitor using the Logs ingestion API. Supporting components configured using the Azure portal.
ms.topic: tutorial
ms.date: 05/08/2026
ms.reviewer: ivkhrul
ai-usage: ai-assisted
---

# Tutorial: Send data to Azure Monitor Logs with Logs ingestion API (Azure portal)

The [Logs Ingestion API](logs-ingestion-api-overview.md) in Azure Monitor lets you send external data to a Log Analytics workspace with a REST API call. This tutorial walks through configuring a new custom table, a [data collection rule (DCR)](../data-collection/data-collection-rule-overview.md), a [data collection endpoint (DCE)](../data-collection/data-collection-endpoint-overview.md), and a sample application that sends log data by using the Azure portal.

A DCR defines the data format, the transformation to apply, and the destination table. A DCE provides the endpoint URL that your application sends data to. The DCR has an **immutableId** property, which is a unique identifier you use in the API call.

> [!NOTE]
> This tutorial uses the Azure portal to configure the components to support the Logs ingestion API. See [Tutorial: Send data to Azure Monitor using Logs ingestion API (Resource Manager templates)](tutorial-logs-ingestion-api.md) for a similar tutorial that uses Azure Resource Manager templates to configure these components and that has sample code for client libraries for [.NET](/dotnet/api/overview/azure/Monitor.Ingestion-readme), [Go](https://pkg.go.dev/github.com/Azure/azure-sdk-for-go/sdk/monitor/ingestion/azlogs), [Java](/java/api/overview/azure/monitor-ingestion-readme), [JavaScript](/javascript/api/overview/azure/monitor-ingestion-readme), and [Python](/python/api/overview/azure/monitor-ingestion-readme).

The steps required to configure the Logs ingestion API are as follows:

1. [Create a Microsoft Entra application](#create-azure-ad-application) to authenticate against the API.
1. [Create a data collection endpoint (DCE)](#create-data-collection-endpoint) to receive data.
1. [Create a custom table in a Log Analytics workspace](#create-new-table-in-log-analytics-workspace). As part of this process, you create a data collection rule (DCR) to direct the data to the target table.
1. [Give the Microsoft Entra application access to the DCR](#assign-permissions-to-the-dcr).
1. [Use sample code to send data by using the Logs ingestion API](#send-sample-data).

## Prerequisites

To complete this tutorial, you need:

* A Log Analytics workspace where you have at least [contributor rights](manage-access.md#azure-rbac).
* [Permissions to create DCR objects](../data-collection/data-collection-rule-create-edit.md#permissions) in the workspace.
* PowerShell 7.2 or later.

## Overview

In this tutorial, you use a PowerShell script to send sample Apache access logs over HTTP to the Logs Ingestion API endpoint. The script converts plain text log data to JSON format, which is the required format for the API. A transformation defined in the DCR parses each log entry, extracts specific fields (such as client IP, request type, and response code), and filters out records that don't need to be ingested.

After the configuration is finished, you send sample data from the command line and inspect the results in Log Analytics.

<a name='create-azure-ad-application'></a>

## Create Microsoft Entra application

Start by registering a Microsoft Entra application to authenticate against the API. Any Resource Manager authentication scheme is supported, but this tutorial follows the [Client Credential Grant Flow scheme](/entra/identity-platform/v2-oauth2-client-creds-grant-flow).

1. On the **Microsoft Entra ID** menu in the Azure portal, select **App registrations** > **New registration**.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/new-app-registration.png" lightbox="media/tutorial-logs-ingestion-portal/new-app-registration.png" alt-text="Screenshot that shows the app registration screen.":::

1. Give the application a name and change the tenancy scope if the default isn't appropriate for your environment. A **Redirect URI** isn't required.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/new-app-name.png" lightbox="media/tutorial-logs-ingestion-portal/new-app-name.png" alt-text="Screenshot that shows app details.":::

1. After registration, you can view the details of the application. Note the **Application (client) ID** and the **Directory (tenant) ID**. You use these values when you configure the PowerShell script in the [Generate sample data](#generate-sample-data) step.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/new-app-id.png" lightbox="media/tutorial-logs-ingestion-portal/new-app-id.png" alt-text="Screenshot that shows the app ID.":::

1. You now need to generate an application client secret, which is similar to creating a password to use with a username. Select **Certificates & secrets** > **New client secret**. Give the secret a name to identify its purpose and select an **Expires** duration. The value **1 year** is selected here. For a production implementation, you would follow best practices for a secret rotation procedure or use a more secure authentication mode, such as a certificate.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/new-app-secret.png" lightbox="media/tutorial-logs-ingestion-portal/new-app-secret.png" alt-text="Screenshot that shows a secret for a new app.":::

1. Select **Add** to save the secret and then note the **Value**. Ensure that you record this value because you can't recover it after you move away from this page. Use the same security measures as you would for safekeeping a password because it's the functional equivalent.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/new-app-secret-value.png" lightbox="media/tutorial-logs-ingestion-portal/new-app-secret-value.png" alt-text="Screenshot that shows the secret value for the new app.":::

## Create data collection endpoint

This tutorial requires a data collection endpoint (DCE) because the Azure portal custom log creation wizard requires one. If you use [other methods to create the custom table and DCR](./tutorial-logs-ingestion-api.md), you can use the [DCR endpoint](../data-collection/data-collection-endpoint-overview.md) instead.

The DCE must be in the same region as the Log Analytics workspace or the data collection rule. After you configure and link the DCE to a DCR, your application can send data over HTTP to the DCE's logs ingestion URI.

1. To create a new DCE, go to the **Monitor** menu in the Azure portal. Select **Data Collection Endpoints** and then select **Create**.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/new-data-collection-endpoint.png" lightbox="media/tutorial-logs-ingestion-portal/new-data-collection-endpoint.png" alt-text="Screenshot that shows new DCE.":::

1. Provide a name for the DCE and ensure that it's in the same region as your workspace. Select **Create** to create the DCE.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/data-collection-endpoint-details.png" lightbox="media/tutorial-logs-ingestion-portal/data-collection-endpoint-details.png" alt-text="Screenshot that shows DCE details.":::

1. After the DCE is created, select it so that you can view its properties. Note the **Logs ingestion** URI. You use this URI as the `$DceURI` parameter when you run the PowerShell script.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/data-collection-endpoint-uri.png" lightbox="media/tutorial-logs-ingestion-portal/data-collection-endpoint-uri.png" alt-text="Screenshot that shows DCE URI.":::

## Create new table in Log Analytics workspace

Before you can send data to the workspace, you need to create the custom table where the data will be sent.

> [!NOTE]
> The table creation for a log ingestion API custom log below can't be used to create a [agent custom log table](../agents/data-collection-text-log.md). You must use the CLI or custom template process to create the table. If you do not have sufficient rights to run CLI or custom template you must ask your administrator to add the table for you.

1. Go to the **Log Analytics workspaces** menu in the Azure portal and select **Tables**. The tables in the workspace will appear. Select **Create** > **New custom log (DCR based)**.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/new-custom-log.png" lightbox="media/tutorial-logs-ingestion-portal/new-custom-log.png" alt-text="Screenshot that shows the new DCR-based custom log.":::

1. Specify a name for the table. You don't need to add the *_CL* suffix required for a custom table because it will be automatically added to the name you specify.

1. Select **Create a new data collection rule** to create the DCR that will be used to send data to this table. If you have an existing DCR, you can choose to use it instead. Specify the **Subscription**, **Resource group**, and **Name** for the DCR that will contain the custom log configuration.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/new-data-collection-rule.png" lightbox="media/tutorial-logs-ingestion-portal/new-data-collection-rule.png" alt-text="Screenshot that shows the new DCR.":::

1. Select a DCE that you already created from the pull-down menu and select **Next**.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/custom-log-table-name.png" lightbox="media/tutorial-logs-ingestion-portal/custom-log-table-name.png" alt-text="Screenshot that shows the custom log table name.":::

## Parse and filter sample data

Instead of directly configuring the schema of the table, you can upload a file with a sample JSON array of data through the portal, and Azure Monitor will set the schema automatically. The sample JSON file must contain one or more log records structured as an array, in the same way the data is sent in the body of an HTTP request of the logs ingestion API call.

1. Generate the *data_sample.json* file before you continue. Go to [Generate sample data](#generate-sample-data), run the PowerShell script with the `-Type "file"` option, then return to this step.

1. Select **Browse for files** and locate the *data_sample.json* file that you previously created.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/custom-log-browse-files.png" lightbox="media/tutorial-logs-ingestion-portal/custom-log-browse-files.png" alt-text="Screenshot that shows custom log browse for files.":::

1. Data from the sample file is displayed with a warning that `TimeGenerated` isn't in the data. All log tables within Azure Monitor Logs are required to have a `TimeGenerated` column populated with the timestamp of the logged event. In this sample, the timestamp of the event is stored in the field called `Time`. You'll add a transformation that will rename this column in the output.

1. Select **Transformation editor** to open the transformation editor to add this column. You'll add a transformation that will rename this column in the output. The transformation editor lets you create a transformation for the incoming data stream. This is a KQL query that's run against each incoming record. The results of the query will be stored in the destination table. For more information on transformation queries, see [Data collection rule transformations in Azure Monitor](../data-collection/data-collection-transformations.md).

    :::image type="content" source="media/tutorial-logs-ingestion-portal/custom-log-data-preview.png" lightbox="media/tutorial-logs-ingestion-portal/custom-log-data-preview.png" alt-text="Screenshot that shows the custom log data preview.":::

1. Add the following query to the transformation editor to add the `TimeGenerated` column to the output:

    ```kusto
    source
    | extend TimeGenerated = todatetime(Time)
    ```

1. Select **Run** to view the results. You can see that the `TimeGenerated` column is now added to the other columns. Most of the interesting data is contained in the `RawData` column, though.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/custom-log-query-01.png" lightbox="media/tutorial-logs-ingestion-portal/custom-log-query-01.png" alt-text="Screenshot that shows the initial custom log data query.":::

1. Modify the query to the following example, which extracts the client IP address, the HTTP method, the address of the page being accessed, and the response code from each log entry.

    ```kusto
    source
    | extend TimeGenerated = todatetime(Time)
    | parse RawData with 
    ClientIP:string
    ' ' *
    ' ' *
    ' [' * '] "' RequestType:string
    ' ' Resource:string
    ' ' *
    '" ' ResponseCode:int
    ' ' *
    ```

1. Select **Run** to view the results. This action extracts the contents of `RawData` into the separate columns `ClientIP`, `RequestType`, `Resource`, and `ResponseCode`.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/custom-log-query-02.png" lightbox="media/tutorial-logs-ingestion-portal/custom-log-query-02.png" alt-text="Screenshot that shows the custom log data query with parse command.":::

1. The query can be optimized more though by removing the `RawData` and `Time` columns because they aren't needed anymore. You can also filter out any records with `ResponseCode` of 200 because you're only interested in collecting data for requests that weren't successful. This step reduces the volume of data being ingested, which reduces its overall cost.

    ```kusto
    source
    | extend TimeGenerated = todatetime(Time)
    | parse RawData with 
    ClientIP:string
    ' ' *
    ' ' *
    ' [' * '] "' RequestType:string
    ' ' Resource:string
    ' ' *
    '" ' ResponseCode:int
    ' ' *
    | project-away Time, RawData
    | where ResponseCode != 200
    ```

1. Select **Run** to view the results.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/custom-log-query-03.png" lightbox="media/tutorial-logs-ingestion-portal/custom-log-query-03.png" alt-text="Screenshot that shows a custom log data query with a filter.":::

1. Select **Apply** to save the transformation and view the schema of the table that's about to be created. Select **Next** to proceed.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/custom-log-final-schema.png" lightbox="media/tutorial-logs-ingestion-portal/custom-log-final-schema.png" alt-text="Screenshot that shows a custom log final schema.":::

1. Verify the final details and select **Create** to save the custom log.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/custom-log-create.png" lightbox="media/tutorial-logs-ingestion-portal/custom-log-create.png" alt-text="Screenshot that shows custom log create.":::

## Collect information from the DCR

The Logs Ingestion API call requires the DCR's immutable ID (a value starting with `dcr-` followed by a GUID) to identify the data collection rule. Collect this value from the DCR's JSON view.

1. On the **Monitor** menu in the Azure portal, select **Data collection rules** and select the DCR you created. From **Overview** for the DCR, select **JSON View**.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/data-collection-rule-json-view.png" lightbox="media/tutorial-logs-ingestion-portal/data-collection-rule-json-view.png" alt-text="Screenshot that shows the DCR JSON view.":::

1. Copy the **immutableId** value.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/data-collection-rule-immutable-id.png" lightbox="media/tutorial-logs-ingestion-portal/data-collection-rule-immutable-id.png" alt-text="Screenshot that shows collecting the immutable ID from the JSON view.":::

## Assign permissions to the DCR

Assign the **Monitoring Metrics Publisher** role to your Microsoft Entra application on the DCR. This role grants the `Microsoft.Insights/Telemetry/Write` permission that the Logs Ingestion API requires.

1. Select **Access Control (IAM)** for the DCR and then select **Add role assignment**.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/add-role-assignment.png" lightbox="media/tutorial-logs-ingestion-portal/custom-log-create.png" alt-text="Screenshot that shows adding the custom role assignment to the DCR.":::

1. Select **Monitoring Metrics Publisher** > **Next**. You could instead create a custom action with the `Microsoft.Insights/Telemetry/Write` data action.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/add-role-assignment-select-role.png" lightbox="media/tutorial-logs-ingestion-portal/add-role-assignment-select-role.png" alt-text="Screenshot that shows selecting the role for the DCR role assignment.":::

1. Select **User, group, or service principal** for **Assign access to** and choose **Select members**. Select the application that you created and then choose **Select**.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/add-role-assignment-select-member.png" lightbox="media/tutorial-logs-ingestion-portal/add-role-assignment-select-member.png" alt-text="Screenshot that shows selecting members for the DCR role assignment.":::

1. Select **Review + assign** and verify the details before you save your role assignment.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/add-role-assignment-save.png" lightbox="media/tutorial-logs-ingestion-portal/add-role-assignment-save.png" alt-text="Screenshot that shows saving the DCR role assignment.":::

## Generate sample data

The following PowerShell script generates sample data to configure the custom table and sends sample data to the logs ingestion API to test the configuration.

> [!NOTE]
> This sample script requires PowerShell v7.2 or later.

1. Run the following PowerShell command, which adds a required assembly for the script:

    ```powershell
    Add-Type -AssemblyName System.Web
    ```

1. Update the values of `$tenantId`, `$appId`, and `$appSecret` with the values you noted for **Directory (tenant) ID**, **Application (client) ID**, and secret **Value**. Then save it with the file name *LogGenerator.ps1*.

    ``` PowerShell
    param ([Parameter(Mandatory=$true)] $Log, $Type="file", $Output, $DcrImmutableId, $DceURI, $Table)
    ################
    ##### Usage
    ################
    # LogGenerator.ps1
    #   -Log <String>              - Log file to be forwarded
    #   [-Type "file|API"]         - Whether the script should generate sample JSON file or send data via
    #                                API call. Data will be written to a file by default.
    #   [-Output <String>]         - Path to resulting JSON sample
    #   [-DcrImmutableId <string>] - DCR immutable ID
    #   [-DceURI]                  - Data collection endpoint URI
    #   [-Table]                   - The name of the custom log table, including "_CL" suffix


    ##### >>>> PUT YOUR VALUES HERE <<<<<
    # Information needed to authenticate to Microsoft Entra ID and obtain a bearer token
    $tenantId = "<put tenant ID here>"; #the tenant ID from the Microsoft Entra app registration
    $appId = "<put application ID here>"; #the Application (client) ID from the Microsoft Entra app registration
    $appSecret = "<put secret value here>"; #the client secret value - never store secrets in source code
    ##### >>>> END <<<<<


    $file_data = Get-Content $Log
    if ("file" -eq $Type) {
        ############
        ## Convert plain log to JSON format and output to .json file
        ############
        # If not provided, get output file name
        if ($null -eq $Output) {
            $Output = Read-Host "Enter output file name" 
        };

        # Form file payload
        $payload = @();
        $records_to_generate = [math]::min($file_data.count, 500)
        for ($i=0; $i -lt $records_to_generate; $i++) {
            $log_entry = @{
                # Define the structure of log entry, as it will be sent
                Time = Get-Date ([datetime]::UtcNow) -Format O
                Application = "LogGenerator"
                RawData = $file_data[$i]
            }
            $payload += $log_entry
        }
        # Write resulting payload to file
        New-Item -Path $Output -ItemType "file" -Value ($payload | ConvertTo-Json -AsArray) -Force

    } else {
        ############
        ## Send the content to the data collection endpoint
        ############
        if ($null -eq $DcrImmutableId) {
            $DcrImmutableId = Read-Host "Enter DCR Immutable ID" 
        };

        if ($null -eq $DceURI) {
            $DceURI = Read-Host "Enter data collection endpoint URI" 
        }

        if ($null -eq $Table) {
            $Table = Read-Host "Enter the name of custom log table" 
        }

        ## Obtain a bearer token used to authenticate against the data collection endpoint
        $scope = [System.Web.HttpUtility]::UrlEncode("https://monitor.azure.com//.default")   
        $body = "client_id=$appId&scope=$scope&client_secret=$appSecret&grant_type=client_credentials";
        $headers = @{"Content-Type" = "application/x-www-form-urlencoded" };
        $uri = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"
        $bearerToken = (Invoke-RestMethod -Uri $uri -Method "Post" -Body $body -Headers $headers).access_token

        ## Generate and send some data
        foreach ($line in $file_data) {
            # We are going to send log entries one by one with a small delay
            $log_entry = @{
                # Define the structure of log entry, as it will be sent
                Time = Get-Date ([datetime]::UtcNow) -Format O
                Application = "LogGenerator"
                RawData = $line
            }
            # Sending the data to Log Analytics via the DCR!
            $body = $log_entry | ConvertTo-Json -AsArray;
            $headers = @{"Authorization" = "Bearer $bearerToken"; "Content-Type" = "application/json" };
            $uri = "$DceURI/dataCollectionRules/$DcrImmutableId/streams/Custom-$Table"+"?api-version=2023-01-01";
            $uploadResponse = Invoke-RestMethod -Uri $uri -Method "Post" -Body $body -Headers $headers;

            # Let's see how the response looks
            Write-Output $uploadResponse
            Write-Output "---------------------"

            # Pausing for 1 second before processing the next entry
            Start-Sleep -Seconds 1
        }
    }
    ```

1. Download the [sample_access.log](https://github.com/microsoft/AzureMonitorCommunity/tree/master/Scenarios/How%20to%20collect%20data%20with%20the%20Logs%20Ingestion%20API) file from the Azure Monitor Community repository, or use your own Apache log data. Save it as `sample_access.log`.

1. To read the data in the file and create a JSON file called `data_sample.json` that you can send to the logs ingestion API, run:

    ```PowerShell
    .\LogGenerator.ps1 -Log "sample_access.log" -Type "file" -Output "data_sample.json"
    ```

## Send sample data

Allow at least 30 minutes for the configuration to take effect. You might also experience increased latency for the first few entries, but this activity should normalize.

1. Run the following command providing the values that you collected for your DCR and DCE. The script will start ingesting data by placing calls to the API at the pace of approximately one record per second.

    ```PowerShell
    .\LogGenerator.ps1 -Log "sample_access.log" -Type "API" -Table "ApacheAccess_CL" -DcrImmutableId <immutable ID> -DceUri <data collection endpoint URL> 
    ```

1. From Log Analytics, query your newly created table to verify that data arrived and that it's transformed properly.

## Troubleshooting

If your data doesn't appear in the custom log table, check these common issues:

| Symptom | Cause | Resolution |
|---------|-------|------------|
| HTTP 403 Forbidden when sending data | The Microsoft Entra application doesn't have the **Monitoring Metrics Publisher** role on the DCR. | Open the DCR in the Azure portal, go to **Access Control (IAM)**, and verify the role assignment. Allow up to 30 minutes for role changes to take effect. |
| HTTP 404 Not Found on the ingestion endpoint | The DCR immutable ID or table name in the API URI is incorrect. | Verify that `$DcrImmutableId` matches the value from the DCR's JSON view and that `$Table` includes the `_CL` suffix. The stream name in the URI must be `Custom-<TableName_CL>`. |
| Data arrives but columns are empty or missing | The transformation KQL query doesn't match the incoming data schema. | Open the DCR in the portal, go to the transformation editor, and verify that the `parse` operator pattern matches the format of your log entries. |

For more troubleshooting guidance, see the [Troubleshooting](tutorial-logs-ingestion-code.md#troubleshooting) section of the sample code article.

## Sample data

Download the synthetic `sample_access.log` file from the [Azure Monitor Community repository](https://github.com/microsoft/AzureMonitorCommunity/tree/master/Scenarios/How%20to%20collect%20data%20with%20the%20Logs%20Ingestion%20API). The file contains ~200 entries in Apache Combined Log Format with a mix of response codes (200, 301, 404, 500, and others). All IP addresses and domain names are synthetic — no real-world data is included.

The following snippet shows the format of the sample data:

```
198.51.100.138 - - [15/Mar/2024:08:02:46 +0000] "POST /js/app.js HTTP/1.1" 200 39128 "-" "Python-urllib/3.12" "-"
203.0.113.61 - - [15/Mar/2024:08:03:33 +0000] "GET /images/hero-bg.webp HTTP/2.0" 200 57251 "https://www.contoso-web.example.com/products" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
198.51.100.2 - - [15/Mar/2024:08:04:33 +0000] "GET /support/tickets HTTP/2.0" 304 0 "-" "axios/1.6.7" "-"
10.0.176.220 - - [15/Mar/2024:08:09:53 +0000] "POST /support/kb/2045 HTTP/2.0" 400 582 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:124.0) Gecko/20100101 Firefox/124.0" "-"
203.0.113.164 - - [15/Mar/2024:08:10:27 +0000] "GET /about.html HTTP/2.0" 200 26623 "https://search.contoso.example.com/results?q=monitor+logs" "Mozilla/5.0 (iPad; CPU OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Mobile/15E148 Safari/604.1" "-"
```

You can also generate your own sample data with a configurable number of entries using the [Generate-SampleAccessLog.ps1](https://github.com/microsoft/AzureMonitorCommunity/tree/master/Scenarios/How%20to%20collect%20data%20with%20the%20Logs%20Ingestion%20API) script from the same repository.

## Next steps

* [Complete a similar tutorial by using ARM templates](tutorial-logs-ingestion-api.md)
* [Read more about custom logs](logs-ingestion-api-overview.md)
* [Learn more about writing transformation queries](../data-collection/data-collection-transformations.md)
