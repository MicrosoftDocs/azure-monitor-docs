---
title: Failures and performance views in Application Insights | Microsoft Docs
description: Monitor application performance and failures with Application Insights.
ms.topic: how-to
ms.date: 03/26/2025
ms.reviewer: cogoodson
---

# Failures and performance views

[Application Insights](app-insights-overview.md) collects telemetry from your application to help diagnosing failures and investigating slow transactions. It includes two essential tools:

* The **Failures** experience, which tracks errors, exceptions, and faults, offering clear insights for fast problem-solving and enhanced stability.

* The **Performance** experience, which quickly identifies and helps resolve application bottlenecks by displaying response times and operation counts.

Together, these tools ensure the ongoing health and efficiency of web applications. You can use them to pinpoint issues or enhancements that would have the most impact on users.

### [Failures view](#tab/failures-view)

To get to the **Failures** view in Application Insights, select either the **Failed requests** graph on the **Overview** pane, or **Failures** under the **Investigate** category in the resource menu.

:::image type="content" source="media/failures-and-performance-views/failures-view-go-to.png" lightbox="media/failures-and-performance-views/failures-view-go-to.png" alt-text="Screenshot showing how to reach the 'Failures' view in Application Insights.":::

You can also get to the failures view from the [Application Map](app-map.md) by selecting a resource, then **Investigate failures** from the triage section.

### [Performance view](#tab/performance-view)

To get to the **Performance** view in Application Insights, select either the **Server response time** or **Server requests** graph in the **Overview** pane, or **Performance** under the **Investigate** category in the resource menu.

:::image type="content" source="media/failures-and-performance-views/performance-view-go-to.png" lightbox="media/failures-and-performance-views/performance-view-go-to.png" alt-text="Screenshot showing how to reach the 'Performance' view in Application Insights.":::

You can also get to the performance view from the [Application Map](app-map.md) by selecting a resource, then **Investigate performance** from the triage section.

---

## Overview

### [Failures view](#tab/failures-view)

The **Failures** view shows a list of all failed operations collected for your application with the option to drill into each one. It lets you view their frequency and the number of users affected, to help you focus your efforts on the issues with the highest impact.

:::image type="content" source="media/failures-and-performance-views/failures-view.png" lightbox="media/failures-and-performance-views/failures-view.png" alt-text="Screenshot showing the 'Failures' view in Application Insights.":::

### [Performance view](#tab/performance-view)

The **Performance** view shows a list of all operations collected for your application with the option to drill into each one. It lets you view their count and average duration, to help you focus your efforts on the issues with the highest impact.

:::image type="content" source="media/failures-and-performance-views/performance-view.png" lightbox="media/failures-and-performance-views/performance-view.png" alt-text="Screenshot showing the 'Performance' view in Application Insights.":::

---

## Investigate

### [Failures view](#tab/failures-view)

To investigate the root cause of an error or exception, you can drill into the problematic operation for a detailed end-to-end transaction details view that includes dependencies and exception details.

1. Select an operation to view the **Top 3 response codes**, **Top 3 exception types**, and **Top 3 failed dependencies** for that operation.

1. Under **Drill into**, select the button with the number of filtered results to view a list of sample operations.

1. Select a sample operation to open the **End-to-end transaction details** view.

	:::image type="content" source="media/failures-and-performance-views/failures-view-drill-into.png" lightbox="media/failures-and-performance-views/failures-view-drill-into.png" alt-text="Screenshot showing the 'Failures' view with the 'Drill into' button highlighted.":::

	> [!NOTE]
	> The **Suggested** samples have related telemetry from all components, even if sampling was in effect in any of them.

### [Performance view](#tab/performance-view)

To investigate the root cause of a performance issue, you can drill into the problematic operation for a detailed end-to-end transaction details view that includes dependencies and exception details.

1. Select an operation to view the **Distribution of durations** for different requests of that operation, and additional **Insights**.

1. Under **Drill into**, select the button with the number of filtered results to view a list of sample operations.

1. Select a sample operation to open the **End-to-end transaction details** view.

	:::image type="content" source="media/failures-and-performance-views/performance-view-drill-into.png" lightbox="media/failures-and-performance-views/performance-view-drill-into.png" alt-text="Screenshot showing the 'Performance' view with the 'Drill into' button highlighted.":::

	> [!NOTE]
	> The **Suggested** samples have related telemetry from all components, even if sampling was in effect in any of them.

---

## End-to-end transaction details

The **End-to-end transaction details** view shows a Gantt chart of the transaction, which lists all events with their duration and response code. Selecting a specific event reveals its properties, including additional information like the underlying command or call stack.

:::image type="content" source="media/failures-and-performance-views/transaction-view.png" lightbox="media/failures-and-performance-views/transaction-view.png" alt-text="Screenshot showing the 'End-to-end transaction details' view.":::

### Debug Snapshot

To see code-level debug information of an exception:

1. Select the exception in the Gantt chart, then **Open debug snapshot**.

    :::image type="content" source="media/failures-and-performance-views/transaction-view-open-debugger.png" lightbox="media/failures-and-performance-views/transaction-view-open-debugger.png" alt-text="Screenshot showing the 'End-to-end transaction details' view with the 'Open debug snapshot' button highlighted.":::

