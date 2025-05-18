---
title: Configure Granular Role-based Access Control (Preview)
titleSuffix: Azure Monitor Log Analytics
description: Learn how to use granular RBAC in Azure Monitor Log Analytics including a step-by-step example of configuring row-level access.
services: azure-monitor
sub-service: logs
ms.reviewer: rofrenke
ms.topic: how-to
ms.date: 05/12/2025


# Customer intent: As an Azure administrator, I want to understand how to use granular RBAC in Log Analytics for the use case scenario of separating custom log table access at the row level.
---

# Configure granular RBAC (Preview) in Azure Monitor

Granular role-based access control (RBAC) is a feature of Azure Monitor Log Analytics that implements fine-grained data access control. 

Learn how to control access to logs based on roles, departments, and geographical locations. This includes scenarios like restricting HR personnel to employee data or limiting access to logs by country or department. 

In this example scenario, custom log tables and fields are used to enforce row-level access. Data is segregated based on attributes like device type and user principal name (UPN).

For more information about granular RBAC concepts, see [Granular role-based access control (RBAC) in Azure Monitor](granular-rbac-log-analytics.md).

## Prerequisites

The following prerequisites are required to complete this scenario:

- Azure Log Analytics workspace (optionally enabled for Microsoft Sentinel) with custom log tables and fields
- A role assigned to your account giving permission to create custom roles and assign them to users or groups like the [Role Based Access Control Administrator](/azure/role-based-access-control/built-in-roles/#role-based-access-control-administrator) or [User Access Administrator](/azure/role-based-access-control/built-in-roles/privileged#user-access-administrator).

## Define the scenario

In this scenario, row-level access control is implemented for the `CommonSecurityLog` and `SigninLogs` tables in a Microsoft Sentinel workspace. Conditions are set for a group of operators as follows:

1. Remove operators' `read` access from higher level scopes for the operators.
1. Set group access to most tables with general data access using the *Access to all data, except what is not allowed* strategy.
1. Set row-level access to network team members to have access to the `CommonSecurityLog` table, but restricted to only the records that match network devices using the *No access to data, except what is allowed* strategy.
1. Allow security tier 1 analysts access to the entire `CommonSecurityLog` table, but restrict access to the `SigninLogs` table to prevent accessing records for the UPN of the CEO by theme (UPN).

## Create custom roles

Setup custom roles for the scenario. Create one with general data access, but no access to the restricted tables. Then create one for the network team and another for the security team. For more information, see [Configure granular RBAC role creation](granular-rbac-log-analytics.md#role-creation).

1. From the resource group containing the prerequisite Log Analytics workspace, select **Access control (IAM)**.
1. Select **Add custom role**.
1. Create the general data access role with the following actions and data action at the resource group level:  

   | Custom role definition | Detail |
   |---|---|
   | Actions | `Microsoft.OperationalInsights/workspaces/query/read`</br>`Microsoft.OperationalInsights/workspaces/read` |
   | Data actions | `Microsoft.OperationalInsights/workspaces/tables/data/read` |

   :::image type="content" source="media/configure-granular-rbac/custom-role-example.png" alt-text="Screenshot showing how the custom role actions and data actions appear.":::

1. Enter a name for the custom role, such as `Log Analytics Data Access`
1. Repeat steps 2-4 for the `Log Analytics Network Device team` and `Log Analytics Security Analysts tier 1` custom roles. Use the **Clone a role** option and choose the `Log Analytics Data Access` role as a base.

## Assign custom roles

Assign the custom roles to a user or group. For more information, see [Assign granular RBAC roles](granular-rbac-log-analytics.md#conditions-and-expressions). 

The first custom role uses the *Access to all data, except what is not allowed* strategy.

1. From Log Analytics workspace, select **Access control (IAM)**.
1. Select **Add role assignment**.
1. Select the  `Log Analytics Network Device team` custom role you created, then select **Next**.
1. Select the user or group you want to assign the role to, then select **Next**. For this example, assign the role to the group of users.

1. Select the **Conditions** tab.

## Add condition

Another paragraph is about stuff here.

1. Select **Add condition**.

   :::image type="content" source="media/configure-granular-rbac/add-conditions.png" lightbox="media/configure-granular-rbac/add-conditions.png" alt-text="A screenshot showing the conditions tab of the add role assignment page.":::

1. Select **Add action**.
1. Choose the **Read workspace data** data action and click **Select** 

   :::image type="content" source="media/configure-granular-rbac/add-action.png" lightbox="media/configure-granular-rbac/add-action.png" alt-text="A screenshot showing the add action part of the add conditions page.":::

1. In the **Build expression** section, select **Add expression**
1. Select *Resource* from the **Attribute source** dropdown.
1. Select *Table* from the **Attribute** dropdown.
1. Select *StringEquals* from the **Operator** dropdown then select **Value**.
1. Select **SigninLogs** from the **Value** dropdown.

   :::image type="content" source="media/configure-granular-rbac/build-expression.png" lightbox="media/configure-granular-rbac/build-expression.png" alt-text="A screenshot showing the build expression part of the add conditions page.":::

1. Select **Add expression**, then select **And** to add another expression.

1. Select *Resource* from the **Attribute source** dropdown.
1. Select *Column value* from the **Attribute** dropdown.
1. Select *UserPrincipalName* from the **Key** dropdown. 
1. Select *StringEquals* from the **Operator** dropdown then select **Value**.
1. In the **Value** field, enter the name of the user you want to restrict access to. 
1. Select **Save**.

   :::image type="content" source="media/granular-rbac-log-analytics/add-second-expression.png" lightbox="media/granular-rbac-log-analytics/add-second-expression.png" alt-text="A screenshot showing the adding of a second expression.":::

## Configure Security Analysts tier 1 role

Assume that this group of users needs access to all other tables in this workspace, while still restricting access to records in the SigninLogs table. This change can be achieved by making two modifications to the conditions: 

1. Change the *StringEquals* operator for the SigninLogs table to *StringNotEquals*

1. Change the **And** to **Or**
1. Change the *StringEquals* operator for the UserprincipalName condition to *StringNotEquals*
1. Select **Save**

Allow up to 15 minutes for effective permissions to take effect.

## Troubleshoot ABAC conditions

For general troubleshooting for ABAC, see [Troubleshoot Azure role assignment conditions](/azure/role-based-access-control/conditions-troubleshoot).

- The values used for table names and column values are case-sensitive. If a table name or value is incorrectly specified, the condition may fail, or yield unexpected behavior, and access to the requested data may be denied.
- Invalid conditions that cause a logic error trigger a "400 Bad Request" error message for all affected users. The condition must be revised by the administrator.

## Related content

- [Granular role-based access control (RBAC) in Azure Monitor](granular-rbac-log-analytics.md)
- [Microsoft Sentinel Syslog data connector](/azure/sentinel/connect-syslog)