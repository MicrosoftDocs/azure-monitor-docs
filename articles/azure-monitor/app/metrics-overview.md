---
title: Metrics in Application Insights - Azure Monitor | Microsoft Docs
description: This article explains the difference between log-based and standard/preaggregated metrics in Application Insights.
ms.topic: conceptual
ms.date: 09/06/2024
ms.reviewer: vitalyg
---

# Metrics in Application Insights

Application Insights supports three different types of metrics: standard (preaggregated), log-based, and custom metrics. Each one brings a unique value in monitoring application health, diagnostics, and analytics. Developers who are instrumenting applications can decide which type of metric is best suited to a particular scenario. Decisions are based on the size of the application, expected volume of telemetry, and business requirements for metrics precision and alerting. This article explains the difference between all supported metrics types.

* **Standard metrics:** Standard metrics in Application Insights are predefined metrics which are automatically collected and monitored by the service. These metrics cover a wide range of performance and usage indicators, such as CPU usage, memory consumption, request rates, and response times. Standard metrics provide a comprehensive overview of your application's health and performance without requiring any additional configuration. Standard metrics are preaggregated during collection, giving them better performance at query time. This makes them the best choice for dashboards and real-time alerting.
    
    For more information, see [Application Insights standard metrics](standard-metrics.md)

* **Log-based metrics:** Log-based metrics in Application Insights are a query-time concept, represented as a time series on top of the log data of your application. The underlying logs aren't preaggregated at the collection or storage time and retain all properties of each log entry. This makes it possible to use log properties as dimensions on log-based metrics at a query time for [metric chart filtering](../essentials/analyze-metrics.md#add-filters) and [metric splitting](../essentials/analyze-metrics.md#apply-metric-splitting), giving log-based metrics superior analytical and diagnostic value. However, telemetry volume reduction techniques such as [sampling](sampling-classic-api.md) and [telemetry filtering](api-filtering-sampling.md#filtering) commonly used with monitoring large applications impacts the quantity of the collected log entries and therefore reduce the accuracy of log-based metrics.

    For more information, see [Application Insights log-based metrics](../essentials/app-insights-metrics.md).

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

## Create charts and explore metrics

Use [Azure Monitor metrics explorer](../essentials/metrics-getting-started.md) to plot charts from preaggregated, log-based, and custom metrics, and to author dashboards with charts. After you select the Application Insights resource you want, use the namespace picker to switch between metrics.

:::image type="content" source="./../essentials/media/metrics-custom-overview/002-metric-namespace.png" lightbox="./../essentials/media/metrics-custom-overview/002-metric-namespace.png" alt-text="Screenshot that shows Metric namespace.":::

## Pricing models for Application Insights metrics

Ingesting metrics into Application Insights, whether log-based or preaggregated, generates costs based on the size of the ingested data. For more information, see [Azure Monitor Logs pricing details](../logs/cost-logs.md#application-insights-billing). Your custom metrics, including all its dimensions, are always stored in the Application Insights log store. Also, a preaggregated version of your custom metrics with no dimensions is forwarded to the metrics store by default.

Selecting the [Enable alerting on custom metric dimensions](./../essentials/metrics-custom-overview.md#custom-metrics-dimensions-and-preaggregation) option to store all dimensions of the preaggregated metrics in the metric store can generate *extra costs* based on [custom metrics pricing](https://azure.microsoft.com/pricing/details/monitor/).

## Next steps

* [Metrics - Get - REST API](/rest/api/application-insights/metrics/get)
* [Application Insights API for custom events and metrics](api-custom-events-metrics.md)
* [Near real time alerting](../alerts/alerts-metric-near-real-time.md)
* [GetMetric and TrackValue](./api-custom-events-metrics.md#getmetric)
