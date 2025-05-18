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

- Azure Log Analytics workspace with custom log tables and fields
- A role assigned to your account giving permission to create custom roles and assign them to users or groups like the [Role Based Access Control Administrator](/azure/role-based-access-control/built-in-roles/#role-based-access-control-administrator) or [User Access Administrator](/azure/role-based-access-control/built-in-roles/privileged#user-access-administrator).

## Define the scenario

In this scenario, row-level access control is implemented for the `CommonSecurityLog` and `SigninLogs` tables in a Logs Analytics workspace. Conditions are set for a group of operators as follows:

1. Set the network team's group access to just access the `CommonSecurityLog` table where the DeviceVendor name matches the network firewalls. This configuration uses the *No access to data, except what is allowed* strategy.
1. Set the tier 1 security analyst team's access to all tables, but restrict the `SigninLogs` and `DnsEvents` tables to prevent accessing records for the UPN or computername of the CEO using the *Access to all data, except what is not allowed* strategy.

## Create custom roles

Setup custom roles for the defined scenario. Create one with general data access, but the condition configured at assignment gives no access to the restricted tables. Then create one for the network team and another for the security team. For more information, see [Configure granular RBAC role creation](granular-rbac-log-analytics.md#role-creation).

1. From the resource group containing the prerequisite Log Analytics workspace, select **Access control (IAM)**.
1. Select **Add custom role**.
1. Create the general data access role with the following actions and data action at the resource group level:  

   | Custom role definition | Detail |
   |---|---|
   | Actions | `Microsoft.OperationalInsights/workspaces/read`</br>`Microsoft.OperationalInsights/workspaces/query/read` |
   | Data actions | `Microsoft.OperationalInsights/workspaces/tables/data/read` |

   This image shows how the custom role actions and data actions appear in the **Add custom role** page.

   :::image type="content" source="media/configure-granular-rbac/custom-role-example.png" lightbox="media/configure-granular-rbac/custom-role-example.png" alt-text="Screenshot showing how the custom role actions and data actions appear.":::

1. Enter a name for the custom role, such as `Log Analytics Network Device team`
1. Repeat steps 2-4 for the `Log Analytics Security Analysts tier 1` custom role. Use the **Clone a role** option and choose the `Log Analytics Network Device team` role as a base.

## Assign custom roles

Assign the custom roles to a user or group. For more information, see [Assign granular RBAC roles](granular-rbac-log-analytics.md#conditions-and-expressions). 

1. From the Log Analytics workspace, select **Access control (IAM)**.
1. Select **Add role assignment**.
1. Select the `Log Analytics Network Device team` custom role you created, then select **Next**.
1. Select the user or group you want to assign the role to, then select **Next**. This example assigns the role to the network team security group.
1. Select **Conditions** > **Add condition** > **Add action**.
1. Choose the **Read workspace data** data action > **Select**.

   :::image type="content" source="media/configure-granular-rbac/add-action.png" lightbox="media/configure-granular-rbac/add-action.png" alt-text="A screenshot showing the add action part of the add conditions page.":::

### Build restrictive expression

The first custom role uses the *No access to data, except what is allowed* strategy.

1. In the **Build expression** section, select **Add expression**
1. Select *Resource* from the **Attribute source** dropdown.
1. Select *Table Name* from the **Attribute** dropdown.
1. Select *StringEquals* from the **Operator** dropdown then select **Value**.
1. Type **CommonSecurityLog** in the **Value** dropdown.

1. Select **Add expression**, then select **And** to add another expression.
1. Select *Resource* from the **Attribute source** dropdown.
1. Select *Column value* from the **Attribute** dropdown.
1. Enter *DeviceVendor* for the **Key**. 
1. Select *ForAnyOfAnyValues:StringLikeIgnoreCase* from the **Operator** dropdown then select **Value**.
1. In the **Value** fields, enter `Check Point` and `SonicWall`.
1. Select expression **1** and **2** > select **Group** with the **And** radio button selected.
   
   Here's how the condition looks when completed:

   :::image type="content" source="media/configure-granular-rbac/no-access-to-data-except-allowed-condition.png" lightbox="media/configure-granular-rbac/no-access-to-data-except-allowed-condition.png" alt-text="A screenshot showing the adding of a second expression.":::

   Here's how the condition looks in code form:
   ```
   (
    (
     !(ActionMatches{'Microsoft.OperationalInsights/workspaces/tables/data/read'})
    )
    OR 
    (
     (
      @Resource[Microsoft.OperationalInsights/workspaces/tables:name] StringEquals 'CommonSecurityLog'
      AND
      @Resource[Microsoft.OperationalInsights/workspaces/tables/record:DeviceVendor<$key_case_sensitive$>] ForAnyOfAnyValues:StringLikeIgnoreCase {'Check Point', 'SonicWall'}
     )
    )
   )
   ```
   
1. Select **Save**.

### Build permissive expression

The second custom role uses the *Access to all data, except what is not allowed* strategy.

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