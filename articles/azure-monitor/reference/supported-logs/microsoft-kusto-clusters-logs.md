---
title: Supported log categories - Microsoft.Kusto/clusters
description: Reference for Microsoft.Kusto/clusters in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Kusto/clusters, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.Kusto/clusters

The following table lists the types of logs available for the Microsoft.Kusto/clusters resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.Kusto/clusters](../supported-metrics/microsoft-kusto-clusters-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`Command` |Command |[ADXCommand](/azure/azure-monitor/reference/tables/adxcommand)<p>Azure Data Explorer command execution summary.|No|Yes||No |
|`DataOperation` |Data operation |[ADXDataOperation](/azure/azure-monitor/reference/tables/adxdataoperation)<p>Azure Data Explorer data operation summary.|No|No||Yes |
|`FailedIngestion` |Failed ingestion |[FailedIngestion](/azure/azure-monitor/reference/tables/failedingestion)<p>Failed ingestion operations logs provide detailed information about failed ingest operations. Logs include data source details, as well as error code and failure status (transient or permanent), that can be used for tracking the process of data source ingestion. Users can identify usage errors (permanent bad requests) and handle retries of transient failures. Ingestion logs are supported for queued ingestion to the ingestion endpoint using SDKs, data connections, and connectors.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/failedingestion)|No |
|`IngestionBatching` |Ingestion batching |[ADXIngestionBatching](/azure/azure-monitor/reference/tables/adxingestionbatching)<p>Azure Data Explorer ingestion batching operations. These logs have detailed statistics of batches ready for ingestion (duration, batch size and blobs count).|No|No|[Queries](/azure/azure-monitor/reference/queries/adxingestionbatching)|No |
|`Journal` |Journal |[ADXJournal](/azure/azure-monitor/reference/tables/adxjournal)<p>Azure Data Explorer journal (metadata operations).|No|Yes||Yes |
|`Query` |Query |[ADXQuery](/azure/azure-monitor/reference/tables/adxquery)<p>Azure Data Explorer query execution summary.|No|Yes||No |
|`SucceededIngestion` |Succeeded ingestion |[SucceededIngestion](/azure/azure-monitor/reference/tables/succeededingestion)<p>Succeeded ingestion operations logs provide information about successfully completed ingest operations. Logs include data source details that together with `Failed ingestion operations` logs can be used for tracking the process of ingestion of each data source. Ingestion logs are supported for queued ingestion to the ingestion endpoint using SDKs, data connections, and connectors.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/succeededingestion)|No |
|`TableDetails` |Table details |[ADXTableDetails](/azure/azure-monitor/reference/tables/adxtabledetails)<p>Azure Data Explorer table details.|No|Yes||No |
|`TableUsageStatistics` |Table usage statistics |[ADXTableUsageStatistics](/azure/azure-monitor/reference/tables/adxtableusagestatistics)<p>Azure Data Explorer table usage statistics.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/adxtableusagestatistics)|No |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
