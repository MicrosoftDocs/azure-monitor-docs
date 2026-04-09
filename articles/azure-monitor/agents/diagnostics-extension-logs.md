---
title: Send data from Azure Diagnostics extension to Azure Monitor Logs
description: Azure Monitor can read the logs for Azure services that write diagnostics to Azure Table Storage or IIS logs written to Azure Blob Storage.
ms.topic: how-to
ms.date: 04/07/2026
ms.reviewer: shseth
ai-usage: ai-assisted

---

# Send data from Azure Diagnostics extension to Azure Monitor Logs by using Azure Diagnostics extension


Azure Diagnostics extension is an [agent in Azure Monitor](../agents/agents-overview.md) that collects monitoring data from the guest operating system of Azure compute resources, including virtual machines. This article describes how to collect data that the diagnostics extension gathers from Azure Storage to Azure Monitor Logs.

> [!WARNING]
> The Azure Diagnostics extension no longer collects any log types from Azure Storage accounts to send to Log Analytics workspaces since the retirement March 31, 2026. Installing or configuring the Azure Diagnostics extension is no longer supported. Migrate to the recommended Azure Storage blobs solution by using the [Azure Monitor Agent](azure-monitor-agent-migration-wad-lad.md) described in [Azure Diagnostics extension overview migration guidance](diagnostics-extension-overview.md#migration-guidance).

## Supported data types

> [!NOTE]
> The following data types apply to the retired Azure Diagnostics extension's legacy storage schema and are provided for reference only. For equivalent data collection and analysis capabilities, use the [recommended alternatives](diagnostics-extension-overview.md#migration-guidance).

Azure Diagnostics extension stores data in an Azure Storage account. For Azure Monitor Logs to collect this data, it must be in the following locations:

| Log type | Resource type | Location |
|----------|---------------|----------|
| IIS logs | Virtual machines<br>Web roles<br>Worker roles | wad-iis-logfiles (Azure Blob Storage) |
| Syslog | Virtual machines | LinuxsyslogVer2v0 (Azure Table Storage) |
| Azure Service Fabric Operational Events | Service Fabric nodes | WADServiceFabricSystemEventTable |
| Service Fabric Reliable Actor Events | Service Fabric nodes | WADServiceFabricReliableActorEventTable |
| Service Fabric Reliable Service Events | Service Fabric nodes | WADServiceFabricReliableServiceEventTable |
| Windows Event logs | Service Fabric nodes<br>Virtual machines<br>Web roles<br>Worker roles | WADWindowsEventLogsTable (Table Storage) |
| Windows ETW logs | Service Fabric nodes<br>Virtual machines<br>Web roles<br>Worker roles | WADETWEventTable (Table Storage) |

## Data types not supported

The following data types aren't supported:

* Performance data from the guest operating system
* IIS logs from Azure websites

## Enable Azure Diagnostics extension

For historical reference, see [Install and configure Azure Diagnostics extension for Windows (WAD)](../agents/diagnostics-extension-windows-install.md) or [Use Azure Diagnostics extension for Linux to monitor metrics and logs](/azure/virtual-machines/extensions/diagnostics-linux).

## Collect logs from Azure Storage

To enable collection of diagnostics extension data from an Azure Storage account:

1. In the Azure portal, go to **Log Analytics Workspaces** and select your workspace.
1. Select **Legacy storage account logs** in the **Classic** section of the menu.
1. Select **Add**.
1. Select the **Storage account** that contains the data to collect.
1. Select the **Data Type** you want to collect.
1. The value for **Source** is automatically populated based on the data type.
1. Select **OK** to save the configuration.
1. Repeat for more data types.
In approximately 30 minutes, you see data from the storage account in the Log Analytics workspace. You only see data that's written to storage after the configuration is applied. The workspace doesn't read the preexisting data from the storage account.
In approximately 30 minutes, you'll see data from the storage account in the Log Analytics workspace. You'll only see data that's written to storage after the configuration is applied. The workspace doesn't read the preexisting data from the storage account.

> [!NOTE]
> The portal doesn't validate that the source exists in the storage account or if new data is being written.

## Next steps

* [Collect logs and metrics for Azure services](../essentials/resource-logs.md#send-to-log-analytics-workspace) for supported Azure services.
* [Enable solutions](/previous-versions/azure/azure-monitor/insights/solutions) to provide insight into the data.
* [Use search queries](../logs/log-query-overview.md) to analyze the data.
