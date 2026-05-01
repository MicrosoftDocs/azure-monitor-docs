---
title: Supported metrics - Microsoft.Network/loadBalancers
description: Reference for Microsoft.Network/loadBalancers metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Network/loadBalancers, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Network/loadBalancers

The following table lists the metrics available for the Microsoft.Network/loadBalancers resource type.

**Table headings**

**Metric** - The metric display name as it appears in the Azure portal.
**Name in Rest API** - Metric name as referred to in the [REST API](/azure/azure-monitor/essentials/rest-api-walkthrough).
**Unit** - Unit of measure.
**Aggregation** - The default [aggregation](/azure/azure-monitor/essentials/metrics-aggregation-explained) type. Valid values: Average, Minimum, Maximum, Total, Count.
**Dimensions** - [Dimensions](/azure/azure-monitor/essentials/metrics-aggregation-explained#dimensions-splitting-and-filtering) available for the metric.
**Time Grains** - [Intervals at which the metric is sampled](/azure/azure-monitor/essentials/metrics-aggregation-explained#granularity). For example, `PT1M` indicates that the metric is sampled every minute, `PT30M` every 30 minutes, `PT1H` every hour, and so on.
**DS Export**- Whether the metric is exportable to Azure Monitor Logs via Diagnostic Settings.

For information on exporting metrics, see - [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics) and [Create diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/create-diagnostic-settings?tabs=portal).

For information on metric retention, see [Azure Monitor Metrics overview](/azure/azure-monitor/essentials/data-platform-metrics#retention-of-metrics).


For a list of supported logs, see [Supported log categories - Microsoft.Network/loadBalancers](../supported-logs/microsoft-network-loadbalancers-logs.md)


|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Allocated SNAT Ports**<br><br>Total number of SNAT ports allocated within time period |`AllocatedSnatPorts` |Count |Average |`FrontendIPAddress`, `BackendIPAddress`, `ProtocolType`, `IsAwaitingRemoval`|PT1M |No|
|**Byte Count**<br><br>Total number of Bytes transmitted within time period |`ByteCount` |Bytes |Total (Sum) |`FrontendIPAddress`, `FrontendPort`, `Direction`, `Protocol`|PT1M |Yes|
|**Health Probe Status**<br><br>Average Load Balancer health probe status per time duration |`DipAvailability` |Count |Average |`ProtocolType`, `BackendPort`, `FrontendIPAddress`, `FrontendPort`, `BackendIPAddress`|PT1M |Yes|
|**Health Probe Status**<br><br>Azure Cross-region Load Balancer backend health and status per time duration |`GlobalBackendAvailability` |Count |Average |`FrontendIPAddress`, `FrontendPort`, `BackendIPAddress`, `ProtocolType`, `FrontendRegion`, `BackendRegion`|PT1M |Yes|
|**Packet Count**<br><br>Total number of Packets transmitted within time period |`PacketCount` |Count |Total (Sum) |`FrontendIPAddress`, `FrontendPort`, `Direction`, `Protocol`|PT1M |Yes|
|**SNAT Connection Count**<br><br>Total number of new SNAT connections created within time period |`SnatConnectionCount` |Count |Total (Sum) |`FrontendIPAddress`, `BackendIPAddress`, `ConnectionState`|PT1M |Yes|
|**SYN Count**<br><br>Total number of SYN Packets transmitted within time period |`SYNCount` |Count |Total (Sum) |`FrontendIPAddress`, `FrontendPort`, `Direction`, `Protocol`|PT1M |Yes|
|**Used SNAT Ports**<br><br>Total number of SNAT ports used within time period |`UsedSnatPorts` |Count |Average |`FrontendIPAddress`, `BackendIPAddress`, `ProtocolType`, `IsAwaitingRemoval`|PT1M |No|
|**Data Path Availability**<br><br>Average Load Balancer data path availability per time duration |`VipAvailability` |Count |Average |`FrontendIPAddress`, `FrontendPort`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
