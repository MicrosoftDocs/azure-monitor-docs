---
title: Collect data with Azure Monitor Agent
description: Describes how to collect data from virtual machines, Virtual Machine Scale Sets, and Arc-enabled on-premises servers using the Azure Monitor agent.
ms.topic: conceptual
ms.date: 11/14/2024
author: guywild
ms.author: guywild
ms.reviewer: jeffwo

---

# Collect data with the Azure Monitor agent

The [Azure Monitor agent](azure-monitor-agent-overview.md) is used to collect data from Azure virtual machines, virtual machine scale sets, and Azure Arc-enabled servers. [Data collection rules (DCRs)](../essentials/data-collection-rule-overview.md) define the data to collect from the agent and where that data should be sent. This article describes how to use the Azure portal to create a DCR to collect different types of data and install the agent on any machines that require it.

If you're new to Azure Monitor or have basic data collection requirements, then you might be able to meet all of your requirements by using the Azure portal and the guidance in this article. If you want to take advantage of more DCR features such as [transformations](../essentials/data-collection-transformations.md), then you might need to create a DCR by using other methods or edit it after creating it in the portal. You can also use different methods to manage DCRs and create associations if you want to deploy by using the Azure CLI, Azure PowerShell, ARM templates, or Azure Policy.

> [!NOTE]
> To send data across tenants, you must first enable [Azure Lighthouse](/azure/lighthouse/overview).

> [!WARNING]
> The following cases might collect duplicate data, which might result in more charges.
>
> - Creating multiple DCRs with the same data source and associating them to the same agent. Ensure that you're filtering data in the DCRs such that each collects unique data.
> - Creating a DCR that collects security logs and enabling Microsoft Sentinel for the same agents. In this case, you can collect the same events in the Event table and the SecurityEvent table.
> - Using both the Azure Monitor agent and the legacy Log Analytics agent on the same machine. Limit duplicate events to only the time when you transition from one agent to the other.

## Data sources

The following table lists the types of data you can currently collect with the Azure Monitor agent and where you can send that data. The link for each is to an article describing the details of how to configure that data source. Follow this article to create the DCR and assign it to resources, and then follow the linked article to configure the data source.

| Data source | Description | Client OS | Destinations |
|:---|:---|:---|:---|
| [Windows events](./data-collection-windows-events.md) |  Information sent to the Windows event logging system, including sysmon events. | Windows | Log Analytics workspace |
| [Performance counters](./data-collection-performance.md) | Numerical values that measure the performance of different aspects of the operating system and workloads.  | Windows<br>Linux | Azure Monitor metrics (preview)<br>Log Analytics workspace |
| [Syslog](./data-collection-syslog.md) | Information sent to the Linux event logging system. | Linux | Log Analytics workspace |
| [Text log](./data-collection-log-text.md) | Information sent to a text log file on a local disk. | Windows<br>Linux | Log Analytics workspace
| [JSON log](./data-collection-log-json.md) | Information sent to a JSON log file on a local disk. | Windows<br>Linux | Log Analytics workspace |
| [IIS logs](./data-collection-iis.md) | Internet Information Service (IIS) logs from the local disk of Windows machines | Windows | Log Analytics workspace |

