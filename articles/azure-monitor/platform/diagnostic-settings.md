---
title: Diagnostic settings in Azure Monitor
description: Learn about working with diagnostic settings for Azure Monitor platform metrics and logs.
ms.topic: article
ms.custom:
ms.date: 01/16/2025
ms.reviewer: lualderm
---

# Diagnostic settings in Azure Monitor

Diagnostic settings in Azure Monitor allow you to collect [resource logs](./resource-logs.md) and to send [platform metrics](./metrics-supported.md) and the [activity log](./activity-log.md) to different destinations. Create a separate diagnostic setting for each resource you want to collect data from. Each setting defines the data from the resource to collect and the destinations to send that data to.

The following video walks through routing resource platform logs with diagnostic settings. The following changes were made to diagnostic settings since the video was recorded. 

- [Azure Monitor partners](#destinations)
- [Category groups](#category-groups)


> [!VIDEO https://learn-video.azurefd.net/vod/player?id=2e9e11cc-fc03-4caa-8fee-4386abf454bc]


## Prerequisites


- Any destinations used by the diagnostic setting must exist before the setting can be created. The destination doesn't have to be in the same subscription as the resource sending logs if the user who configures the setting has appropriate Azure role-based access control access to both subscriptions. Use Azure Lighthouse to include destinations in another Microsoft Entra tenant. 
- See [Destinations](#destinations) for details on the requirements for each destination type.




## Sources

Diagnostic settings can collect data from the sources in the following table.

| Data source | Description |
|:---|:---|
| [Platform metrics](./metrics-supported.md) | Automatically collected without configuration. Use a diagnostic setting to sent platform metrics to other [destinations](#destinations). |
| [Activity log](./activity-log.md) | Automatically collected without configuration. Use a diagnostic setting to sent activity log entries to other [destinations](#destinations). |
| [Resource logs](./resource-logs.md) | Aren't collected by default. Create a diagnostic setting to collect resource logs. |

## Destinations

Diagnostic settings send data to the destinations in the following table.To ensure the security of data in transit, all destination endpoints are configured to support TLS 1.2. A single diagnostic setting can define no more than one of each of the destinations. If you want to send data to more than one of a particular destination type (for example, two different Log Analytics workspaces), create multiple settings. Each resource can have up to five diagnostic settings.

| Destination | Description | Requirements |
|:---|:---|:---|
| [Log Analytics workspace](../logs/workspace-design.md) | Retrieve data using [log queries](../logs/log-query-overview.md) and [workbooks](../visualize/workbooks-overview.md). Use [log alerts](../alerts/alerts-types.md#log-search-alerts) to proactively alert on data. See [Azure Monitor Resource log reference](/azure/azure-monitor/reference/tables-index) for the tables used by different Azure resources. | Any tables in a Log Analytics workspace are created automatically when the first data is sent to the workspace, so only the workspace itself must exist. |
| [Azure Storage account](/azure/storage/blobs/) | Store for audit, static analysis, or back up. Storage may be less expensive than other options and can be kept indefinitely. Send data to immutable storage to prevent its modification. Set the immutable policy for the storage account as described in [Set and manage immutability policies for Azure Blob Storage](/azure/storage/blobs/immutable-policy-configure-version-scope). | Storage accounts must be in the same region as the resource being monitored if the resource is regional. [Azure DNS zone endpoints (preview)](/azure/storage/common/storage-account-overview#azure-dns-zone-endpoints-preview) and any [Premium storage accounts](/azure/storage/common/storage-account-overview#types-of-storage-accounts) aren't supported as a destination. Any [Standard storage accounts](/azure/storage/common/storage-account-overview#types-of-storage-accounts) are supported.  | 
| [Azure Event Hubs](/azure/event-hubs/) | Stream data to external systems such as third-party SIEMs and other Log Analytics solutions. | Event hubs must to be in the same region as the resource being monitored if the resource is regional. The shared access policy for event hub namespace defines the permissions that the streaming mechanism has. Streaming to Event Hubs requires `Manage`, `Send`, and `Listen` permissions. To update the diagnostic setting to include streaming, you must have the `ListKey` permission on that Event Hubs authorization rule. |
| [Azure Monitor partner solutions](/azure/partner-solutions/partners#observability)| Specialized integrations can be made between Azure Monitor and other non-Microsoft monitoring platforms. The solutions vary by partner. | See [Azure Native ISV Services documentation](/azure/partner-solutions/overview) for details.|


- Diagnostic settings can't access storage accounts or event hubs when virtual networks are enabled. Enable **Allow trusted Microsoft services** to bypass this firewall setting in storage accounts and event hubs.



   
## Category groups

You can use *category groups* to collect resource logs based on predefined groupings instead of selecting individual log categories. Microsoft defines the groupings to help monitor common use cases. If the categories in the group are updated, your log collection is modified automatically. 

If you do use category groups in a diagnostic setting, you can't select individual category types. You also can't apply retention settings to any logs sent to Azure Storage.

Currently, there are two category groups:

- **allLogs**: all categories for the resource.
- **audit**: All resource logs that record customer interactions with data or the settings of the service. You don't need to select this category group if you select the **allLogs** category group.


> [!NOTE]
> - Not all Azure services use category groups. If category groups aren't available for a particular resource, then the option won't be available when create the diagnostic setting. 
> - Enabling the Audit category in the diagnostic settings for Azure SQL Database does not activate auditing for the database. To enable database auditing, you have to enable it from the auditing blade for Azure Database. 




> [!NOTE]
>
> Resource Logs aren't completely lossless. They're based on a store and forward architecture designed to affordably move petabytes of data per day at scale. This capability includes built-in redundancy and retries across the platform but doesn't provide transactional guarantees. Anytime a persistent source of data loss is identified, its resolution and future prevention is prioritized. Small data losses may still occur to temporary, non-repeating service issues distributed across Azure.


## Metrics limitations

Not all metrics can be sent to a Log Analytics workspace with diagnostic settings. See the **Exportable** column in the [list of supported metrics](./metrics-supported.md).

Diagnostic settings don't currently support multi-dimensional metrics. Metrics with dimensions are exported as flattened single-dimensional metrics and aggregated across dimension values. For example, the **IOReadBytes** metric on a blockchain can be explored and charted on a per-node level. When exported with diagnostic settings, the metric exported shows all read bytes for all nodes.

To work around the limitations for specific metrics, you can manually extract them by using the [Metrics REST API](/rest/api/monitor/metrics/list) and then import them into a Log Analytics workspace with the [Logs ingestion API](../logs/logs-ingestion-api-overview.md).



## Controlling costs

There's a cost for collecting data in a Log Analytics workspace, so only collect the categories you require for each service. The data volume for resource logs varies significantly between services. 

You might also not want to collect platform metrics from Azure resources because this data is already being collected in Metrics. Only configure your diagnostic data to collect metrics if you need metric data in the workspace for more complex analysis with log queries. Diagnostic settings don't allow granular filtering of resource logs.

## Deleting diagnostic settings
Delete any diagnostic settings for a resource if you delete or rename that resource, or migrate it across resource groups or subscriptions. If you recreate this resource, any diagnostic settings for the deleted resource could be applied to the new one. This resumes the collection of resource logs as defined in the diagnostic setting. 

## Next steps

- [Create diagnostic settings for Azure Monitor platform metrics and logs](./create-diagnostic-settings.md)
- [Migrate diagnostic settings storage retention to Azure Storage lifecycle management](./migrate-to-azure-storage-lifecycle-policy.md)
- [Read more about Azure platform logs](./platform-logs-overview.md)