---
title: Monitor and analyze runtime behavior with Code Optimizations
description: Identify and remove CPU and memory bottlenecks using Azure Monitor's Code Optimizations feature
ms.topic: article
ms.service: azure-monitor
ms.subservice: optimization-insights
author: hhunter-ms
ms.author: hannahhunter
ms.date: 05/16/2025
ms.reviewer: jan.kalis
ms.collection: ce-skilling-ai-copilot
ms.update-cycle: 180-days
---

# Monitor and analyze runtime behavior with Code Optimizations

Diagnosing your application's performance issues can be difficult, especially when running on a production environment in the dynamic cloud. Slow responses in your application could be caused by infrastructure, framework, or application code handling the request in the pipeline. 

Code Optimizations, an AI-based service in Azure Application Insights, works in tandem with the Application Insights Profiler for .NET to detect CPU and memory usage performance issues at a code level and provide recommendations on how to fix them. 

Make informed decisions and optimize your code using real-time performance data and insights gathered from your production environment.

[You can review your Code Optimizations in the Azure portal.](https://aka.ms/codeoptimizations)

## Code Optimizations and Application Insights Profiler for .NET

The .NET Profiler and Code Optimizations work together to provide a holistic approach to performance issue detection.

### Code Optimizations

[Code Optimizations](https://aka.ms/codeoptimizations) identifies, analyzes, and resolves the profiling data collected by the Application Insights Profiler for .NET. As the .NET Profiler uploads data to Application Insights, our machine learning model analyzes some of the data to find where the application's code can be optimized. Code Optimizations:

* Displays aggregated data gathered over time.
* Connects data with the methods and functions in your application code.
* Narrows down the culprit by finding bottlenecks within the code.
* Provides code-level performance fixes based on insights.

#### Identify

Using the [Code Optimizations consolidated overview page](view-code-optimizations.md#via-the-code-optimizations-consolidated-overview-page-preview), you can see all Code Optimization recommendations across your Azure subscriptions and Application Insights resources in the Azure portal. Identify bottlenecks in your code and review code-level recommendations for dev, test, pre-production, and production environments. 

#### Analyze

Once your environment's data has been collected, Code Optimizations provides code-level recommendations on an hourly basis. By default, the aggregated data view shows a rolling 24-hour window of recently identified issues, with a 30-day history for you to review and analyze past events.

#### Resolve

After identifying and analyzing the Code Optimization results, you can resolve these issues in your code using the Code Optimizations [Visual Studio](code-optimizations-vs-extension.md) and [Visual Studio Code](code-optimizations-vscode-extension.md) extensions. With these extensions, interact with GitHub Copilot to receive a code fix grounded in Code Optimizations insights. 

You can also create a GitHub issue from the Code Optimizations page in the Azure portal and [assign it to the GitHub Copilot coding agent](./code-optimizations-github-copilot.md). From there, GitHub Copilot opens a pull request and pushes code change commits based on Code Optimization insights.

#### Demo video

> [!VIDEO https://www.youtube-nocookie.com/embed/eu1P_vLTZO0]

### Application Insights Profiler for .NET

The .NET Profiler focuses on tracing specific requests, down to the millisecond. It provides an excellent "big picture" view of issues within your application and general best practices to address them.

With Application Insights Profiler for .NET, you can capture, identify, and view performance traces for your application running in Azure, regardless of the scenario. The .NET Profiler trace process occurs automatically, at scale, and doesn't negatively affect your users. The .NET Profiler identifies:

* The median, fastest, and slowest response times for each web request made by your customers.
* The "hot" code path spending the most time handling a particular web request.

Enable the Profiler for .NET on all your Azure applications to gather data with the following triggers:

* **Sampling trigger**: Starts Profiler randomly about once an hour for two minutes.
* **CPU trigger**: Starts Profiler when the CPU usage percentage is over 80 percent.
* **Memory trigger**: Starts Profiler when memory usage is above 80 percent.

Each of these triggers can be [configured, enabled, or disabled](../profiler/profiler-settings.md#trigger-settings).

## Cost and overhead

Code Optimizations are generated automatically after [Application Insights Profiler for .NET is enabled](../profiler/profiler.md). By default, Profiler actively collects traces every hour for 30 seconds or during periods of high CPU or memory usage for 30 seconds. The hourly traces (called sampling) are great for proactive tuning, while the high CPU and memory traces (called triggers) are useful for reactive troubleshooting.

[!INCLUDE [profiler-overhead](../profiler/includes/profiler-overhead.md)]

Some Code Optimization features (such as code-level fix suggestions) require [Copilot for GitHub](https://docs.github.com/copilot/about-github-copilot/what-is-github-copilot) and/or [Copilot for Azure](/azure/copilot/overview). 

## Enabling .NET Profiler

As frameworks and Azure services evolve, you can enable .NET Profiler for your .NET apps running on Azure via a number of options.

| Azure service | How to enable | Details |
|---------------|---------------|---------|
| Most Azure services | Code change in your application<br>(most universal) | If your .NET app runs on variants of Azure PaaS services or Containers, you can choose between two options for enabling .NET Profiler:<br>- [Application Insights Profiler for ASP.NET Core](https://github.com/microsoft/ApplicationInsights-Profiler-AspNetCore) that uses the [Application Insights SDK](../app/asp-net-core.md), or<br>- ***New*** [Azure Monitor OpenTelemetry Profiler for NET (Preview)](https://github.com/Azure/azuremonitor-opentelemetry-profiler-net) that uses [Azure Monitor OpenTelemetry Distro](../app/application-insights-faq.yml#why-should-i-use-the-azure-monitor-opentelemetry-distro) |
| Azure App Service | No code change for your application | Since the Profiler is pre-installed, you can enable Profiler for .NET in the portal for:<br>- [Azure App Service - .NET app on Windows](../profiler/profiler.md)<br>- [Azure Functions - App Service plan](../profiler/profiler-azure-functions.md) |
| Virtual Machines | No code change for your application | Once you've enabled the Application Insights SDK in your application code, you can enable the Profiler for .NET in your ARM template.<br>- [Azure Virtual Machines and Virtual Machine Scale Sets for Windows](../profiler/profiler-vm.md)<br>- [Azure Service Fabric](../profiler/profiler-servicefabric.md) | 


### Details and examples for enabling Profiler for .NET

* [Azure App Service - .NET app on Windows](../profiler/profiler-containers.md)
* [Azure App Service - .NET app on Linux](../profiler/profiler-aspnetcore-linux.md)
* [Containers](../profiler/profiler-containers.md):
    * Azure Container Apps
    * Azure Kubernetes Services
    * Azure Container Instances
* [Azure Virtual Machines and Virtual Machine Scale Sets for Windows](../profiler/profiler-vm.md)
* [Azure Functions - App Service plan](../profiler/profiler-azure-functions.md)
* [Azure Service Fabric](../profiler/profiler-servicefabric.md)

> [!NOTE]
> You can also use the [Java Profiler for Azure Monitor Application Insights](../app/java-standalone-profiler.md), currently in preview.

## Supported regions

Code Optimizations is available in the same regions as Application Insights. You can check the available regions using the following command:

```sh
az account list-locations -o table
```

You can set an explicit region using connection strings. [Learn more about connection strings with examples.](../app/connection-strings.md#connection-string-examples)

## Limitations

**Profiling web apps**:

* Although you can use the .NET Profiler at no extra cost, your web app must be hosted in the basic tier of the Web Apps feature of Azure App Service, at minimum.
* You can attach only one profiler to each web app.

## Troubleshooting

- **Profiler**

    If you've enabled the Profiler for .NET but aren't seeing traces, see the [Troubleshooting guide](../profiler/profiler-troubleshooting.md).

- **Code Optimizations**
 
    Running into issues? Check the [Code Optimizations troubleshooting guide](code-optimizations-troubleshoot.md) for scenario solutions.

## Next steps

Learn how to enable the .NET Profiler with Code Optimizations on your Azure service:

* [ASP.NET Core application hosted in Windows on Azure App Service](../profiler/profiler.md)
* [ASP.NET Core application hosted in Linux on Azure App Service](../profiler/profiler-aspnetcore-linux.md)
* [Azure Functions app](../profiler/profiler-azure-functions.md)
* [Azure Service Fabric app](../profiler/profiler-servicefabric.md)
* [Azure Virtual Machines](../profiler/profiler-vm.md)
* [ASP.NET Core application running in containers](../profiler/profiler-containers.md)
