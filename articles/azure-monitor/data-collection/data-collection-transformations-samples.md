---
title: Sample transformations in Azure Monitor
description: Sample transformations for common scenarios in Azure Monitor.
ms.topic: how-to
ms.date: 05/15/2026
ms.reviwer: nikeist
ai-usage: ai-assisted
---

# Sample transformations in Azure Monitor

[Transformations in Azure Monitor](data-collection-transformations.md) allow you to filter or modify incoming data before it's sent to a Log Analytics workspace. This article provides  sample queries for common scenarios that you can use to get started creating your own transformations. See [Create a transformation in Azure Monitor](data-collection-transformations-create.md) for details on testing these transformations and adding them to a data collection rule (DCR).

## Reduce data costs

Because you're charged ingestion cost for any data sent to a Log Analytics workspace, you want to filter out any data that you don't require to reduce your costs.

### Filter rows of data

Use a `where` statement to filter incoming data that matches particular requirements. If the incoming record doesn't match the statement, then the record is not sent to the destination. In the following example, only records with a severity of `Critical` are collected.

```kusto
source | where severity == "Critical"
```

### Filter columns of data

Remove columns from the data source that aren't required to save on data ingestion costs. Use a `project` statement to specify the columns in your output, or use `project-away` to specify only columns to remove. In the following example, the `RawData` column is removed from the output.

```kusto
source | project-away RawData
```

## Parse important data from a column

You may have a column with important data buried in excessive text. Keep only the valuable data and remove the text that isn't needed. Use [string functions](data-collection-transformations-kql.md#scalar-functions) such as `substring` and `extract` to parse the data you want. You can also parse the data using `parse` or `split` to break a single column in to multiple values and select the one you want. Then use `extend` to create a new column with the parsed data and `project-away` to remove the original column.

