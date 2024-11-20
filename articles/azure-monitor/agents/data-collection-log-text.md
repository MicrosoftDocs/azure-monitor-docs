---
title: Collect logs from a text file with Azure Monitor Agent 
description: Configure a data collection rule to collect log data from a text file on a virtual machine using Azure Monitor Agent.
ms.topic: conceptual
ms.date: 11/14/2024
author: guywi-ms
ms.author: guywild
ms.reviewer: jeffwo
---

# Collect logs from a text file with Azure Monitor Agent 
**Custom Text Logs** is one of the data sources used in a [data collection rule (DCR)](../essentials/data-collection-rule-create-edit.md). Details for the creation of the DCR are provided in [Collect data with Azure Monitor Agent](./azure-monitor-agent-data-collection.md). This article provides additional details for the text logs type.

Many applications and services will log information to text files instead of standard logging services such as Windows Event log or Syslog. This data can be collected with [Azure Monitor Agent](azure-monitor-agent-overview.md) and stored in a Log Analytics workspace with data collected from other sources.

## Prerequisites

- Log Analytics workspace where you have at least [contributor rights](../logs/manage-access.md#azure-rbac).
- A data collection endpoint (DCE) in the same region as the Log Analytics workspace. See [How to set up data collection endpoints based on your deployment](../essentials/data-collection-endpoint-overview.md#how-to-set-up-data-collection-endpoints-based-on-your-deployment) for details.
- Either a new or existing DCR described in [Collect data with Azure Monitor Agent](./azure-monitor-agent-data-collection.md).

## Basic operation

The following diagram shows the basic operation of collecting log data from a text file. 

1. The agent watches for any log files that match a specified name pattern on the local disk. 
2. Each entry in the log is collected and sent to Azure Monitor. The incoming stream includes the entire log entry in a single column. 
3. If the default transformation is used, the entire log entry is sent to a single column in the target table.
4. If a custom transformation is used, the log entry can be parsed into multiple columns in the target table.


:::image type="content" source="media/data-collection-log-text/text-log-collection.png" lightbox="media/data-collection-log-text/text-log-collection.png" alt-text="Diagram showing collection of a text log by the Azure Monitor agent, showing both simple collection and a transformation for a comma-delimited file." border="false":::


## Text file requirements and best practices
The file that the Azure Monitor Agent is monitoring must meet the following requirements:

- The file must be stored on the local drive of the machine with the Azure Monitor Agent in the directory that is being monitored.
- Each record must be delineated with an end of line. 
- The file must use ASCII or UTF-8 encoding. Other formats such as UTF-16 aren't supported.
- New records should be appended to the end of the file and not overwrite old records. Overwriting will cause data loss.

Adhere to the following recommendations to ensure that you don't experience data loss or performance issues:
  
- Create a new log file every day so that you can easily clean up old files.
- Continuously clean up log files in the monitored directory. Tracking many log files can drive up agent CPU and Memory usage. Wait for at least 2 days to allow ample time for all logs to be processed.
- Don't rename a file that matches the file scan pattern to another name that also matches the file scan pattern. This will cause duplicate data to be ingested. 
- Don't rename or copy large log files that match the file scan pattern into the monitored directory. If you must, do not exceed 50MB per minute.


## Incoming stream

> [!NOTE]
> Multiline support that uses a time stamp to delimited events is now available.  You must use a resource management template deployment until support is added in the Portal UI.

The incoming stream of data includes the columns in the following table. 

| Column | Type | Description |
|:---|:---|:---|
| `TimeGenerated` | datetime | The time the record was generated. This value will be automatically populated with the time the record is added to the Log Analytics workspace. You can override this value using a transformation to set `TimeGenerated` to another value. |
| `RawData` | string | The entire log entry in a single column. You can use a transformation if you want to break down this data into multiple columns before sending to the table. |
| `FilePath` | string | If you add this column to the incoming stream in the DCR, it will be populated with the path to the log file. This column is not created automatically and can't be added using the portal. You must manually modify the DCR created by the portal or create the DCR using another method where you can explicitly define the incoming stream. |
| `Computer` | string | If you add this column to the incoming stream in the DCR, it will be populated with the name of the computer with the log file. This column is not created automatically and can't be added using the portal. You must manually modify the DCR created by the portal or create the DCR using another method where you can explicitly define the incoming stream. |


## Custom table
Before you can collect log data from a text file, you must create a custom table in your Log Analytics workspace to receive the data. The table schema must match the data you are collecting, or you must add a transformation to ensure that the output schema matches the table. 

> [!Warning]
> To avoid data loss, it’s important that you do not use an existing custom log table that MMA agents are currently utilizing.
> Once any AMA agent writes to an existing custom log table, MMA agents will no longer be able to write to that table.
> Instead, you should create a new table specifically for AMA agents to ensure smooth transition from one agent to the next.


For example, you can use the following PowerShell script to create a custom table with `RawData`, `FilePath`, and `Computer`. You wouldn't need a transformation for this table because the schema matches the default schema of the incoming stream. 


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
                        "name": "RawData",
                        "type": "String"
                    },
                    {
                        "name": "FilePath",
                        "type": "String"
                    },
                    {
                        "name": "Computer",
                        "type": "String"
                    }
              ]
        }
    }
}
'@

