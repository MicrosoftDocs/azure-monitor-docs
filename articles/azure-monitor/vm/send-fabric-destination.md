---
title: Send data to Fabric and Azure Data Explorer (Preview)
description: This article describes how to use Azure Monitor Agent to upload data to Azure Data Explorer and Fabric.
ms.topic: how-to
ms.date: 10/30/2025
ms.reviewer: aprilbadger
# Customer intent: As a Azure architect or administrator, I want to send VM data to Azure Data Explorer and Fabric for advanced analytics and real-time event processing.
---

# Send virtual machine client data to Fabric and Azure Data Explorer (Preview)

This article describes how to create data collection rules (DCRs) for the Azure Monitor Agent (AMA) to send VM data to [Azure Data Explorer (ADX)](/azure/data-explorer/data-explorer-overview) and [Fabric eventhouses](/fabric/real-time-intelligence/eventhouse). This feature is in public preview.

## Prerequisites

- Each VM resource must have the [AMA installed](../agents/azure-monitor-agent-manage.md).
- Each VM must have a [user-assigned managed identity](/azure/active-directory/managed-identities-azure-resources/how-manage-user-assigned-managed-identities) assigned to it.
- Each [AMA must be configured to use the managed identity for authentication](../agents/azure-monitor-agent-requirements.md#permissions).
- The DCR region must match the region of the ADX cluster or Fabric eventhouse destination.
- The minimum [AMA version](../agents/azure-monitor-agent-extension-versions.md#version-details) required is 1.39.0 for Windows and 1.38.0 Linux. 

## Permissions

[Permissions to create a DCR and DCR associations](../data-collection/data-collection-rule-create-edit.md#permissions) are required.

The following permissions are required depending on whether the DCR destination is ADX or Fabric eventhouse:

| Destination | Role |
|:---|:---|
| ADX | [Database Admin](/kusto/access-control/role-based-access-control?view=azure-data-explorer&preserve-view=true#roles-and-permissions) at the database scope or Azure contributor at the ADX cluster scope. |
| Fabric | [Workspace contributor](/fabric/fundamentals/roles-workspaces#-workspace-roles). |

The DCR creation process adds the [NativeIngestion](/azure/data-explorer/ingest-data-managed-identity#set-the-managed-identity-policy-in-azure-data-explorer) usage option for the VM user-assigned managed identity.

## Create a data collection rule

1. In the Azure portal, on the **Monitor** menu, select **Data Collection Rules** > **Create** to open the DCR creation pane.
1. Select the option presented by the informational banner to preview the [new Data Collection Rule creation experience](../vm/data-collection.md?tabs=preview#create-a-data-collection-rule).

   :::image type="content" source="./media/send-fabric-destination/preview-experience.png" alt-text="Screenshot of the informational banner to click in order to preview the new Data Collection Rule creation experience.":::

### Basics settings

1. Select the **Basics** tab.
1. The **Region** must match the region of the ADX cluster or Fabric eventhouse.
1. Select the **Type of telemetry** as **Agent-based**. 
1. **Enable Managed Identity** authentication and select the user-assigned managed identity associated with the VMs that use this DCR.

   :::image type="content" source="./media/send-fabric-destination/agent-telemetry.png" alt-text="Screenshot showing the agent-based telemetry source and the basics tab for creating a data collection rule.":::
   <br><sup>*A Data Collection Endpoint (DCE) is only required for private links*</sup>

### Resources

1. Select the **Resources** tab and add the VMs you want to collect data from. 
   <br>For more information, see [Add data collection rule resources](./data-collection.md#add-resources-1).
1. Add or remove VM resources from the DCR as needed after the DCR is created.


### Collect and deliver

1. Select the **Collect and deliver** tab. 
1. Select **Add new datasource**.
1. In the **Data source** tab, choose one of the [supported data types](#supported-data-types). Each data source listed has a link to general steps and special instructions.    
1. In the **Destination** tab > **Add destination** >**Destination type** pull down menu, select either **Azure Data Explorer** or **Microsoft Fabric**.
1. **Configure Destination** and choose the eventhouse or ADX cluster and database > **Select**.

   :::image type="content" source="./media/send-fabric-destination/configure-data-source.png" alt-text="Screenshot showing destination configuration for Microsoft Fabric.":::
   <sup>*The ADX free tier cluster isn't supported*</sup>

1. Select **Apply** > **Save**

   :::image type="content" source="./media/send-fabric-destination/datasource-destination.png" alt-text="Screenshot showing dataflow destination of ADX.":::

1. Review and create the DCR.

## Supported data types

The data types in the following table are agent-based telemetry sources supported to send to Fabric and ADX. Each has a link to an article describing the details of that source and the managed identity required and whether the DCR must use a data collection endpoint (DCE).

| Data source | special instructions | 
|:---|:---|
| [Performance counters](./data-collection-performance.md) | None |
| [IIS logs](./data-collection-iis.md) |  None|
| [Windows Event Logs](./data-collection-windows-events.md) | Table created is `Event` |
| [Linux Syslog](./data-collection-syslog.md) | None |
| [Custom Text logs](./data-collection-log-text.md) |  A transform is required. If no transform is desired, use the default `source`. |
| [Custom JSON logs](./data-collection-log-json.md) |  A transform is required. If no transform is desired, use the default `source`. |

## Verify data ingestion

1. Once the DCR is created, and a delay of a few minutes has passed, verify data is being ingested into ADX or Fabric.
1. Go to the DCR, select **Monitoring** > **Metrics** and select a metric such as **Logs Ingestion Bytes per Minute**.
1. Verify that the metric shows data being ingested as expected.

:::image type="content" source="./media/send-fabric-destination/verify-ingestion.png" alt-text="Screenshot showing the verification of data ingestion in metrics.":::

## Related content

- [Fabric eventhouse overview](/fabric/real-time-intelligence/eventhouse)
- [Azure Data Explorer overview](/azure/data-explorer/data-explorer-overview)
