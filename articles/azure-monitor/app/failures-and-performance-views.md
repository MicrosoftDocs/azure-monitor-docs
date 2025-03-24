---
title: Failures and Performance views in Application Insights | Microsoft Docs
description: Monitor application performance and failures with Application Insights.
ms.topic: conceptual
ms.date: 02/15/2024
ms.reviewer: cogoodson 
---

# Failures and Performance views

[Application Insights](./app-insights-overview.md) features two key tools: the Failures view and the Performance view.

* **Failures view -** Tracks errors, exceptions, and faults, offering clear insights for fast problem-solving and enhanced stability.
* **Performance view -** Quickly identifies and helps resolve application bottlenecks by displaying response times and operation counts.

Together, they ensure the ongoing health and efficiency of web applications.

## [Failures view](#tab/failures-view)

Application Insights comes with a curated Application Performance Management (APM) experience to help you diagnose failures in your monitored applications.

To get to the **Failures** experience in Application Insights, select either the **Failed requests** graph on the **Overview** experience, or the **Failures** option under the **Investigate** category in the resource menu.

:::image type="content" source="media/failures-and-performance-views/failures-view-go-to.png" lightbox="media/failures-and-performance-views/failures-view-go-to.png" alt-text="Screenshot showing how to reach the failures view in Application Insights.":::

You can also get to the failures experience from the [Application Map](app-map.md) by selecting **Investigate failures** from the triage pane.

:::image type="content" source="media/failures-and-performance-views/failures-app-map.png" lightbox="media/failures-and-performance-views/failures-app-map.png" alt-text="Screenshot showing how to reach the failures view from the application map.":::

### Failures overview

The **Failures** view shows you a list of all failed operations collected for your application. It lets you view their frequency as well as the number of users affected, to help you focus your efforts on the issues with the highest impact.

:::image type="content" source="media/failures-and-performance-views/failures-view.png" lightbox="media/failures-and-performance-views/failures-view.png" alt-text="Screenshot of the failures view in Application Insights.":::

### Analyze failures

To continue your investigation into the root cause of an error or exception, you can drill into the problematic transaction for a detailed end-to-end transaction view that includes dependencies and exception details.

1. Select an operation to show more information about it in the right pane.

1. Under **Drill into**, select the button with the number of filtered results to view a list of sample operations.

1. Select a sample operation to open the **End-to-end transaction details** view.

    :::image type="content" source="media/failures-and-performance-views/failures-view-drill-into.png" lightbox="media/failures-and-performance-views/failures-view-drill-into.png" alt-text="Screenshot of the failures view with the 'Drill into' button highlighted.":::

    > [!NOTE]
    > The **Suggested** samples have related telemetry from all components, even if sampling might have been in effect in any of them.

### End-to-end transaction details

The end-to-end tranasction view shows a Gantt chart of the transaction. Selecting an exception shows more information like **Exception Properties** and the **Call Stack**. Additionally, you can **Open debug snapshot** to see code-level debug information of the exception.

:::image type="content" source="media/failures-and-performance-views/failures-exception-open-debugger.png" lightbox="media/failures-and-performance-views/failures-exception-open-debugger.png" alt-text="Screenshot showing the end-to-end transaction with 'Open debug snapshot' highlighted.":::

### Debug Snapshot

The Debug Snapshot view shows the call stack and allows you to inspect variables at each call stack frame. By selecting a method, you can view the values of all local variables at the time of the request. Afterward, you can debug the source code by downloading the snapshot and opening it in Visual Studio.

:::image type="content" source="media/failures-and-performance-views/failures-debug-snapshot-details.png" lightbox="media/failures-and-performance-views/failures-debug-snapshot-details.png" alt-text="Screenshot showing the debug snapshot view with the 'Download snapshot' button highlighted.":::

## [Performance view](#tab/performance-view)

You can further investigate slow transactions to identify slow requests and server-side dependencies.

To get to the **Performance** experience in Application Insights, select either the **Server response time** or **Server requests** graph in the **Overview** experience, or the **Performance** option under the **Investigate** category in the resource menu on the left.

:::image type="content" source="media/failures-and-performance-views/performance-view-go-to.png" lightbox="media/failures-and-performance-views/performance-view-go-to.png" alt-text="Screenshot showing how to reach the performance view in Application Insights.":::

You can also analyze performance in your application or its components from the application map, by selecting **Investigate performance** from the triage pane of [Application Map](app-map.md).

:::image type="content" source="media/failures-and-performance-views/performance-app-map.png" lightbox="media/failures-and-performance-views/performance-app-map.png" alt-text="Screenshot showing how to reach the performance view from the application map.":::

### Performance overview

The **Performance** experience shows a list of operations collected for your application with the option to drill into each one.

:::image type="content" source="media/failures-and-performance-views/performance-view.png" lightbox="media/failures-and-performance-views/performance-view.png" alt-text="Screenshot showing the performance view in Application Insights.":::

On the **Performance** page, you can isolate slow transactions by selecting the time range, operation name, and durations of interest. You're also prompted with automatically identified anomalies and commonalities across transactions. From this page, you can drill into an individual transaction for an end-to-end view of transaction details with a Gantt chart of dependencies.

If you instrument your web pages with Application Insights, you can also gain visibility into page views, browser operations, and dependencies. Collecting this browser data requires adding a script to your web pages. After you add the script, you can access page views and their associated performance metrics by selecting the **Browser** toggle.

