---
title: Structure of a data collection rule (DCR) in Azure Monitor
description: Details on the structure of different kinds of data collection rule in Azure Monitor.
ms.topic: reference
ms.date: 05/15/2026
ms.reviwer: msundaram
ai-usage: ai-assisted
---

# Structure of a data collection rule (DCR) in Azure Monitor

This article describes the JSON structure of DCRs for those cases where you need to work directly with their definition. 

* See [Create and edit data collection rules (DCRs) in Azure Monitor](data-collection-rule-create-edit.md) for details working with the JSON described here.
* See [Sample data collection rules (DCRs) in Azure Monitor](data-collection-rule-samples.md) for sample DCRs for different scenarios.

## Properties

The following table describes properties at the top level of the DCR.

| Property | Description |
|:---------|:------------|
| `description` | Optional description of the data collection rule defined by the user. |
| `dataCollectionEndpointId` | Resource ID of the [data collection endpoint (DCE)](data-collection-endpoint-overview.md) used by the DCR if you provided one when the DCR was created. This property isn't present in DCRs that don't use a DCE. |
| `endpoints`<sup>1</sup> | Contains the `logsIngestion` and `metricsIngestion` URL of the endpoints for the DCR. This section and its properties are automatically created when the DCR is created only if the `kind` attribute in the DCR is `Direct`. |
| `immutableId` | A unique identifier for the data collection rule. This property and its value are automatically created when the DCR is created. |
| `kind` | Specifies the data collection scenario the DCR is used for. This parameter is further described below. |

<sup>1</sup> This property wasn't created for DCRs created before March 31, 2024. DCRs created before this date required a [data collection endpoint (DCE)](data-collection-endpoint-overview.md) and the `dataCollectionEndpointId` property to be specified. If you want to use these embedded DCEs then you must create a new DCR. 

## Kind

The `kind` property in the DCR specifies the type of collection that the DCR is used for. Each kind of DCR has a different structure and properties. 

The following table lists the different kinds of DCRs and their details.

| Kind | Description |
|:-----|:------------|
| `Direct` | Direct ingestion using Logs ingestion API. Endpoints are created for the DCR only if this kind value is used. |
| `AgentSettings` | Configure Azure Monitor agent parameters. |
| `Linux` | Collect events and performance data from Linux machines. |
| `PlatformTelemetry` | Export platform metrics. |
| `Windows` | Collect events and performance data from Windows machines. |
| `WorkspaceTransforms` | Workspace transformation DCR. This DCR doesn't include an input stream. |

## Overview of DCR data flow

The basic flow of a DCR is shown in the following diagram. Each of the components is described in the following sections.

:::image type="content" source="media/data-collection-rule-structure/dcr-flow-diagram.png" lightbox="media/data-collection-rule-structure/dcr-flow-diagram.png" alt-text="Diagram that illustrates the relationship between the different sections of a DCR." border="false":::

## Input streams

The input stream section of a DCR defines the incoming data that's being collected. There are two types of incoming stream, depending on the particular data collection scenario. Most data collection scenarios use one of the input streams, while some may use both.

