---
title: Azure Monitor activity log
description: Send Azure Monitor activity log data to Log Analytics, Azure Event Hubs, and Azure Storage.
ms.topic: how-to
ms.date: 07/08/2025
ms.reviewer: orens
---

# Activity log in Azure Monitor

The Azure Monitor activity log is a platform log for control plane events from Azure resources. It includes information like when a resource is modified or when a deployment error occurs. Use the activity log to either review or audit this information for resources that you monitor, or create an alert to be proactively notified when an event is created.

> [!TIP]
> If you were directed to this article from a deployment operation error, see [Troubleshoot common Azure deployment errors](/azure/azure-resource-manager/troubleshooting/common-deployment-errors).

## Activity log entries

Entries in the activity log are collected by default with no required configuration. They're kept for 90 days at no cost. To store them longer, [send them to a Log Analytics workspace or other location](#export-activity-logs). 

Activity log entries are system generated and can't be changed or deleted. Entries are typically a result of changes (create, update, delete operations) or an action having been initiated. Operations focused on reading details of a resource aren't typically captured.

> [!NOTE]
> Operations above the control plane are logged in [Azure Resource Logs](resource-logs.md). These aren't collected by default and require a [diagnostic setting](./diagnostic-settings.md) to be collected.

## View and retrieve the activity log
You can view the **Activity log** in the Azure portal or retrieve entries with PowerShell and the Azure CLI. It appears in the menu for most Azure resources and also from the **Monitor** menu. If you select it from a resource, the initial filter is set to that resource although you can modify the filter to view all entries.

You can also access activity log events by using the following methods:

