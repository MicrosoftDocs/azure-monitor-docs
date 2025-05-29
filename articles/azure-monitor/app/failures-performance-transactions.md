---
title: Failures and performance views in Application Insights | Microsoft Docs
description: Monitor application performance and failures with Application Insights.
ms.topic: how-to
ms.date: 03/26/2025
ms.reviewer: cogoodson
---

# Investigate failures, performance, and transactions

[Application Insights](app-insights-overview.md) collects telemetry from your application to help diagnosing failures and investigating slow transactions. It includes four essential tools:

* The **Failures** experience, which tracks errors, exceptions, and faults, offering clear insights for fast problem-solving and enhanced stability.

* The **Performance** experience, which quickly identifies and helps resolve application bottlenecks by displaying response times and operation counts.

* The **Transaction search** experience, which enables users to locate and examine individual telemetry items such as page views, exceptions, and custom events.

* The **Transaction diagnostics** experience, which helps to quickly identify issues in components through comprehensive insight into end-to-end transaction details.

Together, these tools ensure the ongoing health and efficiency of web applications. You can use them to pinpoint issues or enhancements that would have the most impact on users.

### [Failures view](#tab/failures-view)

To get to the **Failures** view in Application Insights, select either the **Failed requests** graph on the **Overview** pane, or **Failures** under the **Investigate** category in the resource menu.

:::image type="content" source="media/failures-performance-transactions/failures-view-go-to.png" lightbox="media/failures-performance-transactions/failures-view-go-to.png" alt-text="Screenshot showing how to reach the 'Failures' view in Application Insights.":::

You can also get to the failures view from the [Application Map](app-map.md) by selecting a resource, then **Investigate failures** from the triage section.

### [Performance view](#tab/performance-view)

To get to the **Performance** view in Application Insights, select either the **Server response time** or **Server requests** graph on the **Overview** pane, or **Performance** under the **Investigate** category in the resource menu.

:::image type="content" source="media/failures-performance-transactions/performance-view-go-to.png" lightbox="media/failures-performance-transactions/performance-view-go-to.png" alt-text="Screenshot showing how to reach the 'Performance' view in Application Insights.":::

You can also get to the performance view from the [Application Map](app-map.md) by selecting a resource, then **Investigate performance** from the triage section.

### [Transaction search](#tab/transaction-search)

To get to the **Transaction search** view in Application Insights, select either **Search** from the command bar on the **Overview** pane, or **Transaction search** under the **Investigate** category in the resource menu.

:::image type="content" source="media/failures-performance-transactions/transaction-search-go-to.png" lightbox="media/failures-performance-transactions/transaction-search-go-to.png" alt-text="Screenshot showing how to reach the 'Transaction search' view in Application Insights.":::

---

