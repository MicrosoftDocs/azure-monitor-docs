---
title: Azure Monitor activity log
description: Learn how to view, retrieve, and export Azure Monitor activity log data to Log Analytics, Azure Event Hubs, and Azure Storage for analysis and long-term retention.
ms.topic: how-to
ms.date: 05/04/2026
ms.reviewer: orens
# customer intent: As an Azure administrator, I want to view and export activity log data so that I can audit control plane operations and retain logs beyond the default 90-day period.
---

# Activity log in Azure Monitor

Azure Monitor records management operations for your Azure resources through the activity log feature. The activity log records operations like creating a virtual machine, changing a key vault access policy, or Resource Manager deployment errors. These management operations are also called [*control plane*](/azure/azure-resource-manager/management/control-plane-and-data-plane) operations. Use the activity log to review or audit this information, or create an alert to be proactively notified when an event occurs.

In contrast to the activity log, [Azure resource logs](resource-logs.md) capture *data plane* operations performed within a resource. For example, these operations include getting a secret from a key vault or making a request to a database. Resource logs aren't collected by default and require configuration with a [diagnostic setting](./diagnostic-settings.md).

> [!TIP]
> If a deployment operation error directs you to this article, see [Troubleshoot common Azure deployment errors](/azure/azure-resource-manager/troubleshooting/common-deployment-errors).

## Activity log entries

Azure Monitor collects activity log entries by default with no required configuration. The system generates these entries, and you can't change or delete them. Entries typically result from changes (create, update, and delete operations) or an action being initiated. The activity log doesn't typically capture read operations. 

