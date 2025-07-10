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

### [CSV](#tab/csv)
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
    