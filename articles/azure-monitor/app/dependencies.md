---
title: Dependency Tracking in Application Insights | Microsoft Docs
description: Monitor dependency calls from your on-premises or Azure web application with Application Insights.
ms.topic: how-to
ms.date: 01/31/2025
ms.devlang: csharp
ms.custom: devx-track-csharp, build-2023
---

# Dependency tracking in Application Insights

A *dependency* is a component that's called by your application. It's typically a service called by using HTTP, a database, or a file system. [Application Insights](app-insights-overview.md) measures the duration of dependency calls and whether it's failing or not, and collects information like the name of the dependency. You can investigate specific dependency calls and correlate them to requests and exceptions.

## Automatically tracked dependencies

This section links to lists of dependency calls that are automatically detected as dependencies without requiring any additional modification to your application's code. These dependencies are visualized in the Application Insights [Application map](app-map.md) and [Transaction diagnostics](failures-performance-transactions.md#transaction-diagnostics-experience) views.

If your dependency isn't on the list, you can still track it manually, see [Manually track dependencies](#manually-track-dependencies).

For a list of all autocollected dependencies, see the language-specific tabs in [Add and modify Azure Monitor OpenTelemetry for .NET, Java, Node.js, and Python applications](opentelemetry-add-modify.md#included-instrumentation-libraries).

> [!NOTE]
> For webpages, the [Application Insights JavaScript SDK](javascript-sdk.md) automatically collects AJAX dependencies made via [XMLHttpRequest](https://developer.mozilla.org/docs/Web/API/XMLHttpRequest).

### How does automatic dependency monitoring work?

Dependencies are automatically collected using one of the following techniques, depending on the telemetry collection method.

* [OpenTelemetry instrumentation libraries](opentelemetry-add-modify.md#included-instrumentation-libraries) are used to automatically collect dependencies such as HTTP, SQL, and Azure SDK calls. These libraries hook into supported frameworks and client libraries using `DiagnosticSource` or equivalent mechanisms.

* In supported environments like [Azure App Services](codeless-app-service.md), [autoinstrumentation](codeless-overview.md) is available and enabled by default, injecting telemetry collectors at runtime without code changes.

* In other environments, developers can manually configure instrumentation using the *Azure.Monitor.OpenTelemetry.\** packages and OpenTelemetry APIs to control which dependencies are tracked and how they're enriched or filtered.

## Manually track dependencies

You can manually track dependencies when automatic collection doesn't meet your needs.

To learn how to manually track dependencies, see [Add and modify Azure Monitor OpenTelemetry for .NET, Java, Node.js, and Python applications](opentelemetry-add-modify.md#included-instrumentation-libraries).

> [!NOTE]
> For webpages, you can enable [Real User Monitoring](javascript-sdk.md) with the Application Insights JavaScript SDK.

## Where to find dependency data

The following tools and views in Application Insights make it easy to explore and analyze dependency telemetry:

| Views | Description |
|-------|-------------|
| [Application Map](app-map.md) | Offers a visual representation of your application's dependencies and their relationships with external services. |
| [Transaction Diagnostics](failures-performance-transactions.md#transaction-diagnostics-experience) | Displays end-to-end transaction details, correlating server-side operations with dependency calls. |
| **Browser** tab in [failures and performance views](failures-performance-transactions.md#analyze-client-side-performance-and-failures) | Highlights AJAX calls from client browsers. |
| **Server** tab in [failures and performance views](failures-performance-transactions.md#analyze-client-side-performance-and-failures) | Lets you drill into slow or failed server requests and inspect related dependency calls.<br><br>See examples for [trace from requests to dependencies](#trace-from-requests-to-dependencies) and [failed requests associated with failed calls to dependencies](#failed-requests). |
| [Azure Monitor Logs](../logs/data-platform-logs.md) | Enables advanced querying and analytics on dependency telemetry.<br><br>See [examples to track dependencies using KQL](#logs-analytics). |

## Diagnose slow requests

Each request event is associated with the dependency calls, exceptions, and other events tracked while processing the request. So, if some requests are doing badly, you can find out whether it's because of slow responses from a dependency.

### Trace from requests to dependencies

Select the left-hand **Performance** tab and select the **Dependencies** tab at the top.

Select a **Dependency Name** under **Overall**. After you select a dependency, it shows a graph of that dependency's distribution of durations.

:::image type="content" source="media/dependencies/perf-dependencies.png" lightbox="media/dependencies/perf-dependencies.png" alt-text="Screenshot that shows the Dependencies tab open to select a Dependency Name in the chart.":::

Select the **Samples** button at the bottom right. Then select a sample to see the end-to-end transaction details.

:::image type="content" source="media/dependencies/end-to-end.png" lightbox="media/dependencies/end-to-end.png" alt-text="Screenshot that shows selecting a sample to see the end-to-end transaction details.":::

## Failed requests

Failed requests might also be associated with failed calls to dependencies.

Select the left-hand **Failures** tab and then select the **Dependencies** tab at the top.

:::image type="content" source="media/dependencies/fail.png" lightbox="media/dependencies/fail.png" alt-text="Screenshot that shows selecting the failed requests chart.":::

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

* Review frequently asked questions in our [Dependency tracking FAQ](application-insights-faq.yml#dependency-tracking).
* See the [data model](data-model-complete.md) for Application Insights.
* Check out [platforms](app-insights-overview.md#supported-languages) supported by Application Insights.
