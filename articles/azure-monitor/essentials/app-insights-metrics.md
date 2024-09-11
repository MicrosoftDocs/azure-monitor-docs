---
title: Azure Application Insights log-based metrics | Microsoft Docs
description: This article lists Azure Application Insights metrics with supported aggregations and dimensions. The details about log-based metrics include the underlying Kusto query statements.
author: vgorbenko
services: azure-monitor  
ms.topic: reference
ms.date: 09/06/2024
ms.reviewer: vitalyg
---

# Application Insights log-based metrics

> [!IMPORTANT]
> Both log-based and preaggregated metrics coexist in Application Insights. To differentiate the two, in the Application Insights user experience the preaggregated metrics are now called standard metrics. The traditional metrics from the events were renamed to log-based metrics.

Application Insights log-based metrics let you analyze the health of your monitored apps, create powerful dashboards, and configure alerts.

<!-- TO BE MOVED

There are two kinds of metrics:

* [Log-based metrics](../app/pre-aggregated-metrics-log-metrics.md#log-based-metrics) behind the scene are translated into [Kusto queries](/azure/kusto/query/) from stored events.
* [Standard metrics](../app/pre-aggregated-metrics-log-metrics.md#preaggregated-metrics) are stored as preaggregated time series.

Since *standard metrics* are preaggregated during collection, they have better performance at query time. This makes them a better choice for dashboarding and in real-time alerting. The *log-based metrics* have more dimensions, which makes them the superior option for data analysis and ad-hoc diagnostics. Use the [namespace selector](./metrics-store-custom-rest-api.md#namespace) to switch between log-based and standard metrics in [metrics explorer](./analyze-metrics.md).

-->

## Interpret and use queries from this article

This article lists metrics with supported aggregations and dimensions. The details about log-based metrics include the underlying Kusto query statements. For convenience, each query uses defaults for time granularity, chart type, and sometimes splitting dimension which simplifies using the query in Log Analytics without any need for modification.

When you plot the same metric in [metrics explorer](./analyze-metrics.md), there are no defaults - the query is dynamically adjusted based on your chart settings:

- The selected **Time range** is translated into an additional *where timestamp...* clause to only pick the events from selected time range. For example, a chart showing data for the most recent 24 hours, the query includes *| where timestamp > ago(24 h)*.

- The selected **Time granularity** is put into the final *summarize ... by bin(timestamp, [time grain])* clause.

- Any selected **Filter** dimensions are translated into additional *where* clauses.

- The selected **Split chart** dimension is translated into an extra summarize property. For example, if you split your chart by *location*, and plot using a 5-minute time granularity, the *summarize* clause is summarized *... by bin(timestamp, 5 m), location*.

> [!NOTE]
> If you're new to the Kusto query language, you start by copying and pasting Kusto statements into the Log Analytics query pane without making any modifications. Click **Run** to see basic chart. As you begin to understand the syntax of query language, you can start making small modifications and see the impact of your change. Exploring your own data is a great way to start realizing the full power of [Log Analytics](../logs/log-analytics-tutorial.md) and [Azure Monitor](../overview.md).

## Availability metrics

Metrics in the Availability category enable you to see the health of your web application as observed from points around the world. [Configure the availability tests](/previous-versions/azure/azure-monitor/app/monitor-web-app-availability) to start using any metrics from this category.

### Availability (availabilityResults/availabilityPercentage)
The *Availability* metric shows the percentage of the web test runs that didn't detect any issues. The lowest possible value is 0, which indicates that all of the web test runs have failed. The value of 100 means that all of the web test runs passed the validation criteria.

| Unit of measure | Supported aggregations | Supported dimensions    |
|-----------------|------------------------|-------------------------|
| Percentage      | Average                | Run location, Test name |

```Kusto
availabilityResults 
| summarize sum(todouble(success == 1) * 100) / count() by bin(timestamp, 5m), location
| render timechart
```

### Availability test duration (availabilityResults/duration)

The *Availability test duration* metric shows how much time it took for the web test to run. For the [multi-step web tests](/previous-versions/azure/azure-monitor/app/availability-multistep), the metric reflects the total execution time of all steps.

| Unit of measure | Supported aggregations | Supported dimensions                 |
|-----------------|------------------------|--------------------------------------|
| Milliseconds    | Average, Min, Max      | Run location, Test name, Test result |

```Kusto
availabilityResults
| where notempty(duration)
| extend availabilityResult_duration = iif(itemType == 'availabilityResult', duration, todouble(''))
| summarize sum(availabilityResult_duration)/sum(itemCount) by bin(timestamp, 5m), location
| render timechart
```

### Availability tests (availabilityResults/count)

The *Availability tests* metric reflects the count of the web tests runs by Azure Monitor.

| Unit of measure | Supported aggregations | Supported dimensions                 |
|-----------------|------------------------|--------------------------------------|
| Count           | Count                  | Run location, Test name, Test result |

```Kusto
availabilityResults
| summarize sum(itemCount) by bin(timestamp, 5m)
| render timechart
```

## Browser metrics

Browser metrics are collected by the Application Insights JavaScript SDK from real end-user browsers. They provide great insights into your users' experience with your web app. Browser metrics are typically not sampled, which means that they provide higher precision of the usage numbers compared to server-side metrics which might be skewed by sampling.

> [!NOTE]
> To collect browser metrics, your application must be instrumented with the [Application Insights JavaScript SDK](../app/javascript.md).

### Browser page load time (browserTimings/totalDuration)

Time from user request until DOM, stylesheets, scripts and images are loaded.

| Unit of measure | Supported aggregations | Preaggregated dimensions |
|-----------------|------------------------|--------------------------|
| Milliseconds    | Average, Min, Max      | None                     |

```Kusto
browserTimings
| where notempty(totalDuration)
| extend _sum = totalDuration
| extend _count = itemCount
| extend _sum = _sum * _count
| summarize sum(_sum) / sum(_count) by bin(timestamp, 5m)
| render timechart
```

### Client processing time (browserTiming/processingDuration)

Time between receiving the last byte of a document until the DOM is loaded. Async requests may still be processing.

| Unit of measure | Supported aggregations | Preaggregated dimensions |
|-----------------|------------------------|--------------------------|
| Milliseconds    | Average, Min, Max      | None                     |

```Kusto
browserTimings
| where notempty(processingDuration)
| extend _sum = processingDuration
| extend _count = itemCount
| extend _sum = _sum * _count
| summarize sum(_sum)/sum(_count) by bin(timestamp, 5m)
| render timechart
```

### Page load network connect time (browserTimings/networkDuration)

Time between user request and network connection. Includes DNS lookup and transport connection.

| Unit of measure | Supported aggregations | Preaggregated dimensions |
|-----------------|------------------------|--------------------------|
| Milliseconds    | Average, Min, Max      | None                     |

```Kusto
browserTimings
| where notempty(networkDuration)
| extend _sum = networkDuration
| extend _count = itemCount
| extend _sum = _sum * _count
| summarize sum(_sum) / sum(_count) by bin(timestamp, 5m)
| render timechart
```

### Receiving response time (browserTimings/receiveDuration)

Time between the first and last bytes, or until disconnection.

| Unit of measure | Supported aggregations | Preaggregated dimensions |
|-----------------|------------------------|--------------------------|
| Milliseconds    | Average, Min, Max      | None                     |

```Kusto
browserTimings
| where notempty(receiveDuration)
| extend _sum = receiveDuration
| extend _count = itemCount
| extend _sum = _sum * _count
| summarize sum(_sum) / sum(_count) by bin(timestamp, 5m)
| render timechart
```

### Send request time (browserTimings/sendDuration)

Time between network connection and receiving the first byte.

| Unit of measure | Supported aggregations | Preaggregated dimensions |
|-----------------|------------------------|--------------------------|
| Milliseconds    | Average, Min, Max      | None                     |

```Kusto
browserTimings
| where notempty(sendDuration)
| extend _sum = sendDuration
| extend _count = itemCount
| extend _sum = _sum * _count
| summarize sum(_sum) / sum(_count) by bin(timestamp, 5m)
| render timechart
```

## Failure metrics

The metrics in **Failures** show problems with processing requests, dependency calls, and thrown exceptions.

### Browser exceptions (exceptions/browser)

This metric reflects the number of thrown exceptions from your application code running in browser. Only exceptions that are tracked with a ```trackException()``` Application Insights API call are included in the metric.

| Unit of measure | Supported aggregations | Preaggregated dimensions | Notes                                      |
|-----------------|------------------------|--------------------------|--------------------------------------------|
| Count           | Count                  | None                     | Log-based version uses **Sum** aggregation |

```Kusto
exceptions
| where notempty(client_Browser)
| summarize sum(itemCount) by bin(timestamp, 5m)
| render barchart
```

### Dependency call failures (dependencies/failed)

The number of failed dependency calls.

| Unit of measure | Supported aggregations | Preaggregated dimensions | Notes                                      |
|-----------------|------------------------|--------------------------|--------------------------------------------|
| Count           | Count                  | None                     | Log-based version uses **Sum** aggregation |

```Kusto
dependencies
| where success == 'False'
| summarize sum(itemCount) by bin(timestamp, 5m)
| render barchart
```

### Exceptions (exceptions/count)

Each time when you log an exception to Application Insights, there is a call to the [trackException() method](../app/api-custom-events-metrics.md#trackexception) of the SDK. The Exceptions metric shows the number of logged exceptions.

| Unit of measure | Supported aggregations | Preaggregated dimensions                          | Notes                                      |
|-----------------|------------------------|---------------------------------------------------|--------------------------------------------|
| Count           | Count                  | Cloud role name, Cloud role instance, Device type | Log-based version uses **Sum** aggregation |

```Kusto
exceptions
| summarize sum(itemCount) by bin(timestamp, 5m)
| render barchart
```

### Failed requests (requests/failed)

The count of tracked server requests that were marked as *failed*. By default, the Application Insights SDK automatically marks each server request that returned HTTP response code 5xx or 4xx as a failed request. You can customize this logic by modifying  *success* property of request telemetry item in a [custom telemetry initializer](../app/api-filtering-sampling.md#addmodify-properties-itelemetryinitializer).

| Unit of measure | Supported aggregations | Preaggregated dimensions                                                                            | Notes                                      |
|-----------------|------------------------|-----------------------------------------------------------------------------------------------------|--------------------------------------------|
| Count           | Count                  | Cloud role instance, Cloud role name, Real or synthetic traffic, Request performance, Response code | Log-based version uses **Sum** aggregation |

```Kusto
requests
| where success == 'False'
| summarize sum(itemCount) by bin(timestamp, 5m)
| render barchart
```

### Server exceptions (exceptions/server)

This metric shows the number of server exceptions.

| Unit of measure | Supported aggregations | Preaggregated dimensions             | Notes                                      |
|-----------------|------------------------|--------------------------------------|--------------------------------------------|
| Count           | Count                  | Cloud role name, Cloud role instance | Log-based version uses **Sum** aggregation |

```Kusto
exceptions
| where isempty(client_Browser)
| summarize sum(itemCount) by bin(timestamp, 5m)
| render barchart
```

## Performance counters

Use metrics in the **Performance counters** category to access [system performance counters collected by Application Insights](../app/performance-counters.md).

### Available memory (performanceCounters/availableMemory)

```Kusto
performanceCounters
| where ((category == "Memory" and counter == "Available Bytes") or name == "availableMemory")
| extend performanceCounter_value = iif(itemType == "performanceCounter", value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

### Exception rate (performanceCounters/exceptionRate)

```Kusto
performanceCounters
| where ((category == ".NET CLR Exceptions" and counter == "# of Exceps Thrown / sec") or name == "exceptionRate")
| extend performanceCounter_value = iif(itemType == 'performanceCounter',value,todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

### HTTP request execution time (performanceCounters/requestExecutionTime)

```Kusto
performanceCounters
| where ((category == "ASP.NET Applications" and counter == "Request Execution Time") or name == "requestExecutionTime")
| extend performanceCounter_value = iif(itemType == "performanceCounter", value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

### HTTP request rate (performanceCounters/requestsPerSecond)

```Kusto
performanceCounters
| where ((category == "ASP.NET Applications" and counter == "Requests/Sec") or name == "requestsPerSecond")
| extend performanceCounter_value = iif(itemType == "performanceCounter", value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

### HTTP requests in application queue (performanceCounters/requestsInQueue)

```Kusto
performanceCounters
| where ((category == "ASP.NET Applications" and counter == "Requests In Application Queue") or name == "requestsInQueue")
| extend performanceCounter_value = iif(itemType == "performanceCounter", value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

### Process CPU (performanceCounters/processCpuPercentage)

The metric shows how much of the total processor capacity is consumed by the process that is hosting your monitored app.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Percentage      | Average, Min, Max      | Cloud role instance  |

```Kusto
performanceCounters
| where ((category == "Process" and counter == "% Processor Time Normalized") or name == "processCpuPercentage")
| extend performanceCounter_value = iif(itemType == "performanceCounter", value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

> [!NOTE]
> The range of the metric is between 0 and 100 * n, where n is the number of available CPU cores. For example, the metric value of 200% could represent full utilization of two CPU core or half utilization of 4 CPU cores and so on. The *Process CPU Normalized* is an alternative metric collected by many SDKs which represents the same value but divides it by the number of available CPU cores. Thus, the range of *Process CPU Normalized* metric is 0 through 100.

### Process IO rate (performanceCounters/processIOBytesPerSecond)

| Unit of measure  | Supported aggregations | Supported dimensions |
|------------------|------------------------|----------------------|
| Bytes per second | Average, Min, Max      | Cloud role instance  |

```Kusto
performanceCounters
| where ((category == "Process" and counter == "IO Data Bytes/sec") or name == "processIOBytesPerSecond")
| extend performanceCounter_value = iif(itemType == "performanceCounter", value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

### Process private bytes (performanceCounters/processPrivateBytes)

Amount of non-shared memory that the monitored process allocated for its data.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Bytes           | Average, Min, Max      | Cloud role instance  |

```Kusto
performanceCounters
| where ((category == "Process" and counter == "Private Bytes") or name == "processPrivateBytes")
| extend performanceCounter_value = iif(itemType == "performanceCounter", value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

### Processor time (performanceCounters/processorCpuPercentage)

CPU consumption by *all* processes running on the monitored server instance.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Percentage      | Average, Min, Max      | Cloud role instance  |

>[!NOTE]
> The processor time metric is not available for the applications hosted in Azure App Services. Use the  [Process CPU](#process-cpu-performancecountersprocesscpupercentage) metric to track CPU utilization of the web applications hosted in App Services.

```Kusto
performanceCounters
| where ((category == "Processor" and counter == "% Processor Time") or name == "processorCpuPercentage")
| extend performanceCounter_value = iif(itemType == "performanceCounter", value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

## Server metrics

### Dependency calls (dependencies/count)

This metric is in relation to the number of dependency calls.

```Kusto
dependencies
| summarize sum(itemCount) by bin(timestamp, 5m)
| render barchart
```

### Dependency duration (dependencies/duration)

This metric refers to duration of dependency calls.

```Kusto
dependencies
| where notempty(duration)
| extend dependency_duration = iif(itemType == 'dependency',duration,todouble(''))
| extend _sum = dependency_duration
| extend _count = itemCount
| extend _sum = _sum*_count
| summarize sum(_sum)/sum(_count) by bin(timestamp, 1m)
| render timechart
```

### Server requests (requests/count)

This metric reflects the number of incoming server requests that were received by your web application.

```Kusto
requests
| summarize sum(itemCount) by bin(timestamp, 5m)
| render barchart
```

### Server response time (requests/duration)

This metric reflects the time it took for the servers to process incoming requests.

```Kusto
requests
| where notempty(duration)
| extend request_duration = iif(itemType == 'request', duration, todouble(''))
| extend _sum = request_duration
| extend _count = itemCount
| extend _sum = _sum*_count
| summarize sum(_sum) / sum(_count) by bin(timestamp, 1m)
| render timechart
```

## Usage metrics

### Page view load time (pageViews/duration)

This metric refers to the amount of time it took for PageView events to load.

```Kusto
pageViews
| where notempty(duration)
| extend pageView_duration = iif(itemType == 'pageView', duration, todouble(''))
| extend _sum = pageView_duration
| extend _count = itemCount
| extend _sum = _sum * _count
| summarize sum(_sum) / sum(_count) by bin(timestamp, 5m)
| render barchart
```

### Page views (pageViews/count)

The count of PageView events logged with the TrackPageView() Application Insights API.

```Kusto
pageViews
| summarize sum(itemCount) by bin(timestamp, 1h)
| render barchart
```

### Sessions (sessions/count)

This metric refers to the count of distinct session IDs.

```Kusto
union traces, requests, pageViews, dependencies, customEvents, availabilityResults, exceptions, customMetrics, browserTimings
| where notempty(session_Id)
| summarize dcount(session_Id) by bin(timestamp, 1h)
| render barchart
```

### Traces (traces/count)

The count of trace statements logged with the TrackTrace() Application Insights API call.

```Kusto
traces
| summarize sum(itemCount) by bin(timestamp, 1h)
| render barchart
```

### Users (users/count)

The number of distinct users who accessed your application. The accuracy of this metric may be  significantly impacted by using telemetry sampling and filtering.

```Kusto
union traces, requests, pageViews, dependencies, customEvents, availabilityResults, exceptions, customMetrics, browserTimings
| where notempty(user_Id)
| summarize dcount(user_Id) by bin(timestamp, 1h)
| render barchart
```

### Users, Authenticated (users/authenticated)

The number of distinct users who authenticated into your application.

```Kusto
union traces, requests, pageViews, dependencies, customEvents, availabilityResults, exceptions, customMetrics, browserTimings
| where notempty(user_AuthenticatedId)
| summarize dcount(user_AuthenticatedId) by bin(timestamp, 1h)
| render barchart
```

## Access all your data directly with the Application Insights REST API

The Application Insights REST API enables programmatic retrieval of log-based metrics. It also features an optional parameter “ai.include-query-payload” that when added to a query string, prompts the API to return not only the timeseries data, but also the Kusto Query Language (KQL) statement used to fetch it. This parameter can be particularly beneficial for users aiming to comprehend the connection between raw events in Log Analytics and the resulting log-based metric.

To access your data directly, pass the parameter “ai.include-query-payload” to the Application Insights API in a query using KQL.

```Kusto
api.applicationinsights.io/v1/apps/DEMO_APP/metrics/users/authenticated?api_key=DEMO_KEY&prefer=ai.include-query-payload
```

The following is an example of a return KQL statement for the metric "Authenticated Users.” (In this example, "users/authenticated" is the metric id.) 

```Kusto
output
{
    "value": {
        "start": "2024-06-21T09:14:25.450Z",
        "end": "2024-06-21T21:14:25.450Z",
        "users/authenticated": {
            "unique": 0
        }
    },
    "@ai.query": "union (traces | where timestamp >= datetime(2024-06-21T09:14:25.450Z) and timestamp < datetime(2024-06-21T21:14:25.450Z)), (requests | where timestamp >= datetime(2024-06-21T09:14:25.450Z) and timestamp < datetime(2024-06-21T21:14:25.450Z)), (pageViews | where timestamp >= datetime(2024-06-21T09:14:25.450Z) and timestamp < datetime(2024-06-21T21:14:25.450Z)), (dependencies | where timestamp >= datetime(2024-06-21T09:14:25.450Z) and timestamp < datetime(2024-06-21T21:14:25.450Z)), (customEvents | where timestamp >= datetime(2024-06-21T09:14:25.450Z) and timestamp < datetime(2024-06-21T21:14:25.450Z)), (availabilityResults | where timestamp >= datetime(2024-06-21T09:14:25.450Z) and timestamp < datetime(2024-06-21T21:14:25.450Z)), (exceptions | where timestamp >= datetime(2024-06-21T09:14:25.450Z) and timestamp < datetime(2024-06-21T21:14:25.450Z)), (customMetrics | where timestamp >= datetime(2024-06-21T09:14:25.450Z) and timestamp < datetime(2024-06-21T21:14:25.450Z)), (browserTimings | where timestamp >= datetime(2024-06-21T09:14:25.450Z) and timestamp < datetime(2024-06-21T21:14:25.450Z)) | where notempty(user_AuthenticatedId) | summarize ['users/authenticated_unique'] = dcount(user_AuthenticatedId)"
}
```

## Next steps

* ...