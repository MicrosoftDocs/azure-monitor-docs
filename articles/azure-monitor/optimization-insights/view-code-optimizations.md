---
title: Access and Interpret Code Optimizations Results
description: Access, filter, and interpret Code Optimizations results in Azure Monitor to find performance bottlenecks and get AI-generated fixes for your app code.
ms.topic: how-to
ms.service: azure-monitor
ms.subservice: optimization-insights
author: austinmccollum
ms.author: austinmc
ms.date: 03/16/2026
ms.reviewer: hannahhunter
#customer intent: As an application developer, I need to see the results provided by Code Optimizations in order to continuously improve my apps.
---

# View Code Optimizations results

After you set up and configure Code Optimizations on your app, you can access and view any insights you receive.

## Access Code Optimizations

Access Code Optimizations through two entry points:

- [The Code Optimizations consolidated overview page](#via-the-code-optimizations-consolidated-overview-page-preview).
- [The individual Application Insights resources](#via-individual-application-insights-resources).

<a name="via-the-code-optimizations-consolidated-overview-page-preview"></a>

### Code Optimizations consolidated overview page (preview)

View your Code Optimizations results by using [the Code Optimizations overview page](https://aka.ms/codeoptimizations). In this consolidated overview, you can access results across multiple subscriptions for multiple Application Insights resources.

:::image type="content" source="media/code-optimizations/code-optimizations-consolidated-page.png" alt-text="Screenshot of Code Optimizations consolidated overview page." lightbox="media/code-optimizations/code-optimizations-consolidated-page.png":::

You can filter the consolidated results by searching for a filter field or setting the following filters:

| Filter               | Description           | Default       |
|----------------------|-----------------------|---------------|
| Time Range           | Select the time range from which you want to view Code Optimizations results.   | Last 24 Hours |
| Role                 | The role name assigned to the reporting services machine or workload. Update it through the Application Insights configuration. | All Roles     |
| Subscription         | The subscription that the insight belongs to. You can select more than one.  | N/A           |
| Application Insights | The Application Insights resource associated with your application. Select more than one.  | N/A           |
| Insight Type         | The type of issue, such as CPU, memory, blocking, and exceptions.     | All Types     |

You can then sort the columns in the insights results based on your desired view, including by:

- Performance issue
- The full name of the parent method

<a name="via-individual-application-insights-resources"></a>

### Individual Application Insights resources

Access Code Optimizations specific to individual Application Insights resources from that resource's left menu. Select **Investigate** > **Performance** and select the **Code Optimizations** button from the top menu.

:::image type="content" source="media/code-optimizations/code-optimizations-performance-blade.png" alt-text="Screenshot of Code Optimizations located in the Performance page." lightbox="media/code-optimizations/code-optimizations-performance-blade.png":::

Filter the results for the individual resource by searching for a filter field or setting the following filters:

| Filter       | Description                   | Default       |
|--------------|-------------------------------|---------------|
| Time Range   | Select the time range from which you want to view Code Optimizations results. | Last 24 Hours |
| Role         | The role name assigned to the reporting services machine or workload. You can update it through the Application Insights configuration. | All Roles     |
| Insight Type | The type of issue, such as CPU, memory, blocking, and exceptions. | All Types     |

Then sort the columns in the insights results based on your desired view, including by:

- Performance issue
- The number of profiles that contained that issue
- The full name of the parent method

## Interpret estimated memory and CPU peak usage percentages

Code Optimizations determines the estimated CPU and memory based on the amount of activity in your application. In addition to the memory and CPU percentages, Code Optimizations includes:

- The actual allocation sizes (in bytes)
- A breakdown of the allocated types within the call

### Memory

For memory, the number is a percentage of all allocations in the trace. For example, if an issue takes 24% memory, you spend 24% of your allocations in that call.

### CPU

For CPU, the percentage is based on the number of CPUs in your machine (for example, four-core or eight-core) and the trace time. For example, suppose your trace is 10 seconds long and you have four CPUs: you have a total of 40 seconds of CPU time. If the insight says the line of code is using 5% of the CPU, it's using 5% of 40 seconds, or 2 seconds.

## Blocking

Blocking insights show where threads spend time waiting for resources such as I/O operations, locks, or sleeps. Code Optimizations reports blocking time in seconds and aggregates it across all threads and cores, so totals can exceed the capture duration, just as they do for CPU metrics.

Use this metric to identify latency bottlenecks, such as:

- Lock contention between threads
- Synchronous I/O operations
- Blocking calls on asynchronous operations

## Exceptions

Code Optimizations extracts exception insights from the snapshots that the Snapshot Debugger collects. If you enable Snapshot Debugger in your app and it collects snapshots, Code Optimizations automatically processes them for insight extraction.

## View insights

After sorting and filtering the Code Optimizations results, select each insight to view the following details in a pane:

- Detailed description of the performance bug insight.
- The full call stack.
- Recommendations on how to fix the performance issue.
- The timeline of the issue's trend impact and threshold.

### Insights

The **Insights** tab provides:

- A brief description of the selected issue.
- The current condition of your resource memory or CPU usage.
- An AI-generated recommendation for fixing the issue.

:::image type="content" source="media/code-optimizations/code-optimizations-details.png" alt-text="Screenshot of the detail pane for a specific Code Optimizations CPU result.":::

> [!NOTE]
> If you don't see any insights, it's likely that the Code Optimizations service didn't notice any performance bottlenecks in your code. Check back to see if any insights appear.

### Call Stack

In the insights details pane, under the **Call Stack** heading, you can:

- Select **Expand** to view the full call stack surrounding the performance issue.
- Select **Copy** to copy the call stack.

:::image type="content" source="media/code-optimizations/code-optimizations-call-stack-2.png" alt-text="Screenshot of the call stack heading in the detail pane for the specific CPU result from earlier.":::

:::image type="content" source="media/code-optimizations/code-optimizations-call-stack.png" alt-text="Screenshot of the expanded call stack for the specific CPU result from earlier.":::

### Timeline

In the details pane, under **Timeline**, you can view a graph that shows the timeline of a specific performance issue's impact and threshold. The results vary depending on the filters you set. For example, the insights for a memory "Inefficient `String.SubString()`" performance issue from the last 24 hours might look like:

:::image type="content" source="media/code-optimizations/code-optimizations-trend-impact.png" alt-text="Screenshot of the CPU trend impact over the course of seven days.":::

## Next step

> [!div class="nextstepaction"]
> [Review Code Optimizations in Azure portal](https://aka.ms/codeoptimizations)
