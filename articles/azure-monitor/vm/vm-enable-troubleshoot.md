---
title: Troubleshoot VM monitoring in Azure Monitor
description: Get troubleshooting information for agent installation and common issues when you enable VM monitoring in Azure Monitor.
ms.topic: troubleshooting-general
ms.date: 03/12/2026
ms.custom: references_regions
---

# Troubleshoot VM monitoring in Azure Monitor

This article provides troubleshooting information to help you with problems that you might experience when you try to enable monitoring of virtual machines in Azure Monitor.

## Agent installation

### Verify that the virtual machine is running
The virtual machines must be running for the onboarding process to complete. If the virtual machine is stopped before the installation is complete, the process may fail and must be restarted.

### Verify that the operating system is supported
If the operating system isn't in the [list of supported operating systems](../agents/azure-monitor-agent-supported-operating-systems.md), installation of the extension fails and you get a message about waiting for data to arrive.

### Verify that the extension is installed
In the Azure portal, on the **Extensions** pane for your virtual machine, verify that the following extensions appear:

| Operating system | Agents |
|:---|:---|
| Windows | `AzureMonitorWindowsAgent` |
| Linux | `AzureMonitorLinuxAgent` |

If you don't see the extension in the list of installed extensions, try enabling monitoring again. If the extension is listed but its status doesn't appear as **Provisioning succeeded**, remove the extension and reinstall it.

:::image type="content" source="media/vminsights-troubleshoot/extensions.png" lightbox="media/vminsights-troubleshoot/extensions.png" alt-text="Screenshot of VM insights required extensions for a virtual machine.":::

## OpenTelemetry experience


**The charts are stuck in a loading state**<br>
Network traffic to the Azure Monitor workspace may be blocked, typically by network policies such as ad blocking software. Disable the ad blocker or allowlist `monitor.azure.com` traffic, then reload the page.

**Unable to access Data Collection Rule (DCR)**<br>
You may not have permission to view the associated DCR for the VM, or the DCR may have been deleted. Contact your system administrator or reconfigure OpenTelemetry metrics using the **Monitor Settings** button in the toolbar.

**Data configuration error**<br>
The Azure Monitor workspace or DCR has been modified or deleted. Reconfigure OpenTelemetry metrics using the **Monitor Settings** button in the toolbar.

**Access denied**<br>
Your portal token may have expired, or you don't have permissions to view the associated Azure Monitor workspace. Refresh your browser session or contact your system administrator to request access. You need Monitor Reader permission, and the system administrator should enable the resource centric flag on the Azure Monitor workspace.

**An unknown error occurred**<br>
If this error persists, contact support to open a support ticket.

## Performance view has no data

If the agents appear to be installed correctly but no data appears in the **Performance** view, see the following sections for possible causes.

The following checks apply to the logs-based experience that stores data in a Log Analytics workspace.

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



## Related content

* For more information on enabling VM monitoring, see [Enable VM monitoring in Azure Monitor](vm-enable-monitoring.md)
