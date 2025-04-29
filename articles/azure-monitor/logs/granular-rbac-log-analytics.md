---
title: Granular RBAC in Log Analytics
description: Granular RBAC in Log Analytics enables you to define data access in a fine-grained manner.
services: azure-monitor
sub-service: logs
author: austinmccollum
ms.author: austinmc
ms.reviewer: rofrenke
ms.topic: conceptual 
ms.date: 05/08/2025


# Customer intent: As an Azure administrator, I want to understand how to use attribute-based RBAC in Log Analytics
---

# Granular RBAC (Preview)

Granular RBAC (Roles Based Access Control) is a feature of Log Analytics that enables you to finely tune data access. Define access to your data such that each user can view or query based on the conditions and expressions you specify for their role. For example, define access at the data record level to give access according to the value of a specific field. This feature allows you to maintain all your data in a single Log Analytics workspace and still provide least privilege access at any level, including records.

Granular RBAC can help you achieve various scenarios, such as
-    Data segregation: Separate the data of different units, teams, and geographical locations from within the same workspace, and ensure that each user can only access data that's relevant to them.
-    Data privacy: Protect the sensitive or confidential data of your organization, such as personal information, health records, or financial transactions, and restrict the access to only authorized users.
-    Data compliance: Use granular RBAC as tool to help you meet the regulatory or legal requirements of your industry or region. Enforce the appropriate policies and controls on the data access and usage.

Granular RBAC controls data access such as querying data. It doesn't address control plane actions, such as setting permissions for data access, workspace management, transformation, and data export. 

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

A condition is an addition to your role assignment, providing a fine-grained access control. In Log Analytics, you can set a condition on tables and records, based on the data in each record. For example, restrict access to the activity logs so that users can only see records where the `caller` column is their user ID.

A condition consists of expressions. An expression is a logic statement with the format of <attribute> <operator> <value>.

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

ABAC conditions defined for column values in Log Analytics are based on the data in that column. Only string data types can be compared. The following table shows supported ABAC operators that can be used in expressions. The equivalent Kusto operators are listed for clarity.

 ABAC operator                                          | Kusto equivalent operator | Description 
--------------------------------------------------------|---------------------------|-------------
 `StringEquals` / `StringEqualsIgnoreCase`                  | `==` / `=~`                   |Case-sensitive (or case insensitive) matching. The values must exactly match the string. 
 `StringNotEquals` / `StringNotEqualsIgnoreCase`            | `!=` / `!~`                   | Negation of StringEquals (or StringEqualsIgnoreCase). 
 `StringLike` / `StringLikeIgnoreCase`                      | `has_cs` / `has`              | Case-sensitive (or case-insensitive) matching. Right-hand-side of the operator (RHS) is a whole term in left-hand-side (LHS). 
 `StringNotLike` / `StringNotLikeIgnoreCase`                | `!has_cs` / `!has`            | Negation of StringLike (or StringLikeIgnoreCase) operator 
 `StringStartsWith` / `StringStartsWithIgnoreCase`          | `startswith_cs`/ `startswith` |     Case-sensitive (or case-insensitive) matching. The values start with the string. 
 `StringNotStartsWith`  / `StringNotStartsWithIgnoreCase`   | `!startswith_cs` / `!startswith`  | Negation of StringStartsWith (or StringStartsWithIgnoreCase) operator. 
 `ForAllOfAnyValues:StringEquals` / `ForAllOfAnyValues:StringEqualsIgnoreCase` <br><br>`ForAllOfAllValues:StringNotEquals` / `ForAllOfAllValues:StringNotEqualsIgnoreCase`<br><br>`ForAnyOfAnyValues:StringLikeIgnoreCase`    | `In` / `In~` <br><br><br> `!in` / `!in~`  <br><br><br> `has_any`                  | If every value on the left-hand side satisfies the comparison to at least one value on the right-hand side, then the expression evaluates to true. Format: ForAllOfAnyValues:<BooleanFunction>. Supports multiple strings and numbers. 

For more information on operators and terms, see [String operators](/azure/data-explorer/kusto/query/datatypes-string-operators). 
> [!TIP]
> Use transformations to enrich data, change data types, and change case to better suit your ABAC expressions. For more information, see [Data collection transformations in Azure Monitor](/azure/azure-monitor/essentials/data-collection-transformations).

