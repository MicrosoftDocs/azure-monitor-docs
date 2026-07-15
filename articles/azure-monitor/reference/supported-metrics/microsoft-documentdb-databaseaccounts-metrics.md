---
title: Supported metrics - Microsoft.DocumentDB/DatabaseAccounts
description: Reference for Microsoft.DocumentDB/DatabaseAccounts metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: Microsoft.DocumentDB/DatabaseAccounts, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.DocumentDB/DatabaseAccounts

The following table lists the metrics available for the Microsoft.DocumentDB/DatabaseAccounts resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.DocumentDB/DatabaseAccounts](../supported-logs/microsoft-documentdb-databaseaccounts-logs.md)


### Category: Requests
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Region Added**<br><br>Region Added |`AddRegion` | No | Count |Count |`Region`|PT5M |No|
|**Autoscaled RU**<br><br>Autoscaled RU consumption with Per Region and Per Partition Autoscale |`AutoscaledRU` | No | Count |Maximum |`DatabaseName`, `CollectionName`, `PhysicalPartitionId`, `Region`|PT1M, PT5M, PT1H, P1D |No|
|**Autoscale Max Throughput**<br><br>Autoscale Max Throughput |`AutoscaleMaxThroughput` | No | Count |Maximum |`DatabaseName`, `CollectionName`|PT5M, PT1H |No|
|**(deprecated) Available Storage**<br><br>"Available Storage"will be removed from Azure Monitor at the end of September 2023. Cosmos DB collection storage size is now unlimited. The only restriction is that the storage size for each logical partition key is 20GB. You can enable PartitionKeyStatistics in Diagnostic Log to know the storage consumption for top partition keys. For more info about Cosmos DB storage quota, please check this doc /azure/cosmos-db/concepts-limits. After deprecation, the remaining alert rules still defined on the deprecated metric will be automatically disabled post the deprecation date. |`AvailableStorage` | No | Bytes |Total (Sum), Average |`CollectionName`, `DatabaseName`, `Region`|PT5M |No|
|**Backup Mode Update**<br><br>Backup Mode Update |`BackupModeUpdate` | No | Count |Count |`BackupMode`|PT5M |No|
|**Periodic Backup Policy Interval Update**<br><br>Periodic Backup Policy Interval Update. Valid range: 60 -1440 minutes. |`BackupPolicyIntervalUpdate` | No | Count |Count |`BackupIntervalInHours`|PT5M |No|
|**Periodic Backup Policy Redundancy Update**<br><br>Periodic Backup Policy Redundancy Update |`BackupPolicyRedundancyUpdate` | No | Count |Count |`BackupRedundancy`|PT5M |No|
|**Periodic Backup Policy Retention Update**<br><br>Periodic Backup Policy Retention Update. Valid range: 8 - 720 hours. |`BackupPolicyRetentionUpdate` | No | Count |Count |`BackupRetentionIntervalInHours`|PT5M |No|
|**Periodic Backup Policy Update**<br><br>Periodic Backup Policy Update |`BackupPolicyUpdate` | No | Count |Count |`BackupPolicy`|PT5M |No|
|**Cassandra Connection Closures**<br><br>Number of Cassandra connections that were closed, reported at a 1 minute granularity |`CassandraConnectionClosures` | No | Count |Average, Minimum, Maximum, Total (Sum) |`APIType`, `Region`, `ClosureReason`|PT1M |No|
|**(deprecated) Cassandra Connector Average ReplicationLatency**<br><br>Cassandra Connector Average ReplicationLatency |`CassandraConnectorAvgReplicationLatency` | No | MilliSeconds |Average |\<none\>|PT5M |No|
|**(deprecated) Cassandra Connector Replication Health Status**<br><br>Cassandra Connector Replication Health Status |`CassandraConnectorReplicationHealthStatus` | No | Count |Count |`NotStarted`, `ReplicationInProgress`, `Error`|PT5M |No|
|**Cassandra Keyspace Created**<br><br>Cassandra Keyspace Created |`CassandraKeyspaceCreate` | No | Count |Count |`ResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`, `OperationType`|PT5M |No|
|**Cassandra Keyspace Deleted**<br><br>Cassandra Keyspace Deleted |`CassandraKeyspaceDelete` | No | Count |Count |`ResourceName`, `ApiKind`, `ApiKindResourceType`, `OperationType`|PT5M |No|
|**Cassandra Keyspace Throughput Updated**<br><br>Cassandra Keyspace Throughput Updated |`CassandraKeyspaceThroughputUpdate` | No | Count |Count |`ResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`|PT5M |No|
|**Cassandra Keyspace Updated**<br><br>Cassandra Keyspace Updated |`CassandraKeyspaceUpdate` | No | Count |Count |`ResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`, `OperationType`|PT5M |No|
|**Cassandra Request Charges**<br><br>RUs consumed for Cassandra requests made |`CassandraRequestCharges` | No | Count |Total (Sum), Average, Minimum, Maximum |`APIType`, `DatabaseName`, `CollectionName`, `Region`, `OperationType`, `ResourceType`|PT1M |No|
|**Cassandra Requests**<br><br>Number of Cassandra requests made |`CassandraRequests` | No | Count |Count |`APIType`, `DatabaseName`, `CollectionName`, `Region`, `OperationType`, `ResourceType`, `ErrorCode`|PT1M |No|
|**Cassandra Table Created**<br><br>Cassandra Table Created |`CassandraTableCreate` | No | Count |Count |`ResourceName`, `ChildResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`, `OperationType`|PT5M |No|
|**Cassandra Table Deleted**<br><br>Cassandra Table Deleted |`CassandraTableDelete` | No | Count |Count |`ResourceName`, `ChildResourceName`, `ApiKind`, `ApiKindResourceType`, `OperationType`|PT5M |No|
|**Cassandra Table Throughput Updated**<br><br>Cassandra Table Throughput Updated |`CassandraTableThroughputUpdate` | No | Count |Count |`ResourceName`, `ChildResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`|PT5M |No|
|**Cassandra Table Updated**<br><br>Cassandra Table Updated |`CassandraTableUpdate` | No | Count |Count |`ResourceName`, `ChildResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`, `OperationType`|PT5M |No|
|**ContinuousBackupMode Tier Update**<br><br>ContinuousBackupMode Tier Update |`ContinuousTierUpdate` | No | Count |Count |`ContinuousBackupTier`|PT5M |No|
|**Account Created**<br><br>Account Created |`CreateAccount` | No | Count |Count |\<none\>|PT5M |No|
|**Data Usage**<br><br>Total data usage reported at 5 minutes granularity |`DataUsage` | No | Bytes |Total (Sum), Average, Maximum, Minimum |`CollectionName`, `DatabaseName`, `Region`|PT5M, PT15M, PT30M, PT1H |No|
|**DedicatedGatewayAverageCPUUsage**<br><br>Average CPU usage across dedicated gateway instances |`DedicatedGatewayAverageCPUUsage` | No | Percent |Average |`Region`, `MetricType`|PT5M |No|
|**DedicatedGatewayAverageMemoryUsage**<br><br>Average memory usage across dedicated gateway instances, which is used for both routing requests and caching data |`DedicatedGatewayAverageMemoryUsage` | No | Bytes |Average |`Region`|PT5M |No|
|**DedicatedGatewayCPUUsage**<br><br>CPU usage across dedicated gateway instances |`DedicatedGatewayCPUUsage` | No | Percent |Average, Maximum, Minimum |`Region`, `ApplicationType`|PT1M |No|
|**DedicatedGatewayMaximumCPUUsage**<br><br>Average Maximum CPU usage across dedicated gateway instances |`DedicatedGatewayMaximumCPUUsage` | No | Percent |Average, Maximum |`Region`, `MetricType`|PT5M |No|
|**DedicatedGatewayMemoryUsage**<br><br>Memory usage across dedicated gateway instances |`DedicatedGatewayMemoryUsage` | No | Bytes |Average, Maximum, Minimum |`Region`, `ApplicationType`|PT1M |No|
|**DedicatedGatewayRequests**<br><br>Requests at the dedicated gateway |`DedicatedGatewayRequests` | No | Count |Count |`DatabaseName`, `CollectionName`, `CacheExercised`, `OperationName`, `Region`, `CacheHit`|PT1M |No|
|**Account Deleted**<br><br>Account Deleted |`DeleteAccount` | No | Count |Count |\<none\>|PT5M |No|
|**(deprecated) Document Count**<br><br>Total document count reported at 5 minutes, 1 hour and 1 day granularity |`DocumentCount` | No | Count |Total (Sum), Average |`CollectionName`, `DatabaseName`, `Region`|PT5M, PT1H, P1D |No|
|**Document Count**<br><br>Total document count reported at 5 minutes, 1 hour and 1 day granularity |`DocumentCountV2` | No | Count |Total (Sum), Average |`CollectionName`, `DatabaseName`, `Region`|PT5M, PT1H, P1D |No|
|**Document Quota**<br><br>Total storage quota reported at 5 minutes granularity |`DocumentQuota` | No | Bytes |Total (Sum), Average |`CollectionName`, `DatabaseName`, `Region`|PT5M |No|
|**Global Secondary Index Catchup Gap In Minutes**<br><br>Maximum time difference in minutes between data in source container and data propagated to global secondary index |`GlobalSecondaryIndexCatchupGapInMinutes` | No | Count |Maximum |`Region`, `TargetContainerName`, `BuildType`|PT1M |No|
|**Global Secondary Index Propagation Latency In Seconds**<br><br>Average time difference in seconds between data in source container and data propagated to global secondary index |`GlobalSecondaryIndexPropagationLatencyInSeconds` | No | Count |Average |`Region`, `TargetContainerName`, `TargetContainerStatus`, `BuildType`|PT1M |No|
|**Gremlin Database Created**<br><br>Gremlin Database Created |`GremlinDatabaseCreate` | No | Count |Count |`ResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`, `OperationType`|PT5M |No|
|**Gremlin Database Deleted**<br><br>Gremlin Database Deleted |`GremlinDatabaseDelete` | No | Count |Count |`ResourceName`, `ApiKind`, `ApiKindResourceType`, `OperationType`|PT5M |No|
|**Gremlin Database Throughput Updated**<br><br>Gremlin Database Throughput Updated |`GremlinDatabaseThroughputUpdate` | No | Count |Count |`ResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`|PT5M |No|
|**Gremlin Database Updated**<br><br>Gremlin Database Updated |`GremlinDatabaseUpdate` | No | Count |Count |`ResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`, `OperationType`|PT5M |No|
|**Gremlin Graph Created**<br><br>Gremlin Graph Created |`GremlinGraphCreate` | No | Count |Count |`ResourceName`, `ChildResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`, `OperationType`|PT5M |No|
|**Gremlin Graph Deleted**<br><br>Gremlin Graph Deleted |`GremlinGraphDelete` | No | Count |Count |`ResourceName`, `ChildResourceName`, `ApiKind`, `ApiKindResourceType`, `OperationType`|PT5M |No|
|**Gremlin Graph Throughput Updated**<br><br>Gremlin Graph Throughput Updated |`GremlinGraphThroughputUpdate` | No | Count |Count |`ResourceName`, `ChildResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`|PT5M |No|
|**Gremlin Graph Updated**<br><br>Gremlin Graph Updated |`GremlinGraphUpdate` | No | Count |Count |`ResourceName`, `ChildResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`, `OperationType`|PT5M |No|
|**Gremlin Request Charges**<br><br>Request Units consumed for Gremlin requests made |`GremlinRequestCharges` | No | Count |Total (Sum), Average, Minimum, Maximum |`APIType`, `DatabaseName`, `CollectionName`, `Region`|PT1M |No|
|**Gremlin Requests**<br><br>Number of Gremlin requests made |`GremlinRequests` | No | Count |Count |`APIType`, `DatabaseName`, `CollectionName`, `Region`, `ErrorCode`|PT1M |No|
|**Index Usage**<br><br>Total index usage reported at 5 minutes granularity |`IndexUsage` | No | Bytes |Total (Sum), Average, Maximum, Minimum |`CollectionName`, `DatabaseName`, `Region`, `IsLeakedPartition`|PT5M, PT15M, PT30M, PT1H |No|
|**IntegratedCacheEvictedEntriesSize**<br><br>Size of the entries evicted from the integrated cache |`IntegratedCacheEvictedEntriesSize` | No | Bytes |Average |`Region`|PT5M |No|
|**IntegratedCacheItemExpirationCount**<br><br>Number of items evicted from the integrated cache due to TTL expiration |`IntegratedCacheItemExpirationCount` | No | Count |Average |`Region`, `CacheEntryType`|PT5M |No|
|**IntegratedCacheItemHitRate**<br><br>Number of point reads that used the integrated cache divided by number of point reads routed through the dedicated gateway with eventual consistency |`IntegratedCacheItemHitRate` | No | Percent |Average |`Region`, `CacheEntryType`|PT5M |No|
|**IntegratedCacheQueryExpirationCount**<br><br>Number of queries evicted from the integrated cache due to TTL expiration |`IntegratedCacheQueryExpirationCount` | No | Count |Average |`Region`, `CacheEntryType`|PT5M |No|
|**IntegratedCacheQueryHitRate**<br><br>Number of queries that used the integrated cache divided by number of queries routed through the dedicated gateway with eventual consistency |`IntegratedCacheQueryHitRate` | No | Percent |Average |`Region`, `CacheEntryType`|PT5M |No|
|**Materialized View Catchup Gap In Minutes**<br><br>Maximum time difference in minutes between data in source container and data propagated to materialized view |`MaterializedViewCatchupGapInMinutes` | No | Count |Maximum |`Region`, `TargetContainerName`, `BuildType`|PT1M |No|
|**(deprecated) Materialized Views Builder Average CPU Usage**<br><br>Average CPU usage across materialized view builder instances, which are used for populating data in materialized views |`MaterializedViewsBuilderAverageCPUUsage` | No | Percent |Average |`Region`, `MetricType`|PT5M |No|
|**Materialized Views Builder Average Memory Usage**<br><br>Average memory usage across materialized view builder instances, which are used for populating data in materialized views |`MaterializedViewsBuilderAverageMemoryUsage` | No | Bytes |Average |`Region`, `InstanceId`, `ApplicationType`|PT5M |No|
|**Materialized Views Builder CPU Usage**<br><br>CPU usage across materialized view builder instances, which are used for populating data in materialized views |`MaterializedViewsBuilderCPUUsage` | No | Percent |Average, Maximum |`Region`, `InstanceId`, `ApplicationType`|PT5M |No|
|**(deprecated) Materialized Views Builder Maximum CPU Usage**<br><br>Average Maximum CPU usage across materialized view builder instances, which are used for populating data in materialized views |`MaterializedViewsBuilderMaximumCPUUsage` | No | Percent |Average, Maximum |`Region`, `MetricType`|PT5M |No|
|**Metadata Requests**<br><br>Count of metadata requests. Cosmos DB maintains system metadata collection for each account, that allows you to enumerate collections, databases, etc, and their configurations, free of charge. |`MetadataRequests` | No | Count |Count |`DatabaseName`, `CollectionName`, `Region`, `StatusCode`, `Role`|PT1M |No|
|**Mongo Collection Created**<br><br>Mongo Collection Created |`MongoCollectionCreate` | No | Count |Count |`ResourceName`, `ChildResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`, `OperationType`|PT5M |No|
|**Mongo Collection Deleted**<br><br>Mongo Collection Deleted |`MongoCollectionDelete` | No | Count |Count |`ResourceName`, `ChildResourceName`, `ApiKind`, `ApiKindResourceType`, `OperationType`|PT5M |No|
|**Mongo Collection Throughput Updated**<br><br>Mongo Collection Throughput Updated |`MongoCollectionThroughputUpdate` | No | Count |Count |`ResourceName`, `ChildResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`|PT5M |No|
|**Mongo Collection Updated**<br><br>Mongo Collection Updated |`MongoCollectionUpdate` | No | Count |Count |`ResourceName`, `ChildResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`, `OperationType`|PT5M |No|
|**Mongo Database Deleted**<br><br>Mongo Database Deleted |`MongoDatabaseDelete` | No | Count |Count |`ResourceName`, `ApiKind`, `ApiKindResourceType`, `OperationType`|PT5M |No|
|**Mongo Database Throughput Updated**<br><br>Mongo Database Throughput Updated |`MongoDatabaseThroughputUpdate` | No | Count |Count |`ResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`|PT5M |No|
|**Mongo Database Created**<br><br>Mongo Database Created |`MongoDBDatabaseCreate` | No | Count |Count |`ResourceName`, `ApiKind`, `ApiKindResourceType`, `OperationType`|PT5M |No|
|**Mongo Database Updated**<br><br>Mongo Database Updated |`MongoDBDatabaseUpdate` | No | Count |Count |`ResourceName`, `ApiKind`, `ApiKindResourceType`, `OperationType`|PT5M |No|
|**Mongo Request Charge**<br><br>Mongo Request Units Consumed |`MongoRequestCharge` | No | Count |Total (Sum), Average, Maximum |`DatabaseName`, `CollectionName`, `Region`, `CommandName`, `ErrorCode`, `Status`|PT1M |No|
|**Mongo Requests**<br><br>Number of Mongo Requests Made |`MongoRequests` | No | Count |Count |`DatabaseName`, `CollectionName`, `Region`, `CommandName`, `ErrorCode`, `Status`|PT1M |No|
|**Normalized RU Consumption**<br><br>Max RU consumption percentage per minute |`NormalizedRUConsumption` | No | Percent |Maximum, Average |`CollectionName`, `DatabaseName`, `Region`, `PartitionKeyRangeId`, `CollectionRid`, `PhysicalPartitionId`, `OfferOwnerRid`|PT1M, PT5M, PT1H, P1D |No|
|**Region Offlined**<br><br>Region Offlined |`OfflineRegion` | No | Count |Count |`Region`, `StatusCode`|PT1M |No|
|**Region Onlined**<br><br>Region Onlined |`OnlineRegion` | No | Count |Count |`Region`, `StatusCode`|PT1M |No|
|**Partition Global Write Status**<br><br>Global Write Status of Each Partition |`PartitionGlobalWriteStatus` | No | Count |Total (Sum) |`WriteStatus`, `Region`|PT1M |No|
|**Physical Partition Count**<br><br>Physical Partition Count |`PhysicalPartitionCount` | No | Count |Maximum |`CollectionName`, `DatabaseName`, `IsSharedThroughputOffer`, `OfferOwnerRid`, `Region`|PT5M |No|
|**Physical Partition Size**<br><br>Physical Partition Size in bytes |`PhysicalPartitionSizeInfo` | No | Bytes |Maximum, Average |`CollectionName`, `DatabaseName`, `PhysicalPartitionId`, `OfferOwnerRid`, `Region`|PT1M, PT5M, PT1H, P1D |No|
|**Physical Partition Throughput**<br><br>Physical Partition Throughput |`PhysicalPartitionThroughputInfo` | No | Count |Maximum |`CollectionName`, `DatabaseName`, `PhysicalPartitionId`, `OfferOwnerRid`, `Region`|PT5M, PT1H, P1D |No|
|**Provisioned Throughput**<br><br>Provisioned Throughput |`ProvisionedThroughput` | No | Count |Maximum |`DatabaseName`, `CollectionName`, `Region`|PT5M, PT1H, P1D |No|
|**Region Failed Over**<br><br>Region Failed Over |`RegionFailover` | No | Count |Count |\<none\>|PT5M |No|
|**Region Removed**<br><br>Region Removed |`RemoveRegion` | No | Count |Count |`Region`|PT5M |No|
|**P99 Replication Latency**<br><br>P99 Replication Latency across source and target regions for geo-enabled account |`ReplicationLatency` | No | MilliSeconds |Minimum, Maximum, Average |`SourceRegion`, `TargetRegion`|PT1M |No|
|**(deprecated) Server Side Latency**<br><br>"Server Side Latency" will be removed from Azure Monitor at the end of August 2025. Please use "Server Side Latency Direct" and "Server Side Latency Gateway" to monitor the latency instead. For more info about latency metrics, please refer to this /azure/cosmos-db/monitor-server-side-latency. |`ServerSideLatency` | No | MilliSeconds |Average, Minimum, Maximum, Total (Sum) |`DatabaseName`, `CollectionName`, `Region`, `ConnectionMode`, `OperationType`, `PublicAPIType`|PT1M, PT5M, PT1H, P1D |No|
|**Server Side Latency Direct**<br><br>Server Side Latency in Direct Connection Mode |`ServerSideLatencyDirect` | No | MilliSeconds |Average, Minimum, Maximum, Total (Sum) |`DatabaseName`, `CollectionName`, `Region`, `ConnectionMode`, `OperationType`, `PublicAPIType`, `APIType`, `IsExternal`|PT1M, PT5M, PT1H, P1D |No|
|**Server Side Latency Gateway**<br><br>Server Side Latency in Gateway Connection Mode |`ServerSideLatencyGateway` | No | MilliSeconds |Average, Minimum, Maximum, Total (Sum) |`DatabaseName`, `CollectionName`, `Region`, `ConnectionMode`, `OperationType`, `PublicAPIType`, `APIType`, `IsExternal`|PT1M, PT5M, PT1H, P1D |No|
|**Service Availability**<br><br>Account requests availability at one hour, day or month granularity |`ServiceAvailability` | No | Percent |Minimum, Average, Maximum |`IsExternal`|PT1H |No|
|**Sql Container Created**<br><br>Sql Container Created |`SqlContainerCreate` | No | Count |Count |`ResourceName`, `ChildResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`, `OperationType`|PT5M |No|
|**Sql Container Deleted**<br><br>Sql Container Deleted |`SqlContainerDelete` | No | Count |Count |`ResourceName`, `ChildResourceName`, `ApiKind`, `ApiKindResourceType`, `OperationType`|PT5M |No|
|**Sql Container Throughput Updated**<br><br>Sql Container Throughput Updated |`SqlContainerThroughputUpdate` | No | Count |Count |`ResourceName`, `ChildResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`|PT5M |No|
|**Sql Container Updated**<br><br>Sql Container Updated |`SqlContainerUpdate` | No | Count |Count |`ResourceName`, `ChildResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`, `OperationType`|PT5M |No|
|**Sql Database Created**<br><br>Sql Database Created |`SqlDatabaseCreate` | No | Count |Count |`ResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`, `OperationType`|PT5M |No|
|**Sql Database Deleted**<br><br>Sql Database Deleted |`SqlDatabaseDelete` | No | Count |Count |`ResourceName`, `ApiKind`, `ApiKindResourceType`, `OperationType`|PT5M |No|
|**Sql Database Throughput Updated**<br><br>Sql Database Throughput Updated |`SqlDatabaseThroughputUpdate` | No | Count |Count |`ResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`|PT5M |No|
|**Sql Database Updated**<br><br>Sql Database Updated |`SqlDatabaseUpdate` | No | Count |Count |`ResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`, `OperationType`|PT5M |No|
|**AzureTable Table Created**<br><br>AzureTable Table Created |`TableTableCreate` | No | Count |Count |`ResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`, `OperationType`|PT5M |No|
|**AzureTable Table Deleted**<br><br>AzureTable Table Deleted |`TableTableDelete` | No | Count |Count |`ResourceName`, `ApiKind`, `ApiKindResourceType`, `OperationType`|PT5M |No|
|**AzureTable Table Throughput Updated**<br><br>AzureTable Table Throughput Updated |`TableTableThroughputUpdate` | No | Count |Count |`ResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`|PT5M |No|
|**AzureTable Table Updated**<br><br>AzureTable Table Updated |`TableTableUpdate` | No | Count |Count |`ResourceName`, `ApiKind`, `ApiKindResourceType`, `IsThroughputRequest`, `OperationType`|PT5M |No|
|**Total Requests**<br><br>Number of requests made |`TotalRequests` | No | Count |Count |`DatabaseName`, `CollectionName`, `Region`, `StatusCode`, `OperationType`, `Status`, `CapacityType`, `PriorityLevel`, `ConnectionMode`, `IsExternal`|PT1M |No|
|**Total Requests (Preview)**<br><br>Number of SQL requests |`TotalRequestsPreview` | No | Count |Count |`DatabaseName`, `CollectionName`, `Region`, `StatusCode`, `OperationType`, `Status`, `PriorityLevel`, `IsExternal`, `ThroughputBucket`|PT1M |No|
|**Total Request Units**<br><br>SQL Request Units consumed |`TotalRequestUnits` | No | Count |Total (Sum), Average, Maximum |`DatabaseName`, `CollectionName`, `Region`, `StatusCode`, `OperationType`, `Status`, `CapacityType`, `PriorityLevel`|PT1M |No|
|**Total Request Units (Preview)**<br><br>Request Units consumed with CapacityType |`TotalRequestUnitsPreview` | No | Count |Total (Sum), Average, Maximum |`DatabaseName`, `CollectionName`, `Region`, `StatusCode`, `OperationType`, `Status`, `CapacityType`, `PriorityLevel`, `ThroughputBucket`|PT1M |No|
|**Account Keys Updated**<br><br>Account Keys Updated |`UpdateAccountKeys` | No | Count |Count |`KeyType`|PT5M |No|
|**Account Network Settings Updated**<br><br>Account Network Settings Updated |`UpdateAccountNetworkSettings` | No | Count |Count |\<none\>|PT5M |No|
|**Account Replication Settings Updated**<br><br>Account Replication Settings Updated |`UpdateAccountReplicationSettings` | No | Count |Count |\<none\>|PT5M |No|
|**Account Diagnostic Settings Updated**<br><br>Account Diagnostic Settings Updated |`UpdateDiagnosticsSettings` | No | Count |Count |`DiagnosticSettingsName`, `ResourceGroupName`|PT5M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
