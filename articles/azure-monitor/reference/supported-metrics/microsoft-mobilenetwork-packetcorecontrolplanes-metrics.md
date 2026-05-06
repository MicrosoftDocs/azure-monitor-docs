---
title: Supported metrics - Microsoft.MobileNetwork/packetcorecontrolplanes
description: Reference for Microsoft.MobileNetwork/packetcorecontrolplanes metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.MobileNetwork/packetcorecontrolplanes, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.MobileNetwork/packetcorecontrolplanes

The following table lists the metrics available for the Microsoft.MobileNetwork/packetcorecontrolplanes resource type.

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



### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Active Session Count**<br><br>Number of active PDU/PDN sessions |`ActiveSessionCount` |Count |Total (Sum) |`3gppGen`, `SiteId`, `RanId`, `Dnn`|PT1M |No|
|**Authentication Attempts**<br><br>4G/5G authentication attempts rate (per minute) |`AuthAttempt` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Authentication Failures**<br><br>4G/5G authentication failure rate (per minute) |`AuthFailure` |Count |Total (Sum) |`3gppGen`, `SiteId`, `Result`|PT1M |No|
|**Authentication Successes**<br><br>4G/5G authentication success rate (per minute) |`AuthSuccess` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Connected NodeBs**<br><br>Number of connected gNodeBs or eNodeBs |`ConnectedNodebs` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Default Bearer Attach Attempt**<br><br>Default Bearer Attach Attempt rate (per minute) |`DefaultBearerAttachAttempt` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Default Bearer Attach Failure**<br><br>Default Bearer Attach Failure rate (per minute) |`DefaultBearerAttachFailure` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Default Bearer Attach Success**<br><br>Default Bearer Attach Success rate (per minute) |`DefaultBearerAttachSuccess` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**DeRegistration Attempts**<br><br>Deregistration (5G) or detachment (4G) attempts rate (per minute) |`DeRegistrationAttempt` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**DeRegistration Successes**<br><br>Deregistration (5G) or detachment (4G) success rate (per minute) |`DeRegistrationSuccess` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Diameter Peer Request Received**<br><br>Diameter Peer Request Received rate (per minute) |`DiameterPeerRequestReceived` |Count |Total (Sum) |`3gppGen`, `SiteId`, `CommandCode`|PT1M |No|
|**Diameter Peer Request Sent**<br><br>Diameter Peer Request Sent rate (per minute) |`DiameterPeerRequestSent` |Count |Total (Sum) |`3gppGen`, `SiteId`, `CommandCode`|PT1M |No|
|**Diameter Peer Response Received**<br><br>Diameter Peer Response Received rate (per minute) |`DiameterPeerResponseReceived` |Count |Total (Sum) |`3gppGen`, `SiteId`, `CommandCode`, `ResultCode`|PT1M |No|
|**Diameter Peer Response Sent**<br><br>Diameter Peer Response Sent rate (per minute) |`DiameterPeerResponseSent` |Count |Total (Sum) |`3gppGen`, `SiteId`, `CommandCode`, `ResultCode`|PT1M |No|
|**Initial Context Setup Failures**<br><br>4G/5G Initial Context Setup Failures message rate (per minute) |`InitialContextSetupFailure` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Initial Context Setup Requests**<br><br>4G/5G Initial Context Setup Request message rate (per minute) |`InitialContextSetupRequest` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Initial Context Setup Responses**<br><br>4G/5G Initial Context Setup Response message rate (per minute) |`InitialContextSetupResponse` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**N2 Handover Attempts**<br><br>N2Handover (5G) or s1Handover (4G) attempts rate (per minute) |`N2HandoverAttempt` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**N2 Handover Failures**<br><br>N2Handover (5G) or s1Handover (4G) failure rate (per minute) |`N2HandoverFailure` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**N2 Handover Successes**<br><br>N2Handover (5G) or s1Handover (4G) success rate (per minute) |`N2HandoverSuccess` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Paging Attempts**<br><br>4G/5G paging attempts rate (per minute) |`PagingAttempt` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Paging Failures**<br><br>4G/5G paging failure rate (per minute) |`PagingFailure` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**PDU Resource Setup Request**<br><br>PDU Resource Setup Request rate (per minute) |`PDUResourceSetupRequest` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**PDU Resource Setup Response**<br><br>PDU Resource Setup Response rate (per minute) |`PDUResourceSetupResponse` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Provisioned Subscribers**<br><br>Number of provisioned subscribers |`ProvisionedSubscribers` |Count |Total (Sum) |`SiteId`|PT1M |No|
|**Radius Access Accept Received**<br><br>Radius Access Accept Received rate (per minute) |`RadiusAccessAcceptReceived` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Radius Access Reject Received**<br><br>Radius Access Reject Received rate (per minute) |`RadiusAccessRejectReceived` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Radius Access Request Send Failed**<br><br>Radius Access Request Send Failed rate (per minute) |`RadiusAccessRequestSendFailed` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Radius Access Request Sent**<br><br>Radius Access Request Sent rate (per minute) |`RadiusAccessRequestSent` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Radius Access Request Timeout**<br><br>Radius Access Request Timeout rate (per minute) |`RadiusAccessRequestTimeout` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**RAN Setup Failures**<br><br>RAN setup failure rate (per minute) |`RanSetupFailure` |Count |Total (Sum) |`3gppGen`, `SiteId`, `Cause`|PT1M |No|
|**RAN Setup Requests**<br><br>RAN setup request rate (per minute) |`RanSetupRequest` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**RAN Setup Successes**<br><br>RAN setup success rate (per minute) |`RanSetupSuccess` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Registered Subscribers**<br><br>Number of registered subscribers |`RegisteredSubscribers` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Registered Subscribers Connected**<br><br>Number of registered and connected subscribers |`RegisteredSubscribersConnected` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Registered Subscribers Idle**<br><br>Number of registered and idle subscribers |`RegisteredSubscribersIdle` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Registration Attempts**<br><br>Registration (5G) or attachment (4G) attempts rate (per minute) |`RegistrationAttempt` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Registration Failures**<br><br>Registration (5G) or attachment (4G) failure rate (per minute) |`RegistrationFailure` |Count |Total (Sum) |`3gppGen`, `SiteId`, `Result`|PT1M |No|
|**Registration Successes**<br><br>Registration (5G) or attachment (4G) success rate (per minute) |`RegistrationSuccess` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Service Request Attempts**<br><br>4G/5G service request attempts rate (per minute) |`ServiceRequestAttempt` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Service Request Failures**<br><br>4G/5G service request failure rate (per minute) |`ServiceRequestFailure` |Count |Total (Sum) |`3gppGen`, `SiteId`, `Result`, `Tai`|PT1M |No|
|**Service Request Successes**<br><br>4G/5G service request success rate (per minute) |`ServiceRequestSuccess` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Session Establishment Attempts**<br><br>PDU/PDN session establishment attempts rate (per minute) |`SessionEstablishmentAttempt` |Count |Total (Sum) |`3gppGen`, `SiteId`, `Dnn`|PT1M |No|
|**Session Establishment Failures**<br><br>PDU/PDN session establishment failure rate (per minute) |`SessionEstablishmentFailure` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Session Establishment Successes**<br><br>PDU/PDN session establishment success rate (per minute) |`SessionEstablishmentSuccess` |Count |Total (Sum) |`3gppGen`, `SiteId`, `Dnn`|PT1M |No|
|**Session Releases**<br><br>Session release rate (per minute) |`SessionRelease` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**UE Context Release Commands**<br><br>4G/5G UE context release command message rate (per minute) |`UeContextReleaseCommand` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**UE Context Release Completes**<br><br>4G/5G UE context release complete message rate (per minute) |`UeContextReleaseComplete` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**UE Context Release Requests**<br><br>4G/5G UE context release request message rate (per minute) |`UeContextReleaseRequest` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Xn Handover Attempts**<br><br>XnHandover (5G) or X2Handover (4G) attempts rate (per minute) |`XnHandoverAttempt` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Xn Handover Failures**<br><br>XnHandover (5G) or X2Handover (4G) failure rate (per minute) |`XnHandoverFailure` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|
|**Xn Handover Successes**<br><br>XnHandover (5G) or X2Handover (4G) success rate (per minute) |`XnHandoverSuccess` |Count |Total (Sum) |`3gppGen`, `SiteId`|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
