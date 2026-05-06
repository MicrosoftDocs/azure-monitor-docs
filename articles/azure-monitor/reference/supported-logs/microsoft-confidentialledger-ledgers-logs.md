---
title: Supported log categories - Microsoft.ConfidentialLedger/Ledgers
description: Reference for Microsoft.ConfidentialLedger/Ledgers in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 08/28/2025
ms.custom: Microsoft.ConfidentialLedger/Ledgers, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.ConfidentialLedger/Ledgers

The following table lists the types of logs available for the Microsoft.ConfidentialLedger/Ledgers resource type.


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`transactionlogs` |Azure Confidential Ledger activity Logs with UserId |[ACLTransactionLogs](/azure/azure-monitor/reference/tables/acltransactionlogs)<p>Logs related to transactions.|Yes|No|[Queries](/azure/azure-monitor/reference/queries/acltransactionlogs)|Yes |
|`userdefinedlogs` |Azure Confidential Ledger UDE/UDF logs |[ACLUserDefinedLogs](/azure/azure-monitor/reference/tables/acluserdefinedlogs)<p>Logs related to User Defined Functions and User Defined Endpoints.|Yes|No|[Queries](/azure/azure-monitor/reference/queries/acluserdefinedlogs)|Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
