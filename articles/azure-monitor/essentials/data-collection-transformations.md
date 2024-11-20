---
title: Data collection transformations
description: Use transformations in a data collection rule in Azure Monitor to filter and modify incoming data.
ms.topic: conceptual
author: bwren
ms.author: bwren
ms.date: 10/02/2024
ms.reviwer: nikeist
---

# Data collection transformations in Azure Monitor
With transformations in Azure Monitor, you can filter or modify incoming data before it's sent to a Log Analytics workspace. This article provides a basic description of transformations and how they're implemented. It provides links to other content for creating a transformation.

Transformations are performed in Azure Monitor in the cloud pipeline after the data source delivers the data and before it's sent to the destination. The data source might perform its own filtering before sending data but then rely on the transformation for further manipulation.

Transformations are defined in a [data collection rule (DCR)](data-collection-rule-overview.md) and use a [Kusto Query Language (KQL) statement](data-collection-transformations-structure.md) that's applied individually to each entry in the incoming data. It must understand the format of the incoming data and create output in the structure expected by the destination.

The following diagram illustrates the transformation process for incoming data and shows a sample query that might be used.

:::image type="content" source="media/data-collection-transformations/transformation-overview.png" lightbox="media/data-collection-transformations/transformation-overview.png" alt-text="Diagram that shows ingestion-time transformation for incoming data." border="false":::

## Why to use transformations
The following table describes the different goals that you can achieve by using transformations.

| Category | Details |
|:---|:---|
| Remove sensitive data | You might have a data source that sends information you don't want stored for privacy or compliancy reasons.<br><br>**Filter sensitive information.** Filter out entire rows or particular columns that contain sensitive information.<br><br>**Obfuscate sensitive information.** Replace information such as digits in an IP address or telephone number with a common character.<br><br>**Send to an alternate table.** Send sensitive records to an alternate table with different role-based access control configuration. |
| Enrich data with more or calculated information | Use a transformation to add information to data that provides business context or simplifies querying the data later.<br><br>**Add a column with more information.** For example, you might add a column identifying whether an IP address in another column is internal or external.<br><br>**Add business-specific information.** For example, you might add a column indicating a company division based on location information in other columns. |
| Reduce data costs | Because you're charged ingestion cost for any data sent to a Log Analytics workspace, you want to filter out any data that you don't require to reduce your costs.<br><br>**Remove entire rows.** For example, you might have a diagnostic setting to collect resource logs from a particular resource but not require all the log entries that it generates. Create a transformation that filters out records that match a certain criteria.<br><br>**Remove a column from each row.** For example, your data might include columns with data that's redundant or has minimal value. Create a transformation that filters out columns that aren't required.<br><br>**Parse important data from a column.** You might have a table with valuable data buried in a particular column. Use a transformation to parse the valuable data into a new column and remove the original.<br><br>**Send certain rows to basic logs.** Send rows in your data that require basic query capabilities to basic logs tables for a lower ingestion cost. |
| Format data for destination | You might have a data source that sends data in a format that doesn't match the structure of the destination table. Use a transformation to reformat the data to the required schema. |

## Supported tables
The following tables support transformations:

- Any Azure table listed in [Tables that support transformations in Azure Monitor Logs](../logs/tables-feature-support.md). You can also use the [Azure Monitor data reference](/azure/azure-monitor/reference/) which lists the attributes for each table, including whether it supports transformations.
- Any custom table created for the Azure Monitor Agent. (MMA custom table can't use transformations)


## Transformation performance

Transformation execution time contributes to overall [data ingestion latency](../logs/data-ingestion-time.md). Optimal transformations should take no more than 1 second to run. See [Monitor transformations](./data-collection-transformations-best-practices.md#monitor-transformations) for guidance on monitoring the DCR metrics that measure the execution time of each transformation.

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



## Workspace transformations

The *workspace transformation data collection rule (DCR)* is a special [DCR](./data-collection-rule-overview.md) that's applied directly to a Log Analytics workspace. The purpose of this DCR is to perform [transformations](./data-collection-transformations.md) on data that does not yet use a DCR for its data collection, and thus has no means to define a transformation.

The workspace transformation DCR includes transformations for one or more supported tables in the workspace. These transformations are applied to any data sent to these tables unless that data came from another DCR. 

:::image type="content" source="media/data-collection-transformations-workspace/transformation-workspace.png" lightbox="media/data-collection-transformations-workspace/transformation-workspace.png" alt-text="Diagram that shows operation of the workspace transformation DCR." border="false":::

For example, if you create a transformation in the workspace transformation DCR for the Event table, it would be applied to events collected by virtual machines running the Log Analytics agent (deprecated) because this agent doesn't use a DCR. The transformation would be ignored though by any data sent from Azure Monitor Agent (AMA) because it uses a DCR to define its data collection. You can still use a transformation with Log Analytics agent, but you would include that transformation in the DCR used by AMA and not the workspace transformation DCR.

:::image type="content" source="media/data-collection-transformations-workspace/compare-transformations.png" lightbox="media/data-collection-transformations-workspace/compare-transformations.png" alt-text="Diagram that compares standard DCR transformations with workspace transformation DCR." border="false":::

A common use of the workspace transformation DCR is collection of [resource logs](./resource-logs.md) that are configured with a [diagnostic setting](./diagnostic-settings.md). You might want to apply a transformation to this data to filter out records that you don't require. Since diagnostic settings don't have transformations, you can use the workspace transformation DCR to apply a transformation to this data. Data from Application insights is another common source that relies on the workspace transformation DCR.



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
- [Create a workspace transformation DCRs that applies to data not collected using a DCR](./data-collection-transformations-workspace.md).

