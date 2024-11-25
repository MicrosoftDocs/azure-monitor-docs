---
title: Metrics in Application Insights - Azure Monitor | Microsoft Docs
description: This article explains the difference between log-based and standard/preaggregated metrics in Application Insights.
ms.topic: conceptual
ms.date: 09/06/2024
ms.reviewer: vitalyg
---

# Metrics in Application Insights

Application Insights supports three different types of metrics: standard (preaggregated), log-based, and custom metrics. Each one brings a unique value in monitoring application health, diagnostics, and analytics. Developers who are instrumenting applications can decide which type of metric is best suited to a particular scenario. Decisions are based on the size of the application, expected volume of telemetry, and business requirements for metrics precision and alerting. This article explains the difference between all supported metrics types.

#### Standard metrics

Standard metrics in Application Insights are predefined metrics which are automatically collected and monitored by the service. These metrics cover a wide range of performance and usage indicators, such as CPU usage, memory consumption, request rates, and response times. Standard metrics provide a comprehensive overview of your application's health and performance without requiring any additional configuration. Standard metrics **are preaggregated** during collection and stored as a time series in a specialized repository with only key dimensions, which gives them better performance at query time. This makes them the best choice for [near real time alerting on dimensions of metrics](../alerts/alerts-metric-near-real-time.md) and more responsive [dashboards](./overview-dashboard.md).

#### Log-based metrics

Log-based metrics in Application Insights are a query-time concept, represented as a time series on top of the log data of your application. The underlying logs **aren't preaggregated** at the collection or storage time and retain all properties of each log entry. This makes it possible to use log properties as dimensions on log-based metrics at query time for [metric chart filtering](../essentials/analyze-metrics.md#add-filters) and [metric splitting](../essentials/analyze-metrics.md#apply-metric-splitting), giving log-based metrics superior analytical and diagnostic value. However, telemetry volume reduction techniques such as [sampling](sampling-classic-api.md) and [telemetry filtering](api-filtering-sampling.md#filtering), commonly used with monitoring applications generating large volumes of telemetry, impacts the quantity of the collected log entries and therefore reduce the accuracy of log-based metrics.

#### Custom metrics (preview)

Custom metrics in Application Insights allow you to define and track specific measurements that are unique to your application. These metrics can be created by instrumenting your code to send custom telemetry data to Application Insights. Custom metrics provide the flexibility to monitor any aspect of your application that isn't covered by standard metrics, enabling you to gain deeper insights into your application's behavior and performance.

For more information, see [Custom metrics in Azure Monitor (preview)](../essentials/metrics-custom-overview.md).

> [!NOTE]
> Application Insights also provides a feature called [Live Metrics stream](./live-stream.md), which allows for near real-time monitoring of your web applications and doesn't store any telemetry data.

## Metrics comparison

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

## Metrics preaggregation

OpenTelemetry SDKs and newer Application Insights SDKs (Classic API) preaggregate metrics during collection. This process applies to standard metrics sent by default, so the accuracy isn't affected by sampling or filtering. It also applies to custom metrics sent by using the [OpenTelemetry API](./opentelemetry-add-modify.md#add-custom-metrics) or [GetMetric](./api-custom-events-metrics.md#getmetric), which results in less data ingestion and lower cost.

For SDKs that don't implement preaggregation (that is, older versions of Application Insights SDKs or for browser instrumentation), the Application Insights back end still populates the new metrics by aggregating the events received by the Application Insights event collection endpoint. Although you don't benefit from the reduced volume of data transmitted over the wire, you can still use the preaggregated metrics and experience better performance and support of the near real time dimensional alerting with SDKs that don't preaggregate metrics during collection.

The collection endpoint preaggregates events before ingestion sampling. For this reason, ingestion sampling never affects the accuracy of preaggregated metrics, regardless of the SDK version you use with your application.

The following tables list where preaggregation are preaggregated.

