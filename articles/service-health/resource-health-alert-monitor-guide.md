---
title: Resource Health Alerts in Azure portal
description: Resource health alerts notify you when your Azure resources become unavailable.
ms.topic: conceptual - article
ms.date: 12/22/2025
---

# Resource Health alerts 

Resource Health alerts in Azure Service Health are a proactive monitoring feature that notifies you when the health status of individual Azure resources such as virtual machines, storage accounts, or web apps change.
<br>
These alerts are distinct from general Service Health alerts, which focus on broader platform-level issues. 


## Resource Health alert notifications

:::image type="content" source="./media/resource-health/resource-health-alerts.PNG" alt-text="Screenshot of Resource Health alerts." lightbox="./media/resource-health/resource-health-alerts.PNG":::

Resource Health alerts are created when the health status of a specific Azure resource changes. The types of health status include:

**Available** – The resource is healthy and operating normally.<br>
**Unavailable** – The resource is down or unreachable.<br>
**Degraded** – The resource is experiencing performance or connectivity issues.<br>
**Unknown** – Azure is unable to determine the health of the resource.

Unlike Service Health alerts, which are tied to known platform-wide issues (like regional outages), Resource Health alerts are resource-specific and can detect issues even when no broader Azure incident is occurring. For more information, see [Resource Health overview](resource-health-overview.md).

Here's a quick reference table for Resource Health alert conditions:


|Condition         |Possible value   |When to use |
|------------------|-----------------|------------|
|Event status      |Active, Resolved, In progress |**Active**: Get notified when an issue starts.<br> **Resolved**: Track the recovery.<br> **In progress**: Monitor any ongoing corrections and repairs.        |
|Resource status   |Available, Unavailable, Degraded, Unknown |**Unavailable**: Respond to outages. <br> **Degraded**: Address any performance issues.<br>**Unknown**: Investigate any missing health information.         |
|Status transition |Previous to Current |**Example**: A resource that was unavailable now is available.<br> *Use this option for Service Level Agreement (SLA) tracking or recovery alerts.*         |
|Reason type       |Platform initiated or User initiated |**Platform initiated**: This setting would be an Azure maintenance or incident. <br>**User initiated**: a user stops or deallocates a resource.          |


For steps on how to create a Resource Health alert, see [Create a Resource Health alert](resource-health-alert-arm-template-guide.md).

## Resource Health alerts in the Azure portal
Azure Resource Health keeps you informed about the current and historical health status of your Azure resources. These alerts notify you when these resources have a change in their health status.

Resource health notifications are stored in the [Azure activity log](../azure-monitor/essentials/platform-logs-overview.md). Given the possibly large volume of information stored in the activity log, there's a separate user interface to make it easier to view and set up alerts on resource health notifications.

You can receive an alert when Azure resource sends resource health notifications to your Azure subscription. You can configure an alert based on:

* The subscription affected.
* The resource types affected.
* The resource groups affected.
* The resources affected.
* The event statuses of the resources affected.
* The resources affected statuses.
* The reasons and types of the resources affected.

You can also receive an alert when an Azure resource sends resource health notifications to your Azure subscription using your action groups. To configure the alert:

* Select an existing action group.
* Select a new action group that can be used for future alerts.

To learn more about action groups, see [Azure Monitor action groups](../azure-monitor/alerts/action-groups.md).


## For more information

Learn more about Resource Health:

* [Azure Resource Health overview](Resource-health-overview.md)
* [Resource types and health checks available through Azure Resource Health](resource-health-checks-resource-types.md)

Create Service Health Alerts:

* [Configure Alerts for Service Health](./alerts-activity-log-service-notifications-portal.md) 
* [Azure Activity Log event schema](../azure-monitor/essentials/activity-log-schema.md)
* [Configure resource health alerts](./resource-health-alert-arm-template-guide.md)
