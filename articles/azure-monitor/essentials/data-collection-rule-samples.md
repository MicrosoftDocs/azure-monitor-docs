---
title: Sample data collection rules (DCRs) in Azure Monitor
description: Sample data collection rule for different Azure Monitor data collection scenarios.
author: bwren
ms.topic: sample
ms.date: 11/01/2024
ms.custom: references_region
ms.reviewer: jeffwo

---

# Data collection rule (DCR) samples and scenarios in Azure Monitor
This article includes sample [data collection rules (DCRs)](./data-collection-rule-overview.md) for common data collection scenarios. You can modify these DCRs as required for your environment and create them using the guidance in [Create or edit a data collection rule](./data-collection-rule-create-edit.md). You can also use the basic strategies in these samples to create DCRs for other scenarios.

> [!NOTE]
> These samples provide the source JSON of a DCR if you're using an ARM template or REST API to create or modify a DCR. After creation, the DCR will have additional properties as described in [Structure of a data collection rule in Azure Monitor](data-collection-rule-structure.md).


## Azure Monitor agent
The [Azure Monitor agent](../agents/azure-monitor-agent-data-collection.md) runs on virtual machines, virtual machine scale sets, and Kubernetes clusters. It supports [VM insights](../agents/vminsights-overview.md) and [container insights](../agents/container-insights-overview.md) and supports various data collection scenarios for VMs described in [Azure Monitor agent data collection](../agents/azure-monitor-agent-data-collection.md). 

### Windows events
DCRs for Windows events use the incoming `Microsoft-Event` stream. The schema of this stream is known, so it doesn't need to be defined. The events to collect are specified in the `xPathQueries` property. See [Collect Windows events with Azure Monitor Agent](../agents/data-collection-windows-events.md) for further details. To get started, you can use the guidance in that article to create a DCR using the Azure portal and then inspect the JSON using the guidance at [DCR definition](./data-collection-rule-create-edit.md#dcr-definition).

You can add a transformation to the `dataFlows` property for additional functionality and to further filter data, but you should use facilities and logLevels for filtering as much as possible for efficiency at to avoid potential ingestion charges.

The following sample DCR performs the following actions:

  - Collects Windows security events and uploads every minute.
  - Collects Windows application and system events and uploads every 5 minutes.> [!NOTE]

```json
{
    "location": "eastus",
    "properties": {
      "dataSources": {
        "windowsEventLogs": [
          {
            "name": "securityEvents",
            "streams": [
              "Microsoft-Event"
            ],
            "scheduledTransferPeriod": "PT1M",
            "xPathQueries": [
              "Security!*"
            ]
          },
          {
            "name": "appEvents",
            "streams": [
              "Microsoft-Event"
            ],
            "scheduledTransferPeriod": "PT5M",
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
            "workspaceResourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace",
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
          ]
        }
      ]
    }
  }
```

### Syslog events
DCRs for Syslog events use the incoming `Microsoft-Syslog` stream. The schema of this stream is known, so it doesn't need to be defined. The events to collect are specified in the `facilityNames` and `logLevels` properties. See [Collect Syslog events with Azure Monitor Agent](../agents/data-collection-syslog-events.md) for further details. To get started, you can use the guidance in that article to create a DCR using the Azure portal and then inspect the JSON using the guidance at [DCR definition](./data-collection-rule-create-edit.md#dcr-definition).

You can add a transformation to the `dataFlows` property for additional functionality and to further filter data, but you should use `facilityNames` and `logLevels` for filtering as much as possible for efficiency at to avoid potential ingestion charges.

The following sample DCR performs the following actions:

- Collects all events from `cron` facility.
- Collects `Warning` and higher events from `syslog` and `daemon` facilities.


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
              "Emergency"            ]
          }
        ]
      },
      "destinations": {
        "logAnalytics": [
          {
            "workspaceResourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace",
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
          ]
        }
      ]
    }
  }
```

### Performance counters


```json
{
    "location": "eastus",
    "properties": {
      "dataSources": {
        "performanceCounters": [
          {
            "name": "cloudTeamCoreCounters",
            "streams": [
              "Microsoft-Perf"
            ],
            "scheduledTransferPeriod": "PT1M",
            "samplingFrequencyInSeconds": 15,
            "counterSpecifiers": [
              "\\Processor(_Total)\\% Processor Time",
              "\\Memory\\Committed Bytes",
              "\\LogicalDisk(_Total)\\Free Megabytes",
              "\\PhysicalDisk(_Total)\\Avg. Disk Queue Length"
            ]
          },
          {
            "name": "appTeamExtraCounters",
            "streams": [
              "Microsoft-Perf"
            ],
            "scheduledTransferPeriod": "PT5M",
            "samplingFrequencyInSeconds": 30,
            "counterSpecifiers": [
              "\\Process(_Total)\\Thread Count"
            ]
          }
        ],
      },
      "destinations": {
        "logAnalytics": [
          {
            "workspaceResourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace",
            "name": "centralWorkspace"
          }
        ]
      },
      "dataFlows": [
        {
          "streams": [
            "Microsoft-Perf"
          ],
          "destinations": [
            "centralWorkspace"
          ]
        }
      ]
    }
  }
