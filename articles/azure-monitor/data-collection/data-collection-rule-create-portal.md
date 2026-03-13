---
title: Create data collection rules (DCRs) using the Azure portal
description: Create data collection rules (DCRs) using the Azure portal for different data collection scenarios in Azure Monitor.
ms.topic: how-to
ms.date: 03/13/2026
ms.reviewer: nikeist
---

# Create data collection rules (DCRs) using the Azure portal

The Azure portal provides a simplified experience for creating a [data collection rule (DCR)](data-collection-rule-overview.md) for particular scenarios. Using this method, you don't need to understand the structure of a DCR, although you may be limited in the configuration you can perform and may need to later edit the DCR definition to implement an advanced feature such as a transformation.

This article describes how to create a DCR using the Azure portal for different scenarios. To create a DCR by editing its JSON definition, see [Create data collection rules (DCRs) using JSON](data-collection-rule-create-edit.md).

## Permissions

You require the following permissions to create DCRs and [DCR associations](data-collection-rule-associations.md):

| Built-in role | Scopes | Reason |
|:---|:---|:---|
| [Monitoring Contributor](/azure/role-based-access-control/built-in-roles#monitoring-contributor) | <ul><li>Subscription and/or</li><li>Resource group and/or </li><li>An existing DCR</li></ul> | Create or edit DCRs, assign rules to the machine, deploy associations. |
| [Virtual Machine Contributor](/azure/role-based-access-control/built-in-roles#virtual-machine-contributor)<br>[Azure Connected Machine Resource Administrator](/azure/role-based-access-control/built-in-roles#azure-connected-machine-resource-administrator)</li></ul> | <ul><li>Virtual machines, virtual machine scale sets</li><li>Azure Arc-enabled servers</li></ul> | Deploy agent extensions on the VM (virtual machine). |
| Any role that includes the action *Microsoft.Resources/deployments/** | <ul><li>Subscription and/or</li><li>Resource group and/or </li><li>An existing DCR</li></ul> | Deploy Azure Resource Manager templates. |

> [!IMPORTANT]
> Create your DCR in the same region as your destination Log Analytics workspace or Azure Monitor workspace. You can associate the DCR to machines or containers from any subscription or resource group in the tenant. To send data across tenants, you must first enable [Azure Lighthouse](/azure/lighthouse/overview).

## DCR creation scenarios

The experience will vary for each scenario, so refer to the documentation for the specific scenario you're working with as described in the following table.

| Scenario | Description |
|:---|:---|
| Enable enhanced monitoring for VM | When you enable VM Insights on a VM, the Azure Monitor agent is installed and a DCR is created and associated with the virtual machine. See [Enable VM monitoring in Azure Monitor](../vm/vm-enable-monitoring.md). |
| Collect client data from VM | Create a DCR in the Azure portal using a guided interface to select different data sources from the client operating system of a VM. Examples include Windows events, Syslog events, and text logs. The Azure Monitor agent is automatically installed if necessary, and an association is created between the DCR and each VM you select. See [Collect data with Azure Monitor Agent](../vm/data-collection.md). |
| Metrics export | Create a DCR in the Azure portal using a guided interface to select metrics of different resource types to collect. An association is created between the DCR and each resource you select. See [Create a data collection rule (DCR) for metrics export](metrics-export-create.md). |
| Table creation | When you create a new table in a Log Analytics workspace using the Azure portal, you upload sample data that Azure Monitor uses to create a DCR, including a transformation, that can be used with the [Logs Ingestion API](../logs/logs-ingestion-api-overview.md). You can't modify this DCR in the Azure portal but can modify it using any of the methods described in this article. See [Create a custom table](../logs/create-custom-table.md?tabs=azure-portal-1%2Cazure-portal-2%2Cazure-portal-3#create-a-custom-table). |
| Kubernetes monitoring | To monitor a Kubernetes cluster, you enable Container Insights for logs and Prometheus for metrics. A DCR for each is created and associated with the containerized version of Azure Monitor agent in the cluster. You may need to modify the Container insights DCR to add a transformation. See [Enable monitoring for Kubernetes clusters](../containers/kubernetes-monitoring-enable.md) and [Data transformations in Container insights](../containers/container-insights-transformations.md). |
| Workspace transformation DCR | Workspace transformation DCRs provide transformations for data collection scenarios that don't yet use DCRs. You can create this DCR by using the Azure portal to create a transformation for a particular table. See [Create workspace transformation DCR](data-collection-transformations-create.md#create-workspace-transformation-dcr). |

## Create a data collection rule for virtual machines

This section describes how to create a DCR in the Azure portal to collect data from virtual machines, virtual machine scale sets, and Azure Arc-enabled servers. For specific guidance on each data source type, see [Collect data from virtual machine client with Azure Monitor](../vm/data-collection.md).

[!INCLUDE [data-collection-rule-edit-warning](./includes/data-collection-rule-edit-warning.md)]

In the Azure portal, on the **Monitor** menu, select **Data Collection Rules** > **Create** to open the DCR creation pane.

:::image type="content" source="../vm/media/data-collection/create-data-collection-rule.png" lightbox="../vm/media/data-collection/create-data-collection-rule.png" alt-text="Screenshot that shows the Create button for a new data collection rule.":::

A preview experience for creating DCRs is now available in the Azure portal. Select the tab below for guidance on the experience you want to use.

### [Current experience](#tab/current)

The **Basics** tab includes basic information about the DCR.

:::image type="content" source="../vm/media/data-collection/basics-tab.png" lightbox="../vm/media/data-collection/basics-tab.png" alt-text="Screenshot that shows the Basics tab for a new data collection rule.":::

| Setting | Description |
|:---|:---|
| **Rule Name** | A name for the DCR. The name should be something descriptive that helps you identify the rule. |
| **Subscription** | The subscription to store the DCR. The subscription doesn't need to be the same subscription as the virtual machines. |
| **Resource** | A resource group to store the DCR. The resource group doesn't need to be the same resource group as the virtual machines. |
| **Region** | The Azure region to store the DCR. The region must be the *same* region as any Log Analytics workspace or Azure Monitor workspace that's used in a destination of the DCR. If you have workspaces in different regions, create multiple DCRs to associate with the same set of machines. |
| **Platform Type** | Specifies the type of data sources that are available for the DCR, either **Windows** or **Linux**. **None** allows for both. <sup>1</sup> |
| **Data Collection Endpoint** | Specifies the [data collection endpoint (DCE)](data-collection-endpoint-overview.md) that's used to collect data. A DCE is required only if you're using a data source that requires one. These data sources will be grayed out in the **Add data source** tab if a DCE isn't selected. For most implementations, you can use a single DCE for each Log Analytics workspace. See [Create a data collection endpoint](data-collection-endpoint-overview.md#create-a-data-collection-endpoint) for details on how to create a DCE. |

<sup>1</sup> This option sets the `kind` attribute in the DCR. You can set other values for this attribute, but the values aren't available to select in the portal.

## Add resources

On the **Resources** pane, select **Add resources** to add VMs that will use the DCR. You don't need to add any VMs yet since you can update the DCR after creation and add/remove any resources. If you select **Enable Data Collection Endpoints** on the **Resources** tab, you can select a DCE for each VM. This is only required if you're using [Azure Monitor Private Links](../fundamentals/private-link-vm-kubernetes.md). Otherwise, don't select this option.

> [!NOTE]
> You can't add a virtual machine scale set with flexible orchestration as a resource for a DCR. Instead, add each VM included in the virtual machine scale set.

:::image type="content" source="../vm/media/data-collection/resources-tab.png" lightbox="../vm/media/data-collection/resources-tab.png" alt-text="Screenshot that shows the Resources tab for a new data collection rule.":::

> [!IMPORTANT]
> When resources are added to a DCR, the default option in the Azure portal is to enable a system-assigned managed identity for the resources. For existing applications, if a user-assigned managed identity is already set, if you don't specify the user-assigned identity when you add the resource to a DCR by using the portal, the machine defaults to using a *system-assigned identity* that's applied by the DCR.

## Add data sources

On the **Collect and deliver** pane, click **Add data source** to add and configure data sources and destinations for the DCR. You can choose to add multiple data sources to the same DCR or create multiple DCRs with different data sources. A DCR can have up to 10 data sources, and a VM can use any number of DCRs.

:::image type="content" source="../vm/media/data-collection/add-data-source.png" lightbox="../vm/media/data-collection/add-data-source.png" alt-text="Screenshot that shows the Add data sources tab for a new data collection rule.":::

| Setting | Description |
|:---|:---|
| **Data source** | Select a **Data source type** and provide values for the fields based on the data source type you select. See the table below for details about configuring each type of data source. |
| **Destination** | Add one or more destinations for each data source. Some data sources will only allow a single data source. If you need multiple, then you can create another DCR.<br><br>While you can select multiple destinations of the same type for some data sources, be aware that this will send duplicate data to each which will result in additional cost. See the details for each data type for the different destinations they support. |

The following table lists the types of data you can collect from a VM client with Azure Monitor and where you can send that data. See the linked article for each to learn how to configure that data source.

| Data source | Description | Client OS | Destinations |
|:---|:---|:---|:---|
| [Windows events](../vm/data-collection-windows-events.md) | Information sent to the Windows event logging system, including sysmon events | Windows | Log Analytics workspace |
| [Performance counters](../vm/data-collection-performance.md) | Numerical values that measure the performance of different aspects of the operating system and workloads | Windows<br>Linux | Azure Monitor metrics (preview) <br>Log Analytics workspace |
| [Syslog](../vm/data-collection-syslog.md) | Information sent to the Linux event logging system | Linux | Log Analytics workspace |
| [Text log](../vm/data-collection-log-text.md) | Information sent to a text log file on a local disk | Windows<br>Linux | Log Analytics workspace |
| [JSON log](../vm/data-collection-log-json.md) | Information sent to a JSON log file on a local disk | Windows<br>Linux | Log Analytics workspace |
| [IIS logs](../vm/data-collection-iis.md) | Internet Information Service (IIS) logs from the local disk of Windows machines | Windows | Log Analytics workspace |
| [SNMP traps](../vm/data-collection-snmp-data.md) | SNMP poll and trap data sent to the Syslog data table or custom text table | Linux | Log Analytics workspace |
| [Windows Firewall logs](../vm/data-collection-firewall-logs.md) |  Windows client and server firewall log data collected by DCR and the Security and Audit solution from Marketplace in the Azure portal|  Windows | Log Analytics workspace |

### [Preview experience](#tab/preview)

To use the preview experience, select the banner at the top of the screen.

:::image type="content" source="../vm/media/data-collection/preview-enable-preview-experience.png" lightbox="../vm/media/data-collection/preview-enable-preview-experience.png" alt-text="Screenshot that shows banner to select preview experience.":::

The **Basics** tab includes basic information about the DCR.

:::image type="content" source="../vm/media/data-collection/preview-basics-tab.png" lightbox="../vm/media/data-collection/preview-basics-tab.png" alt-text="Screenshot that shows the preview Basics tab for a new data collection rule.":::

| Setting | Description |
|:---|:---|
| **Rule Name** | A name for the DCR. The name should be something descriptive that helps you identify the rule. |
| **Subscription** | The subscription to store the DCR. The subscription doesn't need to be the same subscription as the virtual machines. |
| **Resource group** | A resource group to store the DCR. The resource group doesn't need to be the same resource group as the virtual machines. |
| **Region** | The Azure region to store the DCR. The region must be the *same* region as any Log Analytics workspace or Azure Monitor workspace that's used in a destination of the DCR. If you have workspaces in different regions, create multiple DCRs to associate with the same set of machines. |
| **Type of telemetry** | Specifies the type of telemetry the DCR will collect. This selection will affect the resources that you can select and the data flows that you can create for the DCR. Select the drop-down to get a short description of each option. Select **Help me choose** to get further details including the types of data source and destination you can select for each option and whether they require a DCE or a managed entity.<sup>1</sup><br><br>For **Platform Telemetry**, see [Create a data collection rule (DCR) for metrics export](metrics-export-create.md). |
| **Data Collection Endpoint** | Specifies the [data collection endpoint (DCE)](data-collection-endpoint-overview.md) that's used to collect data. A DCE is required only if you're using a data source that requires one. Select **Help me choose** next to **Type of telemetry** to identify the data sources that require a DCE. For most implementations, you can use a single DCE for each Log Analytics workspace. See [Create a data collection rule (DCR) for metrics export](data-collection-endpoint-overview.md#create-a-data-collection-endpoint) for details on how to create a DCE. |
| Enable Managed Identity | Specifies whether to enable managed identity for the DCR. Select **Help me choose** next to **Type of telemetry** to identify the data sources that require a managed identity. |

<sup>1</sup> This option sets the `kind` attribute in the DCR. You can set other values for this attribute, but the values aren't available to select in the portal.

## Add resources

On the **Resources** pane, select **Add resources** to add resources that will use the DCR. You don't need to add any resources yet since you can update the DCR after creation and add/remove any resources. The region of the DCR is displayed as a reminder since some telemetry types require the DCR and resources to be in the same region.

> [!NOTE]
> You can't add a virtual machine scale set with flexible orchestration as a resource for a DCR. Instead, add each VM included in the virtual machine scale set.

:::image type="content" source="../vm/media/data-collection/preview-resources-tab.png" lightbox="../vm/media/data-collection/preview-resources-tab.png" alt-text="Screenshot that shows the preview Resources tab for a new data collection rule.":::

> [!IMPORTANT]
> When resources are added to a DCR, the default option in the Azure portal is to enable a system-assigned managed identity for the resources. For existing applications, if a user-assigned managed identity is already set, if you don't specify the user-assigned identity when you add the resource to a DCR by using the portal, the machine defaults to using a *system-assigned identity* that's applied by the DCR.

## Add dataflows

On the **Collect and deliver** pane, click **Add new dataflow** to add and configure data sources and destinations for the DCR. You can choose to add multiple data sources to the same DCR or create multiple DCRs with different data sources. A DCR can have up to 10 data sources, and a VM can use any number of DCRs.

:::image type="content" source="../vm/media/data-collection/preview-add-data-source.png" lightbox="../vm/media/data-collection/preview-add-data-source.png" alt-text="Screenshot that shows the preview Add data sources tab for a new data collection rule.":::

| Setting | Description |
|:---|:---|
| **Data source** | Select a **Data source type** and provide values for the fields based on the data source type you select. See the table below for details about configuring each type of data source. |
| **Destination** | Add one or more destinations for each data source. Some data sources will only allow a single data source. If you need multiple, then you can create another DCR.<br><br>While you can select multiple destinations of the same type for some data sources, be aware that this will send duplicate data to each which will result in additional cost. See the details for each data type for the different destinations they support. |

The following table lists the types of data you can collect from a VM client with Azure Monitor and where you can send that data. See the linked article for each to learn how to configure that data source.

| Data source | Description | Client OS | Destinations |
|:---|:---|:---|:---|
| [Windows events](../vm/data-collection-windows-events.md) | Information sent to the Windows event logging system, including sysmon events | Windows | Log Analytics workspace |
| [Performance counters](../vm/data-collection-performance.md) | Numerical values that measure the performance of different aspects of the operating system and workloads | Windows<br>Linux | Azure Monitor metrics (preview) <br>Log Analytics workspace |
| [Syslog](../vm/data-collection-syslog.md) | Information sent to the Linux event logging system | Linux | Log Analytics workspace |
| [Text log](../vm/data-collection-log-text.md) | Information sent to a text log file on a local disk | Windows<br>Linux | Log Analytics workspace |
| [JSON log](../vm/data-collection-log-json.md) | Information sent to a JSON log file on a local disk | Windows<br>Linux | Log Analytics workspace |
| [IIS logs](../vm/data-collection-iis.md) | Internet Information Service (IIS) logs from the local disk of Windows machines | Windows | Log Analytics workspace |

---

## Next steps

- [View and edit data collection rules](data-collection-rule-view.md)
- [Create data collection rules using JSON](data-collection-rule-create-edit.md)
- [Structure of a data collection rule](data-collection-rule-structure.md)
- [Best practices for data collection rules](data-collection-rule-best-practices.md)
