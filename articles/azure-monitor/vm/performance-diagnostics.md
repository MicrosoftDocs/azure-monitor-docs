---
title: Troubleshoot performance issues on Azure virtual machines using Performance Diagnostics (PerfInsights)
description: Use the Performance Diagnostics tool to identify and troubleshoot performance issues on your Azure virtual machine (VM).
ms.topic: troubleshooting
ms.date: 06/10/2025
ms.reviewer: poharjan

# Customer intent: As a VM administrator or a DevOps engineer, I want to analyze and troubleshoot performance issues on my Azure virtual machine so that I can resolve these issues myself or share Performance Diagnostics information with Microsoft Support.
---

# Troubleshoot performance issues on Azure virtual machines with Performance Diagnostics

**Applies to:** :heavy_check_mark: Linux VMs :heavy_check_mark: Windows VMs

Performance Diagnostics (PerfInsights) helps identify and troubleshoot performance issues on Azure virtual machines. It provides insights into high resource usage such as high CPU, memory, and disk usage, and helps you understand the root cause of performance issues. 

Run Performance Diagnostics directly from the Azure portal where you can review insights and reports about logs, configuration, and diagnostics data for the VM. Use this information to diagnose your issue before contacting Microsoft Support.

Performance Diagnostics stores all insights and reports in a storage account that you can configure for short data retention to minimize costs.

## Performance Diagnostics modes
Performance diagnostics operates in one of the following two modes:

* **Continuous diagnostics** collects data at five-second intervals and reports actionable insights about high resource usage every five minutes. Continuous diagnostics is Generally Available (GA) for Windows VMs and in Public Preview for Linux VMs.
* **On-demand diagnostics** helps you troubleshoot an ongoing performance issue by providing more in-depth data, insights, and recommendations that are based on data that's collected at a single moment. On-demand diagnostics is supported on both Windows and Linux.

