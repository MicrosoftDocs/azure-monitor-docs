---
title: Collect data from VM client with Azure Monitor
description: Learn how to collect data from virtual machines, virtual machine scale sets, and Azure Arc-enabled on-premises servers by using the Azure Monitor Agent.
ms.topic: conceptual
ms.date: 11/14/2024
author: guywild
ms.author: guywild
ms.reviewer: jeffwo

---

# Collect data from VM client with Azure Monitor

> [!NOTE]
> VM insights

Azure Monitor automatically collects metrics and activity logs from your Azure and Arc-enabled virtual machines. To collect metrics and logs from the client operating system and its workloads though, you need to install the [Azure Monitor Agent](azure-monitor-agent-overview.md) and configure [data collection rules (DCRs)](../essentials/data-collection-rule-overview.md) that specify what you want to collect and where to send it.  This article describes how to use the Azure portal to create a DCR to collect different types of common data from VM clients and to install the agent on any machines that require it.

If you're new to Azure Monitor or have basic data collection requirements, you should be able to meet all your requirements by using the Azure portal and the guidance in this article. If you want to take advantage of more advanced features like [transformations](../essentials/data-collection-transformations.md), you might need to create a DCR by using other methods or edit a DCR after you create it in the portal. You can use different methods to manage DCRs and create associations if you want to deploy by using the Azure CLI, Azure PowerShell, an Azure Resource Manager template (ARM template), or Azure Policy.

The Azure portal provides a simplified experience for creating a DCR for virtual machines and scale sets. Using this method, you don't need to understand the structure of a DCR unless you want to implement an advanced feature, like a transformation. You can also use other creation methods that are described in [Create DCRs in Azure Monitor](../essentials/data-collection-rule-create-edit.md).

> [!WARNING]
> The following scenarios might collect duplicate data, which can increase billing charges:
>
> - Creating multiple DCRs that have the same data source and associating them to the same agent. Ensure that you filter data in the DCRs so that each DCR collects unique data.
> - Creating a DCR that collects security logs and enabling Microsoft Sentinel for the same agents. In this case, you can collect the same events in the **Event** table and in the **SecurityEvent** table.
> - Using both the Azure Monitor Agent and the legacy Log Analytics agent on the same machine. Limit duplicate events to only the time when you transition from one agent to the other.

## Data sources

The following table lists the types of data you can currently collect from a VM with the Azure Monitor agent and where you can send that data. Complete the steps in this article to create the DCR and assign it to resources, and then see the relevant linked article to learn how to configure the data source.

| Data source | Description | Client OS | Destinations |
|:---|:---|:---|:---|
| [Windows events](./data-collection-windows-events.md) |  Information sent to the Windows event logging system, including sysmon events | Windows | Log Analytics workspace |
| [Performance counters](./data-collection-performance.md) | Numerical values that measure the performance of different aspects of the operating system and workloads  | Windows<br>Linux | Azure Monitor metrics (preview) <br>Log Analytics workspace |
| [Syslog](./data-collection-syslog.md) | Information sent to the Linux event logging system | Linux | Log Analytics workspace |
| [Text log](./data-collection-log-text.md) | Information sent to a text log file on a local disk | Windows<br>Linux | Log Analytics workspace
| [JSON log](./data-collection-log-json.md) | Information sent to a JSON log file on a local disk | Windows<br>Linux | Log Analytics workspace |
| [IIS logs](./data-collection-iis.md) | Internet Information Service (IIS) logs from the local disk of Windows machines | Windows | Log Analytics workspace |


## Prerequisites

