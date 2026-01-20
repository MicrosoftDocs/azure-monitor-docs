---
title: Configure Azure Monitor pipeline using the Azure portal
description: Use the Azure portal to configure Azure Monitor pipeline which extends Azure Monitor data collection into your data center.
ms.topic: how-to
ms.date: 01/15/2026
ms.custom: references_regions, devx-track-azurecli
---

# Configure Azure Monitor pipeline using the Azure portal

The [Azure Monitor pipeline](./pipeline-overview.md) extends the data collection capabilities of Azure Monitor to edge and multicloud environments. This article describes how to enable and configure the Azure Monitor pipeline in your environment. 

## Prerequisites

For prerequisites and an overview of the pipeline and its components, see [Azure Monitor pipeline overview](./pipeline-overview.md).

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

[!INCLUDE [pipeline-verify-configuration](includes/pipeline-verify-configuration.md)]



## Next steps

* [Configure clients](./pipeline-configure-clients.md) to use the pipeline.
* Modify data before it's sent to the cloud using [pipeline transformations](./pipeline-transformations.md).
