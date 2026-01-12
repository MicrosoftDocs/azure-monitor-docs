---
title: Configure Azure Monitor pipeline transformations
description: Configuration of Azure Monitor pipeline for edge and multicloud scenarios
ms.topic: article
ms.date: 05/21/2025
ms.custom: references_regions, devx-track-azurecli
---


# Azure Monitor pipeline overview transformations

Azure Monitor Pipeline data transformations allow you to filter and manipulate log data before it's sent to Azure Monitor in the cloud. Use transformations to schematize, filter, and aggregate log events to get cleaner data, reduced costs, and lower network bandwidth requirements. Transformations enable you to structure incoming data according to your analytics needs, ensuring that only relevant information is ingested and processed.


- Modify schema to standardize data for analytics
- Filtering records and columns to drop noise and reduce ingestion cost
- Aggregate data to summarize high-volume logs into actionable insights 

## Comparison to Azure Monitor transformations

> [!NOTE]
> Azure Monitor Pipeline data transformations provide similar functionality as [data transformations](./data-collection-transformations.md) in Azure Monitor. Azure Monitor transformations are run after the data is received by Azure Monitor but before it's ingested in the Log Analytics workspace. Azure Monitor pipeline transformations are applied earlier in the data flow, allowing for data shaping and filtering before the data is sent to Azure Monitor.

| Feature | Azure Monitor Transformations | Azure Monitor Pipeline Transformations |
|:---|:---|:---|
| When applied | After data is received by Azure Monitor but before it's stored in Log Analytics workspace | Before data is sent to Azure Monitor |
| Definition location | Defined in Data Collection Rules (DCRs) | Defined in Dataflows within Azure Monitor Pipeline |
| Language | Kusto Query Language (KQL) | Kusto Query Language (KQL) |
| Aggregations | No | Yes |
| Template support | No | Yes |



## Define a transformation
Pipeline transformations are defined as part of a dataflow. You can configure them using either the Azure portal or ARM templates. You can define your own custom transformation or use prebuilt templates for common patterns. Syntax validation, such as checking KQL expressions, is available to help ensure accuracy before saving your configuration. These capabilities allow for flexible and powerful data shaping directly within your monitoring infrastructure.


## Aggregations
An aggregation in KQL summarizes data from multiple records into a single record based on specified criteria. For example, you can aggregate log entries to calculate the average value of numeric property or count the number of occurrences of specific events over a defined time period. Aggregations help reduce data volume and provide insights by condensing large datasets into meaningful summaries.

The default time interval for aggregations is 1 minute, meaning that all records within each one-minute window are grouped together for aggregation. This is the only time interval supported in the Azure portal. To specify different time intervals, you must use ARM templates.

> [!TIP]
> Need the ARM syntax to define the interval.


## Next steps

* [Read more about data collection rules (DCRs) in Azure Monitor](data-collection-rule-overview.md).
