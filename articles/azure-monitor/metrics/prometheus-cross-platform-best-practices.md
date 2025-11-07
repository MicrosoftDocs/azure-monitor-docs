---
title: Cross-platform PromQL queries for Prometheus and OpenTelemetry metrics
description: Learn how to query across Prometheus and OpenTelemetry metrics simultaneously for Health Models, SLIs, and advanced consumption scenarios in Azure Monitor.
ms.topic: how-to
ms.date: 11/07/2025
ms.reviewer: yagil
author: tylerkight
ms.author: tylerkight
---

# Cross-platform PromQL queries for Prometheus and OpenTelemetry metrics

This article provides guidance for writing PromQL queries that combine data from both Prometheus and OpenTelemetry metrics sources. This enables advanced monitoring scenarios including Health Models, Service Level Indicators (SLIs), and comprehensive observability across hybrid metric ecosystems.

## Prerequisites

- Azure Monitor workspace receiving both Prometheus and OpenTelemetry metrics
- Understanding of [PromQL best practices for OpenTelemetry metrics](prometheus-opentelemetry-best-practices.md)
- Familiarity with traditional Prometheus metrics and OpenTelemetry conventions
- Knowledge of Azure Monitor [Health Models](../health-models/overview.md) concepts

## Metric ecosystem challenges

When querying across Prometheus and OpenTelemetry metrics, you'll encounter several challenges:

### Naming convention differences

| Source | Naming Pattern | Example |
|--------|---------------|---------|
| **Prometheus** | `snake_case` with suffixes | `http_requests_total`, `http_request_duration_seconds_bucket` |
| **OpenTelemetry** | `dot.notation` semantic conventions | `http.server.request.duration`, `system.cpu.utilization` |

### Temporality mismatches

- **Prometheus metrics**: Always cumulative
- **OpenTelemetry metrics**: May be cumulative or delta depending on source

### Label naming differences

| Concept | Prometheus | OpenTelemetry |
|---------|-----------|---------------|
| Service identification | `job`, `instance` | `service.name`, `service.instance.id` |
| HTTP status | `code`, `status_code` | `http.response.status_code` |
| Method | `method` | `http.request.method` |

## Unified query patterns

### Service health across metric sources

**Combining traditional and OpenTelemetry HTTP metrics:**
```promql
# Request rate from both sources
(
  # Traditional Prometheus HTTP metrics
  sum(rate(http_requests_total[5m])) by (job)
  +
  # OpenTelemetry HTTP metrics  
  sum(rate("http.server.request.duration"[5m])) by (service_name)
)
```

**Normalizing service identification:**
```promql
# Map different service label patterns
label_replace(
  sum(rate(http_requests_total[5m])) by (job),
  "service", "$1", "job", "(.*)"
) 
or
label_replace(
  sum(rate("http.server.request.duration"[5m])) by (service_name),
  "service", "$1", "service_name", "(.*)"
)
```

### Error rate consolidation

**Unified error rate calculation:**
```promql
# Prometheus-style error rate
(
  sum(rate(http_requests_total{code=~"5.."}[5m])) by (job) /
  sum(rate(http_requests_total[5m])) by (job)
)
or
# OpenTelemetry-style error rate
(
  sum(rate("http.server.request.duration"{http_response_status_code=~"5.."}[5m])) by (service_name) /
  sum(rate("http.server.request.duration"[5m])) by (service_name)
)
```

### Latency percentiles across sources

**P95 latency from different histogram formats:**
```promql
# Traditional Prometheus histograms
histogram_quantile(0.95,
  sum(rate(http_request_duration_seconds_bucket[5m])) by (job, le)
)
or
# OpenTelemetry histograms (explicit buckets)
histogram_quantile(0.95,
  sum(rate("http.server.request.duration_bucket"[5m])) by (service_name, le)
)
```

## Health Models integration

### Multi-source health scoring

**Composite health score from different metric sources:**
```promql
# Health score combining infrastructure and application metrics
(
  # System health (OpenTelemetry)
  (1 - avg("system.cpu.utilization") by (instance)) * 0.3 +
  (1 - avg("system.memory.utilization") by (instance)) * 0.3 +
  
  # Application health (Prometheus)
  (1 - sum(rate(http_requests_total{code=~"5.."}[5m])) by (job) / 
        sum(rate(http_requests_total[5m])) by (job)) * 0.4
) by (instance, job)
```

### Dependency health correlation

**Cross-service health dependencies:**
```promql
# Upstream service health affecting downstream
# OpenTelemetry client metrics correlated with Prometheus server metrics
(
  # Client-side view (OpenTelemetry)
  avg("http.client.request.duration"{peer_service="api-service"}) by (service_name)
  * on() group_left()
  # Server-side view (Prometheus)
  (rate(http_requests_total{job="api-service"}[5m]) > 0)
)
```

### Multi-dimensional health assessment

**Infrastructure and application correlation:**
```promql
# Identify infrastructure impact on application performance
(
  # Application latency increase
  (
    histogram_quantile(0.95, rate("http.server.request.duration_bucket"[5m])) -
    histogram_quantile(0.95, rate("http.server.request.duration_bucket"[5m] offset 1h))
  ) > 0.1
)
and on (instance)
# Correlated with high system utilization
(
  avg("system.cpu.utilization") by (instance) > 0.8
  or
  avg("system.memory.utilization") by (instance) > 0.9
)
```

## Service Level Indicators (SLIs)

### Availability SLI across sources

