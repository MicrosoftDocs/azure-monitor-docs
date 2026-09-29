---
title: Upgrade Legacy Rules Management to the Current Azure Monitor Scheduled Query Rules API
description: Learn how to switch log search alert management to ScheduledQueryRules API.
ms.topic: upgrade-and-migration-article
ms.date: 04/24/2026
ai-usage: ai-assisted
ms.custom: references_regions, cbo-v1.6
---

# Upgrade to the Scheduled Query Rules API from the legacy Log Analytics Alert API

> [!IMPORTANT]
> The [announced](https://azure.microsoft.com/updates/switch-api-preference-log-alerts/) retirement date for the Log Analytics Alert API was October 1, 2025. Transition to the Scheduled Query Rules API for log search alerts.
> Log Analytics workspaces created after June 1, 2019 use the [scheduledQueryRules API](/rest/api/monitor/scheduledqueryrule-2021-08-01/scheduled-query-rules) to manage log search alert rules. [Switch to the current API](./alerts-log-api-switch.md) in older workspaces to take advantage of Azure Monitor scheduledQueryRules [benefits](./alerts-log-api-switch.md#benefits).
> Once you migrate rules to the [scheduledQueryRules API](/rest/api/monitor/scheduledqueryrule-2021-08-01/scheduled-query-rules), you cannot revert back to the older [legacy Log Analytics Alert API](/azure/azure-monitor/alerts/api-alerts).
> This API retirement has no impact on Log search alert rules created using scheduledQueryRules API versions 2018-04-16 or newer.

In the past, users used the [legacy Log Analytics Alert API](/azure/azure-monitor/alerts/api-alerts) to manage log search alert rules. Currently workspaces use the [Scheduled Query Rules API](/rest/api/monitor/scheduledqueryrule-2021-08-01/scheduled-query-rules) for new rules. This article describes the benefits and the process of switching legacy log search alert rules management from the legacy API to the current API.

## Benefits

* Manage all log search alert rules in one API.
* Single template for creation of alert rules (previously needed three separate templates).
* Single API for all Azure resources log alerting.
* Support for stateful (preview) and 1-minute log search alerts.
* [PowerShell cmdlets](/azure/azure-monitor/alerts/alerts-manage-alerts-previous-version#manage-log-alerts-by-using-powershell) and [Azure CLI](/azure/azure-monitor/alerts/alerts-log#manage-log-alerts-using-cli) support for switched rules.
* Alignment of severities with all other alert types and newer rules.
* Ability to create a [cross workspace log alert](/azure/azure-monitor/logs/cross-workspace-query) that spans several external resources like Log Analytics workspaces or Application Insights resources for switched rules.
* Users can specify dimensions to split the alerts for switched rules.
* Log search alerts have an extended period of up to two days of data (previously limited to one day) for switched rules.

## Impact

* All switched rules must be created/edited with the current API. See [sample use via Azure Resource Template](/azure/azure-monitor/alerts/alerts-log-create-templates) and [sample use via PowerShell](/azure/azure-monitor/alerts/alerts-manage-alerts-previous-version#manage-log-alerts-by-using-powershell).
* As rules become Azure Resource Manager tracked resources in the current API and must be unique, the resource IDs for the rules change to this structure: `<WorkspaceName>|<savedSearchId>|<scheduleId>|<ActionId>`. Display names for the alert rules remain unchanged.

## Process

View workspaces to upgrade using this [Azure Resource Graph Explorer query](https://portal.azure.com/?feature.customportal=false#blade/HubsExtension/ArgQueryBlade/query/resources%0A%7C%20where%20type%20%3D~%20%22microsoft.insights%2Fscheduledqueryrules%22%0A%7C%20where%20properties.isLegacyLogAnalyticsRule%20%3D%3D%20true%0A%7C%20distinct%20tolower%28properties.scopes%5B0%5D%29). Open the [link](https://portal.azure.com/?feature.customportal=false#blade/HubsExtension/ArgQueryBlade/query/resources%0A%7C%20where%20type%20%3D~%20%22microsoft.insights%2Fscheduledqueryrules%22%0A%7C%20where%20properties.isLegacyLogAnalyticsRule%20%3D%3D%20true%0A%7C%20distinct%20tolower%28properties.scopes%5B0%5D%29), select all available subscriptions, and run the query.

The process of switching isn't interactive and doesn't require manual steps, in most cases. Your alert rules aren't stopped or stalled, during or after the switch.

The following examples call the legacy workspace `alertsversion` endpoint, which uses API version `2017-04-26-preview`. This version is separate from the Scheduled Query Rules API versions used to manage migrated rules.

Use one of the following methods to switch all alert rules associated with each Log Analytics workspace:

# [Azure CLI](#tab/cli)

The following Azure CLI example uses [az rest](/cli/azure/reference-index#az-rest) to call the [`Alerts Version - Put`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-alerts-version) REST API operation.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"
apiVersion="<ApiVersion>"
payloadFile="./alert-version.json"

# Get the subscription ID from the current Azure CLI context
subscriptionId=$(az account show --query id --output tsv)

# Build request URL
apiEndpoint="https://management.azure.com"
path="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
provider="Microsoft.OperationalInsights/workspaces/$workspaceName"
queryString="?api-version=$apiVersion"
url="$apiEndpoint$path/providers/$provider/alertsversion$queryString"

# Switch alert rules to the scheduledQueryRules API
az rest --method put --url "$url" --body "@$payloadFile"
```

Use the following JSON for `alert-version.json`:

```json
{
  "scheduledQueryRulesEnabled": true
}
```

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses [Invoke-AzRestMethod](/powershell/module/az.accounts/invoke-azrestmethod) to call the [`Alerts Version - Put`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-alerts-version) REST API operation.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$workspaceName = "<WorkspaceName>"
$apiVersion = "<ApiVersion>"

# Get the subscription ID from the current Azure PowerShell context
$subscriptionId = (Get-AzContext).Subscription.Id

# Build request URL
$apiEndpoint = "https://management.azure.com"
$path = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
$provider = "Microsoft.OperationalInsights/workspaces/$workspaceName"
$queryString = "?api-version=$apiVersion"
$url = "$apiEndpoint$path/providers/$provider/alertsversion$queryString"

# Build request body
$body = @{
    scheduledQueryRulesEnabled = $true
} | ConvertTo-Json

# Define parameters for Invoke-AzRestMethod
$invokeAzRestMethodParams = @{
    Method  = "PUT"
    Uri     = $url
    Payload = $body
}

# Switch alert rules to the scheduledQueryRules API
Invoke-AzRestMethod @invokeAzRestMethodParams
```

# [REST](#tab/rest)

The following REST example uses the [`Alerts Version - Put`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-alerts-version) REST API operation.

```REST
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/alertsversion?api-version={apiVersion}
Authorization: Bearer {accessToken}
Content-Type: application/json

{
  "scheduledQueryRulesEnabled": true
}
```

---

If the switch is successful, the response is:

```json
{
  "version": 2,
  "scheduledQueryRulesEnabled": true
}
```

## Check switching status of workspace

Use one of the following methods to check the switch status. These examples use the same legacy `alertsversion` API version as the switch operation.

# [Azure CLI](#tab/cli)

The following Azure CLI example uses [az rest](/cli/azure/reference-index#az-rest) to call the [`Alerts Version - Get`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-alerts-version) REST API operation.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"
apiVersion="<ApiVersion>"

# Get the subscription ID from the current Azure CLI context
subscriptionId=$(az account show --query id --output tsv)

# Build request URL
apiEndpoint="https://management.azure.com"
path="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
provider="Microsoft.OperationalInsights/workspaces/$workspaceName"
queryString="?api-version=$apiVersion"
url="$apiEndpoint$path/providers/$provider/alertsversion$queryString"

# Check the switching status
az rest --method get --url "$url"
```

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses [Invoke-AzRestMethod](/powershell/module/az.accounts/invoke-azrestmethod) to call the [`Alerts Version - Get`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-alerts-version) REST API operation.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$workspaceName = "<WorkspaceName>"
$apiVersion = "<ApiVersion>"

# Get the subscription ID from the current Azure PowerShell context
$subscriptionId = (Get-AzContext).Subscription.Id

# Build request URL
$apiEndpoint = "https://management.azure.com"
$path = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
$provider = "Microsoft.OperationalInsights/workspaces/$workspaceName"
$queryString = "?api-version=$apiVersion"
$url = "$apiEndpoint$path/providers/$provider/alertsversion$queryString"

# Define parameters for Invoke-AzRestMethod
$invokeAzRestMethodParams = @{
    Method = "GET"
    Uri    = $url
}

# Check the switching status
Invoke-AzRestMethod @invokeAzRestMethodParams
```

# [REST](#tab/rest)

The following REST example uses the [`Alerts Version - Get`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-alerts-version) REST API operation.

```REST
GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/alertsversion?api-version={apiVersion}
Authorization: Bearer {accessToken}
```

---

If the Log Analytics workspace was switched to [scheduledQueryRules API](/rest/api/monitor/scheduledqueryrule-2021-08-01/scheduled-query-rules), the response is:

```json
{
  "version": 2,
  "scheduledQueryRulesEnabled": true
}
```

If the Log Analytics workspace wasn't switched, the response is:

```json
{
  "version": 2,
  "scheduledQueryRulesEnabled": false
}
```

## Next steps

* Learn about the [Azure Monitor log search alerts](/azure/azure-monitor/alerts/alerts-types).
* Learn how to [manage your log search alerts using the API](/azure/azure-monitor/alerts/alerts-log-create-templates).
* Learn how to [manage your log search alerts using PowerShell](/azure/azure-monitor/alerts/alerts-manage-alerts-previous-version#manage-log-alerts-by-using-powershell).
* Learn more about the [Azure Alerts experience](/azure/azure-monitor/alerts/alerts-overview).
