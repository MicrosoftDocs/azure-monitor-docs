---
title: Sample data collection rules (DCRs) in Azure Monitor
description: Sample data collection rule for different Azure Monitor data collection scenarios.
author: bwren
ms.topic: sample
ms.date: 12/04/2024
ms.custom: references_region
ms.reviewer: jeffwo

---

# Data collection rule (DCR) samples in Azure Monitor
This article includes sample [data collection rules (DCR)](./data-collection-rule-overview.md) definitions for common data collection scenarios in Azure Monitor. You can modify these DCR definitions as required for your environment and create the DCR using the guidance in [Create or edit a data collection rule](./data-collection-rule-create-edit.md). You can also use and combine the basic strategies in these samples to create DCRs for other scenarios.

These samples require knowledge of the DCR structure as described in [Structure of a data collection rule in Azure Monitor](data-collection-rule-structure.md). Several may be configured using the Azure portal without any detailed knowledge of the DCR structure. Use these samples as a starting point if you want to manage the DCRs using methods outside of the Azure portal such as ARM, CLI, and PowerShell. You may need to use these methods to edit existing DCRs to implement advanced features such as [transformations](../essentials/data-collection-transformations.md).

Each of these samples focuses on a particular data source, although you can combine multiple data sources of different types in a single DCR. Include a data flow for each to send the data to the appropriate destination. There is no functional difference between combining multiple data sources in a single DCR or creating separate DCRs for each data source. The choice depends on your requirements for managing and monitoring the data collection.

> [!NOTE]
> The samples shown in this article provide the source JSON required to create the DCR. After creation, the DCR will have additional properties as described in [Structure of a data collection rule in Azure Monitor](data-collection-rule-structure.md).

## Collect VM client data
The following samples show DCR definitions for collecting different kinds of data from virtual machines using the [Azure Monitor agent](../agents/azure-monitor-agent-overview.md). You can create these DCRs using the Azure portal as described in [Collect data from VM client with Azure Monitor](../vm/data-collection.md). 

### Windows events
DCRs for Windows events use the `windowsEventLogs` data source with the `Microsoft-Event` incoming stream. The schema of this stream is known, so it doesn't need to be defined in the `dataSources` section. The events to collect are specified in the `xPathQueries` property. See [Collect Windows events with Azure Monitor Agent](../agents/data-collection-windows-events.md) for further details on using XPaths to filter the specific data you want to collect. To get started, you can use the guidance in that article to create a DCR using the Azure portal and then inspect the JSON using the guidance at [DCR definition](../essentials/data-collection-rule-create-edit.md#dcr-definition).

You can add a transformation to the `dataFlows` property for calculated columns and to further filter data, but you should use XPaths to filter data at the agent as much as possible for efficiency and to avoid potential ingestion charges.

The following sample DCR performs the following actions:

  - Collects Windows application and system events with error level of Warning, Error, or Critical.
  - Sends data to Event table in the workspace.
  - Uses a simple transformation of a `source` which makes no change to the incoming data.

```json
{
    "location": "eastus",
    "properties": {
      "dataSources": {
        "windowsEventLogs": [
          {
            "name": "eventLogsDataSource",
            "streams": [
              "Microsoft-Event"
            ],
            "xPathQueries": [
              "System!*[System[(Level = 1 or Level = 2 or Level = 3)]]",
              "Application!*[System[(Level = 1 or Level = 2 or Level = 3)]]"
            ]
          }
        ]
    },
      "destinations": {
        "logAnalytics": [
          {
            "workspaceResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace",
            "name": "centralWorkspace"
          }
        ]
      },
      "dataFlows": [
        {
          "streams": [
            "Microsoft-Event"
          ],
          "destinations": [
            "centralWorkspace"
          ],
            "transformKql": "source",
            "outputStream": "Microsoft-Event"
        }
      ]
    }
  }
```

### Syslog events
DCRs for Syslog events use the `syslog` data source with the incoming `Microsoft-Syslog` stream. The schema of this stream is known, so it doesn't need to be defined in the `dataSources` section. The events to collect are specified in the `facilityNames` and `logLevels` properties. See [Collect Syslog events with Azure Monitor Agent](../agents/data-collection-syslog.md) for further details. To get started, you can use the guidance in that article to create a DCR using the Azure portal and then inspect the JSON using the guidance at [DCR definition](../essentials/data-collection-rule-create-edit.md#dcr-definition).

You can add a transformation to the `dataFlows` property for additional functionality and to further filter data, but you should use `facilityNames` and `logLevels` for filtering as much as possible for efficiency at to avoid potential ingestion charges.

