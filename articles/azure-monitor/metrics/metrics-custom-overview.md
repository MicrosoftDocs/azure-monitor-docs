---
title: Custom metrics in Azure Monitor (preview)
description: Learn about custom metrics in Azure Monitor and how they're modeled.
ms.topic: concept-article
ms.date: 08/07/2026
ms.reviewer: priyamishra
ai-usage: ai-assisted
---

# Custom metrics in Azure Monitor (preview)

Azure provides metrics out of the box. These metrics are called [standard or platform](../reference/metrics-index.md) metrics. Custom metrics are performance indicators or business-specific metrics. You can collect them through your application's telemetry. You can also use the Azure Monitor Agent or an external monitoring system. After you publish custom metrics to Azure Monitor, you can browse, query, and alert on them along with the standard Azure metrics.

> [!NOTE]
> Azure Monitor custom metrics are in public preview. This feature won't be made generally available, because an improved generally available feature achieves the same functionality and more: [Application Insights with OpenTelemetry](../app/app-insights-overview.md). In addition to custom metrics, [OpenTelemetry performance counters](../vm/metrics-opentelemetry-guest.md) from the guest OS of VMs are supported as well.

## Use the generally available replacement

The custom metrics described in this article remain in preview and won't be made generally available. For new solutions, use the generally available OpenTelemetry-based path, which provides the same functionality and more. To get started, see [Application Insights with OpenTelemetry](../app/app-insights-overview.md) and [OpenTelemetry system metrics for virtual machines](../vm/metrics-opentelemetry-guest.md).

## Methods to send custom metrics

Custom metrics can be sent to Azure Monitor via several methods:

* Use the Application Insights SDK to instrument your application by sending custom telemetry to Azure Monitor.
* Install the [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md) on your Windows or Linux Azure virtual machine or virtual machine scale set and use a [data collection rule](../vm/data-collection.md) to send performance counters to Azure Monitor metrics.
* Install the [InfluxData Telegraf agent](../agents/collect-custom-metrics-linux-telegraf.md) on your Azure Linux VM. Send metrics by using the Azure Monitor output plug-in.
* Send custom metrics [directly to the Azure Monitor REST API](metrics-store-custom-rest-api.md).

## Pricing model

Ingesting standard metrics (platform metrics) into an Azure Monitor metrics store is free. Native custom metrics are also free during the preview. Queries to the metrics API incur costs. Because custom metrics remain in preview and won't be made generally available, use the [generally available OpenTelemetry-based replacement](../app/app-insights-overview.md) for a supported billing model. For current metric and query pricing, see the [Azure Monitor pricing page](https://azure.microsoft.com/pricing/details/monitor/).

## Custom metric definitions

Each metric data point you publish contains a namespace, name, and dimension information. The first time you emit a custom metric to Azure Monitor, the service automatically creates a metric definition. You can discover this new metric definition on any resource that the metric is emitted from via the metric definitions. You don't need to predefine a custom metric in Azure Monitor before you emit it.

> [!NOTE]
> Application Insights and the InfluxData Telegraf agent are already configured to emit metric values against the correct regional endpoint and carry all the preceding properties in each emission.

## Using custom metrics

After custom metrics are submitted to Azure Monitor, you can browse through them via the Azure portal and query them via the Azure Monitor REST APIs. You can also create alerts on them to notify you when certain conditions are met.

