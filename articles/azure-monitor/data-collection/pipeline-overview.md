---
title: Configure Azure Monitor pipeline 
description: Configuration of Azure Monitor pipeline for edge and multicloud scenarios
ms.topic: article
ms.date: 05/21/2025
ms.custom: references_regions, devx-track-azurecli
---


# Azure Monitor pipeline overview

The [Azure Monitor pipeline](data-collection-rule-overview.md#azure-monitor-pipeline) extends the data collection capabilities of Azure Monitor to edge and multicloud environments. It enables at-scale collection, and routing of telemetry data before it's sent to the cloud. The pipeline can cache data locally and sync with the cloud when connectivity is restored and route telemetry to Azure Monitor in cases where the network is segmented and data can't be sent directly to the cloud.

## Use cases

Specific use cases for Azure Monitor pipeline are:

* **Scalability**. The pipeline can handle large volumes of data from monitored resources that may be limited by other collection methods such as Azure Monitor agent.
* **Periodic connectivity**. Some environments may have unreliable connectivity to the cloud, or may have long unexpected periods without connection. The pipeline can cache data locally and sync with the cloud when connectivity is restored.
* **Layered network**. In some environments, the network is segmented and data can't be sent directly to the cloud. The pipeline can be used to collect data from monitored resources without cloud access and manage the connection to Azure Monitor in the cloud.

:::image type="content" source="media/data-collection-rule-overview/azure-monitor-pipeline-edge.png" lightbox="media/data-collection-rule-overview/azure-monitor-pipeline-edge.png" alt-text="Diagram that shows the data flow for Azure Monitor edge pipeline." border="false":::


## Implementation

The Azure Monitor pipeline is a containerized solution that is deployed on an [Arc-enabled Kubernetes cluster](/azure/azure-arc/kubernetes/overview) and leverages OpenTelemetry Collector as a foundation. 


## Segmented network

[Network segmentation](/azure/architecture/networking/guide/network-level-segmentation) is a model where you use software defined perimeters to create a different security posture for different parts of your network. In this model, you may have a network segment that can't connect to the internet or to other network segments. The Azure Monitor pipeline can be used to collect data from these network segments and send it to the cloud.

:::image type="content" source="media/edge-pipeline-configure/layered-network.png" lightbox="media/edge-pipeline-configure/layered-network.png" alt-text="Diagram of a layered network for Azure Monitor pipeline." border="false":::



## Next steps

* [Read more about data collection rules (DCRs) in Azure Monitor](data-collection-rule-overview.md).
