---
title: Cross workspace queries
description: The API supports the ability to query across multiple workspaces.
ms.date: 07/07/2026
ms.topic: how-to
---
# Cross workspace queries

The API supports querying across multiple workspaces. You can execute these queries in two ways: implicit and explicit. The implicit method automatically unions data from the requested workspace. The explicit method gives you more precision and control over how you access data from each workspace.

You can include up to 100 Log Analytics workspaces or classic Application Insights resources in a single cross-resource query. For more information, see [Cross-resource query considerations](../cross-workspace-query.md#considerations).

## Resource identifiers

For both implicit and explicit cross-workspace queries, specify the resources you want to access. Use one of these four types of identifiers:

 - Name - human-readable string \<workspaceName\> of the Log Analytics workspace
 - Qualified Name - string with format \<subscriptionName\>/\<resourceGroup\>/\<workspaceName\>
 - Workspace ID - GUID string
 - Azure Resource ID - string with format /subscriptions/\<subscriptionId\>/resourceGroups/\<resourceGroup\>/providers/  microsoft.operationalinsights/workspaces/\<workspaceName\>

> [!NOTE]
> To remove ambiguity and improve performance, identify a workspace by its unique Workspace ID or Azure Resource ID.

## Implicit cross workspace queries

For implicit syntax, specify the workspaces that you want to include in your query scope. The API performs a single query over each application provided in your list. The syntax for a cross-workspace POST is:

Example:

```
    POST https://api.loganalytics.azure.com/v1/workspaces/00000000-0000-0000-0000-000000000000/query
    
    Authorization: Bearer <user token>
    Content-Type: application/json
    
    {
       "query": "union * | where TimeGenerated > ago(1d) | summarize count() by Type, TenantId",
       "workspaces": ["AIFabrikamDemo1", "AIFabrikamDemo2"]
    }
```

The same request as a GET (line breaks for readability of query parameters):

```
    GET https://api.loganalytics.azure.com/v1/workspaces/00000000-0000-0000-0000-000000000000/query?query=union+*+%7C+where+TimeGenerated+%3E+ago(1d)+%7C+summarize+count()+by+Type%2C+TenantId&workspaces=AIFabrikamDemo1%2CAIFabrikamDemo2
    
    
    Authorization: Bearer <user token>
    Content-Type: application/json
```

This query runs over AIFabrikamDemo1, AIFabrikamDemo2, and the workspace represented by the GUID 00000000-0000-0000-0000-000000000000, and returns the union of the results. In the GET version, the workspaces query parameter is a comma-separated list of resources to query.

## Explicit cross workspace queries

In some cases, you might want the query to operate over a more targeted subset of the data in the workspaces of interest, combining data from multiple workspaces. In these cases, explicitly mention a workspace and table in the query, similar to making cross-cluster or cross-database queries or joins between tables.

The syntax to reference another application is: `workspace('identifier').table`.

Example:

```
    POST https://api.loganalytics.azure.com/v1/workspaces/00000000-0000-0000-0000-000000000000/query
    Content-Type: application/json
    Authorization: Bearer <user token>
    
    {
    "query": "union (AzureActivity | where timestamp > ago(1d)), (workspaces('00000000-0000-0000-0000-000000000000').AzureActivity | where timestamp> ago(1d))"
    }
```

You can also URL encode this query and make it a GET request. In this case, there's no query parameter for other workspaces since the workspaces get referenced from inside the query.

## Throttling

For rate limiting, one cross-resource query counts as one API query, regardless of the number of resources in the query.
