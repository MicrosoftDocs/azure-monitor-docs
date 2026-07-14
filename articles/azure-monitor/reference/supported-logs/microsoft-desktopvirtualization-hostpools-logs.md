---
title: Supported log categories - Microsoft.DesktopVirtualization/hostpools
description: Reference for Microsoft.DesktopVirtualization/hostpools in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 07/14/2026
ms.custom: Microsoft.DesktopVirtualization/hostpools, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.DesktopVirtualization/hostpools

The following table lists the types of logs available for the Microsoft.DesktopVirtualization/hostpools resource type.


|Category|Costs to export|Log table|[Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)|Example queries|
|---|---|---|---|---|---|
|AgentHealthStatus|No|[WVDAgentHealthStatus](/azure/azure-monitor/reference/tables/wvdagenthealthstatus)<p>Azure Virtual Desktop agent health status.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/wvdagenthealthstatus)|
|Autoscale logs for pooled host pools|Yes|[WVDAutoscaleEvaluationPooled](/azure/azure-monitor/reference/tables/wvdautoscaleevaluationpooled)<p>The results of an Azure Virtual Desktop Autoscale scaling plan evaluation on a hostpool. This includes information on the actions Autoscale took on the sessions hosts, such as starting or deallocating them, and why it took those actions. The column names that start with 'Config' contain the scaling plan configuration values for the current Autoscale schedule phase. If the ResultType column value is 'Failed' then join to the WVDErrors table using the CorrelationId column to get more details. For Autoscale documentation see https://go.microsoft.com/fwlink/?linkid=2169532 .|No|No||
|Checkpoint|No|[WVDCheckpoints](/azure/azure-monitor/reference/tables/wvdcheckpoints)<p>Windows Virtual Desktop Checkpoint Activity|No|Yes|[Queries](/azure/azure-monitor/reference/queries/wvdcheckpoints)|
|Connection|No|[WVDConnections](/azure/azure-monitor/reference/tables/wvdconnections)<p>Windows Virtual Desktop Connection Activity.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/wvdconnections)|
|Connection Graphics Data Logs Preview|Yes|[WVDConnectionGraphicsDataPreview](/azure/azure-monitor/reference/tables/wvdconnectiongraphicsdatapreview)<p>Windows Virtual Desktop connection graphics data.|No|No||
|Error|No|[WVDErrors](/azure/azure-monitor/reference/tables/wvderrors)<p>Windows Virtual Desktop Error Activity|No|Yes|[Queries](/azure/azure-monitor/reference/queries/wvderrors)|
|HostRegistration|No|[WVDHostRegistrations](/azure/azure-monitor/reference/tables/wvdhostregistrations)<p>Windows Virtual Desktop Host Registration Activity|No|Yes||
|Management|No|[WVDManagement](/azure/azure-monitor/reference/tables/wvdmanagement)<p>Windows Virtual Desktop Management Activity|No|Yes||
|Network links logs for AVD connections|Yes|[WVDMultiLinkAdd](/azure/azure-monitor/reference/tables/wvdmultilinkadd)<p>Azure Virtual Desktop MultiLink Add Activity.|No|No||
|Network Data Logs|Yes|[WVDConnectionNetworkData](/azure/azure-monitor/reference/tables/wvdconnectionnetworkdata)<p>Windows Virtual Desktop connection network data.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/wvdconnectionnetworkdata)|
|Session Host Management Activity Logs|Yes|[WVDSessionHostManagement](/azure/azure-monitor/reference/tables/wvdsessionhostmanagement)<p>Windows Virtual Desktop session host management data.|No|No||

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
