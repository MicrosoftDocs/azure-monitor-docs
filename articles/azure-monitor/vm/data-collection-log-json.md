---
title: Collect JSON file from virtual machine with Azure Monitor
description: Configure a data collection rule to collect log data from a JSON file on a virtual machine using Azure Monitor Agent.
ms.topic: conceptual
ms.date: 03/04/2025
ms.reviewer: jeffwo
---

# Collect JSON file from virtual machine with Azure Monitor
Many applications and services will log information to text files instead of standard logging services such as Windows Event log or Syslog. If this data is stored in JSON format, it can be collected by Azure Monitor in a [data collection rule (DCR)](../essentials/data-collection-rule-create-edit.md) with a **Custom JSON Logs** data source.

Details for the creation of the DCR are provided in [Collect data with Azure Monitor Agent](../vm/data-collection.md). This article provides additional details for the JSON logs type.

> [!NOTE]
> To work with the DCR definition directly or to deploy with other methods such as ARM templates, see [Data collection rule (DCR) samples in Azure Monitor](../essentials/data-collection-rule-samples.md#json-logs).

## Prerequisites
In addition to the prerequisites listed in [Collect data from virtual machine client with Azure Monitor](./data-collection.md#prerequisites), you need a custom table in a Log Analytics workspace to receive the data. See [Log Analytics workspace table](#log-analytics-workspace-table) for the  [Create a custom table](../logs/create-custom-table.md#create-a-custom-table) for different methods.

## Configure custom JSON file data source

On the **Collect and deliver** tab of the DCR, select **Custom JSON Logs** from the **Data source type** dropdown.

The options available in the **Custom JSON Logs** configuration are described in the following table.

| Setting | Description |
|:---|:---|
| File pattern | Identifies the location and name of log files on the local disk. Use a wildcard for filenames that vary, for example when a new file is created each day with a new name. You can enter multiple file patterns separated by commas.<br><br>Examples:<br>- C:\Logs\MyLog.txt<br>- C:\Logs\MyLog*.txt<br>- C:\App01\AppLog.txt, C:\App02\AppLog.txt<br>- /var/mylog.log<br>- /var/mylog*.log |
| Table name | Name of the destination table in your Log Analytics Workspace. |     
| Transform | [Ingestion-time transformation](../essentials/data-collection-transformations.md) to filter records or to format the incoming data for the destination table. Use `source` to leave the incoming data unchanged. |
| JSON Schema | Columns to collect from the JSON log file and sent to the destination table. The columns described in [Log Analytics workspace table](#log-analytics-workspace-table) that aren't required, do not need to be included in the schema of the destination table. `TimeGenerated` and any other columns that you added, do not need to be included in the schema of the destination table. |

Retrieving this data with a log query would return the following results.

:::image type="content" source="media/data-collection-log-text/delimited-results.png" lightbox="media/data-collection-log-text/delimited-results.png" alt-text="Screenshot that shows log query returning results of comma-delimited file collection.":::

## JSON file requirements and best practices
The file that the Azure Monitor agent is collecting must meet the following requirements:

- The file must be stored on the local drive of the agent machine in the directory that is being monitored.
- Each entry must be contained in a single row and delineated with an end of line. The JSON body format is not supported. See sample below.
- The file must use ASCII or UTF-8 encoding. Other formats such as UTF-16 aren't supported.
- New records should be appended to the end of the file and not overwrite old records. Overwriting will cause data loss.

Adhere to the following recommendations to ensure that you don't experience data loss or performance issues:

- Create a new log file every day so that you can easily clean up old files.
- Continuously clean up log files in the monitored directory. Tracking many log files can drive up agent CPU and Memory usage. Wait for at least 2 days to allow ample time for all logs to be processed.
- Don't rename a file that matches the file scan pattern to another name that also matches the file scan pattern. This will cause duplicate data to be ingested. 
- Don't rename or copy large log files that match the file scan pattern into the monitored directory. If you must, do not exceed 50MB per minute.

Following is a sample of a typical JSON log file that can be collected by Azure Monitor. This includes the fields: `Time`, `Code`, `Severity`,`Module`, and `Message`. 

```json
{"Time":"2024-06-21 19:17:34","Code":1423,"Severity":"Error","Module":"Sales","Message":"Unable to connect to pricing service."}
{"Time":"2024-06-21 19:18:23","Code":1420,"Severity":"Information","Module":"Sales","Message":"Pricing service connection established."}
{"Time":"2024-06-21 21:45:13","Code":"2011","Severity":"Warning","Module":"Procurement","Message":"Module failed and was restarted."}
{"Time":"2024-06-21 23:53:31","Code":"4100","Severity":"Information","Module":"Data","Message":"Nightly backup complete."}
```

## Log Analytics workspace table
The agent watches for any json files on the local disk that match the specified name pattern. Each entry is collected as it's written to the log and then parsed before being sent to the specified table in a Log Analytics workspace. The custom table in the Log Analytics workspace that will receive the data must exist before you create the DCR.

Any columns in the table that match the name of a field in the parsed Json data will be populated with the value from the log entry. The following table describes the required and optional columns in the table in addition to the columns identified in your JSON data. 

| Column | Type | Required? | Description |
|:---|:---|:---|:---|
| `TimeGenerated` | datetime | Yes | This column contains the time the record was generated and is required in all tables. This value will be automatically populated with the time the record is added to the Log Analytics workspace. You can override this value using a transformation to set `TimeGenerated` to a value from the log entry. |
| `Computer` | string | No | If the table includes this column, it will be populated with the name of the computer the log entry was collected from. |
| `FilePath` | string | No | If the table includes this column, it will be populated with the path to the log file the log entry was collected from. |

> [!WARNING]
> You shouldn't use an existing custom table used by Log Analytics agent. The legacy agents won't be able to write to the table once the first Azure Monitor agent writes to it. Create a new table for Azure Monitor agent to use to prevent Log Analytics agent data loss.

See [Create a custom table](../logs/create-custom-table.md#create-a-custom-table) for different methods to create a table. For example, you can use the following PowerShell script to create a custom table to receive the data from the sample JSON file in [JSON file requirements and best practices](#json-file-requirements-and-best-practices).  

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
                        "name": "Severity",
                        "type": "int"
                    },
                    {
                        "name": "Message",
                        "type": "string"
                    }
              ]
        }
    }
}
'@

