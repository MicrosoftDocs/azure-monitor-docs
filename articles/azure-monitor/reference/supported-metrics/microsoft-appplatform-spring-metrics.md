---
title: Supported metrics - Microsoft.AppPlatform/spring
description: Reference for Microsoft.AppPlatform/spring metrics in Azure Monitor.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.AppPlatform/spring, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported metrics for Microsoft.AppPlatform/spring

The following table lists the metrics available for the Microsoft.AppPlatform/spring resource type.

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


For a list of supported logs, see [Supported log categories - Microsoft.AppPlatform/spring](../supported-logs/microsoft-appplatform-spring-logs.md)


### Category: Common
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**App CPU Usage (Deprecated)**<br><br>The recent CPU usage for the app. This metric is being deprecated. Please use "App CPU Usage" with metric id "PodCpuUsage". |`AppCpuUsage` |Percent |Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**App CPU Usage**<br><br>The recent CPU usage for the app |`PodCpuUsage` |Percent |Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**App Memory Usage**<br><br>The recent Memory usage for the app |`PodMemoryUsage` |Percent |Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**App Network In**<br><br>Cumulative count of bytes received in the app |`PodNetworkIn` |Bytes |Total (Sum), Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**App Network Out**<br><br>Cumulative count of bytes sent from the app |`PodNetworkOut` |Bytes |Total (Sum), Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|

### Category: Core
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Requests**<br><br>Requests processed |`Requests` |Count |Total (Sum), Maximum, Minimum, Average |`containerAppName`, `podName`, `statusCodeCategory`, `statusCode`|PT1M |Yes|
|**Restart Count**<br><br>Restart count of Spring App |`RestartCount` |Count |Total (Sum), Maximum, Minimum, Average |`containerAppName`, `podName`|PT1M |Yes|
|**Network In Bytes**<br><br>Network received bytes |`RxBytes` |Bytes |Total (Sum), Maximum, Minimum, Average |`containerAppName`, `podName`|PT1M |Yes|
|**Network Out Bytes**<br><br>Network transmitted bytes |`TxBytes` |Bytes |Total (Sum), Maximum, Minimum, Average |`containerAppName`, `podName`|PT1M |Yes|
|**CPU Usage**<br><br>CPU consumed by Spring App, in nano cores. 1,000,000,000 nano cores = 1 core |`UsageNanoCores` |NanoCores |Total (Sum), Maximum, Minimum, Average |`containerAppName`, `podName`|PT1M |Yes|
|**Memory Working Set Bytes**<br><br>Spring App working set memory used in bytes. |`WorkingSetBytes` |Bytes |Total (Sum), Maximum, Minimum, Average |`containerAppName`, `podName`|PT1M |Yes|

### Category: Error (Java)
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**tomcat.global.error**<br><br>Tomcat Global Error |`tomcat.global.error` |Count |Total (Sum), Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|

### Category: Gateway
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Max time of requests**<br><br>The max time of requests |`GatewayHttpServerRequestsMilliSecondsMax` |MilliSeconds |Maximum, Average |`Pod`, `httpStatusCode`, `outcome`, `httpMethod`|PT1M |Yes|
|**Request count**<br><br>The number of requests |`GatewayHttpServerRequestsSecondsCount` |Count |Total (Sum), Average |`Pod`, `httpStatusCode`, `outcome`, `httpMethod`|PT1M |Yes|
|**jvm.gc.live.data.size**<br><br>Size of old generation memory pool after a full GC |`GatewayJvmGcLiveDataSizeBytes` |Bytes |Maximum, Average |`Pod`|PT1M |Yes|
|**jvm.gc.max.data.size**<br><br>Max size of old generation memory pool |`GatewayJvmGcMaxDataSizeBytes` |Bytes |Maximum, Average |`Pod`|PT1M |Yes|
|**jvm.gc.memory.allocated**<br><br>Incremented for an increase in the size of the young generation memory pool after one GC to before the next |`GatewayJvmGcMemoryAllocatedBytesTotal` |Bytes |Maximum, Average |`Pod`|PT1M |Yes|
|**jvm.gc.memory.promoted**<br><br>Count of positive increases in the size of the old generation memory pool before GC to after GC |`GatewayJvmGcMemoryPromotedBytesTotal` |Bytes |Maximum, Average |`Pod`|PT1M |Yes|
|**jvm.gc.pause.total.count**<br><br>GC Pause Count |`GatewayJvmGcPauseSecondsCount` |Count |Total (Sum), Average |`Pod`|PT1M |Yes|
|**jvm.gc.pause.max.time**<br><br>GC Pause Max Time |`GatewayJvmGcPauseSecondsMax` |Seconds |Maximum, Average |`Pod`|PT1M |Yes|
|**jvm.gc.pause.total.time**<br><br>GC Pause Total Time |`GatewayJvmGcPauseSecondsSum` |Seconds |Total (Sum), Average |`Pod`|PT1M |Yes|
|**jvm.memory.committed**<br><br>Memory assigned to JVM in bytes |`GatewayJvmMemoryCommittedBytes` |Bytes |Maximum, Minimum, Average |`Pod`|PT1M |Yes|
|**jvm.memory.used**<br><br>Memory Used in bytes |`GatewayJvmMemoryUsedBytes` |Bytes |Maximum, Minimum, Average |`Pod`|PT1M |Yes|
|**process.cpu.usage**<br><br>The recent CPU usage for the JVM process |`GatewayProcessCpuUsage` |Percent |Maximum, Minimum, Average |`Pod`|PT1M |Yes|
|**Throttled requests count**<br><br>The count of the throttled requests |`GatewayRatelimitThrottledCount` |Count |Total (Sum), Average |`Pod`|PT1M |Yes|
|**system.cpu.usage**<br><br>The recent CPU usage for the whole system |`GatewaySystemCpuUsage` |Percent |Maximum, Minimum, Average |`Pod`|PT1M |Yes|

