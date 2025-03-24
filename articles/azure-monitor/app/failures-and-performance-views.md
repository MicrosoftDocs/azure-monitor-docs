---
title: Failures and Performance views in Application Insights | Microsoft Docs
description: Monitor application performance and failures with Application Insights.
ms.topic: conceptual
ms.date: 02/15/2024
ms.reviewer: cogoodson 
---

# Failures and Performance views

[Application Insights](app-insights-overview.md) comes with a curated Application Performance Management (APM) experience to help you diagnose failures and investigate slow transactions in your monitored applications. It includes two essential tools:

*  The **Failures** view tracks errors, exceptions, and faults, offering clear insights for fast problem-solving and enhanced stability.

* The **Performance** view quickly identifies and helps resolve application bottlenecks by displaying response times and operation counts.

Together, they ensure the ongoing health and efficiency of web applications.

### [Failures view](#tab/failures-view)

To get to the **Failures** experience in Application Insights, select either the **Failed requests** graph on the **Overview** pane, or the **Failures** option under the **Investigate** category in the resource menu.

:::image type="content" source="media/failures-and-performance-views/failures-view-go-to.png" lightbox="media/failures-and-performance-views/failures-view-go-to.png" alt-text="Screenshot showing how to reach the failures view in Application Insights.":::

You can also get to the failures pane from the [Application Map](app-map.md) by selecting **Investigate failures** from the triage pane.
<!--
:::image type="content" source="media/failures-and-performance-views/failures-app-map.png" lightbox="media/failures-and-performance-views/failures-app-map.png" alt-text="Screenshot showing how to reach the failures view from the application map.":::
-->
### [Performance view](#tab/performance-view)

To get to the **Performance** experience in Application Insights, select either the **Server response time** or **Server requests** graph in the **Overview** pane, or the **Performance** option under the **Investigate** category in the resource menu.

:::image type="content" source="media/failures-and-performance-views/performance-view-go-to.png" lightbox="media/failures-and-performance-views/performance-view-go-to.png" alt-text="Screenshot showing how to reach the performance view in Application Insights.":::

You can also get to the performance pane from the [Application Map](app-map.md) by selecting **Investigate performance** from the triage pane.
<!--
:::image type="content" source="media/failures-and-performance-views/performance-app-map.png" lightbox="media/failures-and-performance-views/performance-app-map.png" alt-text="Screenshot showing how to reach the performance view from the application map.":::
-->
---

## Overview

### [Failures view](#tab/failures-view)

The **Failures** view shows a list of all failed operations collected for your application with the option to drill into each one. It lets you view their frequency and the number of users affected, to help you focus your efforts on the issues with the highest impact.

You're also prompted with automatically identified anomalies and commonalities across transactions.

:::image type="content" source="media/failures-and-performance-views/failures-view.png" lightbox="media/failures-and-performance-views/failures-view.png" alt-text="Screenshot of the failures view in Application Insights.":::

### [Performance view](#tab/performance-view)

The **Performance** view shows the count and average duration of each operation for the application. You can use this information to identify those operations that affect users the most.

For example, by identifying the operations with the longest duration, you can diagnose potential problems or target your ongoing development to improve the overall performance of the application.

You're also prompted with automatically identified anomalies and commonalities across transactions.

:::image type="content" source="media/failures-and-performance-views/performance-view.png" lightbox="media/failures-and-performance-views/performance-view.png" alt-text="Screenshot showing the performance view in Application Insights.":::

---

## Investigate

### [Failures view](#tab/failures-view)

To investigate the root cause of an error or exception, you can drill into the problematic operation for a detailed end-to-end transaction view that includes dependencies and exception details.

1. Select an operation to show more information about it in the right pane.

1. Under **Drill into**, select the button with the number of filtered results to view a list of sample operations.

1. Select a sample operation to open the **End-to-end transaction details** view.

	:::image type="content" source="media/failures-and-performance-views/failures-view-drill-into.png" lightbox="media/failures-and-performance-views/failures-view-drill-into.png" alt-text="Screenshot of the failures view with the 'Drill into' button highlighted.":::

	> [!NOTE]
	> The **Suggested** samples have related telemetry from all components, even if sampling might have been in effect in any of them.

### [Performance view](#tab/performance-view)

To investigate the root cause of a performance issue, you can drill into the problematic operation for a detailed end-to-end transaction view that includes dependencies and exception details.

1. Selecting an operation opens a panel which shows the **Distribution of durations** for different requests for the selected operation, and additional **Insights**.

1. Under **Drill into**, select the button with the number of filtered results to view a list of sample operations.

1. Select a sample operation to open the **End-to-end transaction details** view.

	:::image type="content" source="media/failures-and-performance-views/performance-view-drill-into.png" lightbox="media/failures-and-performance-views/performance-view-drill-into.png" alt-text="Screenshot showing the performance view with the 'Drill into' button highlighted.":::

	> [!NOTE]
	> The **Suggested** samples have related telemetry from all components, even if sampling might have been in effect in any of them.

