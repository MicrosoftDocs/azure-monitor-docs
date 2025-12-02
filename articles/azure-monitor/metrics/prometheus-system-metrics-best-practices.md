---
title: PromQL for system metrics and Guest OS performance counters
description: Learn how to query OpenTelemetry system metrics and Guest OS performance counters using PromQL in Azure Monitor.
ms.topic: how-to
ms.date: 11/26/2025
author: tylerkight
ms.author: tylerkight
---

# PromQL for system metrics and Guest OS performance counters

This article provides guidance for querying OpenTelemetry system metrics and Guest OS performance counters using PromQL in Azure Monitor. This covers scenarios where Azure Monitor Agent or OpenTelemetry Collector gathers system-level telemetry data.

> [!TIP]
> System metrics queries work in both workspace-scoped and resource-scoped modes. When using [resource-scoped queries](prometheus-resource-scoped-queries.md), filter and group by `"Microsoft.resourceid"` instead of generic identifiers like `instance` or `host.name` to ensure accurate scoping to your resources.

## Prerequisites

- [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md) configured with OpenTelemetry metrics collection
- [Azure Monitor workspace](azure-monitor-workspace-overview.md) receiving [OpenTelemetry Guest OS metrics](metrics-opentelemetry-guest.md)
- Understanding of [PromQL best practices for OpenTelemetry metrics](prometheus-opentelemetry-best-practices.md)
- Familiarity with [PromQL basics](prometheus-api-promql.md)
- Knowledge of system performance monitoring concepts

## System metrics overview

OpenTelemetry system metrics provide comprehensive visibility into Guest OS performance through standardized metric names and semantic conventions:

### Core system metric categories

| Category | OpenTelemetry Metrics | Traditional Equivalents |
|----------|----------------------|-------------------------|
| **CPU** | `system.cpu.utilization` | % Processor Time |
| **Memory** | `system.memory.usage`, `system.memory.utilization` | Available Memory, Memory Usage |
| **Disk** | `system.disk.io.bytes`, `system.disk.operations` | Disk Bytes/sec, Disk Operations/sec |
| **Network** | `system.network.io.bytes`, `system.network.packets` | Network Bytes/sec, Packets/sec |
| **Process** | `process.cpu.utilization`, `process.memory.usage` | Process-specific counters |

## CPU metrics and queries

### System-wide CPU utilization

```promql
# Overall CPU utilization across all cores
avg({"system.cpu.utilization"}) by ("Microsoft.resourceid")

# CPU utilization by state (user, system, idle, etc.)
{"system.cpu.utilization"} by ("Microsoft.resourceid", state)

# High CPU utilization detection
avg_over_time({"system.cpu.utilization"}[5m]) > 0.8
```

### Per-core CPU analysis

```promql
# CPU utilization per core
{"system.cpu.utilization"} by ("Microsoft.resourceid", cpu)

# Identify CPU hotspots
topk(5, 
  avg_over_time({"system.cpu.utilization"}[5m]) by (cpu)
)

# CPU load distribution
histogram_quantile(0.95,
  rate({"system.cpu.load_average"}[5m])
) by ("Microsoft.resourceid")
```

### Process-level CPU monitoring

```promql
# Top 5 CPU-consuming processes by command
topk(5, sum by ("process.command") ({"process.cpu.utilization"}))

# Process CPU time accumulation (for cumulative metrics)
rate({"process.cpu.time"}[5m]) by ("process.command")

# Identify CPU-bound processes
{"process.cpu.utilization"} > 0.5
```

## Memory metrics and queries

### System memory analysis

```promql
# Memory utilization percentage
({"system.memory.usage"} / {"system.memory.limit"}) * 100

# Available memory
{"system.memory.usage"}{state="available"}

# Memory pressure indicators
{"system.memory.utilization"} > 0.9
```

### Memory usage by type

```promql
# Memory usage breakdown
{"system.memory.usage"} by ("Microsoft.resourceid", state)

# Swap usage monitoring
{"system.memory.usage"}{state="swap_used"} / 
{"system.memory.usage"}{state="swap_total"}

# Cache and buffer utilization
{"system.memory.usage"}{state=~"cache|buffers"}
```

### Process memory monitoring

