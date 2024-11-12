---
title: Application Insights overview
description: Learn how Application Insights in Azure Monitor provides performance management and usage tracking of your live web application.
ms.topic: overview
ms.date: 11/16/2024
---

# Application Insights overview

Azure Monitor Application Insights, a feature of [Azure Monitor](..\overview.md), excels in application performance monitoring (APM) for live web applications.

:::image type="content" source="media/app-insights-overview/app-insights-overview-screenshot.png" alt-text="A screenshot of the Azure Monitor Application Insights user interface displaying an application map." lightbox="media/app-insights-overview/app-insights-overview-screenshot.png":::

---------------------------

## Experiences

Application Insights provides many experiences to enhance the performance, reliability, and quality of your applications.

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

* [Users, sessions, and events](usage.md#users-sessions-and-events---analyze-telemetry-from-three-perspectives): Determine when, where, and how users interact with your web app.
* [Funnels](usage.md#funnels---discover-how-customers-use-your-application): Analyze conversion rates to identify where users progress or drop off in the funnel.
* [Flows](usage.md#user-flows---analyze-user-navigation-patterns): Visualize user paths on your site to identify high engagement areas and exit points.
* [Cohorts](usage.md#cohorts---analyze-a-specific-set-of-users-sessions-events-or-operations): Group users by shared characteristics to simplify trend identification, segmentation, and performance troubleshooting.

### Code analysis

* [Profiler](../profiler/profiler-overview.md): Capture, identify, and view performance traces for your application.
* [Code optimizations](../insights/code-optimizations.md): Harness AI to create better and more efficient applications.
* [Snapshot debugger](../snapshot-debugger/snapshot-debugger.md): Automatically collect debug snapshots when exceptions occur in .NET application

---------------------------

## Logic model

The logic model diagram visualizes components of Application Insights and how they interact.

:::image type="content" source="media/app-insights-overview/app-insights-overview-blowout.svg" alt-text="Diagram that shows the path of data as it flows through the layers of the Application Insights service." lightbox="media/app-insights-overview/app-insights-overview-blowout.svg":::

> [!Note]
> Firewall settings must be adjusted for data to reach ingestion endpoints. For more information, see [IP addresses used by Azure Monitor](../ip-addresses.md).

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
* [`Log4J`, Logback, or java.util.logging](./opentelemetry-add-modify.md?tabs=java#send-custom-telemetry-using-the-application-insights-classic-api)
* [LogStash plug-in](https://github.com/Azure/azure-diagnostics-tools/tree/master/Logstash/logstash-output-applicationinsights)
* [Azure Monitor](/archive/blogs/msoms/application-insights-connector-in-oms)

#### Export and data analysis
* [Integrate Log Analytics with Power BI](../logs/log-powerbi.md)

### Unsupported Software Development Kits (SDKs)

Many community-supported Application Insights SDKs exist, but Microsoft only provides support for instrumentation options listed in this article.

---------------------------

## Frequently asked questions

This section provides answers to common questions.

### How do I instrument an application?

For detailed information about instrumenting applications to enable Application Insights, see [data collection basics](opentelemetry-overview.md).

### How do I use Application Insights?

After enabling Application Insights by [instrumenting an application](opentelemetry-overview.md), we suggest first checking out [Live metrics](live-stream.md) and the [Application map](app-map.md).

### What telemetry does Application Insights collect?

From server web apps:

* HTTP requests.
* [Dependencies](./asp-net-dependencies.md). Calls to SQL databases, HTTP calls to external services, Azure Cosmos DB, Azure Table Storage, Azure Blob Storage, and Azure Queue Storage.
* [Exceptions](./asp-net-exceptions.md) and stack traces.
* [Performance counters](./performance-counters.md): Performance counters are available when using:
  * [Azure Monitor Application Insights agent](application-insights-asp-net-agent.md)
  * [Azure monitoring for VMs or virtual machine scale sets](./azure-vm-vmss-apps.md)
  * [Application Insights `collectd` writer](/previous-versions/azure/azure-monitor/app/deprecated-java-2x#collectd-linux-performance-metrics-in-application-insights-deprecated).
* [Custom events and metrics](./api-custom-events-metrics.md) that you code.
* [Trace logs](./asp-net-trace-logs.md) if you configure the appropriate collector.
          
From [client webpages](./javascript-sdk.md):
          
* Uncaught exceptions in your app, including information on
  * Stack trace
  * Exception details and message accompanying the error
  * Line & column number of error
  * URL where error was raised
  * Network Dependency Requests made by your app XML Http Request (XHR) and Fetch (fetch collection is disabled by default) requests, include information on:
      * Url of dependency source
      * Command & Method used to request the dependency
      * Duration of the request
      * Result code and success status of the request
      * ID (if any) of user making the request
      * Correlation context (if any) where request is made
* User information (for example, Location, network, IP)
* Device information (for example, Browser, OS, version, language, model)
* Session information

  > [!Note]
  > For some applications, such as single-page applications (SPAs), the duration may not be recorded and will default to 0.

    For more information, see [Data collection, retention, and storage in Application Insights](/previous-versions/azure/azure-monitor/app/data-retention-privacy).
          
From other sources, if you configure them:
          
* [Azure diagnostics](../agents/diagnostics-extension-to-application-insights.md)
* [Import to Log Analytics](../logs/data-collector-api.md)
* [Log Analytics](../logs/data-collector-api.md)
* [Logstash](../logs/data-collector-api.md)


### How many Application Insights resources should I deploy?
To understand the number of Application Insights resources required to cover your application or components across environments, see the [Application Insights deployment planning guide](create-workspace-resource.md#how-many-application-insights-resources-should-i-deploy).

### How can I manage Application Insights resources with PowerShell?
          
You can [write PowerShell scripts](./powershell.md) by using Azure Resource Monitor to:
          
* Create and update Application Insights resources.
* Set the pricing plan.
* Get the instrumentation key.
* Add a metric alert.
* Add an availability test.
          
You can't set up a metrics explorer report or set up continuous export.

### How can I query Application Insights telemetry? 
          
Use the [REST API](/rest/api/application-insights/) to run [Log Analytics](../logs/log-query-overview.md) queries.

### Can I send telemetry to the Application Insights portal?

We recommend the [Azure Monitor OpenTelemetry Distro](opentelemetry-enable.md).

The [ingestion schema](https://github.com/microsoft/ApplicationInsights-dotnet/tree/master/BASE/Schema/PublicSchema) and [endpoint protocol](https://github.com/MohanGsk/ApplicationInsights-Home/blob/master/EndpointSpecs/ENDPOINT-PROTOCOL.md) are available publicly.

### How long does it take for telemetry to be collected?

Most Application Insights data has a latency of under 5 minutes. Some data can take longer, which is typical for larger log files. See the [Application Insights service-level agreement](https://azure.microsoft.com/support/legal/sla/application-insights/v1_2/).    
          
### How does Application Insights handle data collection, retention, storage, and privacy?

#### Collection

Application Insights collects telemetry about your app, including web server telemetry, web page telemetry, and performance counters. This data can be used to monitor your app's performance, health, and usage. You can select the location when you [create a new Application Insights resource](./create-workspace-resource.md).

#### Retention and Storage

Data is sent to an Application Insights [Log Analytics workspace](../logs/log-analytics-workspace-overview.md). You can choose the retention period for raw data, from 30 to 730 days. Aggregated data is retained for 90 days, and debug snapshots are retained for 15 days.

#### Privacy

Application Insights doesn't handle sensitive data by default. We recommend you don't put sensitive data in URLs as plain text and ensure your custom code doesn't collect personal or other sensitive details. During development and testing, check the sent data in your IDE and browser's debugging output windows.

For archived information, see [Data collection, retention, and storage in Application Insights](/previous-versions/azure/azure-monitor/app/data-retention-privacy).

### What is the Application Insights pricing model?

Application Insights is billed through the Log Analytics workspace into which its log data ingested. The default Pay-as-you-go Log Analytics pricing tier includes 5 GB per month of free data allowance per billing account. Learn more about [Azure Monitor logs pricing options](https://azure.microsoft.com/pricing/details/monitor/).
          
### Are there data transfer charges between an Azure web app and Application Insights?

* If your Azure web app is hosted in a datacenter where there's an Application Insights collection endpoint, there's no charge.
* If there's no collection endpoint in your host datacenter, your app's telemetry incurs [Azure outgoing charges](https://azure.microsoft.com/pricing/details/bandwidth/).
          
This answer depends on the distribution of our endpoints, *not* on where your Application Insights resource is hosted.

### Do I incur network costs if my Application Insights resource is monitoring an Azure resource (that is, telemetry producer) in a different region?

Yes, you can incur more network costs, which vary depending on the region the telemetry is coming from and where it's going.
Refer to [Azure bandwidth pricing](https://azure.microsoft.com/pricing/details/bandwidth/) for details.

### What TLS versions does Application Insights support

> [!IMPORTANT]
>  On 1 March 2025, in alignment with the Azure wide legacy TLS retirement, TLS 1.0/1.1 protocol versions and the listed TLS 1.2/1.3 legacy Cipher suites and Elliptical curves will be retired for Application Insights.
To provide best-in-class encryption, Application Insights uses Transport Layer Security (TLS) 1.2 and 1.3 as the encryption mechanisms of choice. 

For any general questions around the legacy TLS problem, see [Solving TLS problems](/security/engineering/solving-tls1-problem) and [Azure Resource Manager TLS Support](/azure/azure-resource-manager/management/tls-support).

## Help and support

### Azure technical support

For Azure support issues, open an [Azure support ticket](https://azure.microsoft.com/support/create-ticket/).

### Microsoft Questions and Answers forum

Post general questions to the [Microsoft Questions and Answers forum](/answers/topics/24223/azure-monitor.html).

### Stack Overflow

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
