---
title: Supported log categories - Microsoft.ServiceNetworking/trafficControllers
description: Reference for Microsoft.ServiceNetworking/trafficControllers in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.ServiceNetworking/trafficControllers, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.ServiceNetworking/trafficControllers

The following table lists the types of logs available for the Microsoft.ServiceNetworking/trafficControllers resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.ServiceNetworking/trafficControllers](../supported-metrics/microsoft-servicenetworking-trafficcontrollers-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`TrafficControllerAccessLog` |Application Gateway for Containers Access Log |[AGCAccessLogs](/azure/azure-monitor/reference/tables/agcaccesslogs)<p>Contains details of client requests made to Application Gateway for Containers. Each client request creats a log entry that can be used to identify slow requests, determine error rates, and correlate logs with backend services.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/agcaccesslogs)|Yes |
|`TrafficControllerFirewallLog` |Application Gateway for Containers Firewall Log |[AGCFirewallLogs](/azure/azure-monitor/reference/tables/agcfirewalllogs)<p>Contains web application firewall logs logged through either detection or prevention mode for Application Gateway for Containers.|Yes|No||Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
