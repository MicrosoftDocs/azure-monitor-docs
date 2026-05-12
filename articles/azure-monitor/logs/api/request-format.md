---
title: Request format for the Azure Monitor Log Analytics Query API
description: Learn how to format GET and POST requests for the Azure Monitor Log Analytics query API using REST, Azure CLI, and PowerShell.
ms.topic: how-to
ms.date: 05/12/2026
ms.custom: ai-assisted
---
# Request format for the Azure Monitor Log Analytics Query API

Use the public Log Analytics query endpoint to run KQL queries against a Log Analytics
workspace. For the broader Azure Monitor API surface, see the [Azure Monitor REST API
index](../../fundamentals/azure-monitor-rest-api-index.md), the [Log Analytics REST API
reference](/rest/api/loganalytics/), and [API access and authentication](access-api.md).

> [!NOTE]
> This article covers the public query endpoint at `api.loganalytics.azure.com`. It doesn't
> cover Azure Resource Manager (ARM) management operations for Log Analytics workspaces.

## Public query endpoint format

Use the public query endpoint in this format:

```text
https://api.loganalytics.azure.com/{apiVersion}/workspaces/{workspaceId}/query?[parameters]
```

- `apiVersion` is the public query API version. Use `v1`.
- `workspaceId` is the GUID of the Log Analytics workspace to query.
- `[parameters]` are query string values such as `query`, `timespan`, and `workspaces`.

## GET request format

When you call the endpoint with `GET`, include request parameters in the query string. Common
parameters include `query` for the KQL statement, `timespan` for the query window, and
`workspaces` for additional workspaces in cross-workspace queries.

For Azure CLI, use `az monitor log-analytics query` with `--workspace` and
`--analytics-query`. Add `--timespan` or `--workspaces` when your query needs them. The
command is provided by the GA `log-analytics` extension, which Azure CLI installs
automatically when needed.

# [Azure CLI](#tab/azure-cli)

```azurecli
workspaceId="myWorkspaceId"

az monitor log-analytics query \
  --workspace "$workspaceId" \
  --analytics-query "AzureActivity | summarize count() by Category"
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
> `Invoke-AzRestMethod` does not support the Log Analytics query endpoint natively. Pass the
> full URL by using `-Uri` instead of `-Path`, and omit `-ResourceId`.

# [REST API](#tab/rest-api)

```rest
GET https://api.loganalytics.azure.com/v1/workspaces/{workspaceId}/query
    ?query=AzureActivity%20|%20summarize%20count()%20by%20Category
Authorization: Bearer {token}
Content-Type: application/json
```

---

## POST request format

When you call the endpoint with `POST`, send request parameters in the JSON body.

- The request body must be valid JSON.
- Include the `Content-Type: application/json` header.
- Put request values such as `query`, `timespan`, and `workspaces` in the JSON body.
- If you specify `timespan` in both the query string and the body, the service uses the
  intersection of the two values.

# [Azure CLI](#tab/azure-cli)

The `az monitor log-analytics query` command is in the GA `log-analytics` extension, which
Azure CLI installs automatically when needed.

```azurecli
workspaceId="myWorkspaceId"

az monitor log-analytics query \
  --workspace "$workspaceId" \
  --analytics-query "AzureActivity | summarize count() by Category"
```

> [!NOTE]
> The `az monitor log-analytics query` command always sends a POST request internally. The
> same command syntax works for both GET and POST query scenarios.

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
