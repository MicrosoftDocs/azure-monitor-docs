---
title: Supported metrics - Microsoft.StorageCache/amlFilesystems
description: Reference for Microsoft.StorageCache/amlFilesystems metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: Microsoft.StorageCache/amlFilesystems, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.StorageCache/amlFilesystems

The following table lists the metrics available for the Microsoft.StorageCache/amlFilesystems resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.StorageCache/amlFilesystems](../supported-logs/microsoft-storagecache-amlfilesystems-logs.md)


|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Client Read Latency Total**<br><br>Client total read op latency. |`ClientReadLatencyTotal` | No | MilliSeconds |Minimum, Maximum, Average, Total (Sum) |`ostnum`|PT1M |No|
|**Client Read Ops**<br><br>Number of client read ops performed. |`ClientReadOps` | No | Count |Minimum, Maximum, Average |`ostnum`|PT1M |No|
|**Client Read Throughput**<br><br>Client read data transfer rate. |`ClientReadThroughput` | No | BytesPerSecond |Minimum, Maximum, Average |`ostnum`|PT1M |No|
|**Client Write Latency Total**<br><br>Client total write op latency. |`ClientWriteLatencyTotal` | No | MilliSeconds |Minimum, Maximum, Average, Total (Sum) |`ostnum`|PT1M |No|
|**Client Write Ops**<br><br>Number of client write ops performed. |`ClientWriteOps` | No | Count |Minimum, Maximum, Average |`ostnum`|PT1M |No|
|**Client Write Throughput**<br><br>Client write data transfer rate. |`ClientWriteThroughput` | No | BytesPerSecond |Minimum, Maximum, Average |`ostnum`|PT1M |No|
|**HSM Action Errors**<br><br>Total number of errors encountered processing requests. |`HSMActionErrors` | No | Count |Minimum, Maximum, Average, Total (Sum) |`mdtnum`|PT1M |No|
|**HSM Archive Requests**<br><br>Number of in-flight HSM archive requests. |`HSMArchiveRequests` | No | Count |Minimum, Maximum, Average, Total (Sum) |`mdtnum`|PT1M |No|
|**HSM Completed Requests**<br><br>Total number of completed HSM requests. |`HSMCompletedRequests` | No | Count |Minimum, Maximum, Average, Total (Sum) |`mdtnum`|PT1M |No|
|**HSM Current Requests**<br><br>Total number of currently active HSM requests. |`HSMCurrentRequests` | No | Count |Minimum, Maximum, Average, Total (Sum) |`mdtnum`|PT1M |No|
|**HSM Remove Requests**<br><br>Number of in-flight HSM remove requests. |`HSMRemoveRequests` | No | Count |Minimum, Maximum, Average, Total (Sum) |`mdtnum`|PT1M |No|
|**HSM Restore Requests**<br><br>Number of in-flight HSM restore requests. |`HSMRestoreRequests` | No | Count |Minimum, Maximum, Average, Total (Sum) |`mdtnum`|PT1M |No|
|**Lustre Client Evictions**<br><br>The number of client evictions reported over a 1 minute period. |`LustreClientEvictions` | No | Count |Minimum, Maximum, Average, Total (Sum) |\<none\>|PT1M |No|
|**MDT Bytes Available**<br><br>Number of bytes marked as available on the MDT. |`MDTBytesAvailable` | No | Bytes |Minimum, Maximum, Average |`mdtnum`|PT1M |No|
|**MDT Bytes Total**<br><br>Total number of bytes supported on the MDT. |`MDTBytesTotal` | No | Bytes |Minimum, Maximum, Average |`mdtnum`|PT1M |No|
|**MDT Bytes Used**<br><br>Number of bytes available for use minus the number of bytes marked as free on the MDT. |`MDTBytesUsed` | No | Bytes |Minimum, Maximum, Average |`mdtnum`|PT1M |No|
|**MDT Client Latency**<br><br>Client latency for all operations to MDTs. |`MDTClientLatency` | No | MilliSeconds |Minimum, Maximum, Average |`mdtnum`, `operation`|PT1M |No|
|**Client MDT Ops**<br><br>Number of client MDT metadata ops performed. |`MDTClientOps` | No | Count |Minimum, Maximum, Average |`mdtnum`, `operation`|PT1M |No|
|**MDT Connected Clients**<br><br>Number of client connections (exports) to the MDT |`MDTConnectedClients` | No | Count |Minimum, Maximum, Average, Total (Sum) |`mdtnum`|PT1M |No|
|**MDT Files Free**<br><br>Count of free files (inodes) on the MDT. |`MDTFilesFree` | No | Count |Minimum, Maximum, Average |`mdtnum`|PT1M |No|
|**MDT Files Total**<br><br>Total number of files supported on the MDT. |`MDTFilesTotal` | No | Count |Minimum, Maximum, Average |`mdtnum`|PT1M |No|
|**MDT Files Used**<br><br>Number of total supported files minus the number of free files on the MDT. |`MDTFilesUsed` | No | Count |Minimum, Maximum, Average |`mdtnum`|PT1M |No|
|**OST Bytes Available**<br><br>Number of bytes marked as available on the OST. |`OSTBytesAvailable` | No | Bytes |Minimum, Maximum, Average |`ostnum`|PT1M |No|
|**OST Bytes Total**<br><br>Total number of bytes supported on the OST. |`OSTBytesTotal` | No | Bytes |Minimum, Maximum, Average |`ostnum`|PT1M |No|
|**OST Bytes Used**<br><br>Number of bytes available for use minus the number of bytes marked as free on the OST. |`OSTBytesUsed` | No | Bytes |Minimum, Maximum, Average |`ostnum`|PT1M |No|
|**OST Client Latency**<br><br>Client latency for all operations to OSTs. |`OSTClientLatency` | No | MilliSeconds |Minimum, Maximum, Average |`ostnum`, `operation`|PT1M |No|
|**Client OST Ops**<br><br>Number of client OST metadata ops performed. |`OSTClientOps` | No | Count |Minimum, Maximum, Average |`ostnum`, `operation`|PT1M |No|
|**OST Connected Clients**<br><br>Number of client connections (exports) to the OST |`OSTConnectedClients` | No | Count |Minimum, Maximum, Average |`ostnum`|PT1M |No|
|**OST Files Free**<br><br>Count of free files (inodes) on the OST. |`OSTFilesFree` | No | Count |Minimum, Maximum, Average |`ostnum`|PT1M |No|
|**OST Files Total**<br><br>Total number of files supported on the OST. |`OSTFilesTotal` | No | Count |Minimum, Maximum, Average |`ostnum`|PT1M |No|
|**OST Files Used**<br><br>Number of total supported files minus the number of free files on the OST. |`OSTFilesUsed` | No | Count |Minimum, Maximum, Average |`ostnum`|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
