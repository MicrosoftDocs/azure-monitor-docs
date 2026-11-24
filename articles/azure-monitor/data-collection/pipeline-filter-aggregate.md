---
title: Filter and aggregate data with Azure Monitor pipeline
description: Filter records and aggregate log data before Azure Monitor pipeline sends it to Azure Monitor.
ai-usage: ai-assisted
ms.topic: concept-article
ms.date: 11/23/2026
---

# Filter and aggregate data with Azure Monitor pipeline

Use pipeline KQL transformations to reduce log volume and summarize records before they leave your environment.

> [!IMPORTANT]
> Filtering and aggregation apply only to log data sources: Syslog, CEF, and OpenTelemetry logs. Pipeline KQL transformations don't apply to OpenTelemetry metrics or traces.

## Filter logs

Use `where` and the supported comparison and string operators to drop records that you don't want to send to Azure Monitor. For example:

```kusto
source
| where severity_number >= 9
```

The following example retains OTel log records with an INFO or higher severity number.

## Aggregate logs

Use `summarize` with supported aggregation functions such as `count()`, `sum()`, `min()`, `max()`, and `avg()`:

```kusto
source
| summarize EventCount=count() by DestinationIP, DestinationPort
```

Aggregation introduces batching latency. If an aggregation changes the output schema, send the result to a compatible custom table.

For the complete configuration model, examples, limitations, and supported KQL, see [Azure Monitor pipeline transformations](./pipeline-transformations.md).
