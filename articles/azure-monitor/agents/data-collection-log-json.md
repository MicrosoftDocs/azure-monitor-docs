---
title: Collect logs from a JSON file with Azure Monitor Agent 
description: Configure a data collection rule to collect log data from a JSON file on a virtual machine using Azure Monitor Agent.
ms.topic: conceptual
ms.date: 02/14/2025
author: guywi-ms
ms.author: guywild
ms.reviewer: jeffwo
---

# Collect logs from a JSON file with Azure Monitor Agent 
**Custom JSON Logs** is one of the data sources you can collect from a virtual machine using a [data collection rule (DCR)](../essentials/data-collection-rule-create-edit.md) in Azure Monitor. Details for the creation of the DCR are provided in [Collect data with Azure Monitor Agent](./azure-monitor-agent-data-collection.md). This article provides additional details for the JSON logs data source type.

## Prerequisites

- Custom table in a Log Analytics workspace to receive the data. See [Create a custom table](../logs/create-custom-table.md#create-a-custom-table) for different methods.
- A data collection endpoint (DCE) in the same region as the Log Analytics workspace. See [How to set up data collection endpoints based on your deployment](../essentials/data-collection-endpoint-overview.md#how-to-set-up-data-collection-endpoints-based-on-your-deployment) for details.
- Either a new or existing DCR described in [Collect data with Azure Monitor Agent](./azure-monitor-agent-data-collection.md).

> [!WARNING]
> You shouldn't use an existing custom table used by Log Analytics agent. The legacy agents won't be able to write to the table once the first Azure Monitor agent writes to it. Create a new table for Azure Monitor agent to use to prevent Log Analytics agent data loss.

## Basic operation
The following diagram shows the basic operation of collecting log data from a json file. 

1. The agent watches for any log files that match a specified name pattern on the local disk. 
2. Each entry in the log is collected and sent to Azure Monitor. The incoming stream defined by the user is used to parse the log data into columns.
3. A default transformation is used if the schema of the incoming stream matches the schema of the target table.

:::image type="content" source="media/data-collection-log-json/json-log-collection.png" lightbox="media/data-collection-log-json/json-log-collection.png" alt-text="Screenshot that shows log query returning results of comma-delimited file collection." border="false":::


## JSON file requirements
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

Following is a sample of a typical JSON log file that can be collected by Azure Monitor.

```json
{"TimeGenerated":"2025-02-14 01:08:53","StatusCode":3215,"Message":"This is the status message."}
{"TimeGenerated":"2025-02-14 01:08:53","StatusCode":3215,"Message":"This is the status message."}
{"TimeGenerated":"2025-02-14 01:08:53","StatusCode":3215,"Message":"This is the status message."}
{"TimeGenerated":"2025-02-14 01:08:53","StatusCode":3215,"Message":"This is the status message."}
{"TimeGenerated":"2025-02-14 01:08:53","StatusCode":3215,"Message":"This is the status message."}
```

## Incoming stream schema

| Column | Type | Description |
|:---|:---|:---|
| `TimeGenerated` | datetime | The time the record was generated. This value will be automatically populated with the time the record is added to the Log Analytics workspace if it's not included in the incoming stream.  |
| `FilePath` | string | If you add this column to the incoming stream in the DCR, it will be populated with the path to the log file. This column is not created automatically and can't be added using the portal. You must manually modify the DCR created by the portal or create the DCR using another method where you can explicitly define the incoming stream. |
| `Computer` | string | If you add this column to the incoming stream in the DCR, it will be populated with the name of the computer with the log file. This column is not created automatically and can't be added using the portal. You must manually modify the DCR created by the portal or create the DCR using another method where you can explicitly define the incoming stream. |

### Transformation
The [transformation](../essentials/data-collection-transformations.md) potentially modifies the incoming stream to filter records or to modify the schema to match the target table. If the schema of the incoming stream is the same as the target table, then you can use the default transformation of `source`. If not, then modify the `transformKql` section of tee ARM template with a KQL query that returns the required schema.

## Create a data collection rule for a JSON file

### [Portal](#tab/portal)

Create a data collection rule, as described in [Collect data with Azure Monitor Agent](./azure-monitor-agent-data-collection.md). In the **Collect and deliver** step, select **Custom Text Logs** from the **Data source type** dropdown. 
 

| Setting | Description |
|:---|:---|
| File pattern | Identifies the location and name of log files on the local disk. Use a wildcard for filenames that vary, for example when a new file is created each day with a new name. You can enter multiple file patterns separated by commas.<br><br>Examples:<br>- C:\Logs\MyLog.txt<br>- C:\Logs\MyLog*.txt<br>- C:\App01\AppLog.txt, C:\App02\AppLog.txt<br>- /var/mylog.log<br>- /var/mylog*.log |
| Table name | Name of the destination table in your Log Analytics Workspace. |     
| Record delimiter | Not currently used but reserved for future potential use allowing delimiters other than the currently supported end of line (`/r/n`). | 
| Transform | [Ingestion-time transformation](../essentials/data-collection-transformations.md) to filter records or to format the incoming data for the destination table. Use `source` to leave the incoming data unchanged. |



### [Resource Manager template](#tab/arm)

Use the following ARM template to create a DCR for collecting JSON log files, making the changes described in the previous sections. The following table describes the parameters that require values when you deploy the template.

| Setting | Description |
|:---|:---|
| Data collection rule name | Unique name for the DCR. |
| Data collection endpoint resource ID | Resource ID of the data collection endpoint (DCE). |
| Location | Region for the DCR. Must be the same location as the Log Analytics workspace. |
| File patterns | Identifies the location and name of log files on the local disk. Use a wildcard for filenames that vary, for example when a new file is created each day with a new name. You can enter multiple file patterns separated by commas (AMA version 1.26 or higher required for multiple file patterns on Linux).<br><br>Examples:<br>- C:\Logs\MyLog.json<br>- C:\Logs\MyLog*.json<br>- C:\App01\AppLog.json, C:\App02\AppLog.json<br>- /var/mylog.json<br>- /var/mylog*.json |
| Table name | Name of the destination table in your Log Analytics Workspace. |     
| Workspace resource ID | Resource ID of the Log Analytics workspace with the target table. |

After you create the DCR using an ARM template, you must associate the DCR with the machine that will use it. You can use the Azure portal and select the machines as described in [Add resources](./azure-monitor-agent-data-collection.md#add-resources)

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "dataCollectionRuleName": {
            "type": "string",
            "metadata": {
                "description": "Unique name for the DCR."
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
                "description": "Region for the DCR. Must be the same location as the Log Analytics workspace."
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
        }
      }
    },
    "variables": {
        "tableOutputStream": "[concat('Custom-', parameters('tableName'))]"
    },
    "resources": [
        {
            "type": "Microsoft.Insights/dataCollectionRules",
            "apiVersion": "2022-06-01",
            "name": "[parameters('dataCollectionRuleName')]",
            "location": "[parameters('location')]",
            "properties": {
                "dataCollectionEndpointId": "[parameters('dataCollectionEndpointResourceId')]",
                "streamDeclarations": {
                    "Custom-Json-stream": {
                        "columns": [
                            {
                                "name": "TimeGenerated",
                                "type": "datetime"
                            },
                            {
                                "name": "FilePath",
                                "type": "string"
                            },
                            {
                                "name": "MyStringColumn",
                                "type": "string"
                            },
                            {
                                "name": "MyIntegerColumn",
                                "type": "int"
                            },
                            {
                                "name": "MyRealColumn",
                                "type": "real"
                            },
                            {
                                "name": "MyBooleanColumn",
                                "type": "boolean"
                            }
                        ]
                    }
                },
                "dataSources": {
                    "logFiles": [
                        {
                            "streams": [
                                "Custom-Json-stream"
                            ],
                            "filePatterns": [
                                "[parameters('filePatterns')]"
                            ],
                            "format": "json",
                            "name": "Custom-Json-stream"
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
                            "Custom-Json-stream"
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

## Transformation
A [transformation](../essentials/data-collection-transformations.md) can modifies the incoming stream to filter records or to modify the schema to match the target table. The default transformation of `source` makes does not modify the table.

## Troubleshooting
Go through the following steps if you aren't collecting data from the JSON log that you're expecting.

- Verify that data is being written to the log file being collected.
- Verify that the name and location of the log file matches the file pattern you specified.
- Verify that the schema of the incoming stream in the DCR matches the schema in the log file.
- Verify that the schema of the target table matches the incoming stream or that you have a transformation that will convert the incoming stream to the correct schema.
- See [Verify operation](./azure-monitor-agent-data-collection.md#verify-operation) to verify whether the agent is operational and data is being received.




## Next steps

Learn more about: 

- [Azure Monitor Agent](azure-monitor-agent-overview.md).
- [Data collection rules](../essentials/data-collection-rule-overview.md).
- [Best practices for cost management in Azure Monitor](../best-practices-cost.md).
