---
title: Diagnostic settings in Azure Monitor
description: Learn about working with diagnostic settings for Azure Monitor platform metrics and logs.
ms.topic: article
ms.custom:
ms.date: 01/16/2025
ms.reviewer: lualderm
---

# Diagnostic settings in Azure Monitor

Diagnostic settings in Azure Monitor allow you to collect [resource logs](./resource-logs.md) and to send [platform metrics](./metrics-supported.md) and the [activity log](./activity-log.md) to different destinations. This article describes how to create and configure diagnostic settings.

## Overview
A diagnostic setting applies to a single Azure resource, such as a virtual machine, storage account, or SQL database. Create a separate diagnostic setting for each resource you want to collect data from. Each settings defines the sources of data to collect and the destinations to send that data to.

A single diagnostic setting can define no more than one of each of the destinations. If you want to send data to more than one of a particular destination type (for example, two different Log Analytics workspaces), create multiple settings. Each resource can have up to five diagnostic settings.

> [!WARNING]
> Delete any diagnostic settings for a resource if you delete or rename that resource, or migrate it across resource groups or subscriptions. If you recreate this resource, any diagnostic settings for the deleted resource could be applied to the new one. This resumes the collection of resource logs as defined in the diagnostic setting. 

> [!NOTE]
>
> Resource Logs aren't completely lossless. They're based on a store and forward architecture designed to affordably move petabytes of data per day at scale. This capability includes built-in redundancy and retries across the platform but doesn't provide transactional guarantees. Anytime a persistent source of data loss is identified, its resolution and future prevention is prioritized. Small data losses may still occur to temporary, non-repeating service issues distributed across Azure.

The following video walks through routing resource platform logs with diagnostic settings. The following changes were made to diagnostic settings since the video was recorded. These changes are described in this article.


> [!VIDEO https://learn-video.azurefd.net/vod/player?id=2e9e11cc-fc03-4caa-8fee-4386abf454bc]

## Sources

Diagnostic settings can collect data from the sources in the following table.

| Data source | Description |
|:---|:---|
| [Platform metrics](./metrics-supported.md) | Automatically collected without configuration. Use a diagnostic setting to sent platform metrics to other [destinations](#destinations). |
| [Activity log](./activity-log.md) | Automatically collected without configuration. Use a diagnostic setting to sent activity log entries to other [destinations](#destinations). |
| [Resource logs](./resource-logs.md) | Aren't collected by default. Create a diagnostic setting to collect resource logs. |

## Destinations

Diagnostic settings send data to the destinations in the following table.To ensure the security of data in transit, all destination endpoints are configured to support TLS 1.2.

| Destination | Description |
|:---|:---|
| [Log Analytics workspace](../logs/workspace-design.md) | Retrieve data using [log queries](../logs/log-query-overview.md) and [workbooks](../visualize/workbooks-overview.md). Use [log alerts](../alerts/alerts-types.md#log-search-alerts) to proactively alert on data. See [Azure Monitor Resource log reference](/azure/azure-monitor/reference/tables-index) for the tables used by different Azure resources. |
| [Azure Storage account](/azure/storage/blobs/) <sup>1</sup> | Store for audit, static analysis, or back up. Storage may be less expensive than other options and can be kept indefinitely.  | 
| [Azure Event Hubs](/azure/event-hubs/) | Stream data to external systems such as third-party SIEMs and other Log Analytics solutions.  |
| [Azure Monitor partner solutions](/azure/partner-solutions/partners#observability)| Specialized integrations can be made between Azure Monitor and other non-Microsoft monitoring platforms. The solutions vary by partner. Check the [Azure Native ISV Services documentation](/azure/partner-solutions/overview) for details.|

<sup>1</sup> The Retention Policy as set in the Diagnostic Setting settings is now deprecated and can no longer be used. Use the Azure Storage Lifecycle Policy to manage the length of time that your logs are retained. For more information, see [Migrate diagnostic settings storage retention to Azure Storage lifecycle management](migrate-to-azure-storage-lifecycle-policy.md).
   
## Category groups

> [!NOTE]
> Not all Azure services use category groups. If category groups aren't available for a particular resource, then the option won't be available when create the diagnostic setting. 

You can use *category groups* to collect resource logs based on predefined groupings instead of selecting individual log categories. Microsoft defines the groupings to help monitor common use cases. If the categories in the group are updated, your log collection is modified automatically. 

If you do use category groups in a diagnostic setting, you can't select individual category types. You also can't apply retention settings to any logs sent to Azure Storage.

Currently, there are two category groups:

- **allLogs**: all categories for the resource.
- **audit**: All resource logs that record customer interactions with data or the settings of the service. You don't need to select this category group if you select the **allLogs** category group.


> [!IMPORTANT]
> Enabling the Audit category in the diagnostic settings for Azure SQL Database does not activate auditing for the database. To enable database auditing, you have to enable it from the auditing blade for Azure Database. 



## Metrics limitations

Not all metrics can be sent to a Log Analytics workspace with diagnostic settings. See the **Exportable** column in the [list of supported metrics](./metrics-supported.md).

Diagnostic settings to not currently support multi-dimensional metrics. Metrics with dimensions are exported as flattened single-dimensional metrics and aggregated across dimension values. For example, the **IOReadBytes** metric on a blockchain can be explored and charted on a per-node level. When exported with diagnostic settings, the metric exported shows all read bytes for all nodes.

To work around the limitations for specific metrics, you can manually extract them by using the [Metrics REST API](/rest/api/monitor/metrics/list) and then import them into a Log Analytics workspace with the [Logs ingestion API](../logs/logs-ingestion-api-overview.md).




 

## Controlling costs

There's a cost for collecting data in a Log Analytics workspace, so only collect the categories you require for each service. The data volume for resource logs varies significantly between services. 

You might also not want to collect platform metrics from Azure resources because this data is already being collected in Metrics. Only configure your diagnostic data to collect metrics if you need metric data in the workspace for more complex analysis with log queries. Diagnostic settings don't allow granular filtering of resource logs.


## Next steps

- [Create diagnostic settings for Azure Monitor platform metrics and logs](./create-diagnostic-settings.md)
- [Migrate diagnostic settings storage retention to Azure Storage lifecycle management](./migrate-to-azure-storage-lifecycle-policy.md)
- [Read more about Azure platform logs](./platform-logs-overview.md)