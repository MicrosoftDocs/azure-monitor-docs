---
ms.topic: include
ms.date: 02/03/2026
---

### Azure Monitor Logs strategies for optimizing performance

Azure Monitor Logs is a fully managed, cloud‑scale service designed to automatically handle ingestion, indexing, and querying across large and fluctuating workloads. Its underlying engine employs built‑in mechanisms that optimize query execution, distribute processing, and automatically scale resources seamlessly without user intervention. As with any large analytical system, running queries across very large datasets requires extra compute resources and might impact query performance. Use the following strategies to optimize performance, especially with large datasets and when querying over long time ranges. 

### Design checklist

> [!div class="checklist"]
> * Configure log query auditing
> * Use Log Analytics workspace insights to identify slow and inefficient queries.
> * Optimize your log queries.
> * Use summary tables to pre-aggregate large datasets for improved query performance.

### Configuration recommendations

| Recommendation | Benefit |
|:---------------|:--------|
| Configure log query auditing | [Log query auditing](../query-audit.md) stores the compute time required to run each query and the time until results are returned. |
| Use Log Analytics workspace insights to identify slow and inefficient queries. |  [Log Analytics workspace insights](../log-analytics-workspace-insights-overview.md#query-audit-tab) uses this data to list potentially inefficient queries in your workspace.|
| Optimize your log queries by following the guidance in [Optimize log queries in Azure Monitor](../query-optimization.md). | Well-optimized queries run faster and consume fewer resources, providing insights to data more quickly and are less likely to get throttled or rejected. Follow best practices for writing efficient Kusto Query Language (KQL) queries to improve performance. |
| Use summary tables to pre-aggregate large datasets for improved query performance. | Summary tables store pre-aggregated data that can be queried more efficiently than raw data. Use [summary rules](../summary-rules.md) to create and manage summary tables in your Log Analytics workspace. |

