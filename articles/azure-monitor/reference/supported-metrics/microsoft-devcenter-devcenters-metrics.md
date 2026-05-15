---
title: Supported metrics - Microsoft.DevCenter/devcenters
description: Reference for Microsoft.DevCenter/devcenters metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.DevCenter/devcenters, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.DevCenter/devcenters

The following table lists the metrics available for the Microsoft.DevCenter/devcenters resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.DevCenter/devcenters](../supported-logs/microsoft-devcenter-devcenters-logs.md)


### Category: Connections
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Successful connect**<br><br>Count of devbox connections. |`DevBoxConnect` |Count |Count |`ProjectId`|PT1M |Yes|

### Category: DevBox Creations
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Failed creations**<br><br>Count of dev boxes which failed to create. |`DevBoxCreationFailed` |Count |Count |`ProjectId`, `ErrorCode`|PT1M |Yes|
|**Successful creations**<br><br>Count of dev boxes which were created successfully. |`DevBoxCreationSucceeded` |Count |Count |`ProjectId`|PT1M |Yes|

### Category: Devbox Deallocate
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Successful deallocate**<br><br>Count of devbox which succeeded to deallocate. |`DevBoxDeallocateSucceeded` |Count |Count |`ProjectId`|PT1M |Yes|

### Category: DevBox Definition Creations
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Failed creations**<br><br>Count of failed dev box definitions which can be filtered by error code. |`DevBoxDefinitionCreationFailed` |Count |Count |`ErrorDetails`|PT1M |Yes|

### Category: Devbox Hibernate
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Failed hibernates**<br><br>Count of devbox which failed to hibernate. |`DevBoxHibernateFailed` |Count |Count |`ProjectId`|PT1M |Yes|
|**Successful hibernates**<br><br>Count of devbox which succeeded to hibernate. |`DevBoxHibernateSucceeded` |Count |Count |`ProjectId`|PT1M |Yes|

### Category: Devbox Start
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Failed starts**<br><br>Count of devbox which failed to start. |`DevBoxStartFailed` |Count |Count |`ProjectId`|PT1M |Yes|
|**Successful starts**<br><br>Count of devbox which succeeded to start. |`DevBoxStartSucceeded` |Count |Count |`ProjectId`|PT1M |Yes|

### Category: Devbox Stop
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Failed stops**<br><br>Count of devbox which failed to start. |`DevBoxStopFailed` |Count |Count |`ProjectId`|PT1M |Yes|
|**Successful stops**<br><br>Count of devbox which succeeded to start. |`DevBoxStopSucceeded` |Count |Count |`ProjectId`|PT1M |Yes|

### Category: DevCenter Creations
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Failed creations**<br><br>Count of devcenters which failed to create. |`DevCenterCreationFailed` |Count |Count |`ErrorCode`|PT1M |Yes|
|**Successful creations**<br><br>Count of devcenters which succeeded to create. |`DevCenterCreationSucceeded` |Count |Count |\<none\>|PT1M |Yes|

### Category: DevCenter Deletions
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Failed deletions**<br><br>Count of devcenters which failed to delete. |`DevCenterDeletionFailed` |Count |Count |`ErrorCode`|PT1M |Yes|
|**Successful deletions**<br><br>Count of devcenters which succeeded to delete. |`DevCenterDeletionSucceeded` |Count |Count |\<none\>|PT1M |Yes|

### Category: DevCenter Updates
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Failed updates**<br><br>Count of devcenters which failed to update. |`DevCenterUpdateFailed` |Count |Count |`ErrorCode`|PT1M |Yes|
|**Successful updates**<br><br>Count of devcenters which succeeded to update. |`DevCenterUpdateSucceeded` |Count |Count |\<none\>|PT1M |Yes|

### Category: Disconnections
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Successful disconnect**<br><br>Count of devbox disconnections. |`DevBoxDisconnect` |Count |Count |`ProjectId`|PT1M |Yes|

### Category: NetworkConnection Health Check
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Health Check**<br><br>Count of NetworkConnection health check. |`NetworkConnectionHealthCheck` |Count |Count |\<none\>|PT1M |Yes|

### Category: Performance
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Image Validation Duration**<br><br>Time taken for validating created device images. |`ImageValidationDuration` |Seconds |Average, Maximum, Minimum |\<none\>|PT1M |Yes|

### Category: Pool Creates or Updates
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Pool create**<br><br>Count of pools that have been succesffuly created. |`PoolCreatedOrUpdated` |Count |Count |`ProjectId`, `DevBoxDefinitionName`, `PoolHibernateEnabled`|PT1M |Yes|

### Category: Project Creations
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Successful creations**<br><br>Count of projects that were created successfully. |`ProjectCreated` |Count |Count |\<none\>|PT1M |Yes|

### Category: Project Deletions
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Successful deletions**<br><br>Count of projects that were deleted successfully. |`ProjectDeleted` |Count |Count |\<none\>|PT1M |Yes|

### Category: Schedule Creates or Updates
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Failed creates or updates**<br><br>Count of schedules which failed to create or update. |`ScheduleCreatedOrUpdatedFailed` |Count |Count |`ErrorCode`|PT1M |Yes|
|**Successful creates or updates**<br><br>Count of schedules which succeeded to create or update. |`ScheduleCreatedOrUpdatedSucceeded` |Count |Count |\<none\>|PT1M |Yes|

### Category: Schedule Deletions
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Successful deletion**<br><br>Count of schedules that were successfully deleted. |`ScheduleDeletionSucceeded` |Count |Count |\<none\>|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
