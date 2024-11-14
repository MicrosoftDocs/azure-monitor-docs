---
title: Collect performance counters with Azure Monitor Agent
description: Describes how to collect performance counters from virtual machines, Virtual Machine Scale Sets, and Arc-enabled on-premises servers using Azure Monitor Agent.
ms.topic: conceptual
ms.date: 07/12/2024
author: guywild
ms.author: guywild
ms.reviewer: jeffwo

---

# Collect performance counters with Azure Monitor Agent

**Performance counters** is one of the data sources used in a [data collection rule (DCR)](../essentials/data-collection-rule-create-edit.md). Details for the creation of the DCR are provided in [Collect data with Azure Monitor Agent](./azure-monitor-agent-data-collection.md). This article provides more details for the Windows events data source type.

Performance counters provide insight into the performance of hardware components, operating systems, and applications. [Azure Monitor Agent](azure-monitor-agent-overview.md) can collect performance counters from Windows and Linux machines at frequent intervals for near real time analysis.

## Prerequisites

* If you're going to send performance data to a [Log Analytics workspace](../logs/log-analytics-workspace-overview.md), then you must have one created where you have at least [contributor rights](../logs/manage-access.md#azure-rbac).
* Either a new or existing DCR described in [Collect data with Azure Monitor Agent](./azure-monitor-agent-data-collection.md).

## Configure performance counters data source

Create a data collection rule, as described in [Collect data with Azure Monitor Agent](./azure-monitor-agent-data-collection.md). In the **Collect and deliver** step, select **Performance Counters** from the **Data source type** dropdown. 

For performance counters, select from a predefined set of objects and their sampling rate. 
    
:::image type="content" source="media/data-collection-performance/data-source-performance.png" lightbox="media/data-collection-performance/data-source-performance.png" alt-text="Screenshot that shows the Azure portal form to select basic performance counters in a data collection rule." border="false":::

Select **Custom** to specify an [XPath](https://www.w3schools.com/xml/xpath_syntax.asp) to collect any performance counters not available by default. Use the format `\PerfObject(ParentInstance/ObjectInstance#InstanceIndex)\Counter`. If the counter name contains an ampersand (&), replace it with `&amp;`. For example, `\Memory\Free &amp; Zero Page List Bytes`. You can view the default counters for examples.

:::image type="content" source="media/data-collection-performance/data-source-performance-custom.png" lightbox="media/data-collection-performance/data-source-performance-custom.png" alt-text="Screenshot that shows the Azure portal form to select custom performance counters in a data collection rule." border="false":::

> [!WARNING]
> Take care when manually defining counters for DCRs that are associated with both Windows and Linux machines, as certain Windows- and Linux-style counter names can resolve to the same metric and cause duplicative collection. For instance, specifying both `\LogicalDisk(*)\Disk Transfers/sec` and `Logical Disk(*)\Disk Transfers/sec` in the same DCR will cause the Disk Transfers metric to be reported twice per sampling period. This behavior can be avoided by not collecting performance counters in untyped DCRs; ensure Windows-style counters are only specified in Windows-type DCRs and associated solely with Windows machines, and vice-versa for Linux-style counters.

> [!NOTE] 
> At this time, Microsoft.HybridCompute ([Azure Arc-enabled servers](/azure/azure-arc/servers/overview)) resources can't be viewed in [Metrics Explorer](../essentials/metrics-getting-started.md) (the Azure portal UX), but they can be acquired via the Metrics REST API (Metric Namespaces - List, Metric Definitions - List, and Metrics - List).

## Destinations

Performance counters data can be sent to the following locations.

| Destination             | Table / Namespace                                                    |
|:------------------------|:---------------------------------------------------------------------|
| Log Analytics workspace | Perf (see [Azure Monitor Logs reference](/azure/azure-monitor/reference/tables/perf#columns)) |
| Azure Monitor Metrics   | Windows: Virtual Machine Guest<br>Linux: azure.vm.linux.guestmetrics |
    
> [!NOTE]
> On Linux, using Azure Monitor Metrics as the only destination is supported in v1.10.9.0 or higher.

:::image type="content" source="media/data-collection-performance/destination-metrics.png" lightbox="media/data-collection-performance/destination-metrics.png" alt-text="Screenshot that shows configuration of an Azure Monitor Logs destination in a data collection rule.":::

## Log queries with performance records

The following queries are examples to retrieve performance records.

#### All performance data from a particular computer

```query
Perf
| where Computer == "MyComputer"
```

#### Average CPU utilization across all computers

```query
Perf 
| where ObjectName == "Processor" and CounterName == "% Processor Time" and InstanceName == "_Total"
| summarize AVGCPU = avg(CounterValue) by Computer
```

#### Hourly average, minimum, maximum, and 75-percentile CPU usage for a specific computer

```query
Perf
| where CounterName == "% Processor Time" and InstanceName == "_Total" and Computer == "MyComputer"
| summarize ["min(CounterValue)"] = min(CounterValue), ["avg(CounterValue)"] = avg(CounterValue), ["percentile75(CounterValue)"] = percentile(CounterValue, 75), ["max(CounterValue)"] = max(CounterValue) by bin(TimeGenerated, 1h), Computer
```

> [!NOTE]
> Additional query examples are available at [Queries for the Perf table](/azure/azure-monitor/reference/queries/perf).

## Next steps

* [Collect text logs by using Azure Monitor Agent](data-collection-text-log.md).
* Learn more about [Azure Monitor Agent](azure-monitor-agent-overview.md).
* Learn more about [data collection rules](../essentials/data-collection-rule-overview.md).