The following sample DCR performs the following actions:

- Collects all events from `cron` facility.
- Collects `Warning` and higher events from `syslog` and `daemon` facilities.
  - Sends data to Syslog table in the workspace.
  - Uses a simple transformation of a `source` which makes no change to the incoming data.

```json
{
    "location": "eastus",
    "properties": {
      "dataSources": {
        "syslog": [
          {
            "name": "cronSyslog",
            "streams": [
              "Microsoft-Syslog"
            ],
            "facilityNames": [
              "cron"
            ],
            "logLevels": [
              "Debug",
              "Info",
              "Notice",
              "Warning",
              "Error",
              "Critical",
              "Alert",
              "Emergency"
            ]
          },
          {
            "name": "syslogBase",
            "streams": [
              "Microsoft-Syslog"
            ],
            "facilityNames": [
              "daemon",              
              "syslog"
            ],
            "logLevels": [
              "Warning",
              "Error",
              "Critical",
              "Alert",
              "Emergency"           
            ]
          }
        ]
      },
      "destinations": {
        "logAnalytics": [
          {
            "workspaceResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace",
            "name": "centralWorkspace"
          }
        ]
      },
      "dataFlows": [
        {
          "streams": [
            "Microsoft-Syslog"
          ],
          "destinations": [
            "centralWorkspace"
          ],
            "transformKql": "source",
            "outputStream": "Microsoft-Syslog"
        }
      ]
    }
  }
```

