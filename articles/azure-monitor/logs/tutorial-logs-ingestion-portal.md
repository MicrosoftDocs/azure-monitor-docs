---
title: 'Tutorial: Send data to Azure Monitor Logs with Logs ingestion API (Azure portal)'
description: Tutorial on how sending data to a Log Analytics workspace in Azure Monitor using the Logs ingestion API. Supporting components configured using the Azure portal.
ms.topic: tutorial
ms.date: 05/08/2026
ms.reviewer: ivkhrul
ai-usage: ai-assisted
---

# Tutorial: Send data to Azure Monitor Logs by using the Logs ingestion API (Azure portal)

The [Logs Ingestion API](logs-ingestion-api-overview.md) in Azure Monitor enables you to send external data to a Log Analytics workspace by using a REST API call. This tutorial walks you through configuring a new custom table, a [data collection rule (DCR)](../data-collection/data-collection-rule-overview.md), a [data collection endpoint (DCE)](../data-collection/data-collection-endpoint-overview.md), and a sample application that sends log data by using the Azure portal.

A DCR defines the data format, the transformation to apply, and the destination table. A DCE provides the endpoint URL that your application sends data to. The DCR has an **immutableId** property, which is a unique identifier you use in the API call.

> [!NOTE]
> This tutorial uses the Azure portal to configure the components to support the Logs ingestion API. For a similar tutorial that uses Azure Resource Manager templates to configure these components, see [Tutorial: Send data to Azure Monitor using Logs ingestion API (Resource Manager templates)](tutorial-logs-ingestion-api.md). That tutorial also has sample code for the client libraries [.NET](/dotnet/api/overview/azure/Monitor.Ingestion-readme), [Go](https://pkg.go.dev/github.com/Azure/azure-sdk-for-go/sdk/monitor/ingestion/azlogs), [Java](/java/api/overview/azure/monitor-ingestion-readme), [JavaScript](/javascript/api/overview/azure/monitor-ingestion-readme), and [Python](/python/api/overview/azure/monitor-ingestion-readme).



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

When you finish the configuration, you send sample data from the command line and inspect the results in Log Analytics.

<a name='create-azure-ad-application'></a>

## Create Microsoft Entra application

Start by registering a Microsoft Entra application to authenticate against the API. The API supports any Resource Manager authentication scheme, but this tutorial follows the [Client Credential Grant Flow scheme](/entra/identity-platform/v2-oauth2-client-creds-grant-flow).

1. On the **Microsoft Entra ID** menu in the Azure portal, select **App registrations** > **New registration**.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/new-app-registration.png" lightbox="media/tutorial-logs-ingestion-portal/new-app-registration.png" alt-text="Screenshot that shows the app registration screen.":::

1. Enter a name for the application and change the tenancy scope if the default isn't appropriate for your environment. You don't need to provide a **Redirect URI**.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/new-app-name.png" lightbox="media/tutorial-logs-ingestion-portal/new-app-name.png" alt-text="Screenshot that shows app details.":::

1. After registration, view the details of the application. Note the **Application (client) ID** and the **Directory (tenant) ID**. You use these values when you configure the PowerShell script in the [Generate sample data](#generate-sample-data) step.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/new-app-id.png" lightbox="media/tutorial-logs-ingestion-portal/new-app-id.png" alt-text="Screenshot that shows the app ID.":::

1. Next, generate an application client secret, which is similar to creating a password to use with a username. Select **Certificates & secrets** > **New client secret**. Enter a name for the secret to identify its purpose and select an **Expires** duration. The value **1 year** is selected here. For a production implementation, follow best practices for a secret rotation procedure or use a more secure authentication mode, such as a certificate.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/new-app-secret.png" lightbox="media/tutorial-logs-ingestion-portal/new-app-secret.png" alt-text="Screenshot that shows a secret for a new app.":::

1. Select **Add** to save the secret and then note the **Value**. Record this value because you can't recover it after you move away from this page. Use the same security measures as you would for safekeeping a password because it's the functional equivalent.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/new-app-secret-value.png" lightbox="media/tutorial-logs-ingestion-portal/new-app-secret-value.png" alt-text="Screenshot that shows the secret value for the new app.":::

## Create data collection endpoint

This tutorial requires a data collection endpoint (DCE) because the Azure portal custom log creation wizard requires one. If you use ARM deployment templates or the Logs management API to [create the custom table and DCR](./tutorial-logs-ingestion-api.md), you have the option to use the [DCR endpoint](../data-collection/data-collection-endpoint-overview.md) instead.

The DCE must be in the same region as the Log Analytics workspace or the data collection rule. After you configure and link the DCE to a DCR, your application can send data over HTTP to the DCE's logs ingestion URI.

1. To create a new DCE, go to the **Monitor** menu in the Azure portal. Select **Data Collection Endpoints** and then select **Create**.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/new-data-collection-endpoint.png" lightbox="media/tutorial-logs-ingestion-portal/new-data-collection-endpoint.png" alt-text="Screenshot that shows new DCE.":::

1. Enter a name for the DCE and make sure it's in the same region as your workspace. Select **Create** to create the DCE.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/data-collection-endpoint-details.png" lightbox="media/tutorial-logs-ingestion-portal/data-collection-endpoint-details.png" alt-text="Screenshot that shows DCE details.":::

1. After the DCE is created, select it to view its properties. Note the **Logs ingestion** URI. Use this URI as the `$DceURI` parameter when you run the PowerShell script.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/data-collection-endpoint-uri.png" lightbox="media/tutorial-logs-ingestion-portal/data-collection-endpoint-uri.png" alt-text="Screenshot that shows DCE URI.":::

## Create new table in Log Analytics workspace

Before you can send data to the workspace, you need to create the custom table where the data will be sent.

> [!NOTE]
> The following table creation process for a log ingestion API custom log can't be used to create an [agent custom log table](../agents/data-collection-text-log.md). You must use the CLI or custom template process to create the table. If you don't have sufficient rights to run CLI or custom template, ask your administrator to add the table for you.

1. Go to the **Log Analytics workspaces** menu in the Azure portal and select **Tables**. The tables in the workspace appear. Select **Create** > **New custom log (DCR based)**.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/new-custom-log.png" lightbox="media/tutorial-logs-ingestion-portal/new-custom-log.png" alt-text="Screenshot that shows the new DCR-based custom log.":::

1. Enter a name for the table. You don't need to add the *_CL* suffix required for a custom table because the portal automatically adds it to the name you specify.

1. Select **Create a new data collection rule** to create the DCR used to send data to this table. Optionally, choose an existing DCR instead. Specify the **Subscription**, **Resource group**, and **Name** for the DCR that contains the custom log configuration.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/new-data-collection-rule.png" lightbox="media/tutorial-logs-ingestion-portal/new-data-collection-rule.png" alt-text="Screenshot that shows the new DCR.":::

1. Select a DCE that you already created from the pull-down menu and select **Next**.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/custom-log-table-name.png" lightbox="media/tutorial-logs-ingestion-portal/custom-log-table-name.png" alt-text="Screenshot that shows the custom log table name.":::

## Parse and filter sample data

Instead of directly configuring the schema of the table, upload a file with a sample JSON array of data through the portal, and Azure Monitor sets the schema automatically. The sample JSON file must contain one or more log records structured as an array, in the same way the data is sent in the body of an HTTP request of the logs ingestion API call.

1. Generate the *data_sample.json* file before you continue. Go to [Generate sample data](#generate-sample-data), run the PowerShell script with the `-Type "file"` option, and then return to this step.

1. Select **Browse for files** and locate the *data_sample.json* file that you previously created.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/custom-log-browse-files.png" lightbox="media/tutorial-logs-ingestion-portal/custom-log-browse-files.png" alt-text="Screenshot that shows custom log browse for files.":::

1. Data from the sample file is displayed with a warning that `TimeGenerated` isn't in the data. All log tables within Azure Monitor Logs are required to have a `TimeGenerated` column populated with the timestamp of the logged event. In this sample, the timestamp of the event is stored in the field called `Time`. You add a transformation that renames this column in the output.

1. Select **Transformation editor** to open the transformation editor to add this column. You add a transformation that renames this column in the output. The transformation editor lets you create a transformation for the incoming data stream. This transformation is a KQL query that's run against each incoming record. The results of the query are stored in the destination table. For more information on transformation queries, see [Data collection rule transformations in Azure Monitor](../data-collection/data-collection-transformations.md).

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

1. Optimize the query more by removing the `RawData` and `Time` columns because they aren't needed anymore. You can also filter out any records with `ResponseCode` of 200 because you're only interested in collecting data for requests that weren't successful. This step reduces the volume of data being ingested, which reduces its overall cost.

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

1. Select **Monitoring Metrics Publisher** > **Next**. If you don't want to use that role, create a custom action with the `Microsoft.Insights/Telemetry/Write` data action instead.

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

1. Copy the sample log data from [sample data](#sample-data) or use your own Apache log data. Save it as `sample_access.log`.

1. Run the following command to read the data in the file and create a JSON file called `data_sample.json`:

    ```PowerShell
    .\LogGenerator.ps1 -Log "sample_access.log" -Type "file" -Output "data_sample.json"
    ```

## Send sample data

Allow at least 30 minutes for the configuration to take effect. You might also experience increased latency for the first few entries, but this activity should normalize.

1. Run the following command providing the values that you collected for your DCR and DCE. The script starts ingesting data by placing calls to the API at the pace of approximately one record per second.

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

Use the following synthetic sample data for the tutorial. Alternatively, use your own data if you have your own Apache access logs.

```
10.0.144.150 - - [15/Mar/2024:08:00:00 +0000] "POST /pricing HTTP/1.1" 503 588 "https://www.contoso-web.example.com/products" "Mozilla/5.0 (Linux; Android 13; SM-S911B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36" "-"
198.51.100.24 - - [15/Mar/2024:08:00:40 +0000] "GET /products/details?id=2087 HTTP/1.1" 200 21854 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Mobile/15E148 Safari/604.1" "-"
203.0.113.31 - - [15/Mar/2024:08:00:56 +0000] "DELETE /api/v1/health HTTP/1.1" 200 5002 "https://www.contoso-web.example.com/blog/2024/new-features" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:124.0) Gecko/20100101 Firefox/124.0" "-"
198.51.100.58 - - [15/Mar/2024:08:01:36 +0000] "HEAD /docs/getting-started HTTP/2.0" 200 10506 "https://search.contoso.example.com/results?q=monitor+logs" "Mozilla/5.0 (iPad; CPU OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Mobile/15E148 Safari/604.1" "-"
203.0.113.107 - - [15/Mar/2024:08:02:04 +0000] "DELETE /css/main.css HTTP/1.1" 500 266 "https://www.contoso-web.example.com/blog/2024/new-features" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.0.187.234 - - [15/Mar/2024:08:02:13 +0000] "GET /dashboard HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Linux; Android 13; SM-S911B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36" "-"
198.51.100.249 - - [15/Mar/2024:08:02:58 +0000] "HEAD /favicon.ico HTTP/1.1" 200 32197 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:124.0) Gecko/20100101 Firefox/124.0" "-"
10.0.132.58 - - [15/Mar/2024:08:03:11 +0000] "GET /blog/2024/new-features HTTP/1.1" 200 17354 "https://www.contoso-web.example.com/products" "curl/8.5.0" "-"
198.51.100.203 - - [15/Mar/2024:08:03:16 +0000] "GET /fonts/opensans.woff2 HTTP/1.1" 200 54415 "-" "Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)" "-"
10.0.209.6 - - [15/Mar/2024:08:03:40 +0000] "HEAD /api/v1/inventory HTTP/1.1" 200 6523 "-" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Mobile/15E148 Safari/604.1" "-"
203.0.113.49 - - [15/Mar/2024:08:04:35 +0000] "GET /login HTTP/1.1" 200 33218 "https://www.contoso-web.example.com/docs/getting-started" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
198.51.100.138 - - [15/Mar/2024:08:04:59 +0000] "POST /download/latest HTTP/2.0" 200 1644 "https://www.contoso-web.example.com/products" "Mozilla/5.0 (Linux; Android 13; SM-S911B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36" "-"
10.0.195.154 - - [15/Mar/2024:08:05:09 +0000] "GET /favicon.ico HTTP/1.1" 200 9439 "https://www.contoso-web.example.com/docs/getting-started" "Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)" "-"
203.0.113.110 - - [15/Mar/2024:08:06:24 +0000] "PUT /docs/getting-started HTTP/1.1" 200 18702 "-" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Mobile/15E148 Safari/604.1" "-"
10.0.26.65 - - [15/Mar/2024:08:07:45 +0000] "DELETE /api/v1/status HTTP/1.1" 503 387 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:124.0) Gecko/20100101 Firefox/124.0" "-"
198.51.100.47 - - [15/Mar/2024:08:09:01 +0000] "GET /admin/reports HTTP/1.1" 200 20411 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:124.0) Gecko/20100101 Firefox/124.0" "-"
10.0.166.75 - - [15/Mar/2024:08:09:37 +0000] "HEAD /support/tickets HTTP/2.0" 302 6731 "-" "Mozilla/5.0 (Linux; Android 13; SM-S911B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36" "-"
203.0.113.55 - - [15/Mar/2024:08:09:50 +0000] "GET /about.html HTTP/1.1" 200 11857 "-" "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)" "-"
203.0.113.65 - - [15/Mar/2024:08:10:29 +0000] "PUT /pricing HTTP/1.1" 404 202 "https://www.contoso-web.example.com/" "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)" "-"
198.51.100.88 - - [15/Mar/2024:08:11:06 +0000] "DELETE /images/logo.png HTTP/1.1" 404 286 "-" "axios/1.6.7" "-"
203.0.113.179 - - [15/Mar/2024:08:12:26 +0000] "HEAD /products/details?id=3291 HTTP/1.1" 200 29107 "https://www.contoso-web.example.com/docs/getting-started" "Python-urllib/3.12" "-"
10.0.96.59 - - [15/Mar/2024:08:13:36 +0000] "GET /api/v1/orders HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.0.240.88 - - [15/Mar/2024:08:13:54 +0000] "GET /images/banner.jpg HTTP/1.1" 200 90926 "https://search.contoso.example.com/results?q=monitor+logs" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Safari/605.1.15" "-"
198.51.100.36 - - [15/Mar/2024:08:14:21 +0000] "POST /products/details?id=2087 HTTP/1.1" 404 327 "https://www.contoso-web.example.com/blog/2024/new-features" "Mozilla/5.0 (Linux; Android 13; SM-S911B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36" "-"
198.51.100.149 - - [15/Mar/2024:08:15:45 +0000] "HEAD /css/theme.css HTTP/2.0" 200 5724 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Safari/605.1.15" "-"
198.51.100.154 - - [15/Mar/2024:08:16:35 +0000] "POST /admin/users HTTP/1.1" 200 23414 "-" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Mobile/15E148 Safari/604.1" "-"
198.51.100.92 - - [15/Mar/2024:08:16:58 +0000] "GET /index.html HTTP/1.1" 400 352 "https://www.contoso-web.example.com/docs/getting-started" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
198.51.100.167 - - [15/Mar/2024:08:17:39 +0000] "GET /docs/getting-started HTTP/2.0" 200 13966 "https://www.contoso-web.example.com/products" "axios/1.6.7" "-"
10.0.93.74 - - [15/Mar/2024:08:18:41 +0000] "GET /pricing HTTP/1.1" 400 456 "-" "Python-urllib/3.12" "-"
203.0.113.19 - - [15/Mar/2024:08:19:40 +0000] "GET /images/hero-bg.webp HTTP/2.0" 200 79413 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/122.0.6261.62 Mobile/15E148 Safari/604.1" "-"
203.0.113.165 - - [15/Mar/2024:08:20:57 +0000] "GET /api/v1/users HTTP/1.1" 200 3962 "https://www.contoso-web.example.com/products" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Safari/605.1.15" "-"
198.51.100.13 - - [15/Mar/2024:08:21:51 +0000] "HEAD /products HTTP/1.1" 200 9982 "-" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Mobile/15E148 Safari/604.1" "-"
10.0.80.50 - - [15/Mar/2024:08:23:16 +0000] "GET /api/v1/users HTTP/1.1" 200 2526 "-" "Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.6261.64 Mobile Safari/537.36" "-"
198.51.100.89 - - [15/Mar/2024:08:24:02 +0000] "GET /sitemap.xml HTTP/1.1" 200 29252 "https://www.contoso-web.example.com/docs/getting-started" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.0.236.222 - - [15/Mar/2024:08:24:30 +0000] "GET /api/v1/health HTTP/1.1" 200 608 "https://www.contoso-web.example.com/" "Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.6261.64 Mobile Safari/537.36" "-"
198.51.100.80 - - [15/Mar/2024:08:25:41 +0000] "GET /products HTTP/1.1" 404 238 "https://www.contoso-web.example.com/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
203.0.113.210 - - [15/Mar/2024:08:25:56 +0000] "POST /support/kb/1001 HTTP/2.0" 404 284 "https://www.contoso-web.example.com/docs/getting-started" "Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)" "-"
203.0.113.161 - - [15/Mar/2024:08:27:25 +0000] "GET /products HTTP/1.1" 404 183 "https://www.contoso-web.example.com/docs/getting-started" "Mozilla/5.0 (iPad; CPU OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Mobile/15E148 Safari/604.1" "-"
203.0.113.69 - - [15/Mar/2024:08:27:44 +0000] "DELETE /docs/api-reference HTTP/2.0" 404 268 "https://www.contoso-web.example.com/blog/2024/new-features" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Mobile/15E148 Safari/604.1" "-"
198.51.100.93 - - [15/Mar/2024:08:28:35 +0000] "GET /js/analytics.js HTTP/1.1" 500 477 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.0.105.141 - - [15/Mar/2024:08:29:34 +0000] "GET /download/latest HTTP/1.1" 200 24434 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.0.162.224 - - [15/Mar/2024:08:30:42 +0000] "GET /js/analytics.js HTTP/1.1" 404 451 "-" "Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)" "-"
198.51.100.89 - - [15/Mar/2024:08:32:09 +0000] "GET /blog/2024/performance-tips HTTP/1.1" 404 353 "https://www.contoso-web.example.com/products" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
203.0.113.49 - - [15/Mar/2024:08:32:59 +0000] "GET /api/v1/orders HTTP/1.1" 200 1305 "-" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/122.0.6261.62 Mobile/15E148 Safari/604.1" "-"
203.0.113.20 - - [15/Mar/2024:08:34:25 +0000] "GET /images/hero-bg.webp HTTP/1.1" 401 532 "-" "Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.6261.64 Mobile Safari/537.36" "-"
10.0.139.177 - - [15/Mar/2024:08:35:06 +0000] "GET /about.html HTTP/2.0" 200 24876 "https://search.contoso.example.com/results?q=monitor+logs" "Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)" "-"
203.0.113.230 - - [15/Mar/2024:08:36:12 +0000] "GET /admin/users HTTP/1.1" 200 6595 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:124.0) Gecko/20100101 Firefox/124.0" "-"
203.0.113.134 - - [15/Mar/2024:08:36:29 +0000] "HEAD /docs/faq HTTP/1.1" 200 5233 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.0.14.232 - - [15/Mar/2024:08:37:56 +0000] "PUT /js/app.js HTTP/1.1" 200 10423 "-" "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)" "-"
203.0.113.7 - - [15/Mar/2024:08:37:57 +0000] "PUT /api/v1/orders HTTP/1.1" 200 3931 "https://www.contoso-web.example.com/products" "curl/8.5.0" "-"
10.0.7.17 - - [15/Mar/2024:08:38:48 +0000] "GET /api/v2/search?q=monitor HTTP/2.0" 200 2886 "https://www.contoso-web.example.com/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.0.3.75 - - [15/Mar/2024:08:40:17 +0000] "HEAD /docs/faq HTTP/1.1" 200 30166 "https://www.contoso-web.example.com/blog/2024/new-features" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
203.0.113.244 - - [15/Mar/2024:08:41:33 +0000] "HEAD /support/kb/2045 HTTP/1.1" 404 510 "https://www.contoso-web.example.com/docs/getting-started" "axios/1.6.7" "-"
10.0.98.177 - - [15/Mar/2024:08:42:23 +0000] "GET /pricing HTTP/1.1" 200 1235 "-" "Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.6261.64 Mobile Safari/537.36" "-"
198.51.100.112 - - [15/Mar/2024:08:43:30 +0000] "DELETE /css/theme.css HTTP/1.1" 401 439 "-" "Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)" "-"
203.0.113.62 - - [15/Mar/2024:08:44:57 +0000] "GET /favicon.ico HTTP/1.1" 200 31785 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.0.52.35 - - [15/Mar/2024:08:45:35 +0000] "POST /blog/2024/performance-tips HTTP/2.0" 200 6108 "https://www.contoso-web.example.com/docs/getting-started" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
203.0.113.44 - - [15/Mar/2024:08:46:32 +0000] "POST /login HTTP/1.1" 200 14068 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Safari/605.1.15" "-"
203.0.113.248 - - [15/Mar/2024:08:47:16 +0000] "DELETE /images/hero-bg.webp HTTP/1.1" 200 5877 "-" "Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)" "-"
198.51.100.199 - - [15/Mar/2024:08:47:47 +0000] "GET / HTTP/1.1" 404 194 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.0.122.128 - - [15/Mar/2024:08:48:13 +0000] "GET /api/v1/inventory HTTP/1.1" 200 7935 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
198.51.100.125 - - [15/Mar/2024:08:48:15 +0000] "GET /products/details?id=3291 HTTP/2.0" 304 0 "https://www.contoso-web.example.com/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.0.224.122 - - [15/Mar/2024:08:49:21 +0000] "GET /about.html HTTP/1.1" 200 22671 "https://www.contoso-web.example.com/blog/2024/new-features" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Mobile/15E148 Safari/604.1" "-"
198.51.100.136 - - [15/Mar/2024:08:50:06 +0000] "GET /products/details?id=3291 HTTP/1.1" 200 26601 "https://www.contoso-web.example.com/products" "Mozilla/5.0 (iPad; CPU OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Mobile/15E148 Safari/604.1" "-"
198.51.100.52 - - [15/Mar/2024:08:51:16 +0000] "GET /dashboard/settings HTTP/2.0" 401 211 "-" "axios/1.6.7" "-"
10.0.179.107 - - [15/Mar/2024:08:52:32 +0000] "GET /api/v1/inventory HTTP/2.0" 200 5011 "https://www.contoso-web.example.com/docs/getting-started" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Safari/605.1.15" "-"
10.0.77.165 - - [15/Mar/2024:08:52:36 +0000] "PUT /docs/getting-started HTTP/1.1" 200 17459 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.0.196.168 - - [15/Mar/2024:08:52:54 +0000] "GET /products/details?id=1042 HTTP/1.1" 200 6902 "-" "Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)" "-"
203.0.113.67 - - [15/Mar/2024:08:54:15 +0000] "POST /api/v1/inventory HTTP/1.1" 200 5818 "https://www.contoso-web.example.com/" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Mobile/15E148 Safari/604.1" "-"
10.0.75.215 - - [15/Mar/2024:08:55:33 +0000] "GET /api/v1/inventory HTTP/2.0" 401 211 "https://search.contoso.example.com/results?q=monitor+logs" "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)" "-"
198.51.100.177 - - [15/Mar/2024:08:55:53 +0000] "GET /index.html HTTP/2.0" 200 20022 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/122.0.6261.62 Mobile/15E148 Safari/604.1" "-"
198.51.100.5 - - [15/Mar/2024:08:57:16 +0000] "POST /images/hero-bg.webp HTTP/1.1" 200 118872 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)" "-"
198.51.100.212 - - [15/Mar/2024:08:57:34 +0000] "GET /api/v1/health HTTP/2.0" 304 0 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (Linux; Android 13; SM-S911B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36" "-"
203.0.113.172 - - [15/Mar/2024:08:57:37 +0000] "GET /docs/api-reference HTTP/1.1" 200 19005 "https://www.contoso-web.example.com/" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Mobile/15E148 Safari/604.1" "-"
10.0.128.161 - - [15/Mar/2024:08:59:01 +0000] "GET /dashboard HTTP/1.1" 502 479 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.0.119.212 - - [15/Mar/2024:09:00:11 +0000] "GET /pricing HTTP/2.0" 500 509 "https://search.contoso.example.com/results?q=monitor+logs" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.0.88.245 - - [15/Mar/2024:09:00:43 +0000] "GET /contact.html HTTP/1.1" 200 24833 "https://www.contoso-web.example.com/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:124.0) Gecko/20100101 Firefox/124.0" "-"
10.0.127.189 - - [15/Mar/2024:09:01:47 +0000] "GET /sitemap.xml HTTP/1.1" 200 30554 "https://www.contoso-web.example.com/products" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
203.0.113.5 - - [15/Mar/2024:09:01:58 +0000] "DELETE /api/v2/search?q=logs HTTP/1.1" 404 224 "https://www.contoso-web.example.com/blog/2024/new-features" "Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)" "-"
203.0.113.107 - - [15/Mar/2024:09:02:21 +0000] "GET /docs/faq HTTP/2.0" 200 10905 "-" "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)" "-"
203.0.113.241 - - [15/Mar/2024:09:03:06 +0000] "HEAD /favicon.ico HTTP/1.1" 200 2116 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:124.0) Gecko/20100101 Firefox/124.0" "-"
203.0.113.127 - - [15/Mar/2024:09:04:36 +0000] "HEAD /support/kb/1001 HTTP/2.0" 200 19023 "-" "Mozilla/5.0 (Linux; Android 13; SM-S911B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36" "-"
198.51.100.37 - - [15/Mar/2024:09:04:56 +0000] "GET /css/main.css HTTP/2.0" 200 14286 "-" "curl/8.5.0" "-"
203.0.113.100 - - [15/Mar/2024:09:05:09 +0000] "GET /dashboard/settings HTTP/1.1" 200 15588 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)" "-"
10.0.119.46 - - [15/Mar/2024:09:06:05 +0000] "DELETE /fonts/opensans.woff2 HTTP/1.1" 404 456 "https://www.contoso-web.example.com/docs/getting-started" "Mozilla/5.0 (iPad; CPU OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Mobile/15E148 Safari/604.1" "-"
203.0.113.130 - - [15/Mar/2024:09:06:54 +0000] "GET /fonts/opensans.woff2 HTTP/1.1" 401 437 "-" "curl/8.5.0" "-"
10.0.100.13 - - [15/Mar/2024:09:07:22 +0000] "PUT /products/details?id=2087 HTTP/1.1" 200 1326 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:124.0) Gecko/20100101 Firefox/124.0" "-"
203.0.113.38 - - [15/Mar/2024:09:08:22 +0000] "GET /images/banner.jpg HTTP/1.1" 200 89850 "-" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Mobile/15E148 Safari/604.1" "-"
198.51.100.57 - - [15/Mar/2024:09:08:57 +0000] "GET /admin/reports HTTP/1.1" 500 333 "-" "Mozilla/5.0 (iPad; CPU OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Mobile/15E148 Safari/604.1" "-"
10.0.6.147 - - [15/Mar/2024:09:10:00 +0000] "GET /support/kb/2045 HTTP/1.1" 200 18279 "https://www.contoso-web.example.com/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
198.51.100.86 - - [15/Mar/2024:09:10:09 +0000] "PUT /products/details?id=1042 HTTP/2.0" 401 153 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
203.0.113.16 - - [15/Mar/2024:09:11:03 +0000] "PUT /favicon.ico HTTP/1.1" 304 0 "https://www.contoso-web.example.com/" "Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.6261.64 Mobile Safari/537.36" "-"
198.51.100.35 - - [15/Mar/2024:09:12:16 +0000] "PUT /images/banner.jpg HTTP/1.1" 200 74710 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Safari/605.1.15" "-"
198.51.100.22 - - [15/Mar/2024:09:12:38 +0000] "GET /dashboard HTTP/1.1" 200 7065 "-" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/122.0.6261.62 Mobile/15E148 Safari/604.1" "-"
10.0.112.6 - - [15/Mar/2024:09:14:00 +0000] "PUT /download/latest HTTP/1.1" 200 14596 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Safari/605.1.15" "-"
203.0.113.182 - - [15/Mar/2024:09:15:02 +0000] "HEAD /dashboard HTTP/1.1" 200 23295 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.0.246.120 - - [15/Mar/2024:09:16:15 +0000] "PUT /api/v1/status HTTP/1.1" 200 1859 "-" "Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.6261.64 Mobile Safari/537.36" "-"
203.0.113.163 - - [15/Mar/2024:09:16:44 +0000] "GET /images/logo.png HTTP/1.1" 200 20968 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:124.0) Gecko/20100101 Firefox/124.0" "-"
10.0.154.169 - - [15/Mar/2024:09:17:04 +0000] "GET /css/theme.css HTTP/1.1" 200 20486 "https://search.contoso.example.com/results?q=monitor+logs" "curl/8.5.0" "-"
203.0.113.70 - - [15/Mar/2024:09:17:21 +0000] "PUT /css/main.css HTTP/2.0" 200 11344 "https://www.contoso-web.example.com/" "curl/8.5.0" "-"
10.0.70.200 - - [15/Mar/2024:09:18:03 +0000] "GET /admin/users HTTP/2.0" 200 6236 "https://www.contoso-web.example.com/docs/getting-started" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
198.51.100.4 - - [15/Mar/2024:09:19:18 +0000] "DELETE /api/v2/search?q=logs HTTP/1.1" 200 7477 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
198.51.100.65 - - [15/Mar/2024:09:19:32 +0000] "GET /products/details?id=1042 HTTP/1.1" 200 13081 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.6261.64 Mobile Safari/537.36" "-"
203.0.113.204 - - [15/Mar/2024:09:20:52 +0000] "DELETE /about.html HTTP/1.1" 200 27612 "-" "Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)" "-"
203.0.113.81 - - [15/Mar/2024:09:21:05 +0000] "GET / HTTP/1.1" 403 416 "https://www.contoso-web.example.com/" "axios/1.6.7" "-"
10.0.251.72 - - [15/Mar/2024:09:22:34 +0000] "GET /about.html HTTP/1.1" 200 5059 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:124.0) Gecko/20100101 Firefox/124.0" "-"
203.0.113.78 - - [15/Mar/2024:09:22:55 +0000] "PUT /css/theme.css HTTP/1.1" 302 43869 "https://www.contoso-web.example.com/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Safari/605.1.15" "-"
203.0.113.237 - - [15/Mar/2024:09:23:09 +0000] "DELETE /about.html HTTP/1.1" 404 330 "-" "Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)" "-"
10.0.178.63 - - [15/Mar/2024:09:23:31 +0000] "PUT /pricing HTTP/1.1" 200 3517 "https://www.contoso-web.example.com/products" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
203.0.113.94 - - [15/Mar/2024:09:23:38 +0000] "GET /css/main.css HTTP/1.1" 200 10624 "https://search.contoso.example.com/results?q=monitor+logs" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Mobile/15E148 Safari/604.1" "-"
198.51.100.160 - - [15/Mar/2024:09:24:17 +0000] "HEAD /api/v1/orders HTTP/1.1" 200 4928 "-" "Mozilla/5.0 (Linux; Android 13; SM-S911B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36" "-"
203.0.113.95 - - [15/Mar/2024:09:24:32 +0000] "PUT /dashboard HTTP/1.1" 304 0 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
198.51.100.105 - - [15/Mar/2024:09:24:54 +0000] "GET /about.html HTTP/1.1" 200 29644 "https://www.contoso-web.example.com/" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/122.0.6261.62 Mobile/15E148 Safari/604.1" "-"
10.0.155.45 - - [15/Mar/2024:09:24:57 +0000] "GET /docs/api-reference HTTP/1.1" 200 23496 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:124.0) Gecko/20100101 Firefox/124.0" "-"
198.51.100.134 - - [15/Mar/2024:09:25:12 +0000] "PUT /support/kb/1001 HTTP/1.1" 200 23411 "https://www.contoso-web.example.com/docs/getting-started" "curl/8.5.0" "-"
203.0.113.123 - - [15/Mar/2024:09:25:16 +0000] "DELETE /docs/getting-started HTTP/1.1" 200 33721 "https://www.contoso-web.example.com/blog/2024/new-features" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:124.0) Gecko/20100101 Firefox/124.0" "-"
203.0.113.40 - - [15/Mar/2024:09:25:53 +0000] "HEAD /support/kb/2045 HTTP/1.1" 302 6724 "https://www.contoso-web.example.com/" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/122.0.6261.62 Mobile/15E148 Safari/604.1" "-"
198.51.100.237 - - [15/Mar/2024:09:26:46 +0000] "GET /contact.html HTTP/1.1" 200 26385 "https://www.contoso-web.example.com/products" "axios/1.6.7" "-"
203.0.113.250 - - [15/Mar/2024:09:27:10 +0000] "PUT /sitemap.xml HTTP/1.1" 200 3261 "https://www.contoso-web.example.com/blog/2024/new-features" "Mozilla/5.0 (iPad; CPU OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Mobile/15E148 Safari/604.1" "-"
10.0.146.130 - - [15/Mar/2024:09:27:43 +0000] "GET /login HTTP/2.0" 403 154 "https://www.contoso-web.example.com/" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/122.0.6261.62 Mobile/15E148 Safari/604.1" "-"
10.0.85.245 - - [15/Mar/2024:09:28:59 +0000] "PUT /admin/users HTTP/1.1" 200 24276 "https://search.contoso.example.com/results?q=monitor+logs" "Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)" "-"
10.0.234.28 - - [15/Mar/2024:09:29:59 +0000] "POST /css/main.css HTTP/2.0" 200 4532 "https://search.contoso.example.com/results?q=monitor+logs" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:124.0) Gecko/20100101 Firefox/124.0" "-"
203.0.113.112 - - [15/Mar/2024:09:31:21 +0000] "GET /products HTTP/1.1" 404 325 "https://www.contoso-web.example.com/products" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
203.0.113.105 - - [15/Mar/2024:09:32:08 +0000] "POST /blog/2024/performance-tips HTTP/1.1" 200 6005 "https://www.contoso-web.example.com/docs/getting-started" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Mobile/15E148 Safari/604.1" "-"
198.51.100.243 - - [15/Mar/2024:09:33:24 +0000] "HEAD /products/details?id=1042 HTTP/1.1" 200 31460 "-" "Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.6261.64 Mobile Safari/537.36" "-"
203.0.113.73 - - [15/Mar/2024:09:33:55 +0000] "POST /products HTTP/1.1" 200 13432 "https://www.contoso-web.example.com/blog/2024/new-features" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.0.146.116 - - [15/Mar/2024:09:34:54 +0000] "GET /contact.html HTTP/1.1" 200 32849 "https://www.contoso-web.example.com/docs/getting-started" "curl/8.5.0" "-"
198.51.100.114 - - [15/Mar/2024:09:36:16 +0000] "POST /api/v1/inventory HTTP/1.1" 200 2408 "https://www.contoso-web.example.com/products" "curl/8.5.0" "-"
10.0.143.180 - - [15/Mar/2024:09:37:31 +0000] "POST /docs/getting-started HTTP/1.1" 200 6891 "https://search.contoso.example.com/results?q=monitor+logs" "Python-urllib/3.12" "-"
203.0.113.22 - - [15/Mar/2024:09:38:52 +0000] "PUT /api/v1/users HTTP/1.1" 401 202 "-" "Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)" "-"
203.0.113.235 - - [15/Mar/2024:09:39:00 +0000] "GET /blog/2024/performance-tips HTTP/1.1" 404 336 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.0.35.68 - - [15/Mar/2024:09:39:17 +0000] "POST /download/latest HTTP/1.1" 200 28141 "-" "Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)" "-"
10.0.245.37 - - [15/Mar/2024:09:40:46 +0000] "PUT /docs/api-reference HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
198.51.100.94 - - [15/Mar/2024:09:41:26 +0000] "DELETE /contact.html HTTP/1.1" 200 7501 "https://www.contoso-web.example.com/" "Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)" "-"
10.0.72.57 - - [15/Mar/2024:09:42:45 +0000] "PUT /js/analytics.js HTTP/1.1" 404 331 "https://search.contoso.example.com/results?q=monitor+logs" "Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)" "-"
10.0.148.74 - - [15/Mar/2024:09:43:56 +0000] "GET /api/v1/orders HTTP/2.0" 200 2906 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
203.0.113.66 - - [15/Mar/2024:09:45:02 +0000] "GET /dashboard HTTP/1.1" 403 419 "-" "Mozilla/5.0 (iPad; CPU OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Mobile/15E148 Safari/604.1" "-"
198.51.100.59 - - [15/Mar/2024:09:45:47 +0000] "GET /products/catalog HTTP/1.1" 200 12346 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:124.0) Gecko/20100101 Firefox/124.0" "-"
198.51.100.244 - - [15/Mar/2024:09:45:56 +0000] "GET /images/logo.png HTTP/1.1" 200 27223 "https://search.contoso.example.com/results?q=monitor+logs" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:124.0) Gecko/20100101 Firefox/124.0" "-"
203.0.113.218 - - [15/Mar/2024:09:46:55 +0000] "HEAD /support/kb/2045 HTTP/1.1" 200 2283 "https://portal.contoso.example.com/dashboard" "Python-urllib/3.12" "-"
203.0.113.156 - - [15/Mar/2024:09:47:42 +0000] "GET /api/v2/search?q=logs HTTP/2.0" 404 432 "https://www.contoso-web.example.com/blog/2024/new-features" "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)" "-"
203.0.113.220 - - [15/Mar/2024:09:49:01 +0000] "GET /api/v2/search?q=logs HTTP/2.0" 502 549 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Safari/605.1.15" "-"
10.0.171.103 - - [15/Mar/2024:09:49:27 +0000] "DELETE /support/kb/2045 HTTP/2.0" 200 22105 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)" "-"
198.51.100.105 - - [15/Mar/2024:09:50:21 +0000] "GET / HTTP/2.0" 200 34208 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (Linux; Android 13; SM-S911B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36" "-"
203.0.113.2 - - [15/Mar/2024:09:51:12 +0000] "GET /support/kb/2045 HTTP/2.0" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
198.51.100.61 - - [15/Mar/2024:09:51:55 +0000] "PUT /download/latest HTTP/1.1" 200 29957 "https://www.contoso-web.example.com/blog/2024/new-features" "Mozilla/5.0 (iPad; CPU OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Mobile/15E148 Safari/604.1" "-"
198.51.100.42 - - [15/Mar/2024:09:52:12 +0000] "GET /docs/api-reference HTTP/1.1" 404 234 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
198.51.100.203 - - [15/Mar/2024:09:52:33 +0000] "DELETE /api/v1/orders HTTP/1.1" 404 444 "https://search.contoso.example.com/results?q=monitor+logs" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
203.0.113.64 - - [15/Mar/2024:09:53:07 +0000] "PUT /products/details?id=2087 HTTP/2.0" 200 26159 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)" "-"
203.0.113.58 - - [15/Mar/2024:09:53:29 +0000] "GET /css/theme.css HTTP/2.0" 200 14059 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (Linux; Android 13; SM-S911B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36" "-"
198.51.100.11 - - [15/Mar/2024:09:54:34 +0000] "GET /api/v1/health HTTP/1.1" 200 6491 "https://search.contoso.example.com/results?q=monitor+logs" "Python-urllib/3.12" "-"
203.0.113.182 - - [15/Mar/2024:09:55:27 +0000] "GET /products/catalog HTTP/1.1" 200 31011 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.0.162.84 - - [15/Mar/2024:09:55:30 +0000] "GET /products/catalog HTTP/2.0" 200 14183 "-" "Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)" "-"
10.0.42.30 - - [15/Mar/2024:09:56:22 +0000] "GET /docs/getting-started HTTP/2.0" 304 0 "https://www.contoso-web.example.com/blog/2024/new-features" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
203.0.113.183 - - [15/Mar/2024:09:57:25 +0000] "GET /dashboard/settings HTTP/1.1" 200 27116 "https://www.contoso-web.example.com/docs/getting-started" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/122.0.6261.62 Mobile/15E148 Safari/604.1" "-"
10.0.238.85 - - [15/Mar/2024:09:58:43 +0000] "DELETE /blog/2024/performance-tips HTTP/1.1" 200 6665 "https://www.contoso-web.example.com/docs/getting-started" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.0.83.38 - - [15/Mar/2024:09:59:03 +0000] "GET /docs/getting-started HTTP/1.1" 301 28536 "https://portal.contoso.example.com/dashboard" "curl/8.5.0" "-"
198.51.100.138 - - [15/Mar/2024:09:59:29 +0000] "GET /fonts/opensans.woff2 HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
198.51.100.169 - - [15/Mar/2024:09:59:34 +0000] "GET /pricing HTTP/2.0" 200 20414 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:124.0) Gecko/20100101 Firefox/124.0" "-"
10.0.149.235 - - [15/Mar/2024:09:59:43 +0000] "DELETE /products/catalog HTTP/1.1" 200 7249 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
198.51.100.17 - - [15/Mar/2024:10:00:52 +0000] "HEAD /api/v2/search?q=monitor HTTP/2.0" 200 1409 "https://www.contoso-web.example.com/products" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:124.0) Gecko/20100101 Firefox/124.0" "-"
198.51.100.162 - - [15/Mar/2024:10:02:03 +0000] "GET /admin/reports HTTP/1.1" 200 25674 "-" "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)" "-"
198.51.100.196 - - [15/Mar/2024:10:02:41 +0000] "POST /login HTTP/1.1" 500 158 "https://portal.contoso.example.com/dashboard" "curl/8.5.0" "-"
10.0.51.98 - - [15/Mar/2024:10:03:45 +0000] "PUT /api/v1/users HTTP/1.1" 200 2403 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.0.139.98 - - [15/Mar/2024:10:05:02 +0000] "PUT /docs/faq HTTP/1.1" 304 0 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Safari/605.1.15" "-"
10.0.230.52 - - [15/Mar/2024:10:05:45 +0000] "GET /dashboard HTTP/1.1" 200 14400 "https://www.contoso-web.example.com/blog/2024/new-features" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.0.98.86 - - [15/Mar/2024:10:05:56 +0000] "GET /pricing HTTP/1.1" 200 5881 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.6261.64 Mobile Safari/537.36" "-"
203.0.113.125 - - [15/Mar/2024:10:06:58 +0000] "GET /docs/faq HTTP/2.0" 200 15606 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Safari/605.1.15" "-"
10.0.120.68 - - [15/Mar/2024:10:07:23 +0000] "GET /api/v1/status HTTP/1.1" 200 2180 "https://www.contoso-web.example.com/docs/getting-started" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
198.51.100.115 - - [15/Mar/2024:10:07:47 +0000] "GET /dashboard/settings HTTP/1.1" 200 33326 "https://search.contoso.example.com/results?q=monitor+logs" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Mobile/15E148 Safari/604.1" "-"
10.0.126.159 - - [15/Mar/2024:10:09:17 +0000] "GET /js/analytics.js HTTP/1.1" 403 212 "-" "Python-urllib/3.12" "-"
203.0.113.71 - - [15/Mar/2024:10:09:39 +0000] "GET /js/analytics.js HTTP/1.1" 200 14377 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
198.51.100.166 - - [15/Mar/2024:10:10:34 +0000] "GET /products/catalog HTTP/1.1" 304 0 "https://www.contoso-web.example.com/" "curl/8.5.0" "-"
198.51.100.210 - - [15/Mar/2024:10:12:03 +0000] "DELETE /support/tickets HTTP/2.0" 200 28291 "https://search.contoso.example.com/results?q=monitor+logs" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
198.51.100.103 - - [15/Mar/2024:10:13:03 +0000] "GET /robots.txt HTTP/1.1" 200 19145 "-" "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)" "-"
10.0.29.154 - - [15/Mar/2024:10:13:53 +0000] "GET /js/analytics.js HTTP/1.1" 200 11324 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:124.0) Gecko/20100101 Firefox/124.0" "-"
198.51.100.22 - - [15/Mar/2024:10:14:25 +0000] "PUT /docs/api-reference HTTP/1.1" 200 2416 "https://www.contoso-web.example.com/blog/2024/new-features" "Mozilla/5.0 (compatible; AhrefsBot/7.0; +http://ahrefs.com/robot/)" "-"
203.0.113.36 - - [15/Mar/2024:10:15:01 +0000] "PUT /css/theme.css HTTP/2.0" 200 42635 "https://search.contoso.example.com/results?q=monitor+logs" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
198.51.100.185 - - [15/Mar/2024:10:15:23 +0000] "GET /robots.txt HTTP/1.1" 200 6896 "https://search.contoso.example.com/results?q=monitor+logs" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.0.92.206 - - [15/Mar/2024:10:15:50 +0000] "PUT /products HTTP/1.1" 404 230 "-" "Mozilla/5.0 (Linux; Android 13; SM-S911B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36" "-"
198.51.100.200 - - [15/Mar/2024:10:16:07 +0000] "POST /products HTTP/1.1" 401 266 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.0.235.2 - - [15/Mar/2024:10:16:21 +0000] "GET /products/catalog HTTP/2.0" 403 398 "-" "axios/1.6.7" "-"
198.51.100.33 - - [15/Mar/2024:10:17:25 +0000] "GET /robots.txt HTTP/2.0" 200 7803 "-" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/122.0.6261.62 Mobile/15E148 Safari/604.1" "-"
10.0.253.189 - - [15/Mar/2024:10:17:59 +0000] "GET /robots.txt HTTP/1.1" 404 393 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
198.51.100.3 - - [15/Mar/2024:10:19:09 +0000] "GET /api/v1/inventory HTTP/1.1" 200 7035 "-" "Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.6261.64 Mobile Safari/537.36" "-"
198.51.100.108 - - [15/Mar/2024:10:19:22 +0000] "POST /images/banner.jpg HTTP/1.1" 200 119730 "https://www.contoso-web.example.com/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.0.130.134 - - [15/Mar/2024:10:19:25 +0000] "GET /js/app.js HTTP/1.1" 401 246 "https://www.contoso-web.example.com/" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/122.0.6261.62 Mobile/15E148 Safari/604.1" "-"
203.0.113.213 - - [15/Mar/2024:10:20:29 +0000] "PUT /login HTTP/1.1" 200 7016 "-" "Mozilla/5.0 (Linux; Android 13; SM-S911B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36" "-"
198.51.100.171 - - [15/Mar/2024:10:20:46 +0000] "PUT /admin/reports HTTP/2.0" 200 9250 "https://portal.contoso.example.com/dashboard" "Python-urllib/3.12" "-"
10.0.204.237 - - [15/Mar/2024:10:21:59 +0000] "HEAD /js/analytics.js HTTP/2.0" 200 8118 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Safari/605.1.15" "-"
203.0.113.185 - - [15/Mar/2024:10:23:08 +0000] "GET /admin/reports HTTP/1.1" 302 16466 "https://www.contoso-web.example.com/" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Mobile/15E148 Safari/604.1" "-"
10.0.207.154 - - [15/Mar/2024:10:24:07 +0000] "DELETE /support/kb/2045 HTTP/1.1" 200 23028 "https://www.contoso-web.example.com/products" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
203.0.113.35 - - [15/Mar/2024:10:24:15 +0000] "DELETE /api/v1/health HTTP/2.0" 200 2452 "https://www.contoso-web.example.com/products" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:124.0) Gecko/20100101 Firefox/124.0" "-"
198.51.100.177 - - [15/Mar/2024:10:25:45 +0000] "HEAD /api/v1/orders HTTP/1.1" 401 309 "https://www.contoso-web.example.com/blog/2024/new-features" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36" "-"
10.0.70.137 - - [15/Mar/2024:10:25:47 +0000] "GET /about.html HTTP/1.1" 200 28630 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/122.0.6261.62 Mobile/15E148 Safari/604.1" "-"
10.0.95.70 - - [15/Mar/2024:10:26:32 +0000] "GET /api/v2/search?q=logs HTTP/1.1" 200 720 "https://search.contoso.example.com/results?q=monitor+logs" "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:124.0) Gecko/20100101 Firefox/124.0" "-"
203.0.113.86 - - [15/Mar/2024:10:27:46 +0000] "GET /js/app.js HTTP/1.1" 200 2753 "-" "Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/122.0.6261.62 Mobile/15E148 Safari/604.1" "-"
203.0.113.201 - - [15/Mar/2024:10:29:04 +0000] "DELETE /support/tickets HTTP/1.1" 401 403 "https://www.contoso-web.example.com/blog/2024/new-features" "Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)" "-"
10.0.231.94 - - [15/Mar/2024:10:29:05 +0000] "POST /sitemap.xml HTTP/2.0" 200 20531 "https://www.contoso-web.example.com/blog/2024/new-features" "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Safari/605.1.15" "-"
203.0.113.176 - - [15/Mar/2024:10:29:28 +0000] "GET /products/details?id=3291 HTTP/1.1" 200 29593 "https://portal.contoso.example.com/dashboard" "Mozilla/5.0 (iPad; CPU OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3 Mobile/15E148 Safari/604.1" "-"
```

## Next steps

* [Complete a similar tutorial by using ARM templates](tutorial-logs-ingestion-api.md)
* [Read more about custom logs](logs-ingestion-api-overview.md)
* [Learn more about writing transformation queries](../data-collection/data-collection-transformations.md)