**Multi-source availability calculation:**
```promql
# Availability SLI combining different uptime indicators
(
  # Prometheus-based service up indicator
  up{job=~"web-.*"} 
  * on (instance) group_left()
  # OpenTelemetry system availability
  (("system.cpu.utilization" > 0) and ("system.memory.utilization" < 0.99))
)
```

### Latency SLI normalization

**Unified latency SLI from different sources:**
```promql
# Percentage of requests under 200ms across metric sources
(
  # Prometheus histogram buckets
  (
    sum(rate(http_request_duration_seconds_bucket{le="0.2"}[5m])) by (job) /
    sum(rate(http_request_duration_seconds_bucket{le="+Inf"}[5m])) by (job)
  )
  or
  # OpenTelemetry histogram buckets  
  (
    sum(rate("http.server.request.duration_bucket"{le="0.2"}[5m])) by (service_name) /
    sum(rate("http.server.request.duration_bucket"{le="+Inf"}[5m])) by (service_name)
  )
) * 100
```

### Throughput SLI aggregation

**Combined throughput from multiple sources:**
```promql
# Total system throughput from all sources
sum(
  # Prometheus application metrics
  sum(rate(http_requests_total[5m])) by (job)
  or
  # OpenTelemetry application metrics
  sum(rate("http.server.request.duration"[5m])) by (service_name)
  or  
  # System-level throughput (OpenTelemetry)
  sum(rate("system.network.io.bytes"[5m])) by (instance) / 1024  # Convert to KB/s
)
```

## Advanced query techniques

### Metric source identification

**Automatically detect metric source type:**
```promql
# Label metrics by their source type
label_replace(
  {__name__=~".*_total|.*_seconds.*"}, 
  "metric_source", "prometheus", "__name__", ".*"
)
or
label_replace(
  {__name__=~".*\\..*"}, 
  "metric_source", "opentelemetry", "__name__", ".*"
)
```

### Temporal alignment

**Handle different collection intervals:**
```promql
# Align metrics with different collection frequencies
(
  # 15-second Prometheus metrics
  avg_over_time(up[1m])
  * on (instance) group_left()
  # 60-second OpenTelemetry metrics
  avg_over_time("system.cpu.utilization"[1m])
)
```

### Missing data handling

**Graceful degradation when sources are unavailable:**
```promql
# Primary source with fallback
(
  # Prefer OpenTelemetry metrics
  "http.server.request.duration"
  or
  # Fallback to Prometheus metrics
  http_request_duration_seconds
)
```

## Recording rules for cross-platform metrics

### Unified recording rules

**Create consistent metrics across sources:**
```yaml
# Example recording rule configuration
groups:
- name: unified_metrics
  rules:
  - record: unified:request_rate
    expr: |
      (
        sum(rate(http_requests_total[5m])) by (job)
        or
        sum(rate("http.server.request.duration"[5m])) by (service_name)
      )
      
  - record: unified:error_rate  
    expr: |
      (
        sum(rate(http_requests_total{code=~"5.."}[5m])) by (job) /
        sum(rate(http_requests_total[5m])) by (job)
      )
      or
      (
        sum(rate("http.server.request.duration"{http_response_status_code=~"5.."}[5m])) by (service_name) /
        sum(rate("http.server.request.duration"[5m])) by (service_name)
      )
```

## Alerting across metric sources

### Unified alerting rules

**Alert on conditions from either metric source:**
```promql
# High error rate from any source
(
  (
    sum(rate(http_requests_total{code=~"5.."}[5m])) by (job) /
    sum(rate(http_requests_total[5m])) by (job)
  ) > 0.05
)
or
(
  (
    sum(rate("http.server.request.duration"{http_response_status_code=~"5.."}[5m])) by (service_name) /
    sum(rate("http.server.request.duration"[5m])) by (service_name)
  ) > 0.05
)
```

### Correlation-based alerts

**Alert on metric correlation across sources:**
```promql
# Application errors correlated with system resource pressure
(
  # Application error spike
  increase(http_requests_total{code=~"5.."}[5m]) > 10
  and on (instance)
  # System resource pressure (OpenTelemetry)
  ("system.cpu.utilization" > 0.9 or "system.memory.utilization" > 0.95)
)
```

## Best practices for cross-platform queries

1. **Normalize label names** early in queries using `label_replace()`
2. **Use recording rules** for expensive cross-platform aggregations
3. **Implement fallback patterns** for metric source availability
4. **Document metric sources** and their expected temporality
5. **Test query performance** with realistic cardinality
6. **Monitor query execution time** and optimize accordingly

## Troubleshooting cross-platform queries

### Common issues

**Label name mismatches:**
- Use `label_replace()` to standardize label names
- Create mapping documentation for different sources

**Temporality confusion:**
- Clearly document which metrics are cumulative vs. delta
- Use appropriate rate calculations for each source

**Performance problems:**
- Use recording rules for complex cross-platform aggregations
- Limit time ranges and use efficient selectors

**Missing data scenarios:**
- Implement `or` patterns for metric fallbacks
- Use `absent()` function to detect missing metric sources

## Related content

- [PromQL best practices for OpenTelemetry metrics](prometheus-opentelemetry-best-practices.md)
- [Azure Monitor Health Models](../health-models/overview.md)
- [PromQL for Application Insights scenarios](prometheus-application-insights-best-practices.md)
- [PromQL for system metrics and performance counters](prometheus-system-metrics-best-practices.md)
- [Prometheus rule groups](prometheus-rule-groups.md)