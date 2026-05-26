---
title: "Configure Protected Tables in Azure Monitor Logs"
description: "Learn how to set up protected tables in Azure Monitor Logs to isolate sensitive data and control access using RBAC, ABAC conditions, and the Privileged Monitoring Data Reader role."
author: austinmccollum
ms.author: austinmc
ms.date: 05/26/2026
ms.topic: how-to
ms.service: azure-monitor
ms.subservice: logs
---

# Configure protected tables in Azure Monitor Logs (preview)

This article walks you through setting a table's protection level, granting access to authorized users, and verifying that your configuration works as expected. Protected tables use a "deny by default" model so that standard read roles cannot access sensitive data until you explicitly grant permission through ABAC conditions.

## Prerequisites

| Requirement | Details |
|---|---|
| Azure subscription | An active Azure subscription with a [Log Analytics workspace](./quick-create-workspace.md). |
| Permissions | Owner or [Log Analytics Contributor](/azure/role-based-access-control/built-in-roles/analytics#log-analytics-contributor) role on the workspace. You need the `Microsoft.OperationalInsights/workspaces/tables/protectionLevel/write` action to change a table's protection level. |
| RBAC and ABAC familiarity | Understanding of [Azure RBAC](/azure/role-based-access-control/overview) and [ABAC conditions](/azure/role-based-access-control/conditions-overview). For background on ABAC in Log Analytics, see [Granular RBAC in Azure Monitor](granular-rbac-log-analytics.md). |

## Set a table's protection level

Setting a table's protection level to `Protected` immediately prevents standard read roles from accessing the data in that table. Complete these steps for each table that contains sensitive telemetry.

### [Azure portal](#tab/portal-1)

1. In the Azure portal, go to **Log Analytics workspaces** and select your workspace.
1. Under **Settings**, select **Tables**.
1. Find the table you want to protect and select the ellipsis (**...**) menu.
1. Select **Manage table**.
1. Under **Protection level**, select **Protected**.
1. Select **Save**.

<!-- Placeholder: screenshot of protection level setting in the Tables blade -->

### [Azure CLI](#tab/azure-cli-1)

Use the following command to set a table's protection level to `Protected` by using the CLI.

```azurecli
# User input
subscriptionId="aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
resourceGroupName="myResourceGroupName"
workspaceName="myWorkspaceName"
tableName="myTableName"

# Build request URL
apiEndpoint="https://management.azure.com"
path="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
provider="Microsoft.OperationalInsights/workspaces/$workspaceName/tables/$tableName"
url="$apiEndpoint$path/providers/$provider?api-version=2025-02-01"

az rest --method patch --url "$url" \
  --body '{"properties": {"protectionLevel": "Protected"}}'
```

### [REST API](#tab/rest-1)

To update the table's protection level, use this `PATCH` request for the [Tables - Update](/rest/api/loganalytics/tables/update) operation. Use the latest `apiVersion` documented there.

```REST
PATCH https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/tables/{tableName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
Content-Type: application/json

{
  "properties": {
    "protectionLevel": "Protected"
  }
}
```

A successful response returns the table definition with `protectionLevel` set to `Protected`:

```json
{
  "properties": {
    "protectionLevel": "Protected",
    "schema": { ... },
    "retentionInDays": 30
  }
}
```

---

| Placeholder | Value |
|---|---|
| `{subscriptionId}` | Your Azure subscription ID. |
| `{resourceGroupName}` | The resource group that contains your workspace. |
| `{workspaceName}` | Your Log Analytics workspace name. |
| `{tableName}` | The table to protect (for example, `SecurityEvent`). |

## Grant access to protected tables

After you protect a table, you must explicitly grant access to users who need the data. You can use the built-in Privileged Monitoring Data Reader role for broad access, or create custom ABAC conditions for more targeted grants.

### Assign the Privileged Monitoring Data Reader role

The **Privileged Monitoring Data Reader** built-in role grants read access to all protected tables at the assigned scope.

#### [Azure portal](#tab/portal-2)

1. In the Azure portal, go to the scope where you want to assign the role (subscription, resource group, or workspace).
1. Select **Access control (IAM)** > **Add** > **Add role assignment**.
1. On the **Role** tab, search for **Privileged Monitoring Data Reader** and select it.
1. On the **Members** tab, select the user, group, or managed identity.
1. Select **Review + assign**.

#### [Azure CLI](#tab/azure-cli-2)

Use the following command to assign the Privileged Monitoring Data Reader role by using the CLI.

```azurecli
# User input
subscriptionId="aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
resourceGroupName="myResourceGroupName"
workspaceName="myWorkspaceName"
assigneeObjectId="myAssigneeObjectId"

scope="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
scope+="/providers/Microsoft.OperationalInsights/workspaces/$workspaceName"

az role assignment create \
  --assignee "$assigneeObjectId" \
  --role "Privileged Monitoring Data Reader" \
  --scope "$scope"
```

---

| Placeholder | Value |
|---|---|
| `assigneeObjectId` | The Microsoft Entra object ID of the user or group. |
| `subscriptionId` | Your Azure subscription ID. |
| `resourceGroupName` | The resource group that contains your workspace. |
| `workspaceName` | Your Log Analytics workspace name. |

### Grant access to specific protected tables only

For scenarios where you need to limit access to individual protected tables rather than all of them, create a custom role assignment with ABAC conditions that filter on both table name and protection level.

1. Create or select a custom role with the following DataAction:

    ```
    Microsoft.OperationalInsights/workspaces/tables/data/read
    ```

1. When creating the role assignment, add a condition with two expressions joined by **AND**:

    | Expression | Attribute | Operator | Value |
    |---|---|---|---|
    | 1 | `Microsoft.OperationalInsights/workspaces/tables:name` | `StringEquals` | The specific table name (for example, `AppTraces`) |
    | 2 | `Microsoft.OperationalInsights/workspaces/tables:protectionLevel` | `StringEquals` | `Protected` |

    The condition in ABAC format looks like this:

    ```
    (
      (
        !(ActionMatches{'Microsoft.OperationalInsights/workspaces/tables/data/read'})
      )
      OR
      (
        @Resource[Microsoft.OperationalInsights/workspaces/tables:name] StringEquals 'AppTraces'
        AND
        @Resource[Microsoft.OperationalInsights/workspaces/tables:protectionLevel] StringEquals 'Protected'
      )
    )
    ```

    Adjust the table name and operator as needed. For access to multiple tables, use `ForAllOfAnyValues:StringEquals` with a list of table names. For more details on expression syntax, see [Granular RBAC in Azure Monitor](granular-rbac-log-analytics.md#conditions-and-expressions).

### Grant time-bound access with PIM

Use [Microsoft Entra Privileged Identity Management (PIM)](/entra/id-governance/privileged-identity-management/pim-configure) to grant just-in-time, time-limited access to protected tables.

1. In PIM, create an **eligible assignment** for the Privileged Monitoring Data Reader role (or your custom role) at the desired scope.
1. Set the maximum activation duration according to your organization's policy.
1. When users need access, they activate the role in PIM. Access is automatically revoked when the activation window expires.

This pattern works well for incident response and support scenarios where engineers need temporary access to sensitive logs.

## Enable DataAction-only mode

By default, some control-plane roles (such as Reader and Monitoring Reader) provide implicit read access to log data. DataAction-only mode closes this path so that only DataActions govern data access.

### [Azure CLI](#tab/azure-cli-3)

Use the following command to enable DataAction-only mode by using the CLI.

```azurecli
# User input
subscriptionId="aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e"
resourceGroupName="myResourceGroupName"
workspaceName="myWorkspaceName"

# Build request URL
apiEndpoint="https://management.azure.com"
path="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
provider="Microsoft.OperationalInsights/workspaces/$workspaceName"
url="$apiEndpoint$path/providers/$provider?api-version=2025-02-01"

az rest --method patch --url "$url" \
  --body '{"properties": {"features": {"dataAuthorizationMode": "DataActionsOnly"}}}'
```

### [REST API](#tab/rest-3)

To enable DataAction-only mode, use this `PATCH` request for the [Workspaces - Update](/rest/api/loganalytics/workspaces/update) operation. Use the latest `apiVersion` documented there.

```REST
PATCH https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
Content-Type: application/json

{
  "properties": {
    "features": {
      "dataAuthorizationMode": "DataActionsOnly"
    }
  }
}
```

---

| Placeholder | Value |
|---|---|
| `{subscriptionId}` | Your Azure subscription ID. |
| `{resourceGroupName}` | The resource group that contains your workspace. |
| `{workspaceName}` | Your Log Analytics workspace name. |

After you enable DataAction-only mode, verify that users who previously relied on control-plane roles for log access now receive appropriate DataAction-based role assignments.

## Verify your configuration

Run these checks to confirm that protection and access grants are working correctly.

### Confirm that non-privileged users see no data

1. Sign in as a user who has the Log Analytics Reader role but does not have the Privileged Monitoring Data Reader role or a custom role with a `protectionLevel` condition.
1. Open the workspace in the Azure portal and go to **Logs**.
1. Run a query against the protected table:

    ```kusto
    ProtectedTableName
    | take 10
    ```

1. Confirm that the query succeeds but returns zero rows.

### Confirm that privileged users see data

1. Sign in as a user who has the Privileged Monitoring Data Reader role or an appropriate custom role with ABAC conditions.
1. Run the same query.
1. Confirm that the query returns data rows.

### Check Activity Log for configuration changes

Open **Activity Log** for the workspace and filter by the operation name **Update Table**. Look for entries that show changes to the `protectionLevel` property. These entries confirm when and by whom tables were protected.

## Related content

- [Manage access to Log Analytics workspaces](manage-access.md)
- [Granular RBAC in Azure Monitor](granular-rbac-log-analytics.md)
- [Manage table-level access in a Log Analytics workspace](manage-table-access.md)
