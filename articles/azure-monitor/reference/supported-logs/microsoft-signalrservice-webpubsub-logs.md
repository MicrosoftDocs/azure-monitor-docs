---
title: Supported log categories - Microsoft.SignalRService/WebPubSub
description: Reference for Microsoft.SignalRService/WebPubSub in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.SignalRService/WebPubSub, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.SignalRService/WebPubSub

The following table lists the types of logs available for the Microsoft.SignalRService/WebPubSub resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.SignalRService/WebPubSub](../supported-metrics/microsoft-signalrservice-webpubsub-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`ConnectivityLogs` |Connectivity logs for Azure Web PubSub Service. |[WebPubSubConnectivity](/azure/azure-monitor/reference/tables/webpubsubconnectivity)<p>Connectivity logs provide detailed information for Azure Web PubSub hub connections. For example, basic information (user ID, connection ID, and so on) and event information (connect, disconnect, and abort event, and so on) and can be used to troubleshoot connection-related issues.|No|Yes||Yes |
|`HttpRequestLogs` |Http Request logs for Azure Web PubSub Service. |[WebPubSubHttpRequest](/azure/azure-monitor/reference/tables/webpubsubhttprequest)<p>Http request logs provide detailed information for the http requests received by Azure Web PubSub. For example, status code and url of the request and is helpful to troubleshoot request-related issues.|No|Yes||Yes |
|`MessagingLogs` |Messaging logs for Azure Web PubSub Service. |[WebPubSubMessaging](/azure/azure-monitor/reference/tables/webpubsubmessaging)<p>Messaging logs provide tracing information for the Azure Web PubSub hub messages received and sent via Azure Web PubSub service. For example, tracing ID and message type of the message. Typically the message is recorded when it arrives at or leaves from service and is helpful for troubleshooting message-related issues.|No|Yes||Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
