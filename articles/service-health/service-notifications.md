---
title: View service health notifications from the Azure portal
description: View your service health notifications in the Azure portal. The Azure infrastructure publishes Service health notifications into the Azure activity log.
ms.topic: how-to
ms.date: 8/11/2025
---

# View service health notifications from the Azure portal

Azure infrastructure publishes Service health notifications into the [Azure activity log](../azure-monitor/essentials/platform-logs-overview.md). The notifications contain information about the resources under your subscription.<br> 
Given that there could be large volume of information stored in the activity log, there's a separate user interface to make it easier to view and set up alerts on service health notifications.

Service health notifications can be informational or actionable, depending on the class.

For more information on the various classes of service health notifications, see [Service health notifications properties](service-health-notifications-properties.md).

## View your service health notifications in the Azure portal

In the [Azure portal](https://portal.azure.com), select **Monitor**.


Azure Monitor brings together all your monitoring settings and data into one consolidated view.

:::image type="content" source="media/service-notifications/azure-main-service-health.png" alt-text="Screenshot of the Azure portal home page."  Lightbox="media/service-notifications/azure-main-service-health.png":::

You can create an alert rule in two ways:<br>

1. Directly in Azure Monitor:<br>
    Select **Create alert rules** from the Monitor screen to create it directly in Azure.<br> 
        
1. In the Service Health portal:
    1. Select **View Service health** to open the Azure Service Health portal.<br>
    2. Select **Create service health alert**  and set up an alert to ensure you're notified for future service notifications.<br>
    3. Select **+Create/Add activity log alert**, and set up an alert to ensure you're notified for future service notifications.<br>        
 
For more information, see [Create activity log alerts on service notifications](./alerts-activity-log-service-notifications-portal.md).


## Next steps

* Learn more about [activity log alerts](/azure/azure-monitor/alerts/alerts-types).
* Learn more about Service Health notifications [Service Health notification updates](service-health-notifications-properties.md).
