---
title: Collect log data from virtual machine client with Azure Monitor
description: Learn how to collect data from virtual machines, virtual machine scale sets, and Azure Arc-enabled on-premises servers by using the Azure Monitor Agent.
ms.topic: how-to
ms.date: 03/10/2026
---

# Collect log data from virtual machine client with Azure Monitor

Azure Monitor automatically collects host metrics and activity logs from your Azure virtual machines, virtual machine scale sets, and Azure Arc-enabled servers. When you enable enhanced monitoring, the [Azure Monitor agent](../agents/azure-monitor-agent-overview.md) is installed, and [data collection rules (DCRs)](../data-collection/data-collection-rule-overview.md) are applied that collect metrics from the guest operating system. For complete monitoring of your client applications and workloads though, you typically need to collect log data and potentially additional metrics that aren't collected by default.

This article describes how to use the Azure portal to create DCRs to collect different types of common data from VM clients. If you have basic data collection requirements, you should be able to meet all your requirements using the guidance in this article and the related articles on each [data source](#add-data-sources). You can use the Azure portal to create and edit the DCR, and the Azure Monitor agent is automatically installed on each VM that doesn't already have it.

> [!NOTE]
> If you want to take advantage of more advanced features like [transformations](../data-collection/data-collection-transformations.md) or create and assign DCRs using other methods such as Azure CLI or Azure Policy, then see [Create data collection rules (DCRs) using JSON](../data-collection/data-collection-rule-create-edit.md). You can also view sample DCRs created by this process at [Data collection rule (DCR) samples for VM  in Azure Monitor](../data-collection/data-collection-rule-samples.md#collect-vm-client-data).

## Prerequisites

* For logs, a [Log Analytics workspace](../logs/log-analytics-workspace-overview.md) where you have at least [contributor rights](../logs/manage-access.md#azure-rbac) to collect the data you configure.
* For OpenTelemetry metrics, an [Azure Monitor workspace](../metrics/azure-monitor-workspace-manage.md) where you have at least contributor rights to collect the data you configure. 
* [Permissions to create DCR objects](../data-collection/data-collection-rule-create-edit.md#permissions) in the workspace.
* To send data across tenants, you must first enable [Azure Lighthouse](/azure/lighthouse/overview).
* See the detailed article for each [data source](#add-data-sources) for any additional prerequisites.

> [!IMPORTANT]
> If your Log Analytics workspace is associated with a network security perimeter see [Configure Azure Monitor with Network Security Perimeter](../fundamentals/network-security-perimeter.md) to configure your Log Analytics workspace.

## Create a data collection rule

Use the Azure portal to create a DCR for collecting data from virtual machines. For step-by-step instructions, see [Create data collection rules (DCRs) using the Azure portal](../data-collection/data-collection-rule-create-portal.md#create-a-data-collection-rule-for-virtual-machines).

## Add data sources

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
| [OpenTelemetry metrics](data-collection-otel-metrics.md) | Virtual Machines | Azure Monitor workspace |
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

* Learn more about the [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md).
* Learn more about [data collection rules](../data-collection/data-collection-rule-overview.md).
