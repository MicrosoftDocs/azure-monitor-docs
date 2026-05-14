---
title: Request Format for the Azure Monitor Logs Query API
description: Learn how to format GET and POST requests for the Azure Monitor Logs query API to run KQL queries. Includes REST, Azure CLI, and Azure PowerShell examples.
ms.topic: how-to
ms.date: 05/12/2026
ai-usage: ai-assisted

#customer intent: As a developer, I want to format GET and POST requests for the Azure Monitor Logs query API so that I can run KQL queries against my workspace programmatically.

---
# Request format for the Azure Monitor Logs query API

The Logs query API lets you run Kusto Query Language (KQL) queries against a Log Analytics workspace through a public REST endpoint. Retrieve or analyze log data programmatically for automation, custom reporting, or integration with other tools.

This article shows how to format `GET` and `POST` requests for the query endpoint, with examples for REST, Azure CLI, and Azure PowerShell. For the broader Azure Monitor API surface, see the [Azure Monitor REST API index](../../fundamentals/azure-monitor-rest-api-index.md#azure-monitor-logs-apis), the [Log Analytics REST API reference](../../fundamentals/azure-monitor-rest-api-index.md#log-analytics-apis), and [API access and authentication](access-api.md).

> [!NOTE]
> This article covers the public query endpoint at `api.loganalytics.azure.com`. It doesn't cover Azure Resource Manager (ARM) management operations for Log Analytics workspaces.

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

For `GET` requests, include request parameters in the query string. 

# [Azure CLI](#tab/azure-cli)

This Azure CLI command is part of the generally available `log-analytics` extension, which Azure CLI installs automatically.

```azurecli
workspaceId="myWorkspaceId"

az monitor log-analytics query \
  --workspace "$workspaceId" \
  --analytics-query "AzureActivity | summarize count() by Category" \
  --timespan "PT12H"
```

# [PowerShell](#tab/powershell)

```azurepowershell
$workspaceId = 'myWorkspaceId'
$query = 'AzureActivity | summarize count() by Category'
$logAnalyticsEndpoint = 'https://api.loganalytics.azure.com'

$invokeAzRestMethodParams = @{
    Method = 'GET'
    Uri    = "$logAnalyticsEndpoint/v1/workspaces/$workspaceId/query?query=$query"
}

Invoke-AzRestMethod @invokeAzRestMethodParams
```

> [!NOTE]
> `Invoke-AzRestMethod` doesn't support the Log Analytics query endpoint natively. Pass the full URL by using `-Uri` instead of `-Path`, and omit `-ResourceId`.

# [REST API](#tab/rest-api)

```rest
GET https://api.loganalytics.azure.com/v1/workspaces/{workspaceId}/query?query=AzureActivity%20|%20summarize%20count()%20by%20Category
Authorization: Bearer {token}
Content-Type: application/json
```

---

## POST request format

For `POST` requests, send request parameters in the JSON body.

- The request body must be valid JSON.
- Include the `Content-Type: application/json` header.
- Put request values such as `query`, `timespan`, and `workspaces` in the JSON body.
- If you specify `timespan` in both the query string and the body, the service uses the
  intersection of the two values.

# [Azure CLI](#tab/azure-cli)

The `az monitor log-analytics query` command is in the generally available `log-analytics` extension, which Azure CLI installs automatically.

```azurecli
workspaceId="myWorkspaceId"

az monitor log-analytics query \
  --workspace "$workspaceId" \
  --analytics-query "AzureActivity | summarize count() by Category"
```

> [!NOTE]
> The `az monitor log-analytics query` command always sends a POST request internally. The same command syntax works for both `GET` and `POST` query scenarios.

# [PowerShell](#tab/powershell)

```azurepowershell
$workspaceId = 'myWorkspaceId'
$logAnalyticsEndpoint = 'https://api.loganalytics.azure.com'

$body = @{
    query = 'AzureActivity | summarize count() by Category'
} | ConvertTo-Json

$invokeAzRestMethodParams = @{
    Method  = 'POST'
    Uri     = "$logAnalyticsEndpoint/v1/workspaces/$workspaceId/query"
    Payload = $body
}

Invoke-AzRestMethod @invokeAzRestMethodParams
```

# [REST API](#tab/rest-api)

```rest
POST https://api.loganalytics.azure.com/v1/workspaces/{workspaceId}/query
Authorization: Bearer {token}
Content-Type: application/json

{
  "query": "AzureActivity | summarize count() by Category"
}
```

---

## Related content

- [API access and authentication](access-api.md)
- [Response format for the Log Analytics Query API](response-format.md)
- [Azure Monitor REST API index](../../fundamentals/azure-monitor-rest-api-index.md#azure-monitor-logs-apis)