> [!NOTE]
> You need the [Monitoring Reader](/azure/role-based-access-control/built-in-roles#monitoring-reader) role to view custom metrics.

### Browse your custom metrics via the Azure portal

1. Go to the [Azure portal](https://portal.azure.com).
1. Select the **Monitor** pane.
1. Select **Metrics**.
1. Select a resource that you emit custom metrics against.
1. Select the metrics namespace for your custom metric.
1. Select the custom metric.

For more information on viewing metrics in the Azure portal, see [Analyze metrics with Azure Monitor metrics explorer](analyze-metrics.md).

## Latency and storage retention

Custom metrics are retained for the [same amount of time as platform metrics](data-platform-metrics.md#retention-of-metrics).

A newly added metric or a newly added dimension to a metric might take up to 3 minutes to appear. After the data is in the system, it should appear in less than 30 seconds 99 percent of the time.

If you delete a metric or remove a dimension, the change can take a week to a month to be deleted from the system.

## Quotas and limits

Azure Monitor imposes the following usage limits on custom metrics:

| Category                                                                                | Limit          |
|-----------------------------------------------------------------------------------------|----------------|
| Total active time series in a subscription per region                                   | 50,000         |
| Dimension keys per metric                                                               | 10             |
| String length for metric namespaces, metric names, dimension keys, and dimension values | 256 characters |
| The combined length of all custom metric names, using utf-8 encoding                    | 64 KB          |

An active time series is any unique combination of metric, dimension key, or dimension value that has metric values published in the past 12 hours.

To understand the limit of 50,000 on time series, consider the following metric:

> *Server response time* with Dimensions: *Region*, *Department*, *CustomerID*

With this metric, if you have 10 regions, 20 departments, and 100 customers, that gives you 10 x 20 x 100 = 20,000 time series.

If you have 100 regions, 200 departments, and 2,000 customers, the result is 100 x 200 x 2,000 = 40 million time series. This number is far over the limit for a single metric.

Again, this limit isn't for an individual metric. It's for the sum of all such metrics across a subscription and region.

To see your current total active time series metrics and get more information for troubleshooting, follow these steps.

1. Navigate to the Monitor section of the Azure portal.
1. Select **Metrics** on the left hand side.
1. Under **Select a scope**, check the applicable subscription and resource groups.
1. Under **Refine scope**, choose **Custom Metric Usage** and the desired location.
1. Select the **Apply** button.
1. Choose either **Active Time Series**, **Active Time Series Limit**, or **Throttled Time Series**.

Azure Monitor limits the combined length of all custom metric names to 64 KB, assuming UTF-8 encoding or 1 byte per character. If your metric names exceed this limit, Azure Monitor blocks access to metadata for the other metrics. The Azure portal omits those metric names from selection fields, and the API skips them when it returns metric definitions. You can still query the metric data directly, even without the metadata.

When the limit is exceeded, reduce the number of metrics you're sending or shorten the length of their names. It takes up to two days for the new metrics' names to appear.

To avoid reaching the limit, don't include variable or dimensional aspects in your metric names.
For example, the metrics for server CPU usage,`CPU_server_12345678-319d-4a50-b27e-1234567890ab` and `CPU_server_abcdef01-319d-4a50-b27e-abcdef012345` should be defined as metric `CPU` and with a `Server` dimension.

## Design limitations and considerations

### Using Application Insights for auditing

The Application Insights telemetry pipeline is optimized to minimize the performance impact and limit the network traffic from monitoring your application. As such, it throttles or samples (takes only a percentage of your telemetry and ignores the rest) if the initial dataset becomes too large. Because of this behavior, you can't use it for auditing purposes because some records are likely to be dropped.

### Metrics with a variable in the name

Don't use a variable as part of the metric name. Use a constant instead. Each time the variable changes its value, Azure Monitor generates a new metric. Azure Monitor then quickly hits the limit on the number of metrics. Generally, when developers want to include a variable in the metric name, they really want to track multiple time series within one metric and should use dimensions instead of variable metric names.

### High-cardinality metric dimensions

Metrics with too many valid values in a dimension (a *high cardinality*) are much more likely to hit the 50,000 limit. In general, you should never use a constantly changing value in a dimension. Timestamp, for example, should never be a dimension. You can use server, customer, or product ID, but only if you have a smaller number of each of those types.

As a test, ask yourself if you would ever chart such data on a graph. If you have 10 or maybe even 100 servers, it might be useful to see them all on a graph for comparison. But if you have 1,000, the resulting graph would likely be difficult or impossible to read. A best practice is to keep it to fewer than 100 valid values. Up to 300 is a gray area. If you need to go over this amount, use Azure Monitor custom logs instead.

If you have a variable in the name or a high-cardinality dimension, the following issues can occur:

* Metrics become unreliable because of throttling.
* Metrics explorer doesn't work.
* Alerting and notifications become unpredictable.
* Costs can increase unexpectedly because metric queries are billed. For a supported, generally available billing model, use the [OpenTelemetry-based replacement](../app/app-insights-overview.md).

If the metric name or dimension value is populated with an identifier or high-cardinality dimension by mistake, you can easily fix it by removing the variable part.

But if high cardinality is essential for your scenario, the aggregated metrics are probably not the right choice. Switch to using custom logs (that is, trackMetric API calls with [trackEvent](../app/usage.md#how-to-log-custom-events)). However, consider that logs don't aggregate values, so every single entry is stored. As a result, if you have a large volume of logs in a small time period (1 million a second, for example), it can cause throttling and ingestion delays.

[!INCLUDE [application-insights-metrics-interval](../app/includes/application-insights-metrics-interval.md)]

## Next steps

Use custom metrics from various services:

* [Send custom metrics to Azure Monitor using the REST API](metrics-store-custom-rest-api.md)
* [Collect custom metrics from a virtual machine](../agents/collect-custom-metrics-guestos-resource-manager-vm.md)
* [Collect custom metrics from a Virtual Machine Scale Set](../agents/collect-custom-metrics-guestos-resource-manager-vmss.md)
* [Collect custom metrics from an Azure virtual machine (classic)](../agents/collect-custom-metrics-guestos-vm-classic.md)
* [Collect custom metrics from a Linux virtual machine using the Telegraf agent](../agents/collect-custom-metrics-linux-telegraf.md)
* [Collect custom metrics from a classic cloud service](../agents/collect-custom-metrics-guestos-vm-cloud-service-classic.md)
