---
title: Metrics in Application Insights - Azure Monitor | Microsoft Docs
description: This article explains the difference between log-based and standard/preaggregated metrics in Application Insights.
ms.topic: how-to
ms.date: 11/06/2025
---

# Metrics in Application Insights

Application Insights supports three different types of metrics: standard (preaggregated), log-based, and custom metrics. Each one brings a unique value in monitoring application health, diagnostics, and analytics. Developers who are instrumenting applications can decide which type of metric is best suited to a particular scenario. Decisions are based on the size of the application, expected volume of telemetry, and business requirements for metrics precision and alerting. This article explains the difference between all supported metrics types.

#### Standard metrics

Application Insights collects and monitors standard metrics automatically. These predefined metrics cover a wide range of performance and usage indicators, such as CPU usage, memory consumption, request rates, and response times. You don't need to configure anything to start using them. During collection, the service preaggregates standard metrics and stores them as a time series in a specialized repository with only key dimensions. This design improves query performance. Because of their speed and structure, standard metrics work best for near real-time alerting and responsive [dashboards](overview-dashboard.md).

#### Log-based metrics

Log-based metrics in Application Insights are a query-time concept. The system represents them as time series built from your application's log data. It doesn't preaggregate the underlying logs during collection or storage. Instead, it retains all properties of each log entry.

