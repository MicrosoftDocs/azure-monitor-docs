---
title: Best practices and samples for transformations in Azure Monitor
description: Best practices and recommendations for using transformations in Azure Monitor to ensure that they're reliable and cost effective.
ms.topic: conceptual
author: bwren
ms.author: bwren
ms.date: 10/02/2024
ms.reviwer: nikeist
---

# Best practices and samples for transformations in Azure Monitor
[Transformations in Azure Monitor](./data-collection-transformations.md) allow you to filter or modify incoming data before it's sent to a Log Analytics workspace. This article provides best practices and recommendations for using transformations to ensure that they're reliable and cost effective. It also includes samples for common scenarios that you can use to get started creating your own transformation.

## Optimize query
Transformations run a KQL query against every record collected with the DCR, so it's important that they run efficiently. Transformations that take excessive time to run can impact the performance of the data collection pipeline and result in data loss. See [Optimize log queries in Azure Monitor](../logs/query-optimization.md) for guidance on testing your query before you implement it as a transformation and for recommendations on optimizing queries that don't run efficiently. 

## Monitor transformations
Because transformations don't run interactively, it's important to continuously monitor them to ensure that they're running properly and not taking excessive time to process data. See [Monitor and troubleshoot DCR data collection in Azure Monitor](data-collection-monitor.md) for details on logs and metrics that monitor the health and performance of transformations. This includes identifying any errors that occur in the KQL and metrics to track their running duration.

The following metrics are automatically collected for transformations and should be reviewed regularly to verify that your transformations are still running as expected. Create [metric alert rules](../alerts/alerts-create-metric-alert-rule.yml) to be automatically notified when one of these metrics exceeds a threshold.

- Logs Transformation Duration per Min
- Logs Transformation Errors per Min

[Enable DCR error logs](./data-collection-monitor.md#enable-dcr-error-logs) to track any errors that occur in your transformations or other queries. Create a [log alert rule](../alerts/alerts-create-log-alert-rule.md) to be automatically notified when an entry is written to this table.


## Parse data
A common use of transformations is to parse incoming data into multiple columns to match the schema of the destination table. For example, you may collect entries from a log file that isn't in a structured format and need to parse the data into columns for the table. 
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

With transformations, you can send data to multiple destinations in a Log Analytics workspace by using a single DCR. You provide a KQL query for each destination, and the results of each query are sent to their corresponding location. You can send different sets of data to different tables or use multiple queries to send different sets of data to the same table. To use multiple destinations, you must currently either manually create a new DCR or [edit an existing one](data-collection-rule-edit.md). 

For example, you might send event data into Azure Monitor by using the Logs Ingestion API. Most of the events should be sent an analytics table where it could be queried regularly, while audit events should be sent to a custom table configured for [basic logs](../logs/logs-table-plans.md) to reduce your cost.

> [!IMPORTANT]
> Currently, the tables in the DCR must be in the same Log Analytics workspace. To send to multiple workspaces from a single data source, use multiple DCRs and configure your application to send the data to each.

:::image type="content" source="media/data-collection-transformations/transformation-multiple-destinations.png" lightbox="media/data-collection-transformations/transformation-multiple-destinations.png" alt-text="Diagram that shows transformation sending data to multiple tables." border="false":::

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

- [Read more about data collection rules (DCRs)](./data-collection-rule-overview.md).
- [Create a workspace transformation DCRs that applies to data not collected using a DCR](./data-collection-transformations-workspace.md).

