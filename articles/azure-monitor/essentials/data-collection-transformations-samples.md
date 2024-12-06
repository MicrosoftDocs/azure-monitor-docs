---
title: Best practices and samples for transformations in Azure Monitor
description: Best practices and recommendations for using transformations in Azure Monitor to ensure that they're reliable and cost effective.
ms.topic: conceptual
author: bwren
ms.author: bwren
ms.date: 12/04/2024
ms.reviwer: nikeist
---

# Best practices and samples for transformations in Azure Monitor
[Transformations in Azure Monitor](./data-collection-transformations.md) allow you to filter or modify incoming data before it's sent to a Log Analytics workspace. This article provides best practices and recommendations for using transformations to ensure that they're reliable and cost effective. It also includes sample queries for common scenarios that you can use to get started creating your own transformations.

## Optimize and monitor transformations
Transformations run a KQL query against every record collected with the DCR, so it's important that they run efficiently. Transformations that take excessive time to run can impact the performance of the data collection pipeline and result in data loss. See [Optimize log queries in Azure Monitor](../logs/query-optimization.md) for guidance on testing your query before you implement it as a transformation and for recommendations on optimizing queries that don't run efficiently. 

Because transformations don't run interactively, it's important to continuously monitor them to ensure that they're running properly and not taking excessive time to process data. See [Monitor and troubleshoot DCR data collection in Azure Monitor](data-collection-monitor.md) for details on logs and metrics that monitor the health and performance of transformations. This includes identifying any errors that occur in the KQL and metrics to track their running duration.

The following metrics are automatically collected for transformations and should be reviewed regularly to verify that your transformations are still running as expected. Create [metric alert rules](../alerts/alerts-create-metric-alert-rule.yml) to be automatically notified when one of these metrics exceeds a threshold.

- Logs Transformation Duration per Min
- Logs Transformation Errors per Min

[Enable DCR error logs](./data-collection-monitor.md#enable-dcr-error-logs) to track any errors that occur in your transformations or other queries. Create a [log alert rule](../alerts/alerts-create-log-alert-rule.md) to be automatically notified when an entry is written to this table.


## Parse data
A common use of transformations is to parse incoming data into multiple columns to match the schema of the destination table. For example, you may collect entries from a log file that isn't in a structured format and need to parse the data into columns for the table. 

## Reduce data costs
Because you're charged ingestion cost for any data sent to a Log Analytics workspace, you want to filter out any data that you don't require to reduce your costs.

**Filter rows of data**
Use a `where` statement to filter incoming data that matches particular requirements. If the incoming record doesn't match the statement, then the record is not sent to the destination. In the following example, only records with a severity of "Critical" are collected.

```kusto
source | where severity == "Critical" 
```

**Filter columns of data**
Remove columns from the data source that aren't required to save on data ingestion costs. Use a `project` statement to specify the columns in your output, or use `project-away` to specify only columns to remove. In the following example, the `RawData` column is removed from the output.

```kusto
source | project-away RawData
```

**Parse important data from a column**
You may have a column with important data buried in excessive text. Keep only the valuable data and remove the text that isn't needed. Use [string functions](./data-collection-transformations-kql.md#scalar-functions) such as `substring` and `extract` to parse the data you want. You can also parse the data using `parse` or `split` to break a single column in to multiple values and select the one you want. Then use `extend` to create a new column with the parsed data and `project-away` to remove the original column.

In the following example, the `RequestContext` column contains JSON with the workspace ResourceId. The `parse_json` and `spli` functions are used to extract the simple name of the workspace. A new column is created for this value and the other columns are removed.

```kusto
source
| extend Context = parse_json(RequestContext)
| extend Workspace_CF = tostring(Context['workspaces'][0])
| extend WorkspaceName_CF = split(Workspace_CF,"/")[8]
| project-away RequestContext, Context, Workspace_CF
```

**Send rows to basic logs**
Send rows in your data that require basic query capabilities to basic logs tables for a lower ingestion cost. See [Send data to multiple tables](./data-collection-rule-samples.md#send-data-to-multiple-tables) below for details on how to send data to multiple tables.


## Remove sensitive data
You might have a data source that sends information you don't want stored for privacy or compliancy reasons.

**Filter sensitive information**
Use the same strategies described in [Reduce data costs](#reduce-data-costs) to filter out entire rows or particular columns that contain sensitive information. In the following example, the `ClientIP` column is removed from the output.

```kusto
source | project-away ClientIP
```

**Obfuscate sensitive information**
Use [string functions](./data-collection-transformations-kql.md#scalar-functions) to replace information such as digits in an IP address or telephone number with a common character. The following example replaces the username in an email address with "*****".

```kusto
source | extend Email = replace_string(Email,substring(Email,0,indexof(Email,"@")),"*****")
```

**Send to an alternate table**
Send sensitive records to an alternate table with different role-based access control configuration. See [Send data to multiple tables](./data-collection-rule-samples.md#send-data-to-multiple-tables) below for details on how to send data to multiple tables.

## Enrich data
Use a transformation to add information to data that provides business context or simplifies querying the data later.

**Add a column with more information** 
Use [string functions](./data-collection-transformations-kql.md#scalar-functions) to extract critical information from a column and then use the `extend` statement to add a new column to the data source. The following example adds a column identifying whether an IP address in another column is internal or external.

```kusto
source | extend IpLocation = iff(split(ClientIp,".")[0] in ("10","192"), "Internal", "External")
```

## Format data for destination
You might have a data source that sends data in a format that doesn't match the structure of the destination table. Use a transformation to reformat the data to the required schema.

**Modify schema**

Use commands such as `extend` and `project` to modify the schema of the incoming data to match the target table. In the following example, a new column called `TimeGenerated` is added to outgoing data using a KQL function to return the current time.

```kusto
source | extend TimeGenerated = now()
```

**Parse data**

Use the `split` or `parse` operator to parse data into multiple columns in the destination table. In the following example, the incoming data has a comma-delimited column named `RawData` that's split into individual columns for the destination table.

```kusto
source 
| project d = split(RawData,",") 
| project TimeGenerated=todatetime(d[0]), Code=toint(d[1]), Severity=tostring(d[2]), Module=tostring(d[3]), Message=tostring(d[4])
```






## Next steps

- [Read more about data collection rules (DCRs)](./data-collection-rule-overview.md).
- [Create a workspace transformation DCRs that applies to data not collected using a DCR](./data-collection-transformations.md#workspace-transformation-dcr).

