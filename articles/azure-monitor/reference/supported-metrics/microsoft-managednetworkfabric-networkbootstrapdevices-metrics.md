---
title: Supported metrics - Microsoft.ManagedNetworkFabric/networkBootstrapDevices
description: Reference for Microsoft.ManagedNetworkFabric/networkBootstrapDevices metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 11/23/2026
ms.custom: Microsoft.ManagedNetworkFabric/networkBootstrapDevices, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.ManagedNetworkFabric/networkBootstrapDevices

The following table lists the metrics available for the Microsoft.ManagedNetworkFabric/networkBootstrapDevices resource type.

**Table headings**

- **Metric** - The metric display name as it appears in the Azure portal.
- **Name in Rest API** - Metric name as referred to in the [REST API](/azure/azure-monitor/essentials/rest-api-walkthrough).
- **Advanced platform metrics** - A premium, [paid tier of platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform) in Azure Monitor that provide more granular observability for Azure resources.
- **Unit** - Unit of measure.
- **Aggregation** - The default [aggregation](/azure/azure-monitor/essentials/metrics-aggregation-explained) type. Valid values: Average, Minimum, Maximum, Total, Count.
- **Dimensions** - [Dimensions](/azure/azure-monitor/essentials/metrics-aggregation-explained#dimensions-splitting-and-filtering) available for the metric.
- **Time Grains** - [Intervals at which the metric is sampled](/azure/azure-monitor/essentials/metrics-aggregation-explained#granularity). For example, `PT1M` indicates that the metric is sampled every minute, `PT30M` every 30 minutes, `PT1H` every hour, and so on.
- **DS Export** - Shows whether the metric is exportable to Azure Monitor Logs via Diagnostic Settings.

For information on exporting metrics, see - [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics) and [Create diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/create-diagnostic-settings?tabs=portal).

For information on metric retention, see [Azure Monitor Metrics overview](/azure/azure-monitor/essentials/data-platform-metrics#retention-of-metrics).



### Category: Interfaces
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Interface Administrative Status**<br><br>The desired administrative state of an interface on the network bootstrap device: 1 = up, 2 = down, and 3 = testing. |`ifAdminStatus` | No | Unspecified |Minimum, Maximum |`FabricId`, `Interface`|PT1M |Yes|
|**Interface Inbound Discards**<br><br>The number of inbound packets discarded on an interface. |`ifInDiscards` | No | Count |Average, Minimum, Maximum |`FabricId`, `Interface`|PT1M |Yes|
|**Interface Inbound Errors**<br><br>The number of inbound packets containing errors on an interface. |`ifInErrors` | No | Count |Average, Minimum, Maximum |`FabricId`, `Interface`|PT1M |Yes|
|**Interface Inbound Bytes**<br><br>The total number of bytes received on an interface. |`ifInOctets` | No | Bytes |Average, Minimum, Maximum |`FabricId`, `Interface`|PT1M |Yes|
|**Interface Operational Status**<br><br>The current operational state of an interface on the network bootstrap device: 1 = up, 2 = down, 3 = testing, 4 = unknown, 5 = dormant, 6 = not present, and 7 = lower-layer down. |`ifOperStatus` | No | Unspecified |Minimum, Maximum |`FabricId`, `Interface`|PT1M |Yes|
|**Interface Outbound Discards**<br><br>The number of outbound packets discarded on an interface. |`ifOutDiscards` | No | Count |Average, Minimum, Maximum |`FabricId`, `Interface`|PT1M |Yes|
|**Interface Outbound Errors**<br><br>The number of outbound packets that could not be transmitted because of errors on an interface. |`ifOutErrors` | No | Count |Average, Minimum, Maximum |`FabricId`, `Interface`|PT1M |Yes|
|**Interface Outbound Bytes**<br><br>The total number of bytes transmitted on an interface. |`ifOutOctets` | No | Bytes |Average, Minimum, Maximum |`FabricId`, `Interface`|PT1M |Yes|

### Category: Power
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Power Supply Input Voltage**<br><br>The input voltage reported by a power supply on the network bootstrap device. |`ogOmPowerSupplyInputVoltage` | No | Unspecified |Average, Minimum, Maximum |`FabricId`, `ogOmPowerSupplyName`, `ogOmPowerSupplyDevice`|PT1M |Yes|
|**Power Supply Output Current**<br><br>The output current reported by a power supply on the network bootstrap device. |`ogOmPowerSupplyOutputCurrent` | No | Unspecified |Average, Minimum, Maximum |`FabricId`, `ogOmPowerSupplyName`, `ogOmPowerSupplyDevice`|PT1M |Yes|
|**Power Supply Output Power**<br><br>The output power reported by a power supply on the network bootstrap device. |`ogOmPowerSupplyOutputPower` | No | Unspecified |Average, Minimum, Maximum |`FabricId`, `ogOmPowerSupplyName`, `ogOmPowerSupplyDevice`|PT1M |Yes|

### Category: Sensors
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Temperature Sensor Value**<br><br>The temperature value reported by the PHY Temperature sensor (lmTempSensorsTable index 1) on the network bootstrap device, in milli-degrees Celsius. Divide by 1,000 to obtain degrees Celsius. |`lmTempSensorsValue` | No | Unspecified |Average, Minimum, Maximum |`FabricId`, `lmTempSensorsDevice`|PT1M |Yes|
|**Voltage Sensor Value**<br><br>The voltage values reported by the in1 and in3 sensors (lmVoltSensorsTable indexes 3 and 5, respectively) on the network bootstrap device. |`lmVoltSensorsValue` | No | Unspecified |Average, Minimum, Maximum |`FabricId`, `lmVoltSensorsDevice`|PT1M |Yes|

### Category: Serial Ports
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Serial Port Received Bytes**<br><br>The number of bytes received by a serial port on the network bootstrap device. |`ogOmSerialPortRxBytes` | No | Bytes |Average, Minimum, Maximum |`FabricId`, `Port`|PT1M |Yes|
|**Serial Port Transmitted Bytes**<br><br>The number of bytes transmitted by a serial port on the network bootstrap device. |`ogOmSerialPortTxBytes` | No | Bytes |Average, Minimum, Maximum |`FabricId`, `Port`|PT1M |Yes|

### Category: Storage
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Storage Used**<br><br>The amount of storage in use on the network bootstrap device, reported in bytes. |`hrStorageUsed` | No | Bytes |Average, Minimum, Maximum |`FabricId`, `hrStorageDescr`, `hrStorageType`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
