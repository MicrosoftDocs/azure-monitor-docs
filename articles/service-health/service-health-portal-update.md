---
title: Azure Service Health Portal
description: The Azure Service Health portal experience lets users engage with service events and manage actions to maintain the business continuity of affected applications.
ms.topic: overview
ms.date: 10/16/2025
---

# Azure Service Health portal

The [Service Health portal](https://portal.azure.com/#view/Microsoft_Azure_Health/AzureHealthBrowseBlade/~/serviceIssues) is part of the [Service Health service](overview.md). The portal provides you with a customizable dashboard that tracks the health of your Azure services in the regions where you use them.

By using the Azure Service Health portal, you can engage with service events and manage actions and alerts to maintain the business continuity of affected applications. In this dashboard, you can track active events like ongoing service issues, upcoming planned maintenance, relevant health advisories, and billing updates. For more information about the portal elements and controls, see [Azure portal overview](/azure/azure-portal/azure-portal-overview).

You can use the Service Health dashboard to create and manage Service Health alerts, which proactively notify you when service issues are affecting you.

## Service Health events

The [Service Health portal](https://portal.azure.com/#view/Microsoft_Azure_Health/AzureHealthBrowseBlade/~/serviceIssues) tracks five types of health events that might affect your resources:

- **Service issues**: Problems in the Azure services that affect you right now.
- **Planned maintenance**: Upcoming maintenance that can affect the availability of your services in the future.  
- **Health advisories**: Changes in Azure services that require your attention. Examples include deprecation of Azure features or upgrade requirements (like needing to upgrade to a supported PHP framework).
- **Security advisories**: Security-related notifications or violations that might affect the availability of your Azure services.
- **Billing updates**: Billing communications related to your subscription.


### The retention of Service Health events
Azure Service Health retains all event types in the Health History section of the portal for up to 90 days after they become inactive. These events are archived in the Health History once they're resolved or inactive. You can filter and review them by type, date, and impact.
> [!NOTE]
> Service issues are displayed for 90 days in the Portal. They remain in the active tab if status is active or the issue is updated within 90 days and then  moved to the History pane once resolved.
>
> Issues older than 90 days aren't shown, but are stored for a year and can be accessed via an API query.

- **Alerts**: Service Health alerts (for example, via email, webhook, Logic Apps) aren't subject to the 90-day limit because they're tied to your alerting infrastructure.
- **Resource Health**: Resource Health events, like when a virtual machine (VM) goes offline aren’t part of Service Health. They’re saved for 90 days and viewed in a different section of the Azure portal.
- **Saved Views**: Custom views in the Service Health portal are retained for 30 days unless actively used. 
- **Metadata**: Tags and event levels remain in place until the event is resolved or archived.

> [!NOTE]
> If you use Azure Resource Graph queries to retrieve Service Health events, you might notice a different count compared to the Service Health UI. This outcome is expected. Resource Graph returns one record per subscription ID and tracking ID combination. On the Azure portal, updates are grouped under each tracking ID, so you might see fewer rows.
>
> However, all updates for each tracking ID are still available on the **Issue Updates** tab, and the number of unique tracking IDs is the same in both Resource Graph and the Service Health portal.

## Get started with Service Health

### See issues that might affect your services

Select **Service issues** on the left menu to see a map with all user services across the world. This information can help you find services that could be affected from an outage, based on your subscription or tenant admin access.

:::image type="content" source="media/service-health-portal-update/services-issue-window-1.png" alt-text="A screenshot of the Service issues user interface." lightbox="media/service-health-portal-update/services-issue-window-1.png":::

### See planned maintenance events

Select **Planned maintenance** on the left menu to see a list of all planned maintenance events. For more information, see [View affected resources for planned maintenance events](impacted-resources-planned-maintenance.md).

:::image type="content" source="media/service-health-portal-update/services-issue-planned-maintenance.png" alt-text="A screenshot of the Planned maintenance window." lightbox="media/service-health-portal-update/services-issue-planned-maintenance.png":::

### See updates about health advisories

Health advisories are notifications that inform users about changes in Azure services. These advisories can include information about the deprecation of Azure features, upgrade requirements, or other actions that users need to take to maintain the health and performance of their Azure resources.

Select **Health advisories** on the left menu to see all the health advisories based on your subscription access. For more information, see [Health advisories](service-health-advisories.md). <br>
For information on how to configure alerts for Service Health events, see [Create Service Health alerts by using the Azure portal](alerts-activity-log-service-notifications.md), [Create activity log alerts by using a Bicep file](alerts-activity-log-service-notifications-bicep.md), or [Create Service Health alerts by using an ARM template](alerts-activity-log-service-notifications-arm.md).

:::image type="content" source="media/service-health-portal-update/services-issue-health-advisories.png" alt-text="A screenshot of the Health advisories window." lightbox="media/service-health-portal-update/services-issue-health-advisories.png":::

### View and keep track of security advisories

Select **Security advisories** from the left menu to see all the current security advisories based on your subscription. For more information, see [Elevated access for viewing Security advisories](security-advisories-elevated-access.md).

:::image type="content" source="media/service-health-portal-update/health-alerts-security.png" alt-text="A screenshot of the security advisories window." lightbox="media/service-health-portal-update/health-alerts-security.png":::

### See all billing updates

Select **Billing updates** from the left menu to see billing updates. Only users with subscription owner or contributor permissions can access this information. <br>For more information, see [In-portal billing](billing-elevated-access.md).

:::image type="content" source="media/service-health-portal-update/in-portal-billing-blade.png" alt-text="A screenshot of the Billing updates window." lightbox="media/service-health-portal-update/in-portal-billing-blade.png":::


### View the history of all your Service Health events

Select **Health history** from the left menu to see a detailed view of the health status of your Azure services and resources. You can monitor outages, track incidents and configure alerts.

:::image type="content" source="media/service-health-portal-update/services-issue-health-history.png" alt-text="A screenshot of the health history window." lightbox="media/service-health-portal-update/services-issue-health-history.png":::


### See and manage your resource health

Select **Resource health** from the left menu to find out if your resource is running as expected. You can select links that open directly to information about the health of your selected resource. For more information, see [Resource health overview](resource-health-overview.md).

:::image type="content" source="media/service-health-portal-update/services-issue-resource-health-1.png" alt-text="A screenshot of the Resource health window." lightbox="media/service-health-portal-update/services-issue-resource-health-1.png":::

### View and sort health alerts

Select **Health alerts** from the left menu to search for and sort your alert rules by name. You can also group alert rules by subscription and status.

You can configure your alerts so that an alert is triggered when specified conditions are met. Select any alert rule to see more information, including the alert firing history. You can also select the link of any alert to see more details. 

- For more information on Service Health Alerts, see [Configure Service Health alerts by using the Azure portal](alerts-activity-log-service-notifications-portal.md).
- Learn how to deploy alerts at scale through [Deploy Service health alerts at scale using Azure Policy](service-health-alert-deploy-policy.md).

:::image type="content" source="media/service-health-portal-update/health-alerts-filter.png" alt-text="Screenshot that shows Health alerts filters." lightbox="media/service-health-portal-update/health-alerts-filter.png":::


### Manage your account and information

#### Tenant and subscription access

Tenant access requires tenant admin roles and refers to the ability to view events that affect the entire organization. Subscription access, on the other hand, allows users with appropriate permissions to view events specific to the resources within a particular subscription. Tenant-level events affect the whole organization, whereas subscription-level events are limited to the resources in that subscription.

For more information, see [Subscription vs. tenant access](subscription-vs-tenant.md).

This distinction ensures that users can effectively manage and monitor Azure services based on their roles and the scope of their responsibilities.

The **Service issues**, **Health advisories**, **Security advisories**, and **Health history** panes show events at both the **Tenant** and **Subscription** levels. For more information about roles, see [Role-based access control (RBAC) for security incident resource impact](impacted-resources-security.md).  

:::image type="content" source="media/service-health-portal-update/service-issue-window-2.png" alt-text="A screenshot of the Service issues user interface that highlights Tenant and Subscription checkboxes." lightbox="media/service-health-portal-update/service-issue-window-2.png":::

> [!NOTE] 
> You can also create an alert at the tenant level. See [Create tenant level service health alerts (preview)](../azure-monitor/alerts/alerts-create-tenant-level-service-heath-alerts.md).

#### Filtering and sorting the information

On the **Service issues** pane, you can filter by **Scope**. The **Scope** column indicates when an event is affecting the **Tenant** level or **Subscription** level.

:::image type="content" source="media/service-health-portal-update/services-issue-window-3.png" alt-text="A screenshot of the Service issues user interface that highlights the Scope column." lightbox="media/service-health-portal-update/services-issue-window-3.png":::
