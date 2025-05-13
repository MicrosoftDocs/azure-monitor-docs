---
title: How to Configure Granular RBAC (Preview)
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

This article is a step-by-step example of defining granular RBAC conditions in Log Analytics using the Azure portal. For more information about granular RBAC concepts, see [Granular role-based access control (RBAC) in Azure Monitor](granular-rbac-log-analytics.md).

## Prerequisites

The following prerequisites are required to complete this scenario:

- Azure Log Analytics workspace (optionally enabled for Microsoft Sentinel) with custom log tables and fields
- A role assigned to your account giving permission to create custom roles and assign them to users or groups like the [Role Based Access Control Administrator](/azure/role-based-access-control/built-in-roles/#role-based-access-control-administrator) or [User Access Administrator](/azure/role-based-access-control/built-in-roles/privileged#user-access-administrator).

## Define the scenario

In this scenario, row-level access control is implemented for the Syslog table in a Microsoft Sentinel workspace. Conditions are set for a group of operations as follows:

1. Users are only given access to the tables they need to work with in the workspace. Even if they have Read access at a higher level, they won't be able to see the data in any of the tables unless they have been assigned a custom role with the appropriate conditions.
1. Some users have access to the Syslog table, but it's restricted to only the records that match their department. For example, if a user is in the network team, they can only see records for network devices.

## Create custom role

Setup a custom role with the appropriate actions and data actions. For more information, see [Configure granular RBAC role creation](granular-rbac-log-analytics.md#role-creation).

1. Create a custom role, called `Log Analytics Network Device team`, with the following actions and data action:  

| Custom role definition | Detail |
|---|---|
| Actions | `Microsoft.OperationalInsights/workspaces/read`</br>`Microsoft.OperationalInsights/workspaces/tables/data/read` |
| Data actions | `Microsoft.OperationalInsights/workspaces/tables/data/read` |



## Assign custom role

Assign the custom role to a user or group. For more information, see [Assign granular RBAC roles](granular-rbac-log-analytics.md#assign-role).


1. From Log Analytics workspace, select **Access control (IAM)**.

1. Select **Add role assignment**.
1. Select the  `Log Analytics Operator` custom role you created, then select **Next**.
1. Select the user or group you want to assign the role to, then select **Next**. For this quickstart, assign the role to the group of users.
1. Select the **Conditions** tab.
1. Select **Add condition**.
      :::image type="content" source="media/granular-rbac-log-analytics/add-conditions.png" lightbox="media/granular-rbac-log-analytics/add-conditions.png" alt-text="A screenshot showing the conditions tab of the add role assignment page.":::
 
1. Select **Add action**.
1. Choose the **Read workspace data** data action and click **Select** 
     :::image type="content" source="media/granular-rbac-log-analytics/add-action.png" lightbox="media/granular-rbac-log-analytics/add-action.png" alt-text="A screenshot showing the add action part of the add conditions page.":::
1. In the **Build expression** section, select **Add expression**
1. Select *Resource* from the **Attribute source** dropdown.
1. Select *Table* from the **Attribute** dropdown.
1. Select *StringEquals* from the **Operator** dropdown then select **Value**.
1. Select **SigninLogs** from the **Value** dropdown.

    :::image type="content" source="media/granular-rbac-log-analytics/build-expression.png" lightbox="media/granular-rbac-log-analytics/build-expression.png" alt-text="A screenshot showing the build expression part of the add conditions page.":::

1. Select **Add expression**, then select **And** to add another expression.
1. Select *Resource* from the **Attribute source** dropdown.
1. Select *Column value* from the **Attribute** dropdown.
1. Select *UserPrincipalName* from the **Key** dropdown. 
1. Select *StringEquals* from the **Operator** dropdown then select **Value**.
1. In the **Value** field, enter the name of the user you want to restrict access to. 
1. Select **Save**. 
   :::image type="content" source="media/granular-rbac-log-analytics/add-second-expression.png" lightbox="media/granular-rbac-log-analytics/add-second-expression.png" alt-text="A screenshot showing the adding of a second expression.":::
 

Assume that this group of users needs access to all other tables in this workspace, while still restricting access to records in the SigninLogs table. This change can be achieved by making two modifications to the conditions: 

1. Change the *StringEquals* operator for the SigninLogs table to *StringNotEquals*

1. Change the **And** to **Or**
1. Chang the *StringEquals* operator for the UserprincipalName condition to *StringNotEquals*
1. Select **Save**

This configuration allows the group of users to access all tables in the workspace except for the SigninLogs table for the specified user name.


> [!NOTE]
> It can take up to 15 minutes for the permissions to become active.


## Set conditions

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

1. boom
1. bada boom
1. bada bing

## Troubleshoot ABAC conditions

For general troubleshooting for ABAC, see (Troubleshoot Azure role assignment conditions)(/azure/role-based-access-control/conditions-troubleshoot).

*    The values used for table names and column values are case-sensitive. If a table name or value is incorrectly specified, the condition may fail, or yield unexpected behavior, and access to the requested data may be denied.

*    Invalid conditions that cause a logic error trigger a "400 Bad Request" error message for all affected users. The condition must be revised by the administrator.

## Related content

- [Granular role-based access control (RBAC) in Azure Monitor](granular-rbac-log-analytics.md)
- [Microsoft Sentinel Syslog data connector](/azure/sentinel/connect-syslog)