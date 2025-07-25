---
title: Troubleshoot Linux virtual machine performance issues with Performance Diagnostics (PerfInsights)
description: Learns how to use PerfInsights to troubleshoot Linux VM performance problems.
services: virtual-machines
documentationcenter: ''
author: anandhms
manager: dcscontentpm
tags: ''
ms.custom: sap:VM Performance, linux-related-content
ms.service: azure-virtual-machines
ms.collection: linux
ms.workload: infrastructure-services
ms.tgt_pltfrm: vm-linux
ms.topic: troubleshooting
ms.date: 06/10/2025
ms.author: jarrettr
---
# Troubleshoot Linux virtual machine performance issues with Performance Diagnostics (PerfInsights)

**Applies to:** :heavy_check_mark: Linux VMs

[PerfInsights Linux](https://aka.ms/perfinsightslinuxdownload) is a self-help diagnostics tool that collects and analyzes the diagnostic data, and provides a report to help troubleshoot Linux virtual machine performance problems in Azure. Use Performance Diagnostics to identify and troubleshoot performance issues in one of two modes: 

- **Continuous diagnostics** collects data at five-second intervals and reports actionable insights about high resource usage every five minutes. 

- **On-demand diagnostics** helps you troubleshoot an ongoing performance issue with more in-depth data, insights, and recommendations based on data collected at a single point in time.

This article explains how to download the Performance Diagnostics extension to your Linux VM and run the tool using the CLI tool. You can also [run Performance Diagnostics from the portal](../windows/performance-diagnostics.md).

If you are experiencing performance problems with virtual machines, before contacting support, run this tool.

## Supported troubleshooting scenarios

You can use Performance Diagnostics to troubleshoot various scenarios. The following sections describe common scenarios for using Continuous and On-Demand Performance Diagnostics to identify and troubleshoot performance issues. For a comparison of Continuous and On-Demand Performance Diagnostics, see [Performance Diagnostics insights and reports](../windows/performance-diagnostics.md).

## Continuous diagnostics

Continuous Performance diagnostics lets you identify high resource usage by monitoring your VM regularly for: 

- High CPU usage: Detects high CPU usage periods and shows the top CPU usage consumers during those periods. 

- High memory usage: Detects high memory usage periods and shows the top memory usage consumers during those periods. 

- High disk usage: Detects high disk usage periods on physical disks and shows the top disk usage consumers during those periods.

PerfInsights can collect and analyze several kinds of information. The following sections cover common scenarios.

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

## What kind of information is collected by PerfInsights

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

## Run the PerfInsights Linux on your VM

### What do I have to know before I run the tool

#### Tool requirements

- This tool must be run on the VM that has the performance issue.
- Python 3.6 or a later version, must be installed on the VM. 
  > [!Note]
  > Python 2 is no longer supported by the Python Software Foundation (PSF). If Python 2.7 is installed on the VM, PerfInsights can be installed. However, no changes or bug fixes will be made in PerfInsights to support Python 2.7. For more information, see [Sunsetting Python 2](https://www.python.org/doc/sunset-python-2/).

- The following distributions are currently supported:

  > [!NOTE]  
  > Microsoft has only tested the versions that are listed in the table. If a version isn't listed in the table, then it isn't explicitly tested by Microsoft, but the version might still work.

    | Distribution | Version |
    |:---|:---|
    | Oracle Linux Server | 6.10 [`*`], 7.3, 7.5, 7.6, 7.7, 7.8, 7.9 |
    | RHEL | 7.4, 7.5, 7.6, 7.7, 7.8, 7.9, 8.0 [`*`], 8.1, 8.2, 8.4, 8.5, 8.6, 8.7, 8.8, 8.9 |
    | Ubuntu | 16.04, 18.04, 20.04, 22.04 |
    | Debian | 9, 10, 11 [`*`] |
    | SLES | 12 SP5 [`*`], 15 SP1 [`*`], 15 SP2 [`*`], 15 SP3 [`*`], 15 SP4 [`*`], 15 SP5 [`*`], 15 SP6 [`*`] |
    | AlmaLinux | 8.4, 8.5 |
    | Azure Linux | 2.0, 3.0 |

>[!Note]
>[`*`] Please refer to [Known issues](#known-issues) section

>[!Note]
>[`*`] The HPC scenario relies on the [HPCDiag](https://aka.ms/hpcdiag) tool, so check its support matrix for supported VM sizes and OSes. In particular, NDv4 size VMs aren't yet supported and reports for those VMs may show extraneous findings.

### Known issues

- RHEL 8 doesn't have Python installed by default because both Python 2 and Python 3.6 are available. To install Python 3.6, run the `yum install python3` command.

- PCI devices information is not collected on Debian based distributions.

- LVM information is partially collected on some distributions.


## Next steps

You can upload diagnostics logs and reports to Microsoft Support for further review. When you work with the Microsoft Support staff, they might request that you transmit the output that is generated by PerfInsights to assist with the troubleshooting process.

The following screenshot shows a message similar to what you might receive:

:::image type="content" source="media/how-to-use-perfinsights-linux/support-email.png" alt-text="Screenshot of sample message from Microsoft Support。":::

Follow the instructions in the message to access the file transfer workspace. For additional security, you have to change your password on first use.

After you sign in, you will find a dialog box to upload the **PerformanceDiagnostics\_yyyy-MM-dd\_hh-mm-ss-fff.tar.gz** file that was collected by PerfInsights.

[!INCLUDE [Azure Help Support](includes/azure-help-support.md)]
