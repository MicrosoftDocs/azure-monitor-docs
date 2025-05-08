---
title: Granular RBAC in Log Analytics
description: Granular RBAC in Log Analytics enables you to define data access in a fine-grained manner.
services: azure-monitor
sub-service: logs
ms.reviewer: rofrenke
ms.topic: conceptual 
ms.date: 05/08/2025


# Customer intent: As an Azure administrator, I want to understand how to use attribute-based RBAC in Log Analytics
---

# Granular RBAC (Preview)

Granular Role Based Access Control (RBAC) is a feature of Log Analytics that enables you to finely tune data access. Define customized roles to view or query your workspace data based on the conditions and expressions you specify for authorized users. For example, define access at the row level based on the table and record values. This feature simplifies your workspace architecture by reducing the need for multiple workspaces.

Here are a just a few scenarios where granular RBAC really excels:
- **Data segregation** - Separate the data of different units, teams, and geographical locations from within the same workspace, and ensure that each user can only access data that's relevant to their group. Access conditions use custom log fields to enforce row-level access segregated by attributes like firewall, device type, subscription ID or other identifiers.
- **Data privacy** - Protect sensitive or confidential data, such as personal information, health records, or financial transactions, and allow access to only authorized users.
- **Data compliance** - Use granular RBAC as tool to help you meet the regulatory or legal requirements of your industry or region. Enforce the appropriate policies and controls on the data access and usage.

Granular RBAC controls data access such as querying data. It doesn't address control plane actions, such as setting permissions for data access, workspace management, transformations, and data export. 

> [!NOTE]
> Azure RBAC is an additive model. Your effective permissions are the sum of your role assignments. For example, if a you have two role assignments on the same scope, one set with a */read action and the other with conditions that limit access to specific records, the applicable permission is */read action granting access to all logs in this scope. For the conditions to take effect, you must remove the role assignment with higher access privileges. 

## Azure ABAC

Azure Log Analytics granular RBAC is based on Azure ABAC (Attribute Based Access Control). Azure ABAC extends the functionality of Azure RBAC by incorporating conditions to role assignments that depend on contextual attributes for particular actions. For more information on ABAC, see [Azure ABAC](/azure/role-based-access-control/conditions-overview).

Azure ABAC is supported in the following environments:

