---
title: Data plane API and metrics batch query versus metrics export 
description: A comparison of Data plane API or metrics batch query and metrics export.
services: azure-monitor
author: EdB-MSFT
ms.author: edbaynash
ms.topic: conceptual
ms.date: 09/15/2024

# As an Azure administrator, I want to understand the differences between the Data Plane API or Metrics Batch query and Metrics export so that I can choose the right service for my scenario.

---


# Data plane metrics batch API query versus metrics export 


Azure Monitor provides two ways to access metrics data at scale: Data plane or Metrics Batch API, and Metrics Export. Although both work for collecting metrics data, they're more effective for different use cases. This article provides a scenario comparison for using these services, and recommendations on when to use which service.

## Data plane metrics batch query

The data plane API or Metrics Batch query allows you to query historical metrics data for up to 50 resources in a single API call. The query supports filtering based on subscription, metric, time and other dimensions, and provides aggregation such as sum, average, minimum, and maximum.
The batch query can significantly improve query throughput and reduce the risk of throttling. For more information on how to use the data plane metrics batch API, see [Azure Monitor Metrics Data plane API](/rest/api/monitor/metrics-batch/batch). This service is ideal for scenarios where you want to query metrics data across time, and multiple resources in a single subscription and region.

## Metrics export

The Metrics Export uses data collection rules (DCRs) to stream platform metrics in near real-time to different Azure destinations such as Storage Accounts, Event Hubs, and Log Analytics Workspace for persistent storage. While you can filter which metrics are exported, there's no access to historical data. This service is ideal for scenarios where you want to continuously export metrics data in real time across subscriptions and resources. For more information on how to use the Metrics Export service, see [Export metrics using Data Collection Rules](./data-collection-metrics.md).


## Comparison and recommendations 

|	Scenario 	|	Data plane API 	|	Metrics Export 	|	Recommendation 
|	---	|	---	|	---	|	---
| Primary use case 	|	Querying metrics data with historical depth for multiple resources in a single subscription and region 	|	Exporting metrics data across subscriptions and resources 	|	Data plane metrics batch API is recommended for querying metrics and has access to 93 days of data.<p> Metrics Export is recommended for the continuous exporting of metrics data to Azure and external destinations.
|	Querying large subscriptions with multiple resources 	|	Querying for multiple resources in a single batch call including filtering and aggregation with 93 days of history. |	No query support. Continuous export of metrics data in real time 	|	Data plane Metrics Batch API is a better fit for this task as it supports queries and has access to historical data. Metrics Export can't query data and has no access to historical information. 
|Continuous export in near real-time of metrics to Storage Accounts, Event Hubs, Log Analytics Workspace. |	Possible but inefficient. Requires the creation of a repetitive query mechanism to extract the data and a method to store the data at the destination. 	|	One-time configuration using data collection rule to continuously export metrics in real time. The data can be seamlessly sent and stored in a Storage Account, Event Hubs, and Log Analytics Workspace 	|	Metrics Export provides "set and forget", fully managed functionality. Using the Data plane API requires more development effort to extract and store the data at the destination.
|	Limitations in querying and export 	|	The Data plane API allows querying up to 50 resource IDs in a single API call.	|	There's no limit to the number of resources for metrics export that can be associated with a single data collection rule. A single resource can be associated with a maximum of only 5 DCRs |	Metrics Export might be a better fit to query unlimited data for the resources.
|	Independent Software Vendors (ISV) querying and analyzing metrics. 	|	Data plane API can help enable querying metrics from the customer subscriptions by third-party applications. 	|	Metrics Export requires the creation of a data collection rule and a certain level of permissions for exporting resource metrics.	|	Data plane API is recommended for ISVs. 
|	Billing 	|	For low volume data, Data plane API is cheaper. For more information, see [Azure Monitor pricing, Export](https://azure.microsoft.com/pricing/details/monitor/). | For high volume data, Metrics Export has a lower cost as it has an event-based billing model. For more information, see [Azure Monitor pricing, Native Metrics](https://azure.microsoft.com/pricing/details/monitor/)	|	Data plane API is recommended for low volume data. Metrics Export is recommended for high volume data.|

