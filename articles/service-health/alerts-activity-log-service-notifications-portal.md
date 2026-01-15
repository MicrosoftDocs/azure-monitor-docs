---
title: Create Service Health alerts for Azure service notifications
description: Learn how to use the Azure portal to set up Service Health alerts.
ms.topic: quickstart
ms.date: 01/15/2026

---

# Create Service Health alerts
  

Azure stores Service Health notifications in the [Azure activity log](../azure-monitor/essentials/platform-logs-overview.md), along with other types of events. To help you quickly find what matters, Azure provides a dedicated Service Health experience where you can easily view these notifications and set up alerts.


This article provides a step-by-step guide on how to configure alerts for Azure Service Health notifications through the Azure portal.

When your alerts are created, you can view them on the Health alerts page. For more information, see [Resource Health alerts](resource-health-alert-monitor-guide.md). 

**Prerequisites**

To create or edit an alert rule, you must have the following permissions:

- Read permission on the target resource of the alert rule.
- Write permission on the resource group in which the alert rule is created.
- Read permission on any action group associated to the alert rule, if applicable.

For more information about Roles and access permissions, read [Roles, permissions and security in Azure Monitor](/azure/azure-monitor/fundamentals/roles-permissions-security).

## Service Health alerts overview

Alerts are based on the type of notification, affected subscription, tenant directories, services, and regions. They're created using the Azure portal’s Service Health interface.

You receive an alert when Azure sends Service Health notifications to your Azure subscription or tenant directory. You can configure the alert based on:

- The class of service health notification (Service issues, Planned maintenance, Health advisories, Security advisories)
- The subscription that is affected
- The services that are affected
- The regions that are affected
- The tenant directories that are affected


> [!NOTE]
> Service Health notifications don't send alerts for resource health events. For more information, see [Health alerts](resource-health-alert-monitor-guide.md).


For information on how to configure service health notification alerts by using Azure Resource Manager templates, see [Resource Manager templates](../azure-monitor/alerts/alerts-activity-log.md).

