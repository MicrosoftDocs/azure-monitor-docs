---
title: Troubleshoot the Azure Monitor agent on Linux virtual machines and scale sets
description: Guidance for troubleshooting issues on Linux virtual machines, scale sets with Azure Monitor agent and Data Collection Rules.
ms.topic: troubleshooting-general
ms.date: 11/14/2024
ms.custom: references_region, linux-related-content
ms.reviewer: shseth
---

# Troubleshooting guidance for the Azure Monitor agent on Linux virtual machines and scale sets

[!INCLUDE [azure-monitor-agent-architecture](includes/azure-monitor-agent-architecture-include.md)]

## Basic troubleshooting steps

Follow the steps below to troubleshoot the latest version of the Azure Monitor agent running on your Linux virtual machine:

1. **Carefully review the [prerequisites here](./azure-monitor-agent-manage.md#prerequisites).**

1. **Verify that the extension was successfully installed and provisioned, which installs the agent binaries on your machine**:

    1. Open Azure portal > select your virtual machine > Open **Settings** : **Extensions + applications** from the pane on the left > 'AzureMonitorLinuxAgent'should show up with Status: 'Provisioning succeeded'

    1. If you don't see the extension listed, check if machine can reach Azure and find the extension to install using the command below:

        ```azurecli
        az vm extension image list-versions --location <machine-region> --name AzureMonitorLinuxAgent --publisher Microsoft.Azure.Monitor
        ```

    1. Wait for 10-15 minutes as extension maybe in transitioning status. If it still doesn't show up as above, [uninstall and install the extension](./azure-monitor-agent-manage.md) again.

    1. Check if you see any errors in extension logs located at `/var/log/azure/Microsoft.Azure.Monitor.AzureMonitorLinuxAgent/` on your machine

1. **Verify that the agent is running**:

    1. Check if the agent is emitting heartbeat logs to Log Analytics workspace using the query below. Skip if 'Custom Metrics' is the only destination in the DCR:

        ```Kusto
        Heartbeat | where Category == "Azure Monitor Agent" and Computer == "<computer-name>" | take 10
        ```

    1. Check if the agent service is running

        ```
        systemctl status azuremonitoragent
        ```

    1. Check if you see any errors in core agent logs located at `/var/opt/microsoft/azuremonitoragent/log/mdsd.*` on your machine

1. **Verify that the DCR exists and is associated with the virtual machine:**

    1. If using Log Analytics workspace as destination, verify that DCR exists in the same physical region as the Log Analytics workspace.
    1. Open Azure portal > select your data collection rule > Open **Configuration** : **Resources** from the pane on the left > You should see the virtual machine listed here.
    1. If not listed, click 'Add' and select your virtual machine from the resource picker. Repeat across all DCRs.

1. **Verify that agent was able to download the associated DCR(s) from AMCS service:**

    1. Check if you see the latest DCR downloaded at this location `/etc/opt/microsoft/azuremonitoragent/config-cache/configchunks/`


## Issues collecting Syslog

For more information on how to troubleshoot syslog issues with Azure Monitor Agent, see [here](azure-monitor-agent-troubleshoot-linux-vm-rsyslog.md).

* The quality of service (QoS) file `/var/opt/microsoft/azuremonitoragent/log/mdsd.qos` provides CSV-format 15-minute aggregations of the processed events and contains the information on the amount of the processed syslog events in the given timeframe. **This file is useful in tracking Syslog event ingestion drops**.

    For example, the below fragment shows that in the 15 minutes preceding 2022-02-28T19:55:23.5432920Z, the agent received 77 syslog events with facility daemon and level info and sent 77 of said events to the upload task. Additionally, the agent upload task received 77 and successfully uploaded all 77 of these daemon.info messages.

    ```
    #Time: 2022-02-28T19:55:23.5432920Z
    #Fields: Operation,Object,TotalCount,SuccessCount,Retries,AverageDuration,AverageSize,AverageDelay,TotalSize,TotalRowsRead,TotalRowsSent
    ...
    MaRunTaskLocal,daemon.debug,15,15,0,60000,0,0,0,0,0
    MaRunTaskLocal,daemon.info,15,15,0,60000,46.2,0,693,77,77
    MaRunTaskLocal,daemon.notice,15,15,0,60000,0,0,0,0,0
    MaRunTaskLocal,daemon.warning,15,15,0,60000,0,0,0,0,0
    MaRunTaskLocal,daemon.error,15,15,0,60000,0,0,0,0,0
    MaRunTaskLocal,daemon.critical,15,15,0,60000,0,0,0,0,0
    MaRunTaskLocal,daemon.alert,15,15,0,60000,0,0,0,0,0
    MaRunTaskLocal,daemon.emergency,15,15,0,60000,0,0,0,0,0
    ...
    MaODSRequest,https://e73fd5e3-ea2b-4637-8da0-5c8144b670c8_LogManagement,15,15,0,455067,476.467,0,7147,77,77
    ```

**Troubleshooting steps**

1. Review the [generic Linux AMA troubleshooting steps](#basic-troubleshooting-steps) first. If agent is emitting heartbeats, proceed to step 2.

1. The parsed configuration is stored at `/etc/opt/microsoft/azuremonitoragent/config-cache/configchunks/`. Check that Syslog collection is defined and the log destinations are the same as constructed in DCR UI / DCR JSON.

    1. If yes, proceed to step 3. If not, the issue is in the configuration workflow. 
    1. Investigate `mdsd.err`,`mdsd.warn`, `mdsd.info` files under `/var/opt/microsoft/azuremonitoragent/log` for possible configuration errors.

1. Validate the layout of the Syslog collection workflow to ensure all necessary pieces are in place and accessible:

    1. For `rsyslog` users, ensure the `/etc/rsyslog.d/10-azuremonitoragent.conf` file is present, isn't empty, and is accessible by the `rsyslog` daemon (syslog user).
        1. Check your rsyslog configuration at `/etc/rsyslog.conf` and `/etc/rsyslog.d/*` to see if you have any inputs bound to a non-default ruleset, as messages from these inputs won't be forwarded to Azure Monitor Agent. For instance, messages from an input configured with a non-default ruleset like `input(type="imtcp" port="514" `**`ruleset="myruleset"`**`)` won't be forward.
    1. For `syslog-ng` users, ensure the `/etc/syslog-ng/conf.d/azuremonitoragent.conf` file is present, isn't empty, and is accessible by the `syslog-ng` daemon (syslog user).
    1. Ensure the file `/run/azuremonitoragent/default_syslog.socket` exists and is accessible by `rsyslog` or `syslog-ng` respectively.
    1. Check that syslog daemon queue isn't overflowing, causing the upload to fail, by referring the guidance here: [Rsyslog data not uploaded due to Full Disk space issue on AMA Linux Agent](./azure-monitor-agent-troubleshoot-linux-vm-rsyslog.md)

1. To debug syslog events ingestion further, you can append trace flag **-T 0x2002** at the end of **MDSD_OPTIONS** in the file `/etc/default/azuremonitoragent`, and restart the agent:

    ```
    export MDSD_OPTIONS="-A -c /etc/opt/microsoft/azuremonitoragent/mdsd.xml -d -r $MDSD_ROLE_PREFIX -S $MDSD_SPOOL_DIRECTORY/eh -L $MDSD_SPOOL_DIRECTORY/events -e $MDSD_LOG_DIR/mdsd.err -w $MDSD_LOG_DIR/mdsd.warn -o $MDSD_LOG_DIR/mdsd.info -T 0x2002"
    ```

1. After the issue is reproduced with the trace flag on, you'll find more debug information in `/var/opt/microsoft/azuremonitoragent/log/mdsd.info`. Inspect the file for the possible cause of syslog collection issue, such as parsing / processing / configuration / upload errors.

    > [!WARNING]
    > Ensure to remove trace flag setting **-T 0x2002** after the debugging session, since it generates many trace statements that could fill up the disk more quickly or make visually parsing the log file difficult.

## Troubleshooting issues on Arc-enabled server

If after checking basic troubleshooting steps you don't see the Azure Monitor Agent emitting logs or find **'Failed to get MSI token from IMDS endpoint'** errors in `/var/opt/microsoft/azuremonitoragent/log/mdsd.err` log file, it's likely `syslog` user isn't a member of the group `himds`. Add `syslog` user to `himds` user group if the user isn't a member of this group. Create user `syslog` and the group `syslog`, if necessary, and make sure that the user is in that group. For more information check out Azure Arc-enabled server authentication requirements [here](/azure/azure-arc/servers/managed-identity-authentication).

## Enabling automatic upgrade on VMSS appears in JSON but instances don't change

When you enable *automatic extension upgrade* for `AzureMonitorLinuxAgent` on a VMSS, the flag first updates the scale set model. If your scale set's upgrade policy is set to *Manual*, this change doesn't propagate to existing instances until you apply the model update.

You can apply the latest model in the Azure portal or programmatically.

# [Portal](#tab/portal)

1. Go to the **Azure portal**.
1. Open your **Virtual Machine Scale Set**.
1. Go to **Instances**.
1. Select the intances to update.
1. In the top menu bar, select **Upgrade** > **Apply latest model**.

    This forces the current scale set model (including the updated `enableAutomaticUpgrade` flag) onto the selected instances.

# [Azure CLI](#tab/cli)

Run the following command:

```azurecli
az vmss update-instances -g <rg> -n <vmss> --instance-ids "*"
```

# [PowerShell](#tab/ps)

Run the following command:

```powershell
Update-AzVmssInstance -ResourceGroupName <rg> -VMScaleSetName <vmss> -InstanceId "*"
```

---

> [!TIP]
> You can change upgrade policy to *Rolling* so future model changes flow automatically by running the following CLI command:
> 
> ```azurecli
> az vmss update -g <rg> -n <vmss> --set upgradePolicy.mode=Rolling
> ```

If specific VMs still don't update, check *Instance protection* (protect from scale set actions) and clear it if set.
