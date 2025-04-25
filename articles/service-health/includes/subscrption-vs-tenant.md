---
title: Subscription vs Tenant admin accounts in Service Health
description: Information on the difference and how to set up the accounts 
ms.topic: overview
ms.date: 04/25/2025
---
# Subscription vs Tenant Admin accounts in Service Health

## Tenant Admin Account

In the Azure Service Health portal, a tenant admin role refers to a dedicated instance of Azure Active Directory (Azure AD) that an organization receives when it signs up for a Microsoft cloud service. This tenant is used to manage users, groups, and permissions within the organization. Tenant-level events are those that affect the entire organization and can be viewed by users with tenant admin access.

Tenant admin access in Azure refers to the permissions granted to roles that allow users to manage and view resources at the tenant level. These roles include Global Administrator, Application Administrator, and others. Tenant admin access enables users to manage users, groups, and permissions within the organization, and view tenant-level events in the Azure Service Health portal. 

For Tenant-level roles see [Roles with tenant admin access](admin-access-reference).

To create a tenant account in Service Health, follow these steps:
1.	**Sign in to the Azure portal**: Go to the Azure portal and sign in with your credentials.
2.	**Navigate to Microsoft Entra ID**: From the Azure portal menu, select Microsoft Entra ID.
3.	**Manage tenants**: Navigate to Identity > Overview > Manage tenants.
4.	**Create a new tenant**: Select Create. On the Basics tab, choose the type of tenant you want to create, either Microsoft Entra ID or Microsoft Entra ID (B2C).
5.	**Enter tenant details**: On the Configuration tab, enter the following information:
    •	Organization name (e.g., Contoso Organization)
    •	Initial domain name (e.g., Contosoorg)
    •	Country/Region (you can leave the default option or select your desired country/region)
6.	**Review and create**: Select Next: Review + Create. Review the information you entered and if everything is correct, select Create in the lower left corner. Your new tenant will be created with the domain contoso.onmicrosoft.com.
Once the tenant is created, you will be the first user and automatically assigned the Global Administrator role. You can then manage your tenant account and assign roles to other users as needed. 

For more information:
| Scope | Access via Service Health Portal| Access via API|Access via ARG queries| Permissions required|
|---|----|---|---|---|
|Tenant | Yes| yes| No|Tenant Admin Role see [admin access](admin-access-reference).|
Subscription| Yes| Yes|Yes|Subscription reader role or equivalent|

## Subscription Account

 A subscription is an agreement with Microsoft to use one or more cloud services, where each subscription is associated with a tenant. Subscriptions are used to manage and organize resources in Azure. Subscription-level events are specific to the resources within that subscription and can be viewed by users with the appropriate permissions.

In Azure Service Health, subscription access allows users to view and manage various aspects of service health notifications and alerts. Here are some key points about what subscription access entails:

**Viewing Service Health Events**<br>
    - Users with subscription access can view service health events such as service issues, planned maintenance, health advisories, and security advisories. These events are specific to the resources within the subscription.
    
**Creating Service Health Alerts**<br>
    - Users can create Service Health alerts to receive notifications about Service Health events. The permissions required to create these alerts are like those for Azure Activity Logs.
    
**Role-Based Access Control (RBAC)**<br>
    - Subscription access is managed through RBAC. Users must be granted the Reader role on a subscription to view Service Health events. For sensitive information, such as security advisories, elevated access is required. See [Elevated access for viewing Security Advisories](security-advisories-elevated-access) and [Resource impace from Azure security incidents](impacted-resources-security).
    
**Filtering and Sorting Events** <br>
    - In the Service Health portal, users can filter and sort events by subscription scope . This allows them to see service issues, health advisories, security advisories, and health history at the subscription level. See [Azure Service Health Portal](service-health-portal-update).

**Access to Specific Endpoints**<br>
    - There are specific endpoints for accessing detailed information about service health events. For example, the `events/{trackingId}/fetchEventDetails` endpoint provides detailed properties of a particular event, including sensitive information for security advisory events.<br>

    
In the Service Health portal, you can filter and sort events by tenant or subscription scope. This allows you to see service issues, health advisories, security advisories, and health history at both the tenant and subscription levels.    

For more information see [Resource impace from Azure security incidents](impacted-resources-security).

>[!Note]
> 
* Tenant level events cannot be seen within Subscription scope on UI. 
* Subscription level events cannot be seen at Tenant scope. Events published on Azure Service Health are mutually exclusive in view scope.
