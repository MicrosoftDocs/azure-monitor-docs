---
title: Supported log categories - Microsoft.DevCenter/devcenters
description: Reference for Microsoft.DevCenter/devcenters in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.DevCenter/devcenters, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.DevCenter/devcenters

The following table lists the types of logs available for the Microsoft.DevCenter/devcenters resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.DevCenter/devcenters](../supported-metrics/microsoft-devcenter-devcenters-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`AgentHealthStatus` |Agent Health Status |[DevCenterAgentHealthLogs](/azure/azure-monitor/reference/tables/devcenteragenthealthlogs)<p>Agent health logs pertaining to the underlying Azure VM of the dev box.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/devcenteragenthealthlogs)|Yes |
|`ConnectionEvent` |Connections |[DevCenterConnectionLogs](/azure/azure-monitor/reference/tables/devcenterconnectionlogs)<p>Connection events which include information around when a dev box was connected to, if the connection was successful and what client was used in connecting.|Yes|Yes||Yes |
|`DataplaneAuditEvent` |Dataplane audit logs |[DevCenterDiagnosticLogs](/azure/azure-monitor/reference/tables/devcenterdiagnosticlogs)<p>Data plane audit logs related to your dev center resources. Will display information concerning stop/start/deletes on dev boxes and environments.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/devcenterdiagnosticlogs)|Yes |
|`ResourceOperation` |Resource Operations |[DevCenterResourceOperationLogs](/azure/azure-monitor/reference/tables/devcenterresourceoperationlogs)<p>Operation logs pertaining to DevCenter resources, including information around resource health status changes.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/devcenterresourceoperationlogs)|Yes |
|`Usage` |Billing events |[DevCenterBillingEventLogs](/azure/azure-monitor/reference/tables/devcenterbillingeventlogs)<p>Billing event related to DevCenter resources. Logs contains information about the quantity and unit charged per meter.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/devcenterbillingeventlogs)|Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
