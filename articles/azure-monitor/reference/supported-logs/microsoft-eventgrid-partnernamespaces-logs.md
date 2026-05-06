---
title: Supported log categories - Microsoft.EventGrid/partnerNamespaces
description: Reference for Microsoft.EventGrid/partnerNamespaces in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.EventGrid/partnerNamespaces, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.EventGrid/partnerNamespaces

The following table lists the types of logs available for the Microsoft.EventGrid/partnerNamespaces resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.EventGrid/partnerNamespaces](../supported-metrics/microsoft-eventgrid-partnernamespaces-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`DataPlaneRequests` |Data plane operations logs |[AegDataPlaneRequests](/azure/azure-monitor/reference/tables/aegdataplanerequests)<p>Logs for Event Grid data plane requests (publish and options) against a topic/domain/partnernamespace. It can be used for auditing purposes. Logs are aggregated over a minute and displays the total number of requests with specific request properties.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/aegdataplanerequests)|Yes |
|`PublishFailures` |Publish Failure Logs |[AegPublishFailureLogs](/azure/azure-monitor/reference/tables/aegpublishfailurelogs)<p>Azure Event Grid - event publish failure logs.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/aegpublishfailurelogs)|No |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
