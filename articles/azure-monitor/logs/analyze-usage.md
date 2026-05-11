---
title: Analyze usage in a Log Analytics workspace in Azure Monitor
description: Methods and queries to analyze the data in your Log Analytics workspace to help you understand usage and potential cause for high usage.
ms.topic: how-to
ms.reviewer: Dale.Koetke
ms.date: 05/08/2026
ai-usage: ai-assisted
---

# Analyze usage in a Log Analytics workspace

Azure Monitor costs can vary significantly based on the volume of data collected in your Log Analytics workspace. The set of solutions that use the workspace and the amount of data each solution collects affect this volume.

This article provides guidance on analyzing your collected data to help you control your data ingestion costs. It helps you:

* Determine the cause of higher-than-expected usage.
* Predict your costs as you monitor more resources and configure different Azure Monitor features.

:::image source="media/analyze-usage/log-analytics-example.png" lightbox="media/analyze-usage/log-analytics-example.png" alt-text="Screenshot that shows the output for an example query in Log Analytics.":::

[!INCLUDE [azure-monitor-cost-optimization](../fundamentals/includes/azure-monitor-cost-optimization.md)]

## Causes for higher-than-expected usage

Each Log Analytics workspace is charged as a separate service and contributes to the bill for your Azure subscription. The amount of data ingestion can be considerable, depending on the:

* Set of insights and services (for example, [Application Insights](../app/app-insights-overview.md), [Container Insights](../containers/kubernetes-monitoring-overview.md), [VM Insights](../vm/tutorial-monitor-vm-enable-insights.md)) enabled and their configuration.
* Number and type of monitored resources.
* Volume of data collected from each monitored resource.

An unexpected increase in any of these factors can result in increased charges for data retention. The rest of this article provides methods for detecting such a situation and then analyzing collected data to identify and mitigate the source of the increased usage.

## Send alert when data collection is high

To avoid unexpected bills, set up proactive notifications for excessive usage. By receiving notifications, you're setup to address any potential anomalies before the end of your billing period.

