---
title: Supported metrics - Microsoft.Orbital/geocatalogs
description: Reference for Microsoft.Orbital/geocatalogs metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 06/03/2025
ms.custom: Microsoft.Orbital/geocatalogs, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Orbital/geocatalogs

The following table lists the metrics available for the Microsoft.Orbital/geocatalogs resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.Orbital/geocatalogs](../supported-logs/microsoft-orbital-geocatalogs-logs.md)


### Category: Asset Metrics
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Geospatial Storage**<br><br>Ingested data stored after any cloud-optimization and compression |`spatio.asset.capacity` |Bytes |Average |\<none\>|PT1H |Yes|
|**Assets Count**<br><br>Denotes the Number of assets created in this GeoCatalog |`spatio.asset.count` |Count |Average |\<none\>|PT1H |Yes|

### Category: Collection Metrics
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**STAC Collection Count**<br><br>Denotes the Number of STAC Collections created in this GeoCatalog |`spatio.collection.count` |Count |Average |\<none\>|PT1M |Yes|
|**Item Count**<br><br>Denotes the Number of items created in this GeoCatalog |`spatio.item.exact_count` |Count |Average |`collection_id`|PT1M |Yes|

### Category: Usage Metrics
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Ingest and Transform**<br><br>Compute consumed transforming data into cloud-optimized formats (for example COG generation) and ingesting data into GeoCatalog |`spatio.ingress.cpu_usage` |Count |Average |\<none\>|PT1M |Yes|
|**Used Capacity**<br><br>Denotes the amount of storage used by this GeoCatalog |`spatio.storage.capacity` |Bytes |Average |\<none\>|PT1H |Yes|
|**Bandwidth**<br><br>Data transferred out of the Azure region hosting the GeoCatalog resource. This includes egress to external client from the Geocatalog as well as egress within Azure. As a result, this number does not reflect billable egress. |`spatio.storage.egress_bandwidth` |Bytes |Total (Sum), Average |\<none\>|PT1M |Yes|
|**Geospatial Data Operations**<br><br>Storage read / metadata retrieval operations (search, list, item/asset metadata access) |`spatio.storage.transactions` |Count |Total (Sum), Average |`ApiName`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
