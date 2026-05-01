---
title: Supported log categories - Microsoft.Network/networkManagers
description: Reference for Microsoft.Network/networkManagers in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Network/networkManagers, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.Network/networkManagers

The following table lists the types of logs available for the Microsoft.Network/networkManagers resource type.


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`ConnectivityConfigurationChange` |Connectivity Configuration Change |[AVNMConnectivityConfigurationChange](/azure/azure-monitor/reference/tables/avnmconnectivityconfigurationchange)<p>Includes logs related to application or removal of connectivity configuration, on network resources like a virtual network.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/avnmconnectivityconfigurationchange)|Yes |
|`NetworkGroupMembershipChange` |Network Group Membership Change |[AVNMNetworkGroupMembershipChange](/azure/azure-monitor/reference/tables/avnmnetworkgroupmembershipchange)<p>Includes changes to network group membership of network resources like a virtual network.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/avnmnetworkgroupmembershipchange)|Yes |
|`RuleCollectionChange` |Rule Collection Change |[AVNMRuleCollectionChange](/azure/azure-monitor/reference/tables/avnmrulecollectionchange)<p>Include logs related to application or removal of rule collections, on network resources like a virtual network or a subnet.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/avnmrulecollectionchange)|Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
