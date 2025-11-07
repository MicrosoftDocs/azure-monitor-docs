---
title: PromQL for Application Insights OpenTelemetry scenarios
description: Learn how to query Application Insights and APM data using PromQL when metrics are collected via OpenTelemetry.
ms.topic: how-to
ms.date: 11/07/2025
ms.reviewer: yagil
author: tylerkight
ms.author: tylerkight
---

# PromQL for Application Insights OpenTelemetry scenarios

This article provides guidance for querying Application Insights and application performance monitoring (APM) data using PromQL when metrics are collected through OpenTelemetry. This covers scenarios where applications instrumented with OpenTelemetry SDKs send metrics to Azure Monitor workspaces.

## Prerequisites

- Application Insights resource configured for OpenTelemetry
- Azure Monitor workspace receiving OpenTelemetry metrics
- Applications instrumented with OpenTelemetry SDKs
- Familiarity with [PromQL best practices for OpenTelemetry metrics](prometheus-opentelemetry-best-practices.md)

## Common Application Insights metric patterns

OpenTelemetry SDKs automatically generate metrics that correspond to traditional Application Insights telemetry:

### HTTP server metrics

```promql
# Request rate
"http.server.request.duration"

# Request latency percentiles  
"http.server.request.duration"{quantile="0.95"}

# Error rate by status code
"http.server.response.status_code"
```

### HTTP client metrics

```promql
# Outbound request duration
"http.client.request.duration"

# Dependency call rates
"http.client.request.size"
```

### Database metrics

```promql
# Database operation duration
"db.client.operation.duration"

# Database connection metrics
"db.client.connection.count"
```

## Key query patterns for APM scenarios

### Application performance monitoring

**Request throughput:**
```promql
# Total requests per second across all services
sum(rate("http.server.request.duration"[5m])) by (service_name)

# Requests per endpoint
sum(rate("http.server.request.duration"[5m])) by (service_name, http_route)
```

**Response time analysis:**
```promql
# Average response time by service
avg_over_time("http.server.request.duration"[5m]) by (service_name)

# 95th percentile response time
histogram_quantile(0.95, 
  rate("http.server.request.duration_bucket"[5m])
) by (service_name)
```

**Error rate tracking:**
```promql
# Error rate by HTTP status
sum(rate("http.server.request.duration"[5m])) by (http_status_code) 
/ sum(rate("http.server.request.duration"[5m]))

# 4xx and 5xx error rates
sum(rate("http.server.request.duration"{http_status_code=~"[45].."}[5m])) 
/ sum(rate("http.server.request.duration"[5m]))
```

### Service dependency mapping

**Identify service dependencies:**
```promql
# Outbound calls from each service
sum by (service_name, peer_service) (
  rate("http.client.request.duration"[5m])
)

# Database dependencies
sum by (service_name, db_name) (
  rate("db.client.operation.duration"[5m])
)
```

### Resource utilization

**CPU and memory usage:**
```promql
# Process CPU utilization
"process.cpu.utilization" * 100

# Process memory usage
"process.memory.usage" / 1024 / 1024  # Convert to MB
```

**Garbage collection impact:**
```promql
# GC duration impact on performance  
"process.runtime.jvm.gc.duration"

# Memory pressure indicators
"process.runtime.jvm.memory.usage" / "process.runtime.jvm.memory.limit"
```

## Scenario-specific query examples

### Golden signals implementation

**Latency:**
```promql
# P95 latency for critical services
histogram_quantile(0.95,
  sum(rate("http.server.request.duration_bucket"{
    service_name=~"frontend|api|checkout"
  }[5m])) by (service_name, le)
)
```

**Traffic:**
```promql
# Requests per second by service
sum(rate("http.server.request.duration"[5m])) by (service_name)
```

**Errors:**
```promql
# Error rate percentage
(
  sum(rate("http.server.request.duration"{http_status_code=~"5.."}[5m])) by (service_name)
  /
  sum(rate("http.server.request.duration"[5m])) by (service_name)
) * 100
```

