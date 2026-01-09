---
title: Azure Monitor Agent Supported Operating Systems
description: Learn the operating systems that are supported by the Azure Monitor Agent.
ms.topic: concept-article
ms.date: 03/07/2025
ms.custom: references_regions
ms.reviewer: jeffwo

# Customer intent: As an IT manager, I want to understand the capabilities of the Azure Monitor Agent to determine whether I can use the agent to collect the data I need from the operating systems of my virtual machines.

---

# Azure Monitor Agent supported operating systems and environments

This article lists the operating systems that the [Azure Monitor Agent](./azure-monitor-agent-overview.md) supports. For installation information, see [Install and manage the Azure Monitor Agent](./azure-monitor-agent-manage.md).

> [!NOTE]
> All operating systems listed are assumed to be x64. x86 isn't supported for any operating system.

## Windows operating systems

| Operating system | Support |
|:---|:---:|
| Windows Server 2025                                      | ✓ |
| Windows Server 2022                                      | ✓ |
| Windows Server 2022 Core                                 | ✓ |
| Windows Server 2019                                      | ✓ |
| Windows Server 2019 Core                                 | ✓ |
| Windows Server 2016                                      | ✓ |
| Windows Server 2016 Core                                 | ✓ |
| Windows Server 2012 R2 with an ESU agreement             | ✓ |
| Windows 11 Client and Pro                                | ✓<sup>1, 2</sup> |
| Windows 11 Enterprise<br>(including multi-session)       | ✓ |
| Windows 10 1803 (RS4) and later                          | ✓<sup>1</sup> |
| Windows 10 Enterprise<br>(including multi-session) and Pro<br>(server scenarios only)  | ✓ |
| Azure Local                                              | ✓ |
| Windows IoT Enterprise                                   | ✓ |

<sup>1</sup> Requires the Azure Monitor Agent [client installer](./azure-monitor-agent-windows-client.md) for Windows client devices.<br>
<sup>2</sup> Also supported on ARM64-based machines.

## Linux operating systems

| Operating system | Support <sup>1</sup> |
|:---|:---:|
| AlmaLinux 9                                                 | ✓ |
| AlmaLinux 8                                                 | ✓<sup>2</sup> |
| Amazon Linux 2                                              | ✓ |
| Amazon Linux 2023                                           | ✓ |
| Azure Linux 3.0                                             | ✓<sup>2</sup> |
| CBL-Mariner 2.0                                             | ✓<sup>2, 3</sup> |
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
| Red Hat Enterprise Linux Server 7.9                         | ✓ |
| Rocky Linux 9                                               | ✓ |
| Rocky Linux 8                                               | ✓ |
| SUSE Linux Enterprise Server 15 SP7                         | ✓<sup>2</sup> |
| SUSE Linux Enterprise Server 15 SP6                         | ✓<sup>2</sup> |
| SUSE Linux Enterprise Server 15 SP5                         | ✓<sup>2</sup> |
| SUSE Linux Enterprise Server 15 SP4                         | ✓<sup>2</sup> |
| SUSE Linux Enterprise Server 15 SP3                         | ✓ |
| SUSE Linux Enterprise Server 15 SP2                         | ✓ |
| SUSE Linux Enterprise Server 15 SP1                         | ✓ |
| SUSE Linux Enterprise Server 15                             | ✓ |
| SUSE Linux Enterprise Server 12 SP5                         | ✓ |
| Ubuntu 24.04 LTS                                            | ✓<sup>2</sup> |
| Ubuntu 22.04 LTS                                            | ✓<sup>2</sup> |
| Ubuntu 20.04 LTS                                            | ✓<sup>2</sup> |
| Ubuntu 18.04 LTS                                            | ✓<sup>2</sup> |
| Ubuntu 16.04 LTS                                            | ✓ |

<sup>1</sup> Requires Python (3 or 2) to be installed on the machine. Requires packages _which_ and _initscripts_.<br>
<sup>2</sup> Also supported on ARM64-based machines.<br>
<sup>3</sup> Does not include the required minimum 4 GB of disk space by default. See the following note. 

