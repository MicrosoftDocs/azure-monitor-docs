---
title: Platform Metrics Export Feature Comparison
description: Compare the Data plane Metrics Batch API and Platform Metrics Export to choose the right approach for your scenario.
ms.topic: concept-article
ms.date: 08/27/2026
---

# Platform Metrics Export feature comparison

Azure Monitor provides two ways to access metrics data at scale: the [Azure Monitor Metrics Data plane API](/rest/api/monitor/metrics-batch/batch) and [Platform Metrics Export](./metrics-export-create.md). Although both give access to metrics data, they're more effective for different use cases. This article provides a scenario comparison for using these features and recommendations on when to use each.

## Data plane metrics batch query

The data plane API, or Metrics Batch query, queries historical metrics data for up to 50 resources in a single API call. The query supports filtering based on subscription, metric, time and other dimensions, and provides aggregation such as sum, average, minimum, and maximum.

The batch query can significantly improve query throughput and reduce the risk of throttling. This feature is ideal for scenarios where you want to query metrics data across time, and multiple resources in a single subscription and region.

## Platform Metrics Export

Platform Metrics Export uses [data collection rules (DCRs)](./data-collection-rule-overview.md) to stream platform metrics in near real-time to different Azure destinations such as Storage Accounts, Event Hubs, and Log Analytics Workspaces for persistent storage. Filtering controls which metrics are exported, and historical data is only available from the destination the metrics were sent to. This feature is ideal for scenarios where you want to continuously export metrics data in real time across subscriptions and resources.

## Comparison and recommendations 

| Scenario | Data plane API | Platform Metrics Export | Recommendation |
|----------|----------------|----------------|----------------|
| Primary use case | Querying metrics data with historical depth for multiple resources in a single subscription and region | Exporting metrics data across subscriptions and resources | Data plane metrics batch API is recommended for querying metrics and has access to 93 days of data. Platform Metrics Export is recommended for the continuous exporting of metrics data to Azure and external destinations. |
| Querying large subscriptions with multiple resources | Querying for multiple resources in a single batch call including filtering and aggregation with 93 days of history. | No query support. Continuous export of metrics data in real time. | Data plane Metrics Batch API is a better fit for this task as it supports queries and has access to historical data. Platform Metrics Export can't query data and has no access to historical information. |
| Continuous export in near real-time of metrics to Storage Accounts, Event Hubs, Log Analytics Workspace. | Possible but inefficient. Requires the creation of a repetitive query mechanism to extract the data and a method to store the data at the destination. | One-time configuration using data collection rule to continuously export metrics in real time. The data can be seamlessly sent and stored in a Storage Account, Event Hubs, and Log Analytics Workspace. | Platform Metrics Export provides "set and forget", fully managed functionality. Using the Data plane API requires more development effort to extract and store the data at the destination. |
| Limitations in querying and export | The Data plane API allows querying up to 50 resource IDs in a single API call. |	There's no limit to the number of resources for Platform Metrics Export that can be associated with a single data collection rule. A single resource can be associated with a maximum of only 5 DCRs | Platform Metrics Export might be a better fit to query unlimited data for the resources. |
| Independent Software Vendors (ISV) querying and analyzing metrics. | Data plane API can help enable querying metrics from the customer subscriptions by third-party applications. | Platform Metrics Export requires the creation of a data collection rule and a certain level of permissions for exporting resource metrics.	| Data plane API is recommended for ISVs. |
| Billing |	For low volume data, Data plane API is cheaper. For more information, see [Azure Monitor pricing, Export](https://azure.microsoft.com/pricing/details/monitor/). | For high volume data, Platform Metrics Export has a lower cost as it has an event-based billing model. For more information, see [Azure Monitor pricing, Native Metrics](https://azure.microsoft.com/pricing/details/monitor/). |	Data plane API is recommended for low volume data. Platform Metrics Export is recommended for high volume data. |

## Related content

- [Platform Metrics Export using data collection rules](metrics-export-create.md)
- [Platform Metrics Export supported resources and regions](metrics-export-reference.md)
- [Data collection rule (DCR) structure for Platform Metrics Export](metrics-export-structure.md)
