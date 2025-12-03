---
title: OpenTelemetry Guest OS Metrics (preview)
description: Learn about OpenTelemetry System Metrics (Guest OS Performances Counters) in Azure Monitor and how they're modeled.
ms.topic: article
ms.date: 09/27/2025
ms.reviewer: tylerkight
---

# OpenTelemetry Guest OS Metrics (preview)

At Microsoft, we embrace Open Standards through adoption and support of OpenTelemetry metrics stored in Azure Monitor Workspaces(AMW), with Prometheus Query Language(PromQl) our foundational metrics query language across all AMW metrics. 

Before reading this article, users are recommended to first understand the difference between [Host OS vs Guest OS performance counters on virtual machines](/azure/virtual-machines/monitor-vm). 

This article is about Guest OS performance counters that users must opt-in to collecting, either via Azure Monitor Agent with DCR, VM Insights with DCR, or user-collected with the OTelCollector as part of OTel instrumentation libraries. Users are recommended to store all metrics in the metrics-optimized Azure Monitor Workspace, where they are cheaper and faster to query than in Log Analytics Workspaces. 
 
This article provides users with the following information:
* [Overview of performance counters](#performance-counters)
* [Benefits of using OpenTelemetry system metrics](#benefits-of-opentelemetry)
* [Benefits of using Azure Monitor Workspace for metrics](#benefits-of-azure-monitor-workspace)
* [Comparison of OpenTelemetry naming convention to traditional performance counters](#performance-counter-names)
* [Resource Attributes](#resource-attributes)

OpenTelemetry Guest OS Performance Counters are currently in public preview.

## Performance Counters

Both Windows and Linux provide users with OS-level metrics related to CPU usage, memory consumption, disk I/O, networking and more to help diagnose performance issues. You can easily see an example on your local machine right now by using [Performance Monitor(perfmon)](/windows/win32/perfctrs/performance-counters-portal) on Windows or by using the [*perf* command](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/developer_guide/perf) on Linux. 

The total number of available OS performance counters is dynamic, with Windows providing [~1846 OS performance counters](/troubleshoot/windows-server/performance/rebuild-performance-counter-library-values) by default and several more available based on the local machine available hardware, software, and tracepoint events.

A subset of OpenTelemetry Metrics are known as [system metrics](https://opentelemetry.io/docs/specs/semconv/system/system-metrics/). System metrics are essentially another name for performance counters; they are an Open Source Standard for consistent naming and formatting of performance counters and do not add any net-new OS performance counters.  

## Benefits of OpenTelemetry

**Cross-OS observability**
The OpenTelemetry semantic convention for system metrics streamlines the cross-OS end user experience by converging Windows and Linux performance counters into a consistent naming convention and metric data model. This makes it easier for users to manage their virtual machines / nodes across their fleet with a single set of queries used for either Windows or Linux OS images. The same configuration-as-code (ARM/Bicep templates, Terraform, etc.) using the same PromQl queries can be used for any hosting resource that adopts OpenTelemetry system metrics. 

**More performance counters**
The OpenTelemetry Collector Host Metrics Receiver collects many more performance counters than Azure Monitor currently makes available for collection via DCR with Log Analytics workspace as a destination. For example, users can now monitor per-process CPU utilization, disk I/O, memory usage and more.

**Fewer performance counters**
In many scenarios, existing performance counters have been simplified into a single OTel system metric with metric dimensions [(Resource Attributes)](https://opentelemetry.io/docs/specs/otel/metrics/data-model/#timeseries-model) simplifying the user experience.

For example, the CPU time in different states can surface as the following three performance counters in Windows:
* \Processor Information(_Total )\% Processor Time
* \Processor Information(_Total)\% Privileged Time
* \Processor Information(_Total)\% User Time
or as the following seven performance counters in Linux:
* Cpu/usage_user
* Cpu/usage_system
* Cpu/usage_idle
* Cpu/usage_active
* Cpu/usage_nice
* Cpu/usage_iowait
* Cpu/usage_irq

In OpenTelemetry, all of these counters become a single performance counter: system.cpu.time, and the time spent in each state (such as user, system, idle) can now be found by simply filtering on the dimension *State*.

## Benefits of Azure Monitor Workspace

Metrics stored in Azure Monitor workspaces are cheaper and faster to query than when stored in Log Analytics workspaces, due to the different data models backing these different data stores. 

In addition to those general benefits, users no longer experience mismatches in schemas between the Perf and Insights tables. VM Insights (v2) sending to AMW uses a subset of the OpenTelemetry system metrics we make available to users, providing seamless compatibility across user cohorts. Large enterprises with application teams that use a mix of VM Insights and non-VM Insights Guest OS performance counter monitoring can use the same PromQl queries, dashboards, and alerts for the same OTel metrics.

## Performance Counter Names 

The following performance counters are collected by the Azure Monitor Agent for Windows and Linux virtual machines. The default sampling frequency is 60 seconds, but this frequency can be changed when creating or updating the data collection rule.

### [OpenTelemetry](#tab/OpenTelemetry)

| OTel Performance Counter | Type | Unit | Aggregation | Monotonic | Dimensions | Description |
|--------------------------|------|-------------|-----------|------|------------|-------|
| system.cpu.utilization | Gauge | 1 | N/A | FALSE | **cpu**: Logical CPU number starting at 0 (values: Any Str)<br>**state**: Breakdown of CPU usage by type (values: idle, interrupt, nice, softirq, steal, system, user, wait) | Difference in system.cpu.time since the last measurement per logical CPU, divided by the elapsed time (0–1).|
| system.cpu.time | Sum | s | Cumulative | TRUE | **cpu**: Logical CPU number starting at 0 (values: Any Str)<br>**state**: Breakdown of CPU usage by type (values: idle, interrupt, nice, softirq, steal, system, user, wait) | Total seconds each logical CPU spent on each mode. |
| system.cpu.physical.count | Sum | {cpu} | Cumulative | FALSE | *(none)* | Number of available physical CPUs. |
| system.cpu.logical.count | Sum | {cpu} | Cumulative | FALSE | **cpu**: Logical CPU number starting at 0 (values: Any Str) | Number of available logical CPUs. |
| system.cpu.load_average.5m | Gauge | {thread} | N/A | FALSE | *(none)* | Average CPU Load over 5 minutes. |
| system.cpu.load_average.1m | Gauge | {thread} | N/A | FALSE | *(none)* | Average CPU Load over 1 minute. |
| system.cpu.load_average.15m | Gauge | {thread} | N/A | FALSE | *(none)* | Average CPU Load over 15 minutes. |
| system.cpu.frequency | Gauge | Hz | N/A | FALSE | *(none)* | Current frequency of the CPU core in Hz. |
| process.uptime | Gauge | s | N/A | FALSE | *(none)* | Time the process has been running. |
| process.threads | Sum | {threads} | Cumulative | FALSE | *(none)* | Process threads count. |
| process.signals_pending | Sum | {signals} | Cumulative | FALSE | *(none)* | Number of pending signals for the process (Linux only). |
| process.paging.faults | Sum | {faults} | Cumulative | TRUE | **type**: Type of fault (values: major, minor) | Number of page faults the process has made (Linux only). |
| process.open_file_descriptors | Sum | {count} | Cumulative | FALSE | *(none)* | Number of file descriptors in use by the process. |
| process.memory.virtual | Sum | By | Cumulative | FALSE | *(none)* | Virtual memory size. |
| process.memory.utilization | Gauge | 1 | N/A | FALSE | *(none)* | Percentage of total physical memory used by the process. |
| process.memory.usage | Sum | By | Cumulative | FALSE | *(none)* | Amount of physical memory in use. |
| system.disk.weighted_io_time | Sum | s | Cumulative | FALSE | **device**: Name of the disk (values: Any Str) | Time disk spent activated multiplied by queue length. |
| system.disk.pending_operations | Sum | {operations} | Cumulative | FALSE | **device**: Name of the disk (values: Any Str) | Queue size of pending I/O operations. |
| system.disk.operations | Sum | {operations} | Cumulative | TRUE | **device**: Name of the disk (values: Any Str)<br>**direction**: Direction of flow (values: read, write) | Disk operations count. |
| system.disk.operation_time | Sum | s | Cumulative | TRUE | **device**: Name of the disk (values: Any Str)<br>**direction**: Direction of flow (values: read, write) | Time spent in disk operations. |
| system.disk.merged | Sum | {operations} | Cumulative | TRUE | **device**: Name of the disk (values: Any Str)<br>**direction**: Direction of flow (values: read, write) | Disk reads/writes merged into single physical operations. |
| system.disk.io_time | Sum | s | Cumulative | TRUE | **device**: Name of the disk (values: Any Str) | Time disk spent activated. |
| system.disk.io | Sum | By | Cumulative | TRUE | **device**: Name of the disk (values: Any Str)<br>**direction**: Direction of flow (values: read, write) | Disk bytes transferred. |
| process.handles | Sum | {count} | Cumulative | FALSE | *(none)* | Number of open handles (Windows only). |
| process.disk.operations | Sum | {operations} | Cumulative | TRUE | **direction**: Direction of flow (values: read, write) | Disk operations performed by the process. |
| process.disk.io | Sum | By | Cumulative | TRUE | **direction**: Direction of flow (values: read, write) | Disk bytes transferred. |
| process.cpu.utilization | Gauge | 1 | N/A | FALSE | **state**: Breakdown of CPU usage (values: system, user, wait) | Percentage of total CPU time used by the process since last scrape (0–1). |
| process.cpu.time | Sum | s | Cumulative | TRUE | **state**: Breakdown of CPU usage (values: system, user, wait) | Total CPU seconds broken down by states. |
| process.context_switches | Sum | {count} | Cumulative | TRUE | **type**: Type of context switch (values: Any Str) | Number of times the process has been context switched (Linux only). |
| system.memory.utilization | Gauge | 1 | N/A | FALSE | **state**: Breakdown of memory usage (values: buffered, cached, inactive, free, slab_reclaimable, slab_unreclaimable, used) | Percentage of memory bytes in use. |
| system.memory.usage | Sum | By | Cumulative | FALSE | **state**: Breakdown of memory usage (values: buffered, cached, inactive, free, slab_reclaimable, slab_unreclaimable, used) | Bytes of memory in use. |
| system.memory.page_size | Gauge | By | N/A | FALSE | *(none)* | System's configured page size. |
| system.memory.limit | Sum | By | Cumulative | FALSE | *(none)* | Total bytes of memory available. |
| system.linux.memory.dirty | Sum | By | Cumulative | FALSE | *(none)* | Amount of dirty memory (/proc/meminfo). |
| system.linux.memory.available | Sum | By | Cumulative | FALSE | *(none)* | Estimate of available memory (Linux only). |
| system.network.packets | Sum | {packets} | Cumulative | TRUE | **device**: Network interface name (values: Any Str)<br>**direction**: Direction of flow (values: receive, transmit) | Number of packets transferred. |
| system.network.io | Sum | By | Cumulative | TRUE | *(none)* | Bytes transmitted and received. |
| system.network.errors | Sum | {errors} | Cumulative | FALSE | **device**: Network interface name (values: Any Str)<br>**direction**: Direction of flow (values: receive, transmit) | Number of errors encountered. |
| system.network.dropped | Sum | {packets} | Cumulative | TRUE | **device**: Network interface name (values: Any Str)<br>**direction**: Direction of flow (values: receive, transmit) | Number of packets dropped. |
| system.network.conntrack.max | Sum | {entries} | Cumulative | FALSE | *(none)* | Limit for entries in conntrack table. |
| system.network.conntrack.count | Sum | {entries} | Cumulative | FALSE | *(none)* | Count of entries in conntrack table. |
| system.network.connections | Sum | {connections} | Cumulative | FALSE | **protocol**: Network protocol (values: tcp)<br>**state**: Connection state (values: Any Str) | Number of connections. |
| system.uptime | Gauge | s | N/A | FALSE | *(none)* | Time the system has been running. |
| system.processes.created | Sum | {processes} | Cumulative | TRUE | *(none)* | Total number of created processes. |
| system.processes.count | Sum | {processes} | Cumulative | FALSE | **status**: Process status (values: blocked, daemon, detached, idle, locked, orphan, paging, running, sleeping, stopped, system, unknown, zombies) | Total number of processes in each state. |
| system.paging.utilization | Gauge | 1 | N/A | FALSE | **device**: Page file name (values: Any Str)<br>**state**: Paging usage type (values: cached, free, used) | Swap (Unix) or pagefile (Windows) utilization. |
| system.paging.usage | Sum | By | Cumulative | FALSE | **device**: Page file name (values: Any Str)<br>**state**: Paging usage type (values: cached, free, used) | Swap (Unix) or pagefile (Windows) usage. |
| system.paging.operations | Sum | {operations} | Cumulative | TRUE | **direction**: Page flow (values: page_in, page_out)<br>**type**: Fault type (values: major, minor) | Paging operations. |
| system.paging.faults | Sum | {faults} | *(none)* | TRUE | **type**: Fault type (values: major, minor) | Number of page faults. |
| system.filesystem.utilization | Gauge | 1 | N/A | FALSE | **device**: Filesystem identifier<br>**mode**: Mount mode (values: ro, rw)<br>**mountpoint**: Path<br>**type**: Filesystem type (values: ext4, tmpfs, etc.) | Fraction of filesystem bytes used. |
| system.filesystem.usage | Sum | By | Cumulative | FALSE | **device**: Filesystem identifier<br>**mode**: Mount mode<br>**mountpoint**: Path<br>**type**: Filesystem type<br>**state**: Usage type (values: free, reserved, used) | Filesystem bytes used. |
| system.filesystem.inodes.usage | Sum | {inodes} | Cumulative | FALSE | **device**: Filesystem identifier<br>**mode**: Mount mode<br>**mountpoint**: Path<br>**type**: Filesystem type<br>**state**: Usage type (values: free, reserved, used) | Filesystem inodes used. |

### [Windows](#tab/windows)

###   Windows performance counters

| Performance Counter | Category |
|---------|----------|
| \\Processor Information(_Total)\\% Processor Time | CPU |
| \\Processor Information(_Total)\\% Privileged Time | CPU |
| \\Processor Information(_Total)\\% User Time | CPU |
| \\Processor Information(_Total)\\Processor Frequency | CPU |
| \\System\\Processes | CPU |
| \\Process(_Total)\\Thread Count | CPU |
| \\Process(_Total)\\Handle Count | CPU |
| \\System\\System Up Time | CPU |
| \\System\\Context Switches/sec | CPU |
| \\System\\Processor Queue Length | CPU |
| \\Memory\\% Committed Bytes In Use | Memory |
| \\Memory\\Available Bytes | Memory |
| \\Memory\\Committed Bytes | Memory |
| \\Memory\\Cache Bytes | Memory |
| \\Memory\\Pool Paged Bytes | Memory |
| \\Memory\\Pool Nonpaged Bytes | Memory |
| \\Memory\\Pages/sec | Memory |
| \\Memory\\Page Faults/sec | Memory |
| \\Process(_Total)\\Working Set | Memory |
| \\Process(_Total)\\Working Set - Private | Memory |
| \\LogicalDisk(_Total)\\% Disk Time | Disk |
| \\LogicalDisk(_Total)\\% Disk Read Time | Disk |
| \\LogicalDisk(_Total)\\% Disk Write Time | Disk |
| \\LogicalDisk(_Total)\\% Idle Time | Disk |
| \\LogicalDisk(_Total)\\Disk Bytes/sec | Disk |
| \\LogicalDisk(_Total)\\Disk Read Bytes/sec | Disk |
| \\LogicalDisk(_Total)\\Disk Write Bytes/sec | Disk |
| \\LogicalDisk(_Total)\\Disk Transfers/sec | Disk |
| \\LogicalDisk(_Total)\\Disk Reads/sec | Disk |
| \\LogicalDisk(_Total)\\Disk Writes/sec | Disk |
| \\LogicalDisk(_Total)\\Avg. Disk sec/Transfer | Disk |
| \\LogicalDisk(_Total)\\Avg. Disk sec/Read | Disk |
| \\LogicalDisk(_Total)\\Avg. Disk sec/Write | Disk |
| \\LogicalDisk(_Total)\\Avg. Disk Queue Length | Disk |
| \\LogicalDisk(_Total)\\Avg. Disk Read Queue Length | Disk |
| \\LogicalDisk(_Total)\\Avg. Disk Write Queue Length | Disk |
| \\LogicalDisk(_Total)\\% Free Space | Disk |
| \\LogicalDisk(_Total)\\Free Megabytes  | Disk  |
| \\Network Interface(*) \\Bytes Total/sec  | Network  |
| \\Network Interface(*) \\Bytes Sent/sec  | Network  |
| \\Network Interface(*) \\Bytes Received/sec  | Network  |
| \\Network Interface(*) \\Packets/sec  | Network  |
| \\Network Interface(*) \\Packets Sent/sec  | Network  |
| \\Network Interface(*) \\Packets Received/sec  | Network  |
| \\Network Interface(*) \\Packets Outbound Errors  | Network  |
| \\Network Interface(*) \\Packets Received Errors  | Network  |


### [Linux](#tab/linux)

### Linux performance counters

| Performance counter | Category |
|---------------------|----------|
| Processor(*)\\% Processor Time | CPU |
| Processor(*)\\% Idle Time | CPU |
| Processor(*)\\% User Time | CPU |
| Processor(*)\\% Nice Time | CPU |
| Processor(*)\\% Privileged Time | CPU |
| Processor(*)\\% IO Wait Time | CPU |
| Processor(*)\\% Interrupt Time | CPU |
| Memory(*)\\Available MBytes Memory | Memory |
| Memory(*)\\% Available Memory | Memory |
| Memory(*)\\Used Memory MBytes | Memory |
| Memory(*)\\% Used Memory | Memory |
| Memory(*)\\Pages/sec | Memory |
| Memory(*)\\Page Reads/sec | Memory |
| Memory(*)\\Page Writes/sec | Memory |
| Memory(*)\\Available MBytes Swap | Memory |
| Memory(*)\\% Available Swap Space | Memory |
| Memory(*)\\Used MBytes Swap Space | Memory |
| Memory(*)\\% Used Swap Space | Memory |
| Process(*)\\Pct User Time | Memory |
| Process(*)\\Pct Privileged Time | Memory |
| Process(*)\\Used Memory | Memory |
| Process(*)\\Virtual Shared Memory | Memory |
| Logical Disk(*)\\% Free Inodes | Disk |
| Logical Disk(*)\\% Used Inodes | Disk |
| Logical Disk(*)\\Free Megabytes | Disk |
| Logical Disk(*)\\% Free Space | Disk |
| Logical Disk(*)\\% Used Space | Disk |
| Logical Disk(*)\\Logical Disk Bytes/sec | Disk |
| Logical Disk(*)\\Disk Read Bytes/sec | Disk |
| Logical Disk(*)\\Disk Write Bytes/sec | Disk |
| Logical Disk(*)\\Disk Transfers/sec | Disk |
| Logical Disk(*)\\Disk Reads/sec | Disk |
| Logical Disk(*)\\Disk Writes/sec | Disk |
| Network(*)\\Total Bytes Transmitted | Network |
| Network(*)\\Total Bytes Received | Network |
| Network(*)\\Total Bytes | Network |
| Network(*)\\Total Packets Transmitted | Network |
| Network(*)\\Total Packets Received | Network |
| Network(*)\\Total Rx Errors | Network |
| Network(*)\\Total Tx Errors | Network |
| Network(*)\\Total Collisions | Network |
| System(*)\\Uptime | System |
| System(*)\\Load1 | System |
| System(*)\\Load5 | System |
| System(*)\\Load15 | System |
| System(*)\\Users | System |
| System(*)\\Unique Users | System |
| System(*)\\CPUs | System |

---

> [!TIP]
> Feel free to share your feedback on new performance counters or functionality you would like to see by posting to our [GitHub Community](https://github.com/microsoft/AzureMonitorCommunity/discussions) or via [Portal feedback](/answers/questions/564554/where-can-i-submit-suggestions-for-azure).

## Resource Attributes

The OpenTelemetry [Resource semantic convention](https://opentelemetry.io/docs/specs/semconv/resource/) is still in development. We are actively engaging with the OSS community to improve and standardize this naming convention for a variety of scenarios - please share your feedback to help us continuously improve your experience.

In general, OpenTelemetry metrics collected via Azure Monitor Agent + Data Collection Rules and sent to Azure Monitor workspaces have the following cloud resource attributes automatically added as dimensions to support resource-scoped querying:
* Microsoft.resourceid
 * Microsoft.subscriptionid
 * Microsoft.resourcegroupname
 * Microsoft.resourcetype
 * Microsoft.amwresourceid

OpenTelemetry [**per-process** metrics](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/receiver/hostmetricsreceiver/internal/scraper/processscraper/documentation.md#process) have their own special set of [Resource Attributes](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/receiver/hostmetricsreceiver/internal/scraper/processscraper/documentation.md#resource-attributes). The table shows those resource attributes that the Azure Monitor Agent automatically promotes as dimensions.

| Name | Description | Values | Enabled | 
|------|-------------|--------|---------|
| process.command | The command used to launch the process (i.e., the command name). On Linux-based systems, can be set to the zeroth string in `proc/[pid]/cmdline`. On Windows, can be set to the first parameter extracted from `GetCommandLineW`. | Any Str | true |
 process.executable.name  | The name of the process executable. On Linux-based systems, can be set to the `Name` in `proc/[pid]/status`. On Windows, can be set to the base name of `GetProcessImageFileNameW`. | Any Str | true |
| process.owner            | The username of the user that owns the process. | Any Str | true |
| process.pid              | Process identifier (PID). | Any Int | true |
| process.cgroup           | cgroup associated with the process (Linux only). | Any Str | false |
| process.command_line     | The full command used to launch the process as a single string representing the full command. On Windows, can be set to the result of `GetCommandLineW`. Do not set this if you have to assemble it just for monitoring; use `process.command_args` instead. | Any Str | false |
| process.executable.path  | The full path to the process executable. On Linux-based systems, can be set to the target of `proc/[pid]/exe`. On Windows, can be set to the result of `GetProcessImageFileNameW`. | Any Str | false |
| process.parent_pid | Parent Process Identifier (PPID). | Any Int | false |

The process.command_line attribute can contain extremely long strings with thousands of characters, making it unsuitable as a normal metric dimension. We might find a different way to surface this attribute based on customer user scenarios submitted as feedback to the product team.

## Next steps

Use custom metrics from various services:

* [How to begin collecting OpenTelemetry Guest OS performance counters: DCR collection](../vm/data-collection-performance.md)
 * [How to begin collecting OpenTelemetry Guest OS performance counters: VM Insights](../vm/vminsights-opentelemetry.md)
 * [How to query OpenTelemetry Guest OS performance counters with PromQl](./prometheus-system-metrics-best-practices.md)
