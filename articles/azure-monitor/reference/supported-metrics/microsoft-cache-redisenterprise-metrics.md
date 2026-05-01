---
title: Supported metrics - Microsoft.Cache/redisEnterprise
description: Reference for Microsoft.Cache/redisEnterprise metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Cache/redisEnterprise, arm

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Cache/redisEnterprise

The following table lists the metrics available for the Microsoft.Cache/redisEnterprise resource type.

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



|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Cache Hits**<br><br>The number of successful key lookups. For more details, see https://aka.ms/redis/enterprise/metrics. |`cachehits` |Count |Total (Sum) |\<none\>|PT5M, PT1H |Yes|
|**Cache Latency Microseconds (Preview)**<br><br>The latency to the cache in microseconds. For more details, see https://aka.ms/redis/enterprise/metrics. |`cacheLatency` |Count |Average |`InstanceId`|PT5M, PT1H |Yes|
|**Cache Misses**<br><br>The number of failed key lookups. For more details, see https://aka.ms/redis/enterprise/metrics. |`cachemisses` |Count |Total (Sum) |\<none\>|PT5M, PT1H |Yes|
|**Cache Read**<br><br>The amount of data read from the cache in Megabytes per second (MB/s). For more details, see https://aka.ms/redis/enterprise/metrics. |`cacheRead` |BytesPerSecond |Maximum |`InstanceId`|PT5M, PT1H |Yes|
|**Cache Write**<br><br>The amount of data written to the cache in Megabytes per second (MB/s). For more details, see https://aka.ms/redis/enterprise/metrics. |`cacheWrite` |BytesPerSecond |Maximum |`InstanceId`|PT5M, PT1H |Yes|
|**Connected Clients**<br><br>The number of client connections to the cache. For more details, see https://aka.ms/redis/enterprise/metrics. |`connectedclients` |Count |Maximum |`InstanceId`|PT5M, PT1H |Yes|
|**Evicted Keys**<br><br>The number of items evicted from the cache. For more details, see https://aka.ms/redis/enterprise/metrics. |`evictedkeys` |Count |Total (Sum) |\<none\>|PT5M, PT1H |Yes|
|**Expired Keys**<br><br>The number of items expired from the cache. For more details, see https://aka.ms/redis/enterprise/metrics. |`expiredkeys` |Count |Total (Sum) |\<none\>|PT5M, PT1H |Yes|
|**Geo Replication Healthy**<br><br>The health of geo replication in an Active Geo-Replication group. 0 represents Unhealthy and 1 represents Healthy. For more details, see https://aka.ms/redis/enterprise/metrics. |`geoReplicationHealthy` |Count |Maximum |\<none\>|PT5M, PT1H |Yes|
|**Gets**<br><br>The number of get operations from the cache. For more details, see https://aka.ms/redis/enterprise/metrics. |`getcommands` |Count |Total (Sum) |\<none\>|PT5M, PT1H |Yes|
|**Operations Per Second**<br><br>The number of instantaneous operations per second executed on the cache. For more details, see https://aka.ms/redis/enterprise/metrics. |`operationsPerSecond` |Count |Maximum |\<none\>|PT5M, PT1H |Yes|
|**CPU**<br><br>The CPU utilization of the Azure Redis Cache server as a percentage. For more details, see https://aka.ms/redis/enterprise/metrics. |`percentProcessorTime` |Percent |Maximum |`InstanceId`|PT5M, PT1H |Yes|
|**Server Load**<br><br>The percentage of cycles in which the Redis server is busy processing and not waiting idle for messages. For more details, see https://aka.ms/redis/enterprise/metrics. |`serverLoad` |Percent |Maximum |\<none\>|PT5M, PT1H |Yes|
|**Sets**<br><br>The number of set operations to the cache. For more details, see https://aka.ms/redis/enterprise/metrics. |`setcommands` |Count |Total (Sum) |\<none\>|PT5M, PT1H |Yes|
|**Total Operations**<br><br>The total number of commands processed by the cache server. For more details, see https://aka.ms/redis/enterprise/metrics. |`totalcommandsprocessed` |Count |Total (Sum) |\<none\>|PT5M, PT1H |Yes|
|**Total Keys**<br><br>The total number of items in the cache. For more details, see https://aka.ms/redis/enterprise/metrics. |`totalkeys` |Count |Maximum |\<none\>|PT5M, PT1H |Yes|
|**Used Memory**<br><br>The amount of cache memory used for key/value pairs in the cache in MB. For more details, see https://aka.ms/redis/enterprise/metrics. |`usedmemory` |Bytes |Maximum |\<none\>|PT5M, PT1H |Yes|
|**Used Memory Percentage**<br><br>The percentage of cache memory used for key/value pairs. For more details, see https://aka.ms/redis/enterprise/metrics. |`usedmemorypercentage` |Percent |Maximum |\<none\>|PT5M, PT1H |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