> [!NOTE]
> The Azure Monitor agent also supports Azure service [SQL Best Practices Assessment](/sql/sql-server/azure-arc/assess/) which is currently in general availability. For more information, see [Configure best practices assessment by using the Azure Monitor agent](/sql/sql-server/azure-arc/assess#enable-best-practices-assessment).

## Prerequisites

- [Permissions to create Data Collection Rule objects](../essentials/data-collection-rule-create-edit.md#permissions) in the workspace.
- See the article describing each data source for any other prerequisites.

## Create data collection rule (DCR)

The Azure portal provides a simplified experience for creating a DCR for virtual machines and virtual machine scale sets. Using this method, you don't need to understand the structure of a DCR unless you want to implement an advanced feature such as a transformation. You can also use other creation methods described in [Create data collection rules (DCRs) in Azure Monitor](../essentials/data-collection-rule-create-edit.md).

On the **Monitor** menu in the Azure portal, select **Data Collection Rules** > **Create** to open the DCR creation page.

:::image type="content" source="media/azure-monitor-agent-data-collection/create-data-collection-rule.png" lightbox="media/azure-monitor-agent-data-collection/create-data-collection-rule.png" alt-text="Screenshot that shows Create button for a new data collection rule.":::

The **Basic** pane includes basic information about the DCR.

:::image type="content" source="media/azure-monitor-agent-data-collection/basics-tab.png" lightbox="media/azure-monitor-agent-data-collection/basics-tab.png" alt-text="Screenshot that shows the Basics tab for a new data collection rule.":::

| Setting | Description |
|:---|:---|
| Rule Name | Name for the DCR. The name should be something descriptive that helps you identify the rule. |
| Subscription | Subscription to store the DCR. The subscription doesn't need to be the same subscription as the virtual machines. |
| Resource group | Resource group to store the DCR. The resource group doesn't need to be the same resource group as the virtual machines. |
| Region | Region to store the DCR. The region must be the same region as any Log Analytics workspace or Azure Monitor workspace used in a destination of the DCR. If you have workspaces in different regions, then create multiple DCRs associated with the same set of machines. |
| Platform Type | Specifies the type of data sources that are available for the DCR, either **Windows** or **Linux**. **None** allows for both. <sup>1</sup> |
| Data Collection Endpoint | Specifies the data collection endpoint (DCE) used to collect data. The DCE is only required if you're using Azure Monitor Private Links. This DCE must be in the same region as the DCR. For more information, see [How to set up data collection endpoints based on your deployment](../essentials/data-collection-endpoint-overview.md). |

<sup>1</sup> This option sets the `kind` attribute in the DCR. There are other values that can be set for this attribute, but they aren't available in the portal.

## Add resources

On the **Resources** pane, you can add VMs to be associated with the DCR. To choose resources to add, select **Add resources**. The Azure Monitor agent is automatically installed on any resources that don't already have it. A [data collection rule association (DCRA)](../essentials/data-collection-rule-overview.md#data-collection-rule-associations-dcra) is created between the machine and the DCR.

> [!IMPORTANT]
> The portal enables system assigned managed identity on the target resources, and existing user assigned identities, if there are any. For existing applications, unless you specify the user assigned identity in the request, the machine defaults to using system assigned identity instead.

:::image type="content" source="media/azure-monitor-agent-data-collection/resources-tab.png" lightbox="media/azure-monitor-agent-data-collection/resources-tab.png" alt-text="Screenshot that shows the Resources tab for a new data collection rule.":::

If the machine you're monitoring isn't in the same region as your destination Log Analytics workspace and you're collecting data types that require a DCE, select **Enable Data Collection Endpoints** and select an endpoint in the region of each monitored machine. If the monitored machine is in the same region as your destination Log Analytics workspace, or if you don't require a DCE, don't select a data collection endpoint on the **Resources** tab.

## Add data sources

On the **Collect and deliver** pane, you can add and configure data sources for the DCR and add a destination for each source.

| Screen element | Description |
|:---|:---|
| **Data source** | Select a **Data source type** and define related fields based on the data source type you select. See the articles in [Data sources](/azure/azure-monitor/agents/azure-monitor-agent-data-collection#data-sources) for details on configuring each type of data source. |
| **Destination** | Add one or more destinations for each data source. You can select multiple destinations of the same or different types. For instance, you can select multiple Log Analytics workspaces, which is also known as multihoming. See the details for each data type for the different destinations they support. |

A DCR can contain multiple different data sources up to a limit of 10 data sources in a single DCR. You can combine different data sources in the same DCR, but you typically create different DCRs for different data collection scenarios. See [Best practices for data collection rule creation and management in Azure Monitor](../essentials/data-collection-rule-best-practices.md) for recommendations on how to organize your DCRs.

> [!NOTE]
> It can take up to 5 minutes for data to be sent to the destinations when you create a data collection rule by using the data collection rule wizard.

## Verify operation

After you create a DCR and associated it with a machine, you can verify that the agent is operational and that data is being collected by running queries in the Log Analytics workspace.

### Verify agent operation

Verify that the agent is operational and communicating properly by running the following query in Log Analytics to check if there are any records in the [Heartbeat](/azure/azure-monitor/reference/tables/heartbeat) table. A record should be sent to this table from each agent every minute.

``` kusto
Heartbeat
| where TimeGenerated > ago(24h)
| where Computer has "<computer name>"
| project TimeGenerated, Category, Version
| order by TimeGenerated desc
```

### Verify that records are being received

It takes a few minutes for the agent to be installed and start running any new or modified DCRs. You can then verify that records are being received from each of your data sources by checking the table that each writes to in the Log Analytics workspace.

For example, the following query checks for Windows events in the [Event](/azure/azure-monitor/reference/tables/event) table:

``` kusto
Event
| where TimeGenerated > ago(48h)
| order by TimeGenerated desc
```

## Troubleshooting

If data that you're expecting isn't being collected, complete the following steps:

1. Verify that the agent is installed and running on the machine.
1. See the **Troubleshooting** section of the article for the data source you're having trouble with.
1. [Enable monitoring for the DCR](../essentials/data-collection-monitor.md), and then:

   1. View metrics to determine if data is being collected and whether any rows are being dropped.
   1. View logs to identify errors in the data collection.

## Related content

- [Collect text logs by using the Azure Monitor agent](data-collection-log-text.md).
- Learn more about the [Azure Monitor agent](azure-monitor-agent-overview.md).
- Learn more about [data collection rules](../essentials/data-collection-rule-overview.md).
