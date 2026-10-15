---
title: Activity Log in Azure Monitor
description: Learn how to view, retrieve, and export Azure Monitor activity log data to Log Analytics, Azure Event Hubs, and Azure Storage for analysis and long-term retention.
ms.topic: how-to
ms.date: 05/04/2026
ms.reviewer: orens
ai-usage: ai-assisted

# customer intent: As an Azure administrator, I want to view and export activity log data so that I can audit control plane operations and retain logs beyond the default 90-day period.
---

# Activity log in Azure Monitor

Azure Monitor records management operations for your Azure resources through the activity log feature. The activity log records operations like creating a virtual machine, changing a key vault access policy, or Resource Manager deployment errors. These management operations are also called [*control plane*](/azure/azure-resource-manager/management/control-plane-and-data-plane) operations. Use the activity log to review or audit this information, or create an alert to be proactively notified when an event occurs.

In contrast to the activity log, [Azure resource logs](../logs/resource-logs.md) capture *data plane* operations performed within a resource. For example, these operations include getting a secret from a key vault or making a request to a database. Resource logs aren't collected by default and require configuration with a [diagnostic setting](../data-collection/diagnostic-settings.md).

> [!TIP]
> If a deployment operation error directs you to this article, see [Troubleshoot common Azure deployment errors](/azure/azure-resource-manager/troubleshooting/common-deployment-errors).

## Activity log entries

Azure Monitor collects activity log entries by default with no required configuration. The system generates these entries, and you can't change or delete them. Entries typically result from changes (create, update, and delete operations) or an action being initiated. The activity log doesn't typically capture read operations. 

