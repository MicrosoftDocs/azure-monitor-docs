---
title: Supported metrics - Microsoft.EventGrid/partnerTopics
description: Reference for Microsoft.EventGrid/partnerTopics metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.EventGrid/partnerTopics, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.EventGrid/partnerTopics

The following table lists the metrics available for the Microsoft.EventGrid/partnerTopics resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.EventGrid/partnerTopics](../supported-logs/microsoft-eventgrid-partnertopics-logs.md)


|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Advanced Filter Evaluations**<br><br>Total advanced filters evaluated across event subscriptions for this partner topic. |`AdvancedFilterEvaluationCount` |Count |Total (Sum) |`EventSubscriptionName`|PT1M |Yes|
|**Dead Lettered Events**<br><br>Total dead lettered events matching to this event subscription |`DeadLetteredCount` |Count |Total (Sum) |`DeadLetterReason`, `EventSubscriptionName`|PT1M |Yes|
|**Delivery Failed Events**<br><br>Total events failed to deliver to this event subscription |`DeliveryAttemptFailCount` |Count |Total (Sum) |`Error`, `ErrorType`, `EventSubscriptionName`|PT1M |No|
|**Delivered Events**<br><br>Total events delivered to this event subscription |`DeliverySuccessCount` |Count |Total (Sum) |`EventSubscriptionName`|PT1M |Yes|
|**Destination Processing Duration**<br><br>Destination processing duration in milliseconds |`DestinationProcessingDurationInMs` |MilliSeconds |Average |`EventSubscriptionName`|PT1M |No|
|**Dropped Events**<br><br>Total dropped events matching to this event subscription |`DroppedEventCount` |Count |Total (Sum) |`DropReason`, `EventSubscriptionName`|PT1M |Yes|
|**Matched Events**<br><br>Total events matched to this event subscription |`MatchedEventCount` |Count |Total (Sum) |`EventSubscriptionName`|PT1M |Yes|
|**Published Events**<br><br>Total events published to this partner topic |`PublishSuccessCount` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Unmatched Events**<br><br>Total events not matching any of the event subscriptions for this partner topic |`UnmatchedEventCount` |Count |Total (Sum) |\<none\>|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
