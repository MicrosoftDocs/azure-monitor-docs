---
title: Supported log categories - Microsoft.ManagedNetworkFabric/networkDevices
description: Reference for Microsoft.ManagedNetworkFabric/networkDevices in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.ManagedNetworkFabric/networkDevices, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.ManagedNetworkFabric/networkDevices

The following table lists the types of logs available for the Microsoft.ManagedNetworkFabric/networkDevices resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.ManagedNetworkFabric/networkDevices](../supported-metrics/microsoft-managednetworkfabric-networkdevices-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`BfdStateUpdates` |Bi-Directional Forwarding Detection Updates ||No|No||Yes |
|`ComponentStateUpdates` |Component State Updates |[MNFDeviceUpdates](/azure/azure-monitor/reference/tables/mnfdeviceupdates)<p>Components state updates representing the status changes of ethernet ports, power supply units, fan modules, chassis and device software.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/mnfdeviceupdates)|Yes |
|`InterfaceStateUpdates` |Interface State Updates ||No|No||Yes |
|`InterfaceVxlanUpdates` |Interface Vxlan Updates ||No|No||Yes |
|`NetworkInstanceBgpNeighborUpdates` |BGP Neighbor Updates ||No|No||Yes |
|`NetworkInstanceUpdates` |Network Instance Updates ||No|No||Yes |
|`SystemSessionHistoryUpdates` |System Session History Updates |[MNFSystemSessionHistoryUpdates](/azure/azure-monitor/reference/tables/mnfsystemsessionhistoryupdates)<p>System session history update events in the Nexus network fabric devices.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/mnfsystemsessionhistoryupdates)|Yes |
|`SystemStateMessageUpdates` |System State Message Updates |[MNFSystemStateMessageUpdates](/azure/azure-monitor/reference/tables/mnfsystemstatemessageupdates)<p>System state message update events in the Nexus network fabric devices.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/mnfsystemstatemessageupdates)|Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
