---
title: Transformations in Azure Monitor
description: Use transformations in a data collection rule in Azure Monitor to filter and modify incoming data, including multi-stage transformations with processors.
ms.topic: concept-article
ms.date: 05/15/2026
ms.reviewer: nikeist
ai-usage: ai-assisted
---

# Transformations in Azure Monitor

Transformations in Azure Monitor allow you to filter or modify incoming data before it's sent to a Log Analytics workspace. Transformations are run after the data source delivers the data and before it's sent to the destination. They're defined in a [data collection rule (DCR)](data-collection-rule-overview.md) and use a [Kusto Query Language (KQL) statement](data-collection-transformations-kql.md) that's applied individually to each entry in the incoming data.

The following diagram illustrates the transformation process for incoming data and shows a sample query that might be used. In this sample, only records where the `message` column contains the word `error` are collected.

:::image type="content" source="media/data-collection-transformations/transformation-overview.png" lightbox="media/data-collection-transformations/transformation-overview.png" alt-text="Diagram that shows ingestion-time transformation for incoming data." border="false":::

## Supported tables

The following tables in a Log Analytics workspace support transformations.

* Any Azure table listed in [Tables that support transformations in Azure Monitor Logs](../logs/tables-feature-support.md). You can also use the [Azure Monitor data reference](/azure/azure-monitor/reference/) which lists the attributes for each table, including whether it supports transformations.
* Any custom table created for the Azure Monitor Agent.
* Custom tables with the [Auxiliary plan](../logs/create-custom-table-auxiliary.md).

## Create a transformation

There are some data collection scenarios that allow you to add a transformation using the Azure portal, but most scenarios require you to create a new DCR using its JSON definition or add a transformation to an existing DCR. See [Create a transformation in Azure Monitor](data-collection-transformations-create.md) for different options and [Best practices and samples for transformations in Azure Monitor](data-collection-transformations-samples.md) for sample transformation queries for common scenarios.

## Multi-stage transformations (preview)

> [!IMPORTANT]
> Multi-stage transformations are currently in public preview. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

Standard transformations apply a single KQL query to incoming data during ingestion. Multi-stage transformations extend this model by letting you define a processing pipeline composed of multiple ordered processing stages, applied as data flows through the system.

With multi-stage transformations, a DCR defines a data processing pipeline rather than a single transformation step. Data flows through the following stages:

1. **Data collection.** Azure Monitor Agent (AMA) collects data from the resource based on the data source settings in the DCR.
1. **Client-side processing.** Transformations run locally on the agent before data is sent over the network. The transformation applies to the data in its raw form, which might differ from the standard table representation.
1. **Ingestion-time processing.** After data reaches Azure Monitor, transformations are applied during ingestion before the data is written to its destination table in Log Analytics. This transformation applies after the data is fully schematized and enriched.
1. **Data delivery.** Processed logs are delivered to their final destination.

### Processors

Transformations in multi-stage DCRs are defined using *processors* — small, declarative building blocks that each perform a specific type of operation. Processors have the following characteristics:

- **Composable.** Multiple processors can be chained together in a single transformation.
- **Ordered.** Processors run sequentially in the order defined in the transformation.
- **Stage-agnostic.** The same processor type can be used across different data sources, stages, or scenarios, with some limitations during preview.

Every transformation starts with a *header processor* that converts raw data into a known schematized tabular format. After the header, you can chain additional processors to filter, map, parse, aggregate, enrich, or apply KQL expressions to the data.

The following processor families are available:

| Family | Processors | Description |
|:-------|:-----------|:------------|
| Header | `header.Syslog`, `header.WindowsEvents`, `header.TextLog`, `header.StandardStream`, `header.CustomStream`, and others | Schematize raw data into a tabular format. Must be the first processor. |
| Filter | `filter.Basic` | Drop records based on condition evaluation. |
| Map | `map.Rename`, `map.Drop` | Rename, typecast, or drop columns. |
| Parse | `parse.JsonPath`, `parse.XmlPath`, `parse.CEFAttribute` | Extract fields from JSON, XML, or CEF-formatted strings. |
| Aggregation | `aggregate.Basic` | Summarize records using aggregation operators with grouping dimensions. |
| Enrichment | `enrich.DNSLookup` | Look up an IP address and add a DNS name column. |
| Custom transform | `transform.KQL` | Apply an arbitrary KQL expression. Ingestion-side only. |