This retention allows you to use log properties as dimensions when querying log-based metrics. You can apply [metric chart filtering](../essentials/analyze-metrics.md#add-filters) and [metric splitting](../essentials/analyze-metrics.md#apply-metric-splitting), which gives these metrics strong analytical and diagnostic value.

However, telemetry volume reduction techniques affect log-based metrics. Techniques like [sampling](opentelemetry-sampling.md) and [telemetry filtering](api-filtering-sampling.md#filtering), often used to reduce data from high-volume applications, reduce the number of collected log entries. This reduction lowers the accuracy of log-based metrics.

#### Custom metrics (preview)

Custom metrics in Application Insights allow you to define and track specific measurements that are unique to your application. These metrics can be created by instrumenting your code to send custom telemetry data to Application Insights. Custom metrics provide the flexibility to monitor any aspect of your application that isn't covered by standard metrics, enabling you to gain deeper insights into your application's behavior and performance.

For more information, see [Custom metrics in Azure Monitor (preview)](../metrics/metrics-custom-overview.md).

> [!NOTE]
> Application Insights also provides a feature called [Live Metrics stream](live-stream.md), which allows for near real-time monitoring of your web applications and doesn't store any telemetry data.

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
| **Service limit** | Subject to [Application Insights limits](./../service-limits.md#application-insights). | Subject to [Log Analytics workspace limits](./../service-limits.md#log-analytics-workspaces). | Limited by the quota for free metrics and the cost for extra dimensions. |
| **Use cases** | Real-time monitoring, performance dashboards, and quick insights. | Detailed diagnostics, troubleshooting, and in-depth analysis. | Tailored performance indicators and business-specific metrics. |
| **Examples** | CPU usage, memory usage, request duration. | Request counts, exception traces, dependency calls. | Custom application-specific metrics like user engagement, feature usages. |

## Metrics preaggregation

OpenTelemetry SDKs preaggregate metrics during collection to reduce the volume of data sent from the SDK to the telemetry channel endpoint. This process applies to standard metrics sent by default, so the accuracy isn't affected by sampling or filtering. It also applies to custom metrics sent using the [OpenTelemetry API](opentelemetry-add-modify.md#add-custom-metrics), which results in less data ingestion and lower cost.

The Application Insights JavaScript SDK (browser-based) doesn't implement preaggregation. Instead, the back end creates the new metrics by aggregating the events received through the telemetry channel. This doesn't reduce the volume of data sent from the browser. However, you can still use the preaggregated metrics the back end produces. This setup gives you better performance and supports near real-time dimensional alerting, even without preaggregation during collection. The telemetry channel endpoint preaggregates events before ingestion sampling. For this reason, ingestion sampling never affects the accuracy of preaggregated metrics, regardless of the SDK version you use with your application.

The following tables list where preaggregation are preaggregated.

### Metrics preaggregation with Azure Monitor OpenTelemetry Distro

| Current production SDK | Standard metrics preaggregation | Custom metrics preaggregation |
|------------------------|---------------------------------|-------------------------------|
| ASP.NET Core | SDK | SDK via [OpenTelemetry API](/azure/azure-monitor/app/opentelemetry-add-modify?tabs=aspnetcore#add-custom-metrics) |
| .NET (via Exporter) | SDK | SDK via [OpenTelemetry API](/azure/azure-monitor/app/opentelemetry-add-modify?tabs=net#add-custom-metrics) |
| Java (3.x) | SDK | SDK via [OpenTelemetry API](/azure/azure-monitor/app/opentelemetry-add-modify?tabs=java#add-custom-metrics) |
| Java native | SDK | SDK via [OpenTelemetry API](/azure/azure-monitor/app/opentelemetry-add-modify?tabs=java-native#add-custom-metrics) |
| Node.js | SDK | SDK via [OpenTelemetry API](/azure/azure-monitor/app/opentelemetry-add-modify?tabs=nodejs#add-custom-metrics) |
| Python | SDK | SDK via [OpenTelemetry API](/azure/azure-monitor/app/opentelemetry-add-modify?tabs=python#add-custom-metrics) |

### Metrics preaggregation with autoinstrumentation

With autoinstrumentation, the SDK is automatically added to your application code and can't be customized. For custom metrics, manual instrumentation is required.

| Current production SDK | Standard metrics preaggregation | Custom metrics preaggregation |
|------------------------|---------------------------------|-------------------------------|
| ASP.NET Core | SDK <sup>1<sup> | Not supported |
| ASP.NET | SDK <sup>2<sup> | Not supported |
| Java | SDK | Supported <sup>3<sup> |
| Node.js | SDK | Not supported |
| Python | SDK | Not supported |

**Footnotes**

* <sup>1</sup> [ASP.NET Core autoinstrumentation on App Service](azure-web-apps-net-core.md) emits standard metrics without dimensions. Manual instrumentation is required for all dimensions.<br>
* <sup>2</sup> [ASP.NET autoinstrumentation on virtual machines/virtual machine scale sets](azure-vm-vmss-apps.md) and [on-premises](application-insights-asp-net-agent.md) emits standard metrics without dimensions. The same is true for Azure App Service, but the collection level must be set to recommended. Manual instrumentation is required for all dimensions.
* <sup>3</sup> The Java agent used with autoinstrumentation captures metrics emitted by popular libraries and sends them to Application Insights as custom metrics.

### Custom metrics dimensions and preaggregation

All metrics that you send using [OpenTelemetry](opentelemetry-add-modify.md), [trackMetric](api-custom-events-metrics.md), or [GetMetric and TrackValue](api-custom-events-metrics.md#getmetric) API calls are automatically stored in both the metrics store and logs. These metrics can be found in the customMetrics table in Application Insights and in Metrics Explorer under the Custom Metric Namespace called *azure.applicationinsights*. Although the log-based version of your custom metric always retains all dimensions, the preaggregated version of the metric is stored by default with no dimensions. Retaining dimensions of custom metrics is a Preview feature that can be turned on from the [Usage and estimated cost](./../cost-usage.md#usage-and-estimated-costs) tab by selecting **With dimensions** under **Send custom metrics to Azure Metric Store**.

:::image type="content" source="media/metrics-overview/usage-and-costs.png" lightbox="media/metrics-overview/usage-and-costs.png" alt-text="Screenshot that shows usage and estimated costs.":::

### Quotas

Preaggregated metrics are stored as time series in Azure Monitor. [Azure Monitor quotas on custom metrics](../essentials/metrics-custom-overview.md#quotas-and-limits) apply.

> [!NOTE]
> Going over the quota might have unintended consequences. Azure Monitor might become unreliable in your subscription or region. To learn how to avoid exceeding the quota, see [Design limitations and considerations](../essentials/metrics-custom-overview.md#design-limitations-and-considerations).

### Why is collection of custom metrics dimensions turned off by default?

Application Insights turns off the collection of custom metric dimensions by default. Storing custom metrics with dimensions incurs separate billing from Application Insights. Storing nondimensional custom metrics remains free, up to a quota. For details, see the [Azure Monitor pricing page](https://azure.microsoft.com/pricing/details/monitor/).

## Create charts and explore metrics

Use [Azure Monitor metrics explorer](../essentials/metrics-getting-started.md) to plot charts from preaggregated, log-based, and custom metrics, and to author dashboards with charts. After you select the Application Insights resource you want, use the namespace picker to switch between metrics.

:::image type="content" source="media/metrics-overview/metric-namespace.png" lightbox="media/metrics-overview/metric-namespace.png" alt-text="Screenshot that shows Metric namespace.":::

## Pricing models for Application Insights metrics

Ingesting metrics into Application Insights, whether log-based or preaggregated, generates costs based on the size of the ingested data. For more information, see [Azure Monitor Logs pricing details](../logs/cost-logs.md#application-insights-billing). Your custom metrics, including all its dimensions, are always stored in the Application Insights log store. Also, a preaggregated version of your custom metrics with no dimensions is forwarded to the metrics store by default.

Selecting the [Enable alerting on custom metric dimensions](#custom-metrics-dimensions-and-preaggregation) option to store all dimensions of the preaggregated metrics in the metric store can result in increased charges based on [custom metrics pricing](https://azure.microsoft.com/pricing/details/monitor/).

## Available metrics

### [Standard](#tab/standard)

The following sections list metrics with supported aggregations and dimensions. The details about log-based metrics include the underlying Kusto query statements.

> [!IMPORTANT]
> * **Time Series Limit:** Each metric can only have up to **5,000** time series within *24 hours*. Once this limit is reached, all dimension values of that metric point are replaced with the constant `Maximum values reached`.
>
> * **Cardinality limit:** Each dimension supports a limited number of unique values within a seven-day period. When the limit is reached, Azure Monitor replaces all new values with the constant `Other values`. The following tables list the cardinality limit for each dimension.

### [Log-based](#tab/log-based)

The following sections list metrics with supported aggregations and dimensions. The details about log-based metrics include the underlying Kusto query statements. For convenience, each query uses defaults for time granularity, chart type, and sometimes splitting dimension, which simplifies using the query in Log Analytics without any need for modification.

When you plot the same metric in [metrics explorer](./../essentials/analyze-metrics.md), there are no defaults - the query is dynamically adjusted based on your chart settings:

* The selected **Time range** is translated into a `where timestamp...` clause to only pick the events from selected time range. For example, a chart showing data for the most recent 24 hours, the query includes `| where timestamp > ago(24 h)`.

* The selected **Time granularity** is put into the final `summarize ... by bin(timestamp, [time grain])` clause.

* Any selected **Filter** dimensions are translated into `where` clauses.

* The selected **Split chart** dimension is translated into a `summarize` property. For example, if you split your chart by `location`, and plot using a 5-minute time granularity, the `summarize` clause is summarized `... by bin(timestamp, 5 m), location`.

> [!NOTE]
> If you're new to the Kusto query language, you start by copying and pasting Kusto statements into the Log Analytics query pane without making any modifications. Select **Run** to see basic chart. As you begin to understand the syntax of query language, you can start making small modifications and see the impact of your change. Exploring your own data is a great way to start realizing the full power of [Log Analytics](../logs/log-analytics-overview.md) and [Azure Monitor](../overview.md).

> [!IMPORTANT]
> For the following log-based metrics, if multiple aggregations are supported, the aggregation in *italic* is used in the Kusto query example.

---

### Availability metrics

Metrics in the Availability category enable you to see the health of your web application as observed from points around the world. [Configure the availability tests](availability.md) to start using any metrics from this category.

### [Standard](#tab/standard)

#### Availability (availabilityResults/availabilityPercentage)

The *Availability* metric shows the percentage of the web test runs that didn't detect any issues. The lowest possible value is 0, which indicates that all of the web test runs failed. The value of 100 means that all of the web test runs passed the validation criteria.
<!--
| Unit of measure | Aggregations | Dimension name<br>(Metrics Explorer) | Dimension name<br>(Log Analytics) | Cardinality limit |
|-----------------|--------------|--------------------------------------|-----------------------------------|------------------:|
| Percentage      | Avg          |                                      |                                   |                   |
|                 |              | `Run location`                       | `availabilityResult/location`     | 50                |
|                 |              | `Test name`                          | `availabilityResult/name`         | 100               |
-->
<table>
    <thead>
        <tr>
            <th>Unit of measure</th>
            <th>Aggregations</th>
            <th>Dimension name<br>(Metrics Explorer)</th>
            <th>Dimension name<br>(Log Analytics)</th>
            <th align='right'>Cardinality limit</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=2>Percentage</td>
            <td rowspan=2>Avg</td>
            <td><code>Run location</code></td>
            <td><code>availabilityResult/location</code></td>
            <td align='right'>50</td>
        </tr>
        <tr>
            <td><code>Test name</code></td>
            <td><code>availabilityResult/name</code></td>
            <td align='right'>100</td>
        </tr>
    </tbody>
</table>

#### Availability test duration (availabilityResults/duration)

The *Availability test duration* metric shows how much time it took for the web test to run. For the [multi-step web tests](/previous-versions/azure/azure-monitor/app/availability-multistep), the metric reflects the total execution time of all steps.
<!--
| Unit of measure | Aggregations  | Dimension name<br>(Metrics Explorer) | Dimension name<br>(Log Analytics) | Cardinality limit |
|-----------------|---------------|--------------------------------------|-----------------------------------|------------------:|
| Milliseconds    | Avg, Max, Min |                                      |                                   |                   |
|                 |               | `Run location`                       | `availabilityResult/location`     | 50                |
|                 |               | `Test name`                          | `availabilityResult/name`         | 100               |
|                 |               | `Test result`                        | `availabilityResult/success`      | 2                 |
-->
<table>
    <thead>
        <tr>
            <th>Unit of measure</th>
            <th>Aggregations</th>
            <th>Dimension name<br>(Metrics Explorer)</th>
            <th>Dimension name<br>(Log Analytics)</th>
            <th align='right'>Cardinality limit</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=3>Milliseconds</td>
            <td rowspan=3>Avg, Max, Min</td>
            <td><code>Run location</code></td>
            <td><code>availabilityResult/location</code></td>
            <td align='right'>50</td>
        </tr>
        <tr>
            <td><code>Test name</code></td>
            <td><code>availabilityResult/name</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Test result</code></td>
            <td><code>availabilityResult/success</code></td>
            <td align='right'>2</td>
        </tr>
    </tbody>
</table>

#### Availability tests (availabilityResults/count)

The *Availability tests* metric reflects the count of the web tests runs by Azure Monitor.
<!--
| Unit of measure | Aggregations | Dimension name<br>(Metrics Explorer) | Dimension name<br>(Log Analytics) | Cardinality limit |
|-----------------|--------------|--------------------------------------|-----------------------------------|------------------:|
| Count           | Count        |                                      |                                   |                   |
|                 |              | `Run location`                       | `availabilityResult/location`     | 50                |
|                 |              | `Test name`                          | `availabilityResult/name`         | 100               |
|                 |              | `Test result`                        | `availabilityResult/success`      | 2                 |
-->
<table>
    <thead>
        <tr>
            <th>Unit of measure</th>
            <th>Aggregations</th>
            <th>Dimension name<br>(Metrics Explorer)</th>
            <th>Dimension name<br>(Log Analytics)</th>
            <th align='right'>Cardinality limit</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=3>Count</td>
            <td rowspan=3>Count</td>
            <td><code>Run location</code></td>
            <td><code>availabilityResult/location</code></td>
            <td align='right'>50</td>
        </tr>
        <tr>
            <td><code>Test name</code></td>
            <td><code>availabilityResult/name</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Test result</code></td>
            <td><code>availabilityResult/success</code></td>
            <td align='right'>2</td>
        </tr>
    </tbody>
</table>

### [Log-based](#tab/log-based)

#### Availability (availabilityResults/availabilityPercentage)

The *Availability* metric shows the percentage of the web test runs that didn't detect any issues. The lowest possible value is 0, which indicates that all of the web test runs failed. The value of 100 means that all of the web test runs passed the validation criteria.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Percentage      | Avg                    | All telemetry fields |

```kusto
availabilityResults
| summarize ['availabilityResults/availabilityPercentage_avg'] = sum(todouble(success == 1) * 100) / count() by bin(timestamp, 15m)
| render timechart
```

#### Availability test results count (availabilityResults/count)

The *Availability tests* metric reflects the count of the web tests runs by Azure Monitor.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```kusto
availabilityResults
| summarize ['availabilityResults/count_sum'] = sum(itemCount) by bin(timestamp, 15m)
| render barchart
```

#### Test duration (availabilityResults/duration)

The *Availability test duration* metric shows how much time it took for the web test to run. For the [multi-step web tests](/previous-versions/azure/azure-monitor/app/availability-multistep), the metric reflects the total execution time of all steps.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | *Avg*, Min, Max        | All telemetry fields |

```kusto
availabilityResults
| where notempty(duration)
| extend availabilityResult_duration = iif(itemType == 'availabilityResult', duration, todouble(''))
| summarize ['availabilityResults/duration_avg'] = sum(availabilityResult_duration) / sum(itemCount) by bin(timestamp, 5m)
| render timechart
```

---

### Browser metrics

The Application Insights JavaScript SDK collects browser metrics from real end-user browsers. These metrics give you valuable insights into your users' experience with your web app. The SDK typically doesn't sample browser metrics, so they offer higher precision in usage numbers. In contrast, server-side metrics often use sampling, which can skew results.

> [!NOTE]
> To collect browser metrics, your application must be instrumented with the [Application Insights JavaScript SDK](javascript-sdk.md).

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
| Milliseconds    | *Avg*, Min, Max        | All telemetry fields |

```kusto
browserTimings
| where notempty(totalDuration)
| extend _sum = totalDuration
| extend _count = itemCount
| extend _sum = _sum * _count
| summarize ['browserTimings/totalDuration_avg'] = sum(_sum) / sum(_count) by bin(timestamp, 15m)
| render timechart
```

#### Client processing time (browserTiming/processingDuration)

Time between receiving the last byte of a document until the DOM is loaded. Async requests could still be processing.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | *Avg*, Min, Max        | All telemetry fields |

```kusto
browserTimings
| where notempty(processingDuration)
| extend _sum = processingDuration
| extend _count = itemCount
| extend _sum = _sum * _count
| summarize ['browserTimings/processingDuration_avg'] = sum(_sum) / sum(_count) by bin(timestamp, 15m)
| render timechart
```

#### Page load network connect time (browserTimings/networkDuration)

Time between user request and network connection. Includes Domain Name System (DNS) lookup and transport connection.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | *Avg*, Min, Max        | All telemetry fields |

```kusto
browserTimings
| where notempty(networkDuration)
| extend _sum = networkDuration
| extend _count = itemCount
| extend _sum = _sum * _count
| summarize ['browserTimings/networkDuration_avg'] = sum(_sum) / sum(_count) by bin(timestamp, 15m)
| render timechart
```

#### Receiving response time (browserTimings/receiveDuration)

Time between the first and last bytes, or until disconnection.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | *Avg*, Min, Max        | All telemetry fields |

```kusto
browserTimings
| where notempty(receiveDuration)
| extend _sum = receiveDuration
| extend _count = itemCount
| extend _sum = _sum * _count
| summarize ['browserTimings/receiveDuration_avg'] = sum(_sum) / sum(_count) by bin(timestamp, 15m)
| render timechart
```

#### Send request time (browserTimings/sendDuration)

Time between network connection and receiving the first byte.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | *Avg*, Min, Max        | All telemetry fields |

```kusto
browserTimings
| where notempty(sendDuration)
| extend _sum = sendDuration
| extend _count = itemCount
| extend _sum = _sum * _count
| summarize ['browserTimings/sendDuration_avg'] = sum(_sum) / sum(_count) by bin(timestamp, 15m)
| render timechart
```

---

### Failure metrics

The metrics in **Failures** show problems with processing requests, dependency calls, and thrown exceptions.

### [Standard](#tab/standard)

#### Browser exceptions (exceptions/browser)

This metric reflects the number of thrown exceptions from your application code running in browser. Only exceptions that are tracked with a `trackException()` Application Insights API call are included in the metric.

| Unit of measure | Aggregations | Dimension name<br>(Metrics Explorer) | Dimension name<br>(Log Analytics) | Cardinality limit |
|-----------------|--------------|--------------------------------------|-----------------------------------|------------------:|
| Count           | Count        | `Cloud role name`                    | `cloud/roleName`                  | 100               |

#### Dependency call failures (dependencies/failed)

The number of failed dependency calls.
<!--
| Unit of measure | Aggregations | Dimension name<br>(Metrics Explorer) | Dimension name<br>(Log Analytics) | Cardinality limit |
|-----------------|--------------|--------------------------------------|-----------------------------------|------------------:|
| Count           | Count        |                                      |                                   |                   |
|                 |              | `Cloud role instance`                | `cloud/roleInstance`              | 100               |
|                 |              | `Cloud role name`                    | `cloud/roleName`                  | 100               |
|                 |              | `Dependency performance`             | `dependency/performanceBucket`    | 20                |
|                 |              | `Dependency type`                    | `dependency/type`                 | 100               |
|                 |              | `Is traffic synthetic`               | `operation/synthetic`             | 10                |
|                 |              | `Result code`                        | `dependency/resultCode`           | 100               |
|                 |              | `Target of dependency call`          | `dependency/target`               | 100               |
-->
<table>
    <thead>
        <tr>
            <th>Unit of measure</th>
            <th>Aggregations</th>
            <th>Dimension name<br>(Metrics Explorer)</th>
            <th>Dimension name<br>(Log Analytics)</th>
            <th align='right'>Cardinality limit</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=7>Count</td>
            <td rowspan=7>Count</td>
            <td><code>Cloud role instance</code></td>
            <td><code>cloud/roleInstance</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Cloud role name</code></td>
            <td><code>cloud/roleName</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Dependency performance</code></td>
            <td><code>dependency/performanceBucket</code></td>
            <td align='right'>20</td>
        </tr>
        <tr>
            <td><code>Dependency type</code></td>
            <td><code>dependency/type</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Is traffic synthetic</code></td>
            <td><code>operation/synthetic</code></td>
            <td align='right'>10</td>
        </tr>
        <tr>
            <td><code>Result code</code></td>
            <td><code>dependency/resultCode</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Target of dependency call</code></td>
            <td><code>dependency/target</code></td>
            <td align='right'>100</td>
        </tr>
    </tbody>
</table>

#### Exceptions (exceptions/count)

Each time when you log an exception to Application Insights, there's a call to the [trackException() method](api-custom-events-metrics.md#trackexception) of the SDK. The Exceptions metric shows the number of logged exceptions.
<!--
| Unit of measure | Aggregations | Dimension name<br>(Metrics Explorer) | Dimension name<br>(Log Analytics) | Cardinality limit |
|-----------------|--------------|--------------------------------------|-----------------------------------|------------------:|
| Count           | Count        |                                      |                                   |                   |
|                 |              | `Cloud role instance`                | `cloud/roleInstance`              | 100               |
|                 |              | `Cloud role name`                    | `cloud/roleName`                  | 100               |
|                 |              | `Device type`                        | `client/type`                     | 2                 |
-->
<table>
    <thead>
        <tr>
            <th>Unit of measure</th>
            <th>Aggregations</th>
            <th>Dimension name<br>(Metrics Explorer)</th>
            <th>Dimension name<br>(Log Analytics)</th>
            <th align='right'>Cardinality limit</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=3>Count</td>
            <td rowspan=3>Count</td>
            <td><code>Cloud role instance</code></td>
            <td><code>cloud/roleInstance</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Cloud role name</code></td>
            <td><code>cloud/roleName</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Device type</code></td>
            <td><code>client/type</code></td>
            <td align='right'>2</td>
        </tr>
    </tbody>
</table>

#### Failed requests (requests/failed)

The count of tracked server requests that were marked as *failed*. By default, the Application Insights SDK automatically marks each server request that returned HTTP response code 5xx or 4xx (except for 401) as a failed request. You can customize this logic by modifying *success* property of request telemetry item in a [custom telemetry initializer](api-filtering-sampling.md#addmodify-properties-itelemetryinitializer). For more information about various response codes, see [Application Insights telemetry data model](data-model-complete.md#request-telemetry).
<!--
| Unit of measure | Aggregations | Dimension name<br>(Metrics Explorer) | Dimension name<br>(Log Analytics) | Cardinality limit |
|-----------------|--------------|--------------------------------------|-----------------------------------|------------------:|
| Count           | Count        |                                      |                                   |                   |
|                 |              | `Cloud role instance`                | `cloud/roleInstance`              | 100               |
|                 |              | `Cloud role name`                    | `cloud/roleName`                  | 100               |
|                 |              | `Is synthetic traffic`               | `operation/synthetic`             | 10                |
|                 |              | `Request performance`                | `request/performanceBucket`       | 20                |
|                 |              | `Result code`                        | `request/resultCode`              | 100               |
-->
<table>
    <thead>
        <tr>
            <th>Unit of measure</th>
            <th>Aggregations</th>
            <th>Dimension name<br>(Metrics Explorer)</th>
            <th>Dimension name<br>(Log Analytics)</th>
            <th align='right'>Cardinality limit</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=5>Count</td>
            <td rowspan=5>Count</td>
            <td><code>Cloud role instance</code></td>
            <td><code>cloud/roleInstance</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Cloud role name</code></td>
            <td><code>cloud/roleName</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Is synthetic traffic</code></td>
            <td><code>operation/synthetic</code></td>
            <td align='right'>10</td>
        </tr>
        <tr>
            <td><code>Request performance</code></td>
            <td><code>request/performanceBucket</code></td>
            <td align='right'>20</td>
        </tr>
        <tr>
            <td><code>Result code</code></td>
            <td><code>request/resultCode</code></td>
            <td align='right'>100</td>
        </tr>
    </tbody>
</table>

#### Server exceptions (exceptions/server)

This metric shows the number of server exceptions.
<!--
| Unit of measure | Aggregations | Dimension name<br>(Metrics Explorer) | Dimension name<br>(Log Analytics) | Cardinality limit |
|-----------------|--------------|--------------------------------------|-----------------------------------|------------------:|
| Count           | Count        |                                      |                                   |                   |
|                 |              | `Cloud role instance`                | `cloud/roleInstance`              | 100               |
|                 |              | `Cloud role name`                    | `cloud/roleName`                  | 100               |
-->
<table>
    <thead>
        <tr>
            <th>Unit of measure</th>
            <th>Aggregations</th>
            <th>Dimension name<br>(Metrics Explorer)</th>
            <th>Dimension name<br>(Log Analytics)</th>
            <th align='right'>Cardinality limit</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=2>Count</td>
            <td rowspan=2>Count</td>
            <td><code>Cloud role instance</code></td>
            <td><code>cloud/roleInstance</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Cloud role name</code></td>
            <td><code>cloud/roleName</code></td>
            <td align='right'>100</td>
        </tr>
    </tbody>
</table>

### [Log-based](#tab/log-based)

#### Browser exceptions (exceptions/browser)

This metric reflects the number of thrown exceptions from your application code running in browser. Only exceptions that are tracked with a `trackException()` Application Insights API call are included in the metric.

> [!NOTE]
> When you're sampling, the itemCount indicates how many telemetry items a single log record represents. For example, with 25% sampling, each log record kept represents four items (1 kept + 3 sampled out). Log-based queries sum up all itemCount values to ensure the metric reflects the total number of actual events, not just the number of stored log records.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```kusto
exceptions
| where client_Type == 'Browser'
| summarize ['exceptions/browser_sum'] = sum(itemCount) by bin(timestamp, 15m)
| render barchart
```

#### Dependency call failures (dependencies/failed)

The number of failed dependency calls.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```kusto
dependencies
| where success == 'False'
| summarize ['dependencies/failed_sum'] = sum(itemCount) by bin(timestamp, 15m)
| render barchart
```

#### Exceptions (exceptions/count)

Each time when you log an exception to Application Insights, there's a call to the [trackException() method](api-custom-events-metrics.md#trackexception) of the SDK. The Exceptions metric shows the number of logged exceptions.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```kusto
exceptions
| summarize ['exceptions/count_sum'] = sum(itemCount) by bin(timestamp, 15m)
| render barchart
```

#### Failed requests (requests/failed)

The count of tracked server requests that were marked as *failed*. By default, the Application Insights SDK automatically marks each server request that returned HTTP response code 5xx or 4xx as a failed request. You can customize this logic by modifying *success* property of request telemetry item in a [custom telemetry initializer](api-filtering-sampling.md#addmodify-properties-itelemetryinitializer).

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```kusto
requests
| where success == 'False'
| summarize ['requests/failed_sum'] = sum(itemCount) by bin(timestamp, 15m)
| render barchart
```

#### Server exceptions (exceptions/server)

This metric shows the number of server exceptions.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```kusto
exceptions
| where client_Type != 'Browser'
| summarize ['exceptions/server_sum'] = sum(itemCount) by bin(timestamp, 15m)
| render barchart
```

---

### Performance counters

[Application Insights](app-insights-overview.md) uses system and process metrics, called performance counters, to help diagnose performance issues and support built-in experiences.

The [Azure Monitor OpenTelemetry Distro](opentelemetry-enable.md) exports these counters as custom metrics to the `performanceCounters` table, each identified by a unique metric name.

#### Counter names and descriptions

| Counter | Name | Description | Measure |
|---|---|---|---|
| Available Memory | `Available Bytes` | Physical memory available to running processes. | Bytes |
| Exception Rate | `# of Exceps Thrown / sec` | Exceptions thrown by the application per second. | Exceptions per second |
| Request Execution Time | `Request Execution Time` | Average time to complete a request. | Milliseconds |
| Request Rate | `Requests/Sec` | Requests processed each second. | Requests per second |
| Requests in Queue | `Requests In Application Queue` | Requests currently waiting in the application queue. | Count |
| Process CPU % | `% Processor Time` | CPU utilization of the application process. | Percent |
| Process CPU % Normalized | `% Processor Time Normalized` | Process CPU utilization divided by logical processor count. | Percent |
| Process I/O Rate | `IO Data Bytes/sec` | I/O throughput for the application process. | Bytes per second |
| Process Private Bytes | `Private Bytes` | Private memory used by the application process. | Bytes |
| Processor Time %<br>**Category:** Processor | `% Processor Time` | Total machine CPU utilization. | Percent | 
| Processor Time %<br>**Category:** Process | `% Processor Time` | Process CPU utilization. | Percent |

#### Experiences enhanced by performance counters

* [**Performance view**](failures-performance-transactions.md?tabs=performance-view): Available Memory, Process CPU %, Process I/O Rate.
* [**Failures view**](failures-performance-transactions.md?tabs=failures-view): Available Memory, Process CPU %, Process I/O Rate.
* [**Smart Detection and Smart Alerts**](../alerts/proactive-diagnostics.md): Process Private Bytes.
* [**Request count charts**](../visualize/workbooks-chart-visualizations.md): Charts display counts from the `requests` table.

#### List performance counter types

For a complete list of available performance counters, which varies depending on language-specific runtime and configuration:

1. Open your [Application Insights resource](create-workspace-resource.md) in the Azure portal.
1. Under **Monitoring**, select **Logs**.
1. From **Select a table** menu, choose `performanceCounters` and then **Run**.

Alternately run the following query.

```kusto
// List distinct performance counter names with category and counter.
performanceCounters
| where timestamp > ago(1d)
| summarize by name, category, counter
| order by name asc, category asc
```

### Server metrics

### [Standard](#tab/standard)

#### Dependency calls (dependencies/count)

This metric is in relation to the number of dependency calls.
<!--
| Unit of measure | Aggregations | Dimension name<br>(Metrics Explorer) | Dimension name<br>(Log Analytics) | Cardinality limit |
|-----------------|--------------|--------------------------------------|-----------------------------------|------------------:|
| Count           | Count        |                                      |                                   |                   |
|                 |              | `Cloud role instance`                | `cloud/roleInstance`              | 100               |
|                 |              | `Cloud role name`                    | `cloud/roleName`                  | 100               |
|                 |              | `Dependency performance`             | `dependency/performanceBucket`    | 20                |
|                 |              | `Dependency type`                    | `dependency/type`                 | 100               |
|                 |              | `Is traffic synthetic`               | `operation/synthetic`             | 10                |
|                 |              | `Result code`                        | `dependency/resultCode`           | 100               |
|                 |              | `Successful call`                    | `dependency/success`              | 2                 |
|                 |              | `Target of a dependency call`        | `dependency/target`               | 100               |
-->
<table>
    <thead>
        <tr>
            <th>Unit of measure</th>
            <th>Aggregations</th>
            <th>Dimension name<br>(Metrics Explorer)</th>
            <th>Dimension name<br>(Log Analytics)</th>
            <th align='right'>Cardinality limit</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=8>Count</td>
            <td rowspan=8>Count</td>
            <td><code>Cloud role instance</code></td>
            <td><code>cloud/roleInstance</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Cloud role name</code></td>
            <td><code>cloud/roleName</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Dependency performance</code></td>
            <td><code>dependency/performanceBucket</code></td>
            <td align='right'>20</td>
        </tr>
        <tr>
            <td><code>Dependency type</code></td>
            <td><code>dependency/type</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Is traffic synthetic</code></td>
            <td><code>operation/synthetic</code></td>
            <td align='right'>10</td>
        </tr>
        <tr>
            <td><code>Result code</code></td>
            <td><code>request/resultCode</code></td>
            <td align='right'>2</td>
        </tr>
        <tr>
            <td><code>Successful call</code></td>
            <td><code>dependency/success</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Target of a dependency call</code></td>
            <td><code>dependency/target</code></td>
            <td align='right'>100</td>
        </tr>
    </tbody>
</table>

#### Dependency duration (dependencies/duration)

This metric refers to duration of dependency calls.
<!--
| Unit of measure | Aggregations  | Dimension name<br>(Metrics Explorer) | Dimension name<br>(Log Analytics) | Cardinality limit |
|-----------------|---------------|--------------------------------------|-----------------------------------|------------------:|
| Milliseconds    | Avg, Max, Min |                                      |                                   |                   |
|                 |               | `Cloud role instance`                | `cloud/roleInstance`              | 100               |
|                 |               | `Cloud role name`                    | `cloud/roleName`                  | 100               |
|                 |               | `Dependency performance`             | `dependency/performanceBucket`    | 20                |
|                 |               | `Dependency type`                    | `dependency/type`                 | 100               |
|                 |               | `Is traffic synthetic`               | `operation/synthetic`             | 10                |
|                 |               | `Result code`                        | `dependency/resultCode`           | 100               |
|                 |               | `Successful call`                    | `dependency/success`              | 2                 |
|                 |               | `Target of a dependency call`        | `dependency/target`               | 100               |
-->
<table>
    <thead>
        <tr>
            <th>Unit of measure</th>
            <th>Aggregations</th>
            <th>Dimension name<br>(Metrics Explorer)</th>
            <th>Dimension name<br>(Log Analytics)</th>
            <th align='right'>Cardinality limit</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=8>Milliseconds</td>
            <td rowspan=8>Avg, Max, Min</td>
            <td><code>Cloud role instance</code></td>
            <td><code>cloud/roleInstance</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Cloud role name</code></td>
            <td><code>cloud/roleName</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Dependency performance</code></td>
            <td><code>dependency/performanceBucket</code></td>
            <td align='right'>20</td>
        </tr>
        <tr>
            <td><code>Dependency type</code></td>
            <td><code>dependency/type</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Is traffic synthetic</code></td>
            <td><code>operation/synthetic</code></td>
            <td align='right'>10</td>
        </tr>
        <tr>
            <td><code>Result code</code></td>
            <td><code>request/resultCode</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Successful call</code></td>
            <td><code>dependency/success</code></td>
            <td align='right'>2</td>
        </tr>
        <tr>
            <td><code>Target of a dependency call</code></td>
            <td><code>dependency/target</code></td>
            <td align='right'>100</td>
        </tr>
    </tbody>
</table>

#### Server request rate (requests/rate)

This metric shows the number of incoming server requests your web application receives.
<!--
| Unit of measure  | Aggregations | Dimension name<br>(Metrics Explorer) | Dimension name<br>(Log Analytics) | Cardinality limit |
|------------------|--------------|--------------------------------------|-----------------------------------|------------------:|
| Count per second | Avg          |                                      |                                   |                   |
|                  |              | `Cloud role instance`                | `cloud/roleInstance`              | 100               |
|                  |              | `Cloud role name`                    | `cloud/roleName`                  | 100               |
|                  |              | `Is traffic synthetic`               | `operation/synthetic`             | 10                |
|                  |              | `Request performance`                | `request/performanceBucket`       | 20                |
|                  |              | `Result code`                        | `request/resultCode`              | 100               |
|                  |              | `Successful request`                 | `request/success`                 | 2                 |
-->
<table>
    <thead>
        <tr>
            <th>Unit of measure</th>
            <th>Aggregations</th>
            <th>Dimension name<br>(Metrics Explorer)</th>
            <th>Dimension name<br>(Log Analytics)</th>
            <th align='right'>Cardinality limit</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=6>Count per second</td>
            <td rowspan=6>Avg</td>
            <td><code>Cloud role instance</code></td>
            <td><code>cloud/roleInstance</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Cloud role name</code></td>
            <td><code>cloud/roleName</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Is traffic synthetic</code></td>
            <td><code>operation/synthetic</code></td>
            <td align='right'>10</td>
        </tr>
        <tr>
            <td><code>Request performance</code></td>
            <td><code>request/performanceBucket</code></td>
            <td align='right'>20</td>
        </tr>
        <tr>
            <td><code>Result code</code></td>
            <td><code>request/resultCode</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Successful call</code></td>
            <td><code>dependency/success</code></td>
            <td align='right'>2</td>
        </tr>
    </tbody>
</table>

#### Server requests (requests/count)
<!--
| Unit of measure | Aggregations | Dimension name<br>(Metrics Explorer) | Dimension name<br>(Log Analytics) | Cardinality limit |
|-----------------|--------------|--------------------------------------|-----------------------------------|------------------:|
| Count           | Count        |                                      |                                   |                   |
|                 |              | `Cloud role instance`                | `cloud/roleInstance`              | 100               |
|                 |              | `Cloud role name`                    | `cloud/roleName`                  | 100               |
|                 |              | `Is traffic synthetic`               | `operation/synthetic`             | 10                |
|                 |              | `Request performance`                | `request/performanceBucket`       | 20                |
|                 |              | `Result code`                        | `request/resultCode`              | 100               |
|                 |              | `Successful request`                 | `request/success`                 | 2                 |
-->
<table>
    <thead>
        <tr>
            <th>Unit of measure</th>
            <th>Aggregations</th>
            <th>Dimension name<br>(Metrics Explorer)</th>
            <th>Dimension name<br>(Log Analytics)</th>
            <th align='right'>Cardinality limit</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=6>Count</td>
            <td rowspan=6>Count</td>
            <td><code>Cloud role instance</code></td>
            <td><code>cloud/roleInstance</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Cloud role name</code></td>
            <td><code>cloud/roleName</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Is traffic synthetic</code></td>
            <td><code>operation/synthetic</code></td>
            <td align='right'>10</td>
        </tr>
        <tr>
            <td><code>Request performance</code></td>
            <td><code>request/performanceBucket</code></td>
            <td align='right'>20</td>
        </tr>
        <tr>
            <td><code>Result code</code></td>
            <td><code>request/resultCode</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Successful call</code></td>
            <td><code>dependency/success</code></td>
            <td align='right'>2</td>
        </tr>
    </tbody>
</table>

#### Server response time (requests/duration)

This metric reflects the time it took for the servers to process incoming requests.
<!--
| Unit of measure | Aggregations  | Dimension name<br>(Metrics Explorer) | Dimension name<br>(Log Analytics) | Cardinality limit |
|-----------------|---------------|--------------------------------------|-----------------------------------|------------------:|
| Milliseconds    | Avg, Max, Min |                                      |                                   |                   |
|                 |               | `Cloud role instance`                | `cloud/roleInstance`              | 100               |
|                 |               | `Cloud role name`                    | `cloud/roleName`                  | 100               |
|                 |               | `Is traffic synthetic`               | `operation/synthetic`             | 10                |
|                 |               | `Request performance`                | `request/performanceBucket`       | 20                |
|                 |               | `Result code`                        | `request/resultCode`              | 100               |
|                 |               | `Successful request`                 | `request/success`                 | 2                 |
-->
<table>
    <thead>
        <tr>
            <th>Milliseconds</th>
            <th>Avg, Max, Min</th>
            <th>Dimension name<br>(Metrics Explorer)</th>
            <th>Dimension name<br>(Log Analytics)</th>
            <th align='right'>Cardinality limit</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=6>Count</td>
            <td rowspan=6>Count</td>
            <td><code>Cloud role instance</code></td>
            <td><code>cloud/roleInstance</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Cloud role name</code></td>
            <td><code>cloud/roleName</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Is traffic synthetic</code></td>
            <td><code>operation/synthetic</code></td>
            <td align='right'>10</td>
        </tr>
        <tr>
            <td><code>Request performance</code></td>
            <td><code>request/performanceBucket</code></td>
            <td align='right'>20</td>
        </tr>
        <tr>
            <td><code>Result code</code></td>
            <td><code>request/resultCode</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Successful call</code></td>
            <td><code>dependency/success</code></td>
            <td align='right'>2</td>
        </tr>
    </tbody>
</table>

### [Log-based](#tab/log-based)

#### Dependency calls (dependencies/count)

This metric is in relation to the number of dependency calls.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```kusto
dependencies
| summarize ['dependencies/count_sum'] = sum(itemCount) by bin(timestamp, 15m)
| render barchart
```

#### Dependency duration (dependencies/duration)

This metric refers to duration of dependency calls.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | *Avg*, Min, Max        | All telemetry fields |

```kusto
dependencies
| where notempty(duration)
| extend dependency_duration = iif(itemType == 'dependency', duration, todouble(''))
| extend _sum = dependency_duration
| extend _count = itemCount
| extend _sum = _sum * _count
| summarize ['dependencies/duration_avg'] = sum(_sum) / sum(_count) by bin(timestamp, 15m)
| render timechart
```

#### Server requests (requests/count)

This metric shows the number of incoming server requests your web application receives.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```kusto
requests
| summarize ['requests/count_sum'] = sum(itemCount) by bin(timestamp, 15m)
| render barchart
```

#### Server response time (requests/duration)

This metric reflects the time it took for the servers to process incoming requests.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | *Avg*, Min, Max        | All telemetry fields |

```kusto
requests
| where notempty(duration)
| extend request_duration = iif(itemType == 'request', duration, todouble(''))
| extend _sum = request_duration
| extend _count = itemCount
| extend _sum = _sum * _count
| summarize ['requests/duration_avg'] = sum(_sum) / sum(_count) by bin(timestamp, 15m)
| render timechart
```

---

### Usage metrics

### [Standard](#tab/standard)

#### Page view load time (pageViews/duration)

This metric refers to the amount of time it took for PageView events to load.
<!--
| Unit of measure | Aggregations  | Dimension name<br>(Metrics Explorer) | Dimension name<br>(Log Analytics) | Cardinality limit |
|-----------------|---------------|--------------------------------------|-----------------------------------|------------------:|
| Milliseconds    | Avg, Max, Min |                                      |                                   |                   |
|                 |               | `Cloud role name`                    | `cloud/roleName`                  | 100               |
|                 |               | `Is traffic synthetic`               | `operation/synthetic`             | 10                |
-->
<table>
    <thead>
        <tr>
            <th>Milliseconds</th>
            <th>Avg, Max, Min</th>
            <th>Dimension name<br>(Metrics Explorer)</th>
            <th>Dimension name<br>(Log Analytics)</th>
            <th align='right'>Cardinality limit</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=2>Milliseconds</td>
            <td rowspan=2>Avg, Max, Min</td>
            <td><code>Cloud role name</code></td>
            <td><code>cloud/roleName</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Is traffic synthetic</code></td>
            <td><code>operation/synthetic</code></td>
            <td align='right'>10</td>
        </tr>
    </tbody>
</table>

#### Page views (pageViews/count)

The count of PageView events logged with the TrackPageView() Application Insights API.
<!--
| Unit of measure | Aggregations | Dimension name<br>(Metrics Explorer) | Dimension name<br>(Log Analytics) | Cardinality limit |
|-----------------|--------------|--------------------------------------|-----------------------------------|------------------:|
| Count           | Count        |                                      |                                   |                   |
|                 |              | `Cloud role name`                    | `cloud/roleName`                  | 100               |
|                 |              | `Is traffic synthetic`               | `operation/synthetic`             | 10                |
-->
<table>
    <thead>
        <tr>
            <th>Count</th>
            <th>Count</th>
            <th>Dimension name<br>(Metrics Explorer)</th>
            <th>Dimension name<br>(Log Analytics)</th>
            <th align='right'>Cardinality limit</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=2>Milliseconds</td>
            <td rowspan=2>Avg, Max, Min</td>
            <td><code>Cloud role name</code></td>
            <td><code>cloud/roleName</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Is traffic synthetic</code></td>
            <td><code>operation/synthetic</code></td>
            <td align='right'>10</td>
        </tr>
    </tbody>
</table>

#### Traces (traces/count)

The count of trace statements logged with the TrackTrace() Application Insights API call.
<!--
| Unit of measure | Aggregations | Dimension name<br>(Metrics Explorer) | Dimension name<br>(Log Analytics) | Cardinality limit |
|-----------------|--------------|--------------------------------------|-----------------------------------|------------------:|
| Count           | Count        |                                      |                                   |                   |
|                 |              | `Cloud role instance`                | `cloud/roleInstance`              | 100               |
|                 |              | `Cloud role name`                    | `cloud/roleName`                  | 100               |
|                 |              | `Is traffic synthetic`               | `operation/synthetic`             | 10                |
|                 |              | `Severity level`                     | `trace/severityLevel`             | 100               |
-->
<table>
    <thead>
        <tr>
            <th>Count</th>
            <th>Count</th>
            <th>Dimension name<br>(Metrics Explorer)</th>
            <th>Dimension name<br>(Log Analytics)</th>
            <th align='right'>Cardinality limit</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan=4>Count</td>
            <td rowspan=4>Count</td>
            <td><code>Cloud role instance</code></td>
            <td><code>cloud/roleInstance</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Cloud role name</code></td>
            <td><code>cloud/roleName</code></td>
            <td align='right'>100</td>
        </tr>
        <tr>
            <td><code>Is traffic synthetic</code></td>
            <td><code>operation/synthetic</code></td>
            <td align='right'>10</td>
        </tr>
        <tr>
            <td><code>Severity level</code></td>
            <td><code>trace/severityLevel</code></td>
            <td align='right'>100</td>
        </tr>
    </tbody>
</table>

### [Log-based](#tab/log-based)
<!--
#### Data point count (pageViews/...)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```kusto

```

#### Data point volume (pageViews/...)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```kusto

```
-->
#### Events (customEvents/count)

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```kusto
customEvents
| summarize ['customEvents/count_sum'] = sum(itemCount) by bin(timestamp, 15m)
| render barchart
```

#### Page view load time (pageViews/duration)

This metric refers to the amount of time it took for PageView events to load.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Milliseconds    | *Avg*, Min, Max        | All telemetry fields |

```kusto
pageViews
| where notempty(duration)
| extend pageView_duration = iif(itemType == 'pageView', duration, todouble(''))
| extend _sum = pageView_duration
| extend _count = itemCount
| extend _sum = _sum * _count
| summarize ['pageViews/duration_avg'] = sum(_sum) / sum(_count) by bin(timestamp, 15m)
| render barchart
```

#### Page views (pageViews/count)

The count of PageView events logged with the TrackPageView() Application Insights API.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```kusto
pageViews
| summarize ['pageViews/count_sum'] = sum(itemCount) by bin(timestamp, 15m)
| render barchart
```

#### Sessions (sessions/count)

This metric refers to the count of distinct session identifiers (IDs).

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Unique                 | All telemetry fields |

```kusto
union traces, requests, pageViews, dependencies, customEvents, availabilityResults, exceptions, customMetrics, browserTimings
| where notempty(session_Id)
| summarize ['sessions/count_unique'] = dcount(session_Id) by bin(timestamp, 15m)
| render barchart
```

#### Traces (traces/count)

The count of trace statements logged with the TrackTrace() Application Insights API call.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Sum                    | All telemetry fields |

```kusto
traces
| summarize ['traces/count_sum'] = sum(itemCount) by bin(timestamp, 15m)
| render barchart
```

#### Users (users/count)

The number of distinct users who accessed your application. The accuracy of this metric could be impacted by using telemetry sampling and filtering.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Unique                 | All telemetry fields |

```kusto
union traces, requests, pageViews, dependencies, customEvents, availabilityResults, exceptions, customMetrics, browserTimings
| where notempty(user_Id)
| summarize ['users/count_unique'] = dcount(user_Id) by bin(timestamp, 15m)
| render barchart
```

#### Users, Authenticated (users/authenticated)

The number of distinct users who authenticated into your application.

| Unit of measure | Supported aggregations | Supported dimensions |
|-----------------|------------------------|----------------------|
| Count           | Unique                 | All telemetry fields |

```kusto
union traces, requests, pageViews, dependencies, customEvents, availabilityResults, exceptions, customMetrics, browserTimings
| where notempty(user_AuthenticatedId)
| summarize ['users/authenticated_unique'] = dcount(user_AuthenticatedId) by bin(timestamp, 15m)
| render barchart
```

---

### Custom metrics

### [Standard](#tab/standard)

Not applicable to standard metrics.

### [Log-based](#tab/log-based)

Custom metrics are stored in both the metrics store and logs, making it possible to retrieve them using Kusto queries.

For example, if you instrument your application with `_telemetryClient.GetMetric("Sales Amount").TrackValue(saleAmount);` using [GetMetric](get-metric.md) and [TrackValue](/dotnet/api/microsoft.applicationinsights.metric.trackvalue) to track the custom metric *Sales Amount*, you can use the following Kusto queries for each available aggregation.

#### Average (avg)

```kusto
customMetrics
| where name == "Sales Amount"
| extend
    customMetric_valueSum = iif(itemType == 'customMetric', valueSum, todouble('')),
    customMetric_valueCount = iif(itemType == 'customMetric', valueCount, toint(''))
| summarize ['customMetrics/Sales Amount_avg'] = sum(customMetric_valueSum) / sum(customMetric_valueCount) by bin(timestamp, 15m)
| order by timestamp desc
| render timechart
```

#### Minimum (min)

```kusto
customMetrics
| where name == "Sales Amount"
| extend customMetric_valueMin = iif(itemType == 'customMetric', valueMin, todouble(''))
| summarize ['customMetrics/Sales Amount_min'] = min(customMetric_valueMin) by bin(timestamp, 15m)
| render timechart
```

#### Maximum (max)

```kusto
customMetrics
| where name == "Sales Amount"
| extend customMetric_valueMax = iif(itemType == 'customMetric', valueMax, todouble(''))
| summarize ['customMetrics/Sales Amount_max'] = max(customMetric_valueMax) by bin(timestamp, 15m)
| render timechart
```

#### Sum (sum)

```kusto
customMetrics
| where name == "Sales Amount"
| extend customMetric_valueSum = iif(itemType == 'customMetric', valueSum, todouble(''))
| summarize ['customMetrics/Sales Amount_sum'] = sum(customMetric_valueSum) by bin(timestamp, 15m)
| render barchart
```

#### Count (count)

```kusto
customMetrics
| where name == "Sales Amount"
| extend customMetric_valueCount = iif(itemType == 'customMetric', valueCount, toint(''))
| summarize ['customMetrics/Sales Amount_count'] = sum(customMetric_valueCount) by bin(timestamp, 15m)
| render barchart
```

#### Unique (unique)

```kusto
customMetrics
| where name == "Sales Amount"
| extend customMetric_value = iif(itemType == 'customMetric', value, todouble(''))
| summarize ['customMetrics/Sales Amount_unique'] = dcount(customMetric_value) by bin(timestamp, 15m)
| render barchart
```

---

## Access log-based metrics directly with the Application Insights REST API

The Application Insights REST API enables programmatic retrieval of log-based metrics. It also features an optional parameter `ai.include-query-payload` that when added to a query string, prompts the API to return not only the time series data, but also the Kusto Query Language (KQL) statement used to fetch it. This parameter can be beneficial for users aiming to comprehend the connection between raw events in Log Analytics and the resulting log-based metric.

To access your data directly, pass the parameter `ai.include-query-payload` to the Application Insights API in a query using KQL.

> [!NOTE]
> To retrieve the underlying logs query, `DEMO_APP` and `DEMO_KEY` ***don't*** have to be replaced. If you just want to retrieve the KQL statement and not the time series data of your own application, you can copy and paste it directly into your browser search bar.

```Kusto
api.applicationinsights.io/v1/apps/DEMO_APP/metrics/users/authenticated?api_key=DEMO_KEY&prefer=ai.include-query-payload
```

This example shows a return KQL statement for the metric `Authenticated Users`. In this example, `"users/authenticated"` is the metric ID.

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
* [GetMetric and TrackValue](api-custom-events-metrics.md#getmetric)
