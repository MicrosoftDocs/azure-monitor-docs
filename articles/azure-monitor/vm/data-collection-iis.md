---
title: Collect IIS logs from virtual machine with Azure Monitor
description: Configure collection of Internet Information Services (IIS) logs on virtual machines with Azure Monitor Agent.
ms.topic: concept-article
ms.date: 03/03/2025
ms.reviewer: jeffwo

---

# Collect IIS logs from virtual machine with Azure Monitor
Internet Information Services (IIS) stores user activity in log files that can be collected by Azure Monitor agent and sent to a Log Analytics workspace.


**IIS Logs** is one of the data sources used in a [data collection rule (DCR)](../essentials/data-collection-rule-create-edit.md). Details for the creation of the DCR are provided in [Collect data with Azure Monitor Agent](../vm/data-collection.md). This article provides additional details for the Windows events data source type.

## Configure IIS log data source

Create a data collection rule, as described in [Collect data with Azure Monitor Agent](../vm/data-collection.md). In the **Collect and deliver** step, select **IIS Logs** from the **Data source type** dropdown. You only need to specify a file pattern to identify the directory where the log files are located if they are stored in a different location than configured in IIS. In most cases, you can leave this value blank.

:::image type="content" source="media/data-collection-iis/iis-data-collection-rule.png" lightbox="media/data-collection-iis/iis-data-collection-rule.png" alt-text="Screenshot that shows the Azure portal form to select basic performance counters in a data collection rule.":::

## Destinations

IIS log data can be sent to the following locations.

| Destination | Table / Namespace |
|:---|:---|
| Log Analytics workspace | [W3CIISLog](/azure/azure-monitor/reference/tables/w3ciislog) |


## Configure collection of IIS logs on client
Before you can collect IIS logs from the machine, you must ensure that IIS logging has been enabled and is configured correctly.

- The IIS log file must be in W3C format and stored on the local drive of the machine running the agent. 
- Each entry in the log file must be delineated with an end of line. 
- The log file must not use circular logging, which overwrites old entries.
- The log file must not use renaming, where a file is moved and a new file with the same name is opened. 

The default location for IIS log files is **C:\\inetpub\\logs\\LogFiles\\W3SVC1**. Verify that log files are being written to this location or check your IIS configuration to identify an alternate location. Check the timestamps of the log files to ensure that they're recent.

:::image type="content" source="media/data-collection-iis/iis-log-format-setting.png" lightbox="media/data-collection-iis/iis-log-format-setting.png" alt-text="Screenshot of IIS logging configuration dialog box on agent machine.":::



    



> [!NOTE]
> The X-Forwarded-For custom field is not supported at this time. If this is a critical field, you can collect the IIS logs as a custom text log.

## Troubleshooting
Go through the following steps if you aren't collecting data from the JSON log that you're expecting.

- Verify that IIS logs are being created in the location you specified.
- Verify that IIS logs are configured to be W3C formatted.
- See [Verify operation](../vm/data-collection.md#verify-operation) to verify whether the agent is operational and data is being received.


## Next steps

Learn more about: 

- [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md).
- [Data collection rules](../essentials/data-collection-rule-overview.md).
- [Best practices for cost management in Azure Monitor](../best-practices-cost.md).
