---
title: Azure Application Insights standard metrics | Microsoft Docs
description: This article lists Azure Application Insights metrics with supported aggregations and dimensions. 
services: azure-monitor
ms.topic: reference
ms.date: 09/06/2024
ms.reviewer: vitalyg
---

# Application Insights standard metrics

Standard metrics that are stored in a specialized repository that's optimized for time series. The new metrics are no longer kept as individual events with lots of properties. Instead, they're stored as preaggregated time series, and only with key dimensions. This change makes standard metrics superior at query time. Retrieving data happens faster and requires less compute power. As a result, new scenarios are enabled, such as [near real time alerting on dimensions of metrics](../alerts/alerts-metric-near-real-time.md) and more responsive [dashboards](./overview-dashboard.md).

<!-- NEW INTRO
Standard metrics are stored in a specialized repository that's optimized for time series as preaggregated time series with only key dimensions. As a result, retrieving data happens faster and requires less compute power compared to log-based metrics, which enables new scenarios such as [near real time alerting on dimensions of metrics](../alerts/alerts-metric-near-real-time.md) and more responsive [dashboards](./overview-dashboard.md).
-->

> [!IMPORTANT]
> Both log-based and preaggregated metrics coexist in Application Insights. To differentiate the two, in the Application Insights user experience the preaggregated metrics are now called standard metrics. The traditional metrics from the events were renamed to log-based metrics.

