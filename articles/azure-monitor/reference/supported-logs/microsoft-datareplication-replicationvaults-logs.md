---
title: Supported log categories - Microsoft.DataReplication/replicationVaults
description: Reference for Microsoft.DataReplication/replicationVaults in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.DataReplication/replicationVaults, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.DataReplication/replicationVaults

The following table lists the types of logs available for the Microsoft.DataReplication/replicationVaults resource type.


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`HealthEvents` |ASRv2 Health Event Data ||No|No||Yes |
|`JobEvents` |ASRv2 Job Event Data ||No|No||Yes |
|`ProtectedItems` |ASRv2 Protected Item Data |[ASRv2ProtectedItems](/azure/azure-monitor/reference/tables/asrv2protecteditems)<p>This table contains records of Azure Site Recovery v2 (ASRv2) protected item related events.|Yes|Yes||Yes |
|`ReplicationExtensions` |ASRv2 Replication Extension Data ||No|No||Yes |
|`ReplicationPolicies` |ASRv2 Replication Policy Data ||No|No||Yes |
|`ReplicationVaults` |ASRv2 Replication Vault Data |[ASRv2ReplicationVaults](/azure/azure-monitor/reference/tables/asrv2replicationvaults)<p>This table contains records of Azure Site Recovery v2 (ASRv2) replication vault related events.|Yes|Yes||Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