> [!WARNING]
> See [Break up large parse commands](../logs/query-optimization.md#break-up-large-parse-commands) for tips on using complex parse commands.

In the following example, the `RequestContext` column contains JSON with the workspace ResourceId. The `parse_json` and `split` functions are used to extract the simple name of the workspace. A new column is created for this value and the other columns are removed.

```kusto
source
| extend Context = parse_json(RequestContext)
| extend Workspace_CF = tostring(Context['workspaces'][0])
| extend WorkspaceName_CF = split(Workspace_CF,"/")[8]
| project-away RequestContext, Context, Workspace_CF
```

## Send rows to basic logs

Send rows in your data that require basic query capabilities to basic logs tables for a lower ingestion cost. See [Send data to multiple tables](data-collection-rule-samples.md#send-data-to-multiple-tables) for details on how to send data to multiple tables.

## Remove sensitive data

You might have a data source that sends information you don't want stored for privacy or compliancy reasons.

### Filter sensitive information

Use the same strategies described in [Reduce data costs](#reduce-data-costs) to filter out entire rows or particular columns that contain sensitive information. In the following example, the `ClientIP` column is removed from the output.

```kusto
source | project-away ClientIP
```

### Obfuscate sensitive information

Use [string functions](data-collection-transformations-kql.md#scalar-functions) to replace information such as digits in an IP address or telephone number with a common character. The following example replaces the username in an email address with "*****".

```kusto
source | extend Email = replace_string(Email,substring(Email,0,indexof(Email,"@")),"*****")
```

### Send to an alternate table

Send sensitive records to an alternate table with different role-based access control configuration. See [Send data to multiple tables](data-collection-rule-samples.md#send-data-to-multiple-tables) for details on how to send data to multiple tables.

## Enrich data

Use a transformation to add information to data that provides business context or simplifies querying the data later. Use [string functions](data-collection-transformations-kql.md#scalar-functions) to extract critical information from a column and then use the `extend` statement to add a new column to the data source. The following example adds a column identifying whether an IP address in another column is internal or external.

```kusto
source | extend IpLocation = iff(split(ClientIp,".")[0] in ("10","192"), "Internal", "External")
```

## Normalize data

Normalize data to a common schema to simplify querying and reporting, such as the [Advanced Security Information Model (ASIM)](/azure/sentinel/normalization) used by Microsoft Sentinel. Use a transformation to normalize data at ingestion time as described in [Ingest time normalization](/azure/sentinel/normalization-ingest-time).

In the following example, the incoming data is transformed to the normalized schema of the [ASimAuditEventLogs](/azure/azure-monitor/reference/tables/asimauditeventlogs) table.

```kusto
source
| project TimeGenerated = timestamp, EventOwner=owner, EventMessage=message, EventResult=result, EventSeverity=severity
```

## Format data for destination

You might have a data source that sends data in a format that doesn't match the structure of the destination table. Use a transformation to reformat the data to the required schema.

### Modify schema

Use commands such as `extend` and `project` to modify the schema of the incoming data to match the target table. In the following example, a new column called `TimeGenerated` is added to outgoing data using a KQL function to return the current time.

```kusto
source | extend TimeGenerated = now()
```

### Parse data

Use the `split` or `parse` operator to parse data into multiple columns in the destination table. In the following example, the incoming data has a comma-delimited column named `RawData` that's split into individual columns for the destination table.

```kusto
source 
| project d = split(RawData,",") 
| project TimeGenerated=todatetime(d[0]), Code=toint(d[1]), Severity=tostring(d[2]), Module=tostring(d[3]), Message=tostring(d[4])
```

> [!WARNING]
> See [Break up large parse commands](../logs/query-optimization.md#break-up-large-parse-commands) for tips on using complex parse commands.

## Multi-stage transformation samples (preview)

> [!IMPORTANT]
> Multi-stage transformations are currently in public preview. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

The following samples demonstrate processor-based multi-stage transformations. Each sample shows the `transformations` section of a DCR definition. For the complete DCR structure and how to reference these transformations from data sources and data flows, see [Create a multi-stage transformation](data-collection-transformations-create.md#create-a-multi-stage-transformation-preview).

### Filter syslog by facility on the client

Filter syslog records on the client side to keep only `auth` and `authpriv` events before sending them over the network.

```json
{
    "name": "client_filter_auth",
    "headerProcessor": {
        "processor": "header.Syslog",
        "configuration": {}
    },
    "processors": [
        {
            "processor": "filter.Basic",
            "configuration": {
                "any": [
                    {
                        "all": [
                            {
                                "columnName": "Facility",
                                "operator": "==",
                                "value": "auth"
                            }
                        ]
                    },
                    {
                        "all": [
                            {
                                "columnName": "Facility",
                                "operator": "==",
                                "value": "authpriv"
                            }
                        ]
                    }
                ]
            }
        }
    ]
}
```

### Parse JSON fields from Windows Events

Extract structured fields from a JSON payload in the `EventData` column of Windows Events.

```json
{
    "name": "client_parse_windows_events",
    "headerProcessor": {
        "processor": "header.WindowsEvents",
        "configuration": {}
    },
    "processors": [
        {
            "processor": "parse.XmlPath",
            "configuration": {
                "columnName": "RawXml",
                "all": [
                    {
                        "path": "/Event/System/EventID",
                        "nameAs": "EventID",
                        "typeAs": "int"
                    },
                    {
                        "path": "/Event/EventData/Data[@Name='SubjectUserName']",
                        "nameAs": "SubjectUserName",
                        "typeAs": "string"
                    }
                ]
            }
        },
        {
            "processor": "map.Drop",
            "configuration": {
                "columnNames": ["RawXml", "RenderingInfo"]
            }
        }
    ]
}
```

### Aggregate performance counters

Aggregate performance counter data on the client side to reduce data volume by summarizing values over a 5-minute window.

```json
{
    "name": "client_aggregate_perf",
    "headerProcessor": {
        "processor": "header.WindowsPerformanceCounters",
        "configuration": {}
    },
    "processors": [
        {
            "processor": "aggregate.Basic",
            "configuration": {
                "batchingSettings": {
                    "timeWindow": "5m",
                    "maxBatchRows": 1000
                },
                "aggregates": [
                    {
                        "columnName": "CounterValue",
                        "operator": "avg",
                        "nameAs": "AvgValue"
                    },
                    {
                        "columnName": "CounterValue",
                        "operator": "max",
                        "nameAs": "MaxValue"
                    },
                    {
                        "operator": "count",
                        "nameAs": "SampleCount"
                    }
                ],
                "dimensionColumns": ["CounterName", "Instance"]
            }
        }
    ]
}
```

> [!IMPORTANT]
> Aggregation changes the output schema entirely. Route aggregated data to a separate custom table.

### Extract CEF attributes from syslog

Extract CEF (Common Event Format) attributes from syslog messages, often used for security device data.

```json
{
    "name": "client_parse_cef",
    "headerProcessor": {
        "processor": "header.Syslog",
        "configuration": {}
    },
    "processors": [
        {
            "processor": "parse.CEFAttribute",
            "configuration": {
                "columnName": "Message",
                "all": [
                    {
                        "path": "deviceAction",
                        "nameAs": "DeviceAction",
                        "typeAs": "string"
                    },
                    {
                        "path": "sourceAddress",
                        "nameAs": "SourceIP",
                        "typeAs": "string"
                    },
                    {
                        "path": "destinationAddress",
                        "nameAs": "DestinationIP",
                        "typeAs": "string"
                    }
                ]
            }
        },
        {
            "processor": "enrich.DNSLookup",
            "configuration": {
                "columnName": "SourceIP",
                "nameAs": "SourceDNSName"
            }
        }
    ]
}
```

### Ingestion-side KQL transformation

Apply a KQL expression to a standard stream at ingestion time. This provides a migration path from the legacy `transformKql` property.

```json
{
    "name": "ingestion_kql_syslog",
    "headerProcessor": {
        "processor": "header.StandardStream",
        "configuration": {
            "streamId": "Microsoft-Syslog"
        }
    },
    "processors": [
        {
            "processor": "transform.KQL",
            "configuration": {
                "expression": "source | where SeverityLevel != 'info' | extend EnrichedMsg = strcat(HostName, ': ', SyslogMessage)"
            }
        }
    ]
}
```

### Syslog to CommonSecurityLog two-stage approach

Transform syslog data and ingest it as CommonSecurityLog using a two-stage approach. The client-side transformation parses CEF attributes, and the ingestion-side transformation maps the data to the CommonSecurityLog table schema.

**Client-side transformation:**

```json
{
    "name": "client_cef_extract",
    "headerProcessor": {
        "processor": "header.Syslog",
        "configuration": {}
    },
    "processors": [
        {
            "processor": "parse.CEFAttribute",
            "configuration": {
                "columnName": "Message",
                "all": [
                    {
                        "path": "deviceAction",
                        "nameAs": "DeviceAction",
                        "typeAs": "string"
                    }
                ]
            }
        }
    ]
}
```

**Ingestion-side transformation:**

```json
{
    "name": "ingestion_map_to_csl",
    "headerProcessor": {
        "processor": "header.StandardStream",
        "configuration": {
            "streamId": "Microsoft-CommonSecurityLog"
        }
    },
    "processors": [
        {
            "processor": "transform.KQL",
            "configuration": {
                "expression": "source | extend DeviceAction = DeviceAction"
            }
        }
    ]
}
```

## Next steps

* [Read more about data collection rules (DCRs)](data-collection-rule-overview.md).
* [Multi-stage transformations in Azure Monitor](data-collection-transformations.md#multi-stage-transformations-preview).
* [Create a multi-stage transformation](data-collection-transformations-create.md#create-a-multi-stage-transformation-preview).
* [DCR structure - Transformations](data-collection-rule-structure.md#transformations) for the complete processor reference.
