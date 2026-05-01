---
title: Supported metrics - Microsoft.Insights/datacollectionrules
description: Reference for Microsoft.Insights/datacollectionrules metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Insights/datacollectionrules, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Insights/datacollectionrules

The following table lists the metrics available for the Microsoft.Insights/datacollectionrules resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.Insights/datacollectionrules](../supported-logs/microsoft-insights-datacollectionrules-logs.md)


|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Logs Ingestion Requests per Min**<br><br>Number of requests received via Log Ingestion API or from the agent |`ApiCallReceived_Count` |Count |Count |`InputStreamId`, `ResponseCode`|PT1M |Yes|
|**Logs Ingestion Bytes per Min**<br><br>Number of bytes received via Log Ingestion API or from the agent |`BytesReceived_Count` |Bytes |Total (Sum), Average, Minimum, Maximum |`InputStreamId`|PT1M |Yes|
|**Metrics Ingestion Requests per Min**<br><br>The number of requests made to the Data Collection Endpoint to submit metrics |`MetricIngestionRequest_Count` |Count |Total (Sum), Average, Minimum, Maximum |`InputStreamId`, `ResponseCode`|PT1M |No|
|**Logs Rows Dropped per Min**<br><br>Number of rows dropped while running transformation. |`RowsDropped_Count` |Count |Total (Sum), Average, Minimum, Maximum |`InputStreamId`|PT1M |Yes|
|**Logs Rows Received per Min**<br><br>Total number of rows recevied for transformation. |`RowsReceived_Count` |Count |Total (Sum), Average, Minimum, Maximum |`InputStreamId`|PT1M |Yes|
|**Logs Transform Errors per Min**<br><br>The number of times when execution of KQL transformation resulted in an error, e.g. KQL syntax error or going over a service limit. |`TransformationErrors_Count` |Count |Count |`InputStreamId`, `ErrorType`|PT1M |Yes|
|**Logs Transform Duration per Min**<br><br>Total time taken to transform given set of records, measured in milliseconds. |`TransformationRuntime_DurationMs` |MilliSeconds |Average, Minimum, Maximum |`InputStreamId`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
