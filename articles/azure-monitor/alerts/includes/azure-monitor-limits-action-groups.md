---
ms.topic: include
ms.date: 04/25/2023
---

You can have an unlimited number of action groups in a subscription. (ARM resource group limits still apply [See more](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resources-without-resource-group-limit)).

| Resource | Default limit | Maximum limit |
|----------|---------------|---------------|
| **Notifications (rate limits)** | **Per subscription:** 300 notifications per minute per region.<br>**Per alert rule:** 100 notifications every 5 minutes per region.<br>**Per action groupbr>**Service Health (per rule):** 150 notifications every 5 minutes per region.<br>**Service Health (per subscription):** 200 notifications per minute per region.<br>**Test (per action group):** 2 test notifications every 5 minutes per region.<br>**Test (per subscription):** 5 test notifications every 5 minutes per region. | Same as Default |
| Azure app push | 10 Azure app actions per action group. | Same as Default |
| Email | 1,000 email actions in an action group.<br>No more than 100 emails every hour for each email address per region.<br>The character limit in an e-mail address is 64.<br>The character limit in an e-mail is 55296.<br>Also see [Service limits for notifications](../action-groups.md#service-limits-for-notifications). | Same as Default |
| Email Azure Resource Manager role | 10 Email ARM role actions per action group.<br>In production: No more than 100 emails in an hour per region.<br>In a test action group: No more than two emails in every one (1) minute. | Same as Default |
| Event Hubs | 10 Event Hubs actions per action group. | Same as Default |
| ITSM | 10 ITSM actions in an action group. | Same as Default |
| Logic app | 10 logic app actions in an action group. | Same as Default |
| Runbook | 10 runbook actions in an action group. | Same as Default |
| Secure Webhook | 10 secure webhook actions in an action group.<br>Maximum number of webhook calls is 1500 per minute per subscription. | Same as Default |
| SMS | 10 SMS actions in an action group.<br>In production: No more than one SMS message every five minutes.<br>In a test action group: No more than one SMS every one minute. | Same as Default |
| Voice | 10 voice actions in an action group.<br>In production: No more than one voice call every five minutes.<br>In a test action group: No more than one voice call every one minute. | Same as Default |
| Webhook | 10 webhook actions in an action group.<br>Maximum number of webhook calls is 1500 per minute per subscription. | Same as Default |

#### Avoiding rate limits
1. Deploy action groups across multiple regions - Regional limits apply per region. Distributing action groups across East US, West Europe, and Southeast Asia triples available capacity. ([All Action Group supported regions](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups#:~:text=live%2Dsite%20incidents.-,Regional,-The%20action%20group))
2. Consolidate alert rules - Use multi-resource alerts instead of creating duplicate rules per resource.
3. Use stateful alerts - Reduces notifications by alerting only on state changes.
4. Tune evaluation frequency - Use longer intervals (5+ minutes) for non-critical alerts.
5. Avoid action group reuse - Don't share one action group across hundreds of alert rules.
