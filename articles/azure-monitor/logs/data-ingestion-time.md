---
title: Log data ingestion time in Azure Monitor | Microsoft Docs
description: This article explains the different factors that affect latency in collecting log data in Azure Monitor.
ms.topic: concept-article
ms.reviewer: ivkhrul
ms.date: 02/27/2026

---

# Log data ingestion time in Azure Monitor

Azure Monitor is a high-scale data service that sends terabytes of data each month and continues to grow. Under normal service operations, the time it takes for log data to become available after collection is predictable and consistent. This article explains the factors that affect this latency.

## Average latency

Latency refers to the time between when data is created on the monitored system and when it becomes available for analysis in Azure Monitor. The average latency to ingest log data is *less than 10 seconds*. The specific latency for any particular data varies depending on several factors that are explained in this article.

## Factors affecting latency

The total ingestion time for a particular set of data is the cumulative time from the client to the Azure Monitor service.

:::image type="content" source="../data-collection/media/data-collection-rule-overview/azure-monitor-pipeline-simple.png" lightbox="../data-collection/media/data-collection-rule-overview/azure-monitor-pipeline-simple.png" alt-text="Architecture diagram showing the Azure Monitor ingestion process.":::

* **Client time**: The time to discover an event, collect it, and then send it to a [data collection endpoint](../data-collection/data-collection-endpoint-overview.md) as a log record. In most cases, an agent like the Azure Monitor Agent (AMA) handles this process. Custom applications that use the Logs ingestion API aren't part of this article's calculations, but they might have their own latency characteristics that are similar to the AMA client time.
* **Azure Monitor time**: After the client hands off to Azure Monitor, the time for ingestion to process the log record. This time period includes parsing the properties of the event and potentially adding calculated information. 

The following sections describe the different latency introduced in this process.

### Agent collection latency

**Latency: Time varies**

Agents use different strategies to collect data, which might affect the latency. Some specific examples are listed in the following table.

| Type of data  | Collection frequency  | Notes |
|:--------------|:----------------------|:------|
| Windows events, Syslog events, and performance metrics | Collected immediately| |
| Linux performance counters | Polled at 30-second intervals| |
| IIS logs and text logs | Collected after their timestamp changes | For IIS logs, this schedule is influenced by the [rollover schedule configured on IIS](../agents/data-sources-iis-logs.md). |

For more information about agent performance, see [Azure Monitor Agent performance](../agents/azure-monitor-agent-performance.md).

### Agent upload frequency

**Latency: Under 1 minute**

To keep the Azure Monitor Agent lightweight, it buffers logs and periodically uploads them to Azure Monitor. Upload frequency varies between 30 seconds and 2 minutes depending on the type of data. Most data is uploaded in under 1 minute.

### Network

**Latency: Varies**