> [!NOTE]
> [Workspace transformation DCRs](data-collection-transformations.md#workspace-transformation-dcr) don't have an input stream.

| Input stream | Description |
|:-------------|:------------|
| `dataSources` | Known type of data. This is often data processed by Azure Monitor agent and delivered to Azure Monitor using a known data type. |
| `streamDeclarations` | Custom data that needs to be defined in the DCR. |

Data sent from the Logs ingestion API uses a `streamDeclaration` with the schema of the incoming data. This is because the API sends custom data that can have any schema.

Text logs from AMA are an example of data collection that requires both `dataSources` and `streamDeclarations`. The data source includes the configuration 

### Data sources

Data sources are unique sources of monitoring data that each has its own format and method of exposing its data. Each data source type has a unique set of parameters that must be configured for each data source. The data returned by the data source is typically a known type, so the schema doesn't need to be defined in the DCR.

For example, events and performance data collected from a VM with the Azure Monitor agent (AMA), use data sources such as `windowsEventLogs` and `performanceCounters`. You specify criteria for the events and performance counters that you want to collect, but you don't need to define the structure of the data itself since this is a known schema for potential incoming data.

#### Common parameters

All data source types share the following common parameters.

| Parameter | Description |
|:----------|:------------|
| `name` | Name to identify the data source in the DCR. |
| `streams` | List of streams that the data source will collect. If this is a standard data type such as a Windows event, then the stream will be in the form `Microsoft-<TableName>`. If it's a custom type, then it will be in the form `Custom-<TableName>` |
| `transform` | (Preview) Name of a transformation from the [`transformations`](#transformations) section to apply client-side. Use this property for multi-stage transformations. See [Multi-stage transformations](data-collection-transformations.md#multi-stage-transformations-preview). |

#### Valid data source types

The data source types currently available are listed in the following table.

| Data source type | Description | Streams | Parameters |
|:-----------------|:------------|:--------|:-----------|
| `eventHub` | Data from Azure Event Hubs. | Custom<sup>1</sup> | `consumerGroup` - Consumer group of event hub to collect from. |
| `iisLogs` | IIS logs from Windows machines | `Microsoft-W3CIISLog` |`logDirectories` - Directory where IIS logs are stored on the client. |
| `logFiles` | Text or json log on a virtual machine | Custom<sup>1</sup> | `filePatterns` - Folder and file pattern for log files to be collected from client.<br>`format` - *json* or *text* |
| `performanceCounters` | Performance counters for both Windows and Linux virtual machines | `Microsoft-Perf`<br>`Microsoft-InsightsMetrics` | `samplingFrequencyInSeconds` - Frequency that performance data should be sampled.<br>`counterSpecifiers` - Objects and counters that should be collected. |
| `prometheusForwarder` | Prometheus data collected from Kubernetes cluster. | `Microsoft-PrometheusMetrics` | `streams` - Streams to collect<br>`labelIncludeFilter` - List of label inclusion filters as name-value pairs. Currently only 'microsoft_metrics_include_label' supported. |
| `syslog` | Syslog events on Linux virtual machines<br><br>Events in Common Event Format on security appliances | `Microsoft-Syslog`<br><br>`Microsoft-CommonSecurityLog` for CEF | `facilityNames` - Facilities to collect<br>`logLevels` - Log levels to collect |
| `windowsEventLogs` | Windows event log on virtual machines | `Microsoft-Event` | `xPathQueries` - XPaths specifying the criteria for the events that should be collected. |
| `extension` | Extension-based data source used by Azure Monitor agent. | Varies by extension | `extensionName` - Name of the extension<br>`extensionSettings` - Values for each setting required by the extension |

<sup>1</sup> These data sources use both a data source and a stream declaration since the schema of the data they collect can vary. The stream used in the data source should be the custom stream defined in the stream declaration.

### Stream declarations

Declaration of the different types of data sent into the Log Analytics workspace. Each stream is an object whose key represents the stream name, which must begin with *Custom-*. The stream contains a full list of top-level properties that are contained in the JSON data that will be sent. The shape of the data you send to the endpoint doesn't need to match that of the destination table. Instead, the output of the transform that's applied on top of the input data needs to match the destination shape.

#### Data types

The possible data types that can be assigned to the properties are:

* `string`
* `int`
* `long`
* `real`
* `boolean`
* `dynamic`
* `datetime`

## Destinations

The `destinations` section includes an entry for each destination where the data will be sent. These destinations are matched with input streams in the `dataFlows` section.

### Common parameters

| Parameters | Description |
|:-----------|:------------|
| `name` | Name to identify the destination in the `dataSources` section. |

### Valid destinations

The destinations currently available are listed in the following table.

| Destination | Description | Required parameters |
|:------------|:------------|:--------------------|
| `azureDataExplorer` | Azure Data Explorer | `resourceId` - Resource ID of the ADX cluster<br>`databaseName` - Name of the database in the ADX cluster<br>`ingestionUri` - Ingestion URI of the cluster |
| `azureMonitorMetrics` | Azure Monitor metrics | No configuration is required since there's only a single metrics store for the subscription. |
| `logAnalytics` | Log Analytics workspace | `workspaceResourceId` - Resource ID of the workspace.<br>`workspaceID` - ID of the workspace<br><br>This only specifies the workspace, not the table where the data will be sent. If it's a known destination, then no table needs to be specified. For custom tables, the table is specified in the data source. |
| `microsoftFabric` | Microsoft Fabric eventhouse | `tenantId` - Tenant ID of the Fabric workspace<br>`databaseName` - Name of the database in the Fabric eventhouse<br>`ingestionUri` - [Ingestion URI of the Fabric eventhouse database](/fabric/real-time-intelligence/manage-monitor-database#database-details) |

> [!IMPORTANT]
> One stream can only send to one Log Analytics workspace in a DCR. You can have multiple `dataFlow` entries for a single stream if they're using different tables in the same workspace. If you need to send data to multiple Log Analytics workspaces from a single stream, create a separate DCR for each workspace.

## Data flows

Data flows match input streams with destinations. Each data source may optionally specify a transformation and in some cases will specify a specific table in the Log Analytics workspace. 

### Data flow properties

| Section | Description |
|:--------|:------------|
| `streams` | One or more streams defined in the input streams section. You may include multiple streams in a single data flow if you want to send multiple data sources to the same destination. Only use a single stream though if the data flow includes a transformation. One stream can also be used by multiple data flows when you want to send a particular data source to multiple tables in the same Log Analytics workspace. |
| `destinations` | One or more destinations from the `destinations` section above. Multiple destinations are allowed for multi-homing scenarios. |
| `transform` | (Preview) Name of a transformation from the [`transformations`](#transformations) section to apply at ingestion time. Mutually exclusive with `transformKql`. See [Multi-stage transformations](data-collection-transformations.md#multi-stage-transformations-preview). |
| `transformKql` | Optional [transformation](data-collection-transformations.md) applied to the incoming stream. The transformation must understand the schema of the incoming data and output data in the schema of the target table. If you use a transformation, the data flow should only use a single stream. Mutually exclusive with `transform`. |
| `outputStream` | Describes which table in the workspace specified under the `destination` property the data will be sent to. The value of `outputStream` has the format `Microsoft-[tableName]` when data is being ingested into a standard table, or `Custom-[tableName]` when ingesting data into a custom table. Only one destination is allowed per stream.<br><br>This property isn't used for known data sources from Azure Monitor such as events and performance data since these are sent to predefined tables. |

## Transformations

> [!IMPORTANT]
> Multi-stage transformations are currently in public preview. This section requires API version `2025-05-11` or later. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

The `transformations` section defines reusable named transformations referenced by `dataSources` and `dataFlows`. Each transformation defines a pipeline of [processors](data-collection-transformations.md#processors) that are applied sequentially to the data. See [Multi-stage transformations](data-collection-transformations.md#multi-stage-transformations-preview) for conceptual details.

```json
"transformations": [
    {
        "name": "my_transform",
        "headerProcessor": {
            "processor": "header.Syslog",
            "configuration": { }
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
                        }
                    ]
                }
            }
        ]
    }
]
```

### Transformation object properties

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `name` | string | Yes | Unique name for this transformation. Referenced by `dataSources[].transform` and `dataFlows[].transform`. |
| `headerProcessor` | object | Yes | Header processor that establishes the starting schema. Must be the first element. See [Header processors](#header-processors). |
| `processors` | array | No | Ordered sequence of transformation processors applied after the header. See [Processor types](#processor-types). |

### Processor object

Each processor is a declarative building block that describes a specific data transformation operation.

```json
{
    "processor": "family.Name",
    "configuration": { }
}
```

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `processor` | string | Yes | Processor name in the format `Family.Name`. Case-sensitive. |
| `configuration` | object | Yes | Processor-specific configuration. See individual processor sections. |

### Header processors

Header processors receive raw data and convert it into a known schematized tabular format. A header processor must be the first processor in any transformation.

#### Client-side headers

These header processors are used for client-side transformations assigned to data sources.

| Processor | Data source | Configuration |
|:----------|:------------|:--------------|
| `header.Syslog` | Syslog | None |
| `header.WindowsEvents` | Windows event logs | None |
| `header.WindowsPerformanceCounters` | Windows performance counters | None |
| `header.LinuxPerformanceCounters` | Linux performance counters | None |
| `header.TextLog` | Custom text log files | None |
| `header.IISLog` | IIS logs | None |
| `header.WindowsFirewallLog` | Windows Firewall logs | None |

Each header processor outputs a fixed schema. For example, `header.Syslog` outputs columns including `TimeGenerated`, `Facility`, `SeverityNumber`, `Message`, `Host`, and others.

#### Ingestion-side headers

These header processors are used for ingestion-side transformations assigned to data flows.

**header.StandardStream** — Used when the input is a standard stream such as `Microsoft-Syslog` or `Microsoft-Event`.

```json
{
    "processor": "header.StandardStream",
    "configuration": {
        "streamId": "Microsoft-Syslog"
    }
}
```

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `streamId` | string | Yes | Identifier of the standard stream, such as `Microsoft-Syslog`. |

**header.CustomStream** — Used when the input is a custom stream defined in `streamDeclarations`.

```json
{
    "processor": "header.CustomStream",
    "configuration": {
        "streamId": "Custom-MyStream"
    }
}
```

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `streamId` | string | Yes | Identifier of the custom stream. Must match a stream defined in `streamDeclarations`. |

### Processor types

#### filter.Basic

Drops entire records based on condition evaluation. Conditions are structured as OR groups of AND groups.

```json
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
            }
        ]
    }
}
```

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `any` | array of AND groups | Yes | Top-level OR group. A record is kept if any AND group evaluates to true. |

Each AND group has an `all` property containing an array of condition objects:

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `columnName` | string | Yes | Column to evaluate. |
| `operator` | string | Yes | Comparison operator. String: `==`, `!=`, `contains`, `!contains`. Numeric: `==`, `!=`, `>`, `<`, `>=`, `<=`. |
| `value` | string, number, or boolean | Yes | Reference value to compare against. |

Output schema: Same as input. Records are dropped, not columns.

#### map.Rename

Renames a column and optionally changes its type.

```json
{
    "processor": "map.Rename",
    "configuration": {
        "all": [
            {
                "columnName": "OldName",
                "nameAs": "NewName",
                "typeAs": "string"
            }
        ]
    }
}
```

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `columnName` | string | Yes | Existing column to rename or typecast. |
| `nameAs` | string | No | New column name. If omitted, column keeps its name. |
| `typeAs` | string | No | Target type: `string`, `int`, `long`, `real`, `bool`, `datetime`. If casting fails, `null` is returned. |

#### map.Drop

Drops one or more columns from the data.

```json
{
    "processor": "map.Drop",
    "configuration": {
        "columnNames": ["Column1", "Column2"]
    }
}
```

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `columnNames` | array of string | Yes | Columns to drop. |

#### parse.JsonPath

Parses a JSON-formatted string in a column and extracts specified keys into new columns.

```json
{
    "processor": "parse.JsonPath",
    "configuration": {
        "columnName": "EventData",
        "all": [
            {
                "path": "$.user.name",
                "nameAs": "UserName",
                "typeAs": "string"
            }
        ]
    }
}
```

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `columnName` | string | Yes | Column containing the JSON string. |
| `all` | array of extraction objects | Yes | Keys to extract. |

Extraction object properties:

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `path` | string | Yes | JSON path to the key, such as `$.key` or `$.nested.key`. |
| `nameAs` | string | Yes | New output column name. |
| `typeAs` | string | No | Target type. If casting fails, `null` is returned. |

#### parse.XmlPath

Parses an XML-formatted string in a column and extracts specified elements into new columns.

```json
{
    "processor": "parse.XmlPath",
    "configuration": {
        "columnName": "RawXml",
        "all": [
            {
                "path": "/Event/System/EventID",
                "nameAs": "EventID",
                "typeAs": "int"
            }
        ]
    }
}
```

Configuration properties match `parse.JsonPath`, except `path` uses XPath syntax (for example, `/Event/System/EventID` or `/Event/EventData/Data[@Name='SubjectUserName']`).

> [!NOTE]
> Valid XPath syntax is governed by the parser library at each stage. Advanced XPath expressions might only be supported in specific execution locations.

#### parse.CEFAttribute

Parses CEF (Common Event Format) data in a column and extracts specified fields into new columns.

```json
{
    "processor": "parse.CEFAttribute",
    "configuration": {
        "columnName": "Message",
        "all": [
            {
                "path": "deviceAction",
                "nameAs": "Action",
                "typeAs": "string"
            }
        ]
    }
}
```

Configuration properties match `parse.JsonPath`, except `path` specifies the CEF key name.

#### aggregate.Basic

Summarizes records using aggregation operators with grouping dimensions.

```json
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
                "operator": "count",
                "nameAs": "RecordCount"
            }
        ],
        "dimensionColumns": ["Host", "CounterName"]
    }
}
```

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `batchingSettings.timeWindow` | string | Yes | Timespan per aggregation batch, such as `5m` or `1h`. |
| `batchingSettings.maxBatchRows` | int | Yes | Maximum rows per aggregation batch. |
| `aggregates` | array | Yes | Aggregation definitions. |
| `dimensionColumns` | array of string | Yes | Columns to group by. Only `string` type is supported. |

Aggregate entry properties:

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `columnName` | string | No | Column to aggregate. Not required for the `count` operator. |
| `operator` | string | Yes | Aggregation function: `sum`, `avg`, `min`, `max`, `count`. |
| `nameAs` | string | Yes | Output column name for the aggregated value. |

> [!IMPORTANT]
> Aggregation changes the output schema entirely. The output contains only the aggregate columns and dimension columns. Route aggregated data to a separate custom table.

#### enrich.DNSLookup

Looks up an IP address in a column and adds a DNS name column.

```json
{
    "processor": "enrich.DNSLookup",
    "configuration": {
        "columnName": "IPAddress",
        "nameAs": "DNSName"
    }
}
```

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `columnName` | string | Yes | Column containing the IP address to look up. |
| `nameAs` | string | Yes | New output column name for the resolved DNS name. |

> [!NOTE]
> DNS resolution is best-effort. If the lookup fails, the output column contains `null`.

#### transform.KQL

Applies an arbitrary KQL expression for advanced scenarios. This processor is ingestion-side only.

```json
{
    "processor": "transform.KQL",
    "configuration": {
        "expression": "source | where SeverityNumber >= 4 | extend EnrichedMsg = strcat(Host, ': ', Message)"
    }
}
```

| Property | Type | Required | Description |
|:---------|:-----|:---------|:------------|
| `expression` | string | Yes | KQL query string applied to the input data. |

> [!NOTE]
> Limited validation is performed on the KQL expression. The output schema is determined by the KQL expression and can't be statically validated. This processor provides a migration path for existing DCRs that use `transformKql` in data flows.

### Processor availability matrix

The following table shows which processors are available on the client side and the ingestion side.

| Processor | Family | Client-side | Ingestion-side |
|:----------|:-------|:------------|:---------------|
| `header.Syslog` | Header | Yes | No |
| `header.WindowsEvents` | Header | Yes | No |
| `header.WindowsPerformanceCounters` | Header | Yes | No |
| `header.LinuxPerformanceCounters` | Header | Yes | No |
| `header.TextLog` | Header | Yes | No |
| `header.IISLog` | Header | Yes | No |
| `header.WindowsFirewallLog` | Header | Yes | No |
| `header.StandardStream` | Header | No | Yes |
| `header.CustomStream` | Header | No | Yes |
| `filter.Basic` | Filter | Yes | Yes |
| `map.Rename` | Map | Yes | Yes |
| `map.Drop` | Map | Yes | Yes |
| `parse.JsonPath` | Parse | Yes | Yes |
| `parse.XmlPath` | Parse | Yes | Yes |
| `parse.CEFAttribute` | Parse | Yes | Yes |
| `aggregate.Basic` | Aggregate | Yes | Yes |
| `enrich.DNSLookup` | Enrich | Yes | Yes |
| `transform.KQL` | Transform | No | Yes |

## Related content

- [Overview of data collection rules and methods for creating them](data-collection-rule-overview.md)
- [Create and edit data collection rules (DCRs) in Azure Monitor](data-collection-rule-create-edit.md)
- [Multi-stage transformations in Azure Monitor](data-collection-transformations.md#multi-stage-transformations-preview)
- [Create a transformation in Azure Monitor](data-collection-transformations-create.md)
- [Collect data from VM clients](../vm/data-collection.md)
