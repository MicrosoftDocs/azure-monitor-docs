---
title: Supported metrics - Microsoft.App/managedEnvironments
description: Reference for Microsoft.App/managedEnvironments metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.App/managedEnvironments, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.App/managedEnvironments

The following table lists the metrics available for the Microsoft.App/managedEnvironments resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.App/managedEnvironments](../supported-logs/microsoft-app-managedenvironments-logs.md)


### Category: Basic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Ingress CPU Usage Percentage (Preview)**<br><br>CPU consumed by the ingress pods as a percentage of the total CPU limit. |`IngressCpuPercentage` |Percent |Average, Maximum, Minimum |`podName`, `nodeName`|PT1M |Yes|
|**Ingress Memory Usage Percentage (Preview)**<br><br>Ingress memory usage as a percentage of the total memory limit. |`IngressMemoryPercentage` |Percent |Average, Maximum, Minimum |`podName`, `nodeName`|PT1M |Yes|
|**Ingress Memory Usage Bytes (Preview)**<br><br>Ingress pods usage memory in bytes. Represents the total memory consumed by a container |`IngressUsageBytes` |Bytes |Total (Sum), Average, Maximum, Minimum |`podName`, `nodeName`|PT1M |Yes|
|**Ingress CPU Usage (Preview)**<br><br>CPU consumed by the ingress pods in nano cores. 1,000,000,000 nano cores = 1 core |`IngressUsageNanoCores` |NanoCores |Total (Sum), Average, Maximum, Minimum |`podName`, `nodeName`|PT1M |Yes|
|**Cores Quota Limit (Deprecated)**<br><br>The cores quota limit of managed environment (Deprecated) |`EnvCoresQuotaLimit` |Count |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Percentage Cores Used Out Of Limit (Deprecated)**<br><br>The cores quota utilization of managed environment (Deprecated) |`EnvCoresQuotaUtilization` |Percent |Average, Maximum, Minimum |\<none\>|PT1M |Yes|
|**Workload Profile Node Count (Preview)**<br><br>The Node Count per workload profile |`NodeCount` |Count |Average, Total (Sum), Maximum, Minimum |`workloadProfileName`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
