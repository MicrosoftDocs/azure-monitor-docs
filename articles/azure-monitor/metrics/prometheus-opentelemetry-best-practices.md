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
- Understanding of OpenTelemetry metric conventions

## Key differences between Prometheus and OpenTelemetry metrics

OpenTelemetry metrics differ from traditional Prometheus metrics in several important ways that affect how you write PromQL queries:

### Metric naming and character encoding

OpenTelemetry metrics often contain characters that require special handling in PromQL:

- **Dots in metric names**: OpenTelemetry uses dots (`.`) in metric names like `http.server.duration`
- **Special characters in labels**: Resource attributes may contain non-alphanumeric characters
- **UTF-8 encoding**: With Prometheus 3.0, full UTF-8 support enables querying without character escaping

### Data model differences

| Aspect | Prometheus (Legacy) | OpenTelemetry |
|--------|-------------------|---------------|
| **Aggregation temporality** | Cumulative only | Cumulative or Delta |
| **Histogram buckets** | Explicit buckets with `le` labels | Exponential buckets or explicit buckets |
| **Rate calculations** | Always use `rate()` or `increase()` | Depends on temporality |
| **Metric suffixes** | Manual (`_total`, `_bucket`) | Automatic based on instrument type |

## UTF-8 character escaping for OpenTelemetry metrics

### Prometheus 3.0 and later (Recommended)

With Prometheus 3.0's UTF-8 support, you can query OpenTelemetry metrics directly using their original names:

```promql
# Direct querying with UTF-8 support
"http.server.duration"

# Query with complex label names
"process.runtime.jvm.memory.usage"{
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

OpenTelemetry metrics follow semantic conventions that often include dots:

```promql
# HTTP metrics
"http.server.duration"
"http.client.request.size"

# System metrics  
"system.cpu.utilization"
"system.memory.usage"

# Runtime metrics
"process.runtime.jvm.memory.usage"
"process.runtime.go.gc.duration"
```

## Handling aggregation temporality

One of the most critical differences when querying OpenTelemetry metrics is understanding aggregation temporality.

### Cumulative temporality

Cumulative metrics work like traditional Prometheus counters and require rate calculations:

```promql
# For cumulative HTTP request counts
rate(http_server_requests_total[5m])

# For cumulative HTTP durations (histograms)
rate(http_server_duration_seconds_sum[5m]) / 
rate(http_server_duration_seconds_count[5m])
```

### Delta temporality

Delta metrics represent changes since the last measurement and **should not** use `rate()` or `increase()`:

```promql
# For delta HTTP request counts - NO rate() needed
http_server_requests_total

# For delta HTTP durations 
http_server_duration_seconds_sum / http_server_duration_seconds_count
```

### Determining temporality

Unfortunately, PromQL cannot automatically detect temporality. You need to know your data source:

- **Azure Monitor Agent**: Typically sends cumulative metrics
- **Application Insights**: Mixed, depends on the SDK and configuration
- **Custom exporters**: Check your exporter documentation

### Best practices for temporality

1. **Document your data sources** - Keep track of which metrics use which temporality
2. **Use consistent naming** - Consider adding temporality hints to your metric names
3. **Create separate dashboards** - Build different views for cumulative vs. delta metrics
4. **Test your queries** - Verify that rate calculations produce expected results vs. raw values

## Histogram query patterns

OpenTelemetry histograms can use different bucket strategies:

### Explicit histograms (Legacy compatible)

```promql
# Calculate percentiles from explicit buckets
histogram_quantile(0.95, 
  rate(http_server_duration_seconds_bucket[5m])
)

# Ensure you have the correct temporality:
# - Use rate() for cumulative histograms
# - Use raw values for delta histograms
```

### Exponential histograms

Exponential histograms provide automatic bucket sizing but require special handling:

```promql
# Native histogram queries (Prometheus 3.0+)
http_server_duration_seconds{quantile="0.95"}

# Note: Exponential histogram support varies by platform
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
"http.server.duration"{service_name="frontend"}

# Less efficient - starts with label matching
{service_name="frontend", __name__=~"http.*"}
```

### 2. Limit time ranges for high-cardinality metrics

```promql
# Be cautious with broad queries over long time ranges
sum by (service_name) ("http.server.duration"[1h])
```

### 3. Aggregate early when possible

```promql
# Better - aggregate before complex operations
sum(rate("http.server.requests"[5m])) by (service_name)

# Avoid - complex operations on high cardinality
rate(sum("http.server.requests"[5m]) by (service_name, method, status))
```

## Troubleshooting common issues

### Missing metrics with dots in names

**Problem**: Queries return no data for metrics like `http.server.duration`

**Solution**: Use UTF-8 quoting or `__name__` selector:

```promql
# Try UTF-8 quoting first
"http.server.duration"

# Fallback to __name__
{__name__="http.server.duration"}
```

### Incorrect rate calculations

**Problem**: Rate calculations show unexpected spikes or drops

**Solution**: Verify temporality and adjust queries:

```promql
# For cumulative metrics
rate(http_requests_total[5m])

# For delta metrics (no rate needed)
http_requests_total
```

### Label name conflicts

**Problem**: OpenTelemetry resource attributes conflict with Prometheus conventions

**Solution**: Use explicit label selection:

```promql
# Specify the exact label name
{"service.name"="my-service"}

# Not just
{service_name="my-service"} 
```

## Related content

- [Query Prometheus metrics using the API and PromQL](prometheus-api-promql.md)
- [PromQL for Application Insights scenarios](prometheus-application-insights-best-practices.md)
- [PromQL for system metrics and performance counters](prometheus-system-metrics-best-practices.md)
- [Cross-platform PromQL queries](prometheus-cross-platform-best-practices.md)
- [Azure Monitor workspace overview](azure-monitor-workspace-overview.md)