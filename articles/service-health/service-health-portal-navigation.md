---
title: Service Health portal navigation
description: Learn how to use the Service Health portal and navigate through each blade
ms.topic: overview
ms.date: 06/19/2025

---

# Service Health portal overview 


The Azure Service Health portal is a personalized dashboard within the Azure portal that helps you stay informed about the health of your Azure services and resources. It provides real-time insights and alerts about service issues, planned maintenance, health advisories, and security advisories that could have an impact on your environment.

The portal provides you with a customizable dashboard, which tracks the health of your Azure services in the regions where you use them. In this dashboard, you can track active events like ongoing service issues, upcoming planned maintenance, or relevant health advisories. When events become inactive, they get placed in your health history for up to 90 days. Finally, you can use the Service Health dashboard to create and manage service health alerts, which proactively notify you when service issues are affecting you.

This article explains how to navigate around the portal and where to find the information you're looking for.

## Get started with Service Health

Open the Service Health Portal from the Azure Status page.
Sign in and you see the main screen with several blades that provide you with information about the health and status of your Azure services and resources. For more information, see [Service Health Overview](overview.md)

For active events:
- Service issues
- Planned maintenance
- Health advisories
- Security advisories
- Billing updates

View your service health history
- Health history

Resource Health
- Resource health

See the alerts you set up
- Health alerts

Select the name on the left menu to open the blade to view and sort the information about your subscriptions.

## Service Health menu guide

### Search
On the top menu you can search resources, services, and documents from the top of the page.

:::image type="content" source="media/service-health-navigation/portal-search-icons.png" alt-text="A screenshot of Service Health main window." lightbox="media/service-health-navigation/portal-search-icons.png":::

Or you can type in the box to search for a specific topic.

:::image type="content" source="media/service-health-navigation/portal-search-topic.png" alt-text="A screenshot of Service Health main window." lightbox="media/service-health-navigation/portal-search-topic.png":::


### Copilot
If you have any questions select the icon to start a conversation with Copilot. For more information, read [Understanding Copilot in Service Health](understand-service-health.md).

:::image type="content" source="media/service-health-navigation/portal-copilot.png" alt-text="A screenshot of Service Health main and prompt to chat with Copilot." lightbox="media/service-health-navigation/portal-copilot.png":::


### Notifications
To see a list of all the notifications, select the bell in the top menu.

:::image type="content" source="media/service-health-navigation/portal-search-notifications.png" alt-text="A screenshot of Service Health list of all current notifications." lightbox="media/service-health-navigation/portal-copilot.png":::

### Support and Troubleshooting

For any troubleshooting or support select the question mark (?).

:::image type="content" source="media/service-health-navigation/portal-troubleshooting.png" alt-text="A screenshot of Service Health troubleshooting and support options." lightbox="media/service-health-navigation/portal-troubleshooting.png":::

### Portal settings

To see information about your subscriptions, directories, or even to change the appearance of your portal select the gear icon.

:::image type="content" source="media/service-health-navigation/portal-subscription.png" alt-text="A screenshot of Service Health subscription information." lightbox="media/service-health-navigation/portal-subscription.png":::


## Related content

Learn more about Resource Health:

* [Azure Resource Health overview](Resource-health-overview.md)
* [Resource types and health checks available through Azure Resource Health](resource-health-checks-resource-types.md)

Create Service Health Alerts:

* [Configure Alerts for Service Health](./alerts-activity-log-service-notifications-portal.md) 
* [Azure Activity Log event schema](../azure-monitor/essentials/activity-log-schema.md)
* [Configure resource health alerts using Resource Manager templates](./resource-health-alert-arm-template-guide.md)