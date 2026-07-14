---
title: Supported log categories - Microsoft.Synapse/workspaces/kustoPools
description: Reference for Microsoft.Synapse/workspaces/kustoPools in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 07/14/2026
ms.custom: Microsoft.Synapse/workspaces/kustoPools, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.Synapse/workspaces/kustoPools

The following table lists the types of logs available for the Microsoft.Synapse/workspaces/kustoPools resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.Synapse/workspaces/kustoPools](../supported-metrics/microsoft-synapse-workspaces-kustopools-metrics.md)


|Category|Costs to export|Log table|[Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)|Example queries|
|---|---|---|---|---|---|
|Command|Yes|[SynapseDXCommand](/azure/azure-monitor/reference/tables/synapsedxcommand)<p>Azure data explorer synapse command execution summary. Logs include DatabaseName, State, Duration that can be used for monitoring the commands which were invoked on the cluster|No|No||
|Data operation|Yes||No|No||
|Failed ingestion|Yes|[SynapseDXFailedIngestion](/azure/azure-monitor/reference/tables/synapsedxfailedingestion)<p>Failed ingestion operations logs provide detailed information about failed ingest operations. Logs include data source details, as well as error code and failure status (transient or permanent), that can be used for tracking the process of data source ingestion. Users can identify usage errors (permanent bad requests) and handle retries of transient failures. Ingestion logs are supported for queued ingestion to the ingestion endpoint using SDKs, data connections, and connectors|No|Yes||
|Ingestion batching|Yes|[SynapseDXIngestionBatching](/azure/azure-monitor/reference/tables/synapsedxingestionbatching)<p>Azure data explore synapse ingestion batching operations. These logs have detailed statistics of batches ready for ingestion (duration, batch size and blobs count)|No|No||
|Journal|Yes||No|No||
|Query|Yes|[SynapseDXQuery](/azure/azure-monitor/reference/tables/synapsedxquery)<p>Azure data explorer synpase query execution summary. Logs include DatabaseName, State, Duration that can be used for monitoring the queries which were invoked on the cluster|No|No||
|Succeeded ingestion|Yes|[SynapseDXSucceededIngestion](/azure/azure-monitor/reference/tables/synapsedxsucceededingestion)<p>Succeeded ingestion operations logs provide information about successfully completed ingest operations. Logs include data source details that together with `Failed ingestion operations` logs can be used for tracking the process of ingestion of each data source. Ingestion logs are supported for queued ingestion to the ingestion endpoint using SDKs, data connections, and connectors|No|Yes||
|Table details|Yes|[SynapseDXTableDetails](/azure/azure-monitor/reference/tables/synapsedxtabledetails)<p>Azure Data Explorer Synpase table details|No|No||
|Table usage statistics|Yes|[SynapseDXTableUsageStatistics](/azure/azure-monitor/reference/tables/synapsedxtableusagestatistics)<p>Azure date explorer synapse table usage statistics. Logs include DatabaseName, TableName, User that can be used for monitoring cluster's table usage|No|No||

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
