---
title: Collect data from virtual machine client with Azure Monitor
description: Learn how to collect data from virtual machines, virtual machine scale sets, and Azure Arc-enabled on-premises servers by using the Azure Monitor Agent.
ms.topic: conceptual
ms.date: 02/26/2025
ms.reviewer: jeffwo

---

# Collect data from virtual machine client with Azure Monitor

Azure Monitor automatically collects host metrics and activity logs from your Azure and Arc-enabled virtual machines. To collect metrics and logs from the client operating system and its workloads though, you need to create [data collection rules (DCRs)](../essentials/data-collection-rule-overview.md) that specify what you want to collect and where to send it.  This article describes how to use the Azure portal to create a DCR to collect different types of common data from VM clients.

> [!NOTE]
>If you have basic data collection requirements, you should be able to meet all your requirements using the guidance in this article and the related articles on each [data source](#add-data-sources). You can use the Azure portal to create and edit the DCR, and the [Azure Monitor agent](../agents/azure-monitor-agent-overview.md) is automatically installed on each VM that doesn't already have it.
>
>If you want to take advantage of more advanced features like [transformations](../essentials/data-collection-transformations.md) or create and assign DCRs using other methods such as Azure CLI or Azure Policy, then see [Install and manage the Azure Monitor Agent](../agents/azure-monitor-agent-manage.md) and [Create DCRs in Azure Monitor](../essentials/data-collection-rule-create-edit.md). You can also view sample DCRs created by this process at [Data collection rule (DCR) samples for VM  in Azure Monitor](../essentials/data-collection-rule-samples.md#collect-vm-client-data).


## Prerequisites

- [Log Analytics workspace](../logs/log-analytics-workspace-overview.md) where you have at least [contributor rights](../logs/manage-access.md#azure-rbac) to collect the data you configure. See [Create a Log Analytics workspace](../logs/quick-create-workspace.md) if you don't already have a workspace you can use.
- [Permissions to create DCR objects](../essentials/data-collection-rule-create-edit.md#permissions) in the workspace.
- To send data across tenants, you must first enable [Azure Lighthouse](/azure/lighthouse/overview).
- See the detailed article for each [data source](#add-data-sources) for any additional prerequisites.

## Create a data collection rule

In the Azure portal, on the **Monitor** menu, select **Data Collection Rules** > **Create** to open the DCR creation pane.

:::image type="content" source="media/data-collection/create-data-collection-rule.png" lightbox="media/data-collection/create-data-collection-rule.png" alt-text="Screenshot that shows the Create button for a new data collection rule.":::

The **Basics** tab includes basic information about the DCR.

:::image type="content" source="media/data-collection/basics-tab.png" lightbox="media/data-collection/basics-tab.png" alt-text="Screenshot that shows the Basics tab for a new data collection rule.":::

| Setting | Description |
|:---|:---|
| **Rule Name** | A name for the DCR. The name should be something descriptive that helps you identify the rule. |
| **Subscription** | The subscription to store the DCR. The subscription doesn't need to be the same subscription as the virtual machines. |
| **Resource** | A resource group to store the DCR. The resource group doesn't need to be the same resource group as the virtual machines. |
| **Region** | The Azure region to store the DCR. The region must be the *same* region as any Log Analytics workspace or Azure Monitor workspace that's used in a destination of the DCR. If you have workspaces in different regions, create multiple DCRs to associate with the same set of machines. |
| **Platform Type** | Specifies the type of data sources that are available for the DCR, either **Windows** or **Linux**. **None** allows for both. <sup>1</sup> |
| **Data Collection Endpoint** | Specifies the [data collection endpoint (DCE)](../essentials/data-collection-endpoint-overview.md) that's used to collect data. A DCE is required only if you're using a data source that requires one. These data sources will be grayed out in the **Add data source** tab if a DCE isn't selected. For most implementations, you can use a single DCE for each Log Analytics workspace. See [Create a data collection endpoint](../essentials/data-collection-endpoint-overview.md#create-a-data-collection-endpoint) for details on how to create a DCE. |

<sup>1</sup> This option sets the `kind` attribute in the DCR. You can set other values for this attribute, but the values aren't available to select in the portal.

## Add resources

On the **Resources** pane, select **Add resources** to add VMs that will use the DCR. You don't need to add any VMs yet since you can update the DCR after creation and add/remove any resources. If you select **Enable Data Collection Endpoints** on the **Resources** tab, you can select a DCE for each VM. This is only required if you're using [Azure Monitor Private Links](../agents/azure-monitor-agent-private-link.md). Otherwise, don't select this option.

:::image type="content" source="media/data-collection/resources-tab.png" lightbox="media/data-collection/resources-tab.png" alt-text="Screenshot that shows the Resources tab for a new data collection rule.":::


> [!IMPORTANT]
> When resources are added to a DCR, the default option in the Azure portal is to enable a system-assigned managed identity for the resources. For existing applications, if a user-assigned managed identity is already set, if you don't specify the user-assigned identity when you add the resource to a DCR by using the portal, the machine defaults to using a *system-assigned identity* that's applied by the DCR.

## Add data sources

On the **Collect and deliver** pane, click **Add data source** to add and configure data sources and destinations for the DCR. You can choose to add multiple data sources to the same DCR or create multiple DCRs with different data sources. A DCR can have up to 10 data sources, and a VM can use any number of DCRs.

:::image type="content" source="media/data-collection/add-data-source.png" lightbox="media/data-collection/add-data-source.png" alt-text="Screenshot that shows the Add data sources tab for a new data collection rule.":::

| Setting | Description |
|:---|:---|
| **Data source** | Select a **Data source type** and provide values for the fields based on the data source type you select. See the table below for details about configuring each type of data source. |
| **Destination** | Add one or more destinations for each data source. Some data sources will only allow a single data source. If you need multiple, then you can create another DCR.<br><br>While you can select multiple destinations of the same type for some data sources, be aware that this will send duplicate data to each which will result in additional cost. See the details for each data type for the different destinations they support. |

The following table lists the types of data you can collect from a VM client with Azure Monitor and where you can send that data. See the linked article for each to learn how to configure that data source.

| Data source | Description | Client OS | Destinations |
|:---|:---|:---|:---|
| [Windows events](./data-collection-windows-events.md) |  Information sent to the Windows event logging system, including sysmon events | Windows | Log Analytics workspace |
| [Performance counters](./data-collection-performance.md) | Numerical values that measure the performance of different aspects of the operating system and workloads  | Windows<br>Linux | Azure Monitor metrics (preview) <br>Log Analytics workspace |
| [Syslog](./data-collection-syslog.md) | Information sent to the Linux event logging system | Linux | Log Analytics workspace |
| [Text log](./data-collection-log-text.md) | Information sent to a text log file on a local disk | Windows<br>Linux | Log Analytics workspace
| [JSON log](./data-collection-log-json.md) | Information sent to a JSON log file on a local disk | Windows<br>Linux | Log Analytics workspace |
| [IIS logs](./data-collection-iis.md) | Internet Information Service (IIS) logs from the local disk of Windows machines | Windows | Log Analytics workspace |



## Verify operation

It can take up to 5 minutes for data to be sent to the destinations after you create a DCR. You can verify that the agent is operational and that data is being collected by querying the data in the Log Analytics workspace. 

### Verify agent operation

Verify that the agent is operational and communicating properly with Azure Monitor by checking the [Heartbeat](/azure/azure-monitor/reference/tables/heartbeat) for the VM. When an agent is properly communicating with Azure Monitor, it sends a record to the Heartbeat table every minute. 

From the virtual machine in the Azure portal, select **Logs** and then click the **Tables** button. Under the **Virtual machines** category, click **Run** next to **Heartbeat**. If the agent is communicating correctly, you should see heartbeat records for the VM.

:::image type="content" source="media/data-collection/heartbeat.png" lightbox="media/data-collection/heartbeat.png" alt-text="Screenshot that shows the selection of the Heartbeats table in a Log Analytics workspace.":::

### Verify that records are received
Once you verify that the agent is communicating properly, make sure that the data you expect is being collected. Use the same process as above to view the data in the table for the data source that you configured. The following table lists the category and table for each data source.

| Data source | Category | Table |
|:---|:---|:---|
| [Windows events](./data-collection-windows-events.md) |  Virtual Machines | Event |
| [Performance counters](./data-collection-performance.md) | Virtual Machines  | Perf |
| [Syslog](./data-collection-syslog.md) | Virtual Machines  | Syslog |
| [IIS logs](./data-collection-iis.md) | Virtual Machines  | W3CIISLog |
| [Text log](./data-collection-log-text.md) | Custom Logs | \<Custom table name\> |
| [JSON log](./data-collection-log-json.md) | Custom Logs | \<Custom table name\> |


## Duplicate data warning

Be careful of the following scenarios which may result in collecting duplicate data which will increase your billing charges:

- Creating multiple DCRs that have the same data source and associating them to the same VM. If you do have DCRs with the same data source, make sure that you configure them to filter for unique data.
- Creating a DCR that collects security logs and enabling [Microsoft Sentinel](/azure/sentinel) for the same VMs. In this case, the same events will be sent to both the **Event** table (Azure Monitor) and in the **SecurityEvent** table (Microsoft Sentinel).
- Creating a DCR for a VM that's also running the legacy [Log Analytics agent](../agents/log-analytics-agent.md) on the same machine. Both may be collecting identical data and storing it in the same table. Follow the guidance at [Migrate to Azure Monitor Agent from Log Analytics agent](../agents/azure-monitor-agent-migration.md) to migrate from the legacy agent.

See [Manage data collection rule associations in Azure Monitor](../essentials/data-collection-rule-associations.md#preview-dcr-experience) to list the DCRs associated with a VM in the Azure portal. You can also use the following PowerShell command to list all DCRs for a VM:

```powershell
Get-AzDataCollectionRuleAssociation -resourceUri <vm-resource-id>
```

## Related content

- Learn more about the [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md).
- Learn more about [data collection rules](../essentials/data-collection-rule-overview.md).