```promql
# Top 5 memory-consuming processes by command (percentage)
topk(5, 100 * sum by ("process.command") ({"process.memory.usage"}))

# Process memory growth rate (for delta metrics)
increase({"process.memory.usage"}[10m]) by ("process.command")

# Memory leak detection (for cumulative metrics)
rate({"process.memory.usage"}[10m]) > 1000000  # 1MB/sec growth
```

## Disk I/O metrics and queries

### Disk performance monitoring

```promql
# Disk I/O rate (bytes per second)
rate({"system.disk.io.bytes"}[5m]) by ("Microsoft.resourceid", device, direction)

# Disk operations per second
rate({"system.disk.operations"}[5m]) by ("Microsoft.resourceid", device, direction)

# Disk utilization percentage
{"system.disk.utilization"} by ("Microsoft.resourceid", device)
```

### Disk throughput analysis

```promql
# Top 5 processes by disk operations (read and write)
topk(5, sum by ("process.command", "direction") (rate({"process.disk.operations"}[2m])))

# Read vs write throughput
sum(rate({"system.disk.io.bytes"}{"direction"="read"}[5m])) by ("Microsoft.resourceid") /
sum(rate({"system.disk.io.bytes"}[5m])) by ("Microsoft.resourceid")

# High disk activity detection
rate({"system.disk.operations"}[5m]) > 1000

# Disk queue length monitoring
{"system.disk.pending_operations"} by ("Microsoft.resourceid", device)
```

### Storage capacity monitoring

```promql
# Disk space utilization
({"system.filesystem.usage"} / {"system.filesystem.limit"}) * 100 by (device, mountpoint)

# Available disk space
{"system.filesystem.usage"}{state="available"} by (device, mountpoint)

# Low disk space alerts
({"system.filesystem.usage"} / {"system.filesystem.limit"}) > 0.9
```

## Network metrics and queries

### Network throughput monitoring

```promql
# Network I/O bytes per second
rate({"system.network.io.bytes"}[5m]) by ("Microsoft.resourceid", device, direction)

# Network packets per second  
rate({"system.network.packets"}[5m]) by ("Microsoft.resourceid", device, direction)

# Network utilization by interface
{"system.network.io.bytes"} by ("Microsoft.resourceid", device)
```

### Network performance analysis

```promql
# Network error rates
rate({"system.network.errors"}[5m]) by ("Microsoft.resourceid", device, direction)

# Dropped packet detection
rate({"system.network.dropped"}[5m]) by ("Microsoft.resourceid", device, direction)

# Network saturation indicators
rate({"system.network.io.bytes"}[5m]) / {"system.network.bandwidth"} > 0.8
```

## System health dashboards

### Golden signals for infrastructure

**Latency (Disk I/O latency):**
```promql
# Average disk operation time
{"system.disk.operation.time"} / {"system.disk.operations"}

# 95th percentile disk latency
histogram_quantile(0.95,
  rate({"system.disk.operation.time_bucket"}[5m])
) by (device)
```

**Traffic (System throughput):**
```promql
# Combined network and disk throughput
sum(rate({"system.network.io.bytes"}[5m])) by ("Microsoft.resourceid") +
sum(rate({"system.disk.io.bytes"}[5m])) by ("Microsoft.resourceid")
```

**Errors (System errors):**
```promql
# System error rate
sum(rate({"system.network.errors"}[5m])) by ("Microsoft.resourceid") +
sum(rate({"system.disk.errors"}[5m])) by ("Microsoft.resourceid")
```

**Saturation (Resource utilization):**
```promql
# Overall system saturation score
(
  avg({"system.cpu.utilization"}) +
  avg({"system.memory.utilization"}) +
  avg({"system.disk.utilization"})
) / 3 by ("Microsoft.resourceid")
```

## Performance counter mapping

### Windows Performance Counters to OpenTelemetry

