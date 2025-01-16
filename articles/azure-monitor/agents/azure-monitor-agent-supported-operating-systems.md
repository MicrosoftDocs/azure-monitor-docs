---
title: Azure Monitor Agent supported operating systems
description: Identifies the operating systems supported by Azure Monitor Agent.
ms.topic: conceptual
author: rboucher
ms.author: robb
ms.date: 01/08/2025
ms.custom: references_regions
ms.reviewer: jeffwo

# Customer intent: As an IT manager, I want to understand the capabilities of Azure Monitor Agent to determine whether I can use the agent to collect the data I need from the operating systems of my virtual machines.

---

# Azure Monitor Agent supported operating systems and environments
This article lists the operating systems supported by [Azure Monitor Agent](./azure-monitor-agent-overview.md). See [Install and manage Azure Monitor Agent](./azure-monitor-agent-manage.md) for details on installing the agent.

> [!NOTE]
> All operating systems listed are assumed to be x64. x86 isn't supported for any operating system.

## Windows operating systems

| Operating system | Support |
|:---|:---:|
| Windows Server 2022                                      | ✓ |
| Windows Server 2022 Core                                 | ✓ |
| Windows Server 2019                                      | ✓ |
| Windows Server 2019 Core                                 | ✓ |
| Windows Server 2016                                      | ✓ |
| Windows Server 2016 Core                                 | ✓ |
| Windows Server 2012 R2                                   | ✓ |
| Windows Server 2012                                      | ✓ |
| Windows 11 Client and Pro                                | ✓<sup>1,2</sup> |
| Windows 11 Enterprise<br>(including multi-session)       | ✓ |
| Windows 10 1803 (RS4) and higher                         | ✓<sup>1</sup> |
| Windows 10 Enterprise<br>(including multi-session) and Pro<br>(Server scenarios only)  | ✓ |
| Azure Stack HCI                                          | ✓ |
| Windows IoT Enterprise                                   | ✓ |

<sup>1</sup> Requires Azure Monitor agent [client installer](./azure-monitor-agent-windows-client.md) for Windows client devices.<br>
<sup>2</sup> Also supported on Arm64-based machines.

## Linux operating systems

> [!CAUTION]
> CentOS is a Linux distribution that is nearing End Of Life (EOL) status. Consider your use and planning accordingly. For more information, see the [CentOS End Of Life guidance](/azure/virtual-machines/workloads/centos/centos-end-of-life).

| Operating system | Support <sup>1</sup> |
|:---|:---:|
| AlmaLinux 9                                                 | ✓<sup>2</sup> |
| AlmaLinux 8                                                 | ✓<sup>2</sup> |
| Amazon Linux 2                                              | ✓ |
| Amazon Linux 2023                                           | ✓ |
| Azure Linux 3.0                                             | ✓<sup>2</sup> |
| CentOS Linux 8                                              | ✓ |
| CentOS Linux 7                                              | ✓<sup>2</sup> |
| CBL-Mariner 2.0                                             | ✓<sup>2,3</sup> |
| Debian 12                                                   | ✓ |
| Debian 11                                                   | ✓<sup>2</sup> |
| Debian 10                                                   | ✓ |
| Debian 9                                                    | ✓ |
| OpenSUSE 15                                                 | ✓ |
| Oracle Linux 9                                              | ✓ |
| Oracle Linux 8                                              | ✓ |
| Oracle Linux 7                                              | ✓ |
| Red Hat Enterprise Linux Server 9+                          | ✓ |
| Red Hat Enterprise Linux Server 8.6+                        | ✓<sup>2</sup> |
| Red Hat Enterprise Linux Server 8.0-8.5                     | ✓ |
| Red Hat Enterprise Linux Server 7                           | ✓ |
| Rocky Linux 9                                               | ✓ |
| Rocky Linux 8                                               | ✓ |
| SUSE Linux Enterprise Server 15 SP6                         | ✓<sup>2</sup> |
| SUSE Linux Enterprise Server 15 SP5                         | ✓<sup>2</sup> |
| SUSE Linux Enterprise Server 15 SP4                         | ✓<sup>2</sup> |
| SUSE Linux Enterprise Server 15 SP3                         | ✓ |
| SUSE Linux Enterprise Server 15 SP2                         | ✓ |
| SUSE Linux Enterprise Server 15 SP1                         | ✓ |
| SUSE Linux Enterprise Server 15                             | ✓ |
| SUSE Linux Enterprise Server 12                             | ✓ |
| Ubuntu 24.04 LTS                                            | ✓<sup>2</sup> |
| Ubuntu 22.04 LTS                                            | ✓<sup>2</sup> |
| Ubuntu 20.04 LTS                                            | ✓<sup>2</sup> |
| Ubuntu 18.04 LTS                                            | ✓<sup>2</sup> |
| Ubuntu 16.04 LTS                                            | ✓ |