Activity log entries are usually available for analysis and alerting within [3 to 20 minutes of the event occurring](../logs/data-ingestion-time.md#azure-metrics-resource-logs-activity-logs). For a description of activity log categories, see [Azure activity log event schema](activity-log-schema.md#categories).

## Retention period

Azure retains activity log events for *90 days* and then deletes them. You aren't charged for entries during this time, regardless of volume. For more functionality, such as longer retention, create a diagnostic setting and [collect the entries in another location](#export-activity-log) based on your needs. One of the most common reasons to extend the retention period is to preserve [resource creator information](#identify-resource-creation), which is only available in the activity log.

## View and retrieve the activity log

View activity log events for a subscription, resource group, or an individual resource. Use the Azure portal or programmatically query them by using the [Activity Log REST API](../fundamentals/azure-monitor-rest-api-index.md#activity-log). 

The Azure portal provides the **Activity log** blade from most service menus. Each of these areas also support programmatic access with REST or through specific Azure CLI and Azure PowerShell commands.

Specify a time interval of events to retrieve. To retrieve events by using the REST API, you must include the `$filter` parameter along with at least an `eventTimestamp` start value. By default, the activity log retains events for 90 days. Make sure both the start and end of your time range fall within that 90-day window. 

### Activity log access scenarios

The following sections present common scenarios showing different ways to access and retrieve activity log events through the Azure portal and programmatically using Azure CLI, Azure PowerShell, and the REST API.
- Azure portal samples provide extra context around what kind of events to expect in that view.
- Azure CLI samples highlight the specific commands available through the [az monitor activity-log list](https://learn.microsoft.com/cli/azure/monitor/activity-log#az-monitor-activity-log-list) command.
- Azure PowerShell samples highlight the specific cmdlets available through the [Get-AzActivityLog](/powershell/module/az.monitor/get-azactivitylog) commandlet.
- REST API samples show how to retrieve events by using the required `$filter` parameter with the [Activity Log REST API](../fundamentals/azure-monitor-rest-api-index.md#activity-log). The samples also demonstrate how to explicitly set a timeout for your client to match the maximum timeout period for the activity log REST API of 75 seconds by using the [`Prefer` header](../logs/api/timeouts.md#timeout-request-header).

  | Supported `$filter` patterns | Details |
  |---|----|
  | default subscription with a time range | `$filter=eventTimestamp ge '{startTime}' and eventTimestamp le '{endTime}'` |
  | resource group | `$filter=eventTimestamp ge '{startTime}' and eventTimestamp le '{endTime}' and resourceGroupName eq '{resourceGroupName}'`|
  | specific resource | `$filter=eventTimestamp ge '{startTime}' and eventTimestamp le '{endTime}' and resourceUri eq '{resourceURI}'` |
  | resource provider | `$filter=eventTimestamp ge '{startTime}' and eventTimestamp le '{endTime}' and resourceProvider eq '{resourceProviderName}'` |
  | correlation ID | `$filter=eventTimestamp ge '{startTime}' and eventTimestamp le '{endTime}' and correlationId eq '{correlationID}'` | 

#### List activity log events for a subscription

Subscription level events capture events created directly by resource providers and is the default scope for listing activity log events. Tenant level and management group level events only capture Azure Resource Manager events in those hierarchies. These higher-level scopes do not include events generated directly by resource providers outside of Azure Resource Manager operations.

The following example retrieves activity log events for a subscription during a specific time range. 

# [Azure Portal](#tab/azure-portal)

The menu you open **Activity log** from determines its initial filter. If you open it from the **Monitor** menu, the only filter selected by default is the subscription. This is the same as opening it from **Subscriptions** > select subscription > **Activity Log**. 

:::image type="content" source="./media/activity-log/view-activity-log.png" lightbox="./media/activity-log/view-activity-log.png" alt-text="Screenshot that shows the activity log." :::


# [Azure CLI](#tab/azure-cli)

Use the [az monitor activity-log list](/cli/azure/monitor/activity-log#az-monitor-activity-log-list) Azure CLI command to retrieve activity log events for a subscription over a specified time range. By default, this command retrieves events for the subscription currently set in your Azure CLI context. To explicitly specify a subscription, use the `--subscription` parameter as shown in the example below.

```azurecli
az monitor activity-log list --offset 14d --subscription "aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
```


# [REST API](#tab/rest-api)

To list activity log events, use this `GET` request for the [Activity Log REST API](../fundamentals/azure-monitor-rest-api-index.md#activity-log).

```http
GET https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.Insights/eventtypes/management/values?api-version=2015-04-01&$filter=eventTimestamp ge '2026-03-01T00:00:00Z' and eventTimestamp le '2026-03-14T23:59:59Z'
```

# [PowerShell](#tab/powershell)

Azure PowerShell provides the [Get-AzActivityLog](/powershell/module/az.monitor/get-azactivitylog) cmdlet to retrieve activity log events for a subscription over a specified time range.

```azurepowershell
$subscriptionId = 'aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e'

Set-AzContext -Subscription $subscriptionId

$activityLogParams = @{
    StartTime = (Get-Date).AddDays(-14)
    EndTime   = Get-Date
}

Get-AzActivityLog @activityLogParams
```

---

#### List activity log events for a resource group

Add `resourceGroupName` to the `$filter` to scope Azure Monitor activity log results to a specific resource group.

# [Azure Portal](#tab/azure-portal)

The menu you open **Activity log** from determines its initial filter. If you open it from a resource's menu, the filter is set to that resource. Select **Add Filter** to add more properties to the filter. Here are the other properties you can filter by in the portal:

* **Resource** - Items that are part of your Azure solution, such as a database or virtual machine.
* **Resource type** – The category to which a resource belongs, such as virtual machines, web apps, or databases.
* **Operation** - An action or command, such as create, delete, and write, that affects Azure Resource Manager resources.
* **Event initiated by** – Filter events by the identity that initiated the event.
* **Event category** – Filter the event types for certain operations.

# [Azure CLI](#tab/azure-cli)

Use the [az monitor activity-log list](/cli/azure/monitor/activity-log#az-monitor-activity-log-list) command to retrieve activity log events scoped to a resource group. Specific Azure CLI commands reduce the complexity of the equivalent REST API call. This example uses the default subscription context. To explicitly scope the command to a subscription, add the `--subscription` parameter.

```azurecli
az monitor activity-log list \
  --subscription "aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e" \
  --resource-group "myResourceGroup" \
  --offset 30d \
  --select "eventName operationName"
```

# [REST API](#tab/rest-api)

To list activity log events scoped to a resource group using the Azure Resource Manager REST API, use a `GET` request with a `$filter` that includes both the time range and the `resourceGroupName` property. Optionally, include the `Prefer` header to specify a specific timeout for the request (maximum `75` wait time in seconds).

```REST
GET https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.Insights/eventtypes/management/values?api-version=2015-04-01&$filter=eventTimestamp ge '2026-02-01T00:00:00Z' and eventTimestamp le '2026-02-28T23:59:59Z' and resourceGroupName eq '{resourceGroupName}'
Prefer: wait=75
```

# [PowerShell](#tab/powershell)

Azure PowerShell provides the [Get-AzActivityLog](/powershell/module/az.monitor/get-azactivitylog) cmdlet to retrieve activity log events scoped to a resource group over a specified time range.

```azurepowershell
$subscriptionId = 'aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e'
Set-AzContext -Subscription $subscriptionId

$activityLogParams = @{
    ResourceGroupName = 'myResourceGroup'
    StartTime         = (Get-Date).AddDays(-30)
    EndTime           = Get-Date
}

Get-AzActivityLog @activityLogParams
```

---

#### Return specific activity log properties

Use a parameter to return only specified properties, which reduces the response payload size. For more information, see [Activity log schema property descriptions](activity-log-schema.md#property-descriptions).

# [Azure Portal](#tab/azure-portal)

The Azure portal doesn't provide a way to limit the properties returned from activity log events directly. To reduce the amount of data viewed, use the **Edit columns** option in the **Activity log** blade to select which columns are displayed in the portal view.


# [Azure CLI](#tab/azure-cli)

Use the [az monitor activity-log list](/cli/azure/monitor/activity-log#az-monitor-activity-log-list) command with the `--select` parameter to specify which properties to return from activity log events.

```azurecli
az monitor activity-log list \
  --offset 30d \
  --select "eventName operationName status eventTimestamp correlationId submissionTimestamp level"
```

# [REST API](#tab/rest-api)

To list activity log events with only specific properties returned using the Azure Resource Manager REST API, include the `$select` query parameter in the `GET` request with a comma-separated list of the properties you want returned.

```http
GET https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.Insights/eventtypes/management/values?api-version=2015-04-01&$filter=eventTimestamp ge '2026-03-01T00:00:00Z' and eventTimestamp le '2026-03-29T23:59:59Z'&$select=eventName,operationName,status,eventTimestamp,correlationId,submissionTimestamp,level
```

# [PowerShell](#tab/powershell)

Limit the properties returned from activity log events in Azure PowerShell by piping the results of `Get-AzActivityLog` to `Select-Object` and specifying the properties you want returned. This doesn't reduce the API response size since `Select-Object` only filters the properties in the output that PowerShell displays. 

Use the `-MaxRecord` parameter of `Get-AzActivityLog` to limit the number of records returned. This reduces the amount of data returned.

```azurepowershell
$subscriptionId = 'aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e'
Set-AzContext -Subscription $subscriptionId

$activityLogParams = @{
    StartTime      = (Get-Date).AddDays(-30)
    EndTime        = Get-Date
    DetailedOutput = $true
    MaxRecordCount = 100
}

Get-AzActivityLog @activityLogParams | Select-Object EventName, OperationName, Status, EventTimestamp, CorrelationId, SubmissionTimestamp, Level
```

---

#### List tenant-level activity log events

Tenant-level activity log events typically have limited entries but might include important events such as management group or subscription creation. These events are separate from subscription-level activity log events, but might contain duplicate resource management events. 

Querying at this scope uses a different REST API than the subscription-level activity log events API. Azure CLI and Azure PowerShell don't provide dedicated commands.

# [Azure portal](#tab/azure-portal)

Go to **Monitor** > **Activity log** in the Azure portal. Change the **Activity** pull down menu and select **Directory Activity**. 

:::image type="content" source="media/activity-log/directory-activity-logs.png" alt-text="Screenshot showing the Directory Activity option selected in the Activity log blade in the Azure portal." lightbox="media/activity-log/directory-activity-logs.png":::

# [Azure CLI](#tab/azure-cli)

To list tenant-level activity log events, use the [az rest](/cli/azure/use-azure-cli-rest-command) Azure CLI command:

```azurecli
apiVersion="2015-04-01"
filter="\$filter=eventTimestamp ge '2026-01-15T00:00:00Z' and eventTimestamp le '2026-03-29T23:59:59Z'"
providers="Microsoft.Insights/eventtypes/management/values"

az rest --method get \
  --uri "/providers/$providers?api-version=$apiVersion&$filter" \
  --headers "Prefer=wait=75"
```

# [REST API](#tab/rest-api)

To list tenant-level activity log events, use this `GET` request. Note that this request targets the tenant-level activity log endpoint, which is different from the subscription-level activity log API.

```http
GET https://management.azure.com/providers/Microsoft.Insights/eventtypes/management/values?api-version=2015-04-01&$filter=eventTimestamp ge '2026-01-15T00:00:00Z' and eventTimestamp le '2026-03-29T23:59:59Z'
```

# [PowerShell](#tab/powershell)

A dedicated PowerShell cmdlet isn't available for tenant-level activity log events. The following example calls the REST API directly by using `Invoke-AzRestMethod`.

```azurepowershell
$apiVersion = '2015-04-01'
$startTime = '2026-01-15T00:00:00Z'
$endTime = '2026-03-29T23:59:59Z'
$providers = 'Microsoft.Insights/eventtypes/management/values'

$restParams = @{
    Method = 'GET'
    Path   = "/providers/$providers?api-version=$apiVersion" +
             "&`$filter=eventTimestamp ge '$startTime' and eventTimestamp le '$endTime'"
}

Invoke-AzRestMethod @restParams
```

---

#### List management group-level activity log events

Management group-level activity log events capture events scoped to a specific management group, such as policy assignments and management group membership changes.

# [Azure portal](#tab/azure-portal)

To view management group-level activity log events in the Azure portal, go to **Management groups** > select a management group > **Activity log**. 

:::image type="content" source="media/activity-log/management-group-scope.png" alt-text="Screenshot showing the Activity log blade for a management group in the Azure portal." lightbox="media/activity-log/management-group-scope.png":::

# [Azure CLI](#tab/azure-cli)

To list management group-level activity log events, use the [az rest](/cli/azure/use-azure-cli-rest-command) Azure CLI command. This command calls the Azure Resource Manager REST API directly to retrieve activity log events scoped to the specified management group with the `2017-03-01-preview` API version.

```azurecli
managementGroupId="myManagementGroup"
apiVersion="2017-03-01-preview"
filter="\$filter=eventTimestamp ge '2026-03-01T00:00:00Z' and eventTimestamp le '2026-03-29T23:59:59Z'"
providers="Microsoft.Insights/eventtypes/management/values"
resourceId="/providers/Microsoft.Management/managementGroups/$managementGroupId/providers/$providers"

az rest --method get --uri "$resourceId?api-version=$apiVersion&$filter" --headers "Prefer=wait=75"
```

# [REST API](#tab/rest-api)

To list management group-level activity log events, use this `GET` request against the Azure Resource Manager REST API. Replace `{managementGroupId}` with the ID of the management group you want to query, and specify the time range in the `$filter` query parameter. Note the use of the `2017-03-01-preview` API version, which is required for management group-level activity log queries.

```http
GET https://management.azure.com/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.Insights/eventtypes/management/values?api-version=2017-03-01-preview&$filter=eventTimestamp ge '2026-03-01T00:00:00Z' and eventTimestamp le '2026-03-29T23:59:59Z'
```

# [PowerShell](#tab/powershell)

A dedicated PowerShell cmdlet isn't available for management group-level activity log events. The following example calls the REST API directly by using `Invoke-AzRestMethod`.

```azurepowershell
$managementGroupId = 'myManagementGroup'
$apiVersion = '2017-03-01-preview'
$startTime = '2026-03-01T00:00:00Z'
$endTime = '2026-03-29T23:59:59Z'
$providers = 'Microsoft.Insights/eventtypes/management/values'
$resourceId = "/providers/Microsoft.Management/managementGroups/$managementGroupId/providers/$providers"

$restParams = @{
    Method = 'GET'
    Path   = "$resourceId?api-version=$apiVersion" +
             "&`$filter=eventTimestamp ge '$startTime' and eventTimestamp le '$endTime'"
}

Invoke-AzRestMethod @restParams
```

---

The following table describes the parameters used in the preceding examples.

| Parameter | Description |
|-----------|-------------|
| `{subscriptionId}` | The ID of the Azure subscription. |
| `{resourceGroupName}` | The name of the resource group. |
| `{managementGroupId}` | The ID of the management group. |
| `eventTimestamp ge` / `le` | The start and end of the time range in ISO 8601 format. The start date can't exceed 90 days from the current date unless retention is configured for longer periods. |

## View change history

For some events, you can view the change history, which shows what changes happened during that event time. Select an event from the activity log that you want to look at more deeply. Select the **Change history** tab to view any changes on the resource up to 30 minutes before and after the time of the operation.

:::image type="content" source="media/activity-log/change-history-event.png" lightbox="media/activity-log/change-history-event.png" alt-text="Screenshot that shows the Change history list for an event.":::

If any changes are associated with the event, the portal shows you a selectable list of changes. Selecting a change opens the **Change history** page. This page displays the changes to the resource. 

The following example shows that the VM changed sizes. The page displays the VM size before the change and after the change. To learn more about change history, see [Get resource changes](/azure/governance/resource-graph/how-to/get-resource-changes).

:::image type="content" source="media/activity-log/change-history-event-details.png" lightbox="media/activity-log/change-history-event-details.png" alt-text="Screenshot that shows the Change history page showing differences.":::

## Activity log insights

Activity log insights is an Azure Monitor workbook that provides a set of dashboards that monitor the changes to resources and resource groups in a subscription. The dashboards also present data about which users or services performed activities in the subscription and the activities' status. 

To enable activity log insights, export the activity log to a Log Analytics workspace as described in [Export activity log](#export-activity-log). This process sends events to the `AzureActivity` table, which activity log insights uses.


:::image type="content" source="media/activity-log/activity-logs-insights-main-screen.png" lightbox= "media/activity-log/activity-logs-insights-main-screen.png" alt-text="Screenshot that shows activity log insights dashboards.":::

You can open activity log insights at the subscription or resource level. For the subscription, select **Activity Logs Insights** from the **Workbooks** section of the **Monitor** menu.

:::image type="content" source="media/activity-log/open-activity-log-insights-workbook.png" lightbox= "media/activity-log/open-activity-log-insights-workbook.png" alt-text="Screenshot that shows how to locate and open the Activity Logs Insights workbook on a scale level.":::

For an individual resource, select **Activity Logs Insights** from the **Workbooks** section of the resource's menu.

:::image type="content" source="media/activity-log/activity-log-resource-level.png" lightbox= "media/activity-log/activity-log-resource-level.png" alt-text="Screenshot that shows how to locate and open the Activity Logs Insights workbook on a resource level.":::

## Export activity log

Create a diagnostic setting to send activity log entries to other destinations for extra retention time and functionality.

:::image type="content" source="media/diagnostic-settings/platform-logs-metrics.png" lightbox="media/diagnostic-settings/platform-logs-metrics.png" alt-text="Diagram showing collection of activity logs, resource logs, and platform metrics." border="false":::

In the Azure portal, select **Activity log** on the **Azure Monitor** menu and then select **Export Activity Logs**. For more information and other methods for creating diagnostic settings, see [Diagnostic settings in Azure Monitor](diagnostic-settings.md). Make sure you disable any [legacy configuration for the activity log](/previous-versions/azure/azure-monitor/essentials/legacy-collection-methods).


:::image type="content" source="media/diagnostic-settings/menu-activity-log.png" alt-text="Screenshot that shows the Azure Monitor menu with Activity log selected and Export activity logs highlighted in the Monitor-Activity log menu bar.":::


The following sections provide details on each configurable destination for resource logs.

> [!NOTE]
> The legacy method of exporting the activity log is log profiles. See [Legacy collection methods](/previous-versions/azure/azure-monitor/essentials/legacy-collection-methods).

### [Log Analytics workspace](#tab/log-analytics)

Send the activity log to a [Log Analytics workspace](../logs/log-analytics-workspace-overview.md) for the following functionality:

- Correlate activity logs with other log data by using [log queries](../logs/log-query-overview.md). 
- Create [log alerts](../alerts/alerts-create-log-alert-rule.md), which can use more complex logic than [activity log alerts](../alerts/alerts-create-activity-log-alert-rule.md).
- Access activity log data with [Power BI](/power-bi/transform-model/log-analytics/desktop-log-analytics-overview).
- Retain activity log data for longer than 90 days.

There are no data ingestion charges for activity logs. Retention charges for activity logs apply only to the period extended past the default retention period of 90 days. You can [increase the retention period](../logs/data-retention-configure.md) to up to 12 years.

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
> In some scenarios, values in fields of `AzureActivity` might have different case from otherwise equivalent values. When querying data in `AzureActivity`, use case-insensitive operators for string comparisons, or use a scalar function to force a field to a uniform casing before any comparisons. For example, use the [tolower()](/azure/kusto/query/tolowerfunction) function on a field to force it to always be lowercase or the [=~ operator](/azure/kusto/query/datatypes-string-operators) when performing a string comparison.

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
                    "iss": "https://sts.windows.net/aaaabbbb-0000-cccc-1111-dddd2222eeee/",
                    "iat": "1421876371",
                    "nbf": "1421876371",
                    "exp": "1421880271",
                    "ver": "1.0",
                    "http://schemas.microsoft.com/identity/claims/tenantid": "aaaabbbb-0000-cccc-1111-dddd2222eeee",
                    "http://schemas.microsoft.com/claims/authnmethodsreferences": "pwd",
                    "http://schemas.microsoft.com/identity/claims/objectidentifier": "aaaa0000-bb11-2222-33cc-444444dddddd",
                    "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/upn": "admin@contoso.com",
                    "puid": "1003BFFD8EC002D4",
                    "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier": "9vckmEGF7zDKk1YzIY8k0t1_EAPaXoeHyPRn6f413zM",
                    "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname": "John",
                    "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname": "Smith",
                    "name": "John Smith",
                    "groups": "bbbb1111-cc22-3333-44dd-555555eeeeee,aaaaaaaa-0000-1111-2222-bbbbbbbbbbbb,cccc2222-dd33-4444-55ee-666666ffffff",
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
                "serviceRequestId": "bbbbbbbb-1111-2222-3333-cccccccccccc"
            }
        }
    ]
}
```

### [Azure Storage](#tab/storage)

Send the activity log to an Azure Storage account if you want to retain your log data longer than 90 days for audit, static analysis, or backup. If you need to retain your events for 90 days or less, you don't need to set up archival to a storage account.

When you send the activity log to storage, a storage container is created in the storage account as soon as an event occurs. The blobs in the container use the following naming convention:

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
---


## Export management group activity logs

When you create a diagnostic setting for a management group, it exports Azure Monitor activity log events for that management group in addition to all management groups under it in the hierarchy. If multiple management groups in the hierarchy have diagnostic settings, you receive duplicate events. You only need a diagnostic setting on the highest level management group to capture all events for the hierarchy.

The management group also collects many of the same events as any subscriptions under it. If the subscription and management group both have diagnostic settings, you receive duplicate events. Azure Resource Manager includes a hierarchy property when writing events, but it's not a required field. Resource providers outside Azure Resource Manager don't populate it, so their events don't propagate up the hierarchy. Because of this, getting duplicate events is better than missing events.

For example, if you have MG1 which contains MG2 which contains Subscription1, a diagnostic setting on MG1 captures all activity log events for MG1, MG2, and many of the events collected by a diagnostic setting on Subscription1. In this case, no diagnostic setting is needed on MG2 since it would just collect duplicate events.

If you have duplicate events, combine them by using a query that uses a hash of all fields to identify unique records. The following example Kusto query shows a sample for logs collected in a Log Analytics workspace:

```kusto
AzureActivity
| extend Hash = hash(dynamic_to_json(pack_all()))
| summarize arg_max(TimeGenerated, *) by Hash
```

## Export the activity log to CSV

Select **Download as CSV** to export the activity log to a CSV file in the Azure portal.

:::image type="content" source="media/activity-log/export-csv.png" lightbox="media/activity-log/export-csv.png" alt-text="Screenshot that shows the Download as CSV button in the Azure portal activity log.":::

> [!IMPORTANT]
> Exporting a large number of log entries can take a long time. To improve performance, reduce the time range of the export. In the Azure portal, set the **Timespan** setting. 


You can also export the activity log to a CSV file by using PowerShell or the Azure CLI, as shown in the following examples.

# [Azure CLI](#tab/csv-azure-cli)

```azurecli
az monitor activity-log list --start-time "2024-03-01T00:00:00Z" --end-time "2024-03-15T23:59:59Z" --max-items 1000 > activitylog.json
```

# [PowerShell](#tab/csv-powershell)

```powershell
Get-AzActivityLog -StartTime 2021-12-01T10:30 -EndTime 2022-01-14T11:30 | Export-csv operations_logs.csv
```

---

The following example PowerShell script exports the activity log to CSV files in one-hour intervals, each saved to a separate file.


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

## Identify resource creation

Use the activity log to find out when the system created a resource and who created it. The activity log is the only place that stores the creator of a resource. Because the activity log only retains data for 90 days by default, you must export the logs to a location that allows you to extend the retention period, like a Log Analytics workspace. Then find the creator of a resource by querying the `AzureActivity` table. The data is retained for the duration you specified in the [retention period for this table](../logs/data-retention-configure.md).


## Related content

* [Activity log event schema](activity-log-schema.md)
* [Resource logs](resource-logs.md)
* [Diagnostic settings](diagnostic-settings.md)
