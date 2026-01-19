---
title: Configure Azure Monitor pipeline using the Azure portal
description: Use the Azure portal to configure Azure Monitor pipeline which extends Azure Monitor data collection into your own data center 
ms.topic: article
ms.date: 01/15/2026
ms.custom: references_regions, devx-track-azurecli
---

# Configure Azure Monitor pipeline using the Azure portal

The [Azure Monitor pipeline](./pipeline-overview.md) extends the data collection capabilities of Azure Monitor to edge and multicloud environments. This article describes how to enable and configure the Azure Monitor pipeline in your environment.

## Supported configurations

| Supported distros | Supported locations |
|:---|:---|
| - Canonical<br>- Cluster API Provider for Azure<br>- K3<br>- Rancher Kubernetes Engine<br>- VMware Tanzu Kubernetes Grid | - Canada Central<br>- East US2<br>- Italy North<br>- West US2<br>- West Europe<br><br>For more information, see [Product availability by region](https://azure.microsoft.com/explore/global-infrastructure/products-by-region/table) |



> [!NOTE]
> Private link is supported by Azure Monitor pipeline for the connection to the cloud.

## Prerequisites

* [Arc-enabled Kubernetes cluster](/azure/azure-arc/kubernetes/overview) in your own environment with an external IP address. See [Connect an existing Kubernetes cluster to Azure Arc](/azure/azure-arc/kubernetes/quickstart-connect-cluster) for details on enabling Arc for a cluster.
* The Arc-enabled Kubernetes cluster must have the custom locations features enabled. See [Create and manage custom locations on Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/custom-locations#enable-custom-locations-on-your-cluster).
* Log Analytics workspace in Azure Monitor to receive the data from the pipeline. See [Create a Log Analytics workspace in the Azure portal](../logs/quick-create-workspace.md) for details on creating a workspace.
* The following resource providers must be registered in your Azure subscription. See [Azure resource providers and types](/azure/azure-resource-manager/management/resource-providers-and-types).
    * Microsoft.Insights
    * Microsoft.Monitor 


## Create table in Log Analytics workspace

Before you configure the data collection process for the pipeline, any destination tables in the Log Analytics workspace must already exist. If you're sending to a custom table, then you need to create that table before you can create any data flows that send to it. The schema of the table must match the data that it receives, but there are multiple steps in the collection process where you can modify the incoming data, so the table schema doesn't need to match the source data that you're collecting. The only requirement for the table in the Log Analytics workspace is that it has a `TimeGenerated` column.

See [Add or delete tables and columns in Azure Monitor Logs](../logs/create-custom-table.md) for details on different methods for creating a table. For example, use the CLI command below to create a table with the three columns called `Body`, `TimeGenerated`, and `SeverityText`.

```azurecli
az monitor log-analytics workspace table create --workspace-name my-workspace --resource-group my-resource-group --name my-table_CL --columns TimeGenerated=datetime Body=string SeverityText=string
```

## Create pipeline and data flows

When you use the Azure portal to enable and configure the pipeline, all required components are created based on your selections. This saves you from the complexity of creating each component individually, but you made need to use other methods for more advanced functionality and configuration.

Perform one of the following in the Azure portal to launch the installation process for the Azure Monitor pipeline:

* From the **Azure Monitor pipelines (preview)** menu, click **Create**. 
* From the menu for your Arc-enabled Kubernetes cluster, select **Extensions** and then add the **Azure Monitor pipeline extension (preview)** extension.

### Basics tab

The **Basic** tab prompts you for the following information to deploy the extension and pipeline instance on your cluster.

:::image type="content" source="./media/pipeline-configure/create-pipeline.png" lightbox="./media/pipeline-configure/create-pipeline.png" alt-text="Screenshot of Create Azure Monitor pipeline screen.":::

The settings in this tab are described in the following table.

| Property | Description |
|:---------|:------------|
| Instance name | Name for the Azure Monitor pipeline instance. Must be unique for the subscription. |
| Subscription | Azure subscription to create the pipeline instance. |
| Resource group | Resource group to create the pipeline instance. |
| Cluster name | Select your Arc-enabled Kubernetes cluster that the pipeline will be installed on. |
| Custom Location | Custom location for your Arc-enabled Kubernetes cluster. This will be automatically populated with the name of a custom location that will be created for your cluster or you can select another custom location in the cluster. |

### Dataflow tab

The **Dataflow** tab allows you to create and edit dataflows for the pipeline instance. Each dataflow includes the following details:

:::image type="content" source="./media/pipeline-configure/create-dataflow.png" lightbox="./media/pipeline-configure/create-dataflow.png" alt-text="Screenshot of Create add dataflow screen.":::

The settings in this tab are described in the following table.

| Property | Description |
|:---------|:------------|
| Name | Name for the dataflow. Must be unique for this pipeline. |
| Source type | The type of data being collected. The following source types are currently supported:<br>- Syslog<br>- OTLP |
| Port | Port that the pipeline listens on for incoming data. If two dataflows use the same port, they both receive and process the data. |
| Protocol<br>(Syslog only) | Specify whether the dataflow should collect TCP or UDP traffic. |
| RFC<br>(Syslog only) | Specify which Syslog message format the dataflow will collect. 5424 is the newer, more structured format. 3164 is the older, less structured format. |
| Collect messages with PRI header<br>(Syslog only) | Select this checkbox to collect Syslog messages that don't include the PRI header. This is a calculated value detailing the message's severity level and facility based on a fixed formula. Some devices do not send this header attached to the message. |
| Log Analytics Workspace | Log Analytics workspace to send the data to. |
| Table<br>(Syslog only) | Specify whether data will be sent to the [Syslog]() table, the [CommonSecurityLog]() table, or a custom table. <sup>1</sup> |
| Table Name | The name of the table in the Log Analytics workspace to send the data to. Must be the same as **Table** if `Syslog` or `CommonSecurityLog` <sup>1</sup> |
| Add Data Transformations | Enable to add a transformation to the dataflow. See [Azure Monitor pipeline transformations](./pipeline-transformations.md). |


> [!IMPORTANT]
> The send data to either of the following two built-in tables, the Log Analytics workspace must be onboarded to Microsoft Sentinel. You can send data to custom tables without onboarding to Microsoft Sentinel.
> 
> - [Syslog](/azure/azure-monitor/reference/tables/syslog)
> - [CommonSecurityLog](/azure/azure-monitor/reference/tables/commonsecuritylog)



## Enable cache

Edge devices in some environments may experience intermittent connectivity due to various factors such as network congestion, signal interference, power outage, or mobility. In these environments, you can configure the pipeline to cache data by creating a [persistent volume](https://kubernetes.io) in your cluster. The process for this will vary based on your particular environment, but the configuration must meet the following requirements:

* Metadata namespace must be the same as the specified instance of Azure Monitor pipeline.
* Access mode must support `ReadWriteMany`.

Once the volume is created in the appropriate namespace, configure it using parameters in the pipeline configuration file below.

> [!CAUTION]
> Each replica of the pipeline stores data in a location in the persistent volume specific to that replica. Decreasing the number of replicas while the cluster is disconnected from the cloud will prevent that data from being backfilled when connectivity is restored.

Data is retrieved from the cache using first-in-first-out (FIFO). Any data older than 48 hours will be discarded.


## Verify configuration

### Verify pipeline components running in the cluster

In the Azure portal, navigate to the **Kubernetes services** menu and select your Arc-enabled Kubernetes cluster. Select **Services and ingresses** and ensure that you see the following services:

* \<pipeline name\>-external-service
* \<pipeline name\>-service

:::image type="content" source="./media/pipeline-configure/pipeline-cluster-components.png" lightbox="./media/pipeline-configure/pipeline-cluster-components.png" alt-text="Screenshot of cluster components supporting Azure Monitor pipeline."::: 

Click on the entry for **\<pipeline name\>-external-service** and note the IP address and port in the **Endpoints** column. This is the external IP address and port that your clients will send data to. See [Retrieve ingress endpoint](#retrieve-ingress-endpoint) for retrieving this address from the client.

### Verify heartbeat

Each pipeline configured in your pipeline instance will send a heartbeat record to the `Heartbeat` table in your Log Analytics workspace every minute. The contents of the `OSMajorVersion` column should match the name your pipeline instance. If there are multiple workspaces in the pipeline instance, then the first one configured will be used.

Retrieve the heartbeat records using a log query as in the following example:

:::image type="content" source="./media/pipeline-configure/heartbeat-records.png" lightbox="./media/pipeline-configure/heartbeat-records.png" alt-text="Screenshot of log query that returns heartbeat records for Azure Monitor pipeline.":::

## Client configuration

Once your pipeline extension and instance are installed, then you need to configure your clients to send data to the pipeline.

### Retrieve ingress endpoint

Each client requires the external IP address of the Azure Monitor pipeline service. Use the following command to retrieve this address:

```azurecli
kubectl get services -n <namespace where azure monitor pipeline was installed>
```

* If the application producing logs is external to the cluster, copy the *external-ip* value of the service *\<pipeline name\>-service* or *\<pipeline name\>-external-service* with the load balancer type.
* If the application is on a pod within the cluster, copy the *cluster-ip* value. 

> [!NOTE]
> If the external-ip field is set to *pending*, you need to configure an external IP for this ingress manually according to your cluster configuration.

| Client | Description |
|:-------|:------------|
| Syslog | Update Syslog clients to send data to the pipeline endpoint and the port of your Syslog dataflow. |
| OTLP | The Azure Monitor pipeline exposes a gRPC-based OTLP endpoint on port 4317. Configuring your instrumentation to send to this OTLP endpoint will depend on the instrumentation library itself. See [OTLP endpoint or Collector](https://opentelemetry.io/docs/instrumentation/python/exporters/#otlp-endpoint-or-collector) for OpenTelemetry documentation. The environment variable method is documented at [OTLP Exporter Configuration](https://opentelemetry.io/docs/concepts/sdk-configuration/otlp-exporter-configuration/). |

## Verify data

The final step is to verify that the data is received in the Log Analytics workspace. You can perform this verification by running a query in the Log Analytics workspace to retrieve data from the table.

:::image type="content" source="./media/pipeline-configure/log-results-syslog.png" lightbox="./media/pipeline-configure/log-results-syslog.png" alt-text="Screenshot of log query that returns of Syslog collection."::: 

## Next steps

* Modify data before it's sent to the cloud using [pipeline transformations](./pipeline-transformations.md).
