---
title: Granular RBAC (Preview)
titleSuffix: Azure Monitor Log Analytics
description: Granular RBAC in Log Analytics enables you to define data access in a fine-grained manner.
services: azure-monitor
sub-service: logs
ms.reviewer: rofrenke
ms.topic: concept-article
ms.date: 11/02/2025

# Customer intent: As an Azure administrator, I want to understand how to use attribute-based access control to granularly define access in Log Analytics workspaces.
---

# Granular RBAC (Preview) in Azure Monitor 

Granular role-based access control (RBAC) in Azure Monitor Log Analytics allows you to filter workspace data that each user can view or query, based on conditions you specify to meet your business and security needs. Benefits of this access control include:
- Row level access
- Table level access
- Separation of control and data planes

If your Log Analytics architecture includes multiple workspaces to accommodate data segregation, privacy, or compliance, granular RBAC helps simplify your topology by reducing the number of workspaces required.

## Introduction video

> [!VIDEO 661dc5e1-bbe4-4f41-8a3d-05a008becfe7]

### Prerequisites

| Action | Permission required |
|---|---|
| Create a new custom role | `Microsoft.Authorization/roleDefinitions/write` permission at the assignable scopes. </br>For example, as provided by the privileged built-in role, [User Access Administrators](/azure/role-based-access-control/built-in-roles/privileged#user-access-administrators). |
| Add or update conditions | `Microsoft.Authorization/roleAssignments/write` and `Microsoft.Authorization/roleAssignments/delete` permissions to the Log Analytics workspace. </br>For example, as provided by the privileged built-in role, [Role Based Access Control Administrator](/azure/role-based-access-control/built-in-roles/privileged#role-based-access-control-administrator). |

## When to use granular RBAC?

Granular RBAC helps you achieve the following scenarios:
- **Data segregation** - Separate the data of different units, teams, and geographical locations from within the same workspace, and ensure that each user can only access data that's relevant to their group. Access conditions use custom log fields to enforce row-level access segregated by attributes like firewall, device type, subscription ID, or other identifiers.
- **Data privacy** - Protect sensitive or confidential data, such as personal information, health records, or financial transactions, and only allow access to authorized users.
- **Data compliance** - Use granular RBAC as a tool to help you meet the regulatory or legal requirements of your industry or region. Enforce appropriate policies and controls on data access and usage.

Granular RBAC controls data access such as viewing or querying data. It doesn't address control plane actions, such as setting permissions for data access, workspace management, transformations, or data export. 

## Configure granular RBAC

Jump into granular RBAC with a [**Step by step granular RBAC example**](granular-rbac-use-case.md).

The following sections provide an overview of the key concepts and steps involved in configuring granular RBAC. 

- [Role creation](#role-selection)
- [Conditions and expressions](#conditions-and-expressions)
- [Expression operators](#expression-operators)

### Role selection

To configure granular RBAC, use the built-in role, [**Log Analytics Data Reader**](manage-access.md#log-analytics-data-reader), or create a custom role with specific, required **actions**. Then assign the selected role using **conditions**. For more information on custom roles, see [Azure custom roles](/azure/role-based-access-control/custom-roles-portal).

The minimum required action and data action permissions:

| Custom role definition | Permission | Description |
|---|---|---|
| Control plane (Actions) |`Microsoft.OperationalInsights/workspaces/query/read` | Run queries in Log Analytics and see metadata. This permission doesn't grant access to data. |
| Data plane (DataActions) | `Microsoft.OperationalInsights/workspaces/tables/data/read` | Access to the data and is the `dataaction` chosen in the role assignment condition. If no condition is set, this permission grants access to all data at the assigned scope. |

Optionally, include access to the Logs UI in the Azure portal by adding the `Microsoft.OperationalInsights/workspaces/read` control action. For more information, see [Azure RBAC control and data actions](/azure/role-based-access-control/role-definitions#control-data-actions).
 
> [!NOTE]
> Granular RBAC, like Azure RBAC, is an additive model. Your effective permissions are the sum of your role assignments. For granular RBAC conditions to take effect, you must remove any role assignments with higher access privileges. 

For example, if you have two role assignments on the same scope, one set with a `*/read` action and the other with conditions that limit access to specific records, the resulting permission is the `*/read` action granting access to all logs in the scope. There's no explicit deny action, only deny assignments.

### Conditions and expressions

Just like regular role assignments, the custom role created must be assigned to a user or group. The difference is, during the role assignment, conditions are configured to finely tune access control. 

Granular RBAC allows you to set a condition on tables and at the row level, based on the data in each record. Plan restrictions based on these two strategies:

| Access control method | Example |
|---|---|
| No access to data, except what is allowed | Restrict access to application logs so that users can only see records where the `application id` column is an application they're allowed to access. |
| Access to all data, except what isn't allowed | Allow access to all sign-in logs, except for the records where the `userPrincipalName` column is the CEO. |

A condition consists of the **data action** of the role and **expressions**. An expression is a logic statement with the format of `Attribute` `Operator` `Value`.

Values are restricted with support for the following characters:
- Alphanumeric characters
- Special characters:`@`, `.`, `-`

Log Analytics granular RBAC supports table and column/value attributes:

|Attribute source | Display Name | Type | Description | Attribute Name|
|-----------------|--------------|------|-------------|----------------|
|Resource         | Table Name   | String | Table names used to grant/limit to. | Microsoft.OperationalInsights/workspaces/tables:\`<name\>`|
|Resource         | Column value (Key is the column name) | Dictionary (Key-value) |Column name and value. Column name is the key. The data value in the column is the value. | Microsoft.OperationalInsights/workspaces/tables/record:\<key\>|

Here's an example screenshot of a granular RBAC role assignment condition using the *No access to data, except what is allowed* method [configured using the Azure portal](/azure/role-based-access-control/conditions-role-assignments-portal).

:::image type="content" source="media/granular-rbac-log-analytics/example-role-assignment.png" alt-text="Screenshot showing an example role assignment condition for Log Analytics." lightbox="media/granular-rbac-log-analytics/example-role-assignment.png":::

Reduce complexity by configuring your granular RBAC role assignments at the scope you set its conditions to match. For example, if your custom role is assigned at a resource group scope, it's possible other workspaces don't have the table or column resources specified in your expression, causing your condition to apply unexpectedly.

However, if you set a condition for a role assignment at the table level, two roles must be created like this:
- Role 1: Action: `Microsoft.OperationalInsights/workspaces/query/read` for the table's workspace.  
- Role 2: DataAction: `Microsoft.OperationalInsights/workspaces/tables/data/read` for the table within this workspace. Define the condition on the role with the data action.  

To avoid creating two roles use the simplest approach by assigning the role at the workspace and setting the conditions to control the table level.

For more information, see [Azure RBAC scope levels](/azure/role-based-access-control/scope-overview#scope-levels).

### Expression operators 

Granular RBAC expressions use a subset of attribute-based access control [(ABAC) operators](/azure/role-based-access-control/conditions-format#function-operators).

The table name attribute supports four operators. These operators give you flexibility to match the values of table names when setting a condition.

| ABAC operators | Description |
|----------------|-------------|
| `StringEquals` | Case-sensitive matching. The values must exactly match the string. |
| `StringNotEquals` | Negation of StringEquals. |
| `ForAllOfAnyValues:StringEquals` | Logically equivalent to `in()`. If every value on the left-hand side satisfies the comparison to at least one value on the right-hand side, then the expression evaluates to true. |
| `ForAllOfAllValues:StringNotEquals` | Logically equivalent to `!in()`. If every value on the left-hand side satisfies the comparison to at least one value on the right-hand side, then the expression evaluates to false. |

ABAC conditions defined for column values in Log Analytics are based on the data in that column. Only string data types can be compared. For the row-level access attribute, any casting is solely based on KQL behavior. 

The following table shows supported ABAC expression operators. The equivalent Kusto operators are listed for clarity.

| ABAC operator                                          | Kusto equivalent operator | Description |
|--------------------------------------------------------|---------------------------|-------------|
| `StringEquals` / `StringEqualsIgnoreCase`                  | `==` / `=~`                   | Case-sensitive (or case-insensitive) matching. The values must exactly match the string. |
| `StringNotEquals` / `StringNotEqualsIgnoreCase`            | `!=` / `!~`                   | Negation of StringEquals (or StringEqualsIgnoreCase). |
| `StringLike` / `StringLikeIgnoreCase`                      | `has_cs` / `has`              | Case-sensitive (or case-insensitive) matching. Right-hand-side of the operator (RHS) is a whole term in left-hand-side (LHS). |
| `StringNotLike` / `StringNotLikeIgnoreCase`                | `!has_cs` / `!has`            | Negation of StringLike (or StringLikeIgnoreCase) operator |
| `StringStartsWith` / `StringStartsWithIgnoreCase`          | `startswith_cs`/ `startswith` | Case-sensitive (or case-insensitive) matching. The value starts with the string. |
| `StringNotStartsWith`  / `StringNotStartsWithIgnoreCase`   | `!startswith_cs` / `!startswith`  | Negation of StringStartsWith (or StringStartsWithIgnoreCase) operator. |
| `ForAllOfAnyValues:StringEquals` / `ForAllOfAnyValues:StringEqualsIgnoreCase` <br><br>`ForAllOfAllValues:StringNotEquals` / `ForAllOfAllValues:StringNotEqualsIgnoreCase`<br><br>`ForAnyOfAnyValues:StringLikeIgnoreCase`    | `In` / `In~` <br><br><br> `!in` / `!in~`  <br><br><br> `has_any`                  | 'ForAllOfAnyValues:\<BooleanFunction\>' supports multiple strings and numbers. </br>If every value on the left-hand side satisfies the comparison to at least one value on the right-hand side, then the expression evaluates to true.|

ABAC conditions aren't set on functions directly. If you set the condition on a table, then it will propagate up to any function that relies on it. For more information on operators and terms, see [String operators](/azure/data-explorer/kusto/query/datatypes-string-operators).

> [!TIP]
> Use transformations to enrich data, change data types, and change case to better suit your ABAC expressions. If your data doesn't support the conditions you want to apply, transformations are also the solution. For example, to apply conditions to data with high cardinality, such as IP ranges, use transformations to group IPs belonging to selected subnets by subnet name. 
>
> For more information, see [Data collection transformations in Azure Monitor](../essentials/data-collection-transformations.md).

## Considerations

Several considerations apply when using granular RBAC in Log Analytics. The following sections provide specifics.
- Granular RBAC is available in the public cloud, Azure Commercial (GCC) and Azure China.

### Azure Monitor

- Search Jobs and Summary Rules are planned for granular RBAC support, but not Data Export. For all of these experiences, if full access doesn't exist to the queried tables, the user isn't able to configure the search job or rule and receives an error.
- Alerts: Only managed identity based log alerts are supported.
- Application Insights: Only workspace-based Application Insights are supported.

### Microsoft Sentinel

When data is replicated from original tables using hunting, bookmarks, analytics rule, and incidents, the replicated data isn't protected by the ABAC conditions.

### Azure ABAC and RBAC

Normal Azure RBAC and ABAC limitations apply. For example, the threshold of max role assignments per subscription is an Azure service limit for RBAC. Azure ABAC limits the number of expressions per condition and the overall size of the condition in KB. For more information, see the following articles:
- [Azure RBAC limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-rbac-limits)
- [Azure ABAC limits](/azure/role-based-access-control/conditions-overview#limits)
- [FAQ for Azure role assignment conditions](/azure/role-based-access-control/conditions-faq)
- [Troubleshoot Azure RBAC limits](/azure/role-based-access-control/troubleshoot-limits)

## Audit and monitoring

Changes to role assignments are logged in Azure Activity Logs. User queries in the `LAQueryLogs` table indicate whether the query was executed with an applicable ABAC access condition in the [`ConditionalDataAccess` column](../reference/tables/laquerylogs.md#columns). Enable logs using the diagnostics settings in the Log Analytics workspace. For more information, see [Azure Monitor logs diagnostic settings](../essentials/diagnostic-settings.md).


## Frequently Asked Questions

**I'm accessing my logs via resource context. Can my condition be enforced?**</br>
RBAC and ABAC are enforced for resource-context queries, but require the workspaces containing the resource logs to fulfill these prerequisites:
- Set all relevant workspaces' **Access control mode** to *Require workspace permissions*. </br>If set to *Use resources or workspace permissions*, the Azure read permission assigned to a resource provides access to all logs. Workspace and ABAC permissions are ignored. 
- Set ABAC on all relevant workspaces.

For more information, see [Manage access to Log Analytics workspaces, access mode](../logs/manage-access.md#access-mode).

**Do granular RBAC conditions persist when a table is exported?**</br>
Granular RBAC conditions are only enforced on queries. For example, data successfully exported using the workspace data export feature doesn't maintain the ABAC conditions on the target table's data.

**How do you configure access based on data classification?**</br>
To implement the *Bell-LaPadula* style access model, you must explicitly set ABAC conditions to stick to principals such as *read down*. For example, a user with top-secret permissions must have permission explicitly set for lower levels like secret, confidential, and unclassified to ensure they can access data at levels lower than their top assigned level.

## Related content

- [Granular RBAC use case for Log Analytics Workspaces](granular-rbac-use-case.md)
- [Manage access to Log Analytics workspaces](manage-access.md)
- [Azure ABAC](/azure/role-based-access-control/conditions-overview)
