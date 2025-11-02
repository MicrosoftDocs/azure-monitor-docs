---
title: Manage table-level access
titleSuffix: Log Analytics workspaces
description: This article explains how you to manage table-level access in a Log Analytics workspace.
services: azure-monitor
sub-service: logs
ms.topic: how-to
ms.reviewer: rofrenke
ms.date: 11/02/2025
ms.custom: devx-track-azurepowershell

# Customer intent: As an Azure Monitor Log Analytics administrator, I want to understand the best method for creating access at the table level.
---

# Manage table-level access in a Log Analytics workspace

There are three ways to manage table-level access in a Log Analytics workspace using role-based access control (RBAC). This article references all the methods, even though only granular RBAC is recommended.

- [Granular RBAC (Recommended)](#configure-granular-rbac-for-table-level-access)
- [Table-level RBAC (dual role)](#configure-table-level-access-dual-role-method)
- [Table-level RBAC (legacy)](#configure-table-level-access-legacy-method)

Granular RBAC lets you finely tune access at the table or row level. Users with table-level access can read data and query from specified tables in both the workspace and the resource context. For more information, see [Granular RBAC](granular-rbac-log-analytics.md).

## Configure granular RBAC for table-level access

Table-level access configuration using granular RBAC is less complex than earlier methods and offers the flexibility to implement row-level conditions. These steps just focus on configuring table-level access though. For more information, see [Granular RBAC](granular-rbac-log-analytics.md).

Configuring granular RBAC for table-level access requires these steps:
1. Select the built-in **Log Analytics Data Reader** role, or create a custom role
1. Build the condition for the assigned role (permissive or restrictive)

#### Create granular RBAC custom role 

The control plane "data action" differentiates granular RBAC apart from earlier methods of configuring table-level access, and it's already configured in the built-in **Log Analytics Data Reader** role. If you don't select the built-in role, follow these steps to create a custom role. For more information, see [Create granular RBAC role assignment](granular-rbac-use-case.md#assign-selected-role).

Here's the JSON for an example custom role:

```json
{    "properties": {
        "roleName": "Log Analytics Standard Table Access",
        "description": "This custom role provides general access to all non-restricted tables.",
        "assignableScopes": [
            "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/contoso-US-la-workspace"
        ],
        "permissions": [
            {
                "actions": [
                    "Microsoft.OperationalInsights/workspaces/read",
                    "Microsoft.OperationalInsights/workspaces/query/read"
                ],
                "notActions": [],
                "dataActions": [
                    "Microsoft.OperationalInsights/workspaces/tables/data/read"
                ],
                "notDataActions": []
            }
        ]
    }
}
```

Assign the role to a user or group. For more information, see [Assign granular RBAC roles](granular-rbac-log-analytics.md#conditions-and-expressions).
 
1. From the Log Analytics workspace, select **Access control (IAM)**.
1. Select **Add role assignment**.
1. Select the `Log Analytics Standard Table Access` example custom role you created, then select **Next**.
1. Select the user or group you want to assign the role to, then select **Next**. This example assigns the role to the network team security group.
1. Select **Conditions** > **Add condition** > **Add action**.
1. Choose the **Read workspace data** data action > **Select**.

#### Build permissive condition 

This example builds a permissive condition using the *Access to all data, except what isn't allowed* strategy. Access is restricted to the `SigninLogs` and `SecurityEvent` tables but access is permitted to all other tables. To see an example of a restrictive condition, see [Granular RBAC use cases](granular-rbac-use-case.md#build-restrictive-condition).
   
1. In the **Build expression** section, select **Add expression**
1. Select *Resource* from the **Attribute source** dropdown.
1. Select *Table Name* from the **Attribute** dropdown.
1. Select *ForAnyOfAllValues:StringNotEquals* from the **Operator** dropdown.
1. Type `SigninLogs` and `SecurityEvent` in the **Value** fields.

Here's how the permissive table-level access condition looks when completed.

:::image type="content" source="media/manage-access/granular-table-access-condition.png" lightbox="media/manage-access/granular-table-access-condition.png" alt-text="Screenshot of granular RBAC table-level permissive access condition.":::

With a single role assignment, table-level access is configured separating restricted tables from standard tables. For more information, see [granular RBAC considerations](granular-rbac-log-analytics.md#considerations) and [troubleshooting granular RBAC](granular-rbac-use-case.md#troubleshoot-and-monitor). 

## Configure table-level access (dual role method)

The best practice is to use the granular RBAC method instead of this method. For reference, this section outlines the steps on how the dual role method is configured. 

This method of table-level access control also uses Azure custom roles to grant users or groups access to specific tables in a workspace, but requires assigning two roles for each user or group.

| Scope | Role Description |
|---|---|
| Workspace | A custom role that provides limited permissions to read workspace details and run a query in the workspace, but not to read data from any tables|      
| Table | A **Reader** role, scoped to the specific table|

#### Build workspace role

Create a [custom role](/azure/role-based-access-control/custom-roles) at the workspace level to let users read workspace details and run a query in the workspace, without providing read access to data in any tables:

1. Navigate to your workspace and select **Access control (IAM)** > **Roles**.
1. Right-click the **Reader** role and select **Clone**.
    :::image type="content" source="media/manage-access/access-control-clone-role.png" alt-text="Screenshot that shows the Roles tab of the Access control screen with the clone button highlighted for the Reader role." lightbox="media/manage-access/access-control-clone-role.png":::
    This opens the **Create a custom role** screen.
1. On the **Basics** tab of the screen: 
    1. Enter a **Custom role name** value and, optionally, provide a description.
    1. Set **Baseline permissions** to **Start from scratch**. 
    :::image type="content" source="media/manage-access/manage-access-create-custom-role.png" alt-text="Screenshot that shows the Basics tab of the Create a custom role screen with the Custom role name and Description fields highlighted." lightbox="media/manage-access/manage-access-create-custom-role.png":::
1. Select the **JSON** tab > **Edit**:
   1. In the `"actions"` section, add these actions:
       ```json
       "Microsoft.OperationalInsights/workspaces/read",
       "Microsoft.OperationalInsights/workspaces/query/read" 
       ```
    1. In the `"not actions"` section, add:
       ```json
       "Microsoft.OperationalInsights/workspaces/sharedKeys/read"
       ```
1. Select **Save** > **Review + Create** > **Create**.
1. Select **Access control (AIM)** > **Add** > **Add role assignment**.
1. Select the custom role you created and select **Next**.
   This opens the **Members** tab of the **Add custom role assignment** screen.
1. **+ Select members** to open the **Select members** screen.
1. Search for a user > **Select**.
1. Select **Review and assign**.

The user can now read workspace details and run a query, but can't read data from any tables.

#### Assign table access role

1. From the **Log Analytics workspaces** menu, select **Tables**.
1. Select the ellipsis ( **...** ) to the right of your table and select **Access control (IAM)**.
   :::image type="content" source="media/manage-access/table-level-access-control.png" alt-text="Screenshot that shows the Log Analytics workspace table management screen with the table-level access control button highlighted." lightbox="media/manage-access/table-level-access-control.png":::
1. On the **Access control (IAM)** screen, select **Add** > **Add role assignment**.
1. Select the **Reader** role and select **Next**.
1. **+ Select members** to open the **Select members** screen.
1. 1. Search for the user > **Select**.
1. Select **Review and assign**.

The user can now read data from this specific table. Grant the user read access to other tables in the workspace, as needed. 
    
## Configure table-level access (legacy method)

The legacy method of table-level access control is no longer recommended. It doesn't support row-level conditions and is more complex than the granular RBAC method. The best practice is to use the granular RBAC method instead of this method. For reference, this section outlines the steps on how the legacy method was configured.

The legacy method of table-level also uses [Azure custom roles](/azure/role-based-access-control/custom-roles) to let you grant users or groups access to specific tables in the workspace. Azure custom roles apply to workspaces with either workspace-context or resource-context [access control modes](manage-access.md#access-control-mode) regardless of the user's [access mode](manage-access.md#access-mode).

To define access to a particular table, create a [custom role](/azure/role-based-access-control/custom-roles):

1. Set the user permissions in the **Actions** section of the role definition. 
1. Use `Microsoft.OperationalInsights/workspaces/query/*` to grant access to all tables.
1. To exclude access to specific tables when you use a wildcard in **Actions**, list the tables excluded tables in the **NotActions** section of the role definition.

Here are examples of custom role actions to grant and deny access to specific tables.

Grant access to the _Heartbeat_ and _AzureActivity_ tables:

```
"Actions":  [
    "Microsoft.OperationalInsights/workspaces/read",
    "Microsoft.OperationalInsights/workspaces/query/read",
    "Microsoft.OperationalInsights/workspaces/query/Heartbeat/read",
    "Microsoft.OperationalInsights/workspaces/query/AzureActivity/read"
  ],
```

Grant access to only the _SecurityBaseline_ table:

```
"Actions":  [
    "Microsoft.OperationalInsights/workspaces/read",
    "Microsoft.OperationalInsights/workspaces/query/read",
    "Microsoft.OperationalInsights/workspaces/query/SecurityBaseline/read"
],
```


Grant access to all tables except the _SecurityAlert_ table:

```
"Actions":  [
    "Microsoft.OperationalInsights/workspaces/read",
    "Microsoft.OperationalInsights/workspaces/query/read",
    "Microsoft.OperationalInsights/workspaces/query/*/read"
],
"notActions":  [
    "Microsoft.OperationalInsights/workspaces/query/SecurityAlert/read"
],
```

### Limitations of the legacy method related to custom tables

Custom tables store data you collect from data sources such as [text logs](../agents/data-sources-custom-logs.md) and the [HTTP Data Collector API](data-collector-api.md). To identify the table type, [view table information in Log Analytics](./log-analytics-tutorial.md#view-table-information).

Using the legacy method of table-level access, you can't grant access to individual custom log tables at the table level, but you can grant access to all custom log tables. To create a role with access to all custom log tables, create a custom role by using the following actions:

```
"Actions":  [
    "Microsoft.OperationalInsights/workspaces/read",
    "Microsoft.OperationalInsights/workspaces/query/read",
    "Microsoft.OperationalInsights/workspaces/query/Tables.Custom/read"
],
```

## Considerations

- In the Log Analytics UI, users with table-level can see the list of all tables in the workspace, but can only retrieve data from tables to which they have access.
- The standard Reader or Contributor roles, which include the _\*/read_ action, override table-level access control and give users access to all log data.
- A user with table-level access but no workspace-level permissions can access log data from the API but not from the Azure portal. 
- Administrators and owners of the subscription have access to all data types regardless of any other permission settings.
- Workspace owners are treated like any other user for per-table access control.
- Assign roles to security groups instead of individual users to reduce the number of assignments. This best practice helps you use existing group management tools to configure and verify access.

## Related content

- [Managing access to Log Analytics workspaces](manage-access.md)
- [Granular RBAC](granular-rbac-log-analytics.md)
- [Granular RBAC use cases](granular-rbac-use-case.md)
