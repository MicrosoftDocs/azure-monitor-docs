---
ms.topic: include
ms.date: 2025/07/25
---

## Avoiding duplicate time series

Prometheus [does not support duplicate time series](https://promlabs.com/blog/2022/12/15/understanding-duplicate-samples-and-out-of-order-timestamp-errors-in-prometheus). Azure Managed Prometheus surfaces these to users as 422 errors rather than silently drop duplicate time series. Users encountering these errors should take action to avoid duplication of time series. 

For example, if a user uses the same "cluster" label value for two different clusters stored in different resource groups but ingesting to the same AMW, they should rename one of these labels for uniqueness. This error will only arise in edge-cases where the timestamp and values are identical across both clusters in this scenario.

This can be fixed by adding a unique identifier label, reinstrumenting an existing label that was intended to be unique, or using [relabel_configs](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config) to inject or modify labels at scrape time.