```

### Text logs
The sample data collection rule below is used to collect [text logs using Azure Monitor agent](../agents/data-collection-text-log.md). Note that the names of streams for custom text logs should begin with the "Custom-" prefix.

```json
{
    "location": "eastus",
    "properties": {
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
                },
                {
                    "streams": [
                        "Custom-MyLogFileFormat" 
                    ],
                    "filePatterns": [
                        "//var//*.log"
                    ],
                    "format": "text",
                    "settings": {
                        "text": {
                            "recordStartTimestampFormat": "ISO 8601"
                        }
                    },
                    "name": "myLogFileFormat-Linux"
                }
            ]
        },
        "destinations": {
            "logAnalytics": [
                {
                    "workspaceResourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace",
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
                "transformKql": "source",
                "outputStream": "Custom-MyTable_CL"
            }
        ]
    }
}
```

### Json logs
The sample data collection rule below is used to collect [text logs using Azure Monitor agent](../agents/data-collection-text-log.md). Note that the names of streams for custom text logs should begin with the "Custom-" prefix.

```json
{
    "location": "eastus",
    "properties": {
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
                        "C:\\logs\\*.json"
                    ],
                    "format": "json",
                    "settings": {
                        "text": {
                            "recordStartTimestampFormat": "ISO 8601"
                        }
                    },
                    "name": "myLogFileFormat-Windows"
                },
                {
                    "streams": [
                        "Custom-MyLogFileFormat" 
                    ],
                    "filePatterns": [
                        "//var//*.log"
                    ],
                    "format": "text",
                    "settings": {
                        "text": {
                            "recordStartTimestampFormat": "ISO 8601"
                        }
                    },
                    "name": "myLogFileFormat-Linux"
                }
            ]
        },
        "destinations": {
            "logAnalytics": [
                {
                    "workspaceResourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace",
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
                "transformKql": "source",
                "outputStream": "Custom-MyTable_CL"
            }
        ]
    }
}
```

## Send data to Event Hubs
The sample data collection rule below is used to collect [data from an event hub](../logs/ingest-logs-event-hub.md).

```json
{
    "location": "eastus",
    "properties": {
        "streamDeclarations": {
            "Custom-MyEventHubStream": {
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
                        "name": "Properties",
                        "type": "dynamic"
                    }
                ]
            }
        },
        "dataSources": {
            "dataImports": {
                "eventHub": {
                            "consumerGroup": "<consumer-group>",
                            "stream": "Custom-MyEventHubStream",
                            "name": "myEventHubDataSource1"
                            }
                }
        },
        "destinations": {
            "logAnalytics": [
                {
                    "workspaceResourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace",
                    "name": "MyDestination"
                }
            ]
        },
        "dataFlows": [
            {
                "streams": [
                    "Custom-MyEventHubStream"
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

## Logs ingestion API
DCRs for the [Logs ingestion API](../logs/logs-ingestion-api-overview.md) must define schema of the incoming stream in the `streamDeclarations` section of the DCR definition. The incoming data must be formatted in JSON with a schema matching the columns in this definition. No transformation is required if this schema matches the schema of the target table. If the schemas don't match, then you must add a transformation to the `dataFlows` property to format the data for the target table. 

The sample DCR below has the following details:

- Sends data to a table called `MyTable_CL` in a workspace called `my-workspace`. Before installing this DCR, you would need to create the table with the following columns:
  - TimeGenerated
  - Computer
  - AdditionalContext
  - ExtendedColumn
- Applies a [transformation](../essentials/data-collection-transformations.md) to the incoming data to format the data for the target table.

> [!IMPORTANT]
> This sample doesn't include the `dataCollectionEndpointId` property because with `kind:Direct`, when the DCR is created. the [`logsIngestion`](../essentials/data-collection-rule-structure.md#properties) property will be created. This includes the URL of the endpoint that the application can use.

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
                    "workspaceResourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/cefingestion/providers/microsoft.operationalinsights/workspaces/my-workspace",
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
Workspace transformation DCRs have an empty `datasources` section since the transformations are applied to any data sent to supported tables in the workspace. It must include one and only entry for `workspaceResourceId` and an entry in `dataFlows` for each table with a transformation.

The sample DCR below has the following details:
- Transformation for the `LAQueryLogs` table that filters out queries of the table itself and adds a column with the workspace name.
- Transformation for the `Event` table that filters out Information events and removes the `ParameterXml` column. This will only apply to data coming from the deprecated Log Analytics agent and not the Azure Monitor agent.

```json
{
    "location": "eastus",
    "properties": {
        "dataSources": {},
        "destinations": {
            "logAnalytics": [
                {
                    "workspaceResourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace",
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
            "logFiles": [
                {
                    "streams": [
                        "Microsoft-Event"
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
                    "workspaceResourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace",
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
                "transformKql": "source | where Level in ('Error', 'Warning')",
                "outputStream": "Event"
            },
            {
                "streams": [
                    "Microsoft-Event"
                ],
                "destinations": [
                    "MyDestination"
                ],
                "transformKql": "source | where Level not in ('Error', 'Warning')",
                "outputStream": "Event_CL"
            }
        ]
    }
}
```



## Next steps

- [Get details for the different properties in a DCR](../essentials/data-collection-rule-structure.md)
- [See different methods for creating a DCR](../essentials/data-collection-rule-create-edit.md)

