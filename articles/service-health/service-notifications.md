---
title: View service health notifications from the Azure portal
description: View your service health notifications in the Azure portal. The Azure infrastructure publishes the Service health notifications  into the Azure activity log.
ms.topic: how-to
ms.date: 7/28/2025
---

# View service health notifications from the Azure portal

Azure infrastructure publishes Service health notifications into the [Azure activity log](../azure-monitor/essentials/platform-logs-overview.md). The notifications contain information about the resources under your subscription.<br> 
Given that there could be large volume of information stored in the activity log, there a separate user interfaces to make it easier to view and set up alerts on service health notifications.

Service health notifications can be informational or actionable, depending on the class.

For more information on the various classes of service health notifications, see [Service health notifications](service-health-notifications-properties.md).


## View your service health notifications in the Azure portal

1. In the [Azure portal](https://portal.azure.com), select **Monitor**.

    Azure Monitor brings together all your monitoring settings and data into one consolidated view.

:::image type="content" source="media/service-notifications/azure-main-service-health.png" alt-text="Screenshot Azure portal home page."  Lightbox="media/service-notifications/azure-main-service-health.png":::

1. Select **View Service health**.

1. You can create an alert rule in two ways:
    1. Select **Create alert rules** from the Monitor screen. 
    1. Select **View Service health** to open the Azure Service Health portal.
        1. Select **Create service health alert**  and set up an alert to ensure you're notified for future service notifications. 
    
For more information, see [Create activity log alerts on service notifications](./alerts-activity-log-service-notifications-portal.md).

## Next steps

* Learn more about [activity log alerts](/azure/azure-monitor/alerts/alerts-types).


