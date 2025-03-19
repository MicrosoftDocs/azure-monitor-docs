---
ms.service: azure-monitor
ms.topic: include
ms.date: 01/25/2024
ms.author: edbaynash
author: EdB-MSFT
---

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
