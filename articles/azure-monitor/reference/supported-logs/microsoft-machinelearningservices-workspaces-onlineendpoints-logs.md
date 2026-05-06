---
title: Supported log categories - Microsoft.MachineLearningServices/workspaces/onlineEndpoints
description: Reference for Microsoft.MachineLearningServices/workspaces/onlineEndpoints in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.MachineLearningServices/workspaces/onlineEndpoints, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.MachineLearningServices/workspaces/onlineEndpoints

The following table lists the types of logs available for the Microsoft.MachineLearningServices/workspaces/onlineEndpoints resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.MachineLearningServices/workspaces/onlineEndpoints](../supported-metrics/microsoft-machinelearningservices-workspaces-onlineendpoints-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`AmlOnlineEndpointConsoleLog` |AmlOnlineEndpointConsoleLog |[AmlOnlineEndpointConsoleLog](/azure/azure-monitor/reference/tables/amlonlineendpointconsolelog)<p>Azure ML online endpoints console logs. It provides console logs output from user containers.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/amlonlineendpointconsolelog)|Yes |
|`AmlOnlineEndpointEventLog` |AmlOnlineEndpointEventLog |[AmlOnlineEndpointEventLog](/azure/azure-monitor/reference/tables/amlonlineendpointeventlog)<p>Azure ML online endpoints event logs. It provides event logs regarding the inference-server container's life cycle.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/amlonlineendpointeventlog)|Yes |
|`AmlOnlineEndpointTrafficLog` |AmlOnlineEndpointTrafficLog |[AmlOnlineEndpointTrafficLog](/azure/azure-monitor/reference/tables/amlonlineendpointtrafficlog)<p>Traffic logs for AzureML (machine learning) online endpoints. The table could be used to check the detailed information of the request to an online endpoint. For example, you could use it to check the request duration, the request failure reason, etc.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/amlonlineendpointtrafficlog)|Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
