---
title: Supported metrics - Microsoft.Logic/IntegrationServiceEnvironments
description: Reference for Microsoft.Logic/IntegrationServiceEnvironments metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: Microsoft.Logic/IntegrationServiceEnvironments, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Logic/IntegrationServiceEnvironments

The following table lists the metrics available for the Microsoft.Logic/IntegrationServiceEnvironments resource type.

**Table headings**

- **Metric** - The metric display name as it appears in the Azure portal.
- **Name in Rest API** - Metric name as referred to in the [REST API](/azure/azure-monitor/essentials/rest-api-walkthrough).
- **Advanced platform metrics** - A premium, [paid tier of platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform) in Azure Monitor that provide more granular observability for Azure resources.
- **Unit** - Unit of measure.
- **Aggregation** - The default [aggregation](/azure/azure-monitor/essentials/metrics-aggregation-explained) type. Valid values: Average, Minimum, Maximum, Total, Count.
- **Dimensions** - [Dimensions](/azure/azure-monitor/essentials/metrics-aggregation-explained#dimensions-splitting-and-filtering) available for the metric.
- **Time Grains** - [Intervals at which the metric is sampled](/azure/azure-monitor/essentials/metrics-aggregation-explained#granularity). For example, `PT1M` indicates that the metric is sampled every minute, `PT30M` every 30 minutes, `PT1H` every hour, and so on.
- **DS Export** -S Whether the metric is exportable to Azure Monitor Logs via Diagnostic Settings.

For information on exporting metrics, see - [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics) and [Create diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/create-diagnostic-settings?tabs=portal).

For information on metric retention, see [Azure Monitor Metrics overview](/azure/azure-monitor/essentials/data-platform-metrics#retention-of-metrics).



|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Action Latency**<br><br>Latency of completed workflow actions. |`ActionLatency` | No | Seconds |Average |\<none\>|PT1M |Yes|
|**Actions Completed**<br><br>Number of workflow actions completed. |`ActionsCompleted` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Actions Failed**<br><br>Number of workflow actions failed. |`ActionsFailed` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Actions Skipped**<br><br>Number of workflow actions skipped. |`ActionsSkipped` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Actions Started**<br><br>Number of workflow actions started. |`ActionsStarted` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Actions Succeeded**<br><br>Number of workflow actions succeeded. |`ActionsSucceeded` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Action Success Latency**<br><br>Latency of succeeded workflow actions. |`ActionSuccessLatency` | No | Seconds |Average |\<none\>|PT1M |Yes|
|**Connector Memory Usage for Integration Service Environment**<br><br>Connector memory usage for integration service environment. |`IntegrationServiceEnvironmentConnectorMemoryUsage` | No | Percent |Average |\<none\>|PT1M |Yes|
|**Connector Processor Usage for Integration Service Environment**<br><br>Connector processor usage for integration service environment. |`IntegrationServiceEnvironmentConnectorProcessorUsage` | No | Percent |Average |\<none\>|PT1M |Yes|
|**Workflow Memory Usage for Integration Service Environment**<br><br>Workflow memory usage for integration service environment. |`IntegrationServiceEnvironmentWorkflowMemoryUsage` | No | Percent |Average |\<none\>|PT1M |Yes|
|**Workflow Processor Usage for Integration Service Environment**<br><br>Workflow processor usage for integration service environment. |`IntegrationServiceEnvironmentWorkflowProcessorUsage` | No | Percent |Average |\<none\>|PT1M |Yes|
|**Run Latency**<br><br>Latency of completed workflow runs. |`RunLatency` | No | Seconds |Average |\<none\>|PT1M |Yes|
|**Runs Cancelled**<br><br>Number of workflow runs cancelled. |`RunsCancelled` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Runs Completed**<br><br>Number of workflow runs completed. |`RunsCompleted` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Runs Failed**<br><br>Number of workflow runs failed. |`RunsFailed` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Runs Started**<br><br>Number of workflow runs started. |`RunsStarted` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Runs Succeeded**<br><br>Number of workflow runs succeeded. |`RunsSucceeded` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Run Success Latency**<br><br>Latency of succeeded workflow runs. |`RunSuccessLatency` | No | Seconds |Average |\<none\>|PT1M |Yes|
|**Trigger Fire Latency**<br><br>Latency of fired workflow triggers. |`TriggerFireLatency` | No | Seconds |Average |\<none\>|PT1M |Yes|
|**Trigger Latency**<br><br>Latency of completed workflow triggers. |`TriggerLatency` | No | Seconds |Average |\<none\>|PT1M |Yes|
|**Triggers Completed**<br><br>Number of workflow triggers completed. |`TriggersCompleted` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Triggers Failed**<br><br>Number of workflow triggers failed. |`TriggersFailed` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Triggers Fired**<br><br>Number of workflow triggers fired. |`TriggersFired` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Triggers Skipped**<br><br>Number of workflow triggers skipped. |`TriggersSkipped` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Triggers Started**<br><br>Number of workflow triggers started. |`TriggersStarted` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Triggers Succeeded**<br><br>Number of workflow triggers succeeded. |`TriggersSucceeded` | No | Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Trigger Success Latency**<br><br>Latency of succeeded workflow triggers. |`TriggerSuccessLatency` | No | Seconds |Average |\<none\>|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
