---
title: Getting started with granular RBAC in Log Analytics
description: Learn how to use granular row-level access control in Log Analytics.
services: azure-monitor
sub-service: logs
ms.reviewer: rofrenke
ms.topic: how-to
ms.date: 05/08/2025


# Customer intent: As an Azure administrator, I want to understand how to use granular RBAC in Log Analytics for the use case scenario of separating custom log table access at the row level.
---

Granular Access Control for Logs: Many users emphasize the need for granular access control to logs based on roles, departments, and geographical locations. This includes scenarios like restricting HR personnel to employee data or limiting access to logs by country or department
Custom Log Tables and Fields: Several scenarios involve the use of custom log tables (e.g., _CL) and fields (e.g., _CF) to enforce row-level access. Users aim to segregate data based on attributes like device type, subscription ID, or specific identifiers.

# Getting started with granular RBAC in Log Analytics

Granular RBAC (Roles Based Access Control) is a feature of Log Analytics that implements Azure ABAC for fine-grained data access control. 

This article helps you get started defining ABAC conditions in Log Analytics using the Azure portal.


## Quickstart scenario

In this quick start guide, we implement row-level access control in Log Analytics. We set conditions for a group of operations users as follows:
- The users can only access sign in logs.
- The users can't access sign in logs of company's CEO as identified by the user principal name johndoe@contoso.com.

## Prerequisites

- An Azure Log Analytics workspace
- An Azure user with permissions to manage the Log Analytics workspace: `Microsoft.OperationalInsights/workspaces/tables/data/read `


## Create custom role with ABAC conditions

1. Create a custom role, called `Log Analytics Operator`, with the following action and data action:  
   Actions:
    - `Microsoft.OperationalInsights/workspaces/read`
    - `Microsoft.OperationalInsights/workspaces/tables/data/read`
    
    Data actions:
    - `Microsoft.OperationalInsights/workspaces/tables/data/read`
 
1. From Log Analytics workspace, select **Access control (IAM)**.

1. Select **Add role assignment**.
1. Select the  `Log Analytics Operator` custom role you created, then select **Next**.
1. Select the user or group you want to assign the role to, then select **Next**. For this quickstart, assign the role to the group of users.
1. Select the **Conditions** tab.
1. Select **Add condition**.
      :::image type="content" source="media/granular-rbac-log-analytics/add-conditions.png" lightbox="media/granular-rbac-log-analytics/add-conditions.png" alt-text="A screenshot showing the conditions tab of the add role assignment page.":::
 
1. Select **Add action**.
1. Choose the **Read workspace data** data action and click **Select**  ????????????
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


**TBD need to verify steps and add screenshots**

## Troubleshoot ABAC conditions

For general troubleshooting for ABAC, see (Troubleshoot Azure role assignment conditions)(/azure/role-based-access-control/conditions-troubleshoot).

*    The values used for table names and column values are case-sensitive. If a table name or value is incorrectly specified, the condition may fail, or yield unexpected behavior, and access to the requested data may be denied.

*    Invalid conditions that cause a logic error trigger a "400 Bad Request" error message for all affected users. The condition must be revised by the administrator.

## Next steps
TBD