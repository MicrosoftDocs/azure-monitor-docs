---
title: Metrics in Application Insights - Azure Monitor | Microsoft Docs
description: This article explains the difference between log-based and standard/preaggregated metrics in Application Insights.
ms.topic: conceptual
ms.date: 09/06/2024
ms.reviewer: vitalyg
---

# Metrics in Application Insights

Application Insights supports three different types of metrics: standard (preaggregated), log-based, and custom metrics. Each one brings a unique value in monitoring application health, diagnostics, and analytics. Developers who are instrumenting applications can decide which type of metric is best suited to a particular scenario. Decisions are based on the size of the application, expected volume of telemetry, and business requirements for metrics precision and alerting. This article explains the difference between all supported metrics types.

* **Standard metrics:** Standard metrics in Application Insights are predefined metrics which are automatically collected and monitored by the service. These metrics cover a wide range of performance and usage indicators, such as CPU usage, memory consumption, request rates, and response times. Standard metrics provide a comprehensive overview of your application's health and performance without requiring any additional configuration. *Standard metrics **are preaggregated** during collection*, which gives them better performance at query time. This makes them the best choice for dashboards and real-time alerting.

* **Log-based metrics:** Log-based metrics in Application Insights are a query-time concept, represented as a time series on top of the log data of your application. *The underlying logs **aren't preaggregated** at the collection or storage time* and retain all properties of each log entry. This makes it possible to use log properties as dimensions on log-based metrics at a query time for [metric chart filtering](../essentials/analyze-metrics.md#add-filters) and [metric splitting](../essentials/analyze-metrics.md#apply-metric-splitting), giving log-based metrics superior analytical and diagnostic value. However, telemetry volume reduction techniques such as [sampling](sampling-classic-api.md) and [telemetry filtering](api-filtering-sampling.md#filtering) commonly used with monitoring large applications impacts the quantity of the collected log entries and therefore reduce the accuracy of log-based metrics.

* **Custom metrics (preview):** Custom metrics in Application Insights allow you to define and track specific measurements that are unique to your application. These metrics can be created by instrumenting your code to send custom telemetry data to Application Insights. Custom metrics provide the flexibility to monitor any aspect of your application that isn't covered by standard metrics, enabling you to gain deeper insights into your application's behavior and performance. 

    For more information, see [Custom metrics in Azure Monitor (preview)](../essentials/metrics-custom-overview.md).

> [!NOTE]
> Application Insights also provides a feature called [Live Metrics stream](./live-stream.md), which allows for near real-time monitoring of your web applications and doesn't store any telemetry data.

### Feature comparison

