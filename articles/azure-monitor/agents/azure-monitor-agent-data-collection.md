---
title: Collect Data via the Azure Monitor Agent
description: Learn how to collect data from virtual machines, virtual machine scale sets, and Azure Arc-enabled on-premises servers by using the Azure Monitor Agent.
ms.topic: conceptual
ms.date: 11/14/2024
author: guywild
ms.author: guywild
ms.reviewer: jeffwo

---

# Collect data by using the Azure Monitor Agent

The [Azure Monitor Agent](azure-monitor-agent-overview.md) collects data from Azure virtual machines, virtual machine scale sets, and Azure Arc-enabled servers. [Data collection rules (DCRs)](../essentials/data-collection-rule-overview.md) define the data to collect from the agent and where to send the data. This article describes how to use the Azure portal to create a DCR to collect different types of data and to install the agent on any machines that require it.

If you're new to Azure Monitor or have basic data collection requirements, you might be able to meet all your requirements by using the Azure portal and the guidance in this article. If you want to take advantage of more DCR features, like [transformations](../essentials/data-collection-transformations.md), you might need to create a DCR by using other methods or edit a DCR after you create it in the portal. You can use different methods to manage DCRs and create associations if you want to deploy by using the Azure CLI, Azure PowerShell, an Azure Resource Manager template (ARM template), or Azure Policy.

> [!NOTE]
> To send data across tenants, you must first enable [Azure Lighthouse](/azure/lighthouse/overview).

> [!WARNING]
> The following scenarios might collect duplicate data, which can increase billing charges:
>
> - Creating multiple DCRs that have the same data source and associating them to the same agent. Ensure that you filter data in the DCRs so that each DCR collects unique data.
> - Creating a DCR that collects security logs and enabling Microsoft Sentinel for the same agents. In this case, you can collect the same events in the **Event** table and in the **SecurityEvent** table.
> - Using both the Azure Monitor Agent and the legacy Log Analytics agent on the same machine. Limit duplicate events to only the time when you transition from one agent to the other.

## Data sources

The following table lists the types of data you can currently collect by using the Azure Monitor Agent and where you can send that data. The link for each data source is for an article that describes the details of how to configure the data source. Complete the steps in this article to create the DCR and assign it to resources, and then see the relevant linked article to learn how to configure the data source.

| Data source | Description | Client OS | Destinations |
|:---|:---|:---|:---|
| [Windows events](./data-collection-windows-events.md) |  Information sent to the Windows event logging system, including sysmon events | Windows | Log Analytics workspace |
| [Performance counters](./data-collection-performance.md) | Numerical values that measure the performance of different aspects of the operating system and workloads  | Windows<br>Linux | Azure Monitor metrics (preview) <br>Log Analytics workspace |
| [Syslog](./data-collection-syslog.md) | Information sent to the Linux event logging system | Linux | Log Analytics workspace |
| [Text log](./data-collection-log-text.md) | Information sent to a text log file on a local disk | Windows<br>Linux | Log Analytics workspace
| [JSON log](./data-collection-log-json.md) | Information sent to a JSON log file on a local disk | Windows<br>Linux | Log Analytics workspace |
| [IIS logs](./data-collection-iis.md) | Internet Information Service (IIS) logs from the local disk of Windows machines | Windows | Log Analytics workspace |

