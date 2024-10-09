---
title: Data Collection Basics of Azure Monitor Application Insights 
description: This article provides an overview of how to collect telemetry to send to Azure Monitor Application Insights.
ms.topic: conceptual
ms.date: 12/15/2023
ms.reviewer: mmcc
---

# Data Collection Basics of Azure Monitor Application Insights

Before you can monitor your application, it needs to be instrumented.

In the following sections, we cover some data collection basics of Azure Monitor Application Insights.

## Instrumentation Options

At a basic level, "instrumenting" is simply enabling an application to capture telemetry.

There are two methods to instrument your application:

- Automatic instrumentation (autoinstrumentation)
- Manual instrumentation

**Autoinstrumentation** enables telemetry collection through configuration without touching the application's code. Although it's more convenient, it tends to be less configurable. It's also not available in all languages. See [Autoinstrumentation supported environments and languages](codeless-overview.md). When autoinstrumentation is available, it's the easiest way to enable Azure Monitor Application Insights.

**Manual instrumentation** is coding against the Application Insights or OpenTelemetry API. In the context of a user, it typically refers to installing a language-specific SDK in an application. This means that you have to manage the updates to the latest package version by yourself. You can use this option if you need to make custom dependency calls or API calls that are not captured by default with autoinstrumentation. There are two options for manual instrumentation:

- [Application Insights SDKs](asp-net-core.md)
- [Azure Monitor OpenTelemetry Distros](opentelemetry-enable.md).

While we see OpenTelemetry as our future direction, we have no plans to stop collecting data from older SDKs. We still have a way to go before our Azure OpenTelemetry Distros [reach feature parity with our Application Insights SDKs](./opentelemetry-help-support-feedback.md#whats-the-current-release-state-of-features-within-the-azure-monitor-opentelemetry-distro). In many cases, customers continue to choose to use Application Insights SDKs for quite some time.

> [!IMPORTANT]
> "Manual" doesn't mean you'll be required to write complex code to define spans for distributed traces, although it remains an option. Instrumentation Libraries packaged into our Distros enable you to effortlessly capture telemetry signals across common frameworks and libraries. We're actively working to [instrument the most popular Azure Service SDKs using OpenTelemetry](https://devblogs.microsoft.com/azure-sdk/introducing-experimental-opentelemetry-support-in-the-azure-sdk-for-net/) so these signals are available to customers who use the Azure Monitor OpenTelemetry Distro.

## Telemetry Types

Telemetry, the data collected to observe your application, can be broken into three types or "pillars":

- Distributed Tracing
- Metrics
- Logs

A complete observability story includes all three pillars, and Application Insights further breaks down these pillars into tables based on our [data model](data-model-complete.md). Our Application Insights SDKs or Azure Monitor OpenTelemetry Distros include everything you need to power Application Performance Monitoring on Azure. The package itself is free to install, and you only pay for the data you ingest in Azure Monitor.

The following sources explain the three pillars:

- [OpenTelemetry community website](https://opentelemetry.io/docs/concepts/data-collection/)
- [OpenTelemetry specifications](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/overview.md)
- [Distributed Systems Observability](https://www.oreilly.com/library/view/distributed-systems-observability/9781492033431/ch04.html) by Cindy Sridharan

## Telemetry Routing

There are two ways to send your data to Azure Monitor (or any vendor):

- Via a direct exporter
- Via an agent

A direct exporter sends telemetry in-process (from the application's code) directly to the Azure Monitor ingestion endpoint. The main advantage of this approach is onboarding simplicity.

*The currently available Application Insights SDKs and Azure Monitor OpenTelemetry Distros rely on a direct exporter*.

> [!NOTE]
> For Azure Monitor's position on the OpenTelemetry-Collector, see the [OpenTelemetry FAQ](./opentelemetry-help-support-feedback.md#can-i-use-the-opentelemetry-collector).

> [!TIP]
> If you are planning to use OpenTelemetry-Collector for sampling or additional data processing, you may be able to get these same capabilities built-in to Azure Monitor. [Workspace-based Application Insights resources](create-workspace-resource.md) benefit from [Ingestion-time Transformations](../essentials/data-collection-transformations.md). To enable, follow the details in the [tutorial](../logs/tutorial-workspace-transformations-portal.md), skipping the step that shows how to set up a diagnostic setting since with Workspace-centric Application Insights this is already configured. If you’re filtering less than 50% of the overall volume, it’s no additional cost. After 50%, there is a cost but much less than the standard per GB charge.

## OpenTelemetry

Microsoft is excited to embrace [OpenTelemetry](https://opentelemetry.io/) as the future of telemetry instrumentation. You, our customers, asked for vendor-neutral instrumentation, and we're pleased to partner with the OpenTelemetry community to create consistent APIs and SDKs across languages.

Microsoft worked with project stakeholders from two previously popular open-source telemetry projects, [OpenCensus](https://opencensus.io/) and [OpenTracing](https://opentracing.io/). Together, we helped to create a single project, OpenTelemetry. OpenTelemetry includes contributions from all major cloud and Application Performance Management (APM) vendors and lives within the [Cloud Native Computing Foundation (CNCF)](https://www.cncf.io/). Microsoft is a Platinum Member of the CNCF.

For terminology, see the [glossary](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/glossary.md) in the OpenTelemetry specifications.

Some legacy terms in Application Insights are confusing because of the industry convergence on OpenTelemetry. The following table highlights these differences. OpenTelemetry terms are replacing Application Insights terms.

Application Insights | OpenTelemetry
------ | ------
Autocollectors | Instrumentation libraries
Channel | Exporter
Codeless / Agent-based | Autoinstrumentation
Traces | Logs
Requests | Server Spans
Dependencies | Other Span Types (Client, Internal, etc.)
Operation ID | Trace ID
ID or Operation Parent ID | Span ID

## Frequently asked questions

#### Where can I find a list of Application Insights SDK versions and their names?

A list of SDK versions and names is hosted on GitHub. For more information, see [SDK Version](https://github.com/microsoft/ApplicationInsights-dotnet/blob/develop/docs/versions_and_names.md).

## Next steps

Select your enablement approach:

- [Autoinstrumentation](codeless-overview.md)
- Application Insights SDKs
    - [ASP.NET](./asp-net.md)
    - [ASP.NET Core](./asp-net-core.md)
    - [Node.js](./nodejs.md)
    - [Python](/previous-versions/azure/azure-monitor/app/opencensus-python)
    - [JavaScript: Web](./javascript.md)
- [Azure Monitor OpenTelemetry Distro](opentelemetry-enable.md)

Check out the [Azure Monitor Application Insights FAQ](./app-insights-overview.md#frequently-asked-questions) and [OpenTelemetry FAQ](./opentelemetry-help-support-feedback.md#frequently-asked-questions) for more information.
