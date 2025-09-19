---
ms.topic: include
ms.date: 3/21/2025
---

## Application Insights API for custom events and metrics

Insert a few lines of code in your application to find out what users are doing with it, or to help diagnose issues. You can send telemetry from device and desktop apps, web clients, and web servers. Use the [Application Insights](../app-insights-overview.md) core telemetry API to send custom events and metrics and your own versions of standard telemetry. This API is the same API that the standard Application Insights data collectors use.

### API summary

The core API is uniform across all platforms, apart from a few variations like `GetMetric` (.NET only).

| Method | Used for |
|--------|----------|
| [`TrackPageView`](#page-views) | Pages, screens, panes, or forms. |
| [`TrackEvent`](#trackevent) | User actions and other events. Used to track user behavior or to monitor performance. |
| [`TrackMetric`](#trackmetric) | Performance measurements such as queue lengths not related to specific events. |
| [`TrackException`](#trackexception) | Logging exceptions for diagnosis. Trace where they occur in relation to other events and examine stack traces. |
| [`TrackRequest`](#trackrequest) | Logging the frequency and duration of server requests for performance analysis. |
| [`TrackTrace`](#tracktrace) | Resource Diagnostic log messages. You can also capture third-party logs. |
| [`TrackDependency`](#trackdependency) | Logging the duration and frequency of calls to external components that your app depends on. |

You can [attach properties and metrics](#properties) to most of these telemetry calls.

### Prerequisites

If you don't have a reference on Application Insights SDK yet:

* Add the Application Insights SDK to your project.

* In your device or web server code, include:

    ```java
    import com.microsoft.applicationinsights.TelemetryClient;
    ```

### Get a TelemetryClient instance

Get an instance of `TelemetryClient`:

```java
private TelemetryClient telemetry = new TelemetryClient();
```

`TelemetryClient` is thread safe.

> [!NOTE]
> If you use Azure Functions v2+ or Azure WebJobs v3+, see [Monitor Azure Functions](/azure/azure-functions/functions-monitoring).

You might want to create more instances of `TelemetryClient` for other modules of your app. For example, you might have one `TelemetryClient` instance in your middleware class to report business logic events. You can set properties such as `UserId` and `DeviceId` to identify the machine. This information is attached to all events that the instance sends.

```java
telemetry.getContext().getUser().setId("...");
telemetry.getContext().getDevice().setId("...");
```

### TrackEvent

In Application Insights, a *custom event* is a data point that you can display in [Metrics Explorer](../../metrics/analyze-metrics.md) as an aggregated count and in [Diagnostic Search](../failures-performance-transactions.md?tabs=transaction-search) as individual occurrences. (It isn't related to MVC or other framework "events.")

Insert `TrackEvent` calls in your code to count various events. For example, you might want to track how often users choose a particular feature. Or you might want to know how often they achieve certain goals or make specific types of mistakes.

For example, in a game app, send an event whenever a user wins the game:

```java
telemetry.trackEvent("WinGame");
```

#### Custom events in Log Analytics

The telemetry is available in the `customEvents` table on the [Application Insights Logs tab](../../logs/log-query-overview.md) or [usage experience](../usage.md). Events might come from `trackEvent(..)` or the [Click Analytics Auto-collection plug-in](../javascript-feature-extensions.md).

If [sampling](../sampling.md) is in operation, the `itemCount` property shows a value greater than `1`. For example, `itemCount==10` means that of 10 calls to `trackEvent()`, the sampling process transmitted only one of them. To get a correct count of custom events, use code such as `customEvents | summarize sum(itemCount)`.

> [!NOTE]
> itemCount has a minimum value of one; the record itself represents an entry.

### TrackMetric

Application Insights can chart metrics that aren't attached to particular events. For example, you could monitor a queue length at regular intervals. With metrics, the individual measurements are of less interest than the variations and trends, and so statistical charts are useful.

To send metrics to Application Insights, you can use the `TrackMetric(..)` API. There are two ways to send a metric:

* **Single value**. Every time you perform a measurement in your application, you send the corresponding value to Application Insights.

    For example, assume you have a metric that describes the number of items in a container. During a particular time period, you first put three items into the container and then you remove two items. Accordingly, you would call `TrackMetric` twice. First, you would pass the value `3` and then pass the value `-2`. Application Insights stores both values for you.

* **Aggregation**. When you work with metrics, every single measurement is rarely of interest. Instead, a summary of what happened during a particular time period is important. Such a summary is called _aggregation_.

    In the preceding example, the aggregate metric sum for that time period is `1` and the count of the metric values is `2`. When you use the aggregation approach, you invoke `TrackMetric` only once per time period and send the aggregate values. We recommend this approach because it can significantly reduce the cost and performance overhead by sending fewer data points to Application Insights, while still collecting all relevant information.

#### Single value examples

To send a single metric value:

```java
telemetry.trackMetric("queueLength", 42.0);
```

#### Custom metrics in Log Analytics

The telemetry is available in the `customMetrics` table in [Application Insights Analytics](../logs/log-query-overview.md). Each row represents a call to `trackMetric(..)` in your app.

* `valueSum`: The sum of the measurements. To get the mean value, divide by `valueCount`.
* `valueCount`: The number of measurements that were aggregated into this `trackMetric(..)` call.

> [!NOTE]
> valueCount has a minimum value of one; the record itself represents an entry.

### Page views

In a device or webpage app, page view telemetry is sent by default when each screen or page is loaded. But you can change the default to track page views at more or different times. For example, in an app that displays tabs or panes, you might want to track a page whenever the user opens a new pane.

User and session data is sent as properties along with page views, so the user and session charts come alive when there's page view telemetry.

#### Custom page views

```java
telemetry.trackPageView("GameReviewPage");
```

#### Page telemetry in Log Analytics

In [Log Analytics](../logs/log-query-overview.md), two tables show data from browser operations:

* `pageViews`: Contains data about the URL and page title.
* `browserTimings`: Contains data about client performance like the time taken to process the incoming data.

To find how long the browser takes to process different pages:

```kusto
browserTimings
| summarize avg(networkDuration), avg(processingDuration), avg(totalDuration) by name
```

To discover the popularity of different browsers:

```kusto
pageViews
| summarize count() by client_Browser
```

To associate page views to AJAX calls, join with dependencies:

```kusto
pageViews
| join (dependencies) on operation_Id
```

### TrackRequest

The server SDK uses `TrackRequest` to log HTTP requests.

You can also call it yourself if you want to simulate requests in a context where you don't have the web service module running.

The recommended way to send request telemetry is where the request acts as an <a href="#operation-context">operation context</a>.

### Operation context

You can correlate telemetry items together by associating them with operation context. The standard request-tracking module does this for exceptions and other events that are sent while an HTTP request is being processed. In [Search](../failures-performance-transactions.md?tabs=transaction-search) and [Analytics](../logs/log-query-overview.md), you can easily find any events associated with the request by using its operation ID.

Telemetry items reported within a scope of operation become children of such an operation. Operation contexts could be nested.

In **Search**, the operation context is used to create the **Related Items** list.

:::image type="content" source="media/dot-net/related-items-list.png" lightbox="media/dot-net/related-items-list.png" alt-text="Screenshot that shows the Related Items list.":::

#### Requests in Log Analytics

In [Application Insights Analytics](../../logs/log-query-overview.md), requests show up in the `requests` table.

If [sampling](../sampling.md) is in operation, the `itemCount` property shows a value greater than `1`. For example, `itemCount==10` means that of 10 calls to `trackRequest()`, the sampling process transmitted only one of them. To get a correct count of requests and average duration segmented by request names, use code such as:

```kusto
requests
| summarize count = sum(itemCount), avgduration = avg(duration) by name
```

### TrackException

Send exceptions to Application Insights:

* To [count them](../../metrics/analyze-metrics.md), as an indication of the frequency of a problem.
* To [examine individual occurrences](../failures-performance-transactions.md?tabs=transaction-search).

The reports include the stack traces.

```java
try {
    ...
} catch (Exception ex) {
    telemetry.trackException(ex);
}
```

[Exceptions are caught automatically](../opentelemetry-enable.md?tabs=java), so you don't always have to call `TrackException` explicitly.


#### Exceptions in Log Analytics

In [Application Insights Analytics](../../logs/log-query-overview.md), exceptions show up in the `exceptions` table.

If [sampling](../sampling.md) is in operation, the `itemCount` property shows a value greater than `1`. For example, `itemCount==10` means that of 10 calls to `trackException()`, the sampling process transmitted only one of them. To get a correct count of exceptions segmented by type of exception, use code such as:

```kusto
exceptions
| summarize sum(itemCount) by type
```

Most of the important stack information is already extracted into separate variables, but you can pull apart the `details` structure to get more. Because this structure is dynamic, you should cast the result to the type you expect. For example:

```kusto
exceptions
| extend method2 = tostring(details[0].parsedStack[1].method)
```

To associate exceptions with their related requests, use a join:

```kusto
exceptions
| join (requests) on operation_Id
```

### TrackTrace

Use `TrackTrace` to help diagnose problems by sending a "breadcrumb trail" to Application Insights. You can send chunks of diagnostic data and inspect them in [Diagnostic Search](../failures-performance-transactions.md?tabs=transaction-search).

> [!NOTE]
> In Java, the [Application Insights Java agent](../opentelemetry-enable.md?tabs=java) autocollects and sends logs to the portal.

```java
telemetry.trackTrace(message, SeverityLevel.Warning, properties);
```

Log a diagnostic event such as entering or leaving a method.

| Parameter | Description |
|-----------|-------------|
| `message` | Diagnostic data. Can be much longer than a name. |
| `properties` | Map of string to string. More data is used to [filter exceptions](#properties) in the portal. Defaults to empty. |
| `severityLevel` | Supported values: [SeverityLevel.ts](https://github.com/microsoft/ApplicationInsights-JS/blob/17ef50442f73fd02a758fbd74134933d92607ecf/shared/AppInsightsCommon/src/Interfaces/Contracts/Generated/SeverityLevel.ts). |

You can search on message content, but unlike property values, you can't filter on it.

The size limit on `message` is much higher than the limit on properties. An advantage of `TrackTrace` is that you can put relatively long data in the message. For example, you can encode POST data there.

You can also add a severity level to your message. And, like other telemetry, you can add property values to help you filter or search for different sets of traces. For example:

```java
Map<String, Integer> properties = new HashMap<>();
properties.put("Database", db.ID);
telemetry.trackTrace("Slow Database response", SeverityLevel.Warning, properties);
```

In [Search](../failures-performance-transactions.md?tabs=transaction-search), you can then easily filter out all the messages of a particular severity level that relate to a particular database.

#### Traces in Log Analytics

In [Application Insights Analytics](../../logs/log-query-overview.md), calls to `TrackTrace` show up in the `traces` table.

If [sampling](../sampling.md) is in operation, the `itemCount` property shows a value greater than `1`. For example, `itemCount==10` means that of 10 calls to `trackTrace()`, the sampling process transmitted only one of them. To get a correct count of trace calls, use code such as `traces | summarize sum(itemCount)`.

### TrackDependency

Use the `TrackDependency` call to track the response times and success rates of calls to an external piece of code. The results appear in the dependency charts in the portal. The following code snippet must be added wherever a dependency call is made.

```java
boolean success = false;
Instant startTime = Instant.now();
try {
    success = dependency.call();
}
finally {
    Instant endTime = Instant.now();
    Duration delta = Duration.between(startTime, endTime);
    RemoteDependencyTelemetry dependencyTelemetry = new RemoteDependencyTelemetry("My Dependency", "myCall", delta, success);
    dependencyTelemetry.setTimeStamp(startTime);
    telemetry.trackDependency(dependencyTelemetry);
}
```

> [!NOTE]
> In Java, many dependency calls can be automatically tracked by using the [Application Insights Java agent](opentelemetry-enable.md?tabs=java).

You use this call if you want to track calls that the automated tracking doesn't catch.

#### Dependencies in Log Analytics

In [Application Insights Analytics](../../logs/log-query-overview.md), `trackDependency` calls show up in the `dependencies` table.

If [sampling](../sampling.md) is in operation, the `itemCount` property shows a value greater than 1. For example, `itemCount==10` means that of 10 calls to `trackDependency()`, the sampling process transmitted only one of them. To get a correct count of dependencies segmented by target component, use code such as:

```kusto
dependencies
| summarize sum(itemCount) by target
```

To associate dependencies with their related requests, use a join:

```kusto
dependencies
| join (requests) on operation_Id
```

### Flushing data

Normally, the SDK sends data at fixed intervals, typically 30 seconds, or whenever the buffer is full, which is typically 500 items. In some cases, you might want to flush the buffer. An example is if you're using the SDK in an application that shuts down.

```java
telemetry.flush();
//Allow some time for flushing before shutting down
Thread.sleep(5000);
```

> [!NOTE]
> * The Java SDK automatically flushes on application shutdown.

### Authenticated users

In a web app, users are [identified by cookies](usage.md#users-sessions-and-events) by default. A user might be counted more than once if they access your app from a different machine or browser, or if they delete cookies.

If users sign in to your app, you can get a more accurate count by setting the authenticated user ID in the browser code. It isn't necessary to use the user's actual sign-in name. It only has to be an ID that is unique to that user. It must not include spaces or any of the characters `,;=|`.

The user ID is also set in a session cookie and sent to the server. If the server SDK is installed, the authenticated user ID is sent as part of the context properties of both client and server telemetry. You can then filter and search on it.

If your app groups users into accounts, you can also pass an identifier for the account. The same character restrictions apply.

In [Metrics Explorer](../essentials/metrics-charts.md), you can create a chart that counts **Users, Authenticated**, and **User accounts**.

You can also [search](../failures-performance-transactions.md?tabs=transaction-search) for client data points with specific user names and accounts.

### Filter, search, and segment your data by using properties

You can attach properties and measurements to your events, metrics, page views, exceptions, and other telemetry data.

*Properties* are string values that you can use to filter your telemetry in the usage reports. For example, if your app provides several games, you can attach the name of the game to each event so that you can see which games are more popular.

There's a limit of 8,192 on the string length. If you want to send large chunks of data, use the message parameter of `TrackTrace`.

*Metrics* are numeric values that can be presented graphically. For example, you might want to see if there's a gradual increase in the scores that your gamers achieve. The graphs can be segmented by the properties that are sent with the event so that you can get separate or stacked graphs for different games.

Metric values should be greater than or equal to 0 to display correctly.

There are some [limits on the number of properties, property values, and metrics](#limits) that you can use.

```java
Map<String, String> properties = new HashMap<String, String>();
properties.put("game", currentGame.getName());
properties.put("difficulty", currentGame.getDifficulty());

Map<String, Double> metrics = new HashMap<String, Double>();
metrics.put("Score", currentGame.getScore());
metrics.put("Opponents", currentGame.getOpponentCount());

telemetry.trackEvent("WinGame", properties, metrics);
```

> [!IMPORTANT]
> Make sure you don't log personally identifiable information in properties.

> [!WARNING]
> Don't reuse the same telemetry item instance (`event` in this example) to call `Track*()` multiple times. This practice might cause telemetry to be sent with incorrect configuration.

#### Custom measurements and properties in Log Analytics

In [Log Analytics](../logs/log-query-overview.md), custom metrics and properties show in the `customMeasurements` and `customDimensions` attributes of each telemetry record.

For example, if you add a property named "game" to your request telemetry, this query counts the occurrences of different values of "game" and shows the average of the custom metric "score":

```kusto
requests
| summarize sum(itemCount), avg(todouble(customMeasurements.score)) by tostring(customDimensions.game)
```

Notice that:

* When you extract a value from the `customDimensions` or `customMeasurements` JSON, it has dynamic type, so you must cast it `tostring` or `todouble`.
* To take account of the possibility of [sampling](../sampling.md), use `sum(itemCount)` not `count()`.

### Timing events

Sometimes you want to chart how long it takes to perform an action. For example, you might want to know how long users take to consider choices in a game. To obtain this information, use the measurement parameter.

```java
long startTime = System.currentTimeMillis();

// Perform timed action

long endTime = System.currentTimeMillis();
Map<String, Double> metrics = new HashMap<>();
metrics.put("ProcessingTime", (double)endTime-startTime);

// Setup some properties
Map<String, String> properties = new HashMap<>();
properties.put("signalSource", currentSignalSource.getName());

// Send the event
telemetry.trackEvent("SignalProcessed", properties, metrics);
```

### Default properties for custom telemetry

If you want to set default property values for some of the custom events that you write, set them in a `TelemetryClient` instance. They're attached to every telemetry item that's sent from that client.

```java
import com.microsoft.applicationinsights.TelemetryClient;
import com.microsoft.applicationinsights.TelemetryContext;
...

TelemetryClient gameTelemetry = new TelemetryClient();
TelemetryContext context = gameTelemetry.getContext();
context.getProperties().put("Game", currentGame.Name);

gameTelemetry.TrackEvent("WinGame");
```

Individual telemetry calls can override the default values in their property dictionaries.

### Disable telemetry

To *dynamically stop and start* the collection and transmission of telemetry:

```java
telemetry.getConfiguration().setTrackingDisabled(true);
```

### Dynamic connection string

To avoid mixing up telemetry from development, test, and production environments, you can [create separate Application Insights resources](../create-workspace-resource.md) and change their connection strings, depending on the environment.

Instead of getting the connection string from the configuration file, you can set it in the initialization method of your code:

```java
// Initialize once, e.g., at startup
TelemetryClient telemetry = new TelemetryClient();

// Prefer env var; falls back to hard-coded for illustration
String cs = System.getenv("APPLICATIONINSIGHTS_CONNECTION_STRING");
if (cs != null && !cs.isEmpty()) {
    telemetry.getContext().setConnectionString(cs);
}
```

### TelemetryContext

`TelemetryClient` has a Context property, which contains values that are sent along with all telemetry data. They're normally set by the standard telemetry modules, but you can also set them yourself. For example:

```csharp
telemetry.Context.Operation.Name = "MyOperationName";
```

If you set any of these values yourself, consider removing the relevant line from *ApplicationInsights.config* so that your values and the standard values don't get confused.

* **Component**: The app and its version.
* **Device**: Data about the device where the app is running. In web apps, it's the server or client device that the telemetry is sent from.
* **InstrumentationKey**: The Application Insights resource in Azure where the telemetry appears.
* **Location**: The geographic location of the device.
* **Operation**: In web apps, the current HTTP request. In other app types, you can set this value to group events together.
    * **ID**: A generated value that correlates different events so that when you inspect any event in Diagnostic Search, you can find related items.
    * **Name**: An identifier, usually the URL of the HTTP request.
    * **SyntheticSource**: If not null or empty, a string that indicates that the source of the request has been identified as a robot or web test. By default, it's excluded from calculations in Metrics Explorer.
* **Session**: The user's session. The ID is set to a generated value, which is changed when the user hasn't been active for a while.
* **User**: User information.

### Limits

[!INCLUDE [application-insights-limits](application-insights-limits.md)]

To avoid hitting the data rate limit, use [sampling](../sampling.md).

To determine how long data is kept, see [Data retention and privacy](/previous-versions/azure/azure-monitor/app/data-retention-privacy).

