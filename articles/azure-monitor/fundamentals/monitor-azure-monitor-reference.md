---
title: Monitoring data reference for Azure Monitor
description: This article contains important reference material you need when you monitor Azure Monitor.
ms.date: 09/16/2024
ms.custom: horz-monitor
ms.topic: reference
---

# Azure Monitor monitoring data reference

[!INCLUDE [horz-monitor-ref-intro](~/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-ref-intro.md)]

See [Monitor Azure Monitor](monitor-azure-monitor.md) for details on the data you can collect for Azure Monitor and how to use it.

<!-- ## Metrics. Required section. -->
[!INCLUDE [horz-monitor-ref-metrics-intro](~/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-ref-metrics-intro.md)]

<!-- Repeat the following section for each resource type/namespace in your service. For each ### section, replace the <ResourceType/namespace> placeholder, add the metrics-tableheader #include, and add the table #include.

To add the table #include, find the table(s) for the resource type in the Metrics column at https://review.learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-metrics/metrics-index?branch=main#supported-metrics-and-log-categories-by-resource-type, which is autogenerated from underlying systems. -->

### Supported metrics for Microsoft.Monitor/accounts
The following table lists the metrics available for the Microsoft.Monitor/accounts resource type.
[!INCLUDE [horz-monitor-ref-metrics-tableheader](~/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-ref-metrics-tableheader.md)]
[!INCLUDE [Microsoft.Monitor/accounts](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/metrics/microsoft-monitor-accounts-metrics-include.md)]


### Supported metrics for microsoft.insights/autoscalesettings
The following table lists the metrics available for the microsoft.insights/autoscalesettings resource type.
[!INCLUDE [horz-monitor-ref-metrics-tableheader](~/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-ref-metrics-tableheader.md)]
[!INCLUDE [microsoft.insights/autoscalesettings](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/metrics/microsoft-insights-autoscalesettings-metrics-include.md)]

### Supported metrics for microsoft.insights/components
The following table lists the metrics available for the microsoft.insights/components resource type.
[!INCLUDE [horz-monitor-ref-metrics-tableheader](~/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-ref-metrics-tableheader.md)]
[!INCLUDE [microsoft.insights/components](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/metrics/microsoft-insights-components-metrics-include.md)]

