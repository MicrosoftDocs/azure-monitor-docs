---
title: Send data to Fabric and Azure Data Explorer (Preview)
description: This article describes how to use Azure Monitor Agent to upload data to Azure Data Explorer and Fabric.
ms.topic: how-to
ms.date: 10/30/2025
ms.reviewer: aprilbadger
---

# Send virtual machine client data to Fabric and Azure Data Explorer (Preview)

This article describes how to create data collection rules (DCRs) for the Azure Monitor agent (AMA) to send VM data to Azure Data Explorer (ADX) and Fabric eventhouses. This feature is in public preview.

## Prerequisites

Each VM resource must have the AMA installed. For more information, see [Install the Azure Monitor agent on virtual machines](../agents/azure-monitor-agent-virtual-machines.md).

The agent VM must have a user-assigned managed identity associated to it. User-assigned managed identities are required, and they're recommended in general for better scalability and performance. For more information, see [User-assigned managed identity](/azure/active-directory/managed-identities-azure-resources/how-manage-user-assigned-managed-identities). The agent must be configured to use the managed identity for authentication as described in [Azure Monitor agent requirements](../agents/azure-monitor-agent-requirements.md#permissions). 

Select the option presented by the informational banner to preview the new Data Collection Rule creation experience. For more information, see [Create a data collection rule](../vm/data-collection.md?tabs=preview#create-a-data-collection-rule).

:::image type="content" source="./media/send-fabric-destination/preview-experience.png" alt-text="Screenshot of the informational banner to click in order to preview the new Data Collection Rule creation experience.":::


## Supported data types

The data types in the following table are agent-based telemetry sources supported to send to Fabric and ADX. Each has a link to an article describing the details of that source and the managed identity required and whether the DCR must use a data collection endpoint (DCE).

| Data source | DCE needed | Managed identity required | 
|:---|:---|:---|
| [Performance counters](./data-collection-performance.md) | No | User-assigned |
| [IIS logs](./data-collection-iis.md) |  No | User-assigned |
| [Windows Event Logs](./data-collection-windows-events.md) | No | User-assigned |
| [Linux Syslog](./data-collection-syslog.md) | No | User-assigned |
| [Custom Text logs](./data-collection-log-text.md) |  No | User-assigned |
| [Custom JSON logs](./data-collection-log-json.md) |  No | User-assigned |


## Permissions

In addition to the [general permissions required to create a DCR and DCR associations](../data-collection/data-collection-rule-create-edit.md#permissions), the following permissions are required in order to create a DCR that sends data to ADX or Fabric:

| Destination | Role |
|:---|:---|
| ADX | Database Admin at the database scope where the DCR is pointing to, or Azure contributor at the ADX cluster scope where the DCR is pointing to. |
| Fabric | Workspace contributor where the eventhouse is located. For more information, see [Give users access to eventhouse workspaces](/fabric/fundamentals/give-access-workspaces). |

The DCR creation process adds the VM user-assigned managed identity as a NativeIngestor to the ADX database or eventhouse. For more information, see [Ingest data using managed identity authentication - Azure Data Explorer](/azure/data-explorer/ingest-data-managed-identity).

## Create a data collection rule

:::image type="content" source="./media/send-fabric-destination/agent-telemetry.png" alt-text="{alt-text}":::

:::image type="content" source="./media/send-fabric-destination/data-flow-destination.png" alt-text="{alt-text}":::

## Verify data ingestion
