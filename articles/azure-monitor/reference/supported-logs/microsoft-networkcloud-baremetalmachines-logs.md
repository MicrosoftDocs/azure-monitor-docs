---
title: Supported log categories - Microsoft.NetworkCloud/bareMetalMachines
description: Reference for Microsoft.NetworkCloud/bareMetalMachines in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 08/21/2026
ms.custom: Microsoft.NetworkCloud/bareMetalMachines, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.NetworkCloud/bareMetalMachines

The following table lists the types of logs available for the Microsoft.NetworkCloud/bareMetalMachines resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.NetworkCloud/bareMetalMachines](../supported-metrics/microsoft-networkcloud-baremetalmachines-metrics.md)


|Category|Costs to export|Log table|[Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)|Example queries|
|---|---|---|---|---|---|
|DefenderSecurity|Yes|[NCBMSecurityDefenderLogs](/azure/azure-monitor/reference/tables/ncbmsecuritydefenderlogs)<p>Security log events on Nexus Baremetal Machines to monitor and detect user access to the system.|Yes|Yes||
|NexusBreakGlassAudit|Yes|[NCBMBreakGlassAuditLogs](/azure/azure-monitor/reference/tables/ncbmbreakglassauditlogs)<p>Security log events on Nexus Baremetal Machines to monitor and detect user access to the system.|Yes|Yes||
|SecurityAudit|Yes||No|No||
|SecurityCritical|Yes||No|No||
|SecurityDebug|Yes|[NCBMSecurityLogs](/azure/azure-monitor/reference/tables/ncbmsecuritylogs)<p>Security log events on Nexus Baremetal Machines to monitor and detect user access to the system.|Yes|Yes||
|SecurityError|Yes|[NCBMSecurityLogs](/azure/azure-monitor/reference/tables/ncbmsecuritylogs)<p>Security log events on Nexus Baremetal Machines to monitor and detect user access to the system.|Yes|Yes||
|SecurityInfo|Yes|[NCBMSecurityLogs](/azure/azure-monitor/reference/tables/ncbmsecuritylogs)<p>Security log events on Nexus Baremetal Machines to monitor and detect user access to the system.|Yes|Yes||
|SecurityNotice|Yes|[NCBMSecurityLogs](/azure/azure-monitor/reference/tables/ncbmsecuritylogs)<p>Security log events on Nexus Baremetal Machines to monitor and detect user access to the system.|Yes|Yes||
|SecurityWarning|Yes||No|No||
|SyslogCritical|Yes|[NCBMSystemLogs](/azure/azure-monitor/reference/tables/ncbmsystemlogs)<p>Syslog events on Nexus Baremetal Machines providing critical insights into system activities, errors and anomalies for effecient troubleshooting and monitoring.|Yes|Yes||
|SyslogDebug|Yes|[NCBMSystemLogs](/azure/azure-monitor/reference/tables/ncbmsystemlogs)<p>Syslog events on Nexus Baremetal Machines providing critical insights into system activities, errors and anomalies for effecient troubleshooting and monitoring.|Yes|Yes||
|SyslogError|Yes|[NCBMSystemLogs](/azure/azure-monitor/reference/tables/ncbmsystemlogs)<p>Syslog events on Nexus Baremetal Machines providing critical insights into system activities, errors and anomalies for effecient troubleshooting and monitoring.|Yes|Yes||
|SyslogInfo|Yes|[NCBMSystemLogs](/azure/azure-monitor/reference/tables/ncbmsystemlogs)<p>Syslog events on Nexus Baremetal Machines providing critical insights into system activities, errors and anomalies for effecient troubleshooting and monitoring.|Yes|Yes||
|SyslogNotice|Yes|[NCBMSystemLogs](/azure/azure-monitor/reference/tables/ncbmsystemlogs)<p>Syslog events on Nexus Baremetal Machines providing critical insights into system activities, errors and anomalies for effecient troubleshooting and monitoring.|Yes|Yes||
|SyslogWarning|Yes|[NCBMSystemLogs](/azure/azure-monitor/reference/tables/ncbmsystemlogs)<p>Syslog events on Nexus Baremetal Machines providing critical insights into system activities, errors and anomalies for effecient troubleshooting and monitoring.|Yes|Yes||

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
