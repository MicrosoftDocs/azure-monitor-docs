---
title: Troubleshoot VM Insights
description: Get troubleshooting information about agent installation and the use of the VM Insights feature in Azure Monitor.
ms.topic: troubleshooting-general
ms.date: 03/27/2025
ms.custom: references_regions
---

# Troubleshoot VM insights

This article provides troubleshooting information to help you with problems that you might experience when you try to enable or use VM Insights in Azure Monitor.

## Issues enabling VM insights

When you enable VM insights from the Azure portal, the following actions are performed. Each of these steps is verified as it's completed with a notification status appearing in the portal.

* A new Log Analytics workspace is created unless you selected an existing one.
* The [Azure Monitor Agent (AMA)](../agents/azure-monitor-agent-overview.md) is installed on each virtual machine [using an extension](../agents/azure-monitor-agent-manage.md#install-the-agent-extension) if the VM doesn't already have it installed.
* The [Dependency Agent](./vminsights-dependency-agent.md) is installed on the virtual machine [using an extension](/azure/virtual-machines/extensions/agent-dependency-windows) if you chose to enable processes and dependencies.
* A [data collection rule (DCR)](../agents/data-collection-rule-overview.md) is created to collect performance data from the virtual machine and associated with the virtual machine.

Configuration of the workspace and the agent installation may take up to 10 minutes, and it may take up to an additional 10 minutes for data to become available to view in the portal. If you receive a message that the virtual machine needs to be onboarded after you perform the onboarding process, allow up to 30 minutes for the process to finish. If the problem persists, see the following sections for possible causes.

### Verify that the virtual machine is running
The virtual machines must be running for the onboarding process to complete. If the virtual machine is stopped before the installation is complete, the process may fail and must be restarted.

### Verify that the operating system supported
If the operating system isn't in the [list of supported operating systems](vminsights-enable-overview.md#supported-operating-systems), installation of the extension fails and you get a message about waiting for data to arrive.

> [!IMPORTANT]
> If a virtual machine that you onboarded on or after April 11, 2022, doesn't appear in VM Insights, you might be running an older version of the Dependency Agent. For more information, see the blog post [Potential breaking changes for VM Insights Linux customers](https://techcommunity.microsoft.com/t5/azure-monitor-status/potential-breaking-changes-for-vm-insights-linux-customers/ba-p/3271989). This consideration doesn't apply for Windows machines and for virtual machines that you onboarded before April 11, 2022.

### Verify that the extension is installed
In the Azure portal, on the **Extensions** pane for your virtual machine, verify that the following extensions appear:

| Operating system | Agents |
|:---|:---|
| Windows | `AzureMonitorWindowsAgent`<br>`DependencyAgentWindows` |
| Linux | `AzureMonitorLinuxAgent`<br>`DependencyAgentLinux` |

If you don't see both extensions in the list of installed extensions, then attempt the onboarding process again. If the extensions are listed but their status doesn't appear as **Provisioning succeeded**, remove the extensions and reinstall them.

:::image type="content" source="media/vminsights-troubleshoot/extensions.png" lightbox="media/vminsights-troubleshoot/extensions.png" alt-text="Screenshot of VM insights required extensions for a virtual machine.":::

## Performance view has no data

If the agents appear to be installed correctly but no data appears in the **Performance** view, see the following sections for possible causes.

### Check the daily cap for the Log Analytics workspace
When you set a daily cap for a Log Analytics workspace, it stops collecting data when the cap is reached and then resumes again the next day. See [Set daily cap on Log Analytics workspace](../logs/daily-cap.md) for details on how to set the daily cap and to determine whether it has been reached.

### Verify that the agent is connected to the Log Analytics workspace
When the agent is communicating properly with the Log Analytics workspace, it sends a heartbeat every minute. You can verify that the agent is connected by checking the **Heartbeat** table for these entries.

In the Azure portal, on the **Azure Monitor** menu, select **Logs** to open the Log Analytics workspace. Run the following query for your computer:

```kusto
Heartbeat
| where Computer == "my-computer"
| sort by TimeGenerated desc 
```

### Verify that the DCR hasn't been modified
When you enable VM insights, a data collection rule (DCR) is created to collect performance data from the virtual machine. If the DCR was modified after it was created, it may not be collecting the data that you expect. Create a new DCR for the virtual machine and delete the old one.

If you have multiple virtual machines using the same DCR, you can edit the DCR to remove the modifications so you don't have to reconfigure each machine. Create a new VM insights DCR and compare it to the DCR that was potentially modified. Use guidance at [Create or edit a DCR using JSON](../essentials/data-collection-rule-create-edit.md#create-or-edit-a-dcr-using-json) to edit your DCR to match the new one.

## Virtual machine doesn't appear in the Map view

The following sections help you resolve problems with the **Map** view.

### Verify that the map feature was enabled for the virtual machine
The virtual machine is only added to the map if you selected **Processes and dependencies (Map)** when you enabled VM insights on the virtual machine. Click the **Enable** button next to the virtual machine on the **Overview** pane of VM insights view the current configuration. If **Processes and dependencies (Map)** isn't enabled, click **Edit** to either select a different data collection rule (DCR) with this feature enabled or create a new DCR. See [Enable VM Insights](./vminsights-enable.md) for details.


### Verify that the Dependency agent is installed
The Dependency agent is required on VMs in order to collect process and dependency data which is required for a VM to appear in the **Map** view. Use the information in [Verify that the extension is installed](#verify-that-the-extension-is-installed) to determine if the Dependency Agent is installed and working properly.

### Verify performance data is being collected

Use the log query in the [Performance view has no data](#performance-view-has-no-data) section to determine if data is being collected for the virtual machine.

## Virtual machine appears in the Map view but has missing data

If the virtual machine is in the Map view and the Dependency Agent is installed and running, verify whether the kernel driver loaded successfully. Check the log file at the following locations. The last lines of the file should indicate if the kernel didn't load and provide a reason.

| Operating system | Log                                                          |
|:-----------------|:-------------------------------------------------------------|
| Windows          | C:\Program Files\Microsoft Dependency Agent\logs\wrapper.log |
| Linux            | /var/opt/microsoft/dependency-agent/log/service.log          |



## Related content

* For more information on installing VM Insights, see [Enable VM Insights overview](vminsights-enable-overview.md)
