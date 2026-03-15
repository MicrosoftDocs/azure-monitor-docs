---
title: Metrics experience for VMs in Azure Monitor
description: Learn about OpenTelemetry System Metrics (Guest OS Performance Counters) in Azure Monitor and how they're modeled.
ms.topic: concept-article
ms.date: 09/27/2025
ms.reviewer: tylerkight
---

# Metrics experience for VMs in Azure Monitor
When you enable enhanced monitoring for Azure virtual machines or Arc-enabled servers in Azure Monitor, you choose between two experiences for collecting and visualizing performance data from the guest operating system: OpenTelemetry-based metrics (preview) and log-based metrics (classic). This article describes the differences between these experiences and provides guidance on which to select.

> [!NOTE]
> OpenTelemetry metrics experience is currently in public preview.

## Compare experiences
The following table compares the OpenTelemetry-based and logs-based metrics experiences for Azure Monitor VM insights. Further details on each experience are provided in the sections below.

| Feature | OpenTelemetry-based (preview) | Logs-based (classic) |
|:---|:---|:---|
| **Data storage** | Azure Monitor workspace | Log Analytics workspace |
| **Applies to** | Azure VMs<br>Arc-enabled servers | Azure VMs<br>Arc-enabled servers<br>VM Scale Sets |
| **Data model** | OpenTelemetry system metrics with consistent cross-platform naming | Platform-specific performance counters |
| **Query language** | PromQL (Prometheus Query Language) | KQL (Kusto Query Language) |
| **Latency** | Near real-time with low latency | Typically 1-3 minutes |
| **Cost** | Optimized for metrics storage and retrieval | Standard Log Analytics ingestion and retention costs |
| **Multi-VM views** | Currently limited | Full VM insights multi-VM dashboards and workbooks |
| **Correlation with logs** | Requires separate queries | Single workspace for metrics and logs enables correlation in one query |

## Performance counters
Both Windows and Linux provide OS-level metrics such as CPU usage, memory consumption, disk I/O, and networking to help diagnose performance issues. The total number of available OS performance counters is dynamic, with Windows providing [~1846 OS performance counters](/troubleshoot/windows-server/performance/rebuild-performance-counter-library-values) by default and several more available based on the local machine available hardware, software, and tracepoint events.

A subset of OpenTelemetry metrics are known as [system metrics](https://opentelemetry.io/docs/specs/semconv/system/system-metrics/). System metrics are essentially another name for performance counters; they provide an open source standard for consistent naming and formatting of performance counters and don't add any new OS performance counters.

## Benefits of OpenTelemetry

**Cross-OS observability**<br>
The OpenTelemetry semantic convention for system metrics streamlines the cross-OS end user experience by converging Windows and Linux performance counters into a consistent naming convention and metric data model. This makes it easier for you to manage all virtual machines with a single set of queries used for either Windows or Linux OS images. The same [configuration-as-code](./vm-enable-monitoring.md) deployment methods and the same PromQl queries can be used for any hosting resource that adopts OpenTelemetry system metrics. 

**More performance counters**<br>
The OpenTelemetry Collector Host Metrics Receiver collects more performance counters than Azure Monitor currently makes available for logs-based collection. For example, you can monitor per-process CPU utilization, disk I/O, and memory usage.

**Simplified counters**<br>
In many scenarios, existing performance counters have been simplified into a single OpenTelemetry (OTel) system metric with metric dimensions [(Resource Attributes)](https://opentelemetry.io/docs/specs/otel/metrics/data-model/#timeseries-model), simplifying the user experience.

For example, OTel includes a `system.cpu.time` metric. You can filter on the `State` dimension for time in each state such as *user*, *system*, *idle*. With logs-based collection, you would need to collect and query the following performance counters.

- Windows
    - `\Processor Information(_Total )\% Processor Time`
    - `\Processor Information(_Total)\% Privileged Time`
    - `\Processor Information(_Total)\% User Time`
- Linux
    - `Cpu/usage_user`
    - `Cpu/usage_system`
    - `Cpu/usage_idle`
    - `Cpu/usage_active`
    - `Cpu/usage_nice`
    - `Cpu/usage_iowait`
    - `Cpu/usage_irq`

## Benefits of Azure Monitor workspace

Metrics stored in Azure Monitor workspaces are cheaper and faster to query than the same data stored in Log Analytics workspaces because they're optimized for retrieval from a time series database. 

Using OTel metrics in Azure Monitor workspace also avoids the multiple schemas in logs-based collection. Metrics collected by VM insights are stored in the `InsightsMetrics` table, while additional metrics that you enable are collected in the `Perf` table, which uses a different schema.

Enhanced monitoring with OpenTelemetry uses a subset of the available system metrics, providing seamless compatibility across user cohorts. Large enterprises with different application teams can use the same PromQL queries, dashboards, and alerts for the same sets of OTel metrics.

## Current limitations of OpenTelemetry experience

- OpenTelemetry-based collection is currently only available for individual VMs and Arc-enabled servers. Logs-based collection can also be used for VM Scale Sets.
- You can't perform a single query across data in a Log Analytics workspace and Azure Monitor workspace. With logs-based collection, logs and metrics for your VMs are stored together, allowing you to correlate between them in a single KQL query. With OpenTelemetry-based collection, metrics are stored in an Azure Monitor workspace and logs are stored in a Log Analytics workspace, requiring separate queries for each.
- You can create your own workbooks and dashboards to view multi-VM charts using OpenTelemetry metrics, but there isn't a built-in experience in the Azure portal like the one available for logs-based collection.
 
### When to choose each experience
You can enable either or both experiences on a VM. For step-by-step guidance, see [Enable monitoring for Azure virtual machine](vm-enable-monitoring.md).

**Choose OpenTelemetry-based (preview) if:**
- You're monitoring individual VMs and want the fastest, most cost-effective metrics solution.
- You're building new monitoring solutions and want to use open standards.
- You need cross-platform consistency with the same metric names for Windows and Linux.
- You need per-process metrics for deep performance analysis.

**Choose logs-based (classic) if:**
- You need to monitor VM Scale Sets.
- You want multi-VM dashboards and trending views across your entire VM fleet.
- You want to correlate metrics and logs in a single query.
- You have existing queries, dashboards, and alerts that use the `InsightsMetrics` table.

> [!TIP]
> Share your feedback on new performance counters or functionality you would like to see by posting to the Azure Monitor [GitHub Community](https://github.com/microsoft/AzureMonitorCommunity/discussions) or via [Portal feedback](/answers/questions/564554/where-can-i-submit-suggestions-for-azure).


## Next steps

- [Enable enhanced monitoring for an Azure virtual machine](./tutorial-vm-enable-monitoring.md)
- [Customize OpenTelemetry metric collection](./vminsights-opentelemetry.md)
- [How to begin collecting OpenTelemetry Guest OS performance counters: DCR collection](./data-collection-performance.md)
