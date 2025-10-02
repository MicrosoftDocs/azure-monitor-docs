---
title: Migrate to VM Insights OpenTelemetry
description: Learn how to migrate to VM Insights OpenTelemetry for enhanced monitoring and observability of your Azure virtual machines.
ms.topic: concept-article
ms.date: 01/15/2025
---

# Migrate to VM Insights OpenTelemetry (Preview)

[VM insights](./vminsights-overview.md) in Azure Monitor currently uses a Log Analytics workspace to collect client performance data from your virtual machines and to power visualizations in the Azure portal. With the release of OpenTelemetry (OTel) system metrics, VMinsights is being transitioned to a more cost-effective and efficient method of collecting and visualize system-level metrics. This article describes how to get started using OpenTelemetry metrics as your primary visualization tool.

## Benefits of OpenTelemetry for VM insights

Benefits of the new OTel-based collection pipeline include the following:

- Standard system-level metrics such as CPU, memory, disk I/O, and network errors.
- Per-process metrics such as process uptime, memory, and open file descriptors that were not previously available in Azure Monitor.
- Extensibility to non-OS workloads such as MongoDB, Cassandra, and Oracle.
- Cross-platform consistency with a unified schema across Linux and Windows.

## Prerequisites

- Azure VM or Arc-enabled server running an [operating system supported by the Azure Monitor agent](../agents/azure-monitor-agent-supported-operating-systems.md).
- See [Manage the Azure Monitor agent](../agents/azure-monitor-agent-manage.md) for prerequisites related to Azure Monitor agent.
- See [Azure Monitor agent network configuration](../agents/azure-monitor-agent-network-configuration.md) for network requirements for the Azure Monitor agent.


## Enable OpenTelemetry for VM insights

Select a VM in the Azure portal and navigate to the **Insights** pane under the **Monitoring** section. 

If your VM is already onboarded to VM insights, you'll see a prompt to enable OpenTelemetry.

:::image type="content" source="media/vminsights-opentelemetry/upgrade.png" lightbox="media/vminsights-opentelemetry/upgrade.png" alt-text="Screenshot that shows option to upgrade VM insights to OpenTelemetry experience in the Azure portal.":::

If your VM isn't onboarded yet, you can enable OpenTelemetry during the onboarding process.

:::image type="content" source="media/vminsights-opentelemetry/enable.png" lightbox="media/vminsights-opentelemetry/enable.png" alt-text="Screenshot that shows option to enable VM insights to OpenTelemetry experience in the Azure portal.":::

Select whether to enable just the Opentelemetry metrics or both OpenTelemetry and Log Analytics metrics. 


## Metrics reference

### Available at no additional cost

| Metric Name                        | Description                                      |
|------------------------------------|--------------------------------------------------|
| system.uptime                     | Time since last reboot (in seconds)               |
| system.cpu.time                   | Total CPU time consumed (user + system + idle), in seconds |
| system.memory.usage               | Memory in use (bytes)                            |
| system.network.io                 | Bytes transmitted/received                       |
| system.network.dropped            | Dropped packets                                  |
| system.network.errors             | Network errors                                   |
| system.disk.io                    | Disk I/O (bytes read/written)                    |
| system.disk.operations            | Disk operations (read/write counts)              |
| system.filesystem.usage           | Filesystem usage in bytes                        |
| system.disk.operation_time        | Average disk operation time                      |

### Additional cost

| Metric Name                        | Description                                      |
|------------------------------------|--------------------------------------------------|
| system.cpu.utilization            | CPU usage %                                      |
| system.cpu.logical.count          | Number of logical processors                     |
| system.cpu.physical.count         | Number of physical CPUs                          |
| system.cpu.frequency              | CPU frequency                                    |
| system.cpu.load_average.1m        | System load average (1 min)                      |
| system.cpu.load_average.5m        | System load average (5 min)                      |
| system.cpu.load_average.15m       | System load average (15 min)                     |
| system.memory.utilization         | % memory used                                    |
| system.memory.limit               | Total memory limit                               |
| system.memory.page_size           | Page size (bytes)                                |
| system.linux.memory.available     | Available memory                                 |
| system.linux.memory.dirty         | Dirty memory pages                               |
| system.paging.faults              | Page faults                                      |
| system.paging.operations          | Paging operations (reads/writes)                 |
| system.paging.usage               | Paging/swap usage (bytes)                        |
| system.paging.utilization         | % paging/swap used                               |
| system.disk.io_time               | Time spent doing I/O                             |
| system.disk.merged                | Number of merged operations                      |
| system.disk.pending_operations    | Pending I/O operations                           |
| system.disk.weighted_io_time      | Weighted I/O time (accounts for queue depth)     |
| system.filesystem.utilization     | Filesystem usage %                               |
| system.filesystem.inodes.usage    | Inodes usage                                     |
| system.network.packets            | Packets transmitted/received                     |
| system.network.connections        | Active network connections                       |
| system.network.conntrack.count    | Current conntrack table entries                  |
| system.network.conntrack.max      | Maximum conntrack table size                     |
| process.uptime                    | Process uptime                                   |
| process.cpu.time                  | CPU time consumed by process                     |
| process.cpu.utilization           | CPU usage % per process                          |
| process.memory.usage              | Memory usage (RSS)                               |
| process.memory.virtual            | Virtual memory usage                             |
| process.memory.utilization        | Memory % usage                                   |
| process.disk.io                   | Disk I/O (bytes per process)                     |
| process.disk.operations           | Disk operations per process                      |
| process.paging.faults             | Process page faults                              |
| process.open_file_descriptors     | Open file descriptors                            |
| process.threads                   | Number of threads                                |
| process.handles                   | Handles in use (Windows)                         |
| process.context_switches          | Context switches                                 |
| process.signals_pending           | Pending signals                                  |
| system.processes.count            | Total number of processes                        |
| system.processes.created          | Processes created                                |

## Learn More
- [Azure Monitor documentation](https://learn.microsoft.com/azure/azure-monitor/)
- [Log Analytics overview](https://learn.microsoft.com/azure/azure-monitor/logs/log-analytics-overview)