---

## End-to-end transaction details

The end-to-end tranasction view shows a Gantt chart of the transaction. Selecting an exception shows more information like **Exception Properties** and the **Call Stack**. Additionally, you can **Open debug snapshot** to see code-level debug information of the exception.

:::image type="content" source="media/failures-and-performance-views/failures-exception-open-debugger.png" lightbox="media/failures-and-performance-views/failures-exception-open-debugger.png" alt-text="Screenshot showing the end-to-end transaction with 'Open debug snapshot' highlighted.":::

### Debug Snapshot

The Debug Snapshot view shows the call stack and allows you to inspect variables at each call stack frame. By selecting a method, you can view the values of all local variables at the time of the request. Afterward, you can debug the source code by downloading the snapshot and opening it in Visual Studio.

:::image type="content" source="media/failures-and-performance-views/failures-debug-snapshot-details.png" lightbox="media/failures-and-performance-views/failures-debug-snapshot-details.png" alt-text="Screenshot showing the debug snapshot view with the 'Download snapshot' button highlighted.":::

### Add a work item

If you connect Application Insights to a tracking system, such as Azure DevOps or GitHub, you can create a work item directly from Application Insights.

Select **Create work item** and create a new template or pick an existing one.

:::image type="content" source="media/failures-and-performance-views/performance-transaction-view-create-work-item.png" lightbox="media/failures-and-performance-views/performance-transaction-view-create-work-item.png" alt-text="Screenshot showing the 'Create work item' button highlighted.":::

The **New Work Item** pane opens with details about the exception already populated. You can add more information before you save it.

## Use analytics data

All data collected by Application Insights is stored in Log Analytics, which provides a rich query language that you can use to analyze the requests that generated the exception you're researching.

On either the performance or failures view, select **View in Logs** in the top navigation bar and pick a query from the dropdown menu.

:::image type="content" source="media/failures-and-performance-views/view-in-logs.png" lightbox="media/failures-and-performance-views/view-in-logs.png" alt-text="Screenshot highlighting 'View in logs' in the top action bar.":::

This takes you to the **Logs** view where you can further modify the query or select a different one from the sidebar.

:::image type="content" source="media/failures-and-performance-views/performance-logs.png" lightbox="media/failures-and-performance-views/performance-logs.png" alt-text="Screenshot showing logs when reached from the performance view.":::

## Profiler traces

The Profiler helps get further with code-level diagnostics by showing the actual code that ran for the operation and the time required for each step. Some operations might not have a trace because the Profiler runs periodically. Over time, more operations should have traces.

1. To start the Profiler for the operation, select **Profiler traces**.

    :::image type="content" source="media/failures-and-performance-views/performance-profiler-traces-button.png" lightbox="media/failures-and-performance-views/performance-profiler-traces-button.png" alt-text="Screenshot highlighting the 'Profiler traces' button on the Performance pane.":::

1. The trace shows the individual events for each operation so that you can diagnose the root cause for the duration of the overall operation. Select one of the top examples that has the longest duration.

    :::image type="content" source="media/failures-and-performance-views/performance-profiler-traces.png" lightbox="media/failures-and-performance-views/performance-profiler-traces.png" alt-text="Screenshot showing the profiler traces feature.":::

    > [!NOTE]
    > **Hot path** is selected by default. It highlights (indicated by the flame icon to the left of the event name) the specific path of events that contribute to the issue you're investigating.

1. Select the link in the **Performance Tip** (in this example, **CPU time**) for documentation on interpreting the event.

1. For further analysis, select **Download Trace** to download the trace. You can view this data by using [PerfView](https://github.com/Microsoft/perfview#perfview-overview).

### Identify slow client operations

If you instrument your web pages with Application Insights, you can also gain visibility into page views, browser operations, and dependencies. Collecting this browser data requires adding a script to your web pages.

After you add the script, you can access page views and their associated performance metrics by selecting the **Browser** toggle on the **Performance** or **Failures** pane. This view provides a visual summary of various telemetries of your application from the perspective of the browser.

The End-to-end transaction details open on the right side where you can view the **Page View Properties**. You can view details of the client requesting the page including the type of browser and its location. This information can assist you in determining whether there are performance issues related to particular types of clients.

> [!NOTE]
> Like the data collected for server performance, Application Insights makes all client data available for deep analysis by using logs.

:::image type="content" source="media/failures-and-performance-views/performance-transaction-view.png" lightbox="media/failures-and-performance-views/performance-transaction-view.png" alt-text="Screenshot showing the end-to-end transaction view.":::

## Next steps

* Learn more about using [Application Map](app-map.md) to spot performance bottlenecks and failure hotspots across all components of your application.
* Learn more about using the [Availability view](availability-overview.md) to set up recurring tests to monitor availability and responsiveness for your application.
