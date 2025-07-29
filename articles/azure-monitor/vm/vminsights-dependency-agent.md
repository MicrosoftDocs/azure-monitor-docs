---
title: Dependency Agent in Azure Monitor VM insights
description: This article describes how to upgrade the VM Insights Dependency Agent using command-line, setup wizard, and other methods.
ms.topic: article
ms.custom: linux-related-content
ms.date: 01/29/2025
---

# Dependency Agent in Azure Monitor VM insights

Dependency Agent collects data about processes running on the virtual machine and their external process dependencies. Updates include bug fixes or support of new features or functionality. This article describes Dependency Agent requirements and how to upgrade it manually or through automation.

> [!IMPORTANT]
>  The Dependency Agent and the Map experience in VM Insights will be retired on 30 June 2028. See [our retirement guidance](https://aka.ms/DependencyAgentRetirement) for more details. 


>[!NOTE]
> Dependency Agent sends heartbeat data to the [InsightsMetrics](/azure/azure-monitor/reference/tables/insightsmetrics) table, for which you incur data ingestion charges. This behavior is different from Azure Monitor Agent, which sends agent health data to the [Heartbeat](/azure/azure-monitor/reference/tables/heartbeat) table that is free from data collection charges.

## Dependency Agent requirements

- Azure Monitor agent must be installed on the same machine.
- Requires a connection from the virtual machine to the address 169.254.169.254. This address identifies the Azure metadata service endpoint.

## Supported operating systems

The Dependency agent currently supports the same [Windows versions that Azure Monitor Agent supports](../agents/azure-monitor-agent-supported-operating-systems.md) up to Windows Server 2022, except Azure Stack HCI and Windows IoT Enterprise. Windows Server Core isn't supported. The Dependency Agent only supports x64 architectures.

Consider the following before you install Dependency agent on a Linux machine:

- Only default and SMP Linux kernel releases are supported.
- Nonstandard kernel releases, such as physical address extension (PAE) and Xen, aren't supported for any Linux distribution. For example, a system with the release string of *2.6.16.21-0.8-xen* isn't supported.
- Custom kernels, including recompilations of standard kernels, aren't supported.
- For Debian distros other than version 9.4, the Map feature isn't supported. The Performance feature is available only from the Azure Monitor menu. It isn't available directly from the left pane of the Azure VM.
- Installing Dependency agent taints the Linux kernel and you might lose support from your Linux distribution until the machine resets.

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

## Install or upgrade Dependency Agent 

> [!NOTE]
> Dependency Agent is installed automatically when [VM Insights is enabled on a machine](./vminsights-enable-overview.md) for process and connection data. If VM Insights is enabled exclusively for performance data, Dependency Agent won't be installed.

You can upgrade Dependency Agent for Windows and Linux manually or automatically, depending on the deployment scenario and environment the machine is running in, using these methods:

| Environment | Installation method | Upgrade method |
|-------------|---------------------|----------------|
| Azure VM | Dependency Agent VM extension for [Windows](/azure/virtual-machines/extensions/agent-dependency-windows) and [Linux](/azure/virtual-machines/extensions/agent-dependency-linux) | Agent is automatically upgraded by default unless you configured your Azure Resource Manager template to opt out by setting the property `autoUpgradeMinorVersion` to **false**. The upgrade for minor version where auto upgrade is disabled, and a major version upgrade follow the same method - uninstall and reinstall the extension. |
| Custom Azure VM images | Manual install of Dependency Agent for Windows/Linux | Updating VMs to the newest version of the agent needs to be performed from the command line running the Windows installer package or Linux self-extracting and installable shell script bundle. |
| Non-Azure VMs | Manual install of Dependency Agent for Windows/Linux | Updating VMs to the newest version of the agent needs to be performed from the command line running the Windows installer package or Linux self-extracting and installable shell script bundle. |


### Manually install or upgrade Dependency Agent on Windows 

Update the agent on a Windows VM from the command prompt, with a script or other automation solution, or by using the InstallDependencyAgent-Windows.exe Setup Wizard.

#### Prerequisites

> [!div class="checklist"]
> * Download the latest version of the Windows agent from [aka.ms/dependencyagentwindows](https://aka.ms/dependencyagentwindows).

#### Using the Setup Wizard

1. Sign on to the computer with an account that has administrative rights.

1. Execute **InstallDependencyAgent-Windows.exe** to start the Setup Wizard.
   
1. Follow the **Dependency Agent Setup** wizard to uninstall the previous version of Dependency Agent and then install the latest version.

#### From the command line

1. Sign in on the computer using an account with administrative rights.

1. Run the following command:

    ```cmd
    InstallDependencyAgent-Windows.exe /S /RebootMode=manual
    ```

    The `/RebootMode=manual` parameter prevents the upgrade from automatically rebooting the machine if some processes are using files from the previous version and have a lock on them. 

1. To confirm the upgrade was successful, check the `install.log` for detailed setup information. The log directory is *%Programfiles%\Microsoft Dependency Agent\logs*.

### Manually install or upgrade Dependency Agent on Linux

Upgrading from prior versions of Dependency Agent on Linux is supported and performed following the same command as a new installation.

#### Prerequisites

> [!div class="checklist"]
> * Download the latest version of the Linux agent from [aka.ms/dependencyagentlinux](https://aka.ms/dependencyagentlinux) or via curl:

```bash
curl -L -o DependencyAgent-Linux64.bin https://aka.ms/dependencyagentlinux
```

> [!NOTE]
> Curl doesn't automatically set execution permissions. You need to manually set them using chmod:
> 
> ```bash
> chmod +x DependencyAgent-Linux64.bin
> ```

#### From the command line

1. Sign in on the computer with a user account that has sudo privileges to execute commands as root.

1. Run the following command:

    ```bash
    sudo <path>/InstallDependencyAgent-Linux64.bin
    ```

If Dependency Agent fails to start, check the logs for detailed error information. On Linux agents, the log directory is */var/opt/microsoft/dependency-agent/log*. 

## Uninstall Dependency Agent

> [!NOTE]
> If Dependency Agent was installed manually, it won't show in the Azure portal and has to be uninstalled manually. It will only show if it was installed via the [Azure portal](vminsights-enable-portal.md), [PowerShell](vminsights-enable-powershell.md), [ARM template deployment](vminsights-enable-resource-manager.md), or [Azure policy](vminsights-enable-policy.md).

1. From the **Virtual Machines** menu in the Azure portal, select your virtual machine.

1. Select **Extensions + applications** > **DependencyAgentWindows** or **DependencyAgentLinux** > **Uninstall**.

    :::image type="content" source="media/vminsights-dependency-agent/azure-monitor-uninstall-dependency-agent.png" alt-text="Screenshot showing the Extensions and applications screen for a virtual machine." lightbox="media/vminsights-dependency-agent/azure-monitor-uninstall-dependency-agent.png":::

### Manually uninstall Dependency Agent on Windows

**Method 1:** In Windows, go to **Add and remove programs**, find Microsoft Dependency Agent, click on the ellipsis to open the context menu, and select **Uninstall**.

**Method 2:** Use the uninstaller located in the Microsoft Dependency Agent folder, for example, `C:\Program Files\Microsoft Dependency Agent"\Uninstall_v.w.x.y.exe` (where v.w.x.y is the version number).

### Manually uninstall Dependency Agent on Linux

1. Sign in on the computer with a user account that has sudo privileges to execute commands as root.

1. Run the following command:

    ```bash
    sudo /opt/microsoft/dependency-agent/uninstall -s
    ```

## Dependency Agent Linux support

Since Dependency Agent works at the kernel level, support is also dependent on the kernel version. As of Dependency Agent version 9.10.* the agent supports * kernels. The following table lists the major and minor Linux OS release and supported kernel versions for Dependency Agent.

[!INCLUDE [dependency-agent-linux-versions](~/reusable-content/ce-skilling/azure/includes/azure-monitor/vm-insights-dependency-agent-linux-versions.md)]

## Next steps

If you want to stop monitoring your VMs for a while or remove VM Insights entirely, see [Disable monitoring of your VMs in VM Insights](../vm/vminsights-optout.md).