For the complete processor reference, including configuration schemas and output schemas, see [DCR structure - Transformations](data-collection-rule-structure.md#transformations).

### Client-side vs. ingestion-side transformations

Each transformation is assigned to a specific processing stage. This distinction determines where compute happens, what data is sent over the network, and what costs can be optimized early.

| Aspect | Client-side | Ingestion-side |
|:-------|:------------|:---------------|
| Assigned to | Data source (`dataSources`) | Data flow (`dataFlows`) |
| Runs on | Azure Monitor Agent (VM) | Azure Monitor service |
| Header processor | Data-source-specific (for example, `header.Syslog`) | `header.StandardStream` or `header.CustomStream` |
| Cost benefit | Reduces network and ingestion costs by filtering/aggregating before data leaves the resource | Applies after data is schematized and enriched with additional table columns |

A single DCR can combine both client-side and ingestion-side transformations. The output of the client-side stage becomes the input to the ingestion-side stage automatically.

### Multi-stage DCR requirements

- Multi-stage transformations require API version `2025-05-11` or later.
- The `transformations` section and the `transform` property on data sources and data flows aren't recognized by earlier API versions.
- The `transform` property is mutually exclusive with `transformKql` per data flow. A DCR can mix old-style and new-style data flows across different streams.
- To access the portal authoring UI during the preview, navigate to `https://portal.azure.com/?feature.transformEnabled=true`.
- For issues during preview, contact `multistagetransforms@microsoft.com` with your DCR resource ID and subscription.

### Design approach for multi-stage processing

Follow these steps when designing a multi-stage DCR:

1. **Assess data sources and destinations.** Identify your data source types and decide where each lands: the default standard table or a custom table.
1. **Identify aggregation needs.** Aggregated logs should go to a separate table because their shape differs from the raw form.
1. **Plan for differential processing.** If you need to process portions of the same logs differently, create multiple data sources of the same type with different collection settings and apply different client-side transformations to each.
1. **Author client-side transformations.** Use standard streams (`Microsoft-*`) if the output retains the header schema, or custom streams (`Custom-*`) if it doesn't. Define custom streams in `streamDeclarations`.
1. **Define data flows.** For each stream, create a data flow. Use ingestion-time data flows to split a single stream across multiple destination tables by applying different filter criteria per data flow.

> [!NOTE]
> At this time, you must manually coordinate the header of the downstream transformation with the outcome of the upstream transformation. For example, if you apply aggregation to a raw stream of Windows Events, the outcome might not be compatible with the corresponding Event table, and the ingestion-time transformation should begin with a custom stream header.

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

## Multi-stage transformations (preview)

> [!IMPORTANT]
> Multi-stage transformations are currently in public preview. See [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

Multi-stage transformations extend Azure Monitor's ingestion pipeline by allowing multiple, ordered transformations applied to telemetry at the client (on the virtual machine via Azure Monitor Agent) or during ingestion, before the data is stored in Log Analytics. Multi-stage transformations use a processor-based model defined in a new `transformations` section within a [data collection rule (DCR)](data-collection-rule-overview.md).

Multi-stage transformations require API version `2025-05-11` or later. During preview, DCRs with multi-stage transformations must be authored via REST API.

### Capabilities

Multi-stage transformations let you:

- **Extract attributes** from raw data in common formats (CEF, JSON, XML) on the client.
- **Rename and drop columns** on the client before data leaves the resource.
- **Filter and aggregate logs** on the client to reduce data volume sent to Azure Monitor.
- **Apply KQL transformations** at ingestion time.
- **Combine client-side and ingestion-time transformations** in a single DCR.
- **Apply multiple processors** to the same data stream in a defined order.

### How it works

Data collection rules define a multi-stage processing pipeline with four stages:

1. **Data collection** — Azure Monitor Agent collects data from the source.
1. **Client-side processing** — Transformations run on the agent before data leaves the resource.
1. **Ingestion-time processing** — Transformations run in Azure Monitor after data is received.
1. **Data delivery** — Data is stored in the destination Log Analytics workspace table.

Transformations are explicitly assigned to stages. Client-side transformations attach to data sources. Ingestion-time transformations attach to data flows.

### Processors

Each transformation is built from ordered, composable *processors*. A transformation begins with a **header processor** that establishes the schema, followed by one or more processing steps.

#### Header processors

Header processors define the output schema and depend on the data source type. Available headers include:

| Header | Description |
|--------|-------------|
| `header.Syslog` | Syslog data sources |
| `header.WindowsEvents` | Windows event log data sources |
| `header.WindowsPerformanceCounters` | Windows performance counter data sources |
| `header.LinuxPerformanceCounters` | Linux performance counter data sources |
| `header.TextLog` | Custom text log data sources |
| `header.IISLog` | IIS log data sources |
| `header.WindowsFirewallLog` | Windows Firewall log data sources |
| `header.StandardStream` | Standard stream (ingestion-time) |
| `header.CustomStream` | Custom stream (ingestion-time) |

#### Processing processors

After the header, apply one or more processors to transform data:

| Processor | Description | Stage |
|-----------|-------------|-------|
| `filter.Basic` | Filter records based on conditions | Client and ingestion |
| `map.Rename` | Rename columns | Client and ingestion |
| `map.Drop` | Drop columns | Client and ingestion |
| `parse.JsonPath` | Extract fields from JSON data | Client and ingestion |
| `parse.XmlPath` | Extract fields from XML data | Client and ingestion |
| `parse.CEFAttribute` | Extract fields from CEF-formatted data | Client and ingestion |
| `aggregate.Basic` | Aggregate records (changes output schema) | Client |
| `enrich.DNSLookup` | Enrich records with DNS lookup data | Client |
| `transform.KQL` | Apply a KQL transformation | Ingestion only |

> [!NOTE]
> Aggregation changes the output schema and requires routing aggregated data to a separate table from non-aggregated data.

### DCR structure for multi-stage transformations

Multi-stage DCRs introduce a `transformations` section alongside the existing `dataFlows` section. The `transformations` section contains named transformation objects, each with an ordered list of processors.

- Client-side transformations are referenced from `dataSources` entries.
- Ingestion-time transformations are referenced from `dataFlows` entries using the `transform` property (which replaces the `transformKql` property used in single-stage transformations).

### Design approach

When authoring a multi-stage DCR:

1. Assess data sources and destinations.
1. Identify aggregation needs (aggregation changes schema, requiring separate output tables).
1. Plan differential processing paths if different records need different treatment.
1. Author client-side transformations for filtering and parsing that reduces data volume before transmission.
1. Define data flows per stream, applying ingestion-time transformations as needed.

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
- [Create a transformation in Azure Monitor](data-collection-transformations-create.md), including multi-stage transformations.
- [Structure of a data collection rule (DCR)](data-collection-rule-structure.md) for the complete JSON schema, including the multi-stage `transformations` section.
- [Create a workspace transformation DCR](data-collection-transformations-create.md#create-workspace-transformation-dcr) for data not collected using a DCR.