## Create a Service Health alert in the Azure portal
1. In the [portal](https://portal.azure.com/), select **Service Health**.

:::image type="content"source="media/alerts-activity-log-service-notifications/home-service-health.png"alt-text="A screenshot of Azure portal with link to open Service Health."Lightbox="media/alerts-activity-log-service-notifications/home-service-health.png":::

2. In the **Service Issues** panel, select **Create service health alert** to open a new window where you fill in the information required to create the alert. 

:::image type="content"source="media/alerts-activity-log-service-notifications/service-health-blades.png"alt-text="A screenshot of the Health alerts tab."Lightbox="media/alerts-activity-log-service-notifications/service-health-blades.png":::

On this panel you set up:

- **Scope** - select the scope level by *subscription*.
- **Condition** - select the *Services*, *Regions, and *Event types* from the drop-down menus.
- **Details** - select the *Resource group* and then create an *Alert rule name*.
- **Notify me by** - enter the email address to send the alerts to, select the *Email Azure Resource Manager Role* and if needed, the *Azure mobile app notification*.
    
>[!TIP]
> We recommend selecting **all Services and all Regions** when configuring Service Health alerts. Service Health only triggers alerts when events affect the regions where your services are running. As a result, selecting everything doesn't result in alerts for unused services or regions.

3. Select **Create** to finish the alert, or if you want to add more detailed information for the service health alert, select **Advanced Options** to add more information to your alert.


> [!NOTE]
> The option to create a Service Health alert isn't available on the Billing panel.

### Create Advanced options

The *Advanced Options* section lets you add more details and adjust how a Service Health alert works.
These settings don't change the Service Health events that Microsoft publishes. Instead, they control which events you're notified about and how you receive those notifications.

Use Advanced Options to choose the event types, services, regions, and notification actions for your alert. This section includes all the available settings you can use to customize alert behavior.

#### Scope
When you select **Advanced options**, the Scope tab opens first. 

On this tab, select the *Scope level* and *Subscription* from the drop-down menus to start.

:::image type="content"source="media/create-alerts/service-health-alert-scope.png"alt-text="Screenshot of the Scope tab."Lightbox="media/create-alerts/service-health-alert-scope.png":::
For more information, see [Create, or edit a metric alert rule](/azure/azure-monitor/alerts/alerts-create-metric-alert-rule?tabs=metric).

#### Condition
On the **Condition** tab, you configure when the alert rule should trigger by setting up the services, regions, and event types.

From the *Services* drop-down menu, select the Azure Resource types (for example, Action Groups or Activity Log) that you want this alert rule to monitor.

:::image type="content"source="media/create-alerts/service-health-alert-condition.png"alt-text="Screenshot of the Condition tab."Lightbox="media/create-alerts/service-health-alert-condition.png":::

From the *Regions* drop-down menu, select one or more locations of the service health event you want to monitor.
From the *Event types* drop-down menu, select the types of health events you want to monitor.

#### Actions
Use the **Actions** tab to select from existing groups, or create new action groups to set up the actions you want to happen with the alert triggers. For more information, see [Action groups](/azure/azure-monitor/alerts/alerts-create-metric-alert-rule?tabs=metric).

:::image type="content"source="media/create-alerts/service-health-alert-actions.png"alt-text="Screenshot of the Actions tab."Lightbox="media/create-alerts/service-health-alert-actions.png":::


The actions include:
- email recipients
- SMS notifications
- Azure app push notifications
- Webhook, Logic Apps, Functions, or ITSM integrations

:::image type="content"source="media/create-alerts/service-health-alert-actions-02.png"alt-text="Screenshot of the Create an action window."Lightbox="media/create-alerts/service-health-alert-actions-02.png":::

You also can configure who the alert should be sent to:

- Select an existing action group.
- Create a new action group that can be used for future alerts.
- 
> [!NOTE]
> Service Health Alerts are only supported in public clouds within the global region.
> 
>For Action Groups to properly function in response to a Service Health Alert, the region of the action group must be set as "Global."

#### Details

On the **Details** tab, you set up the details of the project by *Subscription* and *Resource group*. 
Then define the *Alert rule name* for the alert and add a description for more clarifications if needed.

:::image type="content"source="media/create-alerts/service-health-alert-details.png"alt-text="Screenshot of the Details tab."Lightbox="media/create-alerts/service-health-alert-details.png":::

Here you can select **Advanced options** to set up your own *Custom properties* to the alert.
:::image type="content"source="media/create-alerts/service-health-alert-advanced.png"alt-text="Screenshot of the Advanced settings section."Lightbox="media/create-alerts/service-health-alert-advanced.png":::

#### Tags

On the **Tags** tab, you can select tags and then assign a value for them. For more information, see [Learn about tags](/azure/azure-resource-manager/management/tag-resources?wt.mc_id=azuremachinelearning_inproduct_portal_utilities-tags-tab).

:::image type="content"source="media/create-alerts/service-health-alert-tags.png"alt-text="Screenshot of the Tags tab."Lightbox="media/create-alerts/service-health-alert-tags.png":::

#### Review + create
The **Review + Create** tab lets you review everything you selected. When you’re done, select *Create* to finish and create the alert.

:::image type="content"source="media/create-alerts/service-health-alert-final.png"alt-text="Screenshot of the Review and create tab."Lightbox="media/create-alerts/service-health-alert-final.png":::



<!--
### Create a tenant-level alert
>[!IMPORTANT]
>The option to select a tenant directory is currently in preview mode.
To set your alert for a tenant directory select **Directory (preview)** from the scope drop-down menu.

:::image type="content"source="./media/alerts-activity-log-service-notifications/service-health-blades-1.png"alt-text="A screenshot of the Health alerts tab for tenant-level alerts."Lightbox="./media/alerts-activity-log-service-notifications/service-health-blades-1.png":::

To add more detailed information for the service health alert, select **Advanced Options** which opens the page **Create an alert rule**, where you can start entering your data.

Under the **Details** tab, select the subscription and resource group where the alert group is to be saved.

:::image type="content"source="./media/alerts-activity-log-service-notifications/service-health-details.png"alt-text="Screenshot of the Details tab in Create service health alert command."Lightbox="./media/alerts-activity-log-service-notifications/service-health-details.png":::

Learn how to [Configure webhook notifications for existing problem management systems](service-health-alert-webhook-guide.md). 

For information on the webhook schema for activity log alerts, see [Webhooks for Azure activity log alerts](../azure-monitor/alerts/activity-log-alerts-webhook.md).
-->
> [!NOTE] 
> You can also create an alert at the tenant level. See [Create tenant level service health alerts (preview)](../azure-monitor/alerts/alerts-create-tenant-level-service-heath-alerts.md).

## More information
- Watch a video about [best practices for setting up Azure Service Health alerts](https://learn-video.azurefd.net/vod/player?id=771688cf-0348-44c4-ba48-f36bcd0aba3f).
- Learn how to [setup mobile push notifications for Azure Service Health](https://learn-video.azurefd.net/vod/player?id=4a3171ca-2104-4447-8f4b-c4d27f6dfe96).
- Learn how to [configure webhook notifications for existing problem management systems](service-health-alert-webhook-guide.md).
- Learn about [service health notifications](service-notifications.md).
- Learn about [notification rate limiting](../azure-monitor/alerts/alerts-rate-limiting.md).
- Review the [activity log alert webhook schema](../azure-monitor/alerts/activity-log-alerts-webhook.md).
- Get an [overview of activity log alerts](../azure-monitor/alerts/alerts-overview.md).
- Learn more about [action groups](../azure-monitor/alerts/action-groups.md).