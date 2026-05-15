---
title: Request Format for the Azure Monitor Logs Query API
description: Learn how to format GET and POST requests for the Azure Monitor Logs query API to run KQL queries. Includes REST, Azure CLI, and Azure PowerShell examples.
ms.topic: how-to
ms.date: 05/15/2026
ai-usage: ai-assisted

#customer intent: As a developer, I want to format GET and POST requests for the Azure Monitor Logs query API so that I can run KQL queries against my workspace programmatically.
---

# Request format for the Azure Monitor Logs query API

The Logs query API lets you run Kusto Query Language (KQL) queries against a Log Analytics workspace through a public REST endpoint. Retrieve or analyze log data programmatically for automation, custom reporting, or integration with other tools.

This article shows how to format `GET` and `POST` requests for the Logs query API endpoint, including direct REST examples and equivalent Azure CLI and Azure PowerShell commands.

For the broader Azure Monitor API surface, see the [Azure Monitor REST API index](../../fundamentals/azure-monitor-rest-api-index.md#azure-monitor-apis).

## Public query endpoint format

The public Logs query API endpoint has this format:

`https://api.loganalytics.azure.com/{apiVersion}/workspaces/{workspaceId}/query?[parameters]`

- `apiVersion` is the public query API version. Use `v1`.
- `workspaceId` is the GUID of the Log Analytics workspace to query.
- `[parameters]` are query string values such as `query`, `timespan`, and `workspaces`.

## Query parameters

Pass these parameters in the query string for `GET` requests or in the JSON body for `POST` requests.

| Parameter | Required | Description |
|-----------|----------|-------------|
| `query` | Yes | The KQL query to run. |
| `timespan` | No | The time range for the query. Use an ISO 8601 duration (for example, `PT12H` for 12 hours) or a start/end pair separated by `/` (for example, `2024-01-01/2024-01-02`). If omitted, the query runs against all available data. |
| `workspaces` | No | Additional workspace IDs to include in a [cross-workspace query](../cross-workspace-query.md). |

## GET request format

For `GET` requests, include request parameters in the query string. For example, to count `AzureActivity` events by `Category` over the last 12 hours, use the following request:

# [Azure CLI](#tab/cli)

Use `az rest` to call the Logs query API directly.

```azurecli
subscriptionId="aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
workspaceId="myWorkspaceId"
encodedQuery="AzureActivity%20%7C%20summarize%20count%28%29%20by%20Category"
timespan="PT12H"
logsQueryApiEndpoint="https://api.loganalytics.azure.com"
resourceId="$logsQueryApiEndpoint/v1/workspaces/$workspaceId/query"

az account set --subscription "$subscriptionId"

az rest \
  --method get \
  --uri "$resourceId?query=$encodedQuery&timespan=$timespan" \
  --resource "$logsQueryApiEndpoint"
```

Alternatively, Azure CLI supports this operation using the [az monitor log-analytics query](/cli/azure/monitor/log-analytics) command. It's part of the generally available `log-analytics` extension, which Azure CLI installs automatically.

```azurecli
subscriptionId="aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
workspaceId="myWorkspaceId"
query="AzureActivity | summarize count() by Category"
timespan="PT12H"

az account set --subscription "$subscriptionId"

az monitor log-analytics query \
  --workspace "$workspaceId" \
  --analytics-query "$query" \
  --timespan "$timespan"
```

# [PowerShell](#tab/powershell)

Use `Invoke-AzRestMethod` to call the Logs query API directly.

```azurepowershell
$subscriptionId = 'aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e'
$workspaceId = 'myWorkspaceId'
$query = 'AzureActivity | summarize count() by Category'
$encodedQuery = [System.Uri]::EscapeDataString($query)
$timespan = 'PT12H'
$logsQueryApiEndpoint = 'https://api.loganalytics.azure.com'
$resourceId = "$logsQueryApiEndpoint/v1/workspaces/$workspaceId/query"

Set-AzContext -Subscription $subscriptionId

$restParams = @{
    Method     = 'GET'
    Uri        = "${resourceId}?query=$encodedQuery&timespan=$timespan"
    ResourceId = $logsQueryApiEndpoint
}

$response = Invoke-AzRestMethod @restParams
$results = $response.Content | ConvertFrom-Json
$results.tables
```

Alternatively, Azure PowerShell supports this operation using the [Invoke-AzOperationalInsightsQuery](/powershell/module/az.operationalinsights/invoke-azoperationalinsightsquery) cmdlet (from the [Az.OperationalInsights](/powershell/module/az.operationalinsights/) module). It handles authentication and JSON serialization automatically.

```azurepowershell
$subscriptionId = 'aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e'
$workspaceId = 'myWorkspaceId'
$query = 'AzureActivity | summarize count() by Category'
$timespan = New-TimeSpan -Hours 12

Set-AzContext -Subscription $subscriptionId

$queryParams = @{
    WorkspaceId = $workspaceId
    Query       = $query
    Timespan    = $timespan
}

$results = Invoke-AzOperationalInsightsQuery @queryParams
$results.Results
```

> [!TIP]
> Use `-IncludeStatistics` to return query performance data, or `-Wait` to set a server-side timeout in seconds.

# [REST](#tab/rest)

```REST
GET https://api.loganalytics.azure.com/v1/workspaces/{workspaceId}/query?query=AzureActivity%20%7C%20summarize%20count%28%29%20by%20Category&timespan=PT12H
Authorization: Bearer {accessToken}
```

---

## POST request format

For `POST` requests, send request parameters in the JSON body.

- The request body must be valid JSON.
- Include the `Content-Type: application/json` header.
- Put request values such as `query`, `timespan`, and `workspaces` in the JSON body.
- If you specify `timespan` in both the query string and the body, the service uses the
  intersection of the two values.

# [Azure CLI](#tab/cli)

Use `az rest` to call the Logs query API directly.

```azurecli
subscriptionId="aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
workspaceId="myWorkspaceId"
logsQueryApiEndpoint="https://api.loganalytics.azure.com"
resourceId="$logsQueryApiEndpoint/v1/workspaces/$workspaceId/query"
payloadFile="./query-payload.json"

az account set --subscription "$subscriptionId"

az rest \
  --method post \
  --uri "$resourceId" \
  --resource "$logsQueryApiEndpoint" \
  --headers Content-Type=application/json \
  --body @"$payloadFile"
```

**Payload file (query-payload.json):**

```json
{
  "query": "AzureActivity | summarize count() by Category",
  "timespan": "PT12H"
}
```

Alternatively, use the [az monitor log-analytics query](/cli/azure/monitor/log-analytics) command which abstracts the HTTP request format and works for both `GET` and `POST` query scenarios. See the [GET request format](#get-request-format) section for a command sample.

# [PowerShell](#tab/powershell)

Use `Invoke-AzRestMethod` to call the Logs query API directly.

```azurepowershell
$subscriptionId = 'aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e'
$workspaceId = 'myWorkspaceId'
$logsQueryApiEndpoint = 'https://api.loganalytics.azure.com'
$resourceId = "$logsQueryApiEndpoint/v1/workspaces/$workspaceId/query"
$payloadFile = './query-payload.json'

Set-AzContext -Subscription $subscriptionId

$restParams = @{
    Method     = 'POST'
    Uri        = $resourceId
    ResourceId = $logsQueryApiEndpoint
    Payload    = Get-Content -Raw -Path $payloadFile
}

Invoke-AzRestMethod @restParams
```

**Payload file (query-payload.json):**

```json
{
  "query": "AzureActivity | summarize count() by Category",
  "timespan": "PT12H"
}
```

Alternatively, use the [Invoke-AzOperationalInsightsQuery](/powershell/module/az.operationalinsights/invoke-azoperationalinsightsquery) cmdlet which abstracts the HTTP request format and works for both `GET` and `POST` query scenarios. See the [GET request format](#get-request-format) section for a cmdlet sample.

# [REST API](#tab/rest)

```rest
POST https://api.loganalytics.azure.com/v1/workspaces/{workspaceId}/query
Authorization: Bearer {accessToken}
Content-Type: application/json

{
  "query": "AzureActivity | summarize count() by Category",
  "timespan": "PT12H"
}
```

---

## Related content

- [API access and authentication](access-api.md)
- [Response format for the Log Analytics Query API](response-format.md)
- [Azure Monitor REST API index](../../fundamentals/azure-monitor-rest-api-index.md#azure-monitor-logs-apis)
