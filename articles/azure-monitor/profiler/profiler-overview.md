---
title: Analyze application performance traces with Azure Monitor Application Insights Profiler for .NET
description: Identify the hot path in your web server code with a low-footprint .NET Profiler.
ms.contributor: charles.weininger
ms.topic: conceptual
ms.date: 08/15/2024
ms.reviewer: ryankahng
---

# Profile production applications in Azure with Application Insights Profiler for .NET

Diagnosing your application's performance issues can be difficult, especially when running on a production environment in the dynamic cloud. Slow responses in your application could be caused by infrastructure, framework, or application code handling the request in the pipeline. 

With Application Insights Profiler for .NET, you can capture, identify, and view performance traces for your application running in Azure, regardless of the scenario. The .NET Profiler trace process occurs automatically, at scale, and doesn't negatively affect your users. The .NET Profiler identifies:

- The median, fastest, and slowest response times for each web request made by your customers.
- The "hot" code path spending the most time handling a particular web request.

Enable the Profiler for .NET on all your Azure applications to gather data with the following triggers:

- **Sampling trigger**: Starts Profiler randomly about once an hour for two minutes.
- **CPU trigger**: Starts Profiler when the CPU usage percentage is over 80 percent.
- **Memory trigger**: Starts Profiler when memory usage is above 80 percent.

Each of these triggers can be [configured, enabled, or disabled](./profiler-settings.md#trigger-settings).

## Sampling rate and overhead 

By default, Profiler actively collects traces every hour for 30 seconds or during periods of high CPU or memory usage for 30 seconds. The hourly traces (called sampling) are great for proactive tuning, while the high CPU and memory traces (called triggers) are useful for reactive troubleshooting.

[!INCLUDE [profiler-overhead](./includes/profiler-overhead.md)]

## Supported in the .NET Profiler

Profiler works with .NET applications deployed on the following Azure services. View specific instructions for enabling Profiler for each service type in the following links.

| Compute platform | .NET (>= 4.6) | .NET Core |
| ---------------- | ------------- | --------- |
| [Azure App Service](profiler.md) | Yes | Yes |
| [Azure Virtual Machines and Virtual Machine Scale Sets for Windows](profiler-vm.md) | Yes | Yes |
| [Azure Virtual Machines and Virtual Machine Scale Sets for Linux](profiler-aspnetcore-linux.md) | No | Yes |
| [Azure Cloud Services](profiler-cloudservice.md) | Yes | Yes |
| [Azure Container Instances for Windows](profiler-containers.md) | No | Yes |
| [Azure Container Instances for Linux](profiler-containers.md) | No | Yes |
| Kubernetes | No | Yes |
| [Azure Functions](./profiler-azure-functions.md) | Yes | Yes |
| [Azure Service Fabric](profiler-servicefabric.md) | Yes | Yes |

> [!NOTE]
> You can also use the [Java Profiler for Azure Monitor Application Insights](../app/java-standalone-profiler.md), currently in preview.

If you've enabled the Profiler for .NET but aren't seeing traces, see the [Troubleshooting guide](profiler-troubleshooting.md).

## Limitations

- **Data retention**: The default data retention period is five days.
- **Profiling web apps**:
   - Although you can use the .NET Profiler at no extra cost, your web app must be hosted in the basic tier of the Web Apps feature of Azure App Service, at minimum.
   - You can attach only one profiler to each web app.
   - .NET Profiler on Linux is only supported on Windows-based web apps.

## Next steps
Learn how to enable the .NET Profiler on your Azure service:
- [Azure App Service](./profiler.md)
- [Azure Functions app](./profiler-azure-functions.md)
- [Azure Cloud Services](./profiler-cloudservice.md)
- [Azure Service Fabric app](./profiler-servicefabric.md)
- [Azure Virtual Machines](./profiler-vm.md)
- [ASP.NET Core application hosted in Linux on Azure App Service](./profiler-aspnetcore-linux.md)
- [ASP.NET Core application running in containers](./profiler-containers.md)
