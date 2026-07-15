---
title: Supported metrics - Microsoft.DevOpsInfrastructure/pools
description: Reference for Microsoft.DevOpsInfrastructure/pools metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: Microsoft.DevOpsInfrastructure/pools, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.DevOpsInfrastructure/pools

The following table lists the metrics available for the Microsoft.DevOpsInfrastructure/pools resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.DevOpsInfrastructure/pools](../supported-logs/microsoft-devopsinfrastructure-pools-logs.md)


### Category: Latency
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**AllocationDurationMs**<br><br>Average time to allocate requests (ms) |`AllocationDurationMs` | No | Milliseconds |Average |`PoolId`, `Type`, `ResourceRequestType`, `Image`|PT1M |Yes|
|**TimeSpentInPreviousStateMs**<br><br>Time spent in previous state before transitioning to current state (ms) |`TimeSpentInPreviousStateMs` | No | Milliseconds |Average, Maximum, Minimum |`PoolId`, `Image`, `ImageVersion`, `DataDiskType`, `PreviousState`, `NewState`|PT1M |Yes|

### Category: Saturation
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Allocated**<br><br>Resources that are allocated |`Allocated` | No | Count |Average, Maximum, Minimum |`PoolId`, `SKU`, `Images`, `ProviderName`|PT1M |Yes|
|**Demand**<br><br>Total active demand on the pool |`Demand` | No | Count |Average, Maximum, Minimum |`PoolId`, `SKU`, `Images`, `ProviderName`|PT1M |Yes|
|**NotReady**<br><br>Resources that are not ready to be used |`NotReady` | No | Count |Average, Maximum, Minimum |`PoolId`, `SKU`, `Images`, `ProviderName`|PT1M |Yes|
|**PendingReimage**<br><br>Resources that are pending reimage |`PendingReimage` | No | Count |Average, Maximum, Minimum |`PoolId`, `SKU`, `Images`, `ProviderName`|PT1M |Yes|
|**PendingReturn**<br><br>Resources that are pending return |`PendingReturn` | No | Count |Average, Maximum, Minimum |`PoolId`, `SKU`, `Images`, `ProviderName`|PT1M |Yes|
|**Provisioned**<br><br>Resources that are provisioned |`Provisioned` | No | Count |Average, Maximum, Minimum |`PoolId`, `SKU`, `Images`, `ProviderName`|PT1M |Yes|
|**Ready**<br><br>Resources that are ready to be used |`Ready` | No | Count |Average, Maximum, Minimum |`PoolId`, `SKU`, `Images`, `ProviderName`|PT1M |Yes|
|**Starting**<br><br>Resources that are starting |`Starting` | No | Count |Average, Maximum, Minimum |`PoolId`, `SKU`, `Images`, `ProviderName`|PT1M |Yes|
|**Total**<br><br>Total Number of Resources |`Total` | No | Count |Average, Maximum, Minimum |`PoolId`, `SKU`, `Images`, `ProviderName`|PT1M |Yes|

### Category: SaturationByCapability
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Allocated**<br><br>Resources that are allocated by capability |`AllocatedByCapability` | No | Count |Average, Maximum, Minimum |`PoolId`, `Image`, `ImageVersion`, `DataDiskType`|PT1M |Yes|
|**Demand**<br><br>Total active demand on the pool by capability |`DemandByCapability` | No | Count |Average, Maximum, Minimum |`PoolId`, `Image`, `ImageVersion`, `DataDiskType`|PT1M |Yes|
|**NotReady**<br><br>Resources that are not ready to be used by capability |`NotReadyByCapability` | No | Count |Average, Maximum, Minimum |`PoolId`, `Image`, `ImageVersion`, `DataDiskType`|PT1M |Yes|
|**PendingReimage**<br><br>Resources that are pending reimage by capability |`PendingReimageByCapability` | No | Count |Average, Maximum, Minimum |`PoolId`, `Image`, `ImageVersion`, `DataDiskType`|PT1M |Yes|
|**PendingReturn**<br><br>Resources that are pending return by capability |`PendingReturnByCapability` | No | Count |Average, Maximum, Minimum |`PoolId`, `Image`, `ImageVersion`, `DataDiskType`|PT1M |Yes|
|**Provisioned**<br><br>Resources that are provisioned by capability |`ProvisionedByCapability` | No | Count |Average, Maximum, Minimum |`PoolId`, `Image`, `ImageVersion`, `DataDiskType`|PT1M |Yes|
|**Ready**<br><br>Resources that are ready to be used by capability |`ReadyByCapability` | No | Count |Average, Maximum, Minimum |`PoolId`, `Image`, `ImageVersion`, `DataDiskType`|PT1M |Yes|
|**Starting**<br><br>Resources that are starting by capability |`StartingByCapability` | No | Count |Average, Maximum, Minimum |`PoolId`, `Image`, `ImageVersion`, `DataDiskType`|PT1M |Yes|

### Category: Traffic
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Count**<br><br>Number of requests in last dump |`Count` | No | Count |Count |`RequestType`, `Status`, `PoolId`, `Type`, `ErrorCode`, `FailureStage`, `Image`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
