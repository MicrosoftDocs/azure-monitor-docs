---
title: View service health notifications by using the Azure portal
description: View your service health notifications in the Azure portal. The Azure infrastructure publishes Service health notifications into the Azure activity log.
ms.topic: how-to
ms.date: 7/29/2025
---

# View service health notifications by using the Azure portal

Azure infrastructure publishes Service health notifications into the [Azure activity log](../azure-monitor/essentials/platform-logs-overview.md). The notifications contain information about the resources under your subscription.<br> 
Given that there could be large volume of information stored in the activity log, there's a separate user interface to make it easier to view and set up alerts on service health notifications.

Service health notifications can be informational or actionable, depending on the class.

For more information on the various classes of service health notifications, see [Service health notifications properties](service-health-notifications-properties.md).

## View your service health notifications in the Azure portal

1. In the [Azure portal](https://portal.azure.com), select **Monitor**.

    Azure Monitor brings together all your monitoring settings and data into one consolidated view. It first opens to the **Activity log** section.

1. Select **Service health**.

1. Select **+Create/Add activity log alert**, and set up an alert to ensure you're notified for future service notifications. For more information, see [Create activity log alerts on service notifications](./alerts-activity-log-service-notifications-portal.md).

## Next steps

* Learn more about [activity log alerts](/azure/azure-monitor/alerts/alerts-types).
	