---
title: Create Service Health alerts for Azure service notifications using Azure portal
description: Learn how to use the Azure portal to set up Service Health alerts.
ms.topic: quickstart
ms.date: 05/23/2025

---

# Create Service Health alerts using the Azure portal

## Overview

This article provides a step-by-step guide on how to configure alerts for Azure Service Health notifications through the Azure portal.  

Service Health notifications are stored in the [Azure activity log](../azure-monitor/essentials/platform-logs-overview.md). Given the large volume of information stored in the activity log, there's a separate user interface to make it easier to view and set up alerts on service health notifications. 

**Key Features**

- Alerts are based on the type of notification, affected subscription, services, and regions.
- They're created using the Azure portal’s Service Health interface.
- You can choose or create an "action group" to define who receives the alert.
- Alerts are only supported in public clouds within the global region.
- Advanced options allow for more detailed configurations, including webhook notifications for integration with external systems.

 You can receive an alert when Azure sends Service Health notifications to your Azure subscription. You can configure the alert based on

- The class of service health notification (Service issues, Planned maintenance, Health advisories, Security advisories)
- The subscription that is affected
- The services that are affected
- The regions that are affected

> [!NOTE]
> Service Health notifications don't send alerts for resource health events.

You also can configure who the alert should be sent to:

- Select an existing action group.
- Create a new action group (that can be used for future alerts).
> [!NOTE]
> Service Health Alerts are only supported in public clouds within the global region. For Action Groups to properly function in response to a Service Health Alert, the region of the action group must be set as "Global."

To learn more about action groups, see [Create and manage action groups](../azure-monitor/alerts/action-groups.md).

For information on how to configure service health notification alerts by using Azure Resource Manager templates, see [Resource Manager templates](../azure-monitor/alerts/alerts-activity-log.md).

## Create a Service Health alert using the Azure portal
1. In the [portal](https://portal.azure.com/), select **Service Health**.

    ![The "Service Health" service](media/alerts-activity-log-service-notifications/home-service-health.png)

1. In the **Service Issues** section, select **Create service health alert** to open a new window where you fill in the information required to create the alert. Follow the steps in the [create a new alert rule wizard](../azure-monitor/alerts/alerts-create-activity-log-alert-rule.md?tabs=activity-log).
    
    :::image type="content"source="media/alerts-activity-log-service-notifications/service-health-blades.png"alt-text="A screenshot of the Health alerts tab."Lightbox="media/alerts-activity-log-service-notifications/service-health-blades.png":::

   If you need to add more detailed information for the service health alert select **Advanced Options** which opens the page **Create an alert rule** so you can start entering your data.

    :::image type="content"source="media/alerts-activity-log-service-notifications/service-health-portal-create-alert-rule.png"alt-text="Screenshot of the Create service health alert command."Lightbox="media/alerts-activity-log-service-notifications/service-health-portal-create-alert-rule.png":::

Learn how to [Configure webhook notifications for existing problem management systems](service-health-alert-webhook-guide.md). For information on the webhook schema for activity log alerts, see [Webhooks for Azure activity log alerts](../azure-monitor/alerts/activity-log-alerts-webhook.md).


## Next steps
- Learn about [best practices for setting up Azure Service Health alerts](https://learn-video.azurefd.net/vod/player?id=771688cf-0348-44c4-ba48-f36bcd0aba3f).
- Learn how to [setup mobile push notifications for Azure Service Health](https://learn-video.azurefd.net/vod/player?id=4a3171ca-2104-4447-8f4b-c4d27f6dfe96).
- Learn how to [configure webhook notifications for existing problem management systems](service-health-alert-webhook-guide.md).
- Learn about [service health notifications](service-notifications.md).
- Learn about [notification rate limiting](../azure-monitor/alerts/alerts-rate-limiting.md).
- Review the [activity log alert webhook schema](../azure-monitor/alerts/activity-log-alerts-webhook.md).
- Get an [overview of activity log alerts](../azure-monitor/alerts/alerts-overview.md), and learn how to receive alerts.
- Learn more about [action groups](../azure-monitor/alerts/action-groups.md).