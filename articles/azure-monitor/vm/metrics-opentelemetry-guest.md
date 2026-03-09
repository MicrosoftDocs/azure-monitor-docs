---
title: OpenTelemetry Guest OS Metrics (preview)
description: Learn about OpenTelemetry System Metrics (Guest OS Performances Counters) in Azure Monitor and how they're modeled.
ms.topic: concept-article
ms.date: 09/27/2025
ms.reviewer: tylerkight
---

# OpenTelemetry Guest OS Metrics (preview)
When you enable enhanced monitoring for a virtual machine in Azure Monitor, you can choose between two experiences for collecting and visualizing performance data from the VM guest operating system: OpenTelemetry-based metrics (preview) and log-based metrics (classic). This article describes the differences between these two experiences and how to migrate from the logs-based experience OpenTelemetry-based metrics.

> [!NOTE]
> OpenTelemetry Guest OS Performance Counters are currently in public preview.

This article is about Guest OS performance counters that users must opt-in to collecting, either via Azure Monitor Agent with DCR, VM Insights with DCR, or user-collected with the OTelCollector as part of OTel instrumentation libraries. Users are recommended to store all metrics in the metrics-optimized Azure Monitor Workspace, where they are cheaper and faster to query than in Log Analytics Workspaces. 
 
This article provides users with the following information:
* [Overview of performance counters](#performance-counters)
* [Benefits of using OpenTelemetry system metrics](#benefits-of-opentelemetry)
* [Benefits of using Azure Monitor Workspace for metrics](#benefits-of-azure-monitor-workspace)
* [Comparison of OpenTelemetry naming convention to traditional performance counters](#performance-counter-names)
* [Resource Attributes](#resource-attributes)

## Performance Counters
Both Windows and Linux provide OS-level metrics such as CPU usage, memory consumption, disk I/O, and networking to help diagnose performance issues. The total number of available OS performance counters is dynamic, with Windows providing [~1846 OS performance counters](/troubleshoot/windows-server/performance/rebuild-performance-counter-library-values) by default and several more available based on the local machine available hardware, software, and tracepoint events.

A subset of OpenTelemetry Metrics are known as [system metrics](https://opentelemetry.io/docs/specs/semconv/system/system-metrics/). System metrics are essentially another name for performance counters; they are an Open Source Standard for consistent naming and formatting of performance counters and do not add any net-new OS performance counters.

## Benefits of OpenTelemetry

**Cross-OS observability**
The OpenTelemetry semantic convention for system metrics streamlines the cross-OS end user experience by converging Windows and Linux performance counters into a consistent naming convention and metric data model. This makes it easier for you to manage all virtual machines with a single set of queries used for either Windows or Linux OS images. The same configuration-as-code (including ARM/Bicep templates and Terraform) using the same PromQl queries can be used for any hosting resource that adopts OpenTelemetry system metrics. 

**More performance counters**
The OpenTelemetry Collector Host Metrics Receiver collects many more performance counters than Azure Monitor currently makes available for logs-based collection. For example, you can monitor per-process CPU utilization, disk I/O, and memory usage.

**Simplified counters**
In many scenarios, existing performance counters have been simplified into a single OTel system metric with metric dimensions [(Resource Attributes)](https://opentelemetry.io/docs/specs/otel/metrics/data-model/#timeseries-model), simplifying the user experience.


| Collection | Windows | Linux |
|:---|:---|:---|
| Otel | `system.cpu.time` (Filter on the dimension *State* for time in each state such as user, system, idle.) |
| Logs | * \Processor Information(_Total )\% Processor Time<br>* \Processor Information(_Total)\% Privileged Time<br>* \Processor Information(_Total)\% User Time | * Cpu/usage_user<br>* Cpu/usage_system<br>* Cpu/usage_idle<br>* Cpu/usage_active<br>* Cpu/usage_nice<br>* Cpu/usage_iowait<br>* Cpu/usage_irq |


## Benefits of Azure Monitor Workspace

Metrics stored in Azure Monitor workspaces are cheaper and faster to query than the same data stored in Log Analytics workspaces because they're optimized for retrieval from a time series database. 

Using OTel metrics in AMW also avoids the current multiple schemas in logs-based collection. Metrics collected by VM insights are stored in the `InsightsMetrics` table while additional metrics that you enable are collected in the `Perf` table which uses a different schema.

Enhanced monitoring with OpenTelemetry uses a subset of the system metrics available to users, providing seamless compatibility across user cohorts. Large enterprises with different application teams can use the same PromQl queries, dashboards, and alerts for the same sets of OTel metrics.

## Current limitations
There currently isn't a method to perform a single query across data in a Log Analytics workspace and Azure Monitor workspace. Using logs-based collection, logs and metrics for your VMs are stored together in a Log Analytics workspace, allowing you to correlate between them in a single KQL query. With OpenTelemetry-based collection, metrics are stored in an Azure Monitor workspace and logs are stored in a Log Analytics workspace, requiring separate queries for each.

## Compare OpenTelemetry and logs-based experiences

| Feature | OpenTelemetry-based (preview) | Logs-based (classic) |
|:---|:---|:---|
| **Data storage** | Azure Monitor workspace (metrics) | Log Analytics workspace (logs) |
| **Applies to** | Azure VMs | Azure VMs and VM Scale Sets |
| **Data model** | OpenTelemetry system metrics with consistent cross-platform naming | Platform-specific performance counters (Windows and Linux have different counter names) |
| **Query language** | PromQL (Prometheus Query Language) | KQL (Kusto Query Language) |
| **Latency** | Near real-time with low latency | Typically 1-3 minutes |
| **Cost** | Optimized for metrics storage and retrieval | Standard Log Analytics ingestion and retention costs |
| **Multi-VM views** | Currently limited | Full VM insights multi-VM dashboards and workbooks |
| **Correlation with logs** | Requires separate queries (metrics in Azure Monitor workspace, logs in Log Analytics) | Single workspace for metrics and logs enables correlation in one query |

### When to choose each experience
You can enable either or both experiences on a VM. For step-by-step guidance, see [Enable monitoring for Azure virtual machine](vm-enable-monitoring.md).

**Choose OpenTelemetry-based (preview) if:**
- You're monitoring individual VMs and want the fastest, most cost-effective metrics solution
- You're building new monitoring solutions and want to use open standards
- You need cross-platform consistency with the same metric names for Windows and Linux
- You need per-process metrics for deep performance analysis

**Choose logs-based (classic) if:**
- You need to monitor VM Scale Sets
- You want multi-VM dashboards and trending views across your entire VM fleet
- You need dependency mapping to understand application component relationships
- You want to correlate metrics and logs in a single query
- You have existing queries, dashboards, and alerts that use the `InsightsMetrics` table



> [!TIP]
> Feel free to share your feedback on new performance counters or functionality you would like to see by posting to our [GitHub Community](https://github.com/microsoft/AzureMonitorCommunity/discussions) or via [Portal feedback](/answers/questions/564554/where-can-i-submit-suggestions-for-azure).

## Resource Attributes

The OpenTelemetry [Resource semantic convention](https://opentelemetry.io/docs/specs/semconv/resource/) is still in development. We are actively engaging with the OSS community to improve and standardize this naming convention for a variety of scenarios - please share your feedback to help us continuously improve your experience.

In general, OpenTelemetry metrics collected via Azure Monitor Agent + Data Collection Rules and sent to Azure Monitor workspaces have the following cloud resource attributes automatically added as dimensions to support resource-scoped querying:
* Microsoft.resourceid
 * Microsoft.subscriptionid
 * Microsoft.resourcegroupname
 * Microsoft.resourcetype
 * Microsoft.amwresourceid

OpenTelemetry [**per-process** metrics](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/receiver/hostmetricsreceiver/internal/scraper/processscraper/documentation.md#process) have their own special set of [Resource Attributes](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/receiver/hostmetricsreceiver/internal/scraper/processscraper/documentation.md#resource-attributes). The table shows those resource attributes that the Azure Monitor Agent automatically promotes as dimensions.

| Name | Description | Values | Enabled | 
|------|-------------|--------|---------|
| process.command | The command used to launch the process (i.e., the command name). On Linux-based systems, can be set to the zeroth string in `proc/[pid]/cmdline`. On Windows, can be set to the first parameter extracted from `GetCommandLineW`. | Any Str | true |
 process.executable.name  | The name of the process executable. On Linux-based systems, can be set to the `Name` in `proc/[pid]/status`. On Windows, can be set to the base name of `GetProcessImageFileNameW`. | Any Str | true |
| process.owner            | The username of the user that owns the process. | Any Str | true |
| process.pid              | Process identifier (PID). | Any Int | true |
| process.cgroup           | cgroup associated with the process (Linux only). | Any Str | false |
| process.command_line     | The full command used to launch the process as a single string representing the full command. On Windows, can be set to the result of `GetCommandLineW`. Do not set this if you have to assemble it just for monitoring; use `process.command_args` instead. | Any Str | false |
| process.executable.path  | The full path to the process executable. On Linux-based systems, can be set to the target of `proc/[pid]/exe`. On Windows, can be set to the result of `GetProcessImageFileNameW`. | Any Str | false |
| process.parent_pid | Parent Process Identifier (PPID). | Any Int | false |

The process.command_line attribute can contain extremely long strings with thousands of characters, making it unsuitable as a normal metric dimension. We might find a different way to surface this attribute based on customer user scenarios submitted as feedback to the product team.

## Next steps

Use custom metrics from various services:

* [How to begin collecting OpenTelemetry Guest OS performance counters: DCR collection](../vm/data-collection-performance.md)
 * [How to begin collecting OpenTelemetry Guest OS performance counters: VM Insights](../vm/vminsights-opentelemetry.md)
 * [How to query OpenTelemetry Guest OS performance counters with PromQl](./prometheus-system-metrics-best-practices.md)
