---
title: Transform data with Azure Monitor agent
description: Learn how to filter and reshape data collected by Azure Monitor agent by using client-side and ingestion-time transformations.
ms.topic: concept-article
ms.date: 11/18/2026
ms.reviewer: shseth, nmangum
ai-usage: ai-assisted
---

# Transform data with Azure Monitor agent

Azure Monitor agent collects data according to data collection rules (DCRs). You can add transformations to a DCR to filter, reshape, enrich, or aggregate supported data before Azure Monitor stores it. This article explains the transformation stages that apply to Azure Monitor agent and directs you to the detailed configuration and reference guidance.

## Choose a transformation stage

Azure Monitor agent supports transformations at two stages. Choose the stage based on when you need to process the data.

| Stage | Runs on | Use when | DCR configuration |
|:---|:---|:---|:---|
| Client-side | Azure Monitor agent | You need to reduce or reshape supported data before it leaves the monitored machine. | A named multistage transformation referenced by a supported data source. |
| Ingestion-time | Azure Monitor | You need to filter or reshape schematized data before it's written to the destination table. | An inline `transformKql` query or a named multistage transformation referenced by a data flow. |

Multistage transformations, including client-side processing, are in public preview. Not every data source and processor is available at both stages. Review the [transformation processor applicability table](../data-collection/data-collection-rule-structure.md#processor-types) before you design the DCR.

## Configure a transformation

1. [Configure data collection](../vm/data-collection.md) and identify the DCR associated with your monitored resources.
1. Choose the client-side or ingestion-time stage based on your processing and cost requirements.
1. [Create the transformation](../data-collection/data-collection-transformations-create.md) and add it to the DCR.
1. Make sure the transformation output matches the destination table schema. Send records with a different shape, such as aggregated records, to a compatible custom table.
1. Send test data and verify both the retained fields and the destination table before applying the DCR broadly.

For supported KQL operators and functions, see [Supported KQL features in Azure Monitor transformations](../data-collection/data-collection-transformations-kql.md). For common filtering, parsing, enrichment, and cost-reduction patterns, see [Sample transformations in Azure Monitor](../data-collection/data-collection-transformations-samples.md).

## Related content

- [Transformations in Azure Monitor](../data-collection/data-collection-transformations.md)
- [Data collection rules in Azure Monitor](../data-collection/data-collection-rule-overview.md)
- [Best practices for DCR creation and management](../data-collection/data-collection-rule-best-practices.md)
