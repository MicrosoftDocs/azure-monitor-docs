---
title: Metrics in Azure Monitor
description: Learn about metrics in Azure Monitor, which are lightweight monitoring data capable of supporting near real-time scenarios.
ms.reviewer: priyamishra
ms.topic: concept-article
ms.date: 08/07/2026
ai-usage: ai-assisted
---

# Azure Monitor Metrics overview

Azure Monitor Metrics is a feature of Azure Monitor that collects numeric data from monitored resources into a time-series database. Metrics are numerical values that are collected at regular intervals and describe some aspect of a system at a particular time.

> [!NOTE]
> Azure Monitor Metrics is one half of the data platform that supports Azure Monitor. The other half is [Azure Monitor Logs](../logs/data-platform-logs.md), which collects and organizes log and performance data. You can analyze that data by using a rich query language.

## Types of metrics

There are multiple types of metrics supported by Azure Monitor Metrics:

* Native metrics use tools in Azure Monitor for analysis and alerting.

    * Platform metrics are collected from Azure resources. They require no configuration and have no cost.
    * [Advanced platform metrics](metrics-advanced-platform.md) extend platform metrics with deeper, more granular data for supported resource providers. You explicitly opt in to these metrics at the resource level, and they're a paid feature. Advanced platform metrics are currently in preview.
    * Custom metrics are collected from different sources that you configure including applications and agents running on virtual machines.

* Azure Monitor collects Prometheus metrics from Kubernetes clusters, including Azure Kubernetes Service (AKS). Use industry-standard tools such as PromQL and Grafana to analyze the metrics and create alerts.

:::image type="content" source="media/data-platform-metrics/metrics-overview.png" lightbox="media/data-platform-metrics/metrics-overview.png" alt-text="Diagram that shows sources and uses of metrics.":::

The differences between each of the metrics are summarized in the following table.

