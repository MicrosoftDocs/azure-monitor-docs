---
title: Azure Monitor REST API index
description: Lists the operation groups for the Azure Monitor REST API, which includes Application Insights, Log Analytics, and Monitor.
ms.date: 04/29/2026
ms.topic: reference
---

# Azure Monitor REST API index

Azure Monitor has a wide assortment of APIs. This index separates them into three primary sections, Azure Monitor, Application Insights, and Azure Monitor Logs.

> [!NOTE]
> The Azure Monitor section does include the managed service *Managed Prometheus*, but other managed services such as *Azure Managed Grafana* and *Azure Monitor SCOM Managed Instance* use their own REST APIs and aren't included in this index.
>
> For more information, see [Azure Managed Grafana REST API Reference](/rest/api/managed-grafana/) and [System Center Operations Manager REST API Reference](/rest/operationsmanager/).

## Azure Monitor APIs

These APIs are part of the Azure Resource Manager (ARM) control plane APIs for various Azure Monitor features. See the [Azure Monitor section](/rest/api/monitor/) of the Azure REST APIs documentation to find the latest API versions for these operation groups.

The endpoints for all of these Azure Monitor ARM APIs are under the `https://management.azure.com/` base URL, which is the standard endpoint for ARM APIs.

### Activity log

These Azure Monitor APIs retrieve and manage activity logs.

| Operation groups | Description |
|------------------|-------------|
| <a name="op-monitor-activity-logs"></a>[Activity log(s)](/rest/api/monitor/activity-logs) | Get a list of event entries in the [activity log](../essentials/platform-logs-overview.md). |
| <a name="op-monitor-event-categories"></a>[(Activity log) event categories](/rest/api/monitor/event-categories) | Lists the types of Activity Log Entries. |
| <a name="op-monitor-activity-log-profiles"></a>[Activity log profiles](/rest/api/monitor/log-profiles) | Operations to manage [activity log profiles](../essentials/platform-logs-overview.md) so you can route activity log events to other locations. |
| <a name="op-monitor-activity-log-tenant-events"></a>[Activity log tenant events](/rest/api/monitor/tenant-activity-logs) | Gets the [Activity Log](../essentials/platform-logs-overview.md) event entries for a specific tenant. |

### Alerts management and action groups

These Azure Monitor APIs create and manage alert rules, action groups, and alert processing rules.

