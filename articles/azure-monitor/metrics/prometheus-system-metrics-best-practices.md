---
title: PromQL for system metrics and Guest OS performance counters
description: Learn how to query OpenTelemetry system metrics and Guest OS performance counters using PromQL in Azure Monitor.
ms.topic: how-to
ms.date: 12/15/2025
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

## Recommended PromQL queries for system metrics

### CPU

```promql
# Dashboarding CPU utilization when query is scoped to a single VM resource
100 * (1 - avg ({"system.cpu.utilization", state="idle"}))

# Dashboarding to identify CPU hotspots across a fleet of VMs, scoped to an AMW, subscription or resource group
topk (5, 100 * (1 - avg by ("Microsoft.resourceid") ({"system.cpu.utilization", state="idle"})))

# Alerting on high CPU utilization, scoped to a single VM
avg_over_time({"system.cpu.utilization"}[5m]) > 0.8

# Dashboarding to identify top 5 CPU-consuming processes by command, scoped to a single VM.
topk(5, sum by ("process.command") ({"process.cpu.utilization"}))

# Identify CPU-bound processes, scoped to a single VM
{"process.cpu.utilization"} > 0.5
```

### Memory

```promql
# Dashboarding available MB, scoped to a single VM
(sum ({"system.memory.limit"}) - sum ({"system.memory.usage", state="used"})) / (1024 * 1024)

# Alerting on high memory utilization
{"system.memory.utilization", state="used"} > 0.9
```


### Disk I/O 

```promql
# Dashboarding disk total throughput (Bytes/sec), scoped to a single VM. Can be filtered to Read or Write.
sum by (device, direction) rate({"system.disk.io"}[5m]) 

# Dashboarding disk total operations per second, scoped to a single VM. Can be filtered to Read or Write.
sum by (device, direction) rate({"system.disk.operations"}[5m]) 

# Dashboarding top 5 processes by disk operations (read and write), scoped to an AMW, subscription or resource group.
topk(5, sum by ("process.command", direction) (rate({"process.disk.operations"}[5m])))

# Alerting on high disk activity detection, scoped to a single VM.
rate({"system.disk.operations"}[5m]) > 1000

```

## Migrating from KQL to PromQL

This section provides side-by-side comparisons of common KQL queries for system performance counters and their PromQL equivalents. Each example includes both a like-for-like migration and a recommended approach optimized for Prometheus.

