---
title: Migrate to VM insights OpenTelemetry
description: Learn how to migrate to VM insights OpenTelemetry for enhanced monitoring and observability of your Azure virtual machines.
ms.topic: concept-article
ms.date: 01/15/2025
---

# Migrate to VM insights OpenTelemetry (preview)

[VM insights](./vminsights-overview.md) in Azure Monitor currently uses a Log Analytics workspace to collect client performance data from your virtual machines and to power visualizations in the Azure portal. With the release of OpenTelemetry (OTel) system metrics, VMinsights is being transitioned to a more cost-effective and efficient method of collecting and visualize system-level metrics. This article describes how to get started using OpenTelemetry metrics as your primary visualization tool.

## Benefits of OpenTelemetry for VM insights

Benefits of the new OTel-based collection pipeline include the following:

- Standard system-level metrics such as CPU, memory, disk I/O, and network errors.
- Per-process metrics such as process uptime, memory, and open file descriptors that weren't previously available in Azure Monitor.
- Extensibility to non-OS workloads such as MongoDB, Cassandra, and Oracle.
- Cross-platform consistency with a unified schema across Linux and Windows.

## Prerequisites

- Azure VM or Arc-enabled server running an [operating system supported by the Azure Monitor agent](../agents/azure-monitor-agent-supported-operating-systems.md).
- See [Manage the Azure Monitor agent](../agents/azure-monitor-agent-manage.md) for prerequisites related to Azure Monitor agent.
- See [Azure Monitor agent network configuration](../agents/azure-monitor-agent-network-configuration.md) for network requirements for the Azure Monitor agent.


## Enable OpenTelemetry for VM insights

> [!NOTE]
> The Azure portal is currently the only supported method to enable OpenTelemetry for VM insights.

1. Select a VM in the Azure portal and navigate to the **Insights** pane under the **Monitoring** section. 

2. If your VM is already onboarded to VM insights, you'll see a prompt to enable OpenTelemetry.

    :::image type="content" source="media/vminsights-opentelemetry/upgrade.png" lightbox="media/vminsights-opentelemetry/upgrade.png" alt-text="Screenshot that shows option to upgrade VM insights to OpenTelemetry experience in the Azure portal.":::

    If your VM isn't onboarded yet, you can enable OpenTelemetry during the onboarding process.

    :::image type="content" source="media/vminsights-opentelemetry/enable.png" lightbox="media/vminsights-opentelemetry/enable.png" alt-text="Screenshot that shows option to enable VM insights to OpenTelemetry experience in the Azure portal.":::

3. For a VM that hasn't been onboarded yet, you can choose whether to enable the classic log-based metrics, the new OpenTelemetry metrics, or both. For a VM that has already been onboarded, you can only add OpenTelemetry metrics. The option to disable classic log-based metrics isn't currently available. See [Disable classic log-based metrics](#disable-classic-log-based-metrics) to disable the classic experience.

4. The Azure Monitor workspace for OTel metrics and the Log Analytics workspace for classic metrics that will be used are displayed. You can change either workspace by selecting **Customize infrastructure monitoring**. If a workspace doesn't already exist, a default workspace will be created for you. You can also choose to create your own new workspace.

    :::image type="content" source="media/vminsights-opentelemetry/customize-configuration.png" lightbox="media/vminsights-opentelemetry/customize-configuration.png" alt-text="Screenshot that shows screen for customizing metric collection in the Azure portal.":::

    > [!NOTE]
    > This screen displays the metrics that will be collected, although you can't modify them here. See [Customize metric collection](#customize-metric-collection).

## Visualize OpenTelemetry metrics
When you enable OTel metrics, the VM insights dashboards are updated to use these metrics instead of those stored in Log Analytics workspace. You can do custom analysis of these metrics select the **Metrics** option from the Azure Monitor workspace to open metrics explorer. See [Azure Monitor metrics explorer with PromQL](../metrics/metrics-explorer.md).

:::image type="content" source="media/vminsights-opentelemetry/metrics-explorer.png" lightbox="media/vminsights-opentelemetry/metrics-explorer.png" alt-text="Screenshot that shows metrics explorer with PromQL in the Azure portal.":::

## Disable classic log-based metrics
If your VM is currently using the classic log-based VM insights experience, then you can choose to stop sending metrics to the Log Analytics workspace to save on ingestion and retention costs. See [Disable monitoring of your VMs in VM insights](./vminsights-optout.md) for this process.

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
                        "system.filesystem.usage",
                        "system.filesystem.utilization",
                        "system.disk.io",
                        "system.disk.operation_time",
                        "system.disk.operations",
                        "system.memory.usage",
                        "system.network.io",
                        "system.cpu.time",
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
                    "accountResourceId": "/subscriptions/my-subscription/resourcegroups/my-resource-group/providers/microsoft.monitor/accounts/my-workspace",
                    "name": "MonitoringAccountDestination"
                }
            ]
        },
        "dataFlows": [
            {
                "streams": [
                    "Microsoft-OtelPerfMetrics"
                ],
                "destinations": [
                    "MonitoringAccountDestination"
                ]
            }
        ]
    }
}
```



## Troubleshooting

**The charts are stuck in a loading state**<br>
This issue occurs if the network traffic for the Azure Monitor workspace is blocked. This is typically related to network policies such as ad blocking software. To resolve this issue, disable the ad block or allowlist `monitor.azure.com` traffic and reload the page.

**Unable to access Data Collection Rule (DCR)**<br>
This error occurs when the user doesn't have permission to view the associated Prometheus DCR for the cluster, or the DCR may have been deleted. To resolve, grant access to the Prometheus DCR or reconfigure managed Prometheus using the **Monitor Settings** button in the toolbar.

**Data configuration error**<br>
This error occurs when the Azure Monitor workspace or DCR has been modified or deleted. Use the **Reconfigure** button to patch the recording rules and try again.

**Access denied**<br>
This error occurs when the user's portal token expires or doesn't have permissions to view the associated Azure Monitor workspace. This can typically be resolved by refreshing the browser session or contacting your system administrator to request access. The user needs monitor reader permission, and the resource centric flag should be enabled on the Azure Monitor workspace by the system administrator.

**An unknown error occurred**<br>
If this error message persists, then contact support to open up a ticket.


## Metrics reference
The following tables list the metrics collected by VM insights OpenTelemetry.

### Default metrics
The metrics in the following table are collected by default and at no additional cost.

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

### Additional metrics
The metrics in the following table can be collected by modifying the DCR for the VM as described in [Customize metric collection](#customize-metric-collection). There is an additional cost to collect these metrics. 

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
- [Azure Monitor metrics](../metrics/data-platform-metrics.md)
