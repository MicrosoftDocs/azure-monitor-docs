---
title: Log-based and preaggregated metrics in Application Insights | Microsoft Docs
description: This article explains when to use log-based versus preaggregated metrics in Application Insights.
ms.topic: conceptual
ms.date: 01/31/2024
ms.reviewer: vitalyg
---

<!-- This document will be replaced by a general metrics overview doc, and certain sections moved to log-based, standard, and custom metrics-specific articles -->

# Log-based and preaggregated metrics in Application Insights

[!INCLUDE [azure-monitor-app-insights-otel-available-notification](../includes/azure-monitor-app-insights-otel-available-notification.md)]


<!-- Moved to metrics-overview.md

This article explains the difference between "traditional" Application Insights metrics that are based on logs and preaggregated metrics. Both types of metrics are available to users of Application Insights. Each one brings a unique value in monitoring application health, diagnostics, and analytics. The developers who are instrumenting applications can decide which type of metric is best suited to a particular scenario. Decisions are based on the size of the application, expected volume of telemetry, and business requirements for metrics precision and alerting.

-->


<!-- Moved to metrics-overview.md

## Log-based metrics

In the past, the application monitoring telemetry data model in Application Insights was solely based on a few predefined types of events, such as requests, exceptions, dependency calls, and page views. Developers can use the SDK to emit these events manually by writing code that explicitly invokes the SDK. Or they can rely on the automatic collection of events from autoinstrumentation. In either case, the Application Insights back end stores all collected events as logs. The Application Insights panes in the Azure portal act as an analytical and diagnostic tool for visualizing event-based data from logs.

Using logs to retain a complete set of events can bring great analytical and diagnostic value. For example, you can get an exact count of requests to a particular URL with the number of distinct users who made these calls. Or you can get detailed diagnostic traces, including exceptions and dependency calls for any user session. Having this type of information can improve visibility into the application health and usage. It can also cut down the time necessary to diagnose issues with an app.

At the same time, collecting a complete set of events might be impractical or even impossible for applications that generate a large volume of telemetry. For situations when the volume of events is too high, Application Insights implements several telemetry volume reduction techniques that reduce the number of collected and stored events. These techniques include [sampling](./sampling.md) and [filtering](./api-filtering-sampling.md). Unfortunately, lowering the number of stored events also lowers the accuracy of the metrics that, behind the scenes, must perform query-time aggregations of the events stored in logs.

> [!NOTE]
> In Application Insights, the metrics that are based on the query-time aggregation of events and measurements stored in logs are called log-based metrics. These metrics typically have many dimensions from the event properties, which makes them superior for analytics. The accuracy of these metrics is negatively affected by sampling and filtering.

-->


<!-- Moved to metrics-overview.md

## Preaggregated metrics

In addition to log-based metrics, in late 2018, the Application Insights team shipped a public preview of metrics that are stored in a specialized repository that's optimized for time series. The new metrics are no longer kept as individual events with lots of properties. Instead, they're stored as preaggregated time series, and only with key dimensions. This change makes the new metrics superior at query time. Retrieving data happens faster and requires less compute power. As a result, new scenarios are enabled, such as [near real time alerting on dimensions of metrics](../alerts/alerts-metric-near-real-time.md) and more responsive [dashboards](./overview-dashboard.md).

> [!IMPORTANT]
> Both log-based and preaggregated metrics coexist in Application Insights. To differentiate the two, in the Application Insights user experience the preaggregated metrics are now called standard metrics. The traditional metrics from the events were renamed to log-based metrics.