Invoke-AzRestMethod -Path "/subscriptions/{subscription}/resourcegroups/{resourcegroup}/providers/microsoft.operationalinsights/workspaces/{WorkspaceName}/tables/{TableName}_CL?api-version=2021-12-01-preview" -Method PUT -payload $tableParams
```

## Transformation
The [transformation](../essentials/data-collection-transformations.md) potentially modifies the incoming stream to filter records or to modify the schema to match the target table. If the schema of the incoming stream is the same as the target table, then you can use the default transformation of `source`. If not, then modify the `transformKql` section of the ARM template with a KQL query that returns the required schema.

For example, in the example above, the log entry has a `Time` field that contains the time the log entry was created. There is no corresponding field in the destination table though, so the `TimeGenerated` property is populated with the time that the log entry is received. To map the value of the `Time` field in the log entry to the `TimeGenerated` field in the destination table, you can use a transformation like the following:

```json
source | extend TimeGenerated = todatetime(Time) | project-away Time
```


## Troubleshooting
Go through the following steps if you aren't collecting data from the JSON log that you're expecting.

- Verify that data is being written to the log file being collected.
- Verify that the name and location of the log file matches the file pattern you specified.
- Verify that the schema of the incoming stream in the DCR matches the schema in the log file.
- Verify that the schema of the target table matches the incoming stream or that you have a transformation that will convert the incoming stream to the correct schema.
- See [Verify operation](../vm/data-collection.md#verify-operation) to verify whether the agent is operational and data is being received.




## Next steps

Learn more about: 

- [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md).
- [Data collection rules](../essentials/data-collection-rule-overview.md).