> [!NOTE]
> The Azure Monitor Agent also supports the Azure service [SQL Best Practices Assessment](/sql/sql-server/azure-arc/assess/), which is currently in general availability. For more information, see [Configure best practices assessment by using the Azure Monitor Agent](/sql/sql-server/azure-arc/assess#enable-best-practices-assessment).

## Prerequisites

- [Permissions to create DCR objects](../essentials/data-collection-rule-create-edit.md#permissions) in the workspace.
- For all prerequisites, see the linked article in the preceding table that describes the relevant data source.

## Create a data collection rule

The Azure portal provides a simplified experience for creating a DCR for virtual machines and scale sets. Using this method, you don't need to understand the structure of a DCR unless you want to implement an advanced feature, like a transformation. You can also use other creation methods that are described in [Create DCRs in Azure Monitor](../essentials/data-collection-rule-create-edit.md).

In the Azure portal, on the **Monitor** menu, select **Data Collection Rules** > **Create** to open the DCR creation pane.

:::image type="content" source="media/azure-monitor-agent-data-collection/create-data-collection-rule.png" lightbox="media/azure-monitor-agent-data-collection/create-data-collection-rule.png" alt-text="Screenshot that shows the Create button for a new data collection rule.":::

The **Basics** tab includes basic information about the DCR.

:::image type="content" source="media/azure-monitor-agent-data-collection/basics-tab.png" lightbox="media/azure-monitor-agent-data-collection/basics-tab.png" alt-text="Screenshot that shows the Basics tab for a new data collection rule.":::

| Setting | Description |
|:---|:---|
| **Rule Name** | A name for the DCR. The name should be something descriptive that helps you identify the rule. |
| **Subscription** | The subscription to store the DCR. The subscription doesn't need to be the same subscription as the virtual machines. |
| **Resource** | A resource group to store the DCR. The resource group doesn't need to be the same resource group as the virtual machines. |
| **Region** | The Azure region to store the DCR. The region must be the *same* region as any Log Analytics workspace or Azure Monitor workspace that's used in a destination of the DCR. If you have workspaces in different regions, create multiple DCRs to associate with the same set of machines. |
| **Platform Type** | Specifies the type of data sources that are available for the DCR, either **Windows** or **Linux**. **None** allows for both. <sup>1</sup> |
| **Data Collection Endpoint** | Specifies the data collection endpoint (DCE) that's used to collect data. The DCE is required only if you're using a data source that requires a DCE. For more information, see [Set up data collection endpoints based on your deployment](../essentials/data-collection-endpoint-overview.md). |

<sup>1</sup> This option sets the `kind` attribute in the DCR. You can set other values for this attribute, but the values aren't available to select in the portal.

## Add resources

On the **Resources** pane, you can add VMs to be associated with the DCR. To choose resources to add, select **Add resources**. The Azure Monitor Agent is automatically installed on any resource that doesn't already have the agent installed. A [data collection rule association (DCRA)](../essentials/data-collection-rule-overview.md#data-collection-rule-associations-dcra) is created between the machine and the DCR.

> [!IMPORTANT]
> When resources are added to a DCR, the default option in the Azure portal is to enable a system-assigned managed identity for the resources. For existing applications, if a user-assigned managed identity is already set, if you don't specify the user-assigned identity when you add the resource to a DCR by using the portal, the machine defaults to using a *system-assigned identity* that's applied by the DCR.

:::image type="content" source="media/azure-monitor-agent-data-collection/resources-tab.png" lightbox="media/azure-monitor-agent-data-collection/resources-tab.png" alt-text="Screenshot that shows the Resources tab for a new data collection rule.":::

If you're using Azure Monitor Private Links, select **Enable Data Collection Endpoints** on the **Resources** tab and select an endpoint in the region of each monitored machine.

## Add data sources

On the **Collect and deliver** pane, you can add and configure data sources for the DCR, and add a destination for each source.

| Setting | Description |
|:---|:---|
| **Data source** | Select a **Data source type** and define related fields based on the data source type you select. For details about configuring each type of data source, see related articles in [Data sources](/azure/azure-monitor/agents/azure-monitor-agent-data-collection#data-sources). |
| **Destination** | Add one or more destinations for each data source. You can select multiple destinations of the same type or select different types. For example, you can select multiple Log Analytics workspaces, which is called *multihoming*. See the details for each data type for the different destinations they support. |

A DCR can contain multiple different data sources. A maximum of 10 data sources can be in a single DCR. You can combine different data sources in the same DCR, but you typically create different DCRs for different data collection scenarios. For recommendations on how to organize your DCR, see [Best practices for data collection rule creation and management in Azure Monitor](../essentials/data-collection-rule-best-practices.md).

> [!NOTE]
> It can take up to 5 minutes for data to be sent to the destinations when you create a DCR by using the data collection rule wizard.

## Verify operation

After you create a DCR and associate it with a machine, you can verify that the agent is operational and that data is being collected by running queries in the Log Analytics workspace.

### Verify agent operation

Verify that the agent is operational and communicating properly by running the following query in Log Analytics. The query checks to see if there are any records in the [Heartbeat](/azure/azure-monitor/reference/tables/heartbeat) table. A record should be sent to this table from each agent every minute.

``` kusto
Heartbeat
| where TimeGenerated > ago(24h)
| where Computer has "<computer name>"
| project TimeGenerated, Category, Version
| order by TimeGenerated desc
```

### Verify that records are received

It takes a few minutes for the agent to be installed and start running any new or modified DCRs. You can then verify that records are being received from each of your data sources by checking the table that each source writes to in the Log Analytics workspace.

For example, the following query checks for Windows events in the [Event](/azure/azure-monitor/reference/tables/event) table:

``` kusto
Event
| where TimeGenerated > ago(48h)
| order by TimeGenerated desc
```

## Troubleshoot

If data that you're expecting to see isn't collected, complete the following steps:

1. Verify that the agent is installed and running on the machine.
1. See the troubleshooting section of the article for the data source you're having trouble with.
1. [Enable monitoring for the DCR](../essentials/data-collection-monitor.md), and then:

   1. View metrics to determine if data is being collected and whether any rows are being dropped.
   1. View logs to identify errors in the data collection.

## Related content

- [Collect text logs by using the Azure Monitor Agent](data-collection-log-text.md).
- Learn more about the [Azure Monitor Agent](azure-monitor-agent-overview.md).
- Learn more about [data collection rules](../essentials/data-collection-rule-overview.md).