Invoke-AzRestMethod -Path "/subscriptions/{subscription}/resourcegroups/{resourcegroup}/providers/microsoft.operationalinsights/workspaces/{WorkspaceName}/tables/{TableName}_CL?api-version=2021-12-01-preview" -Method PUT -payload $tableParams
```


## Create a data collection rule for a text file

### [Portal](#tab/portal)

Create a data collection rule, as described in [Collect data with Azure Monitor Agent](./azure-monitor-agent-data-collection.md). In the **Collect and deliver** step, select **Custom Text Logs** from the **Data source type** dropdown. 
 

| Setting | Description |
|:---|:---|
| File pattern | Identifies the location and name of log files on the local disk. Use a wildcard for filenames that vary, for example when a new file is created each day with a new name. You can enter multiple file patterns separated by commas.<br><br>Examples:<br>- C:\Logs\MyLog.txt<br>- C:\Logs\MyLog*.txt<br>- C:\App01\AppLog.txt, C:\App02\AppLog.txt<br>- /var/mylog.log<br>- /var/mylog*.log |
| Table name | Name of the destination table in your Log Analytics Workspace. |     
| Record delimiter | Not currently used but reserved for future potential use allowing delimiters other than the currently supported end of line (`/r/n`). | 
| Transform | [Ingestion-time transformation](../essentials/data-collection-transformations.md) to filter records or to format the incoming data for the destination table. Use `source` to leave the incoming data unchanged. |

 

### [Resource Manager template](#tab/arm)

Use the following ARM template to create a DCR for collecting text log files, making the changes described in the previous sections. The following table describes the parameters that require values when you deploy the template. 
 

| Setting | Description |
|:---|:---|
| File pattern | Identifies the location and name of log files on the local disk. Use a wildcard for filenames that vary, for example when a new file is created each day with a new name. You can enter multiple file patterns separated by commas.<br><br>Examples:<br>- C:\Logs\MyLog.txt<br>- C:\Logs\MyLog*.txt<br>- C:\App01\AppLog.txt, C:\App02\AppLog.txt<br>- /var/mylog.log<br>- /var/mylog*.log |
| Table name | Name of the destination table in your Log Analytics Workspace. |     
| Record delimiter | Not currently used but reserved for future potential use allowing delimiters other than the currently supported end of line (`/r/n`). | 
| Transform | [Ingestion-time transformation](../essentials/data-collection-transformations.md) to filter records or to format the incoming data for the destination table. Use `source` to leave the incoming data unchanged. |
| timeFormat| The following times formats are supported.  Use the quotes strings in your ARM template. Do not include the sample time that is in parentheses. <br> - “yyyy-MM-ddTHH:mm:ssk”   (2024-10-29T18:28:34) <br> - “YYYY-MM-DD HH:MM:SS”   (2024-10-29 18:28:34) <br> - “M/D/YYYY HH:MM:SS AM/PM”   (10/29/2024 06:28:34 PM) <br> - “Mon DD, YYYY HH:MM:SS”   (Oct[ober] 29, 2024 18:28:34) <br> - “yyMMdd HH:mm:ss”   (241029 18:28:34) <br> - “ddMMyy HH:mm:ss”   (291024 18:28:34) <br> - “MMM d HH:mm:ss”   (Oct 29 18:28:34) <br> - “dd/MMM/yyyy:HH:mm:ss zzz”   (14/Oct/2024:18:28:34 -000) |



Use the following ARM template to create or modify a DCR for collecting text log files. In addition to the parameter values, you may need to modify the following values in the template:

- `columns`: Remove the `FilePath` column if you don't want to collect it.
- `transformKql`: Modify the default transformation if you want to modify or filter the incoming stream, for example to parse the log entry into multiple columns. The output schema of the transformation must match the schema of the target table.

> [!IMPORTANT]
> If you create the DCR using an ARM template, you still must associate the DCR with the agents that will use it. You can edit the DCR in the Azure portal and select the agents as described in [Add resources](../essentials/data-collection-rule-create-edit.md#add-resources). The parameters section in the DCR is optional if you replace them with strings lower down in the JSON.

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "dataCollectionRuleName": {
            "type": "string",
            "metadata": {
              "description": "Unique name for the DCR. "
            }
        },
        "dataCollectionEndpointResourceId": {
            "type": "string",
            "metadata": {
              "description": "Resource ID of the data collection endpoint (DCE)."
            }
        },
        "location": {
            "type": "string",
            "metadata": {
              "description": "Region for the DCR. Must be the same location as the Log Analytics workspace. "
            }
        },
        "filePatterns": {
            "type": "string",
            "metadata": {
              "description": "Path on the local disk for the log file to collect. May include wildcards.Enter multiple file patterns separated by commas (AMA version 1.26 or higher required for multiple file patterns on Linux)."
            }
        },
        "tableName": {
            "type": "string",
            "metadata": {
              "description": "Name of destination table in your Log Analytics workspace. "
            }
        },
        "workspaceResourceId": {
            "type": "string",
            "metadata": {
              "description": "Resource ID of the Log Analytics workspace with the target table."
            }
        },
        "timeFormat": {
            "type": "string"
            "metadata": {
                "discription": "The time format that you would like to use to split multi line imput"
            }
      }
    },
    "variables": {
      "tableOutputStream": "[concat('Custom-', parameters('tableName'))]"
    },
    "resources": [
        {
            "type": "Microsoft.Insights/dataCollectionRules",
            "name": "[parameters('dataCollectionRuleName')]",
            "location": "[parameters('location')]",
            "apiVersion": "2022-06-01",
            "properties": {
                "dataCollectionEndpointId": "[parameters('dataCollectionEndpointResourceId')]",
                "streamDeclarations": {
                    "Custom-Text-stream": {
                        "columns": [
                            {
                                "name": "TimeGenerated",
                                "type": "datetime"
                            },
                            {
                                "name": "RawData",
                                "type": "string"
                            },
                            {
                                "name": "FilePath",
                                "type": "string"
                            },
                            {
                                "name": "Computer",
                                "type": "string"
                            }
                        ]
                    }
                },
                "dataSources": {
                    "logFiles": [
                        {
                            "streams": [
                                "Custom-Text-stream"
                            ],
                            "filePatterns": [
                                "[parameters('filePatterns')]"
                            ],
                            "format": "text",
                            "name": "Custom-Text-dataSource",
                            "settings": {
                               "text": {
                                      "recordStartTimestampFormat": "[parameters('timeFormat')]"
                               }
                            }
                        }
                    ]
                },
                "destinations": {
                    "logAnalytics": [
                        {
                            "workspaceResourceId": "[parameters('workspaceResourceId')]",
                            "name": "workspace"
                        }
                    ]
                },
                "dataFlows": [
                    {
                        "streams": [
                            "Custom-Text-dataSource"
                        ],
                        "destinations": [
                            "workspace"
                        ],
                        "transformKql": "source",
                        "outputStream": "[variables('tableOutputStream')]"
                    }
                ]
            }
        }
    ]
}
```

---

## Delimited log files
Many text log files have entries that are delimited by a character such as a comma. To parse this data into separate columns, use a transformation with the [split function](/azure/data-explorer/kusto/query/split-function).

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
- See [Verify operation](./azure-monitor-agent-data-collection.md#verify-operation) to verify whether the agent is operational and data is being received.

## Next steps

Learn more about: 

- [Azure Monitor Agent](azure-monitor-agent-overview.md)
- [Data collection rules](../essentials/data-collection-rule-overview.md)
- [Best practices for cost management in Azure Monitor](../best-practices-cost.md)
