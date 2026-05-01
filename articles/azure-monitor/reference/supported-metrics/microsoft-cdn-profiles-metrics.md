---
title: Supported metrics - Microsoft.Cdn/profiles
description: Reference for Microsoft.Cdn/profiles metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Cdn/profiles, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Cdn/profiles

The following table lists the metrics available for the Microsoft.Cdn/profiles resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.Cdn/profiles](../supported-logs/microsoft-cdn-profiles-logs.md)


### Category: Latency
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Origin Latency**<br><br>The time calculated from when the request was sent by AFDX edge to the backend until AFDX received the last response byte from the backend. |`OriginLatency` |MilliSeconds |Average |`Origin`, `Endpoint`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Total Latency**<br><br>The time calculated from when the client request was received by the HTTP/S proxy until the client acknowledged the last response byte from the HTTP/S proxy |`TotalLatency` |MilliSeconds |Average |`HttpStatus`, `HttpStatusGroup`, `ClientRegion`, `ClientCountry`, `Endpoint`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|

### Category: Origin Health
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Origin Health Percentage**<br><br>The percentage of successful health probes from AFDX to backends. |`OriginHealthPercentage` |Percent |Average |`Origin`, `OriginGroup`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|

### Category: Request Status
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Byte Hit Ratio**<br><br>This is the ratio of the total bytes served from the cache compared to the total response bytes |`ByteHitRatio` |Percent |Average |`Endpoint`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Percentage of 4XX**<br><br>The percentage of all the client requests for which the response status code is 4XX |`Percentage4XX` |Percent |Average |`Endpoint`, `ClientRegion`, `ClientCountry`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Percentage of 5XX**<br><br>The percentage of all the client requests for which the response status code is 5XX |`Percentage5XX` |Percent |Average |`Endpoint`, `ClientRegion`, `ClientCountry`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|

### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Active Websocket Connections**<br><br>The number of active WebSocket connection |`ActiveWebSocketConnections` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Average WebSocket Connection Duration**<br><br>The average time taken by WebSocket connection |`AverageWebSocketConnectionDuration` |MilliSeconds |Average |`HttpStatus`, `HttpStatusGroup`, `ClientRegion`, `ClientCountry`, `Endpoint`|PT1M |Yes|
|**Web Application Firewall HTTPDDoSRuleset Is Active**<br><br>Indicates whether the HTTP DDoS ruleset is active in the Web Application Firewall |`HTTPDDoSRulesetIsActive` |Count |Average |`PolicyName`|PT1M |Yes|
|**Origin Request Count**<br><br>The number of requests sent from AFDX to origin. |`OriginRequestCount` |Count |Total (Sum) |`HttpStatus`, `HttpStatusGroup`, `Origin`, `Endpoint`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Request Count**<br><br>The number of client requests served by the HTTP/S proxy |`RequestCount` |Count |Total (Sum) |`HttpStatus`, `HttpStatusGroup`, `ClientRegion`, `ClientCountry`, `Endpoint`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Request Size**<br><br>The number of bytes sent as requests from clients to AFDX. |`RequestSize` |Bytes |Total (Sum) |`HttpStatus`, `HttpStatusGroup`, `ClientRegion`, `ClientCountry`, `Endpoint`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Response Size**<br><br>The number of bytes sent as responses from HTTP/S proxy to clients |`ResponseSize` |Bytes |Total (Sum) |`HttpStatus`, `HttpStatusGroup`, `ClientRegion`, `ClientCountry`, `Endpoint`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Web Application Firewall CAPTCHA Request Count**<br><br>The number of CAPTCHA requests evaluated by the Web Application Firewall |`WebApplicationFirewallCaptchaRequestCount` |Count |Total (Sum) |`PolicyName`, `RuleName`, `Action`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Web Application Firewall JS Challenge Request Count**<br><br>The number of JS challenge requests evaluated by the Web Application Firewall |`WebApplicationFirewallJsRequestCount` |Count |Total (Sum) |`PolicyName`, `RuleName`, `Action`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Web Application Firewall Request Count**<br><br>The number of client requests processed by the Web Application Firewall |`WebApplicationFirewallRequestCount` |Count |Total (Sum) |`PolicyName`, `RuleName`, `Action`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**WebSocket Connections**<br><br>The number of WebSocket connections requested |`WebSocketConnections` |Count |Total (Sum) |`HttpStatus`, `HttpStatusGroup`, `ClientRegion`, `ClientCountry`, `Endpoint`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
