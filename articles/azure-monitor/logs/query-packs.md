---
title: Query packs in Azure Monitor Logs
description: Query packs in Azure Monitor provide a way to share collections of log queries in multiple Log Analytics workspaces.
ms.subservice: logs
ms.topic: how-to
ms.reviewer: roygal
ms.date: 08/07/2026
ai-usage: ai-assisted

---

# Query packs in Azure Monitor Logs
Query packs act as containers for log queries in Azure Monitor. They let you save log queries and share them across workspaces and other contexts in Log Analytics.

## Permissions
Set the permissions on a query pack when you view it in the Azure portal. Two role contexts apply, depending on whether you use queries within an existing query pack or create a new query pack.

To use or modify queries in an existing query pack, assign one of the following roles on the query pack:

- **Reader**: See and run all queries in the query pack.
- **Contributor**: Modify existing queries and add new queries to the query pack.

Creating a new query pack requires a different role, assigned at a broader scope.

> [!IMPORTANT]
> To create a query pack, assign the user the Log Analytics Contributor role at the resource group scope.

## View query packs
View and manage query packs in the Azure portal from the **Log Analytics query packs** menu. Select a query pack to view and edit its permissions.
:::image type="content" source="media/query-packs/view-query-pack.png" lightbox="media/query-packs/view-query-pack.png" alt-text="Screenshot that shows query packs." border="false":::

## Default query pack
Azure Monitor automatically creates a query pack called `DefaultQueryPack` in each subscription in a resource group called `LogAnalyticsDefaultResources` when you save your first query. Save queries to this query pack or create other query packs depending on your requirements.

## Use multiple query packs

The default query pack is sufficient for most users to save and reuse queries. Create multiple query packs for users in your organization if, for example, you want to load different sets of queries in different Log Analytics sessions and provide different permissions for different collections of queries.

When you [create a new query pack](#create-a-query-pack), add tags that classify queries based on your business needs. For example, tag a query pack to relate it to a particular department in your organization or to the severity of issues that the included queries are meant to address. Tags let you create different sets of queries intended for different sets of users and different situations.

To add query packs to your Log Analytics workspace:

1. Open Log Analytics and select **Queries** in the upper-right corner.
1. In the upper-left corner on the **Queries** dialog, next to **Query packs**, click **Select query packs** or **0 selected**.
1. Select the query packs that you want to add to the workspace.

:::image type="content" source="media/query-packs/log-analytics-add-query-pack.png" alt-text="Screenshot that shows the Select query packs page in Log Analytics, where you can add query packs to a Log Analytics workspace." lightbox="media/query-packs/log-analytics-add-query-pack.png":::

> [!IMPORTANT]
> A Log Analytics workspace supports up to five query packs.

## Create a query pack
This article describes how to create a query pack by using the REST API. Alternatively, create a query pack from the **Log Analytics query packs** pane in the Azure portal. To open the **Log Analytics query packs** pane in the portal, select **All services** > **Other**.

> [!NOTE]
> Queries saved in [query packs](query-packs.md) aren't encrypted with a customer-managed key. Select **Save as Legacy query** when saving queries instead, to protect them with your customer-managed key.

### Create a token for the query pack API
The API request requires a token for authentication. Get a token by using either of the following methods.

One method is to use the Azure CLI:

```azurecli
az account get-access-token --resource https://management.azure.com
```

Another method is to use [ARMClient](https://github.com/projectkudu/ARMClient), an open-source command-line tool. First, sign in to Azure:

```
armclient login
```

Then create the token. The token is automatically copied to the clipboard, ready to paste into another tool.

```
armclient token
```

### Create a query pack payload
The query pack is an Azure resource that contains queries. Its payload specifies the Azure region and optional resource tags. The query pack name is part of the request URI.

```json
{
    "location": "eastus",
    "properties": {},
    "tags": {
        "Department": "IT"
    }
}
```

### Create a query pack request
Use the following request with the query pack payload to create or replace a query pack. Use bearer token authorization and the `application/json` content type.

```rest
PUT https://management.azure.com/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/queryPacks/my-query-pack?api-version=2025-07-01
```

For the complete operation reference, see [Query Packs - Create Or Update](/rest/api/loganalytics/query-packs/create-or-update?view=rest-loganalytics-2025-07-01&preserve-view=true).

## Add a query to a query pack

Create a unique query ID, such as a UUID, and use it in the request URI. The query payload is separate from the query pack payload.

```json
{
    "properties": {
        "displayName": "All events",
        "description": "Returns event records.",
        "body": "Event",
        "related": {
            "categories": [
                "workloads"
            ],
            "resourceTypes": [
                "microsoft.insights/components"
            ],
            "solutions": [
                "logmanagement"
            ]
        },
        "tags": {
            "Environment": [
                "Production"
            ]
        }
    }
}
```

Each query in the query pack has the following properties:

| Property | Description |
| :--- | :--- |
| `displayName` | Unique display name for the query within the query pack. |
| `description` | Description of the query displayed in Log Analytics. |
| `body` | Query written in Kusto Query Language. |
| `related` | Related categories, resource types, and solutions for the query. Used for grouping and filtering in Log Analytics to help locate the query. Each query can have up to 10 values of each type. Retrieve allowed values from the [metadata endpoint](https://api.loganalytics.io/v1/metadata) by selecting `resourceTypes`, `solutions`, and `categories`. |
| `tags` | Tags used for sorting and filtering in Log Analytics. Each tag is added to Category, Resource Type, and Solution when you [group and filter queries](queries.md#find-and-filter-queries). |

Submit the query payload with this request:

```rest
PUT https://management.azure.com/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/queryPacks/my-query-pack/queries/11111111-1111-1111-1111-111111111111?api-version=2025-07-01
```

For the complete operation reference, see [Queries - Put](/rest/api/loganalytics/queries/put?view=rest-loganalytics-2025-07-01&preserve-view=true).

## Update a query
To update an existing query, submit the complete query payload with a `PATCH` request. Use the query ID from the query resource URI.

```rest
PATCH https://management.azure.com/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/queryPacks/my-query-pack/queries/11111111-1111-1111-1111-111111111111?api-version=2025-07-01
```

For the complete operation reference, see [Queries - Update](/rest/api/loganalytics/queries/update?view=rest-loganalytics-2025-07-01&preserve-view=true).

## Next steps

See [Using queries in Azure Monitor Log Analytics](queries.md) to see how users interact with query packs in Log Analytics.
