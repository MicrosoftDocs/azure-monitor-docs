---
title: Supported metrics - Microsoft.Monitor/accounts
description: Reference for Microsoft.Monitor/accounts metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Monitor/accounts, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Monitor/accounts

The following table lists the metrics available for the Microsoft.Monitor/accounts resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.Monitor/accounts](../supported-logs/microsoft-monitor-accounts-logs.md)


|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Active Time Series**<br><br>The number of unique time series recently ingested into the account over the previous 12 hours |`ActiveTimeSeries` |Count |Maximum |`StampColor`|PT1M |No|
|**Active Time Series Limit**<br><br>The limit on the number of unique time series which can be actively ingested into the account |`ActiveTimeSeriesLimit` |Count |Average, Maximum |`StampColor`|PT1M |No|
|**Active Time Series % Utilization**<br><br>The percentage of current active time series account limit being utilized |`ActiveTimeSeriesPercentUtilization` |Percent |Average |`StampColor`|PT1M |No|
|**Events Dropped (preview)**<br><br>Number of events that were dropped by reason |`EventsDropped` |Count |Maximum |`StampColor`, `Reason`|PT1M |No|
|**Events Per Minute Received**<br><br>The number of events per minute recently received |`EventsPerMinuteIngested` |Count |Maximum |`StampColor`|PT1M |No|
|**Events Per Minute Received Limit**<br><br>The maximum number of events per minute which can be received before events become throttled |`EventsPerMinuteIngestedLimit` |Count |Average, Maximum |`StampColor`|PT1M |No|
|**Events Per Minute Received % Utilization**<br><br>The percentage of the current metric ingestion rate limit being utilized |`EventsPerMinuteIngestedPercentUtilization` |Percent |Average |`StampColor`|PT1M |No|
|**Time Series Samples Dropped (preview)**<br><br>Number of timeseries samples that were dropped by reason |`TimeSeriesSamplesDropped` |Count |Maximum |`StampColor`, `Reason`|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
