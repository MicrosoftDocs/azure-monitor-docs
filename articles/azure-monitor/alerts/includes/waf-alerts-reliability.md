---
ms.topic: include
ms.date: 4/24/2026
---

Azure Monitor alerts offer high reliability without any design decisions. Features of other Azure Monitor components often mitigate conditions where a temporary loss of alert data might occur.

### Design checklist

> [!div class="checklist"]
> * Configure service health alert rules.
> * Configure resource health alert rules.
> * Avoid service limits for alert rules that produce large scale notifications.
 
### Configuration recommendations

| Recommendation | Benefit |
|:---------------|:--------|
| Configure service health alert rules. | Service Health alerts send you notifications for outages, service disruptions, planned maintenance, and security advisories. For best coverage, configure both subscription-level and tenant-level Service Health alert rules, because events can be scoped at either level. For more information, see [Create Service Health alerts](/azure/service-health/alerts-activity-log-service-notifications-portal) and [Create tenant level service health alerts (preview)](../alerts-create-tenant-level-service-heath-alerts.md). |
| Configure resource health alert rules. | Resource Health alerts can notify you in near real-time when these resources have a change in their health status. For more information, see [Create Resource Health alerts in the Azure portal](/azure/service-health/resource-health-alert-monitor-guide). |
| Avoid service limits for alert rules that produce large scale notifications. | If you have alert rules that send a large number of notifications, you might reach your service limits for the service you use to send email or SMS notifications. Configure programmatic actions or choose an alternate notification method or provider to handle large scale notifications. For more information, see [Service limits for notifications](../action-groups.md#service-limits-for-notifications). |