| Category | Native platform metrics | Native custom metrics | Prometheus metrics |
|:---------|:------------------------|:----------------------|:-------------------|
| Sources | Azure resources | Azure Monitor Agent<br>Application Insights<br>REST API | Azure Kubernetes Service (AKS) cluster<br>Any Kubernetes cluster through remote-write |
| Configuration | None | Varies by source | Enable Azure Monitor managed service for Prometheus |
| Stored | Subscription | Subscription | [Azure Monitor workspace](azure-monitor-workspace-overview.md) |
| Cost | No charge | No charge during preview | Billed |
| Aggregation | Pre-aggregated | Pre-aggregated | Raw data |
| Analyze | [Metrics explorer](analyze-metrics.md) | [Metrics explorer](analyze-metrics.md) | PromQL<br>Grafana dashboards |
| Alert | [metrics alert rule](../alerts/tutorial-metric-alert.md) | [metrics alert rule](../alerts/tutorial-metric-alert.md) | [Prometheus alert rule](prometheus-rule-groups.md) |
| Visualize | [Workbooks](../visualize/workbooks-overview.md)<br>[Azure dashboards](../app/overview-dashboard.md#create-custom-kpi-dashboards-using-application-insights)<br>[Grafana](../visualize/visualize-grafana-overview.md) | [Workbooks](../visualize/workbooks-overview.md)<br>[Azure dashboards](../app/overview-dashboard.md#create-custom-kpi-dashboards-using-application-insights)<br>[Grafana](../visualize/visualize-grafana-overview.md) | [Grafana](/azure/managed-grafana/overview) |
| Retrieve | Client libraries and CLIs (listed after this table) | Client libraries and CLIs (listed after this table) | [Grafana](/azure/managed-grafana/overview) |

Use the following client libraries and command-line tools to retrieve native platform and native custom metrics:

* [Azure CLI](/cli/azure/monitor/metrics)
* [Azure PowerShell cmdlets](/powershell/module/az.monitor)
* [REST API](../platform/rest-api-walkthrough.md) or client library
* [.NET](/dotnet/api/overview/azure/Monitor.Query-readme)
* [Go](https://pkg.go.dev/github.com/Azure/azure-sdk-for-go/sdk/monitor/query/azmetrics)
* [Java](/java/api/overview/azure/monitor-query-readme)
* [JavaScript](/javascript/api/overview/azure/monitor-query-readme)
* [Python](/python/api/overview/azure/monitor-query-readme)

## Data collection

Azure Monitor collects metrics from the following sources. After these metrics are collected in the Azure Monitor metric database, they can be evaluated together regardless of their source:

* **Azure resources**: Azure resources create platform metrics that give you visibility into their health and performance. Each type of resource creates a [distinct set of metrics](../reference/metrics-index.md) without any configuration required. Azure Monitor collects platform metrics from Azure resources at a one-minute frequency unless the metric's definition specifies otherwise.
* **Applications**: Application Insights creates metrics for your monitored applications to help you detect performance issues and track trends in how your application is being used. Values include *Server response time* and *Browser exceptions*.
* **Virtual machine agents**: Metrics are collected from the guest operating system of a virtual machine. You can enable guest OS metrics for Windows virtual machines by using the [Azure Monitor Agent](/azure/azure-monitor/agents/agents-overview). Azure Monitor Agent replaces the legacy agents - [Windows diagnostic extension](../agents/diagnostics-extension-overview.md) and the [InfluxData Telegraf agent](https://www.influxdata.com/time-series-platform/telegraf/) for Linux virtual machines.
* **Custom metrics**: Define metrics in addition to the standard metrics that are automatically available. [Define custom metrics in an application](../app/metrics-overview.md#custom-metrics-preview) monitored by Application Insights, or create custom metrics for an Azure service by using the [custom metrics API](metrics-store-custom-rest-api.md).
* **Kubernetes clusters**: Kubernetes clusters typically send metric data to a local Prometheus server that you must maintain. [Azure Monitor managed service for Prometheus](prometheus-metrics-overview.md) provides a managed service that collects metrics from Kubernetes clusters and stores them in Azure Monitor Metrics.

> [!NOTE]
> Metrics from different sources and collection methods might use different aggregations. For example, platform metrics are pre-aggregated and stored in a time-series database, while Prometheus metrics are stored as raw data. Resource metrics might also have a different latency than other metrics. Differences in aggregation and latency can lead to different metric values for a specific sample time. Over time when latency ceases to be an issue, and when analyzing the metrics at the same time granularity, these differences disappear. For specific latency expectations for platform metrics exported via diagnostic settings, see [Log data ingestion time in Azure Monitor](../logs/data-ingestion-time.md#azure-metrics-resource-logs-activity-logs).

## REST API

Azure Monitor provides REST APIs that allow you to get data in and out of Azure Monitor Metrics.
* **Custom metrics API** - [Custom metrics](metrics-custom-overview.md) allow you to load your own metrics into the Azure Monitor Metrics database. The same analysis tools that process Azure Monitor platform metrics can then use those metrics.
* **Azure Monitor Metrics REST API** - Allows you to access Azure Monitor platform metrics definitions and values. For more information, see [Azure Monitor REST API](/rest/api/monitor/metrics/list). For information on how to use the API, see the [Azure monitoring REST API walkthrough](../platform/rest-api-walkthrough.md).
* **Azure Monitor Metrics Batch REST API** - [Azure Monitor Metrics Batch API](/rest/api/monitor/metrics-batch/) is a high-volume API designed for customers with large volume metrics queries. It's similar to the existing standard Azure Monitor Metrics REST API, but provides the capability to retrieve metric data for up to 50 resource IDs in the same subscription and region in a single batch API call. This improves query throughput and reduces the risk of throttling.

## Security

All communication between connected systems and the Azure Monitor service is encrypted using the TLS 1.2 (HTTPS) protocol. The Microsoft SDL process is followed to ensure all Azure services are up-to-date with the most recent advances in cryptographic protocols.

Secure connection is established between the agent and the Azure Monitor service using certificate-based authentication and TLS with port 443. Azure Monitor uses a secret store to generate and maintain keys. Private keys are rotated every 90 days and are stored in Azure and are managed by the Azure operations who follow strict regulatory and compliance practices. For more information on security, see [Encryption of data in transit](/azure/security/fundamentals/encryption-overview#encryption-of-data-in-transit), [Encryption of data at rest](/azure/security/fundamentals/encryption-atrest), and [Azure Monitor security overview and guidelines](../fundamentals/best-practices-security.md).

## Metrics explorer

Use [Metrics explorer](analyze-metrics.md) to interactively analyze the data in your metric database and chart the values of multiple metrics over time. Pin the charts to a dashboard to view them with other visualizations. Retrieve metrics by using the [Azure monitoring REST API](../platform/rest-api-walkthrough.md).
<!-- convertborder later -->
:::image type="content" source="media/data-platform-metrics/metrics-explorer.png" lightbox="media/data-platform-metrics/metrics-explorer.png" alt-text="Screenshot that shows an example graph in Metrics explorer that displays server requests, server response time, and failed requests." border="false":::

For more information, see [Analyze metrics with Azure Monitor metrics explorer](analyze-metrics.md).

## Data structure

Data that Azure Monitor Metrics collects, is stored in a time-series database that's optimized for analyzing time-stamped data. Each set of metric values is a time series with the following properties:

* The time when the value was collected.
* The resource that the value is associated with.
* A namespace that acts like a category for the metric.
* A metric name.
* The value itself.
* [Multiple dimensions](#multi-dimensional-metrics) when they're present. Custom metrics are limited to 10 dimensions.

## Multi-dimensional metrics

One of the challenges to metric data is that it often has limited information to provide context for collected values. Azure Monitor addresses this challenge with multi-dimensional metrics.

Metric dimensions are name/value pairs that carry more data to describe the metric value. For example, a metric called *Available disk space* might have a dimension called *Drive* with values *C:* and *D:*. That dimension would allow viewing available disk space across all drives or for each drive individually.

See [Apply dimension filters and splitting](analyze-metrics.md?#use-dimension-filters-and-splitting) for details on viewing metric dimensions in metrics explorer.

### Nondimensional metric

The following table shows sample data from a nondimensional metric, network throughput. It can only answer a basic question like "What was my network throughput at a given time?"

| Timestamp     | Metric value |
| ------------- |:-------------|
| 8/9/2017 8:14 | 1,331.8 Kbps |
| 8/9/2017 8:15 | 1,141.4 Kbps |
| 8/9/2017 8:16 | 1,110.2 Kbps |

### Network throughput and two dimensions ("IP" and "Direction")

The following table shows sample data from a multidimensional metric, network throughput with two dimensions called *IP* and *Direction*. It can answer questions such as "What was the network throughput for each IP address?" and "How much data was sent versus received?"

| Timestamp     | Dimension "IP"   | Dimension "Direction" | Metric value |
|---------------|:-----------------|:----------------------|:-------------|
| 8/9/2017 8:14 | IP="192.168.5.2" | Direction="Send"      | 646.5 Kbps   |
| 8/9/2017 8:14 | IP="192.168.5.2" | Direction="Receive"   | 420.1 Kbps   |
| 8/9/2017 8:14 | IP="10.24.2.15"  | Direction="Send"      | 150.0 Kbps   |
| 8/9/2017 8:14 | IP="10.24.2.15"  | Direction="Receive"   | 115.2 Kbps   |
| 8/9/2017 8:15 | IP="192.168.5.2" | Direction="Send"      | 515.2 Kbps   |
| 8/9/2017 8:15 | IP="192.168.5.2" | Direction="Receive"   | 371.1 Kbps   |
| 8/9/2017 8:15 | IP="10.24.2.15"  | Direction="Send"      | 155.0 Kbps   |
| 8/9/2017 8:15 | IP="10.24.2.15"  | Direction="Receive"   | 100.1 Kbps   |

> [!NOTE]
> Dimension names and dimension values are case-insensitive.

## Retention of metrics

### Platform and custom metrics

Platform and custom metrics are stored for **93 days** with the following exceptions:

* **Classic guest OS metrics**: These performance counters are collected by the [Windows diagnostic extension](../agents/diagnostics-extension-overview.md) or the [Linux diagnostic extension](/azure/virtual-machines/extensions/diagnostics-linux) and routed to an Azure Storage account. Retention for these metrics is guaranteed to be at least 14 days, although no expiration date is written to the storage account.

    For performance reasons, the portal limits how much data it displays based on volume. So, the actual number of days that the portal retrieves can be longer than 14 days if the volume of data being written isn't large.

* **Guest OS metrics sent to Azure Monitor Metrics**: These performance counters are collected by the [Windows diagnostic extension](../agents/diagnostics-extension-overview.md) and sent to the [Azure Monitor data sink](../agents/diagnostics-extension-overview.md#data-destinations), or the [InfluxData Telegraf agent](https://www.influxdata.com/time-series-platform/telegraf/) on Linux machines, or the newer [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md) via data-collection rules. Retention for these metrics is 93 days.

* **Guest OS metrics collected by the Log Analytics agent (retired)**: The Log Analytics agent was retired in August 2024. Don't deploy it for new metric collection. Use the [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md) instead. For legacy deployments, the Log Analytics agent collected these performance counters and sent them to a Log Analytics workspace. Retention is 31 days and can be extended up to two years.

* **Application Insights log-based metrics**: Behind the scenes, [log-based metrics](../app/metrics-overview.md#log-based-metrics) translate into log queries. Their retention is variable and matches the retention of events in underlying logs, which is 31 days to two years. For Application Insights resources, logs are stored for 90 days.

> [!NOTE]
> You can [send platform metrics for Azure Monitor resources to a Log Analytics workspace](../platform/diagnostic-settings.md) for long-term trending.

While platform and custom metrics are stored for 93 days, you can only query (in the **Metrics** tile) for a maximum of 30 days' worth of data on any single chart. This limitation doesn't apply to log-based metrics. If you see a blank chart or your chart displays only part of metric data, verify that the difference between start and end dates in the time picker doesn't exceed the 30-day interval. After you've selected a 30-day interval, you can [pan](analyze-metrics.md#pan-across-metrics-data) the chart to view the full retention window.

> [!NOTE]
> Moving or renaming an Azure Resource may result in a loss of metric history for that resource.

### Prometheus metrics

Prometheus metrics are stored for **18 months**, but a PromQL query can only span a maximum of 32 days.

## Next steps

* Learn more about the [Azure Monitor data platform](../fundamentals/data-platform.md).
* Learn about [log data in Azure Monitor](../logs/data-platform-logs.md).
* Learn about the [monitoring data available](../fundamentals/data-sources.md) for various resources in Azure.