:::image type="content" source="media/failures-and-performance-views/performance-view-drill-into.png" lightbox="media/failures-and-performance-views/performance-view-drill-into.png" alt-text="Screenshot showing the performance view with the 'Drill into' button highlighted.":::

### Identify slow server operations

Application Insights collects performance details for the different operations in your application. By identifying the operations with the longest duration, you can diagnose potential problems or target your ongoing development to improve the overall performance of the application.

1. The **Performance** screen shows the count and average duration of each operation for the application. You can use this information to identify those operations that affect users the most. In this example, the **GET Customers/Details** and **GET Home/Index** are likely candidates to investigate because of their relatively high duration and number of calls. Other operations might have a higher duration but were rarely called, so the effect of their improvement would be minimal.

	<!-- Screenshot showing the Performance server panel. -->

1. The graph currently shows the average duration of the selected operations over time. You can switch to the 95th percentile to find the performance issues. Add the operations you're interested in by pinning them to the graph. The graph shows that there are some peaks worth investigating. To isolate them further, reduce the time window of the graph.

	<!-- Screenshot showing Pin operations. -->

1. The performance panel on the right shows distribution of durations for different requests for the selected operation. Reduce the window to start around the 95th percentile. The **Top 3 Dependencies** insights card can tell you at a glance that the external dependencies are likely contributing to the slow transactions. Select the button with the number of samples to see a list of the samples. Then select any sample to see transaction details.

1. You can see at a glance that the call to the Fabrikamaccount Azure Table contributes most to the total duration of the transaction. You can also see that an exception caused it to fail. Select any item in the list to see its details on the right side.

	<!-- Screenshot showing end-to-end transaction details. -->

1. The Profiler helps get further with code-level diagnostics by showing the actual code that ran for the operation and the time required for each step. Some operations might not have a trace because the Profiler runs periodically. Over time, more operations should have traces. To start the Profiler for the operation, select **Profiler traces**.
1. The trace shows the individual events for each operation so that you can diagnose the root cause for the duration of the overall operation. Select one of the top examples that has the longest duration.
1. Select **Hot path** to highlight the specific path of events that contribute the most to the total duration of the operation. In this example, you can see that the slowest call is from the `FabrikamFiberAzureStorage.GetStorageTableData` method. The part that takes the most time is the `CloudTable.CreateIfNotExist` method. If this line of code is executed every time the function gets called, unnecessary network call and CPU resources will be consumed. The best way to fix your code is to put this line in some startup method that executes only once.

	<!-- Screenshot showing Profiler details. -->

1. The **Performance Tip** at the top of the screen supports the assessment that the excessive duration is because of waiting. Select the **waiting** link for documentation on interpreting the different types of events.

	<!-- Screenshot showing a Performance Tip. -->

1. For further analysis, select **Download Trace** to download the trace. You can view this data by using [PerfView](https://github.com/Microsoft/perfview#perfview-overview).

### Identify slow client operations

In addition to identifying server processes to optimize, Application Insights can analyze the perspective of client browsers. This information can help you identify potential improvements to client components and even identify issues with different browsers or different locations.

1. Select **Browser** under **Investigate** and then select **Browser Performance**. Alternatively, select **Performance** under **Investigate** and switch to the **Browser** tab by selecting the **Server/Browser** toggle button in the upper-right corner to open the browser performance summary. This view provides a visual summary of various telemetries of your application from the perspective of the browser.

	<!-- Screenshot showing the Browser summary. -->

1. Select one of the operation names, select the **Samples** button at the bottom right, and then select an operation. End-to-end transaction details open on the right side where you can view the **Page View Properties**. You can view details of the client requesting the page including the type of browser and its location. This information can assist you in determining whether there are performance issues related to particular types of clients.

	<!-- Screenshot showing Page View Properties. -->

> [!NOTE]
> Like the data collected for server performance, Application Insights makes all client data available for deep analysis by using logs.

:::image type="content" source="media/failures-and-performance-views/performance-transaction-view.png" lightbox="media/failures-and-performance-views/performance-transaction-view.png" alt-text="Screenshot showing the end-to-end transaction view.":::

:::image type="content" source="media/failures-and-performance-views/performance-profiler-traces.png" lightbox="media/failures-and-performance-views/performance-profiler-traces.png" alt-text="Screenshot showing the profiler traces feature.":::

---

### Use analytics data

All data collected by Application Insights is stored in Log Analytics, which provides a rich query language that you can use to analyze the data in various ways. You can use this data to analyze the requests that generated the exception you're researching. 

On either the performance or failures view, select **View in Logs** in the top navigation bar and pick a query from the dropdown menu. This will take you to the Logs view where you can further modify the query or select a different one from the sidebar.

:::image type="content" source="media/failures-and-performance-views/performance-logs.png" lightbox="media/failures-and-performance-views/performance-logs.png" alt-text="Screenshot showing logs when reached from the performance view.":::

### Add a work item

If you connect Application Insights to a tracking system, such as Azure DevOps or GitHub, you can create a work item directly from Application Insights.

1. Select **Create work item** and create a new template or pick an existing one.

1. The **New Work Item** pane opens with details about the exception already populated. You can add more information before you save it.

## Next steps

* Learn more about using [Application Map](app-map.md) to spot performance bottlenecks and failure hotspots across all components of your application.
* Learn more about using the [Availability view](availability-overview.md) to set up recurring tests to monitor availability and responsiveness for your application.
