---
title: Supported metrics - Microsoft.ApiManagement/service
description: Reference for Microsoft.ApiManagement/service metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.ApiManagement/service, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.ApiManagement/service

The following table lists the metrics available for the Microsoft.ApiManagement/service resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.ApiManagement/service](../supported-logs/microsoft-apimanagement-service-logs.md)


### Category: Capacity
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Capacity**<br><br>Utilization metric for ApiManagement service. Note: For skus other than Premium, 'Max' aggregation will show the value as 0. |`Capacity` |Percent |Average, Maximum |`Location`|PT1M |Yes|
|**CPU Percentage of Gateway**<br><br>CPU Percentage of Gateway for SKUv2 services |`CpuPercent_Gateway` |Percent |Average, Maximum |\<none\>|PT1M |Yes|
|**Memory Percentage of Gateway**<br><br>Memory Percentage of Gateway for SKUv2 services |`MemoryPercent_Gateway` |Percent |Average, Maximum |\<none\>|PT1M |Yes|

### Category: EventHub Events
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Dropped EventHub Events**<br><br>Number of events skipped because of queue size limit reached |`EventHubDroppedEvents` |Count |Total (Sum) |`Location`|PT1M |Yes|
|**Rejected EventHub Events**<br><br>Number of rejected EventHub events (wrong configuration or unauthorized) |`EventHubRejectedEvents` |Count |Total (Sum) |`Location`|PT1M |Yes|
|**Successful EventHub Events**<br><br>Number of successful EventHub events |`EventHubSuccessfulEvents` |Count |Total (Sum) |`Location`|PT1M |Yes|
|**Throttled EventHub Events**<br><br>Number of throttled EventHub events |`EventHubThrottledEvents` |Count |Total (Sum) |`Location`|PT1M |Yes|
|**Timed Out EventHub Events**<br><br>Number of timed out EventHub events |`EventHubTimedoutEvents` |Count |Total (Sum) |`Location`|PT1M |Yes|
|**Size of EventHub Events**<br><br>Total size of EventHub events in bytes |`EventHubTotalBytesSent` |Bytes |Total (Sum) |`Location`|PT1M |Yes|
|**Total EventHub Events**<br><br>Number of events sent to EventHub |`EventHubTotalEvents` |Count |Total (Sum) |`Location`|PT1M |Yes|
|**Failed EventHub Events**<br><br>Number of failed EventHub events |`EventHubTotalFailedEvents` |Count |Total (Sum) |`Location`|PT1M |Yes|

### Category: Gateway Requests
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Duration of Backend Requests**<br><br>Duration of Backend Requests in milliseconds |`BackendDuration` |MilliSeconds |Average, Maximum, Minimum |`Location`, `Hostname`, `ApiId`|PT1M |Yes|
|**Overall Duration of Gateway Requests**<br><br>Overall Duration of Gateway Requests in milliseconds |`Duration` |MilliSeconds |Average, Maximum, Minimum |`Location`, `Hostname`, `ApiId`|PT1M |Yes|
|**Failed Gateway Requests (Deprecated)**<br><br>Number of failures in gateway requests - Use multi-dimension request metric with GatewayResponseCodeCategory dimension instead |`FailedRequests` |Count |Total (Sum) |`Location`, `Hostname`|PT1M |Yes|
|**Other Gateway Requests (Deprecated)**<br><br>Number of other gateway requests - Use multi-dimension request metric with GatewayResponseCodeCategory dimension instead |`OtherRequests` |Count |Total (Sum) |`Location`, `Hostname`|PT1M |Yes|
|**Requests**<br><br>Gateway request metrics with multiple dimensions |`Requests` |Count |Total (Sum), Maximum, Minimum |`Location`, `Hostname`, `LastErrorReason`, `BackendResponseCode`, `GatewayResponseCode`, `BackendResponseCodeCategory`, `GatewayResponseCodeCategory`, `ApiId`|PT1M |Yes|
|**Successful Gateway Requests (Deprecated)**<br><br>Number of successful gateway requests - Use multi-dimension request metric with GatewayResponseCodeCategory dimension instead |`SuccessfulRequests` |Count |Total (Sum) |`Location`, `Hostname`|PT1M |Yes|
|**Total Gateway Requests (Deprecated)**<br><br>Number of gateway requests - Use multi-dimension request metric with GatewayResponseCodeCategory dimension instead |`TotalRequests` |Count |Total (Sum) |`Location`, `Hostname`|PT1M |Yes|
|**Unauthorized Gateway Requests (Deprecated)**<br><br>Number of unauthorized gateway requests - Use multi-dimension request metric with GatewayResponseCodeCategory dimension instead |`UnauthorizedRequests` |Count |Total (Sum) |`Location`, `Hostname`|PT1M |Yes|

### Category: Gateway WebSocket
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**WebSocket Connection Attempts (Preview)**<br><br>Count of WebSocket connection attempts based on selected source and destination |`ConnectionAttempts` |Count |Total (Sum), Average |`Location`, `Source`, `Destination`, `State`|PT1M |Yes|
|**WebSocket Messages (Preview)**<br><br>Count of WebSocket messages based on selected source and destination |`WebSocketMessages` |Count |Total (Sum), Average |`Location`, `Source`, `Destination`|PT1M |Yes|

### Category: Network Status
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Network Connectivity Status of Resources (Preview)**<br><br>Network Connectivity status of dependent resource types from API Management service |`NetworkConnectivity` |Count |Total (Sum), Average |`Location`, `ResourceType`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
