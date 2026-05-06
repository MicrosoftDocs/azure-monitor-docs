---
title: Supported metrics - Microsoft.HealthcareApis/workspaces/dicomservices
description: Reference for Microsoft.HealthcareApis/workspaces/dicomservices metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 10/31/2025
ms.custom: Microsoft.HealthcareApis/workspaces/dicomservices, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.HealthcareApis/workspaces/dicomservices

The following table lists the metrics available for the Microsoft.HealthcareApis/workspaces/dicomservices resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.HealthcareApis/workspaces/dicomservices](../supported-logs/microsoft-healthcareapis-workspaces-dicomservices-logs.md)


### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Number of DICOM files processed by import**<br><br>The total number of DICOM files processed by an import. |`ImportsProcessed` |Count |Total (Sum) |`Status`, `ResourceName`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
