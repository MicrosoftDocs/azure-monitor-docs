---
title: Supported metrics - Microsoft.IoTCentral/IoTApps
description: Reference for Microsoft.IoTCentral/IoTApps metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.IoTCentral/IoTApps, arm

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.IoTCentral/IoTApps

The following table lists the metrics available for the Microsoft.IoTCentral/IoTApps resource type.

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



|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Failed command invocations**<br><br>The count of all failed command requests initiated from IoT Central |`c2d.commands.failure` |Count |Total (Sum) |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Request size of command invocations**<br><br>Request size of all command requests initiated from IoT Central |`c2d.commands.requestSize` |Bytes |Total (Sum) |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Response size of command invocations**<br><br>Response size of all command responses initiated from IoT Central |`c2d.commands.responseSize` |Bytes |Total (Sum) |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Successful command invocations**<br><br>The count of all successful command requests initiated from IoT Central |`c2d.commands.success` |Count |Total (Sum) |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Failed Device Property Reads from IoT Central**<br><br>The count of all failed property reads initiated from IoT Central |`c2d.property.read.failure` |Count |Total (Sum) |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Successful Device Property Reads from IoT Central**<br><br>The count of all successful property reads initiated from IoT Central |`c2d.property.read.success` |Count |Total (Sum) |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Failed Device Property Updates from IoT Central**<br><br>The count of all failed property updates initiated from IoT Central |`c2d.property.update.failure` |Count |Total (Sum) |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Successful Device Property Updates from IoT Central**<br><br>The count of all successful property updates initiated from IoT Central |`c2d.property.update.success` |Count |Total (Sum) |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Total Connected Devices**<br><br>Number of devices connected to IoT Central |`connectedDeviceCount` |Count |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|
|**Failed Device Property Reads from Devices**<br><br>The count of all failed property reads initiated from devices |`d2c.property.read.failure` |Count |Total (Sum) |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Successful Device Property Reads from Devices**<br><br>The count of all successful property reads initiated from devices |`d2c.property.read.success` |Count |Total (Sum) |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Failed Device Property Updates from Devices**<br><br>The count of all failed property updates initiated from devices |`d2c.property.update.failure` |Count |Total (Sum) |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Successful Device Property Updates from Devices**<br><br>The count of all successful property updates initiated from devices |`d2c.property.update.success` |Count |Total (Sum) |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Total Telemetry Message Send Attempts**<br><br>Number of device-to-cloud telemetry messages attempted to be sent to the IoT Central application |`d2c.telemetry.ingress.allProtocol` |Count |Total (Sum) |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Total Telemetry Messages Sent**<br><br>Number of device-to-cloud telemetry messages successfully sent to the IoT Central application |`d2c.telemetry.ingress.success` |Count |Total (Sum) |\<none\>|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Data Export Errors**<br><br>Number of errors encountered for data export |`dataExport.error` |Count |Total (Sum) |`exportId`, `exportDisplayName`, `destinationId`, `destinationDisplayName`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Data Export Messages Filtered**<br><br>Number of messages that have passed through filters in data export |`dataExport.messages.filtered` |Count |Total (Sum) |`exportId`, `exportDisplayName`, `destinationId`, `destinationDisplayName`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Data Export Messages Received**<br><br>Number of messages incoming to data export, before filtering and enrichment processing |`dataExport.messages.received` |Count |Total (Sum) |`exportId`, `exportDisplayName`, `destinationId`, `destinationDisplayName`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Data Export Messages Written**<br><br>Number of messages written to a destination |`dataExport.messages.written` |Count |Total (Sum) |`exportId`, `exportDisplayName`, `destinationId`, `destinationDisplayName`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Data Export Status Change**<br><br>Number of status changes |`dataExport.statusChange` |Count |Total (Sum) |`exportId`, `exportDisplayName`, `destinationId`, `destinationDisplayName`, `status`|PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Total Device Data Usage**<br><br>Bytes transferred to and from any devices connected to IoT Central application |`deviceDataUsage` |Bytes |Total (Sum) |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |Yes|
|**Total Provisioned Devices**<br><br>Number of devices provisioned in IoT Central application |`provisionedDeviceCount` |Count |Average |\<none\>|PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
