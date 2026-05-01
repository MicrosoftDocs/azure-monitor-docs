---
title: Supported metrics - Microsoft.Network/networkWatchers/connectionMonitors
description: Reference for Microsoft.Network/networkWatchers/connectionMonitors metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Network/networkWatchers/connectionMonitors, arm

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Network/networkWatchers/connectionMonitors

The following table lists the metrics available for the Microsoft.Network/networkWatchers/connectionMonitors resource type.

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
|**Avg. Round-trip Time (ms) (classic)**<br><br>Average network round-trip time (ms) for connectivity monitoring probes sent between source and destination |`AverageRoundtripMs` |MilliSeconds |Average |\<none\>|PT1M, PT1H |Yes|
|**Checks Failed Percent**<br><br>% of connectivity monitoring checks failed |`ChecksFailedPercent` |Percent |Average |`SourceAddress`, `SourceName`, `SourceResourceId`, `SourceType`, `Protocol`, `DestinationAddress`, `DestinationName`, `DestinationResourceId`, `DestinationType`, `DestinationPort`, `TestGroupName`, `TestConfigurationName`, `SourceIP`, `DestinationIP`, `SourceSubnet`, `DestinationSubnet`|PT1M, PT1H |Yes|
|**% Probes Failed (classic)**<br><br>% of connectivity monitoring probes failed |`ProbesFailedPercent` |Percent |Average |\<none\>|PT1M, PT1H |Yes|
|**Round-Trip Time (ms)**<br><br>Round-trip time in milliseconds for the connectivity monitoring checks |`RoundTripTimeMs` |MilliSeconds |Average |`SourceAddress`, `SourceName`, `SourceResourceId`, `SourceType`, `Protocol`, `DestinationAddress`, `DestinationName`, `DestinationResourceId`, `DestinationType`, `DestinationPort`, `TestGroupName`, `TestConfigurationName`, `SourceIP`, `DestinationIP`, `SourceSubnet`, `DestinationSubnet`|PT1M, PT1H |Yes|
|**Test Result**<br><br>Connection monitor test result |`TestResult` |Count |Average |`SourceAddress`, `SourceName`, `SourceResourceId`, `SourceType`, `Protocol`, `DestinationAddress`, `DestinationName`, `DestinationResourceId`, `DestinationType`, `DestinationPort`, `TestGroupName`, `TestConfigurationName`, `TestResultCriterion`, `SourceIP`, `DestinationIP`, `SourceSubnet`, `DestinationSubnet`|PT1M, PT1H |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
