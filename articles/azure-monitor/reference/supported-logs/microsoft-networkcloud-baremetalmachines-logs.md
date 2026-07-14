---
title: Supported log categories - Microsoft.NetworkCloud/bareMetalMachines
description: Reference for Microsoft.NetworkCloud/bareMetalMachines in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 07/14/2026
ms.custom: Microsoft.NetworkCloud/bareMetalMachines, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.NetworkCloud/bareMetalMachines

The following table lists the types of logs available for the Microsoft.NetworkCloud/bareMetalMachines resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.NetworkCloud/bareMetalMachines](../supported-metrics/microsoft-networkcloud-baremetalmachines-metrics.md)


|Category|Costs to export|Log table|[Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)|Example queries|
|---|---|---|---|---|---|
|Security - Defender|Yes|[NCBMSecurityDefenderLogs](/azure/azure-monitor/reference/tables/ncbmsecuritydefenderlogs)<p>Security log events on Nexus Baremetal Machines to monitor and detect user access to the system.|Yes|Yes||
|Security - Break Glass Audit|Yes|[NCBMBreakGlassAuditLogs](/azure/azure-monitor/reference/tables/ncbmbreakglassauditlogs)<p>Security log events on Nexus Baremetal Machines to monitor and detect user access to the system.|Yes|Yes||
|Security - Audit|Yes||No|No||
|Security - Critical|Yes||No|No||
|Security - Debug|Yes|[NCBMSecurityLogs](/azure/azure-monitor/reference/tables/ncbmsecuritylogs)<p>Security log events on Nexus Baremetal Machines to monitor and detect user access to the system.|Yes|Yes||
|Security - Error|Yes|[NCBMSecurityLogs](/azure/azure-monitor/reference/tables/ncbmsecuritylogs)<p>Security log events on Nexus Baremetal Machines to monitor and detect user access to the system.|Yes|Yes||
|Security - Info|Yes|[NCBMSecurityLogs](/azure/azure-monitor/reference/tables/ncbmsecuritylogs)<p>Security log events on Nexus Baremetal Machines to monitor and detect user access to the system.|Yes|Yes||
|Security - Notice|Yes|[NCBMSecurityLogs](/azure/azure-monitor/reference/tables/ncbmsecuritylogs)<p>Security log events on Nexus Baremetal Machines to monitor and detect user access to the system.|Yes|Yes||
|Security - Warning|Yes||No|No||
|System - Critical|Yes|[NCBMSystemLogs](/azure/azure-monitor/reference/tables/ncbmsystemlogs)<p>Syslog events on Nexus Baremetal Machines providing critical insights into system activities, errors and anomalies for effecient troubleshooting and monitoring.|Yes|Yes||
|System - Debug|Yes|[NCBMSystemLogs](/azure/azure-monitor/reference/tables/ncbmsystemlogs)<p>Syslog events on Nexus Baremetal Machines providing critical insights into system activities, errors and anomalies for effecient troubleshooting and monitoring.|Yes|Yes||
|System - Error|Yes|[NCBMSystemLogs](/azure/azure-monitor/reference/tables/ncbmsystemlogs)<p>Syslog events on Nexus Baremetal Machines providing critical insights into system activities, errors and anomalies for effecient troubleshooting and monitoring.|Yes|Yes||
|System - Info|Yes|[NCBMSystemLogs](/azure/azure-monitor/reference/tables/ncbmsystemlogs)<p>Syslog events on Nexus Baremetal Machines providing critical insights into system activities, errors and anomalies for effecient troubleshooting and monitoring.|Yes|Yes||
|System - Notice|Yes|[NCBMSystemLogs](/azure/azure-monitor/reference/tables/ncbmsystemlogs)<p>Syslog events on Nexus Baremetal Machines providing critical insights into system activities, errors and anomalies for effecient troubleshooting and monitoring.|Yes|Yes||
|System - Warning|Yes|[NCBMSystemLogs](/azure/azure-monitor/reference/tables/ncbmsystemlogs)<p>Syslog events on Nexus Baremetal Machines providing critical insights into system activities, errors and anomalies for effecient troubleshooting and monitoring.|Yes|Yes||

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
