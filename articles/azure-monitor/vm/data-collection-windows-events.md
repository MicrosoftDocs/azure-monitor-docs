---
title: Collect Windows events from virtual machines with Azure Monitor Agent
description: Describes how to collect Windows events counters from virtual machines, Virtual Machine Scale Sets, and Arc-enabled on-premises servers using Azure Monitor Agent.
ms.topic: conceptual
ms.date: 03/03/2025
ms.reviewer: jeffwo

---

# Collect Windows events from virtual machine with Azure Monitor
Windows event logs are some of the most common sources for health of the client operating system and workloads of Windows machines. You can collect events from standard logs, such as System and Application, and any custom logs created by applications you need to monitor. Collect Windows event logs from virtual machines using a [data collection rule (DCR)](../essentials/data-collection-rule-create-edit.md) with a **Windows events** data source. 

Details for the creation of the DCR are provided in [Collect data from VM client with Azure Monitor](../vm/data-collection.md). This article provides additional details for the Windows Events data source type.

> [!NOTE]
> To work with the DCR definition directly or to deploy with other methods such as ARM templates, see [Data collection rule (DCR) samples in Azure Monitor](../essentials/data-collection-rule-samples.md#windows-events).

## Configure Windows event data source
Create the DCR using the process in [Collect data from virtual machine client with Azure Monitor](./data-collection.md). On the **Collect and deliver** tab of the DCR, select **Windows Event Logs** from the **Data source type** dropdown. Select from a set of logs and severity levels to collect. Only logs with the selected severity level for each log are collected.

> [!TIP]
> If you select the **Security** log in the DCR, the events are sent to the [Event](/azure/azure-monitor/reference/tables/Event) table in your Log Analytics workspace with events from other logs such as System and Application. Another option is to enable [Microsoft Sentinel](/azure/sentinel/) on the workspace and enable the [Windows Security Events via AMA connector for Microsoft Sentinel](/azure/sentinel/data-connectors/windows-security-events-via-ama). This uses the same [Azure Monitor agent](../agents/azure-monitor-agent-overview.md) and collects the same events, but they're sent to the [SecurityEvent](/azure/azure-monitor/reference/tables/SecurityEvent) table which is used by Sentinel.

:::image type="content" source="media/data-collection-windows-event/data-source-windows-event.png" lightbox="media/data-collection-windows-event/data-source-windows-event.png" alt-text="Screenshot that shows configuration of a Windows event data source in a data collection rule." :::

Select **Custom** to [filter events by using XPath queries](#filter-events-using-xpath-queries). This allows you more granular control over the events that you collect by using an [XPath](https://www.w3schools.com/xml/xpath_syntax.asp) to specify the events to collect. See [Filter events using XPath queries](#filter-events-using-xpath-queries) for details and examples of XPath queries.

:::image type="content" source="media/data-collection-windows-event/data-source-windows-event-custom.png" lightbox="media/data-collection-windows-event/data-source-windows-event-custom.png" alt-text="Screenshot that shows custom configuration of a Windows event data source in a data collection rule." :::


## Add destinations
Windows event data can only be sent to a Log Analytics workspace where it's stored in the [Event](/azure/azure-monitor/reference/tables/event) table. Add a destination of type **Azure Monitor Logs** and select a Log Analytics workspace. While you can add multiple workspaces, be aware that this sends duplicate data to each which results in additional cost.


:::image type="content" source="media/data-collection/destination-workspace.png" lightbox="media/data-collection/destination-workspace.png" alt-text="Screenshot that shows configuration of an Azure Monitor Logs destination in a data collection rule." :::


## Verify data collection
To verify that data is being collected, check for records in the **Event** table. From the virtual machine or from the Log Analytics workspace in the Azure portal, select **Logs** and then click the **Tables** button. Under the **Virtual machines** category, click **Run** next to **Event**. 

:::image type="content" source="media/data-collection-windows-event/verify-event.png" lightbox="media/data-collection-windows-event/verify-event.png" alt-text="Screenshot that shows records returned from Event table." :::

## Filter events using XPath queries
The basic configuration in the Azure portal provides you with a limited ability to filter events based on log and severity. To specify more granular filtering, use custom configuration and specify an XPath that filters for only the events you need. 

XPath entries are written in the form `LogName!XPathQuery`. For example, you might want to return only events from the Application event log with an event ID of 1035. The `XPathQuery` for these events would be `*[System[EventID=1035]]`. Because you want to retrieve the events from the Application event log, the XPath is `Application!*[System[EventID=1035]]`

> [!NOTE]
> Azure Monitor agent uses the [EvtSubscribe](/windows/win32/api/winevt/nf-winevt-evtsubscribe) system API to subscribe to Windows Event Logs. Windows OS does not allow subscribing to Windows Event Logs of type Analytic/Debug channels. Therefore, you cannot collect or export data from Analytic and Debug channels to a Log Analytics workspace.

### Extract XPath queries from Windows Event Viewer

You can use Event Viewer in Windows to extract XPath queries as shown in the following screenshots.

When you paste the XPath query into the field on the **Add data source** screen, as shown in step 5, you must append the log type category followed by an exclamation point (!).

:::image type="content" source="media/data-collection-rule-azure-monitor-agent/data-collection-rule-extract-xpath.png" lightbox="media/data-collection-rule-azure-monitor-agent/data-collection-rule-extract-xpath.png" alt-text="Screenshot that shows the steps to create an XPath query in the Windows Event Viewer.":::


> [!TIP]
> You can use the PowerShell cmdlet `Get-WinEvent` with the `FilterXPath` parameter to test the validity of an XPath query locally on your machine first. For more information, see the tip provided in the [Windows agent-based connections](/azure/sentinel/connect-services-windows-based) instructions. The [`Get-WinEvent`](/powershell/module/microsoft.powershell.diagnostics/get-winevent) PowerShell cmdlet supports up to 23 expressions. Azure Monitor data collection rules support up to 20. The following script shows an example:
>
> ```powershell
> $XPath = '*[System[EventID=1035]]'
> Get-WinEvent -LogName 'Application' -FilterXPath $XPath
> ```
>
> - In the preceding cmdlet, the value of the `-LogName` parameter is the initial part of the XPath query until the exclamation point (!). The rest of the XPath query goes into the `$XPath` parameter.
> - If the script returns events, the query is valid.
> - If you receive the message "No events were found that match the specified selection criteria," the query might be valid but there are no matching events on the local machine.
> - If you receive the message "The specified query is invalid," the query syntax is invalid.

The following table gives examples of XPath queries to filter events:

| Description |  XPath |
|:---|:---|
| Collect only System events with Event ID = 4648 |  `System!*[System[EventID=4648]]`
| Collect Security Log events with Event ID = 4648 and a process name of consent.exe | `Security!*[System[(EventID=4648)]] and *[EventData[Data[@Name='ProcessName']='C:\Windows\System32\consent.exe']]` |
| Collect all Critical, Error, Warning, and Information events from the System event log except for Event ID = 6 (Driver loaded) |  `System!*[System[(Level=1 or Level=2 or Level=3) and (EventID != 6)]]` |
| Collect all success and failure Security events except for Event ID 4624 (Successful logon) |  `Security!*[System[(band(Keywords,13510798882111488)) and (EventID != 4624)]]` |

> [!NOTE]
> For a list of limitations in the XPath supported by Windows event log, see [XPath 1.0 limitations](/windows/win32/wes/consuming-events#xpath-10-limitations).  For example, you can use the "position", "Band", and "timediff" functions within the query but other functions like "starts-with" and "contains" are not currently supported.


## Next steps

- Learn more about [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md).
- Learn more about [data collection rules](../essentials/data-collection-rule-overview.md).
