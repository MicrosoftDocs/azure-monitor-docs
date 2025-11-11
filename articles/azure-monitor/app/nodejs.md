## Basic usage

For out-of-the-box collection of HTTP requests, popular third-party library events, unhandled exceptions, and system metrics:

```javascript
let appInsights = require("applicationinsights");
appInsights.setup("[your connection string]").start();
```

> [!NOTE]
> If the connection string is set in the environment variable `APPLICATIONINSIGHTS_CONNECTION_STRING`, `.setup()` can be called with no arguments. This makes it easy to use different connection strings for different environments.

Load the Application Insights library `require("applicationinsights")` as early as possible in your scripts before you load other packages. This step is needed so that the Application Insights library can prepare later packages for tracking. If you encounter conflicts with other libraries doing similar preparation, try loading the Application Insights library afterwards.

Because of the way JavaScript handles callbacks, more work is necessary to track a request across external dependencies and later callbacks. By default, this extra tracking is enabled. Disable it by calling `setAutoDependencyCorrelation(false)` as described in the [SDK configuration](#sdk-configuration) section.






## Migrate from versions prior to 0.22

There are breaking changes between releases prior to version 0.22 and after. These changes are designed to bring consistency with other Application Insights SDKs and allow future extensibility.

In general, you can migrate with the following actions:

* Replace references to `appInsights.client` with `appInsights.defaultClient`.
* Replace references to `appInsights.getClient()` with `new appInsights.TelemetryClient()`.
* Replace all arguments to client.track* methods with a single object containing named properties as arguments. See your IDE's built-in type hinting or [TelemetryTypes](https://github.com/Microsoft/ApplicationInsights-node.js/tree/develop/Declarations/Contracts/TelemetryTypes) for the excepted object for each type of telemetry.

If you access SDK configuration functions without chaining them to `appInsights.setup()`, you can now find these functions at `appInsights.Configurations`. An example is `appInsights.Configuration.setAutoCollectDependencies(true)`. Review the changes to the default configuration in the next section.






## SDK configuration

The `appInsights` object provides many configuration methods. They're listed in the following snippet with their default values.

```javascript
let appInsights = require("applicationinsights");
appInsights.setup("<connection_string>")
    .setAutoDependencyCorrelation(true)
    .setAutoCollectRequests(true)
    .setAutoCollectPerformance(true, true)
    .setAutoCollectExceptions(true)
    .setAutoCollectDependencies(true)
    .setAutoCollectConsole(true)
    .setUseDiskRetryCaching(true)
    .setSendLiveMetrics(false)
    .setDistributedTracingMode(appInsights.DistributedTracingModes.AI)
    .start();
```

To fully correlate events in a service, be sure to set `.setAutoDependencyCorrelation(true)`. With this option set, the SDK can track context across asynchronous callbacks in Node.js.

Review their descriptions in your IDE's built-in type hinting or [applicationinsights.ts](https://github.com/microsoft/ApplicationInsights-node.js/blob/develop/applicationinsights.ts) for detailed information and optional secondary arguments.

> [!NOTE]
> By default, `setAutoCollectConsole` is configured to *exclude* calls to `console.log` and other console methods. Only calls to supported third-party loggers (for example, winston and bunyan) will be collected. You can change this behavior to include calls to `console` methods by using `setAutoCollectConsole(true, true)`.

[!INCLUDE [Distributed tracing](./includes/application-insights-distributed-trace-data.md)]






### Multiple roles for multi-component applications

In some scenarios, your application might consist of multiple components that you want to instrument all with the same connection string. You want to still see these components as separate units in the portal, as if they were using separate connection strings. An example is separate nodes on Application Map. You need to manually configure the `RoleName` field to distinguish one component's telemetry from other components that send data to your Application Insights resource.

Use the following code to set the `RoleName` field:

```javascript
const appInsights = require("applicationinsights");
appInsights.setup("<connection_string>");
appInsights.defaultClient.context.tags[appInsights.defaultClient.context.keys.cloudRole] = "MyRoleName";
appInsights.start();
```







### Automatic third-party instrumentation

To track context across asynchronous calls, some changes are required in third-party libraries, such as MongoDB and Redis. By default, Application Insights uses [`diagnostic-channel-publishers`](https://github.com/Microsoft/node-diagnostic-channel/tree/master/src/diagnostic-channel-publishers) to monkey-patch some of these libraries. This feature can be disabled by setting the `APPLICATION_INSIGHTS_NO_DIAGNOSTIC_CHANNEL` environment variable.

> [!NOTE]
> By setting that environment variable, events might not be correctly associated with the right operation.

 Individual monkey patches can be disabled by setting the `APPLICATION_INSIGHTS_NO_PATCH_MODULES` environment variable to a comma-separated list of packages to disable. For example, use `APPLICATION_INSIGHTS_NO_PATCH_MODULES=console,redis` to avoid patching the `console` and `redis` packages.

Currently, nine packages are instrumented: `bunyan`,`console`,`mongodb`,`mongodb-core`,`mysql`,`redis`,`winston`,`pg`, and `pg-pool`. For information about exactly which version of these packages are patched, see the [diagnostic-channel-publishers' README](https://github.com/Microsoft/node-diagnostic-channel/blob/master/src/diagnostic-channel-publishers/README.md).

The `bunyan`, `winston`, and `console` patches generate Application Insights trace events based on whether `setAutoCollectConsole` is enabled. The rest generates Application Insights dependency events based on whether `setAutoCollectDependencies` is enabled.






### Extended metrics

> [!NOTE]
> The ability to send extended native metrics was added in version 1.4.0.

To enable sending extended native metrics from your app to Azure, install the separate native metrics package. The SDK automatically loads when it's installed and start collecting Node.js native metrics.

```bash
npm install applicationinsights-native-metrics
```

Currently, the native metrics package performs autocollection of garbage collection CPU time, event loop ticks, and heap usage:

* **Garbage collection**: The amount of CPU time spent on each type of garbage collection, and how many occurrences of each type.
* **Event loop**: How many ticks occurred and how much CPU time was spent in total.
* **Heap vs. non-heap**: How much of your app's memory usage is in the heap or non-heap.













## TelemetryClient API

For a full description of the TelemetryClient API, see [Application Insights API for custom events and metrics](#core-api-for-custom-events-and-metrics).

You can track any request, event, metric, or exception by using the Application Insights client library for Node.js. The following code example demonstrates some of the APIs that you can use:

```javascript
let appInsights = require("applicationinsights");
appInsights.setup().start(); // assuming connection string in env var. start() can be omitted to disable any non-custom data
let client = appInsights.defaultClient;
client.trackEvent({name: "my custom event", properties: {customProperty: "custom property value"}});
client.trackException({exception: new Error("handled exceptions can be logged with this method")});
client.trackMetric({name: "custom metric", value: 3});
client.trackTrace({message: "trace message"});
client.trackDependency({target:"http://dbname", name:"select customers proc", data:"SELECT * FROM Customers", duration:231, resultCode:0, success: true, dependencyTypeName: "ZSQL"});
client.trackRequest({name:"GET /customers", url:"http://myserver/customers", duration:309, resultCode:200, success:true});

let http = require("http");
http.createServer( (req, res) => {
  client.trackNodeHttpRequest({request: req, response: res}); // Place at the beginning of your request handler
});
```






### Add a custom property to all events

Use the following code to add a custom property to all events:

```javascript
appInsights.defaultClient.commonProperties = {
  environment: process.env.SOME_ENV_VARIABLE
};
```








### Track HTTP GET requests

Use the following code to manually track HTTP GET requests:

> [!NOTE]
> * All requests are tracked by default. To disable automatic collection, call `.setAutoCollectRequests(false)` before calling `start()`.
> * Native fetch API requests aren't automatically tracked by classic Application Insights; manual dependency tracking is required.

```javascript
appInsights.defaultClient.trackRequest({name:"GET /customers", url:"http://myserver/customers", duration:309, resultCode:200, success:true});
```

Alternatively, you can track requests by using the `trackNodeHttpRequest` method:

```javascript
var server = http.createServer((req, res) => {
  if ( req.method === "GET" ) {
      appInsights.defaultClient.trackNodeHttpRequest({request:req, response:res});
  }
  // other work here....
  res.end();
});
```










### Track server startup time

Use the following code to track server startup time:

```javascript
let start = Date.now();
server.on("listening", () => {
  let duration = Date.now() - start;
  appInsights.defaultClient.trackMetric({name: "server startup time", value: duration});
});
```









### Flush

By default, telemetry is buffered for 15 seconds before it's sent to the ingestion server. If your application has a short lifespan, such as a CLI tool, it might be necessary to manually flush your buffered telemetry when the application terminates by using `appInsights.defaultClient.flush()`.

If the SDK detects that your application is crashing, it calls flush for you by using `appInsights.defaultClient.flush({ isAppCrashing: true })`. With the flush option `isAppCrashing`, your application is assumed to be in an abnormal state and isn't suitable to send telemetry. Instead, the SDK saves all buffered telemetry to [persistent storage](/previous-versions/azure/azure-monitor/app/data-retention-privacy#nodejs) and lets your application terminate. When your application starts again, it tries to send any telemetry that was saved to persistent storage.

[!INCLUDE [Filter and preprocess telemetry](./includes/application-insights-api-filtering-sampling.md)]

[!INCLUDE [Telemetry processor and telemetry initializer](./includes/application-insights-processor-initializer.md)]











## Advanced configuration options

The client object contains a `config` property with many optional settings for advanced scenarios. To set them, use:

```javascript
client.config.PROPERTYNAME = VALUE;
```

These properties are client specific, so you can configure `appInsights.defaultClient` separately from clients created with `new appInsights.TelemetryClient()`.

| Property | Description |
|----------|-------------|
| connectionString | An identifier for your Application Insights resource. |
| endpointUrl | The ingestion endpoint to send telemetry payloads to. |
| quickPulseHost | The Live Metrics Stream host to send live metrics telemetry to. |
| proxyHttpUrl | A proxy server for SDK HTTP traffic. (Optional. Default is pulled from `http_proxy` environment variable.) |
| proxyHttpsUrl | A proxy server for SDK HTTPS traffic. (Optional. Default is pulled from `https_proxy` environment variable.) |
| httpAgent | An http.Agent to use for SDK HTTP traffic. (Optional. Default is undefined.) |
| httpsAgent | An https.Agent to use for SDK HTTPS traffic. (Optional. Default is undefined.) |
| maxBatchSize | The maximum number of telemetry items to include in a payload to the ingestion endpoint. (Default is `250`.) |
| maxBatchIntervalMs | The maximum amount of time to wait for a payload to reach maxBatchSize. (Default is `15000`.) |
| disableAppInsights | A flag indicating if telemetry transmission is disabled. (Default is `false`.) |
| samplingPercentage | The percentage of telemetry items tracked that should be transmitted. (Default is `100`.) |
| correlationIdRetryIntervalMs | The time to wait before retrying to retrieve the ID for cross-component correlation. (Default is `30000`.) |
| correlationHeaderExcludedDomains| A list of domains to exclude from cross-component correlation header injection. (Default. See [Config.ts](https://github.com/Microsoft/ApplicationInsights-node.js/blob/develop/Library/Config.ts).) |

[!INCLUDE [azure-monitor-custom-events-metrics](includes/application-insights-api-custom-events-metrics.md)]
