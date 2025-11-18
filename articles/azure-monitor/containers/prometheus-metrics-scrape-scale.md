---
title: Scrape Prometheus metrics at scale in Azure Monitor
description: Guidance on performance that can be expected when collection metrics at high scale for Azure Monitor managed service for Prometheus.
ms.topic: article
ms.date: 5/25/2025
ms.reviewer: viviandiec
---

# Scrape Prometheus metrics at scale in Azure Monitor

This article provides guidance on performance that can be expected when collection metrics at high scale for [Azure Monitor managed service for Prometheus](../essentials/prometheus-metrics-overview.md). 

## CPU and memory

The CPU and memory usage is correlated with the number of bytes of each sample and the number of samples scraped. These benchmarks are based on the [default targets scraped](prometheus-metrics-scrape-default.md), volume of custom metrics scraped, and number of nodes, pods, and containers. These numbers are meant as a reference since usage can still vary significantly depending on the number of time series and bytes per metric.

The upper volume limit per pod is currently about 3-3.5 million samples per minute, depending on the number of bytes per sample. 

The agent consists of a deployment with two replicas by default (which will be automatically configured by HPA based on memory utilization) and DaemonSet for scraping metrics. The DaemonSet scrapes any node-level targets such as cAdvisor, kubelet, and node exporter. You can also configure it to scrape any custom targets at the node level with static configs. The replica set scrapes everything else such as kube-state-metrics or custom scrape jobs that utilize service discovery.

## Comparison between small and large cluster for replica

| Scrape Targets                      | Samples Sent / Minute | Node Count | Pod Count | Prometheus-Collector CPU Usage (cores) | Prometheus-Collector Memory Usage (bytes) |
|:------------------------------------|:----------------------|:-----------|:----------|:---------------------------------------|:------------------------------------------|
| default targets                     | 11,344                | 3          | 40        | 12.9 mc                                | 148 Mi                                    |
| default targets                     | 260,000               | 340        | 13000     | 1.10 c                                 | 1.70 GB                                   |
| default targets<br>+ custom targets | 3.56 million          | 340        | 13000     | 5.13 c                                 | 9.52 GB                                   |

## Comparison between small and large cluster for DaemonSets

| Scrape Targets | Samples Sent / Minute Total | Samples Sent / Minute / Pod |  Node Count | Pod Count | Prometheus-Collector CPU Usage Total (cores) |Prometheus-Collector Memory Usage Total (bytes) | Prometheus-Collector CPU Usage / Pod (cores) |Prometheus-Collector Memory Usage / Pod (bytes) |
|:---|:---|:---|:---|:---|:---|:---|:---|:---|
| default targets | 9,858 | 3,327 | 3 | 40 | 41.9 mc | 581 Mi | 14.7 mc | 189 Mi |
| default targets | 2.3 million | 14,400 | 340 | 13000 | 805 mc | 305.34 GB | 2.36 mc | 898 Mi |

For more custom metrics, the single pod behaves the same as the replica pod depending on the volume of custom metrics.


## Schedule ama-metrics replica pod on a node pool with more resources 

A large volume of metrics per pod needs a node with enough CPU and memory. If the *ama-metrics* replica pods aren't scheduled on nodes or node pools with enough resources, they might get OOMKilled and go into CrashLoopBackoff. To fix this, you can add the label `azuremonitor/metrics.replica.preferred=true` to nodes or node pools on your cluster with higher resources (in [system node pool](/azure/aks/use-system-pools#system-and-user-node-pools)). This ensures the replica pods get scheduled on those nodes. You can also create extra system pools with larger nodes and add the same label. It's better to label node pools rather than individual nodes so new nodes in the pool can also be used for scheduling.

```
kubectl label nodes <node-name> azuremonitor/metrics.replica.preferred="true"
```

## Next steps

* [Troubleshoot issues with Prometheus data collection](prometheus-metrics-troubleshoot.md).
