---
title: Supported log categories - Microsoft.ToolchainOrchestrator/diagnostics
description: Reference for Microsoft.ToolchainOrchestrator/diagnostics in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.ToolchainOrchestrator/diagnostics, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.ToolchainOrchestrator/diagnostics

The following table lists the types of logs available for the Microsoft.ToolchainOrchestrator/diagnostics resource type.


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`UserAudits` |Audit Logs |[TOUserAudits](/azure/azure-monitor/reference/tables/touseraudits)<p>Contains all Toolchain orchestrator API Server audit logs including the events generated as a result of interactions with any external system or toolchain. These events are useful for monitoring all the interactions with the Toolchain orchestrator API server and between Toolchain orchestrator and external orchestrated targets, e.g. Kubernetes. Requires Diagnostic Settings to use the Resource Specific destination table.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/touseraudits)|Yes |
|`UserDiagnostics` |Diagnostic Logs |[TOUserDiagnostics](/azure/azure-monitor/reference/tables/touserdiagnostics)<p>Contains all Toolchain orchestrator API Server user diagnostics logs. These events are useful for diagnose failed requests on Toolchain orchestrator. Requires Diagnostic Settings to use the Resource Specific destination table.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/touserdiagnostics)|Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
