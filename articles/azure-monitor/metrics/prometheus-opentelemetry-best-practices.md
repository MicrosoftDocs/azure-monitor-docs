---
title: PromQL best practices for OpenTelemetry metrics
description: Learn best practices for querying OpenTelemetry metrics using PromQL in Azure Monitor, including UTF-8 character handling and temporality considerations.
ms.topic: conceptual
ms.date: 11/07/2025
ms.reviewer: yagil
author: tylerkight
ms.author: tylerkight
---

# PromQL best practices for OpenTelemetry metrics

This article provides best practices for querying OpenTelemetry metrics using Prometheus Query Language (PromQL) in Azure Monitor. OpenTelemetry metrics have unique characteristics that require specific considerations when writing PromQL queries, particularly around character encoding, metric naming, and data temporality.

## Prerequisites

- An Azure Monitor workspace with OpenTelemetry metrics ingestion configured
- Familiarity with [PromQL basics](prometheus-api-promql.md)
- Understanding of [OpenTelemetry metric conventions](https://opentelemetry.io/docs/specs/semconv/general/metrics/)
- Basic knowledge of [Prometheus querying](https://prometheus.io/docs/prometheus/latest/querying/basics/)

## Key differences between Prometheus and OpenTelemetry metrics

OpenTelemetry metrics differ from traditional Prometheus metrics in several important ways that affect how you write PromQL queries:

### Metric naming and character encoding

OpenTelemetry metrics often contain characters that require special handling in PromQL:

- **Dots in metric names**: OpenTelemetry uses dots (`.`) in metric names like `http.server.duration`
- **Special characters in labels**: Resource attributes may contain non-alphanumeric characters
- **UTF-8 encoding**: With [Prometheus 3.0](https://prometheus.io/blog/2024/11/21/prometheus-3-0-release/), full UTF-8 support enables querying without character escaping

### Data model differences

| Aspect | Prometheus (Legacy) | OpenTelemetry |
|--------|-------------------|---------------|
| **Aggregation temporality** | Cumulative only | Cumulative or Delta |
| **Histogram buckets** | Explicit buckets with `le` labels | Exponential buckets or explicit buckets |
| **Rate calculations** | Always use `rate()` or `increase()` | Depends on temporality |
| **Metric suffixes** | Manual (`_total`, `_bucket`) | Automatic based on instrument type |

## UTF-8 character escaping for OpenTelemetry metrics

### Prometheus 3.0 and later (Recommended)

With [Prometheus 3.0's UTF-8 support](https://prometheus.io/blog/2024/11/21/prometheus-3-0-release/), you can query OpenTelemetry metrics directly using their original names:

```promql
# Direct querying with UTF-8 support using curly braces
{"http.server.duration"}

# Query with complex label names
{"process.runtime.jvm.memory.usage"}{
  "service.name"="my-service",
  "jvm.memory.type"="heap"
}
```

### Legacy Prometheus versions

For older Prometheus versions, use the `__name__` label to query metrics with special characters:

```promql
# Using __name__ for metrics with dots
{__name__="http.server.duration"}

# Combining with other label selectors
{__name__="http.server.duration", job="my-app"}
```

### Common OpenTelemetry metric name patterns

OpenTelemetry metrics follow [semantic conventions](https://opentelemetry.io/docs/specs/semconv/general/metrics/) that often include dots:

```promql
# HTTP metrics
{"http.server.duration"}
{"http.client.request.size"}

# System metrics  
{"system.cpu.utilization"}
{"system.memory.usage"}

# Runtime metrics
{"process.runtime.jvm.memory.usage"}
{"process.runtime.go.gc.duration"}
```

## Handling aggregation temporality

One of the most critical differences when querying OpenTelemetry metrics is understanding aggregation temporality.

### Cumulative temporality

Cumulative metrics work like traditional Prometheus counters and require [rate calculations](https://prometheus.io/docs/prometheus/latest/querying/functions/#rate):

```promql
# For cumulative HTTP request counts
rate({"http.server.request.count"}[5m])

# For cumulative HTTP durations (histograms)
rate({"http.server.duration_sum"}[5m]) / 
rate({"http.server.duration_count"}[5m])
```

### Delta temporality

Delta metrics represent changes since the last measurement and **should not** use `rate()` or `increase()`:

```promql
# For delta HTTP request counts - NO rate() needed
{"http.server.request.count"}

# For delta HTTP durations 
{"http.server.duration_sum"} / {"http.server.duration_count"}
```

### Determining temporality

Unfortunately, PromQL cannot automatically detect temporality. You need to know your data source:

- **Prometheus**: Typically sends cumulative metrics
- **OpenTelemetry**: Mixed, depends on the SDK and configuration
- **Custom exporters**: Check your exporter documentation

### Best practices for temporality

1. **Document your data sources** - Keep track of which metrics use which temporality
2. **Use consistent naming** - Consider adding temporality hints to your metric names
3. **Create separate dashboards** - Build different views for cumulative vs. delta metrics
4. **Test your queries** - Verify that rate calculations produce expected results vs. raw values

## Histogram query patterns

OpenTelemetry histograms can use different bucket strategies. Azure Monitor's managed Prometheus implementation provides enhanced support for histogram functions across different histogram types.

### Supported histogram functions

| Function | OTLP Explicit Histograms | Prometheus Native Histograms/OTLP Exponential Histograms | Prometheus Legacy Histograms |
|----------|-------------------------|----------------------------------------------------------|------------------------------|
| `histogram_quantile` | `histogram_quantile(0.9, sum by (cluster, le) (rate({"http.request.duration"}[5m])))` <br/>Note: `le` is an imaginary label only present during query time | `histogram_quantile(0.9, sum by (cluster) (rate({"http.request.duration"}[5m])))` | `histogram_quantile(0.9, sum by (cluster, le) (rate({"http.request.duration_bucket"}[5m])))` |
| `histogram_avg` | `histogram_avg(rate({"http.request.duration"}[5m]))` | `histogram_avg(rate({"http.request.duration"}[5m]))` | Not supported |
| `histogram_count` | `histogram_count(rate({"http.request.duration"}[5m]))` | `histogram_count(rate({"http.request.duration"}[5m]))` | Not supported |
| `histogram_sum` | `histogram_sum(rate({"http.request.duration"}[5m]))` | `histogram_sum(rate({"http.request.duration"}[5m]))` | Not supported |
| `histogram_fraction` | Not supported | `histogram_fraction(0, 0.2, rate({"http.request.duration"}[1h]))` | Not supported |
| `histogram_stddev` | Not supported | Supported | Not supported |
| `histogram_stdvar` | Not supported | Supported | Not supported |

> [!NOTE]
> Azure Monitor's managed Prometheus provides enhanced histogram support beyond open-source Prometheus. All histogram functions (`histogram_avg`, `histogram_count`, `histogram_sum`) working on OTLP explicit histograms are Azure-specific enhancements not available in open-source Prometheus today. For standard Prometheus histogram support, see [histogram_quantile](https://prometheus.io/docs/prometheus/latest/querying/functions/#histogram_quantile).

### Azure Monitor histogram implementation details

When querying histogram metrics in Azure Monitor, keep these performance considerations in mind:

1. **Non-histogram functions on histogram metrics**: When you apply a non-histogram function to a histogram metric, the function operates only on the total sum value and does not retrieve bucket values from the data store.

2. **Histogram query costs**: Histogram metrics queried with histogram functions cost at least 10.5 times more than normal counter samples. Consider this when:
   - Performing long lookbacks on histogram data
   - Applying histogram functions on high-cardinality metrics
   - Designing queries that may approach query throttling limits
   
   Use [recording rules](prometheus-rule-groups.md) to pre-aggregate and reduce cardinality before applying histogram functions.

### Explicit histograms (Legacy compatible)

```promql
# Calculate percentiles from explicit buckets - requires 'le' in group by
histogram_quantile(0.99, 
  sum by ("service.name", le) (rate({"http.server.request.duration"}[2m]))
)

# 95th percentile without additional grouping dimensions
histogram_quantile(0.95,
  sum by (le) (rate({"http.server.duration_bucket"}[5m]))
)

# Average duration using histogram_avg (Azure Monitor enhancement)
histogram_avg(rate({"http.server.request.duration"}[5m]))

# Ensure you have the correct temporality:
# - Use rate() for cumulative histograms
# - Use raw values for delta histograms
```

### Exponential histograms

Exponential histograms provide automatic bucket sizing and do not use the 'le' label:

```promql
# Native histogram queries (Prometheus 3.0+) - no 'le' needed
histogram_quantile(0.99,
  sum by ("service.name") (rate({"http.server.request.duration"}[2m]))
)

# 95th percentile without grouping dimensions
histogram_quantile(0.95,
  rate({"http.server.duration"}[5m])
)

# Calculate fraction of requests under 200ms
histogram_fraction(0, 0.2, rate({"http.server.request.duration"}[1h]))
```

## Resource attribute handling

OpenTelemetry resource attributes become PromQL labels but may need special handling:

```promql
# Service identification
{__name__=~"http.*", "service.name"="frontend"}

# Version filtering  
{__name__=~"http.*", "service.version"=~"v1.*"}

# Environment separation
{__name__=~"system.*", "deployment.environment"="production"}
```

## Query optimization tips

### 1. Use efficient label selectors

```promql
# Efficient - specific metric name first
{"http.server.duration"}{"service.name"="frontend"}

# Less efficient - starts with label matching
{"service.name"="frontend", __name__=~"http.*"}
```

### 2. Limit time ranges for high-cardinality metrics

```promql
# Be cautious with broad queries over long time ranges
sum by ("service.name") ({"http.server.duration"}[1h])
```

### 3. Aggregate early when possible

```promql
# Better - aggregate before complex operations
sum(rate({"http.server.request.count"}[5m])) by ("service.name")

# Avoid - complex operations on high cardinality
rate(sum({"http.server.request.count"}[5m]) by ("service.name", "http.method", "http.status_code"))
```

For more information on aggregation operators, see [Prometheus aggregation operators](https://prometheus.io/docs/prometheus/latest/querying/operators/#aggregation-operators).

## Troubleshooting common issues

### Missing metrics with dots in names

**Problem**: Queries return no data for metrics like `http.server.duration`

**Solution**: Use UTF-8 quoting with curly braces or `__name__` selector:

```promql
# Try UTF-8 quoting with curly braces first
{"http.server.duration"}

# Fallback to __name__
{__name__="http.server.duration"}
```

### Incorrect rate calculations

**Problem**: Rate calculations show unexpected spikes or drops

**Solution**: Verify temporality and adjust queries:

```promql
# For cumulative metrics
rate({"http.server.request.count"}[5m])

# For delta metrics (no rate needed)
{"http.server.request.count"}
```

### Label name conflicts

**Problem**: OpenTelemetry resource attributes conflict with Prometheus conventions

**Solution**: Use explicit label selection:

```promql
# Specify the exact label name
{"service.name"="my-service"}

# Avoid regex when possible
{"service.name"!~"other-service"} 
```

## Related content

- [Query Prometheus metrics using the API and PromQL](prometheus-api-promql.md)
- [PromQL for system metrics and performance counters](prometheus-system-metrics-best-practices.md)
- [Azure Monitor workspace overview](azure-monitor-workspace-overview.md)