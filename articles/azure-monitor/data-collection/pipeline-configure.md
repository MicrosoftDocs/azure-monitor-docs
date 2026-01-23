---
title: Configure Azure Monitor pipeline
description: Configure Azure Monitor pipeline which extends Azure Monitor data collection into your data center.
ms.topic: how-to
ms.date: 01/15/2026
ms.custom: references_regions, devx-track-azurecli
---

# Configure Azure Monitor pipeline

The [Azure Monitor pipeline](./pipeline-overview.md) extends the data collection capabilities of Azure Monitor to edge and multicloud environments. This article provides details on enabling and configuring the Azure Monitor pipeline in your environment. Depending on the method you use, you may not require all the details in this article. 

## Configuration methods
The actual configuration steps vary depending on the method you use to configure the Azure Monitor pipeline. See the following articles for detailed steps to configure the Azure Monitor pipeline for each available method:

- [Azure portal](./pipeline-configure-portal.md)
- [CLI](./pipeline-configure-cli.md)
- [ARM template](./pipeline-configure-template.md)


## Supported configurations

| Supported distros | Supported locations |
|:---|:---|
| - Canonical<br>- Cluster API Provider for Azure<br>- K3<br>- Rancher Kubernetes Engine<br>- VMware Tanzu Kubernetes Grid | - Canada Central<br>- East US2<br>- Italy North<br>- West US2<br>- West Europe<br> |

