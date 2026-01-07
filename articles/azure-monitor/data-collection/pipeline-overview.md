---
title: Configure Azure Monitor pipeline 
description: Configuration of Azure Monitor pipeline for edge and multicloud scenarios
ms.topic: article
ms.date: 05/21/2025
ms.custom: references_regions, devx-track-azurecli
---


# Azure Monitor pipeline overview

The [Azure Monitor pipeline](data-collection-rule-overview.md#azure-monitor-pipeline) extends the data collection capabilities of Azure Monitor to edge and multicloud environments. It enables at-scale collection, and routing of telemetry data before it's sent to the cloud. The pipeline can cache data locally and sync with the cloud when connectivity is restored and route telemetry to Azure Monitor in cases where the network is segmented and data can't be sent directly to the cloud.

The Azure Monitor pipeline is a containerized solution that is deployed on an [Arc-enabled Kubernetes cluster](/azure/azure-arc/kubernetes/overview) and leverages OpenTelemetry Collector as a foundation. The following diagram shows the components of the pipeline. One or more data flows listen for incoming data from clients, and the pipeline extension forwards the data to the cloud, using the local cache if necessary.

The pipeline configuration file defines the data flows and cache properties for the pipeline. The [DCR](data-collection-rule-overview.md#using-a-dcr) defines the schema of the data being sent to the cloud, a transformation to filter or modify the data, and the destination where the data should be sent. Each data flow definition for the pipeline configuration specifies the DCR and stream within that DCR that will process that data in the cloud.


:::image type="content" source="media/edge-pipeline-configure/edge-pipeline-configuration.png" lightbox="media/edge-pipeline-configure/edge-pipeline-configuration.png" alt-text="Overview diagram of the dataflow for Azure Monitor pipeline." border="false"::: 

> [!NOTE]
> Private link is supported by Azure Monitor pipeline for the connection to the cloud.

The following components and configurations are required to enable the Azure Monitor pipeline. If you use the Azure portal to configure the pipeline, then each of these components is created for you. With other methods, you need to configure each one.

| Component | Description |
|:----------|:------------|
| Edge pipeline controller extension | Extension added to your Arc-enabled Kubernetes cluster to support pipeline functionality - `microsoft.monitor.pipelinecontroller`. |
| Edge pipeline controller instance | Instance of the pipeline running on your Arc-enabled Kubernetes cluster. |
| Data flow | Combination of receivers and exporters that run on the pipeline controller instance. Receivers accept data from clients, and exporters to deliver that data to Azure Monitor. |
| Pipeline configuration | Configuration file that defines the data flows for the pipeline instance. Each data flow includes a receiver and an exporter. The receiver listens for incoming data, and the exporter sends the data to the destination. |
| Data collection endpoint (DCE) | Endpoint where the data is sent to Azure Monitor in the cloud. The pipeline configuration includes a property for the URL of the DCE so the pipeline instance knows where to send the data. |

| Configuration | Description |
|:--------------|:------------|
| Data collection rule (DCR) | Configuration file that defines how the data is received by Azure Monitor and where it's sent. The DCR can also include a transformation to filter or modify the data before it's sent to the destination. |
| Pipeline configuration | Configuration that defines the data flows for the pipeline instance, including the data flows and cache. |

## Supported configurations

**Supported distros**

Azure Monitor pipeline is supported on the following Kubernetes distributions:

* Canonical
* Cluster API Provider for Azure
* K3
* Rancher Kubernetes Engine
* VMware Tanzu Kubernetes Grid

**Supported locations**

Azure Monitor pipeline is supported in the following Azure regions:

* Canada Central
* East US2
* Italy North
* West US2
* West Europe

For more information, see [Product availability by region](https://azure.microsoft.com/explore/global-infrastructure/products-by-region/table)


## Next steps

* [Read more about data collection rules (DCRs) in Azure Monitor](data-collection-rule-overview.md).
