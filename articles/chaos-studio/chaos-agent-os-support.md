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

The following compatibility matrix outlines the officially supported operating systems for the Azure Chaos Studio Agent, along with the minimum supported version and the fault support from our agent fault library. In the fault columns, a check (✓) indicates full support, “✓ (outbound)” denotes that only outbound support is provided, and an “✗” means the fault is not supported on that operating system.

> **Note:** While the chaos agent will attempt to auto-install dependencies on certain mainstream OS’s, these are open source packages that you can install yourself using the commands in the package dependencies section. For Linux, the required packages are:
> 
> ```AzCLI
> sudo apt-get install stress-ng tc netem
> ```

---

## Windows Compatibility

| Operating System      | Version  | Agent Compatibility | Notes                                                                                                  | Network Disconnect | Network Disconnect via Firewall | Network Latency | Network Packet Loss | Network Isolation | DNS Failure | CPU Pressure | Physical Memory Pressure | Virtual Memory Pressure | Disk IO Pressure | Stop Service | Kill Process | Pause Process | Time Change | Arbitrary Stress-ng Stressor |
|:---------------------:|:--------:|:-------------------:|--------------------------------------------------------------------------------------------------------|:------------------:|:-------------------------------:|:---------------:|:-------------------:|:-----------------:|:-----------:|:------------:|:------------------------:|:-----------------------:|:----------------:|:------------:|:------------:|:-------------:|:-----------:|:----------------------------:|
| Windows Server | 2016+    | ✓                   | Currently untested on Windows Server 2025                                                                         | ✓                | ✓                              | ✓              | ✓                   | ✓                | ✓           | ✓            | ✓                      | ✓                     | ✓               | ✓            | ✓            | ✓           | ✓         | ✗                          |

---

## Linux Compatibility

| Operating System                | Version  | Agent Compatibility   | Notes                                                                                                                      | Network Disconnect  | Network Disconnect via Firewall | Network Latency  | Network Packet Loss  | Network Isolation  | DNS Failure | CPU Pressure | Physical Memory Pressure | Virtual Memory Pressure | Linux Disk IO Pressure | Stop Service | Kill Process | Pause Process | Time Change | Arbitrary Stress-ng Stressor |
|:-------------------------------:|:--------:|:---------------------:|----------------------------------------------------------------------------------------------------------------------------|:-------------------:|:-------------------------------:|:----------------:|:--------------------:|:------------------:|:-----------:|:------------:|:------------------------:|:-----------------------:|:----------------------:|:------------:|:------------:|:-------------:|:-----------:|:----------------------------:|
| Azure Linux (Mariner)           | Mariner | ✓                     | **Prerequisite:** Manually install ```AzCLI stress-ng``` for CPU, Memory, and Disk I/O faults                            | ✓ (outbound)           | ✗                              | ✓ (outbound)        | ✓ (outbound)              | ✓ (outbound)          | ✗           | ✓            | ✓                      | ✗                     | ✓                    | ✓            | ✓            | ✗           | ✗         | ✓                          |
| Red Hat Enterprise Linux 8.x    | 8.x+    | ✓                     | Tested up to RHEL 8.9                                                                                                      | ✓ (outbound)           | ✗                              | ✓ (outbound)        | ✓ (outbound)              | ✓ (outbound)          | ✗           | ✓            | ✓                      | ✗                     | ✓                    | ✓            | ✓            | ✗           | ✗         | ✓                          |
| Ubuntu Server 20.04/22.04 LTS     | 20.04+  | ✓                     | —                                                                                                                          | ✓ (outbound)           | ✗                              | ✓ (outbound)        | ✓ (outbound)              | ✓ (outbound)          | ✗           | ✓            | ✓                      | ✗                     | ✓                    | ✓            | ✓            | ✗           | ✗         | ✓                          |
| Debian 10 (Buster)              | 10+     | ✓                     | **Prerequisite:** Ensure ```AzCLI unzip``` utility is installed                                                            | ✓ (outbound)           | ✗                              | ✓ (outbound)        | ✓ (outbound)              | ✓ (outbound)          | ✗           | ✓            | ✓                      | ✗                     | ✓                    | ✓            | ✓            | ✗           | ✗         | ✓                          |
| openSUSE Leap 15.2              | 15.2+   | ✓                     | —                                                                                                                          | ✓ (outbound)           | ✗                              | ✓ (outbound)        | ✓ (outbound)              | ✓ (outbound)          | ✗           | ✓            | ✓                      | ✗                     | ✓                    | ✓            | ✓            | ✗           | ✗         | ✓                          |
| Oracle Linux 8.3                | 8.3+    | ✓                     | —                                                                                                                          | ✓ (outbound)           | ✗                              | ✓ (outbound)        | ✓ (outbound)              | ✓ (outbound)          | ✗           | ✓            | ✓                      | ✗                     | ✓                    | ✓            | ✓            | ✗           | ✗         | ✓                          |
| Other Operating Systems         | N/A     | Not officially tested | May work, but additional troubleshooting required                                                                        | ✗                 | ✗                              | ✗              | ✗                    | ✗                | ✗           | ✗            | ✗                      | ✗                     | ✗                    | ✗            | ✗            | ✗           | ✗         | ✗                          |

---

## Additional Package Dependency Information

For Linux distributions, the following open source packages are required for fault injection:

- ```AzCLI
stress-ng
