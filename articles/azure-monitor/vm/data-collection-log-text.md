---
title: Collect text file from virtual machine with Azure Monitor
description: Configure a data collection rule to collect log data from a text file on a virtual machine using Azure Monitor Agent.
ms.topic: conceptual
ms.date: 03/03/2025
ms.reviewer: jeffwo
---

# Collect text file from virtual machine with Azure Monitor
Many applications and services on a virtual machine will log information to text files instead of standard logging services such as Windows Event log or Syslog. Collect custom text logs from virtual machines can be collected using a [data collection rule (DCR)](../essentials/data-collection-rule-create-edit.md) with a **Custom Text Logs** data source. 

Details for the creation of the DCR are provided in [Collect data from VM client with Azure Monitor](../vm/data-collection.md). This article provides additional details for the Custom Text Logs data source type.

> [!NOTE]
> To work with the DCR definition directly or to deploy with other methods such as ARM templates, see [Data collection rule (DCR) samples in Azure Monitor](../essentials/data-collection-rule-samples.md#text-logs).

## Prerequisites
In addition to the prerequisites listed in [Collect data from virtual machine client with Azure Monitor](./data-collection.md#prerequisites), you need a custom table in a Log Analytics workspace to receive the data. See [Log Analytics workspace table](#log-analytics-workspace-table) for details about the requirements of this table.

## Configure custom text file data source
Create the DCR using the process in [Collect data from virtual machine client with Azure Monitor](./data-collection.md). On the **Collect and deliver** tab of the DCR, select **Custom Text Logs** from the **Data source type** dropdown.

:::image type="content" source="media/data-collection-log-text/configuration.png" lightbox="media/data-collection-log-text/configuration.png" alt-text="Screenshot that shows configuration of text file collection.":::

The options available in the **Custom Text Logs** configuration are described in the following table.

| Setting | Description |
|:---|:---|
| File pattern | Identifies the location and name of log files on the local disk. Use a wildcard for filenames that vary, for example when a new file is created each day with a new name. You can enter multiple file patterns separated by commas.<br><br>Examples:<br>- C:\Logs\MyLog.txt<br>- C:\Logs\MyLog*.txt<br>- C:\App01\AppLog.txt, C:\App02\AppLog.txt<br>- /var/mylog.log<br>- /var/mylog*.log |
| Table name | Name of the destination table in your Log Analytics Workspace. This table must already exist. |     
| Record delimiter | Indicates the delimiter between log entries. `TimeStamp` is the only current allowed value. This looks for a date in the format specified in `timeFormat` to identify the start of a new record. If no date in the specified format is found then end of line is used. See [Time formats](#time-formats) for more details. | 
| Timestamp Format| The time format used in the log file as described in [Time formats](#time-formats) below. |
| Transform | [Ingestion-time transformation](../essentials/data-collection-transformations.md) to filter records or to format the incoming data for the destination table. Use `source` to leave the incoming data unchanged and sent to the `RawData` column. See [Delimited log files](#delimited-log-files) for an example of using a transformation. |

## Add destinations
Custom text logs can only be sent to a Log Analytics workspace where it's stored in the [custom table](#log-analytics-workspace-table) that you create. Add a destination of type **Azure Monitor Logs** and select a Log Analytics workspace. You can only add a single workspace to a DCR for a custom text log data source. If you need multiple destinations, create multiple DCRs. Be aware though that this will send duplicate data to each which will result in additional cost.

:::image type="content" source="media/data-collection/destination-workspace.png" lightbox="media/data-collection/destination-workspace.png" alt-text="Screenshot that shows configuration of an Azure Monitor Logs destination in a data collection rule." ::: 

### Time formats
The following table describes the time formats that are supported in the `timeFormat` setting of the DCR. If a time with the specified format is included in the log entry, it will be used to identify a new log entry. If no date in the specified format is found, then end of line is used as the delimiter. See [Multiline log files](#multiline-log-files) for further description on how this setting is used.

| Time format | Example |
|:---|:---|
| `ISO 8601`                | 2024-10-29T18:28:34Z |
| `yyyy-MM-ddTHH:mm:ssk`    | 2024-10-29T18:28:34Z<br>2024-10-29T18:28:34+01:11 |
| `YYYY-MM-DD HH:MM:SS`     | 2024-10-29 18:28:34 |
| `M/D/YYYY HH:MM:SS AM/PM` | 10/29/2024 06:28:34 PM |
| `Mon DD, YYYY HH:MM:SS`   | October 29, 2024 18:28:34 |
| `yyMMdd HH:mm:ss`         | 241029 18:28:34           |
| `ddMMyy HH:mm:ss`         | 291024 18:28:34           | 
| `MMM d HH:mm:ss`          | Oct 29 18:28:34           |
| `dd/MMM/yyyy:HH:mm:ss zzz`| 14/Oct/2024:18:28:34 -00  |


## Text file requirements and best practices
The file that Azure Monitor collects must meet the following requirements:

- The file must be stored on the local drive of the agent machine in the directory that is being monitored.
- The file must use ASCII or UTF-8 encoding. Other formats such as UTF-16 aren't supported.
- New records should be appended to the end of the file and not overwrite old records. Overwriting will cause data loss.

Following is a sample of a typical custom text file that can be collected by Azure Monitor. While each line does start with a date, this isn't required since end of line will be used to identify each entry if no date is found.

```plaintext
2024-06-21 19:17:34,1423,Error,Sales,Unable to connect to pricing service.
2024-06-21 19:18:23,1420,Information,Sales,Pricing service connection established.
2024-06-21 21:45:13,2011,Warning,Procurement,Module failed and was restarted.
2024-06-21 23:53:31,4100,Information,Data,Nightly backup complete.
```

Adhere to the following recommendations to ensure that you don't experience data loss or performance issues:
  
- Continuously clean up log files in the monitored directory. Tracking many log files can drive up agent CPU and Memory usage. Wait for at least two days to allow ample time for all logs to be processed.
- Don't rename a file that matches the file scan pattern to another name that also matches the file scan pattern. This will cause duplicate data to be ingested. 
- Don't rename or copy large log files that match the file scan pattern into the monitored directory. If you must, do not exceed 50MB per minute.

## Log Analytics workspace table
Each entry in the log file is collected as it's created and sent to the specified table in a Log Analytics workspace. The custom table in the Log Analytics workspace that will receive the data must exist before you create the DCR.

 The following table describes the required and optional columns in the workspace table. The table can include other columns, but they won't be populated unless you parse the data with a transformation as described in [Delimited log files](#delimited-log-files).

| Column | Type | Required? | Description |
|:---|:---|:---|:---|
| `TimeGenerated` | datetime | Yes | This column contains the time the record was generated and is required in all tables. This value will be automatically populated with the time the record is added to the Log Analytics workspace. You can override this value using a transformation to set `TimeGenerated` to a value from the log entry. |
| `RawData` | string | Yes<sup>1</sup> | The entire log entry in a single column. You can use a transformation if you want to break down this data into multiple columns before sending to the table. |
| `Computer` | string | No | If the table includes this column, it will be populated with the name of the computer the log entry was collected from. |
| `FilePath` | string | No | If the table includes this column, it will be populated with the path to the log file the log entry was collected from. |

<sup>1</sup> The table doesn't have to include a `RawData` column if you use a transformation to parse the data into multiple columns. 

When collected using default settings, the data from the sample log file shown above would appear as follows when retrieved with a log query.

:::image type="content" source="media/data-collection-log-text/default-results.png" lightbox="media/data-collection-log-text/default-results.png" alt-text="Screenshot that shows log query returning results of default file collection.":::

### Create custom table
If the destination table doesn't already exist then you must create it before creating the DCR. See [Create a custom table](../logs/create-custom-table.md#create-a-custom-table) for different methods to create a table.

For example, you can use the following PowerShell script to create a custom table to receive the data from a custom text log. This example also adds the optional columns.

```powershell
$tableParams = @'
{
    "properties": {
        "schema": {
               "name": "{TableName}_CL",
               "columns": [
                    {
                        "name": "TimeGenerated",
                        "type": "DateTime"
                    }, 
                    {
                        "name": "Computer",
                        "type": "string"
                    },
                    {
                        "name": "FilePath",
                        "type": "string"
                    },
                    {
                        "name": "RawData",
                        "type": "string"
                    }
              ]
        }
    }
}
'@
```

## Multiline log files
Some log files may contain entries that span multiple lines. If each log entry starts with a date, then this date can be used as the delimiter to define each log entry. In this case, the extra lines will be joined together in the `RawData` column.

For example, the text file in the previous example might be formatted as follows:

```plaintext
2024-06-21 19:17:34,1423,Error,Sales,
Unable to connect to pricing service.
2024-06-21 19:18:23,1420,Information,Sales,
Pricing service connection established.
2024-06-21 21:45:13,2011,Warning,Procurement,
Module failed and was restarted.
2024-06-21 23:53:31,4100,Information,Data,
Nightly backup complete.
```
If the time stamp format `YYYY-MM-DD HH:MM:SS` is used in the DCR, then the data would be collected in the same way as the previous example. The extra lines would be included in the `RawData` column. If another time stamp format were used that doesn't match the date in the log entry, then each entry would be collected as two separate records.

## Delimited log files
Many text log files have entries with columns delimited by a character such as a comma. Instead of sending the entire entry to the `RawData` column, you can parse the data into separate columns so that each can be populated in the destination table. Use a transformation with the [split function](/azure/data-explorer/kusto/query/split-function) to perform this parsing.

The sample text file shown above is comma-delimited, and the fields could be described as: `Time`, `Code`, `Severity`, `Module`, and `Message`. To parse this data into separate columns, add each of the columns to the destination table and add the following transformation to the DCR.

> [!IMPORTANT]
> Prior to adding this transformation to the DCR, you must add these columns to the destination table. You can modify the PowerShell script above to include the additional columns when the table is created. Or use the Azure portal as described in [Add or delete a custom column](../logs/create-custom-table.md#add-or-delete-a-custom-column) to add the columns to an existing table.

Notable details of the transformation query include the following:

- The query outputs properties that each match a column name in the target table. 
- This example renames the `Time` property in the log file so that this value is used for `TimeGenerated`. If this was not provided, then `TimeGenerated` would be populated with the ingestion time.
- Because `split` returns dynamic data, you must use functions such as `tostring` and `toint` to convert the data to the correct scalar type. 

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

- Learn more about [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md).
- Learn more about [data collection rules](../essentials/data-collection-rule-overview.md).