| Windows Counter | OpenTelemetry Equivalent | PromQL Query |
|----------------|-------------------------|--------------||
| `\Processor(_Total)\% Processor Time` | `system.cpu.utilization` | `avg({"system.cpu.utilization"}) by (cpu)` |
| `\Memory\Available Bytes` | `system.memory.usage{state="available"}` | `{"system.memory.usage"}{state="available"}` |
| `\PhysicalDisk(_Total)\Disk Bytes/sec` | `system.disk.io.bytes` | `rate({"system.disk.io.bytes"}[5m])` |
| `\Network Interface(*)\Bytes Total/sec` | `system.network.io.bytes` | `rate({"system.network.io.bytes"}[5m])` |

### Linux metrics to OpenTelemetry

| Linux Source | OpenTelemetry Equivalent | PromQL Query |
|-------------|-------------------------|--------------||
| `/proc/stat` (CPU) | `system.cpu.utilization` | `{"system.cpu.utilization"} by (state)` |
| `/proc/meminfo` | `system.memory.usage` | `{"system.memory.usage"} by (state)` |
| `/proc/diskstats` | `system.disk.operations` | `rate({"system.disk.operations"}[5m])` |
| `/proc/net/dev` | `system.network.io.bytes` | `rate({"system.network.io.bytes"}[5m])` |

## Process uptime monitoring

```promql
# Count process restarts over time by command
sum by ("process.command") (count_over_time({"process.uptime", "process.command"!="__empty"}[2m]))

# Process availability over time
avg_over_time({"process.uptime"}[5m]) by ("process.command")

# Detect process crashes (absence of uptime metric)
absent_over_time({"process.uptime"}[5m])
```

## Data Collection Rule (DCR) integration

### Configuring system metrics collection

When using Azure Monitor Agent with DCRs for OpenTelemetry metrics:

```promql
# Verify data collection is working
up{job="azure-monitor-agent"}

# Check metric collection frequency
rate({"system.cpu.utilization"}[1m]) != 0
```

### Troubleshooting collection issues

```promql
# Missing metrics detection
absent({"system.cpu.utilization"} offset 5m)

# Data freshness check
(time() - timestamp({"system.cpu.utilization"})) > 300  # 5 minutes old
```

## Alerting patterns for system metrics

### Critical system alerts

**High CPU usage:**
```promql
avg_over_time({"system.cpu.utilization"}[10m]) > 0.9
```

**Memory exhaustion:**
```promql
{"system.memory.utilization"} > 0.95
```

**Disk space critically low:**
```promql
({"system.filesystem.usage"} / {"system.filesystem.limit"}) > 0.95
```

**High disk I/O latency:**
```promql
histogram_quantile(0.95,
  rate({"system.disk.operation.time_bucket"}[5m])
) > 0.1  # 100ms
```

### Predictive alerts

**Memory leak detection:**
```promql
# Memory usage growing over 1 hour
(
  {"system.memory.utilization"} - 
  {"system.memory.utilization"} offset 1h
) > 0.1  # 10% increase
```

**Disk space trending:**
```promql
# Predict disk full in 24 hours
predict_linear({"system.filesystem.usage"}[2h], 24*3600) > 
{"system.filesystem.limit"} * 0.95
```

## Best practices for system metrics

1. **Set appropriate time windows** - Use longer ranges (5-15m) for system metrics to avoid noise
2. **Monitor both utilization and saturation** - Track percentage and absolute values
3. **Use resource-aware aggregation** - Group by logical units (instance, device, mountpoint)
4. **Implement tiered alerting** - Warning at 80%, critical at 95% utilization
5. **Consider seasonality** - System usage patterns may vary by time of day/week

## Troubleshooting system metrics queries

### Common issues

**Metrics not appearing:**
- Verify Azure Monitor Agent is configured for OpenTelemetry metrics
- Check that DCR includes system metrics collection
- Ensure proper UTF-8 quoting for metric names with dots

**Inconsistent values:**
- Verify metric temporality (cumulative vs delta)
- Use appropriate aggregation functions
- Check collection intervals and query time ranges

**High cardinality warnings:**
- Limit queries by instance or device first
- Use recording rules for expensive aggregations
- Avoid querying all dimensions simultaneously

## Related content

- [PromQL best practices for OpenTelemetry metrics](prometheus-opentelemetry-best-practices.md)
- [Azure Monitor Agent data collection configuration](../data-collection/data-collection-rule-overview.md)
- [VM insights OpenTelemetry metrics](../vm/vminsights-opentelemetry.md)