---
title: Application Insights OpenTelemetry observability overview
description: Learn how Azure Monitor Application Insights integrates with OpenTelemetry (OTel) for comprehensive application observability.
ms.topic: overview
ms.date: 04/22/2025

#customer intent: As a developer or site reliability engineer, I want to use OpenTelemetry (OTel), often searched as 'Open Telemetry', with Application Insights so that I can collect, analyze, and monitor application telemetry in a standardized way for improved observability and performance diagnostics.

---

# Introduction to Application Insights - OpenTelemetry observability

Azure Monitor Application Insights is an OpenTelemetry feature of [Azure Monitor](..\overview.md) that offers application performance monitoring (APM) for live web applications. Integrating with OpenTelemetry (OTel) provides a vendor-neutral approach to collecting and analyzing telemetry data, enabling comprehensive observability of your applications.

:::image type="content" source="media/app-insights-overview/app-insights-overview-screenshot.png" alt-text="A screenshot of the Azure Monitor Application Insights user interface displaying an application map." lightbox="media/app-insights-overview/app-insights-overview-screenshot.png":::

---------------------------

## Application Insights Experiences

Application Insights supports OpenTelemetry (OTel) to collect telemetry data in a standardized format across platforms. Integration with Azure services allows for efficient monitoring and diagnostics, improving application observability and performance.

### Investigate

* [Application dashboard](overview-dashboard.md): An at-a-glance assessment of your application's health and performance.
* [Application map](app-map.md): A visual overview of application architecture and components' interactions.
* [Live metrics](live-stream.md): A real-time analytics dashboard for insight into application activity and performance.
* [Transaction search](transaction-search-and-diagnostics.md?tabs=transaction-search): Trace and diagnose transactions to identify issues and optimize performance.
* [Availability view](availability-overview.md): Proactively monitor and test the availability and responsiveness of application endpoints.
* [Failures view](failures-and-performance-views.md?tabs=failures-view): Identify and analyze failures in your application to minimize downtime.
* [Performance view](failures-and-performance-views.md?tabs=performance-view): Review application performance metrics and potential bottlenecks.

### Monitoring

* [Alerts](../alerts/alerts-overview.md): Monitor a wide range of aspects of your application and trigger various actions.
* [Metrics](../essentials/metrics-getting-started.md): Dive deep into metrics data to understand usage patterns and trends.
* [Diagnostic settings](../essentials/diagnostic-settings.md): Configure streaming export of platform logs and metrics to the destination of your choice. 
* [Logs](../logs/log-analytics-overview.md): Retrieve, consolidate, and analyze all data collected into Azure Monitoring Logs.
* [Workbooks](../visualize/workbooks-overview.md): Create interactive reports and dashboards that visualize application monitoring data.

### Usage

