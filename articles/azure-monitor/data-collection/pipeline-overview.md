---
title: Azure Monitor pipeline overview
description: Overview of the Azure Monitor pipeline which extends Azure Monitor data collection into your own data center 
ms.topic: article
ms.date: 01/15/2026
ms.custom: references_regions, devx-track-azurecli
---


# Azure Monitor pipeline overview

The Azure Monitor pipeline extends the data collection capabilities of Azure Monitor to your local data center and multicloud environments. It enables at-scale collection, transformation, and routing of telemetry data before it's sent to the Azure Monitor in the cloud. The pipeline can cache data locally and sync with the cloud when connectivity is restored and route telemetry to Azure Monitor in cases where clients can't send data directly to the cloud.

:::image type="content" source="./media/pipeline-overview/overview.png" lightbox="./media/pipeline-overview/overview.png" alt-text="Diagram that shows the data flow for Azure Monitor pipeline." border="false":::

## Use cases

Specific use cases for Azure Monitor pipeline include the following:

- **Scalability**. The pipeline can handle large volumes of data from monitored resources that may be limited by other collection methods such as Azure Monitor agent.
- **Periodic connectivity**. Some environments may have unreliable connectivity to the cloud or long unexpected periods without connection. There may also be periods of planned maintenance or need to temporarily disconnect from internet for security reasons. The pipeline can cache data locally and sync with the cloud when connectivity is restored.
- **Reduce network bandwidth**. Transformations in Azure Monitor pipeline can filter and aggregate data before it's sent to the cloud, reducing the amount of data transmitted over the network.


## Implementation

The Azure Monitor pipeline is a containerized solution that is deployed on an [Arc-enabled Kubernetes cluster](/azure/azure-arc/kubernetes/overview) located in your local data center or another cloud provider. It leverages OpenTelemetry Collector as a foundation and consists of multiple components that work together to collect, process, and transmit telemetry data to Azure Monitor in the cloud. Configuration in the pipeline determines the data collected from the local clients and how it's processed before being sent to Azure Monitor. Configuration in Azure Monitor understands the data being delivered from the pipeline and how it's processed and stored in a Log Analytics workspace.

## Supported configurations

| Supported distros | Supported locations |
|:---|:---|
| - Canonical<br>- Cluster API Provider for Azure<br>- K3<br>- Rancher Kubernetes Engine<br>- VMware Tanzu Kubernetes Grid | - Canada Central<br>- East US2<br>- Italy North<br>- West US2<br>- West Europe<br> |

For more information, see [Product availability by region](https://azure.microsoft.com/explore/global-infrastructure/products-by-region/table)



## Next steps

* [Configure Azure Monitor pipeline](./pipeline-configure.md) on your Arc-enabled cluster.
* Modify data before it's sent to the cloud using [pipeline transformations](./pipeline-transformations.md).
* Use [pod placement](./pipeline-pod-placement.md) to manage resource utilization on your Kubernetes cluster.
* Secure the connection from your pipeline to Azure Monitor by [configuring TLS](./pipeline-tls.md).
