---
title: Application Insights telemetry data model
description: This article describes the Application Insights telemetry data model including request, dependency, exception, trace, event, metric, PageView, and context.
ms.tgt_pltfrm: ibiza
ms.topic: conceptual
ms.date: 01/31/2024
ms.reviewer: mmcc
---

# Application Insights telemetry data model

[Application Insights](app-insights-overview.md) sends telemetry from your web application to the Azure portal to provide insights into the performance and usage of your application and infrastructure. To help you better understand and organize the telemetry data, we categorize it into distinct types.

The telemetry data model is standardized, making it possible to create platform- and language-independent monitoring. Data collected by Application Insights models this typical application execution pattern:

:::image type="content" source="media/data-model-complete/application-insights-data-model-new.png" lightbox="media/data-model-complete/application-insights-data-model-new.png" alt-text="Diagram that shows the Application Insights telemetry data model.":::

## Types of telemetry

The following types of telemetry are used to monitor the execution of your application. The [Azure Monitor OpenTelemetry Distro](opentelemetry-enable.md) and [Application Insights JavaScript SDK](javascript-sdk.md) collect:

| Telemetry type | Table | Description |
|----------------|-------|-------------|
| [Metric (Default)](#metric) | [`performanceCounters`](../reference/tables/appperformancecounters.md)<br>[`customMetrics`](../reference/tables/appmetrics.md) | Performance counters provide numerical data about various aspects of application and system performance, such as CPU usage and memory consumption. Additionally, custom metrics allow you to define and track specific measurements unique to your application, providing flexibility to monitor custom performance indicators. |
| [Dependency](#dependency) | [`dependencies`](../reference/tables/appdependencies.md) | Tracks calls from your application to an external service or storage, such as a REST API or SQL database, and measures the duration and success of these calls. |
| [Exception](#exception) | [`exceptions`](../reference/tables/appexceptions.md) | Captures error information crucial for troubleshooting and understanding failures. |
| [Request](#request) | [`requests`](../reference/tables/apprequests.md) | Logs HTTP requests received by your application, providing details such as operation ID, duration, and success or failure status. |
| [Browser timings](#browsertimings) | [`browserTimings`](../reference/tables/appbrowsertimings.md) | Measures the performance of web pages from the user's browser, including page load times and network durations |
| [Page view](#pageview) | [`pageViews`](../reference/tables/apppageviews.md) | Tracks the pages viewed by users, providing insights into user navigation and engagement within your application. |
| [Availability](#availability) | [`availabilityResults`](../reference/tables/appavailabilityresults.md) | Monitors the availability and responsiveness of your application by sending web requests at regular intervals and alerting you if the application isn't responding or if the response time is too slow. |
| [Event](#event) | [`customEvents`](../reference/tables/appevents.md) | Typically used to capture user interactions and other significant occurrences within your application, such as button clicks or order checkouts. |
| [Trace](#trace) | [`traces`](../reference/tables/apptraces.md) | Logs application-specific events, such as custom diagnostic messages or logs, which are useful for debugging and monitoring application behavior over time. |

Every telemetry item can define the [context information](#context) like application version or user session ID. Context is a set of strongly typed fields that unblocks certain scenarios. When application version is properly initialized, Application Insights can detect new patterns in application behavior correlated with redeployment.

You can use session ID to calculate an outage or an issue impact on users. Calculating the distinct count of session ID values for a specific failed dependency, error trace, or critical exception gives you a good understanding of an impact.

The Application Insights telemetry model defines a way to [correlate](distributed-trace-data.md) telemetry to the operation of which it's a part. For example, a request can make a SQL Database call and record diagnostics information. You can set the correlation context for those telemetry items that tie it back to the request telemetry.

## Schema improvements

The Application Insights data model is a basic yet powerful way to model your application telemetry. We strive to keep the model simple and slim to support essential scenarios and allow the schema to be extended for advanced use.

To report data model or schema problems and suggestions, use our [GitHub repository](https://github.com/microsoft/ApplicationInsights-dotnet/issues/new/choose).

## Telemetry collected by default

### Request

Request telemetry represents information related to incoming HTTP requests to your application. This type of telemetry helps you monitor the performance and success of your application's web-based services.

A request telemetry item in Application Insights represents the logical sequence of execution triggered by an external request to your application. Every request execution is identified by a unique `id` and `url` that contain all the execution parameters.

You can group requests by logical `name` and define the `source` of this request. Code execution can result in `success` or `fail` and has a certain `duration`. You can further group success and failure executions by using `resultCode`. Start time for the request telemetry is defined on the envelope level.

Request telemetry supports the standard extensibility model by using [custom `properties` and `measurements`](#custom-properties-and-measurements).

### Dependency

Dependency telemetry in Application Insights represents an interaction of the monitored component with a remote component such as SQL or an HTTP endpoint.

### Exception

In [Application Insights](app-insights-overview.md), an instance of exception represents a handled or unhandled exception that occurred during execution of the monitored application.

### PageView

PageView telemetry (in [Application Insights](app-insights-overview.md)) is logged when an application user opens a new page of a monitored application. The `Page` in this context is a logical unit that's defined by the developer to be an application tab or a screen and isn't necessarily correlated to a browser webpage load or a refresh action. This distinction can be further understood in the context of single-page applications (SPAs), where the switch between pages isn't tied to browser page actions. The [`pageViews.duration`](/azure/azure-monitor/reference/tables/pageviews) is the time it takes for the application to present the page to the user.

> [!NOTE]
> * By default, Application Insights SDKs log single `PageView` events on each browser webpage load action, with [`pageViews.duration`](/azure/azure-monitor/reference/tables/pageviews) populated by [browser timing](#measure-browsertiming-in-application-insights). Developers can extend additional tracking of `PageView` events by using the [trackPageView API call](api-custom-events-metrics.md#page-views).
> * The default logs retention is 30 days. If you want to view `PageView` statistics over a longer period of time, you must adjust the setting.

### BrowserTimings

Modern browsers expose measurements for page load actions with the [Performance API](https://developer.mozilla.org/en-US/docs/Web/API/Performance_API). Application Insights simplifies these measurements by consolidating related timings into [standard browser metrics](../essentials/metrics-supported.md#microsoftinsightscomponents) as defined by these processing time definitions:

1. **Client <--> DNS:** Client reaches out to DNS to resolve website hostname, and DNS responds with the IP address.
1. **Client <--> Web Server:** Client creates TCP and then TLS handshakes with the web server.
1. **Client <--> Web Server:** Client sends request payload, waits for the server to execute the request, and receives the first response packet.
1. **Client <--> Web Server:** Client receives the rest of the response payload bytes from the web server.
1. **Client:** Client now has full response payload and has to render contents into the browser and load the DOM.

* `browserTimings/networkDuration` = 1. + 2.
* `browserTimings/sendDuration` = 3.
* `browserTimings/receiveDuration` = 4.
* `browserTimings/processingDuration` = 5.
* `browsertimings/totalDuration` = 1. + 2. + 3. + 4. + 5.
* `pageViews/duration`
    * The `PageView` duration is from the browser's performance timing interface, [`PerformanceNavigationTiming.duration`](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceEntry/duration).
    * If `PerformanceNavigationTiming` is available, that duration is used.
     
If it's not, the *deprecated* [`PerformanceTiming`](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceTiming) interface is used and the delta between [`NavigationStart`](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceTiming/navigationStart) and [`LoadEventEnd`](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceTiming/loadEventEnd) is calculated.
    * The developer specifies a duration value when logging custom `PageView` events by using the [trackPageView API call](api-custom-events-metrics.md#page-views).

:::image type="content" source="media/javascript/page-view-load-time.png" lightbox="media/javascript/page-view-load-time.png" border="false" alt-text="Screenshot that shows the Metrics page in Application Insights showing graphic displays of metrics data for a web application." :::

### Metric

[Application Insights](app-insights-overview.md) supports two types of metric telemetry:

* **Single measurement** is a *name* and a *value*.
* **Preaggregated metric** specifies the minimum (*min*) and maximum (*max*) value of the metric in the aggregation interval and the *standard deviation* of it. It assumes that the aggregation period was one minute.

Application Insights supports several well-known metric names. These metrics are placed into the `performanceCounters` table.

For more information on the Metrics REST API, see [Metrics - Get](/rest/api/application-insights/metrics/get).

## Custom telemetry

### Trace

Trace telemetry in [Application Insights](app-insights-overview.md) represents `printf`-style trace statements that are text searched. `Log4Net`, `NLog`, and other text-based log file entries are translated into instances of this type. The trace doesn't have measurements as an extensibility.

### Event

You can create event telemetry items (in [Application Insights](app-insights-overview.md)) to represent an event that occurred in your application. Typically, it's a user interaction such as a button click or an order checkout. It can also be an application lifecycle event like initialization or a configuration update.

Semantically, events might or might not be correlated to requests. If used properly, event telemetry is more important than requests or traces. Events represent business telemetry and should be subject to separate, less aggressive [sampling](api-filtering-sampling.md).

### Availability

Availability telemetry involves synthetic monitoring, where tests simulate user interactions to verify that the application is available and responsive.

## Custom properties and measurements

### Custom properties

[!INCLUDE [application-insights-data-model-properties](includes/application-insights-data-model-properties.md)]

### Custom measurements

[!INCLUDE [application-insights-data-model-measurements](includes/application-insights-data-model-measurements.md)]

## Context

Every telemetry item might have a strongly typed context field. Every field enables a specific monitoring scenario. Use the custom properties collection to store custom or application-specific contextual information.

| Field | Description | Maximum length (characters) |
|---------|---------|---------|
| **Application version** | Information in the application context fields is always about the application that's sending the telemetry. The application version is used to analyze trend changes in the application behavior and its correlation to the deployments. | 1,024 |
| **Client IP address** | This field is the IP address of the client device. IPv4 and IPv6 are supported. When telemetry is sent from a service, the location context is about the user who initiated the operation in the service. Application Insights extract the geo-location information from the client IP and then truncate it. The client IP by itself can't be used as user identifiable information. | 46 |
| **Device type** | Originally, this field was used to indicate the type of the device the user of the application is using. Today it's used primarily to distinguish JavaScript telemetry with the device type `Browser` from server-side telemetry with the device type `PC`. | 64 |
| **Operation ID** | This field is the unique identifier of the root operation. This identifier allows grouping telemetry across multiple components. For more information, see [Telemetry correlation](distributed-trace-data.md). Either a request or a page view creates the operation ID. All other telemetry sets this field to the value for the containing request or page view. | 128 |
| **Parent operation ID** | This field is the unique identifier of the telemetry item's immediate parent. For more information, see [Telemetry correlation](distributed-trace-data.md). | 128 |
| **Operation name** | This field is the name (group) of the operation. Either a request or a page view creates the operation name. All other telemetry items set this field to the value for the containing request or page view. The operation name is used for finding all the telemetry items for a group of operations (for example, `GET Home/Index`). This context property is used to answer questions like What are the typical exceptions thrown on this page? | 1,024 |
| **Synthetic source of the operation** | This field is the name of the synthetic source. Some telemetry from the application might represent synthetic traffic. It might be the web crawler indexing the website, site availability tests, or traces from diagnostic libraries like the Application Insights SDK itself. | 1,024 |
| **Session ID** | Session ID is the instance of the user's interaction with the app. Information in the session context fields is always about the user. When telemetry is sent from a service, the session context is about the user who initiated the operation in the service. | 64 |
| **Anonymous user ID** | The anonymous user ID (User.Id) represents the user of the application. When telemetry is sent from a service, the user context is about the user who initiated the operation in the service.<br><br>[Sampling](sampling.md) is one of the techniques to minimize the amount of collected telemetry. A sampling algorithm attempts to either sample in or out all the correlated telemetry. An anonymous user ID is used for sampling score generation, so an anonymous user ID should be a random-enough value.<br><br>*The count of anonymous user IDs isn't the same as the number of unique application users. The count of anonymous user IDs is typically higher because each time the user opens your app on a different device or browser, or cleans up browser cookies, a new unique anonymous user ID is allocated. This calculation might result in counting the same physical users multiple times.*<br><br>User IDs can be cross-referenced with session IDs to provide unique telemetry dimensions and establish user activity over a session duration.<br><br>Using an anonymous user ID to store a username is a misuse of the field. Use an authenticated user ID. | 128 |
| **Authenticated user ID** | An authenticated user ID is the opposite of an anonymous user ID. This field represents the user with a friendly name. This ID is only collected by default with the ASP.NET Framework SDK's [`AuthenticatedUserIdTelemetryInitializer`](https://github.com/microsoft/ApplicationInsights-dotnet/blob/develop/WEB/Src/Web/Web/AuthenticatedUserIdTelemetryInitializer.cs).<br><br>Use the Application Insights SDK to initialize the authenticated user ID with a value that identifies the user persistently across browsers and devices. In this way, all telemetry items are attributed to that unique ID. This ID enables querying for all telemetry collected for a specific user (subject to [sampling configurations](sampling.md) and [telemetry filtering](api-filtering-sampling.md)).<br><br>User IDs can be cross-referenced with session IDs to provide unique telemetry dimensions and establish user activity over a session duration. | 1,024 |
| **Account ID** | The account ID, in multitenant applications, is the tenant account ID or name that the user is acting with. It's used for more user segmentation when a user ID and an authenticated user ID aren't sufficient. Examples might be a subscription ID for the Azure portal or the blog name for a blogging platform. | 1,024 |
| **Cloud role** | This field is the name of the role of which the application is a part. It maps directly to the role name in Azure. It can also be used to distinguish micro services, which are part of a single application. | 256 |
| **Cloud role instance** | This field is the name of the instance where the application is running. For example, it's the computer name for on-premises or the instance name for Azure. | 256 |
| **Internal: SDK version** | For more information, see [SDK version](https://github.com/MohanGsk/ApplicationInsights-Home/blob/master/EndpointSpecs/SDK-VERSIONS.md). | 64 |
| **Internal: Node name** | This field represents the node name used for billing purposes. Use it to override the standard detection of nodes. | 256 |

## Frequently asked questions

This section provides answers to common questions.

#### How would I measure the impact of a monitoring campaign?

PageView Telemetry includes URL and you could parse the UTM parameter using a regex function in Kusto.
          
Occasionally, this data might be missing or inaccurate if the user or enterprise disables sending User Agent in browser settings. The [UA Parser regexes](https://github.com/ua-parser/uap-core/blob/master/regexes.yaml) might not include all device information. Or Application Insights might not have adopted the latest updates.

#### Why would a custom measurement succeed without error but the log doesn't show up?

This can occur if you're using string values. Only numeric values work with custom measurements.

## Next steps

Learn how to use the [Application Insights API for custom events and metrics](api-custom-events-metrics.md), including:

* [Custom request telemetry](api-custom-events-metrics.md#trackrequest)
* [Custom dependency telemetry](api-custom-events-metrics.md#trackdependency)
* [Custom trace telemetry](api-custom-events-metrics.md#tracktrace)
* [Custom event telemetry](api-custom-events-metrics.md#trackevent)
* [Custom metric telemetry](api-custom-events-metrics.md#trackmetric)

Set up dependency tracking for:

* [.NET](asp-net-dependencies.md)
* [Java](opentelemetry-enable.md?tabs=java)

To learn more:

* Check out [platforms](app-insights-overview.md#supported-languages) supported by Application Insights.
* Check out standard context properties collection [configuration](configuration-with-applicationinsights-config.md#telemetry-initializers-aspnet).
* Explore [.NET trace logs in Application Insights](asp-net-trace-logs.md).
* Explore [Java trace logs in Application Insights](opentelemetry-add-modify.md?tabs=java#send-custom-telemetry-using-the-application-insights-classic-api).
* Learn about the [Azure Functions built-in integration with Application Insights](/azure/azure-functions/functions-monitoring?toc=/azure/azure-monitor/toc.json) to monitor functions executions.
* Learn how to [configure an ASP.NET Core](asp-net.md) application with Application Insights.
* Learn how to [diagnose exceptions in your web apps with Application Insights](asp-net-exceptions.md).
* Learn how to [extend and filter telemetry](api-filtering-sampling.md).
* Use [sampling](sampling.md) to minimize the amount of telemetry based on data model.
