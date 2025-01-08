---
title: Azure Monitor Agent Overview
description: Get an overview of the Azure Monitor agent. Learn how you can use the Azure Monitor agent to collect monitoring data from the guest operating system of virtual machines.
ms.topic: conceptual
author: guywi-ms
ms.author: guywild
ms.date: 11/14/2024
ms.custom: references_regions
ms.reviewer: jeffwo

# Customer intent: As an IT manager, I want to understand the capabilities of the Azure Monitor agent to determine whether I can use the agent to collect the data I need from the operating systems of my virtual machines.

---

# Azure Monitor agent overview

The Azure Monitor agent collects monitoring data from the guest operating system of Azure and hybrid virtual machines (VMs). It delivers the data to Azure Monitor to use by features, insights, and other services, such as [Microsoft Sentinel](/azure/sentinel/overview) and [Microsoft Defender for Cloud](/azure/defender-for-cloud/defender-for-cloud-introduction). This article gives you an overview of the capabilities and supported use cases for the Azure Monitor agent.

For a short introduction to the Azure Monitor agent, including a demo of how to deploy the agent in the Azure portal, see this video:

(https://www.youtube.com/watch?v=f8bIrFU8tCs)

> [!NOTE]
> The Azure Monitor agent replaces the [legacy Log Analytics agent](./log-analytics-agent.md) for Azure Monitor. The Log Analytics agent has been *deprecated* and is not supported as of *August 31, 2024*. If you use the Log Analytics agent to ingest data to Azure Monitor, [migrate now to the Azure Monitor agent](./azure-monitor-agent-migration.md).

## Installation

The Azure Monitor agent is one method of [data collection for Azure Monitor](../data-sources.md). It's installed on VMs running in Azure, in other clouds, or on-premises, where it has access to local logs and performance data. Without the agent, you can collect data only from the host machine because you would have no access to the client operating system and running processes.

The agent can be installed by using different methods as described in [Install and manage the Azure Monitor agent](./azure-monitor-agent-manage.md). You can install the agent on a single machine or at scale by using Azure Policy or other tools. In some cases, the agent is automatically installed when you enable a feature that requires it, such as Microsoft Sentinel.

## Data collection

The Azure Monitor agent collects all data by using a [data collection rule (DCR)](../essentials/data-collection-rule-overview.md). In a DCR, you define the following information:

- The data type that's collected
- How to transform the data, including filtering, aggregating, and shaping
- The destination for collected data

A single DCR can contain multiple data sources of different types. Depending on your requirements, you can choose whether to include several data sources in a few DCRs or to create separate DCRs for each data source. This allows you to centrally define the logic for different data collection scenarios and to apply them to different sets of machines. For recommendations on how to organize your DCRs, see [Best practices for data collection rule creation and management in Azure Monitor](../essentials/data-collection-rule-best-practices.md).

The DCR is applied to a particular agent by creating a [data collection rule association (DCRA)](../essentials/data-collection-rule-overview.md#data-collection-rule-associations-dcra) between the DCR and the agent. One DCR can be associated with multiple agents, and each agent can be associated with multiple DCRs. When an agent is installed, it connects to Azure Monitor to retrieve any DCRs that are associated with it. The agent periodically checks back with Azure Monitor to determine if there are any changes to existing DCRs or associations with new ones.

:::image type="content" source="media/azure-monitor-agent-overview/data-collection-rule-associations.png" alt-text="Diagram that shows data collection rule associations connecting each VM to a single DCR." lightbox="media/azure-monitor-agent-overview/data-collection-rule-associations.png" border="false":::

## Costs

There's no cost to use the Azure Monitor agent, but you might incur charges for the data that's ingested and stored. For information on Log Analytics data collection and retention and for customer metrics, see [Azure Monitor Logs cost calculations and options](../logs/cost-logs.md) and [Analyze usage in a Log Analytics workspace](../logs/analyze-usage.md).

## Supported regions

The Azure Monitor agent is available for general availability features in all public Azure regions, Azure Government, and Azure operated by 21Vianet. It's not yet supported in air-gapped clouds. For more information, see [Product availability by region](https://azure.microsoft.com/global-infrastructure/services/?products=monitor&rar=true&regions=all).

## Supported services and features

The following tables identify the different environments and features that are currently supported by the Azure Monitor agent and those supported by the legacy agent. This information can help you determine whether the Azure Monitor agent supports your current requirements. For guidance about migrating specific features, see [Migrate to the Azure Monitor agent from the Log Analytics agent](../agents/azure-monitor-agent-migration.md).

### Windows agents

| Category | Area | Azure Monitor agent | Legacy agent |
|:---|:---|:---|:---|
| **Environments supported** |  |  |  |
|  | Azure | ✓ | ✓ |
|  | Other cloud (Azure Arc) | ✓ | ✓ |
|  | On-premises (Azure Arc) | ✓ | ✓ |
|  | Windows Client OS | ✓ |  |
| **Data collected** |  |  |  |
|  | Event Logs | ✓ | ✓ |
|  | Performance | ✓ | ✓ |
|  | File-based logs | ✓  | ✓ |
|  | IIS logs | ✓  | ✓ |
| **Data sent to** |  |  |  |
|  | Azure Monitor logs | ✓ | ✓ |
| **Services and features supported** |  |  |  |
|  | Microsoft Sentinel  | ✓ ([View scope](./azure-monitor-agent-migration.md#understand-additional-dependencies-and-services)) | ✓ |
|  | VM insights | ✓ | ✓ |
|  | Microsoft Defender for Cloud (uses only the Microsoft Defender for Endpoint agent) |  |  |
|  | Automation Update Management (moved to Azure Update Manager) | ✓ | ✓ |
|  | Azure Stack HCI | ✓ |  |
|  | Update Manager (no longer uses agents) |  |  |
|  | Change tracking | ✓ | ✓ |
|  | SQL Best Practices Assessment | ✓ |     |

### Linux agents

| Category | Area | Azure Monitor agent | Legacy agent |
|:---|:---|:---|:---|
| **Environments supported** |  |  |  |
|  | Azure | ✓ | ✓ |
|  | Other cloud (Azure Arc) | ✓ | ✓ |
|  | On-premises (Azure Arc) | ✓ | ✓ |
| **Data collected** |  |  |
|  | Syslog | ✓ | ✓ |
|  | Performance | ✓ | ✓ |
|  | File-based logs | ✓ |  |
| **Data sent to** |  |  |  |
|  | Azure Monitor logs | ✓ | ✓ |
| **Services and features supported** |  |  |  |
|  | Microsoft Sentinel  | ✓ ([View scope](./azure-monitor-agent-migration.md#understand-additional-dependencies-and-services)) | ✓ |
|  | VM insights | ✓ | ✓ |
|  | Microsoft Defender for Cloud (uses only the Microsoft Defender for Endpoint agent) | | |
|  | Automation Update Management (moved to Azure Update Manager) | ✓ | ✓ |
|  | Update Manager (no longer uses agents) | | |
|  | Change tracking | ✓ | ✓ |

## Supported data sources

For a list of data sources the Azure Monitor agent can collect and to learn how to configure them, see [Collect data with the Azure Monitor agent](./azure-monitor-agent-data-collection.md).

## Related content

- [Install the Azure Monitor agent](azure-monitor-agent-manage.md) on Windows and Linux virtual machines.
- [Create a data collection rule](./azure-monitor-agent-data-collection.md) to collect data from the agent and send it to Azure Monitor.
