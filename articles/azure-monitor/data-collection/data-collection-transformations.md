---
title: Transformations Azure Monitor
description: Use transformations in a data collection rule in Azure Monitor to filter and modify incoming data.
ms.topic: article
ms.date: 12/06/2024
ms.reviwer: nikeist
---

# Transformations in Azure Monitor

Transformations in Azure Monitor allow you to filter or modify incoming data before it's sent to a Log Analytics workspace. Transformations are run after the data source delivers the data and before it's sent to the destination. They're defined in a [data collection rule (DCR)](data-collection-rule-overview.md) and use a [Kusto Query Language (KQL) statement](data-collection-transformations-kql.md) that's applied individually to each entry in the incoming data.

The following diagram illustrates the transformation process for incoming data and shows a sample query that might be used. In this sample, only records where the `message` column contains the word `error` are collected.

:::image type="content" source="media/data-collection-transformations/transformation-overview.png" lightbox="media/data-collection-transformations/transformation-overview.png" alt-text="Diagram that shows ingestion-time transformation for incoming data." border="false":::

## Supported tables

The following tables in a Log Analytics workspace support transformations.

* Any Azure table listed in [Tables that support transformations in Azure Monitor Logs](../logs/tables-feature-support.md). You can also use the [Azure Monitor data reference](/azure/azure-monitor/reference/) which lists the attributes for each table, including whether it supports transformations.
* Any custom table created for the Azure Monitor Agent.

## Create a transformation

There are some data collection scenarios that allow you to add a transformation using the Azure portal, but most scenarios require you to create a new DCR using its JSON definition or add a transformation to an existing DCR. See [Create a transformation in Azure Monitor](data-collection-transformations-create.md) for different options and [Best practices and samples for transformations in Azure Monitor](data-collection-transformations-samples.md) for sample transformation queries for common scenarios.

## Workspace transformation DCR

Transformations are defined in a data collection rule (DCR), but there are still data collections in Azure Monitor that don't yet use a DCR. Examples include resource logs collected by [diagnostic settings](../platform/diagnostic-settings.md) and application data collected by [Application insights](../app/app-insights-overview.md).

The *workspace transformation data collection rule (DCR)* is a special [DCR](data-collection-rule-overview.md) that's applied directly to a Log Analytics workspace. The purpose of this DCR is to perform [transformations](data-collection-transformations.md) on data that doesn't yet use a DCR for its data collection, and thus has no means to define a transformation.

There can be only one workspace DCR for each workspace, but it can include transformations for any number of supported tables. These transformations are applied to any data sent to these tables unless that data came from another DCR. 

:::image type="content" source="media/data-collection-transformations/workspace-transformation-dcr.png" lightbox="media/data-collection-transformations/workspace-transformation-dcr.png" alt-text="Diagram that shows operation of the workspace transformation DCR." border="false":::

For example, the [Event](../reference/tables/event.md) table is used to store events from Windows virtual machines. If you create a transformation in the workspace transformation DCR for the Event table, it would be applied to events collected by virtual machines running the Log Analytics agent<sup>1</sup> because this agent doesn't use a DCR. The transformation would be ignored though by any data sent from Azure Monitor Agent (AMA) because it uses a DCR to define its data collection. You can still use a transformation with Azure Monitor agent, but you would include that transformation in the DCR associated with the agent and not the workspace transformation DCR.

:::image type="content" source="media/data-collection-transformations/transformation-comparison.png" lightbox="media/data-collection-transformations/transformation-comparison.png" alt-text="Diagram that compares standard DCR transformations with workspace transformation DCR." border="false":::

<sup>1</sup> The Log Analytics agent has been deprecated, but some environments may still use it. It's only one example of a data source that doesn't use a DCR.

## Cost for transformations

Auxiliary Logs charges for data processed and data ingested into a Log Analytics workspace. The data processing charge applies to all of the incoming data received by the Azure Monitor cloud pipeline if the destination in a Log Analytics workspace is an Auxiliary Logs table. The data ingestion charge applies only to the data that is ingested into the Log Analytics workspace as an Auxiliary Logs table after the transformation is applied.

For Analytics or Basic Logs, transformations themselves don't incur direct costs, but the following scenarios can result in additional charges:

* If a transformation increases the size of the incoming data, such as by adding a calculated column, you're charged the standard ingestion rate for the extra data.
* If a transformation reduces the ingested data by more than 50%, you're charged for the amount of filtered data above 50%.

To calculate the data processing charge resulting from transformations, use the following formula:<br>[GB filtered out by transformations] - ([GB data ingested] / 2). The following table shows examples.

|Incoming data size| Data dropped by transformation | Data ingested into Log Analytics workspace as Analytics or Basic Logs| Data processing charge |Data ingestion charge |
|:--------------------------|:------------------------------:|:----------------------------------------:|:----------------------:|:----------------:|
| 20 GB                     | 12 GB                          | 8 GB                                     | 2 GB <sup>1</sup>      | 8 GB             |
| 20 GB                     | 8 GB                           | 12 GB                                    | 0 GB                   | 12 GB            |

<sup>1</sup> This charge excludes the charge for data ingested by Log Analytics workspace.

To avoid this charge, you should filter ingested data using alternative methods before applying transformations. By doing so, you can reduce the amount of data processed by transformations and, therefore, minimize any additional costs.

See [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor) for current charges for ingestion and retention of log data in Azure Monitor.

> [!IMPORTANT]
> If Azure Sentinel is enabled for the Log Analytics workspace, there's no filtering ingestion charge regardless of how much data the transformation filters.

## Next steps

* [Read more about data collection rules (DCRs)](data-collection-rule-overview.md).
* [Create a workspace transformation DCRs that applies to data not collected using a DCR](data-collection-transformations-create.md#create-workspace-transformation-dcr).
