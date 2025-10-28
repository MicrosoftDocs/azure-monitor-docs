---
title: Send data to Fabric and Azure Data Explorer (Preview)
description: This article describes how to use Azure Monitor Agent to upload data to Azure Data Explorer and Fabric.
ms.topic: how-to
ms.date: 10/30/2025
ms.reviewer: aprilbadger
---

# Send virtual machine client data to Fabric and Azure Data Explorer (Preview)

Collect data from virtual machines (VMs) with the Azure Monitor Agent (AMA) using data collection rules (DCRs). This article describes how to send that data to Azure Data Explorer (ADX) and Fabric. This feature is in public preview.

The following table lists the AMA based data sources supported by this feature.

## Prerequisites

Each VM resource must have the AMA installed. For more information, see [Install the Azure Monitor agent on virtual machines](../agents/azure-monitor-agent-virtual-machines.md).

The agent VM must have a user-assigned managed identity associated to it. [User-assigned managed identity](/azure/active-directory/managed-identities-azure-resources/how-manage-user-assigned-managed-identities) is recommended for better scalability and performance. The agent must be configured to use the managed identity for authentication as described in [Azure Monitor agent requirements](../agents/azure-monitor-agent-requirements.md#permissions). 
The agent VM must have a user-assigned managed identity associated to it. [User-assigned managed identity](/azure/active-directory/managed-identities-azure-resources/how-manage-user-assigned-managed-identities) is recommended for better scalability and performance. The agent must be configured to use the managed identity for authentication as described in [Azure Monitor agent requirements](../agents/azure-monitor-agent-requirements.md#permissions).

Opt into the DCR preview feature by selecting the banner in the Azure portal when creating a DCR. There is now a preview feature to create a data collection rule (DCR) that sends data to Event Hubs or storage using the Azure portal. See [Create a data collection rule](../vm/data-collection.md?tabs=preview#create-a-data-collection-rule).

## Supported data types

The data types in the following table are supported sources to send to Fabric and ADX. Each has a link to an article describing the details of that source and the managed identity required and whether the DCR must use a data collection endpoint (DCE).

| Data source | DCE needed | Managed identity required | 
|:---|:---|:---|
| [Performance counters](./data-collection-performance.md) | No | User-assigned |
| [IIS logs](./data-collection-iis.md) |  No | User-assigned |
| [Windows Event Logs](./data-collection-windows-events.md) | No | User-assigned |
| [Linux Syslog](./data-collection-syslog.md) | No | User-assigned |
| [Custom Text logs](./data-collection-log-text.md) |  No | User-assigned |
| [Custom JSON logs](./data-collection-log-json.md) |  No | User-assigned |

> [!NOTE]
> This feature is only supported for Azure VMs. Arc-enabled VMs are not supported.

## Permissions

The following permissions are required to create a DCR that sends data to ADX or Fabric:

| Destination | RBAC role |
|:---|:---|
| ADX | DB Admin (data plane permission) on the database the DCR is pointing to or Azure contributor (control plane permission) on the ADX cluster DCR is pointing to |
| Fabric | Workspace contributor where the Eventhouse is located |

The DCR creation adds the VM user-assigned managed identity as a NativeIngestor to the ADX database or Eventhouse. For more information, see [Ingest data using managed identity authentication - Azure Data Explorer](/azure/data-explorer/ingest-data-managed-identity).

## Create a data collection rule

:::image type="content" source="/media/send-fabric-destination/agent-telemetry.png" alt-text="{alt-text}":::

:::image type="content" source="/media/send-fabric-destination/data-flow-destination.png" alt-text="{alt-text}":::

## Verify data ingestion
