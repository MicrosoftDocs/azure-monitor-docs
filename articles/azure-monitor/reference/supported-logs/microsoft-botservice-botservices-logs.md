---
title: Supported log categories - microsoft.botservice/botservices
description: Reference for microsoft.botservice/botservices in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: microsoft.botservice/botservices, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for microsoft.botservice/botservices

The following table lists the types of logs available for the microsoft.botservice/botservices resource type.

For a list of supported metrics, see [Supported metrics - microsoft.botservice/botservices](../supported-metrics/microsoft-botservice-botservices-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`BotRequest` |Requests from the channels to the bot |[ABSBotRequests](/azure/azure-monitor/reference/tables/absbotrequests)<p>Logs of requests made by Azure Bot Service onbehalf of a bot such as requests from channel to bot and to other dependencies.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/absbotrequests)|Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
