---
title: Dependency tracking in Application Insights | Microsoft Docs
description: Monitor dependency calls from your on-premises or Azure web application with Application Insights.
ms.topic: how-to
ms.date: 01/31/2025
ms.devlang: csharp
ms.custom: devx-track-csharp, build-2023
ms.reviewer: mmcc
---

# Dependency tracking in Application Insights

A *dependency* is a component that's called by your application. It's typically a service called by using HTTP, a database, or a file system. [Application Insights](app-insights-overview.md) measures the duration of dependency calls and whether it's failing or not, and collects information like the name of the dependency. You can investigate specific dependency calls and correlate them to requests and exceptions.

## Automatically tracked dependencies

Below is the currently supported list of dependency calls that are automatically detected as dependencies without requiring any additional modification to your application's code. These dependencies are visualized in the Application Insights [Application map](app-map.md) and [Transaction diagnostics](transaction-search-and-diagnostics.md?tabs=transaction-diagnostics) views. If your dependency isn't on the list, you can still track it manually with a [track dependency call](api-custom-events-metrics.md#trackdependency).

**Azure Monitor OpenTelemetry Distro (recommended)**

For a list of all autocollected dependencies, see the language-specific tabs in [Add and modify Azure Monitor OpenTelemetry for .NET, Java, Node.js, and Python applications](opentelemetry-add-modify.md#included-instrumentation-libraries).

**Application Insights SDK (Classic API)**

* **.NET** - For a list of all autocollected dependencies, see [Application Insights for ASP.NET and ASP.NET Core applications](asp-net.md#automatically-tracked-dependencies).
* **Node.js** - A list of the latest currently supported modules is maintained in [Diagnostic Channel Publishers](https://github.com/microsoft/node-diagnostic-channel/tree/master/src/diagnostic-channel-publishers).
* **Browser (JS)** - The JavaScript SDK autocollects dependencies made via [XMLHttpRequest](https://developer.mozilla.org/docs/Web/API/XMLHttpRequest).

### How does automatic dependency monitoring work?

Dependencies are automatically collected using one of the following techniques, depending on the telemetry collection method.

**Azure Monitor OpenTelemetry Distro**

* [OpenTelemetry instrumentation libraries](opentelemetry-add-modify.md#included-instrumentation-libraries) are used to automatically collect dependencies such as HTTP, SQL, and Azure SDK calls. These libraries hook into supported frameworks and client libraries using `DiagnosticSource` or equivalent mechanisms.
* In supported environments like [Azure App Services](codeless-app-service.md), [autoinstrumentation](codeless-overview.md) is available and enabled by default, injecting telemetry collectors at runtime without code changes.
* In other environments, developers can manually configure instrumentation using the *Azure.Monitor.OpenTelemetry.\** packages and OpenTelemetry APIs to control which dependencies are tracked and how they are enriched or filtered.

**Application Insights SDK (Classic API)**

* Bytecode instrumentation is applied around selected methods using `InstrumentationEngine`, enabled via `StatusMonitor` or the Application Insights extension for Azure App Service.
* `EventSource` callbacks are used to capture telemetry from .NET libraries that emit structured events.
* `DiagnosticSource` callbacks are used in newer .NET and .NET Core SDKs to collect telemetry from libraries that support distributed tracing.

---

## Manually tracking dependencies

**Azure Monitor OpenTelemetry Distro**

..., see [Add and modify Azure Monitor OpenTelemetry for .NET, Java, Node.js, and Python applications](opentelemetry-add-modify.md#included-instrumentation-libraries).

**Application Insights SDK (Classic API)**

* ASP.NET - [Application Insights for ASP.NET and ASP.NET Core applications](asp-net.md#manually-tracking-dependencies).
* Node.js - [Monitor your Node.js services and apps with Application Insights](nodejs.md#track-your-dependencies)
* JavaScript - [Enable Azure Monitor Application Insights Real User Monitoring](javascript-sdk.md)

## Track AJAX calls from webpages

For webpages, the [Application Insights JavaScript SDK](javascript-sdk.md) automatically collects AJAX calls as dependencies.

## Advanced SQL tracking to get full SQL query

> [!NOTE]
> Azure Functions requires separate settings to enable SQL text collection. For more information, see [Enable SQL query collection](/azure/azure-functions/configure-monitoring#enable-sql-query-collection).

...

## Where to find dependency data

* [Application Map](app-map.md) visualizes dependencies between your app and neighboring components.
* [Transaction Diagnostics](transaction-search-and-diagnostics.md?tabs=transaction-diagnostics) shows unified, correlated server data.
* [Browsers tab](javascript.md) shows AJAX calls from your users' browsers.
* Select from slow or failed requests to check their dependency calls.
* [Analytics](#logs-analytics) can be used to query dependency data.

## <a name="diagnosis"></a> Diagnose slow requests

Each request event is associated with the dependency calls, exceptions, and other events tracked while processing the request. So, if some requests are doing badly, you can find out whether it's because of slow responses from a dependency.

### Tracing from requests to dependencies

Select the left-hand **Performance** tab and select the **Dependencies** tab at the top.

Select a **Dependency Name** under **Overall**. After you select a dependency, it shows a graph of that dependency's distribution of durations.

:::image type="content" source="media/asp-net-dependencies/2-perf-dependencies.png" lightbox="media/asp-net-dependencies/2-perf-dependencies.png" alt-text="Screenshot that shows the Dependencies tab open to select a Dependency Name in the chart.":::

Select the **Samples** button at the bottom right. Then select a sample to see the end-to-end transaction details.

:::image type="content" source="media/asp-net-dependencies/3-end-to-end.png" lightbox="media/asp-net-dependencies/3-end-to-end.png" alt-text="Screenshot that shows selecting a sample to see the end-to-end transaction details.":::

### Profile your live site

The [.NET Profiler](profiler.md) traces HTTP calls to your live site and shows you the functions in your code that took the longest time.

## Failed requests

Failed requests might also be associated with failed calls to dependencies.

Select the left-hand **Failures** tab and then select the **Dependencies** tab at the top.

:::image type="content" source="media/asp-net-dependencies/4-fail.png" lightbox="media/asp-net-dependencies/4-fail.png" alt-text="Screenshot that shows selecting the failed requests chart.":::

Here you see the failed dependency count. To get more information about a failed occurrence, select a **Dependency Name** in the bottom table. Select the **Dependencies** button at the bottom right to see the end-to-end transaction details.

## Logs (Analytics)

You can track dependencies in the [Kusto query language](/azure/kusto/query/). Here are some examples.

* Find any failed dependency calls:
    
    ``` Kusto
    
        dependencies | where success != "True" | take 10
    ```

* Find AJAX calls:

    ``` Kusto
    
        dependencies | where client_Type == "Browser" | take 10
    ```

* Find dependency calls associated with requests:
    
    ``` Kusto
    
        dependencies
        | where timestamp > ago(1d) and  client_Type != "Browser"
        | join (requests | where timestamp > ago(1d))
          on operation_Id  
    ```

* Find AJAX calls associated with page views:
    
    ``` Kusto 
    
        dependencies
        | where timestamp > ago(1d) and  client_Type == "Browser"
        | join (browserTimings | where timestamp > ago(1d))
          on operation_Id
    ```

## Open-source SDK

Like every Application Insights SDK, the dependency collection module is also open source. Read and contribute to the code or report issues at [the official GitHub repo](https://github.com/Microsoft/ApplicationInsights-dotnet).

## Next steps

* Review frequently asked questions (FAQ): [Dependency tracking FAQ](application-insights-faq.yml#dependency-tracking)
* See the [data model](data-model-complete.md) for Application Insights.
* Check out [platforms](app-insights-overview.md#supported-languages) supported by Application Insights.
* Set up custom dependency tracking for [ASP.NET or ASP.NET Core](api-custom-events-metrics.md#trackdependency)
* Set up custom dependency tracking for [Java](opentelemetry-add-modify.md?tabs=java#add-custom-spans).
* Set up custom dependency tracking for [OpenCensus Python](/previous-versions/azure/azure-monitor/app/opencensus-python-dependency).
