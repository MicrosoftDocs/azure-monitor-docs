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

## Prerequisites

In addition to the prerequisites in [Collect data from virtual machine client with Azure Monitor](./data-collection.md#prerequisites), you need to install the **Security and Audit** solution in order to create the [WindowsFirewall](/azure/azure-monitor/reference/tables/windowsfirewall) table in your Log Analytics workspace.

In the Azure portal, search for **Security and Audit** and select the solution from the Marketplace. When prompted, specify the **Resource group** and **Log Analytics Workspace** where you'll be sending the firewall log data.

:::image type="content" source="media/data-collection-firewall-log/security-audit-solution.png" lightbox="media/data-collection-firewall-log/security-audit-solution.png" alt-text="Screenshot that shows installation of the Security and Audit solution." :::


## Configure firewall logs data source
Create the DCR using the process in [Collect data from virtual machine client with Azure Monitor](./data-collection.md). On the **Collect and deliver** tab of the DCR, select **Firewall Logs** from the **Data source type** dropdown. Select each of the network profiles that you want to collect.

:::image type="content" source="media/data-collection-firewall-log/data-source-firewall-logs.png" lightbox="media/data-collection-firewall-log/data-source-firewall-logs.png" alt-text="Screenshot that shows configuration of the Firewall Logs data source." :::

## Add destinations
Firewall logs can only be sent to a Log Analytics workspace where it's stored in the [Event](/azure/azure-monitor/reference/tables/event) table. Add a destination of type **Azure Monitor Logs** and select a Log Analytics workspace. You can only add a single workspace to a DCR for a firewall log data source. If you need multiple destinations, create multiple DCRs. Be aware though that this will send duplicate data to each which will result in additional cost.


:::image type="content" source="media/data-collection/destination-workspace.png" lightbox="media/data-collection/destination-workspace.png" alt-text="Screenshot that shows configuration of an Azure Monitor Logs destination in a data collection rule." :::


## Verify data collection
To verify that data is being collected, check for records in the `WindowsFirewall` table. From the virtual machine or from the Log Analytics workspace in the Azure portal, select **Logs** and then click the **Tables** button. Under the **Security and Audit** category, click **Run** next to **WindowsFirewall**. If this section or the table doesn't appear in the list, check [Troubleshoot](#troubleshoot) for steps to resolve the issue.

:::image type="content" source="media/data-collection-firewall-log/verify-firewall.png" lightbox="media/data-collection-firewall-log/verify-firewall.png" alt-text="Screenshot that shows firewall log query with collected firewall logs." :::


## Troubleshoot
Use the following steps to troubleshoot the collection of firewall logs. 

### Verify that Windows Firewall is enabled

Follow these steps on the Windows machine:

1. Select **Start**, then open **Settings**.
1. Under **Update & Security**, select **Windows Security**, and then **Firewall & network protection**.
1. Select a network profile: **domain**, **private**, or **public**.
2. Verify that the **Microsoft Defender Firewall** setting is switched to **On**.

### Verify that firewall logs are being created

Start by checking the timestamps of the log files and open the latest to see that latest timestamps are present in the log files. The default location for firewall log files is **C:\windows\system32\logfiles\firewall\pfirewall.log**.

To verify and modify the logging settings, follow these steps on the Windows machine:

1. From the **Firewall & network protection** page, select **Advanced settings**.

2. Select **Monitoring** and check the **Logging Settings** for each profile.

    :::image type="content" source="media/data-collection-firewall-log/firewall-logging-settings.png" lightbox="media/data-collection-firewall-log/firewall-logging-settings.png" alt-text="Screenshot that shows current firewall log settings." :::


3. To change the logging settings, right-click **Windows Defender Firewall** in the left pane and select **Properties**. Select **Customize** next to **Logging** and modify any settings for each profile.

    :::image type="content" source="media/data-collection-firewall-log/turn-on-firewall-logging.png" lightbox="media/data-collection-firewall-log/turn-on-firewall-logging.png" alt-text="Screenshot that shows modifying firewall log settings." :::

You can enable logging for all profiles using the following command line:

```dos
netsh advfirewall set allprofiles logging allowedconnections enable​
netsh advfirewall set allprofiles logging droppedconnections enable​
```


### Run Azure Monitor Agent troubleshooter
To test your configuration and share logs with Microsoft use the [Azure Monitor Agent Troubleshooter](../agents/troubleshooter-ama-windows.md).


## Next steps
Learn more about: 
- [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md).
- [Data collection rules](../essentials/data-collection-rule-overview.md).
- [Data collection endpoints](../essentials/data-collection-endpoint-overview.md)
