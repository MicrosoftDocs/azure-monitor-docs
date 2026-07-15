---
title: Supported metrics - Microsoft.Cache/redis
description: Reference for Microsoft.Cache/redis metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: Microsoft.Cache/redis, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Cache/redis

The following table lists the metrics available for the Microsoft.Cache/redis resource type.

**Table headings**

- **Metric** - The metric display name as it appears in the Azure portal.
- **Name in Rest API** - Metric name as referred to in the [REST API](/azure/azure-monitor/essentials/rest-api-walkthrough).
- **Advanced platform metrics** - A premium, [paid tier of platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform) in Azure Monitor that provide more granular observability for Azure resources.
- **Unit** - Unit of measure.
- **Aggregation** - The default [aggregation](/azure/azure-monitor/essentials/metrics-aggregation-explained) type. Valid values: Average, Minimum, Maximum, Total, Count.
- **Dimensions** - [Dimensions](/azure/azure-monitor/essentials/metrics-aggregation-explained#dimensions-splitting-and-filtering) available for the metric.
- **Time Grains** - [Intervals at which the metric is sampled](/azure/azure-monitor/essentials/metrics-aggregation-explained#granularity). For example, `PT1M` indicates that the metric is sampled every minute, `PT30M` every 30 minutes, `PT1H` every hour, and so on.
- **DS Export** -S Whether the metric is exportable to Azure Monitor Logs via Diagnostic Settings.

For information on exporting metrics, see - [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics) and [Create diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/create-diagnostic-settings?tabs=portal).

For information on metric retention, see [Azure Monitor Metrics overview](/azure/azure-monitor/essentials/data-platform-metrics#retention-of-metrics).


For a list of supported logs, see [Supported log categories - Microsoft.Cache/redis](../supported-logs/microsoft-cache-redis-logs.md)


### Category: Cache
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Cache Hits (Instance Based)**<br><br>The number of successful key lookups. For more information, see https://aka.ms/redis/metrics. |`allcachehits` | No | Count |Total (Sum) |`ShardId`, `Port`, `Primary`|PT1M |Yes|
|**Cache Misses (Instance Based)**<br><br>The number of failed key lookups. For more information, see https://aka.ms/redis/metrics. |`allcachemisses` | No | Count |Total (Sum) |`ShardId`, `Port`, `Primary`|PT1M |Yes|
|**Cache Read (Instance Based)**<br><br>The amount of data read from the cache in bytes per second. For more information, see https://aka.ms/redis/metrics. |`allcacheRead` | No | BytesPerSecond |Maximum |`ShardId`, `Port`, `Primary`|PT1M |Yes|
|**Cache Write (Instance Based)**<br><br>The amount of data written to the cache in bytes per second. For more information, see https://aka.ms/redis/metrics. |`allcacheWrite` | No | BytesPerSecond |Maximum |`ShardId`, `Port`, `Primary`|PT1M |Yes|
|**Connected Clients (Instance Based)**<br><br>The number of client connections to the cache. For more information, see https://aka.ms/redis/metrics. |`allconnectedclients` | No | Count |Maximum |`ShardId`, `Port`, `Primary`|PT1M |Yes|
|**Connections Closed Per Second (Instance Based)**<br><br>The number of instantaneous connections closed per second on the cache via port 6379 or 6380 (SSL). For more information, see https://aka.ms/redis/metrics. |`allConnectionsClosedPerSecond` | No | CountPerSecond |Average, Minimum, Maximum, Count |`ShardId`, `Primary`, `Ssl`|PT1M |Yes|
|**Connections Created Per Second (Instance Based)**<br><br>The number of instantaneous connections created per second on the cache via port 6379 or 6380 (SSL). For more information, see https://aka.ms/redis/metrics. |`allConnectionsCreatedPerSecond` | No | CountPerSecond |Average, Minimum, Maximum, Count |`ShardId`, `Primary`, `Ssl`|PT1M |Yes|
|**Evicted Keys (Instance Based)**<br><br>The number of items evicted from the cache. For more information, see https://aka.ms/redis/metrics. |`allevictedkeys` | No | Count |Total (Sum) |`ShardId`, `Port`, `Primary`|PT1M |Yes|
|**Expired Keys (Instance Based)**<br><br>The number of items expired from the cache. For more information, see https://aka.ms/redis/metrics. |`allexpiredkeys` | No | Count |Total (Sum) |`ShardId`, `Port`, `Primary`|PT1M |Yes|
|**Gets (Instance Based)**<br><br>The number of get operations from the cache. For more information, see https://aka.ms/redis/metrics. |`allgetcommands` | No | Count |Total (Sum) |`ShardId`, `Port`, `Primary`|PT1M |Yes|
|**Operations Per Second (Instance Based)**<br><br>The number of instantaneous operations per second executed on the cache. For more information, see https://aka.ms/redis/metrics. |`alloperationsPerSecond` | No | Count |Maximum |`ShardId`, `Port`, `Primary`|PT1M |Yes|
|**CPU (Instance Based)**<br><br>The CPU utilization of the Azure Redis Cache server as a percentage. For more information, see https://aka.ms/redis/metrics. |`allpercentprocessortime` | No | Percent |Maximum |`ShardId`, `Port`, `Primary`|PT1M |Yes|
|**Server Load (Instance Based)**<br><br>The percentage of cycles in which the Redis server is busy processing and not waiting idle for messages. For more information, see https://aka.ms/redis/metrics. |`allserverLoad` | No | Percent |Maximum |`ShardId`, `Port`, `Primary`|PT1M |Yes|
|**Sets (Instance Based)**<br><br>The number of set operations to the cache. For more information, see https://aka.ms/redis/metrics. |`allsetcommands` | No | Count |Total (Sum) |`ShardId`, `Port`, `Primary`|PT1M |Yes|
|**Total Operations (Instance Based)**<br><br>The total number of commands processed by the cache server. For more information, see https://aka.ms/redis/metrics. |`alltotalcommandsprocessed` | No | Count |Total (Sum) |`ShardId`, `Port`, `Primary`|PT1M |Yes|
|**Total Keys (Instance Based)**<br><br>The total number of items in the cache. For more information, see https://aka.ms/redis/metrics. |`alltotalkeys` | No | Count |Maximum |`ShardId`, `Port`, `Primary`|PT1M |Yes|
|**Used Memory (Instance Based)**<br><br>The amount of cache memory used for key/value pairs in the cache in MB. For more information, see https://aka.ms/redis/metrics. |`allusedmemory` | No | Bytes |Maximum |`ShardId`, `Port`, `Primary`|PT1M |Yes|
|**Used Memory Percentage (Instance Based)**<br><br>The percentage of cache memory used for key/value pairs. For more information, see https://aka.ms/redis/metrics. |`allusedmemorypercentage` | No | Percent |Maximum |`ShardId`, `Port`, `Primary`|PT1M |Yes|
|**Used Memory RSS (Instance Based)**<br><br>The amount of cache memory used in MB, including fragmentation and metadata. For more information, see https://aka.ms/redis/metrics. |`allusedmemoryRss` | No | Bytes |Maximum |`ShardId`, `Port`, `Primary`|PT1M |Yes|
|**Cache Hits**<br><br>The number of successful key lookups. For more information, see https://aka.ms/redis/metrics. |`cachehits` | No | Count |Total (Sum) |`ShardId`|PT1M |Yes|
|**Cache Hits (Shard 0)**<br><br>The number of successful key lookups. For more information, see https://aka.ms/redis/metrics. |`cachehits0` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Cache Hits (Shard 1)**<br><br>The number of successful key lookups. For more information, see https://aka.ms/redis/metrics. |`cachehits1` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Cache Hits (Shard 2)**<br><br>The number of successful key lookups. For more information, see https://aka.ms/redis/metrics. |`cachehits2` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Cache Hits (Shard 3)**<br><br>The number of successful key lookups. For more information, see https://aka.ms/redis/metrics. |`cachehits3` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Cache Hits (Shard 4)**<br><br>The number of successful key lookups. For more information, see https://aka.ms/redis/metrics. |`cachehits4` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Cache Hits (Shard 5)**<br><br>The number of successful key lookups. For more information, see https://aka.ms/redis/metrics. |`cachehits5` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Cache Hits (Shard 6)**<br><br>The number of successful key lookups. For more information, see https://aka.ms/redis/metrics. |`cachehits6` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Cache Hits (Shard 7)**<br><br>The number of successful key lookups. For more information, see https://aka.ms/redis/metrics. |`cachehits7` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Cache Hits (Shard 8)**<br><br>The number of successful key lookups. For more information, see https://aka.ms/redis/metrics. |`cachehits8` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Cache Hits (Shard 9)**<br><br>The number of successful key lookups. For more information, see https://aka.ms/redis/metrics. |`cachehits9` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Cache Latency Microseconds (Preview)**<br><br>The latency to the cache in microseconds. For more information, see https://aka.ms/redis/metrics. |`cacheLatency` | No | Count |Average |`ShardId`|PT1M |Yes|
|**Cache Misses**<br><br>The number of failed key lookups. For more information, see https://aka.ms/redis/metrics. |`cachemisses` | No | Count |Total (Sum) |`ShardId`|PT1M |Yes|
|**Cache Misses (Shard 0)**<br><br>The number of failed key lookups. For more information, see https://aka.ms/redis/metrics. |`cachemisses0` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Cache Misses (Shard 1)**<br><br>The number of failed key lookups. For more information, see https://aka.ms/redis/metrics. |`cachemisses1` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Cache Misses (Shard 2)**<br><br>The number of failed key lookups. For more information, see https://aka.ms/redis/metrics. |`cachemisses2` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Cache Misses (Shard 3)**<br><br>The number of failed key lookups. For more information, see https://aka.ms/redis/metrics. |`cachemisses3` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Cache Misses (Shard 4)**<br><br>The number of failed key lookups. For more information, see https://aka.ms/redis/metrics. |`cachemisses4` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Cache Misses (Shard 5)**<br><br>The number of failed key lookups. For more information, see https://aka.ms/redis/metrics. |`cachemisses5` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Cache Misses (Shard 6)**<br><br>The number of failed key lookups. For more information, see https://aka.ms/redis/metrics. |`cachemisses6` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Cache Misses (Shard 7)**<br><br>The number of failed key lookups. For more information, see https://aka.ms/redis/metrics. |`cachemisses7` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Cache Misses (Shard 8)**<br><br>The number of failed key lookups. For more information, see https://aka.ms/redis/metrics. |`cachemisses8` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Cache Misses (Shard 9)**<br><br>The number of failed key lookups. For more information, see https://aka.ms/redis/metrics. |`cachemisses9` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Cache Miss Rate**<br><br>The % of get requests that miss. For more information, see https://aka.ms/redis/metrics. |`cachemissrate` | No | Percent |Total (Sum) |`ShardId`|PT1M |Yes|
|**Cache Read**<br><br>The amount of data read from the cache in bytes per second. For more information, see https://aka.ms/redis/metrics. |`cacheRead` | No | BytesPerSecond |Maximum |`ShardId`|PT1M |Yes|
|**Cache Read (Shard 0)**<br><br>The amount of data read from the cache in bytes per second. For more information, see https://aka.ms/redis/metrics. |`cacheRead0` | No | BytesPerSecond |Maximum |\<none\>|PT1M |Yes|
|**Cache Read (Shard 1)**<br><br>The amount of data read from the cache in bytes per second. For more information, see https://aka.ms/redis/metrics. |`cacheRead1` | No | BytesPerSecond |Maximum |\<none\>|PT1M |Yes|
|**Cache Read (Shard 2)**<br><br>The amount of data read from the cache in bytes per second. For more information, see https://aka.ms/redis/metrics. |`cacheRead2` | No | BytesPerSecond |Maximum |\<none\>|PT1M |Yes|
|**Cache Read (Shard 3)**<br><br>The amount of data read from the cache in bytes per second. For more information, see https://aka.ms/redis/metrics. |`cacheRead3` | No | BytesPerSecond |Maximum |\<none\>|PT1M |Yes|
|**Cache Read (Shard 4)**<br><br>The amount of data read from the cache in bytes per second. For more information, see https://aka.ms/redis/metrics. |`cacheRead4` | No | BytesPerSecond |Maximum |\<none\>|PT1M |Yes|
|**Cache Read (Shard 5)**<br><br>The amount of data read from the cache in bytes per second. For more information, see https://aka.ms/redis/metrics. |`cacheRead5` | No | BytesPerSecond |Maximum |\<none\>|PT1M |Yes|
|**Cache Read (Shard 6)**<br><br>The amount of data read from the cache in bytes per second. For more information, see https://aka.ms/redis/metrics. |`cacheRead6` | No | BytesPerSecond |Maximum |\<none\>|PT1M |Yes|
|**Cache Read (Shard 7)**<br><br>The amount of data read from the cache in bytes per second. For more information, see https://aka.ms/redis/metrics. |`cacheRead7` | No | BytesPerSecond |Maximum |\<none\>|PT1M |Yes|
|**Cache Read (Shard 8)**<br><br>The amount of data read from the cache in bytes per second. For more information, see https://aka.ms/redis/metrics. |`cacheRead8` | No | BytesPerSecond |Maximum |\<none\>|PT1M |Yes|
|**Cache Read (Shard 9)**<br><br>The amount of data read from the cache in bytes per second. For more information, see https://aka.ms/redis/metrics. |`cacheRead9` | No | BytesPerSecond |Maximum |\<none\>|PT1M |Yes|
|**Cache Write**<br><br>The amount of data written to the cache in bytes per second. For more information, see https://aka.ms/redis/metrics. |`cacheWrite` | No | BytesPerSecond |Maximum |`ShardId`|PT1M |Yes|
|**Cache Write (Shard 0)**<br><br>The amount of data written to the cache in bytes per second. For more information, see https://aka.ms/redis/metrics. |`cacheWrite0` | No | BytesPerSecond |Maximum |\<none\>|PT1M |Yes|
|**Cache Write (Shard 1)**<br><br>The amount of data written to the cache in bytes per second. For more information, see https://aka.ms/redis/metrics. |`cacheWrite1` | No | BytesPerSecond |Maximum |\<none\>|PT1M |Yes|
|**Cache Write (Shard 2)**<br><br>The amount of data written to the cache in bytes per second. For more information, see https://aka.ms/redis/metrics. |`cacheWrite2` | No | BytesPerSecond |Maximum |\<none\>|PT1M |Yes|
|**Cache Write (Shard 3)**<br><br>The amount of data written to the cache in bytes per second. For more information, see https://aka.ms/redis/metrics. |`cacheWrite3` | No | BytesPerSecond |Maximum |\<none\>|PT1M |Yes|
|**Cache Write (Shard 4)**<br><br>The amount of data written to the cache in bytes per second. For more information, see https://aka.ms/redis/metrics. |`cacheWrite4` | No | BytesPerSecond |Maximum |\<none\>|PT1M |Yes|
|**Cache Write (Shard 5)**<br><br>The amount of data written to the cache in bytes per second. For more information, see https://aka.ms/redis/metrics. |`cacheWrite5` | No | BytesPerSecond |Maximum |\<none\>|PT1M |Yes|
|**Cache Write (Shard 6)**<br><br>The amount of data written to the cache in bytes per second. For more information, see https://aka.ms/redis/metrics. |`cacheWrite6` | No | BytesPerSecond |Maximum |\<none\>|PT1M |Yes|
|**Cache Write (Shard 7)**<br><br>The amount of data written to the cache in bytes per second. For more information, see https://aka.ms/redis/metrics. |`cacheWrite7` | No | BytesPerSecond |Maximum |\<none\>|PT1M |Yes|
|**Cache Write (Shard 8)**<br><br>The amount of data written to the cache in bytes per second. For more information, see https://aka.ms/redis/metrics. |`cacheWrite8` | No | BytesPerSecond |Maximum |\<none\>|PT1M |Yes|
|**Cache Write (Shard 9)**<br><br>The amount of data written to the cache in bytes per second. For more information, see https://aka.ms/redis/metrics. |`cacheWrite9` | No | BytesPerSecond |Maximum |\<none\>|PT1M |Yes|
|**Connected Clients**<br><br>The number of client connections to the cache. For more information, see https://aka.ms/redis/metrics. |`connectedclients` | No | Count |Maximum |`ShardId`|PT1M |Yes|
|**Connected Clients (Shard 0)**<br><br>The number of client connections to the cache. For more information, see https://aka.ms/redis/metrics. |`connectedclients0` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Connected Clients (Shard 1)**<br><br>The number of client connections to the cache. For more information, see https://aka.ms/redis/metrics. |`connectedclients1` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Connected Clients (Shard 2)**<br><br>The number of client connections to the cache. For more information, see https://aka.ms/redis/metrics. |`connectedclients2` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Connected Clients (Shard 3)**<br><br>The number of client connections to the cache. For more information, see https://aka.ms/redis/metrics. |`connectedclients3` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Connected Clients (Shard 4)**<br><br>The number of client connections to the cache. For more information, see https://aka.ms/redis/metrics. |`connectedclients4` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Connected Clients (Shard 5)**<br><br>The number of client connections to the cache. For more information, see https://aka.ms/redis/metrics. |`connectedclients5` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Connected Clients (Shard 6)**<br><br>The number of client connections to the cache. For more information, see https://aka.ms/redis/metrics. |`connectedclients6` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Connected Clients (Shard 7)**<br><br>The number of client connections to the cache. For more information, see https://aka.ms/redis/metrics. |`connectedclients7` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Connected Clients (Shard 8)**<br><br>The number of client connections to the cache. For more information, see https://aka.ms/redis/metrics. |`connectedclients8` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Connected Clients (Shard 9)**<br><br>The number of client connections to the cache. For more information, see https://aka.ms/redis/metrics. |`connectedclients9` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Connected Clients using Microsoft Entra Token (Instance Based)**<br><br>The number of client connections to the cache using Microsoft Entra Token. For more information, see https://aka.ms/redis/metrics. |`ConnectedClientsUsingAADToken` | No | Count |Maximum |`ShardId`, `Port`, `Primary`|PT1M |Yes|
|**Errors**<br><br>The number of errors that occurred on the cache. For more information, see https://aka.ms/redis/metrics. |`errors` | No | Count |Maximum |`ShardId`, `ErrorType`|PT1M |Yes|
|**Evicted Keys**<br><br>The number of items evicted from the cache. For more information, see https://aka.ms/redis/metrics. |`evictedkeys` | No | Count |Total (Sum) |`ShardId`|PT1M |Yes|
|**Evicted Keys (Shard 0)**<br><br>The number of items evicted from the cache. For more information, see https://aka.ms/redis/metrics. |`evictedkeys0` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Evicted Keys (Shard 1)**<br><br>The number of items evicted from the cache. For more information, see https://aka.ms/redis/metrics. |`evictedkeys1` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Evicted Keys (Shard 2)**<br><br>The number of items evicted from the cache. For more information, see https://aka.ms/redis/metrics. |`evictedkeys2` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Evicted Keys (Shard 3)**<br><br>The number of items evicted from the cache. For more information, see https://aka.ms/redis/metrics. |`evictedkeys3` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Evicted Keys (Shard 4)**<br><br>The number of items evicted from the cache. For more information, see https://aka.ms/redis/metrics. |`evictedkeys4` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Evicted Keys (Shard 5)**<br><br>The number of items evicted from the cache. For more information, see https://aka.ms/redis/metrics. |`evictedkeys5` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Evicted Keys (Shard 6)**<br><br>The number of items evicted from the cache. For more information, see https://aka.ms/redis/metrics. |`evictedkeys6` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Evicted Keys (Shard 7)**<br><br>The number of items evicted from the cache. For more information, see https://aka.ms/redis/metrics. |`evictedkeys7` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Evicted Keys (Shard 8)**<br><br>The number of items evicted from the cache. For more information, see https://aka.ms/redis/metrics. |`evictedkeys8` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Evicted Keys (Shard 9)**<br><br>The number of items evicted from the cache. For more information, see https://aka.ms/redis/metrics. |`evictedkeys9` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Expired Keys**<br><br>The number of items expired from the cache. For more information, see https://aka.ms/redis/metrics. |`expiredkeys` | No | Count |Total (Sum) |`ShardId`|PT1M |Yes|
|**Expired Keys (Shard 0)**<br><br>The number of items expired from the cache. For more information, see https://aka.ms/redis/metrics. |`expiredkeys0` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Expired Keys (Shard 1)**<br><br>The number of items expired from the cache. For more information, see https://aka.ms/redis/metrics. |`expiredkeys1` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Expired Keys (Shard 2)**<br><br>The number of items expired from the cache. For more information, see https://aka.ms/redis/metrics. |`expiredkeys2` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Expired Keys (Shard 3)**<br><br>The number of items expired from the cache. For more information, see https://aka.ms/redis/metrics. |`expiredkeys3` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Expired Keys (Shard 4)**<br><br>The number of items expired from the cache. For more information, see https://aka.ms/redis/metrics. |`expiredkeys4` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Expired Keys (Shard 5)**<br><br>The number of items expired from the cache. For more information, see https://aka.ms/redis/metrics. |`expiredkeys5` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Expired Keys (Shard 6)**<br><br>The number of items expired from the cache. For more information, see https://aka.ms/redis/metrics. |`expiredkeys6` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Expired Keys (Shard 7)**<br><br>The number of items expired from the cache. For more information, see https://aka.ms/redis/metrics. |`expiredkeys7` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Expired Keys (Shard 8)**<br><br>The number of items expired from the cache. For more information, see https://aka.ms/redis/metrics. |`expiredkeys8` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Expired Keys (Shard 9)**<br><br>The number of items expired from the cache. For more information, see https://aka.ms/redis/metrics. |`expiredkeys9` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Geo-replication Connectivity Lag**<br><br>Time in seconds since last successful data synchronization with geo-primary cache. Value will continue to increase if the link status is down. For more information, see https://aka.ms/redis/georeplicationmetrics. |`GeoReplicationConnectivityLag` | No | Seconds |Average, Minimum, Maximum |`ShardId`|PT1M |Yes|
|**Geo-replication Data Sync Offset**<br><br>Approximate amount of data in bytes that needs to be synchronized to geo-secondary cache. For more information, see https://aka.ms/redis/georeplicationmetrics. |`GeoReplicationDataSyncOffset` | No | Bytes |Average, Minimum, Maximum |`ShardId`|PT1M |Yes|
|**Geo-replication Full Sync Event Finished**<br><br>Fired on completion of a full synchronization event between geo-replicated caches. This metric reports 0 most of the time because geo-replication uses partial resynchronizations for any new data added after the initial full synchronization. For more information, see https://aka.ms/redis/georeplicationmetrics. |`GeoReplicationFullSyncEventFinished` | No | Count |Count |`ShardId`|PT1M |Yes|
|**Geo-replication Full Sync Event Started**<br><br>Fired on initiation of a full synchronization event between geo-replicated caches. This metric reports 0 most of the time because geo-replication uses partial resynchronizations for any new data added after the initial full synchronization. For more information, see https://aka.ms/redis/georeplicationmetrics. |`GeoReplicationFullSyncEventStarted` | No | Count |Count |`ShardId`|PT1M |Yes|
|**Geo-replication Healthy**<br><br>The health status of geo-replication link. 1 if healthy and 0 if disconnected or unhealthy. For more information, see https://aka.ms/redis/georeplicationmetrics. |`GeoReplicationHealthy` | No | Count |Average, Minimum, Maximum |`ShardId`|PT1M |Yes|
|**Gets**<br><br>The number of get operations from the cache. For more information, see https://aka.ms/redis/metrics. |`getcommands` | No | Count |Total (Sum) |`ShardId`|PT1M |Yes|
|**Gets (Shard 0)**<br><br>The number of get operations from the cache. For more information, see https://aka.ms/redis/metrics. |`getcommands0` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Gets (Shard 1)**<br><br>The number of get operations from the cache. For more information, see https://aka.ms/redis/metrics. |`getcommands1` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Gets (Shard 2)**<br><br>The number of get operations from the cache. For more information, see https://aka.ms/redis/metrics. |`getcommands2` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Gets (Shard 3)**<br><br>The number of get operations from the cache. For more information, see https://aka.ms/redis/metrics. |`getcommands3` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Gets (Shard 4)**<br><br>The number of get operations from the cache. For more information, see https://aka.ms/redis/metrics. |`getcommands4` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Gets (Shard 5)**<br><br>The number of get operations from the cache. For more information, see https://aka.ms/redis/metrics. |`getcommands5` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Gets (Shard 6)**<br><br>The number of get operations from the cache. For more information, see https://aka.ms/redis/metrics. |`getcommands6` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Gets (Shard 7)**<br><br>The number of get operations from the cache. For more information, see https://aka.ms/redis/metrics. |`getcommands7` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Gets (Shard 8)**<br><br>The number of get operations from the cache. For more information, see https://aka.ms/redis/metrics. |`getcommands8` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Gets (Shard 9)**<br><br>The number of get operations from the cache. For more information, see https://aka.ms/redis/metrics. |`getcommands9` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**99th percentile latency**<br><br>Measures the worst-case (99th percentile) latency of server-side commands in microseconds. Measured by issuing PING commands from the load balancer to the Redis server and tracking the time to respond. |`LatencyP99` | No | Count |Average, Minimum, Maximum |\<none\>|PT1M |Yes|
|**Operations Per Second**<br><br>The number of instantaneous operations per second executed on the cache. For more information, see https://aka.ms/redis/metrics. |`operationsPerSecond` | No | Count |Maximum |`ShardId`|PT1M |Yes|
|**Operations Per Second (Shard 0)**<br><br>The number of instantaneous operations per second executed on the cache. For more information, see https://aka.ms/redis/metrics. |`operationsPerSecond0` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Operations Per Second (Shard 1)**<br><br>The number of instantaneous operations per second executed on the cache. For more information, see https://aka.ms/redis/metrics. |`operationsPerSecond1` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Operations Per Second (Shard 2)**<br><br>The number of instantaneous operations per second executed on the cache. For more information, see https://aka.ms/redis/metrics. |`operationsPerSecond2` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Operations Per Second (Shard 3)**<br><br>The number of instantaneous operations per second executed on the cache. For more information, see https://aka.ms/redis/metrics. |`operationsPerSecond3` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Operations Per Second (Shard 4)**<br><br>The number of instantaneous operations per second executed on the cache. For more information, see https://aka.ms/redis/metrics. |`operationsPerSecond4` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Operations Per Second (Shard 5)**<br><br>The number of instantaneous operations per second executed on the cache. For more information, see https://aka.ms/redis/metrics. |`operationsPerSecond5` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Operations Per Second (Shard 6)**<br><br>The number of instantaneous operations per second executed on the cache. For more information, see https://aka.ms/redis/metrics. |`operationsPerSecond6` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Operations Per Second (Shard 7)**<br><br>The number of instantaneous operations per second executed on the cache. For more information, see https://aka.ms/redis/metrics. |`operationsPerSecond7` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Operations Per Second (Shard 8)**<br><br>The number of instantaneous operations per second executed on the cache. For more information, see https://aka.ms/redis/metrics. |`operationsPerSecond8` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Operations Per Second (Shard 9)**<br><br>The number of instantaneous operations per second executed on the cache. For more information, see https://aka.ms/redis/metrics. |`operationsPerSecond9` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**CPU**<br><br>The CPU utilization of the Azure Redis Cache server as a percentage. For more information, see https://aka.ms/redis/metrics. |`percentProcessorTime` | No | Percent |Maximum |`ShardId`|PT1M |Yes|
|**CPU (Shard 0)**<br><br>The CPU utilization of the Azure Redis Cache server as a percentage. For more information, see https://aka.ms/redis/metrics. |`percentProcessorTime0` | No | Percent |Maximum |\<none\>|PT1M |Yes|
|**CPU (Shard 1)**<br><br>The CPU utilization of the Azure Redis Cache server as a percentage. For more information, see https://aka.ms/redis/metrics. |`percentProcessorTime1` | No | Percent |Maximum |\<none\>|PT1M |Yes|
|**CPU (Shard 2)**<br><br>The CPU utilization of the Azure Redis Cache server as a percentage. For more information, see https://aka.ms/redis/metrics. |`percentProcessorTime2` | No | Percent |Maximum |\<none\>|PT1M |Yes|
|**CPU (Shard 3)**<br><br>The CPU utilization of the Azure Redis Cache server as a percentage. For more information, see https://aka.ms/redis/metrics. |`percentProcessorTime3` | No | Percent |Maximum |\<none\>|PT1M |Yes|
|**CPU (Shard 4)**<br><br>The CPU utilization of the Azure Redis Cache server as a percentage. For more information, see https://aka.ms/redis/metrics. |`percentProcessorTime4` | No | Percent |Maximum |\<none\>|PT1M |Yes|
|**CPU (Shard 5)**<br><br>The CPU utilization of the Azure Redis Cache server as a percentage. For more information, see https://aka.ms/redis/metrics. |`percentProcessorTime5` | No | Percent |Maximum |\<none\>|PT1M |Yes|
|**CPU (Shard 6)**<br><br>The CPU utilization of the Azure Redis Cache server as a percentage. For more information, see https://aka.ms/redis/metrics. |`percentProcessorTime6` | No | Percent |Maximum |\<none\>|PT1M |Yes|
|**CPU (Shard 7)**<br><br>The CPU utilization of the Azure Redis Cache server as a percentage. For more information, see https://aka.ms/redis/metrics. |`percentProcessorTime7` | No | Percent |Maximum |\<none\>|PT1M |Yes|
|**CPU (Shard 8)**<br><br>The CPU utilization of the Azure Redis Cache server as a percentage. For more information, see https://aka.ms/redis/metrics. |`percentProcessorTime8` | No | Percent |Maximum |\<none\>|PT1M |Yes|
|**CPU (Shard 9)**<br><br>The CPU utilization of the Azure Redis Cache server as a percentage. For more information, see https://aka.ms/redis/metrics. |`percentProcessorTime9` | No | Percent |Maximum |\<none\>|PT1M |Yes|
|**Server Load**<br><br>The percentage of cycles in which the Redis server is busy processing and not waiting idle for messages. For more information, see https://aka.ms/redis/metrics. |`serverLoad` | No | Percent |Maximum |`ShardId`|PT1M |Yes|
|**Server Load (Shard 0)**<br><br>The percentage of cycles in which the Redis server is busy processing and not waiting idle for messages. For more information, see https://aka.ms/redis/metrics. |`serverLoad0` | No | Percent |Maximum |\<none\>|PT1M |Yes|
|**Server Load (Shard 1)**<br><br>The percentage of cycles in which the Redis server is busy processing and not waiting idle for messages. For more information, see https://aka.ms/redis/metrics. |`serverLoad1` | No | Percent |Maximum |\<none\>|PT1M |Yes|
|**Server Load (Shard 2)**<br><br>The percentage of cycles in which the Redis server is busy processing and not waiting idle for messages. For more information, see https://aka.ms/redis/metrics. |`serverLoad2` | No | Percent |Maximum |\<none\>|PT1M |Yes|
|**Server Load (Shard 3)**<br><br>The percentage of cycles in which the Redis server is busy processing and not waiting idle for messages. For more information, see https://aka.ms/redis/metrics. |`serverLoad3` | No | Percent |Maximum |\<none\>|PT1M |Yes|
|**Server Load (Shard 4)**<br><br>The percentage of cycles in which the Redis server is busy processing and not waiting idle for messages. For more information, see https://aka.ms/redis/metrics. |`serverLoad4` | No | Percent |Maximum |\<none\>|PT1M |Yes|
|**Server Load (Shard 5)**<br><br>The percentage of cycles in which the Redis server is busy processing and not waiting idle for messages. For more information, see https://aka.ms/redis/metrics. |`serverLoad5` | No | Percent |Maximum |\<none\>|PT1M |Yes|
|**Server Load (Shard 6)**<br><br>The percentage of cycles in which the Redis server is busy processing and not waiting idle for messages. For more information, see https://aka.ms/redis/metrics. |`serverLoad6` | No | Percent |Maximum |\<none\>|PT1M |Yes|
|**Server Load (Shard 7)**<br><br>The percentage of cycles in which the Redis server is busy processing and not waiting idle for messages. For more information, see https://aka.ms/redis/metrics. |`serverLoad7` | No | Percent |Maximum |\<none\>|PT1M |Yes|
|**Server Load (Shard 8)**<br><br>The percentage of cycles in which the Redis server is busy processing and not waiting idle for messages. For more information, see https://aka.ms/redis/metrics. |`serverLoad8` | No | Percent |Maximum |\<none\>|PT1M |Yes|
|**Server Load (Shard 9)**<br><br>The percentage of cycles in which the Redis server is busy processing and not waiting idle for messages. For more information, see https://aka.ms/redis/metrics. |`serverLoad9` | No | Percent |Maximum |\<none\>|PT1M |Yes|
|**Sets**<br><br>The number of set operations to the cache. For more information, see https://aka.ms/redis/metrics. |`setcommands` | No | Count |Total (Sum) |`ShardId`|PT1M |Yes|
|**Sets (Shard 0)**<br><br>The number of set operations to the cache. For more information, see https://aka.ms/redis/metrics. |`setcommands0` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Sets (Shard 1)**<br><br>The number of set operations to the cache. For more information, see https://aka.ms/redis/metrics. |`setcommands1` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Sets (Shard 2)**<br><br>The number of set operations to the cache. For more information, see https://aka.ms/redis/metrics. |`setcommands2` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Sets (Shard 3)**<br><br>The number of set operations to the cache. For more information, see https://aka.ms/redis/metrics. |`setcommands3` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Sets (Shard 4)**<br><br>The number of set operations to the cache. For more information, see https://aka.ms/redis/metrics. |`setcommands4` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Sets (Shard 5)**<br><br>The number of set operations to the cache. For more information, see https://aka.ms/redis/metrics. |`setcommands5` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Sets (Shard 6)**<br><br>The number of set operations to the cache. For more information, see https://aka.ms/redis/metrics. |`setcommands6` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Sets (Shard 7)**<br><br>The number of set operations to the cache. For more information, see https://aka.ms/redis/metrics. |`setcommands7` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Sets (Shard 8)**<br><br>The number of set operations to the cache. For more information, see https://aka.ms/redis/metrics. |`setcommands8` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Sets (Shard 9)**<br><br>The number of set operations to the cache. For more information, see https://aka.ms/redis/metrics. |`setcommands9` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Total Operations**<br><br>The total number of commands processed by the cache server. For more information, see https://aka.ms/redis/metrics. |`totalcommandsprocessed` | No | Count |Total (Sum) |`ShardId`|PT1M |Yes|
|**Total Operations (Shard 0)**<br><br>The total number of commands processed by the cache server. For more information, see https://aka.ms/redis/metrics. |`totalcommandsprocessed0` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Total Operations (Shard 1)**<br><br>The total number of commands processed by the cache server. For more information, see https://aka.ms/redis/metrics. |`totalcommandsprocessed1` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Total Operations (Shard 2)**<br><br>The total number of commands processed by the cache server. For more information, see https://aka.ms/redis/metrics. |`totalcommandsprocessed2` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Total Operations (Shard 3)**<br><br>The total number of commands processed by the cache server. For more information, see https://aka.ms/redis/metrics. |`totalcommandsprocessed3` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Total Operations (Shard 4)**<br><br>The total number of commands processed by the cache server. For more information, see https://aka.ms/redis/metrics. |`totalcommandsprocessed4` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Total Operations (Shard 5)**<br><br>The total number of commands processed by the cache server. For more information, see https://aka.ms/redis/metrics. |`totalcommandsprocessed5` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Total Operations (Shard 6)**<br><br>The total number of commands processed by the cache server. For more information, see https://aka.ms/redis/metrics. |`totalcommandsprocessed6` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Total Operations (Shard 7)**<br><br>The total number of commands processed by the cache server. For more information, see https://aka.ms/redis/metrics. |`totalcommandsprocessed7` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Total Operations (Shard 8)**<br><br>The total number of commands processed by the cache server. For more information, see https://aka.ms/redis/metrics. |`totalcommandsprocessed8` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Total Operations (Shard 9)**<br><br>The total number of commands processed by the cache server. For more information, see https://aka.ms/redis/metrics. |`totalcommandsprocessed9` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Total Keys**<br><br>The total number of items in the cache. For more information, see https://aka.ms/redis/metrics. |`totalkeys` | No | Count |Maximum |`ShardId`|PT1M |Yes|
|**Total Keys (Shard 0)**<br><br>The total number of items in the cache. For more information, see https://aka.ms/redis/metrics. |`totalkeys0` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Total Keys (Shard 1)**<br><br>The total number of items in the cache. For more information, see https://aka.ms/redis/metrics. |`totalkeys1` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Total Keys (Shard 2)**<br><br>The total number of items in the cache. For more information, see https://aka.ms/redis/metrics. |`totalkeys2` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Total Keys (Shard 3)**<br><br>The total number of items in the cache. For more information, see https://aka.ms/redis/metrics. |`totalkeys3` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Total Keys (Shard 4)**<br><br>The total number of items in the cache. For more information, see https://aka.ms/redis/metrics. |`totalkeys4` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Total Keys (Shard 5)**<br><br>The total number of items in the cache. For more information, see https://aka.ms/redis/metrics. |`totalkeys5` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Total Keys (Shard 6)**<br><br>The total number of items in the cache. For more information, see https://aka.ms/redis/metrics. |`totalkeys6` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Total Keys (Shard 7)**<br><br>The total number of items in the cache. For more information, see https://aka.ms/redis/metrics. |`totalkeys7` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Total Keys (Shard 8)**<br><br>The total number of items in the cache. For more information, see https://aka.ms/redis/metrics. |`totalkeys8` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Total Keys (Shard 9)**<br><br>The total number of items in the cache. For more information, see https://aka.ms/redis/metrics. |`totalkeys9` | No | Count |Maximum |\<none\>|PT1M |Yes|
|**Used Memory**<br><br>The amount of cache memory used for key/value pairs in the cache in MB. For more information, see https://aka.ms/redis/metrics. |`usedmemory` | No | Bytes |Maximum |`ShardId`|PT1M |Yes|
|**Used Memory (Shard 0)**<br><br>The amount of cache memory used for key/value pairs in the cache in MB. For more information, see https://aka.ms/redis/metrics. |`usedmemory0` | No | Bytes |Maximum |\<none\>|PT1M |Yes|
|**Used Memory (Shard 1)**<br><br>The amount of cache memory used for key/value pairs in the cache in MB. For more information, see https://aka.ms/redis/metrics. |`usedmemory1` | No | Bytes |Maximum |\<none\>|PT1M |Yes|
|**Used Memory (Shard 2)**<br><br>The amount of cache memory used for key/value pairs in the cache in MB. For more information, see https://aka.ms/redis/metrics. |`usedmemory2` | No | Bytes |Maximum |\<none\>|PT1M |Yes|
|**Used Memory (Shard 3)**<br><br>The amount of cache memory used for key/value pairs in the cache in MB. For more information, see https://aka.ms/redis/metrics. |`usedmemory3` | No | Bytes |Maximum |\<none\>|PT1M |Yes|
|**Used Memory (Shard 4)**<br><br>The amount of cache memory used for key/value pairs in the cache in MB. For more information, see https://aka.ms/redis/metrics. |`usedmemory4` | No | Bytes |Maximum |\<none\>|PT1M |Yes|
|**Used Memory (Shard 5)**<br><br>The amount of cache memory used for key/value pairs in the cache in MB. For more information, see https://aka.ms/redis/metrics. |`usedmemory5` | No | Bytes |Maximum |\<none\>|PT1M |Yes|
|**Used Memory (Shard 6)**<br><br>The amount of cache memory used for key/value pairs in the cache in MB. For more information, see https://aka.ms/redis/metrics. |`usedmemory6` | No | Bytes |Maximum |\<none\>|PT1M |Yes|
|**Used Memory (Shard 7)**<br><br>The amount of cache memory used for key/value pairs in the cache in MB. For more information, see https://aka.ms/redis/metrics. |`usedmemory7` | No | Bytes |Maximum |\<none\>|PT1M |Yes|
|**Used Memory (Shard 8)**<br><br>The amount of cache memory used for key/value pairs in the cache in MB. For more information, see https://aka.ms/redis/metrics. |`usedmemory8` | No | Bytes |Maximum |\<none\>|PT1M |Yes|
|**Used Memory (Shard 9)**<br><br>The amount of cache memory used for key/value pairs in the cache in MB. For more information, see https://aka.ms/redis/metrics. |`usedmemory9` | No | Bytes |Maximum |\<none\>|PT1M |Yes|
|**Used Memory Percentage**<br><br>The percentage of cache memory used for key/value pairs. For more information, see https://aka.ms/redis/metrics. |`usedmemorypercentage` | No | Percent |Maximum |`ShardId`|PT1M |Yes|
|**Used Memory RSS**<br><br>The amount of cache memory used in MB, including fragmentation and metadata. For more information, see https://aka.ms/redis/metrics. |`usedmemoryRss` | No | Bytes |Maximum |`ShardId`|PT1M |Yes|
|**Used Memory RSS (Shard 0)**<br><br>The amount of cache memory used in MB, including fragmentation and metadata. For more information, see https://aka.ms/redis/metrics. |`usedmemoryRss0` | No | Bytes |Maximum |\<none\>|PT1M |Yes|
|**Used Memory RSS (Shard 1)**<br><br>The amount of cache memory used in MB, including fragmentation and metadata. For more information, see https://aka.ms/redis/metrics. |`usedmemoryRss1` | No | Bytes |Maximum |\<none\>|PT1M |Yes|
|**Used Memory RSS (Shard 2)**<br><br>The amount of cache memory used in MB, including fragmentation and metadata. For more information, see https://aka.ms/redis/metrics. |`usedmemoryRss2` | No | Bytes |Maximum |\<none\>|PT1M |Yes|
|**Used Memory RSS (Shard 3)**<br><br>The amount of cache memory used in MB, including fragmentation and metadata. For more information, see https://aka.ms/redis/metrics. |`usedmemoryRss3` | No | Bytes |Maximum |\<none\>|PT1M |Yes|
|**Used Memory RSS (Shard 4)**<br><br>The amount of cache memory used in MB, including fragmentation and metadata. For more information, see https://aka.ms/redis/metrics. |`usedmemoryRss4` | No | Bytes |Maximum |\<none\>|PT1M |Yes|
|**Used Memory RSS (Shard 5)**<br><br>The amount of cache memory used in MB, including fragmentation and metadata. For more information, see https://aka.ms/redis/metrics. |`usedmemoryRss5` | No | Bytes |Maximum |\<none\>|PT1M |Yes|
|**Used Memory RSS (Shard 6)**<br><br>The amount of cache memory used in MB, including fragmentation and metadata. For more information, see https://aka.ms/redis/metrics. |`usedmemoryRss6` | No | Bytes |Maximum |\<none\>|PT1M |Yes|
|**Used Memory RSS (Shard 7)**<br><br>The amount of cache memory used in MB, including fragmentation and metadata. For more information, see https://aka.ms/redis/metrics. |`usedmemoryRss7` | No | Bytes |Maximum |\<none\>|PT1M |Yes|
|**Used Memory RSS (Shard 8)**<br><br>The amount of cache memory used in MB, including fragmentation and metadata. For more information, see https://aka.ms/redis/metrics. |`usedmemoryRss8` | No | Bytes |Maximum |\<none\>|PT1M |Yes|
|**Used Memory RSS (Shard 9)**<br><br>The amount of cache memory used in MB, including fragmentation and metadata. For more information, see https://aka.ms/redis/metrics. |`usedmemoryRss9` | No | Bytes |Maximum |\<none\>|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