- [Log Analytics workspace](../logs/log-analytics-workspace-overview.md) where you have at least [contributor rights](../logs/manage-access.md#azure-rbac) to collect the data you configure. You can create a new workspace, but you should probably use an existing one if you have one.
- [Permissions to create DCR objects](../essentials/data-collection-rule-create-edit.md#permissions) in the workspace.
> To send data across tenants, you must first enable [Azure Lighthouse](/azure/lighthouse/overview).
- See the detailed article for each data source for any additional prerequisites.

## Create a data collection rule

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

On the **Resources** pane, select **Add resources** to add VMs that will use the DCR. You don't need to add any VMs yet since you can update the DCR after creation and add/remove any resources. The Azure Monitor Agent is automatically installed on any resource that doesn't already have it. A few minutes after the DCR is saved, 

> [!TIP]
> When you add a VM to a DCR, a [data collection rule association (DCRA)](../essentials/data-collection-rule-overview.md#data-collection-rule-associations-dcra) is created between the machine and the DCR. The same DCRA is removed if you remove the resource from the DCR. You don't need to know anything about DCRAs when working in the Azure portal. It's an important concept though if you work with DCRs using another method such as CLI or PowerShell. See [Manage data collection rule associations in Azure Monitor](../essentials/data-collection-rule-associations.md) for more information about DCRAs.


:::image type="content" source="media/azure-monitor-agent-data-collection/resources-tab.png" lightbox="media/azure-monitor-agent-data-collection/resources-tab.png" alt-text="Screenshot that shows the Resources tab for a new data collection rule.":::

If you're using [Azure Monitor Private Links](azure-monitor-agent-private-link.md), select **Enable Data Collection Endpoints** on the **Resources** tab and select an endpoint in the region of each monitored machine. Otherwise, you don't need to select a DCE for each resource.

> [!IMPORTANT]
> When resources are added to a DCR, the default option in the Azure portal is to enable a system-assigned managed identity for the resources. For existing applications, if a user-assigned managed identity is already set, if you don't specify the user-assigned identity when you add the resource to a DCR by using the portal, the machine defaults to using a *system-assigned identity* that's applied by the DCR.

## Add data sources

On the **Collect and deliver** pane, click **Add data source** to add and configure data sources and destinations for the DCR. You can choose to add multiple data sources to the same DCR or create multiple DCRs with different data sources. A DCR can have up to 10 data sources, and a VM can use any number of DCRs.

:::image type="content" source="media/azure-monitor-agent-data-collection/add-data-source.png" lightbox="media/azure-monitor-agent-data-collection/add-data-source.png" alt-text="Screenshot that shows the Add data sources tab for a new data collection rule.":::

| Setting | Description |
|:---|:---|
| **Data source** | Select a **Data source type** and define related fields based on the data source type you select. For details about configuring each type of data source, see related articles in [Data sources](/azure/azure-monitor/agents/azure-monitor-agent-data-collection#data-sources). |
| **Destination** | Add one or more destinations for each data source. You can select multiple destinations of the same type or select different types. For example, you can select multiple Log Analytics workspaces, which is called *multihoming*. See the details for each data type for the different destinations they support. |

> [!TIP]
> Before you add a VM to a DCR, ensure that the VM isn't associated with other DCRs using the same data sources or you may collect duplicate data. See [Manage data collection rule associations in Azure Monitor](../essentials/data-collection-rule-associations.md#preview-dcr-experience) to list the DCRs associated with a VM in the Azure portal. You can also use the following PowerShell command to list all DCRs for a VM:
>
> ```powershell
> Get-AzDataCollectionRuleAssociation -resourceUri <vm-resource-id>
> ```


## Verify operation

After you create a DCR and associate it with VMs, you can verify that the agent is operational and that data is being collected by querying the data in the Log Analytics workspace.

> [!NOTE]
> It can take up to 5 minutes for data to be sent to the destinations when you create a DCR by using the data collection rule wizard.

### Verify agent operation

Verify that the agent is operational and communicating properly with Azure Monitor by checking the [Heartbeat](/azure/azure-monitor/reference/tables/heartbeat) for the VM. When an agent is properly communicating with Azure Monitor, it sends a record to the Heartbeat table every minute. 

From the virtual machine in the Azure port, select **Logs** and then click the **Tables** button. Under the **Virtual machines** category, click **Run** next to **Heartbeat**. If the agent is communicating correctly, you should see heartbeat records for the VM.

:::image type="content" source="media/azure-monitor-agent-data-collection/resources-tab.png" lightbox="media/azure-monitor-agent-data-collection/resources-tab.png" alt-text="Screenshot that shows the Resources tab for a new data collection rule.":::

### Verify that records are received
Once you verify that the agent is communicating properly, make sure that the data you expect is being collected. Use the same process as above to view the data in the table for the data source that you configured. The following table lists the category and table for each data source.

| Data source | Category | Table |
|:---|:---|:---|
| [Windows events](./data-collection-windows-events.md) |  Virtual Machines | Event |
| [Performance counters](./data-collection-performance.md) | Virtual Machines  | Perf |
| [Syslog](./data-collection-syslog.md) | Virtual Machines  | Syslog |
| [IIS logs](./data-collection-iis.md) | Virtual Machines  | W3CIISLog |
| [Text log](./data-collection-log-text.md) | Custom Logs | <Custom table name> |
| [JSON log](./data-collection-log-json.md) | Custom Logs | <Custom table name> |


## Related content

- [Collect text logs by using the Azure Monitor Agent](data-collection-log-text.md).
- Learn more about the [Azure Monitor Agent](azure-monitor-agent-overview.md).
- Learn more about [data collection rules](../essentials/data-collection-rule-overview.md).