The following table compares the data provided by Continuous and On-demand Performance Diagnostics. For a complete list of all the collected diagnostics data, see [Data collected](#data-collected).

| | Continuous | On-demand |
|:---|:---|:---|
| **Availability**  | GA for Windows VMs<br>Public Preview for Linux VMs | GA for Windows<br>GA for Linux VMs |
| **Insights generated** | Continuous actionable insights into high resource usage, such as high CPU, high memory, and high disk usage | On-demand actionable insights into high resource usage and various system configurations |
| **Data collection frequency** | Collects data every five seconds, updates are uploaded every five minutes | Collects data on demand for the selected duration of the on-demand run |
| **Reports generated** | Doesn't generate a report | Generates a report that has comprehensive diagnostics data |

## Supported troubleshooting scenarios

The following sections describe common scenarios for using continuous and on-demand performance diagnostics to identify and troubleshoot performance issues.

### Continuous diagnostics

Continuous Performance diagnostics lets you identify high resource usage by monitoring your VM regularly for:

- High CPU usage: Detects high CPU usage periods, and shows the top CPU usage consumers during those periods.
- High memory usage: Detects high memory usage periods, and shows the top memory usage consumers during those periods.
- High disk usage: Detects high disk usage periods on physical disks, and shows the top disk usage consumers during those periods.

### On-demand diagnostics
On-demand diagnostics provides different information between Windows and Linux VMs. The following sections describe the scenarios that are available for each platform.

### [Windows](#tab/windows)

You can run the following on-demand reports from Windows machines:

#### Quick analysis

This scenario collects the disk configuration and other important information, including:

- Event logs
- Network status for all incoming and outgoing connections
- Network and firewall configuration settings
- Task list for all applications that are currently running on the system
- Microsoft SQL Server database configuration settings (if VM is running SQL Server)
- Storage reliability counters
- Important Windows hotfixes
- Installed filter drivers

This is a passive collection of information that shouldn't affect the system.

>[!Note]
>This scenario is automatically included in each of the following scenarios.

#### Benchmarking
This scenario runs the [Diskspd](https://github.com/Microsoft/diskspd) benchmark test (IOPS and MBPS) for all drives that are attached to the VM.

> [!Note]
> This scenario can affect the system, and shouldn't be run on a live production system. If necessary, run this scenario in a dedicated maintenance window to avoid any problems. An increased workload that is caused by a trace or benchmark test can adversely affect the performance of your VM.

#### Performance analysis
This scenario runs a [performance counter](/windows/win32/perfctrs/performance-counters-portal) trace by using the counters that are specified in the `RuleEngineConfig.json file`. If the VM is identified as a server that is running SQL Server, a performance counter trace is run. It does so by using the counters that are found in the `RuleEngineConfig.json` file. This scenario also includes performance diagnostics data.

#### Azure Files analysis
This scenario runs a special performance counter capture together with a network trace. The capture includes all the Server Message Block (SMB) client shares counters. The following are some key SMB client share performance counters that are part of the capture:

| **Type**     | **SMB client shares counter** |
|--------------|-------------------------------|
| IOPS         | Data Requests/sec             |
|              | Read Requests/sec             |
|              | Write Requests/sec            |
| Latency      | Avg. sec/Data Request         |
|              | Avg. sec/Read                 |
|              | Avg. sec/Write                |
| IO Size      | Avg. Bytes/Data Request       |
|              | Avg. Bytes/Read               |
|              | Avg. Bytes/Write              |
| Throughput   | Data Bytes/sec                |
|              | Read Bytes/sec                |
|              | Write Bytes/sec               |
| Queue Length | Avg. Read Queue Length        |
|              | Avg. Write Queue Length       |
|              | Avg. Data Queue Length        |

#### Advanced performance analysis
When you run an advanced performance analysis, you select traces to run in parallel. If you want, you can run them all (Performance Counter, Xperf, Network, and StorPort).  

> [!Note]
> This scenario can affect the system, and shouldn't be run on a live production system. If necessary, run this scenario in a dedicated maintenance window to avoid any problems. An increased workload that is caused by a trace or benchmark test can adversely affect the performance of your VM.

### [Linux](#tab/linux)

You can run the following on-demand reports from Linux machines:

### Quick performance analysis

This scenario collects basic information such as storage and hardware configuration of your virtual machine, various logs, including:

- Operating System information
- PCI device information
- General Guest OS logs
- Configuration files
- Storage information
- Azure Virtual Machine Configuration (collected using [Azure Instance Metadata Service](/azure/virtual-machines/windows/instance-metadata-service))
- List of running processes, Disk, Memory, and CPU usage
- Networking information

This is a passive collection of information that shouldn't affect the system.

>[!Note]
>Quick performance analysis scenario is automatically included in each of the following scenarios:

### Performance analysis

This scenario is similar to Quick performance analysis but allows capturing diagnostics information for longer duration.

### HPC performance analysis

This scenario is meant for troubleshooting issues on HPC size VMs, meaning H-Series and N-Series. It checks a VMs configuration against what the Azure HPC Platform team has tested and recommends. It also collects logs and diagnostics related to the status and configuration of the special hardware that is available on those VMs, including:

- GPU Driver information
- GPU hardware diagnostics
- InfiniBand driver information and configuration
- InfiniBand device diagnostics
- Network configuration files
- Performance tuning information

>[!Note]
>Some tools used by the HPC performance analysis scenario, such as cli commands that are packaged in with device drivers, are not present on all VMs. In such cases, those portions of the analysis will be skipped. Running this scenario does not install any software on VMs or make any other permanent changes.

>[!Note]
>Running the HPC scenario directly from the Azure Portal is not supported at this time, so PerfInsights must be downloaded and run from the command line to use it.



### Performance diagnostics trace

Runs a rule-based engine in the background to collect data and diagnose ongoing performance issues. Rules are displayed in the report under the Category -> Finding tab.

Each rule consists of the following:

- Finding: Description of the finding.
- Recommendation: Recommendation on what action could be taken for the finding. There are also reference link(s) to documentation that provide more information on the finding and/or recommendation.
- Impact Level: Represents the potential for having an impact on performance.

The following categories of rules are currently supported:

- High resource usage:
  - High CPU usage: Detects high CPU usage periods, and shows the top CPU usage consumers during those periods.
  - High memory usage: Detects high memory usage periods, and shows the top memory usage consumers during those periods.
  - High disk usage: Detects high disk usage periods on physical disks, and shows the top disk usage consumers during those periods.
- Storage: Detects specific storage configurations.
- Memory: Detects specific memory configurations.
- GPU: Detects specific GPU configurations.
- Network: Detects specific network settings.
- System: Detects specific system settings.

>[!Note]
>[`*`] PCI information is not yet collected on Debian and SLES distributions.
>
>[`**`] /var/log/sysstat or /var/log/sa contains the System Activity Report (SAR) files that are collected by the sysstat package. If the sysstat package is not installed on the VM, the PerfInsights tool provides a recommendation to install it.

---


## Data collected

### [Windows](#tab/windows)

Performance Diagnostics collected the information in the following table from Windows machines., depending on the performance scenario you're using.

| Data collected | Quick performance analysis | Benchmarking | Performance analysis | Azure Files analysis | Advanced performance analysis |
|:---|:---:|:---:|:---:|:---:|:---:|
| Information from event logs | Yes  | Yes  | Yes  | Yes  | Yes  |
| System information  | Yes  | Yes  | Yes  | Yes  | Yes  |
| Volume map  | Yes  | Yes  | Yes  | Yes  | Yes  |
| Disk map    | Yes  | Yes  | Yes  | Yes  | Yes  |
| Running tasks     | Yes  | Yes  | Yes  | Yes  | Yes  |
| Storage reliability counters  | Yes  | Yes  | Yes  | Yes  | Yes  |
| Storage information   | Yes  | Yes  | Yes  | Yes  | Yes  |
| Fsutil output     | Yes  | Yes  | Yes  | Yes  | Yes  |
| Filter driver info  | Yes  | Yes  | Yes  | Yes  | Yes  |
| Netstat output    | Yes  | Yes  | Yes  | Yes  | Yes  |
| Network configuration   | Yes  | Yes  | Yes  | Yes  | Yes  |
| Firewall configuration  | Yes  | Yes  | Yes  | Yes  | Yes  |
| SQL Server configuration    | Yes  | Yes  | Yes  | Yes  | Yes  |
| Performance diagnostics traces *  | Yes  | Yes  | Yes  | Yes  | Yes  |
| Performance counter trace **  |  |    | Yes  |  | Yes  |
| SMB counter trace **  |  |    |    | Yes  |  |
| SQL Server counter trace ** |  |    | Yes  |  | Yes  |
| Xperf trace |  |    |    |  | Yes  |
| StorPort trace    |  |    |    |  | Yes  |
| Network trace     |  |    |    | Yes  | Yes  |
| Diskspd benchmark trace *** |  | Yes  |    |  |  |

### [Linux](#tab/linux)

Information about the Linux virtual machine, operating system, block devices, high resource consumers, configuration, and various logs are collected. Here are more details:

- Operating system
  - Linux distribution and version
  - Kernel information
  - Driver information
  - Azure HPC Driver VM Extension logs`*`
  - SELinux configuration`*`

- Hardware
  - PCI devices [`*`]
  - Output of lscpu`*`
  - System Management BIOS table dump`*`

- Processes and memory
  - List of processes (task name, memory used, files opened)
  - Total, available, and free physical memory
  - Total, available, and free swap memory
  - Profiling capture of CPU and processes CPU usage at 5-second interval
  - Profiling capture of processes memory usage at 5-second interval
  - User-limits for memory access`*`
  - NUMA configuration`*`

- GPU
  - Nvidia SMI output`*`
  - Nvidia DCGM Diagnostics`*`
  - Nvidia debug dump`*`

- Networking  
  - List of network adapters with adapters statistics
  - Network routing table
  - Opened ports and status
  - InfiniBand Partition Keys`*`
  - Output of ibstat`*`

- Storage
  - Block devices list
  - Partitions list
  - Mount points list
  - MDADM volume information
  - LVM volume information
  - Profiling capture on all disks at 5-second interval

- Logs
  - /var/log/messages
  - /var/log/syslog
  - /var/log/kern.log
  - /var/log/cron.log
  - /var/log/boot.log
  - /var/log/yum.log
  - /var/log/dpkg.log
  - /var/log/sysstat or /var/log/sa [`**`]
  - /var/log/cloud-init.log
  - /var/log/cloud-init-output.log
  - /var/log/gpu-manager.log
  - /var/log/waagent.log
  - /var/log/azure/[extension folder]/\*log\*
  - /var/opt/microsoft/omsconfig/omsconfig.log
  - /var/opt/microsoft/omsagent/log/omsagent.log
  - /etc/waagent.config
  - Output of journalctl for the last five days

- [Azure virtual machine instance metadata](/azure/virtual-machines/windows/instance-metadata-service)

`*` Only in HPC scenario

---

## Performance impact

The following table shows the results of running 12-hour tests of continuous Performance Diagnostics on a range of Windows OS versions, Azure VMs of sizes, and CPU loads. These results show a minimal effect on system resources.

| OS version | VM size | CPU load | Average CPU usage | 90th percentile CPU usage | 99th percentile CPU usage | Memory usage |
||:---|:---|:---|:---|:---|:---|
| Windows Server 2019     | B2s, A4V2, D5v2 | 20%, 50%, 80% | <0.5% | 2% | 3% | 42-43 MB |
| Windows Server 2016 SQL | B2s, A4V2, D5v2 | 20%, 50%, 80% | <0.5% | 2% | 3% | 42-43 MB |
| Windows Server 2019     | B2s, A4V2, D5v2 | 20%, 50%, 80% | <0.5% | 2% | 3% | 42-43 MB |
| Windows Server 2022     | B2s, A4V2, D5v2 | 20%, 50%, 80% | <0.5% | <0.5% | 3% | 42-43 MB |


## Storage costs
Assuming steady stress on the VM, the storage cost for continuous performance diagnostics is estimated to be less than one cent per month, assuming that you use locally redundant storage. It stores insights in a table and a JSON file in a BLOB container. Each row is approximately 0.5 KB, and the report is approximately 9 KB before compression. Two rows every five minutes plus the corresponding report upload equals 10 KB, or 0.00001 GB.

To calculate the storage cost:

- Rows per month: 17,280
- Size per row: 0.00001 GB
- **Total data size:** 17,280 x 0.000001 = 0.1728 GB

See [Azure Blob Storage pricing](https://azure.microsoft.com/pricing/details/storage/blobs/) for the latest prices. 

## Moving VM across regions

Azure VMs, and related network and storage resources, can be moved across regions by using Azure Resource Mover. However, moving VM extensions, including the Azure Performance Diagnostics VM extension, across regions isn't supported. You have to manually install the extension on the VM in the target region after you move the VM. For more information, see [Support matrix for moving Azure VMs between Azure regions](/azure/resource-mover/support-matrix-move-region-azure-vm).

## Sharing diagnostics data with Microsoft Support

When you open a support ticket with Microsoft, it's important to share the Performance Diagnostics report from an on-demand Performance Diagnostics run. The Microsoft Support contact provides the option to upload the on-demand Performance Diagnostics report to a workspace. Use either of the following methods to download the on-demand Performance Diagnostics report:

- Download the report from the Performance Diagnostics blade, as described in [View Performance Diagnostics reports](#view-performance-diagnostics-reports).
- Download the report from the storage account, as described in [View and manage storage account and stored data](#view-and-manage-storage-account-and-stored-data).



[!INCLUDE [Azure Help Support](includes/azure-help-support.md)]