### Category: Ingress
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**Bytes Received**<br><br>Count of bytes received by Azure Spring Apps from the clients |`IngressBytesReceived` |Bytes |Maximum, Minimum, Average |`Hostname`, `HttpStatus`|PT1M |Yes|
|**Throughput In (bytes/s)**<br><br>Bytes received per second by Azure Spring Apps from the clients |`IngressBytesReceivedRate` |BytesPerSecond |Maximum, Minimum, Average |`Hostname`, `HttpStatus`|PT1M |Yes|
|**Bytes Sent**<br><br>Count of bytes sent by Azure Spring Apps to the clients |`IngressBytesSent` |Bytes |Maximum, Minimum, Average |`Hostname`, `HttpStatus`|PT1M |Yes|
|**Throughput Out (bytes/s)**<br><br>Bytes sent per second by Azure Spring Apps to the clients |`IngressBytesSentRate` |BytesPerSecond |Maximum, Minimum, Average |`Hostname`, `HttpStatus`|PT1M |Yes|
|**Failed Requests**<br><br>Count of failed requests by Azure Spring Apps from the clients |`IngressFailedRequests` |Count |Maximum, Minimum, Average |`Hostname`, `HttpStatus`|PT1M |Yes|
|**Requests**<br><br>Count of requests by Azure Spring Apps from the clients |`IngressRequests` |Count |Maximum, Minimum, Average |`Hostname`, `HttpStatus`|PT1M |Yes|
|**Response Status**<br><br>HTTP response status returned by Azure Spring Apps. The response status code distribution can be further categorized to show responses in 2xx, 3xx, 4xx, and 5xx categories |`IngressResponseStatus` |Count |Maximum, Minimum, Average |`Hostname`, `HttpStatus`|PT1M |Yes|
|**Response Time**<br><br>Http response time return by Azure Spring Apps |`IngressResponseTime` |Seconds |Maximum, Minimum, Average |`Hostname`, `HttpStatus`|PT1M |Yes|

### Category: Performance (.NET)
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**active-timer-count**<br><br>Number of timers that are currently active |`active-timer-count` |Count |Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**alloc-rate**<br><br>Number of bytes allocated in the managed heap |`alloc-rate` |Bytes |Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**assembly-count**<br><br>Number of Assemblies Loaded |`assembly-count` |Count |Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**cpu-usage**<br><br>% time the process has utilized the CPU |`cpu-usage` |Percent |Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**exception-count**<br><br>Number of Exceptions |`exception-count` |Count |Total (Sum), Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**gc-heap-size**<br><br>Total heap size reported by the GC (MB) |`gc-heap-size` |Count |Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**gen-0-gc-count**<br><br>Number of Gen 0 GCs |`gen-0-gc-count` |Count |Total (Sum), Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**gen-0-size**<br><br>Gen 0 Heap Size |`gen-0-size` |Bytes |Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**gen-1-gc-count**<br><br>Number of Gen 1 GCs |`gen-1-gc-count` |Count |Total (Sum), Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**gen-1-size**<br><br>Gen 1 Heap Size |`gen-1-size` |Bytes |Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**gen-2-gc-count**<br><br>Number of Gen 2 GCs |`gen-2-gc-count` |Count |Total (Sum), Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**gen-2-size**<br><br>Gen 2 Heap Size |`gen-2-size` |Bytes |Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**loh-size**<br><br>LOH Heap Size |`loh-size` |Bytes |Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**monitor-lock-contention-count**<br><br>Number of times there were contention when trying to take the monitor lock |`monitor-lock-contention-count` |Count |Total (Sum), Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**threadpool-completed-items-count**<br><br>ThreadPool Completed Work Items Count |`threadpool-completed-items-count` |Count |Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**threadpool-queue-length**<br><br>ThreadPool Work Items Queue Length |`threadpool-queue-length` |Count |Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**threadpool-thread-count**<br><br>Number of ThreadPool Threads |`threadpool-thread-count` |Count |Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**time-in-gc**<br><br>% time in GC since the last GC |`time-in-gc` |Percent |Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**working-set**<br><br>Amount of working set used by the process (MB) |`working-set` |Count |Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|

