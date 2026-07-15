---
title: Supported metrics - Microsoft.Network/virtualHubs
description: Reference for Microsoft.Network/virtualHubs metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 07/13/2026
ms.custom: Microsoft.Network/virtualHubs, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Network/virtualHubs

The following table lists the metrics available for the Microsoft.Network/virtualHubs resource type.

**Table headings**

- **Metric** - The metric display name as it appears in the Azure portal.
- **Name in Rest API** - Metric name as referred to in the [REST API](/azure/azure-monitor/essentials/rest-api-walkthrough).
- **Advanced platform metrics** - A premium, [paid tier of platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform) in Azure Monitor that provide more granular observability for Azure resources.
- **Unit** - Unit of measure.
- **Aggregation** - The default [aggregation](/azure/azure-monitor/essentials/metrics-aggregation-explained) type. Valid values: Average, Minimum, Maximum, Total, Count.
- **Dimensions** - [Dimensions](/azure/azure-monitor/essentials/metrics-aggregation-explained#dimensions-splitting-and-filtering) available for the metric.
- **Time Grains** - [Intervals at which the metric is sampled](/azure/azure-monitor/essentials/metrics-aggregation-explained#granularity). For example, `PT1M` indicates that the metric is sampled every minute, `PT30M` every 30 minutes, `PT1H` every hour, and so on.
- **DS Export** -S Whether the metric is exportable to Azure Monitor Logs via Diagnostic Settings.

For information on exporting metrics, see - [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics) and [Create diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/create-diagnostic-settings?tabs=portal).

For information on metric retention, see [Azure Monitor Metrics overview](/azure/azure-monitor/essentials/data-platform-metrics#retention-of-metrics).



### Category: Scalability
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Bgp Peer Status**<br><br>1 - Connected, 0 - Not connected |`BgpPeerStatus` | No | Count |Maximum |`routeserviceinstance`, `bgppeerip`, `bgppeertype`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Count Of Routes Advertised To Peer**<br><br>Total number of routes advertised to peer |`CountOfRoutesAdvertisedToPeer` | No | Count |Maximum |`routeserviceinstance`, `bgppeerip`, `bgppeertype`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Count Of Routes Learned From Peer**<br><br>Total number of routes learned from peer |`CountOfRoutesLearnedFromPeer` | No | Count |Maximum |`routeserviceinstance`, `bgppeerip`, `bgppeertype`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Routing Infrastructure Units**<br><br>Total number of routing infrastructure units, which represent the virtual hub's capacity |`RoutingInfrastructureUnits` | No | Count |Maximum |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Spoke VM Utilization**<br><br>Number of deployed spoke VMs as a percentage of the total number of spoke VMs that the hub's routing infrastructure units can support |`SpokeVMUtilization` | No | Percent |Maximum |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|

### Category: Traffic
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Data Processed by the Virtual Hub Router**<br><br>Data on how much traffic traverses the virtual hub router in a given time period. Only the following flows use the virtual hub router: VNet to VNet (same hub and interhub) and branch to VNet (interhub). If a virtual hub is secured with routing intent, then these flows traverse the firewall instead of the hub router. |`VirtualHubDataProcessed` | No | Bytes |Total (Sum) |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
