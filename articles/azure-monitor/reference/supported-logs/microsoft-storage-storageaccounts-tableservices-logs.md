---
title: Supported log categories - Microsoft.Storage/storageAccounts/tableServices
description: Reference for Microsoft.Storage/storageAccounts/tableServices in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 07/14/2026
ms.custom: Microsoft.Storage/storageAccounts/tableServices, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.Storage/storageAccounts/tableServices

The following table lists the types of logs available for the Microsoft.Storage/storageAccounts/tableServices resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.Storage/storageAccounts/tableServices](../supported-metrics/microsoft-storage-storageaccounts-tableservices-metrics.md)


|Category|Costs to export|Log table|[Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)|Example queries|
|---|---|---|---|---|---|
|StorageDelete|Yes|[StorageTableLogs](/azure/azure-monitor/reference/tables/storagetablelogs)<p>Storage Table Service Logs Schema|Yes|Yes||
|StorageRead|Yes|[StorageTableLogs](/azure/azure-monitor/reference/tables/storagetablelogs)<p>Storage Table Service Logs Schema|Yes|Yes||
|StorageWrite|Yes|[StorageTableLogs](/azure/azure-monitor/reference/tables/storagetablelogs)<p>Storage Table Service Logs Schema|Yes|Yes||

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
