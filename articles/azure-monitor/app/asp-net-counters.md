---
title: ASP.NET performance and event counters
description: Monitor .NET system and event counters in Application Insights.
ms.topic: how-to
ms.date: 04/08/2025
ms.devlang: csharp
ms.custom: devx-track-csharp, devx-track-dotnet
ms.reviewer: rijolly
---

# Counters for .NET in Application Insights

[Azure Monitor](..\overview.md) [Application Insights](app-insights-overview.md) supports performance counters and event counters. This guide provides an overview of both, including their purpose, configuration, and usage in .NET applications.

[!INCLUDE [azure-monitor-app-insights-otel-available-notification](includes/azure-monitor-app-insights-otel-available-notification.md)]

## Overview

> [!div class="checklist"]
> - **Performance counters** are built into the Windows operating system and offer predefined metrics like CPU usage, memory consumption, and disk activity. These counters are ideal for monitoring standard performance metrics with minimal setup. They help track resource utilization or troubleshoot system-level bottlenecks in Windows-based applications but don't support custom application-specific metrics.
> - **Event counters** work across multiple platforms, including Windows, Linux, and macOS. They allow developers to define and monitor lightweight, customizable application-specific metrics, providing more flexibility than performance counters. Event counters are useful when system metrics are insufficient or when detailed telemetry is needed in cross-platform applications. They require explicit implementation and configuration, which makes setup more effort-intensive.

## Configuring counters

### [Performance counters](#tab/performancecounters)

Windows provides various [performance counters](/windows/desktop/perfctrs/about-performance-counters), such as those used to gather processor, memory, and disk usage statistics. You can also define your own performance counters. 

Your application supports performance counter collection if it runs under Internet Information Server (IIS) on an on-premises host or a virtual machine with administrative access. Applications running as Azure Web Apps can't directly access performance counters, but Application Insights collects a subset of available counters.

### Prerequisites

