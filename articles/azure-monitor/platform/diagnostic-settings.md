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

- You can now also send platform metrics and logs to certain Azure Monitor partners.
- A new feature called category groups was introduced in November 2021.

> [!VIDEO https://learn-video.azurefd.net/vod/player?id=2e9e11cc-fc03-4caa-8fee-4386abf454bc]

## Sources

There are three data sources collected by diagnostic settings:

- [Platform metrics](./metrics-supported.md) are automatically sent to [Azure Monitor Metrics](./data-platform-metrics.md) without configuration. Use a diagnostic setting to sent platform metrics to other [destinations](#destinations). Send them to a Log Analytics workspace to analyze them with related log data.
- The [Activity log](./activity-log.md) are automatically collected without configuration. Use a diagnostic setting to sent activity log entries to other [destinations](#destinations).
- [Resource logs](./resource-logs.md) aren't collected by default. Create a diagnostic setting to collect resource logs.
   
### Category groups in resource logs

> [!NOTE]
> Not all Azure services use category groups. If category groups aren't available for a particular resource, then the option won't be available when create the diagnostic setting. 

You can use *category groups* to collect resource logs based on predefined groupings instead of selecting individual log categories. Microsoft defines the groupings to help monitor common use cases. If the categories in the group are updated, your log collection is modified automatically. 

If you do use category groups in a diagnostic setting, you can't select individual category types. You also can't apply retention settings to any logs sent to Azure Storage.

Currently, there are two category groups:

- **allLogs**: all categories for the resource.
- **audit**: All resource logs that record customer interactions with data or the settings of the service. You don't need to select this category group if you select the **allLogs** category group.

The following image shows the logs category groups on the **Add diagnostics settings** page.

:::image type="content" source="./media/diagnostic-settings/audit-category-group.png" alt-text="A screenshot showing the logs category groups."::: 

> [!IMPORTANT]
> Enabling the Audit category in the diagnostic settings for Azure SQL Database does not activate auditing for the database. To enable database auditing, you have to enable it from the auditing blade for Azure Database. 


## Destinations

Diagnostic settings can send data to one or more of the following destinations. To ensure the security of data in transit, all destination endpoints are configured to support TLS 1.2.

| Destination | Description |
|:---|:---|
| [Log Analytics workspace](../logs/workspace-design.md) | Retrieve data using [log queries](../logs/log-query-overview.md) and [workbooks](../visualize/workbooks-overview.md). Use [log alerts](../alerts/alerts-types.md#log-search-alerts) to proactively alert on data. See [Azure Monitor Resource log reference](/azure/azure-monitor/reference/tables-index) for the tables used by different Azure resources. |
| [Azure Storage account](/azure/storage/blobs/) | Store for audit, static analysis, or back up. Storage may be less expensive than other options and can be kept indefinitely.  | 
| [Azure Event Hubs](/azure/event-hubs/) | Stream data to external systems such as third-party SIEMs and other Log Analytics solutions.  |
| [Azure Monitor partner solutions](/azure/partner-solutions/partners#observability)| Specialized integrations can be made between Azure Monitor and other non-Microsoft monitoring platforms.  |

> [!IMPORTANT]
>The Retention Policy as set in the Diagnostic Setting settings is now deprecated and can no longer be used. Use the Azure Storage Lifecycle Policy to manage the length of time that your logs are retained. For more information, see [Migrate diagnostic settings storage retention to Azure Storage lifecycle management](migrate-to-azure-storage-lifecycle-policy.md).

## Requirements and limitations

This section discusses requirements and limitations.

### Time before telemetry gets to destination
Data should start arriving at the destinations within 90 minutes after a diagnostic setting has been created. 


When sending logs to a Log Analytics workspace, the table is created automatically if it doesn't already exist. The table is only created when the first log records are received. If you get no information within 24 hours, then you might be experiencing one of the following issues:

- No logs are being generated.
- Something is wrong in the underlying routing mechanism.

If you're experiencing an issue, you can try disabling the configuration and then reenabling it. Contact Azure support through the Azure portal if you continue to have issues. 

### Metrics as a source

There are certain limitations with exporting metrics:

- **Sending multi-dimensional metrics via diagnostic settings isn't currently supported**. Metrics with dimensions are exported as flattened single-dimensional metrics, aggregated across dimension values. For example, the **IOReadBytes** metric on a blockchain can be explored and charted on a per-node level. However, when exported via diagnostic settings, the metric exported shows all read bytes for all nodes.
- **Not all metrics are exportable with diagnostic settings**. Because of internal limitations, not all metrics are exportable to Azure Monitor Logs or Log Analytics. For more information, see the **Exportable** column in the [list of supported metrics](./metrics-supported.md).

To get around these limitations for specific metrics, you can manually extract them by using the [Metrics REST API](/rest/api/monitor/metrics/list). Then you can import them into Azure Monitor Logs by using the [Azure Monitor Data Collector API](../logs/data-collector-api.md).

> [!IMPORTANT]
> Diagnostic settings don't support resourceIDs with non-ASCII characters (for example, Preproduccón). For more information, see [Troubleshooting](#setting-disappears-due-to-non-ascii-characters-in-resourceid).

### Destination limitations

Any destinations for the diagnostic setting must be created before you create the diagnostic settings. The destination doesn't have to be in the same subscription as the resource sending logs if the user who configures the setting has appropriate Azure role-based access control access to both subscriptions. By using Azure Lighthouse, it's also possible to have diagnostic settings sent to a workspace, storage account, or event hub in another Microsoft Entra tenant.

The following table provides unique requirements for each destination including any regional restrictions.

| Destination | Requirements |
|:---|:---|
| Log Analytics workspace | The workspace doesn't need to be in the same region as the resource being monitored.|
| Storage account | Don't use an existing storage account that has other, nonmonitoring data stored in it. Splitting the types of data up allow you better control access to the data. If you're archiving the activity log and resource logs together, you might choose to use the same storage account to keep all monitoring data in a central location.<br><br>To prevent modification of the data, send it to immutable storage. Set the immutable policy for the storage account as described in [Set and manage immutability policies for Azure Blob Storage](/azure/storage/blobs/immutable-policy-configure-version-scope). You must follow all steps in this linked article including enabling protected append blobs writes.<br><br>The storage account needs to be in the same region as the resource being monitored if the resource is regional.<br><br> Diagnostic settings can't access storage accounts when virtual networks are enabled. You must enable **Allow trusted Microsoft services** to bypass this firewall setting in storage accounts so that the Azure Monitor diagnostic settings service is granted access to your storage account.<br><br>[Azure DNS zone endpoints (preview)](/azure/storage/common/storage-account-overview#azure-dns-zone-endpoints-preview) and any [Premium storage accounts](/azure/storage/common/storage-account-overview#types-of-storage-accounts) aren't supported as a log or metric destination. Any [Standard storage accounts](/azure/storage/common/storage-account-overview#types-of-storage-accounts) are supported. |
| Event Hubs | The shared access policy for the namespace defines the permissions that the streaming mechanism has. Streaming to Event Hubs requires Manage, Send, and Listen permissions. To update the diagnostic setting to include streaming, you must have the ListKey permission on that Event Hubs authorization rule.<br><br>The event hub namespace needs to be in the same region as the resource being monitored if the resource is regional. <br><br> Diagnostic settings can't access Event Hubs resources when virtual networks are enabled. You must enable **Allow trusted Microsoft services** to bypass this firewall setting in Event Hubs so that the Azure Monitor diagnostic settings service is granted access to your Event Hubs resources.|
| Partner solutions | The solutions vary by partner. Check the [Azure Native ISV Services documentation](/azure/partner-solutions/overview) for details.|

### Diagnostic logs for Application Insights

If you want to store diagnostic logs for Application Insights in a Log Analytics workspace, don't send the logs to the same workspace that the Application Insights resource is based on. This configuration can cause duplicate telemetry to be displayed because Application Insights is already storing this data. Send your Application Insights logs to a different Log Analytics workspace.

When sending Application Insights logs to a different workspace, be aware that Application Insights accesses telemetry across Application Insight resources, including multiple Log Analytics workspaces. Restrict the Application Insights user's access to only the Log Analytics workspace linked with the Application Insights resource. Set the access control mode to **Requires workspace permissions** and manage permissions through Azure role-based access control to ensure that Application Insights only has access to the Log Analytics workspace that the Application Insights resource is based on.

 

## Controlling costs

There's a cost for collecting data in a Log Analytics workspace, so only collect the categories you require for each service. The data volume for resource logs varies significantly between services. 

You might also not want to collect platform metrics from Azure resources because this data is already being collected in Metrics. Only configure your diagnostic data to collect metrics if you need metric data in the workspace for more complex analysis with log queries. Diagnostic settings don't allow granular filtering of resource logs.

[!INCLUDE [azure-monitor-cost-optimization](../fundamentals/includes/azure-monitor-cost-optimization.md)]

[!INCLUDE [diagnostics-settings-troubleshooting](includes/diagnostics-settings-troubleshooting.md)]

## Next steps

- [Create diagnostic settings for Azure Monitor platform metrics and logs](./create-diagnostic-settings.md)
- [Migrate diagnostic settings storage retention to Azure Storage lifecycle management](./migrate-to-azure-storage-lifecycle-policy.md)
- [Read more about Azure platform logs](./platform-logs-overview.md)