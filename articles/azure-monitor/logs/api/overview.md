---
title: Azure Monitor Logs Query API Overview
description: Use the Logs query REST API to run KQL queries against Azure Monitor Logs, retrieve data programmatically, and integrate with your tools and workflows.
ms.topic: concept-article
ms.custom: cbo-v1.6
ms.date: 05/14/2026
ai-usage: ai-assisted
---

# Azure Monitor Logs query API overview

Query the full set of data collected by Azure Monitor Logs with the Logs query API. This REST API uses the same query language that's used throughout the service to retrieve data, build new visualizations of your data, and extend the capabilities of Log Analytics. For the broader Azure Monitor API surface, see the [Logs query](../../fundamentals/azure-monitor-rest-api-index.md#logs-query) section of the Azure Monitor REST API index.

## Query endpoint

All queries target a Log Analytics workspace. The following examples run the KQL query `AzureActivity | summarize count() by Category` over the past 12 hours to count activity log records by category.

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az monitor log-analytics query`](/cli/azure/monitor/log-analytics#az-monitor-log-analytics-query) command.

```bash
# Set variables
workspaceId="<WorkspaceId>"
query="AzureActivity | summarize count() by Category"
timespan="PT12H"

# Run the Log Analytics query
az monitor log-analytics query \
  --workspace "$workspaceId" \
  --analytics-query "$query" \
  --timespan "$timespan"
```

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`Invoke-AzOperationalInsightsQuery`](/powershell/module/az.operationalinsights/invoke-azoperationalinsightsquery) cmdlet.

```powershell
# Set variables
$workspaceId = "<WorkspaceId>"
$query = "AzureActivity | summarize count() by Category"
$timespan = New-TimeSpan -Hours 12

# Define parameters for Invoke-AzOperationalInsightsQuery
$invokeAzOperationalInsightsQueryParams = @{
    WorkspaceId = $workspaceId
    Query       = $query
    Timespan    = $timespan
}

# Run the Log Analytics query
Invoke-AzOperationalInsightsQuery @invokeAzOperationalInsightsQueryParams
```

# [REST](#tab/rest)

The following REST example uses the [`Query - Execute`](../../fundamentals/azure-monitor-rest-api-index.md#op-logs-query) REST API operation. The `v1` version is part of the URL path. This endpoint doesn't use an `api-version` query parameter.

```REST
POST https://api.loganalytics.azure.com/v1/workspaces/{workspaceId}/query
Authorization: Bearer {accessToken}
Content-Type: application/json

{
  "query": "AzureActivity | summarize count() by Category",
  "timespan": "PT12H"
}
```

---

The REST API returns a JSON response containing a `tables` array. Each table includes `columns` (the schema) and `rows` (the data). The following example shows results for the activity log query:

```json
{
  "tables": [
    {
      "name": "PrimaryResult",
      "columns": [
        { "name": "Category", "type": "string" },
        { "name": "count_", "type": "long" }
      ],
      "rows": [
        ["Administrative", 20839],
        ["Recommendation", 122],
        ["Alert", 64],
        ["ServiceHealth", 11]
      ]
    }
  ]
}
```

For the full request parameter reference (including `timespan` and cross-workspace options), see [Request format](request-format.md#query-parameters). For detailed response structure and error handling, see [Response format](response-format.md).

## Logs query API authentication

Your application must authenticate to access the Logs query API:

- To query your workspaces, you must use [Microsoft Entra authentication](/entra/fundamentals/what-is-entra).
- To quickly explore the API without using Microsoft Entra authentication, use the demo API key to query sample data in a non-production test environment.

<a name='azure-ad-authentication-for-workspace-data'></a>

### Microsoft Entra authentication for workspace data

The Logs query API supports Microsoft Entra authentication with [Microsoft Entra ID OAuth2](/entra/identity-platform/v2-oauth2-auth-code-flow). Choose the flow that fits your application:

* Authorization code (with PKCE, recommended for interactive apps)
* Client credentials (for non-interactive, service-to-service access)

The implicit grant flow is supported for backward compatibility but is no longer recommended. For new applications, use the authorization code flow with PKCE or the client credentials flow.

The authorization code flow requires at least one user interactive sign-in to your application. If you need a non-interactive flow, use the client credentials flow.

After you receive a token, the process for calling the Logs query API is the same for all flows. Requests require the `Authorization: Bearer` header, populated with the token received from the OAuth2 flow.

> [!NOTE]
> When you use Microsoft Entra authentication, it might take several minutes for the Logs query API to recognize new role-based access control permissions. While permissions are propagating, REST API calls might fail with error code 403.

### API key authentication for sample data

To quickly explore the API without using Microsoft Entra authentication, Microsoft provides a demonstration workspace with sample data. [Authenticate by using an API key](access-api.md#authenticate-with-a-demo-api-key).

## Logs query API limits

The API enforces limits on concurrency, result size, query duration, and throttling rate. These limits apply per workspace and vary depending on the query source. For the full list of thresholds, see [Query API limits](../../fundamentals/service-limits.md#log-analytics-workspaces).

## Client libraries and command-line tools

Azure Monitor supports client libraries for various programming languages. Instead of calling the REST API directly, these libraries provide a wrapper for calling the Logs query API that also handles authentication, retries, and response parsing for you. Client libraries are available for:

* [.NET](/dotnet/api/overview/azure/Monitor.Query-readme)
* [Go](https://pkg.go.dev/github.com/Azure/azure-sdk-for-go/sdk/monitor/query/azlogs)
* [Java](/java/api/overview/azure/monitor-query-readme)
* [JavaScript](/javascript/api/overview/azure/monitor-query-readme)
* [Python](/python/api/overview/azure/monitor-query-readme)

For Azure CLI and Azure PowerShell examples, see [Query endpoint](#query-endpoint).

## Try the API

To explore the API without writing code, use an API client such as [Bruno](https://www.usebruno.com/) or [Insomnia](https://insomnia.rest/) to build queries with a visual interface. You can also use [cURL](https://curl.haxx.se/) from the command line and pipe the output into [jsonlint](https://github.com/zaach/jsonlint) for readable JSON.

## Related content

* Discover available endpoints and operations in [Azure Monitor REST API index](../../fundamentals/azure-monitor-rest-api-index.md).
* Learn how to bring data into Azure Monitor by checking out [Logs Ingestion API in Azure Monitor](../logs-ingestion-api-overview.md).
* [Copy and transform data from and to a REST endpoint by using Azure Data Factory](/azure/data-factory/connector-rest?tabs=data-factory).