Grant the app pool service account permission to monitor performance counters by adding it to the [Performance Monitor Users](/windows/security/identity-protection/access-control/active-directory-security-groups#bkmk-perfmonitorusers) group.

```shell
net localgroup "Performance Monitor Users" /add "IIS APPPOOL\NameOfYourPool"
```

### View counters

The **Metrics** pane shows the default set of performance counters.

Default counters for ASP.NET web applications:

- % Process\\Processor Time
- % Process\\Processor Time Normalized
- Memory\\Available Bytes
- ASP.NET Requests/Sec
- .NET Common Language Runtime (CLR) Exceptions Thrown / sec
- ASP.NET ApplicationsRequest Execution Time
- Process\\Private Bytes
- Process\\IO Data Bytes/sec
- ASP.NET Applications\\Requests In Application Queue
- Processor(_Total)\\% Processor Time

Default counters for ASP.NET Core web applications:

- % Process\\Processor Time
- % Process\\Processor Time Normalized
- Memory\\Available Bytes
- Process\\Private Bytes
- Process\\IO Data Bytes/sec
- Processor(_Total)\\% Processor Time

### Add counters

If the performance counter you want isn't included in the list of metrics, you can add it.

1. Find out what counters are available in your server by using this PowerShell command on the local server:

    ```shell
    Get-Counter -ListSet *
    ```

    For more information, see [`Get-Counter`](/powershell/module/microsoft.powershell.diagnostics/get-counter).

1. Open `ApplicationInsights.config`.

    If you added Application Insights to your app during development:
    1. Edit `ApplicationInsights.config` in your project.
    1. Redeploy it to your servers.

1. Edit the performance collector directive:

    ```xml

        <Add Type="Microsoft.ApplicationInsights.Extensibility.PerfCounterCollector.PerformanceCollectorModule, Microsoft.AI.PerfCounterCollector">
          <Counters>
            <Add PerformanceCounter="\Objects\Processes"/>
            <Add PerformanceCounter="\Sales(photo)\# Items Sold" ReportAs="Photo sales"/>
          </Counters>
        </Add>
    ```

> [!NOTE]
> ASP.NET Core applications don't have `ApplicationInsights.config`, so the preceding method isn't valid for ASP.NET Core applications.

You capture both standard counters and counters you implement yourself. `\Objects\Processes` is an example of a standard counter that's available on all Windows systems. `\Sales(photo)\# Items Sold` is an example of a custom counter that might be implemented in a web service.

The format is `\Category(instance)\Counter`, or for categories that don't have instances, just `\Category\Counter`.

The `ReportAs` parameter is required for counter names that don't match `[a-zA-Z()/-_ \.]+`.

If you specify an instance, it becomes a dimension `CounterInstanceName` of the reported metric.

### Collect performance counters in code for ASP.NET web applications or .NET/.NET Core console applications
To collect system performance counters and send them to Application Insights, you can adapt the following snippet:

```csharp
    var perfCollectorModule = new PerformanceCollectorModule();
    perfCollectorModule.Counters.Add(new PerformanceCounterCollectionRequest(
      @"\Process([replace-with-application-process-name])\Page Faults/sec", "PageFaultsPerfSec"));
    perfCollectorModule.Initialize(TelemetryConfiguration.Active);
```

Or you can do the same thing with custom metrics that you created:

```csharp
    var perfCollectorModule = new PerformanceCollectorModule();
    perfCollectorModule.Counters.Add(new PerformanceCounterCollectionRequest(
      @"\Sales(photo)\# Items Sold", "Photo sales"));
    perfCollectorModule.Initialize(TelemetryConfiguration.Active);
```

### Collect performance counters in code for ASP.NET Core web applications

Configure `PerformanceCollectorModule` after the `WebApplication.CreateBuilder()` method in `Program.cs`:

```csharp
using Microsoft.ApplicationInsights.Extensibility.PerfCounterCollector;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddApplicationInsightsTelemetry();

// The following configures PerformanceCollectorModule.

builder.Services.ConfigureTelemetryModule<PerformanceCollectorModule>((module, o) =>
    {
        // The application process name could be "dotnet" for ASP.NET Core self-hosted applications.
        module.Counters.Add(new PerformanceCounterCollectionRequest(@"\Process([replace-with-application-process-name])\Page Faults/sec", "DotnetPageFaultsPerfSec"));
    });

var app = builder.Build();
```

### ASP.NET and Application Insights counts

The next sections discuss ASP.NET and Application Insights counts.

#### Performance counters for applications running in Azure Web Apps and Windows containers on Azure App Service

Both ASP.NET and ASP.NET Core applications deployed to Azure Web Apps run in a special sandbox environment. Applications deployed to Azure App Service can utilize a [Windows container](/azure/app-service/quickstart-custom-container?pivots=container-windows&tabs=dotnet) or be hosted in a sandbox environment. If the application is deployed in a Windows container, all standard performance counters are available in the container image.

The sandbox environment doesn't allow direct access to system performance counters. However, a limited subset of counters is exposed as environment variables as described in [Perf Counters exposed as environment variables](https://github.com/projectkudu/kudu/wiki/Perf-Counters-exposed-as-environment-variables). Only a subset of counters is available in this environment. For the full list, see [Perf Counters exposed as environment variables](https://github.com/microsoft/ApplicationInsights-dotnet/blob/main/WEB/Src/PerformanceCollector/PerformanceCollector/Implementation/WebAppPerformanceCollector/CounterFactory.cs).

The Application Insights SDK for [ASP.NET](https://nuget.org/packages/Microsoft.ApplicationInsights.Web) and [ASP.NET Core](https://nuget.org/packages/Microsoft.ApplicationInsights.AspNetCore) detects if code is deployed to a web app or a non-Windows container. The detection determines whether it collects performance counters in a sandbox environment or utilizes the standard collection mechanism when hosted on a Windows container or virtual machine.

#### Performance counters in ASP.NET Core applications

Support for performance counters in ASP.NET Core is limited:

* [SDK](https://nuget.org/packages/Microsoft.ApplicationInsights.AspNetCore) versions 2.4.1 and later collect performance counters if the application is running in Azure Web Apps (Windows).
* SDK versions 2.7.1 and later collect performance counters if the application is running in Windows and targets `NETSTANDARD2.0` or later.
* For applications that target the .NET Framework, all versions of the SDK support performance counters.
* SDK versions 2.8.0 and later support the CPU/Memory counter in Linux. No other counter is supported in Linux. To get system counters in Linux (and other non-Windows environments), use event counters.

### [Event counters](#tab/eventcounters)

[`EventCounter`](/dotnet/core/diagnostics/event-counters) is .NET/.NET Core mechanism to publish and consume counters or statistics. EventCounters are supported in all OS platforms - Windows, Linux, and macOS. It can be thought of as a cross-platform equivalent for the [PerformanceCounters](/dotnet/api/system.diagnostics.performancecounter) that is only supported in Windows systems.

While users can publish any custom event counters to meet their needs, [.NET](/dotnet/fundamentals/) publishes a set of these counters by default. This document walks through the steps required to collect and view event counters (system defined or user defined) in Azure Application Insights.

### Using Application Insights to collect EventCounters

Application Insights supports collecting `EventCounters` with its `EventCounterCollectionModule`, which is part of the newly released NuGet package [Microsoft.ApplicationInsights.EventCounterCollector](https://www.nuget.org/packages/Microsoft.ApplicationInsights.EventCounterCollector). `EventCounterCollectionModule` is automatically enabled when using either [AspNetCore](asp-net-core.md) or [WorkerService](worker-service.md). `EventCounterCollectionModule` collects counters with a nonconfigurable collection frequency of 60 seconds. There are no special permissions required to collect EventCounters. For ASP.NET Core applications, you also want to add the [Microsoft.ApplicationInsights.AspNetCore](https://www.nuget.org/packages/Microsoft.ApplicationInsights.AspNetCore) package.

```dotnetcli
dotnet add package Microsoft.ApplicationInsights.EventCounterCollector
dotnet add package Microsoft.ApplicationInsights.AspNetCore
```

### Default counters collected

Starting with 2.15.0 version of either [AspNetCore SDK](asp-net-core.md) or [WorkerService SDK](worker-service.md), no counters are collected by default. The module itself is enabled, so users can add the desired counters to collect them.

To get a list of well known counters published by the .NET Runtime, see [Available Counters](/dotnet/core/diagnostics/event-counters#available-counters) document.

### Customizing counters to be collected

The following example shows how to add/remove counters. This customization would be done as part of your application service configuration after Application Insights telemetry collection is enabled using either `AddApplicationInsightsTelemetry()` or `AddApplicationInsightsWorkerService()`. Following is an example code from an ASP.NET Core application. For other type of applications, refer to [this](worker-service.md#configure-or-remove-default-telemetry-modules) document.

```csharp
using Microsoft.ApplicationInsights.Extensibility.EventCounterCollector;
using Microsoft.Extensions.DependencyInjection;

builder.Services.ConfigureTelemetryModule<EventCounterCollectionModule>(
        (module, o) =>
        {
            // Removes all default counters, if any.
            module.Counters.Clear();

            // Adds a user defined counter "MyCounter" from EventSource named "MyEventSource"
            module.Counters.Add(
                new EventCounterCollectionRequest("MyEventSource", "MyCounter"));

            // Adds the system counter "gen-0-size" from "System.Runtime"
            module.Counters.Add(
                new EventCounterCollectionRequest("System.Runtime", "gen-0-size"));
        }
    );
```

### Disabling EventCounter collection module

`EventCounterCollectionModule` can be disabled by using `ApplicationInsightsServiceOptions`.

The following example uses the ASP.NET Core SDK.

```csharp
using Microsoft.ApplicationInsights.AspNetCore.Extensions;
using Microsoft.Extensions.DependencyInjection;

var applicationInsightsServiceOptions = new ApplicationInsightsServiceOptions();
applicationInsightsServiceOptions.EnableEventCounterCollectionModule = false;
builder.Services.AddApplicationInsightsTelemetry(applicationInsightsServiceOptions);
```

A similar approach can be used for the WorkerService SDK as well, but the namespace must be changed as shown in the following example.

```csharp
using Microsoft.ApplicationInsights.AspNetCore.Extensions;
using Microsoft.Extensions.DependencyInjection;

var applicationInsightsServiceOptions = new ApplicationInsightsServiceOptions();
applicationInsightsServiceOptions.EnableEventCounterCollectionModule = false;
builder.Services.AddApplicationInsightsTelemetry(applicationInsightsServiceOptions);
```

---

## Log Analytics queries

### [Performance counters](#tab/performancecounters)

You can search and display performance counter reports in [Log Analytics](../logs/log-query-overview.md).

The **performanceCounters** schema exposes the `category`, `counter` name, and `instance` name of each performance counter. In the telemetry for each application, you see only the counters for that application. For example, to see what counters are available:

```kusto
performanceCounters | summarize count(), avg(value) by category, instance, counter
```

Here, `Instance` refers to the performance counter instance, not the role, or server machine instance. The performance counter instance name typically segments counters, such as processor time, by the name of the process or application.

To get a chart of available memory over the recent period:

```kusto
performanceCounters | where counter == "Available Bytes" | summarize avg(value), min(value) by bin(timestamp, 1h) | render timechart
```

Like other telemetry, **performanceCounters** also has a column `cloud_RoleInstance` that indicates the identity of the host server instance on which your app is running. For example, to compare the performance of your app on the different machines:

```kusto
performanceCounters | where counter == "% Processor Time" and instance == "SendMetrics" | summarize avg(value) by cloud_RoleInstance, bin(timestamp, 1d)
```

### [Event counters](#tab/eventcounters)

You can search and display event counter reports in [Log Analytics](../logs/log-query-overview.md), in the **customMetrics** table.

For example, run the following query to see what counters are collected and available to query:

```Kusto
customMetrics | summarize avg(value) by name
```

To get a chart of a specific counter (for example: `ThreadPool Completed Work Item Count`) over the recent period, run the following query.

```Kusto
customMetrics 
| where name contains "System.Runtime|ThreadPool Completed Work Item Count"
| where timestamp >= ago(1h)
| summarize  avg(value) by cloud_RoleInstance, bin(timestamp, 1m)
| render timechart
```

Like other telemetry, **customMetrics** also has a column `cloud_RoleInstance` that indicates the identity of the host server instance on which your app is running. The prior query shows the counter value per instance, and can be used to compare performance of different server instances.

---

## Alerts

Like other metrics, you can [set an alert](../alerts/alerts-log.md) to warn if a counter goes outside a specified limit.

To set an alert, open the **Alerts** pane and select **Add Alert**.

## Next steps

-  To review frequently asked questions (FAQ), see [Performance counters FAQ](application-insights-faq.yml#asp-net-performance-counters) and [Event counters FAQ](application-insights-faq.yml#asp-net-event-counters)
- Validate you're running a [supported version](/troubleshoot/azure/azure-monitor/app-insights/telemetry/sdk-support-guidance) of the Application Insights SDK.