### Performance counters
DCRs for performance data use the `performanceCounters` data source with the incoming `Microsoft-InsightsMetrics` and `Microsoft-Perf` streams. `Microsoft-InsightsMetrics` is used to send data to Azure Monitor Metrics, while `Microsoft-Perf` is used to send data to a Log Analytics workspace. You can include both data sources in the DCR if you're sending performance data to both destinations. The schemas of these streams are known, so they don't need to be defined in the `dataSources` section.
 
 The performance counters to collect are specified in the `counterSpecifiers` property. See [Collect performance counters with Azure Monitor Agent](../agents/data-collection-performance.md) for further details. To get started, you can use the guidance in that article to create a DCR using the Azure portal and then inspect the JSON using the guidance at [DCR definition](../essentials/data-collection-rule-create-edit.md#dcr-definition).

You can add a transformation to the `dataFlows` property for `Microsoft-Perf` for additional functionality and to further filter data, but you should select only the counters you require in `counterSpecifiers` for efficiency at to avoid potential ingestion charges.

The following sample DCR performs the following actions:

- Collects set of performance counters every 60 seconds and another set every 30 seconds.
- Sends data to Azure Monitor Metrics and a Log Analytics workspace.
- Uses a simple transformation of a `source` which makes no change to the incoming data.

```json
{
    "location": "eastus",
    "properties": {
      "dataSources": {
        "performanceCounters": [
          {
            "name": "perfCounterDataSource60",
            "streams": [
              "Microsoft-Perf",
              "Microsoft-InsightsMetrics"
            ],
            "samplingFrequencyInSeconds": 60,
            "counterSpecifiers": [
              "\\Processor(_Total)\\% Processor Time",
              "\\Memory\\Committed Bytes",
              "\\LogicalDisk(_Total)\\Free Megabytes",
              "\\PhysicalDisk(_Total)\\Avg. Disk Queue Length"
            ]
          },
          {
            "name": "perfCounterDataSource30",
            "streams": [
              "Microsoft-Perf"
            ],
            "samplingFrequencyInSeconds": 30,
            "counterSpecifiers": [
              "\\Process(_Total)\\Thread Count"
            ]
          }
        ]
      },
      "destinations": {
        "logAnalytics": [
          {
            "workspaceResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace",
            "name": "centralWorkspace"
          }
        ],
        "azureMonitorMetrics": 
        {
            "name": "azureMonitorMetrics-default"
        }
      },
      "dataFlows": [
        {
            "streams": [
                "Microsoft-Perf"
            ],
            "destinations": [
                "centralWorkspace"
            ],
            "transformKql": "source",
            "outputStream": "Microsoft-Perf"
        },
        {
            "streams": [
                "Microsoft-Perf"
            ],
            "destinations": [
                "azureMonitorMetrics-default"
            ],
            "outputStream": "Microsoft-InsightsMetrics"
        }
      ]
    }
}
```

### Text logs
DCRs for text logs have a `logfiles` data source that has the details for the log files that should be collected by the agent. This includes the name of a stream that must be defined in `streamDeclarations` with the columns of the incoming data. This is currently a set list as described in [Collect logs from a text file with Azure Monitor Agent](../agents/data-collection-log-text.md#incoming-stream).

Add a transformation to the `dataFlows` property to filter out records you don't want to collect and to format the data to match the schema of the destination table. A common scenario is to parse a delimited log file into multiple columns as described in [Delimited log files](../agents/data-collection-log-text.md#delimited-log-files).

The following sample DCR performs the following actions:

- Collects entries from all files with an extension of `.txt` in the `c:\logs` folder of the agent computer.
- Uses a transformation to split the incoming data into columns based on a comma (`,`) delimiter. This transformation is specific to the format of the log file and must be adjusted for log files with other formats.
- Sends the collected logs to a custom table called `MyTable_CL`. This table must already exist and have the columns output by the transformation.
- Collects the `FilePath` and `Computer` for text log as described in [Incoming stream](../agents/data-collection-log-text.md#incoming-stream). These columns must also exist in the destination table.

```json
{
    "location": "eastus",
    "properties": {
        "dataCollectionEndpointId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionEndpoints/my-dce",
        "streamDeclarations": {
            "Custom-MyLogFileFormat": {
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
                        "Custom-MyLogFileFormat"
                    ],
                    "filePatterns": [
                        "C:\\logs\\*.txt"
                    ],
                    "format": "text",
                    "settings": {
                        "text": {
                            "recordStartTimestampFormat": "ISO 8601"
                        }
                    },
                    "name": "myLogFileFormat-Windows"
                }
            ]
        },
        "destinations": {
            "logAnalytics": [
                {
                    "workspaceResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace",
                    "name": "MyDestination"
                }
            ]
        },
        "dataFlows": [
            {
                "streams": [
                    "Custom-MyLogFileFormat"
                ],
                "destinations": [
                    "MyDestination"
                ],
                "transformKql": "source | project d = split(RawData,\",\") | project TimeGenerated=todatetime(d[0]), Code=toint(d[1]), Severity=tostring(d[2]), Module=tostring(d[3]), Message=tostring(d[4])",
                "outputStream": "Custom-MyTable_CL"
            }
        ]
    }
}

```

### Json logs
DCRs for Json logs have a `logfiles` data source that has the details for the log files that should be collected by the agent. This includes the name of a stream that must be defined in `streamDeclarations` with the columns of the incoming data. See [Collect logs from a JSON file with Azure Monitor Agent](../agents/data-collection-log-json.md) for further details.

Add a transformation to the `dataFlows` property to filter out records you don't want to collect and to format the data to match the schema of the destination table.

The following sample DCR performs the following actions:

- Collects entries from all files with an extension of `.json` in the `c:\logs` folder of the agent computer. The file must be formatted in json and have the columns listed in the stream declaration.
- Sends the collected logs to a custom table called `MyTable_CL`. This table must already exist and have the same columns as the incoming stream. If the columns don't match, you would need to modify the transformation in `transformKql` property to format the data for the target table.

```json
{
    "location": "eastus",
    "properties": {
        "dataCollectionEndpointId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionEndpoints/my-dce",
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
                        "name": "Code",
                        "type": "int"
                    },
                    {
                        "name": "Module",
                        "type": "string"
                    },
                    {
                        "name": "Message",
                        "type": "string"
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
                        "C:\\logs\\*.json"
                    ],
                    "format": "json",
                    "name": "MyJsonFile"
                }
            ]
        },
        "destinations": {
            "logAnalytics": [
                {
                    "workspaceResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace",
                    "name": "MyDestination"
                }
            ]
        },
        "dataFlows": [
            {
                "streams": [
                    "Custom-Json-stream"
                ],
                "destinations": [
                    "MyDestination"
                ],
                "transformKql": "source",
                "outputStream": "Custom-MyTable_CL"
            }
        ]
    }
}
```

### Send data to Event Hubs or Storage
DCRs sending data to event hubs or storage accounts use the same data sources as other DCRs that collect data with Azure Monitor agent (AMA), but have one or more of the following destinations. See [Send data to Event Hubs and Storage (Preview)](../agents/azure-monitor-agent-send-data-to-event-hubs-and-storage.md) for more details.

- `eventHubsDirect`
- `storageBlobsDirect`
- `storageTablesDirect`

> [!NOTE]
> DCRs sending data to event hubs or storage accounts must have `"kind": "AgentDirectToStore"`

The following sample DCR performs the following actions:

- Collects performance counters and Windows events from Windows machines with Azure Monitor agent (AMA).
- Sends the data to event hub, blob storage, and table storage.

```json
{
    "location": "eastus",
    "kind": "AgentDirectToStore",
    "properties": {
        "dataSources": {
            "performanceCounters": [
                {
                "streams": [
                    "Microsoft-Perf"
                ],
                "samplingFrequencyInSeconds": 10,
                "counterSpecifiers": [
                    "\\Process(_Total)\\Working Set - Private",
                    "\\Memory\\% Committed Bytes In Use",
                    "\\LogicalDisk(_Total)\\% Free Space",
                    "\\Network Interface(*)\\Bytes Total/sec"
                ],
                "name": "perfCounterDataSource"
                }
            ],
            "windowsEventLogs": [
                {
                "streams": [
                    "Microsoft-Event"
                ],
                "xPathQueries": [
                    "Application!*[System[(Level=2)]]",
                    "System!*[System[(Level=2)]]"
                ],
                "name": "eventLogsDataSource"
                }
            ]
        },
        "destinations": {
            "eventHubsDirect": [
                {
                "eventHubResourceId": "/subscriptions/71b36fb6-4fe4-4664-9a7b-245dc62f2930/resourceGroups/my-resource-group/providers/Microsoft.EventHub/namespaces/my-eventhub-namespace/eventhubs/my-eventhub",
                "name": "myEh"
                }
            ],
            "storageBlobsDirect": [
                {
                "storageAccountResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/my-resource-group/providers/Microsoft.Storage/storageAccounts/mystorageaccount",
                "containerName": "myperfblob",
                "name": "PerfBlob"
                },
                {
                "storageAccountResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/my-resource-group/providers/Microsoft.Storage/storageAccounts/mystorageaccount",
                "containerName": "myeventblob",
                "name": "EventBlob"
                }
            ],
            "storageTablesDirect": [
                {
                "storageAccountResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/my-resource-group/providers/Microsoft.Storage/storageAccounts/mystorageaccount",
                "containerName": "myperftable",
                "name": "PerfTable"
                },
                {
                "storageAccountResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/my-resource-group/providers/Microsoft.Storage/storageAccounts/mystorageaccount",
                "containerName": "mymyeventtable",
                "name": "EventTable"
                }
            ]
        },
        "dataFlows": [
            {
                "streams": [
                "Microsoft-Perf"
                ],
                "destinations": [
                "myEh",
                "PerfBlob",
                "PerfTable"
                ]
            },
            {
                "streams": [
                "Microsoft-Event"
                ],
                "destinations": [
                "myEh",
                "EventBlob",
                "EventTable"
                ]
            },
        ]
    }
}
```



## Logs ingestion API
DCRs for the Logs ingestion API must define the schema of the incoming stream in the `streamDeclarations` section of the DCR definition. The incoming data must be formatted in JSON with a schema matching the columns in this definition. No transformation is required if this schema matches the schema of the target table. If the schemas don't match, then you must add a transformation to the `dataFlows` property to format the data. See [Logs Ingestion API in Azure Monitor](../logs/logs-ingestion-api-overview.md) for more details.

The sample DCR below has the following details:

- Sends data to a table called `MyTable_CL` in a workspace called `my-workspace`. Before installing this DCR, you would need to create the table with the following columns:
  - TimeGenerated
  - Computer
  - AdditionalContext
  - ExtendedColumn (defined in the transformation)
- Applies a [transformation](../essentials/data-collection-transformations.md) to the incoming data to format the data for the target table.

> [!IMPORTANT]
> This sample doesn't include the [`dataCollectionEndpointId`](../logs/logs-ingestion-api-overview.md#endpoint) property since this is created automatically when the DCR is created. You need the value of this property since it's the URL that the application will send data to. The DCR must have `kind:Direct` for this property to be created. See [Properties](../essentials/data-collection-rule-structure.md#properties) for more details.

```json
{
    "location": "eastus",
    "kind": "Direct",
    "properties": {
        "streamDeclarations": {
            "Custom-MyTable": {
                "columns": [
                    {
                        "name": "Time",
                        "type": "datetime"
                    },
                    {
                        "name": "Computer",
                        "type": "string"
                    },
                    {
                        "name": "AdditionalContext",
                        "type": "string"
                    }
                ]
            }
        },
        "destinations": {
            "logAnalytics": [
                {
                    "workspaceResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/cefingestion/providers/microsoft.operationalinsights/workspaces/my-workspace",
                    "name": "LogAnalyticsDest"
                }
            ]
        },
        "dataFlows": [
            {
                "streams": [
                    "Custom-MyTable"
                ],
                "destinations": [
                    "LogAnalyticsDest"
                ],
                "transformKql": "source | extend jsonContext = parse_json(AdditionalContext) | project TimeGenerated = Time, Computer, AdditionalContext = jsonContext, ExtendedColumn=tostring(jsonContext.CounterName)",
                "outputStream": "Custom-MyTable_CL"
            }
        ]
    }
}
```

## Workspace transformation DCR
Workspace transformation DCRs have an empty `datasources` section since the transformations are applied to any data sent to supported tables in the workspace. It must include one and only entry for `workspaceResourceId` and an entry in `dataFlows` for each table with a transformation. It also must have `"kind": "WorkspaceTransforms"`.

The sample DCR below has the following details:
- Transformation for the `LAQueryLogs` table that filters out queries of the table itself and adds a column with the workspace name.
- Transformation for the `Event` table that filters out Information events and removes the `ParameterXml` column. This will only apply to data coming from the deprecated Log Analytics agent and not the Azure Monitor agent as explained in [Workspace transformation DCR](./data-collection-transformations.md#workspace-transformation-dcr).

```json
{
    "kind": "WorkspaceTransforms",
    "location": "eastus",
    "properties": {
        "dataSources": {},
        "destinations": {
            "logAnalytics": [
                {
                    "workspaceResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace",
                    "name": "clv2ws1"
                }
            ]
        },
        "dataFlows": [
            {
                "streams": [
                    "Microsoft-Table-LAQueryLogs"
                ],
                "destinations": [
                    "clv2ws1"
                ],
                "transformKql": "source | where QueryText !contains 'LAQueryLogs' | extend Context = parse_json(RequestContext) | extend Workspace_CF = tostring(Context['workspaces'][0]) | project-away RequestContext, Context"
            },
            {
                "streams": [
                    "Microsoft-Table-Event"
                ],
                "destinations": [
                    "clv2ws1"
                ],
                "transformKql": "source | where EventLevelName in ('Error', 'Critical', 'Warning') | project-away ParameterXml"
            }
        ]
    }
}
```


## Send data to multiple tables
There are multiple reasons why you might want to send data from a single data source to multiple tables in the same Log Analytics workspace, including the following:

- Save ingestion costs by sending records used for occasional troubleshooting to a [basic logs table](../logs/basic-logs-azure-tables.md). 
- Send records or columns with sensitive data to a table with different permissions or retention settings.

To send data from a single data source to multiple tables, create multiple data flows in the DCR with a unique transformation query and output table for each as shown in the following diagram.

> [!IMPORTANT]
> Currently, the tables in the DCR must be in the same Log Analytics workspace. To send to multiple workspaces from a single data source, use multiple DCRs and configure your application to send the data to each.

:::image type="content" source="media/data-collection-rule-samples/multiple-destinations.png" lightbox="media/data-collection-rule-samples/multiple-destinations.png" alt-text="Diagram that shows transformation sending data to multiple tables." border="false":::

The following sample filters records sent to the Event table by the Azure Monitor agent. Only warning and error events are sent to the Event table. Other events are sent to a copy of the event table named Event_CL which is configured for basic logs.

> [!NOTE]
> This sample requires a copy of the Event table created in the same workspace named Event_CL. 

```json
{
    "location": "eastus",
    "properties": {
        "dataSources": {
            "windowsEventLogs": [
              {
                "name": "eventLogsDataSource",
                "streams": [
                  "Microsoft-Event"
                ],
                "xPathQueries": [
                  "System!*[System[(Level = 1 or Level = 2 or Level = 3)]]",
                  "Application!*[System[(Level = 1 or Level = 2 or Level = 3)]]"
                ]
              }
            ]
        },
        "destinations": {
            "logAnalytics": [
                {
                    "workspaceResourceId": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace",
                    "name": "MyDestination"
                }
            ]
        },
        "dataFlows": [
            {
                "streams": [
                    "Microsoft-Event"
                ],
                "destinations": [
                    "MyDestination"
                ],
                "transformKql": "source | where EventLevelName in ('Error', 'Warning')",
                "outputStream": "Microsoft-Event"
            },
            {
                "streams": [
                    "Microsoft-Event"
                ],
                "destinations": [
                    "MyDestination"
                ],
                "transformKql": "source | where EventLevelName !in ('Error', 'Warning')",
                "outputStream": "Custom-Event_CL"
            }
        ]
    }
}
```



## Next steps

- [Get details for the different properties in a DCR](../essentials/data-collection-rule-structure.md)
- [See different methods for creating a DCR](../essentials/data-collection-rule-create-edit.md)
