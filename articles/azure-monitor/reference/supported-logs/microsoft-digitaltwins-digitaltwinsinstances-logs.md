---
title: Supported log categories - Microsoft.DigitalTwins/digitalTwinsInstances
description: Reference for Microsoft.DigitalTwins/digitalTwinsInstances in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 07/14/2026
ms.custom: Microsoft.DigitalTwins/digitalTwinsInstances, arm

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.DigitalTwins/digitalTwinsInstances

The following table lists the types of logs available for the Microsoft.DigitalTwins/digitalTwinsInstances resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.DigitalTwins/digitalTwinsInstances](../supported-metrics/microsoft-digitaltwins-digitaltwinsinstances-metrics.md)


|Category|Costs to export|Log table|[Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)|Example queries|
|---|---|---|---|---|---|
|DataHistoryOperation|Yes|[ADTDataHistoryOperation](/azure/azure-monitor/reference/tables/adtdatahistoryoperation)<p>This table tracks all data history events being published to time series database connections.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/adtdatahistoryoperation)|
|DigitalTwinsOperation|No|[ADTDigitalTwinsOperation](/azure/azure-monitor/reference/tables/adtdigitaltwinsoperation)<p>Schema for Azure Digital Twins' Digital Twin operations. The Digital Twins Operation category tracks all customer requests to manage a digital twin, including CRUD on Twins and Relationships.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/adtdigitaltwinsoperation)|
|EventRoutesOperation|No|[ADTEventRoutesOperation](/azure/azure-monitor/reference/tables/adteventroutesoperation)<p>Schema for Azure Digital Twins' Event Routes operations. The Event Routes Operation category tracks all events being published to endpoints, which are other Azure services.|No|No|[Queries](/azure/azure-monitor/reference/queries/adteventroutesoperation)|
|ModelsOperation|No|[ADTModelsOperation](/azure/azure-monitor/reference/tables/adtmodelsoperation)<p>Schema for Azure Digital Twins' Models operations. The Models Operation category tracks all customer requests to manage models in a digital twins instance.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/adtmodelsoperation)|
|QueryOperation|No|[ADTQueryOperation](/azure/azure-monitor/reference/tables/adtqueryoperation)<p>Schema for Azure Digital Twins' Query operations. The Query Operation category tracks all customer requests to query their digital twins instance.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/adtqueryoperation)|
|ResourceProviderOperation|Yes||No|No||

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
