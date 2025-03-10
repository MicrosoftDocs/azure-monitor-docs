---
title: Chaos Agent Version Compatibility
description: Compatibility reference for the Azure Chaos Studio Agent across operating systems, fault differences, and package dependencies.
services: chaos-studio
author: nikhilkaul-msft
ms.topic: article
ms.date: 03/03/2025
ms.author: abbyweisberg
ms.reviewer: nikhilkaul
ms.service: azure-chaos-studio
---

# Chaos Agent Version Compatibility

The following compatibility matrix outlines the officially supported operating systems for the Azure Chaos Studio Agent, along with the minimum supported version and the fault support from our agent fault library. In the fault columns, a check (✓) indicates full support, "✓ (outbound)" denotes that only outbound support is provided, and an "✗" means the fault isn't supported on that operating system.


---

## Windows Compatibility

| Operating System | Version | Notes | Network Disconnect | Network Disconnect via Firewall | Network Latency | Network Packet Loss | Network Isolation | DNS Failure | CPU Pressure | Physical Memory Pressure | Virtual Memory Pressure | Disk IO Pressure | Stop Service | Kill Process | Pause Process | Time Change | Arbitrary Stress-ng Stressor |
|:----------------:|:-------:|-------|:------------------:|:-------------------------------:|:---------------:|:-------------------:|:-----------------:|:-----------:|:------------:|:------------------------:|:-----------------------:|:----------------:|:------------:|:------------:|:-------------:|:-----------:|:----------------------------:|
| Windows Server   | 2016+   | Currently untested on Windows Server 2025 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ |

---

## Linux Compatibility

| Operating System          | Version | Notes | Network Disconnect | Network Disconnect via Firewall | Network Latency | Network Packet Loss | Network Isolation | DNS Failure | CPU Pressure | Physical Memory Pressure | Virtual Memory Pressure | Linux Disk IO Pressure | Stop Service | Kill Process | Pause Process | Time Change | Arbitrary Stress-ng Stressor |
|:-------------------------:|:-------:|-------|:------------------:|:-------------------------------:|:---------------:|:-------------------:|:-----------------:|:-----------:|:------------:|:------------------------:|:-----------------------:|:----------------------:|:------------:|:------------:|:-------------:|:-----------:|:----------------------------:|
| Azure Linux (Mariner)     | 3       | **Prerequisite:** Manually install `AzCLI stress-ng` for CPU, Memory, and Disk I/O faults | ✓ (outbound) | ✗ | ✓ (outbound) | ✓ (outbound) | ✓ (outbound) | ✗ | ✓ | ✓ | ✗ | ✓ | ✓ | ✓ | ✗ | ✗ | ✓ |
| Red Hat Enterprise Linux  | 8.x+    | Tested up to RHEL 8.9 | ✓ (outbound) | ✗ | ✓ (outbound) | ✓ (outbound) | ✓ (outbound) | ✗ | ✓ | ✓ | ✗ | ✓ | ✓ | ✓ | ✗ | ✗ | ✓ |
| Ubuntu Server             | 20.04+  | —     | ✓ (outbound) | ✗ | ✓ (outbound) | ✓ (outbound) | ✓ (outbound) | ✗ | ✓ | ✓ | ✗ | ✓ | ✓ | ✓ | ✗ | ✗ | ✓ |
| Debian (Buster)           | 10+     | **Prerequisite:** Ensure `AzCLI unzip` utility is installed | ✓ (outbound) | ✗ | ✓ (outbound) | ✓ (outbound) | ✓ (outbound) | ✗ | ✓ | ✓ | ✗ | ✓ | ✓ | ✓ | ✗ | ✗ | ✓ |
| openSUSE Leap             | 15.2+   | —     | ✓ (outbound) | ✗ | ✓ (outbound) | ✓ (outbound) | ✓ (outbound) | ✗ | ✓ | ✓ | ✗ | ✓ | ✓ | ✓ | ✗ | ✗ | ✓ |
| Oracle Linux              | 8.3+    | —     | ✓ (outbound) | ✗ | ✓ (outbound) | ✓ (outbound) | ✓ (outbound) | ✗ | ✓ | ✓ | ✗ | ✓ | ✓ | ✓ | ✗ | ✗ | ✓ |
| Other Operating Systems   | N/A     | Not officially tested. May work, but more troubleshooting/manual dependency installation may be required | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? | ? |

---

## Manual Package Dependencies for specific OS':

While the agent may autoinstall some dependencies on certain mainstream Linux OS', you might need to install the following packages manually on certain operating systems due to limitations or other required configurations:

### Linux (Debian/Ubuntu):

```sudo apt-get install stress-ng tc netem unzip```

### Red Hat Enterprise Linux / CentOS:
 

```sudo yum install stress-ng tc netem```


### openSUSE / Oracle Linux:
 

```sudo zypper install stress-ng tc netem```


### Azure Linux (Mariner):

Ensure that stress-ng is manually installed using your distribution’s package manager.

## Known Issues

### Windows DNS Fault:
The DNS fault on Windows requires the LKG plugin to be installed. If a conflicting plugin is present (that is, if the customer overrides the LKG plugin), the DNS fault can't execute.

### Hardened OS/Custom OS Support info: 
The agent isn't currently tested against custom Linux distributions or hardened Linux distributions (for example, FIPS or SELinux).

If an operating system isn't currently listed, you may still attempt to install, use, and troubleshoot the virtual machine extension, agent, and agent-based capabilities, but Chaos Studio can't guarantee behavior or support for an unlisted operating system.

To request validation and support on more operating systems or versions, use the [Chaos Studio Feedback Community](https://aka.ms/ChaosStudioFeedback).
