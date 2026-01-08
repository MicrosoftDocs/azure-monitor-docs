---
title: Configure Azure Monitor pipeline transformations
description: Configuration of Azure Monitor pipeline for edge and multicloud scenarios
ms.topic: article
ms.date: 05/21/2025
ms.custom: references_regions, devx-track-azurecli
---


# Azure Monitor pipeline overview transformations

Azure Monitor Pipeline data transformations can be used to schematize, filter, and aggregate log events before they are sent to Azure Monitor in the cloud. By applying these transformations before ingestion, users get cleaner data, reduced costs and network bandwidth. Transformations enable you to structure incoming data according to your analytics needs, ensuring that only relevant information is ingested and processed.

- Modify schema to standardize data for analytics
- Filtering records and columns to drop noise and reduce ingestion cost
- Aggregate data to summarize high-volume logs into actionable insights 

You can configure transformations in a dataflow in the Azure Monitor Pipeline using either the Azure portal or ARM templates. 

, where you can choose to add transforms while setting up a dataflow. You have the option to use prebuilt templates for common transformation patterns or customize the logic according to your requirements. Syntax validation, such as checking KQL expressions, is available to help ensure accuracy before saving your configuration. These capabilities allow for flexible and powerful data shaping directly within your monitoring infrastructure.


## Next steps

* [Read more about data collection rules (DCRs) in Azure Monitor](data-collection-rule-overview.md).
