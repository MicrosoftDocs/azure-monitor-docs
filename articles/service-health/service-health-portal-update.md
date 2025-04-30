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


:::image type="content" source="media/service-health-portal-update/services-issue-window-1.png" alt-text="A screenshot of the services issue user interface highlighting the switch to classic button." lightbox="media/service-health-portal-update/services-issue-window-1.png":::


## Highlights


##### Service Issues
The Service Issues blade shows a map with all the user services across the world. The information on this blade helps you find services that might be impacted from an outage based on your subscription or tenant admin access.


>[!Note]
>The classic experience for the Health Alerts blade will be retired. Users will not be able to switch back from the new experience once it is rolled out.

> [!IMPORTANT]
>Customers are observing a mismatch in the number of health advisories between the Azure Resource Graph query results and the service health blade.
> 
>This behavior is expected as the backend query for the service health blade on the portal merges the results by tracking ID. So, from Resource Graph, the responses contain multiple communications for one tracking ID.
>
>Although the Resource Graph query returns multiple responses for each tracking ID, the service health blade on the portal aggregates the results into one event.
>
>As a result, the Resource Graph query returns a significantly higher number of health advisories compared to what is shown on the portal, leading to confusion, and concerns regarding the accuracy of the service health information.


##### Tenant and Subscription access
Tenant access refers to the ability to view events that impact the entire organization, requiring tenant admin roles. Subscription access, on the other hand, allows users with appropriate permissions to view events specific to the resources within a particular subscription. Tenant-level events affect the whole organization, while subscription-level events are limited to the resources in that subscription. 

This distinction ensures that users can manage and monitor Azure services effectively based on their roles and the scope of their responsibilities. 

The Service Issues, Health Advisories, Security Advisories, and Health History blades show events both at tenant and subscription levels.
For more information about the roles, see [Role Based Access (RBAC) for security Incident Resource Impact](impacted-resources-security.md).  

:::image type="content" source="media/service-health-portal-update/service-issue-window-2.png" alt-text="A screenshot of the services issue user interface highlighting the scope selection boxes of tenant and subscription." lightbox="media/service-health-portal-update/service-issue-window-2.png":::

##### Filtering and Sorting

You can filter on the scope (tenant or subscription) within the blades. The scope column indicates when an event is at the tenant or subscription level.

:::image type="content" source="media/service-health-portal-update/services-issue-window-3.png" alt-text="A screenshot of the services issue user interface highlighting the scope column." lightbox="media/service-health-portal-update/services-issue-window-3.png":::

<!--
##### Issues Details
The issues details look and feel has been updated, for better readability. 
-->

## Planned Maintenance

On this blade, you can see a list of all planned maintenance events. For more information, see [Viewing Impacted Resources for planned maintenance events](impacted-resources-planned-maintenance.md).

:::image type="content" source="media/service-health-portal-update/services-issue-planned-maintenance.png" alt-text="A screenshot of the Planned maintenance blade." lightbox="media/service-health-portal-update/services-issue-planned-maintenance.png":::

## Health advisories
Health Advisories in Azure Service Health are notifications that inform users about changes in Azure services that require attention. These advisories can include information about the deprecation of Azure features, upgrade requirements, or other actions needed to maintain the health and performance of your Azure resources.

<br>Open this blade to see all the Health Advisories based on your subscription access. For more information on how to configure alerts for service health events, see [Create Service Health alert using the Azure Portal](alerts-activity-log-service-notifications.md), [Create activity log alerts using a Bicep file](alerts-activity-log-service-notifications-bicep.md), or [Create Service Health alerts using an ARM template](alerts-activity-log-service-notifications-arm.md).

:::image type="content" source="media/service-health-portal-update/services-issue-health-advisories.png" alt-text="A screenshot of the health advisories blade." lightbox="media/service-health-portal-update/services-issue-health-advisories.png":::

## Security advisories
This blade lists all the current security advisories based on your subscription. For more information, see [Elevated access for viewing Security Advisories](security-advisories-elevated-access.md)

:::image type="content" source="media/service-health-portal-update/health-alerts-security.png" alt-text="A screenshot of the security advisories blade." lightbox="media/service-health-portal-update/health-alerts-security.png":::


## Billing updates
If you have access as a subscription owner or contributor, you see the billing updates on this page. For more information, see [In-Portal Billing](billing-elevated-access.md)

:::image type="content" source="media/service-health-portal-update/in-portal-billing-blade.png" alt-text="A screenshot of the Billing updates blade." lightbox="media/service-health-portal-update/in-portal-billing-blade.png":::


## Resource health
This page watches your resource and tells you if it's running as expected. There are links that open directly to information about the health of your selected resource. For more information, see [Resource Health overview](resource-health-overview.md)

:::image type="content" source="media/service-health-portal-update/services-issue-resource-health-1.png" alt-text="A screenshot of the Resource health blade." lightbox="media/service-health-portal-update/services-issue-resource-health-1.png":::

## Health alerts

The Health Alerts blade allows you to search for and sort your alert rules by name. You can also group alert rules by subscription and status. 
<br>An alert is triggered when the specified conditions are met. You can click directly on any alert rule for more information, and details and see the alert firing history. You can click on the link of any alert to see more details. For more information on Service Health Alerts, see [Configure Service Health alerts using Azure Portal](alerts-activity-log-service-notifications-portal.md)

:::image type="content" source="media/service-health-portal-update/health-alerts-filter.png" alt-text="A screenshot highlighting the health alerts blade filters." lightbox="media/service-health-portal-update/health-alerts-filter.png":::

<!--
:::image type="content" source="media/service-health-portal-update/services-issue-resource-health-alerts.png" alt-text="A screenshot of the health alerts blade." lightbox="media/service-health-portal-update/services-issue-resource-health-alerts.png":::
-->