1. [Snapshot Debugger](../snapshot-debugger/snapshot-debugger.md) shows the call stack and allows you to inspect variables at each call stack frame. By selecting a method, you can view the values of all local variables at the time of the request.

1. Afterwards, you can debug the source code by downloading the snapshot and opening it in Visual Studio.

    :::image type="content" source="media/failures-and-performance-views/debug-snapshot.png" lightbox="media/failures-and-performance-views/debug-snapshot.png" alt-text="Screenshot showing Snapshot Debugger with the 'Download Snapshot' button highlighted.":::

### Create a work item

If you connect Application Insights to a tracking system such as Azure DevOps or GitHub, you can create a work item directly from Application Insights.

1. Select **Create work item** and create a new template or pick an existing one.

    :::image type="content" source="media/failures-and-performance-views/transaction-view-create-work-item.png" lightbox="media/failures-and-performance-views/transaction-view-create-work-item.png" alt-text="Screenshot showing the 'End-to-end transaction details' view with the 'Create work item' button highlighted.":::

1. The **New Work Item** pane opens with details about the exception already populated. You can add more information before you save it.

## Use analytics data

All data collected by Application Insights is stored in [Log Analytics](../logs/log-analytics-overview.md), which provides a rich query language to analyze the requests that generated the exception you're investigating.

> [!TIP]
> [Simple mode](../logs/log-analytics-simple-mode.md) in Log Analytics offers an intuitive point-and-click interface for analyzing and visualizing log data.

1. On either the performance or failures view, select **View in Logs** in the top navigation bar and pick a query from the dropdown menu.

    :::image type="content" source="media/failures-and-performance-views/logs-view-go-to.png" lightbox="media/failures-and-performance-views/logs-view-go-to.png" alt-text="Screenshot of the top action bar with the 'View in logs' button highlighted.":::

1. This takes you to the **Logs** view, where you can further modify the query or select a different one from the sidebar.

    :::image type="content" source="media/failures-and-performance-views/logs-view.png" lightbox="media/failures-and-performance-views/logs-view.png" alt-text="Screenshot showing the 'Logs' view.":::

## Profiler traces

The [.NET Profiler](../insights/code-optimizations-profiler-overview.md#enabling-net-profiler) helps get further with code-level diagnostics by showing the actual code that ran for the operation and the time required for each step. Some operations might not have a trace because the Profiler runs periodically. Over time, more operations should have traces.

1. To start .NET Profiler, select an operation on the **Performance** view, then go to **Profiler traces**.

    :::image type="content" source="media/failures-and-performance-views/performance-view-profiler.png" lightbox="media/failures-and-performance-views/performance-view-profiler.png" alt-text="Screenshot of the 'Performance' view with the 'Profiler traces' button highlighted.":::

    Alternatively, you can do so on the [end-to-end transaction details](#end-to-end-transaction-details)  view.

    :::image type="content" source="media/failures-and-performance-views/transaction-view-profiler.png" lightbox="media/failures-and-performance-views/transaction-view-profiler.png" alt-text="Screenshot showing the 'End-to-end transaction details' view with the 'Profiler traces' button highlighted.":::

1. The trace shows the individual events for each operation so that you can diagnose the root cause for the duration of the overall operation. Select one of the top examples that has the longest duration.

1. Select the link in the **Performance Tip** (in this example, **CPU time**) for documentation on interpreting the event.

1. For further analysis, select **Download Trace** to download the trace. You can view this data by using [PerfView](https://github.com/Microsoft/perfview#perfview-overview).

    :::image type="content" source="media/failures-and-performance-views/profiler-traces.png" lightbox="media/failures-and-performance-views/profiler-traces.png" alt-text="Screenshot showing .NET Profiler.":::

    > [!NOTE]
    > **Hot path** is selected by default. It highlights the specific path of events that contribute to the issue you're investigating, indicated by the flame icon next the event name.

## Analyze client-side performance and failures

If you instrument your web pages with Application Insights, you can gain visibility into page views, browser operations, and dependencies. Collecting this browser data requires [adding a script to your web pages](javascript-sdk.md#add-the-javascript-code).

1. After you add the script, you can access page views and their associated performance metrics by selecting the **Browser** toggle on the **Performance** or **Failures** view.

    :::image type="content" source="media/failures-and-performance-views/server-browser-toggle.png" lightbox="media/failures-and-performance-views/server-browser-toggle.png" alt-text="Screenshot highlighting the 'Server / Browser' toggle below the top action bar.":::

    This view provides a visual summary of various telemetries of your application from the perspective of the browser.

1. For browser operations, the [end-to-end transaction details](#end-to-end-transaction-details) view shows **Page View Properties** of the client requesting the page, including the type of browser and its location. This information can assist in determining whether there are performance issues related to particular types of clients.

    :::image type="content" source="media/failures-and-performance-views/transaction-view-page-view-properties.png" lightbox="media/failures-and-performance-views/transaction-view-page-view-properties.png" alt-text="Screenshot showing the 'End-to-end transaction details' view with the 'Page View Properties' section highlighted.":::

> [!NOTE]
> Like the data collected for server performance, Application Insights makes all client data available for deep analysis by using logs.

## Next steps

* Learn more about using [Application Map](app-map.md) to spot performance bottlenecks and failure hotspots across all components of your application.
* Learn more about using the [Availability view](availability-overview.md) to set up recurring tests to monitor availability and responsiveness for your application.
