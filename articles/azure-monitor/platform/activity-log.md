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

Activity log entries are system generated and can't be changed or deleted. Entries are typically a result of changes (create, update, delete operations) or an action having been initiated. Operations focused on reading details of a resource aren't typically captured. For a description of activity log categories, see [Azure activity log event schema](activity-log-schema.md#categories).

> [!NOTE]
> Operations above the control plane are logged in [Azure Resource Logs](resource-logs.md). These aren't collected by default and require a [diagnostic setting](./diagnostic-settings.md) to be collected.

## Retention period

Activity log events are retained in Azure for *90 days* and then deleted. There's no charge for entries during this time regardless of volume. For more functionality, such as longer retention, create a diagnostic setting and route the entries to another location based on your needs. See the criteria in the preceding section.

## View and retrieve the activity log
You can access the activity log from most menus in the Azure portal. The menu that you open it from determines its initial filter. If you open it from the **Monitor** menu, the only filter is on the subscription. If you open it from a resource's menu, the filter is set to that resource. You can always change the filter to view all other entries. Select **Add Filter** to add more properties to the filter.

:::image type="content" source="./media/activity-log/view-activity-log.png" lightbox="./media/activity-log/view-activity-log.png" alt-text="Screenshot that shows the activity log." :::

You can also access activity log events by using the following methods:

- Use the [Get-AzLog](/powershell/module/az.monitor/get-azlog) cmdlet to retrieve the activity log from PowerShell. See [Azure Monitor PowerShell samples](../powershell-samples.md#retrieve-activity-log).
- Use [az monitor activity-log](/cli/azure/monitor/activity-log) to retrieve the activity log from the CLI. See [Azure Monitor CLI samples](../cli-samples.md#view-activity-log).
* Use the [Azure Monitor REST API](/rest/api/monitor/) to retrieve the activity log from a REST client.

## View change history

For some events, you can view the change history, which shows what changes happened during that event time. Select an event from the activity log you want to look at more deeply. Select the **Change history** tab to view any changes on the resource up to 30 minutes before and after the time of the operation.

:::image type="content" source="media/activity-log/change-history-event.png" lightbox="media/activity-log/change-history-event.png" alt-text="Screenshot that shows the Change history list for an event.":::

If any changes are associated with the event, you'll see a list of changes that you can select. Selecting a change opens the **Change history** page. This page displays the changes to the resource. In the following example, you can see that the VM changed sizes. The page displays the VM size before the change and after the change. To learn more about change history, see [Get resource changes](/azure/governance/resource-graph/how-to/get-resource-changes).

:::image type="content" source="media/activity-log/change-history-event-details.png" lightbox="media/activity-log/change-history-event-details.png" alt-text="Screenshot that shows the Change history page showing differences.":::

## Activity log insights

Activity log insights provide you with a set of dashboards that monitor the changes to resources and resource groups in a subscription. The dashboards also present data about which users or services performed activities in the subscription and the activities' status. This article explains how to onboard and view activity log insights in the Azure portal.

Activity log insights are a curated [Log Analytics workbook](../visualize/workbooks-overview.md) with dashboards that visualize the data in the `AzureActivity` table. For example, data might include which administrators deleted, updated, or created resources and whether the activities failed or succeeded.

Azure Monitor stores all activity logs you send to a [Log Analytics workspace](../logs/log-analytics-workspace-overview.md) in a table called `AzureActivity`. Before you use activity log insights, you must [enable sending logs to your Log Analytics workspace](./diagnostic-settings.md).

:::image type="content" source="media/activity-log/activity-logs-insights-main-screen.png" lightbox= "media/activity-log/activity-logs-insights-main-screen.png" alt-text="Screenshot that shows activity log insights dashboards.":::

## View resource group or subscription-level activity log insights 

To view activity log insights at the resource group or subscription level:

1. In the Azure portal, select **Monitor** > **Workbooks**.
1. In the **Insights** section, select **Activity Logs Insights**.

    :::image type="content" source="media/activity-log/open-activity-log-insights-workbook.png" lightbox= "media/activity-log/open-activity-log-insights-workbook.png" alt-text="Screenshot that shows how to locate and open the Activity Logs Insights workbook on a scale level.":::

1. At the top of the **Activity Logs Insights** page, select:

    - One or more subscriptions from the **Subscriptions** dropdown.
    - Resources and resource groups from the **CurrentResource** dropdown.
    - A time range for which to view data from the **TimeRange** dropdown.

## View resource-level activity log insights

>[!Note]
> Activity log insights does not currently support Application Insights resources.

To view activity log insights at the resource level:

1. In the Azure portal, go to your resource and select **Workbooks**.
1. In the **Activity Logs Insights** section, select **Activity Logs Insights**.

    :::image type="content" source="media/activity-log/activity-log-resource-level.png" lightbox= "media/activity-log/activity-log-resource-level.png" alt-text="Screenshot that shows how to locate and open the Activity Logs Insights workbook on a resource level.":::

1. At the top of the **Activity Logs Insights** page, select a time range for which to view data from the **TimeRange** dropdown:
   
   * **Azure Activity Log Entries** shows the count of activity log records in each activity log category.
     
     :::image type="content" source="media/activity-log/activity-logs-insights-category-value.png" lightbox= "media/activity-log/activity-logs-insights-category-value.png" alt-text="Screenshot that shows Azure activity logs by category value.":::
    
   * **Activity Logs by Status** shows the count of activity log records in each status.
    
     :::image type="content" source="media/activity-log/activity-logs-insights-status.png" lightbox= "media/activity-log/activity-logs-insights-status.png" alt-text="Screenshot that shows Azure activity logs by status.":::
    
   * At the subscription and resource group level, **Activity Logs by Resource** and **Activity Logs by Resource Provider** show the count of activity log records for each resource and resource provider.
    
     :::image type="content" source="media/activity-log/activity-logs-insights-resource.png" lightbox= "media/activity-log/activity-logs-insights-resource.png" alt-text="Screenshot that shows Azure activity logs by resource.":::

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