<sup>1</sup> Requires Python (2 or 3) to be installed on the machine. Requires packages _which_ and _initscripts_.<br>
<sup>2</sup> Also supported on Arm64-based machines.<br>
<sup>3</sup> Does not include the required least 4GB of disk space by default. See the following note. 

> [!NOTE]
> Machines and appliances that run heavily customized or stripped-down versions of the above distributions and hosted solutions that disallow customization by the user are not supported. Azure Monitor relies on various packages and other baseline functionality that is often removed from such systems. Installation may require some environmental modifications that the appliance vendor normally disallows. For example, [GitHub Enterprise Server](https://docs.github.com/en/enterprise-server/admin/overview/about-github-enterprise-server) is not supported due to heavy customization as well as [documented, license-level disallowance](https://docs.github.com/en/enterprise-server/admin/overview/system-overview#operating-system-software-and-patches) of operating system modification.

> [!NOTE]
> Disk size in Azure Linux (previously known as CBL-Mariner) is by default lower compared to other Azure VMs, which are about 30 GB. The Azure Monitor Agent requires at least 4 GB disk size in order to install and run successfully. See the [Azure Linux documentation](https://eng.ms/docs/products/mariner-linux/gettingstarted/azurevm/azurevm#disk-size) for more information and instructions on how to increase disk size before installing the agent.

## Hardening standards
Azure Monitoring Agent supports most industry-standard hardening standards and is continuously tested and certified against these standards every release. All Azure Monitor Agent scenarios are designed from the ground up with security in mind.

### Windows hardening
Azure Monitoring Agent supports all standard Windows hardening standards, including STIG and FIPs, and is FedRamp compliant under Azure Monitor.

### Linux hardening

> [!NOTE]
> Only the Azure Monitoring Agent for Linux supports these hardening standards. The standards are not supported by the [Dependency Agent](../vm/vminsights-dependency-agent-maintenance.md) or the [Azure Diagnostics extension](./diagnostics-extension-overview.md).

The Azure Monitoring Agent for Linux supports various hardening standards for Linux operating systems and distros. Every release of the agent is tested and certified against the supported hardening standards using images that are publicly available on the Azure Marketplace, including images published by [Center for Internet Security (CIS)](/compliance/regulatory/offering-cis-benchmark). Only the settings and hardening that are applied to those images are supported. CIS-published images with additional customizations and images customized with settings and hardening that differs from official CIS benchmarks are not supported.

Currently supported hardening standards:
- SELinux
- CIS level 1 and 2<sup>1</sup>
- STIG
- FIPS
- FedRAMP

<sup>1</sup> Only the below-listed distributions are supported:<br>

| CIS-hardened operating system | Support |
|:---|:---:|
| CentOS Linux 7                    | ✓ |
| Debian 10                         | ✓ |
| Oracle Linux 8                    | ✓ |
| Ubuntu 18.04 LTS                  | ✓ |
| Ubuntu 20.04 LTS                  | ✓ |
| Red Hat Enterprise Linux Server 7 | ✓ |
| Red Hat Enterprise Linux Server 8 | ✓ |
| Red Hat Enterprise Linux Server 9 | ✓ |

> [!IMPORTANT]  
> Configuring your Linux Machine system-wide crypto policy to "FUTURE" does not work with the Azure Monitor Agent.
> This policy disables certain cryptographic algorithms and thus prevents communication with backend Azure Monitor services that use best practice crypto policies.
> Specifically, the FUTURE policy disables some algorithms that use less than 3072 bits keys, such as SHA-1, RSA, and Diffie-Hellman.

To identify the current policy setting mode, run the following update-crypto-policies command:

```cmd
sudo update-crypto-policies --show
```

## On-premises and other clouds
Azure Monitor agent is supported on machines in other clouds and on-premises with [Azure Arc-enabled servers](/azure/azure-arc/servers/overview). Azure Monitor agent authenticates to your workspace with managed identity, which is created when you install the [Connected Machine agent](/azure/azure-arc/servers/agent-overview), which is part of Azure Arc. The legacy Log Analytics agent authenticated using the workspace ID and key, so it didn't need Azure Arc. Managed identity is a more secure and manageable authentication solution. 

The Azure Arc agent is only used as an installation mechanism and does not add any cost or resource consumption. There are paid options for Azure Arc, but these aren't required for the Azure Monitor agent.



## Next steps

- [Install the Azure Monitor Agent](azure-monitor-agent-manage.md) on Windows and Linux virtual machines.
- [Identify requirements and prerequisites](azure-monitor-agent-requirements.md) for Azure Monitor Agent installation.
