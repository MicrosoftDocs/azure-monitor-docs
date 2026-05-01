---
title: Supported metrics - Microsoft.ContainerService/managedClusters
description: Reference for Microsoft.ContainerService/managedClusters metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.ContainerService/managedClusters, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.ContainerService/managedClusters

The following table lists the metrics available for the Microsoft.ContainerService/managedClusters resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.ContainerService/managedClusters](../supported-logs/microsoft-containerservice-managedclusters-logs.md)


### Category: API Server
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**API Server CPU Usage Percentage**<br><br>Maximum CPU percentage (based off current limit) used by API server pod across instances |`apiserver_cpu_usage_percentage` |Percent |Maximum, Average |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |Yes|
|**API Server Memory Usage Percentage**<br><br>Maximum memory percentage (based off current limit) used by API server pod across instances |`apiserver_memory_usage_percentage` |Percent |Maximum, Average |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |Yes|

### Category: API Server (PREVIEW)
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Inflight Requests**<br><br>Maximum number of currently used inflight requests on the apiserver per request kind in the last second |`apiserver_current_inflight_requests` |Count |Total (Sum), Average |`requestKind`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|

### Category: Cluster Autoscaler (PREVIEW)
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Cluster Health**<br><br>Determines whether or not cluster autoscaler will take action on the cluster |`cluster_autoscaler_cluster_safe_to_autoscale` |Count |Total (Sum), Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Scale Down Cooldown**<br><br>Determines if the scale down is in cooldown - No nodes will be removed during this timeframe |`cluster_autoscaler_scale_down_in_cooldown` |Count |Total (Sum), Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Unneeded Nodes**<br><br>Cluster auotscaler marks those nodes as candidates for deletion and are eventually deleted |`cluster_autoscaler_unneeded_nodes_count` |Count |Total (Sum), Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Unschedulable Pods**<br><br>Number of pods that are currently unschedulable in the cluster |`cluster_autoscaler_unschedulable_pods_count` |Count |Total (Sum), Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|

### Category: ETCD
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**ETCD CPU Usage Percentage**<br><br>Maximum CPU percentage (based off current limit) used by ETCD pod across instances |`etcd_cpu_usage_percentage` |Percent |Maximum, Average |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |Yes|
|**ETCD Database Usage Percentage**<br><br>Maximum utilization of the ETCD database across instances |`etcd_database_usage_percentage` |Percent |Maximum, Average |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |Yes|
|**ETCD Memory Usage Percentage**<br><br>Maximum memory percentage (based off current limit) used by ETCD pod across instances |`etcd_memory_usage_percentage` |Percent |Maximum, Average |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |Yes|

### Category: Nodes
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Total number of available cpu cores in a managed cluster**<br><br>Total number of available cpu cores in a managed cluster |`kube_node_status_allocatable_cpu_cores` |Count |Total (Sum), Average |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Total amount of available memory in a managed cluster**<br><br>Total amount of available memory in a managed cluster |`kube_node_status_allocatable_memory_bytes` |Bytes |Total (Sum), Average |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Statuses for various node conditions**<br><br>Statuses for various node conditions |`kube_node_status_condition` |Count |Total (Sum), Average |`condition`, `status`, `status2`, `node`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|

### Category: Nodes (PREVIEW)
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**CPU Usage Millicores**<br><br>Aggregated measurement of CPU utilization in millicores across the cluster |`node_cpu_usage_millicores` |MilliCores |Maximum, Average |`node`, `nodepool`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |Yes|
|**CPU Usage Percentage**<br><br>Aggregated average CPU utilization measured in percentage across the cluster |`node_cpu_usage_percentage` |Percent |Maximum, Average |`node`, `nodepool`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |Yes|
|**Disk Used Bytes**<br><br>Disk space used in bytes by device |`node_disk_usage_bytes` |Bytes |Maximum, Average |`node`, `nodepool`, `device`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |Yes|
|**Disk Used Percentage**<br><br>Disk space used in percent by device |`node_disk_usage_percentage` |Percent |Maximum, Average |`node`, `nodepool`, `device`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |Yes|
|**Memory RSS Bytes**<br><br>Container RSS memory used in bytes |`node_memory_rss_bytes` |Bytes |Maximum, Average |`node`, `nodepool`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |Yes|
|**Memory RSS Percentage**<br><br>Container RSS memory used in percent |`node_memory_rss_percentage` |Percent |Maximum, Average |`node`, `nodepool`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |Yes|
|**Memory Working Set Bytes**<br><br>Container working set memory used in bytes |`node_memory_working_set_bytes` |Bytes |Maximum, Average |`node`, `nodepool`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |Yes|
|**Memory Working Set Percentage**<br><br>Container working set memory used in percent |`node_memory_working_set_percentage` |Percent |Maximum, Average |`node`, `nodepool`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |Yes|
|**Network In Bytes**<br><br>Network received bytes |`node_network_in_bytes` |Bytes |Maximum, Average |`node`, `nodepool`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |Yes|
|**Network Out Bytes**<br><br>Network transmitted bytes |`node_network_out_bytes` |Bytes |Maximum, Average |`node`, `nodepool`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |Yes|

### Category: Pods
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Number of pods by phase**<br><br>Number of pods by phase |`kube_pod_status_phase` |Count |Total (Sum), Average |`phase`, `namespace`, `pod`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|
|**Number of pods in Ready state**<br><br>Number of pods in Ready state |`kube_pod_status_ready` |Count |Total (Sum), Average |`namespace`, `pod`, `condition`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
