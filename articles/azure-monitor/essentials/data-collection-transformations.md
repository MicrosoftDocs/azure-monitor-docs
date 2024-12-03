---
title: Transformations Azure Monitor
description: Use transformations in a data collection rule in Azure Monitor to filter and modify incoming data.
ms.topic: conceptual
author: bwren
ms.author: bwren
ms.date: 10/02/2024
ms.reviwer: nikeist
---

# Transformations in Azure Monitor
Transformations in Azure Monitor allow you to filter or modify incoming data before it's sent to a Log Analytics workspace. Transformations are performed in the cloud pipeline after the data source delivers the data and before it's sent to the destination. They're defined in a [data collection rule (DCR)](data-collection-rule-overview.md) and use a [Kusto Query Language (KQL) statement](data-collection-transformations-structure.md) that's applied individually to each entry in the incoming data.

The following diagram illustrates the transformation process for incoming data and shows a sample query that might be used. In this sample, only records where the `message` column contains the word `error` will be collected.

:::image type="content" source="media/data-collection-transformations/transformation-overview.png" lightbox="media/data-collection-transformations/transformation-overview.png" alt-text="Diagram that shows ingestion-time transformation for incoming data." border="false":::

## Workspace transformations
Transformations are defined in a data collection rule (DCR), but there are still data collections in Azure Monitor that don't yet use a DCR. Examples include resource logs collected by [diagnostic settings](./diagnostic-settings.md) and application data collected by [Application insights](../app/app-insights-overview.md).

The *workspace transformation data collection rule (DCR)* is a special [DCR](./data-collection-rule-overview.md) that's applied directly to a Log Analytics workspace. The purpose of this DCR is to perform [transformations](./data-collection-transformations.md) on data that does not yet use a DCR for its data collection, and thus has no means to define a transformation.

There can be only one workspace DCR for each workspace, but it can include transformations for any number of tables. These transformations are applied to any data sent to these tables unless that data came from another DCR. 

:::image type="content" source="media/data-collection-transformations-workspace/transformation-workspace.png" lightbox="media/data-collection-transformations-workspace/transformation-workspace.png" alt-text="Diagram that shows operation of the workspace transformation DCR." border="false":::


## Supported tables
The following tables in a Log Analytics workspace support transformations.

- Any Azure table listed in [Tables that support transformations in Azure Monitor Logs](../logs/tables-feature-support.md). You can also use the [Azure Monitor data reference](/azure/azure-monitor/reference/) which lists the attributes for each table, including whether it supports transformations.
- Any custom table created for the Azure Monitor Agent. (MMA custom table can't use transformations)


## Transformation performance

Transformation execution time contributes to overall [data ingestion latency](../logs/data-ingestion-time.md). Optimal transformations should take no more than 1 second to run. See [Monitor transformations](./data-collection-monitor.md) for guidance on monitoring the DCR metrics that measure the execution time of each transformation.

> [!WARNING]
>  You may experience data loss if a transformation takes more than 20 seconds.

## Optimize query
Transformations run a KQL query against every record collected with the DCR, so it's important that they run efficiently. Transformations that take excessive time to run can impact the performance of the data collection pipeline and result in data loss. See [Optimize log queries in Azure Monitor](../logs/query-optimization.md) for guidance on testing your query before you implement it as a transformation and for recommendations on optimizing queries that don't run efficiently. 

## Monitor transformations
Because transformations don't run interactively, it's important to continuously monitor them to ensure that they're running properly and not taking excessive time to process data. See [Monitor and troubleshoot DCR data collection in Azure Monitor](data-collection-monitor.md) for details on logs and metrics that monitor the health and performance of transformations. This includes identifying any errors that occur in the KQL and metrics to track their running duration.

The following metrics are automatically collected for transformations and should be reviewed regularly to verify that your transformations are still running as expected. Create [metric alert rules](../alerts/alerts-create-metric-alert-rule.yml) to be automatically notified when one of these metrics exceeds a threshold.

- Logs Transformation Duration per Min
- Logs Transformation Errors per Min

[Enable DCR error logs](./data-collection-monitor.md#enable-dcr-error-logs) to track any errors that occur in your transformations or other queries. Create a [log alert rule](../alerts/alerts-create-log-alert-rule.md) to be automatically notified when an entry is written to this table.




## Cost for transformations
While transformations themselves don't incur direct costs, the following scenarios can result in additional charges:

- If a transformation increases the size of the incoming data, such as by adding a calculated column, you'll be charged the standard ingestion rate for the extra data.
- If a transformation reduces the ingested data by more than 50%, you'll be charged for the amount of filtered data above 50%.

To calculate the data processing charge resulting from transformations, use the following formula:<br>[GB filtered out by transformations] - ([GB data ingested by pipeline] / 2). The following table shows examples.

| Data ingested by pipeline | Data dropped by transformation | Data ingested by Log Analytics workspace | Data processing charge | Ingestion charge |
|:---|:-:|:-:|:-:|:-:|
| 20 GB | 12 GB | 8 GB | 2 GB <sup>1</sup> | 8 GB |
| 20 GB | 8 GB | 12 GB | 0 GB | 12 GB |

<sup>1</sup> This charge excludes the charge for data ingested by Log Analytics workspace.

To avoid this charge, you should filter ingested data using alternative methods before applying transformations. By doing so, you can reduce the amount of data processed by transformations and, therefore, minimize any additional costs.

See [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor) for current charges for ingestion and retention of log data in Azure Monitor.

> [!IMPORTANT]
> If Azure Sentinel is enabled for the Log Analytics workspace, there's no filtering ingestion charge regardless of how much data the transformation filters.





## Next steps

- [Read more about data collection rules (DCRs)](./data-collection-rule-overview.md).
- [Create a workspace transformation DCRs that applies to data not collected using a DCR](./data-collection-transformations.md#workspace-transformations).