> [!NOTE]
> - Machines and appliances that run heavily customized or stripped-down versions of the listed distributions and hosted solutions that disallow customization by the user are not supported. Azure Monitor relies on various packages and other baseline functionality that is often removed from these kinds of systems. Installations might require some environment modifications that the appliance vendor normally disallows. For example, [GitHub Enterprise Server](https://docs.github.com/en/enterprise-server/admin/overview/about-github-enterprise-server) is not supported due to heavy customization and because of [documented, license-level disallowance](https://docs.github.com/en/enterprise-server/admin/overview/system-overview#operating-system-software-and-patches) of operating system modification.
> - Disk size in Azure Linux (previously known as CBL-Mariner) is by default lower compared to other Azure VMs, which are about 30 GB. The Azure Monitor Agent requires at least a 4-GB disk size to install and run successfully. For more information and for instructions on how to increase disk size before you install the agent, see the [Azure Linux documentation](https://eng.ms/docs/products/mariner-linux/gettingstarted/azurevm/azurevm#disk-size).

## Hardening standards

The Azure Monitor Agent supports most industry-standard hardening standards and is continuously tested and certified against these standards for every release. All Azure Monitor Agent scenarios are explicitly designed for security.

### Windows hardening

The Azure Monitor Agent supports all standard Windows hardening standards, including Security Technical Implementation Guides (STIGs) and Federal Information Processing Standards (FIPS), and is Federal Risk and Authorization Management Program (FedRAMP) compliant under Azure Monitor.

### Linux hardening

> [!NOTE]
> Only the Azure Monitor Agent for Linux supports the hardening standards described in this section. The standards aren't supported by the [Dependency Agent](../vm/vminsights-dependency-agent-maintenance.md) or by the [Azure Diagnostics extension](./diagnostics-extension-overview.md).

The Azure Monitor Agent for Linux supports various hardening standards for Linux operating systems and distributions. Every release of the agent is tested and certified against the supported hardening standards by using images that are publicly available in Azure Marketplace, including images published by [Center for Internet Security (CIS)](/compliance/regulatory/offering-cis-benchmark). Only settings and hardening that apply to those images are supported. CIS-published images that have more customizations and images customized with settings and hardening that differs from official CIS benchmarks aren't supported.

Currently supported hardening standards:

- SELinux
- CIS level 1 and 2<sup>1</sup>
- STIG
- FIPS
- FedRAMP

<sup>1</sup> Only the following distributions are supported:<br>

| CIS-hardened operating system | Support |
|:---|:---:|
| Debian 10                         | ✓ |
| Oracle Linux 8                    | ✓ |
| Ubuntu 18.04 LTS                  | ✓ |
| Ubuntu 20.04 LTS                  | ✓ |
| Red Hat Enterprise Linux Server 7 | ✓ |
| Red Hat Enterprise Linux Server 8 | ✓ |
| Red Hat Enterprise Linux Server 9 | ✓ |

> [!IMPORTANT]  
> Configuring your Linux machine system-wide crypto policy to "FUTURE" does not work with the Azure Monitor Agent. This policy disables certain cryptographic algorithms and prevents communication with back-end Azure Monitor services that use best-practice crypto policies. Specifically, the FUTURE policy disables some algorithms that use less than 3,072-bit keys, such as SHA-1, RSA, and Diffie-Hellman.
>
> To identify the current policy setting mode, run the following `update-crypto-policies` command:
>
> ```cmd
> sudo update-crypto-policies --show
> ```

## On-premises and in other clouds

The Azure Monitor Agent is supported on machines in other clouds and in on-premises environments via [Azure Arc-enabled servers](/azure/azure-arc/servers/overview). The Azure Monitor Agent authenticates to your workspace by using a managed identity. The managed identity is created when you install the [Connected Machine agent](/azure/azure-arc/servers/agent-overview), which is part of Azure Arc. The legacy Log Analytics agent authenticated by using the workspace ID and key, so it didn't need Azure Arc. Managed identity is a more secure and manageable authentication solution.

The Azure Arc agent is used only as an installation mechanism and doesn't add cost or resource consumption. Paid options for Azure Arc are available, but these options aren't required to use the Azure Monitor Agent.

## Related content

- [Install the Azure Monitor Agent](azure-monitor-agent-manage.md) on Windows and Linux virtual machines.
- [Identify requirements and prerequisites](azure-monitor-agent-requirements.md) for Azure Monitor Agent installation.
