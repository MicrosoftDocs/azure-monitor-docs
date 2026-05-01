---
title: Supported metrics - Microsoft.StorageSync/storageSyncServices
description: Reference for Microsoft.StorageSync/storageSyncServices metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 03/02/2026
ms.custom: Microsoft.StorageSync/storageSyncServices, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.StorageSync/storageSyncServices

The following table lists the metrics available for the Microsoft.StorageSync/storageSyncServices resource type.

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
|**Sync Session Result**<br><br>Metric that logs a value of 1 each time the Server Endpoint successfully completes a Sync Session with the Cloud Endpoint |`ServerSyncSessionResult` |Count |Average, Count, Total (Sum), Maximum, Minimum |`SyncGroupName`, `ServerEndpointName`, `SyncDirection`|PT1M |Yes|
|**Agent Version Expiration Information**<br><br>Emits the number of days until the agent version expires |`StorageSyncAgentVersionExpirationDays` |Count |Count, Minimum, Maximum |`CurrentAgentVersion`, `ServerName`|PT1M |Yes|
|**Bytes synced**<br><br>Total file size transferred for Sync Sessions |`StorageSyncBatchTransferredFileBytes` |Bytes |Average, Total (Sum) |`SyncGroupName`, `ServerEndpointName`, `SyncDirection`|PT1M |Yes|
|**Cloud tiering cache hit rate**<br><br>Percentage of bytes that were served from the cache |`StorageSyncComputedCacheHitRate` |Percent |Average |`SyncGroupName`, `ServerName`, `ServerEndpointName`|PT1M |Yes|
|**Cache data size by last access time**<br><br>Size of data by last access time |`StorageSyncDataSizeByAccessPattern` |Bytes |Average, Maximum, Minimum |`SyncGroupName`, `ServerName`, `ServerEndpointName`, `LastAccessTime`|PT1M |No|
|**Cloud tiering size of data tiered by last maintenance job**<br><br>Size of data tiered during last maintenance job |`StorageSyncIncrementalTieredDataSizeBytes` |Bytes |Total (Sum), Average, Maximum, Minimum |`SyncGroupName`, `ServerName`, `ServerEndpointName`, `TieringReason`|PT1M |Yes|
|**Cloud tiering low disk space mode**<br><br>Indicates if the server endpoint is in low disk space mode or not (1=yes; 0=no) |`StorageSyncLowDiskModeCount` |Count |Count, Minimum, Maximum, Total (Sum) |`SyncGroupName`, `ServerName`, `ServerEndpointName`|PT1M |Yes|
|**Cloud tiering recall success rate**<br><br>Percentage of all recalls that were successful |`StorageSyncRecallComputedSuccessRate` |Percent |Average |`SyncGroupName`, `ServerName`, `ServerEndpointName`|PT1M |Yes|
|**Cloud tiering recall size by application**<br><br>Size of data recalled by application |`StorageSyncRecalledNetworkBytesByApplication` |Bytes |Average, Total (Sum) |`SyncGroupName`, `ServerName`, `ApplicationName`|PT1M |Yes|
|**Cloud tiering recall size**<br><br>Size of data recalled |`StorageSyncRecalledTotalNetworkBytes` |Bytes |Average, Total (Sum) |`SyncGroupName`, `ServerName`, `ServerEndpointName`|PT1M |Yes|
|**Cloud tiering recall throughput**<br><br>Size of data recall throughput |`StorageSyncRecallThroughputBytesPerSecond` |BytesPerSecond |Average, Total (Sum), Maximum, Minimum |`SyncGroupName`, `ServerName`, `ServerEndpointName`|PT1M |Yes|
|**Server Online Status**<br><br>Metric that logs a value of 1 each time the resigtered server successfully records a heartbeat with the Cloud Endpoint |`StorageSyncServerHeartbeat` |Count |Average, Count, Total (Sum), Maximum, Minimum |`ServerName`|PT1M |Yes|
|**Files Synced**<br><br>Count of Files synced |`StorageSyncSyncSessionAppliedFilesCount` |Count |Average, Total (Sum) |`SyncGroupName`, `ServerEndpointName`, `SyncDirection`|PT1M |Yes|
|**Files not syncing**<br><br>Count of files failed to sync |`StorageSyncSyncSessionPerItemErrorsCount` |Count |Average |`SyncGroupName`, `ServerEndpointName`, `SyncDirection`|PT1M |Yes|
|**Cloud tiering size of data tiered**<br><br>Size of data tiered to Azure file share |`StorageSyncTieredDataSizeBytes` |Bytes |Average, Total (Sum), Maximum, Minimum |`SyncGroupName`, `ServerName`, `ServerEndpointName`|PT1M |Yes|
|**Server cache size**<br><br>Size of data cached on the server |`StorageSyncTieringCacheSizeBytes` |Bytes |Average, Maximum, Minimum |`SyncGroupName`, `ServerName`, `ServerEndpointName`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
