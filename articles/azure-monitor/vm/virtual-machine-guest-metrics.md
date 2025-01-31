---
title: Virtual machine guest performance counters
description: Guest metrics and performance counters collected by the Azure Monitor Agent for Linux and Windows virtual machines
author: EdB-MSFT
ms.author: edbaynash
services: azure-monitor
ms.topic: conceptual
ms.date: 01/29/2025

# Customer intent: As an Azure administrator I want to learn about the guest metrics and performance counters collected by the Azure Monitor Agent for Linux and Windows virtual machines
---


# Virtual machine guest performance counters  


The Azure Monitor Agent collects guest metrics or performance counters from Windows and Linux virtual machines. These metrics are collected from the guest operating system and are useful for monitoring virtual machine performance. The performance counters can be stored in an Azure Monitor Log Analytics workspace or an Azure Monitor workspace. For information on how to collect data from a virtual machine using Azure Monitor Agent, see [Collect performance counters with Azure Monitor Agent](../agents/data-collection-performance.md).  For information on how to install Azure Monitor Agent, see [Install and manage the Azure Monitor Agent](../agents/azure-monitor-agent-manage.md).

Platform metrics are metrics that are automatically collected by Azure Monitor for each resource type. For a complete list of platform metrics, see [Azure Monitor supported metrics](/azure/azure-monitor/reference/metrics-index).

## Performance counters

The following performance counters are collected by the Azure Monitor Agent for Windows and Linux virtual machines:
The default sample frequency is 60 seconds. The sample frequency can be changed when creating or updating the data collection rule.

### [Windows virtual machines](#tab/windows)

###   Windows performance counters

The following performance counters are collected from Windows virtual machines by the Azure Monitor Agent:


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


### [Linux virtual machines](#tab/linux)

### Linux performance counters

The following performance counters are collected from Linux virtual machines by the Azure Monitor Agent:

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

+ [Install and manage the Azure Monitor Agent](../agents/azure-monitor-agent-manage.md)
+ [Collect performance counters with Azure Monitor Agent](../agents/data-collection-performance.md)

