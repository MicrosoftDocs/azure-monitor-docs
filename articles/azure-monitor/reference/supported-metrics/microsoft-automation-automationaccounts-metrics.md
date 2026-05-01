---
title: Supported metrics - Microsoft.Automation/automationAccounts
description: Reference for Microsoft.Automation/automationAccounts metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Automation/automationAccounts, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Automation/automationAccounts

The following table lists the metrics available for the Microsoft.Automation/automationAccounts resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.Automation/automationAccounts](../supported-logs/microsoft-automation-automationaccounts-logs.md)


|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Hybrid Worker Ping**<br><br>The number of pings from the hybrid worker |`HybridWorkerPing` |Count |Total (Sum), Average, Maximum, Minimum, Count |`HybridWorkerGroup`, `HybridWorker`, `HybridWorkerVersion`|PT1M |Yes|
|**Total Jobs**<br><br>The total number of jobs |`TotalJob` |Count |Total (Sum), Average, Maximum, Minimum, Count |`Runbook`, `Status`|PT1M |Yes|
|**Total Update Deployment Machine Runs**<br><br>Total software update deployment machine runs in a software update deployment run |`TotalUpdateDeploymentMachineRuns` |Count |Total (Sum), Average, Maximum, Minimum, Count |`Status`, `TargetComputer`, `SoftwareUpdateConfigurationName`, `SoftwareUpdateConfigurationRunId`|PT1M |Yes|
|**Total Update Deployment Runs**<br><br>Total software update deployment runs |`TotalUpdateDeploymentRuns` |Count |Total (Sum), Average, Maximum, Minimum, Count |`Status`, `SoftwareUpdateConfigurationName`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
