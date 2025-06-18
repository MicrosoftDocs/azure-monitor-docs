---
title: Autoscaling Support for Addon Pods
description: Documentation regarding addon pod autoscaling support for Azure Managed Prometheus.
ms.topic: concept-article
ms.date: 2/28/2024
ms.reviewer: rashmy
---

# Horizontal Pod Autoscaling (HPA) for Collector Replica set

### Overview
Azure Managed Prometheus supports Horizontal Pod Autoscaling(HPA) for the ama-metrics replica set pod by default. 
The HPA allows the ama-metrics replica set pod, which scrapes Prometheus metrics with custom jobs, to scale automatically based on memory utilization to prevent OOMKills. By default, the HPA is configured with a minimum of two replicas and a maximum of 12 replicas. Users can configure the number of shards within the range of 2 to 12 replicas.

[Kubernetes support for HPA](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) 

### Update Min and Max shards
The HPA object named **ama-metrics-hpa** in the kube-system namespace can be edited to update the min and max shards/replica set instances.
If the changes aren't within the supported range of 2 to 12 they are ineffective and fall back to the last known good.

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
If the default HPA settings don't meet the customer's requirements, they can configure the minimum and maximum number of shards to be the same.
This prevents the HPA from scaling the replicas based on varying loads, ensuring a consistent number of replicas.

Ex - If the customer wants to set the shards to 8 and not have the HPA update the shards, update the min and max shards to 8.

**Update Min and Max replicas**
```bash
kubectl patch hpa ama-metrics-hpa -n kube-system --type merge --patch '{"spec": {"minReplicas": 8, "maxReplicas": 8}}'
```

*A kubectl edit on the ama-metrics-hpa spec gives more information about the scale up and scale down configurations used for HPA*

## Next steps

* [Troubleshoot issues with Prometheus data collection](prometheus-metrics-troubleshoot.md).
