---
title: Collect performance counters with Azure Monitor Agent
description: Describes how to collect performance counters from virtual machines, Virtual Machine Scale Sets, and Arc-enabled on-premises servers using Azure Monitor Agent.
ms.topic: article
ms.date: 10/27/2025
ms.reviewer: jeffwo, tylerkight

---

# Collect performance counters from virtual machine with Azure Monitor
Performance counters provide insight into the performance of virtual hardware components, operating systems, and workloads. Collect counters from both Windows and Linux virtual machines using a [data collection rule (DCR)](../essentials/data-collection-rule-create-edit.md) with a **Performance Counters** data source. 

Details for the creation of the DCR are provided in [Collect data from VM client with Azure Monitor](../vm/data-collection.md). This article provides additional details for the Performance Counters data source type.

A new data source has been added for OpenTelemetry performance counters, supporting Azure Monitor Workspace as a destination. [Read more about the benefits of using this new data source here](../metrics/metrics-opentelemetry-guest.md). 

> [!NOTE]
> To work with the DCR definition directly or to deploy with other methods such as ARM templates, see [Data collection rule (DCR) samples in Azure Monitor](../essentials/data-collection-rule-samples.md#collect-vm-client-data).

## Configure OpenTelemetry performance counters data source (Preview)
Create the DCR using the process in [Collect data from virtual machine client with Azure Monitor](./data-collection.md). On the **Collect and deliver** tab of the DCR, select **OpenTelemetry Performance Counters** from the **Data source type** dropdown. Select from a predefined set of objects to collect and their sampling rate. The lower the sampling rate, the more frequently the value is collected.
    
:::image type="content" source="media/data-collection-performance/otelperfdcr-1.png" lightbox="media/data-collection-performance/otelperfdcr-1.png" alt-text="Screenshot that shows the Azure portal form to select basic OpenTelemetry performance counters in a data collection rule." :::

Select **Custom** for a more granular selection of OpenTelemetry performance counters. 

:::image type="content" source="media/data-collection-performance/otelperfdcr-2.png" lightbox="media/data-collection-performance/otelperfdcr-2.png" alt-text="Screenshot that shows the Azure portal form to select custom OpenTelemetry performance counters in a data collection rule." border="false":::

## Configure performance counters data source
Create the DCR using the process in [Collect data from virtual machine client with Azure Monitor](./data-collection.md). On the **Collect and deliver** tab of the DCR, select **Performance Counters** from the **Data source type** dropdown. Select from a predefined set of objects to collect and their sampling rate. The lower the sampling rate, the more frequently the value is collected.
    
:::image type="content" source="media/data-collection-performance/data-source-performance.png" lightbox="media/data-collection-performance/data-source-performance.png" alt-text="Screenshot that shows the Azure portal form to select basic performance counters in a data collection rule." :::

Select **Custom** to specify an [XPath](https://www.w3schools.com/xml/xpath_syntax.asp) to collect any performance counters not available with the **Basic** selection. Use the format `\PerfObject(ParentInstance/ObjectInstance#InstanceIndex)\Counter`. 

> [!TIP]
> If the counter name contains an ampersand (&), replace it with `&amp;`. For example, `\Memory\Free &amp; Zero Page List Bytes`. 

:::image type="content" source="media/data-collection-performance/data-source-performance-custom.png" lightbox="media/data-collection-performance/data-source-performance-custom.png" alt-text="Screenshot that shows the Azure portal form to select custom performance counters in a data collection rule." border="false":::

> [!WARNING]
> Be careful when manually defining counters for DCRs that are associated with both Windows and Linux machines, since some Windows and Linux style counter names can resolve to the same metric and cause duplicate collection. For example, specifying both `\LogicalDisk(*)\Disk Transfers/sec` (Windows) and `Logical Disk(*)\Disk Transfers/sec` (Linux) in the same DCR will cause the Disk Transfers metric to be collected twice per sampling period.
> 
> This behavior can be avoided by not collecting performance counters in DCRs that don't specify a [platform type](./data-collection.md#create-a-data-collection-rule). Ensure that Windows counters are only included in DCRs associated with Windows machines, and Linux counters are only included in DCRs associated with Linux machines.

> [!NOTE] 
> Microsoft.HybridCompute ([Azure Arc-enabled servers](/azure/azure-arc/servers/overview)) resources can't currently be viewed in [Metrics Explorer](../essentials/metrics-getting-started.md), but their metric data can be acquired via the Metrics REST API (Metric Namespaces - List, Metric Definitions - List, and Metrics - List).

## Add destinations
OpenTelemetry Performance Counters can be sent to an Azure Monitor Workspace where it can be queried via PromQl. This is the recommended data destination for all users, as Container Insights, Application Insights, and VM Insights are all moving to use Azure Monitor Workspace as their source for metrics instead of Log Analytics workspaces.

:::image type="content" source="media/data-collection-performance/otelperfdcr-3-destinations.png" lightbox="media/data-collection-performance/otelperfdcr-3-destinations.png" alt-text="Screenshot that shows configuration of an Azure Monitor Workspace destination in a data collection rule.":::

Performance counters can still be sent to a Log Analytics workspace where it's stored in the [Perf](/azure/azure-monitor/reference/tables/event) table and/or Azure Monitor Metrics (preview) where it's available in [Metrics explorer](../essentials/metrics-explorer.md). Add a destination of type **Azure Monitor Logs** and select a Log Analytics workspace. While you can add multiple workspaces, be aware that this will send duplicate data to each which will result in additional cost. No further details are required for **Azure Monitor Metrics (preview)** since this is stored at the subscription level for the monitored resource.

:::image type="content" source="media/data-collection-performance/destination-metrics.png" lightbox="media/data-collection-performance/destination-metrics.png" alt-text="Screenshot that shows configuration of an Azure Monitor Logs destination in a data collection rule.":::

## Verify data collection
To verify OpenTelemetry performance counters are being collected in the Azure Monitor workspace, you can start by scoping a query to the AMW chosen as destination for the DCR, and check for any of the **System.** metrics flowing as expected.

:::image type="content" source="media/data-collection-performance/otelperfdcr-4-query.png" lightbox="media/data-collection-performance/otelperfdcr-4-query.png" alt-text="Screenshot that shows records returned from an AMW." :::

If the AMW was set to [resource-context access mode](../metrics/azure-monitor-workspace-manage-access.md), you can also verify the same query works as expected when scoped to the VM itself by navigating to the VM Metrics blade in Portal and either choosing the "add with editor" dropdown or choosing the "view AMW metrics in editor" dropdown under Metric Namespaces. 

:::image type="content" source="media/data-collection-performance/otelperfdcr-5-query.png" lightbox="media/data-collection-performance/otelperfdcr-5-query.png" alt-text="Screenshot that shows how to navigate to AMW PromQl editor from a VM Metrics blade." :::

Both entry points should result in a PromQl editor with a query scoped to the VM resource now, where the same query will work as before, but without any need to filter on the VM microsoft.resourceid dimension.

:::image type="content" source="media/data-collection-performance/otelperfdcr-6-query.png" lightbox="media/data-collection-performance/otelperfdcr-6-query.png" alt-text="Screenshot that shows records returned from a VM, stored in an AMW." :::

:::image type="content" source="media/data-collection-performance/otelperfdcr-7-query.png" lightbox="media/data-collection-performance/otelperfdcr-7-query.png" alt-text="Screenshot that shows query scoped to VM rather than AMW." :::

To verify the legacy Performance Counter data source is being collected in the Log Analytics workspace, check for records in the **Perf** table. From the virtual machine or from the Log Analytics workspace in the Azure portal, select **Logs** and then click the **Tables** button. Under the **Virtual machines** category, click **Run** next to **Perf**. 

:::image type="content" source="media/data-collection-performance/verify-performance-counter.png" lightbox="media/data-collection-performance/verify-performance-counter.png" alt-text="Screenshot that shows records returned from Perf table." :::

To verify the legacy Performance Counter data source is being collected in Azure Monitor Metrics, select **Metrics** from the virtual machine in the Azure portal. Select **Virtual Machine Guest** (Windows) or **azure.vm.linux.guestmetrics** for the namespace and then select a metric to add to the view.

:::image type="content" source="media/data-collection-performance/verify-metrics.png" lightbox="media/data-collection-performance/verify-metrics.png" alt-text="Screenshot that shows client metrics in Metrics explorer." :::

## Performance counters

The following performance counters are available to be collected by the Azure Monitor Agent for Windows and Linux virtual machines. The sample frequency can be changed when creating or updating the data collection rule.

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

| Performance Counter | Category | Default sample frequency |
|---------|----------|--------------------------|
| \\Processor Information(_Total)\\% Processor Time | CPU | 60 |
| \\Processor Information(_Total)\\% Privileged Time | CPU | 60 |
| \\Processor Information(_Total)\\% User Time | CPU | 60 |
| \\Processor Information(_Total)\\Processor Frequency | CPU | 60 |
| \\System\\Processes | CPU | 60 |
| \\Process(_Total)\\Thread Count | CPU | 60 |
| \\Process(_Total)\\Handle Count | CPU | 60 |
| \\System\\System Up Time | CPU | 60 |
| \\System\\Context Switches/sec | CPU | 60 |
| \\System\\Processor Queue Length | CPU | 60 |
| \\Memory\\% Committed Bytes In Use | Memory | 60 |
| \\Memory\\Available Bytes | Memory | 60 |
| \\Memory\\Committed Bytes | Memory | 60 |
| \\Memory\\Cache Bytes | Memory | 60 |
| \\Memory\\Pool Paged Bytes | Memory | 60 |
| \\Memory\\Pool Nonpaged Bytes | Memory | 60 |
| \\Memory\\Pages/sec | Memory | 60 |
| \\Memory\\Page Faults/sec | Memory | 60 |
| \\Process(_Total)\\Working Set | Memory | 60 |
| \\Process(_Total)\\Working Set - Private | Memory | 60 |
| \\LogicalDisk(_Total)\\% Disk Time | Disk | 60 |
| \\LogicalDisk(_Total)\\% Disk Read Time | Disk | 60 |
| \\LogicalDisk(_Total)\\% Disk Write Time | Disk | 60 |
| \\LogicalDisk(_Total)\\% Idle Time | Disk | 60 |
| \\LogicalDisk(_Total)\\Disk Bytes/sec | Disk | 60 |
| \\LogicalDisk(_Total)\\Disk Read Bytes/sec | Disk | 60 |
| \\LogicalDisk(_Total)\\Disk Write Bytes/sec | Disk | 60 |
| \\LogicalDisk(_Total)\\Disk Transfers/sec | Disk | 60 |
| \\LogicalDisk(_Total)\\Disk Reads/sec | Disk | 60 |
| \\LogicalDisk(_Total)\\Disk Writes/sec | Disk | 60 |
| \\LogicalDisk(_Total)\\Avg. Disk sec/Transfer | Disk | 60 |
| \\LogicalDisk(_Total)\\Avg. Disk sec/Read | Disk | 60 |
| \\LogicalDisk(_Total)\\Avg. Disk sec/Write | Disk | 60 |
| \\LogicalDisk(_Total)\\Avg. Disk Queue Length | Disk | 60 |
| \\LogicalDisk(_Total)\\Avg. Disk Read Queue Length | Disk | 60 |
| \\LogicalDisk(_Total)\\Avg. Disk Write Queue Length | Disk | 60 |
| \\LogicalDisk(_Total)\\% Free Space | Disk | 60 |
| \\LogicalDisk(_Total)\\Free Megabytes  | Disk  | 60 |
| \\Network Interface(*) \\Bytes Total/sec  | Network  | 60 |
| \\Network Interface(*) \\Bytes Sent/sec  | Network  | 60 |
| \\Network Interface(*) \\Bytes Received/sec  | Network  | 60 |
| \\Network Interface(*) \\Packets/sec  | Network  | 60 |
| \\Network Interface(*) \\Packets Sent/sec  | Network  | 60 |
| \\Network Interface(*) \\Packets Received/sec  | Network  | 60 |
| \\Network Interface(*) \\Packets Outbound Errors  | Network  | 60 |
| \\Network Interface(*) \\Packets Received Errors  | Network  | 60 |


### [Linux](#tab/linux)

### Linux performance counters

| Performance counter | Category | Default sample frequency |
|---------------------|----------|--------------------------|
| Processor(*)\\% Processor Time | CPU | 60 |
| Processor(*)\\% Idle Time | CPU | 60 |
| Processor(*)\\% User Time | CPU | 60 |
| Processor(*)\\% Nice Time | CPU | 60 |
| Processor(*)\\% Privileged Time | CPU | 60 |
| Processor(*)\\% IO Wait Time | CPU | 60 |
| Processor(*)\\% Interrupt Time | CPU | 60 |
| Memory(*)\\Available MBytes Memory | Memory | 60 |
| Memory(*)\\% Available Memory | Memory | 60 |
| Memory(*)\\Used Memory MBytes | Memory | 60 |
| Memory(*)\\% Used Memory | Memory | 60 |
| Memory(*)\\Pages/sec | Memory | 60 |
| Memory(*)\\Page Reads/sec | Memory | 60 |
| Memory(*)\\Page Writes/sec | Memory | 60 |
| Memory(*)\\Available MBytes Swap | Memory | 60 |
| Memory(*)\\% Available Swap Space | Memory | 60 |
| Memory(*)\\Used MBytes Swap Space | Memory | 60 |
| Memory(*)\\% Used Swap Space | Memory | 60 |
| Process(*)\\Pct User Time | Memory | 60 |
| Process(*)\\Pct Privileged Time | Memory | 60 |
| Process(*)\\Used Memory | Memory | 60 |
| Process(*)\\Virtual Shared Memory | Memory | 60 |
| Logical Disk(*)\\% Free Inodes | Disk | 60 |
| Logical Disk(*)\\% Used Inodes | Disk | 60 |
| Logical Disk(*)\\Free Megabytes | Disk | 60 |
| Logical Disk(*)\\% Free Space | Disk | 60 |
| Logical Disk(*)\\% Used Space | Disk | 60 |
| Logical Disk(*)\\Logical Disk Bytes/sec | Disk | 60 |
| Logical Disk(*)\\Disk Read Bytes/sec | Disk | 60 |
| Logical Disk(*)\\Disk Write Bytes/sec | Disk | 60 |
| Logical Disk(*)\\Disk Transfers/sec | Disk | 60 |
| Logical Disk(*)\\Disk Reads/sec | Disk | 60 |
| Logical Disk(*)\\Disk Writes/sec | Disk | 60 |
| Network(*)\\Total Bytes Transmitted | Network | 60 |
| Network(*)\\Total Bytes Received | Network | 60 |
| Network(*)\\Total Bytes | Network | 60 |
| Network(*)\\Total Packets Transmitted | Network | 60 |
| Network(*)\\Total Packets Received | Network | 60 |
| Network(*)\\Total Rx Errors | Network | 60 |
| Network(*)\\Total Tx Errors | Network | 60 |
| Network(*)\\Total Collisions | Network | 60 |
| System(*)\\Uptime | System | 60 |
| System(*)\\Load1 | System | 60 |
| System(*)\\Load5 | System | 60 |
| System(*)\\Load15 | System | 60 |
| System(*)\\Users | System | 60 |
| System(*)\\Unique Users | System | 60 |
| System(*)\\CPUs | System | 60 |

---

## Next steps
- Learn more about [OpenTelemetry performance counters](../metrics/metrics-opentelemetry-guest.md)
- Learn more about [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md).
- Learn more about [data collection rules](../essentials/data-collection-rule-overview.md).
