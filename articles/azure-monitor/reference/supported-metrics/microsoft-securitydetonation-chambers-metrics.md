---
title: Supported metrics - microsoft.securitydetonation/chambers
description: Reference for microsoft.securitydetonation/chambers metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: microsoft.securitydetonation/chambers, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for microsoft.securitydetonation/chambers

The following table lists the metrics available for the microsoft.securitydetonation/chambers resource type.

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



### Category: Latency
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Submission Duration**<br><br>The submission duration (processing time), from creation to completion. |`SubmissionDuration` |MilliSeconds |Maximum, Minimum |`Region`|PT1M |No|

### Category: Saturation
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Capacity Utilization**<br><br>The percentage of the allocated capacity the resource is actively using. |`CapacityUtilization` |Percent |Maximum, Minimum |`Region`|PT1M |No|
|**CPU Utilization**<br><br>The percentage of the CPU that is being utilized across the resource. |`CpuUtilization` |Percent |Average, Maximum, Minimum |`Region`|PT1M |No|
|**Available Disk Space**<br><br>The percent amount of available disk space across the resource. |`PercentFreeDiskSpace` |Percent |Average, Maximum, Minimum |`Region`|PT1M |No|
|**Outstanding Submissions**<br><br>The average number of outstanding submissions that are queued for processing. |`SubmissionsOutstanding` |Count |Average, Maximum, Minimum |`Region`|PT1M |No|

### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**CreateSubmission Api Results**<br><br>The total number of CreateSubmission API requests, with return code. |`CreateSubmissionApiResult` |Count |Count |`OperationName`, `ServiceTypeName`, `Region`, `HttpReturnCode`|PT1M |No|
|**Completed Submissions / Hr**<br><br>The number of completed submissions / Hr. |`SubmissionsCompleted` |Count |Maximum, Minimum |`Region`|PT1M |No|
|**Failed Submissions / Hr**<br><br>The number of failed submissions / Hr. |`SubmissionsFailed` |Count |Maximum, Minimum |`Region`|PT1M |No|
|**Successful Submissions / Hr**<br><br>The number of successful submissions / Hr. |`SubmissionsSucceeded` |Count |Maximum, Minimum |`Region`|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
