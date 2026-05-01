---
title: Supported metrics - microsoft.deviceregistry/namespaces
description: Reference for microsoft.deviceregistry/namespaces metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 03/27/2026
ms.custom: microsoft.deviceregistry/namespaces, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for microsoft.deviceregistry/namespaces

The following table lists the metrics available for the microsoft.deviceregistry/namespaces resource type.

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



### Category: Traffic (Business)
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Device Certificate Issued**<br><br>Total device certificates issued (including renewals/rotations). Use to track device certificate issuance volume by policy and verify provisioning flows. Updated every minute. |`DeviceCertificateIssued/Count` |Count |Total (Sum) |`PolicyName`, `Status`, `StatusCode`|PT1M |Yes|
|**Device Certificate Revoked**<br><br>Total device certificates revoked. Use to audit revocation activity, validate revocation policies, and detect unexpected spikes. Updated every minute. |`DeviceCertificateRevoked/Count` |Count |Total (Sum) |`PolicyName`, `Status`, `StatusCode`|PT1M |Yes|
|**Policy Certificate Issued**<br><br>Total policy certificates issued (including renewals/rotations). Use to track policy certificate (ICA) issuance volume. Updated every minute. |`PolicyCertificateIssued/Count` |Count |Total (Sum) |`PolicyName`, `Status`, `StatusCode`|PT1M |Yes|
|**Policy Certificate Revoked**<br><br>Total policy certificates revoked. Use to audit revocation activity, validate revocation policies, and detect unexpected spikes. Updated every minute. |`PolicyCertificateRevoked/Count` |Count |Total (Sum) |`PolicyName`, `Status`, `StatusCode`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
