---
title: Collect performance counters with Azure Monitor Agent
description: Describes how to collect performance counters from virtual machines, Virtual Machine Scale Sets, and Arc-enabled on-premises servers using Azure Monitor Agent.
ms.topic: article
ms.date: 03/03/2025
ms.reviewer: jeffwo

---

# Collect performance counters from virtual machine with Azure Monitor
Performance counters provide insight into the performance of virtual hardware components, operating systems, and workloads. Collect counters from both Windows and Linux virtual machines using a [data collection rule (DCR)](../essentials/data-collection-rule-create-edit.md) with a **Performance Counters** data source. 

Details for the creation of the DCR are provided in [Collect data from VM client with Azure Monitor](../vm/data-collection.md). This article provides additional details for the Performance Counters data source type.

> [!NOTE]
> To work with the DCR definition directly or to deploy with other methods such as ARM templates, see [Data collection rule (DCR) samples in Azure Monitor](../essentials/data-collection-rule-samples.md#collect-vm-client-data).

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
Performance counters can be sent to a Log Analytics workspace where it's stored in the [Perf](/azure/azure-monitor/reference/tables/event) table and/or Azure Monitor Metrics (preview) where it's available in [Metrics explorer](../essentials/metrics-explorer.md). Add a destination of type **Azure Monitor Logs** and select a Log Analytics workspace. While you can add multiple workspaces, be aware that this will send duplicate data to each which will result in additional cost. No further details are required for **Azure Monitor Metrics (preview)** since this is stored at the subscription level for the monitored resource.

> [!NOTE]
> For Linux, using Azure Monitor Metrics as the only destination is supported in v1.10.9.0 or higher.

:::image type="content" source="media/data-collection-performance/destination-metrics.png" lightbox="media/data-collection-performance/destination-metrics.png" alt-text="Screenshot that shows configuration of an Azure Monitor Logs destination in a data collection rule.":::

## Verify data collection
To verify that data is being collected in the Log Analytics workspace, check for records in the **Perf** table. From the virtual machine or from the Log Analytics workspace in the Azure portal, select **Logs** and then click the **Tables** button. Under the **Virtual machines** category, click **Run** next to **Perf**. 

:::image type="content" source="media/data-collection-performance/verify-performance-counter.png" lightbox="media/data-collection-performance/verify-performance-counter.png" alt-text="Screenshot that shows records returned from Perf table." :::

To verify that data is being collected in Azure Monitor Metrics, select **Metrics** from the virtual machine in the Azure portal. Select **Virtual Machine Guest** (Windows) or **azure.vm.linux.guestmetrics** for the namespace and then select a metric to add to the view.

:::image type="content" source="media/data-collection-performance/verify-metrics.png" lightbox="media/data-collection-performance/verify-metrics.png" alt-text="Screenshot that shows client metrics in Metrics explorer." :::

## Performance counters

The following performance counters are available to be collected by the Azure Monitor Agent for Windows and Linux virtual machines. The sample frequency can be changed when creating or updating the data collection rule.

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

- Learn more about [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md).
- Learn more about [data collection rules](../essentials/data-collection-rule-overview.md).
