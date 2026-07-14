---
title: Supported log categories - Microsoft.ApiManagement/service
description: Reference for Microsoft.ApiManagement/service in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 07/14/2026
ms.custom: Microsoft.ApiManagement/service, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.ApiManagement/service

The following table lists the types of logs available for the Microsoft.ApiManagement/service resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.ApiManagement/service](../supported-metrics/microsoft-apimanagement-service-metrics.md)


|Category|Costs to export|Log table|[Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)|Example queries|
|---|---|---|---|---|---|
|Logs related to Developer Portal usage|Yes|[APIMDevPortalAuditDiagnosticLog](/azure/azure-monitor/reference/tables/apimdevportalauditdiagnosticlog)<p>Diagnostic Logs for API Management Developer Portal API.|Yes|Yes||
|Logs related to generative AI gateway|Yes|[ApiManagementGatewayLlmLog](/azure/azure-monitor/reference/tables/apimanagementgatewayllmlog)<p>Gateway Logs related to language models for API Management Language.|Yes|Yes||
|Logs related to ApiManagement Gateway|No|[ApiManagementGatewayLogs](/azure/azure-monitor/reference/tables/apimanagementgatewaylogs)<p>Azure ApiManagement gateway logs.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/apimanagementgatewaylogs)|
|Logs related to Model Context Protocol (MCP) servers usage|Yes|[ApiManagementGatewayMCPLog](/azure/azure-monitor/reference/tables/apimanagementgatewaymcplog)<p>Gateway Logs related to MCP requests.|Yes|No||
|Logs related to Websocket Connections|Yes|[ApiManagementWebSocketConnectionLogs](/azure/azure-monitor/reference/tables/apimanagementwebsocketconnectionlogs)<p>Websocket connection logs provides logs on websocket connection events for API Management Gateway. Logging starts when the request arrives to API Management Gateway for handshake and till the request gets terminated. Every request log can be uniquely identified with CorrelationId.|Yes|No||

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