### Role prerequisites

To define a condition for a role, the role must have the following actions specified:
For information on role definitions, see [Understanding Azure role definitions](/azure/role-based-access-control/role-definitions).

- Actions: `Microsoft.OperationalInsights/workspaces/query/read`. This control action grants the permission to run queries in Log Analytics and see metadata, but doesn't grant access to data.

- DataAction: `Microsoft.OperationalInsights/workspaces/tables/data/read`. This data action provides access to the data. If no condition is set, access is granted to all data at the assigned scope.

You can also include other actions in the role definition For example, the required action `Microsoft.OperationalInsights/workspaces/query/read` gives access to automated functions such as REST, to include access via the Azure portal add the `Microsoft.OperationalInsights/workspaces/read` action.


### Required permissions

To define conditions for a role, you must have a role assignment that includes the `Microsoft.Authorization/roleAssignments/write` action. Create a custom role or use one of the standard roles such as `Owner` , `Contributor`, `Role Based Access Control Administrator`, and `User Access Administrator`. For more information on roles, see [Azure built-in roles](/azure/role-based-access-control/built-in-roles).


### Limitations

Azure RBAC and ABAC have the following limits:

- <<<include ???>>>> Microsoft Sentinel: Any time data replicated from the original tables, such as hunting, bookmarks, and incidents aren't protected by the ABAC conditions.
- Alerts: Only MSI based alerts are supported.
- Application Insights: Only workspace-based Application Insights is supported.
- Values are restricted in ABAC. The following characters are supported:
    -  Alphanumeric characters
    -  Special characters:`@`, `.`, `-`
  - The maximum length of each value is  <<<<<<<<<<<<XYZ>>>>>>>>>>>> characters

 For more information, see  [Azure ABAC limits](/azure/role-based-access-control/conditions-overview#limits) and [Azure RBAC limits](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-rbac-limits).


### Audit and monitoring

Changes to role assignments are logged in Azure Activity Logs. User queries in the `LAQueryLogs` table indicate whether ABAC was effectively used in each query. Enable logs using the diagnostics settings in the Log Analytics workspace. For more information, see [Azure Monitor logs](../essentials/diagnostic-settings.md).

## Enable conditions for users with existing access

When enabling conditions for users who currently have access, you must remove any Azure role assignments for standard Azure roles assigned to the user. These assignments may override the new conditions. When removing role assignments, make sure that you only remove the assignment from the scope where you want to enforce the condition. If the user has access at the subscription scope, a restriction at workspace level is ineffective.


## Frequently Asked Questions


**My data doesn't have a column that I can use for conditions. How can I change my data to fit the conditions I wish to apply?**
Transformation can be used to create new columns with data that you can use to define conditions. For example for dat with high cardinality, such as IP ranges, use transformations to group IPs belonging to selected subnets by subnet name. For more information, see [Data collection transformations in Azure Monitor](../essentials/data-collection-transformations.md).

**I'm accessing my logs via resource context. Is my condition be enforced?**
RBAC and ABAC are enforced for resource-context queries, but require the workspaces containing the resource logs meet two prerequisites:
1.    Set all relevant workspaces' **Access control mode** to *Require workspace permissions*. 
    If set to *Use resources or workspace permissions*, the Azure read permission assigned to a resource provides access to all logs. Workspace and ABAC permissions are ignored. 
1.    Setting ABAC on all relevant workspaces

For more information, on resource context, see [Manage access to Log Analytics workspaces, access mode](../logs/manage-access.md#access-mode).

**What happens if data exported is configured for a table ?**
The ABAC conditions are only enforced on queries. Data exported using the workspace Data export feature isn't affected by ABAC conditions.

**How do you configure access based on data classification ?**

To implement [Bell-LaPadula](https://en.wikipedia.org/wiki/Bell%E2%80%93LaPadula_model) style access, you must explicitly set ABAC conditions to stick to principals such as Read Down. For example, a user with "Top-Secret" permissions must have permission explicitly set for lower levels like "Secret", "Confidential", and "Unclassified" to ensure they can access data at level that are lower than their top assigned level.

## Next steps

- [Getting started with Azure ABAC for Log Analytics Workspaces](./getting-started-abac-for-log-analytics.md)
- [Azure ABAC](/azure/role-based-access-control/conditions-overview)