---
title: Subscription vs Tenant admin accounts in Service Health
description: Information on the difference and how to set up the accounts 
ms.topic: overview
ms.date: 05/20/2025
---
# Subscription vs tenant admin accounts in Service Health

In Azure Service Health, tenant-level and subscription-level access are different. These differences determine what service health updates a user can see and who is allowed to view them. This article provides a breakdown on the access needed to use Azure Service Health.

## Tenant admin account

In the Azure Service Health portal, a tenant admin role refers to a dedicated instance of Microsoft Entra ID that an organization receives when it signs up for a Microsoft cloud service. The tenant is used to manage users, groups, and permissions within the organization. Tenant-level events affect the entire organization, and users with tenant admin access can see them.

Tenant admin access in Azure refers to the permissions granted to roles that allow users to manage and view resources at the tenant level. These roles include Global Administrator, Application Administrator, and others. Tenant admin access enables users to manage users, groups, and permissions within the organization, and view tenant-level events in the Azure Service Health portal. 

For Tenant-level roles, see [Roles with tenant admin access](admin-access-reference.md).

To create a tenant account in Service Health, follow these steps:
1.	**Sign in to the Azure portal**: Go to the Azure portal and sign in with your credentials.
2.	**Navigate to Microsoft Entra ID**: From the Azure portal menu, select Microsoft Entra ID.
3.	**Manage tenants**: Navigate to Identity > Overview > Manage tenants.
4.	**Create a new tenant**: Select Create. On the Basics tab, choose the type of tenant you want to create, either Microsoft Entra ID or Microsoft Entra ID (B2C).
5.	**Enter tenant details**: On the Configuration tab, enter the following information:
    - **Organization name**: Enter the name of your organization (for example, Contoso Organization).
    - **Initial domain name**: Provide an initial domain name for your tenant (for example, Contosoorg).
    - **Country/Region**: Select your desired country or region from the dropdown menu, or leave the default option.
6.	**Review and create**: Select Next: Review + Create. Review the information you entered and if everything is correct, select Create in the lower left corner. Your new tenant account is created with the domain contoso.onmicrosoft.com (*this account is a sample account*).
Once the tenant is created, you're the first user and automatically assigned the Global Administrator role. You can then manage your tenant account and assign roles to other users as needed. 

For more information:

| Scope | Access via Service Health Portal| Access via API|Access via Azure Resource Graphs (ARG) queries| Permissions required|
|---|----|---|---|---|
|**Tenant** | Yes| yes| No|Tenant Admin Role for  see [Roles with tenant admin access](admin-access-reference.md).|
|**Subscription**| Yes| Yes|Yes|Subscription reader role or equivalent.|

## Subscription account

A subscription is an agreement with Microsoft to use one or more cloud services, where each subscription is associated with a tenant. Subscriptions are used to manage and organize resources in Azure. <br>Subscription-level events are specific to the resources within that subscription and users with the appropriate permissions can view them.

In Azure Service Health, subscription access allows users to view and manage various aspects of service health notifications and alerts. <br>Here are some key points about what a subscription access includes:

**Viewing Service Health Events**<br>
* Users with subscription access can view service health events such as service issues, planned maintenance, health advisories, and security advisories. These events are specific to the resources within the subscription.
    
**Creating Service Health Alerts**<br>
* Users can create Service Health alerts to receive notifications about Service Health events. The permissions required to create these alerts are like those for Azure Activity Logs.
    
**Role-Based Access Control (RBAC)**<br>
* Subscription access is managed through RBAC. Users must be granted the Reader role on a subscription to view Service Health events. For sensitive information, such as security advisories, elevated access is required. See [Elevated access for viewing Security Advisories](security-advisories-elevated-access.md) and [Resource impact from Azure security advisories](impacted-resources-security.md).
    
**Filtering and Sorting Events** <br>
* In the Service Health portal, users can filter and sort events by subscription scope. These filters allow them to see service issues, health advisories, security advisories, and health history at the subscription level. See [Azure Service Health Portal](service-health-portal-update.md).

**Access to Specific Endpoints**<br>
* There are specific endpoints for accessing detailed information about service health events. For example, the `events/{trackingId}/fetchEventDetails` endpoint provides detailed properties of a particular event, including sensitive information for security advisory events.<br>

    
In the Service Health portal, you can filter and sort events by tenant or subscription scope. These filters allow you to see service issues, health advisories, security advisories, and health history at both the tenant and subscription levels.    

For more information, see[Resource impact from Azure security advisories](impacted-resources-security.md).

>[!Note]
> 
>* Tenant-level events can't be seen within Subscription scope on UI. 
>* Subscription-level events can't be seen at Tenant scope. Events published on Azure Service Health are mutually exclusive in view scope.
