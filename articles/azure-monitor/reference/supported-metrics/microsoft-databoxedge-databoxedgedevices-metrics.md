---
title: Supported metrics - Microsoft.DataBoxEdge/dataBoxEdgeDevices
description: Reference for Microsoft.DataBoxEdge/dataBoxEdgeDevices metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.DataBoxEdge/dataBoxEdgeDevices, arm

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.DataBoxEdge/dataBoxEdgeDevices

The following table lists the metrics available for the Microsoft.DataBoxEdge/dataBoxEdgeDevices resource type.

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



### Category: Capacity
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Available Capacity**<br><br>The available capacity in bytes during the reporting period. |`AvailableCapacity` |Bytes |Average, Minimum, Maximum |\<none\>|PT5M, PT15M, PT1H |Yes|
|**Total Capacity**<br><br>The total capacity of the device in bytes during the reporting period. |`TotalCapacity` |Bytes |Average, Minimum, Maximum |\<none\>|PT5M, PT15M, PT1H |Yes|

### Category: Transaction
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Cloud Bytes Uploaded (Device)**<br><br>The total number of bytes that is uploaded to Azure from a device during the reporting period. |`BytesUploadedToCloud` |Bytes |Average, Minimum, Maximum |\<none\>|PT5M, PT15M, PT1H |Yes|
|**Cloud Bytes Uploaded (Share)**<br><br>The total number of bytes that is uploaded to Azure from a share during the reporting period. |`BytesUploadedToCloudPerShare` |Bytes |Average, Minimum, Maximum |`Share`|PT1M, PT15M, PT1H |Yes|
|**Cloud Download Throughput**<br><br>The cloud download throughput to Azure during the reporting period. |`CloudReadThroughput` |BytesPerSecond |Average, Minimum, Maximum |\<none\>|PT5M, PT15M, PT1H |Yes|
|**Cloud Download Throughput (Share)**<br><br>The download throughput to Azure from a share during the reporting period. |`CloudReadThroughputPerShare` |BytesPerSecond |Average, Minimum, Maximum |`Share`|PT1M, PT15M, PT1H |Yes|
|**Cloud Upload Throughput**<br><br>The cloud upload throughput to Azure during the reporting period. |`CloudUploadThroughput` |BytesPerSecond |Average, Minimum, Maximum |\<none\>|PT5M, PT15M, PT1H |Yes|
|**Cloud Upload Throughput (Share)**<br><br>The upload throughput to Azure from a share during the reporting period. |`CloudUploadThroughputPerShare` |BytesPerSecond |Average, Minimum, Maximum |`Share`|PT1M, PT15M, PT1H |Yes|
|**Edge Compute - Memory Usage**<br><br>Amount of RAM in Use |`HyperVMemoryUtilization` |Percent |Average, Minimum, Maximum |`InstanceName`|PT1M, PT15M, PT1H |Yes|
|**Edge Compute - Percentage CPU**<br><br>Percent CPU Usage |`HyperVVirtualProcessorUtilization` |Percent |Average, Minimum, Maximum |`InstanceName`|PT1M, PT15M, PT1H |Yes|
|**Read Throughput (Network)**<br><br>The read throughput of the network interface on the device in the reporting period for all volumes in the gateway. |`NICReadThroughput` |BytesPerSecond |Average, Minimum, Maximum |`InstanceName`|PT1M, PT15M, PT1H |Yes|
|**Write Throughput (Network)**<br><br>The write throughput of the network interface on the device in the reporting period for all volumes in the gateway. |`NICWriteThroughput` |BytesPerSecond |Average, Minimum, Maximum |`InstanceName`|PT1M, PT15M, PT1H |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