The newer SDKs ([Application Insights 2.7](https://www.nuget.org/packages/Microsoft.ApplicationInsights/2.7.2) SDK or later for .NET) preaggregate metrics during collection. This process applies to [standard metrics sent by default](../essentials/metrics-supported.md#microsoftinsightscomponents), so the accuracy isn't affected by sampling or filtering. It also applies to custom metrics sent by using [GetMetric](./api-custom-events-metrics.md#getmetric), which results in less data ingestion and lower cost.

For the SDKs that don't implement preaggregation (that is, older versions of Application Insights SDKs or for browser instrumentation), the Application Insights back end still populates the new metrics by aggregating the events received by the Application Insights event collection endpoint. Although you don't benefit from the reduced volume of data transmitted over the wire, you can still use the preaggregated metrics and experience better performance and support of the near real time dimensional alerting with SDKs that don't preaggregate metrics during collection.

The collection endpoint preaggregates events before ingestion sampling. For this reason, [ingestion sampling](./sampling.md) never affects the accuracy of preaggregated metrics, regardless of the SDK version you use with your application.

-->


<!-- Moved to standard-metrics.md

### SDK supported preaggregated metrics table

| Current production SDKs | Standard metrics (SDK preaggregation) | Custom metrics (without SDK preaggregation) | Custom metrics (with SDK preaggregation)|
|------------------------------|-----------------------------------|----------------------------------------------|---------------------------------------|
| .NET Core and .NET Framework | Supported (V2.13.1+)| Supported via [TrackMetric](api-custom-events-metrics.md#trackmetric)| Supported (V2.7.2+) via [GetMetric](get-metric.md) |
| Java                         | Not supported       | Supported via [TrackMetric](api-custom-events-metrics.md#trackmetric)| Not supported                           |
| Node.js                      | Supported (V2.0.0+) | Supported via [TrackMetric](api-custom-events-metrics.md#trackmetric)| Not supported                           |
| Python                       | Not supported       | Supported                                 | Partially supported via [OpenCensus.stats](/previous-versions/azure/azure-monitor/app/opencensus-python#metrics) |  

> [!NOTE]
> The metrics implementation for Python by using OpenCensus.stats is different from GetMetric. For more information, see the [Python documentation on metrics](/previous-versions/azure/azure-monitor/app/opencensus-python#metrics).

### Codeless supported preaggregated metrics table

| Current production SDKs | Standard metrics (SDK preaggregation) | Custom metrics (without SDK preaggregation) | Custom metrics (with SDK preaggregation)|
|-------------------------|--------------------------|-------------------------------------------|-----------------------------------------|
| ASP.NET                 | Supported <sup>1<sup>    | Not supported                             | Not supported                           |
| ASP.NET Core            | Supported <sup>2<sup>    | Not supported                             | Not supported                           |
| Java                    | Not supported            | Not supported                             | [Supported](opentelemetry-add-modify.md?tabs=java#send-custom-telemetry-using-the-application-insights-classic-api) |
| Node.js                 | Not supported            | Not supported                             | Not supported                           |

1. [ASP.NET autoinstrumentation on virtual machines/virtual machine scale sets](./azure-vm-vmss-apps.md) and [on-premises](./application-insights-asp-net-agent.md) emits standard metrics without dimensions. The same is true for Azure App Service, but the collection level must be set to recommended. The SDK is required for all dimensions.
2. [ASP.NET Core autoinstrumentation on App Service](./azure-web-apps-net-core.md) emits standard metrics without dimensions. SDK is required for all dimensions.

## Use preaggregation with Application Insights custom metrics

You can use preaggregation with custom metrics. The two main benefits are: 

- Configure and alert on a dimension of a custom metric
- Reduce the volume of data sent from the SDK to the Application Insights collection endpoint

There are several [ways of sending custom metrics from the Application Insights SDK](./api-custom-events-metrics.md). If your version of the SDK offers [GetMetric and TrackValue](./api-custom-events-metrics.md#getmetric), these methods are the preferred way of sending custom metrics. In this case, preaggregation happens inside the SDK. This approach reduces the volume of data stored in Azure and also the volume of data transmitted from the SDK to Application Insights. Otherwise, use the [trackMetric](./api-custom-events-metrics.md#trackmetric) method, which preaggregates metric events during data ingestion.

-->


## Custom metrics dimensions and preaggregation

All metrics that you send using [OpenTelemetry](opentelemetry-add-modify.md), [trackMetric](./api-custom-events-metrics.md#trackmetric), or [GetMetric and TrackValue](./api-custom-events-metrics.md#getmetric) API calls are automatically stored in both logs and metrics stores. These metrics can be found in the customMetrics table in Application Insights and in Metrics Explorer under the Custom Metric Namespace called "azure.applicationinsights". Although the log-based version of your custom metric always retains all dimensions, the preaggregated version of the metric is stored by default with no dimensions. Retaining dimensions of custom metrics is a Preview feature that can be turned on from the [Usage and estimated cost](../cost-usage.md#usage-and-estimated-costs) tab by selecting **With dimensions** under **Send custom metrics to Azure Metric Store**.

:::image type="content" source="./media/pre-aggregated-metrics-log-metrics/001-cost.png" lightbox="./media/pre-aggregated-metrics-log-metrics/001-cost.png" alt-text="Screenshot that shows usage and estimated costs.":::


<!-- Moved to standard-metrics.md

## Quotas

Preaggregated metrics are stored as time series in Azure Monitor. [Azure Monitor quotas on custom metrics](../essentials/metrics-custom-overview.md#quotas-and-limits) apply.

> [!NOTE]
> Going over the quota might have unintended consequences. Azure Monitor might become unreliable in your subscription or region. To learn how to avoid exceeding the quota, see [Design limitations and considerations](../essentials/metrics-custom-overview.md#design-limitations-and-considerations).

-->


## Why is collection of custom metrics dimensions turned off by default?

The collection of custom metrics dimensions is turned off by default because in the future storing custom metrics with dimensions will be billed separately from Application Insights. Storing the nondimensional custom metrics remain free (up to a quota). You can learn about the upcoming pricing model changes on our official [pricing page](https://azure.microsoft.com/pricing/details/monitor/).


<!-- Moved to metrics-overview.md

## Create charts and explore log-based and standard preaggregated metrics

Use [Azure Monitor metrics explorer](../essentials/metrics-getting-started.md) to plot charts from preaggregated and log-based metrics and to author dashboards with charts. After you select the Application Insights resource you want, use the namespace picker to switch between standard and log-based metrics. You can also select a custom metric namespace.

:::image type="content" source="./media/pre-aggregated-metrics-log-metrics/002-metric-namespace.png" lightbox="./media/pre-aggregated-metrics-log-metrics/002-metric-namespace.png" alt-text="Screenshot that shows Metric namespace.":::

-->


<!-- Moved to metrics-overview.md

## Pricing models for Application Insights metrics

Ingesting metrics into Application Insights, whether log-based or preaggregated, generates costs based on the size of the ingested data. For more information, see [Azure Monitor Logs pricing details](../logs/cost-logs.md#application-insights-billing). Your custom metrics, including all its dimensions, are always stored in the Application Insights log store. Also, a preaggregated version of your custom metrics with no dimensions is forwarded to the metrics store by default.

Selecting the [Enable alerting on custom metric dimensions](#custom-metrics-dimensions-and-preaggregation) option to store all dimensions of the preaggregated metrics in the metric store can generate *extra costs* based on [custom metrics pricing](https://azure.microsoft.com/pricing/details/monitor/).

-->


## Next steps

* [Metrics - Get - REST API](/rest/api/application-insights/metrics/get)
* [Application Insights API for custom events and metrics](api-custom-events-metrics.md)
* [Near real time alerting](../alerts/alerts-metric-near-real-time.md)
* [GetMetric and TrackValue](./api-custom-events-metrics.md#getmetric)
