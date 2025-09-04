---
title: Remote-write in Azure Monitor Managed Service for Prometheus
description: Describes how to configure remote-write to send data from self-managed Prometheus running in your AKS cluster or Azure Arc-enabled Kubernetes cluster 
ms.topic: how-to
ms.date: 09/16/2024
---

# Connect self-managed Prometheus to Azure Monitor managed service for Prometheus
Azure Monitor managed service for Prometheus is intended to be a replacement for self managed Prometheus so you don't need to manage a Prometheus server in your Kubernetes clusters. There may be scenarios though where you want to continue to use self-managed Prometheus in your Kubernetes clusters while also sending data to Managed Prometheus for long term data retention and to create a centralized view across your clusters. This may be a temporary solution while you migrate to Managed Prometheus or a long term solution if you have specific requirements for self-managed Prometheus.


## Architecture
[Remote_write](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#remote_write) is a feature in Prometheus that allows you to send metrics from a local Prometheus instance to remote storage or to another Prometheus instance. Use this feature to send metrics from self-managed Prometheus running in your Kubernetes cluster to an Azure Monitor workspace used by Managed Prometheus.

The following diagram illustrates this strategy. A data collection rule (DCR) in Azure Monitor provides an endpoint for the self-managed Prometheus to send metrics to and defines the Azure Monitor workspace where the data will be sent.

:::image type="content" source="media/prometheus-remote-write/overview.png" alt-text="Diagram showing use of remote-write to send metrics from local Prometheus to Managed Prometheus." lightbox="media/prometheus-remote-write/overview.png"  border="false":::


## Authentication types
The configuration requirements for remote-write depend on the authentication type used to connect to the Azure Monitor workspace. The following table describes the supported authentication types. The details for each configuration are described in the linked articles.

| Type | Clusters supported | Configuration |
|:---|:---|:---|
| [Managed identity](./prometheus-remote-write-managed-identity.md) | Azure Kubernetes service (AKS)<br>Azure Arc-enabled Kubernetes cluster | Remote-write configuration added to self-managed Prometheus config. |
| [Microsoft Entra ID](./prometheus-remote-write-active-directory.md) | Azure Kubernetes service (AKS)<br>Azure Arc-enabled Kubernetes cluster<br>Cluster running in another cloud or on-premises. | Remote-write configuration added to self-managed Prometheus config. |
| [Microsoft Entra ID Workload Identity](./prometheus-remote-write-azure-workload-identity.md) | Recommended for AKS and Azure Arc-enabled Kubernetes cluster. | Azure Monitor [side car container](/azure/architecture/patterns/sidecar) required to provide an abstraction for ingesting Prometheus remote write metrics and helps in authenticating packets. |



## Release notes

For detailed release notes on the remote write side car image, please refer to the [remote write release notes](https://github.com/Azure/prometheus-collector/blob/main/REMOTE-WRITE-RELEASENOTES.md).


## Next steps

- [Learn more about Azure Monitor managed service for Prometheus](../essentials/prometheus-metrics-overview.md).
- [Collect Prometheus metrics from an AKS cluster](../containers/kubernetes-monitoring-enable.md)
