---
title: Configure Azure Monitor pipeline 
description: Configuration of Azure Monitor pipeline for edge and multicloud scenarios
ms.topic: article
ms.date: 05/21/2025
ms.custom: references_regions, devx-track-azurecli
---


# Azure Monitor pipeline overview

The [Azure Monitor pipeline](data-collection-rule-overview.md#azure-monitor-pipeline) extends the data collection capabilities of Azure Monitor to edge and multicloud environments. It enables at-scale collection, and routing of telemetry data before it's sent to the cloud. The pipeline can cache data locally and sync with the cloud when connectivity is restored and route telemetry to Azure Monitor in cases where the network is segmented and data can't be sent directly to the cloud.

:::image type="content" source="./media/pipeline-overview/overview.png" lightbox="./media/pipeline-overview/overview.png" alt-text="Diagram that shows the data flow for Azure Monitor pipeline." border="false":::

## Use cases

Specific use cases for Azure Monitor pipeline are:

- **Scalability**. The pipeline can handle large volumes of data from monitored resources that may be limited by other collection methods such as Azure Monitor agent.
- **Periodic connectivity**. Some environments may have unreliable connectivity to the cloud, or may have long unexpected periods without connection. The pipeline can cache data locally and sync with the cloud when connectivity is restored.
- **Reduce network bandwidth**


## Implementation

The Azure Monitor pipeline is a containerized solution that is deployed on an [Arc-enabled Kubernetes cluster](/azure/azure-arc/kubernetes/overview) and leverages OpenTelemetry Collector as a foundation. 


## Next steps

* [Read more about data collection rules (DCRs) in Azure Monitor](data-collection-rule-overview.md).
