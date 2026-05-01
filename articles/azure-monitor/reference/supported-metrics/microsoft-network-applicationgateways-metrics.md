---
title: Supported metrics - Microsoft.Network/applicationgateways
description: Reference for Microsoft.Network/applicationgateways metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Network/applicationgateways, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.Network/applicationgateways

The following table lists the metrics available for the Microsoft.Network/applicationgateways resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.Network/applicationgateways](../supported-logs/microsoft-network-applicationgateways-logs.md)


|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Application Gateway Total Time**<br><br>Time that it takes for a request to be processed and its response to be sent. This is the interval from the time when Application Gateway receives the first byte of an HTTP request to the time when the response send operation finishes. It's important to note that this usually includes the Application Gateway processing time, time that the request and response packets are traveling over the network and the time the backend server took to respond. |`ApplicationGatewayTotalTime` |MilliSeconds |Average, Maximum |`Listener`|PT1M |No|
|**Requests per minute per Healthy Host**<br><br>Average request count per minute per healthy backend host in a pool |`AvgRequestCountPerHealthyHost` |Count |Average |`BackendSettingsPool`|PT1M |No|
|**WAF Bot Protection Matches**<br><br>Matched Bot Rules |`AzwafBotProtection` |Count |Total (Sum) |`Action`, `Category`, `Mode`, `CountryCode`, `PolicyName`, `PolicyScope`|PT1M |Yes|
|**WAF CAPTCHA Request Count**<br><br>Total number of CAPTCHA requests evaluated by WAF |`AzWAFCaptchaChallengeRequestCount` |Count |Total (Sum) |`Action`, `PolicyName`, `Rule`, `PolicyScope`|PT1M |Yes|
|**WAF Custom Rule Matches**<br><br>Matched Custom Rules |`AzwafCustomRule` |Count |Total (Sum) |`Action`, `CustomRuleID`, `Mode`, `CountryCode`, `PolicyName`, `PolicyScope`|PT1M |Yes|
|**WAF JS Challenge Request Count**<br><br>Total number of JS challenge requests evaluated by WAF |`AzWAFJSChallengeRequestCount` |Count |Total (Sum) |`Action`, `PolicyName`, `Rule`, `PolicyScope`|PT1M |Yes|
|**WAF Penalty Box Hits**<br><br>Denotes number of times IP was added or updated in the penalty box with time and context. |`AzwafPenaltyBoxHits` |Count |Average, Total (Sum) |\<none\>|PT1M |Yes|
|**WAF Penalty Box Size**<br><br>Denotes number of IPs in the penalty box at a given time. |`AzwafPenaltyBoxSize` |Count |Average, Total (Sum) |\<none\>|PT1M |Yes|
|**WAF Managed Rule Matches**<br><br>Matched Managed Rules |`AzwafSecRule` |Count |Total (Sum) |`Action`, `Mode`, `RuleGroupID`, `RuleID`, `CountryCode`, `PolicyName`, `PolicyScope`, `RuleSetName`|PT1M |Yes|
|**WAF Total Requests**<br><br>Total number of requests evaluated by WAF |`AzwafTotalRequests` |Count |Total (Sum) |`Action`, `CountryCode`, `Method`, `Mode`, `PolicyName`, `PolicyScope`|PT1M |Yes|
|**Backend Connect Time**<br><br>Time spent establishing a connection with a backend server |`BackendConnectTime` |MilliSeconds |Average, Maximum |`Listener`, `BackendServer`, `BackendPool`, `BackendHttpSetting`|PT1M |No|
|**Backend First Byte Response Time**<br><br>Time interval between start of establishing a connection to backend server and receiving the first byte of the response header, approximating processing time of backend server |`BackendFirstByteResponseTime` |MilliSeconds |Average, Maximum |`Listener`, `BackendServer`, `BackendPool`, `BackendHttpSetting`|PT1M |No|
|**Backend Last Byte Response Time**<br><br>Time interval between start of establishing a connection to backend server and receiving the last byte of the response body |`BackendLastByteResponseTime` |MilliSeconds |Average, Maximum |`Listener`, `BackendServer`, `BackendPool`, `BackendHttpSetting`|PT1M |No|
|**Backend Response Status**<br><br>The number of HTTP response codes generated by the backend members. This does not include any response codes generated by the Application Gateway. |`BackendResponseStatus` |Count |Total (Sum) |`BackendServer`, `BackendPool`, `BackendHttpSetting`, `HttpStatusGroup`|PT1M |Yes|
|**Web Application Firewall Blocked Requests Rule Distribution**<br><br>Web Application Firewall blocked requests rule distribution |`BlockedCount` |Count |Total (Sum) |`RuleGroup`, `RuleId`|PT1M |Yes|
|**Bytes Received**<br><br>The total number of bytes received by the Application Gateway from the clients |`BytesReceived` |Bytes |Total (Sum) |`Listener`|PT1M |Yes|
|**Bytes Sent**<br><br>The total number of bytes sent by the Application Gateway to the clients |`BytesSent` |Bytes |Total (Sum) |`Listener`|PT1M |Yes|
|**Current Capacity Units**<br><br>Capacity Units consumed |`CapacityUnits` |Count |Average |\<none\>|PT1M |No|
|**Client RTT**<br><br>Round trip time between clients and Application Gateway. This metric indicates how long it takes to establish connections and return acknowledgements |`ClientRtt` |MilliSeconds |Average, Maximum |`Listener`|PT1M |No|
|**Current Compute Units**<br><br>Compute Units consumed |`ComputeUnits` |Count |Average |\<none\>|PT1M |No|
|**CPU Utilization**<br><br>Current CPU utilization of the Application Gateway |`CpuUtilization` |Percent |Average |\<none\>|PT1M |No|
|**Current Connections**<br><br>Count of current connections established with Application Gateway |`CurrentConnections` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**Estimated Billed Capacity Units**<br><br>Estimated capacity units that will be charged |`EstimatedBilledCapacityUnits` |Count |Average |\<none\>|PT1M |No|
|**Failed Requests**<br><br>Count of failed requests that Application Gateway has served |`FailedRequests` |Count |Total (Sum) |`BackendSettingsPool`|PT1M |Yes|
|**Fixed Billable Capacity Units**<br><br>Minimum capacity units that will be charged |`FixedBillableCapacityUnits` |Count |Average |\<none\>|PT1M |No|
|**Healthy Host Count**<br><br>Number of healthy backend hosts |`HealthyHostCount` |Count |Average |`BackendSettingsPool`|PT1M |Yes|
|**Web Application Firewall Total Rule Distribution**<br><br>Web Application Firewall Total Rule Distribution for the incoming traffic |`MatchedCount` |Count |Total (Sum) |`RuleGroup`, `RuleId`|PT1M |Yes|
|**New connections per second**<br><br>New connections per second established with Application Gateway |`NewConnectionsPerSecond` |CountPerSecond |Average |\<none\>|PT1M |No|
|**Response Status**<br><br>Http response status returned by Application Gateway |`ResponseStatus` |Count |Total (Sum) |`HttpStatusGroup`|PT1M |Yes|
|**Throughput**<br><br>Number of bytes per second the Application Gateway has served |`Throughput` |BytesPerSecond |Average |\<none\>|PT1M |No|
|**Client TLS Protocol**<br><br>The number of TLS and non-TLS requests initiated by the client that established connection with the Application Gateway. To view TLS protocol distribution, filter by the dimension TLS Protocol. |`TlsProtocol` |Count |Total (Sum) |`Listener`, `TlsProtocol`|PT1M |Yes|
|**Total Requests**<br><br>Count of successful requests that Application Gateway has served |`TotalRequests` |Count |Total (Sum) |`BackendSettingsPool`|PT1M |Yes|
|**Unhealthy Host Count**<br><br>Number of unhealthy backend hosts |`UnhealthyHostCount` |Count |Average |`BackendSettingsPool`|PT1M |Yes|
|**WebSocket Active Connections**<br><br>Count of WebSocket Active Connections established with Application Gateway |`WebSocketActiveConnections` |Count |Total (Sum) |\<none\>|PT1M |Yes|
|**WebSocket Specific Close Status Code**<br><br>Count of WebSocket Specific Close Status Code |`WebsocketSpecificCloseStatusCode` |Count |Total (Sum) |`RequestSource`, `CloseStatus`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
