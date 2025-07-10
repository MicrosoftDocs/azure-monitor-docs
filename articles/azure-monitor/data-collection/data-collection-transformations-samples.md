---
title: Sample transformations in Azure Monitor
description: Sample transformations for common scenarios in Azure Monitor.
ms.topic: how-to
ms.date: 12/04/2024
ms.reviwer: nikeist
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

## Next steps

* [Read more about data collection rules (DCRs)](data-collection-rule-overview.md).
* [Create a workspace transformation DCRs that applies to data not collected using a DCR](data-collection-transformations.md#workspace-transformation-dcr).
