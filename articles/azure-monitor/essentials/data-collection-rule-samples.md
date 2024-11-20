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
This article includes strategies and sample [data collection rules (DCRs)](./data-collection-rule-overview.md) for common data collection scenarios.



**Filter data**

Use a `where` statement to filter the incoming data. If the incoming record doesn't match the statement, then the record is not sent to the destination. In the following example, only records with a severity of "Critical" are collected.

```kusto
source | where severity == "Critical" 
```

**Modify schema**

Use commands such as `extend` and `project` to modify the schema of the incoming data to match the target table. In the following example, a new column called `TimeGenerated` is added to outgoing data using a KQL function to return the current time.

```kusto
source | extend TimeGenerated = now()
```

**Parse data**

Use the `split` or `parse` operator to parse data into multiple columns in the destination table. In the following example, the incoming data has a comma-delimited column named `RawData` that's split into individual columns for the destination table.

```kusto
source | project d = split(RawData,",") | project TimeGenerated=todatetime(d[0]), Code=toint(d[1]), Severity=tostring(d[2]), Module=tostring(d[3]), Message=tostring(d[4])
```

**Combine functions**

A transformation can include multiple functions to filter, modify, and format the incoming data. The following sample query does the following:

- Filters the incoming data with a [`where`](/azure/data-explorer/kusto/query/whereoperator) statement. This assumes that the incoming data has a column named `severity`.
- Adds a new column using the [`extend`](/azure/data-explorer/kusto/query/extendoperator) and `parse_json` operators. This assumes that the incoming data has a column named `properties` that contains a JSON object.
- Formats the output to match the columns of the target table using the [`project`](/azure/data-explorer/kusto/query/projectoperator) operator. This assumes that the incoming data has columns named `time`. `category`, `StatusDescription`, `name`, and a dynamic column named `Properties`. It also assumes that the target table has columns named `Category`, `StatusDescription`, `EventName`,  `EventId`. (All tables have a column named `TimeGenerated`.)

```kusto
source  
| where severity == "Critical" 
| extend Properties = parse_json(properties)
| project
    TimeGenerated = todatetime(["time"]),
    Category = category,
    StatusDescription = StatusDescription,
    EventName = name,
    EventId = tostring(Properties.EventId)
```



## Filter data
Filtering data is one of the most common requirements in a DCR since it allows you to reduce the amount of data sent to a destination and reduce your data ingestion costs.

### Filter at the data source

### Remove records

### Remove columns

## Obfuscate data

## Parse data
A common use of transformations is to parse incoming data into multiple columns to match the schema of the destination table. For example, you may collect entries from a log file that isn't in a structured format and need to parse the data into columns for the table. 


## Send data to multiple tables

With transformations, you can send data to multiple destinations in a Log Analytics workspace by using a single DCR. You provide a KQL query for each destination, and the results of each query are sent to their corresponding location. You can send different sets of data to different tables or use multiple queries to send different sets of data to the same table. To use multiple destinations, you must currently either manually create a new DCR or [edit an existing one](data-collection-rule-edit.md). 

For example, you might send event data into Azure Monitor by using the Logs Ingestion API. Most of the events should be sent an analytics table where it could be queried regularly, while audit events should be sent to a custom table configured for [basic logs](../logs/logs-table-plans.md) to reduce your cost.

> [!IMPORTANT]
> Currently, the tables in the DCR must be in the same Log Analytics workspace. To send to multiple workspaces from a single data source, use multiple DCRs and configure your application to send the data to each.

:::image type="content" source="media/data-collection-transformations/transformation-multiple-destinations.png" lightbox="media/data-collection-transformations/transformation-multiple-destinations.png" alt-text="Diagram that shows transformation sending data to multiple tables." border="false":::




> [!NOTE]
> These samples provide the source JSON of a DCR if you're using an ARM template or REST API to create or modify a DCR. After creation, the DCR will have additional properties as described in [Structure of a data collection rule in Azure Monitor](data-collection-rule-structure.md).

## Azure Monitor agent - events and performance data
The sample [data collection rule](../essentials/data-collection-rule-overview.md) below is for virtual machines with [Azure Monitor agent](../agents/azure-monitor-agent-data-collection.md) and has the following details:

- Performance data
  - Collects specific Processor, Memory, Logical Disk, and Physical Disk counters every 15 seconds and uploads every minute.
  - Collects specific Process counters every 30 seconds and uploads every 5 minutes.
