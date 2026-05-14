---
title: Transformations Azure Monitor
description: Use transformations in a data collection rule in Azure Monitor to filter and modify incoming data.
ms.topic: concept-article
ms.date: 05/13/2026
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
* Custom tables with the [Auxiliary plan](../logs/create-custom-table-auxiliary.md). See [Auxiliary logs transformations](#auxiliary-logs-transformations) for details.

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

## Azure Monitor pipeline transformations

[Azure Monitor pipeline data transformations](./pipeline-transformations.md) provide similar functionality as data transformations in Azure Monitor. Both allow you to apply a KQL query to incoming data to filter or modify that data before it's sent to the next step in the data flow.

Azure Monitor transformations are run after the data is received by Azure Monitor but before it's ingested in the Log Analytics workspace. Azure Monitor pipeline transformations are applied earlier in the data flow, allowing for data shaping and filtering before the data is sent to Azure Monitor. This makes pipeline transformations useful for reducing data volume and network bandwidth when sending data from edge or multicloud environments.

The following table summarizes the key differences between Azure Monitor pipeline transformations and Azure Monitor transformations:

| Feature | Azure Monitor Pipeline Transformations | Azure Monitor Transformations |
|:---|:---|:---|
| When applied | Before data is sent to Azure Monitor | After data is received by Azure Monitor.<br>Before it's stored in Log Analytics workspace |
| Definition | Defined in data flows in Azure Monitor pipeline | Defined in Data Collection Rules (DCRs) in Azure Monitor |
| Language | Kusto Query Language (KQL) | Kusto Query Language (KQL) |
| Aggregations supported? | Yes | No |
| Template supported? | Yes | No |

The data that's ingested into Azure Monitor is a combination of the pipeline transformation and any subsequent Azure Monitor transformations. The only requirement is that the output schema of the pipeline transformation must match the input schema expected by the Azure Monitor transformation. While you can filter data in either transformation, it's generally more efficient to filter data in the pipeline transformations since this reduces the amount of data sent over the network. The schema of the data output by the Azure Monitor transformation must match the schema of the destination table in the Log Analytics workspace.

:::image type="content" source="./media/pipeline-transformations/workflow.png" lightbox="./media/pipeline-transformations/workflow.png" alt-text="Diagram showing the flow of data from pipeline transformation to Azure Monitor transformation to Log Analytics workspace.":::

## Auxiliary logs transformations

> [!IMPORTANT]
> Auxiliary logs transformations are currently in public preview. See [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

You can use transformations to parse, filter, and split logs ingested into [Auxiliary-tier](../logs/data-platform-logs.md#table-plans) custom tables. Auxiliary logs transformations let you:

- **Parse and filter custom logs** on ingestion into Auxiliary-tier tables to reduce stored data volume and cost.
- **Direct standard logs** (for example, VM or resource logs) to custom Auxiliary-tier tables for low-cost retention.
- **Split logs** between Analytics-tier and Auxiliary-tier tables by configuring multiple `dataFlows` in a DCR with KQL transformations that route data to different output streams.

### Prerequisites

- A Log Analytics workspace where you have at least [contributor rights](../logs/manage-access.md#azure-rbac).
- [Permissions to create and modify data collection rules](data-collection-rule-create-edit.md#permissions).
- Logs already flowing into Analytics or Basic tier tables.

### Configure auxiliary logs transformations

You can configure transformations for Auxiliary logs in the following scenarios:

- **API-based ingestion**: Configure a DCR with the Auxiliary table as the output stream.
- **Azure Monitor Agent–collected logs**: Modify `dataFlows` in the DCR to redirect output to an Auxiliary table.
- **Logs collected via diagnostic settings**: Modify the workspace's default DCR to route data to Auxiliary-tier tables.

To create a custom table with the Auxiliary plan, see [Set up a table with the Auxiliary plan](../logs/create-custom-table-auxiliary.md).

### Split logs between Analytics and Auxiliary tiers

To split logs between tiers, implement multiple `dataFlows` for the same input stream in a DCR. Use KQL transformations to filter and route data into different output streams — for example, send high-value records to an Analytics-tier table and route verbose or low-priority records to an Auxiliary-tier table for low-cost retention.

## Cost for transformations

Processing logs (transforming and filtering) in the Azure Monitor cloud pipeline has different billing implications depending on the type of table into which data is being ingested in a Log Analytics workspace. 

### Auxiliary Logs

Auxiliary Logs charges for data processed and data ingested into a Log Analytics workspace. The data processing charge applies to all of the incoming data received by the Azure Monitor cloud pipeline if the destination in a Log Analytics workspace is an Auxiliary Logs table. The data ingestion charge applies only to the data after the transformation which is ingested as an Auxiliary Logs table into a Log Analytics workspace. Transformations can either increase of decrease the size of the data. 

The following tables shows some examples: 

|Incoming data size| Data dropped or added by transformation | Data ingested into a Log Analytics workspace as an Auxiliary Logs table| Data processing billable GBs |Data ingestion billable GBs |
|:--------------------------|:------------------------------:|:----------------------------------------:|:----------------------:|:----------------:|
| 20 GB                     | 12 GB dropped                         | 8 GB                                     | 20 GB                   | 8 GB             |
| 20 GB                     | 8 GB dropped                           | 12 GB                                    | 20 GB                   | 12 GB            |
| 20 GB                     | 4 GB added                           | 24 GB                                    | 20 GB                   | 24 GB            |

See [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor) for prices for log processing and log data ingestion.

### Analytics or Basic Logs

For Analytics or Basic Logs, transformations themselves don't usually incur any costs, but the following scenarios can result in additional charges:

* If a transformation increases the size of the incoming data, such as by adding a calculated column, you're charged the standard ingestion rate for the extra data.
* If a transformation reduces the ingested data by more than 50%, you're charged for the amount of filtered data above 50%.

To calculate the data processing charge resulting from transformations, use the following formula:  
<br>[GB data dropped by transformation] - ([GB incoming data size] / 2).   
  
The following table shows examples.

|Incoming data size| Data dropped or added by transformation | Data ingested into a Log Analytics workspace as an Analytics or Basic Logs table| Data processing billable GBs |Data ingestion billable GBs |
|:--------------------------|:------------------------------:|:----------------------------------------:|:----------------------:|:----------------:|
| 20 GB                     | 12 GB dropped                  | 8 GB                                     | 2 GB                   | 8 GB             |
| 20 GB                     | 8 GB dropped                   | 12 GB                                    | 0 GB                   | 12 GB            |
| 20 GB                     | 4 GB added                     | 24 GB                                    | 0 GB                   | 24 GB            |

To avoid this charge, you should filter ingested data using alternative methods before applying transformations. By doing so, you can reduce the amount of data processed by transformations and, therefore, minimize any additional costs.

See [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor) for pricing for log processing and log data ingestion.

> [!IMPORTANT]
> If Microsoft Sentinel is enabled for the Log Analytics workspace, there's no cost for transformation to Analytics tables regardless of how much data the transformation filters.

## Next steps

* [Read more about data collection rules (DCRs)](data-collection-rule-overview.md).
* [Create a workspace transformation DCRs that applies to data not collected using a DCR](data-collection-transformations-create.md#create-workspace-transformation-dcr).
