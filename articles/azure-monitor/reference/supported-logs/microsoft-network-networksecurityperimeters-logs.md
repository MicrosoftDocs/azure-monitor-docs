---
title: Supported log categories - Microsoft.Network/networkSecurityPerimeters
description: Reference for Microsoft.Network/networkSecurityPerimeters in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 07/14/2026
ms.custom: Microsoft.Network/networkSecurityPerimeters, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.Network/networkSecurityPerimeters

The following table lists the types of logs available for the Microsoft.Network/networkSecurityPerimeters resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.Network/networkSecurityPerimeters](../supported-metrics/microsoft-network-networksecurityperimeters-metrics.md)


|Category|Costs to export|Log table|[Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)|Example queries|
|---|---|---|---|---|---|
|Cross perimeter inbound access allowed by perimeter link.|Yes|[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||
|Cross perimeter outbound access allowed by perimeter link.|Yes|[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||
|Inbound access allowed within same perimeter.|Yes|[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||
|Outbound attempted to same or different perimeter.|Yes|[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||
|Private endpoint traffic allowed.|Yes|[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||
|Public inbound access allowed by NSP access rules.|Yes|[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||
|Public inbound access denied by NSP access rules.|Yes|[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||
|Public inbound access allowed by PaaS resource rules.|Yes|[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||
|Public inbound access denied by PaaS resource rules.|Yes|[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||
|Public outbound access allowed by NSP access rules.|Yes|[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||
|Public outbound access denied by NSP access rules.|Yes|[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||
|Public outbound access allowed by PaaS resource rules.|Yes|[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||
|Public outbound access denied by PaaS resource rules|Yes|[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
