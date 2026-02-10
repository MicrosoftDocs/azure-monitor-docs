---
title: Configure Azure Monitor pipeline using the Azure portal
description: Use the Azure portal to configure Azure Monitor pipeline which extends Azure Monitor data collection into your data center.
ms.topic: how-to
ms.date: 01/15/2026
ms.custom: references_regions, devx-track-azurecli
---

# Configure Azure Monitor pipeline using the Azure portal

The [Azure Monitor pipeline](./pipeline-overview.md) extends the data collection capabilities of Azure Monitor to edge and multicloud environments. This article describes how to enable and configure the Azure Monitor pipeline using the Azure portal. Using this method, you don't need to understand the individual components that make up the pipeline, but you may need to use other methods for more advanced functionality such as enabling the cache. To use CLI or ARM templates to configure the pipeline, see [Configure Azure Monitor](./pipeline-configure.md).

## Prerequisites

See the prerequisites in [Configure Azure Monitor pipeline](./pipeline-configure.md#prerequisites) for details on the requirements for enabling and configuring the Azure Monitor pipeline.

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

The **Dataflow** tab allows you to create and edit dataflows for the pipeline instance. 

:::image type="content" source="./media/pipeline-configure/create-dataflow.png" lightbox="./media/pipeline-configure/create-dataflow.png" alt-text="Screenshot of Create add dataflow screen.":::

#### Standard tables
To send Syslog and CEF data to the standard Azure tables, select `Syslog` as the **Source type** and either `Syslog` or `CommonSecurityLog` as the **Table**. The incoming data is automatically converted to the appropriate format. If you want to filter data or perform any other data processing, select **Add Data Transformations**, and select an appropriate template. 

#### Custom tables  
To send data to a custom table, select `Syslog` or `OTLP` as the **Source type** and then specify a custom table name in the **Table Name** field. Select **Add Data Transformations**, and then add a transformation to convert the data to the desired format. See [Azure Monitor pipeline transformations](./pipeline-transformations.md) for details on creating transformations. 

#### Transformations
If you specify a transformation, click **Check KQL syntax** to validate the syntax of the query before saving the dataflow. For Syslog and CEF data, the checker will also verify that the data resulting from the transformation matches the schema of the data type. If the transformation renames or adds columns as part of an aggregation for example, you will be prompted to either remove those transformations or send the data to a custom table instead. An example is shown in the following image.

:::image type="content" source="./media/pipeline-configure/check-syntax.gif" lightbox="./media/pipeline-configure/check-syntax.gif" alt-text="Screenshot of KQL syntax checker and typical error message.":::

For `Syslog` and `CommonSecurityLog` tables, all appropriate columns will be available for the transformation. For custom tables, only `TimeGenerated`, `SeverityText`, `Body` columns are available. For other columns, you need to use an ARM template for the pipeline configuration. See [Pipeline configuration](./pipeline-configure.md#pipeline-configuration) for details.
 
> [!NOTE]
> See [Azure Monitor pipeline transformations](./pipeline-transformations.md) for details on creating transformations.

#### Dataflow settings

The settings in the **Dataflow** tab are described in the following table.

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





## Next steps

* [Configure clients](./pipeline-configure-clients.md) to use the pipeline.
* Modify data before it's sent to the cloud using [pipeline transformations](./pipeline-transformations.md).
