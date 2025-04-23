---
ms.topic: include
ms.date: 02/02/2025
---

| Resource | Default limit | Maximum limit |
|----------|---------------|---------------|
| Metric alerts | 5,000 active alert rules per subscription in Azure public, Microsoft Azure operated by 21Vianet, and Azure Government clouds. If you're hitting this limit, explore if you can use the [same type multi-resource alerts](../alerts-metric-overview.md#monitoring-at-scale-using-metric-alerts-in-azure-monitor).<br>10,000 metric time-series per alert rule. | Call support. |
| Activity log alerts | 100 active alert rules per subscription (can't be increased).<br>As this limit can't be increased, consider [sending your Activity Logs to a Log Analytics workspace](../../essentials/activity-log.md#send-to-log-analytics-workspace) and creating log search alerts instead, if you need a larger number of rules per subscription. | Same as default. |
| Log alerts | 5,000 active alert rules per subscription. Out of which, 100 active alert rules with a 1-minute frequency.<br>1,000 active alert rules per resource.<br>Each stateless alert rule can trigger up to 6,000 alerts per evaluation.<br>Each stateful alert rule can trigger up to 300 alerts per evaluation.<br>Up to 5,000 fired stateful alerts at a time per alert rule.<br>The combined size of all data in the log alert rule properties can't exceed 64 KB.<br>The Kusto query results can't exceed more than 20 MB. | Call support. |
| Alert processing rules | 1,000 active rules per subscription. | Call support. |
| Alert rules and alert processing rules description length| Log search alerts 4,096 characters.<br>All others are 2,048 characters. | Same as default. |

### Alerts API

Azure Monitor alerts have several throttling limits to protect against users making an excessive number of calls. Such behavior can potentially overload the system back-end resources and jeopardize service responsiveness. The following limits are designed to protect customers from interruptions and ensure a consistent service level. The user throttling and limits are designed to affect only extreme usage scenarios. They shouldn't be relevant for typical usage.

> [!NOTE]
> There is a limit of API calls per instance. The exact limit number depands on the number of instances.

| Resource                                                                                | Default limit                           | Maximum limit   |
|-----------------------------------------------------------------------------------------|-----------------------------------------|-----------------|
| [Alerts - Get Summary](/rest/api/monitor/alertsmanagement/alerts/get-summary)           | 50 calls per minute per subscription    | Same as default |
| [Alerts - Get All](/rest/api/monitor/alertsmanagement/alerts/get-all) (not "Get By ID") | 100 calls per minute per subscription   | Same as default |
| [All other alerts calls](/rest/api/monitor/alertsmanagement/alerts)                     | 1,000 calls per minute per subscription | Same as default |