- Use the [Get-AzLog](/powershell/module/az.monitor/get-azlog) cmdlet to retrieve the activity log from PowerShell. See [Azure Monitor PowerShell samples](../powershell-samples.md#retrieve-activity-log).
- Use [az monitor activity-log](/cli/azure/monitor/activity-log) to retrieve the activity log from the CLI. See [Azure Monitor CLI samples](../cli-samples.md#view-activity-log).
* Use the [Azure Monitor REST API](/rest/api/monitor/) to retrieve the activity log from a REST client.


### Export activity logs
Create a [diagnostic setting](./diagnostic-settings.md) to export activity log entries to one or more of the following destinations:

- [Log Analytics workspace](#send-to-a-log-analytics-workspace) for more complex querying and alerting.
- [Azure Event Hubs](#send-to-azure-event-hubs) to forwarding logs outside of Azure.
- [Azure Storage](#send-to-azure-storage) for cheaper, long-term archiving.

## [Log Analytics workspace](#tab/log-analytics)

Send the activity log to a [Log Analytics workspace](../logs/log-analytics-workspace-overview.md), which offers the following benefits:

- Correlate activity logs with other log data using [log queries](../logs/log-query-overview.md). 
- Create [log alerts](../alerts/alerts-create-log-alert-rule.md) which can use more complex logic than [activity log alerts](../alerts/alerts-create-activity-log-alert-rule.md).
- Access activity log data with [Power BI](/power-bi/transform-model/log-analytics/desktop-log-analytics-overview).

There are data ingestion or retention charges for activity logs for the default retention period of 90 days. You can [increase the retention period](../logs/data-retention-configure.md) to up to 12 years.

Activity log data in a Log Analytics workspace is stored in a table called [AzureActivity](/azure/azure-monitor/reference/tables/azureactivity). The structure of this table varies depending on the [category of the log entry](activity-log-schema.md).

For example, to view a count of activity log records for each category, use the following query:

```kusto
AzureActivity
| summarize count() by CategoryValue
```

To retrieve all records in the administrative category, use the following query:

```kusto
AzureActivity
| where CategoryValue == "Administrative"
```

> [!IMPORTANT]
> In some scenarios, it's possible that values in fields of `AzureActivity` might have different case from otherwise equivalent values. When querying data in `AzureActivity`, use case-insensitive operators for string comparisons, or use a scalar function to force a field to a uniform casing before any comparisons. For example, use the [tolower()](/azure/kusto/query/tolowerfunction) function on a field to force it to always be lowercase or the [=~ operator](/azure/kusto/query/datatypes-string-operators) when performing a string comparison.

### [Azure Event Hubs](#tab/event-hub)
Send the activity log to Azure Event Hubs to send entries outside of Azure, for example, to a third-party SIEM or other log analysis solutions. Activity log events from event hubs are consumed in JSON format with a `records` element that contains the records in each payload. The schema depends on the category and is described in [Azure activity log event schema](activity-log-schema.md).

The following sample output data is from event hubs for an activity log:

```json
{
    "records": [
        {
            "time": "2019-01-21T22:14:26.9792776Z",
            "resourceId": "/subscriptions/s1/resourceGroups/MSSupportGroup/providers/microsoft.support/supporttickets/115012112305841",
            "operationName": "microsoft.support/supporttickets/write",
            "category": "Write",
            "resultType": "Success",
            "resultSignature": "Succeeded.Created",
            "durationMs": 2826,
            "callerIpAddress": "111.111.111.11",
            "correlationId": "aaaa0000-bb11-2222-33cc-444444dddddd",
            "identity": {
                "authorization": {
                    "scope": "/subscriptions/s1/resourceGroups/MSSupportGroup/providers/microsoft.support/supporttickets/115012112305841",
                    "action": "microsoft.support/supporttickets/write",
                    "evidence": {
                        "role": "Subscription Admin"
                    }
                },
                "claims": {
                    "aud": "https://management.core.windows.net/",
                    "iss": "https://sts.windows.net/72f988bf-86f1-41af-91ab-2d7cd011db47/",
                    "iat": "1421876371",
                    "nbf": "1421876371",
                    "exp": "1421880271",
                    "ver": "1.0",
                    "http://schemas.microsoft.com/identity/claims/tenantid": "ffffffff-eeee-dddd-cccc-bbbbbbbbbbb0",
                    "http://schemas.microsoft.com/claims/authnmethodsreferences": "pwd",
                    "http://schemas.microsoft.com/identity/claims/objectidentifier": "2468adf0-8211-44e3-95xq-85137af64708",
                    "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/upn": "admin@contoso.com",
                    "puid": "20030000801A118C",
                    "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier": "9vckmEGF7zDKk1YzIY8k0t1_EAPaXoeHyPRn6f413zM",
                    "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname": "John",
                    "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname": "Smith",
                    "name": "John Smith",
                    "groups": "cacfe77c-e058-4712-83qw-f9b08849fd60,7f71d11d-4c41-4b23-99d2-d32ce7aa621c,31522864-0578-4ea0-9gdc-e66cc564d18c",
                    "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name": " admin@contoso.com",
                    "appid": "00001111-aaaa-2222-bbbb-3333cccc4444",
                    "appidacr": "2",
                    "http://schemas.microsoft.com/identity/claims/scope": "user_impersonation",
                    "http://schemas.microsoft.com/claims/authnclassreference": "1"
                }
            },
            "level": "Information",
            "location": "global",
            "properties": {
                "statusCode": "Created",
                "serviceRequestId": "50d5cddb-8ca0-47ad-9b80-6cde2207f97c"
            }
        }
    ]
}
```

### [Azure Storage](#tab/storage)

Send the activity log to an Azure Storage account if you want to retain your log data longer than 90 days for audit, static analysis, or back up. If you're required to retain your events for 90 days or less, you don't need to set up archival to a storage account. Activity log events are retained in the Azure platform for 90 days.

When you send the activity log to Azure, a storage container is created in the storage account as soon as an event occurs. The blobs in the container use the following naming convention:

```
insights-activity-logs/resourceId=/SUBSCRIPTIONS/{subscription ID}/y={four-digit numeric year}/m={two-digit numeric month}/d={two-digit numeric day}/h={two-digit 24-hour clock hour}/m=00/PT1H.json
```

For example, a particular blob might have a name similar to:

```
insights-activity-logs/resourceId=/SUBSCRIPTIONS/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/y=2020/m=06/d=08/h=18/m=00/PT1H.json
```

Each `PT1H.json` blob contains a JSON object with events from log files that were received during the hour specified in the blob URL. During the present hour, events are appended to the PT1H.json file as they're received, regardless of when they were generated. The minute value in the URL, `m=00` is always `00` as blobs are created on a per hour basis.

Each event is stored in the PT1H.json file with the following format. This format uses a common top-level schema but is otherwise unique for each category, as described in [Activity log schema](activity-log-schema.md).

```json
{ "time": "2020-06-12T13:07:46.766Z", "resourceId": "/SUBSCRIPTIONS/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/RESOURCEGROUPS/MY-RESOURCE-GROUP/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINES/MV-VM-01", "correlationId": "bbbb1111-cc22-3333-44dd-555555eeeeee", "operationName": "Microsoft.Resourcehealth/healthevent/Updated/action", "level": "Information", "resultType": "Updated", "category": "ResourceHealth", "properties": {"eventCategory":"ResourceHealth","eventProperties":{"title":"This virtual machine is starting as requested by an authorized user or process. It will be online shortly.","details":"VirtualMachineStartInitiatedByControlPlane","currentHealthStatus":"Unknown","previousHealthStatus":"Unknown","type":"Downtime","cause":"UserInitiated"}}}
```

### CSV
Select **Download as CSV** to export the activity log to a CSV file using the Azure portal.

:::image type="content" source="media/activity-log/export-csv.png" lightbox="media/activity-log/export-csv.png" alt-text="Screenshot that shows option to export to CSV.":::

> [!IMPORTANT]
> The export may take an excessive amount of time if you have a large number of log entries. To improve performance, reduce the time range of the export. In the Azure portal, this is set with the **Timespan** setting. 


You can also export the activity log to a CSV file using PowerShell or the Azure CLI as in the following examples.

```azurecli
az monitor activity-log list --start-time "2024-03-01T00:00:00Z" --end-time "2024-03-15T23:59:59Z" --max-items 1000 > activitylog.json
```

```powershell
Get-AzActivityLog -StartTime 2021-12-01T10:30 -EndTime 2022-01-14T11:30 | Export-csv operations_logs.csv
```

The following example PowerShell script exports the activity log to CSV files in one hour intervals, each being saved to a separate file. 


```powershell
# Parameters
$subscriptionId = "Subscription ID here"  # Replace with your subscription ID
$startTime = [datetime]"2025-05-08T00:00:00" # Adjust as needed
$endTime = [datetime]"2025-05-08T12:00:00"  # Adjust as needed
$outputFolder = "\Logs"    # Change path as needed
 
# Ensure output folder exists
if (-not (Test-Path $outputFolder)) {
    New-Item -Path $outputFolder -ItemType Directory
}
 
# Set subscription context
Set-AzContext -SubscriptionId $subscriptionId
 
# Loop through 1-hour intervals
$currentStart = $startTime
while ($currentStart -lt $endTime) {
    $currentEnd = $currentStart.AddHours(1)
    $timestamp = $currentStart.ToString("yyyyMMdd-HHmm")
    $csvFile = Join-Path $outputFolder "ActivityLog_$timestamp.csv"
 
    Write-Host "Fetching logs from $currentStart to $currentEnd..."
    Get-AzActivityLog -StartTime $currentStart -EndTime $currentEnd |
        Export-Csv -Path $csvFile -NoTypeInformation
 
    $currentStart = $currentEnd
}
 
Write-Host "Export completed. Files saved to $outputFolder."
```

---


## Legacy collection methods

> [!NOTE]
> The Azure Activity Log solution was used to forward activity logs to Log Analytics. This solution is being retired on the 15th of Sept 2026 and will be automatically converted to Diagnostic settings.

If you're collecting activity logs using the legacy collection method, we recommend you [export activity logs to your Log Analytics workspace](#send-to-a-log-analytics-workspace) and disable the legacy collection using the [Data Sources - Delete API](/rest/api/loganalytics/data-sources/delete?tabs=HTTP) as follows:

1. List all data sources connected to the workspace using the [Data Sources - List By Workspace API](/rest/api/loganalytics/data-sources/list-by-workspace?tabs=HTTP#code-try-0) and filter for activity logs by setting `kind eq 'AzureActivityLog'`.

    :::image type="content" source="media/activity-log/data-sources-list-by-workspace-api.png" alt-text="Screenshot showing the configuration of the Data Sources - List By Workspace API." lightbox="media/activity-log/data-sources-list-by-workspace-api.png":::

1. Copy the name of the connection you want to disable from the API response.

    :::image type="content" source="media/activity-log/data-sources-list-by-workspace-api-connection.png" alt-text="Screenshot showing the connection information you need to copy from the output of the Data Sources - List By Workspace API." lightbox="media/activity-log/data-sources-list-by-workspace-api-connection.png":::
 
1. Use the [Data Sources - Delete API](/rest/api/loganalytics/data-sources/delete?tabs=HTTP) to stop collecting activity logs for the specific resource.

    :::image type="content" source="media/activity-log/data-sources-delete-api.png" alt-text="Screenshot of the configuration of the Data Sources - Delete API." lightbox="media/activity-log/data-sources-delete-api.png":::

### Managing legacy Log Profiles (retiring)

> [!NOTE]
> * Logs Profiles was used to forward activity logs to storage accounts and Event Hubs. This method is being retired on the 15th of Sept 2026.
> * If you're using this method, transition to Diagnostic Settings before 15th of Sept 2025, when we'll stop allowing new creates of Log Profiles.

Log profiles are the legacy method for sending the activity log to storage or event hubs. If you're using this method, transition to Diagnostic Settings, which provide better functionality and consistency with resource logs.

#### [PowerShell](#tab/powershell)

If a log profile already exists, you first must remove the existing log profile, and then create a new one.

1. Use `Get-AzLogProfile` to identify if a log profile exists. If a log profile exists, note the `Name` property.

1. Use `Remove-AzLogProfile` to remove the log profile by using the value from the `Name` property.

    ```powershell
    # For example, if the log profile name is 'default'
    Remove-AzLogProfile -Name "default"
    ```

1. Use `Add-AzLogProfile` to create a new log profile:

    ```powershell
    Add-AzLogProfile -Name my_log_profile -StorageAccountId /subscriptions/s1/resourceGroups/myrg1/providers/Microsoft.Storage/storageAccounts/my_storage -serviceBusRuleId /subscriptions/s1/resourceGroups/Default-ServiceBus-EastUS/providers/Microsoft.ServiceBus/namespaces/mytestSB/authorizationrules/RootManageSharedAccessKey -Location global,westus,eastus -RetentionInDays 90 -Category Write,Delete,Action
    ```

    | Property | Required | Description |
    |----------|----------|-------------|
    | Name |Yes |Name of your log profile. |
    | StorageAccountId |No |Resource ID of the storage account where the activity log should be saved. |
    | serviceBusRuleId |No |Service Bus Rule ID for the Service Bus namespace where you want to have event hubs created. This string has the format `{service bus resource ID}/authorizationrules/{key name}`. |
    | Location |Yes |Comma-separated list of regions for which you want to collect activity log events. |
    | RetentionInDays |Yes |Number of days for which events should be retained in the storage account, from 1 through 365. A value of zero stores the logs indefinitely. |
    | Category |No |Comma-separated list of event categories to be collected. Possible values are Write, Delete, and Action. |

**Example script**

This sample PowerShell script creates a log profile that writes the activity log to both a storage account and an event hub.

```powershell
# Settings needed for the new log profile
$logProfileName = "default"
$locations = (Get-AzLocation).Location
$locations += "global"
$subscriptionId = "<your Azure subscription Id>"
$resourceGroupName = "<resource group name your Event Hub belongs to>"
$eventHubNamespace = "<Event Hub namespace>"
$storageAccountName = "<Storage Account name>"

# Build the service bus rule Id from the settings above
$serviceBusRuleId = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.EventHub/namespaces/$eventHubNamespace/authorizationrules/RootManageSharedAccessKey"

# Build the Storage Account Id from the settings above
$storageAccountId = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Storage/storageAccounts/$storageAccountName"

Add-AzLogProfile -Name $logProfileName -Location $locations -StorageAccountId $storageAccountId -ServiceBusRuleId $serviceBusRuleId
```

#### [CLI](#tab/cli)

If a log profile already exists, you first must remove the existing log profile, and then create a log profile.

1. Use `az monitor log-profiles list` to identify if a log profile exists.
1. Use `az monitor log-profiles delete --name "<log profile name>` to remove the log profile by using the value from the `name` property.
1. Use `az monitor log-profiles create` to create a log profile:

    ```azurecli-interactive
    az monitor log-profiles create --name "default" --location null --locations "global" "eastus" "westus" --categories "Delete" "Write" "Action" --enabled false --days 0 --service-bus-rule-id "/subscriptions/<YOUR SUBSCRIPTION ID>/resourceGroups/<RESOURCE GROUP NAME>/providers/Microsoft.EventHub/namespaces/<Event Hub NAME SPACE>/authorizationrules/RootManageSharedAccessKey"
    ```

    | Property | Required | Description |
    |----------|----------|-------------|
    | `name` |Yes |Name of your log profile. |
    | `storage-account-id` |Yes |Resource ID of the storage account to which activity logs should be saved. |
    | `locations` |Yes |Space-separated list of regions for which you want to collect activity log events. View a list of all regions for your subscription by using `az account list-locations --query [].name`. |
    | `days` |Yes |Number of days for which events should be retained, from 1 through 365. A value of zero stores the logs indefinitely (forever). If zero, then the enabled parameter should be set to False. |
    |`enabled` | Yes |True or False. Used to enable or disable the retention policy. If True, then the `days` parameter must be a value greater than zero. |
    | `categories` |Yes |Space-separated list of event categories that should be collected. Possible values are Write, Delete, and Action. |

---

### Data structure changes

The Export activity logs experience sends the same data as the legacy method used to send the activity log with some changes to the structure of the `AzureActivity` table.

The columns in the following table are deprecated in the updated schema. They still exist in `AzureActivity`, but they have no data. The replacements for these columns aren't new, but they contain the same data as the deprecated column. They're in a different format, so you might need to modify log queries that use them.

| Activity log JSON | Old Log Analytics column name<br>*(deprecated)* | New Log Analytics column name | Notes |
|-------------------|-------------------------------------------------|-------------------------------|-------|
| category | Category | CategoryValue | |
| status<br><br>Values are `success`, `start`, `accept`, `failure` | ActivityStatus <br><br>Values same as JSON | ActivityStatusValue<br><br>Values change to `succeeded`, `started`, a`ccepted`, `failed` | The valid values change as shown. | 
| subStatus | ActivitySubstatus | ActivitySubstatusValue | |
| operationName	| OperationName | OperationNameValue | REST API localizes the operation name value. Log Analytics UI always shows English. |
| resourceProviderName | ResourceProvider | ResourceProviderValue | |

> [!IMPORTANT]
> In some cases, the values in these columns might be all uppercase. If you have a query that includes these columns, use the [=~ operator](/azure/kusto/query/datatypes-string-operators) to do a case-insensitive comparison.

The following columns have been added to `AzureActivity` in the updated schema:

* `Authorization_d`
* `Claims_d`
* `Properties_d`

## Next steps

Learn more about:

* [Platform logs](./platform-logs-overview.md)
* [Activity log event schema](activity-log-schema.md)
* [Activity log insights](activity-log-insights.md)





1. Go to **Azure Monitor** > **Activity log** and select **Export Activity Logs**.
    
    :::image type="content" source="media/activity-log/go-to-activity-logs.png" lightbox="media/activity-log/go-to-activity-logs.png" alt-text="Screenshot that shows how to get to activity logs.":::
    
    > [!NOTE]
    > You can send the activity log from any single subscription to up to five workspaces.

1. **Add diagnostic setting** to send activity logs to one or more of these locations:

    * [Log Analytics workspace](#send-to-a-log-analytics-workspace) for more complex querying and alerting.
    * [Azure Event Hubs](#send-to-azure-event-hubs) to forwarding logs outside of Azure.
    * [Azure Storage](#send-to-azure-storage) for cheaper, long-term archiving.

    :::image type="content" source="media/activity-log/add-diagnostic-setting.png" lightbox="media/activity-log/add-diagnostic-setting.png" alt-text="Screenshot that shows adding a diagnostic setting.":::
    