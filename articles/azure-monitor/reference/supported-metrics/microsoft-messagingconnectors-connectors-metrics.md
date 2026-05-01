---
title: Supported metrics - Microsoft.MessagingConnectors/connectors
description: Reference for Microsoft.MessagingConnectors/connectors metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.MessagingConnectors/connectors, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.MessagingConnectors/connectors

The following table lists the metrics available for the Microsoft.MessagingConnectors/connectors resource type.

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
|**Sink Record Read Total By Time**<br><br>Number of records read by the sink connector by time |`SinkRecordReadTotalByTime` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Sink Record Send Total By Time**<br><br>Number of records sent by the sink connector by time |`SinkRecordSendTotalByTime` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Source Record Poll Total By Time**<br><br>Number of records polled by the source connector by time |`SourceRecordPollTotalByTime` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Source Record Write Total**<br><br>Number of records written by the source connector |`SourceRecordWriteTotal` |Count |Maximum, Minimum |\<none\>|PT1M |Yes|
|**Source Record Write Total By Time**<br><br>Number of records written by the source connector by time |`SourceRecordWriteTotalByTime` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Total Errors Logged By Time**<br><br>Number of errors logged by time |`TotalErrorsLoggedByTime` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Total Record Errors By Time**<br><br>Number of records errors by time |`TotalRecordErrorsByTime` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Total Record Failures By Time**<br><br>Number of record failures by time |`TotalRecordFailuresByTime` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Total Records Skipped By Time**<br><br>Number of records skipped by time |`TotalRecordsSkippedByTime` |Count |Total (Sum) |\<none\>|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
