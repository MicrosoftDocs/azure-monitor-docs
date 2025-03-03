---
title: Collect logs from a text file with Azure Monitor Agent 
description: Configure a data collection rule to collect log data from a text file on a virtual machine using Azure Monitor Agent.
ms.topic: conceptual
ms.date: 02/18/2025
author: bwren
ms.author: bwren
ms.reviewer: jeffwo
---

# Collect logs from a text file with Azure Monitor Agent 
Many applications and services will log information to text files instead of standard logging services such as Windows Event log or Syslog. This data can be collected by Azure Monitor using the **Custom Text Logs** data source in a [data collection rule (DCR)](../essentials/data-collection-rule-create-edit.md). Details for the creation of the DCR are provided in [Collect data with Azure Monitor Agent](../vm/data-collection.md). This article provides additional details for the custom text logs type.

## Prerequisites
 
- Custom table in a Log Analytics workspace to receive the data. See [Create a custom table](../logs/create-custom-table.md#create-a-custom-table) for different methods to create a new table if you don't already have one.
- A data collection endpoint (DCE) in the same region as the Log Analytics workspace. See [How to set up data collection endpoints based on your deployment](../essentials/data-collection-endpoint-overview.md#how-to-set-up-data-collection-endpoints-based-on-your-deployment) for details.
- Either a new or existing DCR described in [Collect data with Azure Monitor Agent](../vm/data-collection.md).

> [!WARNING]
> You shouldn't use an existing custom table used by Log Analytics agent. The legacy agents won't be able to write to the table once the first Azure Monitor agent writes to it. Create a new table for Azure Monitor agent to use to prevent Log Analytics agent data loss.

## Text file requirements and best practices
The file that Azure Monitor collects must meet the following requirements:

- The file must be stored on the local drive of the machine with the Azure Monitor Agent in the directory that is being monitored.
- Each record must be delineated with an end of line. 
- The file must use ASCII or UTF-8 encoding. Other formats such as UTF-16 aren't supported.
- New records should be appended to the end of the file and not overwrite old records. Overwriting will cause data loss.

Adhere to the following recommendations to ensure that you don't experience data loss or performance issues:
  
- Create a new log file every day so that you can easily clean up old files.
- Continuously clean up log files in the monitored directory. Tracking many log files can drive up agent CPU and Memory usage. Wait for at least 2 days to allow ample time for all logs to be processed.
- Don't rename a file that matches the file scan pattern to another name that also matches the file scan pattern. This will cause duplicate data to be ingested. 
- Don't rename or copy large log files that match the file scan pattern into the monitored directory. If you must, do not exceed 50MB per minute.

## Log Analytics workspace table
The agent watches for any log files on the local disk that match the specified name pattern. Each entry is collected as it's written to the log and sent to the specified table in a Log Analytics workspace. The custom table in the Log Analytics workspace that will receive the data must exist before you create the DCR.

 The following table describes the required and optional columns in the table. The table can include other columns, but they won't be populated unless you parse the data with a transformation as described in [Delimited log files](#delimited-log-files).

| Column | Type | Required? | Description |
|:---|:---|:---|:---|
| `TimeGenerated` | datetime | Yes | This column contains the time the record was generated and is required in all tables. This value will be automatically populated with the time the record is added to the Log Analytics workspace. You can override this value using a transformation to set `TimeGenerated` to a value from the log entry. |
| `RawData` | string | Yes<sup>1</sup> | The entire log entry in a single column. You can use a transformation if you want to break down this data into multiple columns before sending to the table. |
| `Computer` | string | No | If the table includes this column, it will be populated with the name of the computer the log entry was collected from. |
| `FilePath` | string | No | If the table includes this column, it will be populated with the path to the log file the log entry was collected from. |

<sup>1</sup> The table doesn't have to include a `RawData` column if you use a transformation to parse the data into multiple columns. 

For example, consider a text file with the following data.

```plaintext
2024-06-21 19:17:34,1423,Error,Sales,Unable to connect to pricing service.
2024-06-21 19:18:23,1420,Information,Sales,Pricing service connection established.
2024-06-21 21:45:13,2011,Warning,Procurement,Module failed and was restarted.
2024-06-21 23:53:31,4100,Information,Data,Nightly backup complete.
```

When collected using default settings, this data would appear as follows when retrieved with a log query.

:::image type="content" source="media/data-collection-log-text/default-results.png" lightbox="media/data-collection-log-text/default-results.png" alt-text="Screenshot that shows log query returning results of default file collection.":::


## Create a data collection rule (DCR) for a text file

Create a DCR, as described in [Collect data with Azure Monitor Agent](../vm/data-collection.md). In the **Collect and deliver** step, select **Custom Text Logs** from the **Data source type** dropdown. 

:::image type="content" source="media/data-collection-log-text/configuration.png" lightbox="media/data-collection-log-text/configuration.png" alt-text="Screenshot that shows configuration of text file collection.":::

The options available in the **Custom Text Logs** configuration are described in the following table.

| Setting | Description |
|:---|:---|
| File pattern | Identifies the location and name of log files on the local disk. Use a wildcard for filenames that vary, for example when a new file is created each day with a new name. You can enter multiple file patterns separated by commas.<br><br>Examples:<br>- C:\Logs\MyLog.txt<br>- C:\Logs\MyLog*.txt<br>- C:\App01\AppLog.txt, C:\App02\AppLog.txt<br>- /var/mylog.log<br>- /var/mylog*.log |
| Table name | Name of the destination table in your Log Analytics Workspace. This table must already exist. |     
| Record delimiter | Indicates the delimiter between log entries. `TimeStamp` is the only current allowed value. This looks for a date in the format specified in `timeFormat` to identify the start of a new record. If no date in the specified format is found then end of line is used. | 
| timeFormat| The following time formats are supported.<br><br> - `yyyy-MM-ddTHH:mm:ssk`  (2024-10-29T18:28:34) <br> - `YYYY-MM-DD HH:MM:SS`   (2024-10-29 18:28:34) <br> - `M/D/YYYY HH:MM:SS AM/PM`   (10/29/2024 06:28:34 PM) <br> - `Mon DD, YYYY HH:MM:SS`   (October 29, 2024 18:28:34) <br> - `yyMMdd HH:mm:ss`   (241029 18:28:34) <br> - `ddMMyy HH:mm:ss`   (291024 18:28:34) <br> - `MMM d HH:mm:ss`   (Oct 29 18:28:34) <br> - `dd/MMM/yyyy:HH:mm:ss zzz`   (14/Oct/2024:18:28:34 -00) |
| Transform | [Ingestion-time transformation](../essentials/data-collection-transformations.md) to filter records or to format the incoming data for the destination table. Use `source` to leave the incoming data unchanged and sent to the `RawData` column. |


## Delimited log files
Many text log files have entries with columns delimited by a character such as a comma. Instead of sending the entire entry to the `RawData` column, you can parse the data into separate columns so that each can be populated in the destination table. Use a transformation with the [split function](/azure/data-explorer/kusto/query/split-function) to perform this parsing.

For example, consider a text file with the following comma-delimited data. These fields could be described as: `Time`, `Code`, `Severity`,`Module`, and `Message`. 

```plaintext
2024-06-21 19:17:34,1423,Error,Sales,Unable to connect to pricing service.
2024-06-21 19:18:23,1420,Information,Sales,Pricing service connection established.
2024-06-21 21:45:13,2011,Warning,Procurement,Module failed and was restarted.
2024-06-21 23:53:31,4100,Information,Data,Nightly backup complete.
```

The following transformation parses the data into separate columns. Because `split` returns dynamic data, you must use functions such as `tostring` and `toint` to convert the data to the correct scalar type. You also need to provide a name for each entry that matches the column name in the target table. Note that this example provides a `TimeGenerated` value. If this was not provided, the ingestion time would be used.

```kusto
source | project d = split(RawData,",") | project TimeGenerated=todatetime(d[0]), Code=toint(d[1]), Severity=tostring(d[2]), Module=tostring(d[3]), Message=tostring(d[4])
```

:::image type="content" source="media/data-collection-log-text/delimited-configuration.png" lightbox="media/data-collection-log-text/delimited-configuration.png" alt-text="Screenshot that shows configuration of comma-delimited file collection.":::

Retrieving this data with a log query would return the following results.

:::image type="content" source="media/data-collection-log-text/delimited-results.png" lightbox="media/data-collection-log-text/delimited-results.png" alt-text="Screenshot that shows log query returning results of comma-delimited file collection.":::


## Troubleshooting
Go through the following steps if you aren't collecting data from the text log that you're expecting.

- Verify that data is being written to the log file being collected.
- Verify that the name and location of the log file matches the file pattern you specified.
- Verify that the schema of the target table matches the incoming stream or that you have a transformation that will convert the incoming stream to the correct schema.
- See [Verify operation](../vm/data-collection.md#verify-operation) to verify whether the agent is operational and data is being received.

## Next steps

Learn more about: 

- [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md)
- [Data collection rules](../essentials/data-collection-rule-overview.md)
- [Best practices for cost management in Azure Monitor](../best-practices-cost.md)
