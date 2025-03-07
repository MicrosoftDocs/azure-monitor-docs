---
title: Collect Firewall logs with Azure Monitor Agent
description: Configure collection of Windows Firewall logs on virtual machines with Azure Monitor Agent.
ms.topic: how-to
ms.date: 03/03/2025
ms.reviewer: jeffwo

---

# Collect Windows Firewall logs from virtual machine with Azure Monitor
Windows Firewall is a Microsoft Windows application that filters information coming to your system from the Internet and blocks potentially harmful programs. Windows Firewall logs are generated on both client and server operating systems. These logs provide valuable information about network traffic, including dropped packets and successful connections. Parsing Windows Firewall log files can be done using methods like Windows Event Forwarding (WEF) or forwarding logs to a SIEM product like Azure Sentinel. 

Details for the creation of the DCR are provided in [Collect data from VM client with Azure Monitor](../vm/data-collection.md). This article provides additional details for the Windows Firewall data source type.





You can turn it on or off by following these steps on any Windows system:
1. Select Start, then open Settings.
1. Under Update & Security, select Windows Security, Firewall & network protection.
1. Select a network profile: domain, private, or public.
1. Under Microsoft Defender Firewall, switch the setting to On or Off.

## Prerequisites

In addition to the prerequisites in [Collect data from virtual machine client with Azure Monitor](./data-collection.md#prerequisites), you need to install the **Security and Audit** solution in order to create the [WindowsFirewall](/azure/azure-monitor/reference/tables/windowsfirewall) table in your Log Analytics workspace.

In the Azure portal, search for **Security and Audit** and select the solution from the Marketplace. When prompted, specify the **Resource group** and **Log Analytics Workspace** where you'll be sending the firewall log data.

:::image type="content" source="media/data-collection-firewall-log/security-and-audit-solution.png" lightbox="media/data-collection-firewall-log/security-and-audit-solution.png" alt-text="Screenshot that shows installation of the Security and Audit solution." :::


## Configure firewall logs data source

On the **Collect and deliver** tab of the DCR, select **Firewall Logs** from the **Data source type** dropdown. Select each of the network profiles that you want to collect.

:::image type="content" source="media/data-collection-firewall-log/data-source-firewall-logs.png" lightbox="media/data-collection-firewall-log/data-source-firewall-logs.png" alt-text="Screenshot that shows configuration of the Firewall Logs data source." :::

## Verify data collection
To verify that data is being collected, check for records in the **WindowsFirewall** table. From the virtual machine or from the Log Analytics workspace in the Azure portal, select **Logs** and then click the **Tables** button. Under the **Virtual machines** category, click **Run** next to **WindowsFirewall**. 


## Troubleshoot
Use the following steps to troubleshoot the collection of firewall logs. 

### Run Azure Monitor Agent troubleshooter
To test your configuration and share logs with Microsoft use the [Azure Monitor Agent Troubleshooter](../agents/troubleshooter-ama-windows.md).

### Verify that firewall logs are being created
Look at the timestamps of the log files and open the latest to see that latest timestamps are present in the log files. The default location for firewall log files is C:\windows\system32\logfiles\firewall\pfirewall.log.

:::image type="content" source="media/data-collection-firewall-log/firewall-files-on-disk.png" lightbox="media/data-collection-firewall-log/firewall-files-on-disk.png" alt-text="Screenshot that shows firewall logs on a local disk." :::

To turn on logging follow these steps.
1. gpedit {follow the picture}​
2. netsh advfirewall>set allprofiles logging allowedconnections enable​
3. netsh advfirewall>set allprofiles logging droppedconnections enable​

:::image type="content" source="media/data-collection-firewall-log/turn-on-firewall-logging.png" lightbox="media/data-collection-firewall-log/turn-on-firewall-logging.png" alt-text="Screenshot that show all the steps to turn on logging." :::

## Next steps
Learn more about: 
- [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md).
- [Data collection rules](../essentials/data-collection-rule-overview.md).
- [Data collection endpoints](../essentials/data-collection-endpoint-overview.md)
