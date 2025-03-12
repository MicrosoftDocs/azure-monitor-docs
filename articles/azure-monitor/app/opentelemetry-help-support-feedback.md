---
title: OpenTelemetry help and support for Azure Monitor Application Insights
description: This article provides FAQs, troubleshooting steps, support options, and feedback mechanisms for OpenTelemetry (OTel) in Application Insights for .NET, Java, Node.js, and Python applications.
ms.topic: conceptual
ms.date: 03/12/2025
ms.reviewer: mmcc

#customer intent: As a developer or site reliability engineer, I want to find support resources and provide feedback for OpenTelemetry (OTel) integration with Application Insights to effectively monitor my .NET, Java, Node.js, or Python applications.

---

# OpenTelemetry Support and Feedback for Application Insights

This document outlines available resources for assistance, support channels, and feedback mechanisms related to OpenTelemetry (OTel) integration with [Azure Monitor Application Insights](.\opentelemetry-enable.md) for .NET, Java, Node.js, and Python applications.

> [!div class="checklist"]
> - [Review frequently asked questions](#frequently-asked-questions)
> - [Take troubleshooting steps](#troubleshooting)
> - [Get support](#support)
> - [Provide feedback](#opentelemetry-feedback)

## Frequently asked questions

### What is OpenTelemetry?

It's a new open-source standard for observability. Learn more at [OpenTelemetry](https://opentelemetry.io/).

### Why is Microsoft Azure Monitor investing in OpenTelemetry?

Microsoft is investing in OpenTelemetry for the following reasons:

* It's vendor-neutral and provides consistent APIs/SDKs across languages.
* Over time, we believe OpenTelemetry will enable Azure Monitor customers to observe applications written in languages beyond our [supported languages](../app/app-insights-overview.md#supported-languages).
* It expands the types of data you can collect through a rich set of [instrumentation libraries](https://opentelemetry.io/docs/concepts/components/#instrumentation-libraries).
* OpenTelemetry Software Development Kits (SDKs) tend to be more performant at scale than their predecessors, the Application Insights SDKs.
* OpenTelemetry aligns with Microsoft's strategy to [embrace open source](https://opensource.microsoft.com/).

### What's the status of OpenTelemetry?

See [OpenTelemetry Status](https://opentelemetry.io/status/).

### What is the Azure Monitor OpenTelemetry Distro?

You can think of it as a thin wrapper that bundles together all the OpenTelemetry components for a first-class experience on Azure. This wrapper is also called a [distribution](https://opentelemetry.io/docs/concepts/distributions/) in OpenTelemetry.

### Why should I use the Azure Monitor OpenTelemetry Distro?

There are several advantages to using the Azure Monitor OpenTelemetry Distro over native OpenTelemetry from the community:

* Reduces enablement effort
* Supported by Microsoft
* Brings in Azure-specific features such as:
    * Sampling compatible with classic Application Insights SDKs
    * [Microsoft Entra authentication](../app/azure-ad-authentication.md)
    * [Offline Storage and Automatic Retries](../app/opentelemetry-configuration.md#offline-storage-and-automatic-retries)
    * [Statsbeat](../app/statsbeat.md)
    * [Application Insights Standard Metrics](../app/standard-metrics.md)
    * Detect resource metadata to autopopulate [Cloud Role Name](../app/java-standalone-config.md#cloud-role-name) and [Cloud Role Instance](../app/java-standalone-config.md#cloud-role-instance) on various Azure environments
    * [Live Metrics](../app/live-stream.md)

In the spirit of OpenTelemetry, we designed the distro to be open and extensible. For example, you can add:

* An OpenTelemetry Protocol (OTLP) exporter and send to a second destination simultaneously
* Other instrumentation libraries not included in the distro

Because the Distro provides an [OpenTelemetry distribution](https://opentelemetry.io/docs/concepts/distributions/#what-is-a-distribution), the Distro supports anything supported by OpenTelemetry. For example, you can add more telemetry processors, exporters, or instrumentation libraries, if OpenTelemetry supports them.

> [!NOTE]
> The Distro sets the sampler to a custom, fixed-rate sampler for Application Insights. You can change this to a different sampler, but doing so might disable some of the Distro's included capabilities.
> For more information about the supported sampler, see the [Enable Sampling](../app/opentelemetry-configuration.md#enable-sampling) section of [Configure Azure Monitor OpenTelemetry](../app/opentelemetry-configuration.md).

For languages without a supported standalone OpenTelemetry exporter, the Azure Monitor OpenTelemetry Distro is the only currently supported way to use OpenTelemetry with Azure Monitor. For languages with a supported standalone OpenTelemetry exporter, you have the option of using either the Azure Monitor OpenTelemetry Distro or the appropriate standalone OpenTelemetry exporter depending on your telemetry scenario. For more information, see [When should I use the Azure Monitor OpenTelemetry exporter?](#when-should-i-use-the-azure-monitor-opentelemetry-exporter).

### How can I test out the Azure Monitor OpenTelemetry Distro?

Check out our enablement docs for [.NET, Java, JavaScript (Node.js), and Python](../app/opentelemetry-enable.md).

### Should I use OpenTelemetry or the Application Insights SDK?

We recommend using the Azure Monitor OpenTelemetry Distro for new projects when [its capabilities](#whats-the-current-release-state-of-features-within-the-azure-monitor-opentelemetry-distro) align with your monitoring needs. OpenTelemetry is an industry-standard framework that enhances cross-platform observability and provides a standardized approach to telemetry collection.

However, the Application Insights SDKs still provide certain capabilities that aren't yet fully automated in OpenTelemetry, including:

- Automatic dependency tracking – OpenTelemetry supports dependency tracking, but some dependencies require additional configuration compared to the automatic tracking available in Application Insights SDKs.
- Custom telemetry types, such as `AvailabilityTelemetry` and `PageViewTelemetry` – OpenTelemetry doesn't have direct equivalents. Similar functionality can be implemented via manual instrumentation.
- Telemetry processors and initializers – OpenTelemetry has processors and span processors, but they don't fully replace Application Insights Telemetry Processors and Initializers in all scenarios.
- Extended metrics collection – While OpenTelemetry has a strong metrics system, some built-in metrics from Application Insights SDKs require manual setup in OpenTelemetry.

OpenTelemetry also provides advantages over the Application Insights SDKs, including:

- Better standardization across platforms
- A wider ecosystem of instrumentation libraries
- Greater flexibility in data collection and processing
- Improved vendor neutrality, though Azure Monitor OpenTelemetry Distro is still optimized for Azure.

Azure Monitor's OpenTelemetry integration is continuously evolving, and Microsoft continues to enhance its capabilities. If you're considering a transition, carefully evaluate whether OpenTelemetry currently meets your observability requirements or if the Application Insights SDK remains the better fit for your needs.

### When should I use the Azure Monitor OpenTelemetry exporter?

For ASP.NET Core, Java, Node.js, and Python, we recommend using the Azure Monitor OpenTelemetry Distro. It's one line of code to get started.

For all other .NET scenarios, including classic ASP.NET, console apps, Windows Forms (WinForms), etc., we recommend using the .NET Azure Monitor OpenTelemetry exporter: `Azure.Monitor.OpenTelemetry.Exporter`.

For more complex Python telemetry scenarios that require advanced configuration, we recommend using the Python [Azure Monitor OpenTelemetry Exporter](/python/api/overview/azure/monitor-opentelemetry-exporter-readme?view=azure-python-preview&preserve-view=true).

### What's the current release state of features within the Azure Monitor OpenTelemetry Distro?

The following chart breaks out OpenTelemetry feature support for each language.

| Feature                                                                                                              | .NET               | Node.js            | Python             | Java               |
|----------------------------------------------------------------------------------------------------------------------|--------------------|--------------------|--------------------|--------------------|
| [Distributed tracing](../app/distributed-trace-data.md)                                                              | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| [Custom metrics](../app/opentelemetry-add-modify.md#add-custom-metrics)                                              | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| [Standard metrics](../app/standard-metrics.md)                                                                       | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| [Fixed-rate sampling](../app/sampling.md)                                                                            | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| [Offline storage and automatic retries](../app/opentelemetry-configuration.md#offline-storage-and-automatic-retries) | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| [Exception reporting](../app/asp-net-exceptions.md)                                                                  | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| [Logs collection](../app/asp-net-trace-logs.md)                                                                      | :white_check_mark: | :warning:          | :white_check_mark: | :white_check_mark: |
| [Custom Events](../app/usage.md#track-user-interactions-with-custom-events)                                          | :warning:          | :warning:          | :warning:          | :white_check_mark: |
| [Microsoft Entra authentication](../app/azure-ad-authentication.md)                                                  | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| [Live metrics](../app/live-stream.md)                                                                                | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| [Live Metrics Filtering](../app/live-stream.md#select-and-filter-your-metrics)                                       | :white_check_mark: | :x:                | :x:                | :x:                |
| Detect Resource Context for VM/VMSS and App Service                                                                  | :white_check_mark: | :x:                | :white_check_mark: | :white_check_mark: |
| Detect Resource Context for Azure Kubernetes Service (AKS) and Functions                                             | :x:                | :x:                | :x:                | :white_check_mark: |
| Availability Testing Events generated using the Track Availability API                                               | :x:                | :x:                | :x:                | :white_check_mark: |
| Filter requests, dependencies, logs, and exceptions by anonymous user ID and synthetic source                        | :x:                | :x:                | :x:                | :white_check_mark: |
| Filter dependencies, logs, and exceptions by operation name                                                          | :x:                | :x:                | :x:                | :white_check_mark: |
| [Adaptive sampling](../app/sampling.md#adaptive-sampling)                                                            | :x:                | :x:                | :x:                | :white_check_mark: |
| [.NET Profiler](../profiler/profiler-overview.md)                                                                    | :warning:          | :x:                | :x:                | :warning:          |
| [Snapshot Debugger](../snapshot-debugger/snapshot-debugger.md)                                                       | :x:                | :x:                | :x:                | :x:                |

**Key**
* :white_check_mark: This feature is available to all customers with formal support.
* :warning: This feature is available as a public preview. See [Supplemental terms of use for Microsoft Azure previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).
* :x: This feature isn't available or isn't applicable.

### Can OpenTelemetry be used for web browsers?

Yes, but we don't recommend it and Azure doesn't support it. OpenTelemetry JavaScript is heavily optimized for Node.js. Instead, we recommend using the Application Insights JavaScript SDK.

### When can we expect the OpenTelemetry SDK to be available for use in web browsers?

The OpenTelemetry web SDK doesn't have a determined availability timeline. We're likely several years away from a browser SDK that is a viable alternative to the Application Insights JavaScript SDK.

### Can I test OpenTelemetry in a web browser today?

The [OpenTelemetry web sandbox](https://github.com/open-telemetry/opentelemetry-sandbox-web-js) is a fork designed to make OpenTelemetry work in a browser. It's not yet possible to send telemetry to Application Insights. The SDK doesn't define general client events.

### Is running Application Insights alongside competitor agents like AppDynamics, DataDog, and NewRelic supported?

This practice isn't something we plan to test or support, although our Distros allow you to [export to an OTLP endpoint](../app/opentelemetry-configuration.md#enable-the-otlp-exporter) alongside Azure Monitor simultaneously.

### Can I use preview features in production environments?

We don't recommend it. See [Supplemental terms of use for Microsoft Azure previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

### What's the difference between manual and automatic instrumentation?

See the [OpenTelemetry Overview](../app/opentelemetry-overview.md).

### Can I use the OpenTelemetry Collector?

Some customers use the OpenTelemetry Collector as an agent alternative, even though Microsoft doesn't officially support an agent-based approach for application monitoring yet. In the meantime, the open-source community contributed an [OpenTelemetry Collector Azure Monitor Exporter](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/exporter/azuremonitorexporter) that some customers are using to send data to Azure Monitor Application Insights. **This is not supported by Microsoft.**

### What's the difference between OpenCensus and OpenTelemetry?

[OpenCensus](https://opencensus.io/) is the precursor to [OpenTelemetry](https://opentelemetry.io/). Microsoft helped bring together [OpenTracing](https://opentracing.io/) and OpenCensus to create OpenTelemetry, a single observability standard for the world. The current [production-recommended Python SDK](/previous-versions/azure/azure-monitor/app/opencensus-python) for Azure Monitor is based on OpenCensus. Microsoft is committed to making Azure Monitor based on OpenTelemetry.

### In Grafana, why do I see `Status: 500. Can't visualize trace events using the trace visualizer`?

You could be trying to visualize raw text logs rather than OpenTelemetry traces.

In Application Insights, the 'Traces' table stores raw text logs for diagnostic purposes. They aid in identifying and correlating traces associated with user requests, other events, and exception reports. However, the 'Traces' table doesn't directly contribute to the end-to-end transaction view (waterfall chart) in visualization tools like Grafana.

With the growing adoption of cloud-native practices, there's an evolution in telemetry collection and terminology. OpenTelemetry became a standard for collecting and instrumenting telemetry data. In this context, the term 'Traces' took on a new meaning. Rather than raw logs, 'Traces' in OpenTelemetry refer to a richer, structured form of telemetry that includes spans, which represent individual units of work. These spans are crucial for constructing detailed transaction views, enabling better monitoring and diagnostics of cloud-native applications.

## Troubleshooting

### [ASP.NET Core](#tab/aspnetcore)

For troubleshooting information, see [Troubleshoot OpenTelemetry issues in .NET](/troubleshoot/azure/azure-monitor/app-insights/telemetry/opentelemetry-troubleshooting-dotnet) and [Troubleshoot missing application telemetry in Azure Monitor Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/investigate-missing-telemetry).

### [.NET](#tab/net)

For troubleshooting information, see [Troubleshoot OpenTelemetry issues in .NET](/troubleshoot/azure/azure-monitor/app-insights/telemetry/opentelemetry-troubleshooting-dotnet) and [Troubleshoot missing application telemetry in Azure Monitor Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/investigate-missing-telemetry).

### [Java](#tab/java)

For troubleshooting information, see [Troubleshoot OpenTelemetry issues in Java](/troubleshoot/azure/azure-monitor/app-insights/telemetry/opentelemetry-troubleshooting-java) and [Troubleshoot missing application telemetry in Azure Monitor Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/investigate-missing-telemetry).

### [Java native](#tab/java-native)

For troubleshooting information, see [Troubleshoot OpenTelemetry issues in Spring Boot native image applications](/troubleshoot/azure/azure-monitor/app-insights/telemetry/java-spring-native-opentelemetry-issues) and [Troubleshoot missing application telemetry in Azure Monitor Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/investigate-missing-telemetry).

### [Node.js](#tab/nodejs)

For troubleshooting information, see [Troubleshoot OpenTelemetry issues in Node.js](/troubleshoot/azure/azure-monitor/app-insights/telemetry/opentelemetry-troubleshooting-nodejs) and [Troubleshoot missing application telemetry in Azure Monitor Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/investigate-missing-telemetry).

### [Python](#tab/python)

For troubleshooting information, see [Troubleshoot OpenTelemetry issues in Python](/troubleshoot/azure/azure-monitor/app-insights/telemetry/opentelemetry-troubleshooting-python) and [Troubleshoot missing application telemetry in Azure Monitor Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/investigate-missing-telemetry).

---

## Support

Select a tab for the language of your choice to discover support options.

### [ASP.NET Core](#tab/aspnetcore)

- For Azure support issues, open an [Azure support ticket](https://azure.microsoft.com/support/create-ticket/).
- For OpenTelemetry issues, contact the [OpenTelemetry .NET community](https://github.com/open-telemetry/opentelemetry-dotnet) directly.
- For a list of open issues related to Azure Monitor Exporter, see the [GitHub Issues Page](https://github.com/Azure/azure-sdk-for-net/issues?q=is%3Aopen+is%3Aissue+label%3A%22Monitor+-+Exporter%22).

### [.NET](#tab/net)

- For Azure support issues, open an [Azure support ticket](https://azure.microsoft.com/support/create-ticket/).
- For OpenTelemetry issues, contact the [OpenTelemetry .NET community](https://github.com/open-telemetry/opentelemetry-dotnet) directly.
- For a list of open issues related to Azure Monitor Exporter, see the [GitHub Issues Page](https://github.com/Azure/azure-sdk-for-net/issues?q=is%3Aopen+is%3Aissue+label%3A%22Monitor+-+Exporter%22).

### [Java](#tab/java)

- For Azure support issues, open an [Azure support ticket](https://azure.microsoft.com/support/create-ticket/).
- For help with troubleshooting, review the [troubleshooting steps](/troubleshoot/azure/azure-monitor/app-insights/java-standalone-troubleshoot).
- For OpenTelemetry issues, contact the [OpenTelemetry community](https://opentelemetry.io/community/) directly.
- For a list of open issues related to Azure Monitor Java Autoinstrumentation, see the [GitHub Issues Page](https://github.com/microsoft/ApplicationInsights-Java/issues).

### [Java native](#tab/java-native)

- For Azure support issues, open an [Azure support ticket](https://azure.microsoft.com/support/create-ticket/).
- For OpenTelemetry issues, contact the [OpenTelemetry community](https://opentelemetry.io/community/) directly.
- For a list of open issues with Spring Boot native applications, see the [GitHub Issues Page](https://github.com/Azure/azure-sdk-for-java/issues?q=is%3Aopen+is%3Aissue+label%3A%22Spring+Monitor%22).
- For a list of open issues with Quarkus native applications, see the [GitHub Issues Page](https://github.com/quarkiverse/quarkus-opentelemetry-exporter).

### [Node.js](#tab/nodejs)

- For Azure support issues, open an [Azure support ticket](https://azure.microsoft.com/support/create-ticket/).
- For OpenTelemetry issues, contact the [OpenTelemetry JavaScript community](https://github.com/open-telemetry/opentelemetry-js) directly.
- For a list of open issues related to Azure Monitor Exporter, see the [GitHub Issues Page](https://github.com/Azure/azure-sdk-for-js/issues?q=is%3Aopen+is%3Aissue+label%3A%22Monitor+-+Exporter%22).

### [Python](#tab/python)

- For Azure support issues, open an [Azure support ticket](https://azure.microsoft.com/support/create-ticket/).
- For OpenTelemetry issues, contact the [OpenTelemetry Python community](https://github.com/open-telemetry/opentelemetry-python) directly.
- For a list of open issues related to Azure Monitor Distro, see the [GitHub Issues Page](https://github.com/Azure/azure-sdk-for-python/issues/new/choose).

---

## OpenTelemetry Feedback

To provide feedback:

- Fill out the OpenTelemetry community's [customer feedback survey](https://docs.google.com/forms/d/e/1FAIpQLScUt4reClurLi60xyHwGozgM9ZAz8pNAfBHhbTZ4gFWaaXIRQ/viewform).
- Tell Microsoft about yourself by joining the [OpenTelemetry Early Adopter Community](https://aka.ms/AzMonOTel/).
- Engage with other Azure Monitor users in the [Microsoft Tech Community](https://techcommunity.microsoft.com/t5/azure-monitor/bd-p/AzureMonitor).
- Make a feature request at the [Azure Feedback Forum](https://feedback.azure.com/d365community/forum/3887dc70-2025-ec11-b6e6-000d3a4f09d0).
 