**Saturation:**
```promql
# Memory saturation
("process.memory.usage" / "process.memory.limit") * 100

# CPU saturation
"process.cpu.utilization" * 100
```

### Business metrics correlation

**User experience metrics:**
```promql
# Page load times by browser
avg("http.server.request.duration"{
  http_route="/",
  user_agent_name=~"Chrome|Firefox|Safari"
}) by (user_agent_name)

# Transaction success rates
sum(rate("custom.transaction.completed"[5m])) by (transaction_type)
/ sum(rate("custom.transaction.started"[5m])) by (transaction_type)
```

### Multi-service transaction tracing

**Cross-service latency:**
```promql
# Total transaction time across services
sum by (trace_id) (
  max_over_time("http.server.request.duration"[1m])
)
```

**Service-level SLA monitoring:**
```promql
# Services meeting SLA (< 200ms P95)
(
  histogram_quantile(0.95,
    rate("http.server.request.duration_bucket"[5m])
  ) < 0.2
) by (service_name)
```

## Alerting patterns for APM scenarios

### High-level service health alerts

**Service availability:**
```promql
# Alert when error rate exceeds 5%
(
  sum(rate("http.server.request.duration"{http_status_code=~"5.."}[5m])) by (service_name)
  /
  sum(rate("http.server.request.duration"[5m])) by (service_name)
) > 0.05
```

**Response time degradation:**
```promql
# Alert when P95 latency exceeds 500ms
histogram_quantile(0.95,
  rate("http.server.request.duration_bucket"[5m])
) > 0.5
```

### Resource-based alerts

**Memory pressure:**
```promql
# Alert when memory usage exceeds 80%
("process.memory.usage" / "process.memory.limit") > 0.8
```

**High CPU usage:**
```promql
# Alert when CPU usage exceeds 70% for 5 minutes
"process.cpu.utilization" > 0.7
```

## Troubleshooting APM queries

### Common issues and solutions

**Missing HTTP metrics:**
- Verify OpenTelemetry SDK configuration includes HTTP instrumentation
- Check that metrics are being exported to the correct Azure Monitor workspace
- Ensure metric names use proper UTF-8 quoting in PromQL

**Inconsistent latency calculations:**
- Verify whether your metrics use cumulative or delta temporality
- Use appropriate aggregation functions (rate vs. raw values)
- Consider using native histograms vs. classic histogram buckets

**High cardinality performance issues:**
- Limit queries by service name or environment first
- Use recording rules for frequently-accessed aggregations
- Avoid querying all labels simultaneously

## Integration with Application Insights features

### Correlation with logs and traces

While this article focuses on PromQL for metrics, remember that Application Insights provides rich correlation capabilities:

- Use trace IDs from metrics to query related log data
- Combine metric alerts with log-based investigations
- Leverage Application Map for visual service dependency understanding

### Custom business metrics

```promql
# Custom application metrics
"application.orders.processed" by (region)

# Business KPI tracking
"application.revenue.generated" / "application.orders.total"
```

## Best practices summary

1. **Start with service-level queries** before drilling into detailed metrics
2. **Use consistent labeling** across your OpenTelemetry instrumentation
3. **Monitor golden signals** (latency, traffic, errors, saturation) for each service
4. **Set up progressive alerting** from high-level business metrics to low-level resource metrics
5. **Document your metric semantics** including temporality and aggregation methods

## Related content

- [PromQL best practices for OpenTelemetry metrics](prometheus-opentelemetry-best-practices.md)
- [Application Insights OpenTelemetry overview](../app/opentelemetry.md)
- [Configure OpenTelemetry](../app/opentelemetry-configuration.md)
- [PromQL for system metrics and performance counters](prometheus-system-metrics-best-practices.md)
- [Cross-platform PromQL queries](prometheus-cross-platform-best-practices.md)