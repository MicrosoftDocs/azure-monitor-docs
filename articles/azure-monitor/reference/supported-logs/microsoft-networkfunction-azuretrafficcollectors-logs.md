---
title: Supported log categories - Microsoft.NetworkFunction/azureTrafficCollectors
description: Reference for Microsoft.NetworkFunction/azureTrafficCollectors in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.NetworkFunction/azureTrafficCollectors, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.NetworkFunction/azureTrafficCollectors

The following table lists the types of logs available for the Microsoft.NetworkFunction/azureTrafficCollectors resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.NetworkFunction/azureTrafficCollectors](../supported-metrics/microsoft-networkfunction-azuretrafficcollectors-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`ATCMicrosoftPeeringMetadata` |Microsoft Peering Metadata |[ATCMicrosoftPeeringMetadata](/azure/azure-monitor/reference/tables/atcmicrosoftpeeringmetadata)<p>This table has Microsoft Peering public IP metadata.|No|Yes||Yes |
|`ATCPrivatePeeringMetadata` |Private Peering Metadata |[ATCPrivatePeeringMetadata](/azure/azure-monitor/reference/tables/atcprivatepeeringmetadata)<p>This table has Private Peering Vnet metadata.|No|Yes||Yes |
|`ExpressRouteCircuitIpfix` |Express Route Circuit IPFIX Flow Records |[ATCExpressRouteCircuitIpfix](/azure/azure-monitor/reference/tables/atcexpressroutecircuitipfix)<p>This table has Express Route Circuit IPFIX flow records. Flow records are captured and emitted by Azure Traffic Collector (ATC).|No|Yes|[Queries](/azure/azure-monitor/reference/queries/atcexpressroutecircuitipfix)|Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