### Metrics preaggregation with Azure Monitor OpenTelemetry Distro
<!--
| Current production SDK | Standard metrics (with SDK preaggregation) | Custom metrics (without SDK preaggregation) | Custom metrics (with SDK preaggregation) |
|---------------------------|----------------------------------|-----------------------------------------|--------------------------------------|
| ASP.NET Core | ✅ | ❌ | ✅ via [OpenTelemetry API](/azure/azure-monitor/app/opentelemetry-add-modify?tabs=aspnetcore#add-custom-metrics) |
| .NET (via Exporter) | ✅ | ❌ | ✅ via [OpenTelemetry API](/azure/azure-monitor/app/opentelemetry-add-modify?tabs=net#add-custom-metrics) |
| Java (3.x.x) | ✅ | ❌ | ✅ via [OpenTelemetry API](/azure/azure-monitor/app/opentelemetry-add-modify?tabs=java#add-custom-metrics) |
| Java native | ✅ | ❌ | ✅ via [OpenTelemetry API](/azure/azure-monitor/app/opentelemetry-add-modify?tabs=java-native#add-custom-metrics) |
| Node.js | ✅ | ❌ | ✅ via [OpenTelemetry API](/azure/azure-monitor/app/opentelemetry-add-modify?tabs=nodejs#add-custom-metrics) |
| Python | ✅ | ❌ | ✅ via [OpenTelemetry API](/azure/azure-monitor/app/opentelemetry-add-modify?tabs=python#add-custom-metrics) |
-->
| Current production SDK | Standard metrics preaggregation | Custom metrics preaggregation |
|------------------------|---------------------------------|-------------------------------|
| ASP.NET Core | SDK | SDK via [OpenTelemetry API](/azure/azure-monitor/app/opentelemetry-add-modify?tabs=aspnetcore#add-custom-metrics) |
| .NET (via Exporter) | SDK | SDK via [OpenTelemetry API](/azure/azure-monitor/app/opentelemetry-add-modify?tabs=net#add-custom-metrics) |
| Java (3.x) | SDK | SDK via [OpenTelemetry API](/azure/azure-monitor/app/opentelemetry-add-modify?tabs=java#add-custom-metrics) |
| Java native | SDK | SDK via [OpenTelemetry API](/azure/azure-monitor/app/opentelemetry-add-modify?tabs=java-native#add-custom-metrics) |
| Node.js | SDK | SDK via [OpenTelemetry API](/azure/azure-monitor/app/opentelemetry-add-modify?tabs=nodejs#add-custom-metrics) |
| Python | SDK | SDK via [OpenTelemetry API](/azure/azure-monitor/app/opentelemetry-add-modify?tabs=python#add-custom-metrics) |

### Metrics preaggregation with Application Insights SDK (Classic API)
<!--
| Current production SDK | Standard metrics (with SDK preaggregation) | Custom metrics (without SDK preaggregation) | Custom metrics (with SDK preaggregation) |
|-------------------------|----------------------------------|---------------------------------------------|------------------------------------------|
| .NET Core and .NET Framework | ✅ (V2.13.1+) | ✅ via [TrackMetric](api-custom-events-metrics.md#trackmetric) | ✅ (V2.7.2+) via [GetMetric](get-metric.md) |
| Java (2.x.x) | ❌ | ✅ via [TrackMetric](api-custom-events-metrics.md#trackmetric) | ❌ |
| JavaScript (Browser) | ❌ <sup>3<sup> | ✅ via [TrackMetric](api-custom-events-metrics.md#trackmetric) | ❌ |
| Node.js | ❌ | ✅ via [TrackMetric](api-custom-events-metrics.md#trackmetric) | ❌ |
| Python | ❌ | ✔️ | ✔️ via [OpenCensus.stats (retired)](/previous-versions/azure/azure-monitor/app/opencensus-python#metrics) |
-->
| Current production SDK | Standard metrics preaggregation | Custom metrics preaggregation |
|------------------------|---------------------------------|-------------------------------|
| .NET Core and .NET Framework | SDK (V2.13.1+) | SDK (V2.7.2+) via [GetMetric](get-metric.md)<br>Endpoint via [TrackMetric](api-custom-events-metrics.md#trackmetric) |
| Java (2.x) <sup>1<sup> | Endpoint | Endpoint via [TrackMetric](api-custom-events-metrics.md#trackmetric) |
| JavaScript (Web) | Endpoint | Endpoint via [TrackMetric](api-custom-events-metrics.md#trackmetric) |
| Node.js | Endpoint | Endpoint via [TrackMetric](api-custom-events-metrics.md#trackmetric) |
| Python <sup>2<sup> | Endpoint | SDK via [OpenCensus.stats (retired)](/previous-versions/azure/azure-monitor/app/opencensus-python#metrics)<br>Endpoint via [TrackMetric](api-custom-events-metrics.md#trackmetric) |

**Footnotes**

* <sup>1</sup> The Application Insights Java 2.X SDK is no longer recommended. Use the [OpenTelemetry-based Java offering](./opentelemetry-enable.md?tabs=java) instead.
* <sup>2</sup> The [OpenCensus Python SDK is retired](https://opentelemetry.io/blog/2023/sunsetting-opencensus/). We recommend the [OpenTelemetry-based Python offering](./opentelemetry-enable.md?tabs=python) and provide [migration guidance](./opentelemetry-python-opencensus-migrate.md?tabs=python).

> [!CAUTION]
> The [OpenCensus Python SDK is retired](https://opentelemetry.io/blog/2023/sunsetting-opencensus/). We recommend the [OpenTelemetry-based Python offering](./opentelemetry-enable.md?tabs=python) and provide [migration guidance](./opentelemetry-python-opencensus-migrate.md?tabs=python).

### Metrics preaggregation with autoinstrumentation
<!--
| Current production SDK | Standard metrics (with SDK preaggregation) | Custom metrics (without SDK preaggregation) | Custom metrics (with SDK preaggregation) |
|-------------------------|----------------------------------|-----------------------------------------|--------------------------------------|
| ASP.NET Core | ✅ <sup>1<sup> | ❌ | ❌ |
| ASP.NET | ✅ <sup>2<sup> | ❌ | ❌ |
| Java | ✅ | ❌ | ✅ via [OpenTelemetry API](/azure/azure-monitor/app/opentelemetry-add-modify?tabs=java#add-custom-metrics) |
| JavaScript (Browser) | ❌ <sup>3<sup> | ❌ | ❌ |
| Node.js | ✅ | ❌ | ❌ |
| Python | ✅ | ❌ | ❌ |
-->
| Current production SDK | Standard metrics preaggregation | Custom metrics preaggregation |
|------------------------|---------------------------------|-------------------------------|
| ASP.NET Core | SDK <sup>1<sup> | Not supported |
| ASP.NET | SDK <sup>2<sup> | Not supported |
| Java | SDK | SDK via [OpenTelemetry API](/azure/azure-monitor/app/opentelemetry-add-modify?tabs=java#add-custom-metrics) |
| Node.js | SDK | Not supported |
| Python | SDK | Not supported |

**Footnotes**

* <sup>1</sup> [ASP.NET Core autoinstrumentation on App Service](./azure-web-apps-net-core.md) emits standard metrics without dimensions. Manual instrumentation is required for all dimensions.<br>
* <sup>2</sup> [ASP.NET autoinstrumentation on virtual machines/virtual machine scale sets](./azure-vm-vmss-apps.md) and [on-premises](./application-insights-asp-net-agent.md) emits standard metrics without dimensions. The same is true for Azure App Service, but the collection level must be set to recommended. Manual instrumentation is required for all dimensions.

Standard metrics are supported with autoinstrumentation. However, custom metrics require user code and therefore manual instrumentation via the Application Insights SDK (Classic API) or the Azure Monitor OpenTelemetry Distro.

> [!NOTE]
> [ASP.NET Core autoinstrumentation on App Service](./azure-web-apps-net-core.md) emits standard metrics without dimensions. SDK is required for all dimensions.<br>
>
> [ASP.NET autoinstrumentation on virtual machines/virtual machine scale sets](./azure-vm-vmss-apps.md) and [on-premises](./application-insights-asp-net-agent.md) emits standard metrics without dimensions. The same is true for Azure App Service, but the collection level must be set to recommended. The SDK is required for all dimensions.

## Preaggregation with Application Insights custom metrics

You can use preaggregation with custom metrics to reduce the volume of data sent from the SDK to the Application Insights collection endpoint.

There are several [ways of sending custom metrics from the Application Insights SDK](./api-custom-events-metrics.md). If your version of the SDK offers [GetMetric and TrackValue](./api-custom-events-metrics.md#getmetric), these methods are the preferred way of sending custom metrics. In this case, preaggregation happens inside the SDK. This approach reduces the volume of data stored in Azure and also the volume of data transmitted from the SDK to Application Insights. Otherwise, use the [trackMetric](./api-custom-events-metrics.md#trackmetric) method, which preaggregates metric events during data ingestion.

### Custom metrics dimensions and preaggregation

All metrics that you send using [OpenTelemetry](./../app/opentelemetry-add-modify.md), [trackMetric](./../app/api-custom-events-metrics.md), or [GetMetric and TrackValue](./../app/api-custom-events-metrics.md#getmetric) API calls are automatically stored in both logs and metrics stores. These metrics can be found in the customMetrics table in Application Insights and in Metrics Explorer under the Custom Metric Namespace called "azure.applicationinsights". Although the log-based version of your custom metric always retains all dimensions, the preaggregated version of the metric is stored by default with no dimensions. Retaining dimensions of custom metrics is a Preview feature that can be turned on from the [Usage and estimated cost](./../cost-usage.md#usage-and-estimated-costs) tab by selecting **With dimensions** under **Send custom metrics to Azure Metric Store**.

:::image type="content" source="./media/metrics-overview/usage-and-costs.png" lightbox="./media/metrics-overview/usage-and-costs.png" alt-text="Screenshot that shows usage and estimated costs.":::

### Quotas

Preaggregated metrics are stored as time series in Azure Monitor. [Azure Monitor quotas on custom metrics](../essentials/metrics-custom-overview.md#quotas-and-limits) apply.

> [!NOTE]
> Going over the quota might have unintended consequences. Azure Monitor might become unreliable in your subscription or region. To learn how to avoid exceeding the quota, see [Design limitations and considerations](../essentials/metrics-custom-overview.md#design-limitations-and-considerations).

### Why is collection of custom metrics dimensions turned off by default?

The collection of custom metrics dimensions is turned off by default because in the future, storing custom metrics with dimensions will be billed separately from Application Insights. Storing the nondimensional custom metrics remain free (up to a quota). You can learn about the upcoming pricing model changes on our official [pricing page](https://azure.microsoft.com/pricing/details/monitor/).

## Create charts and explore metrics

Use [Azure Monitor metrics explorer](../essentials/metrics-getting-started.md) to plot charts from preaggregated, log-based, and custom metrics, and to author dashboards with charts. After you select the Application Insights resource you want, use the namespace picker to switch between metrics.

:::image type="content" source="./media/metrics-overview/metric-namespace.png" lightbox="./media/metrics-overview/metric-namespace.png" alt-text="Screenshot that shows Metric namespace.":::

## Pricing models for Application Insights metrics

Ingesting metrics into Application Insights, whether log-based or preaggregated, generates costs based on the size of the ingested data. For more information, see [Azure Monitor Logs pricing details](../logs/cost-logs.md#application-insights-billing). Your custom metrics, including all its dimensions, are always stored in the Application Insights log store. Also, a preaggregated version of your custom metrics with no dimensions is forwarded to the metrics store by default.

Selecting the [Enable alerting on custom metric dimensions](#custom-metrics-dimensions-and-preaggregation) option to store all dimensions of the preaggregated metrics in the metric store can generate *extra costs* based on [custom metrics pricing](https://azure.microsoft.com/pricing/details/monitor/).

## Available metrics

### [Standard](#tab/standard)

The following sections list metrics with supported aggregations and dimensions. The details about log-based metrics include the underlying Kusto query statements.

### [Log-based](#tab/log-based)

The following sections list metrics with supported aggregations and dimensions. The details about log-based metrics include the underlying Kusto query statements. For convenience, each query uses defaults for time granularity, chart type, and sometimes splitting dimension which simplifies using the query in Log Analytics without any need for modification.

When you plot the same metric in [metrics explorer](./../essentials/analyze-metrics.md), there are no defaults - the query is dynamically adjusted based on your chart settings:

* The selected **Time range** is translated into an additional `where timestamp...` clause to only pick the events from selected time range. For example, a chart showing data for the most recent 24 hours, the query includes `| where timestamp > ago(24 h)`.

* The selected **Time granularity** is put into the final `summarize ... by bin(timestamp, [time grain])` clause.

* Any selected **Filter** dimensions are translated into additional `where` clauses.

* The selected **Split chart** dimension is translated into an extra summarize property. For example, if you split your chart by `location`, and plot using a 5-minute time granularity, the `summarize` clause is summarized `... by bin(timestamp, 5 m), location`.

> [!NOTE]
> If you're new to the Kusto query language, you start by copying and pasting Kusto statements into the Log Analytics query pane without making any modifications. Click **Run** to see basic chart. As you begin to understand the syntax of query language, you can start making small modifications and see the impact of your change. Exploring your own data is a great way to start realizing the full power of [Log Analytics](../logs/log-analytics-tutorial.md) and [Azure Monitor](../overview.md).

---

### Availability metrics

Metrics in the Availability category enable you to see the health of your web application as observed from points around the world. [Configure the availability tests](../app/availability-overview.md) to start using any metrics from this category.

### [Standard](#tab/standard)

#### Availability (availabilityResults/availabilityPercentage)

The *Availability* metric shows the percentage of the web test runs that didn't detect any issues. The lowest possible value is 0, which indicates that all of the web test runs have failed. The value of 100 means that all of the web test runs passed the validation criteria.

| Unit of measure | Supported aggregations | Supported dimensions        |
|-----------------|------------------------|-----------------------------|
| Percentage      | Avg                    | `Run location`, `Test name` |

#### Availability test duration (availabilityResults/duration)

The *Availability test duration* metric shows how much time it took for the web test to run. For the [multi-step web tests](/previous-versions/azure/azure-monitor/app/availability-multistep), the metric reflects the total execution time of all steps.

| Unit of measure | Supported aggregations | Supported dimensions                       |
|-----------------|------------------------|--------------------------------------------|
| Milliseconds    | Avg, Max, Min          | `Run location`, `Test name`, `Test result` |

#### Availability tests (availabilityResults/count)

The *Availability tests* metric reflects the count of the web tests runs by Azure Monitor.

| Unit of measure | Supported aggregations | Supported dimensions                       |
|-----------------|------------------------|--------------------------------------------|
| Count           | Count                  | `Run location`, `Test name`, `Test result` |

### [Log-based](#tab/log-based)

#### Availability (availabilityResults/availabilityPercentage)

The *Availability* metric shows the percentage of the web test runs that didn't detect any issues. The lowest possible value is 0, which indicates that all of the web test runs have failed. The value of 100 means that all of the web test runs passed the validation criteria.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Percentage      | Avg                    | All telemetry fields |

```Kusto
availabilityResults 
| summarize sum(todouble(success == 1) * 100) / count() by bin(timestamp, 5m), location
| render timechart
```

```
availabilityResults
| where timestamp >= datetime(2024-11-21T16:55:39.185Z) and timestamp < datetime(2024-11-22T16:55:39.185Z)
| summarize ['availabilityResults/availabilityPercentage_avg'] = sum(todouble(success == 1) * 100) / count() by bin(timestamp, 5m)
| order by timestamp desc
```

#### Availability test results count (availabilityResults/count)

The *Availability tests* metric reflects the count of the web tests runs by Azure Monitor.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```Kusto
availabilityResults
| summarize sum(itemCount) by bin(timestamp, 5m)
| render timechart
```

```Kusto
availabilityResults
| where timestamp >= datetime(2024-11-21T16:55:06.319Z) and timestamp < datetime(2024-11-22T16:55:06.319Z)
| summarize ['availabilityResults/count_sum'] = sum(itemCount) by bin(timestamp, 5m)
| order by timestamp desc
```

#### Test duration (availabilityResults/duration)

The *Availability test duration* metric shows how much time it took for the web test to run. For the [multi-step web tests](/previous-versions/azure/azure-monitor/app/availability-multistep), the metric reflects the total execution time of all steps.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Avg, Min, Max          | All telemetry fields |

```Kusto
availabilityResults
| where notempty(duration)
| extend availabilityResult_duration = iif(itemType == 'availabilityResult', duration, todouble(''))
| summarize sum(availabilityResult_duration)/sum(itemCount) by bin(timestamp, 5m), location
| render timechart
```

```Kusto
availabilityResults
| where timestamp >= datetime(2024-11-21T16:53:50.902Z) and timestamp < datetime(2024-11-22T16:53:50.902Z)
| where notempty(duration)
| extend availabilityResult_duration = iif(itemType == 'availabilityResult', duration, todouble(''))
| summarize ['availabilityResults/duration_avg'] = sum(availabilityResult_duration) / sum(itemCount) by bin(timestamp, 5m)
| order by timestamp desc
```

---

### Browser metrics

Browser metrics are collected by the Application Insights JavaScript SDK from real end-user browsers. They provide great insights into your users' experience with your web app. Browser metrics are typically not sampled, which means that they provide higher precision of the usage numbers compared to server-side metrics which might be skewed by sampling.

> [!NOTE]
> To collect browser metrics, your application must be instrumented with the [Application Insights JavaScript SDK](../app/javascript.md).

### [Standard](#tab/standard)

#### Browser page load time (browserTimings/totalDuration)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Avg, Max, Min          | None                 |

#### Client processing time (browserTiming/processingDuration)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Avg, Max, Min          | None                 |

#### Page load network connect time (browserTimings/networkDuration)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Avg, Max, Min          | None                 |

#### Receiving response time (browserTimings/receiveDuration)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Avg, Max, Min          | None                 |

#### Send request time (browserTimings/sendDuration)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Avg, Max, Min          | None                 |

### [Log-based](#tab/log-based)

#### Browser page load time (browserTimings/totalDuration)

Time from user request until DOM, stylesheets, scripts, and images are loaded.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Avg, Min, Max          | All telemetry fields |

```Kusto
browserTimings
| where notempty(totalDuration)
| extend _sum = totalDuration
| extend _count = itemCount
| extend _sum = _sum * _count
| summarize sum(_sum) / sum(_count) by bin(timestamp, 5m)
| render timechart
```

```Kusto
| order by timestamp desc
```

#### Client processing time (browserTiming/processingDuration)

Time between receiving the last byte of a document until the DOM is loaded. Async requests may still be processing.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Avg, Min, Max          | All telemetry fields |

```Kusto
browserTimings
| where notempty(processingDuration)
| extend _sum = processingDuration
| extend _count = itemCount
| extend _sum = _sum * _count
| summarize sum(_sum)/sum(_count) by bin(timestamp, 5m)
| render timechart
```

#### Page load network connect time (browserTimings/networkDuration)

Time between user request and network connection. Includes DNS lookup and transport connection.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Avg, Min, Max          | All telemetry fields |

```Kusto
browserTimings
| where notempty(networkDuration)
| extend _sum = networkDuration
| extend _count = itemCount
| extend _sum = _sum * _count
| summarize sum(_sum) / sum(_count) by bin(timestamp, 5m)
| render timechart
```

#### Receiving response time (browserTimings/receiveDuration)

Time between the first and last bytes, or until disconnection.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Avg, Min, Max          | All telemetry fields |

```Kusto
browserTimings
| where notempty(receiveDuration)
| extend _sum = receiveDuration
| extend _count = itemCount
| extend _sum = _sum * _count
| summarize sum(_sum) / sum(_count) by bin(timestamp, 5m)
| render timechart
```

#### Send request time (browserTimings/sendDuration)

Time between network connection and receiving the first byte.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Avg, Min, Max          | All telemetry fields |

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

### Failure metrics

The metrics in **Failures** show problems with processing requests, dependency calls, and thrown exceptions.

### [Standard](#tab/standard)

#### Browser exceptions (exceptions/browser)

This metric reflects the number of thrown exceptions from your application code running in browser. Only exceptions that are tracked with a `trackException()` Application Insights API call are included in the metric.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Count                  | `Cloud role name`    |

#### Dependency call failures (dependencies/failed)

The number of failed dependency calls.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count | Count | `Cloud role instance`, `Cloud role name`, `Dependency performance`, `Dependency type`, `Is traffic synthetic`, `Result code`, `Target of dependency call` |

#### Exceptions (exceptions/count)

Each time when you log an exception to Application Insights, there's a call to the [trackException() method](../app/api-custom-events-metrics.md#trackexception) of the SDK. The Exceptions metric shows the number of logged exceptions.

| Unit of measure | Supported aggregations | Supported dimensions                                    |
|-----------------|------------------------|---------------------------------------------------------|
| Count           | Count                  | `Cloud role instance`, `Cloud role name`, `Device type` |

#### Failed requests (requests/failed)

The count of tracked server requests that were marked as *failed*. By default, the Application Insights SDK automatically marks each server request that returned HTTP response code 5xx or 4xx as a failed request. You can customize this logic by modifying *success* property of request telemetry item in a [custom telemetry initializer](../app/api-filtering-sampling.md#addmodify-properties-itelemetryinitializer).

| Unit of measure | Supported aggregations | Supported dimensions                                                                                   |
|-----------------|------------------------|--------------------------------------------------------------------------------------------------------|
| Count           | Count                  | `Cloud role instance`, `Cloud role name`, `Is synthetic traffic`, `Request performance`, `Result code` |

#### Server exceptions (exceptions/server)

This metric shows the number of server exceptions.

| Unit of measure | Supported aggregations | Supported dimensions                     |
|-----------------|------------------------|------------------------------------------|
| Count           | Count                  | `Cloud role instance`, `Cloud role name` |

### [Log-based](#tab/log-based)

#### Browser exceptions (exceptions/browser)

This metric reflects the number of thrown exceptions from your application code running in browser. Only exceptions that are tracked with a `trackException()` Application Insights API call are included in the metric.

> [!NOTE]
> When using sampling, the itemCount indicates how many telemetry items a single log record represents. For example, with 25% sampling, each log record kept represents 4 items (1 kept + 3 sampled out). Log-based queries sum up all itemCount values to ensure the metric reflects the total number of actual events, not just the number of stored log records.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```Kusto
exceptions
| where notempty(client_Browser)
| summarize sum(itemCount) by bin(timestamp, 5m)
| render barchart
```

<!--
```Kusto
| where client_Type == 'Browser'
```
-->

#### Dependency call failures (dependencies/failed)

The number of failed dependency calls.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```Kusto
dependencies
| where success == 'False'
| summarize sum(itemCount) by bin(timestamp, 5m)
| render barchart
```

#### Exceptions (exceptions/count)

Each time when you log an exception to Application Insights, there's a call to the [trackException() method](../app/api-custom-events-metrics.md#trackexception) of the SDK. The Exceptions metric shows the number of logged exceptions.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```Kusto
exceptions
| summarize sum(itemCount) by bin(timestamp, 5m)
| render barchart
```

#### Failed requests (requests/failed)

The count of tracked server requests that were marked as *failed*. By default, the Application Insights SDK automatically marks each server request that returned HTTP response code 5xx or 4xx as a failed request. You can customize this logic by modifying *success* property of request telemetry item in a [custom telemetry initializer](../app/api-filtering-sampling.md#addmodify-properties-itelemetryinitializer).

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```Kusto
requests
| where success == 'False'
| summarize sum(itemCount) by bin(timestamp, 5m)
| render barchart
```

#### Server exceptions (exceptions/server)

This metric shows the number of server exceptions.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```Kusto
exceptions
| where isempty(client_Browser)
| summarize sum(itemCount) by bin(timestamp, 5m)
| render barchart
```

<!--
```Kusto
| where client_Type != 'Browser'
```
-->

---

### Performance counters

Use metrics in the **Performance counters** category to access [system performance counters collected by Application Insights](../app/performance-counters.md).

### [Standard](#tab/standard)

#### Available memory (performanceCounters/availableMemory)

| Unit of measure                        | Supported aggregations | Supported dimensions  |
|----------------------------------------|------------------------|-----------------------|
| Megabytes / Gigabytes (data dependent) | Avg, Max, Min          | `Cloud role instance` |

#### Exception rate (performanceCounters/exceptionRate)

| Unit of measure | Supported aggregations | Supported dimensions  |
|-----------------|------------------------|-----------------------|
| Count           | Avg, Max, Min          | `Cloud role instance` |

#### HTTP request execution time (performanceCounters/requestExecutionTime)

| Unit of measure | Supported aggregations | Supported dimensions  |
|-----------------|------------------------|-----------------------|
| Milliseconds    | Avg, Max, Min          | `Cloud role instance` |

#### HTTP request rate (performanceCounters/requestsPerSecond)

| Unit of measure     | Supported aggregations | Supported dimensions  |
|---------------------|------------------------|-----------------------|
| Requests per second | Avg, Max, Min          | `Cloud role instance` |

#### HTTP requests in application queue (performanceCounters/requestsInQueue)

| Unit of measure | Supported aggregations | Supported dimensions  |
|-----------------|------------------------|-----------------------|
| Count           | Avg, Max, Min          | `Cloud role instance` |

#### Process CPU (performanceCounters/processCpuPercentage)

The metric shows how much of the total processor capacity is consumed by the process that is hosting your monitored app.

| Unit of measure | Supported aggregations | Supported dimensions  |
|-----------------|------------------------|-----------------------|
| Percentage      | Avg, Max, Min          | `Cloud role instance` |

> [!NOTE]
> The range of the metric is between 0 and 100 * n, where n is the number of available CPU cores. For example, the metric value of 200% could represent full utilization of two CPU core or half utilization of 4 CPU cores and so on. The *Process CPU Normalized* is an alternative metric collected by many SDKs which represents the same value but divides it by the number of available CPU cores. Thus, the range of *Process CPU Normalized* metric is 0 through 100.

#### Process IO rate (performanceCounters/processIOBytesPerSecond)

| Unit of measure  | Supported aggregations | Supported dimensions  |
|------------------|------------------------|-----------------------|
| Bytes per second | Average, Min, Max      | `Cloud role instance` |

#### Process private bytes (performanceCounters/processPrivateBytes)

Amount of nonshared memory that the monitored process allocated for its data.

| Unit of measure | Supported aggregations | Supported dimensions  |
|-----------------|------------------------|-----------------------|
| Bytes           | Average, Min, Max      | `Cloud role instance` |

#### Processor time (performanceCounters/processorCpuPercentage)

CPU consumption by *all* processes running on the monitored server instance.

| Unit of measure | Supported aggregations | Supported dimensions  |
|-----------------|------------------------|-----------------------|
| Percentage      | Average, Min, Max      | `Cloud role instance` |

>[!NOTE]
> The processor time metric is not available for the applications hosted in Azure App Services. Use the  [Process CPU](#process-cpu-performancecountersprocesscpupercentage) metric to track CPU utilization of the web applications hosted in App Services.

### [Log-based](#tab/log-based)

#### ASP.NET request exection time (performanceCounters/requestExecutionTime)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Avg, Min, Max          | All telemetry fields |

```Kusto
performanceCounters
| where ((category == "ASP.NET Applications" and counter == "Request Execution Time") or name == "requestExecutionTime")
| extend performanceCounter_value = iif(itemType == 'performanceCounter', value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 15m)
| render timechart
```

#### ASP.NET request rate (performanceCounters/requestsPerSecond)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Avg, Min, Max          | All telemetry fields |

```Kusto
performanceCounters
| where ((category == "ASP.NET Applications" and counter == "Requests/Sec") or name == "requestsPerSecond")
| extend performanceCounter_value = iif(itemType == 'performanceCounter', value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 15m)
| render barchart
```

#### ASP.NET request in application queue (performanceCounters/requestsInQueue)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Avg, Min, Max          | All telemetry fields |

```Kusto
performanceCounters
| where ((category == "ASP.NET Applications" and counter == "Requests In Application Queue") or name == "requestsInQueue")
| extend performanceCounter_value = iif(itemType == 'performanceCounter', value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 15m)
| render barchart
```

#### Available memory (performanceCounters/availableMemory)

| Unit of measure                        | Supported aggregations | Supported dimensions |
|----------------------------------------|------------------------|----------------------|
| Megabytes / Gigabytes (data dependent) | Avg, Min, Max          | All telemetry fields |

```Kusto
performanceCounters
| where ((category == "Memory" and counter == "Available Bytes") or name == "availableMemory")
| extend performanceCounter_value = iif(itemType == "performanceCounter", value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

<!--
```Kusto
| where ((category == "Memory" and counter == "Available Bytes") or name == "memoryAvailableBytes")
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 5m)
```
-->

#### Exception rate (performanceCounters/exceptionRate)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Avg, Min, Max          | All telemetry fields |

```Kusto
performanceCounters
| where ((category == ".NET CLR Exceptions" and counter == "# of Exceps Thrown / sec") or name == "exceptionRate")
| extend performanceCounter_value = iif(itemType == 'performanceCounter',value,todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

<!--
```Kusto
| where ((category == ".NET CLR Exceptions" and counter == "# of Exceps Thrown / sec") or name == "exceptionsPerSecond")
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 5m)
```
-->

#### HTTP request execution time (performanceCounters/requestExecutionTime)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Avg, Min, Max          | All telemetry fields |

```Kusto
performanceCounters
| where ((category == "ASP.NET Applications" and counter == "Request Execution Time") or name == "requestExecutionTime")
| extend performanceCounter_value = iif(itemType == "performanceCounter", value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

<!--
```Kusto

```
-->

#### HTTP request rate (performanceCounters/requestsPerSecond)

| Unit of measure     | Supported aggregations | Supported dimensions |
|---------------------|------------------------|----------------------|
| Requests per second | Avg, Min, Max          | All telemetry fields |

```Kusto
performanceCounters
| where ((category == "ASP.NET Applications" and counter == "Requests/Sec") or name == "requestsPerSecond")
| extend performanceCounter_value = iif(itemType == "performanceCounter", value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

<!--
```Kusto

```
-->

#### HTTP requests in application queue (performanceCounters/requestsInQueue)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Avg, Min, Max          | All telemetry fields |

```Kusto
performanceCounters
| where ((category == "ASP.NET Applications" and counter == "Requests In Application Queue") or name == "requestsInQueue")
| extend performanceCounter_value = iif(itemType == "performanceCounter", value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

<!--
```Kusto

```
-->

#### Process CPU (performanceCounters/processCpuPercentage)

The metric shows how much of the total processor capacity is consumed by the process that is hosting your monitored app.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Percentage      | Avg, Min, Max          | All telemetry fields |

```Kusto
performanceCounters
| where ((category == "Process" and counter == "% Processor Time Normalized") or name == "processCpuPercentage")
| extend performanceCounter_value = iif(itemType == "performanceCounter", value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

<!--
```Kusto
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 5m)
```
-->

> [!NOTE]
> The range of the metric is between 0 and 100 * n, where n is the number of available CPU cores. For example, the metric value of 200% could represent full utilization of two CPU core or half utilization of 4 CPU cores and so on. The *Process CPU Normalized* is an alternative metric collected by many SDKs which represents the same value but divides it by the number of available CPU cores. Thus, the range of *Process CPU Normalized* metric is 0 through 100.


#### Process CPU (all cores) (performanceCounters/processCpuPercentageTotal)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Percentage      | Avg, Min, Max          | All telemetry fields |

```Kusto
performanceCounters
| where ((category == "Process" and counter == "% Processor Time") or name == "processCpuPercentageTotal")
| extend performanceCounter_value = iif(itemType == 'performanceCounter', value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 5m)
| render timechart
```

#### Process IO rate (performanceCounters/processIOBytesPerSecond)

| Unit of measure  | Supported aggregations | Supported dimensions |
|------------------|------------------------|----------------------|
| Bytes per second | Avg, Min, Max          | All telemetry fields |

```Kusto
performanceCounters
| where ((category == "Process" and counter == "IO Data Bytes/sec") or name == "processIOBytesPerSecond")
| extend performanceCounter_value = iif(itemType == "performanceCounter", value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

<!--
```Kusto
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 5m)
```
-->

#### Process private bytes (performanceCounters/processPrivateBytes)

Amount of nonshared memory that the monitored process allocated for its data.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Bytes           | Avg, Min, Max          | All telemetry fields |

```Kusto
performanceCounters
| where ((category == "Process" and counter == "Private Bytes") or name == "processPrivateBytes")
| extend performanceCounter_value = iif(itemType == "performanceCounter", value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

<!--
```Kusto
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 5m)
```
-->

#### Processor time (performanceCounters/processorCpuPercentage)

CPU consumption by *all* processes running on the monitored server instance.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Percentage      | Avg, Min, Max          | All telemetry fields |

>[!NOTE]
> The processor time metric is not available for the applications hosted in Azure App Services. Use the  [Process CPU](#process-cpu-performancecountersprocesscpupercentage) metric to track CPU utilization of the web applications hosted in App Services.

```Kusto
performanceCounters
| where ((category == "Processor" and counter == "% Processor Time") or name == "processorCpuPercentage")
| extend performanceCounter_value = iif(itemType == "performanceCounter", value, todouble(''))
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 1m)
| render timechart
```

<!--
```Kusto
| summarize sum(performanceCounter_value) / count() by bin(timestamp, 15m)
```
-->

---

### Server metrics

### [Standard](#tab/standard)

#### Dependency calls (dependencies/count)

This metric is in relation to the number of dependency calls.

| Unit of measure | Supported aggregations | Supported dimensions                                                                                                                                                           |
|-----------------|------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Count           | Count                  | `Cloud role instance`, `Cloud role name`, `Dependency performance`, `Dependency type`, `Is traffic synthetic`, `Result code`, `Successful call`, `Target of a dependency call` |

#### Dependency duration (dependencies/duration)

This metric refers to duration of dependency calls.

| Unit of measure | Supported aggregations | Supported dimensions                                                                                                                                                           |
|-----------------|------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Milliseconds    | Avg, Max, Min          | `Cloud role instance`, `Cloud role name`, `Dependency performance`, `Dependency type`, `Is traffic synthetic`, `Result code`, `Successful call`, `Target of a dependency call` |

#### Server request rate (requests/rate)

This metric reflects the number of incoming server requests that were received by your web application.

| Unit of measure  | Supported aggregations | Supported dimensions                                                                                                        |
|------------------|------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| Count per second | Avg                    | `Cloud role instance`, `Cloud role name`, `Is traffic synthetic`, `Request performance` `Result code`, `Successful request` |

#### Server requests (requests/count)

| Unit of measure | Supported aggregations | Supported dimensions                                                                                                        |
|-----------------|------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| Count           | Count                  | `Cloud role instance`, `Cloud role name`, `Is traffic synthetic`, `Request performance` `Result code`, `Successful request` |

#### Server response time (requests/duration)

This metric reflects the time it took for the servers to process incoming requests.

| Unit of measure | Supported aggregations | Supported dimensions                                                                                                        |
|-----------------|------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| Milliseconds    | Avg, Max, Min          | `Cloud role instance`, `Cloud role name`, `Is traffic synthetic`, `Request performance` `Result code`, `Successful request` |

### [Log-based](#tab/log-based)

#### Dependency calls (dependencies/count)

This metric is in relation to the number of dependency calls.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```Kusto
dependencies
| summarize sum(itemCount) by bin(timestamp, 5m)
| render barchart
```

<!--
```Kusto
| summarize sum(itemCount) by bin(timestamp, 15m)
```
-->

#### Dependency duration (dependencies/duration)

This metric refers to duration of dependency calls.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Avg, Min, Max          | All telemetry fields |

```Kusto
dependencies
| where notempty(duration)
| extend dependency_duration = iif(itemType == 'dependency',duration,todouble(''))
| extend _sum = dependency_duration
| extend _count = itemCount
| extend _sum = _sum * _count
| summarize sum(_sum)/sum(_count) by bin(timestamp, 1m)
| render timechart
```

<!--
```Kusto
| summarize sum(_sum) / sum(_count) by bin(timestamp, 15m)
```
-->

#### Server requests (requests/count)

This metric reflects the number of incoming server requests that were received by your web application.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```Kusto
requests
| summarize sum(itemCount) by bin(timestamp, 5m)
| render barchart
```

#### Server response time (requests/duration)

This metric reflects the time it took for the servers to process incoming requests.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | Avg, Min, Max          | All telemetry fields |

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

<!--
```Kusto
| summarize sum(_sum) / sum(_count) by bin(timestamp, 5m)
```
-->

---

### Usage metrics

### [Standard](#tab/standard)

#### Page view load time (pageViews/duration)

This metric refers to the amount of time it took for PageView events to load.

| Unit of measure | Supported aggregations | Supported dimensions                      |
|-----------------|------------------------|-------------------------------------------|
| (Milli)seconds  | Avg, Max, Min          | `Cloud role name`, `Is traffic synthetic` |

#### Page views (pageViews/count)

The count of PageView events logged with the TrackPageView() Application Insights API.

| Unit of measure | Supported aggregations | Supported dimensions                      |
|-----------------|------------------------|-------------------------------------------|
| Count           | Count                  | `Cloud role name`, `Is traffic synthetic` |

#### Traces (traces/count)

The count of trace statements logged with the TrackTrace() Application Insights API call.

| Unit of measure | Supported aggregations | Supported dimensions                                                               |
|-----------------|------------------------|------------------------------------------------------------------------------------|
| Count           | Count                  | `Cloud role instance`, `Cloud role name`, `Is traffic synthetic`, `Severity level` |

### [Log-based](#tab/log-based)

#### Data point count

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```Kusto

```

#### Data point volume

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```Kusto

```

#### Events (customEvents/count)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```Kusto
customEvents
| summarize sum(itemCount) by bin(timestamp, 5m)
| render barchart
```

#### Page view load time (pageViews/duration)

This metric refers to the amount of time it took for PageView events to load.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| (Milli)seconds  | Avg, Min, Max          | All telemetry fields |

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

#### Page views (pageViews/count)

The count of PageView events logged with the TrackPageView() Application Insights API.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```Kusto
pageViews
| summarize sum(itemCount) by bin(timestamp, 1h)
| render barchart
```

<!--
```Kusto
| summarize sum(itemCount) by bin(timestamp, 5m)
```
-->

#### Sessions (sessions/count)

This metric refers to the count of distinct session IDs.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Unique                 | All telemetry fields |

```Kusto
union traces, requests, pageViews, dependencies, customEvents, availabilityResults, exceptions, customMetrics, browserTimings
| where notempty(session_Id)
| summarize dcount(session_Id) by bin(timestamp, 1h)
| render barchart
```

<!--
```Kusto
| summarize dcount(session_Id) by bin(timestamp, 5m)
```
-->

#### Traces (traces/count)

The count of trace statements logged with the TrackTrace() Application Insights API call.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```Kusto
traces
| summarize sum(itemCount) by bin(timestamp, 1h)
| render barchart
```

<!--
```Kusto
| summarize sum(itemCount) by bin(timestamp, 5m)
```
-->

#### Users (users/count)

The number of distinct users who accessed your application. The accuracy of this metric may be  significantly impacted by using telemetry sampling and filtering.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Unique                 | All telemetry fields |

```Kusto
union traces, requests, pageViews, dependencies, customEvents, availabilityResults, exceptions, customMetrics, browserTimings
| where notempty(user_Id)
| summarize dcount(user_Id) by bin(timestamp, 1h)
| render barchart
```

<!--
```Kusto
| summarize dcount(user_Id) by bin(timestamp, 5m)
```
-->

#### Users, Authenticated (users/authenticated)

The number of distinct users who authenticated into your application.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Unique                 | All telemetry fields |

```Kusto
union traces, requests, pageViews, dependencies, customEvents, availabilityResults, exceptions, customMetrics, browserTimings
| where notempty(user_AuthenticatedId)
| summarize dcount(user_AuthenticatedId) by bin(timestamp, 1h)
| render barchart
```

<!--
```Kusto
| summarize dcount(user_AuthenticatedId) by bin(timestamp, 15m)
```
-->

---

## Access log-based metrics directly with the Application Insights REST API

The Application Insights REST API enables programmatic retrieval of log-based metrics. It also features an optional parameter `ai.include-query-payload` that when added to a query string, prompts the API to return not only the time series data, but also the Kusto Query Language (KQL) statement used to fetch it. This parameter can be particularly beneficial for users aiming to comprehend the connection between raw events in Log Analytics and the resulting log-based metric.

To access your data directly, pass the parameter `ai.include-query-payload` to the Application Insights API in a query using KQL.

```Kusto
api.applicationinsights.io/v1/apps/DEMO_APP/metrics/users/authenticated?api_key=DEMO_KEY&prefer=ai.include-query-payload
```

The following is an example of a return KQL statement for the metric "Authenticated Users.” (In this example, `"users/authenticated"` is the metric id.) 

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

* [Metrics - Get - REST API](/rest/api/application-insights/metrics/get)
* [Application Insights API for custom events and metrics](api-custom-events-metrics.md)
* [Near real time alerting](../alerts/alerts-metric-near-real-time.md)
* [GetMetric and TrackValue](./api-custom-events-metrics.md#getmetric)
