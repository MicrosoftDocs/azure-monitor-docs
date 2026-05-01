---
title: Supported metrics - Microsoft.HDInsight/clusters
description: Reference for Microsoft.HDInsight/clusters metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.HDInsight/clusters, arm

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.HDInsight/clusters

The following table lists the metrics available for the Microsoft.HDInsight/clusters resource type.

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



### Category: Availability
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Categorized Gateway Requests**<br><br>Number of gateway requests by categories (1xx/2xx/3xx/4xx/5xx) |`CategorizedGatewayRequests` |Count |Count, Total (Sum) |`HttpStatus`|PT1M, PT1H, P1D |Yes|
|**Gateway Requests**<br><br>Number of gateway requests |`GatewayRequests` |Count |Count, Total (Sum) |`HttpStatus`|PT1M, PT1H, P1D |Yes|
|**REST proxy Consumer RequestThroughput**<br><br>Number of consumer requests to Kafka REST proxy |`KafkaRestProxy.ConsumerRequest.m1_delta` |CountPerSecond |Total (Sum) |`Machine`, `Topic`|PT1M, PT1H, P1D |Yes|
|**REST proxy Consumer Unsuccessful Requests**<br><br>Consumer request exceptions |`KafkaRestProxy.ConsumerRequestFail.m1_delta` |CountPerSecond |Total (Sum) |`Machine`, `Topic`|PT1M, PT1H, P1D |Yes|
|**REST proxy Consumer RequestLatency**<br><br>Message latency in a consumer request through Kafka REST proxy |`KafkaRestProxy.ConsumerRequestTime.p95` |Milliseconds |Average |`Machine`, `Topic`|PT1M, PT1H, P1D |Yes|
|**REST proxy Consumer Request Backlog**<br><br>Consumer REST proxy queue length |`KafkaRestProxy.ConsumerRequestWaitingInQueueTime.p95` |Milliseconds |Average |`Machine`, `Topic`|PT1M, PT1H, P1D |Yes|
|**REST proxy Producer MessageThroughput**<br><br>Number of producer messages through Kafka REST proxy |`KafkaRestProxy.MessagesIn.m1_delta` |CountPerSecond |Total (Sum) |`Machine`, `Topic`|PT1M, PT1H, P1D |Yes|
|**REST proxy Consumer MessageThroughput**<br><br>Number of consumer messages through Kafka REST proxy |`KafkaRestProxy.MessagesOut.m1_delta` |CountPerSecond |Total (Sum) |`Machine`, `Topic`|PT1M, PT1H, P1D |Yes|
|**REST proxy ConcurrentConnections**<br><br>Number of concurrent connections through Kafka REST proxy |`KafkaRestProxy.OpenConnections` |Count |Total (Sum) |`Machine`, `Topic`|PT1M, PT1H, P1D |Yes|
|**REST proxy Producer RequestThroughput**<br><br>Number of producer requests to Kafka REST proxy |`KafkaRestProxy.ProducerRequest.m1_delta` |CountPerSecond |Total (Sum) |`Machine`, `Topic`|PT1M, PT1H, P1D |Yes|
|**REST proxy Producer Unsuccessful Requests**<br><br>Producer request exceptions |`KafkaRestProxy.ProducerRequestFail.m1_delta` |CountPerSecond |Total (Sum) |`Machine`, `Topic`|PT1M, PT1H, P1D |Yes|
|**REST proxy Producer RequestLatency**<br><br>Message latency in a producer request through Kafka REST proxy |`KafkaRestProxy.ProducerRequestTime.p95` |Milliseconds |Average |`Machine`, `Topic`|PT1M, PT1H, P1D |Yes|
|**REST proxy Producer Request Backlog**<br><br>Producer REST proxy queue length |`KafkaRestProxy.ProducerRequestWaitingInQueueTime.p95` |Milliseconds |Average |`Machine`, `Topic`|PT1M, PT1H, P1D |Yes|
|**Number of Active Workers**<br><br>Number of Active Workers |`NumActiveWorkers` |Count |Average, Maximum, Minimum |`MetricName`|PT1M, PT1H, P1D |Yes|
|**Pending CPU**<br><br>Pending CPU Requests in YARN |`PendingCPU` |Count |Average, Maximum, Minimum |\<none\>|PT1M, PT1H, P1D |Yes|
|**Pending Memory**<br><br>Pending Memory Requests in YARN |`PendingMemory` |Count |Average, Maximum, Minimum |\<none\>|PT1M, PT1H, P1D |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
