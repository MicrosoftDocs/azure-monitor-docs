---
title: Dependency Agent in Azure Monitor VM insights
description: This article describes Dependency Agent requirements, supported operating systems, and how to uninstall the Dependency Agent.
ms.topic: how-to
ms.custom: linux-related-content
ms.date: 02/17/2026
ai-usage: ai-assisted
---

# Dependency Agent in Azure Monitor VM insights

> [!IMPORTANT]
>  The Dependency Agent and the Map experience in VM Insights has been deprecated and will be retired on 30 June 2028. See [our retirement guidance](https://aka.ms/DependencyAgentRetirement) for more details. 

Dependency Agent collects data about processes running on the virtual machine and their external process dependencies. This article describes Dependency Agent requirements and how to uninstall it.

> [!NOTE]
> Don't initiate further Dependency Agent installations on systems. The following requirements and supported operating systems are provided for reference on machines with an existing Dependency Agent installation. The Dependency Agent sends heartbeat data to the [InsightsMetrics](/azure/azure-monitor/reference/tables/insightsmetrics) table, for which you incur data ingestion charges. This behavior is different from Azure Monitor Agent, which sends agent health data to the [Heartbeat](/azure/azure-monitor/reference/tables/heartbeat) table that is free from data collection charges.

## Dependency Agent requirements

- Azure Monitor agent must be installed on the same machine.
- Requires a connection from the virtual machine to the address 169.254.169.254. This address identifies the Azure metadata service endpoint.

## Supported operating systems

The Dependency agent currently supports the same [Windows versions that Azure Monitor Agent supports](../agents/azure-monitor-agent-supported-operating-systems.md) up to Windows Server 2022 , except Azure Stack HCI and Windows IoT Enterprise. Windows Server Core isn't supported. The Dependency Agent only supports x64 architectures.

- [Support matrix for Linux](/azure/virtual-machines/extensions/agent-dependency-linux)
- [Support matrix for Windows](/azure/virtual-machines/extensions/agent-dependency-windows)

Dependency Agent installation restrictions on a Linux machine:

- Only default and SMP Linux kernel releases are supported.
- Nonstandard kernel releases, such as physical address extension (PAE) and Xen, aren't supported for any Linux distribution. For example, a system with the release string of *2.6.16.21-0.8-xen* isn't supported.
- Custom kernels, including recompilations of standard kernels, aren't supported.
- For Debian distros other than version 9.4, the Map feature isn't supported. The Performance feature is available only from the Azure Monitor menu. It isn't available directly from the left pane of the Azure VM.
- The Dependency Agent taints the Linux kernel, and you might lose support from your Linux distribution until the machine resets.

The Linux kernel must be patched for the Spectre and Meltdown vulnerabilities. For more information, consult with your Linux distribution vendor. Run the following command to check for availability if Spectre/Meltdown has been mitigated:

```
$ grep . /sys/devices/system/cpu/vulnerabilities/*
```

Output for this command looks similar to the following and specify whether a machine is vulnerable to either issue. If these files are missing, the machine is unpatched.

```
/sys/devices/system/cpu/vulnerabilities/meltdown:Mitigation: PTI
/sys/devices/system/cpu/vulnerabilities/spectre_v1:Vulnerable
/sys/devices/system/cpu/vulnerabilities/spectre_v2:Vulnerable: Minimal generic ASM retpoline
```

## Uninstall Dependency Agent

> [!NOTE]
> If you manually install the Dependency Agent, it doesn't appear in the Azure portal and you must uninstall it manually. It only appears if you install it through the [Azure portal](vminsights-enable-portal.md), [PowerShell](vminsights-enable-powershell.md), [ARM template deployment](vminsights-enable-resource-manager.md), or [Azure policy](vminsights-enable-policy.md).

To find machines, including standalone installations that don't appear as an extension, that still have the Dependency Agent installed, see [Finding VMs currently using VM Insights map](vminsights-maps-retirement.md#finding-vms-currently-using-vm-insights-map).

1. From the **Virtual Machines** menu in the Azure portal, select your virtual machine.

1. Select **Extensions + applications** > **DependencyAgentWindows** or **DependencyAgentLinux** > **Uninstall**.

    :::image type="content" source="media/vminsights-dependency-agent/azure-monitor-uninstall-dependency-agent.png" alt-text="Screenshot showing the Extensions and applications screen for a virtual machine." lightbox="media/vminsights-dependency-agent/azure-monitor-uninstall-dependency-agent.png":::

### Manually uninstall Dependency Agent on Windows

**Method 1:** In Windows, go to **Add and remove programs**, find Microsoft Dependency Agent, click on the ellipsis to open the context menu, and select **Uninstall**.

**Method 2:** Use the uninstaller located in the installation directory: `C:\Program Files\Microsoft Dependency Agent`. Use the command that matches the installed agent version.

| Dependency Agent version | Command to run from the installation directory |
|---|---|
| 9.7.7.4050 and later | `Uninstall_<version>.exe /S` |
| Prior to 9.7.7.4050 | `Uninstall.exe /S` |

> [!NOTE]
> Uninstallers from versions prior to 9.7.4.3150 don't have a Microsoft digital signature.

### Manually uninstall Dependency Agent on Linux

For version 9.10.2.9060 and later:

1. Sign in on the computer with a user account that has sudo privileges to execute commands as root.

1. Run the uninstaller script:

    ```bash
    sudo /opt/microsoft/dependency-agent/uninstall -s
    ```

For versions prior to 9.10.2.9060, which don't include an uninstaller script, use the package manager command that matches your distribution:

**Debian/Ubuntu:**

```bash
sudo dpkg --purge dependency-agent dependency-agent-service microsoft-dependency-agent-dkms
```

**RPM-based distributions (Red Hat, CentOS, SLES):**

```bash
sudo rpm -e --allmatches dependency-agent
```

## Dependency Agent Linux support

Since Dependency Agent works at the kernel level, support is also dependent on the kernel version. As of Dependency Agent version 9.10.* the agent supports * kernels. The following table lists the major and minor Linux OS release and supported kernel versions for Dependency Agent.

[!INCLUDE [dependency-agent-linux-versions](~/reusable-content/ce-skilling/azure/includes/azure-monitor/vm-insights-dependency-agent-linux-versions.md)]

## Next steps

If you want to stop monitoring your VMs for a while or remove VM Insights entirely, see [Disable monitoring of your VMs in VM Insights](../vm/vminsights-optout.md).
