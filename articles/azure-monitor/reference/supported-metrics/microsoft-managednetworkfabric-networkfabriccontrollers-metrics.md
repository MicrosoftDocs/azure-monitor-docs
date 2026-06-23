---
title: Supported metrics - Microsoft.ManagedNetworkFabric/networkFabricControllers
description: Reference for Microsoft.ManagedNetworkFabric/networkFabricControllers metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 05/29/2026
ms.custom: Microsoft.ManagedNetworkFabric/networkFabricControllers, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.ManagedNetworkFabric/networkFabricControllers

The following table lists the metrics available for the Microsoft.ManagedNetworkFabric/networkFabricControllers resource type.

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



### Category: Health
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**NFC Envoy Restarts**<br><br>Container restart count for Envoy. |`kube_pod_container_status_restarts_total_envoy` |Count |Count, Average, Minimum, Maximum, Total (Sum) |`nfcClusterRole`, `container`|PT1M |No|
|**NFC Geneva Monitoring Infra Restarts**<br><br>Container restart count for Geneva Monitoring Infra. |`kube_pod_container_status_restarts_total_geneva_monitoringinfra` |Count |Count, Average, Minimum, Maximum, Total (Sum) |`nfcClusterRole`, `container`|PT1M |No|
|**NFC gNMI Gateway Restarts**<br><br>Container restart count for gNMI Gateway. |`kube_pod_container_status_restarts_total_gnmigw` |Count |Count, Average, Minimum, Maximum, Total (Sum) |`nfcClusterRole`, `container`|PT1M |No|
|**NFC NTP Restarts**<br><br>Container restart count for NTP. |`kube_pod_container_status_restarts_total_ntp` |Count |Count, Average, Minimum, Maximum, Total (Sum) |`nfcClusterRole`, `container`|PT1M |No|
|**NFC Operator Restarts**<br><br>Container restart count for Operator. |`kube_pod_container_status_restarts_total_operator` |Count |Count, Average, Minimum, Maximum, Total (Sum) |`nfcClusterRole`, `container`|PT1M |No|
|**NFC Redis Restarts**<br><br>Container restart count for Redis. |`kube_pod_container_status_restarts_total_redis` |Count |Count, Average, Minimum, Maximum, Total (Sum) |`nfcClusterRole`, `container`|PT1M |No|
|**NFC XDS Restarts**<br><br>Container restart count for XDS. |`kube_pod_container_status_restarts_total_xds` |Count |Count, Average, Minimum, Maximum, Total (Sum) |`nfcClusterRole`, `container`|PT1M |No|
|**NFC ZooKeeper Restarts**<br><br>Container restart count for ZooKeeper. |`kube_pod_container_status_restarts_total_zk` |Count |Count, Average, Minimum, Maximum, Total (Sum) |`nfcClusterRole`, `container`|PT1M |No|
|**NFC Envoy Availability**<br><br>Composite health state for the Envoy deployments. 1=Healthy, 2=Degraded, 3=Unhealthy. |`nfc_service_replica_state_envoy` |Count |Average, Minimum, Maximum |`nfcClusterRole`, `deployment`|PT1M |No|
|**NFC Geneva Monitoring Infra Availability**<br><br>Composite health state for the Geneva Monitoring Infra deployment. 1=Healthy, 2=Degraded, 3=Unhealthy. |`nfc_service_replica_state_geneva_monitoringinfra` |Count |Average, Minimum, Maximum |`nfcClusterRole`, `deployment`|PT1M |No|
|**NFC gNMI Gateway Availability**<br><br>Composite health state for the gNMI Gateway deployment. 1=Healthy, 2=Degraded, 3=Unhealthy. |`nfc_service_replica_state_gnmigw` |Count |Average, Minimum, Maximum |`nfcClusterRole`, `deployment`|PT1M |No|
|**NFC Operator Availability**<br><br>Composite health state for the NFA Operator. 1=Healthy, 2=Degraded, 3=Unhealthy. |`nfc_service_replica_state_operator` |Count |Average, Minimum, Maximum |`nfcClusterRole`, `deployment`|PT1M |No|
|**NFC XDS Availability**<br><br>Composite health state for the XDS deployment. 1=Healthy, 2=Degraded, 3=Unhealthy. |`nfc_service_replica_state_xds` |Count |Average, Minimum, Maximum |`nfcClusterRole`, `deployment`|PT1M |No|
|**NFC NTP Availability**<br><br>Composite health state for NTP. 1=Healthy, 2=Degraded, 3=Unhealthy. |`nfc_services_statefulset_status_ntp` |Count |Average, Minimum, Maximum |`nfcClusterRole`, `statefulset`|PT1M |No|
|**NFC Redis Availability**<br><br>Composite health state for Redis. 1=Healthy, 2=Degraded, 3=Unhealthy. |`nfc_services_statefulset_status_redis` |Count |Average, Minimum, Maximum |`nfcClusterRole`, `statefulset`|PT1M |No|
|**NFC ZooKeeper Availability**<br><br>Composite health state for ZooKeeper. 1=Healthy, 2=Degraded, 3=Unhealthy. |`nfc_services_statefulset_status_zk` |Count |Average, Minimum, Maximum |`nfcClusterRole`, `statefulset`|PT1M |No|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