> [!NOTE]
> You can access **Transaction diagnostics** through any of the other three experiences. For more information, see [Investigate telemetry](#investigate-telemetry).

## Overview

### [Failures view](#tab/failures-view)

The **Failures** view shows a list of all failed operations collected for your application with the option to drill into each one. It lets you view their frequency and the number of users affected, to help you focus your efforts on the issues with the highest impact.

:::image type="content" source="media/failures-performance-transactions/failures-view.png" lightbox="media/failures-performance-transactions/failures-view.png" alt-text="Screenshot showing the 'Failures' view in Application Insights.":::

### [Performance view](#tab/performance-view)

The **Performance** view shows a list of all operations collected for your application with the option to drill into each one. It lets you view their count and average duration, to help you focus your efforts on the issues with the highest impact.

:::image type="content" source="media/failures-performance-transactions/performance-view.png" lightbox="media/failures-performance-transactions/performance-view.png" alt-text="Screenshot showing the 'Performance' view in Application Insights.":::

### [Transaction search](#tab/transaction-search)

**Transaction search** allows you to find and explore individual telemetry items. You can select which event types to view from the **Event types** dropdown menu, including:

* **Availability**: Results of [availability tests](availability-overview.md).
* **Custom Event**: If you inserted calls to `TrackEvent()` to [monitor usage](api-custom-events-metrics.md), you can search them here.
* **Dependency**: [Calls from your server application](asp-net-dependencies.md) to other services such as REST APIs or databases, and AJAX calls from your [client code](javascript.md).
* **Exception**: Uncaught [exceptions in the server](asp-net-exceptions.md), and the exceptions that you log by using `TrackException()`.
* **Page View**: [Telemetry sent by the web client](javascript.md) used to create page view reports.
* **Request**: HTTP requests received by your server application including pages, scripts, images, style files, and data. These events are used to create the request and response overview charts.
* **Trace**: [Diagnostic logs](asp-net-trace-logs.md) including TrackTrace, log4Net, NLog, and System.Diagnostic.Trace calls.

If you want to restore the filters later, select **Reset**.

:::image type="content" source="media/failures-performance-transactions/transaction-search.png" lightbox="media/failures-performance-transactions/transaction-search.png" alt-text="Screenshot showing the 'Transaction search' view in Application Insights.":::

---

## Filter telemetry

You can filter events on the values of their properties. The available properties depend on the event or telemetry types you selected. To add a filter:

1. Select **Filter** :::image type="content" source="media/failures-performance-transactions/transaction-search-filter-icon.png" lightbox="media/failures-performance-transactions/transaction-search-filter-icon.png" alt-text="Filter icon" border="false"::: to start.

1. From the left dropdown list :::image type="content" source="media/failures-performance-transactions/filter-left-drop-down.png" lightbox="media/failures-performance-transactions/filter-left-drop-down.png" alt-text="Added filter with left field highlighted." border="false":::, select a property.

1. From the center dropdown list :::image type="content" source="media/failures-performance-transactions/filter-center-drop-down.png" lightbox="media/failures-performance-transactions/filter-center-drop-down.png" alt-text="Added filter with center field highlighted." border="false":::, select one of the following operators: `=`, `!=`, `contains`, or `not contains`.

1. From the right dropdown list :::image type="content" source="media/failures-performance-transactions/filter-right-drop-down.png" lightbox="media/failures-performance-transactions/filter-right-drop-down.png" alt-text="Added filter with right field highlighted." border="false":::, select all property values you want to filter on.

    > [!NOTE]
    > Notice that the counts to the right of the filter values show how many occurrences there are in the current filtered set.

1. To add additional filters, select **Filter** :::image type="content" source="media/failures-performance-transactions/transaction-search-filter-icon.png" lightbox="media/failures-performance-transactions/transaction-search-filter-icon.png" alt-text="Filter icon" border="false"::: again.

## Send more telemetry data to Application Insights

In addition to the out-of-the-box telemetry sent by Application Insights SDK, you can:

* Capture log traces from your favorite logging framework in [.NET](asp-net-trace-logs.md) or [Java](opentelemetry-add-modify.md?tabs=java). This means you can search through your log traces and correlate them with page views, exceptions, and other events.

* [Write code](api-custom-events-metrics.md) to send custom events, page views, and exceptions.

Learn how to [send logs and custom telemetry to Application Insights](asp-net-trace-logs.md).

## Search telemetry

> [!NOTE]
> To write more complex queries, see [Use analytics data](#use-analytics-data).

### [Failures view](#tab/failures-view)

You can search for specific operations using the **Search to filter items...** field above the operations list.

:::image type="content" source="media/failures-performance-transactions/failures-view-search.png" lightbox="media/failures-performance-transactions/failures-view-search.png" alt-text="Screenshot that shows the 'Search' field.":::

### [Performance view](#tab/performance-view)

You can search for specific operations using the **Search to filter items...** field above the operations list.

:::image type="content" source="media/failures-performance-transactions/performance-view-search.png" lightbox="media/failures-performance-transactions/performance-view-search.png" alt-text="Screenshot that shows the 'Search' field.":::

### [Transaction search](#tab/transaction-search)

You can search for terms in any of the property values. This capability is useful if you write [custom events](api-custom-events-metrics.md) with property values.

> [!TIP]
> You might want to set a time range because searches over a shorter range are faster.

:::image type="content" source="media/failures-performance-transactions/transaction-search-property.png" lightbox="media/failures-performance-transactions/transaction-search-property.png" alt-text="Screenshot that shows opening a diagnostic search.":::

Search for complete words, not substrings. Use quotation marks to enclose special characters.

| String               | *Not* found                       | Found                                                               |
|----------------------|-----------------------------------|---------------------------------------------------------------------|
| HomeController.About | `home`<br/>`controller`<br/>`out` | `homecontroller`<br/>`about`<br/>`"homecontroller.about"`           |
| United States        | `Uni`<br/>`ted`                   | `united`<br/>`states`<br/>`united AND states`<br/>`"united states"` |

You can use the following search expressions:

| Sample query                           | Effect                                                                              |
|----------------------------------------|-------------------------------------------------------------------------------------|
| `apple`                                | Find all events in the time range whose fields include the word `apple`.            |
| `apple AND banana` <br/>`apple banana` | Find events that contain both words. Use capital `AND`, not `and`. <br/>Short form. |
| `apple OR banana`                      | Find events that contain either word. Use `OR`, not `or`.                           |
| `apple NOT banana`                     | Find events that contain one word but not the other.                                |

> [!NOTE]
> If your app generates significant telemetry and uses ASP.NET SDK version 2.0.0-beta3 or later, it automatically reduces the volume sent to the portal through adaptive sampling. This module sends only a representative fraction of events. It selects or deselects events related to the same request as a group, allowing you to navigate between related events.
>
> Learn about [sampling](sampling.md).

---

## Use analytics data

All data collected by Application Insights is stored in [Log Analytics](../logs/log-analytics-overview.md), which provides a rich query language to analyze the requests that generated the exception you're investigating.

> [!TIP]
> [Simple mode](../logs/log-analytics-simple-mode.md) in Log Analytics offers an intuitive point-and-click interface for analyzing and visualizing log data.

1. On either the performance, failures, or transaction search view, select **View in Logs** in the top navigation bar and pick a query from the dropdown menu.

    :::image type="content" source="media/failures-performance-transactions/logs-view-go-to.png" lightbox="media/failures-performance-transactions/logs-view-go-to.png" alt-text="Screenshot of the top action bar with the 'View in logs' button highlighted.":::

1. This takes you to the **Logs** view, where you can further modify the query or select a different one from the sidebar.

    :::image type="content" source="media/failures-performance-transactions/logs-view.png" lightbox="media/failures-performance-transactions/logs-view.png" alt-text="Screenshot showing the 'Logs' view.":::

## Investigate telemetry

### [Failures view](#tab/failures-view)

To investigate the root cause of an error or exception, you can drill into the problematic operation for a detailed end-to-end transaction details view that includes dependencies and exception details.

1. Select an operation to view the **Top 3 response codes**, **Top 3 exception types**, and **Top 3 failed dependencies** for that operation.

1. Under **Drill into**, select the button with the number of filtered results to view a list of sample operations.

1. Select a sample operation to open the **End-to-end transaction details** view.

	:::image type="content" source="media/failures-performance-transactions/failures-view-drill-into.png" lightbox="media/failures-performance-transactions/failures-view-drill-into.png" alt-text="Screenshot showing the 'Failures' view with the 'Drill into' button highlighted.":::

	> [!NOTE]
	> The **Suggested** samples have related telemetry from all components, even if sampling was in effect in any of them.

### [Performance view](#tab/performance-view)

To investigate the root cause of a performance issue, you can drill into the problematic operation for a detailed end-to-end transaction details view that includes dependencies and exception details.

1. Select an operation to view the **Distribution of durations** for different requests of that operation, and additional **Insights**.

1. Under **Drill into**, select the button with the number of filtered results to view a list of sample operations.

1. Select a sample operation to open the **End-to-end transaction details** view.

	:::image type="content" source="media/failures-performance-transactions/performance-view-drill-into.png" lightbox="media/failures-performance-transactions/performance-view-drill-into.png" alt-text="Screenshot showing the 'Performance' view with the 'Drill into' button highlighted.":::

	> [!NOTE]
	> The **Suggested** samples have related telemetry from all components, even if sampling was in effect in any of them.

### [Transaction search](#tab/transaction-search)

To investigate an event further, select any telemetry item to open the **End-to-end transaction details** view.

:::image type="content" source="media/failures-performance-transactions/transaction-search-telemetry-item.png" lightbox="media/failures-performance-transactions/transaction-search-telemetry-item.png" alt-text="Screenshot that shows an individual dependency request.":::

---

## Transaction diagnostics experience

The **Transaction diagnostics** experience, also called **End-to-end transaction details** view, shows a Gantt chart of the transaction, which lists all events with their duration and response code. 

This diagnostics experience automatically correlates server-side telemetry from across all your Application Insights monitored components into a single view and supports multiple resources. Application Insights detects the underlying relationship and allows you to easily diagnose the application component, dependency, or exception that caused a transaction slowdown or failure.

Selecting a specific event reveals its properties, including additional information like the underlying command or call stack.

This view has four key parts:

#### [Results list](#tab/results-list)

:::image type="content" source="media/failures-performance-transactions/transaction-view-results-list.png" lightbox="media/failures-performance-transactions/transaction-view-results-list.png" alt-text="Screenshot that shows the transaction view with the results list highlighted.":::

This collapsible pane shows the other results that meet the filter criteria. Select any result to update the respective details of the preceding three sections. We try to find samples that are most likely to have the details available from all components, even if sampling is in effect in any of them. These samples are shown as suggestions.

#### [Transaction chart](#tab/transaction-chart)

:::image type="content" source="media/failures-performance-transactions/transaction-view-transaction-chart.png" lightbox="media/failures-performance-transactions/transaction-view-transaction-chart.png" alt-text="Screenshot that shows the transaction view with the cross-component transaction chart highlighted.":::

This chart provides a timeline with horizontal bars during requests and dependencies across components. Any exceptions that are collected are also marked on the timeline.

* The top row on this chart represents the entry point. It's the incoming request to the first component called in this transaction. The duration is the total time taken for the transaction to complete.
* Any calls to external dependencies are simple noncollapsible rows, with icons that represent the dependency type.
* Calls to other components are collapsible rows. Each row corresponds to a specific operation invoked at the component.
* By default, the request, dependency, or exception that you selected appears to the side. Select any row to see its [details](/azure/azure-monitor/app/failures-performance-transactions?tabs=details#transaction-diagnostics-experience).

> [!NOTE]
> Calls to other components have two rows. One row represents the outbound call (dependency) from the caller component. The other row corresponds to the inbound request at the called component. The leading icon and distinct styling of the duration bars help differentiate between them.

#### [Time-sequence list](#tab/time-sequence-list)

:::image type="content" source="media/failures-performance-transactions/transaction-view-time-sequence-collapsed.png" lightbox="media/failures-performance-transactions/transaction-view-time-sequence-collapsed.png" alt-text="Screenshot that shows the transaction view with the collapsed time sequence section highlighted.":::

This section shows a flat list view in a time sequence of all the telemetry related to this transaction. It also shows the custom events and traces that aren't displayed in the transaction chart. You can filter this list to telemetry generated by a specific component or call. You can select any telemetry item in this list to see corresponding [details on the side](/azure/azure-monitor/app/failures-performance-transactions?tabs=details#transaction-diagnostics-experience).

**Expanded:**

:::image type="content" source="media/failures-performance-transactions/transaction-view-time-sequence-expanded.png" lightbox="media/failures-performance-transactions/transaction-view-time-sequence-expanded.png" alt-text="Screenshot that shows the transaction view with the expanded time sequence section highlighted.":::

#### [Details](#tab/details)

:::image type="content" source="media/failures-performance-transactions/transaction-view-details.png" lightbox="media/failures-performance-transactions/transaction-view-details.png" alt-text="Screenshot that shows the transaction view with the details section highlighted.":::

This collapsible pane shows the detail of any selected item from the transaction chart or the list. **Show all** lists all the standard attributes that are collected. Any custom attributes are listed separately under the standard set. Select the ellipsis button (...) under the **Call Stack** trace window to get an option to copy the trace. **Open profiler traces** and **Open debug snapshot** show code-level diagnostics in corresponding detail panes.

---

## .NET Profiler and Snapshot Debugger

[.NET Profiler](./profiler-overview.md) or [Snapshot Debugger](snapshot-debugger.md) help with code-level diagnostics of performance and failure issues. With this experience, you can see .NET Profiler traces or snapshots from any component with a single selection.

### Profiler traces

The [.NET Profiler](../insights/code-optimizations-profiler-overview.md#enabling-net-profiler) helps get further with code-level diagnostics by showing the actual code that ran for the operation and the time required for each step. Some operations might not have a trace because the Profiler runs periodically. Over time, more operations should have traces.

1. To start .NET Profiler, select an operation on the **Performance** view, then go to **Profiler traces**.

    :::image type="content" source="media/failures-performance-transactions/performance-view-profiler.png" lightbox="media/failures-performance-transactions/performance-view-profiler.png" alt-text="Screenshot of the 'Performance' view with the 'Profiler traces' button highlighted.":::

    Alternatively, you can do so on the [end-to-end transaction details](#transaction-diagnostics) view.

    :::image type="content" source="media/failures-performance-transactions/transaction-view-profiler.png" lightbox="media/failures-performance-transactions/transaction-view-profiler.png" alt-text="Screenshot showing the 'End-to-end transaction details' view with the 'Profiler traces' button highlighted.":::

1. The trace shows the individual events for each operation so that you can diagnose the root cause during overall operation. Select one of the top examples that has the longest duration.

1. Select the link in the **Performance Tip** (in this example, **CPU time**) for documentation on interpreting the event.

1. For further analysis, select **Download Trace** to download the trace. You can view this data by using [PerfView](https://github.com/Microsoft/perfview#perfview-overview).

    :::image type="content" source="media/failures-performance-transactions/profiler-traces.png" lightbox="media/failures-performance-transactions/profiler-traces.png" alt-text="Screenshot showing .NET Profiler.":::

    > [!NOTE]
    > **Hot path** is selected by default. It highlights the specific path of events that contribute to the issue you're investigating, indicated by the flame icon next the event name.

If you can't get the .NET Profiler working, contact [serviceprofilerhelp@microsoft.com](mailto:serviceprofilerhelp@microsoft.com).

### Debug Snapshot

To see code-level debug information of an exception:

1. Select the exception in the Gantt chart, then **Open debug snapshot**.

    :::image type="content" source="media/failures-performance-transactions/transaction-view-open-debugger.png" lightbox="media/failures-performance-transactions/transaction-view-open-debugger.png" alt-text="Screenshot showing the 'End-to-end transaction details' view with the 'Open debug snapshot' button highlighted.":::

1. [Snapshot Debugger](../snapshot-debugger/snapshot-debugger.md) shows the call stack and allows you to inspect variables at each call stack frame. By selecting a method, you can view the values of all local variables at the time of the request.

1. Afterwards, you can debug the source code by downloading the snapshot and opening it in Visual Studio.

    :::image type="content" source="media/failures-performance-transactions/debug-snapshot.png" lightbox="media/failures-performance-transactions/debug-snapshot.png" alt-text="Screenshot showing Snapshot Debugger with the 'Download Snapshot' button highlighted.":::

If you can't get Snapshot Debugger working, contact [snapshothelp@microsoft.com](mailto:snapshothelp@microsoft.com).

### Create a work item

If you connect Application Insights to a tracking system such as Azure DevOps or GitHub, you can create a work item with the details from any telemetry item directly from Application Insights.

> [!NOTE]
> The first time you do this step, you're asked to configure a link to your Azure DevOps organization and project.

1. Go to the **End-to-end transaction details** view and select an event.

1. In the **Details** section, select **Create work item** and create a new template or pick an existing one.

    :::image type="content" source="media/failures-performance-transactions/transaction-view-create-work-item.png" lightbox="media/failures-performance-transactions/transaction-view-create-work-item.png" alt-text="Screenshot showing the 'End-to-end transaction details' view with the 'Create work item' button highlighted.":::

1. The **New Work Item** pane opens with details about the exception already populated. You can add more information before you save it.

## Analyze client-side performance and failures

If you instrument your web pages with Application Insights, you can gain visibility into page views, browser operations, and dependencies. Collecting this browser data requires [adding a script to your web pages](javascript-sdk.md#add-the-javascript-code).

1. After you add the script, you can access page views and their associated performance metrics by selecting the **Browser** toggle on the **Performance** or **Failures** view.

    :::image type="content" source="media/failures-performance-transactions/server-browser-toggle.png" lightbox="media/failures-performance-transactions/server-browser-toggle.png" alt-text="Screenshot highlighting the 'Server / Browser' toggle below the top action bar.":::

    This view provides a visual summary of various telemetries of your application from the perspective of the browser.

1. For browser operations, the [end-to-end transaction details](#transaction-diagnostics) view shows **Page View Properties** of the client requesting the page, including the type of browser and its location. This information can help determining whether there are performance issues related to particular types of clients.

    :::image type="content" source="media/failures-performance-transactions/transaction-view-page-view-properties.png" lightbox="media/failures-performance-transactions/transaction-view-page-view-properties.png" alt-text="Screenshot showing the 'End-to-end transaction details' view with the 'Page View Properties' section highlighted.":::

> [!NOTE]
> Like the data collected for server performance, Application Insights makes all client data available for deep analysis by using logs.

## Frequently asked questions

This section provides answers to common questions.

### Transaction search

### What is a component?

Components are independently deployable parts of your distributed or microservice application. Developers and operations teams have code-level visibility or access to telemetry generated by these application components.

* Components are different from "observed" external dependencies, such as SQL and event hubs, which your team or organization might not have access to (code or telemetry).
* Components run on any number of server, role, or container instances.
* Components can be separate Application Insights instrumentation keys, even if subscriptions are different. Components also can be different roles that report to a single Application Insights instrumentation key. The new experience shows details across all components, regardless of how they were set up.

#### How much data is retained?

See the [Limits summary](../service-limits.md#application-insights).

#### How can I see POST data in my server requests?

We don't log the POST data automatically, but you can use [TrackTrace or log calls](./asp-net-trace-logs.md). Put the POST data in the message parameter. You can't filter on the message in the same way you can filter on properties, but the size limit is longer.

#### Why does my Azure Function search return no results?

Azure Functions doesn't log URL query strings.

### Transaction diagnostics

#### Why do I see a single component on the chart and the other components only show as external dependencies without any details?

Potential reasons:

* Are the other components instrumented with Application Insights?
* Are they using the latest stable Application Insights SDK?
* If these components are separate Application Insights resources, validate you have [access](../roles-permissions-security.md).
If you do have access and the components are instrumented with the latest Application Insights SDKs, let us know via the feedback channel in the upper-right corner.

#### I see duplicate rows for the dependencies. Is this behavior expected?

Currently, we're showing the outbound dependency call separate from the inbound request. Typically, the two calls look identical with only the duration value being different because of the network round trip. The leading icon and distinct styling of the duration bars help differentiate between them. Is this presentation of the data confusing? Give us your feedback!

#### What about clock skews across different component instances?

Timelines are adjusted for clock skews in the transaction chart. You can see the exact timestamps in the details pane or by using Log Analytics.

#### Why is the new experience missing most of the related items queries?

This behavior is by design. All the related items, across all components, are already available on the left side in the top and bottom sections. The new experience has two related items that the left side doesn't cover: all telemetry from five minutes before and after this event and the user timeline.

#### Is there a way to see fewer events per transaction when I use the Application Insights JavaScript SDK?

The transaction diagnostics experience shows all telemetry in a [single operation](distributed-trace-data.md#data-model-for-telemetry-correlation) that shares an [Operation ID](data-model-complete.md#context). By default, the Application Insights SDK for JavaScript creates a new operation for each unique page view. In a single-page application (SPA), only one page view event is generated and a single Operation ID is used for all telemetry generated. As a result, many events might be correlated to the same operation.

In these scenarios, you can use Automatic Route Tracking to automatically create new operations for navigation in your SPA. You must turn on [enableAutoRouteTracking](javascript.md#single-page-applications) so that a page view is generated every time the URL route is updated (logical page view occurs). If you want to manually refresh the Operation ID, call `appInsights.properties.context.telemetryTrace.traceID = Microsoft.ApplicationInsights.Telemetry.Util.generateW3CId()`. Manually triggering a PageView event also resets the Operation ID.

#### Why do transaction detail durations not add up to the top-request duration?

Time not explained in the Gantt chart is time that isn't covered by a tracked dependency. This issue can occur because external calls weren't instrumented, either automatically or manually. It can also occur because the time taken was in process rather than because of an external call.

If all calls were instrumented, in process is the likely root cause for the time spent. A useful tool for diagnosing the process is the [.NET Profiler](./profiler-overview.md).

#### What if I see the message ***Error retrieving data*** while navigating Application Insights in the Azure portal? 

This error indicates that the browser was unable to call into a required API or the API returned a failure response. To troubleshoot the behavior, open a browser [InPrivate window](https://support.microsoft.com/microsoft-edge/browse-inprivate-in-microsoft-edge-cd2c9a48-0bc4-b98e-5e46-ac40c84e27e2) and [disable any browser extensions](https://support.microsoft.com/microsoft-edge/add-turn-off-or-remove-extensions-in-microsoft-edge-9c0ec68c-2fbc-2f2c-9ff0-bdc76f46b026) that are running, then identify if you can still reproduce the portal behavior. If the portal error still occurs, try testing with other browsers, or other machines, investigate DNS or other network related issues from the client machine where the API calls are failing. If the portal error continues and needs to be investigated further, [collect a browser network trace](/azure/azure-portal/capture-browser-trace#capture-a-browser-trace-for-troubleshooting) while reproducing the unexpected portal behavior, then open a support case from the Azure portal.

## Next steps

* Learn more about using [Application Map](app-map.md) to spot performance bottlenecks and failure hotspots across all components of your application.
* Learn more about using the [Availability view](availability-overview.md) to set up recurring tests to monitor availability and responsiveness for your application.
* Learn how to [write complex queries in Analytics](../logs/log-analytics-tutorial.md) to gain deeper insights from your telemetry data.
* Learn how to [send logs and custom telemetry to Application Insights](./asp-net-trace-logs.md) for more comprehensive monitoring.
* For an introduction to monitoring uptime and responsiveness, see the [Availability overview](availability-overview.md).
