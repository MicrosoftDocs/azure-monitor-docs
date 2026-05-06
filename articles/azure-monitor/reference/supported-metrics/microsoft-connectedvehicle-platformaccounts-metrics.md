---
title: Supported metrics - Microsoft.ConnectedVehicle/platformAccounts
description: Reference for Microsoft.ConnectedVehicle/platformAccounts metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.ConnectedVehicle/platformAccounts, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.ConnectedVehicle/platformAccounts

The following table lists the metrics available for the Microsoft.ConnectedVehicle/platformAccounts resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.ConnectedVehicle/platformAccounts](../supported-logs/microsoft-connectedvehicle-platformaccounts-logs.md)


|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Claims request execution time**<br><br>The average execution time of requests to the customer claims provider endpoint in milliseconds. |`ClaimsProviderRequestLatency` |Milliseconds |Average |`IsSuccessful`, `FailureCategory`|PT1M |Yes|
|**Claims provider requests**<br><br>Number of requests to claims provider |`ClaimsProviderRequests` |Count |Total (Sum) |`IsSuccessful`, `FailureCategory`|PT1M |Yes|
|**Vehicle connection service request execution time**<br><br>Vehicle conneciton request execution time average in milliseconds |`ConnectionServiceRequestRuntime` |Milliseconds |Average |`IsSuccessful`, `FailureCategory`|PT1M |Yes|
|**Vehicle connection service requests**<br><br>Total number of vehicle connection requests |`ConnectionServiceRequests` |Count |Total (Sum) |`IsSuccessful`, `FailureCategory`|PT1M |Yes|
|**Data pipeline message count**<br><br>The total number of messages sent to the MCVP data pipeline for storage. |`DataPipelineMessageCount` |Count |Total (Sum) |`IsSuccessful`, `FailureCategory`|PT1M |Yes|
|**Extension invocation count**<br><br>Total number of times an extension was called. |`ExtensionInvocationCount` |Count |Total (Sum) |`ExtensionName`, `IsSuccessful`, `FailureCategory`|PT1M |Yes|
|**Extension invocation execution time**<br><br>Average execution time spent inside an extension in milliseconds. |`ExtensionInvocationRuntime` |Milliseconds |Average |`ExtensionName`, `IsSuccessful`, `FailureCategory`|PT1M |Yes|
|**Messages received count**<br><br>The total number of vehicle-sourced publishes. |`MessagesInCount` |Count |Total (Sum) |`IsSuccessful`, `FailureCategory`|PT1M |Yes|
|**Messages sent count**<br><br>The total number of cloud-sourced publishes. |`MessagesOutCount` |Count |Total (Sum) |`IsSuccessful`, `FailureCategory`|PT1M |Yes|
|**Vehicle provision execution time**<br><br>The average execution time of vehicle provision requests in milliseconds |`ProvisionerServiceRequestRuntime` |Milliseconds |Average |`IsSuccessful`, `FailureCategory`|PT1M |Yes|
|**Vehicle provision service requests**<br><br>Total number of vehicle provision requests |`ProvisionerServiceRequests` |Count |Total (Sum) |`IsSuccessful`, `FailureCategory`|PT1M |Yes|
|**State store read execution time**<br><br>State store read request execution time average in milliseconds. |`StateStoreReadRequestLatency` |Milliseconds |Average |`ExtensionName`, `IsSuccessful`, `FailureCategory`|PT1M |Yes|
|**State store read requests**<br><br>Number of read requests to state store |`StateStoreReadRequests` |Count |Total (Sum) |`ExtensionName`, `IsSuccessful`, `FailureCategory`|PT1M |Yes|
|**State store write execution time**<br><br>State store write request execution time average in milliseconds. |`StateStoreWriteRequestLatency` |Milliseconds |Average |`ExtensionName`, `IsSuccessful`, `FailureCategory`|PT1M |Yes|
|**State store write requests**<br><br>Number of write requests to state store |`StateStoreWriteRequests` |Count |Total (Sum) |`ExtensionName`, `IsSuccessful`, `FailureCategory`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