* [Users, sessions, and events](usage.md#users-sessions-and-events): Determine when, where, and how users interact with your web app.
* [Funnels](usage.md#funnels): Analyze conversion rates to identify where users progress or drop off in the funnel.
* [Flows](usage.md#user-flows): Visualize user paths on your site to identify high engagement areas and exit points.
* [Cohorts](usage.md#cohorts): Group users by shared characteristics to simplify trend identification, segmentation, and performance troubleshooting.

### Code analysis

* [.NET Profiler](../profiler/profiler-overview.md): Capture, identify, and view performance traces for your application.
* [Code optimizations](../insights/code-optimizations.md): Harness AI to create better and more efficient applications.
* [Snapshot debugger](../snapshot-debugger/snapshot-debugger.md): Automatically collect debug snapshots when exceptions occur in .NET application

---------------------------

## Logic model

The logic model diagram visualizes components of Application Insights and how they interact.

:::image type="content" source="media/app-insights-overview/app-insights-overview-blowout.svg" alt-text="Diagram that shows the path of data as it flows through the layers of the Application Insights service." lightbox="media/app-insights-overview/app-insights-overview-blowout.svg":::

> [!Note]
> Firewall settings must be adjusted for data to reach ingestion endpoints. For more information, see [Azure Monitor endpoint access and firewall configuration](../fundamentals/azure-monitor-network-access.md).

---------------------------

## Supported languages

This section outlines supported scenarios.

For more information about instrumenting applications to enable Application Insights, see [data collection basics](opentelemetry-overview.md).

### Automatic instrumentation (enable without code changes)
* [Autoinstrumentation supported environments and languages](codeless-overview.md#supported-environments-languages-and-resource-providers)

### Manual instrumentation

#### OpenTelemetry Distro

* [ASP.NET Core](opentelemetry-enable.md?tabs=aspnetcore)
* [.NET](opentelemetry-enable.md?tabs=net)
* [Java](opentelemetry-enable.md?tabs=java)
* [Node.js](opentelemetry-enable.md?tabs=nodejs)
* [Python](opentelemetry-enable.md?tabs=python)

#### Client-side JavaScript SDK

* [JavaScript](./javascript.md)
  * [React](./javascript-framework-extensions.md)
  * [React Native](./javascript-framework-extensions.md)
  * [Angular](./javascript-framework-extensions.md)

#### Application Insights SDK (Classic API)

* [ASP.NET Core](./asp-net-core.md)
* [ASP.NET](./asp-net.md)
* [Node.js](./nodejs.md)

### Supported platforms and frameworks

This section lists all supported platforms and frameworks.

#### Azure service integration (portal enablement, Azure Resource Manager deployments)
* [Azure Virtual Machines and Azure Virtual Machine Scale Sets](./azure-vm-vmss-apps.md)
* [Azure App Service](./azure-web-apps.md)
* [Azure Functions](/azure/azure-functions/functions-monitoring)
* [Azure Spring Apps](/azure/spring-apps/enterprise/how-to-application-insights)
* [Azure Cloud Services](./azure-web-apps-net-core.md), including both web and worker roles

#### Logging frameworks
* [`ILogger`](./ilogger.md)
* [Log4Net, NLog, or System.Diagnostics.Trace](./asp-net-trace-logs.md)
* [`Log4J`, Logback, or java.util.logging](./opentelemetry-add-modify.md?tabs=java)
* [LogStash plug-in](https://github.com/Azure/azure-diagnostics-tools/tree/master/Logstash/logstash-output-applicationinsights)
* [Azure Monitor](/archive/blogs/msoms/application-insights-connector-in-oms)

#### Export and data analysis
* [Integrate Log Analytics with Power BI](../logs/log-powerbi.md)

### Unsupported Software Development Kits (SDKs)

Many community-supported Application Insights SDKs exist, but Microsoft only provides support for instrumentation options listed in this article.

---------------------------

## Troubleshooting

For assistance with troubleshooting Application Insights, see [our dedicated troubleshooting documentation](/troubleshoot/azure/azure-monitor/welcome-azure-monitor).

---------------------------

## Help and support

### Azure technical support

For Azure support issues, open an [Azure support ticket](https://azure.microsoft.com/support/create-ticket/).

### General Questions

Post general questions to the [Microsoft Questions and Answers forum](/answers/topics/24223/azure-monitor.html).

### Coding Questions

Post coding questions to [Stack Overflow](https://stackoverflow.com/questions/tagged/azure-application-insights) by using an `azure-application-insights` tag.

### Feedback Community

Leave product feedback for the engineering team in the [Feedback Community](https://feedback.azure.com/d365community/forum/3887dc70-2025-ec11-b6e6-000d3a4f09d0).

---------------------------

## Next steps

- [Data collection basics](opentelemetry-overview.md)
- [Workspace-based resources](create-workspace-resource.md)
- [Automatic instrumentation overview](codeless-overview.md)
- [Application dashboard](overview-dashboard.md)
- [Application Map](app-map.md)
- [Live metrics](live-stream.md)
- [Transaction search](transaction-search-and-diagnostics.md?tabs=transaction-search)
- [Availability overview](availability-overview.md)
- [Users, sessions, and events](usage.md)
- To review frequently asked questions (FAQ), see <a href="application-insights-faq.yml#overview-faq">Overview FAQ</a>