Activity log entries are usually available for analysis and alerting within [3 to 20 minutes of the event occurring](../logs/data-ingestion-time.md#azure-metrics-resource-logs-activity-logs). For a description of activity log categories, see [Azure activity log event schema](activity-log-schema.md#categories).

## Retention period

Azure retains activity log events for *90 days* and then deletes them. You aren't charged for entries during this time, regardless of volume. For more functionality, such as longer retention, create a diagnostic setting and [collect the entries in another location](#export-activity-log) based on your needs. One of the most common reasons to extend the retention period is to preserve [resource creator information](#identify-resource-creation), which is only available in the activity log.

## View and retrieve the activity log

View activity log events for a subscription, resource group, or an individual resource. Use the Azure portal or programmatically query them by using the [Activity Log REST API](azure-monitor-rest-api-index.md#activity-log).

The Azure portal provides the **Activity log** blade from most service menus. Each of these areas also support programmatic access with REST or through specific Azure CLI and Azure PowerShell commands.

Specify a time interval of events to retrieve. To retrieve events by using the REST API, you must include the `$filter` parameter along with at least an `eventTimestamp` start value. By default, the activity log retains events for 90 days. Make sure both the start and end of your time range fall within that 90-day window. 

### Activity log access scenarios

The following sections present common scenarios showing different ways to access and retrieve activity log events through the Azure portal, programmatically using Azure CLI and Azure PowerShell, or with REST calls:

# [Portal](#tab/portal)

> [!NOTE]
> Azure portal samples provide extra context around what kind of events to expect in that view.

# [Azure CLI](#tab/cli)

> [!NOTE]
> Azure CLI samples highlight the specific commands available through the [az monitor activity-log list](/cli/azure/monitor/activity-log#az-monitor-activity-log-list) command.
>
> The native Azure CLI examples use the subscription selected in your current context. The Bash examples that call REST APIs use `jq` to URL-encode filters.

# [Azure PowerShell](#tab/powershell)

> [!NOTE]
> Azure PowerShell samples highlight the specific cmdlets available through the [Get-AzActivityLog](/powershell/module/az.monitor/get-azactivitylog) cmdlet.
>
> The native Azure PowerShell examples use the subscription selected in your current context.

# [REST](#tab/rest)

> [!NOTE]
> REST API samples show how to retrieve events by using the required `$filter` parameter with the [Activity Log REST API](azure-monitor-rest-api-index.md#activity-log).
>
> The [List activity log events for a resource group](#list-activity-log-events-for-a-resource-group) sample also demonstrates how to explicitly set a timeout for your client to match the maximum timeout period for the activity log REST API of 75 seconds by using the [`Prefer` header](../logs/api/timeouts.md#timeout-request-header).

| Supported `$filter` patterns | Details |
|------------------------------|---------|
| default subscription with a time range | `$filter=eventTimestamp ge '{startTime}' and eventTimestamp le '{endTime}'` |
| resource group | `$filter=eventTimestamp ge '{startTime}' and eventTimestamp le '{endTime}' and resourceGroupName eq '{resourceGroupName}'`|
| specific resource | `$filter=eventTimestamp ge '{startTime}' and eventTimestamp le '{endTime}' and resourceUri eq '{resourceURI}'` |
| resource provider | `$filter=eventTimestamp ge '{startTime}' and eventTimestamp le '{endTime}' and resourceProvider eq '{resourceProviderName}'` |
| correlation ID | `$filter=eventTimestamp ge '{startTime}' and eventTimestamp le '{endTime}' and correlationId eq '{correlationID}'` |

---

#### List activity log events for a subscription

Subscription level events capture events created directly by resource providers and is the default scope for listing activity log events. Tenant level and management group level events only capture Azure Resource Manager events in those hierarchies. These higher-level scopes do not include events generated directly by resource providers outside of Azure Resource Manager operations.

> [!NOTE]
> The following example retrieves activity log events for a subscription during a specific time range.

# [Portal](#tab/portal)

The menu you open **Activity log** from determines its initial filter. If you open it from the **Monitor** menu, the only filter selected by default is the subscription. This is the same as opening it from **Subscriptions** > select subscription > **Activity Log**. 

:::image type="content" source="media/activity-log/view-activity-log.png" lightbox="media/activity-log/view-activity-log.png" alt-text="Screenshot that shows the activity log." :::

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az monitor activity-log list`](/cli/azure/monitor/activity-log#az-monitor-activity-log-list) command.

**Explicit time range:**

Azure CLI supports the same kind of explicit time range as REST by using `--start-time` and `--end-time`:

```bash
# Set variables
startTime="<StartTime>"
endTime="<EndTime>"

# Retrieve activity log events
az monitor activity-log list \
  --start-time "$startTime" \
  --end-time "$endTime"
```

**Relative time range:**

Azure CLI also supports relative time ranges by using `--offset`.

> [!NOTE]
> For example, `--offset 14d` returns events from the last 14 days.

```bash
# Set variables
offset="14d"

# Retrieve activity log events
az monitor activity-log list \
  --offset "$offset"
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`Get-AzActivityLog`](/powershell/module/az.monitor/get-azactivitylog) cmdlet.

**Explicit time range:**

Azure PowerShell supports specifying an exact time range by using `StartTime` and `EndTime`, similar to REST:

```powershell
# Set variables
$startTime = [datetime]"<StartTime>"
$endTime = [datetime]"<EndTime>"

$getAzActivityLogParams = @{
    StartTime = $startTime
    EndTime   = $endTime
}

# Retrieve activity log events
Get-AzActivityLog @getAzActivityLogParams
```

**Relative time range:**

Azure PowerShell also supports querying a relative time range by using `Get-Date` expressions for `StartTime` and `EndTime`.

> [!NOTE]
> The following example returns events from the last 14 days, ending at the time the command runs.

```powershell
# Set variables
$lookbackDays = 14

$getAzActivityLogParams = @{
    StartTime = (Get-Date).AddDays(-$lookbackDays)
    EndTime   = Get-Date
}

# Retrieve activity log events
Get-AzActivityLog @getAzActivityLogParams
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest)

The following REST example uses the [`Activity Logs - List`](azure-monitor-rest-api-index.md#op-monitor-activity-logs) REST API operation.

```REST
GET https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.Insights/eventtypes/management/values?api-version={apiVersion}&$filter=eventTimestamp ge '{startTime}' and eventTimestamp le '{endTime}'
Authorization: Bearer {accessToken}
```

---

#### List activity log events for a resource group

Add `resourceGroupName` to the `$filter` to scope Azure Monitor activity log results to a specific resource group.

# [Portal](#tab/portal)

The menu you open **Activity log** from determines its initial filter. If you open it from a resource's menu, the filter is set to that resource. Select **Add Filter** to add more properties to the filter. Here are the other properties you can filter by in the portal:

* **Resource** - Items that are part of your Azure solution, such as a database or virtual machine.
* **Resource type** – The category to which a resource belongs, such as virtual machines, web apps, or databases.
* **Operation** - An action or command, such as create, delete, and write, that affects Azure Resource Manager resources.
* **Event initiated by** – Filter events by the identity that initiated the event.
* **Event category** – Filter the event types for certain operations.

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az monitor activity-log list`](/cli/azure/monitor/activity-log#az-monitor-activity-log-list) command.

> [!NOTE]
> The REST header `Prefer: wait=75` doesn't have a direct equivalent in the Azure CLI command for this operation. This command issues the query directly and returns the matching Activity Log records.

Use the [az monitor activity-log list](/cli/azure/monitor/activity-log#az-monitor-activity-log-list) command to retrieve activity log events scoped to a resource group. Specific Azure CLI commands reduce the complexity of the equivalent REST API call.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
offset="30d"

# Retrieve activity log events
az monitor activity-log list \
  --resource-group "$resourceGroupName" \
  --offset "$offset"
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`Get-AzActivityLog`](/powershell/module/az.monitor/get-azactivitylog) cmdlet.

> [!NOTE]
> The REST header `Prefer: wait=75` doesn't have a direct equivalent in the Azure PowerShell cmdlet for this operation. This command issues the query directly and returns the matching Activity Log records.

Azure PowerShell provides the [Get-AzActivityLog](/powershell/module/az.monitor/get-azactivitylog) cmdlet to retrieve activity log events scoped to a resource group over a relative time range.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$lookbackDays = 30

$getAzActivityLogParams = @{
    ResourceGroupName = $resourceGroupName
    StartTime         = (Get-Date).AddDays(-$lookbackDays)
    EndTime           = Get-Date
}

# Retrieve activity log events
Get-AzActivityLog @getAzActivityLogParams
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest)

The following REST example uses the [`Activity Logs - List`](azure-monitor-rest-api-index.md#op-monitor-activity-logs) REST API operation.

```REST
GET https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.Insights/eventtypes/management/values?api-version={apiVersion}&$filter=eventTimestamp ge '{startTime}' and eventTimestamp le '{endTime}' and resourceGroupName eq '{resourceGroupName}'
Authorization: Bearer {accessToken}
Prefer: wait=75
```

---

#### Return specific activity log properties

Use a parameter to return only specified properties, which reduces the response payload size. For more information, see [Activity log schema property descriptions](activity-log-schema.md#property-descriptions).

# [Portal](#tab/portal)

The Azure portal doesn't provide a way to limit the properties returned from activity log events directly. To reduce the amount of data viewed, use the **Edit columns** option in the **Activity log** blade to select which columns are displayed in the portal view.

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az monitor activity-log list`](/cli/azure/monitor/activity-log#az-monitor-activity-log-list) command.

Use the `--max-events` parameter of `az monitor activity-log list` to limit the number of records returned.

```bash
# Set variables
offset="30d"
maxEvents=100
selectFields=(
  eventName
  operationName
  status
  eventTimestamp
  correlationId
  submissionTimestamp
  level
)

# Retrieve activity log events
az monitor activity-log list \
  --offset "$offset" \
  --max-events "$maxEvents" \
  --select "${selectFields[@]}"
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`Get-AzActivityLog`](/powershell/module/az.monitor/get-azactivitylog) cmdlet.

Use the `-MaxRecord` parameter of `Get-AzActivityLog` to limit the number of records returned.

```powershell
# Set variables
$lookbackDays = 30
$maxRecord = 100
$selectProperties = @(
    "EventName"
    "OperationName"
    "Status"
    "EventTimestamp"
    "CorrelationId"
    "SubmissionTimestamp"
    "Level"
)

$getAzActivityLogParams = @{
    StartTime = (Get-Date).AddDays(-$lookbackDays)
    EndTime   = Get-Date
    MaxRecord = $maxRecord
}

# Retrieve activity log events
Get-AzActivityLog @getAzActivityLogParams |
    Select-Object -Property $selectProperties
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest)

The following REST example uses the [`Activity Logs - List`](azure-monitor-rest-api-index.md#op-monitor-activity-logs) REST API operation.

```REST
GET https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.Insights/eventtypes/management/values?api-version={apiVersion}&$filter=eventTimestamp ge '{startTime}' and eventTimestamp le '{endTime}'&$select=eventName,operationName,status,eventTimestamp,correlationId,submissionTimestamp,level
Authorization: Bearer {accessToken}
```

---

#### List tenant-level activity log events

Tenant-level activity log events typically have limited entries but might include important events such as management group or subscription creation. These events are separate from subscription-level activity log events, but might contain duplicate resource management events.

Querying at this scope uses a different REST API than the subscription-level activity log events API. Azure CLI and Azure PowerShell don't provide dedicated commands.

# [Portal](#tab/portal)

Go to **Monitor** > **Activity log** in the Azure portal. Change the **Activity** pull down menu and select **Directory Activity**. 

:::image type="content" source="media/activity-log/directory-activity-logs.png" alt-text="Screenshot showing the Directory Activity option selected in the Activity log blade in the Azure portal." lightbox="media/activity-log/directory-activity-logs.png":::

# [Azure CLI](#tab/cli)

The following Azure CLI example uses [az rest](/cli/azure/reference-index#az-rest) to call the [`Tenant Activity Logs - List`](azure-monitor-rest-api-index.md#op-monitor-activity-log-tenant-events) REST API operation.

```bash
# Set variables
apiVersion="<ApiVersion>"
startTime="<StartTime>"
endTime="<EndTime>"
filter="eventTimestamp ge '$startTime' and eventTimestamp le '$endTime'"
encodedFilter=$(jq -rn --arg filter "$filter" '$filter | @uri')

# Build request URL
apiEndpoint="https://management.azure.com"
provider="Microsoft.Insights/eventtypes/management/values"
queryString="?api-version=$apiVersion&\$filter=$encodedFilter"
url="$apiEndpoint/providers/$provider$queryString"

# Retrieve tenant-level activity log events
az rest --method get --url "$url"
```

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses [Invoke-AzRestMethod](/powershell/module/az.accounts/invoke-azrestmethod) to call the [`Tenant Activity Logs - List`](azure-monitor-rest-api-index.md#op-monitor-activity-log-tenant-events) REST API operation.

```powershell
# Set variables
$apiVersion = "<ApiVersion>"
$startTime = "<StartTime>"
$endTime = "<EndTime>"
$filter = "eventTimestamp ge '$startTime' and eventTimestamp le '$endTime'"
$encodedFilter = [uri]::EscapeDataString($filter)

# Build request URL
$apiEndpoint = "https://management.azure.com"
$provider = "Microsoft.Insights/eventtypes/management/values"
$queryString = "?api-version=$apiVersion&`$filter=$encodedFilter"
$url = "$apiEndpoint/providers/$provider$queryString"

$invokeAzRestMethodParams = @{
    Uri    = $url
    Method = "GET"
}

Invoke-AzRestMethod @invokeAzRestMethodParams
```

# [REST](#tab/rest)

The following REST example uses the [`Tenant Activity Logs - List`](azure-monitor-rest-api-index.md#op-monitor-activity-log-tenant-events) REST API operation.

```REST
GET https://management.azure.com/providers/Microsoft.Insights/eventtypes/management/values?api-version={apiVersion}&$filter=eventTimestamp ge '{startTime}' and eventTimestamp le '{endTime}'
Authorization: Bearer {accessToken}
```

---

#### List management group-level activity log events

Management group-level activity log events capture events scoped to a specific management group, such as policy assignments and management group membership changes.

> [!NOTE]
> * The following examples use the `2017-03-01-preview` API version, which is required for management group-level activity log queries.

# [Portal](#tab/portal)

To view management group-level activity log events in the Azure portal, go to **Management groups** > select a management group > **Activity log**. 

:::image type="content" source="media/activity-log/management-group-scope.png" alt-text="Screenshot showing the Activity log blade for a management group in the Azure portal." lightbox="media/activity-log/management-group-scope.png":::

# [Azure CLI](#tab/cli)

The following Azure CLI example uses [az rest](/cli/azure/reference-index#az-rest) to call the [`Management group activity log query`](azure-monitor-rest-api-index.md#activity-log) REST API operation.

```bash
# Set variables
apiVersion="<ApiVersion>"
managementGroupId="<ManagementGroupId>"
startTime="<StartTime>"
endTime="<EndTime>"
filter="eventTimestamp ge '$startTime' and eventTimestamp le '$endTime'"
encodedFilter=$(jq -rn --arg filter "$filter" '$filter | @uri')

# Build request URL
apiEndpoint="https://management.azure.com"
path="/providers/Microsoft.Management/managementGroups/$managementGroupId"
provider="Microsoft.Insights/eventtypes/management/values"
queryString="?api-version=$apiVersion&\$filter=$encodedFilter"
url="$apiEndpoint$path/providers/$provider$queryString"

# Retrieve management-group activity log events
az rest --method get --url "$url"
```

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses [Invoke-AzRestMethod](/powershell/module/az.accounts/invoke-azrestmethod) to call the [`Management group activity log query`](azure-monitor-rest-api-index.md#activity-log) REST API operation.

```powershell
# Set variables
$apiVersion = "<ApiVersion>"
$managementGroupId = "<ManagementGroupId>"
$startTime = "<StartTime>"
$endTime = "<EndTime>"
$filter = "eventTimestamp ge '$startTime' and eventTimestamp le '$endTime'"
$encodedFilter = [uri]::EscapeDataString($filter)

# Build request URL
$apiEndpoint = "https://management.azure.com"
$path = "/providers/Microsoft.Management/managementGroups/$managementGroupId"
$provider = "Microsoft.Insights/eventtypes/management/values"
$queryString = "?api-version=$apiVersion&`$filter=$encodedFilter"
$url = "$apiEndpoint$path/providers/$provider$queryString"

$invokeAzRestMethodParams = @{
    Method = "GET"
    Uri    = $url
}

Invoke-AzRestMethod @invokeAzRestMethodParams
```

# [REST](#tab/rest)

The following REST example uses the [`Management group activity log query`](azure-monitor-rest-api-index.md#activity-log) REST API operation.

```REST
GET https://management.azure.com/providers/Microsoft.Management/managementGroups/{managementGroupId}/providers/Microsoft.Insights/eventtypes/management/values?api-version={apiVersion}&$filter=eventTimestamp ge '{startTime}' and eventTimestamp le '{endTime}'
Authorization: Bearer {accessToken}
```

---

The following table describes the parameters used in the preceding examples.

| Variable | Example value | Purpose |
|----------|---------------|---------|
| `apiEndpoint` | `https://management.azure.com` | ARM endpoint. |
| `subscriptionId` | Current subscription | REST URL scope; native commands use the current context. |
| `resourceGroupName` | `<ResourceGroupName>` | Resource group to query. |
| `managementGroupId` | `<ManagementGroupId>` | Management group to query. |
| `apiVersion` | `<ApiVersion>` | Version for the selected operation in the [REST API index](azure-monitor-rest-api-index.md#activity-log). |

## View change history

For some events, you can view the change history, which shows what changes happened during that event time. Select an event from the activity log that you want to look at more deeply. Select the **Change history** tab to view any changes on the resource up to 30 minutes before and after the time of the operation.

:::image type="content" source="media/activity-log/change-history-event.png" lightbox="media/activity-log/change-history-event.png" alt-text="Screenshot that shows the Change history list for an event.":::

If any changes are associated with the event, the portal shows you a selectable list of changes. Selecting a change opens the **Change history** page. This page displays the changes to the resource. 

> [!NOTE]
> The following example shows that the VM changed sizes. The page displays the VM size before the change and after the change. To learn more about change history, see [Get resource changes](/azure/governance/resource-graph/how-to/get-resource-changes).

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

:::image type="content" source="../data-collection/media/diagnostic-settings/platform-logs-metrics.png" lightbox="../data-collection/media/diagnostic-settings/platform-logs-metrics.png" alt-text="Diagram showing collection of activity logs, resource logs, and platform metrics." border="false":::

In the Azure portal, select **Activity log** on the **Azure Monitor** menu and then select **Export Activity Logs**. For more information and other methods for creating diagnostic settings, see [Diagnostic settings in Azure Monitor](../data-collection/diagnostic-settings.md). Make sure you disable any [legacy configuration for the activity log](/previous-versions/azure/azure-monitor/essentials/legacy-collection-methods).


:::image type="content" source="../data-collection/media/diagnostic-settings/menu-activity-log.png" alt-text="Screenshot that shows the Azure Monitor menu with Activity log selected and Export activity logs highlighted in the Monitor-Activity log menu bar.":::


The following sections provide details on each configurable destination for resource logs.

<a name="legacy-collection-methods"></a>
<a name="managing-legacy-log-profiles"></a>

> [!NOTE]
> The legacy method of exporting the activity log is log profiles. See [Legacy collection methods](/previous-versions/azure/azure-monitor/essentials/legacy-collection-methods).

# [Log Analytics workspace](#tab/log-analytics)

Send the activity log to a [Log Analytics workspace](../logs/log-analytics-workspace-overview.md) for the following functionality:

* Correlate activity logs with other log data by using [log queries](../logs/log-query-overview.md).
* Create [log alerts](../alerts/alerts-create-log-alert-rule.md), which can use more complex logic than [activity log alerts](../alerts/alerts-create-activity-log-alert-rule.md).
* Access activity log data with [Power BI](/power-bi/transform-model/log-analytics/desktop-log-analytics-overview).
* Retain activity log data for longer than 90 days.

There are no data ingestion charges for activity logs. Retention charges for activity logs apply only to the period extended past the default retention period of 90 days. You can [increase the retention period](../logs/data-retention-configure.md) to up to 12 years.

Activity log data in a Log Analytics workspace is stored in a table called [AzureActivity](/azure/azure-monitor/reference/tables/azureactivity). The structure of this table varies depending on the [category of the log entry](activity-log-schema.md).

> [!NOTE]
> For example, to view a count of activity log records for each category, use the following query:

```kusto
AzureActivity
| summarize count() by CategoryValue
```

> [!NOTE]
> To retrieve all records in the administrative category, use the following query:

```kusto
AzureActivity
| where CategoryValue == "Administrative"
```

> [!IMPORTANT]
> In some scenarios, values in fields of `AzureActivity` might have different case from otherwise equivalent values. When querying data in `AzureActivity`, use case-insensitive operators for string comparisons, or use a scalar function to force a field to a uniform casing before any comparisons. For example, use the [tolower()](/azure/kusto/query/tolowerfunction) function on a field to force it to always be lowercase or the [=~ operator](/azure/kusto/query/datatypes-string-operators) when performing a string comparison.

# [Azure Event Hubs](#tab/event-hub)

Send the activity log to Azure Event Hubs to send entries outside of Azure, for example, to a third-party SIEM or other log analysis solutions. Activity log events from event hubs are consumed in JSON format with a `records` element that contains the records in each payload. The schema depends on the category and is described in [Azure activity log event schema](activity-log-schema.md).

> [!NOTE]
> The following sample output data is from event hubs for an activity log:

<br>
<details>
<summary>Export activity log</summary>

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
            "callerIpAddress": "192.0.2.1",
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

</details>

# [Azure Storage](#tab/storage)

Send the activity log to an Azure Storage account if you want to retain your log data longer than 90 days for audit, static analysis, or backup. If you need to retain your events for 90 days or less, you don't need to set up archival to a storage account.

When you send the activity log to storage, a storage container is created in the storage account as soon as an event occurs. The blobs in the container use the following naming convention:

```text
insights-activity-logs/resourceId=/SUBSCRIPTIONS/{subscription ID}/y={four-digit numeric year}/m={two-digit numeric month}/d={two-digit numeric day}/h={two-digit 24-hour clock hour}/m=00/PT1H.json
```

> [!NOTE]
> For example, a particular blob might have a name similar to:

```text
insights-activity-logs/resourceId=/SUBSCRIPTIONS/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/y=2020/m=06/d=08/h=18/m=00/PT1H.json
```

Each `PT1H.json` blob contains a JSON object with events from log files that were received during the hour specified in the blob URL. During the present hour, events are appended to the PT1H.json file as they're received, regardless of when they were generated. The minute value in the URL, `m=00` is always `00` as blobs are created on a per hour basis.

Each event is stored in the PT1H.json file with the following format. This format uses a common top-level schema but is otherwise unique for each category, as described in [Activity log schema](activity-log-schema.md).

```json
{
  "time": "2020-06-12T13:07:46.766Z",
  "resourceId": "/SUBSCRIPTIONS/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/RESOURCEGROUPS/MY-RESOURCE-GROUP/PROVIDERS/MICROSOFT.COMPUTE/VIRTUALMACHINES/MV-VM-01",
  "correlationId": "bbbb1111-cc22-3333-44dd-555555eeeeee",
  "operationName": "Microsoft.Resourcehealth/healthevent/Updated/action",
  "level": "Information",
  "resultType": "Updated",
  "category": "ResourceHealth",
  "properties": {
    "eventCategory": "ResourceHealth",
    "eventProperties": {
      "title": "This virtual machine is starting as requested by an authorized user or process. It will be online shortly.",
      "details": "VirtualMachineStartInitiatedByControlPlane",
      "currentHealthStatus": "Unknown",
      "previousHealthStatus": "Unknown",
      "type": "Downtime",
      "cause": "UserInitiated"
    }
  }
}
```

---

## Export management group activity logs

When you create a diagnostic setting for a management group, it exports Azure Monitor activity log events for that management group in addition to all management groups under it in the hierarchy. If multiple management groups in the hierarchy have diagnostic settings, you receive duplicate events. You only need a diagnostic setting on the highest level management group to capture all events for the hierarchy.

The management group also collects many of the same events as any subscriptions under it. If the subscription and management group both have diagnostic settings, you receive duplicate events. Azure Resource Manager includes a hierarchy property when writing events, but it's not a required field. Resource providers outside Azure Resource Manager don't populate it, so their events don't propagate up the hierarchy. Because of this, getting duplicate events is better than missing events.

> [!NOTE]
> For example, if you have MG1 which contains MG2 which contains Subscription1, a diagnostic setting on MG1 captures all activity log events for MG1, MG2, and many of the events collected by a diagnostic setting on Subscription1. In this case, no diagnostic setting is needed on MG2 since it would just collect duplicate events.

If you have duplicate events, combine them by using a query that uses a hash of all fields to identify unique records.

> [!NOTE]
> The following example Kusto query shows a sample for logs collected in a Log Analytics workspace:

```kusto
AzureActivity
| extend Hash = hash(dynamic_to_json(pack_all()))
| summarize arg_max(TimeGenerated, *) by Hash
```

## Export the activity log to a file

# [Portal](#tab/portal-2)

Select **Download as CSV** to export the activity log to a CSV file in the Azure portal.

:::image type="content" source="media/activity-log/export-csv.png" lightbox="media/activity-log/export-csv.png" alt-text="Screenshot that shows the Download as CSV button in the Azure portal activity log.":::

> [!IMPORTANT]
> Exporting a large number of log entries can take a long time. To improve performance, reduce the time range of the export. In the Azure portal, set the **Timespan** setting. 

# [Azure CLI](#tab/cli-2)

The following Azure CLI example uses the [`az monitor activity-log list`](/cli/azure/monitor/activity-log#az-monitor-activity-log-list) command.

```bash
# Set variables
startTime="<StartTime>"
endTime="<EndTime>"
maxItems=1000
outputFile="<OutputFilePath>"

# Retrieve activity log events
az monitor activity-log list \
  --start-time "$startTime" \
  --end-time "$endTime" \
  --max-items "$maxItems" \
  > "$outputFile"
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell-2)

The following Azure PowerShell example uses the [`Get-AzActivityLog`](/powershell/module/az.monitor/get-azactivitylog) cmdlet.

```powershell
# Set variables
$startTime = "<StartTime>"
$endTime = "<EndTime>"
$outputFile = "<OutputFilePath>"

$getAzActivityLogParams = @{
    StartTime = $startTime
    EndTime   = $endTime
}

# Retrieve activity log events
Get-AzActivityLog @getAzActivityLogParams |
    Export-Csv -Path $outputFile -NoTypeInformation
```

> [!NOTE]
> The following example PowerShell script exports the activity log to CSV files in one-hour intervals, each saved to a separate file.

```powershell
# Set variables
$startTime = [datetime]"<StartTime>"
$endTime = [datetime]"<EndTime>"
$outputFolder = "<OutputFolder>"
 
# Ensure output folder exists
if (-not (Test-Path $outputFolder)) {
    New-Item -Path $outputFolder -ItemType Directory
}
 
# Loop through 1-hour intervals
$currentStart = $startTime
while ($currentStart -lt $endTime) {
    $currentEnd = $currentStart.AddHours(1)
    if ($currentEnd -gt $endTime) { $currentEnd = $endTime }
    $timestamp = $currentStart.ToString("yyyyMMdd-HHmm")
    $csvFile = Join-Path $outputFolder "ActivityLog_$timestamp.csv"
 
    Write-Host "Fetching logs from $currentStart to $currentEnd..."
    Get-AzActivityLog -StartTime $currentStart -EndTime $currentEnd -ErrorAction Stop |
        Export-Csv -Path $csvFile -NoTypeInformation
 
    $currentStart = $currentEnd
}
 
Write-Host "Export completed. Files saved to $outputFolder."
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

---

## Identify resource creation

Use the activity log to find out when the system created a resource and who created it. The activity log is the only place that stores the creator of a resource. Because the activity log only retains data for 90 days by default, you must export the logs to a location that allows you to extend the retention period, like a Log Analytics workspace. Then find the creator of a resource by querying the `AzureActivity` table. The data is retained for the duration you specified in the [retention period for this table](../logs/data-retention-configure.md).

## Related content

* [Activity log event schema](activity-log-schema.md)
* [Resource logs](../logs/resource-logs.md)
* [Diagnostic settings](../data-collection/diagnostic-settings.md)