> [!IMPORTANT]
> All PromQL queries use UTF-8 escaping syntax introduced in Prometheus 3.0. Label names containing dots (like `Microsoft.resourceid`) and metric names must be quoted and moved into braces, as documented in [Prometheus 3.0 release](https://prometheus.io/docs/guides/utf8/#querying).

### KQL: Average CPU percentage per 15 minute interval

```kusto
Perf 
| where CounterName == "% Processor Time"
| where ObjectName == "Processor"
| summarize avg(CounterValue) by bin(TimeGenerated, 15m), Computer, _ResourceId
```

#### PromQL: Like-for-like migration

This query replicates the KQL behavior by calculating CPU utilization from `system.cpu.time`:

```promql
100 * (
  1 -
  (
    sum by ("Microsoft.resourceid") (rate({"system.cpu.time", state="idle"}[15m])) /
    sum by ("Microsoft.resourceid") (rate({"system.cpu.time"}[15m]))
  )
)
```

**Query parameters:**
- Step: `15m` (matches KQL bin size)

**Rationale:** Replicates Windows' calculation of `100 - % Idle Time` with identical time bin size for direct comparison.

#### PromQL: Recommended approach

```promql
100 * (1 - avg by ("Microsoft.resourceid") ({"system.cpu.utilization", state="idle"})) 
```

**Query parameters:**
- Step: `1m`

**Rationale:** Uses the cleaner `system.cpu.utilization` metric if emitted by your collector. The 1-minute step provides higher resolution dashboards and more responsive alerting.

### KQL: Disk reads per second over 5 minutes

```kusto
Perf
| where ObjectName == "LogicalDisk" and CounterName == "Disk Reads/sec"
| summarize avg(CounterValue) by bin(TimeGenerated, 5m), Computer, _ResourceId
```

#### PromQL: Like-for-like migration

```promql
sum by ("Microsoft.resourceid", device) (
  rate({"system.disk.operations", direction="read"}[5m])
)
```

**Query parameters:**
- Step: `5m`

**Rationale:** Matches KQL `bin(TimeGenerated, 5m)` exactly, aggregated by resource and device.

#### PromQL: Recommended approach

```promql
sum by ("Microsoft.resourceid", device) (
  rate({"system.disk.operations", direction="read"}[1m])
)
```

**Query parameters:**
- Step: `1m`

**Rationale:** More responsive metric for dashboards while maintaining accuracy. The 1-minute rate calculation provides smoother visualization.

### KQL: Available memory over time

```kusto
// Virtual Machine available memory 
// Chart the VM's available memory over time. 
Perf
| where ObjectName == "Memory" and
    (CounterName == "Available MBytes Memory" or  // Linux records
     CounterName == "Available MBytes")            // Windows records
| summarize avg(CounterValue) by bin(TimeGenerated, 15m), Computer, _ResourceId
| render timechart
```

#### PromQL: Like-for-like migration

This query aggregates multiple memory states to calculate available memory across Linux and Windows:

```promql
# Available MB, scoped to a single VM
(sum ({"system.memory.limit"}) - sum ({"system.memory.usage", state="used"})) / (1024 * 1024)
```

**Query parameters:**
- Step: `15m`

**Rationale:** Aggregates memory states representing available memory across operating systems. Converts bytes to megabytes to match KQL counter output. Uses 15-minute step to match the bin size.

#### PromQL: Recommended approach (alerting + autoscaling scenarios)

```promql
avg by ("Microsoft.resourceid") ({"system.memory.utilization"})
```

**Query parameters:**
- Step: `5m`

**Rationale:** Alerting and autoscale scenarios benefit from utilization metrics which don't need expensive regex filters or unit conversions.

### KQL: Bottom 10 free disk space percentage

```kusto
// Bottom 10 Free disk space % 
// Bottom 10 Free disk space % by computer, for the last 7 days. 
Perf
| where TimeGenerated > ago(7d)
| where (ObjectName == "Logical Disk" or ObjectName == "LogicalDisk") 
    and CounterName contains "%" 
    and InstanceName != "_Total" 
    and InstanceName != "HarddiskVolume1"
| project TimeGenerated, Computer, ObjectName, CounterName, InstanceName, CounterValue 
| summarize arg_max(TimeGenerated, *) by Computer
| top 10 by CounterValue desc
```

#### PromQL: Like-for-like migration

```promql
sum by ("Microsoft.resourceid", device, mountpoint, type) (
  {"system.filesystem.usage", state="free", type=~"ext4|xfs|btrfs|ntfs|vfat"}
) / (1024 * 1024)
```

**Query parameters:**
- Time range: `7d`

**Rationale:** Converts bytes to megabytes to match Windows counter output. Filters common filesystem types and excludes system volumes using regex pattern matching.

### KQL vs PromQL syntax comparison

The following table highlights key syntax differences when migrating from KQL to PromQL:

| Concept | KQL Syntax | PromQL Syntax |
|---------|-----------|---------------|
| **Time binning** | `bin(TimeGenerated, 15m)` | Use `step` parameter in query API (e.g., `step=15m`) |
| **Rate calculation** | `CounterValue` (already rate) | `rate(metric[5m])` for counter metrics |
| **Aggregation** | `summarize avg(CounterValue) by Computer` | `avg(metric) by ("Microsoft.resourceid")` |
| **Resource filtering** | `where _ResourceId == "..."` | `{metric, "Microsoft.resourceid"="..."}` |
| **String matching** | `where Name contains "pattern"` | `{metric, name=~".*pattern.*"}` |
| **Label with dots** | `_ResourceId` (underscore prefix) | `"Microsoft.resourceid"` (quoted) |
| **Metric name with dots** | N/A - uses table.column | `{"system.cpu.utilization"}` (quoted) |
| **Time range** | `where TimeGenerated > ago(7d)` | API parameter: `start` and `end` |
| **Top N results** | `top 10 by CounterValue desc` | `topk(10, metric)` |

> [!TIP]
> When working with PromQL in Azure Monitor, always quote label names that contain dots (like `"Microsoft.resourceid"`) and metric names with dots (like `{"system.cpu.utilization"}`). This UTF-8 escaping syntax is required in Prometheus 3.0+ and prevents common parsing errors.

## Related content

- [PromQL best practices for OpenTelemetry metrics](prometheus-opentelemetry-best-practices.md)
- [Azure Monitor Agent data collection configuration](../data-collection/data-collection-rule-overview.md)
- [VM insights OpenTelemetry metrics](../vm/vminsights-opentelemetry.md)