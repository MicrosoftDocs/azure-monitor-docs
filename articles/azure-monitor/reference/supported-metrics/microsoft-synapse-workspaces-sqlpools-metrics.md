---
title: Supported metrics - Microsoft.Synapse/workspaces/sqlPools
description: Reference for Microsoft.Synapse/workspaces/sqlPools metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Synapse/workspaces/sqlPools, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Synapse/workspaces/sqlPools

The following table lists the metrics available for the Microsoft.Synapse/workspaces/sqlPools resource type.

**Table headings**

**Metric** - The metric display name as it appears in the Azure portal.
**Name in Rest API** - Metric name as referred to in the [REST API](/azure/azure-monitor/essentials/rest-api-walkthrough).
**Unit** - Unit of measure.
**Aggregation** - The default [aggregation](/azure/azure-monitor/essentials/metrics-aggregation-explained) type. Valid values: Average, Minimum, Maximum, Total, Count.
**Dimensions** - [Dimensions](/azure/azure-monitor/essentials/metrics-aggregation-explained#dimensions-splitting-and-filtering) available for the metric.
**Time Grains** - [Intervals at which the metric is sampled](/azure/azure-monitor/essentials/metrics-aggregation-explained#granularity). For example, `PT1M` indicates that the metric is sampled every minute, `PT30M` every 30 minutes, `PT1H` every hour, and so on.
**DS Export**- Whether the metric is exportable to Azure Monitor Logs via Diagnostic Settings.

For information on exporting metrics, see - [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics) and [Create diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/create-diagnostic-settings?tabs=portal).

For information on metric retention, see [Azure Monitor Metrics overview](/azure/azure-monitor/essentials/data-platform-metrics#retention-of-metrics).


For a list of supported logs, see [Supported log categories - Microsoft.Synapse/workspaces/sqlPools](../supported-logs/microsoft-synapse-workspaces-sqlpools-logs.md)


### Category: SQL dedicated pool
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Active queries**<br><br>The active queries. Using this metric unfiltered and unsplit displays all active queries running on the system |`ActiveQueries` |Count |Total (Sum) |`IsUserDefined`|PT1M |No|
|**Adaptive cache hit percentage**<br><br>Measures how well workloads are utilizing the adaptive cache. Use this metric with the cache hit percentage metric to determine whether to scale for additional capacity or rerun workloads to hydrate the cache |`AdaptiveCacheHitPercent` |Percent |Maximum, Minimum, Average |\<none\>|PT1M |No|
|**Adaptive cache used percentage**<br><br>Measures how well workloads are utilizing the adaptive cache. Use this metric with the cache used percentage metric to determine whether to scale for additional capacity or rerun workloads to hydrate the cache |`AdaptiveCacheUsedPercent` |Percent |Maximum, Minimum, Average |\<none\>|PT1M |No|
|**Connections**<br><br>Count of Total logins to the SQL pool |`Connections` |Count |Total (Sum) |`Result`|PT1M |Yes|
|**Connections blocked by firewall**<br><br>Count of connections blocked by firewall rules. Revisit access control policies for your SQL pool and monitor these connections if the count is high |`ConnectionsBlockedByFirewall` |Count |Total (Sum) |\<none\>|PT1M |No|
|**CPU used percentage**<br><br>CPU utilization across all nodes in the SQL pool |`CPUPercent` |Percent |Maximum, Minimum, Average |\<none\>|PT1M |No|
|**DWU limit**<br><br>Service level objective of the SQL pool |`DWULimit` |Count |Maximum, Minimum, Average |\<none\>|PT1M |No|
|**DWU used**<br><br>Represents a high-level representation of usage across the SQL pool. Measured by DWU limit * DWU percentage |`DWUUsed` |Count |Maximum, Minimum, Average |\<none\>|PT1M |No|
|**DWU used percentage**<br><br>Represents a high-level representation of usage across the SQL pool. Measured by taking the maximum between CPU percentage and Data IO percentage |`DWUUsedPercent` |Percent |Maximum, Minimum, Average |\<none\>|PT1M |No|
|**Local tempdb used percentage**<br><br>Local tempdb utilization across all compute nodes - values are emitted every five minute |`LocalTempDBUsedPercent` |Percent |Maximum, Minimum, Average |\<none\>|PT1M |No|
|**Memory used percentage**<br><br>Memory utilization across all nodes in the SQL pool |`MemoryUsedPercent` |Percent |Maximum, Minimum, Average |\<none\>|PT1M |No|
|**Queued queries**<br><br>Cumulative count of requests queued after the max concurrency limit was reached |`QueuedQueries` |Count |Total (Sum) |`IsUserDefined`|PT1M |No|

### Category: SQL dedicated pool - Workload management
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Workload group active queries**<br><br>The active queries within the workload group. Using this metric unfiltered and unsplit displays all active queries running on the system |`WLGActiveQueries` |Count |Total (Sum) |`IsUserDefined`, `WorkloadGroup`|PT1M |No|
|**Workload group query timeouts**<br><br>Queries for the workload group that have timed out. Query timeouts reported by this metric are only once the query has started executing (it does not include wait time due to locking or resource waits) |`WLGActiveQueriesTimeouts` |Count |Total (Sum) |`IsUserDefined`, `WorkloadGroup`|PT1M |No|
|**Workload group allocation by max resource percent**<br><br>Displays the percentage allocation of resources relative to the Effective cap resource percent per workload group. This metric provides the effective utilization of the workload group |`WLGAllocationByEffectiveCapResourcePercent` |Percent |Maximum, Minimum, Average |`IsUserDefined`, `WorkloadGroup`|PT1M |No|
|**Workload group allocation by system percent**<br><br>The percentage allocation of resources relative to the entire system |`WLGAllocationBySystemPercent` |Percent |Maximum, Minimum, Average, Total (Sum) |`IsUserDefined`, `WorkloadGroup`|PT1M |No|
|**Effective cap resource percent**<br><br>The effective cap resource percent for the workload group. If there are other workload groups with min_percentage_resource > 0, the effective_cap_percentage_resource is lowered proportionally |`WLGEffectiveCapResourcePercent` |Percent |Maximum, Minimum, Average |`IsUserDefined`, `WorkloadGroup`|PT1M |No|
|**Effective min resource percent**<br><br>The effective min resource percentage setting allowed considering the service level and the workload group settings. The effective min_percentage_resource can be adjusted higher on lower service levels |`WLGEffectiveMinResourcePercent` |Percent |Minimum, Maximum, Average, Total (Sum) |`IsUserDefined`, `WorkloadGroup`|PT1M |No|
|**Workload group queued queries**<br><br>Cumulative count of requests queued after the max concurrency limit was reached |`WLGQueuedQueries` |Count |Total (Sum) |`IsUserDefined`, `WorkloadGroup`|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