The network between a client and the Azure Monitor data collection endpoint might add unexpected delays. When you measure the ingestion latency, this network latency is included as part of the `AgentLatency` calculation in the sample queries in the [measure ingestion latency](#measure-ingestion-latency) section.

### Azure metrics, resource logs, activity logs

**Latency: 30 seconds to 20 minutes**

Azure data adds more time to become available at a data collection endpoint for processing:

* **Azure platform metrics** are available in under a minute in the metrics database, but they take another three minutes to be exported to the data collection endpoint.
* **Resource logs** are usually available within 3 to 10 minutes end-to-end, depending on the complexity of the service and the Azure services involved. For example, Azure SQL Database and Azure Virtual Network currently provide their logs every five minutes. To examine this latency in your environment, see the [query that follows](#check-ingestion-time).
* **Activity logs** are available for analysis and alerting in 3 to 20 minutes.

### Azure Monitor process time

**Latency: Less than 10 seconds**

After the data reaches the data collection endpoint, it takes less than 10 seconds before you can query it.

When Azure Monitor ingests log records (as the [_TimeReceived](log-standard-columns.md#_timereceived) property shows), it writes them to temporary storage. This step ensures tenant isolation and prevents data loss. This step usually adds 5 to 15 seconds.

Some solutions use more complex algorithms to aggregate data and derive insights while data streams in. For example, Application Insights calculates application map data. Azure Network Performance Monitoring aggregates incoming data over three-minute intervals, which effectively adds three minutes of latency in this case.

If the data collection includes an [ingestion-time transformation](../data-collection/data-collection-transformations.md), this transformation adds some latency to the Azure Monitor process time. Use the metric [Logs Transformation Duration per Min](../data-collection/data-collection-monitor.md) to monitor the efficiency of the transformation query.

Another process that adds latency is the process that handles custom logs. In some cases, this process might add a few minutes of latency to logs that an agent collects from files.

### New custom data types provisioning

When a new type of custom data is created from a [custom log](../agents/data-sources-custom-logs.md) or the [Logs ingestion API](logs-ingestion-api-overview.md), the system creates a dedicated storage container. This one-time overhead occurs only on the first appearance of this data type.

## Check ingestion time

Ingestion time might vary for different resources under different circumstances. Use log queries to identify specific behavior of your environment. The following table specifies how you determine the different times for a record as it's created and sent to Azure Monitor. For more information about log queries, see [Overview of Log Analytics](log-analytics-overview.md).

> [!WARNING]
> When ingesting logs into the Auxiliary tier of Azure Monitor, avoid submitting a single payload that contains TimeGenerated timestamps that span more than 30 minutes in one API call. This API call might lead to the following ingestion error code `RecordsTimeRangeIsMoreThan30Minutes`. This is a [known limitation](../fundamentals/service-limits.md#logs-ingestion-api) that's getting removed.
>
> This restriction doesn't apply to Auxiliary logs that use [transformations](../data-collection/data-collection-transformations.md).

| Step | Property or function | Comments |
|:-----|:---------------------|:---------|
| Record created at data source | [TimeGenerated](log-standard-columns.md#timegenerated) | The TimeGenerated value can't be more than two days before the received time or more than a day in the future. Otherwise, Azure Monitor Logs replaces the TimeGenerated value with the actual received time.<br>If the data source doesn't set this value, Azure Monitor Logs sets the value to the same time as _TimeReceived. |
| Record received by the data collection endpoint | [_TimeReceived](log-standard-columns.md#_timereceived) | Don't use this field to filter large datasets. It's not optimized for mass processing. |
| Record stored in workspace and available for queries | [ingestion_time()](/azure/kusto/query/ingestiontimefunction) | Use `ingestion_time()` if you need to filter only records that were ingested in a certain time window. In such cases, also add a `TimeGenerated` filter with a larger range. |

### Measure ingestion latency

Measure the latency of a specific record when you compare the result of the [ingestion_time()](/azure/kusto/query/ingestiontimefunction) function to the `TimeGenerated` property. Discover how ingestion latency behaves when you use various aggregations of this data. Examine some percentile of the ingestion time to get insights for large amounts of data.

For example, the following query shows which computers had the highest ingestion time over the prior eight hours:

``` Kusto
Heartbeat
| where TimeGenerated > ago(8h)
| extend E2EIngestionLatency = ingestion_time() - TimeGenerated
| extend AgentLatency = _TimeReceived - TimeGenerated
| summarize percentiles(E2EIngestionLatency,50,95), percentiles(AgentLatency,50,95) by Computer
| top 20 by percentile_E2EIngestionLatency_95 desc
```

The preceding percentile checks are good for finding general trends in latency. To identify a short-term spike in latency, using the maximum (`max()`) might be more effective.

If you want to drill down on the ingestion time for a specific computer over a period of time, use the following query, which also visualizes the data from the past day in a graph:

``` Kusto
Heartbeat
| where TimeGenerated > ago(24h) //and Computer == "ContosoWeb2-Linux"
| extend E2EIngestionLatencyMin = todouble(datetime_diff("Second",ingestion_time(),TimeGenerated))/60
| extend AgentLatencyMin = todouble(datetime_diff("Second",_TimeReceived,TimeGenerated))/60
| summarize percentiles(E2EIngestionLatencyMin,50,95), percentiles(AgentLatencyMin,50,95) by bin(TimeGenerated,30m)
| render timechart
```

Use the following query to show computer ingestion time by the country/region where they're located, which is based on their IP address:

``` Kusto
Heartbeat
| where TimeGenerated > ago(8h)
| extend E2EIngestionLatency = ingestion_time() - TimeGenerated
| extend AgentLatency = _TimeReceived - TimeGenerated
| summarize percentiles(E2EIngestionLatency,50,95),percentiles(AgentLatency,50,95) by RemoteIPCountry
```

Different data types originating from the agent might have different ingestion latency time, so the previous queries could be used with other types. Use the following query to examine the ingestion time of various Azure services:

``` Kusto
AzureDiagnostics
| where TimeGenerated > ago(8h)
| extend E2EIngestionLatency = ingestion_time() - TimeGenerated
| extend AgentLatency = _TimeReceived - TimeGenerated
| summarize percentiles(E2EIngestionLatency,50,95), percentiles(AgentLatency,50,95) by ResourceProvider
```

Use the same query logic to diagnose latency conditions for Application Insights log-based metrics:

```kusto
// Workspace-based Application Insights schema
// This query can be paired with any other Application Insights table other than "requests"
let start=datetime("2026-01-21 05:00:00");
let end=datetime("2026-01-23 05:00:00");
AppRequests
| where TimeGenerated > start and TimeGenerated < end
| extend TimeEventOccurred = TimeGenerated
| extend TimeRequiredtoGettoAzure = _TimeReceived - TimeGenerated
| extend TimeRequiredtoIngest = ingestion_time() - _TimeReceived
| extend EndtoEndTime = ingestion_time() - TimeGenerated
| project TimeGenerated, TimeEventOccurred, _TimeReceived, TimeRequiredtoGettoAzure , ingestion_time(), TimeRequiredtoIngest, EndtoEndTime
| sort by EndtoEndTime desc
```

### Resources that stop responding

In some cases, a resource stops sending data. To understand if a resource is sending data, check its most recent record, which the standard `TimeGenerated` field identifies.

Use the `Heartbeat` table to check the availability of a VM because the agent sends a heartbeat once a minute. Use the following query to list the active computers that didn't report a heartbeat recently:

``` Kusto
Heartbeat
| where TimeGenerated > ago(1d) //show only VMs that were active in the last day 
| summarize NoHeartbeatPeriod = now() - max(TimeGenerated) by Computer
| top 20 by NoHeartbeatPeriod desc 
```

## Next steps

Read the [service-level agreement](https://www.microsoft.com/licensing/docs/view/Service-Level-Agreements-SLA-for-Online-Services) for Azure Monitor.

