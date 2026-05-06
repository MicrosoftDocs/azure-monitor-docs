---
title: Supported metrics - Microsoft.Storage/storageAccounts
description: Reference for Microsoft.Storage/storageAccounts metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Storage/storageAccounts, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Storage/storageAccounts

The following table lists the metrics available for the Microsoft.Storage/storageAccounts resource type.

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
|**Used capacity**<br><br>The amount of storage used by the storage account. For standard storage accounts, it's the sum of capacity used by blob, table, file, and queue. For premium storage accounts and Blob storage accounts, it is the same as BlobCapacity or FileCapacity. |`UsedCapacity` |Bytes |Average |\<none\>|PT1H |No|

### Category: Transaction
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Availability**<br><br>The percentage of availability for the storage service or the specified API operation. Availability is calculated by taking the TotalBillableRequests value and dividing it by the number of applicable requests, including those that produced unexpected errors. All unexpected errors result in reduced availability for the storage service or the specified API operation. |`Availability` |Percent |Average, Minimum, Maximum |`GeoType`, `ApiName`, `Authentication`|PT1M |Yes|
|**Egress**<br><br>The amount of egress data. This number includes egress to external client from Azure Storage as well as egress within Azure. As a result, this number does not reflect billable egress. |`Egress` |Bytes |Total (Sum), Average, Minimum, Maximum |`GeoType`, `ApiName`, `Authentication`|PT1M |Yes|
|**Ingress**<br><br>The amount of ingress data, in bytes. This number includes ingress from an external client into Azure Storage as well as ingress within Azure. |`Ingress` |Bytes |Total (Sum), Average, Minimum, Maximum |`GeoType`, `ApiName`, `Authentication`|PT1M |Yes|
|**Blob Geo-Replication Lag**<br><br>The amount of Geo-replication lag for Blob data in seconds. Geo-replication lag is the time it takes for data stored in the primary region of the storage account to replicate to the secondary region. Since the data written to geo-redundant accounts replicates asynchronously, any data written to the primary region will not be instantly available in the secondary region. |`ReplicationLagSeconds` |Seconds |Average, Minimum, Maximum |\<none\>|PT1M |Yes|
|**Success E2E Latency**<br><br>The average end-to-end latency of successful requests made to a storage service or the specified API operation, in milliseconds. This value includes the required processing time within Azure Storage to read the request, send the response, and receive acknowledgment of the response. |`SuccessE2ELatency` |MilliSeconds |Average, Minimum, Maximum |`GeoType`, `ApiName`, `Authentication`|PT1M |Yes|
|**Success Server Latency**<br><br>The average time used to process a successful request by Azure Storage. This value does not include the network latency specified in SuccessE2ELatency. |`SuccessServerLatency` |MilliSeconds |Average, Minimum, Maximum |`GeoType`, `ApiName`, `Authentication`|PT1M |Yes|
|**Transactions**<br><br>The number of requests made to a storage service or the specified API operation. This number includes successful and failed requests, as well as requests which produced errors. Use ResponseType dimension for the number of different type of response. |`Transactions` |Count |Total (Sum) |`ResponseType`, `GeoType`, `ApiName`, `Authentication`, `TransactionType`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
