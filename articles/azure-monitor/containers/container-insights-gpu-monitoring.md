---
title: Configure GPU monitoring with Container insights
description: This article describes how you can configure monitoring Kubernetes clusters with NVIDIA and AMD GPU enabled nodes with Container insights.
ms.topic: concept-article
ms.date: 02/18/2025
ms.reviewer: aul
---

# Configure GPU monitoring with Container insights and/or Managed Prometheus

Container insights supports monitoring GPU clusters from the following GPU vendors:

- [NVIDIA](https://developer.nvidia.com/kubernetes-gpu)
- [AMD](https://github.com/RadeonOpenCompute/k8s-device-plugin)

>[!NOTE]
>If you are using **[Nvidia DCGM exporter](https://docs.nvidia.com/datacenter/cloud-native/gpu-telemetry/latest/dcgm-exporter.html)**, you can enable GPU monitoring with Managed Prometheus and Managed Grafana. For details on the setup and instructions, please see [Enable GPU monitoring with Nvidia DCGM exporter](./prometheus-dcgm-integration.md).

Container insights automatically starts monitoring GPU usage on nodes and GPU requesting pods and workloads by collecting the following metrics at 60-second intervals and storing them in the **InsightMetrics** table.

>[!CAUTION]
>This method is no longer recommended for collecting GPU metrics.

>[!NOTE]
>After you provision clusters with GPU nodes, ensure that the [GPU driver](/azure/aks/gpu-cluster) is installed as required by Azure Kubernetes Service (AKS) to run GPU workloads. Container insights collect GPU metrics through GPU driver pods running in the node.

|Metric name |Metric dimension (tags) |Description |
|------------|------------------------|------------|
|containerGpuLimits |container.azm.ms/clusterId, container.azm.ms/clusterName, containerName |Each container can specify limits as one or more GPUs. It isn't possible to request or limit a fraction of a GPU. |
|containerGpuRequests |container.azm.ms/clusterId, container.azm.ms/clusterName, containerName |Each container can request one or more GPUs. It isn't possible to request or limit a fraction of a GPU.|
|nodeGpuAllocatable |container.azm.ms/clusterId, container.azm.ms/clusterName, gpuVendor |Number of GPUs in a node that can be used by Kubernetes. |
|nodeGpuCapacity |container.azm.ms/clusterId, container.azm.ms/clusterName, gpuVendor |Total number of GPUs in a node. |

## GPU performance charts

Container insights includes preconfigured charts for the metrics listed earlier in the table as a GPU workbook for every cluster. For a description of the workbooks available for Container insights, see [Workbooks in Container insights](./kubernetes-workbooks.md).

## Next steps

- See [Use GPUs for compute-intensive workloads on Azure Kubernetes Service](/azure/aks/gpu-cluster) to learn how to deploy an AKS cluster that includes GPU-enabled nodes.
- Learn more about [GPU optimized VM SKUs in Azure](/azure/virtual-machines/sizes-gpu).
- Review [GPU support in Kubernetes](https://kubernetes.io/docs/tasks/manage-gpus/scheduling-gpus/) to learn more about Kubernetes experimental support for managing GPUs across one or more nodes in a cluster.
