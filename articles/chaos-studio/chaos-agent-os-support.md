---
title: Chaos Agent Version Compatibility
description: Compatibility reference for the Azure Chaos Studio Agent across operating systems, fault differences, and package dependencies.
services: chaos-studio
author: nikhilkaul-msft
ms.topic: article
ms.date: 03/03/2025
ms.reviewer: nikhilkaul
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

| Operating System | Version | Notes | Network Disconnect | Network Disconnect via Firewall | Network Latency | Network Packet Loss | Network Isolation | DNS Failure | CPU Pressure | Physical Memory Pressure | Virtual Memory Pressure | Disk IO Pressure | Stop Service | Kill Process | Pause Process | Time Change | Arbitrary Stress-ng Stressor |
|:----------------:|:-------:|-------|:------------------:|:-------------------------------:|:---------------:|:-------------------:|:-----------------:|:-----------:|:------------:|:------------------------:|:-----------------------:|:----------------:|:------------:|:------------:|:-------------:|:-----------:|:----------------------------:|
| Azure Linux (Mariner)     | 3       | **Prerequisite:** Manually install `stress-ng` for CPU, Memory, and Disk I/O faults    | ✓ (outbound)       | ✗                               | ✓ (outbound)      | ✓ (outbound)        | ✓ (outbound)      | ✗           | ✓            | ✓                        | ✗                       | ✓                      | ✓            | ✓            | ✓             | ✗           | ✓                            |
| Red Hat Enterprise Linux  | 8.x+    | Tested up to RHEL 8.9                                                                         | ✓ (outbound)       | ✗                               | ✓ (outbound)      | ✓ (outbound)        | ✓ (outbound)      | ✗           | ✓            | ✓                        | ✗                       | ✓                      | ✓            | ✓            | ✓             | ✗           | ✓                            |
| Ubuntu Server             | 20.04+  | —                                                                                             | ✓ (outbound)       | ✗                               | ✓ (outbound)      | ✓ (outbound)        | ✓ (outbound)      | ✗           | ✓            | ✓                        | ✗                       | ✓                      | ✓            | ✓            | ✓             | ✗           | ✓                            |
| Debian (Buster)           | 10+     | **Prerequisite:** Ensure `AzCLI unzip` utility is installed                                   | ✓ (outbound)       | ✗                               | ✓ (outbound)      | ✓ (outbound)        | ✓ (outbound)      | ✗           | ✓            | ✓                        | ✗                       | ✓                      | ✓            | ✓            | ✓             | ✗           | ✓                            |
| openSUSE Leap             | 15.2+   | —                                                                                             | ✓ (outbound)       | ✗                               | ✓ (outbound)      | ✓ (outbound)        | ✓ (outbound)      | ✗           | ✓            | ✓                        | ✗                       | ✓                      | ✓            | ✓            | ✓             | ✗           | ✓                            |
| Oracle Linux              | 8.3+    | —                                                                                             | ✓ (outbound)       | ✗                               | ✓ (outbound)      | ✓ (outbound)        | ✓ (outbound)      | ✗           | ✓            | ✓                        | ✗                       | ✓                      | ✓            | ✓            | ✓             | ✗           | ✓                            |
| Other Operating Systems   | N/A     | Not officially tested. May work, but more troubleshooting/manual dependency installation may be required | ?                  | ?                               | ?                 | ?                   | ?                 | ?           | ?            | ?                        | ?                       | ?                      | ?            | ?            | ?             | ?           | ?                            |
| **Required dependencies** |         | List of Linux packages required in order for the fault to work via the Azure Chaos Studio agent | `tc` and `netem`   | Unavailable on Linux            | `tc` and `netem`  | `tc` and `netem`    | `tc` and `netem`   | Unavailable on Linux | `stress-ng`  | `stress-ng`               | Unavailable on Linux     | `stress-ng`             | None         | None         | Unavailable on Linux | Unavailable on Linux | `stress-ng` |

---

## Manual package dependency installation

While the agent may autoinstall some dependencies on certain mainstream Linux operating systems, you might need to install ```stress-ng``` manually on certain operating systems due to limitations or other required configurations:

### Linux (Debian/Ubuntu):

```sudo apt-get install stress-ng unzip```

### Red Hat Enterprise Linux / CentOS:
 

```sudo yum install stress-ng```


### openSUSE / Oracle Linux:
 

```sudo zypper install stress-ng```


### Azure Linux (Mariner):

```sudo tdnf install stress-ng```

---

## Hardening standards

### Linux hardening 

The agent isn't currently tested against custom Linux distributions or hardened Linux distributions (for example, FIPS or SELinux).

---
## Unlisted operating systems

If an operating system isn't currently listed, you may still attempt to install, use, and troubleshoot the virtual machine extension, agent, and agent-based capabilities, but Chaos Studio can't guarantee behavior or support for an unlisted operating system.

---
To request validation and support on more operating systems or versions, use the [Chaos Studio Feedback Community](https://aka.ms/ChaosStudioFeedback).
