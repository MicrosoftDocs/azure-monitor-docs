---
title: Application Insights telemetry data model
description: This article describes the Application Insights telemetry data model including availabilityResults, browserTimings, dependencies, customEvents, exceptions, performanceCounters, customMetrics, pageViews, requests, and traces.
ms.tgt_pltfrm: ibiza
ms.topic: conceptual
ms.date: 01/31/2024
ms.reviewer: mmcc
---

# Application Insights telemetry data model

[Application Insights](app-insights-overview.md) sends telemetry from your web application to the Azure portal to provide insights into the performance and usage of your application and infrastructure. To help you better understand and organize the telemetry data, we categorize it into distinct types. 

The telemetry data model is standardized, making it possible to create platform- and language-independent monitoring. We strive to keep the model simple and slim to support essential scenarios and allow the schema to be extended for advanced use.

Data collected by Application Insights models this typical application execution pattern:

:::image type="content" source="media/data-model-complete/application-insights-data-model.png" lightbox="media/data-model-complete/application-insights-data-model.png" alt-text="Diagram that shows the Application Insights telemetry data model.":::

<sup>1</sup> `availabilityResults` aren't available by default and require availability tests to be set up.<br>
<sup>2</sup> `customEvents` and `customMetrics` are only available with custom instrumentation.

> [!NOTE]
> Application Insights stores logs in the `traces` table for legacy reasons. The spans for *distributed* traces are stored in the `requests` and `dependencies` tables. We plan to resolve this in a future release to avoid any confusion.

## Types of telemetry

The following types of telemetry are used to monitor the execution of your application. The [Azure Monitor OpenTelemetry Distro](opentelemetry-enable.md) and [Application Insights JavaScript SDK](javascript-sdk.md) collect:

