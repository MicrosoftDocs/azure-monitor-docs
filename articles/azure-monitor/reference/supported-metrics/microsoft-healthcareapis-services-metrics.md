---
title: Supported metrics - Microsoft.HealthcareApis/services
description: Reference for Microsoft.HealthcareApis/services metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/06/2026
ms.custom: Microsoft.HealthcareApis/services, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.HealthcareApis/services

The following table lists the metrics available for the Microsoft.HealthcareApis/services resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.HealthcareApis/services](../supported-logs/microsoft-healthcareapis-services-logs.md)


### Category: Availability
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Availability**<br><br>The availability rate of the service. |`Availability` |Percent |Average |\<none\>|PT1M |Yes|

### Category: Errors
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Total Error Count**<br><br>The total number of errors logged by the Azure IoT Connector for FHIR |`IoTConnectorTotalErrors` |Count |Total (Sum) |`Name`, `Operation`, `ErrorType`, `ErrorSeverity`, `ConnectorName`|PT1M |Yes|
|**Total Errors**<br><br>The total number of internal server errors encountered by the service. |`TotalErrors` |Count |Total (Sum) |`Protocol`, `StatusCode`, `StatusCodeClass`, `StatusText`|PT1M |Yes|

### Category: Latency
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Average Normalize Stage Latency**<br><br>The average time between an event's ingestion time and the time the event is processed for normalization. |`IoTConnectorDeviceEventProcessingLatencyMs` |MilliSeconds |Average |`Operation`, `ConnectorName`|PT1M |Yes|
|**Average Group Stage Latency**<br><br>The time period between when the IoT Connector received the device data and when the data is processed by the FHIR conversion stage. |`IoTConnectorMeasurementIngestionLatencyMs` |MilliSeconds |Average |`Operation`, `ConnectorName`|PT1M |Yes|

### Category: Saturation
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Cosmos DB Collection Size**<br><br>The size of the backing Cosmos DB collection, in bytes. |`CosmosDbCollectionSize` |Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**Cosmos DB Index Size**<br><br>The size of the backing Cosmos DB collection's index, in bytes. |`CosmosDbIndexSize` |Bytes |Total (Sum) |\<none\>|PT1M |Yes|
|**Cosmos DB RU usage**<br><br>The RU usage of requests to the service's backing Cosmos DB. |`CosmosDbRequestCharge` |Count |Total (Sum) |`Operation`, `ResourceType`|PT1M |Yes|
|**Service Cosmos DB throttle rate**<br><br>The total number of 429 responses from a service's backing Cosmos DB. |`CosmosDbThrottleRate` |Count |Total (Sum) |`Operation`, `ResourceType`|PT1M |Yes|

### Category: Traffic
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Service Cosmos DB requests**<br><br>The total number of requests made to a service's backing Cosmos DB. |`CosmosDbRequests` |Count |Total (Sum) |`Operation`, `ResourceType`|PT1M |Yes|
|**Number of Incoming Messages**<br><br>The total number of messages received by the Azure IoT Connector for FHIR prior to any normalization. |`IoTConnectorDeviceEvent` |Count |Total (Sum) |`Operation`, `ConnectorName`|PT1M |Yes|
|**Number of Measurements**<br><br>The number of normalized value readings received by the FHIR conversion stage of the Azure IoT Connector for FHIR. |`IoTConnectorMeasurement` |Count |Total (Sum) |`Operation`, `ConnectorName`|PT1M |Yes|
|**Number of Message Groups**<br><br>The total number of unique groupings of measurements across type, device, patient, and configured time period generated by the FHIR conversion stage. |`IoTConnectorMeasurementGroup` |Count |Total (Sum) |`Operation`, `ConnectorName`|PT1M |Yes|
|**Number of Normalized Messages**<br><br>The total number of mapped normalized values outputted from the normalization stage of the the Azure IoT Connector for FHIR. |`IoTConnectorNormalizedEvent` |Count |Total (Sum) |`Operation`, `ConnectorName`|PT1M |Yes|
|**Total Latency**<br><br>The response latency of the service. |`TotalLatency` |MilliSeconds |Average |`Protocol`|PT1M |Yes|
|**Total Requests**<br><br>The total number of requests received by the service. |`TotalRequests` |Count |Total (Sum) |`Protocol`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
