---
title: Customize OpenTelemetry metric collection for Azure virtual machines
description: Learn how to customize OpenTelemetry metric collection by modifying data collection rules to add per-process metrics and other advanced performance counters for your Azure virtual machines.
ms.topic: how-to
ms.date: 03/12/2026
---

# Customize OpenTelemetry metric collection for Azure virtual machines (preview)

When you enable OpenTelemetry-based monitoring for your Azure virtual machines, a default set of metrics are collected. You can customize your collection to include additional metrics such per-process performance, logical disk usage, filesystem utilization, and other workload-specific metrics.



you can customize which metrics are collected by modifying the data collection rule (DCR). This article describes how to extend the default metric collection to 
OTel guest OS metrics are system and process-level performance counters collected from inside a VM. This includes CPU, memory, disk I/O, network, and per-process details such as CPU percent, memory percent, uptime, and thread count. This level of visibility helps you diagnose issues without logging into the VM.

## Cost
The default set of OTel metrics collected at no cost. There is an additional cost to collect any additional OTel metrics beyond the default set. See [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor) for pricing details.


## Prerequisites

- An Azure virtual machine with OpenTelemetry-based monitoring enabled. See [Enable enhanced monitoring for an Azure virtual machine](./tutorial-vm-enable-monitoring.md).
- Permissions to modify data collection rules.

## Customize metric collection
By default, VM insights collects a core set of metrics at no cost. If you need additional visibility such as per-process performance, logical disk usage, filesystem utilization, or workload-specific metrics, you can extend the collection by updating the [Data Collection Rule (DCR)](../data-collection/data-collection-rule-overview.md) that gets deployed when VM insights with OTel metrics is enabled.

To identify the DCR associated with the VM, open **Data Collection Rules** from the **Monitor** menu in the Azure portal. Select the **Resources** tab and locate your VM.

:::image type="content" source="media/vminsights-opentelemetry/resources.png" lightbox="media/vminsights-opentelemetry/resources.png" alt-text="Screenshot of Resources tab of Data Collection Rules menu item.":::

Click the number in the **Data collection rules** column to list the DCRs associated with the VM. The OTel DCR will have a name in the form `MSVMOtel-<region>-<name>`.

:::image type="content" source="media/vminsights-opentelemetry/data-collection-rules.png" lightbox="media/vminsights-opentelemetry/data-collection-rules.png" alt-text="Screenshot of DCRs associated with selected resource.":::

See [Create data collection rules (DCRs) in Azure Monitor](../data-collection/data-collection-rule-create-edit.md) for guidance on how to modify a DCR. The default configuration is shown below. Add any of the metrics listed in [Additional metrics](#additional-metrics) to the `counterSpecifiers` section of the DCR.

```json
{
    "properties": {
        "dataSources": {
            "performanceCountersOTel": [
                {
                    "streams": [
                        "Microsoft-OtelPerfMetrics"
                    ],
                    "samplingFrequencyInSeconds": 60,
                    "counterSpecifiers": [
                        "system.cpu.time",
                        "system.cpu.utilization",
                        "system.memory.usage",
                        "system.memory.utilization",
                        "system.disk.io",
                        "system.disk.operations",
                        "system.network.io",
                        "system.filesystem.usage",
                        "system.disk.operation_time",
                        "system.uptime",
                        "system.network.dropped",
                        "system.network.errors"
                    ],
                    "name": "OtelDataSource"
                }
            ]
        },
        "destinations": {
            "monitoringAccounts": [
                {
                    "accountResourceId": "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Monitor/accounts/<workspace-name>",
                    "name": "MonitoringAccount"
                }
            ]
        },
        "dataFlows": [
            {
                "streams": [
                    "Microsoft-OtelPerfMetrics"
                ],
                "destinations": [
                    "MonitoringAccount"
                ]
            }
        ]
    }
}
```


## Metrics reference
The following tables list the OpenTelemetry metrics available for virtual machines.

### Default metrics
The metrics in the following table are collected by default and at no additional cost.

| Metric Name | Description |
|:---|:---|
| system.uptime | Time since last reboot (in seconds) |
| system.cpu.time | Total CPU time consumed (user + system + idle), in seconds |
| system.memory.usage | Memory in use (bytes) |
| system.network.io | Bytes transmitted/received |
| system.network.dropped | Dropped packets |
| system.network.errors | Network errors |
| system.disk.io | Disk I/O (bytes read/written) |
| system.disk.operations | Disk operations (read/write counts) |
| system.filesystem.usage | Filesystem usage in bytes |
| system.disk.operation_time | Average disk operation time |

### Additional metrics
The metrics in the following table can be collected by modifying the DCR for the VM as described in [Customize metric collection](#customize-metric-collection). There's an additional cost to collect these metrics. 

| Metric Name | Description |
|:---|:---|
| system.cpu.utilization | CPU usage % |
| system.cpu.logical.count | Number of logical processors |
| system.cpu.physical.count | Number of physical CPUs |
| system.cpu.frequency | CPU frequency |
| system.cpu.load_average.1m | System load average (1 min) |
| system.cpu.load_average.5m | System load average (5 min) |
| system.cpu.load_average.15m | System load average (15 min) |
| system.memory.utilization | % memory used |
| system.memory.limit | Total memory limit |
| system.memory.page_size | Page size (bytes) |
| system.linux.memory.available | Available memory |
| system.linux.memory.dirty | Dirty memory pages |
| system.paging.faults | Page faults |
| system.paging.operations | Paging operations (reads/writes) |
| system.paging.usage | Paging/swap usage (bytes) |
| system.paging.utilization | % paging/swap used |
| system.disk.io_time | Time spent doing I/O |
| system.disk.merged | Number of merged operations |
| system.disk.pending_operations | Pending I/O operations |
| system.disk.weighted_io_time | Weighted I/O time (accounts for queue depth) |
| system.filesystem.utilization | Filesystem usage % |
| system.filesystem.inodes.usage | Inodes usage |
| system.network.packets | Packets transmitted/received |
| system.network.connections | Active network connections |
| system.network.conntrack.count | Current conntrack table entries |
| system.network.conntrack.max | Maximum conntrack table size |
| process.uptime | Process uptime |
| process.cpu.time | CPU time consumed by process |
| process.cpu.utilization | CPU usage % per process |
| process.memory.usage | Memory usage (RSS) |
| process.memory.virtual | Virtual memory usage |
| process.memory.utilization | Memory % usage |
| process.disk.io | Disk I/O (bytes per process) |
| process.disk.operations | Disk operations per process |
| process.paging.faults | Process page faults |
| process.open_file_descriptors | Open file descriptors |
| process.threads | Number of threads |
| process.handles | Handles in use (Windows) |
| process.context_switches | Context switches |
| process.signals_pending | Pending signals |
| system.processes.count | Total number of processes |
| system.processes.created | Processes created |

## Learn More
- [Azure Monitor metrics](../metrics/data-platform-metrics.md)