| Telemetry type | Table name<br>(Application Insights) | Table name<br>(Log Analytics) | Description |
|----------------|--------------------------------------|-------------------------------|-------------|
| [Availability](#availability) | `availabilityResults` | [AppAvailabilityResults](../reference/tables/appavailabilityresults.md) | Monitors the availability and responsiveness of your application by sending web requests at regular intervals and alerting you if the application isn't responding or if the response time is too slow. |
| [Browser timings](#browsertimings) | `browserTimings` | [AppBrowserTimings](../reference/tables/appbrowsertimings.md) | Measures the performance of web pages, including page load times and network durations. |
| [Dependency](#dependency) | `dependencies` | [AppDependencies](../reference/tables/appdependencies.md) | Tracks calls from your application to an external service or storage, such as a REST API or SQL database, and measures the duration and success of these calls. |
| [Event](#event) | `customEvents` | [AppEvents](../reference/tables/appevents.md) | Typically used to capture user interactions and other significant occurrences within your application, such as button clicks or order checkouts, to analyze usage patterns. |
| [Exception](#exception) | `exceptions` | [AppExceptions](../reference/tables/appexceptions.md) | Captures error information crucial for troubleshooting and understanding failures. |
| [Metric](#metric) | `performanceCounters`<br><br>`customMetrics` | [AppPerformanceCounters](../reference/tables/appperformancecounters.md)<br><br>[AppMetrics](../reference/tables/appmetrics.md) | Performance counters provide numerical data about various aspects of application and system performance, such as CPU usage and memory consumption. Additionally, custom metrics allow you to define and track specific measurements unique to your application, providing flexibility to monitor custom performance indicators. |
| [Page view](#pageview) | `pageViews` | [AppPageViews](../reference/tables/apppageviews.md) | Tracks the pages viewed by users, providing insights into user navigation and engagement within your application. |
| [Request](#request) | `requests` | [AppRequests](../reference/tables/apprequests.md) | Logs requests received by your application, providing details such as operation ID, duration, and success or failure status. |
| [Trace](#trace) | `traces` | [AppTraces](../reference/tables/apptraces.md) | Logs application-specific events, such as custom diagnostic messages or trace statements, which are useful for debugging and monitoring application behavior over time. |

Every telemetry item can define the [context information](#context) like application version or user session ID. Context is a set of strongly typed fields that unblocks certain scenarios. When application version is properly initialized, Application Insights can detect new patterns in application behavior correlated with redeployment.

You can use session ID to calculate an outage or an issue impact on users. Calculating the distinct count of session ID values for a specific failed dependency, error trace, or critical exception gives you a good understanding of an impact.

The Application Insights telemetry model defines a way to [correlate](distributed-trace-data.md) telemetry to the operation of which it's a part. For example, a request can make a SQL Database call and record diagnostics information. You can set the correlation context for those telemetry items that tie it back to the request telemetry.

### Availability

Availability telemetry involves synthetic monitoring, where tests simulate user interactions to verify that the application is available and responsive. We recommend setting up [standard availability tests](availability.md) to monitor the availability of your application from various points around the globe, and send your own test information to Application Insights.

| Field name<br>(Application Insights) | Field name<br>(Log Analytics) | Description |
|--------------------------------------|-------------------------------|-------------|
| **id** | **Id** | The unique identifier of an availability test result, used for correlation between individual test executions which can help trace specific failures or patterns over time. For more information, see [Telemetry correlation in Application Insights](distributed-trace-data.md). |
| **name** | **Name** | The name of an availability test. It's defined when creating the test (for example, "Homepage ping test"). |
| **location** | **Location** | The geographical location or data center region from which an availability test was executed (for example, West US, Northern Europe). It helps to identify regional outages or latency issues. |
| **success** | **Success** | This field indicates whether an availability test was successful or not. It is a boolean value where `true` means the test was successful and `false` means it failed. |
| **message** | **Message** | A descriptive message with details about the outcome of the test. It often contains exception details or error responses. |
| **duration** | **Duration** | The amount of time the availability test took to execute. It helps measuring the performance and identifying response time issues. The duration is typically measured in milliseconds. |

### BrowserTimings

Browsers expose measurements for page load actions with the [Performance API](https://developer.mozilla.org/en-US/docs/Web/API/Performance_API). Application Insights simplifies these measurements by consolidating related timings into [standard browser metrics](../essentials/metrics-supported.md#microsoftinsightscomponents) as defined by these processing time definitions:

| Field name<br>(Application Insights) | Field name<br>(Log Analytics) | Description |
|--------------------------------------|-------------------------------|-------------|
| **name** | **Name** | The name of the page view associated with the browser timing event. |
| **url** | **Url** | The full URL of the web page where the browser timing data was collected. This field is crucial to understand which pages might be experiencing performance issues. |
| **networkDuration** | **NetworkDurationMs** | 1. + 2. |
| **sendDuration** | **SendDurationMs** | 3. |
| **receiveDuration** | **ReceiveDurationMs** | 4. |
| **processingDuration** | **ProcessingDurationMs** | 5. |
| **totalDuration** | **TotalDurationMs** | 1. + 2. + 3. + 4. + 5. |

**Context:**

1. **Client ↔ DNS:** Client reaches out to DNS to resolve website hostname, and DNS responds with the IP address.
1. **Client ↔ Web Server:** Client creates TCP and then TLS handshakes with the web server.
1. **Client ↔ Web Server:** Client sends request payload, waits for the server to execute the request, and receives the first response packet.
1. **Client ← Web Server:** Client receives the rest of the response payload bytes from the web server.
1. **Client:** Client now has full response payload and has to render contents into the browser and load the DOM.

:::image type="content" source="media/data-model-complete/page-view-load-time.png" lightbox="media/data-model-complete/page-view-load-time.png" border="false" alt-text="Screenshot that shows the Metrics page in Application Insights showing graphic displays of metrics data for a web application." :::

### Dependency

A dependency telemetry item represents an interaction of the monitored component with a remote component such as SQL or an HTTP endpoint.

| Field name<br>(Application Insights) | Field name<br>(Log Analytics) | Description |
|--------------------------------------|-------------------------------|-------------|
| **id** | **Id** | The unique identifier of a dependency call instance, used for correlation with the request telemetry item that corresponds to this dependency call. For more information, see [Telemetry correlation in Application Insights](distributed-trace-data.md). |
| **target** | **Target** | The target site of a dependency call. Examples are server name and host address. For more information, see [Telemetry correlation in Application Insights](distributed-trace-data.md). |
| **type** | **DependencyType** | The dependency type name. It has a low cardinality value for logical grouping of dependencies and interpretation of other fields like `commandName` and `resultCode`. Examples are SQL, Azure table, and HTTP. |
| **name** | **Name** | The name of the command initiated with this dependency call. It has a low cardinality value. Examples are stored procedure name and URL path template. |
| **data** | **Data** | The command initiated by this dependency call. Examples are SQL statement and HTTP URL with all query parameters. |
| **success** | **Success** | This field indicates whether a call was successful or not. It is a boolean value where `true` means the call was successful and `false` means it failed. |
| **resultCode** | **ResultCode** | The result code of a dependency call. Examples are SQL error code and HTTP status code. |
| **duration** | **DurationMs** | The request duration is in the format `DD.HH:MM:SS.MMMMMM`. It must be less than `1000` days. |

### Event

You can create event telemetry items to represent an event that occurred in your application. Typically, it's a user interaction such as a button click or an order checkout. It can also be an application lifecycle event like initialization or a configuration update.

Semantically, events might or might not be correlated to requests. If used properly, event telemetry is more important than requests or traces. Events represent business telemetry and should be subject to separate, less aggressive [sampling](api-filtering-sampling.md).

| Field name<br>(Application Insights) | Field name<br>(Log Analytics) | Description | Maximum length (characters) |
|--------------------------------------|-------------------------------|-------------|-----------------------------|
| **name** | **Name** | To allow proper grouping and useful metrics, restrict your application so that it generates a few separate event names. For example, don't use a separate name for each generated instance of an event. | 512 |

### Exception

An exception telemetry item represents a handled or unhandled exception that occurred during execution of the monitored application.

| Field name<br>(Application Insights) | Field name<br>(Log Analytics) | Description | Max length (characters) |
|--------------------------------------|-------------------------------|-------------|-------------------------|
| **problemId** | **ProblemId** | Identifies where the exception was thrown in code. It's used for exceptions grouping. Typically, it's a combination of an exception type and a function from the call stack. | 1,024 |
| **type** | **ExceptionType** | The specific kind of exception that occurred. This typically includes the namespace and class name, such as `System.NullReferenceException` or `System.InvalidOperationException`. | 256 |
| **assembly** | **Assembly** | The assembly where the exception was thrown. This is useful for pinpointing the component of the application responsible for the exception. | 256 |
| **method** | **Method** | The method name within the assembly where the exception was thrown. This provides contextual information about where in the code the error occured. | 256 |
| **outerType** | **OuterType** | The type of the outer (wrapping) exception, if the current exception is nested within another exception. This is useful for understanding the context in which the inner exception occurred and can help in tracing the sequence of errors. | 256 |
| **outerMessage** | **OuterMessage** | This message provides a human-readable explanation of the outer exception and can be helpful in understanding the broader issue. | 32,768 |
| **outerAssembly** | **OuterAssembly** | The assembly where the outer exception originated. | 256 |
| **outerMethod** | **OuterMethod** | The method of the outer exception. This provides detailed information about the point of failure within the outer exception. | 256 |
| **severityLevel** | **SeverityLevel** | The trace severity level can be one of the following values: `Verbose`, `Information`, `Warning`, `Error`, or `Critical`. | |
| **details** | **Details** | Contains exception information such as the exception message and the call stack. | |

### Metric (Performance Counters and Custom Metrics)

Application Insights supports two types of metric telemetry which are placed into the `performanceCounters` table:

* A **single measurement** has a *name* and a *value*.
* A **preaggregated metric** takes multiple measurements in a 1-minute aggregation period.

<table>
    <thead>
        <tr>
            <th>Field</th>
            <th>Single measurement</th>
            <th>Preaggregated metric</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><b>Name</b></td>
            <td colspan = "2">This field is the name of the metric you want to see in the Application Insights portal and UI.</td>
        </tr>
        <tr>
            <td><b>Value</b></td>
            <td>This field is the single value for measurement. It's the sum of individual measurements for the aggregation.</td>
            <td>For a preaggregated metric, <b>Value</b> equals <b>Sum</b>.</td>
        </tr>
        <tr>
            <td><b>Max</b></td>
            <td>For a single measurement metric, <b>Max</b> equals <b>Value</b>.</td>
            <td>This field is the maximum value of the aggregated metric. It shouldn't be set for a measurement.</td>
        </tr>
        <tr>
            <td><b>Min</b></td>
            <td>For a single measurement metric, <b>Min</b> equals <b>Value</b>.</td>
            <td>This field is the minimum value of the aggregated metric. It shouldn't be set for a measurement.</td>
        </tr>
        <tr>
            <td><b>Sum</b></td>
            <td>For a single measurement metric, <b>Sum</b> equals <b>Value</b>.</td>
            <td>The sum of all values of the aggregated metric. It shouldn't be set for a measurement.</td>
        </tr>
        <tr>
            <td><b>Count</b></td>
            <td>For a single measurement metric, <b>Count</b> is <code>1</code>.</td>
            <td>The number of measurements in a 1-minute aggregation period. It shouldn't be set for a measurement.</td>
        </tr>
    </tbody>
</table>

> [!NOTE]
> To calculate the average, divide **Sum** by **Count**.

To learn more, see [Metrics in Application Insights](metrics-overview.md). For more information about the Metrics REST API, see [Metrics - Get](/rest/api/application-insights/metrics/get).

#### System and process counter metrics

| .NET name | Description |
|-----------|-------------|
| `\Processor(_Total)\% Processor Time` | Total machine CPU. |
| `\Memory\Available Bytes` | Shows the amount of physical memory, in bytes, available to processes running on the computer. It's calculated by summing the amount of space on the zeroed, free, and standby memory lists. Free memory is ready for use. Zeroed memory consists of pages of memory filled with zeros to prevent later processes from seeing data used by a previous process. Standby memory is memory that's been removed from a process's working set (its physical memory) en route to disk but is still available to be recalled. See [Memory Object](/previous-versions/ms804008(v=msdn.10)). |
| `\Process(??APP_WIN32_PROC??)\% Processor Time` | CPU of the process hosting the application. |
| `\Process(??APP_WIN32_PROC??)\Private Bytes` | Memory used by the process hosting the application. |
| `\Process(??APP_WIN32_PROC??)\IO Data Bytes/sec` | Rate of I/O operations run by the process hosting the application. |
| `\ASP.NET Applications(??APP_W3SVC_PROC??)\Requests/Sec` | Rate of requests processed by an application. |
| `\.NET CLR Exceptions(??APP_CLR_PROC??)\# of Exceps Thrown / sec` | Rate of exceptions thrown by an application. |
| `\ASP.NET Applications(??APP_W3SVC_PROC??)\Request Execution Time` | Average request execution time. |
| `\ASP.NET Applications(??APP_W3SVC_PROC??)\Requests In Application Queue` | Number of requests waiting for the processing in a queue. |

#### Custom properties

The metric with the custom property `CustomPerfCounter` set to `true` indicates that the metric represents the Windows performance counter. These metrics are placed in the `performanceCounters` table, not in `customMetrics`. Also, the name of this metric is parsed to extract category, counter, and instance names.

### PageView

PageView telemetry is logged when an application user opens a new page of a monitored application. The `Page` in this context is a logical unit that's defined by the developer to be an application tab or a screen and isn't necessarily correlated to a browser webpage load or a refresh action.

This distinction can be further understood in the context of single-page applications (SPAs), where the switch between pages isn't tied to browser page actions. The [`pageViews.duration`](/azure/azure-monitor/reference/tables/pageviews) is the time it takes for the application to present the page to the user.

| Field name<br>(Application Insights) | Field name<br>(Log Analytics) | Description |
|--------------------------------------|-------------------------------|-------------|
| **id** | N/A | The unique identifier of a PageView instance, used for correlation between the PageView and other telemetry items. For more information, see [Telemetry correlation in Application Insights](distributed-trace-data.md). |
| **name** | **Name** | The name of the page that was viewed by the user (for example, `"Home"` or `"Shopping Cart"`). |
| **url** | **Url** | The full URL of the page that was viewed. This field is crucial for analyzing traffic and user behavior across the application. |
| **duration** | **DurationMs** | The `PageView` duration is from the browser's performance timing interface, [`PerformanceNavigationTiming.duration`](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceEntry/duration).<br><br>If `PerformanceNavigationTiming` is available, that duration is used. If it's not, the *deprecated* [`PerformanceTiming`](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceTiming) interface is used and the delta between [`NavigationStart`](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceTiming/navigationStart) and [`LoadEventEnd`](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceTiming/loadEventEnd) is calculated.<br><br>The developer specifies a duration value when logging custom `PageView` events by using the [trackPageView API call](api-custom-events-metrics.md#page-views). |

> [!NOTE]
> * By default, the Application Insights JavaScript SDK logs single `PageView` events on each browser webpage load action, with [`pageViews.duration`](/azure/azure-monitor/reference/tables/pageviews) populated by [browser timing](#browsertimings). Developers can extend additional tracking of `PageView` events by using the [trackPageView API call](api-custom-events-metrics.md#page-views).
>
> * The default logs retention is 30 days. If you want to view `PageView` statistics over a longer period of time, you must adjust the setting.

### Request

Request telemetry represents information related to incoming HTTP requests to your application. This type of telemetry helps you monitor the performance and success of your application's web-based services.

A request telemetry item represents the logical sequence of execution triggered by an external request to your application. Every request execution is identified by a unique `id` and `url` that contain all the execution parameters.

You can group requests by logical `name` and define the `source` of this request. Code execution can result in `success` or `fail` and has a certain `duration`. You can further group success and failure executions by using `resultCode`. Start time for the request telemetry is defined on the envelope level.

Request telemetry supports the standard extensibility model by using [custom `properties` and `measurements`](#custom-properties-and-measurements).

| Field name<br>(Application Insights) | Field name<br>(Log Analytics) | Description | Max length (characters) |
|--------------------------------------|-------------------------------|-------------|-------------------------|
| **id** | **Id** | The unique identifier of a request call instance, used for correlation between the request and other telemetry items. The ID should be globally unique. For more information, see [Telemetry correlation in Application Insights](distributed-trace-data.md). | 128 |
| **source** | **Source** | Source is the source of the request. Examples are the instrumentation key of the caller or the IP address of the caller. For more information, see [Telemetry correlation in Application Insights](distributed-trace-data.md). | 1,024 |
| **name** | **Name** | This field is the name of the request and it represents the code path taken to process the request. A low cardinality value allows for better grouping of requests. For HTTP requests, it represents the HTTP method and URL path template like `GET /values/{id}` without the actual `id` value.<br>The Application Insights web SDK sends a request name "as is" about letter case. Grouping on the UI is case sensitive, so `GET /Home/Index` is counted separately from `GET /home/INDEX` even though often they result in the same controller and action execution. The reason for that is that URLs in general are [case sensitive](https://www.w3.org/TR/WD-html40-970708/htmlweb.html). You might want to see if all `404` errors happened for URLs typed in uppercase. You can read more about request name collection by the ASP.NET web SDK in the [blog post](https://apmtips.com/posts/2015-02-23-request-name-and-url/). | 1,024 |
| **url** | **Url** | URL is the request URL with all query string parameters. | 2,048 |
| **success** | **Success** | Success indicates whether a call was successful or unsuccessful. This field is required. When a request isn't set explicitly to `false`, it's considered to be successful. If an exception or returned error result code interrupted the operation, set this value to `false`.<br><br>For web applications, Application Insights defines a request as successful when the response code is less than `400` or equal to `401`. However, there are cases when this default mapping doesn't match the semantics of the application.<br><br>Response code `404` might indicate "no records," which can be part of regular flow. It also might indicate a broken link. For broken links, you can implement more advanced logic. You can mark broken links as failures only when those links are located on the same site by analyzing the URL referrer. Or you can mark them as failures when they're accessed from the company's mobile application. Similarly, `301` and `302` indicate failure when they're accessed from the client that doesn't support redirect.<br><br>Partially accepted content `206` might indicate a failure of an overall request. For instance, an Application Insights endpoint might receive a batch of telemetry items as a single request. It returns `206` when some items in the batch weren't processed successfully. An increasing rate of `206` indicates a problem that needs to be investigated. Similar logic applies to `207` Multi-Status, where the success might be the worst of separate response codes. | |
| **resultCode** | **ResultCode** | The response code is the result of a request execution. It's the HTTP status code for HTTP requests. It might be an `HRESULT` value or an exception type for other request types. | 1,024 |
| **duration** | **DurationMs** | The request duration is formatted as `DD.HH:MM:SS.MMMMMM`. It must be positive and less than `1000` days. This field is required because request telemetry represents the operation with the beginning and the end. | |

### Trace

Trace telemetry represents `printf`-style trace statements that are text searched. `Log4Net`, `NLog`, and other text-based log file entries are translated into instances of this type. The trace doesn't have measurements as an extensibility.

| Field name<br>(Application Insights) | Field name<br>(Log Analytics) | Description | Values |
|--------------------------------------|-------------------------------|-------------|--------|
| **message** | **Message** | Trace message. | **Maximum length:** 32,768 characters |
| **severityLevel** | **SeverityLevel** | Trace severity level. | **Values:** `Verbose`, `Information`, `Warning`, `Error`, and `Critical` |

## Context

Every telemetry item might have a strongly typed context field. Every field enables a specific monitoring scenario. Use the custom properties collection to store custom or application-specific contextual information.

| Field name<br>(Application Insights) | Field name<br>(Log Analytics) | Description | Maximum length (characters) |
|--------------------------------------|-------------------------------|-------------|-----------------------------|
| **operation_Name** | **OperationName** | The name (group) of the operation. Either a request or a page view creates the operation name. All other telemetry items set this field to the value for the containing request or page view. The operation name is used for finding all the telemetry items for a group of operations (for example, `GET Home/Index`). This context property is used to answer questions like What are the typical exceptions thrown on this page? | 1,024 |
| **operation_Id** | **OperationId** | The unique identifier of the root operation. This identifier allows grouping telemetry across multiple components. For more information, see [Telemetry correlation](distributed-trace-data.md). Either a request or a page view creates the operation ID. All other telemetry sets this field to the value for the containing request or page view. | 128 |
| **operation_ParentId** | **ParentId** | The unique identifier of the telemetry item's immediate parent. For more information, see [Telemetry correlation](distributed-trace-data.md). | 128 |
| **operation_SyntheticSource** | **SyntheticSource** | The name of the synthetic source. Some telemetry from the application might represent synthetic traffic. It might be the web crawler indexing the website, site availability tests, or traces from diagnostic libraries like the Application Insights SDK itself. | 1,024 |
| **session_Id** | **SessionId** | Session ID is the instance of the user's interaction with the app. Information in the session context fields is always about the user. When telemetry is sent from a service, the session context is about the user who initiated the operation in the service. | 64 |
| **user_Id** | **UserId** | ... | ... |
| **application_Version** | **AppVersion** | Information in the application context fields is always about the application that's sending the telemetry. The application version is used to analyze trend changes in the application behavior and its correlation to the deployments. | 1,024 |
| **client_Type** | **ClientType** | ... | ... |
| **client_OS** | **ClientOS** | ... | ... |
| **client_IP** | **ClientIP** | The IP address of the client device. IPv4 and IPv6 are supported. When telemetry is sent from a service, the location context is about the user who initiated the operation in the service. Application Insights extracts the geo-location information from the client IP and then truncates it. The client IP by itself can't be used as user identifiable information. | 46 |
| **client_City** | **ClientCity** | ... | ... |
| **client_StateorProvince** | **ClientStateOrProvince** | ... | ... |
| **client_CountryOrRegion** | **ClientCountryOrRegion** | ... | ... |
| ... | **ClientBrowser** | ... | ... |
| **cloud_RoleName** | **AppRoleName** | The name of the role of which the application is a part. It maps directly to the role name in Azure. It can also be used to distinguish micro services, which are part of a single application. | 256 |
| **cloud_RoleInstance** | **AppRoleInstance** | The name of the instance where the application is running. For example, it's the computer name for on-premises or the instance name for Azure. | 256 |
| **appId** | **ResourceGUID** | ... | ... |
| **appName** | N/A | In Application Insights, `appName` is the same as `_ResourceId`. | ... |
| **iKey** | **IKey** | ... | ... |
| **sdkVersion** | **SDKVersion** | ... | ... |
| **itemId** | N/A | ... | ... |
| **itemCount** | **ItemCount** | ... | ... |
| **_ResourceId** | **_ResourceId** | ... | ... |
| **Account ID** |  | The account ID, in multitenant applications, is the tenant account ID or name that the user is acting with. It's used for more user segmentation when a user ID and an authenticated user ID aren't sufficient. Examples might be a subscription ID for the Azure portal or the blog name for a blogging platform. | 1,024 |
| **Anonymous user ID** |  | The anonymous user ID (User.Id) represents the user of the application. When telemetry is sent from a service, the user context is about the user who initiated the operation in the service.<br><br>[Sampling](sampling.md) is one of the techniques to minimize the amount of collected telemetry. A sampling algorithm attempts to either sample in or out all the correlated telemetry. An anonymous user ID is used for sampling score generation, so an anonymous user ID should be a random-enough value.<br><br>*The count of anonymous user IDs isn't the same as the number of unique application users. The count of anonymous user IDs is typically higher because each time the user opens your app on a different device or browser, or cleans up browser cookies, a new unique anonymous user ID is allocated. This calculation might result in counting the same physical users multiple times.*<br><br>User IDs can be cross-referenced with session IDs to provide unique telemetry dimensions and establish user activity over a session duration.<br><br>Using an anonymous user ID to store a username is a misuse of the field. Use an authenticated user ID. | 128 |
| **Authenticated user ID** |  | An authenticated user ID is the opposite of an anonymous user ID. This field represents the user with a friendly name. This ID is only collected by default with the ASP.NET Framework SDK's [`AuthenticatedUserIdTelemetryInitializer`](https://github.com/microsoft/ApplicationInsights-dotnet/blob/develop/WEB/Src/Web/Web/AuthenticatedUserIdTelemetryInitializer.cs).<br><br>Use the Application Insights SDK to initialize the authenticated user ID with a value that identifies the user persistently across browsers and devices. In this way, all telemetry items are attributed to that unique ID. This ID enables querying for all telemetry collected for a specific user (subject to [sampling configurations](sampling.md) and [telemetry filtering](api-filtering-sampling.md)).<br><br>User IDs can be cross-referenced with session IDs to provide unique telemetry dimensions and establish user activity over a session duration. | 1,024 |
| **Device type** |  | Originally, this field was used to indicate the type of the device the user of the application is using. Today it's used primarily to distinguish JavaScript telemetry with the device type `Browser` from server-side telemetry with the device type `PC`. | 64 |
| **Internal: Node name** |  | The node name used for billing purposes. Use it to override the standard detection of nodes. | 256 |
| **Internal: SDK version** |  | For more information, see [SDK version](https://github.com/MohanGsk/ApplicationInsights-Home/blob/master/EndpointSpecs/SDK-VERSIONS.md). | 64 |

## Custom properties and measurements

### Custom properties

[!INCLUDE [application-insights-data-model-properties](includes/application-insights-data-model-properties.md)]

### Custom measurements

[!INCLUDE [application-insights-data-model-measurements](includes/application-insights-data-model-measurements.md)]

## Frequently asked questions

This section provides answers to common questions.

#### How can I report data model or schema problems and suggestions?

To report data model or schema problems and suggestions, use our [GitHub repository](https://github.com/microsoft/ApplicationInsights-dotnet/issues/new/choose).

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

Examples to set up dependency tracking:

* [.NET](asp-net-dependencies.md)
* [Java](opentelemetry-enable.md?tabs=java)

To learn more:

* Check out [platforms](app-insights-overview.md#supported-languages) supported by Application Insights.
* Check out standard context properties collection [configuration](configuration-with-applicationinsights-config.md#telemetry-initializers-aspnet).
* Explore [.NET trace logs in Application Insights](asp-net-trace-logs.md).
* Explore [Java trace logs in Application Insights](opentelemetry-add-modify.md?tabs=java#send-custom-telemetry-using-the-application-insights-classic-api).
* Learn about the [Azure Functions built-in integration with Application Insights](/azure/azure-functions/functions-monitoring?toc=/azure/azure-monitor/toc.json) to monitor functions executions.
* Learn how to [diagnose exceptions in your web apps with Application Insights](asp-net-exceptions.md).
* Learn how to [extend and filter telemetry](api-filtering-sampling.md).
* Learn how to use [sampling](sampling.md) to minimize the amount of telemetry based on data model.
