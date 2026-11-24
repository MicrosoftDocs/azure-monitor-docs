---
title: Manage a legacy Azure Monitor pipeline deployment in the Azure portal
description: Use the Azure portal to manage an existing Azure Monitor pipeline deployment that uses the legacy PipelineGroup configuration model.
ai-usage: ai-assisted
ms.topic: how-to
ms.date: 11/23/2026
ms.custom: references_regions, devx-track-azurecli
---

# Manage a legacy Azure Monitor pipeline deployment in the Azure portal

> [!IMPORTANT]
> Use this article only to manage an existing deployment. For all new Azure Monitor pipeline deployments, use [DCR-based configuration](./pipeline-configure-cli.md). Don't create a new PipelineGroup deployment in the Azure portal.

The portal experience uses the `microsoft.monitor.pipelinecontroller` extension and the legacy PipelineGroup configuration model. For automation of this configuration model, use the [legacy CLI and ARM template procedures](./pipeline-configure-legacy.md#legacy-cli).

> [!NOTE]
> DCR-based configuration and native OpenTelemetry logs, metrics, and traces are available in preview through Azure CLI or ARM templates, not through this portal experience.

## Identify a legacy portal deployment

Use the [extension check](./pipeline-configure-legacy.md#check-the-installed-extension) to confirm that the existing deployment runs the `microsoft.monitor.pipelinecontroller` extension. If it runs `microsoft.monitor.pipeline`, manage it through its DCRs instead of this portal experience.

In the Azure portal, locate the existing deployment under **Azure Monitor pipelines** or under **Extensions** on its Arc-enabled Kubernetes cluster.

## Review basic settings

Portal-created legacy deployments include the following basic settings.

:::image type="content" source="./media/pipeline-configure/create-pipeline.png" lightbox="./media/pipeline-configure/create-pipeline.png" alt-text="Screenshot of the Create Azure Monitor pipeline screen.":::

| Property | Description |
|:---------|:------------|
| Instance name | Name for the Azure Monitor pipeline instance. Must be unique in the subscription. |
| Subscription | Azure subscription where the service creates the pipeline instance. |
| Resource group | Resource group where the service creates the pipeline instance. |
| Cluster name | Arc-enabled Kubernetes cluster where you install the pipeline. |
| Custom location | Custom location for the Arc-enabled Kubernetes cluster. This value is autopopulated if a custom location is created for the cluster, or you optionally select another custom location on the cluster. |
| Enable transport security (TLS) | Deploy the pipeline endpoints with TLS enabled so incoming traffic is encrypted in transit. This setting configures the deployment mode only. After deployment, complete the TLS configuration to choose the certificate management approach and TLS mode. For more information, see [Configure TLS](./pipeline-configure-legacy.md#legacy-tls). |
| Require client authentication within cluster | Require gateway and cluster-local clients to present client certificates when they connect to the pipeline. Use this option when you want mutual TLS (mTLS) for in-cluster or gateway-to-pipeline connections. |

## Review dataflows

Each dataflow in an existing portal deployment includes the following settings.

:::image type="content" source="./media/pipeline-configure/create-dataflow.png" lightbox="./media/pipeline-configure/create-dataflow.png" alt-text="Screenshot of the Add dataflow screen.":::

| Property | Description |
|:---------|:------------|
| Name | Name for the dataflow. Must be unique for this pipeline. |
| Source type | Type of data to collect. Supported values are `Syslog` and `OTLP` (preview). The OTLP source receives logs for a custom table. |
| Port | Port that the pipeline listens on for incoming data. If two dataflows use the same port, they both receive and process the data. |
| Protocol<br>(Syslog only) | Whether the dataflow collects TCP or UDP traffic. |
| Format<br>(Syslog only) | Syslog message formats to collect. `5424` is the newer structured format. `3164` is the older, less structured format. |
| Collect messages with PRI header<br>(Syslog only) | Collect Syslog messages that don't include the PRI header. |
| Log Analytics workspace | Log Analytics workspace that receives the data. |
| Table<br>(Syslog only) | Destination table. Select [Syslog](/azure/azure-monitor/reference/tables/syslog), [CommonSecurityLog](/azure/azure-monitor/reference/tables/commonsecuritylog), or a custom table. |
| Table name | Table name in the Log Analytics workspace. Must match **Table** when the destination is `Syslog` or `CommonSecurityLog`. |
| Add Data Transformations | Add a transformation to the dataflow. See [PipelineGroup transformations](./pipeline-configure-legacy.md#legacy-transformations). |

### Choose a destination table

Choose the destination table based on the data that you want to collect.

- To send Syslog or CEF data to standard Azure Monitor tables, select `Syslog` as the **Source type**, and then select `Syslog` or `CommonSecurityLog` as the **Table**. The incoming data is converted automatically to the required format.
- To send data to a custom table, select `Syslog` or `OTLP` as the **Source type**, and then specify a custom table name in the **Table name** field. Add a transformation to shape the incoming data to match the custom table schema. See [PipelineGroup transformations](./pipeline-configure-legacy.md#legacy-transformations).

### Add transformations

If you specify a transformation, select **Check KQL syntax** before saving the dataflow. For Syslog and CEF data, the validator also checks whether the transformed output matches the destination table schema. If the transformation renames columns or adds columns as part of an aggregation, send the data to a custom table instead. See [PipelineGroup transformations](./pipeline-configure-legacy.md#legacy-transformations) for details on transformations.

:::image type="content" source="./media/pipeline-configure/check-syntax.gif" lightbox="./media/pipeline-configure/check-syntax.gif" alt-text="Screenshot of the KQL syntax checker and a typical error message.":::

For `Syslog` and `CommonSecurityLog`, the transformation has access to the appropriate table columns. For custom tables, the portal experience provides access to only `TimeGenerated`, `SeverityText`, and `Body`. If you need other columns, use the [PipelineGroup CLI and ARM template procedures](./pipeline-configure-legacy.md#legacy-cli).


> [!NOTE]
> For details on creating transformations, see [PipelineGroup transformations](./pipeline-configure-legacy.md#legacy-transformations).


## Verify an existing deployment

Use the [legacy verification steps](./pipeline-configure-legacy.md#legacy-setup-verify-the-configuration) to confirm that the pipeline components are running and that data is reaching your Log Analytics workspace.

## Related articles

- [Configure a Kubernetes gateway](./pipeline-configure-legacy.md#legacy-gateway) to expose the pipeline to external clients.
- [Configure TLS](./pipeline-configure-legacy.md#legacy-tls) to encrypt incoming traffic.
- [Modify data before it's sent to the cloud](./pipeline-configure-legacy.md#legacy-transformations).
- [Set up a gateway](./pipeline-configure-legacy.md#legacy-gateway) for clients outside the cluster.
- [Configure PipelineGroup with CLI or ARM templates](./pipeline-configure-legacy.md#legacy-cli) for automation and advanced scenarios.
