---
title: Supported metrics - Microsoft.Cache/redisEnterprise
description: Reference for Microsoft.Cache/redisEnterprise metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/31/2026
ms.custom: Microsoft.Cache/redisEnterprise, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Cache/redisEnterprise

The following table lists the metrics available for the Microsoft.Cache/redisEnterprise resource type.

**Table headings**

- **Metric** - The metric display name as it appears in the Azure portal.
- **Name in Rest API** - Metric name as referred to in the [REST API](/azure/azure-monitor/essentials/rest-api-walkthrough).
- **Advanced platform metrics** - A premium, [paid tier of platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform) in Azure Monitor that provide more granular observability for Azure resources.
- **Unit** - Unit of measure.
- **Aggregation** - The default [aggregation](/azure/azure-monitor/essentials/metrics-aggregation-explained) type. Valid values: Average, Minimum, Maximum, Total, Count.
- **Dimensions** - [Dimensions](/azure/azure-monitor/essentials/metrics-aggregation-explained#dimensions-splitting-and-filtering) available for the metric.
- **Time Grains** - [Intervals at which the metric is sampled](/azure/azure-monitor/essentials/metrics-aggregation-explained#granularity). For example, `PT1M` indicates that the metric is sampled every minute, `PT30M` every 30 minutes, `PT1H` every hour, and so on.
- **DS Export** - Shows whether the metric is exportable to Azure Monitor Logs via Diagnostic Settings.

For information on exporting metrics, see - [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics) and [Create diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/create-diagnostic-settings?tabs=portal).

For information on metric retention, see [Azure Monitor Metrics overview](/azure/azure-monitor/essentials/data-platform-metrics#retention-of-metrics).



|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Cache Hits**<br><br>Rate of read operations accessing an existing key, in operations per second. |`cachehits` | No | Count |Average |\<none\>|PT1M |Yes|
|**Cache Latency**<br><br>The average latency of requests on the node, in microseconds. |`cacheLatency` | No | MicroSeconds |Average |`InstanceId`|PT1M |Yes|
|**Cache Misses**<br><br>Rate of read operations accessing a non-existing key, in operations per second. |`cachemisses` | No | Count |Average |\<none\>|PT1M |Yes|
|**Cache Read**<br><br>The amount of data read from the cache in megabytes per second (MB/s). |`cacheRead` | No | BytesPerSecond |Maximum |`InstanceId`|PT1M |Yes|
|**Cache Write**<br><br>The amount of data written to the cache in megabytes per second (MB/s). |`cacheWrite` | No | BytesPerSecond |Maximum |`InstanceId`|PT1M |Yes|
|**Connected Clients**<br><br>The number of client connections to the cache. |`connectedclients` | No | Count |Maximum |`InstanceId`|PT1M |Yes|
|**Evicted Keys**<br><br>The rate of key evictions from the cache, in evictions per second. |`evictedkeys` | No | Count |Average |\<none\>|PT1M |Yes|
|**Expired Keys**<br><br>The rate of key expirations from the cache, in expirations per second. |`expiredkeys` | No | Count |Average |\<none\>|PT1M |Yes|
|**Geo Replication Healthy**<br><br>The health of geo replication in an Active Geo-Replication group. 0 represents Unhealthy and 1 represents Healthy. |`geoReplicationHealthy` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Gets**<br><br>The rate of get operations from the cache, in operations per second. |`getcommands` | No | Count |Average |\<none\>|PT1M |Yes|
|**Operations Per Second**<br><br>The rate of operations executed on the cache, in operations per second. |`operationsPerSecond` | No | CountPerSecond |Maximum |\<none\>|PT1M |Yes|
|**CPU**<br><br>The CPU utilization of the cache as a percentage. |`percentProcessorTime` | No | Percent |Maximum |`InstanceId`|PT1M |Yes|
|**Server Load**<br><br>The percentage of time the cluster is busy and not waiting idle. |`serverLoad` | No | Percent |Maximum |\<none\>|PT1M |Yes|
|**Sets**<br><br>The rate of set operations to the cache, in operations per second. |`setcommands` | No | Count |Average |\<none\>|PT1M |Yes|
|**Shard Hashes Items 1M to 8M Elements (Preview)**<br><br>Number of hash keys on this shard with between 1 million and 8 million fields. |`ShardHashesItems1MTo8M` | No | Count |Maximum |`InstanceId`, `Slots`, `Shard`, `Role`|PT1M |No|
|**Shard Hashes Items Over 8M Elements (Preview)**<br><br>Number of hash keys on this shard with more than 8 million fields. |`ShardHashesItemsOver8M` | No | Count |Maximum |`InstanceId`, `Slots`, `Shard`, `Role`|PT1M |No|
|**Shard Hashes Items Under 1M Elements (Preview)**<br><br>Number of hash keys on this shard with fewer than 1 million fields. |`ShardHashesItemsUnder1M` | No | Count |Maximum |`InstanceId`, `Slots`, `Shard`, `Role`|PT1M |No|
|**Shard Key Count (Preview)**<br><br>Total key count. |`ShardKeyCount` | No | Count |Maximum |`InstanceId`, `Slots`, `Shard`, `Role`|PT1M |Yes|
|**Shard Lists Items 1M to 8M Elements (Preview)**<br><br>Number of list keys on this shard with between 1 million and 8 million elements. |`ShardListsItems1MTo8M` | No | Count |Maximum |`InstanceId`, `Slots`, `Shard`, `Role`|PT1M |No|
|**Shard Lists Items Over 8M Elements (Preview)**<br><br>Number of list keys on this shard with more than 8 million elements. |`ShardListsItemsOver8M` | No | Count |Maximum |`InstanceId`, `Slots`, `Shard`, `Role`|PT1M |No|
|**Shard Lists Items Under 1M Elements (Preview)**<br><br>Number of list keys on this shard with fewer than 1 million elements. |`ShardListsItemsUnder1M` | No | Count |Maximum |`InstanceId`, `Slots`, `Shard`, `Role`|PT1M |No|
|**Shard Memory Clients Normal (Bytes) (Preview)**<br><br>Current memory used for input and output buffers of non-replica clients. |`ShardMemoryClientsNormalBytes` | No | Bytes |Maximum |`InstanceId`, `Slots`, `Shard`, `Role`|PT1M |Yes|
|**Shard Memory Clients Replica (Bytes) (Preview)**<br><br>Current memory used for input and output buffers of replica clients. |`ShardMemoryClientsReplicaBytes` | No | Bytes |Maximum |`InstanceId`, `Slots`, `Shard`, `Role`|PT1M |Yes|
|**Shard Memory Used (Bytes) (Preview)**<br><br>Memory used by this shard, in bytes. On flash-enabled SKUs, this includes both DRAM and flash usage. |`ShardMemoryUsedBytes` | No | Bytes |Maximum |`InstanceId`, `Slots`, `Shard`, `Role`|PT1M |Yes|
|**Shard Replication Link Up (Preview)**<br><br>Indicates if the replica is connected to its primary. |`ShardReplicationLinkUp` | No | Count |Minimum |`InstanceId`, `Slots`, `Shard`, `Role`|PT1M |Yes|
|**Shard Sets Items 1M to 8M Elements (Preview)**<br><br>Number of set keys on this shard with between 1 million and 8 million elements. |`ShardSetsItems1MTo8M` | No | Count |Maximum |`InstanceId`, `Slots`, `Shard`, `Role`|PT1M |No|
|**Shard Sets Items Over 8M Elements (Preview)**<br><br>Number of set keys on this shard with more than 8 million elements. |`ShardSetsItemsOver8M` | No | Count |Maximum |`InstanceId`, `Slots`, `Shard`, `Role`|PT1M |No|
|**Shard Sets Items Under 1M Elements (Preview)**<br><br>Number of set keys on this shard with fewer than 1 million elements. |`ShardSetsItemsUnder1M` | No | Count |Maximum |`InstanceId`, `Slots`, `Shard`, `Role`|PT1M |No|
|**Shard Strings Sizes Under 128 MB (Preview)**<br><br>Number of string keys on this shard with a memory size under 128 MB. |`ShardStringsSizesUnder128M` | No | Count |Maximum |`InstanceId`, `Slots`, `Shard`, `Role`|PT1M |No|
|**Shard Sorted Sets Items 1M to 8M Elements (Preview)**<br><br>Number of sorted set keys on this shard with between 1 million and 8 million elements. |`ShardZSetsItems1MTo8M` | No | Count |Maximum |`InstanceId`, `Slots`, `Shard`, `Role`|PT1M |No|
|**Shard Sorted Sets Items Over 8M Elements (Preview)**<br><br>Number of sorted set keys on this shard with more than 8 million elements. |`ShardZSetsItemsOver8M` | No | Count |Maximum |`InstanceId`, `Slots`, `Shard`, `Role`|PT1M |No|
|**Shard Sorted Sets Items Under 1M Elements (Preview)**<br><br>Number of sorted set keys on this shard with fewer than 1 million elements. |`ShardZSetsItemsUnder1M` | No | Count |Maximum |`InstanceId`, `Slots`, `Shard`, `Role`|PT1M |No|
|**Total Operations**<br><br>The rate of commands processed by the cache server, in operations per second. |`totalcommandsprocessed` | No | Count |Average |\<none\>|PT1M |Yes|
|**Total Keys**<br><br>The total number of items in the cache. |`totalkeys` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Used Memory**<br><br>The amount of cache memory used for key/value pairs, in bytes. |`usedmemory` | No | Bytes |Maximum |\<none\>|PT1M |Yes|
|**Used Memory Percentage**<br><br>The percentage of cache memory used for key/value pairs. |`usedmemorypercentage` | No | Percent |Maximum |\<none\>|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