- [Azure portal](/azure/role-based-access-control/conditions-role-assignments-portal)
- [Azure CLI](/azure/role-based-access-control/conditions-role-assignments-cli)
- [PowerShell](/azure/role-based-access-control/conditions-role-assignments-powershell)
- [Azure Resource Manager templates](/azure/role-based-access-control/conditions-role-assignments-template)
- [Azure REST API](/azure/role-based-access-control/conditions-role-assignments-rest)
- [Terraform](https://www.terraform.io)


### Conditions and expressions

A condition is an addition to your role assignment, providing finely tuned access control. In Log Analytics, you can set a condition on tables and records, based on the data in each record. For example, restrict access to the activity logs so that users can only see records where the `caller` column is their user ID.

A condition consists of expressions. An expression is a logic statement with the format of `attribute` `operator` `value`.

Values are restricted with support for the following characters:
- Alphanumeric characters
- Special characters:`@`, `.`, `-`
- The maximum length of each value is also limited.

Log Analytics granular RBAC supports table and column/value attributes:

Attribute source | Display Name | Type | Description | Attribute Name
-----------------|--------------|------|-------------|----------------
Resource         | Table Name   | String | Table names used to grant/limit to. | Microsoft.OperationalInsights/ workspaces/tables:name
Resource         | Column value (Key is the column name) | Dictionary (Key-value) |Column name and value. Column name is the key. The data value in the column is the value. | Microsoft.OperationalInsights /workspaces/tables/record:<Key><case_sensitive column name>

Conditions are added at same scope as the role assignments you wish to set it for. Set the condition at a scope of a table, workspace, or subscription. 

When setting a condition at the table level, two roles must be created as follows:
- Role 1: Action: `Microsoft.OperationalInsights/workspaces/query/read` for the table's workspace.  

- Role 2: DataAction: `Microsoft.OperationalInsights/workspaces/tables/data/read` for the table within this workspace.  
Define the condition on the role with the data action.  

To avoid creating two roles, set the conditions at a higher level, such as Workspace and set the condition to control the table level.  
  
> [!NOTE] 
> If a condition is set on a column that doesn't exactly match an existing column name, access is denied for the role assignments following a least privilege principle. 

### ABAC expression operators 

ABAC conditions defined for column values in Log Analytics are based on the data in that column. Only string data types can be compared. For the row level access attribute, any casting is solely based on KQL behavior. 

The following table shows supported ABAC operators that can be used in expressions. The equivalent Kusto operators are listed for clarity.

 ABAC operator                                          | Kusto equivalent operator | Description 
--------------------------------------------------------|---------------------------|-------------
 `StringEquals` / `StringEqualsIgnoreCase`                  | `==` / `=~`                   | Case-sensitive (or case insensitive) matching. The values must exactly match the string. 
 `StringNotEquals` / `StringNotEqualsIgnoreCase`            | `!=` / `!~`                   | Negation of StringEquals (or StringEqualsIgnoreCase). 
 `StringLike` / `StringLikeIgnoreCase`                      | `has_cs` / `has`              | Case-sensitive (or case-insensitive) matching. Right-hand-side of the operator (RHS) is a whole term in left-hand-side (LHS). 
 `StringNotLike` / `StringNotLikeIgnoreCase`                | `!has_cs` / `!has`            | Negation of StringLike (or StringLikeIgnoreCase) operator 
 `StringStartsWith` / `StringStartsWithIgnoreCase`          | `startswith_cs`/ `startswith` | Case-sensitive (or case-insensitive) matching. The values start with the string. 
 `StringNotStartsWith`  / `StringNotStartsWithIgnoreCase`   | `!startswith_cs` / `!startswith`  | Negation of StringStartsWith (or StringStartsWithIgnoreCase) operator. 
 `ForAllOfAnyValues:StringEquals` / `ForAllOfAnyValues:StringEqualsIgnoreCase` <br><br>`ForAllOfAllValues:StringNotEquals` / `ForAllOfAllValues:StringNotEqualsIgnoreCase`<br><br>`ForAnyOfAnyValues:StringLikeIgnoreCase`    | `In` / `In~` <br><br><br> `!in` / `!in~`  <br><br><br> `has_any`                  | 'ForAllOfAnyValues:BooleanFunction'. Supports multiple strings and numbers.</br>If every value on the left-hand side satisfies the comparison to at least one value on the right-hand side, then the expression evaluates to true.  

ABAC conditions aren't set on functions directly. If you set the condition on a table, then it will propagate up to any function that relies on it. For more information on operators and terms, see [String operators](/azure/data-explorer/kusto/query/datatypes-string-operators).

> [!TIP]
> Use transformations to enrich data, change data types, and change case to better suit your ABAC expressions. If your data doesn't support the conditions you want to apply, transformations are also solution. For example, to apply conditions to data with high cardinality, such as IP ranges, use transformations to group IPs belonging to selected subnets by subnet name. For more information, see [Data collection transformations in Azure Monitor](../essentials/data-collection-transformations.md).

### Role prerequisites

To define a condition for a role, the role must have the following actions specified:
For information on role definitions, see [Understanding Azure role definitions](/azure/role-based-access-control/role-definitions).

- Actions: `Microsoft.OperationalInsights/workspaces/query/read`. This control action grants the permission to run queries in Log Analytics and see metadata, but doesn't grant access to data.

- DataAction: `Microsoft.OperationalInsights/workspaces/tables/data/read`. This data action provides access to the data. If no condition is set, access is granted to all data at the assigned scope.

You can also include other actions in the role definition For example, the required action `Microsoft.OperationalInsights/workspaces/query/read` gives access to automated functions such as REST, to include access via the Azure portal add the `Microsoft.OperationalInsights/workspaces/read` action.


### Required permissions

To define conditions for a role, you must have a role assignment that includes the `Microsoft.Authorization/roleAssignments/write` action. Create a custom role or use one of the standard roles such as `Owner` , `Contributor`, `Role Based Access Control Administrator`, and `User Access Administrator`. For more information on roles, see [Azure built-in roles](/azure/role-based-access-control/built-in-roles).


### Service limits

#### Azure ABAC and RBAC

Normal Azure RBAC and ABAC limitations apply. For example, the threshold of max role assignments per subscription is an Azure service limit for RBAC. Azure ABAC limits the number of expressions per condition and the overall size of the condition in KB. For more information, see the following articles:
- [Azure RBAC limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-rbac-limits)
- [Azure ABAC limits](/azure/role-based-access-control/conditions-overview#limits)
- [FAQ for Azure role assignment conditions](/azure/role-based-access-control/conditions-faq)
- [Troubleshoot Azure RBAC limits](/azure/role-based-access-control/troubleshoot-limits)

#### Log Analytics 

- **Data Export** - if full access doesn't exist, a clear error indicates the user isn't able to configure the rule.
- Alerts: Only MSI based alerts are supported.
- Application Insights: Only workspace-based Application Insights are supported.

#### Microsoft Sentinel

Any time data replicated from the original tables, such as hunting, bookmarks, and incidents aren't protected by the ABAC conditions.

### Audit and monitoring

Changes to role assignments are logged in Azure Activity Logs. User queries in the `LAQueryLogs` table indicate whether ABAC was effectively used by recording the evaluation steps in the [`ConditionalDataAccess` column](../reference/tables/laquerylogs.md#columns). Enable logs using the diagnostics settings in the Log Analytics workspace. For more information, see [Azure Monitor logs](../essentials/diagnostic-settings.md).

## Enable conditions for users with existing access

When enabling conditions for users who currently have access, you must remove any Azure role assignments for standard Azure roles assigned to the user. These assignments may override the new conditions. When removing role assignments, make sure that you only remove the assignment from the scope where you want to enforce the condition. If the user has access at the subscription scope, a restriction at workspace level is ineffective.


## Frequently Asked Questions

**I'm accessing my logs via resource context. Can my condition be enforced?**</br>
RBAC and ABAC are enforced for resource-context queries, but require the workspaces containing the resource logs to fulfill these prerequisites:
1.  Set all relevant workspaces' **Access control mode** to *Require workspace permissions*. 
    If set to *Use resources or workspace permissions*, the Azure read permission assigned to a resource provides access to all logs. Workspace and ABAC permissions are ignored. 
1.  Set ABAC on all relevant workspaces.

For more information, on resource context, see [Manage access to Log Analytics workspaces, access mode](../logs/manage-access.md#access-mode).

**What happens if data exported is configured for a table?**</br>
ABAC conditions are only enforced on queries. Data successfully exported using the workspace **Data export** feature doesn't maintain the ABAC conditions from the original data.

**How do you configure access based on data classification?**</br>
To implement the **Bell-LaPadula** style access model, you must explicitly set ABAC conditions to stick to principals such as *read down*. For example, a user with **top-secret** permissions must have permission explicitly set for lower levels like **secret**, **confidential**, and **unclassified** to ensure they can access data at levels lower than their top assigned level.

## Next steps

- [Getting started with Azure ABAC for Log Analytics Workspaces](./getting-started-abac-for-log-analytics.md)
- [Azure ABAC](/azure/role-based-access-control/conditions-overview)