The newer SDKs ([Application Insights 2.7](https://www.nuget.org/packages/Microsoft.ApplicationInsights/2.7.2) SDK or later for .NET) preaggregate metrics during collection. This process applies to [standard metrics sent by default](../essentials/metrics-supported.md#microsoftinsightscomponents), so the accuracy isn't affected by sampling or filtering. It also applies to custom metrics sent by using [GetMetric](./api-custom-events-metrics.md#getmetric), which results in less data ingestion and lower cost.

For the SDKs that don't implement preaggregation (that is, older versions of Application Insights SDKs or for browser instrumentation), the Application Insights back end still populates the new metrics by aggregating the events received by the Application Insights event collection endpoint. Although you don't benefit from the reduced volume of data transmitted over the wire, you can still use the preaggregated metrics and experience better performance and support of the near real time dimensional alerting with SDKs that don't preaggregate metrics during collection.

The collection endpoint preaggregates events before ingestion sampling. For this reason, [ingestion sampling](./sampling.md) never affects the accuracy of preaggregated metrics, regardless of the SDK version you use with your application.



[!INCLUDE [azure-monitor-app-insights-otel-available-notification](../includes/azure-monitor-app-insights-otel-available-notification.md)]

## Standard metrics support

### SDK supported preaggregated metrics table

| Current production SDKs      | Standard metrics (SDK preaggregation) | Custom metrics (without SDK preaggregation)                           | Custom metrics (with SDK preaggregation)                                                                         |
|------------------------------|---------------------------------------|-----------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------|
| .NET Core and .NET Framework | Supported (V2.13.1+)                  | Supported via [TrackMetric](api-custom-events-metrics.md#trackmetric) | Supported (V2.7.2+) via [GetMetric](get-metric.md)                                                               |
| Java                         | Not supported                         | Supported via [TrackMetric](api-custom-events-metrics.md#trackmetric) | Not supported                                                                                                    |
| Node.js                      | Supported (V2.0.0+)                   | Supported via [TrackMetric](api-custom-events-metrics.md#trackmetric) | Not supported                                                                                                    |
| Python                       | Not supported                         | Supported                                                             | Partially supported via [OpenCensus.stats](/previous-versions/azure/azure-monitor/app/opencensus-python#metrics) |

> [!NOTE]
> The metrics implementation for Python by using OpenCensus.stats is different from GetMetric. For more information, see the [Python documentation on metrics](/previous-versions/azure/azure-monitor/app/opencensus-python#metrics).

### Codeless supported preaggregated metrics table

| Current production SDKs | Standard metrics (SDK preaggregation) | Custom metrics (without SDK preaggregation) | Custom metrics (with SDK preaggregation)                                                                            |
|-------------------------|---------------------------------------|---------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
| ASP.NET                 | Supported <sup>1<sup>                 | Not supported                               | Not supported                                                                                                       |
| ASP.NET Core            | Supported <sup>2<sup>                 | Not supported                               | Not supported                                                                                                       |
| Java                    | Not supported                         | Not supported                               | [Supported](opentelemetry-add-modify.md?tabs=java#send-custom-telemetry-using-the-application-insights-classic-api) |
| Node.js                 | Not supported                         | Not supported                               | Not supported                                                                                                       |

1. [ASP.NET autoinstrumentation on virtual machines/virtual machine scale sets](./azure-vm-vmss-apps.md) and [on-premises](./application-insights-asp-net-agent.md) emits standard metrics without dimensions. The same is true for Azure App Service, but the collection level must be set to recommended. The SDK is required for all dimensions.
2. [ASP.NET Core autoinstrumentation on App Service](./azure-web-apps-net-core.md) emits standard metrics without dimensions. SDK is required for all dimensions.

## Quotas

Preaggregated metrics are stored as time series in Azure Monitor. [Azure Monitor quotas on custom metrics](../essentials/metrics-custom-overview.md#quotas-and-limits) apply.

> [!NOTE]
> Going over the quota might have unintended consequences. Azure Monitor might become unreliable in your subscription or region. To learn how to avoid exceeding the quota, see [Design limitations and considerations](../essentials/metrics-custom-overview.md#design-limitations-and-considerations).

## Availability metrics

Metrics in the Availability category enable you to see the health of your web application as observed from points around the world. [Configure the availability tests](../app/availability-overview.md) to start using any metrics from this category.

### Availability (availabilityResults/availabilityPercentage)

The *Availability* metric shows the percentage of the web test runs that didn't detect any issues. The lowest possible value is 0, which indicates that all of the web test runs have failed. The value of 100 means that all of the web test runs passed the validation criteria.

| Unit of measure | Supported aggregations | Supported dimensions        |
|-----------------|------------------------|-----------------------------|
| Percentage      | Average                | `Run location`, `Test name` |

### Availability test duration (availabilityResults/duration)

The *Availability test duration* metric shows how much time it took for the web test to run. For the [multi-step web tests](/previous-versions/azure/azure-monitor/app/availability-multistep), the metric reflects the total execution time of all steps.

| Unit of measure | Supported aggregations | Supported dimensions                       |
|-----------------|------------------------|--------------------------------------------|
| Milliseconds    | Average, Min, Max      | `Run location`, `Test name`, `Test result` |

### Availability tests (availabilityResults/count)

The *Availability tests* metric reflects the count of the web tests runs by Azure Monitor.

| Unit of measure | Supported aggregations | Supported dimensions                       |
|-----------------|------------------------|--------------------------------------------|
| Count           | Count                  | `Run location`, `Test name`, `Test result` |

## Browser metrics

Browser metrics are collected by the Application Insights JavaScript SDK from real end-user browsers. They provide great insights into your users' experience with your web app. Browser metrics are typically not sampled, which means that they provide higher precision of the usage numbers compared to server-side metrics which might be skewed by sampling.

> [!NOTE]
> To collect browser metrics, your application must be instrumented with the [Application Insights JavaScript SDK](../app/javascript.md).

### Browser page load time (browserTimings/totalDuration)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Average, Min, Max      | None                 |

### Client processing time (browserTiming/processingDuration)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Average, Min, Max      | None                 |

### Page load network connect time (browserTimings/networkDuration)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Average, Min, Max      | None                 |

### Receiving response time (browserTimings/receiveDuration)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Average, Min, Max      | None                 |

### Send request time (browserTimings/sendDuration)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Average, Min, Max      | None                 |

## Failure metrics

The metrics in **Failures** show problems with processing requests, dependency calls, and thrown exceptions.

### Browser exceptions (exceptions/browser)

This metric reflects the number of thrown exceptions from your application code running in browser. Only exceptions that are tracked with a ```trackException()``` Application Insights API call are included in the metric.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Count                  | `Cloud role name`    |

### Dependency call failures (dependencies/failed)

The number of failed dependency calls.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count | Count | `Cloud role instance`, `Cloud role name`, `Dependency performance`, `Dependency type`, `Is traffic synthetic`, `Result code`, `Target of dependency call` |

### Exceptions (exceptions/count)

Each time when you log an exception to Application Insights, there is a call to the [trackException() method](../app/api-custom-events-metrics.md#trackexception) of the SDK. The Exceptions metric shows the number of logged exceptions.

| Unit of measure | Supported aggregations | Supported dimensions                                    |
|-----------------|------------------------|---------------------------------------------------------|
| Count           | Count                  | `Cloud role instance`, `Cloud role name`, `Device type` |

### Failed requests (requests/failed)

The count of tracked server requests that were marked as *failed*. By default, the Application Insights SDK automatically marks each server request that returned HTTP response code 5xx or 4xx as a failed request. You can customize this logic by modifying  *success* property of request telemetry item in a [custom telemetry initializer](../app/api-filtering-sampling.md#addmodify-properties-itelemetryinitializer).

| Unit of measure | Supported aggregations | Supported dimensions                                                                                   |
|-----------------|------------------------|--------------------------------------------------------------------------------------------------------|
| Count           | Count                  | `Cloud role instance`, `Cloud role name`, `Is synthetic traffic`, `Request performance`, `Result code` |

### Server exceptions (exceptions/server)

This metric shows the number of server exceptions.

| Unit of measure | Supported aggregations | Supported dimensions                     |
|-----------------|------------------------|------------------------------------------|
| Count           | Count                  | `Cloud role instance`, `Cloud role name` |

## Performance counters

Use metrics in the **Performance counters** category to access [system performance counters collected by Application Insights](../app/performance-counters.md).

### Available memory (performanceCounters/availableMemory)

| Unit of measure                      | Supported aggregations | Supported dimensions  |
|--------------------------------------|------------------------|-----------------------|
| Data dependent: Megabytes, Gigabytes | Average, Max, Min      | `Cloud role instance` |

### Exception rate (performanceCounters/exceptionRate)

| Unit of measure | Supported aggregations | Supported dimensions  |
|-----------------|------------------------|-----------------------|
| Count           | Average, Max, Min      | `Cloud role instance` |

### HTTP request execution time (performanceCounters/requestExecutionTime)

| Unit of measure | Supported aggregations | Supported dimensions  |
|-----------------|------------------------|-----------------------|
| Milliseconds    | Average, Max, Min      | `Cloud role instance` |

### HTTP request rate (performanceCounters/requestsPerSecond)

| Unit of measure     | Supported aggregations | Supported dimensions  |
|---------------------|------------------------|-----------------------|
| Requests per second | Average, Max, Min      | `Cloud role instance` |

### HTTP requests in application queue (performanceCounters/requestsInQueue)

| Unit of measure | Supported aggregations | Supported dimensions  |
|-----------------|------------------------|-----------------------|
| Count           | Average, Max, Min      | `Cloud role instance` |

### Process CPU (performanceCounters/processCpuPercentage)

The metric shows how much of the total processor capacity is consumed by the process that is hosting your monitored app.

| Unit of measure | Supported aggregations | Supported dimensions  |
|-----------------|------------------------|-----------------------|
| Percentage      | Average, Max, Min      | `Cloud role instance` |

> [!NOTE]
> The range of the metric is between 0 and 100 * n, where n is the number of available CPU cores. For example, the metric value of 200% could represent full utilization of two CPU core or half utilization of 4 CPU cores and so on. The *Process CPU Normalized* is an alternative metric collected by many SDKs which represents the same value but divides it by the number of available CPU cores. Thus, the range of *Process CPU Normalized* metric is 0 through 100.

### Process IO rate (performanceCounters/processIOBytesPerSecond)

| Unit of measure  | Supported aggregations | Supported dimensions  |
|------------------|------------------------|-----------------------|
| Bytes per second | Average, Min, Max      | `Cloud role instance` |

### Process private bytes (performanceCounters/processPrivateBytes)

Amount of non-shared memory that the monitored process allocated for its data.

| Unit of measure | Supported aggregations | Supported dimensions  |
|-----------------|------------------------|-----------------------|
| Bytes           | Average, Min, Max      | `Cloud role instance` |

### Processor time (performanceCounters/processorCpuPercentage)

CPU consumption by *all* processes running on the monitored server instance.

| Unit of measure | Supported aggregations | Supported dimensions  |
|-----------------|------------------------|-----------------------|
| Percentage      | Average, Min, Max      | `Cloud role instance` |

>[!NOTE]
> The processor time metric is not available for the applications hosted in Azure App Services. Use the  [Process CPU](#process-cpu-performancecountersprocesscpupercentage) metric to track CPU utilization of the web applications hosted in App Services.

## Server metrics

### Dependency calls (dependencies/count)

This metric is in relation to the number of dependency calls.

| Unit of measure | Supported aggregations | Supported dimensions                                                                                                                                                           |
|-----------------|------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Count           | Count                  | `Cloud role instance`, `Cloud role name`, `Dependency performance`, `Dependency type`, `Is traffic synthetic`, `Result code`, `Successful call`, `Target of a dependency call` |

### Dependency duration (dependencies/duration)

This metric refers to duration of dependency calls.

| Unit of measure | Supported aggregations | Supported dimensions                                                                                                                                                           |
|-----------------|------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Milliseconds    | Average, Min, Max      | `Cloud role instance`, `Cloud role name`, `Dependency performance`, `Dependency type`, `Is traffic synthetic`, `Result code`, `Successful call`, `Target of a dependency call` |

### Server request rate (requests/rate)

This metric reflects the number of incoming server requests that were received by your web application.

| Unit of measure  | Supported aggregations | Supported dimensions                                                                                                       |
|------------------|------------------------|----------------------------------------------------------------------------------------------------------------------------|
| Count Per Second | Average                | `Cloud role instance`, `Cloud role name`, `Is traffic synthetic`, `Result performance` `Result code`, `Successful request` |

### Server requests (requests/count)

| Unit of measure | Supported aggregations | Supported dimensions                                                                                                       |
|-----------------|------------------------|----------------------------------------------------------------------------------------------------------------------------|
| Count           | Count                  | `Cloud role instance`, `Cloud role name`, `Is traffic synthetic`, `Result performance` `Result code`, `Successful request` |

### Server response time (requests/duration)

This metric reflects the time it took for the servers to process incoming requests.

| Unit of measure | Supported aggregations | Supported dimensions                                                                                                       |
|-----------------|------------------------|----------------------------------------------------------------------------------------------------------------------------|
| MilliSeconds    | Average, Min, Max      | `Cloud role instance`, `Cloud role name`, `Is traffic synthetic`, `Result performance` `Result code`, `Successful request` |

## Usage metrics

### Page view load time (pageViews/duration)

This metric refers to the amount of time it took for PageView events to load.

| Unit of measure | Supported aggregations | Supported dimensions                      |
|-----------------|------------------------|-------------------------------------------|
| MilliSeconds    | Average, Min, Max      | `Cloud role name`, `Is traffic synthetic` |

### Page views (pageViews/count)

The count of PageView events logged with the TrackPageView() Application Insights API.

| Unit of measure | Supported aggregations | Supported dimensions                      |
|-----------------|------------------------|-------------------------------------------|
| Count           | Count                  | `Cloud role name`, `Is traffic synthetic` |

### Traces (traces/count)

The count of trace statements logged with the TrackTrace() Application Insights API call.

| Unit of measure | Supported aggregations | Supported dimensions                                                                |
|-----------------|------------------------|-------------------------------------------------------------------------------------|
| Count           | Count                  | `Cloud role instance`, `Cloud role name`,  `Is traffic synthetic`, `Severity level` |

## Next steps

* [Metrics - Get - REST API](/rest/api/application-insights/metrics/get)
* [Application Insights API for custom events and metrics](api-custom-events-metrics.md)
* [Log-based and preaggregated metrics](./pre-aggregated-metrics-log-metrics.md).
* [Log-based metrics queries and definitions](../essentials/app-insights-metrics.md).
