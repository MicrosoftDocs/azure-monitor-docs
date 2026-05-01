---
title: Supported log categories - Microsoft.Network/networkSecurityPerimeters
description: Reference for Microsoft.Network/networkSecurityPerimeters in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 02/02/2026
ms.custom: Microsoft.Network/networkSecurityPerimeters, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.Network/networkSecurityPerimeters

The following table lists the types of logs available for the Microsoft.Network/networkSecurityPerimeters resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.Network/networkSecurityPerimeters](../supported-metrics/microsoft-network-networksecurityperimeters-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`NspCrossPerimeterInboundAllowed` |Cross perimeter inbound access allowed by perimeter link. |[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||Yes |
|`NspCrossPerimeterOutboundAllowed` |Cross perimeter outbound access allowed by perimeter link. |[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||Yes |
|`NspIntraPerimeterInboundAllowed` |Inbound access allowed within same perimeter. |[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||Yes |
|`NspOutboundAttempt` |Outbound attempted to same or different perimeter. |[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||Yes |
|`NspPrivateInboundAllowed` |Private endpoint traffic allowed. |[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||Yes |
|`NspPublicInboundPerimeterRulesAllowed` |Public inbound access allowed by NSP access rules. |[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||Yes |
|`NspPublicInboundPerimeterRulesDenied` |Public inbound access denied by NSP access rules. |[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||Yes |
|`NspPublicInboundResourceRulesAllowed` |Public inbound access allowed by PaaS resource rules. |[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||Yes |
|`NspPublicInboundResourceRulesDenied` |Public inbound access denied by PaaS resource rules. |[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||Yes |
|`NspPublicOutboundPerimeterRulesAllowed` |Public outbound access allowed by NSP access rules. |[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||Yes |
|`NspPublicOutboundPerimeterRulesDenied` |Public outbound access denied by NSP access rules. |[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||Yes |
|`NspPublicOutboundResourceRulesAllowed` |Public outbound access allowed by PaaS resource rules. |[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||Yes |
|`NspPublicOutboundResourceRulesDenied` |Public outbound access denied by PaaS resource rules |[NSPAccessLogs](/azure/azure-monitor/reference/tables/nspaccesslogs)<p>Logs of Network Security Perimeter (NSP) inbound access allowed based on NSP access rules.|Yes|Yes||Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