### Supported metrics for Microsoft.Insights/datacollectionrules
The following table lists the metrics available for the Microsoft.Insights/datacollectionrules resource type.
[!INCLUDE [horz-monitor-ref-metrics-tableheader](~/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-ref-metrics-tableheader.md)]
[!INCLUDE [Microsoft.Insights/datacollectionrules](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/metrics//microsoft-insights-datacollectionrules-metrics-include.md)]

### Supported metrics for Microsoft.operationalinsight/workspaces

Azure Monitor Logs / Log Analytics workspaces

[!INCLUDE [horz-monitor-ref-metrics-tableheader](~/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-ref-metrics-tableheader.md)]
[!INCLUDE [Microsoft.Insights/datacollectionrules](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/metrics/microsoft-operationalinsights-workspaces-metrics-include.md)] 

<!-- ## Metric dimensions. Required section. -->
[!INCLUDE [horz-monitor-ref-metrics-dimensions-intro](~/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-ref-metrics-dimensions-intro.md)]

[!INCLUDE [horz-monitor-ref-metrics-dimensions](~/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-ref-metrics-dimensions.md)]

Microsoft.Monitor/accounts:

- `Stamp color`

microsoft.insights/autoscalesettings:

- `MetricTriggerRule`
- `MetricTriggerSource`
- `ScaleDirection`

microsoft.insights/components:

- `availabilityResult/name`
- `availabilityResult/location`
- `availabilityResult/success`
- `dependency/type`
- `dependency/performanceBucket`
- `dependency/success`
- `dependency/target`
- `dependency/resultCode`
- `operation/synthetic`
- `cloud/roleInstance`
- `cloud/roleName`
- `client/isServer`
- `client/type`

Microsoft.Insights/datacollectionrules:

- `InputStreamId`
- `ResponseCode`
- `ErrorType`

[!INCLUDE [horz-monitor-ref-resource-logs](~/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-ref-resource-logs.md)]

### Supported resource logs for Microsoft.Monitor/accounts
[!INCLUDE [Microsoft.Monitor/accounts](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/logs/microsoft-monitor-accounts-logs-include.md)] 

### Supported resource logs for microsoft.insights/autoscalesettings
[!INCLUDE [microsoft.insights/autoscalesettings](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/logs/microsoft-insights-autoscalesettings-logs-include.md)]

### Supported resource logs for microsoft.insights/components
[!INCLUDE [microsoft.insights/components](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/logs/microsoft-insights-components-logs-include.md)]

### Supported resource logs for Microsoft.Insights/datacollectionrules
[!INCLUDE [Microsoft.Insights/datacollectionrules](~/reusable-content/ce-skilling/azure/includes/azure-monitor/reference/logs/microsoft-insights-datacollectionrules-logs-include.md)]

[!INCLUDE [horz-monitor-ref-logs-tables](~/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-ref-logs-tables.md)]

### Application Insights
microsoft.insights/components

- [AzureActivity](/azure/azure-monitor/reference/tables/AzureActivity#columns)
- [AzureMetrics](/azure/azure-monitor/reference/tables/AzureMetrics#columns)
- [AppAvailabilityResults](/azure/azure-monitor/reference/tables/AppAvailabilityResults#columns)
- [AppBrowserTimings](/azure/azure-monitor/reference/tables/AutoscaleScaleActionsLog#columns)
- [AppDependencies](/azure/azure-monitor/reference/tables/AppDependencies#columns)
- [AppEvents](/azure/azure-monitor/reference/tables/AppEvents#columns)
- [AppPageViews](/azure/azure-monitor/reference/tables/AppPageViews#columns)
- [AppPerformanceCounters](/azure/azure-monitor/reference/tables/AppPerformanceCounters#columns)
- [AppRequests](/azure/azure-monitor/reference/tables/AppRequests#columns)
- [AppSystemEvents](/azure/azure-monitor/reference/tables/AppSystemEvents#columns)
- [AppTraces](/azure/azure-monitor/reference/tables/AppTraces#columns)
- [AppExceptions](/azure/azure-monitor/reference/tables/AppExceptions#columns)

### Azure Monitor autoscale settings
Microsoft.Insights/AutoscaleSettings

- [AzureActivity](/azure/azure-monitor/reference/tables/AzureActivity#columns)
- [AzureMetrics](/azure/azure-monitor/reference/tables/AzureMetrics#columns)
- [AutoscaleEvaluationsLog](/azure/azure-monitor/reference/tables/AutoscaleEvaluationsLog#columns)
- [AutoscaleScaleActionsLog](/azure/azure-monitor/reference/tables/AutoscaleScaleActionsLog#columns)

### Azure Monitor Workspace
Microsoft.Monitor/accounts

- [AMWMetricsUsageDetails](/azure/azure-monitor/reference/tables/AMWMetricsUsageDetails#columns)

### Data Collection Rules
Microsoft.Insights/datacollectionrules

- [DCRLogErrors](/azure/azure-monitor/reference/tables/DCRLogErrors#columns)

### Workload Monitoring of Azure Monitor Insights
Microsoft.Insights/WorkloadMonitoring

- [InsightsMetrics](/azure/azure-monitor/reference/tables/InsightsMetrics#columns)

[!INCLUDE [horz-monitor-ref-activity-log](~/reusable-content/ce-skilling/azure/includes/azure-monitor/horizontals/horz-monitor-ref-activity-log.md)]
- [Monitor resource provider operations](/azure/role-based-access-control/resource-provider-operations#monitor)

## Related content

- See [Monitor Azure Monitor](monitor-azure-monitor.md) for a description of monitoring Azure Monitor.
- See [Monitor Azure resources with Azure Monitor](/azure/azure-monitor/essentials/monitor-azure-resource) for details on monitoring Azure resources.
