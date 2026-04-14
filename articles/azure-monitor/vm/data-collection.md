---
title: Collect log data from virtual machines with Azure Monitor
description: Learn how to collect log data from virtual machines, virtual machine scale sets, and Azure Arc-enabled servers by using Azure Monitor agent and data collection rules.
ai-usage: ai-assisted
ms.topic: how-to
ms.date: 03/10/2026
---

# Collect guest log data from virtual machines with Azure Monitor

Azure Monitor automatically collects host metrics and activity logs from Azure virtual machines, virtual machine scale sets, and Azure Arc-enabled servers. To fully monitor the guest operating system and workloads, you typically also need to collect log data that isn't collected by default. This article describes how to use the Azure portal to create data collection rules (DCRs) for common virtual machine data sources.

## Scope of article

If you have basic data collection requirements, the guidance in this article and the related articles for each [data source](#add-data-sources) should be sufficient. The Azure portal can create and edit the DCR without requiring you to understand its structure or manually associate it with the VM.

If you need advanced features such as [transformations](../data-collection/data-collection-transformations.md) or want to create and assign DCRs by using Azure CLI, Azure Policy, or other methods, see [Create data collection rules (DCRs) using JSON](../data-collection/data-collection-rule-create-edit.md). You can also review sample DCRs created by this process at [Data collection rule (DCR) samples for VMs in Azure Monitor](../data-collection/data-collection-rule-samples.md#collect-vm-client-data).

## Prerequisites

* [Log Analytics workspace](../logs/log-analytics-workspace-overview.md) where you have at least [contributor rights](../logs/manage-access.md#azure-rbac) to collect the data you configure.
* [Permissions to create DCR objects](../data-collection/data-collection-rule-create-edit.md#permissions) in the workspace.
* To send data across tenants, you must first enable [Azure Lighthouse](/azure/lighthouse/overview).
* See the detailed article for each [data source](#add-data-sources) for any additional prerequisites.

> [!IMPORTANT]
> If your Log Analytics workspace is associated with a network security perimeter, see [Configure Azure Monitor with Network Security Perimeter](../fundamentals/network-security-perimeter.md) to configure your Log Analytics workspace.

## Create data collection rule (DCR)

[!INCLUDE [data-collection-rule-edit-warning](../data-collection/includes/data-collection-rule-edit-warning.md)]

In the Azure portal, on the **Monitor** menu, select **Data Collection Rules** > **Create** to open the DCR creation pane.

:::image type="content" source="media/data-collection/create-data-collection-rule.png" lightbox="media/data-collection/create-data-collection-rule.png" alt-text="Screenshot that shows the Create button for a new data collection rule.":::

A preview experience for creating DCRs is now available in the Azure portal. Select the tab below for guidance on the experience you want to use.

### [Current experience](#tab/current)

The **Basics** tab includes basic information about the DCR.

:::image type="content" source="media/data-collection/basics-tab.png" lightbox="media/data-collection/basics-tab.png" alt-text="Screenshot that shows the Basics tab for a new data collection rule.":::

| Setting | Description |
|:---|:---|
| **Rule Name** | A name for the DCR. The name should be something descriptive that helps you identify the rule. |
| **Subscription** | The subscription to store the DCR. The subscription doesn't need to be the same subscription as the virtual machines. |
| **Resource** | A resource group to store the DCR. The resource group doesn't need to be the same resource group as the virtual machines. |
| **Region** | The Azure region to store the DCR. The region must be the *same* region as any Log Analytics workspace or Azure Monitor workspace that's used in a destination of the DCR. If you have workspaces in different regions, create multiple DCRs to associate with the same set of machines. |
| **Platform Type** | Specifies the type of data sources that are available for the DCR, either **Windows** or **Linux**. **None** allows for both. <sup>1</sup> |
| **Data Collection Endpoint** | Specifies the [data collection endpoint (DCE)](../data-collection/data-collection-endpoint-overview.md) that's used to collect data. A DCE is required only if you're using a data source that requires one. These data sources will be grayed out in the **Add data source** tab if a DCE isn't selected. For most implementations, you can use a single DCE for each Log Analytics workspace. See [Create a data collection endpoint](../data-collection/data-collection-endpoint-overview.md#create-a-data-collection-endpoint) for details on how to create a DCE. |

<sup>1</sup> This option sets the `kind` attribute in the DCR. You can set other values for this attribute, but the values aren't available to select in the portal.

### Add resources

On the **Resources** pane, select **Add resources** to add VMs that will use the DCR. You don't need to add any VMs yet since you can update the DCR after creation and add/remove any resources. If you select **Enable Data Collection Endpoints** on the **Resources** tab, you can select a DCE for each VM. This is only required if you're using [Azure Monitor Private Links](../fundamentals/private-link-vm-kubernetes.md). Otherwise, don't select this option.

> [!NOTE]
> You can't add a virtual machine scale set with flexible orchestration as a resource for a DCR. Instead, add each VM included in the virtual machine scale set.

:::image type="content" source="media/data-collection/resources-tab.png" lightbox="media/data-collection/resources-tab.png" alt-text="Screenshot that shows the Resources tab for a new data collection rule.":::

> [!IMPORTANT]
> When resources are added to a DCR, the default option in the Azure portal is to enable a system-assigned managed identity for the resources. For existing applications, if a user-assigned managed identity is already set, if you don't specify the user-assigned identity when you add the resource to a DCR by using the portal, the machine defaults to using a *system-assigned identity* that's applied by the DCR.

### Add data sources

On the **Collect and deliver** pane, select **Add data source** to add and configure data sources and destinations for the DCR. You can add multiple data sources to the same DCR or create multiple DCRs with different data sources. A DCR can have up to 10 data sources, and a VM can use any number of DCRs.

:::image type="content" source="media/data-collection/add-data-source.png" lightbox="media/data-collection/add-data-source.png" alt-text="Screenshot that shows the Add data sources tab for a new data collection rule.":::

| Setting | Description |
|:---|:---|
| **Data source** | Select a **Data source type** and provide values for the fields based on the data source type you select. See [Add data sources](#add-data-sources) for details about configuring each type of data source. |
| **Destination** | Add one or more destinations for each data source. Some data sources allow only a single destination. If you need multiple destinations, create another DCR.<br><br>While you can select multiple destinations of the same type for some data sources, be aware that this sends duplicate data to each destination and increases cost. See the details for each data type for the destinations it supports. |

### [Preview experience](#tab/preview)

To use the preview experience, select the banner at the top of the screen.

:::image type="content" source="media/data-collection/preview-enable-preview-experience.png" lightbox="media/data-collection/preview-enable-preview-experience.png" alt-text="Screenshot that shows banner to select preview experience.":::

The **Basics** tab includes basic information about the DCR.

:::image type="content" source="media/data-collection/preview-basics-tab.png" lightbox="media/data-collection/preview-basics-tab.png" alt-text="Screenshot that shows the preview Basics tab for a new data collection rule.":::

| Setting | Description |
|:---|:---|
| **Rule Name** | A name for the DCR. The name should be something descriptive that helps you identify the rule. |
| **Subscription** | The subscription to store the DCR. The subscription doesn't need to be the same subscription as the virtual machines. |
| **Resource group** | A resource group to store the DCR. The resource group doesn't need to be the same resource group as the virtual machines. |
| **Region** | The Azure region to store the DCR. The region must be the *same* region as any Log Analytics workspace or Azure Monitor workspace that's used in a destination of the DCR. If you have workspaces in different regions, create multiple DCRs to associate with the same set of machines. |
| **Type of telemetry** | Specifies the type of telemetry the DCR will collect. This selection will affect the resources that you can select and the data flows that you can create for the DCR. Select the drop-down to get a short description of each option. Select **Help me choose** to get further details including the types of data source and destination you can select for each option and whether they require a DCE or a managed entity.<sup>1</sup><br><br>For **Platform Telemetry**, see [Create a data collection rule (DCR) for metrics export](../data-collection/metrics-export-create.md). |
| **Data Collection Endpoint** | Specifies the [data collection endpoint (DCE)](../data-collection/data-collection-endpoint-overview.md) that's used to collect data. A DCE is required only if you're using a data source that requires one. Select **Help me choose** next to **Type of telemetry** to identify the data sources that require a DCE. For most implementations, you can use a single DCE for each Log Analytics workspace. See [Create a data collection endpoint](../data-collection/data-collection-endpoint-overview.md#create-a-data-collection-endpoint) for details on how to create a DCE. |
| Enable Managed Identity | Specifies whether to enable managed identity for the DCR. Select **Help me choose** next to **Type of telemetry** to identify the data sources that require a managed identity. |

<sup>1</sup> This option sets the `kind` attribute in the DCR. You can set other values for this attribute, but the values aren't available to select in the portal.

### Add resources

On the **Resources** pane, select **Add resources** to add resources that will use the DCR. You don't need to add any resources yet since you can update the DCR after creation and add/remove any resources. The region of the DCR is displayed as a reminder since some telemetry types require the DCR and resources to be in the same region.

> [!NOTE]
> You can't add a virtual machine scale set with flexible orchestration as a resource for a DCR. Instead, add each VM included in the virtual machine scale set.

:::image type="content" source="media/data-collection/preview-resources-tab.png" lightbox="media/data-collection/preview-resources-tab.png" alt-text="Screenshot that shows the preview Resources tab for a new data collection rule.":::

> [!IMPORTANT]
> When resources are added to a DCR, the default option in the Azure portal is to enable a system-assigned managed identity for the resources. For existing applications, if a user-assigned managed identity is already set, if you don't specify the user-assigned identity when you add the resource to a DCR by using the portal, the machine defaults to using a *system-assigned identity* that's applied by the DCR.

### Add dataflows

On the **Collect and deliver** pane, select **Add new dataflow** to add and configure data sources and destinations for the DCR. You can add multiple data sources to the same DCR or create multiple DCRs with different data sources. A DCR can have up to 10 data sources, and a VM can use any number of DCRs.

:::image type="content" source="media/data-collection/preview-add-data-source.png" lightbox="media/data-collection/preview-add-data-source.png" alt-text="Screenshot that shows the preview Add data sources tab for a new data collection rule.":::

| Setting | Description |
|:---|:---|
| **Data source** | Select a **Data source type** and provide values for the fields based on the data source type you select. See [Add data sources](#add-data-sources) for details about configuring each type of data source. |
| **Destination** | Add one or more destinations for each data source. Some data sources allow only a single destination. If you need multiple destinations, create another DCR.<br><br>While you can select multiple destinations of the same type for some data sources, be aware that this sends duplicate data to each destination and increases cost. See the details for each data type for the destinations it supports. |

---

## Add data sources

The following table lists the types of data you can collect from a VM client with Azure Monitor and where you can send that data. See the linked article for each to learn how to configure that data source.

| Data source | Description | Client OS | Destinations |
|:---|:---|:---|:---|
| [Windows events](data-collection-windows-events.md) | Information sent to the Windows event logging system, including sysmon events | Windows | Log Analytics workspace |
| [Performance counters](data-collection-performance.md) | Numerical values that measure the performance of different aspects of the operating system and workloads | Windows<br>Linux | Azure Monitor metrics (preview) <br>Log Analytics workspace |
| [OpenTelemetry metrics](metrics-opentelemetry-guest-modify.md) | OpenTelemetry performance counters from the guest operating system | Windows<br>Linux | Azure Monitor workspace |
| [Syslog](data-collection-syslog.md) | Information sent to the Linux event logging system | Linux | Log Analytics workspace |
| [Text log](data-collection-log-text.md) | Information sent to a text log file on a local disk | Windows<br>Linux | Log Analytics workspace |
| [JSON log](data-collection-log-json.md) | Information sent to a JSON log file on a local disk | Windows<br>Linux | Log Analytics workspace |
| [IIS logs](data-collection-iis.md) | Internet Information Service (IIS) logs from the local disk of Windows machines | Windows | Log Analytics workspace |
| [SNMP traps](data-collection-snmp-data.md) | SNMP poll and trap data sent to the Syslog data table or custom text table | Linux | Log Analytics workspace |
| [Windows Firewall logs](data-collection-firewall-logs.md) | Windows client and server firewall log data collected by DCR and the Security and Audit solution from Marketplace in the Azure portal | Windows | Log Analytics workspace |

## Verify operation

It can take up to 5 minutes for data to be sent to the destinations after you create a DCR. You can verify that the agent is operational and that data is being collected by querying the data in the Log Analytics workspace. 

### Verify agent operation

Verify that the agent is operational and communicating properly with Azure Monitor by checking the [Heartbeat](/azure/azure-monitor/reference/tables/heartbeat) for the VM. When an agent is properly communicating with Azure Monitor, it sends a record to the Heartbeat table every minute.

From the virtual machine in the Azure portal, select **Logs** and then click the **Tables** button. Under the **Virtual machines** category, click **Run** next to **Heartbeat**. If the agent is communicating correctly, you should see heartbeat records for the VM.

:::image type="content" source="media/data-collection/heartbeat.png" lightbox="media/data-collection/heartbeat.png" alt-text="Screenshot that shows the selection of the Heartbeats table in a Log Analytics workspace.":::

### Verify that records are received

Once you verify that the agent is communicating properly, make sure that the data you expect is being collected. Use the same process as above to view the data in the table for the data source that you configured. The following table lists the category and table for each data source.

| Data source | Category | Table |
|---|---|---|
| [Windows events](data-collection-windows-events.md) | Virtual Machines | Event |
| [Performance counters](data-collection-performance.md) | Virtual Machines | Perf |
| [OpenTelemetry metrics](metrics-opentelemetry-guest-modify.md) | Virtual Machines | Azure Monitor workspace |
| [Syslog](data-collection-syslog.md) | Virtual Machines | Syslog |
| [IIS logs](data-collection-iis.md) | Virtual Machines | W3CIISLog |
| [Text log](data-collection-log-text.md) | Custom Logs | \<Custom table name\> |
| [JSON log](data-collection-log-json.md) | Custom Logs | \<Custom table name\> |

## Duplicate data warning

Be careful of the following scenarios which may result in collecting duplicate data which will increase your billing charges:

* Creating multiple DCRs that have the same data source and associating them to the same VM. If you do have DCRs with the same data source, make sure that you configure them to filter for unique data.
* Creating a DCR that collects security logs and enabling [Microsoft Sentinel](/azure/sentinel) for the same VMs. In this case, the same events will be sent to both the **Event** table (Azure Monitor) and in the **SecurityEvent** table (Microsoft Sentinel).
* Creating a DCR for a VM that's also running the legacy [Log Analytics agent](../agents/log-analytics-agent.md) on the same machine. Both may be collecting identical data and storing it in the same table. Follow the guidance at [Migrate to Azure Monitor Agent from Log Analytics agent](../agents/azure-monitor-agent-migration.md) to migrate from the legacy agent.

See [Manage data collection rule associations in Azure Monitor](../data-collection/data-collection-rule-associations.md#preview-dcr-experience) to list the DCRs associated with a VM in the Azure portal. You can also use the following PowerShell command to list all DCRs for a VM:

```powershell
Get-AzDataCollectionRuleAssociation -resourceUri <vm-resource-id>
```

## Related content

- [Azure Monitor Agent overview](../agents/azure-monitor-agent-overview.md) - Review how Azure Monitor Agent collects data from virtual machines.
- [Data collection rules in Azure Monitor](../data-collection/data-collection-rule-overview.md) - Learn how DCRs define sources, destinations, and associations.
- [Collect performance counters from virtual machines with Azure Monitor](./data-collection-performance.md) - Configure performance counter collection for logs-based monitoring.
- [Tutorial: Collect guest logs from an Azure virtual machine](./tutorial-collect-logs.md) - Walk through collecting Windows event logs or Syslog from a monitored VM.