| Operation groups | Description |
|------------------|-------------|
| <a name="op-monitor-action-groups"></a>[Action groups](/rest/api/monitor/action-groups) | Manages and lists [action groups](../alerts/action-groups.md). |
| <a name="op-monitor-activity-log-alerts"></a>[Activity log alerts](/rest/api/monitor/activity-log-alerts) | Manages and lists [activity log alert rules](../alerts/alerts-types.md#activity-log-alerts). |
| <a name="op-monitor-alert-management"></a>[Alert management](/rest/api/alerts-management/alerts/alerts) | Lists and updates [fired alerts](../alerts/alerts-overview.md). |
| <a name="op-monitor-alert-processing-rules"></a>[Alert processing rules](/rest/api/alerts-management/processing-rules/alert-processing-rules) | Manages and lists [alert processing rules](../alerts/alerts-processing-rules.md). |
| <a name="op-monitor-metric-alert-baseline"></a>[Metric alert baseline](/rest/api/monitor/baselines) | List the metric baselines used in alert rules with [dynamic thresholds](../alerts/alerts-dynamic-thresholds.md). |
| <a name="op-monitor-metric-alerts"></a>[Metric alerts](/rest/api/monitor/metric-alerts) | Manages and lists [metric alert rules](../alerts/alerts-overview.md). |
| <a name="op-monitor-metric-alerts-status"></a>[Metric alerts status](/rest/api/monitor/metric-alerts-status) | Lists the status of [metric alert rules](../alerts/alerts-overview.md). |
| <a name="op-monitor-prometheus-rule-groups"></a>[Prometheus rule groups](/rest/api/alerts-management/prometheus-rule-groups/prometheus-rule-groups) | Manages and lists [Prometheus rule groups](../essentials/prometheus-rule-groups.md) (alert rules and recording rules). |
| <a name="op-monitor-scheduled-query-rules-2023-03-15-preview"></a>[Scheduled query rules - 2023-03-15 (preview)](/rest/api/monitor/scheduled-query-rules?view=rest-monitor-2023-03-15-preview&preserve-view=true) | Manages and lists [log search alert rules](../alerts/alerts-types.md#log-alerts). |
| <a name="op-monitor-scheduled-query-rules-2018-04-16"></a>[Scheduled query rules - 2018-04-16](/rest/api/monitor/scheduled-query-rules?view=rest-monitor-2018-04-16&preserve-view=true) | Manages and lists [log search alert rules](../alerts/alerts-types.md#log-alerts). |
| <a name="op-monitor-scheduled-query-rules-2021-08-01"></a>[Scheduled query rules - 2021-08-01](/rest/api/monitor/scheduled-query-rules?view=rest-monitor-2021-08-01&preserve-view=true) | Manages and lists [log search alert rules](../alerts/alerts-types.md#log-alerts). |
| <a name="op-monitor-smart-detector-alert-rules"></a>Smart Detector alert rules | Manages and lists [smart detection alert rules](../alerts/alerts-types.md#smart-detection-alerts). |

### Autoscale

These Azure Monitor APIs manage autoscale settings and retrieve predictive metric data.

| Operation groups | Description |
|------------------|-------------|
| <a name="op-monitor-autoscale-settings"></a>[Autoscale settings](/rest/api/monitor/autoscale-settings) | Operations to manage autoscale settings. |
| <a name="op-monitor-predictive-metric"></a>[Predictive metric](/rest/api/monitor/predictive-metric) | Retrieves predicted autoscale metric data. |

### Data collection

These Azure Monitor APIs manage data collection rules, data collection endpoints, and their associations.

| Operation groups | Description |
|------------------|-------------|
| <a name="op-monitor-data-collection-endpoints"></a>[Data collection endpoints](/rest/api/monitor/data-collection-endpoints) | Create and manage a data collection endpoint and retrieve the data collection endpoints within a resource group or subscription. |
| <a name="op-monitor-data-collection-rule-associations"></a>[Data collection rule associations](/rest/api/monitor/data-collection-rule-associations) | Create and manage a data collection rule association and retrieve the data collection rule associations for a data collection endpoint, resource, or data collection rule. |
| <a name="op-monitor-data-collection-rules"></a>[Data collection rules](/rest/api/monitor/data-collection-rules) | Create and manage a data collection rule and retrieve the data collection rules within a resource group or subscription. |

### Diagnostic settings

These Azure Monitor APIs manage diagnostic settings that control routing of metric data and diagnostic logs.

| Operation groups | Description |
|------------------|-------------|
| <a name="op-monitor-diagnostic-settings"></a>[Diagnostic settings](/rest/api/monitor/diagnostic-settings) | Operations to create, update, and retrieve the [diagnostic settings](../essentials/platform-logs-overview.md) for a resource. Controls the routing of metric data and diagnostic logs. |
| <a name="op-monitor-diagnostic-settings-category"></a>[Diagnostic settings category](/rest/api/monitor/diagnostic-settings) | Relates to the [possible categories](../essentials/resource-logs-schema.md) for a given resource. |
| <a name="op-monitor-management-group-diagnostic-settings"></a>[Management group diagnostic settings](/rest/api/monitor/management-group-diagnostic-settings) | Manage the management group diagnostic settings for a resource and retrieve the management group diagnostic settings list for a management group. |
| <a name="op-monitor-subscription-diagnostic-settings"></a>[Subscription diagnostic settings](/rest/api/monitor/subscription-diagnostic-settings) | Manage the subscription diagnostic settings for a resource and retrieve the subscription diagnostic settings list for a subscriptionId. |

### Resource metrics

These Azure Monitor APIs retrieve resource metric definitions, values, and manage Azure Monitor workspaces used for storing Prometheus metrics.

| Operation groups | Description |
|------------------|-------------|
| <a name="op-monitor-azure-monitor-workspaces"></a>[Azure Monitor Workspaces](/rest/api/monitor/azure-monitor-workspaces) | Manage an Azure Monitor workspace and retrieve the Azure Monitor workspaces within a resource group or subscription. |
| <a name="op-monitor-metric-definitions"></a>[Metric definitions](/rest/api/monitor/metric-definitions) | Lists the metric definitions available for the resource. That is, what [specific metrics](/azure/azure-monitor/reference/supported-metrics/metrics-index) can you collect. |
| <a name="op-monitor-metric-namespaces"></a>[Metric namespaces](/rest/api/monitor/metric-namespaces) | Lists the metric namespaces. Most relevant when using [custom metrics](../essentials/metrics-custom-overview.md). |
| <a name="op-monitor-metrics-batch"></a>[Metrics Batch](/rest/api/monitor/metrics-batch) | List the metric values for multiple resources. This requires the `https://<region>.metrics.monitor.azure.com` endpoint. |
| <a name="op-monitor-metrics"></a>[Metrics](/rest/api/monitor/metrics) | Lists the metric values for a resource you identify. |
| <a name="op-monitor-metrics-custom"></a>[Metrics – Custom](/rest/api/monitor/metrics-custom) | Post the metric values for a resource. |

## Application Insights APIs

These Application Insights APIs include both control plane APIs for managing Application Insights resources and data plane APIs for querying telemetry data. See the [Application Insights section](/rest/api/application-insights/) of the Azure REST APIs documentation for the latest API versions.

| Operation groups | Description |
|------------------|-------------|
| <a name="op-appinsights-components"></a>[Components](/rest/api/application-insights/components) | Enables you to manage components that contain Application Insights data. |
| <a name="op-appinsights-data-access"></a>[Data Access](../logs/api/overview.md) | Query Application Insights data. |
| <a name="op-appinsights-events"></a>[Events](/rest/api/application-insights/events) | Retrieve the data for a single event or multiple events by event type and retrieve the OData EDMX metadata for an application. |
| <a name="op-appinsights-metadata"></a>[Metadata](/rest/api/application-insights/metadata) | Retrieve and export metadata information for an Application Insights application. |
| <a name="op-appinsights-metrics"></a>[Metrics](/rest/api/application-insights/metrics) | Retrieve or export the metric data for an application and retrieve the metadata describing the available metrics for an application. |
| <a name="op-appinsights-query"></a>[Query](/rest/api/application-insights/query) | The Query operation group, which includes Execute and Get operations, enables running analytics queries on resources and retrieving the results, even for large data sets that require extended processing time. |
| <a name="op-appinsights-web-tests"></a>[Web Tests](/rest/api/application-insights/web-tests) | Set up web tests to monitor a web endpoint's availability and responsiveness. |
| <a name="op-appinsights-workbooks"></a>[Workbooks](/rest/api/application-insights/workbooks) | Manage Azure workbooks for an Application Insights component resource and retrieve workbooks within resource group or subscription by category. |

## Azure Monitor Logs APIs

These Azure Monitor Logs APIs have three distinct API groups for ingestion, querying and management.

### Logs ingestion

This is the Azure Monitor Logs data plane API to ingest data into a Log Analytics workspace.

API endpoint is either the data collection endpoint (DCE) or the DCR logs ingestion endpoint. For more information see [Logs ingestion API endpoints](../logs/logs-ingestion-api-overview.md#endpoint).

Scope is `https://monitor.azure.com/.default`.

| Operation groups | Description |
|------------------|-------------|
| <a name="op-logs-upload"></a>[Upload](/rest/api/ingestion/upload) | Lets you send data to a Log Analytics workspace using either a [REST API call](../logs/logs-ingestion-api-overview.md#rest-api-call) or [client libraries](../logs/logs-ingestion-api-overview.md#client-libraries). |

### Logs query

These are the Azure Monitor Logs data plane APIs for querying data in your Log Analytics workspaces.

API endpoint is `api.loganalytics.io` or `api.loganalytics.azure.com`.

| Operation groups | Description |
|------------------|-------------|
| <a name="op-logs-query"></a>[Query](/rest/api/logsquery/query) | Query Analytics table logs using the REST API. For more information, see the [Logs query API overview](../logs/api/overview.md). |
| <a name="op-logs-search"></a>[Search](../logs/basic-logs-query.md?tabs=rest#run-a-query-on-a-basic-or-auxiliary-table) | Query Auxiliary / Lake or Basic table logs using the REST API. For more information, see [Run a query on a Basic or Auxiliary table](../logs/basic-logs-query.md?tabs=rest#run-a-query-on-a-basic-or-auxiliary-table) |
| <a name="op-logs-metadata"></a>[Metadata](/rest/api/logsquery/metadata) | Retrieve metadata information for a Log Analytics workspace, including table schemas and functions. |

### Logs management

These Azure Monitor Logs APIs are part of the Azure Resource Manager (ARM) control plane and allow you to create, update, delete, and retrieve Log Analytics workspaces and related resources such as clusters, data export rules, and linked services.

API endpoint is `management.azure.com`.

| Operation groups | Description |
|------------------|-------------|
| <a name="op-logs-available-service-tiers"></a>[Available service tiers](/rest/api/loganalytics/available-service-tiers) | Retrieve the available service tiers for a Log Analytics workspace. |
| <a name="op-logs-clusters"></a>[Clusters](/rest/api/loganalytics/clusters) | Manage Log Analytics clusters. |
| <a name="op-logs-data-export-rules"></a>[Data export rules](/rest/api/loganalytics/data-exports) | Manage data export rules that continuously send data from selected tables in a Log Analytics workspace to an Azure Storage account or Event Hubs. |
| <a name="op-logs-data-sources"></a>[Data Sources](/rest/api/loganalytics/data-sources) | Create or update data sources. |
| <a name="op-logs-deleted-workspaces"></a>[Deleted workspaces](/rest/api/loganalytics/deleted-workspaces) | Retrieve the recently deleted workspaces within a subscription or resource group. |
| <a name="op-logs-gateways"></a>[Gateways](/rest/api/loganalytics/gateways) | Delete a Log Analytics gateway. |
| <a name="op-logs-intelligence-packs"></a>[Intelligence Packs](/rest/api/loganalytics/intelligence-packs) | Enable or disable an intelligence pack for a Log Analytics workspace or retrieve all intelligence packs for a Log Analytics workspace. |
| <a name="op-logs-linked-services"></a>[Linked Services](/rest/api/loganalytics/linked-services) | Create or update linked services. |
| <a name="op-logs-linked-storage-accounts"></a>[Linked Storage Accounts](/rest/api/loganalytics/linked-storage-accounts) | Manage a link relation between a workspace and storage accounts and retrieve all linked storage accounts associated with a workspace. |
| <a name="op-logs-management-groups"></a>[Management Groups](/rest/api/loganalytics/management-groups) | Retrieve all management groups connected to a Log Analytics workspace. |
| <a name="op-logs-operation-statuses"></a>[Operation Statuses](/rest/api/loganalytics/operation-statuses) | Retrieve the status of a long running asynchronous operation. |
| <a name="op-logs-operations"></a>[Operations](/rest/api/loganalytics/operations) | Retrieve all of the available OperationalInsights Rest API operations. |
| <a name="op-logs-query-pack-queries"></a>[Query pack queries](/rest/api/monitor/query-pack-queries) | Manage a query defined within a Log Analytics QueryPack and retrieve or search the list of queries defined within a Log Analytics QueryPack. |
| <a name="op-logs-query-packs"></a>[Query packs](/rest/api/monitor/query-packs) | Manage a Log Analytics QueryPack including updating its tags and retrieve a list of all Log Analytics QueryPacks within a subscription or resource group. |
| <a name="op-logs-saved-searches"></a>[Saved Searches](/rest/api/loganalytics/saved-searches) | Create or update saved searches. |
| <a name="op-logs-search-job"></a>[Search job](/rest/api/loganalytics/tables) | A search job creates a special search table with a query. For more information, see [Run Search Jobs](../logs/search-jobs.md?tabs=rest#run-a-search-job). |
| <a name="op-logs-storage-insights"></a>[Storage Insights](/rest/api/loganalytics/storage-insights) | Create or update storage insights. |
| <a name="op-logs-summary-rules"></a>[Summary rules](/rest/api/loganalytics/summary-logs) | Create, update, start, stop, delete, and retry summary rules that aggregate log data in a Log Analytics workspace. |
| <a name="op-logs-tables"></a>[Tables](/rest/api/loganalytics/tables) | Manage Log Analytics workspace tables. |
| <a name="op-logs-workspace-purge"></a>[Workspace purge](/rest/api/loganalytics/workspace-purge) | Retrieve the status of an ongoing purge operation or purge the data in a Log Analytics workspace. |
| <a name="op-logs-workspace-schema"></a>[Workspace schema](/rest/api/loganalytics/schema) | Retrieves the schema for a Log Analytics workspace. |
| <a name="op-logs-workspace-shared-keys"></a>[Workspace shared keys](/rest/api/loganalytics/shared-keys) | Retrieve or regenerate the shared keys for a Log Analytics workspace. |
| <a name="op-logs-workspace-usages"></a>[Workspace usages](/rest/api/loganalytics/usages) | Retrieve the usage metrics for a Log Analytics workspace. |
| <a name="op-logs-workspaces"></a>[Workspaces](/rest/api/loganalytics/workspaces) | Manage Log Analytics workspaces. |

## Retired and deprecated APIs

The following APIs have been retired or are scheduled for retirement. They're listed here for reference. See the linked documentation for migration guidance.

| Operation groups | Description |
|------------------|-------------|
| <a name="op-retired-alert-rule-incidents"></a>[Alerts (classic) rule incidents](/rest/api/monitor/alert-rule-incidents) | [Retired in 2019](/previous-versions/azure/azure-monitor/alerts/monitoring-classic-retirement) in the public cloud. Older classic alerts functions. Gets an incident associated to a [classic metric alert rule](../alerts/alerts-classic.overview.md). When an alert rule fires because the threshold is crossed in the up or down direction, an incident is created and an entry added to the [Activity Log](../essentials/platform-logs-overview.md). |
| <a name="op-retired-alert-classic-rules"></a>[Alert (classic) rules](/previous-versions/azure/azure-monitor/alerts/alerts-classic.overview) | [Being retired in 2019](/previous-versions/azure/azure-monitor/alerts/monitoring-classic-retirement) in the public cloud. Provides operations for managing [classic alert](../alerts/alerts-classic.overview.md) rules. |
| <a name="op-retired-data-collector"></a>[Data Collector](../logs/custom-logs-migrate.md) | Legacy HTTP Data Collector API reference and how to migrate to the Logs ingestion API. |
| <a name="op-retired-logs-query-batch-and-beta"></a>[Logs query API batch operator](../logs/api/migrate-batch-and-beta.md#split-batch-queries-into-single-queries)<br>[Logs query API beta version](../logs/api/migrate-batch-and-beta.md#change-beta-path-to-v1) | This operation and version of the Logs query API is deprecated. See [Migrate from Logs query batch and beta](../logs/api/migrate-batch-and-beta.md) for timelines. |
