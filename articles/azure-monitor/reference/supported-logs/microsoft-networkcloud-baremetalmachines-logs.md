---
title: Supported log categories - Microsoft.NetworkCloud/bareMetalMachines
description: Reference for Microsoft.NetworkCloud/bareMetalMachines in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.NetworkCloud/bareMetalMachines, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.NetworkCloud/bareMetalMachines

The following table lists the types of logs available for the Microsoft.NetworkCloud/bareMetalMachines resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.NetworkCloud/bareMetalMachines](../supported-metrics/microsoft-networkcloud-baremetalmachines-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`DefenderSecurity` |Security - Defender |[NCBMSecurityDefenderLogs](/azure/azure-monitor/reference/tables/ncbmsecuritydefenderlogs)<p>Security log events on Nexus Baremetal Machines to monitor and detect user access to the system.|Yes|Yes||Yes |
|`NexusBreakGlassAudit` |Security - Break Glass Audit |[NCBMBreakGlassAuditLogs](/azure/azure-monitor/reference/tables/ncbmbreakglassauditlogs)<p>Security log events on Nexus Baremetal Machines to monitor and detect user access to the system.|Yes|Yes||Yes |
|`SecurityAudit` |Security - Audit ||No|No||Yes |
|`SecurityCritical` |Security - Critical ||No|No||Yes |
|`SecurityDebug` |Security - Debug |[NCBMSecurityLogs](/azure/azure-monitor/reference/tables/ncbmsecuritylogs)<p>Security log events on Nexus Baremetal Machines to monitor and detect user access to the system.|Yes|Yes||Yes |
|`SecurityError` |Security - Error |[NCBMSecurityLogs](/azure/azure-monitor/reference/tables/ncbmsecuritylogs)<p>Security log events on Nexus Baremetal Machines to monitor and detect user access to the system.|Yes|Yes||Yes |
|`SecurityInfo` |Security - Info |[NCBMSecurityLogs](/azure/azure-monitor/reference/tables/ncbmsecuritylogs)<p>Security log events on Nexus Baremetal Machines to monitor and detect user access to the system.|Yes|Yes||Yes |
|`SecurityNotice` |Security - Notice |[NCBMSecurityLogs](/azure/azure-monitor/reference/tables/ncbmsecuritylogs)<p>Security log events on Nexus Baremetal Machines to monitor and detect user access to the system.|Yes|Yes||Yes |
|`SecurityWarning` |Security - Warning ||No|No||Yes |
|`SyslogCritical` |System - Critical |[NCBMSystemLogs](/azure/azure-monitor/reference/tables/ncbmsystemlogs)<p>Syslog events on Nexus Baremetal Machines providing critical insights into system activities, errors and anomalies for effecient troubleshooting and monitoring.|Yes|Yes||Yes |
|`SyslogDebug` |System - Debug |[NCBMSystemLogs](/azure/azure-monitor/reference/tables/ncbmsystemlogs)<p>Syslog events on Nexus Baremetal Machines providing critical insights into system activities, errors and anomalies for effecient troubleshooting and monitoring.|Yes|Yes||Yes |
|`SyslogError` |System - Error |[NCBMSystemLogs](/azure/azure-monitor/reference/tables/ncbmsystemlogs)<p>Syslog events on Nexus Baremetal Machines providing critical insights into system activities, errors and anomalies for effecient troubleshooting and monitoring.|Yes|Yes||Yes |
|`SyslogInfo` |System - Info |[NCBMSystemLogs](/azure/azure-monitor/reference/tables/ncbmsystemlogs)<p>Syslog events on Nexus Baremetal Machines providing critical insights into system activities, errors and anomalies for effecient troubleshooting and monitoring.|Yes|Yes||Yes |
|`SyslogNotice` |System - Notice |[NCBMSystemLogs](/azure/azure-monitor/reference/tables/ncbmsystemlogs)<p>Syslog events on Nexus Baremetal Machines providing critical insights into system activities, errors and anomalies for effecient troubleshooting and monitoring.|Yes|Yes||Yes |
|`SyslogWarning` |System - Warning |[NCBMSystemLogs](/azure/azure-monitor/reference/tables/ncbmsystemlogs)<p>Syslog events on Nexus Baremetal Machines providing critical insights into system activities, errors and anomalies for effecient troubleshooting and monitoring.|Yes|Yes||Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
