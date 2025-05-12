---
title: Azure Service Health Portal
description: The Azure Service Health portal experience lets users engage with service events and manage actions to maintain the business continuity of impacted applications.
ms.topic: overview
ms.date: 4/29/2025
---

# Azure Service Health Portal
The [Service Health portal](https://portal.azure.com/#view/Microsoft_Azure_Health/AzureHealthBrowseBlade/~/serviceIssues) is part of the [Service Health service](overview.md). The portal provides you with a customizable dashboard which tracks the health of your Azure services in the regions where you use them. 

The Azure Service Health portal experience lets you engage with service events and manage actions and alerts to maintain the business continuity of impacted applications. In this dashboard, you can track active events like ongoing service issues, upcoming planned maintenance, relevant health advisories, or billing updates. 

When events become inactive, they get placed in your health history for up to 90 days. Finally, you can use the Service Health dashboard to create and manage service health alerts which proactively notify you when service issues are affecting you.


:::image type="content" source="media/service-health-portal-update/services-issue-window-1.png" alt-text="A screenshot of the services issue user interface." lightbox="media/service-health-portal-update/services-issue-window-1.png":::

## Service Health Events

The [Service Health portal](https://portal.azure.com/#view/Microsoft_Azure_Health/AzureHealthBrowseBlade/~/serviceIssues) tracks four types of health events that may impact your resources:

1. **Service issues** - Problems in the Azure services that affect you right now. 
2. **Planned maintenance** - Upcoming maintenance that can affect the availability of your services in the future.  
3. **Health advisories** - Changes in Azure services that require your attention. Examples include deprecation of Azure features or upgrade requirements (e.g upgrade to a supported PHP framework).
4. **Security advisories** - Security related notifications or violations that may affect the availability of your Azure services.
1. **Billing updates** - Billing communications related to your subscription.

> [!NOTE]
> To view Service Health events, users must be [granted the Reader role](/azure/role-based-access-control/role-assignments-portal) on a subscription.


## Get Started with Service Health


### See Service issues which might affect your services
The Service Issues window shows a map with all the user services across the world. The information on this window helps you find services that might be impacted from an outage based on your subscription or tenant admin access.



> [!NOTE]
>The Azure Resource Graph (ARG) query is used to fetch service health events, and returns one record per subscription ID and tracking ID combination.
>The Azure Portal shows one tracking ID for the chosen list of subscriptions.
>The number of unique tracking IDs match across ARG and portal.


##### Tenant and Subscription access
Tenant access refers to the ability to view events that affect the entire organization, requiring tenant admin roles. Subscription access, on the other hand, allows users with appropriate permissions to view events specific to the resources within a particular subscription. Tenant-level events affect the whole organization, while subscription-level events are limited to the resources in that subscription. 

This distinction ensures that users can manage and monitor Azure services effectively based on their roles and the scope of their responsibilities. 

The Service Issues, Health Advisories, Security Advisories, and Health History blades show events both at tenant and subscription levels.
For more information about the roles, see [Role Based Access (RBAC) for security Incident Resource Impact](impacted-resources-security.md).  

:::image type="content" source="media/service-health-portal-update/service-issue-window-2.png" alt-text="A screenshot of the services issue user interface highlighting the scope selection boxes of tenant and subscription." lightbox="media/service-health-portal-update/service-issue-window-2.png":::

##### Filter and sort the information

You can filter on the scope (tenant or subscription) within the blades. The scope column indicates when an event is at the tenant or subscription level.

:::image type="content" source="media/service-health-portal-update/services-issue-window-3.png" alt-text="A screenshot of the services issue user interface highlighting the scope column." lightbox="media/service-health-portal-update/services-issue-window-3.png":::

<!--
##### Issues Details
The issues details look and feel has been updated, for better readability. 
-->

## See scheduled Planned maintenance events

On this window, you can see a list of all planned maintenance events. For more information, see [Viewing Impacted Resources for planned maintenance events](impacted-resources-planned-maintenance.md).

:::image type="content" source="media/service-health-portal-update/services-issue-planned-maintenance.png" alt-text="A screenshot of the Planned maintenance window." lightbox="media/service-health-portal-update/services-issue-planned-maintenance.png":::

## See updates about Health advisories
Health Advisories in Azure Service Health are notifications that inform users about changes in Azure services that require attention. These advisories can include information about the deprecation of Azure features, upgrade requirements, or other actions needed to maintain the health and performance of your Azure resources.

<br>Open this window to see all the Health Advisories based on your subscription access. For more information on how to configure alerts for service health events, see [Create Service Health alert using the Azure Portal](alerts-activity-log-service-notifications.md), [Create activity log alerts using a Bicep file](alerts-activity-log-service-notifications-bicep.md), or [Create Service Health alerts using an ARM template](alerts-activity-log-service-notifications-arm.md).

:::image type="content" source="media/service-health-portal-update/services-issue-health-advisories.png" alt-text="A screenshot of the health advisories window." lightbox="media/service-health-portal-update/services-issue-health-advisories.png":::

## View and keep track of Security advisories
This window lists all the current security advisories based on your subscription. For more information, see [Elevated access for viewing Security Advisories](security-advisories-elevated-access.md)

:::image type="content" source="media/service-health-portal-update/health-alerts-security.png" alt-text="A screenshot of the security advisories window." lightbox="media/service-health-portal-update/health-alerts-security.png":::


## See all Billing updates
If you have access as a subscription owner or contributor, you see the billing updates on this window. For more information, see [In-Portal Billing](billing-elevated-access.md)

:::image type="content" source="media/service-health-portal-update/in-portal-billing-blade.png" alt-text="A screenshot of the Billing updates window." lightbox="media/service-health-portal-update/in-portal-billing-blade.png":::


## See and manage your Resource health
This page watches your resource and tells you if it's running as expected. There are links that open directly to information about the health of your selected resource. For more information, see [Resource Health overview](resource-health-overview.md)

:::image type="content" source="media/service-health-portal-update/services-issue-resource-health-1.png" alt-text="A screenshot of the Resource health window." lightbox="media/service-health-portal-update/services-issue-resource-health-1.png":::

## View and sort Health alerts

The Health Alerts window allows you to search for and sort your alert rules by name. You can also group alert rules by subscription and status. 
<br>An alert is triggered when the specified conditions are met. You can select any alert rule for more information, and details and see the alert firing history. You can also select the link of any alert to see more details. For more information on Service Health Alerts, see [Configure Service Health alerts using Azure Portal](alerts-activity-log-service-notifications-portal.md)

:::image type="content" source="media/service-health-portal-update/health-alerts-filter.png" alt-text="A screenshot highlighting the health alerts window filters." lightbox="media/service-health-portal-update/health-alerts-filter.png":::

<!--
:::image type="content" source="media/service-health-portal-update/services-issue-resource-health-alerts.png" alt-text="A screenshot of the health alerts blade." lightbox="media/service-health-portal-update/services-issue-resource-health-alerts.png":::
-->


