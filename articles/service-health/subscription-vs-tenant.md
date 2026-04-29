---
title: Subscription vs. Tenant Admin Accounts in Service Health
description: Information on the difference and how to set up the accounts.
ms.topic: overview
ms.date: 03/26/2026
---
# Subscription vs. tenant admin accounts in Service Health

In Azure Service Health, tenant-level and subscription-level access work differently. These differences determine which service health updates that a user can see and who can view them. This article explains the access needed to use Azure Service Health.

## Tenant admin account

When an organization signs up for Microsoft cloud services, Microsoft creates a secure space just for that organization. This *tenant* space is where the organization manages its users, accounts, and access settings.

Some events or issues can affect the entire organization. These events are *tenant-level events*, and the Azure Service Health portal shows them.

Tenant admin access means having special permissions to manage the organization's setup. People with these permissions, such as Global administrators and Application administrators, can add or manage users, control access, and see organization-wide service health updates. Regular users don't see this information.

For more information about tenant-level roles, see [Roles with tenant admin access](admin-access-reference.md).

To create a tenant account in Service Health, follow these steps:

1. Go to the Azure portal and sign in with your credentials.
1. On the Azure portal menu, select **Microsoft Entra ID**.
1. Go to **Identity** > **Overview** > **Manage tenants**.
1. Select **Create**. On the **Basics** tab, choose the type of tenant that you want to create, either **Microsoft Entra ID** or **Microsoft Entra ID (B2C)**.
1. On the **Configuration** tab, enter the following information:
    - **Organization name**: Enter the name of your organization (for example, **Contoso Organization**).
    - **Initial domain name**: Provide an initial domain name for your tenant (for example, **Contosoorg**).
    - **Country/Region**: Select a country or region from the dropdown menu, or leave the default option.
1. Select **Next** > **Review + Create**. Review the information that you entered. If everything is correct, select **Create** in the lower-left corner. Your new tenant account is created with the domain `contoso.onmicrosoft.com`. (This account is a sample account.)
After the tenant is created, you're the first user and automatically assigned the Global administrator role. You can then manage your tenant account and assign roles to other users as needed.

For more information:

| Scope | Access via Service Health portal| Access via API|Access via Azure Resource Graph queries| Permissions required|
|---|----|---|---|---|
|Tenant | Yes| Yes| No|Tenant admin role. For more information, see [Roles with Tenant admin access](admin-access-reference.md).|
|Subscription| Yes| Yes|Yes|Subscription Reader role or equivalent.|

## Subscription account

A subscription is an agreement with Microsoft to use one or more cloud services, where each subscription is associated with a tenant. Subscriptions are used to manage and organize resources in Azure.

Subscription-level events are specific to the resources within that subscription. Users with the appropriate permissions can view them.

In Azure Service Health, users with subscription access can view and manage various aspects of Service Health notifications and alerts.

Here are some key points about what a subscription access includes:

* **View Service Health events:** Users with subscription access can view Service Health events such as service issues, planned maintenance, health advisories, and security advisories. These events are specific to the resources within the subscription.

* **Create Service Health alerts:** Users can create Service Health alerts to receive notifications about Service Health events. The permissions required to create these alerts are like those for Azure activity logs.

* **Role-based access control:** Manage subscription access through role-based access control. Users must be granted the Reader role on a subscription to view Service Health events. For sensitive information, such as security advisories, elevated access is required. For more information, see [Elevated access for viewing security advisories](security-advisories-elevated-access.md) and [Resource impact from Azure security advisories](impacted-resources-security.md).

* **Filter and sort events:** In the Service Health portal, users can filter and sort events by subscription scope. With these filters, users can see service issues, health advisories, security advisories, and health history at the subscription level. For more information, see [Azure Service Health portal](service-health-portal-update.md).

* **Access to specific endpoints:** There are specific endpoints for accessing detailed information about Service Health events. For example, the `events/{trackingId}/fetchEventDetails` endpoint provides detailed properties of a particular event, including sensitive information for security advisory events.

In the Service Health portal, you can filter and sort events by tenant or subscription scope. You can use these filters to see service issues, health advisories, security advisories, and health history at both the tenant and subscription levels.

For more information, see [Resource impact from Azure security advisories](impacted-resources-security.md).

>[!NOTE]
>
> * You can't see tenant-level events within subscription scope on the UI.
> * You can't see subscription-level events at tenant scope. Events published on Azure Service Health are mutually exclusive in view scope.
