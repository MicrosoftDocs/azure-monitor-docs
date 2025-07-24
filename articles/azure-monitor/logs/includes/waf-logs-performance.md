---
ms.topic: include
ms.date: 03/30/2023
---

### Design checklist

> [!div class="checklist"]
> * Configure log query auditing and use Log Analytics workspace insights to identify slow and inefficient queries.

### Configuration recommendations

| Recommendation | Benefit |
|:---------------|:--------|
| Configure log query auditing and use Log Analytics workspace insights to identify slow and inefficient queries. | [Log query auditing](../query-audit.md) stores the compute time required to run each query and the time until results are returned. [Log Analytics workspace insights](../log-analytics-workspace-insights-overview.md#query-audit-tab) uses this data to list potentially inefficient queries in your workspace. Consider rewriting these queries to improve their performance. Refer to [Optimize log queries in Azure Monitor](../query-optimization.md) for guidance on optimizing your log queries. |