| Feature | Standard metrics | Log-based metrics | Custom metrics |
|---------|------------------|-------------------|----------------|
| **Data source** | Preaggregated time series data collected during runtime. | Derived from log data using Kusto queries. | User-defined metrics collected via the Application Insights SDK or API. |
| **Granularity** | Fixed intervals (1 minute). | Depends on the granularity of the log data itself. | Flexible granularity based on user-defined metrics. |
| **Accuracy** | High, not affected by log sampling. | Can be affected by sampling and filtering. | High accuracy, especially when using preaggregated methods like GetMetric. |
| **Cost** | Included in Application Insights pricing. | Based on log data ingestion and query costs. | See [Pricing model and retention](./../essentials/metrics-custom-overview.md#pricing-model-and-retention). |
| **Configuration** | Automatically available with minimal configuration. | Require configuration of log queries to extract the desired metrics from log data. | Requires custom implementation and configuration in code. |
| **Query performance** | Fast, due to preaggregation. | Slower, as it involves querying log data. | Depends on data volume and query complexity. |
| **Storage** | Stored as time series data in the Azure Monitor metrics store. | Stored as logs in Log Analytics workspace. | Stored in both Log Analytics and the Azure Monitor metrics store. |
| **Alerting** | Supports real-time alerting. | Allows for complex alerting scenarios based on detailed log data. | Flexible alerting based on user-defined metrics. |
| **Service limit** | Subject to [Application Insights limits](./../service-limits.md#application-insights). | Subject to [Log Analytics workspace limits](./../service-limits.md#log-analytics-workspaces). | Limited by the quota for free metrics and the cost for additional dimensions. |
| **Use cases** | Real-time monitoring, performance dashboards, and quick insights. | Detailed diagnostics, troubleshooting, and in-depth analysis. | Tailored performance indicators and business-specific metrics. |
| **Examples** | CPU usage, memory usage, request duration. | Request counts, exception traces, dependency calls. | Custom application-specific metrics like user engagement, feature usages. |

## Metrics support

> [!NOTE]
> Log-based metrics are supported for all languages and instrumentation methods.

### SDK supported preaggregated metrics table

| Current production SDKs | Standard metrics (SDK preaggregation) | Custom metrics (without SDK preaggregation) | Custom metrics (with SDK preaggregation) |
|-------------------------|---------------------------------------|---------------------------------------------|------------------------------------------|
| .NET Core and .NET Framework | Supported (V2.13.1+) | Supported via [TrackMetric](api-custom-events-metrics.md#trackmetric) | Supported (V2.7.2+) via [GetMetric](get-metric.md) |
| Java | Not supported | Supported via [TrackMetric](api-custom-events-metrics.md#trackmetric) | Not supported |
| Node.js | Supported (V2.0.0+) | Supported via [TrackMetric](api-custom-events-metrics.md#trackmetric) | Not supported |
| Python | Not supported | Supported | Partially supported via [OpenCensus.stats](/previous-versions/azure/azure-monitor/app/opencensus-python#metrics) |

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

## Use preaggregation with Application Insights custom metrics

You can use preaggregation with custom metrics. The two main benefits are: 

- Configure and alert on a dimension of a custom metric
- Reduce the volume of data sent from the SDK to the Application Insights collection endpoint

There are several [ways of sending custom metrics from the Application Insights SDK](./api-custom-events-metrics.md). If your version of the SDK offers [GetMetric and TrackValue](./api-custom-events-metrics.md#getmetric), these methods are the preferred way of sending custom metrics. In this case, preaggregation happens inside the SDK. This approach reduces the volume of data stored in Azure and also the volume of data transmitted from the SDK to Application Insights. Otherwise, use the [trackMetric](./api-custom-events-metrics.md#trackmetric) method, which preaggregates metric events during data ingestion.

## Custom metrics dimensions and preaggregation

All metrics that you send using [OpenTelemetry](opentelemetry-add-modify.md), [trackMetric](./api-custom-events-metrics.md#trackmetric), or [GetMetric and TrackValue](./api-custom-events-metrics.md#getmetric) API calls are automatically stored in both logs and metrics stores. These metrics can be found in the customMetrics table in Application Insights and in Metrics Explorer under the Custom Metric Namespace called "azure.applicationinsights". Although the log-based version of your custom metric always retains all dimensions, the preaggregated version of the metric is stored by default with no dimensions. Retaining dimensions of custom metrics is a Preview feature that can be turned on from the [Usage and estimated cost](../cost-usage.md#usage-and-estimated-costs) tab by selecting **With dimensions** under **Send custom metrics to Azure Metric Store**.

:::image type="content" source="./media/pre-aggregated-metrics-log-metrics/001-cost.png" lightbox="./media/pre-aggregated-metrics-log-metrics/001-cost.png" alt-text="Screenshot that shows usage and estimated costs.":::

## Quotas

Preaggregated metrics are stored as time series in Azure Monitor. [Azure Monitor quotas on custom metrics](../essentials/metrics-custom-overview.md#quotas-and-limits) apply.

> [!NOTE]
> Going over the quota might have unintended consequences. Azure Monitor might become unreliable in your subscription or region. To learn how to avoid exceeding the quota, see [Design limitations and considerations](../essentials/metrics-custom-overview.md#design-limitations-and-considerations).

## Why is collection of custom metrics dimensions turned off by default?

The collection of custom metrics dimensions is turned off by default because in the future storing custom metrics with dimensions will be billed separately from Application Insights. Storing the nondimensional custom metrics remain free (up to a quota). You can learn about the upcoming pricing model changes on our official [pricing page](https://azure.microsoft.com/pricing/details/monitor/).

## Create charts and explore metrics

Use [Azure Monitor metrics explorer](../essentials/metrics-getting-started.md) to plot charts from preaggregated, log-based, and custom metrics, and to author dashboards with charts. After you select the Application Insights resource you want, use the namespace picker to switch between metrics.

:::image type="content" source="./../essentials/media/metrics-custom-overview/002-metric-namespace.png" lightbox="./../essentials/media/metrics-custom-overview/002-metric-namespace.png" alt-text="Screenshot that shows Metric namespace.":::

## Pricing models for Application Insights metrics

Ingesting metrics into Application Insights, whether log-based or preaggregated, generates costs based on the size of the ingested data. For more information, see [Azure Monitor Logs pricing details](../logs/cost-logs.md#application-insights-billing). Your custom metrics, including all its dimensions, are always stored in the Application Insights log store. Also, a preaggregated version of your custom metrics with no dimensions is forwarded to the metrics store by default.

Selecting the [Enable alerting on custom metric dimensions](./../essentials/metrics-custom-overview.md#custom-metrics-dimensions-and-preaggregation) option to store all dimensions of the preaggregated metrics in the metric store can generate *extra costs* based on [custom metrics pricing](https://azure.microsoft.com/pricing/details/monitor/).

## Available metrics

This article lists metrics with supported aggregations and dimensions. The details about log-based metrics include the underlying Kusto query statements. For convenience, each query uses defaults for time granularity, chart type, and sometimes splitting dimension which simplifies using the query in Log Analytics without any need for modification.

When you plot the same metric in [metrics explorer](./../essentials/analyze-metrics.md), there are no defaults - the query is dynamically adjusted based on your chart settings:

* The selected **Time range** is translated into an additional *where timestamp...* clause to only pick the events from selected time range. For example, a chart showing data for the most recent 24 hours, the query includes *| where timestamp > ago(24 h)*.

* The selected **Time granularity** is put into the final *summarize ... by bin(timestamp, [time grain])* clause.

* Any selected **Filter** dimensions are translated into additional *where* clauses.

* The selected **Split chart** dimension is translated into an extra summarize property. For example, if you split your chart by *location*, and plot using a 5-minute time granularity, the *summarize* clause is summarized *... by bin(timestamp, 5 m), location*.

> [!NOTE]
> If you're new to the Kusto query language, you start by copying and pasting Kusto statements into the Log Analytics query pane without making any modifications. Click **Run** to see basic chart. As you begin to understand the syntax of query language, you can start making small modifications and see the impact of your change. Exploring your own data is a great way to start realizing the full power of [Log Analytics](../logs/log-analytics-tutorial.md) and [Azure Monitor](../overview.md).

## Availability metrics

Metrics in the Availability category enable you to see the health of your web application as observed from points around the world. [Configure the availability tests](../app/availability-overview.md) to start using any metrics from this category.

### Availability (availabilityResults/availabilityPercentage)

The *Availability* metric shows the percentage of the web test runs that didn't detect any issues. The lowest possible value is 0, which indicates that all of the web test runs have failed. The value of 100 means that all of the web test runs passed the validation criteria.

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions        |
|-----------------|------------------------|-----------------------------|
| Percentage      | Average                | `Run location`, `Test name` |

#### [Log-based metrics](#tab/log-based)

| Unit of measure | Supported aggregations | Supported dimensions        |
|-----------------|------------------------|-----------------------------|
| Percentage      | Average                | `Run location`, `Test name` |

```Kusto
availabilityResults 
| summarize sum(todouble(success == 1) * 100) / count() by bin(timestamp, 5m), location
| render timechart
```

---

### Availability test duration (availabilityResults/duration)

The *Availability test duration* metric shows how much time it took for the web test to run. For the [multi-step web tests](/previous-versions/azure/azure-monitor/app/availability-multistep), the metric reflects the total execution time of all steps.

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions                       |
|-----------------|------------------------|--------------------------------------------|
| Milliseconds    | Average, Min, Max      | `Run location`, `Test name`, `Test result` |

#### [Log-based metrics](#tab/log-based)

| Unit of measure | Supported aggregations | Supported dimensions                       |
|-----------------|------------------------|--------------------------------------------|
| Milliseconds    | Average, Min, Max      | `Run location`, `Test name`, `Test result` |

```Kusto
availabilityResults
| where notempty(duration)
| extend availabilityResult_duration = iif(itemType == 'availabilityResult', duration, todouble(''))
| summarize sum(availabilityResult_duration)/sum(itemCount) by bin(timestamp, 5m), location
| render timechart
```

---

### Availability tests (availabilityResults/count)

The *Availability tests* metric reflects the count of the web tests runs by Azure Monitor.

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions                       |
|-----------------|------------------------|--------------------------------------------|
| Count           | Count                  | `Run location`, `Test name`, `Test result` |

#### [Log-based metrics](#tab/log-based)

| Unit of measure | Supported aggregations | Supported dimensions                       |
|-----------------|------------------------|--------------------------------------------|
| Count           | Count                  | `Run location`, `Test name`, `Test result` |

```Kusto
availabilityResults
| summarize sum(itemCount) by bin(timestamp, 5m)
| render timechart
```

---

## Browser metrics

Browser metrics are collected by the Application Insights JavaScript SDK from real end-user browsers. They provide great insights into your users' experience with your web app. Browser metrics are typically not sampled, which means that they provide higher precision of the usage numbers compared to server-side metrics which might be skewed by sampling.

> [!NOTE]
> To collect browser metrics, your application must be instrumented with the [Application Insights JavaScript SDK](../app/javascript.md).

### Browser page load time (browserTimings/totalDuration)

Time from user request until DOM, stylesheets, scripts, and images are loaded.

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Average, Min, Max      | None                 |

#### [Log-based metrics](#tab/log-based)

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

---

### Client processing time (browserTiming/processingDuration)

Time between receiving the last byte of a document until the DOM is loaded. Async requests may still be processing.

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Average, Min, Max      | None                 |

#### [Log-based metrics](#tab/log-based)

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

---

### Page load network connect time (browserTimings/networkDuration)

Time between user request and network connection. Includes DNS lookup and transport connection.

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Average, Min, Max      | None                 |

#### [Log-based metrics](#tab/log-based)

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

---

### Receiving response time (browserTimings/receiveDuration)

Time between the first and last bytes, or until disconnection.

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Average, Min, Max      | None                 |

#### [Log-based metrics](#tab/log-based)

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

---

### Send request time (browserTimings/sendDuration)

Time between network connection and receiving the first byte.

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Average, Min, Max      | None                 |

#### [Log-based metrics](#tab/log-based)

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

---

## Failure metrics

The metrics in **Failures** show problems with processing requests, dependency calls, and thrown exceptions.

### Browser exceptions (exceptions/browser)

This metric reflects the number of thrown exceptions from your application code running in browser. Only exceptions that are tracked with a ```trackException()``` Application Insights API call are included in the metric.

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Count                  | `Cloud role name`    |

#### [Log-based metrics](#tab/log-based)

| Unit of measure | Supported aggregations | Preaggregated dimensions | Notes                                      |
|-----------------|------------------------|--------------------------|--------------------------------------------|
| Count           | Count                  | None                     | Log-based version uses **Sum** aggregation |

```Kusto
exceptions
| where notempty(client_Browser)
| summarize sum(itemCount) by bin(timestamp, 5m)
| render barchart
```

---

### Dependency call failures (dependencies/failed)

The number of failed dependency calls.

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions                                                                                                                                      |
|-----------------|------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| Count           | Count                  | `Cloud role instance`, `Cloud role name`, `Dependency performance`, `Dependency type`, `Is traffic synthetic`, `Result code`, `Target of dependency call` |

#### [Log-based metrics](#tab/log-based)

| Unit of measure | Supported aggregations | Preaggregated dimensions | Notes                                      |
|-----------------|------------------------|--------------------------|--------------------------------------------|
| Count           | Count                  | None                     | Log-based version uses **Sum** aggregation |

```Kusto
dependencies
| where success == 'False'
| summarize sum(itemCount) by bin(timestamp, 5m)
| render barchart
```

---

### Exceptions (exceptions/count)

Each time when you log an exception to Application Insights, there's a call to the [trackException() method](../app/api-custom-events-metrics.md#trackexception) of the SDK. The Exceptions metric shows the number of logged exceptions.

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions                                    |
|-----------------|------------------------|---------------------------------------------------------|
| Count           | Count                  | `Cloud role instance`, `Cloud role name`, `Device type` |

#### [Log-based metrics](#tab/log-based)

| Unit of measure | Supported aggregations | Preaggregated dimensions                                | Notes                                      |
|-----------------|------------------------|---------------------------------------------------------|--------------------------------------------|
| Count           | Count                  | `Cloud role instance`, `Cloud role name`, `Device type` | Log-based version uses **Sum** aggregation |

```Kusto
exceptions
| summarize sum(itemCount) by bin(timestamp, 5m)
| render barchart
```

---

### Failed requests (requests/failed)

The count of tracked server requests that were marked as *failed*. By default, the Application Insights SDK automatically marks each server request that returned HTTP response code 5xx or 4xx as a failed request. You can customize this logic by modifying *success* property of request telemetry item in a [custom telemetry initializer](../app/api-filtering-sampling.md#addmodify-properties-itelemetryinitializer).

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions                                                                                   |
|-----------------|------------------------|--------------------------------------------------------------------------------------------------------|
| Count           | Count                  | `Cloud role instance`, `Cloud role name`, `Is synthetic traffic`, `Request performance`, `Result code` |

#### [Log-based metrics](#tab/log-based)

| Unit of measure | Supported aggregations | Preaggregated dimensions                                                                               | Notes                                      |
|-----------------|------------------------|--------------------------------------------------------------------------------------------------------|--------------------------------------------|
| Count           | Count                  | `Cloud role instance`, `Cloud role name`, `Is synthetic traffic`, `Request performance`, `Result code` | Log-based version uses **Sum** aggregation |

```Kusto
requests
| where success == 'False'
| summarize sum(itemCount) by bin(timestamp, 5m)
| render barchart
```

---

### Server exceptions (exceptions/server)

This metric shows the number of server exceptions.

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions                     |
|-----------------|------------------------|------------------------------------------|
| Count           | Count                  | `Cloud role instance`, `Cloud role name` |

#### [Log-based metrics](#tab/log-based)

| Unit of measure | Supported aggregations | Preaggregated dimensions                 | Notes                                      |
|-----------------|------------------------|------------------------------------------|--------------------------------------------|
| Count           | Count                  | `Cloud role instance`, `Cloud role name` | Log-based version uses **Sum** aggregation |

```Kusto
exceptions
| where isempty(client_Browser)
| summarize sum(itemCount) by bin(timestamp, 5m)
| render barchart
```

---

## Performance counters

Use metrics in the **Performance counters** category to access [system performance counters collected by Application Insights](../app/performance-counters.md).

### Available memory (performanceCounters/availableMemory)

#### [Standard metrics](#tab/standard)

| Unit of measure                      | Supported aggregations | Supported dimensions  |
|--------------------------------------|------------------------|-----------------------|
| Data dependent: Megabytes, Gigabytes | Average, Max, Min      | `Cloud role instance` |

#### [Log-based metrics](#tab/log-based)

```Kusto
performanceCounters
| where ((category == "Memory" and counter == "Available Bytes") or name == "availableMemory")
| extend performanceCounter_value = iif(itemType == "performanceCounter", value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

---

### Exception rate (performanceCounters/exceptionRate)

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions  |
|-----------------|------------------------|-----------------------|
| Count           | Average, Max, Min      | `Cloud role instance` |

#### [Log-based metrics](#tab/log-based)

```Kusto
performanceCounters
| where ((category == ".NET CLR Exceptions" and counter == "# of Exceps Thrown / sec") or name == "exceptionRate")
| extend performanceCounter_value = iif(itemType == 'performanceCounter',value,todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

---

### HTTP request execution time (performanceCounters/requestExecutionTime)

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions  |
|-----------------|------------------------|-----------------------|
| Milliseconds    | Average, Max, Min      | `Cloud role instance` |

#### [Log-based metrics](#tab/log-based)

```Kusto
performanceCounters
| where ((category == "ASP.NET Applications" and counter == "Request Execution Time") or name == "requestExecutionTime")
| extend performanceCounter_value = iif(itemType == "performanceCounter", value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

---

### HTTP request rate (performanceCounters/requestsPerSecond)

#### [Standard metrics](#tab/standard)

| Unit of measure     | Supported aggregations | Supported dimensions  |
|---------------------|------------------------|-----------------------|
| Requests per second | Average, Max, Min      | `Cloud role instance` |

#### [Log-based metrics](#tab/log-based)

```Kusto
performanceCounters
| where ((category == "ASP.NET Applications" and counter == "Requests/Sec") or name == "requestsPerSecond")
| extend performanceCounter_value = iif(itemType == "performanceCounter", value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

---

### HTTP requests in application queue (performanceCounters/requestsInQueue)

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions  |
|-----------------|------------------------|-----------------------|
| Count           | Average, Max, Min      | `Cloud role instance` |

#### [Log-based metrics](#tab/log-based)

```Kusto
performanceCounters
| where ((category == "ASP.NET Applications" and counter == "Requests In Application Queue") or name == "requestsInQueue")
| extend performanceCounter_value = iif(itemType == "performanceCounter", value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

---

### Process CPU (performanceCounters/processCpuPercentage)

The metric shows how much of the total processor capacity is consumed by the process that is hosting your monitored app.

> [!NOTE]
> The range of the metric is between 0 and 100 * n, where n is the number of available CPU cores. For example, the metric value of 200% could represent full utilization of two CPU core or half utilization of 4 CPU cores and so on. The *Process CPU Normalized* is an alternative metric collected by many SDKs which represents the same value but divides it by the number of available CPU cores. Thus, the range of *Process CPU Normalized* metric is 0 through 100.

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions  |
|-----------------|------------------------|-----------------------|
| Percentage      | Average, Max, Min      | `Cloud role instance` |

#### [Log-based metrics](#tab/log-based)

| Unit of measure | Supported aggregations | Supported dimensions  |
|-----------------|------------------------|-----------------------|
| Percentage      | Average, Min, Max      | `Cloud role instance` |

```Kusto
performanceCounters
| where ((category == "Process" and counter == "% Processor Time Normalized") or name == "processCpuPercentage")
| extend performanceCounter_value = iif(itemType == "performanceCounter", value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

---

### Process IO rate (performanceCounters/processIOBytesPerSecond)

#### [Standard metrics](#tab/standard)

| Unit of measure  | Supported aggregations | Supported dimensions  |
|------------------|------------------------|-----------------------|
| Bytes per second | Average, Min, Max      | `Cloud role instance` |

#### [Log-based metrics](#tab/log-based)

| Unit of measure  | Supported aggregations | Supported dimensions  |
|------------------|------------------------|-----------------------|
| Bytes per second | Average, Min, Max      | `Cloud role instance` |

```Kusto
performanceCounters
| where ((category == "Process" and counter == "IO Data Bytes/sec") or name == "processIOBytesPerSecond")
| extend performanceCounter_value = iif(itemType == "performanceCounter", value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

---

### Process private bytes (performanceCounters/processPrivateBytes)

Amount of nonshared memory that the monitored process allocated for its data.

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions  |
|-----------------|------------------------|-----------------------|
| Bytes           | Average, Min, Max      | `Cloud role instance` |

#### [Log-based metrics](#tab/log-based)

| Unit of measure | Supported aggregations | Supported dimensions  |
|-----------------|------------------------|-----------------------|
| Bytes           | Average, Min, Max      | `Cloud role instance` |

```Kusto
performanceCounters
| where ((category == "Process" and counter == "Private Bytes") or name == "processPrivateBytes")
| extend performanceCounter_value = iif(itemType == "performanceCounter", value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

---

### Processor time (performanceCounters/processorCpuPercentage)

CPU consumption by *all* processes running on the monitored server instance.

>[!NOTE]
> The processor time metric is not available for the applications hosted in Azure App Services. Use the  [Process CPU](#process-cpu-performancecountersprocesscpupercentage) metric to track CPU utilization of the web applications hosted in App Services.

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions  |
|-----------------|------------------------|-----------------------|
| Percentage      | Average, Min, Max      | `Cloud role instance` |

#### [Log-based metrics](#tab/log-based)

| Unit of measure | Supported aggregations | Supported dimensions  |
|-----------------|------------------------|-----------------------|
| Bytes           | Average, Min, Max      | `Cloud role instance` |

```Kusto
performanceCounters
| where ((category == "Processor" and counter == "% Processor Time") or name == "processorCpuPercentage")
| extend performanceCounter_value = iif(itemType == "performanceCounter", value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

---

## Server metrics

### Dependency calls (dependencies/count)

This metric is in relation to the number of dependency calls.

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions                                                                                                                                                           |
|-----------------|------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Count           | Count                  | `Cloud role instance`, `Cloud role name`, `Dependency performance`, `Dependency type`, `Is traffic synthetic`, `Result code`, `Successful call`, `Target of a dependency call` |

#### [Log-based metrics](#tab/log-based)

```Kusto
dependencies
| summarize sum(itemCount) by bin(timestamp, 5m)
| render barchart
```

---

### Dependency duration (dependencies/duration)

This metric refers to duration of dependency calls.

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions                                                                                                                                                           |
|-----------------|------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Milliseconds    | Average, Min, Max      | `Cloud role instance`, `Cloud role name`, `Dependency performance`, `Dependency type`, `Is traffic synthetic`, `Result code`, `Successful call`, `Target of a dependency call` |

#### [Log-based metrics](#tab/log-based)

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

---

### Server request rate (requests/rate)

This metric reflects the number of incoming server requests that were received by your web application.

#### [Standard metrics](#tab/standard)

| Unit of measure  | Supported aggregations | Supported dimensions                                                                                                       |
|------------------|------------------------|----------------------------------------------------------------------------------------------------------------------------|
| Count Per Second | Average                | `Cloud role instance`, `Cloud role name`, `Is traffic synthetic`, `Result performance` `Result code`, `Successful request` |

#### [Log-based metrics](#tab/log-based)

...

---

### Server requests (requests/count)

This metric reflects the number of incoming server requests that were received by your web application.

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions                                                                                                       |
|-----------------|------------------------|----------------------------------------------------------------------------------------------------------------------------|
| Count           | Count                  | `Cloud role instance`, `Cloud role name`, `Is traffic synthetic`, `Result performance` `Result code`, `Successful request` |

#### [Log-based metrics](#tab/log-based)

```Kusto
requests
| summarize sum(itemCount) by bin(timestamp, 5m)
| render barchart
```

---

### Server response time (requests/duration)

This metric reflects the time it took for the servers to process incoming requests.

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions                                                                                                       |
|-----------------|------------------------|----------------------------------------------------------------------------------------------------------------------------|
| MilliSeconds    | Average, Min, Max      | `Cloud role instance`, `Cloud role name`, `Is traffic synthetic`, `Result performance` `Result code`, `Successful request` |

#### [Log-based metrics](#tab/log-based)

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

---

## Usage metrics

### Page view load time (pageViews/duration)

This metric refers to the amount of time it took for PageView events to load.

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions                      |
|-----------------|------------------------|-------------------------------------------|
| MilliSeconds    | Average, Min, Max      | `Cloud role name`, `Is traffic synthetic` |

#### [Log-based metrics](#tab/log-based)

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

---

### Page views (pageViews/count)

The count of PageView events logged with the TrackPageView() Application Insights API.

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions                      |
|-----------------|------------------------|-------------------------------------------|
| Count           | Count                  | `Cloud role name`, `Is traffic synthetic` |

#### [Log-based metrics](#tab/log-based)

```Kusto
pageViews
| summarize sum(itemCount) by bin(timestamp, 1h)
| render barchart
```

---

### Sessions (sessions/count)

This metric refers to the count of distinct session IDs.

#### [Standard metrics](#tab/standard)

...

#### [Log-based metrics](#tab/log-based)

```Kusto
union traces, requests, pageViews, dependencies, customEvents, availabilityResults, exceptions, customMetrics, browserTimings
| where notempty(session_Id)
| summarize dcount(session_Id) by bin(timestamp, 1h)
| render barchart
```

---

### Traces (traces/count)

The count of trace statements logged with the TrackTrace() Application Insights API call.

#### [Standard metrics](#tab/standard)

| Unit of measure | Supported aggregations | Supported dimensions                                                                |
|-----------------|------------------------|-------------------------------------------------------------------------------------|
| Count           | Count                  | `Cloud role instance`, `Cloud role name`,  `Is traffic synthetic`, `Severity level` |

#### [Log-based metrics](#tab/log-based)

```Kusto
traces
| summarize sum(itemCount) by bin(timestamp, 1h)
| render barchart
```

---

### Users (users/count)

The number of distinct users who accessed your application. The accuracy of this metric may be  significantly impacted by using telemetry sampling and filtering.

#### [Standard metrics](#tab/standard)

...

#### [Log-based metrics](#tab/log-based)

```Kusto
union traces, requests, pageViews, dependencies, customEvents, availabilityResults, exceptions, customMetrics, browserTimings
| where notempty(user_Id)
| summarize dcount(user_Id) by bin(timestamp, 1h)
| render barchart
```

---

### Users, Authenticated (users/authenticated)

The number of distinct users who authenticated into your application.

#### [Standard metrics](#tab/standard)

...

#### [Log-based metrics](#tab/log-based)

```Kusto
union traces, requests, pageViews, dependencies, customEvents, availabilityResults, exceptions, customMetrics, browserTimings
| where notempty(user_AuthenticatedId)
| summarize dcount(user_AuthenticatedId) by bin(timestamp, 1h)
| render barchart
```

---

## Access all your data directly with the Application Insights REST API

#### [Standard metrics](#tab/standard)

...

#### [Log-based metrics](#tab/log-based)

The Application Insights REST API enables programmatic retrieval of log-based metrics. It also features an optional parameter “ai.include-query-payload” that when added to a query string, prompts the API to return not only the time series data, but also the Kusto Query Language (KQL) statement used to fetch it. This parameter can be particularly beneficial for users aiming to comprehend the connection between raw events in Log Analytics and the resulting log-based metric.

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

---

## Next steps

* [Metrics - Get - REST API](/rest/api/application-insights/metrics/get)
* [Application Insights API for custom events and metrics](api-custom-events-metrics.md)
* [Near real time alerting](../alerts/alerts-metric-near-real-time.md)
* [GetMetric and TrackValue](./api-custom-events-metrics.md#getmetric)