- Windows events
  - Collects Windows security events and uploads every minute.
  - Collects Windows application and system events and uploads every 5 minutes.
- Syslog
  - Collects Debug, Critical, and Emergency events from cron facility.
  - Collects Alert, Critical, and Emergency events from syslog facility.
- Destinations
  - Sends all data to a Log Analytics workspace named centralWorkspace.

> [!NOTE]
> For an explanation of XPaths that are used to specify event collection in data collection rules, see [Limit data collection with custom XPath queries](../agents/data-collection-windows-events.md#filter-events-using-xpath-queries).


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
        "windowsEventLogs": [
          {
            "name": "cloudSecurityTeamEvents",
            "streams": [
              "Microsoft-Event"
            ],
            "scheduledTransferPeriod": "PT1M",
            "xPathQueries": [
              "Security!*"
            ]
          },
          {
            "name": "appTeam1AppEvents",
            "streams": [
              "Microsoft-Event"
            ],
            "scheduledTransferPeriod": "PT5M",
            "xPathQueries": [
              "System!*[System[(Level = 1 or Level = 2 or Level = 3)]]",
              "Application!*[System[(Level = 1 or Level = 2 or Level = 3)]]"
            ]
          }
        ],
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
              "Critical",
              "Emergency"
            ]
          },
          {
            "name": "syslogBase",
            "streams": [
              "Microsoft-Syslog"
            ],
            "facilityNames": [
              "syslog"
            ],
            "logLevels": [
              "Alert",
              "Critical",
              "Emergency"
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
            "Microsoft-Perf",
            "Microsoft-Syslog",
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

## Azure Monitor agent - text logs
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
                        "C:\\JavaLogs\\*.log"
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

## Event Hubs
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
The sample [data collection rule](../essentials/data-collection-rule-overview.md) below is used with the [Logs ingestion API](../logs/logs-ingestion-api-overview.md). It has the following details:

- Sends data to a table called MyTable_CL in a workspace called my-workspace.
- Applies a [transformation](../essentials//data-collection-transformations.md) to the incoming data.

> [!NOTE]
> Logs ingestion API requires the [logsIngestion](../essentials/data-collection-rule-structure.md#properties) property which includes the URL of the endpoint. This property is added to the DCR after it's created.

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
The sample [data collection rule](../essentials/data-collection-rule-overview.md) below is used as a 
[workspace transformation DCR](../essentials/data-collection-transformations-workspace.md) to transform all data sent to a table called *LAQueryLogs*.

```json
{
    "location": "eastus",
    "properties": {
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
                "transformKql": "source |where QueryText !contains 'LAQueryLogs' | extend Context = parse_json(RequestContext) | extend Resources_CF = tostring(Context['workspaces']) |extend RequestContext = ''"
            }
        ]
    }
}
```

## Send data to single destination

The following example is a DCR for Azure Monitor Agent that sends data to the `Syslog` table. In this example, the transformation filters the data for records with `error` in the message.

```json
{ 
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "resources" : [
        {
            "type": "Microsoft.Insights/dataCollectionRules", 
            "name": "singleDestinationDCR", 
            "apiVersion": "2021-09-01-preview", 
            "location": "eastus", 
            "properties": { 
              "dataSources": { 
                "syslog": [ 
                  { 
                    "name": "sysLogsDataSource", 
                    "streams": [ 
                      "Microsoft-Syslog" 
                    ], 
                    "facilityNames": [ 
                      "auth",
                      "authpriv",
                      "cron",
                      "daemon",
                      "mark",
                      "kern",
                      "mail",
                      "news",
                      "syslog",
                      "user",
                      "uucp"
                    ], 
                    "logLevels": [ 
                      "Debug", 
                      "Critical", 
                      "Emergency" 
                    ] 
                  } 
                ] 
              }, 
              "destinations": { 
                "logAnalytics": [ 
                  { 
                    "workspaceResourceId": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace", 
                    "name": "centralWorkspace" 
                  } 
                ] 
              }, 
              "dataFlows": [ 
                { 
                  "streams": [ 
                    "Microsoft-Syslog" 
                  ], 
                  "transformKql": "source | where message has 'error'", 
                  "destinations": [ 
                    "centralWorkspace" 
                  ] 
                } 
              ] 
            }
        }
    ]
} 
```

## Send data to multiple destinations

The following example is a DCR for data from the Logs Ingestion API that sends data to both the `Syslog` and `SecurityEvent` tables. This DCR requires a separate `dataFlow` for each with a different `transformKql` and `OutputStream` for each. In this example, all incoming data is sent to the `Syslog` table while malicious data is also sent to the `SecurityEvent` table. If you didn't want to replicate the malicious data in both tables, you could add a `where` statement to first query to remove those records.

```json
{ 
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "resources" : [
        { 
            "type": "Microsoft.Insights/dataCollectionRules", 
            "name": "multiDestinationDCR", 
            "location": "eastus", 
            "apiVersion": "2021-09-01-preview", 
            "properties": { 
                "dataCollectionEndpointId": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/my-resource-group/providers//Microsoft.Insights/dataCollectionEndpoints/my-dce",
                "streamDeclarations": { 
                    "Custom-MyTableRawData": { 
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
                            "workspaceResourceId": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace", 
                            "name": "clv2ws1" 
                        }, 
                    ] 
                }, 
                "dataFlows": [ 
                    { 
                        "streams": [ 
                            "Custom-MyTableRawData" 
                        ], 
                        "destinations": [ 
                            "clv2ws1" 
                        ], 
                        "transformKql": "source | project TimeGenerated = Time, Computer, Message = AdditionalContext", 
                        "outputStream": "Microsoft-Syslog" 
                    }, 
                    { 
                        "streams": [ 
                            "Custom-MyTableRawData" 
                        ], 
                        "destinations": [ 
                            "clv2ws1" 
                        ], 
                        "transformKql": "source | where (AdditionalContext has 'malicious traffic!' | project TimeGenerated = Time, Computer, Subject = AdditionalContext", 
                        "outputStream": "Microsoft-SecurityEvent" 
                    } 
                ] 
            } 
        }
    ]
}
```

## Combination of Azure and custom tables

The following example is a DCR for data from the Logs Ingestion API that sends data to both the `Syslog` table and a custom table with the data in a different format. This DCR requires a separate `dataFlow` for each with a different `transformKql` and `OutputStream` for each. When using custom tables, it is important to ensure that the schema of the destination (your custom table) contains the custom columns ([how-to add or delete custom columns](../logs/create-custom-table.md#add-or-delete-a-custom-column)) that match the schema of the records you are sending. For instance, if your record has a field called SyslogMessage, but the destination custom table only has TimeGenerated and RawData, you’ll receive an event in the custom table with only the TimeGenerated field populated and the RawData field will be empty. The SyslogMessage field will be dropped because the schema of the destination table doesn’t contain a string field called SyslogMessage.

```json
{ 
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "resources" : [
        { 
            "type": "Microsoft.Insights/dataCollectionRules", 
            "name": "multiDestinationDCR", 
            "location": "eastus", 
            "apiVersion": "2021-09-01-preview", 
            "properties": { 
                "dataCollectionEndpointId": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/my-resource-group/providers//Microsoft.Insights/dataCollectionEndpoints/my-dce",
                "streamDeclarations": { 
                    "Custom-MyTableRawData": { 
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
                            "workspaceResourceId": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace", 
                            "name": "clv2ws1" 
                        }, 
                    ] 
                }, 
                "dataFlows": [ 
                    { 
                        "streams": [ 
                            "Custom-MyTableRawData" 
                        ], 
                        "destinations": [ 
                            "clv2ws1" 
                        ], 
                        "transformKql": "source | project TimeGenerated = Time, Computer, SyslogMessage = AdditionalContext", 
                        "outputStream": "Microsoft-Syslog" 
                    }, 
                    { 
                        "streams": [ 
                            "Custom-MyTableRawData" 
                        ], 
                        "destinations": [ 
                            "clv2ws1" 
                        ], 
                        "transformKql": "source | extend jsonContext = parse_json(AdditionalContext) | project TimeGenerated = Time, Computer, AdditionalContext = jsonContext, ExtendedColumn=tostring(jsonContext.CounterName)", 
                        "outputStream": "Custom-MyTable_CL" 
                    } 
                ] 
            } 
        }
    ]
}
```



## Next steps

- [Get details for the different properties in a DCR](../essentials/data-collection-rule-structure.md)
- [See different methods for creating a DCR](../essentials/data-collection-rule-create-edit.md)

