---
title: Supported log categories - Microsoft.ManagedNetworkFabric/networkDevices
description: Reference for Microsoft.ManagedNetworkFabric/networkDevices in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 07/14/2026
ms.custom: Microsoft.ManagedNetworkFabric/networkDevices, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.ManagedNetworkFabric/networkDevices

The following table lists the types of logs available for the Microsoft.ManagedNetworkFabric/networkDevices resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.ManagedNetworkFabric/networkDevices](../supported-metrics/microsoft-managednetworkfabric-networkdevices-metrics.md)


|Category|Costs to export|Log table|[Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)|Example queries|
|---|---|---|---|---|---|
|Bi-Directional Forwarding Detection Updates|Yes||No|No||
|Component State Updates|Yes|[MNFDeviceUpdates](/azure/azure-monitor/reference/tables/mnfdeviceupdates)<p>Components state updates representing the status changes of ethernet ports, power supply units, fan modules, chassis and device software.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/mnfdeviceupdates)|
|Interface State Updates|Yes||No|No||
|Interface Vxlan Updates|Yes||No|No||
|BGP Neighbor Updates|Yes||No|No||
|Network Instance Updates|Yes||No|No||
|System Session History Updates|Yes|[MNFSystemSessionHistoryUpdates](/azure/azure-monitor/reference/tables/mnfsystemsessionhistoryupdates)<p>System session history update events in the Nexus network fabric devices.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/mnfsystemsessionhistoryupdates)|
|System State Message Updates|Yes|[MNFSystemStateMessageUpdates](/azure/azure-monitor/reference/tables/mnfsystemstatemessageupdates)<p>System state message update events in the Nexus network fabric devices.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/mnfsystemstatemessageupdates)|

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