### Category: Performance (Java)
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**jvm.gc.live.data.size**<br><br>Size of old generation memory pool after a full GC |`jvm.gc.live.data.size` |Bytes |Maximum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**jvm.gc.max.data.size**<br><br>Max size of old generation memory pool |`jvm.gc.max.data.size` |Bytes |Maximum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**jvm.gc.memory.allocated**<br><br>Incremented for an increase in the size of the young generation memory pool after one GC to before the next |`jvm.gc.memory.allocated` |Bytes |Maximum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**jvm.gc.memory.promoted**<br><br>Count of positive increases in the size of the old generation memory pool before GC to after GC |`jvm.gc.memory.promoted` |Bytes |Maximum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**jvm.gc.pause.total.count**<br><br>GC Pause Count |`jvm.gc.pause.total.count` |Count |Total (Sum), Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**jvm.gc.pause.total.time**<br><br>GC Pause Total Time |`jvm.gc.pause.total.time` |MilliSeconds |Total (Sum), Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**jvm.memory.committed**<br><br>Memory assigned to JVM in bytes |`jvm.memory.committed` |Bytes |Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**jvm.memory.max**<br><br>The maximum amount of memory in bytes that can be used for memory management |`jvm.memory.max` |Bytes |Maximum |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**jvm.memory.used**<br><br>App Memory Used in bytes |`jvm.memory.used` |Bytes |Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**process.cpu.usage**<br><br>The recent CPU usage for the JVM process |`process.cpu.usage` |Percent |Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**system.cpu.usage**<br><br>The recent CPU usage for the whole system |`system.cpu.usage` |Percent |Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|

### Category: Request (.NET)
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**current-requests**<br><br>Total number of requests in processing in the lifetime of the process |`current-requests` |Count |Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**failed-requests**<br><br>Total number of failed requests in the lifetime of the process |`failed-requests` |Count |Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**requests-rate**<br><br>Request rate |`requests-per-second` |Count |Maximum, Minimum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**total-requests**<br><br>Total number of requests in the lifetime of the process |`total-requests` |Count |Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|

### Category: Request (Java)
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**tomcat.global.received**<br><br>Tomcat Total Received Bytes |`tomcat.global.received` |Bytes |Total (Sum), Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**tomcat.global.request.avg.time**<br><br>Tomcat Request Average Time |`tomcat.global.request.avg.time` |MilliSeconds |Maximum, Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**tomcat.global.request.max**<br><br>Tomcat Request Max Time |`tomcat.global.request.max` |MilliSeconds |Maximum |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**tomcat.global.request.total.count**<br><br>Tomcat Request Total Count |`tomcat.global.request.total.count` |Count |Total (Sum), Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**tomcat.global.request.total.time**<br><br>Tomcat Request Total Time |`tomcat.global.request.total.time` |MilliSeconds |Total (Sum), Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**tomcat.global.sent**<br><br>Tomcat Total Sent Bytes |`tomcat.global.sent` |Bytes |Total (Sum), Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**tomcat.threads.config.max**<br><br>Tomcat Config Max Thread Count |`tomcat.threads.config.max` |Count |Total (Sum), Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**tomcat.threads.current**<br><br>Tomcat Current Thread Count |`tomcat.threads.current` |Count |Total (Sum), Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|

### Category: Session (Java)
|Metric|Name in REST API|Unit|Aggregation|Dimensions|Time Grains|DS Export|
|---|---|---|---|---|---|---|
|**tomcat.sessions.active.current**<br><br>Tomcat Session Active Count |`tomcat.sessions.active.current` |Count |Total (Sum), Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**tomcat.sessions.active.max**<br><br>Tomcat Session Max Active Count |`tomcat.sessions.active.max` |Count |Total (Sum), Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**tomcat.sessions.alive.max**<br><br>Tomcat Session Max Alive Time |`tomcat.sessions.alive.max` |MilliSeconds |Maximum |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**tomcat.sessions.created**<br><br>Tomcat Session Created Count |`tomcat.sessions.created` |Count |Total (Sum), Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**tomcat.sessions.expired**<br><br>Tomcat Session Expired Count |`tomcat.sessions.expired` |Count |Total (Sum), Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|
|**tomcat.sessions.rejected**<br><br>Tomcat Session Rejected Count |`tomcat.sessions.rejected` |Count |Total (Sum), Average |`Deployment`, `AppName`, `Pod`|PT1M |Yes|

## Next steps

- [Read about metrics in Azure Monitor](/azure/azure-monitor/data-platform)
- [Metrics export using data collection rules](/azure/azure-monitor/essentials/data-collection-metrics)
- [Create alerts on metrics](/azure/azure-monitor/alerts/alerts-overview)
- [Export metrics to storage, Event Hub, or Log Analytics](/azure/azure-monitor/essentials/platform-logs-overview)
