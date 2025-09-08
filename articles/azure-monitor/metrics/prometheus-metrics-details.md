---
title: Azure Monitor managed service for Prometheus technical details
description: Get an overview of Azure Monitor with Prometheus, which provides Prometheus-compatible interfaces called Azure Monitor workspaces for storing and retrieving metric data.
ms.topic: concept-article
ms.date: 10/06/2024
---

# Azure Monitor managed service for Prometheus technical details

[Prometheus](http://promehteus.io) is a popular open-source monitoring and alerting solution that's widely used in the cloud-native ecosystem. Azure Monitor provides a fully managed service for Prometheus that enables you to collect, store, and analyze Prometheus metrics without maintaining your own Prometheus server. You can leverage this managed service to collect Prometheus metrics from your Kubernetes clusters and virtual machines, or you can integrate with it from your self-managed Prometheus servers.

## Service limits and quotas

Azure Monitor managed service for Prometheus has default limits and quotas for ingestion. When you reach the ingestion limits, throttling can occur. You can request an increase in these limits. For more information, see [Azure Monitor service limits](../fundamentals/service-limits.md#prometheus-metrics).

To monitor and alert on your ingestion metrics, see [Monitor Azure Monitor workspace metrics ingestion](azure-monitor-workspace-monitor-ingest-limits.md).

## Limitations

The following limitations apply to Azure Monitor managed service for Prometheus:

* The minimum frequency for scraping and storing metrics is 1 second.
* During node updates, you might experience gaps that last 1 to 2 minutes in some metric collections from the cluster-level collector. This gap is due to a regular action from Azure Kubernetes Service to update the nodes in your cluster. This behavior doesn't affect recommended alert rules.
* Managed Prometheus for Windows nodes isn't automatically enabled. To enable monitoring for Windows nodes and pods in your clusters, see [Enable Windows metrics collection (preview)](../containers/enable-windows-metrics.md).

## Case sensitivity

Azure Monitor managed service for Prometheus is a case-insensitive system. It treats strings (such as metric names, label names, or label values) as the same time series if they differ from another time series only by the case of the string.

> [!NOTE]
> This behavior is different from native open-source Prometheus, which is a case-sensitive system.  Self-managed Prometheus instances running in Azure virtual machines, virtual machine scale sets, or Azure Kubernetes Service clusters are case-sensitive systems.

In managed service for Prometheus, the following time series are considered the same:

> `diskSize(cluster="eastus", node="node1", filesystem="usr_mnt")`  
> `diskSize(cluster="eastus", node="node1", filesystem="usr_MNT")`

The preceding examples are a single time series in a time series database. The following considerations apply:

- Any samples ingested against them are stored as if they're scraped or ingested against a single time series.
- If the preceding examples are ingested with the same time stamp, one of them is randomly dropped.
- The casing that's stored in the time series database and returned by a query is unpredictable. The same time series might return different casing at different times.
- Any metric name or label name/value matcher present in the query is retrieved from the time series database through a case-insensitive comparison. If there's a case-sensitive matcher in a query, it's automatically treated as a case-insensitive matcher in string comparisons.

It's a best practice to use a single consistent case to produce or scrape a time series.

Open-source Prometheus treats the preceding examples as two different time series. Any samples scraped or ingested against them are stored separately.


## Avoiding duplicate time series

Prometheus [does not support duplicate time series](https://promlabs.com/blog/2022/12/15/understanding-duplicate-samples-and-out-of-order-timestamp-errors-in-prometheus). Azure Managed Prometheus surfaces these to users as 422 errors rather than silently drop duplicate time series. Users encountering these errors should take action to avoid duplication of time series. 

For example, if a user uses the same "cluster" label value for two different clusters stored in different resource groups but ingesting to the same AMW, they should rename one of these labels for uniqueness. This error will only arise in edge-cases where the timestamp and values are identical across both clusters in this scenario.


## Metric names, label names & label values

Metrics scraping currently has the limitations in the following table:

| Property | Limit |
|:---|:---|
| Label name length | Less than or equal to 511 characters. When this limit is exceeded for any time-series in a job, the entire scrape job fails, and metrics get dropped from that job before ingestion. You can see up=0 for that job and also target Ux shows the reason for up=0. |
| Label value length | Less than or equal to 1023 characters. When this limit is exceeded for any time-series in a job, the entire scrape fails, and metrics get dropped from that job before ingestion. You can see up=0 for that job and also target Ux shows the reason for up=0. |
| Number of labels per time series | Less than or equal to 63. When this limit is exceeded for any time-series in a job, the entire scrape job fails, and metrics get dropped from that job before ingestion. You can see up=0 for that job and also target Ux shows the reason for up=0. |
| Metric name length | Less than or equal to 511 characters. When this limit is exceeded for any time-series in a job, only that particular series get dropped. MetricextensionConsoleDebugLog has traces for the dropped metric. |
| Label names with different casing | Two labels within the same metric sample, with different casing is treated as having duplicate labels and are dropped when ingested. For example, the time series `my_metric{ExampleLabel="label_value_0", examplelabel="label_value_1}` is dropped due to duplicate labels since `ExampleLabel` and `examplelabel` are seen as the same label name. |



## Related content

* [Enable monitoring for Kubernetes clusters](../containers/kubernetes-monitoring-enable.md)
* [Send Prometheus metrics from virtual machines, scale sets, or Kubernetes clusters to an Azure Monitor workspace](prometheus-remote-write-virtual-machines.md)
* [Enable Windows metrics collection (preview)](../containers/enable-windows-metrics.md)
* [Configure Azure Monitor managed service for Prometheus rule groups](prometheus-rule-groups.md)
* [Customize scraping of Prometheus metrics in Azure Monitor managed service for Prometheus](../containers/prometheus-metrics-scrape-configuration.md)
* [Troubleshoot collection of Prometheus metrics in Azure Monitor](../containers/prometheus-metrics-troubleshoot.md)


> [!IMPORTANT]
> The use of Azure Monitor to manage and host Prometheus is intended for storing information about the service health of customer machines and applications. It's not intended for storing any personal data. We strongly recommend that you don't send any sensitive information (for example, usernames and credit card numbers) into Azure Monitor-hosted Prometheus fields like metric names, label names, or label values.


> [!NOTE]
> Azure Managed Prometheus supports Horizontal Pod Autoscaling for replicaset pods in AKS Kubernetes clusters. See [Autoscaling](../containers/prometheus-metrics-scrape-autoscaling.md) to learn more.