The following example is a [log search alert rule](../alerts/alerts-types.md#log-alerts) that sends an alert if the billable data volume ingested in the last 24 hours is greater than 50 GB. Modify the **Alert Logic** setting to use a different threshold based on expected usage in your environment. You can also increase the frequency to check usage multiple times every day, but this option results in a higher charge for the alert rule.

| Setting         | Value                                                                                                     |
|:----------------|:----------------------------------------------------------------------------------------------------------|
| **Scope**       |                                                                                                           |
| Target scope    | Select your Log Analytics workspace.                                                                      |
| **Condition**   |                                                                                                           |
| Query           | `Usage \| where IsBillable \| summarize DataGB = sum(Quantity / 1000)`                                    |
| Measurement     | Measure: *DataGB*<br>Aggregation type: Total<br>Aggregation granularity: 1 day                            |
| Alert Logic     | Operator: Greater than<br>Threshold value: 50<br>Frequency of evaluation: 1 day                           |
| Actions         | Select or add an [action group](../alerts/action-groups.md) to notify you when the threshold is exceeded. |
| **Details**     |                                                                                                           |
| Severity        | Warning                                                                                                   |
| Alert rule name | Billable data volume greater than 50 GB in 24 hours.                                                      |

## Analyze usage with built-in tools

Start your analysis with existing tools in Azure Monitor. These tools require no configuration and can often provide the information you need with minimal effort. If you need deeper analysis into your collected data than existing Azure Monitor features, use any of the following [log queries](log-query-overview.md) in [Log Analytics](log-analytics-overview.md).

### Log Analytics Workspace Insights

[Log Analytics Workspace Insights](log-analytics-workspace-insights-overview.md#usage-tab) gives you a quick understanding of the data in your workspace. For example, these are some of the insights you might uncover:

* Data tables that ingest the most data volume in the main table.
* Top resources that contribute data.
* Trend of data ingestion.

The **Usage** tab provides a breakdown of ingestion by solution and table. This information helps you quickly identify the tables that contribute to the bulk of your data volume. The tab also shows trending of data collection over time. See if data collection steadily increased over time or suddenly increased in response to a configuration change.

Select **Additional Queries** for prebuilt queries that help you better understand your data patterns.

### Usage and estimated costs

The **Data ingestion per solution** chart on the [Usage and estimated costs](../cost-usage.md#usage-and-estimated-costs) page for each workspace shows the total volume of data sent and how much each solution sends over the previous 31 days. This information helps you determine trends, such as whether any increase comes from overall data usage or usage by a particular solution.

## Query billable data volume from the Usage table

Analyze the amount of billable data collected by a particular service or solution. These queries use the [Usage](/azure/azure-monitor/reference/tables/usage) table that collects usage data for each table in the workspace.

> [!NOTE]
> The clause with `TimeGenerated` is only to ensure that the query experience in the Azure portal looks back beyond the default 24 hours. When you use the **Usage** data type, `StartTime` and `EndTime` represent the time buckets for which results are presented.

### Billable data volume by type over the past month

```kusto
Usage 
| where TimeGenerated > ago(32d)
| where StartTime >= startofday(ago(31d)) and EndTime < startofday(now())
| where IsBillable == true
| summarize BillableDataGB = sum(Quantity) / 1000. by bin(StartTime, 1d), DataType 
| render columnchart
```

### Billable data volume by solution and type over the past month

```kusto
Usage 
| where TimeGenerated > ago(32d)
| where StartTime >= startofday(ago(31d)) and EndTime < startofday(now())
| where IsBillable == true
| summarize BillableDataGB = sum(Quantity) / 1000 by Solution, DataType
| sort by Solution asc, DataType asc
```

For more example queries, see [Queries for the Usage table](../reference/queries/usage.md).

## Query billable data volume from event records

Use [log queries](log-query-overview.md) in [Log Analytics](log-analytics-overview.md) if you need deeper analysis into your collected data. Each table in a Log Analytics workspace has the following standard columns that can help you analyze billable data:

* [_IsBillable](log-standard-columns.md#_isbillable) identifies records that incur an ingestion charge. Use this column to filter out non-billable data.
* [_BilledSize](log-standard-columns.md#_billedsize) provides the size in bytes of the record.

### Billable data volume for specific events

If you find that a particular data type is collecting excessive data, you might want to analyze the data in that table to determine particular records that are increasing. This example filters specific event IDs in the  `Event` table and then provides a count for each ID. You can modify this query by using the columns from other tables.

```kusto
Event
| where TimeGenerated > startofday(ago(31d)) and TimeGenerated < startofday(now()) 
| where EventID == 5145 or EventID == 5156
| where _IsBillable == true
| summarize count(), Bytes=sum(_BilledSize) by EventID, bin(TimeGenerated, 1d)
```

For more example queries, see [Queries for the Event table](../reference/queries/event.md).

### Data volume by Azure resource, resource group, or subscription

You can analyze the amount of billable data collected from a particular resource or set of resources. These queries use the [_ResourceId](./log-standard-columns.md#_resourceid) and [_SubscriptionId](./log-standard-columns.md#_subscriptionid) columns for data from resources hosted in Azure.

> [!WARNING]
> Use [find](/azure/data-explorer/kusto/query/findoperator?pivots=azuremonitor) queries sparingly because scans across data types are [resource intensive](./query-optimization.md#query-details-pane) to execute. If you don't need results per subscription, resource group, or resource name, use the [Usage](/azure/azure-monitor/reference/tables/usage) table queries in [Query billable data volume from the Usage table](#query-billable-data-volume-from-the-usage-table).

#### Billable data volume by resource ID for the last full day

```kusto
find where TimeGenerated between(startofday(ago(1d))..startofday(now())) project _ResourceId, _BilledSize, _IsBillable
| where _IsBillable == true 
| summarize BillableDataBytes = sum(_BilledSize) by _ResourceId 
| sort by BillableDataBytes nulls last
```

#### Billable data volume by resource group for the last full day

```kusto
find where TimeGenerated between(startofday(ago(1d))..startofday(now())) project _ResourceId, _BilledSize, _IsBillable
| where _IsBillable == true 
| summarize BillableDataBytes = sum(_BilledSize) by _ResourceId
| extend resourceGroup = tostring(split(_ResourceId, "/")[4] )
| summarize BillableDataBytes = sum(BillableDataBytes) by resourceGroup 
| sort by BillableDataBytes nulls last
```

It might be helpful to parse `_ResourceId`:

```Kusto
| parse tolower(_ResourceId) with "/subscriptions/" subscriptionId "/resourcegroups/" 
    resourceGroup "/providers/" provider "/" resourceType "/" resourceName   
```

#### Billable data volume by subscription for the last full day

```kusto
find where TimeGenerated between(startofday(ago(1d))..startofday(now())) project _BilledSize, _IsBillable, _SubscriptionId
| where _IsBillable == true 
| summarize BillableDataBytes = sum(_BilledSize) by _SubscriptionId 
| sort by BillableDataBytes nulls last
```

> [!TIP]
> For workspaces with large data volumes, doing queries such as the ones shown in this section, which query large volumes of raw data, might need to be restricted to a single day. To track trends over time, consider setting up a [Power BI report](./log-powerbi.md) and using [incremental refresh](./log-powerbi.md#collect-data-with-power-bi-dataflows) to collect data volumes per resource once a day.

### Data volume by computer

You can analyze the amount of billable data collected from a virtual machine or a set of virtual machines. The **Usage** table doesn't have the granularity to show data volumes for specific virtual machines, so these queries use the [find operator](/azure/data-explorer/kusto/query/findoperator) to search all tables that include a computer name. The **Usage** type is omitted because this query is only for analytics of data trends.

> [!WARNING]
> Use [find](/azure/data-explorer/kusto/query/findoperator?pivots=azuremonitor) queries sparingly because scans across data types are [resource intensive](./query-optimization.md#query-details-pane) to execute. If you don't need results per subscription, resource group, or resource name, use the [Usage](/azure/azure-monitor/reference/tables/usage) table queries in [Query billable data volume from the Usage table](#query-billable-data-volume-from-the-usage-table).

#### Billable data volume by computer for the last full day

```kusto
find where TimeGenerated between(startofday(ago(1d))..startofday(now())) project _BilledSize, _IsBillable, Computer, Type
| where _IsBillable == true and Type != "Usage"
| extend computerName = tolower(tostring(split(Computer, '.')[0]))
| summarize BillableDataBytes = sum(_BilledSize) by  computerName 
| sort by BillableDataBytes desc nulls last
```

#### Count of billable events by computer for the last full day

```kusto
find where TimeGenerated between(startofday(ago(1d))..startofday(now())) project _IsBillable, Computer, Type
| where _IsBillable == true and Type != "Usage"
| extend computerName = tolower(tostring(split(Computer, '.')[0]))
| summarize eventCount = count() by computerName  
| sort by eventCount desc nulls last
```

## Query data volume for common data types

If you find that you have excessive billable data for a particular data type, you might need to perform a query to analyze data in that table. The following queries provide samples for some common data types:

### Security solution

```kusto
SecurityEvent 
| summarize AggregatedValue = count() by EventID
| order by AggregatedValue desc nulls last
```

See [Queries for the SecurityEvent table](../reference/queries/securityevent.md) for more example queries.

### Log Management solution

```kusto
Usage 
| where Solution == "LogManagement" and iff(isnotnull(toint(IsBillable)), IsBillable == true, IsBillable == "true") == true 
| summarize AggregatedValue = count() by DataType
| order by AggregatedValue desc nulls last
```

For more example queries, see [Queries for the Usage table](../reference/queries/usage.md).

### Perf data type

```kusto
Perf 
| summarize AggregatedValue = count() by CounterPath
```

```kusto
Perf 
| summarize AggregatedValue = count() by CounterName
```

See [Queries for the Perf table](../reference/queries/securityevent.md) for more example queries.

### Event data type

```kusto
Event 
| summarize AggregatedValue = count() by EventID
```

```kusto
Event 
| summarize AggregatedValue = count() by EventLog, EventLevelName
```

For more example queries, see [Queries for the Event table](../reference/queries/event.md).

### Syslog data type

```kusto
Syslog 
| summarize AggregatedValue = count() by Facility, SeverityLevel
```

```kusto
Syslog 
| summarize AggregatedValue = count() by ProcessName
```

See [Queries for the Syslog table](../reference/queries/syslog.md) for more example queries.

### AzureDiagnostics data type

```kusto
AzureDiagnostics 
| summarize AggregatedValue = count() by ResourceProvider, ResourceId
```

See [Queries for the AzureDiagnostics table](../reference/queries/azurediagnostics.md) for more example queries.

## Query Application Insights data volume

The following queries apply to Application Insights resources, including classic resources that store data outside a Log Analytics workspace. Use the `_BilledSize` property that's available on each ingested event for both workspace-based and classic resources. For classic resources, you can also use aggregated information in the [systemEvents](/azure/azure-monitor/reference/tables/appsystemevents) table.

> [!NOTE]
> Queries against Application Insights tables, except `SystemEvents`, work for both a workspace-based and classic Application Insights resource. [Backward compatibility](/previous-versions/azure/azure-monitor/app/convert-classic-resource) allows you to continue to use [legacy table names](../app/apm-tables.md). For a workspace-based resource, open **Logs** on the **Log Analytics workspace** menu. For a classic resource, open **Logs** on the **Application Insights** menu.

**Dependency operations generate the most data volume in the last 30 days (workspace-based or classic)**

```kusto
dependencies
| where timestamp >= startofday(ago(30d))
| summarize sum(_BilledSize) by operation_Name
| render barchart  
```

**Daily data volume by type for this Application Insights resource for the last 7 days (classic only)**

```kusto
systemEvents
| where timestamp >= startofday(ago(7d)) and timestamp < startofday(now())
| where type == "Billing"
| extend BillingTelemetryType = tostring(dimensions["BillingTelemetryType"])
| extend BillingTelemetrySizeInBytes = todouble(measurements["BillingTelemetrySize"])
| summarize sum(BillingTelemetrySizeInBytes) by BillingTelemetryType, bin(timestamp, 1d)  
```

### Data volume trends for workspace-based resources

To look at the data volume trends for [workspace-based Application Insights resources](../app/create-workspace-resource.md), use a query that includes all the Application Insights tables. The following queries use the [table names specific to workspace-based resources](../app/apm-tables.md#table-schemas).

**Daily data volume by type for all Application Insights resources in a workspace for 7 days**

```kusto
union AppAvailabilityResults,
      AppBrowserTimings,
      AppDependencies,
      AppExceptions,
      AppEvents,
      AppMetrics,
      AppPageViews,
      AppPerformanceCounters,
      AppRequests,
      AppSystemEvents,
      AppTraces
| where TimeGenerated >= startofday(ago(7d)) and TimeGenerated < startofday(now())
| summarize sum(_BilledSize) by _ResourceId, bin(TimeGenerated, 1d)
```

To look at the data volume trends for only a single Application Insights resource, add the following line before `summarize` in the preceding query:

```kusto
| where _ResourceId contains "<myAppInsightsResourceName>"
```

> [!TIP]
> For workspaces with large data volumes, restrict queries such as the preceding one, which query large volumes of raw data, to a single day. To track trends over time, consider setting up a [Power BI report](./log-powerbi.md) and using [incremental refresh](./log-powerbi.md#collect-data-with-power-bi-dataflows) to collect data volumes per resource once a day.

## Understand nodes sending data

If you don't see excessive data from any particular source, you might have an excessive number of agents that send data.

### Count of agent nodes sending a heartbeat each day in the last month

```kusto
Heartbeat 
| where TimeGenerated > startofday(ago(31d))
| summarize nodes = dcount(Computer) by bin(TimeGenerated, 1d)    
| render timechart
```

For more example queries, see [Queries for the Heartbeat table](../reference/queries/heartbeat.md).

> [!WARNING]
> Use [find](/azure/data-explorer/kusto/query/findoperator?pivots=azuremonitor) queries sparingly because scans across data types are [resource intensive](./query-optimization.md#query-details-pane) to execute. If you don't need results per subscription, resource group, or resource name, use the [Usage](/azure/azure-monitor/reference/tables/usage) table queries in [Query billable data volume from the Usage table](#query-billable-data-volume-from-the-usage-table).

### Count of nodes sending any data in the last 24 hours

```kusto
find where TimeGenerated > ago(24h) project Computer
| extend computerName = tolower(tostring(split(Computer, '.')[0]))
| where computerName != ""
| summarize nodes = dcount(computerName)
```

### Data volume sent by each node in the last 24 hours

```kusto
find where TimeGenerated > ago(24h) project _BilledSize, Computer
| extend computerName = tolower(tostring(split(Computer, '.')[0]))
| where computerName != ""
| summarize TotalVolumeBytes=sum(_BilledSize) by computerName
```

## Nodes billed by the legacy Per Node pricing tier

The [legacy Per Node pricing tier](cost-logs.md#legacy-pricing-tiers) bills nodes with hourly granularity. It also doesn't count nodes that only send a set of security data types. To get a list of computers that are billed as nodes if the workspace is in the legacy Per Node pricing tier, look for nodes that send billed data types because some data types are free. In this case, use the leftmost field of the fully qualified domain name.

The following queries return the count of computers with billed data per hour. The number of units on your bill is in units of node months, which the query represents as `billableNodeMonthsPerDay`. If the workspace has the Update Management solution installed, add the **Update** and **UpdateSummary** data types to the list in the `where` clause.

```kusto
find where TimeGenerated >= startofday(ago(7d)) and TimeGenerated < startofday(now()) project Computer, _IsBillable, Type, TimeGenerated
| where Type !in ("SecurityAlert", "SecurityBaseline", "SecurityBaselineSummary", "SecurityDetection", "SecurityEvent", "WindowsFirewall", "MaliciousIPCommunication", "LinuxAuditLog", "SysmonEvent", "ProtectionStatus", "WindowsEvent")
| extend computerName = tolower(tostring(split(Computer, '.')[0]))
| where computerName != ""
| where _IsBillable == true
| summarize billableNodesPerHour=dcount(computerName) by bin(TimeGenerated, 1h)
| summarize billableNodesPerDay = sum(billableNodesPerHour)/24., billableNodeMonthsPerDay = sum(billableNodesPerHour)/24./31.  by day=bin(TimeGenerated, 1d)
| sort by day asc
```

> [!NOTE]
> Some complexity in the actual billing algorithm when solution targeting is used isn't represented in the preceding query.

## Diagnose late-arriving data

If you see high data ingestion reported by using `Usage` records, but you don't see the same results when you sum `_BilledSize` directly on the data type, late-arriving data might be the cause. This situation occurs when data is ingested with old timestamps.

For example, an agent might have a connectivity issue and send accumulated data when it reconnects. Or a host might have an incorrect time. Either example can result in an apparent discrepancy between the ingested data reported by the [Usage](/azure/azure-monitor/reference/tables/usage) data type and a query summing [_BilledSize](./log-standard-columns.md#_billedsize) over the raw data for a particular day specified by **TimeGenerated**, the timestamp when the event was generated.

To diagnose late-arriving data problems, use the [_TimeReceived](./log-standard-columns.md#_timereceived) column and the [TimeGenerated](./log-standard-columns.md#timegenerated) column. The `_TimeReceived` property is the time when Azure Monitor receives the record.

The following example responds to high ingested data volumes of [W3CIISLog](/azure/azure-monitor/reference/tables/w3ciislog) data on May 2, 2021, to identify the timestamps on this ingested data. The `where TimeGenerated > datetime(1970-01-01)` statement is included to provide the clue to the Log Analytics user interface to look over all data.

```Kusto
W3CIISLog
| where TimeGenerated > datetime(1970-01-01)
| where _TimeReceived >= datetime(2021-05-02) and _TimeReceived < datetime(2021-05-03) 
| where _IsBillable == true
| summarize BillableDataMB = sum(_BilledSize)/1.E6 by bin(TimeGenerated, 1d)
| sort by TimeGenerated asc 
```

## Next steps

* For information about how charges are calculated for data in a Log Analytics workspace and different configuration options to reduce your charges, see [Azure Monitor Logs pricing details](cost-logs.md).
* For a description of the different types of Azure Monitor charges and how to analyze them on your Azure bill, see [Azure Monitor cost and usage](../cost-usage.md).
* For best practices on configuring and managing Azure Monitor to minimize your charges, see [Azure Monitor best practices - Cost management](../best-practices-cost.md).
* For information about using transformations to reduce the amount of data you collect in a Log Analytics workspace by filtering unwanted records and columns, see [Data collection transformations in Azure Monitor (preview)](../essentials/data-collection-transformations.md).
