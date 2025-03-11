---
author: AbbyMSFT
ms.author: abbyweisberg
ms.service: azure-monitor
ms.topic: include
ms.date: 03/07/2025
---

Azure Monitor alerts offer a high degree of reliability without any design decisions. Conditions where a temporary loss of alert data may occur are often mitigated by features of other Azure Monitor components.

### Design checklist

> [!div class="checklist"]
> * Configure service health alert rules.
> * Configure resource health alert rules.
> * Avoid service limits for alert rules that produce large scale notifications.
 
### Configuration recommendations

| Recommendation | Benefit |
|:---------------|:--------|
| Configure service health alert rules. | Service health alerts send you notifications for outages, service disruptions, planned maintenance, and security advisories. For more information, see [Create Service Health alerts using the Azure portal](/azure/service-health/alerts-activity-log-service-notifications-portal). |
| Configure resource health alert rules. | Resource Health alerts can notify you in near real-time when these resources have a change in their health status. For more information, see [Create Resource Health alerts in the Azure portal](/azure/service-health/resource-health-alert-monitor-guide). |
| Avoid service limits for alert rules that produce large scale notifications. | If you have alert rules that would send a large number of notifications, you may reach your service limits for the service you use to send email or SMS notifications. Configure programmatic actions or choose an alternate notification method or provider to handle large scale notifications. For more information, see [Service limits for notifications](../alerts/action-groups.md#service-limits-for-notifications). |
