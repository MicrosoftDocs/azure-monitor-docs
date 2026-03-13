---
title: Collect and customize OpenTelemetry metrics for Azure virtual machines
description: Learn how to collect OpenTelemetry metrics from virtual machines and customize the collection by modifying data collection rules to add per-process metrics and other advanced performance counters.
ms.topic: how-to
ms.date: 03/13/2026
ms.reviewer: jeffwo, tylerkight
---

# Collect and customize OpenTelemetry metrics for Azure virtual machines (preview)

OpenTelemetry metrics provide insight into the performance of virtual hardware components, operating systems, and workloads using standardized metric names that work consistently across Windows and Linux. Collect OpenTelemetry metrics from virtual machines using a [data collection rule (DCR)](../data-collection/data-collection-rule-overview.md) with an **OpenTelemetry Performance Counters** data source.

When you enable OpenTelemetry-based monitoring for your Azure virtual machines, a default set of metrics are collected. You can customize your collection to include additional metrics such as per-process performance, logical disk usage, filesystem utilization, and other workload-specific metrics by modifying the data collection rule.

Details for the creation of the DCR are provided in [Collect data from virtual machine client with Azure Monitor](../vm/data-collection.md). This article provides additional details for the OpenTelemetry Performance Counters data source type.

[Read more about the benefits of using OpenTelemetry metrics here](../vm/metrics-opentelemetry-guest.md). 

> [!NOTE]
> To work with the DCR definition directly or to deploy with other methods such as ARM templates, see [Data collection rule (DCR) samples in Azure Monitor](../data-collection/data-collection-rule-samples.md#collect-vm-client-data).

## Cost

The default set of OTel metrics are collected at no cost. There is an additional cost to collect any additional OTel metrics beyond the default set. See [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor) for pricing details.

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

## Customize metric collection

If you need additional visibility such as per-process performance, logical disk usage, filesystem utilization, or workload-specific metrics, you can extend the collection by updating the [Data Collection Rule (DCR)](../data-collection/data-collection-rule-overview.md) that gets deployed when VM insights with OTel metrics is enabled.

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

For a complete reference with types, units, dimensions, and other metadata, see [OpenTelemetry metrics reference](./metrics-guest-reference.md).

## Next steps

- [OpenTelemetry metrics reference](./metrics-guest-reference.md)
- [Metrics experience for VMs in Azure Monitor](./metrics-opentelemetry-guest.md)
- Learn more about [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md)
- Learn more about [data collection rules](../data-collection/data-collection-rule-overview.md)