For more information, see [Product availability by region](https://azure.microsoft.com/explore/global-infrastructure/products-by-region/table)

## Prerequisites

* [Arc-enabled Kubernetes cluster](/azure/azure-arc/kubernetes/overview) in your own environment with an external IP address. See [Connect an existing Kubernetes cluster to Azure Arc](/azure/azure-arc/kubernetes/quickstart-connect-cluster) for details on enabling Arc for a cluster.
* The Arc-enabled Kubernetes cluster must have the custom locations features enabled. See [Create and manage custom locations on Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/custom-locations#enable-custom-locations-on-your-cluster).
* Log Analytics workspace in Azure Monitor to receive the data from the pipeline. See [Create a Log Analytics workspace in the Azure portal](../logs/quick-create-workspace.md) for details on creating a workspace.
* The following resource providers must be registered in your Azure subscription. See [Azure resource providers and types](/azure/azure-resource-manager/management/resource-providers-and-types).
    * Microsoft.Insights
    * Microsoft.Monitor 

## Components

The following diagram shows the components of the Azure Monitor pipeline. The pipeline itself runs on an Arc-enabled Kubernetes cluster in your environment. One or more data flows running in the pipeline listen for incoming data from clients, and the pipeline extension forwards the data to the cloud, using the local cache if necessary.

:::image type="content" source="./media/pipeline-configure/components.png" lightbox="./media/pipeline-configure/components.png" alt-text="Overview diagram of the components making up Azure Monitor pipeline." border="false"::: 

The following table identifies the components required to enable the Azure Monitor pipeline. If you use the Azure portal to configure the pipeline, then each of these components is created for you. With other methods, you need to configure each one.

| Component | Description |
|:----------|:------------|
| Pipeline controller extension | Extension added to your Arc-enabled Kubernetes cluster to support pipeline functionality - `microsoft.monitor.pipelinecontroller`. |
| Pipeline controller instance | Instance of the pipeline running on your Arc-enabled Kubernetes cluster. |
| Data flow | Combination of receivers and exporters that run on the pipeline controller instance. Receivers accept data from clients, and exporters to deliver that data to Azure Monitor. |
| Pipeline configuration | Configuration file that defines the data flows for the pipeline instance. Each data flow includes a receiver and an exporter. The receiver listens for incoming data, and the exporter sends the data to the destination. |
| Data collection endpoint (DCE) | Endpoint where the data is sent to Azure Monitor in the cloud. The pipeline configuration includes a property for the URL of the DCE so the pipeline instance knows where to send the data. |
| Pipeline configuration file | Used by the pipeline running in your data center. Defines the data flows for the pipeline instance, cache details, and pipeline transformation if included. |
| Data collection rule (DCR) | [DCR](./data-collection-rule-overview.md#using-a-dcr) used by Azure Monitor in the cloud to define how the data is received and where it's sent. The DCR can also include a transformation to filter or modify the data before it's sent to the destination. |

## Log Analytics workspace tables

Before you configure the data collection process for the pipeline, any destination tables in the Log Analytics workspace must already exist. 

### Standard tables
Azure Monitor pipeline can send data to the following built-in tables in a Log Analytics workspace:

> [!IMPORTANT]
> The send data to either of the following two built-in tables, the Log Analytics workspace must be onboarded to Microsoft Sentinel. You can send data to custom tables without onboarding to Microsoft Sentinel.
> 
> - [Syslog](/azure/azure-monitor/reference/tables/syslog)
> - [CommonSecurityLog](/azure/azure-monitor/reference/tables/commonsecuritylog)



If you're sending data to a custom table, then you need to create that table before you can create any data flows that send to it. The schema of the table must match the data that it receives. There are multiple steps in the collection process where you can modify the incoming data, so the table schema doesn't need to match the source data that you're collecting. The only requirement for the table in the Log Analytics workspace is that it has a `TimeGenerated` column.

See [Add or delete tables and columns in Azure Monitor Logs](../logs/create-custom-table.md) for details on different methods for creating a table. For example, use the CLI command below to create a table with the three columns called `Body`, `TimeGenerated`, and `SeverityText`.

```azurecli
az monitor log-analytics workspace table create --workspace-name my-workspace --resource-group my-resource-group --name OTelLogs_CL --columns TimeGenerated=datetime Body=string SeverityText=string
```



## Enable cache

Edge devices in some environments may experience intermittent connectivity due to various factors such as network congestion, signal interference, power outage, or mobility. In these environments, you can configure the pipeline to cache data by creating a [persistent volume](https://kubernetes.io) in your cluster. The process for this will vary based on your particular environment, but the configuration must meet the following requirements:

* Metadata namespace must be the same as the specified instance of Azure Monitor pipeline.
* Access mode must support `ReadWriteMany`.

Once the volume is created in the appropriate namespace, configure it using parameters in the pipeline configuration file. Data is retrieved from the cache using first-in-first-out (FIFO). Any data older than 48 hours will be discarded.

> [!CAUTION]
> Each replica of the pipeline stores data in a location in the persistent volume specific to that replica. Decreasing the number of replicas while the cluster is disconnected from the cloud will prevent that data from being backfilled when connectivity is restored.



## Workflow

While you don't need a detail understanding of the different steps performed by the Azure Monitor pipeline to configure it, such an understanding can help to perform more advanced configuration such as transforming the data before it's stored in its destination.

The following tables and diagrams describe the detailed steps and components in the process for collecting data using the pipeline and passing it to the cloud for storage in Azure Monitor. 

| Step | Action | Supporting configuration |
|:-----|:-------|:-------------------------|
| 1. | Client sends data to the pipeline receiver. | Client is configured with IP and port of the pipeline receiver and sends data in the expected format for the receiver type. |
| 2. | Receiver forwards data to the exporter. | Receiver and exporter are configured in the same pipeline. |
| 3. | Optional pipeline transformation is applied to the data. | The data flow may include a transformation that filters or modifies the data before it's sent to Azure Monitor. The output of the transformation must match the schema expected by the DCR. |
| 4. | Exporter tries to send the data to the cloud. | Exporter in the pipeline configuration includes URL of the DCE, a unique identifier for the DCR, and the stream in the DCR that defines how the data will be processed. |
| 4a. | Exporter stores data in the local cache if it can't connect to the DCE. | Persistent volume for the cache and configuration of the local cache is enabled in the pipeline configuration. |

:::image type="content" source="./media/pipeline-configure/pipeline-data-flow.png" lightbox="./media/pipeline-configure/pipeline-data-flow.png" alt-text="Detailed diagram of the steps and components for data collection using Azure Monitor pipeline." border="false":::

| Step | Action | Supporting configuration |
|:-----|:-------|:-------------------------|
| 5. | Azure Monitor accepts the incoming data. | The DCR includes a schema definition for the incoming stream that must match the schema of the data coming from the pipeline. |
| 6. | Optional transformation applied to the data. | The DCR may include a transformation that filters or modifies the data before it's sent to the destination. The output of the transformation must match the schema of the destination table. |
| 7. | Azure Monitor sends the data to the destination. | The DCR includes a destination that specifies the Log Analytics workspace and table where the data will be stored. |

:::image type="content" source="./media/pipeline-configure/cloud-data-flow.png" lightbox="./media/pipeline-configure/cloud-data-flow.png" alt-text="Detailed diagram of the steps and components for data collection using Azure Monitor." border="false":::


## Verify configuration
Once you've complete the configuration using your chosen method, use the following steps verify that the pipeline is running correctly in your environment.

### Verify pipeline components running in the cluster

In the Azure portal, navigate to the **Kubernetes services** menu and select your Arc-enabled Kubernetes cluster. Select **Services and ingresses** and ensure that you see the following services:

* \<pipeline name\>-external-service
* \<pipeline name\>-service

:::image type="content" source="./media/pipeline-configure/pipeline-cluster-components.png" lightbox="./media/pipeline-configure/pipeline-cluster-components.png" alt-text="Screenshot of cluster components supporting Azure Monitor pipeline."::: 

Click on the entry for **\<pipeline name\>-external-service** and note the IP address and port in the **Endpoints** column. This is the external IP address and port that your clients will send data to. See [Retrieve ingress endpoint](./pipeline-configure-clients.md#retrieve-ingress-endpoint) for retrieving this address from the client.

### Verify heartbeat

Each pipeline configured in your pipeline instance will send a heartbeat record to the `Heartbeat` table in your Log Analytics workspace every minute. The contents of the `OSMajorVersion` column should match the name your pipeline instance. If there are multiple workspaces in the pipeline instance, then the first one configured will be used.

Retrieve the heartbeat records using a log query as in the following example:

:::image type="content" source="./media/pipeline-configure/heartbeat-records.png" lightbox="./media/pipeline-configure/heartbeat-records.png" alt-text="Screenshot of log query that returns heartbeat records for Azure Monitor pipeline.":::



## Next steps

* [Configure clients](./pipeline-configure-clients.md) to use the pipeline.
* Modify data before it's sent to the cloud using [pipeline transformations](./pipeline-transformations.md).
