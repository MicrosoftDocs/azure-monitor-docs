---
title: Supported log categories - Microsoft.StandbyPool/standbyvirtualmachinepools
description: Reference for Microsoft.StandbyPool/standbyvirtualmachinepools in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.StandbyPool/standbyvirtualmachinepools, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.StandbyPool/standbyvirtualmachinepools

The following table lists the types of logs available for the Microsoft.StandbyPool/standbyvirtualmachinepools resource type.


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`Execution` |Standby virtual machine pool updates |[SVMPoolExecutionLog](/azure/azure-monitor/reference/tables/svmpoolexecutionlog)<p>Contains Execution Logs for a StandbyVirtualMachinePool, which can be used for audit and troubleshooting.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/svmpoolexecutionlog)|Yes |
|`Request` |Standby virtual machine pool settings updates |[SVMPoolRequestLog](/azure/azure-monitor/reference/tables/svmpoolrequestlog)<p>Contains Request Logs for a StandbyVirtualMachinePool, which can be used for audit and troubleshooting.|Yes|Yes|[Queries](/azure/azure-monitor/reference/queries/svmpoolrequestlog)|Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
