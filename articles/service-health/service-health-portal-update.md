---
title: Azure Service Health Portal
description: The Azure Service Health portal experience lets users engage with service events and manage actions to maintain the business continuity of impacted applications.
ms.topic: overview
ms.date: 4/28/2025
---

# Azure Service Health Portal

The Azure Service Health portal experience lets users engage with service events and manage actions and alerts to maintain the business continuity of impacted applications.

:::image type="content" source="media/service-health-portal-update/services-issue-window-1.png" alt-text="A screenshot of the services issue user interface highlighting the switch to classic button." lightbox="media/service-health-portal-update/services-issue-window-1.png":::


## Highlights


##### Service Issues Blade
The Service Issues blade shows a map with all the user services across the world. The information on this blade helps you find services that might be impacted from an outage based on your subscription or tenant admin access.

##### Health Alerts Blade
The Health Alerts blade allows you to search for and sort your alert rules by name. You can also group alert rules by subscription and status.
:::image type="content" source="media/service-health-portal-update/health-alerts-filter.png" alt-text="A screenshot highlighting the health alerts blade filters." lightbox="media/service-health-portal-update/health-alerts-filter.png":::

An alert is triggered when the specified conditions are met. You can click directly on any alert rule for more information, and details and see the alert firing history. 

:::image type="content" source="media/service-health-portal-update/health-alerts-history.png" alt-text="A screenshot highlighting alerts history" lightbox="media/service-health-portal-update/health-alerts-history.png":::

>[!Note]
>The classic experience for the Health Alerts blade will be retired. Users will not be able to switch back from the new experience once it is rolled out.

> [!IMPORTANT]
>Customers are observing a mismatch in the number of health advisories between the Azure Resource Graph query results and the service health blade.
> 
>This behavior is expected as the backend query for the service health blade on the portal merges the results by tracking ID. So, from Resource Graph, the responses contain multiple communications for one tracking ID.
>
>Although the Resource Graph query returns multiple responses for each tracking ID, the service health blade on the portal aggregates the results into one event.
>
>As a result, the Resource Graph query returns a significantly higher number of health advisories compared to what is shown on the portal, leading to confusion and concerns regarding the accuracy of the service health information.


##### Tenant Level View
Users with [tenant admin access](admin-access-reference.md#roles-with-tenant-admin-access), can view events at the tenant scope. The Service Issues, Health Advisories, Security Advisories, and Health History blades show events both at tenant and subscription levels. 

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

## Health Advisories
Open this blade to see all the Health Advisories based on your access level. For more information, see [View service health notifications by using the Azure portal](service-notifications.md)

:::image type="content" source="media/service-health-portal-update/services-issue-health-advisories.png" alt-text="A screenshot of the health advisories blade." lightbox="media/service-health-portal-update/services-issue-health-advisories.png":::

## Securitiy Advisories
This blade all the current security advisories based on your subscription. For more information, see [Elevated access for viewing Security Advisories](security-advisories-elevated-access.md)

:::image type="content" source="media/service-health-portal-update/health-alerts-security.png" alt-text="A screenshot of the security advisories blade." lightbox="media/service-health-portal-update/health-alerts-security.png":::


## Billing Updates
If you have access as a subscription owner or contributor, you'll see the billing updates on this page. For more information, see [In-Portal Billing](billing-elevated-access.md)

:::image type="content" source="media/service-health-portal-update/in-portal-billing-blade.png" alt-text="A screenshot of the Billing updates blade." lightbox="media/service-health-portal-update/in-portal-billing-blade.png":::


## Resource health
This page watches your resource and tells you if it's running as expected. There are links that open directly to information about the health of your selected resource. 

:::image type="content" source="media/service-health-portal-update/services-issue-resource-health-1.png" alt-text="A screenshot of the Resource health blade." lightbox="media/service-health-portal-update/services-issue-resource-health-1.png":::

## Health alerts
Click on this blade to view any active Health Alerts based on your resources. You can click on the link of any alert to see more details. For more information on Service Health Alerts, see [Configure Service Health alerts using Azure Portal](alerts-activity-log-service-notifications-portal.md)

:::image type="content" source="media/service-health-portal-update/services-issue-resource-health-1.png" alt-text="A screenshot of the health alerts blade." lightbox="media/service-health-portal-update/services-issue-resource-health-1.png":::


