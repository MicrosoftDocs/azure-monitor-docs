---
title: Supported metrics - Oracle.Database/goldenGateDeployments
description: Reference for Oracle.Database/goldenGateDeployments metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 08/28/2026
ms.custom: Oracle.Database/goldenGateDeployments, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Oracle.Database/goldenGateDeployments

The following table lists the metrics available for the Oracle.Database/goldenGateDeployments resource type.

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


For a list of supported logs, see [Supported log categories - Oracle.Database/goldenGateDeployments](../supported-logs/oracle-database-goldengatedeployments-logs.md)


### Category: Availability
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Overall Deployment Health**<br><br>Overall percentage health of deployment services. |`oci_goldengate_DeploymentHealth` | No | Percent |Minimum, Maximum, Average |`deploymentId`, `deploymentName`|PT1M |No|
|**Distribution Path Status**<br><br>Health percentage of a Distribution Path process in the deployment. |`oci_goldengate_DistributionPathStatus` | No | Percent |Minimum, Maximum, Average |`deploymentId`, `deploymentName`, `DistributionPathName`|PT1M |No|
|**Extract Status**<br><br>Health percentage of an Extract process in the deployment. |`oci_goldengate_ExtractStatus` | No | Percent |Minimum, Maximum, Average |`deploymentId`, `deploymentName`, `ExtractName`|PT1M |No|
|**Receiver Path Status**<br><br>Health percentage of a Receiver Path process in the deployment. |`oci_goldengate_ReceiverPathStatus` | No | Percent |Minimum, Maximum, Average |`deploymentId`, `deploymentName`, `ReceiverPathName`|PT1M |No|
|**Replicat Status**<br><br>Health percentage of a Replicat process in the deployment. |`oci_goldengate_ReplicatStatus` | No | Percent |Minimum, Maximum, Average |`deploymentId`, `deploymentName`, `ReplicatName`|PT1M |No|

### Category: Latency
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**Deployment Inbound Lag**<br><br>Average lag, in seconds, for all inbound streams critical to deployment health. |`oci_goldengate_DeploymentInboundLag` | No | Seconds |Minimum, Maximum, Average |`deploymentId`, `deploymentName`|PT1M |No|
|**Deployment Outbound Lag**<br><br>Average lag, in seconds, for all outbound streams critical to deployment health. |`oci_goldengate_DeploymentOutboundLag` | No | Seconds |Minimum, Maximum, Average |`deploymentId`, `deploymentName`|PT1M |No|
|**Distribution Path Lag**<br><br>Average lag, in seconds, of a Distribution Path process in the deployment. |`oci_goldengate_DistributionPathLag` | No | Seconds |Minimum, Maximum, Average |`deploymentId`, `deploymentName`, `DistributionPathName`|PT1M |No|
|**Extract Lag**<br><br>The difference, in seconds, between the time the Extract processed a record and the timestamp of that record in the data source. |`oci_goldengate_ExtractLag` | No | Seconds |Minimum, Maximum, Average |`deploymentId`, `deploymentName`, `ExtractName`|PT1M |No|
|**Heartbeat Lag**<br><br>Average heartbeat lag in seconds. |`oci_goldengate_HeartbeatLag` | No | Seconds |Minimum, Maximum, Average |`deploymentId`, `deploymentName`, `ReplicatName`, `ageSeconds`|PT1M |No|
|**Receiver Path Lag**<br><br>Average lag, in seconds, of a Receiver Path process in the deployment. |`oci_goldengate_ReceiverPathLag` | No | Seconds |Minimum, Maximum, Average |`deploymentId`, `deploymentName`, `ReceiverPathName`|PT1M |No|
|**Replicat Lag**<br><br>The difference, in seconds, between the time the Replicat processed the last record and the timestamp of the record in the trail. |`oci_goldengate_ReplicatLag` | No | Seconds |Minimum, Maximum, Average |`deploymentId`, `deploymentName`, `ReplicatName`|PT1M |No|

### Category: Saturation
|Metric|Name in REST API|[Advanced platform metrics](/azure/azure-monitor/metrics/metrics-advanced-platform)|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|---|
|**CPU Utilization**<br><br>Total CPU usage percentage by all consumer groups. |`oci_goldengate_CpuUtilization` | No | Percent |Minimum, Maximum, Average |`deploymentId`, `deploymentName`|PT1M |No|
|**File System Usage**<br><br>Percentage of file system used. |`oci_goldengate_FileSystemUsage` | No | Percent |Minimum, Maximum, Average |`deploymentId`, `deploymentName`|PT1M |No|
|**Memory Utilization**<br><br>Percentage of available memory used. |`oci_goldengate_MemoryUtilization` | No | Percent |Minimum, Maximum, Average |`deploymentId`, `deploymentName`|PT1M |No|
|**OCPU Consumption**<br><br>Total OCPU number consumed by the deployment. |`oci_goldengate_OcpuConsumption` | No | Count |Minimum, Maximum, Average |`deploymentId`, `deploymentName`|PT1M |No|
|**Swap Space Usage**<br><br>Percentage of swap space used by the deployment. |`oci_goldengate_SwapSpaceUsage` | No | Percent |Minimum, Maximum, Average |`deploymentId`, `deploymentName`|PT1M |No|
|**Temporary Space Usage**<br><br>Percentage of temp space used by the deployment. |`oci_goldengate_TempSpaceUsage` | No | Percent |Minimum, Maximum, Average |`deploymentId`, `deploymentName`|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
