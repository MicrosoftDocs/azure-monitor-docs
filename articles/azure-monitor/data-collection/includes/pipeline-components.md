---
ms.topic: include
ms.date: 01-19-2026
---

## Components

The following diagram shows the components of the Azure Monitor pipeline. The pipeline itself runs on an Arc-enabled Kubernetes cluster in your environment. One or more data flows running in the pipeline listen for incoming data from clients, and the pipeline extension forwards the data to the cloud, using the local cache if necessary.

:::image type="content" source="../media/pipeline-configure/components.png" lightbox="../media/pipeline-configure/components.png" alt-text="Overview diagram of the components making up Azure Monitor pipeline." border="false"::: 

The following table identifies the components required to enable the Azure Monitor pipeline. If you use the Azure portal to configure the pipeline, then each of these components is created for you. With other methods, you need to configure each one.

| Component | Description |
|:----------|:------------|
| Pipeline controller extension | Extension added to your Arc-enabled Kubernetes cluster to support pipeline functionality - `microsoft.monitor.pipelinecontroller`. |
| Pipeline controller instance | Instance of the pipeline running on your Arc-enabled Kubernetes cluster. |
| Data flow | Combination of receivers and exporters that run on the pipeline controller instance. Receivers accept data from clients, and exporters to deliver that data to Azure Monitor. |
| Pipeline configuration | Configuration file that defines the data flows for the pipeline instance. Each data flow includes a receiver and an exporter. The receiver listens for incoming data, and the exporter sends the data to the destination. |
| Data collection endpoint (DCE) | Endpoint where the data is sent to Azure Monitor in the cloud. The pipeline configuration includes a property for the URL of the DCE so the pipeline instance knows where to send the data. |
| Pipeline configuration file | Used by the pipeline running in your data center. Defines the data flows for the pipeline instance, cache details, and pipeline transformation if included. |
| Data collection rule (DCR) | [DCR](../data-collection-rule-overview.md#using-a-dcr) used by Azure Monitor in the cloud to define how the data is received and where it's sent. The DCR can also include a transformation to filter or modify the data before it's sent to the destination. |