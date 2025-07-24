---
title: View Code Optimizations results
description: Learn how to access the results provided by Azure Monitor's Code Optimizations feature.
ms.topic: article
ms.service: azure-monitor
ms.subservice: optimization-insights
author: hhunter-ms
ms.author: hannahhunter
ms.date: 02/07/2025
ms.reviewer: jan.kalis
---

# View Code Optimizations results

Now that you set up and configured Code Optimizations on your app, access and view any insights you received. 

## Access Code Optimizations

You can access Code Optimizations through two main entry points:

* [Via the Code Optimizations consolidated overview page.](#via-the-code-optimizations-consolidated-overview-page-preview)
* [Via individual Application Insights resources.](#via-individual-application-insights-resources)

### Via the Code Optimizations consolidated overview page (preview)

View your Code Optimizations results via [the Code Optimizations overview page](https://aka.ms/codeoptimizations). In this consolidated overview, you can access results across multiple subscriptions for multiple Application Insights resources. 

:::image type="content" source="media/code-optimizations/code-optimizations-consolidated-page.png" alt-text="Screenshot of Code Optimizations consolidated overview page.":::

You can filter the consolidated results by searching for filter field, or setting the following filters:

| Filter               | Description                                                                                                                      | Default       |
|----------------------|----------------------------------------------------------------------------------------------------------------------------------|---------------|
| Time Range           | Select the time range from which you'd like to view Code Optimizations results.                                                  | Last 24 Hours |
| Role                 | The role name assigned to the reporting services machine or workload. Can be updated via the Application Insights configuration. | All Roles     |
| Subscription         | The subscription that the insight belongs to. You can select more than one.                                                      | N/A           |
| Application Insights | The Application Insights resource with which your application is associated. You can select more than one.                       | N/A           |
| Insight Type         | The type of issue, such as CPU, memory, or blocking.                                                                             | All Types     |

You can then sort the columns in the insights results based on your desired view, including by:

* Performance issue
* The full name of the parent method

### Via individual Application Insights resources

You can access Code Optimizations specific to individual Application Insights resources from that resource's left menu. Click **Investigate** > **Performance** and select the **Code Optimizations** button from the top menu.

:::image type="content" source="media/code-optimizations/code-optimizations-performance-blade.png" alt-text="Screenshot of Code Optimizations located in the Performance blade.":::

You can filter the consolidated results by searching for filter field, or setting the following filters:

| Filter       | Description                                                                                                                      | Default       |
|--------------|----------------------------------------------------------------------------------------------------------------------------------|---------------|
| Time Range   | Select the time range from which you'd like to view Code Optimizations results.                                                  | Last 24 Hours |
| Role         | The role name assigned to the reporting services machine or workload. Can be updated via the Application Insights configuration. | All Roles     |
| Insight Type | The type of issue, such as CPU, memory, or blocking.                                                                             | All Types     |

You can then sort the columns in the insights results based on your desired view, including by:

* Performance issue
* The number of profiles that contained that issue
* The full name of the parent method

## Interpret estimated Memory and CPU peak usage percentages

The estimated CPU and Memory are determined based on the amount of activity in your application. In addition to the Memory and CPU percentages, Code Optimizations also includes:

* The actual allocation sizes (in bytes)
* A breakdown of the allocated types made within the call

### Memory

For Memory, the number is a percentage of all allocations made within the trace. For example, if an issue takes 24% memory, you spent 24% of all your allocations within that call.

### CPU

For CPU, the percentage is based on the number of CPUs in your machine (four core, eight core, etc.) and the trace time. For example, let's say your trace is 10 seconds long and you have 4 CPUs: you have a total of 40 seconds of CPU time. If the insight says the line of code is using 5% of the CPU, it's using 5% of 40 seconds, or 2 seconds.

## View insights

After sorting and filtering the Code Optimizations results, you can then select each insight to view the following details in a pane:

* Detailed description of the performance bug insight.
* The full call stack.
* Recommendations on how to fix the performance issue.
* The timeline of the issue's trend impact and threshold.

### Insights

The **Insights** tab provides:

* A brief description of the selected issue. 
* The current condition of your resource memory or CPU usage. 
* An AI-generated recommendation for fixing the issue. 

:::image type="content" source="media/code-optimizations/code-optimizations-details.png" alt-text="Screenshot of the detail pane for a specific Code Optimizations C-P-U result.":::

> [!NOTE]
> If you don't see any insights, it's likely that the Code Optimizations service hasn't noticed any performance bottlenecks in your code. Continue to check back to see if any insights pop up. 

### Call Stack

In the insights details pane, under the **Call Stack** heading, you can:

* Select **Expand** to view the full call stack surrounding the performance issue
* Select **Copy** to copy the call stack.

:::image type="content" source="media/code-optimizations/code-optimizations-call-stack-2.png" alt-text="Screenshot of the call stack heading in the detail pane for the specific C-P-U result from earlier.":::

:::image type="content" source="media/code-optimizations/code-optimizations-call-stack.png" alt-text="Screenshot of the expanded call stack for the specific C-P-U result from earlier.":::

### Timeline

In the details pane, under **Timeline**, you can also view a graph depicting the timeline of a specific performance issue's impact and threshold. The results vary depending on the filters you set. For example, a Memory "Inefficient `String.SubString()`" performance issue's insights seen over the last 24 hours may look like:

:::image type="content" source="media/code-optimizations/code-optimizations-trend-impact.png" alt-text="Screenshot of the C-P-U trend impact over the course of seven days.":::

## Next steps

> [!div class="nextstepaction"]
> [Review Code Optimizations in Azure portal](https://aka.ms/codeoptimizations)
