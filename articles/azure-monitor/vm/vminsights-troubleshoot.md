---
title: Troubleshoot VM Insights
description: Get troubleshooting information about agent installation and the use of the VM Insights feature in Azure Monitor.
ms.topic: conceptual
author: guywi-ms
ms.author: guywild
ms.date: 11/06/2024
ms.custom: references_regions

---

# Troubleshoot VM Insights

This article provides troubleshooting information to help you with problems that you might experience when you try to enable or use the VM Insights feature in Azure Monitor.

## Issues enabling VM insights

When you onboard VM insights from the Azure portal, the following actions are performed. Each of these steps is verified as it's completed with a notification status appearing in the portal.

* A new Log Analytics workspace is created unless you selected an existing one.
* The [Azure Monitor Agent (AMA)](../agents/azure-monitor-agent-overview.md) is installed on each virtual machine [using an extension](../agents/azure-monitor-agent-manage.md#install-the-agent-extension), if the VM doesn't already have it installed.
* The [Dependency Agent](./vminsights-dependency-agent.md) is installed on the virtual machine [using an extension](/azure/virtual-machines/extensions/agent-dependency-windows), if you chose to enable processes and dependencies.

Configuration of the workspace and the agent installation typically may take up to 10 minutes. It may take up to an additional 10 minutes for data to become available to view in the portal. If you receive a message that the virtual machine needs to be onboarded after you perform the onboarding process, allow up to 30 minutes for the process to finish. If the problem persists, see the following sections for possible causes.

**Verify that the virtual machine is running.**<br>
The virtual machines must be running for the onboarding process to complete. If the virtual machine is stopped before the installation is complete, the process may fail and must be restarted.

**Verify that the operating system supported.**<br>
If the operating system isn't in the [list of supported operating systems](vminsights-enable-overview.md#supported-operating-systems), installation of the extension fails and you get a message about waiting for data to arrive.

> [!IMPORTANT]
> If a virtual machine that you onboarded on or after April 11, 2022, doesn't appear in VM Insights, you might be running an older version of the Dependency Agent. For more information, see the blog post [Potential breaking changes for VM Insights Linux customers](https://techcommunity.microsoft.com/t5/azure-monitor-status/potential-breaking-changes-for-vm-insights-linux-customers/ba-p/3271989). This consideration doesn't apply for Windows machines and for virtual machines that you onboarded before April 11, 2022.

**Verify that the extension is installed.**<br>
If a VM is still not being monitored after onboarding, it may mean that one or both of the extensions failed to be installed correctly. In the Azure portal, on the **Extensions** pane for your virtual machine, check whether the following extensions appear:

| Operating system | Agents |
|:---|:---|
| Windows | `AzureMonitorWindowsAgent`<br>`DependencyAgentWindows` |
| Linux | `AzureMonitorLinuxAgent`<br>`DependencyAgentLinux` |

If you don't see both extensions for your operating system in the list of installed extensions, you must install them. If the extensions are listed but their status doesn't appear as **Provisioning succeeded**, remove the extensions and reinstall them.

## Performance view has no data

If the agents appear to be installed correctly but no data appears in the **Performance** view, see the following sections for possible causes.

**Check the daily cap for the Log Analytics workspace.**<br>
When you set a daily cap for a Log Analytics workspace, it stops collecting data when the cap is reached and then resumes again the next day. See [Set daily cap on Log Analytics workspace](../logs/daily-cap.md) for details on how to set the daily cap and to determine whether it has been reached.

**Verify that the agent is connected to the Log Analytics workspace.**<br>
When the agent is communicating properly with the Log Analytics workspace, it sends a heartbeat every minute. You can verify that the agent is connected by checking the **Heartbeat** table for these entries.

In the Azure portal, on the **Azure Monitor** menu, select **Logs** to open the Log Analytics workspace. Run the following query for your computer:

```kusto
Heartbeat
| where Computer == "my-computer"
| sort by TimeGenerated desc 
```

If no data appears or if the computer didn't send a heartbeat recently, you might have problems with your agent. For agent troubleshooting information, see these articles:

* [Troubleshoot issues with the Log Analytics agent for Windows](../agents/agent-windows-troubleshoot.md)
* [Troubleshoot issues with the Log Analytics agent for Linux](../agents/agent-linux-troubleshoot.md)

## Virtual machine doesn't appear in the Map view

The following sections help you resolve problems with the **Map** view.

**Is the Dependency agent installed?**
The Dependency agent is required on VMs in order to collect process and dependency data which is required for a VM to appear in the **Map** view. Use the information in [](#) to determine if the Dependency Agent is installed and working properly.


### Are you on the Log Analytics free tier?

The [Log Analytics free tier](https://azure.microsoft.com/pricing/details/monitor/) is a legacy pricing plan that allows for up to five unique Service Map machines. Any subsequent machines won't appear in Service Map, even if the prior five are no longer sending data.

### Is your virtual machine sending log and performance data to Azure Monitor Logs?

Use the log query in the [Performance view has no data](#performance-view-has-no-data) section to determine if data is being collected for the virtual machine. If no data is being collected, use the TestCloudConnectivity tool to determine if you have connectivity problems.

## Virtual machine appears in the Map view but has missing data

If the virtual machine is in the **Map** view and the Dependency Agent is installed and running, but the kernel driver didn't load, check the log file at the following locations:

| Operating system | Log                                                          |
|:-----------------|:-------------------------------------------------------------|
| Windows          | C:\Program Files\Microsoft Dependency Agent\logs\wrapper.log |
| Linux            | /var/opt/microsoft/dependency-agent/log/service.log          |

The last lines of the file should indicate why the kernel didn't load. For example, the kernel might not be supported on Linux if you updated your kernel.

## Related content

* For more information on installing VM Insights agents, see [Enable VM Insights overview](vminsights-enable-overview.md)
