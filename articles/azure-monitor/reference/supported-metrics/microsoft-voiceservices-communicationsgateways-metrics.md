---
title: Supported metrics - Microsoft.VoiceServices/CommunicationsGateways
description: Reference for Microsoft.VoiceServices/CommunicationsGateways metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.VoiceServices/CommunicationsGateways, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.VoiceServices/CommunicationsGateways

The following table lists the metrics available for the Microsoft.VoiceServices/CommunicationsGateways resource type.

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



### Category: Error
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Active Call Failures**<br><br>Percentage of active call failures |`ActiveCallFailures` |Percent |Average, Minimum, Maximum |`Region`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|

### Category: Preview Call Protection
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Bot Incoming Requests**<br><br>Count of the total number of incoming requests to the AI Voice Services bot |`ACGBotIncomingRequestsCounter` |Count |Total (Sum) |`BotType`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**AI Voice Services Incoming Requests**<br><br>Count of the total number of incoming requests to AI Voice Services |`ACGVBCIncomingRequestsCounter` |Count |Total (Sum) |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Fraud Detected Utterance Average**<br><br>Average number of utterances per call before a scam is detected |`AOCPVishingFraudDetectedHistogram` |Count |Average, Minimum, Maximum |`BotType`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Fraud Alert SMS Sent Counter**<br><br>Count of the total number of fraud warning SMSs sent |`AOCPVishingSmsSentCounter` |Count |Total (Sum) |`BotType`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|

### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Active Calls**<br><br>Count of the total number of active calls (signaling sessions) |`ActiveCalls` |Count |Average, Minimum, Maximum |`Region`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Active Emergency Calls**<br><br>Count of the total number of active emergency calls |`ActiveEmergencyCalls` |Count |Average, Minimum, Maximum |`Region`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**SIP 2xx Responses Received**<br><br>SIP 2xx Responses Received for both OPTIONS and INVITE SIP Methods by this Communications Gateway Resource from your Network |`OPTIONS2XXReceived` |Count |Total (Sum) |`Region`, `index`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**SIP 2xx Responses Sent**<br><br>SIP 2xx Responses Sent for both OPTIONS and INVITE SIP Methods by this Communications Gateway Resource to your Network |`OPTIONS2XXSent` |Count |Total (Sum) |`Region`, `index`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**SIP 3xx Responses Received**<br><br>SIP 3xx Responses Received for both OPTIONS and INVITE SIP Methods by this Communications Gateway Resource from your Network |`OPTIONS3XXReceived` |Count |Total (Sum) |`Region`, `index`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**SIP 3xx Responses Sent**<br><br>SIP 3xx Responses Sent for both OPTIONS and INVITE SIP Methods by this Communications Gateway Resource to your Network |`OPTIONS3XXSent` |Count |Total (Sum) |`Region`, `index`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**SIP 4xx Responses Received**<br><br>SIP 4xx Responses Received for both OPTIONS and INVITE SIP Methods by this Communications Gateway Resource from your Network |`OPTIONS4XXReceived` |Count |Total (Sum) |`Region`, `index`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**SIP 4xx Responses Sent**<br><br>SIP 4xx Responses Sent for both OPTIONS and INVITE SIP Methods by this Communications Gateway Resource to your Network |`OPTIONS4XXSent` |Count |Total (Sum) |`Region`, `index`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**SIP 5xx Responses Received**<br><br>SIP 5xx Responses Received for both OPTIONS and INVITE SIP Methods by this Communications Gateway Resource from your Network |`OPTIONS5XXReceived` |Count |Total (Sum) |`Region`, `index`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**SIP 5xx Responses Sent**<br><br>SIP 5xx Responses Sent for both OPTIONS and INVITE SIP Methods by this Communications Gateway Resource to your Network |`OPTIONS5XXSent` |Count |Total (Sum) |`Region`, `index`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**SIP 6xx Responses Received**<br><br>SIP 6xx Responses Received for both OPTIONS and INVITE SIP Methods by this Communications Gateway Resource from your Network |`OPTIONS6XXReceived` |Count |Total (Sum) |`Region`, `index`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**SIP 6xx Responses Sent**<br><br>SIP 6xx Responses Sent for both OPTIONS and INVITE SIP Methods by this Communications Gateway Resource to your Network |`OPTIONS6XXSent` |Count |Total (Sum) |`Region`, `index`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
