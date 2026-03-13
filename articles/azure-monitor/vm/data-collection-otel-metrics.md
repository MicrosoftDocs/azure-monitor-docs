---
title: Collect OpenTelemetry metrics with Azure Monitor Agent
description: Describes how to collect OpenTelemetry metrics from virtual machines, Virtual Machine Scale Sets, and Arc-enabled on-premises servers using Azure Monitor Agent.
ms.topic: how-to
ms.date: 03/13/2026
ms.reviewer: jeffwo, tylerkight
---

# Collect OpenTelemetry metrics from virtual machines with Azure Monitor

OpenTelemetry metrics provide insight into the performance of virtual hardware components, operating systems, and workloads using standardized metric names that work consistently across Windows and Linux. Collect OpenTelemetry metrics from virtual machines using a [data collection rule (DCR)](../data-collection/data-collection-rule-overview.md) with an **OpenTelemetry Performance Counters** data source. 

Details for the creation of the DCR are provided in [Collect data from virtual machine client with Azure Monitor](../vm/data-collection.md). This article provides additional details for the OpenTelemetry Performance Counters data source type.

[Read more about the benefits of using OpenTelemetry metrics here](../vm/metrics-opentelemetry-guest.md). 

> [!NOTE]
> To work with the DCR definition directly or to deploy with other methods such as ARM templates, see [Data collection rule (DCR) samples in Azure Monitor](../data-collection/data-collection-rule-samples.md#collect-vm-client-data).

## Prerequisites

- An Azure Monitor workspace to store the OpenTelemetry metrics. See [Create an Azure Monitor workspace](../metrics/azure-monitor-workspace-manage.md#create-an-azure-monitor-workspace).
- Permissions to create data collection rules. See [Permissions](../data-collection/data-collection-rule-create-edit.md#permissions).

## Configure data source

Create the DCR using the process in [Collect data from virtual machine client with Azure Monitor](./data-collection.md). On the **Collect and deliver** tab of the DCR, select **OpenTelemetry Performance Counters** from the **Data source type** dropdown. Select from a predefined set of objects to collect and their sampling rate. The lower the sampling rate, the more frequently the value is collected.
    
:::image type="content" source="media/data-collection-performance/opentelemetry-performance-dcr-1.png" lightbox="media/data-collection-performance/opentelemetry-performance-dcr-1.png" alt-text="Screenshot that shows the Azure portal form to select basic OpenTelemetry performance counters in a data collection rule." :::

Select **Custom** for a more granular selection of OpenTelemetry performance counters. 

:::image type="content" source="media/data-collection-performance/opentelemetry-performance-dcr-2.png" lightbox="media/data-collection-performance/opentelemetry-performance-dcr-2.png" alt-text="Screenshot that shows the Azure portal form to select custom OpenTelemetry performance counters in a data collection rule." border="false":::

## Add destination

OpenTelemetry Performance Counters can be sent to an Azure Monitor Workspace where it can be queried via PromQL. This is the recommended data destination for all users, as Container Insights, Application Insights, and VM Insights are all moving to use Azure Monitor Workspace as their source for metrics instead of Log Analytics workspaces.

:::image type="content" source="media/data-collection-performance/opentelemetry-performance-dcr-3-destinations.png" lightbox="media/data-collection-performance/opentelemetry-performance-dcr-3-destinations.png" alt-text="Screenshot that shows configuration of an Azure Monitor Workspace destination in a data collection rule.":::

## Verify data collection

To verify OpenTelemetry performance counters are being collected in the Azure Monitor workspace, you can start by scoping a query to the AMW chosen as destination for the DCR, and check for any of the **System.** metrics flowing as expected.

:::image type="content" source="media/data-collection-performance/opentelemetry-performance-dcr-4-query.png" lightbox="media/data-collection-performance/opentelemetry-performance-dcr-4-query.png" alt-text="Screenshot that shows records returned from an AMW." :::

If the AMW was set to [resource-context access mode](../metrics/azure-monitor-workspace-manage-access.md), you can also verify the same query works as expected when scoped to the VM itself by navigating to the VM Metrics blade in Portal and either choosing the "add with editor" dropdown or choosing the "view AMW metrics in editor" dropdown under Metric Namespaces. 

:::image type="content" source="media/data-collection-performance/opentelemetry-performance-dcr-5-query.png" lightbox="media/data-collection-performance/opentelemetry-performance-dcr-5-query.png" alt-text="Screenshot that shows how to navigate to AMW PromQL editor from a VM Metrics blade." :::

Both entry points should result in a PromQL editor with a query scoped to the VM resource now, where the same query will work as before, but without any need to filter on the VM microsoft.resourceid dimension.

:::image type="content" source="media/data-collection-performance/opentelemetry-performance-dcr-6-query.png" lightbox="media/data-collection-performance/opentelemetry-performance-dcr-6-query.png" alt-text="Screenshot that shows records returned from a VM, stored in an AMW." :::

:::image type="content" source="media/data-collection-performance/opentelemetry-performance-dcr-7-query.png" lightbox="media/data-collection-performance/opentelemetry-performance-dcr-7-query.png" alt-text="Screenshot that shows query scoped to VM rather than AMW." :::

## OpenTelemetry metrics reference

The following OpenTelemetry metrics are available to be collected by the Azure Monitor Agent. The sample frequency can be changed when creating or updating the data collection rule.

| OTel Performance Counter | Type | Unit | Aggregation | Monotonic | Dimensions | Description |
|---|---|---|---|---|---|---|
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

## Next steps

- [Customize OpenTelemetry metric collection](./vminsights-opentelemetry.md)
- [OpenTelemetry metrics reference](./metrics-guest-reference.md)
- [Metrics experience for VMs in Azure Monitor](./metrics-opentelemetry-guest.md)
- Learn more about [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md)
- Learn more about [data collection rules](../data-collection/data-collection-rule-overview.md)
