---
title: Autoscaling support for addon pods
description: Documentation regarding addon pod autoscaling support for Azure Managed Prometheus
ms.topic: conceptual
ms.date: 2/28/2024
ms.reviewer: rashmy
---

# Managed Prometheus support for Horizontal Pod Autoscaling for Collector Replicaset

### Overview
The Managed Prometheus Addon now supports Horizontal Pod Autoscaling(HPA) for the ama-metrics replicaset pod. 
With this, the ama-metrics replicaset pod which handles the scraping of prometheus metrics with custom jobs can scale automatically based on the memory utilization. By default, the HPA is configured with a minimum of 2 replicas (which is our global default) and a maximum of 12 replicas. The customers will also the have capability to set the shards to any number of minimum and maximum repliacas as long as they are within the range of 2 and 12.
With this, HPA automatically takes care of scaling based on the memory utlization of the ama-metrics pod to avoid OOMKills along with providing customer flexibility.

[Kubernetes support for HPA](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) 

[HPA Deployment Spec for Managed Prometheus Addon](https://github.com/Azure/prometheus-collector/blob/main/otelcollector/deploy/addon-chart/azure-monitor-metrics-addon/templates/ama-metrics-collector-hpa.yaml)

### Update Min and Max shards
In order to update the min and max shards on the HPA, the HPA object **ama-metrics-hpa** in the kube-system namespace can be edited and it will not be reconciled as long as it is within the supported range of 2 and 12.

**Update Min replicas**
```bash
kubectl patch hpa ama-metrics-hpa -n kube-system --type merge --patch '{"spec": {"minReplicas": 4}}'
```

**Update Max replicas**
```bash
kubectl patch hpa ama-metrics-hpa -n kube-system --type merge --patch '{"spec": {"maxReplicas": 10}}'
```

**Update Min and Max replicas**
```bash
kubectl patch hpa ama-metrics-hpa -n kube-system --type merge --patch '{"spec": {"minReplicas": 3, "maxReplicas": 10}}'
```

**or**

The min and max replicas can also be edited by doing a **kubectl edit** and updating the spec in the editor
```bash
kubectl edit hpa ama-metrics-hpa -n kube-system
```

### Update min and max shards to disable HPA scaling
HPA should be able to handle the load automatically for varying customer needs. But, it it doesnt fit the needs, the customer can set min shards = max shards so that HPA doesnt scale the replicas based on the varying loads. 

Ex - If the customer wants to set the shards to 8 and not have the HPA update the shards, update the min and max shards to 8.

**Update Min and Max replicas**
```bash
kubectl patch hpa ama-metrics-hpa -n kube-system --type merge --patch '{"spec": {"minReplicas": 8, "maxReplicas": 8}}'
```

## Next steps

* [Troubleshoot issues with Prometheus data collection](prometheus-metrics-troubleshoot.md).
