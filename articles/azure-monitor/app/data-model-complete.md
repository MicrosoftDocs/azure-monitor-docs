---
title: Application Insights telemetry data model
description: This article describes the Application Insights telemetry data model and its different telemetry types.
ms.tgt_pltfrm: ibiza
ms.topic: how-to
ms.date: 04/30/2025
---

# Application Insights telemetry data model

[Application Insights](app-insights-overview.md) sends telemetry from your web application to the Azure portal to provide insights into the performance and usage of your application and infrastructure. To help you better understand and organize telemetry data, we categorize it into distinct types.

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
| [Availability](#availability-telemetry) | `availabilityResults` | `AppAvailabilityResults` | Monitors the availability and responsiveness of your application by sending web requests at regular intervals and alerting you if the application isn't responding or if the response time is too slow. |
| [Browser timing](#browser-timing-telemetry) | `browserTimings` | `AppBrowserTimings` | Measures the performance of web pages, including page load times and network durations. |
| [Dependency](#dependency-telemetry) | `dependencies` | `AppDependencies` | Tracks calls from your application to an external service or storage, such as a REST API or SQL database, and measures the duration and success of these calls. |
| [Event](#event-telemetry) | `customEvents` | `AppEvents` | Typically used to capture user interactions and other significant occurrences within your application, such as button clicks or order checkouts, to analyze usage patterns. |
| [Exception](#exception-telemetry) | `exceptions` | `AppExceptions` | Captures error information crucial for troubleshooting and understanding failures. |
| [Metric](#metric-telemetry) | `performanceCounters`<br><br>`customMetrics` | `AppPerformanceCounters`<br><br>`AppMetrics` | Performance counters provide numerical data about various aspects of application and system performance, such as CPU usage and memory consumption.<br><br>Additionally, custom metrics allow you to define and track specific measurements unique to your application, providing flexibility to monitor custom performance indicators. |
| [Page view](#page-view-telemetry) | `pageViews` | `AppPageViews` | Tracks the pages viewed by users, providing insights into user navigation and engagement within your application. |
| [Request](#request-telemetry) | `requests` | `AppRequests` | Logs requests received by your application, providing details such as operation ID, duration, and success or failure status. |
| [Trace](#trace-telemetry) | `traces` | `AppTraces` | Logs application-specific events, such as custom diagnostic messages or trace statements, which are useful for debugging and monitoring application behavior over time. |

> [!IMPORTANT]
> You can query application telemetry from both Application Insights and Log Analytics *(recommended)*, but the table and field names are different. This distinction preserves backward compatibility, for example to ensure that customer dashboards with custom queries created before the Log Analytics naming convention continue to function correctly.
>
> To compare field names in the Azure portal, open **Application Insights** > **Logs**, run a query, and copy the `Id` of a telemetry item (for example, `1234a5b6c7de8f90`). Then, open a new tab in your browser, go to **Log Analytics** > **Logs**, switch to **KQL mode**, and run the query:
>
> ```kusto
> AppDependencies // Notice that table names are also different.
> | where Id == "1234a5b6c7de8f90"
> ```
>
> Expand both telemetry items by selecting the chevron to the left of each row to view all their properties.

Each telemetry item can include [context information](#context) such as the application version or user session ID. Context consists of a set of strongly typed fields that enable different analysis scenarios.

For example, when application version is properly initialized, Application Insights can detect new patterns in application behavior correlated with redeployment. Similarly, you can use session ID to assess the impact of outages or issues on users. By calculating the number of unique session IDs associated with failed dependencies, error traces, or critical exceptions, you gain a clearer picture of user impact.

The Application Insights telemetry model also supports [correlation of telemetry items](distributed-trace-data.md) to the operations they belong to. For example, if a request triggers a SQL Database call, both the request and the dependency call can include diagnostic data and be linked through a shared correlation context, allowing you to trace the full flow of the operation.

This article covers the fields specific to each telemetry type. To view the complete list of available fields (including context fields) for any telemetry type, follow the link provided beneath each relevant table.

## Availability telemetry

Availability telemetry involves synthetic monitoring, where tests simulate user interactions to verify that the application is available and responsive. We recommend setting up [standard availability tests](availability.md) to monitor the availability of your application from various points around the globe, and send your own test information to Application Insights.

**Availability-specific fields:**

| Field name<br>(Application Insights) | Field name<br>(Log Analytics) | Description |
|--------------------------------------|-------------------------------|-------------|
| `id` | `Id` | The unique identifier of an availability test result, used for correlation between individual test executions which can help trace specific failures or patterns over time. For more information, see [Telemetry correlation in Application Insights](distributed-trace-data.md). |
| `name` | `Name` | The name of an availability test. It's defined when creating the test (for example, "Homepage ping test"). |
| `location` | `Location` | The geographical location or data center region from which an availability test was executed (for example, West US, Northern Europe). It helps to identify regional outages or latency issues. |
| `success` | `Success` | This field indicates whether an availability test was successful or not. It's a boolean value where `true` means the test was successful and `false` means it failed. |
| `message` | `Message` | A descriptive message with details about the outcome of the test. It often contains exception details or error responses. |
| `duration` | `Duration` | The amount of time the availability test took to execute. It helps measuring the performance and identifying response time issues. The duration is typically measured in milliseconds. |

For a list of all available fields, see [AppAvailabilityResults](../reference/tables/appavailabilityresults.md).

## Browser timing telemetry

Browsers expose measurements for page load actions with the [Performance API](https://developer.mozilla.org/en-US/docs/Web/API/Performance_API). Application Insights simplifies these measurements by consolidating related timings into [standard browser metrics](../essentials/metrics-supported.md#microsoftinsightscomponents).

**Browser-timing-specific fields:**

| Field name<br>(Application Insights) | Field name<br>(Log Analytics) | Description |
|--------------------------------------|-------------------------------|-------------|
| `networkDuration` | `NetworkDurationMs` | Client reaches out to DNS to resolve website hostname, and DNS responds with the IP address.<br><br>Client creates TCP and then TLS handshakes with the web server. |
| `sendDuration` | `SendDurationMs` | Client sends request payload, waits for the server to execute the request, and receives the first response packet. |
| `receiveDuration` | `ReceiveDurationMs` | Client receives the rest of the response payload bytes from the web server. |
| `processingDuration` | `ProcessingDurationMs` | Client now has full response payload and has to render contents into the browser and load the DOM. |
| `totalDuration` | `TotalDurationMs` | The sum of all browser timings. |

For a list of all available fields, see [AppBrowserTimings](../reference/tables/appbrowsertimings.md).

## Dependency telemetry

A dependency telemetry item represents an interaction of the monitored component with a remote component such as SQL or an HTTP endpoint.

**Dependency-specific fields:**

| Field name<br>(Application Insights) | Field name<br>(Log Analytics) | Description |
|--------------------------------------|-------------------------------|-------------|
| `id` | `Id` | The unique identifier of a dependency call instance, used for correlation with the request telemetry item that corresponds to this dependency call. For more information, see [Telemetry correlation in Application Insights](distributed-trace-data.md). |
| `target` | `Target` | The target site of a dependency call. Examples are server name and host address. For more information, see [Telemetry correlation in Application Insights](distributed-trace-data.md). |
| `type` | `DependencyType` | The dependency type name. It has a low cardinality value for logical grouping of dependencies and interpretation of other fields like `commandName` and `resultCode`. Examples are SQL, Azure table, and HTTP. |
| `name` | `Name` | The name of the command initiated with this dependency call. It has a low cardinality value. Examples are stored procedure name and URL path template. |
| `data` | `Data` | The command initiated by this dependency call. Examples are SQL statement and HTTP URL with all query parameters. |
| `success` | `Success` | This field indicates whether a call was successful or not. It's a boolean value where `true` means the call was successful and `false` means it failed. |
| `resultCode` | `ResultCode` | The result code of a dependency call. Examples are SQL error code and HTTP status code. |
| `duration` | `DurationMs` | The request duration is in the format `DD.HH:MM:SS.MMMMMM`. It must be less than `1000` days. |

For a list of all available fields, see [AppDependencies](../reference/tables/appdependencies.md).

## Event telemetry

You can create event telemetry items to represent an event that occurred in your application. Typically, it's a user interaction such as a button click or an order checkout. It can also be an application lifecycle event like initialization or a configuration update.

To learn more about creating custom event telemetry, see [Add and modify Azure Monitor OpenTelemetry for .NET, Java, Node.js, and Python applications](opentelemetry-add-modify.md#send-custom-events).

**Event-specific fields:**

| Field name<br>(Application Insights) | Field name<br>(Log Analytics) | Description |
|--------------------------------------|-------------------------------|-------------|
| `name` | `Name` | To allow proper grouping and useful metrics, restrict your application so that it generates a few separate event names. For example, don't use a separate name for each generated instance of an event. |

For a list of all available fields, see [AppEvents](../reference/tables/appevents.md).

## Exception telemetry

An exception telemetry item represents a handled or unhandled exception that occurred during execution of the monitored application.

**Exception-specific fields:**

| Field name<br>(Application Insights) | Field name<br>(Log Analytics) | Description |
|--------------------------------------|-------------------------------|-------------|
| `problemId` | `ProblemId` | Identifies where the exception was thrown in code. It's used for exceptions grouping. Typically, it's a combination of an exception type and a function from the call stack. |
| `type` | `ExceptionType` | The specific kind of exception that occurred. This typically includes the namespace and class name, such as `System.NullReferenceException` or `System.InvalidOperationException`. |
| `assembly` | `Assembly` | The assembly where the exception was thrown. This is useful for pinpointing the component of the application responsible for the exception. |
| `method` | `Method` | The method name within the assembly where the exception was thrown. This provides contextual information about where in the code the error occurred. |
| `outerType` | `OuterType` | The type of the outer (wrapping) exception, if the current exception is nested within another exception. This is useful for understanding the context in which the inner exception occurred and can help in tracing the sequence of errors. |
| `outerMessage` | `OuterMessage` | This message provides a human-readable explanation of the outer exception and can be helpful in understanding the broader issue. |
| `outerAssembly` | `OuterAssembly` | The assembly where the outer exception originated. |
| `outerMethod` | `OuterMethod` | The method of the outer exception. This provides detailed information about the point of failure within the outer exception. |
| `severityLevel` | `SeverityLevel` | The trace severity level can be one of the following values: `Verbose`, `Information`, `Warning`, `Error`, or `Critical`. |
| `details` | `Details` | Contains exception information such as the exception message and the call stack. |

For a list of all available fields, see [AppExceptions](../reference/tables/appexceptions.md).

## Metric telemetry

Application Insights supports two types of metric telemetry:

* A **single measurement** has a *name* and a *value*.
* A **preaggregated metric** takes multiple measurements in a 1-minute aggregation period.

### Performance counters

Performance counters are always single measurement metrics with a `name` and a `value`, but come with the additional fields `category`, `counter`, and for Windows applications also `instance`.

**Performance-counter-specific fields:**

| Field name<br>(Application Insights) | Field name<br>(Log Analytics) | Description |
|--------------------------------------|-------------------------------|-------------|
| `name` | `Name` | The name of the metric you want to see in the Application Insights portal. |
| `value` | `Value` | The single value for measurement. It's the sum of individual measurements for the aggregation. |
| `category` | `Category` | Represents a group of related performance counters (for example, `Process`). |
| `counter` | `Counter` | Specifies the particular performance metric being measured within a category (for example, `IO Data Bytes/sec`). |
| `instance` | `Instance` | Identifies a specific occurrence of a counter within a category (for example, `??APP_WIN32_PROC??`). |

For a list of all available fields, see [AppPerformanceCounters](../reference/tables/appperformancecounters.md).

To learn more about metrics, see [Metrics in Application Insights](metrics-overview.md). For more information about the Metrics REST API, see [Metrics - Get](/rest/api/application-insights/metrics/get).

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

### Custom metrics

Custom metrics are performance indicators or business-specific metrics that you define and collect to gain insights that aren't covered by standard metrics. To learn more about custom metrics, see [Custom metrics in Azure Monitor (preview)](../metrics/metrics-custom-overview.md).

**Custom-metric-specific fields:**

<table>
    <thead>
        <tr>
            <th>Field name<br>(Application Insights)</th>
            <th>Field name<br>(Log Analytics)</th>
            <th>Single measurement</th>
            <th>Preaggregated metric</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>name</code></td>
            <td><code>Name</code></td>
            <td colspan = "2">This field is the name of the metric you want to see in the Application Insights portal and UI.</td>
        </tr>
        <tr>
            <td><code>value</code></td>
            <td><code>Value</code></td>
            <td>This field is the single value for measurement. It's the sum of individual measurements for the aggregation.</td>
            <td>For a preaggregated metric, <b>Value</b> equals <b>Sum</b>.</td>
        </tr>
        <tr>
            <td><code>Max</code></td>
            <td><code>Max</code></td>
            <td>For a single measurement metric, <b>Max</b> equals <b>Value</b>.</td>
            <td>This field is the maximum value of the aggregated metric. It shouldn't be set for a measurement.</td>
        </tr>
        <tr>
            <td><code>Min</code></td>
            <td><code>Min</code></td>
            <td>For a single measurement metric, <b>Min</b> equals <b>Value</b>.</td>
            <td>This field is the minimum value of the aggregated metric. It shouldn't be set for a measurement.</td>
        </tr>
        <tr>
            <td><code>Sum</code></td>
            <td><code>Sum</code></td>
            <td>For a single measurement metric, <b>Sum</b> equals <b>Value</b>.</td>
            <td>The sum of all values of the aggregated metric. It shouldn't be set for a measurement.</td>
        </tr>
        <tr>
            <td><code>Count</code></td>
            <td><code>Count</code></td>
            <td>For a single measurement metric, <b>Count</b> is <code>1</code>.</td>
            <td>The number of measurements in a 1-minute aggregation period. It shouldn't be set for a measurement.</td>
        </tr>
    </tbody>
</table>

For a list of all available fields, see [AppMetrics](../reference/tables/appmetrics.md).

> [!NOTE]
> To calculate the average, divide **Sum** by **Count**.

## Page view telemetry

Page view telemetry is logged when an application user opens a new page of a monitored application. The `Page` in this context is a logical unit that's defined by the developer to be an application tab or a screen and isn't necessarily correlated to a browser webpage load or a refresh action.

This distinction can be further understood in the context of single-page applications (SPAs), where the switch between pages isn't tied to browser page actions. The [`pageViews.duration`](/azure/azure-monitor/reference/tables/pageviews) is the time it takes for the application to present the page to the user.

**Page view-specific fields:**

| Field name<br>(Application Insights) | Field name<br>(Log Analytics) | Description |
|--------------------------------------|-------------------------------|-------------|
| `name` | `Name` | The name of the page that was viewed by the user (for example, `"Home"` or `"Shopping Cart"`). |
| `url` | `Url` | The full URL of the page that was viewed. This field is crucial for analyzing traffic and user behavior across the application. |
| `duration` | `DurationMs` | The `PageView` duration is from the browser's performance timing interface, [`PerformanceNavigationTiming.duration`](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceEntry/duration).<br><br>If `PerformanceNavigationTiming` is available, that duration is used. If it's not, the *deprecated* [`PerformanceTiming`](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceTiming) interface is used and the delta between [`NavigationStart`](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceTiming/navigationStart) and [`LoadEventEnd`](https://developer.mozilla.org/en-US/docs/Web/API/PerformanceTiming/loadEventEnd) is calculated.<br><br>The developer specifies a duration value when logging custom `PageView` events by using the [trackPageView API call](api-custom-events-metrics.md#page-views). |

For a list of all available fields, see [AppPageViews](../reference/tables/apppageviews.md).

> [!NOTE]
> * By default, the Application Insights JavaScript SDK logs single `PageView` events on each browser webpage load action, with [`pageViews.duration`](/azure/azure-monitor/reference/tables/pageviews) populated by [browser timing](#browser-timing-telemetry). Developers can extend additional tracking of `PageView` events by using the [trackPageView API call](api-custom-events-metrics.md#page-views).
>
> * The default logs retention is 30 days. If you want to view `PageView` statistics over a longer period of time, you must adjust the setting.

## Request telemetry

Request telemetry represents information related to incoming HTTP requests to your application. This type of telemetry helps you monitor the performance and success of your application's web-based services. A request telemetry item represents the logical sequence of execution triggered by an external request to your application. Every request execution is identified by a unique `id` and `url` that contain all the execution parameters.

You can group requests by logical `name` and define the `source` of this request. Code execution can result in `success` or `fail` and has a certain `duration`. You can further group success and failure executions by using `resultCode`. Start time for the request telemetry is defined on the envelope level. Request telemetry supports the standard extensibility model by using [custom `properties` and `measurements`](#custom-properties-and-measurements).

**Request-specific fields:**

| Field name<br>(Application Insights) | Field name<br>(Log Analytics) | Description |
|--------------------------------------|-------------------------------|-------------|
| `id` | `Id` | The unique identifier of a request call instance, used for correlation between the request and other telemetry items. The ID should be globally unique. For more information, see [Telemetry correlation in Application Insights](distributed-trace-data.md). |
| `source` | `Source` | Source is the source of the request. Examples are the connection string or the IP address of the caller. For more information, see [Telemetry correlation in Application Insights](distributed-trace-data.md). |
| `name` | `Name` | This field is the name of the request and it represents the code path taken to process the request. A low cardinality value allows for better grouping of requests. For HTTP requests, it represents the HTTP method and URL path template like `GET /values/{id}` without the actual `id` value.<br>The Application Insights web SDK sends a request name "as is" about letter case. Grouping on the UI is case sensitive, so `GET /Home/Index` is counted separately from `GET /home/INDEX` even though often they result in the same controller and action execution. The reason for that is that URLs in general are [case sensitive](https://www.w3.org/TR/WD-html40-970708/htmlweb.html). You might want to see if all `404` errors happened for URLs typed in uppercase. |
| `url` | `Url` | URL is the request URL with all query string parameters. |
| `success` | `Success` | Success indicates whether a call was successful or unsuccessful. This field is required. When a request isn't set explicitly to `false`, it's considered to be successful. If an exception or returned error result code interrupted the operation, set this value to `false`.<br><br>For web applications, Application Insights defines a request as successful when the response code is less than `400` or equal to `401`. However, there are cases when this default mapping doesn't match the semantics of the application.<br><br>Response code `404` might indicate "no records," which can be part of regular flow. It also might indicate a broken link. For broken links, you can implement more advanced logic. You can mark broken links as failures only when those links are located on the same site by analyzing the URL referrer. Or you can mark them as failures when they're accessed from the company's mobile application. Similarly, `301` and `302` indicate failure when they're accessed from the client that doesn't support redirect.<br><br>Partially accepted content `206` might indicate a failure of an overall request. For instance, an Application Insights endpoint might receive a batch of telemetry items as a single request. It returns `206` when some items in the batch weren't processed successfully. An increasing rate of `206` indicates a problem that needs to be investigated. Similar logic applies to `207` Multi-Status, where the success might be the worst of separate response codes. |
| `resultCode` | `ResultCode` | The response code is the result of a request execution. It's the HTTP status code for HTTP requests. It might be an `HRESULT` value or an exception type for other request types. |
| `duration` | `DurationMs` | The request duration is formatted as `DD.HH:MM:SS.MMMMMM`. It must be positive and less than `1000` days. This field is required because request telemetry represents the operation with the beginning and the end. |

For a list of all available fields, see [AppRequests](../reference/tables/apprequests.md).

## Trace telemetry

Trace telemetry represents `printf`-style trace statements that are text searched. `Log4Net`, `NLog`, and other text-based log file entries are translated into instances of this type. The trace doesn't have measurements as an extensibility.

**Trace-specific fields:**

| Field name<br>(Application Insights) | Field name<br>(Log Analytics) | Description |
|--------------------------------------|-------------------------------|-------------|
| `message` | `Message` | Trace message. |
| `severityLevel` | `SeverityLevel` | Trace severity level. |

For a list of all available fields, see [AppTraces](../reference/tables/apptraces.md).

> [!NOTE]
> Values for `severityLevel` are enumerated and platform-specific.

## Custom properties and measurements

### Custom properties

[!INCLUDE [application-insights-data-model-properties](includes/application-insights-data-model-properties.md)]

### Custom measurements

[!INCLUDE [application-insights-data-model-measurements](includes/application-insights-data-model-measurements.md)]

## Context

Every telemetry item might have a strongly typed context field. Every field enables a specific monitoring scenario. Use the custom properties collection to store custom or application-specific contextual information.

| Field name<br>(Application Insights) | Field name<br>(Log Analytics) | Description |
|--------------------------------------|-------------------------------|-------------|
| `account_ID` | `user_AccountId` | The account ID, in multitenant applications, is the tenant account ID or name that the user is acting with. It's used for more user segmentation when a user ID and an authenticated user ID aren't sufficient. Examples might be a subscription ID for the Azure portal or the blog name for a blogging platform. |
| `application_Version` | `AppVersion` | Information in the application context fields is always about the application that's sending the telemetry. The application version is used to analyze trend changes in the application behavior and its correlation to the deployments. |
| `appId` | `ResourceGUID` | A unique identifier for your Application Insights resource to distinguish telemetry from different applications. |
| `appName` | N/A | In Application Insights, `appName` is the same as `_ResourceId`. |
| `client_Browser` | `ClientBrowser` | The name of the web browser used by the client. |
| `client_City` | `ClientCity` | The city where the client was located when the telemetry was collected (based on IP geolocation). |
| `client_CountryOrRegion` | `ClientCountryOrRegion` | The country or region where the client was located when the telemetry was collected (based on IP geolocation). |
| `client_IP` | `ClientIP` | The IP address of the client device. IPv4 and IPv6 are supported. When telemetry is sent from a service, the location context is about the user who initiated the operation in the service. Application Insights extracts the geo-location information from the client IP and then truncates it. The client IP by itself can't be used as user identifiable information. |
| `client_OS` | `ClientOS` | Indicates the operating system of the client that generated the telemetry. |
| `client_StateorProvince` | `ClientStateOrProvince` | The state or province where the client was located when the telemetry was collected (based on IP geolocation). |
| `client_Type` | `ClientType` | Describes the type of client device that sent the telemetry (for example, `Browser` or `PC`.) |
| `cloud_RoleInstance` | `AppRoleInstance` | The name of the instance where the application is running. For example, it's the computer name for on-premises or the instance name for Azure. |
| `cloud_RoleName` | `AppRoleName` | The name of the role of which the application is a part. It maps directly to the role name in Azure. It can also be used to distinguish micro services, which are part of a single application. |
| `iKey` | `IKey` | A legacy unique identifier used to associate telemetry data with a specific Application Insights resource. |
| `itemId` | N/A | A unique identifier for a specific telemetry item. |
| `itemCount` | `ItemCount` | The number of occurrences or counts associated with a single telemetry event. |
| `operation_Id` | `OperationId` | The unique identifier of the root operation. This identifier allows grouping telemetry across multiple components. For more information, see [Telemetry correlation](distributed-trace-data.md). Either a request or a page view creates the operation ID. All other telemetry sets this field to the value for the containing request or page view. |
| `operation_Name` | `OperationName` | The name (group) of the operation. Either a request or a page view creates the operation name. All other telemetry items set this field to the value for the containing request or page view. The operation name is used for finding all the telemetry items for a group of operations (for example, `GET Home/Index`). This context property is used to answer questions like What are the typical exceptions thrown on this page? |
| `operation_ParentId` | `ParentId` | The unique identifier of the telemetry item's immediate parent. For more information, see [Telemetry correlation](distributed-trace-data.md). |
| `operation_SyntheticSource` | `SyntheticSource` | The name of the synthetic source. Some telemetry from the application might represent synthetic traffic. It might be the web crawler indexing the website, site availability tests, or traces from diagnostic libraries like the Application Insights SDK itself. |
| `sdkVersion` | `SDKVersion` | The version of the Application Insights SDK that is sending telemetry data. For more information, see [SDK version](https://github.com/MohanGsk/ApplicationInsights-Home/blob/master/EndpointSpecs/SDK-VERSIONS.md). |
| `session_Id` | `SessionId` | Session ID is the instance of the user's interaction with the app. Information in the session context fields is always about the user. When telemetry is sent from a service, the session context is about the user who initiated the operation in the service. |
| `user_AuthenticatedId` | `UserAuthenticatedId` | An authenticated user ID is the opposite of an anonymous user ID. This field represents the user with a friendly name. This ID is only collected by default with the ASP.NET Framework SDK's [`AuthenticatedUserIdTelemetryInitializer`](https://github.com/microsoft/ApplicationInsights-dotnet/blob/main/WEB/Src/Web/Web/AuthenticatedUserIdTelemetryInitializer.cs).<br><br>Use the Application Insights SDK to initialize the authenticated user ID with a value that identifies the user persistently across browsers and devices. In this way, all telemetry items are attributed to that unique ID. This ID enables querying for all telemetry collected for a specific user (subject to [sampling configurations](sampling.md) and [telemetry filtering](api-filtering-sampling.md)).<br><br>User IDs can be cross-referenced with session IDs to provide unique telemetry dimensions and establish user activity over a session duration. |
| `user_Id` | `UserId` | The anonymous user ID represents the user of the application. When telemetry is sent from a service, the user context is about the user who initiated the operation in the service.<br><br>[Sampling](sampling.md) is one of the techniques to minimize the amount of collected telemetry. A sampling algorithm attempts to either sample in or out all the correlated telemetry. An anonymous user ID is used for sampling score generation, so an anonymous user ID should be a random-enough value.<br><br>*The count of anonymous user IDs isn't the same as the number of unique application users. The count of anonymous user IDs is typically higher because each time the user opens your app on a different device or browser, or cleans up browser cookies, a new unique anonymous user ID is allocated. This calculation might result in counting the same physical users multiple times.*<br><br>User IDs can be cross-referenced with session IDs to provide unique telemetry dimensions and establish user activity over a session duration.<br><br>Using an anonymous user ID to store a username is a misuse of the field. Use an authenticated user ID. |
| `_ResourceId` | `_ResourceId` | The full Azure Resource ID of the Application Insights component, which includes the subscription, resource group, and resource name. |

## Next steps

* Review frequently asked questions (FAQ): [Telemetry data model FAQ](application-insights-faq.yml#telemetry-data-model)
* Check out [platforms](app-insights-overview.md#supported-languages) supported by Application Insights.
* Learn how to [collect custom telemetry using the Azure Monitor OpenTelemetry Distro](opentelemetry-add-modify.md#collect-custom-telemetry).
* Learn how to use the [Application Insights API for custom events and metrics](api-custom-events-metrics.md).
* Learn how to [extend and filter telemetry](api-filtering-sampling.md).
* Learn how to use [sampling](sampling.md) to minimize the amount of telemetry based on data model.

