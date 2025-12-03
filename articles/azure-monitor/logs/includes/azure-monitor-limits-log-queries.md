---
ms.topic: include
ms.date: 07/22/2019
---

### General query limits

| Limit | Description |
|:------|:------------|
| Query language | Azure Monitor uses the same [Kusto Query Language (KQL)](/azure/kusto/query/) as Azure Data Explorer. See [Azure Monitor log query language differences](/azure/data-explorer/kusto/query/) for KQL language elements not supported in Azure Monitor. |
| Azure regions | Log queries can experience excessive overhead when data spans Log Analytics workspaces in multiple Azure regions. See [Query limits](../scope.md#query-scope-limits) for details. |
| Cross resource queries | Maximum number of Application Insights resources and Log Analytics workspaces in a single query limited to 100.<br>Cross-resource query isn't supported in View Designer.<br>Cross-resource query in log alerts is supported in the new scheduledQueryRules API.<br>See [Cross-resource query limits](../cross-workspace-query.md#considerations) for details. |
| Log Analytics dashboard queries | Maximum number of records returned in a single Log Analytics dashboard query is 2,000. |

### User query throttling

Azure Monitor has several throttling limits to protect back-end system resources against users sending an excessive number of queries and ensure consistent service level. These per user limits reflect extreme usage scenarios and shouldn't be relevant for typical query behavior.

| Measure | Limit per user | Description |
|:--------|:---------------|:------------|
| Concurrent Analytics queries | 5 | A user can run up to five concurrent queries against Analytics tables. Additional queries are added to the concurrency queue in a first in, first out order (FIFO). When one of the concurrent running queries finishes, the first query from the queue is added to the concurrent queries and starts running. Alert queries aren't part of this limit. |
| Concurrent Basic and Auxiliary queries | 2 | A user can run up to two concurrent [search queries](..//basic-logs-query.md) against Basic and Auxiliary tables. Additional queries follow the same FIFO model in the concurrency queue. |
| Time in concurrency queue | 3 minutes | If a query sits in the queue for more than 3 minutes without being started, it's terminated with an HTTP error response with code 429. |
| Total queries in concurrency queue | 200 | When the number of queries in the queue reaches 200, the next query is rejected with an HTTP error code 429. This number is in addition to the five queries that can be running simultaneously. |
| Query rate | 200 queries per 30 seconds | Overall rate of queries that can be submitted by a single user to all workspaces. This limit applies to programmatic queries or queries initiated by visualization parts such as Azure dashboards and the Log Analytics workspace summary (deprecated) page. |
| Activity logs API query rate | 50 queries per 30 seconds | The [activity logs API](../../essentials/rest-activity-log.md) has a separate rate limit. |

Keep in mind these best practices to ensure system responsiveness:
* Optimize your queries as described in [Optimize log queries in Azure Monitor](../query-optimization.md).
* Dashboards and workbooks can contain multiple queries in a single view that generate a burst of queries every time they load or refresh. Consider breaking them up into multiple views that load on demand.
* In Power BI, consider extracting only aggregated results rather than raw logs. 
