---
title: Supported metrics - Microsoft.AzureDataTransfer/connections/flows
description: Reference for Microsoft.AzureDataTransfer/connections/flows metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 06/19/2026
ms.custom: Microsoft.AzureDataTransfer/connections/flows, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.AzureDataTransfer/connections/flows

The following table lists the metrics available for the Microsoft.AzureDataTransfer/connections/flows resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.AzureDataTransfer/connections/flows](../supported-logs/microsoft-azuredatatransfer-connections-flows-logs.md)


|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Delivered Byte count**<br><br>The number of bytes delivered. |`DeliveredBytes` |Bytes |Total (Sum), Average, Minimum, Maximum, Count |\<none\>|PT1M |Yes|
|**Delivered object count**<br><br>The number of objects delivered. |`DeliveredObjects` |Count |Total (Sum), Average, Minimum, Maximum, Count |\<none\>|PT1M |Yes|
|**End to end latency**<br><br>The amount of time for an object to be transferred, from object discovery to object delivery |`EndToEndLatency` |Milliseconds |Average, Minimum, Maximum, Total (Sum) |\<none\>|PT1M |Yes|
|**Errors**<br><br>The number of errors. |`Errors` |Count |Total (Sum), Average, Minimum, Maximum, Count |`StatusCode`, `StatusText`|PT1M |Yes|
|**Rejected object count**<br><br>The number of rejected objects. |`RejectedObjects` |Count |Total (Sum), Average, Minimum, Maximum, Count |`StatusCode`, `StatusText`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
