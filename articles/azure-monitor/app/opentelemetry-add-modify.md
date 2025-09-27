---
title: Add and modify OpenTelemetry in Application Insights
description: Learn how to add and modify OpenTelemetry (OTel) in Application Insights. Includes .NET, Java, Node.js, and Python applications, custom attributes, telemetry processors, and log and trace modifications.
ms.topic: how-to
ms.date: 09/30/2025
ms.devlang: csharp
# ms.devlang: csharp, javascript, typescript, python
ms.custom: devx-track-dotnet, devx-track-extended-java, devx-track-python

#customer intent: As a developer or site reliability engineer, I want to integrate and customize OpenTelemetry (OTel) instrumentation in Application Insights so that I can achieve standardized telemetry collection and enhanced observability for my .NET, Java, Node.js, or Python applications.

---

# Add and modify Azure Monitor OpenTelemetry for .NET, Java, Node.js, and Python applications

This guide provides instructions on integrating and customizing OpenTelemetry (OTel) instrumentation within [Azure Monitor Application Insights](app-insights-overview.md).

To learn more about OpenTelemetry concepts, see the [OpenTelemetry overview](opentelemetry-overview.md) or [OpenTelemetry FAQ](opentelemetry-help-support-feedback.md).

> [!NOTE]
> [!INCLUDE [application-insights-functions-link](./includes/application-insights-functions-link.md)]

<!---NOTE TO CONTRIBUTORS: PLEASE DO NOT SEPARATE OUT JAVASCRIPT AND TYPESCRIPT INTO DIFFERENT TABS.--->

## Automatic data collection

The distros automatically collect data by bundling OpenTelemetry instrumentation libraries.

### Included instrumentation libraries

#### [ASP.NET Core](#tab/aspnetcore)

**Requests**

* [ASP.NET
  Core](https://github.com/open-telemetry/opentelemetry-dotnet/blob/1.0.0-rc9.14/src/OpenTelemetry.Instrumentation.AspNetCore/README.md) ¹²

**Dependencies**

* [HttpClient](https://github.com/open-telemetry/opentelemetry-dotnet/blob/1.0.0-rc9.14/src/OpenTelemetry.Instrumentation.Http/README.md) ¹²
* [SqlClient](https://github.com/open-telemetry/opentelemetry-dotnet/blob/1.0.0-rc9.14/src/OpenTelemetry.Instrumentation.SqlClient/README.md) ¹
* [Azure SDK](https://github.com/Azure/azure-sdk)

**Logging**

* `ILogger`

To reduce or increase the number of logs sent to Azure Monitor, configure logging to set the appropriate log level or apply filters. For example, you can choose to send only `Warning` and `Error` logs to OpenTelemetry/Azure Monitor. OpenTelemetry doesn't control log routing or filtering - your `ILogger` configuration makes these decisions. For more information on configuring `ILogger`, see [Configure logging](/dotnet/core/extensions/logging#configure-logging).


For more information about `ILogger`, see [Logging in C# and .NET](/dotnet/core/extensions/logging) and [code examples](https://github.com/open-telemetry/opentelemetry-dotnet/tree/main/docs/logs).

#### [.NET](#tab/net)

The Azure Monitor Exporter doesn't include any instrumentation libraries.

You can collect dependencies from the [Azure Software Development Kits (SDKs)](https://github.com/Azure/azure-sdk) using the following code sample to manually subscribe to the source.

```csharp
// Create an OpenTelemetry tracer provider builder.
// It is important to keep the TracerProvider instance active throughout the process lifetime.
using var tracerProvider = Sdk.CreateTracerProviderBuilder()
	// The following line subscribes to dependencies emitted from Azure SDKs
    .AddSource("Azure.*")
    .AddAzureMonitorTraceExporter()
    .AddHttpClientInstrumentation(o => o.FilterHttpRequestMessage = (_) =>
	{
    	// Azure SDKs create their own client span before calling the service using HttpClient
		// In this case, we would see two spans corresponding to the same operation
		// 1) created by Azure SDK 2) created by HttpClient
		// To prevent this duplication we are filtering the span from HttpClient
		// as span from Azure SDK contains all relevant information needed.
		var parentActivity = Activity.Current?.Parent;
		if (parentActivity != null && parentActivity.Source.Name.Equals("Azure.Core.Http"))
		{
		    return false;
		}
		return true;
	})
    .Build();
```

To reduce or increase the number of logs sent to Azure Monitor, configure logging to set the appropriate log level or apply filters. For example, you can choose to send only `Warning` and `Error` logs to OpenTelemetry/Azure Monitor. OpenTelemetry doesn't control log routing or filtering - your `ILogger` configuration makes these decisions. For more information on configuring `ILogger`, see [Configure logging](/dotnet/core/extensions/logging#configure-logging).

#### [Java](#tab/java)

**Requests**

* Java Message Service (JMS) consumers
* Kafka consumers
* Netty
* Quartz
* RabbitMQ
* Servlets
* Spring scheduling

> [!NOTE]
> Servlet and Netty autoinstrumentation covers most Java HTTP services, including Java EE, Jakarta EE, Spring Boot, Quarkus, and `Micronaut`.

**Dependencies (plus downstream distributed trace propagation)**

* Apache HttpClient
* Apache HttpAsyncClient
* AsyncHttpClient
* Google HttpClient
* gRPC
* java.net.HttpURLConnection
* Java 11 HttpClient
* JAX-RS client
* Jetty HttpClient
* JMS
* Kafka
* Netty client
* OkHttp
* RabbitMQ

**Dependencies (without downstream distributed trace propagation)**

* Supports Cassandra
* Supports Java Database Connectivity (JDBC)
* Supports MongoDB (async and sync)
* Supports Redis (Lettuce and Jedis)

**Metrics**

* Micrometer Metrics, including Spring Boot Actuator metrics
* Java Management Extensions (JMX) Metrics

**Logs**

* Logback (including MDC properties) ¹
* Log4j (including MDC/Thread Context properties) ¹
* JBoss Logging (including MDC properties) ¹
* java.util.logging ¹

To reduce or increase the number of logs that Azure Monitor collects, first set the desired logging level (such as `WARNING` or `ERROR`) in the application's logging library.

**Default collection**

Telemetry emitted by the following Azure SDKs is automatically collected by default:

* [Azure App Configuration](/java/api/overview/azure/data-appconfiguration-readme) 1.1.10+
* [Azure AI Search](/java/api/overview/azure/search-documents-readme) 11.3.0+
* [Azure Communication Chat](/java/api/overview/azure/communication-chat-readme) 1.0.0+
* [Azure Communication Common](/java/api/overview/azure/communication-common-readme) 1.0.0+
* [Azure Communication Identity](/java/api/overview/azure/communication-identity-readme) 1.0.0+
* [Azure Communication Phone Numbers](/java/api/overview/azure/communication-phonenumbers-readme) 1.0.0+
* [Azure Communication SMS (Short Message Service)](/java/api/overview/azure/communication-sms-readme) 1.0.0+
* [Azure Cosmos DB](/java/api/overview/azure/cosmos-readme) 4.22.0+
* [Azure Digital Twins - Core](/java/api/overview/azure/digitaltwins-core-readme) 1.1.0+
* [Azure Event Grid](/java/api/overview/azure/messaging-eventgrid-readme) 4.0.0+
* [Azure Event Hubs](/java/api/overview/azure/messaging-eventhubs-readme) 5.6.0+
* [Azure Event Hubs - Azure Blob Storage Checkpoint Store](/java/api/overview/azure/messaging-eventhubs-checkpointstore-blob-readme) 1.5.1+
* [Azure AI Document Intelligence](/java/api/overview/azure/ai-formrecognizer-readme) 3.0.6+
* [Azure Identity](/java/api/overview/azure/identity-readme) 1.2.4+
* [Azure Key Vault - Certificates](/java/api/overview/azure/security-keyvault-certificates-readme) 4.1.6+
* [Azure Key Vault - Keys](/java/api/overview/azure/security-keyvault-keys-readme) 4.2.6+
* [Azure Key Vault - Secrets](/java/api/overview/azure/security-keyvault-secrets-readme) 4.2.6+
* [Azure Service Bus](/java/api/overview/azure/messaging-servicebus-readme) 7.1.0+
* [Azure Storage - Blobs](/java/api/overview/azure/storage-blob-readme) 12.11.0+
* [Azure Storage - Blobs Batch](/java/api/overview/azure/storage-blob-batch-readme) 12.9.0+
* [Azure Storage - Blobs Cryptography](/java/api/overview/azure/storage-blob-cryptography-readme) 12.11.0+
* [Azure Storage - Common](/java/api/overview/azure/storage-common-readme) 12.11.0+
* [Azure Storage - Files Data Lake](/java/api/overview/azure/storage-file-datalake-readme) 12.5.0+
* [Azure Storage - Files Shares](/java/api/overview/azure/storage-file-share-readme) 12.9.0+
* [Azure Storage - Queues](/java/api/overview/azure/storage-queue-readme) 12.9.0+
* [Azure Text Analytics](/java/api/overview/azure/ai-textanalytics-readme) 5.0.4+

```
[//]: # "Azure Cosmos DB 4.22.0+ due to https://github.com/Azure/azure-sdk-for-java/pull/25571"
[//]: # "the remaining above names and links scraped from https://azure.github.io/azure-sdk/releases/latest/java.html"
[//]: # "and version synched manually against the oldest version in maven central built on azure-core 1.14.0"
[//]: # ""
[//]: # "var table = document.querySelector('#tg-sb-content > div > table')"
[//]: # "var str = ''"
[//]: # "for (var i = 1, row; row = table.rows[i]; i++) {"
[//]: # "  var name = row.cells[0].getElementsByTagName('div')[0].textContent.trim()"
[//]: # "  var stableRow = row.cells[1]"
[//]: # "  var versionBadge = stableRow.querySelector('.badge')"
[//]: # "  if (!versionBadge) {"
[//]: # "    continue"
[//]: # "  }"
[//]: # "  var version = versionBadge.textContent.trim()"
[//]: # "  var link = stableRow.querySelectorAll('a')[2].href"
[//]: # "  str += '* [' + name + '](' + link + ') ' + version + '\n'"
[//]: # "}"
[//]: # "console.log(str)"
```

#### [Java native](#tab/java-native)

**Requests for Spring Boot native applications**

* Spring Web
* Spring Web MVC (Model-View-Controller)
* Spring WebFlux

**Dependencies for Spring Boot native applications**

* JDBC
* R2DBC
* MongoDB
* Kafka
* [Azure SDK](https://github.com/Azure/azure-sdk)

**Metrics**

* Micrometer Metrics

**Logs for Spring Boot native applications**

* Logback

To reduce or increase the number of logs that Azure Monitor collects, first set the desired logging level (such as `WARNING` or `ERROR`) in the application's logging library.

For Quartz native applications, look at the [Quarkus documentation](https://quarkus.io/guides/opentelemetry).

[!INCLUDE [quarkus-support](./includes/quarkus-support.md)]

#### [Node.js](#tab/nodejs)


> [!TIP]
> **Node.js examples use modern ESM `import` syntax.** If your project is CommonJS, you can still use this syntax with the approaches described in the OpenTelemetry JS ESM support guide and Node.js documentation. The code below is valid JavaScript and doesn't require TypeScript.

The following OpenTelemetry Instrumentation libraries are included as part of the Azure Monitor Application Insights Distro. For more information, see [Azure SDK for JavaScript](https://github.com/Azure/azure-sdk-for-js/blob/main/sdk/monitor/monitor-opentelemetry/README.md#instrumentation-libraries).

**Requests**

* [HTTP/HTTPS](https://github.com/open-telemetry/opentelemetry-js/tree/main/experimental/packages/opentelemetry-instrumentation-http)²

**Dependencies**

* Supports [MongoDB](https://github.com/open-telemetry/opentelemetry-js-contrib/tree/main/packages/instrumentation-mongodb)
* Supports [MySQL](https://github.com/open-telemetry/opentelemetry-js-contrib/tree/main/packages/instrumentation-mysql)
* Supports [Postgres](https://github.com/open-telemetry/opentelemetry-js-contrib/tree/main/packages/instrumentation-pg)
* Supports [Redis](https://github.com/open-telemetry/opentelemetry-js-contrib/tree/main/packages/instrumentation-redis)
* Supports [Redis-4](https://github.com/open-telemetry/opentelemetry-js-contrib/tree/main/packages/instrumentation-redis-4)
* Supports [Azure SDK](https://github.com/Azure/azure-sdk-for-js/tree/main/sdk/instrumentation/opentelemetry-instrumentation-azure-sdk)

**Logs**

* [Bunyan](https://github.com/open-telemetry/opentelemetry-js-contrib/tree/main/packages/instrumentation-bunyan)
* [Winston](https://github.com/open-telemetry/opentelemetry-js-contrib/tree/main/packages/instrumentation-winston)

To reduce or increase the number of logs that Azure Monitor collects, first set the desired logging level (such as `WARNING` or `ERROR`) in the application's logging library.

Instrumentations can be configured using `AzureMonitorOpenTelemetryOptions`:

```javascript
// Import Azure Monitor OpenTelemetry
import { useAzureMonitor } from "@azure/monitor-opentelemetry";

// Specific instrumentation configs can be added.
const options = {
  instrumentationOptions: {
    http: {
      // Return true to ignore a specific request
      ignoreIncomingRequestHook: (request) => {
        return false;
      },
      enabled: true,
    },
    azureSdk: { enabled: true },
    mongoDb: { enabled: true },
    mySql: { enabled: true },
    postgreSql: { enabled: true },
    redis: { enabled: true },
    redis4: { enabled: true },
  },
};

// Enable Azure Monitor integration
useAzureMonitor(options);

```

#### [Python](#tab/python)

**Requests**

* [Django](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-django) ¹
* [FastApi](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-fastapi) ¹
* [Flask](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-flask) ¹

**Dependencies**

* [Psycopg2](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-psycopg2)
* [Requests](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-requests) ¹
* [`Urllib`](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-urllib) ¹
* [`Urllib3`](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-urllib3) ¹

**Logs**

* [Python logging library](https://docs.python.org/3/howto/logging.html)

To reduce or increase the number of logs that Azure Monitor collects, first set the desired logging level (such as `WARNING` or `ERROR`) in the application's logging library.

Examples of using the Python logging library can be found on [GitHub](https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/monitor/azure-monitor-opentelemetry/samples/logging).

Telemetry emitted by Azure Software Development Kits (SDKs) is automatically [collected](https://github.com/Azure/azure-sdk-for-python/blob/main/sdk/monitor/azure-monitor-opentelemetry/README.md#officially-supported-instrumentations) by default.

---

**Footnotes**

* ¹: Supports automatic reporting of *unhandled/uncaught* exceptions
* ²: Supports OpenTelemetry Metrics

> [!NOTE]
> The Azure Monitor OpenTelemetry Distros include custom mapping and logic to automatically emit [Application Insights standard metrics](standard-metrics.md).

> [!TIP]
> All OpenTelemetry metrics whether automatically collected from instrumentation libraries or manually collected from custom coding are currently considered Application Insights "custom metrics" for billing purposes. [Learn more](pre-aggregated-metrics-log-metrics.md#custom-metrics-dimensions-and-preaggregation).

### Add a community instrumentation library

You can collect more data automatically when you include instrumentation libraries from the OpenTelemetry community.

[!INCLUDE [azure-monitor-app-insights-opentelemetry-support](includes/azure-monitor-app-insights-opentelemetry-community-library-warning.md)]

#### [ASP.NET Core](#tab/aspnetcore)

To add a community library, use the `ConfigureOpenTelemetryMeterProvider` or `ConfigureOpenTelemetryTracerProvider` methods,
after adding the NuGet package for the library.

The following example demonstrates how the [Runtime Instrumentation](https://www.nuget.org/packages/OpenTelemetry.Instrumentation.Runtime) can be added to collect extra metrics:

```dotnetcli
dotnet add package OpenTelemetry.Instrumentation.Runtime 
```

```csharp
// Create a new ASP.NET Core web application builder.
var builder = WebApplication.CreateBuilder(args);

// Configure the OpenTelemetry meter provider to add runtime instrumentation.
builder.Services.ConfigureOpenTelemetryMeterProvider((sp, builder) => builder.AddRuntimeInstrumentation());

// Add the Azure Monitor telemetry service to the application.
// This service will collect and send telemetry data to Azure Monitor.
builder.Services.AddOpenTelemetry().UseAzureMonitor();

// Build the ASP.NET Core web application.
var app = builder.Build();

// Start the ASP.NET Core web application.
app.Run();
```

#### [.NET](#tab/net)

The following example demonstrates how the [Runtime Instrumentation](https://www.nuget.org/packages/OpenTelemetry.Instrumentation.Runtime) can be added to collect extra metrics:

```csharp
// Create a new OpenTelemetry meter provider and add runtime instrumentation and the Azure Monitor metric exporter.
// It is important to keep the MetricsProvider instance active throughout the process lifetime.
var metricsProvider = Sdk.CreateMeterProviderBuilder()
    .AddRuntimeInstrumentation()
    .AddAzureMonitorMetricExporter();
```

#### [Java](#tab/java)

You can't extend the Java Distro with community instrumentation libraries. To request that we include another instrumentation library, open an issue on our GitHub page. You can find a link to our GitHub page in [Next Steps](#next-steps).

#### [Java native](#tab/java-native)

You can't use community instrumentation libraries with GraalVM Java native applications.

#### [Node.js](#tab/nodejs)

Other OpenTelemetry Instrumentations are available [here](https://github.com/open-telemetry/opentelemetry-js-contrib/tree/main/packages) and could be added using TraceHandler in ApplicationInsightsClient:

```javascript
// Import the Azure Monitor OpenTelemetry plugin and OpenTelemetry API
import { useAzureMonitor } from "@azure/monitor-opentelemetry";
import { metrics, trace } from "@opentelemetry/api";

// Import the OpenTelemetry instrumentation registration function and Express instrumentation
import { registerInstrumentations } from "@opentelemetry/instrumentation";
import { ExpressInstrumentation } from "@opentelemetry/instrumentation-express";

// Enable Azure Monitor integration (uses the APPLICATIONINSIGHTS_CONNECTION_STRING env var if set)
useAzureMonitor();

// Get the OpenTelemetry tracer provider and meter provider
const maybeProxy = trace.getTracerProvider();
const tracerProvider = (typeof maybeProxy?.getDelegate === "function") ? maybeProxy.getDelegate() : maybeProxy;
const meterProvider = metrics.getMeterProvider();

// Register the Express instrumentation
registerInstrumentations({
  instrumentations: [
    new ExpressInstrumentation(),
  ],
  tracerProvider,
  meterProvider,
});

```

#### [Python](#tab/python)

To add a community instrumentation library (not officially supported/included in Azure Monitor distro), you can instrument directly with the instrumentations. The list of community instrumentation libraries can be found [here](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation).

> [!NOTE]
> Instrumenting a [supported instrumentation library](#included-instrumentation-libraries) manually with `instrument()` and the distro `configure_azure_monitor()` isn't recommended. It's not a supported scenario and you could get undesired behavior for your telemetry.

```python
# Import the `configure_azure_monitor()`, `SQLAlchemyInstrumentor`, `create_engine`, and `text` functions from the appropriate packages.
from azure.monitor.opentelemetry import configure_azure_monitor
from opentelemetry.instrumentation.sqlalchemy import SQLAlchemyInstrumentor
from sqlalchemy import create_engine, text

# Configure OpenTelemetry to use Azure Monitor.
configure_azure_monitor()

# Create a SQLAlchemy engine.
engine = create_engine("sqlite:///:memory:")

# SQLAlchemy instrumentation is not officially supported by this package, however, you can use the OpenTelemetry `instrument()` method manually in conjunction with `configure_azure_monitor()`.
SQLAlchemyInstrumentor().instrument(
    engine=engine,
)

# Database calls using the SQLAlchemy library will be automatically captured.
with engine.connect() as conn:
    result = conn.execute(text("select 'hello world'"))
    print(result.all())

```

---

## Collect custom telemetry

This section explains how to collect custom telemetry from your application.
  
Depending on your language and signal type, there are different ways to collect custom telemetry, including:
  
* OpenTelemetry API
* Language-specific logging/metrics libraries
* Application Insights [Classic API](api-custom-events-metrics.md)
 
The following table represents the currently supported custom telemetry types:

| Language                                  | Custom Events | Custom Metrics | Dependencies | Exceptions | Page Views | Requests | Traces |
|-------------------------------------------|---------------|----------------|--------------|------------|------------|----------|--------|
| **ASP.NET Core**                          |               |                |              |            |            |          |        |
| &nbsp;&nbsp;&nbsp;OpenTelemetry API       |               | Yes            | Yes          | Yes        |            | Yes      |        |
| &nbsp;&nbsp;&nbsp;`ILogger` API           |               |                |              |            |            |          | Yes    |
| &nbsp;&nbsp;&nbsp;AI Classic API          |               |                |              |            |            |          |        |
|                                           |               |                |              |            |            |          |        |
| **Java**                                  |               |                |              |            |            |          |        |
| &nbsp;&nbsp;&nbsp;OpenTelemetry API       |               | Yes            | Yes          | Yes        |            | Yes      |        |
| &nbsp;&nbsp;&nbsp;Logback, `Log4j`, JUL   |               |                |              | Yes        |            |          | Yes    |
| &nbsp;&nbsp;&nbsp;Micrometer Metrics      |               | Yes            |              |            |            |          |        |
| &nbsp;&nbsp;&nbsp;AI Classic API          | Yes           | Yes            | Yes          | Yes        | Yes        | Yes      | Yes    |
|                                           |               |                |              |            |            |          |        |
| **Node.js**                               |               |                |              |            |            |          |        |
| &nbsp;&nbsp;&nbsp;OpenTelemetry API       |               | Yes            | Yes          | Yes        |            | Yes      |        |
|                                           |               |                |              |            |            |          |        |
| **Python**                                |               |                |              |            |            |          |        |
| &nbsp;&nbsp;&nbsp;OpenTelemetry API       |               | Yes            | Yes          | Yes        |            | Yes      |        |
| &nbsp;&nbsp;&nbsp;Python Logging Module   |               |                |              |            |            |          | Yes    |
| &nbsp;&nbsp;&nbsp;Events Extension        | Yes           |                |              |            |            |          | Yes    |

> [!NOTE]
> Application Insights Java 3.x and Application Insights Node.js 3.x collect telemetry from the Application Insights [Classic API](api-custom-events-metrics.md). This behavior simplifies upgrades and temporarily supports custom telemetry until the OpenTelemetry API includes all custom telemetry types.

### Add custom metrics

In this context, the custom metrics term refers to manually instrumenting your code to collect extra metrics beyond what the OpenTelemetry Instrumentation Libraries automatically collect. To learn more about using metrics, see [Metrics in Application Insights](metrics-overview.md).

The OpenTelemetry API offers six metric "instruments" to cover various metric scenarios and you need to pick the correct "Aggregation Type" when visualizing metrics in Metrics Explorer. This requirement is true when using the OpenTelemetry Metric API to send metrics and when using an instrumentation library.

The following table shows the recommended [aggregation types](../essentials/metrics-aggregation-explained.md#aggregation-types) for each of the OpenTelemetry Metric Instruments.

| OpenTelemetry Instrument                             | Azure Monitor Aggregation Type                             |
|------------------------------------------------------|------------------------------------------------------------|
| Counter                                              | Sum                                                        |
| Asynchronous Counter                                 | Sum                                                        |
| Histogram                                            | Min, Max, Average, Sum, and Count                           |
| Asynchronous Gauge                                   | Average                                                    |
| UpDownCounter                                        | Sum                                                        |
| Asynchronous UpDownCounter                           | Sum                                                        |

> [!CAUTION]
> Other aggregation types aren't meaningful in most cases.

The [OpenTelemetry Specification](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/metrics/api.md#instrument)
describes the instruments and provides examples of when you might use each one.

> [!TIP]
> The histogram is the most versatile and most closely equivalent to the Application Insights GetMetric [Classic API](api-custom-events-metrics.md). Azure Monitor currently flattens the histogram instrument into our five supported aggregation types, and support for percentiles is underway. Although less versatile, other OpenTelemetry instruments have a lesser effect on your application's performance.

#### Histogram example

##### [ASP.NET Core](#tab/aspnetcore)

Application startup must subscribe to a Meter by name:

```csharp
// Create a new ASP.NET Core web application builder.
var builder = WebApplication.CreateBuilder(args);

// Configure the OpenTelemetry meter provider to add a meter named "OTel.AzureMonitor.Demo".
builder.Services.ConfigureOpenTelemetryMeterProvider((sp, builder) => builder.AddMeter("OTel.AzureMonitor.Demo"));

// Add the Azure Monitor telemetry service to the application.
// This service will collect and send telemetry data to Azure Monitor.
builder.Services.AddOpenTelemetry().UseAzureMonitor();

// Build the ASP.NET Core web application.
var app = builder.Build();

// Start the ASP.NET Core web application.
app.Run();
```

The `Meter` must be initialized using that same name:

```csharp
// Create a new meter named "OTel.AzureMonitor.Demo".
var meter = new Meter("OTel.AzureMonitor.Demo");

// Create a new histogram metric named "FruitSalePrice".
Histogram<long> myFruitSalePrice = meter.CreateHistogram<long>("FruitSalePrice");

// Create a new Random object.
var rand = new Random();

// Record a few random sale prices for apples and lemons, with different colors.
myFruitSalePrice.Record(rand.Next(1, 1000), new("name", "apple"), new("color", "red"));
myFruitSalePrice.Record(rand.Next(1, 1000), new("name", "lemon"), new("color", "yellow"));
myFruitSalePrice.Record(rand.Next(1, 1000), new("name", "lemon"), new("color", "yellow"));
myFruitSalePrice.Record(rand.Next(1, 1000), new("name", "apple"), new("color", "green"));
myFruitSalePrice.Record(rand.Next(1, 1000), new("name", "apple"), new("color", "red"));
myFruitSalePrice.Record(rand.Next(1, 1000), new("name", "lemon"), new("color", "yellow"));
```

##### [.NET](#tab/net)

```csharp
public class Program
{
    // Create a static readonly Meter object named "OTel.AzureMonitor.Demo".
    // This meter will be used to track metrics about the application.
    private static readonly Meter meter = new("OTel.AzureMonitor.Demo");

    public static void Main()
    {
        // Create a new MeterProvider object using the OpenTelemetry SDK.
        // The MeterProvider object is responsible for managing meters and sending
        // metric data to exporters.
        // It is important to keep the MetricsProvider instance active
        // throughout the process lifetime.
        //
        // The MeterProviderBuilder is configured to add a meter named
        // "OTel.AzureMonitor.Demo" and an Azure Monitor metric exporter.
        using var meterProvider = Sdk.CreateMeterProviderBuilder()
            .AddMeter("OTel.AzureMonitor.Demo")
            .AddAzureMonitorMetricExporter()
            .Build();

        // Create a new Histogram metric named "FruitSalePrice".
        // This metric will track the distribution of fruit sale prices.
        Histogram<long> myFruitSalePrice = meter.CreateHistogram<long>("FruitSalePrice");

        // Create a new Random object. This object will be used to generate random sale prices.
        var rand = new Random();
        
        // Record a few random sale prices for apples and lemons, with different colors.
        // Each record includes a timestamp, a value, and a set of attributes.
        // The attributes can be used to filter and analyze the metric data.
        myFruitSalePrice.Record(rand.Next(1, 1000), new("name", "apple"), new("color", "red"));
        myFruitSalePrice.Record(rand.Next(1, 1000), new("name", "lemon"), new("color", "yellow"));
        myFruitSalePrice.Record(rand.Next(1, 1000), new("name", "lemon"), new("color", "yellow"));
        myFruitSalePrice.Record(rand.Next(1, 1000), new("name", "apple"), new("color", "green"));
        myFruitSalePrice.Record(rand.Next(1, 1000), new("name", "apple"), new("color", "red"));
        myFruitSalePrice.Record(rand.Next(1, 1000), new("name", "lemon"), new("color", "yellow"));

        // Display a message to the user and wait for them to press Enter.
        // This allows the user to see the message and the console before the
        // application exits.
        System.Console.WriteLine("Press Enter key to exit.");
        System.Console.ReadLine();
    }
}
```

##### [Java](#tab/java)

```java
import io.opentelemetry.api.GlobalOpenTelemetry;
import io.opentelemetry.api.metrics.DoubleHistogram;
import io.opentelemetry.api.metrics.Meter;

public class Program {

    public static void main(String[] args) {
        Meter meter = GlobalOpenTelemetry.getMeter("OTEL.AzureMonitor.Demo");
        DoubleHistogram histogram = meter.histogramBuilder("histogram").build();
        histogram.record(1.0);
        histogram.record(100.0);
        histogram.record(30.0);
    }
}
```

##### [Java native](#tab/java-native)

1. Inject `OpenTelemetry`:

    * **Spring**
```java
        import io.opentelemetry.api.OpenTelemetry;
        
        @Autowired
        OpenTelemetry openTelemetry;
```

    * **Quarkus**
```java
        import io.opentelemetry.api.OpenTelemetry; 
        
        @Inject
        OpenTelemetry openTelemetry;
```


1. Create a histogram:

```java
    import io.opentelemetry.api.metrics.DoubleHistogram;
    import io.opentelemetry.api.metrics.Meter;
    
    Meter meter = openTelemetry.getMeter("OTEL.AzureMonitor.Demo");
    DoubleHistogram histogram = meter.histogramBuilder("histogram").build();
    histogram.record(1.0);
    histogram.record(100.0);
    histogram.record(30.0);
```

[!INCLUDE [quarkus-support](./includes/quarkus-support.md)]

##### [Node.js](#tab/nodejs)

```javascript
// Import the Azure Monitor OpenTelemetry plugin and OpenTelemetry API
import { useAzureMonitor } from "@azure/monitor-opentelemetry";
import { metrics, trace } from "@opentelemetry/api";

// Import the OpenTelemetry instrumentation registration function and Express instrumentation
import { registerInstrumentations } from "@opentelemetry/instrumentation";
import { ExpressInstrumentation } from "@opentelemetry/instrumentation-express";

// Enable Azure Monitor integration (uses the APPLICATIONINSIGHTS_CONNECTION_STRING env var if set)
useAzureMonitor();

// Get the OpenTelemetry tracer provider and meter provider
const maybeProxy = trace.getTracerProvider();
const tracerProvider = (typeof maybeProxy?.getDelegate === "function") ? maybeProxy.getDelegate() : maybeProxy;
const meterProvider = metrics.getMeterProvider();

// Register the Express instrumentation
registerInstrumentations({
  instrumentations: [
    new ExpressInstrumentation(),
  ],
  tracerProvider,
  meterProvider,
});

```

#### [Python](#tab/python)
  
The Python [logging](https://docs.python.org/3/howto/logging.html) library is [autoinstrumented](#included-instrumentation-libraries). You can attach custom dimensions to your logs by passing a dictionary into the `extra` argument of your logs:

```python
...
# Create a warning log message with the properties "key1" and "value1".
logger.warning("WARNING: Warning log with properties", extra={"key1": "value1"})
...

```

---



## Get the trace ID or span ID
    
You can obtain the `Trace ID` and `Span ID` of the currently active Span using following steps.

### [ASP.NET Core](#tab/aspnetcore)

> [!NOTE]
> The `Activity` and `ActivitySource` classes from the `System.Diagnostics` namespace represent the OpenTelemetry concepts of `Span` and `Tracer`, respectively. It's because parts of the OpenTelemetry tracing API are incorporated directly into the .NET runtime. To learn more, see [Introduction to OpenTelemetry .NET Tracing API](https://github.com/open-telemetry/opentelemetry-dotnet/blob/main/src/OpenTelemetry.Api/README.md#introduction-to-opentelemetry-net-tracing-api).

```csharp
// Get the current activity.
Activity activity = Activity.Current;
// Get the trace ID of the activity.
string traceId = activity?.TraceId.ToHexString();
// Get the span ID of the activity.
string spanId = activity?.SpanId.ToHexString();
```

### [.NET](#tab/net)

> [!NOTE]
> The `Activity` and `ActivitySource` classes from the `System.Diagnostics` namespace represent the OpenTelemetry concepts of `Span` and `Tracer`, respectively. It's because parts of the OpenTelemetry tracing API are incorporated directly into the .NET runtime. To learn more, see [Introduction to OpenTelemetry .NET Tracing API](https://github.com/open-telemetry/opentelemetry-dotnet/blob/main/src/OpenTelemetry.Api/README.md#introduction-to-opentelemetry-net-tracing-api).

```csharp
// Get the current activity.
Activity activity = Activity.Current;
// Get the trace ID of the activity.
string traceId = activity?.TraceId.ToHexString();
// Get the span ID of the activity.
string spanId = activity?.SpanId.ToHexString();
```

### [Java](#tab/java)

You can use `opentelemetry-api` to get the trace ID or span ID.

1. Add `opentelemetry-api-1.0.0.jar` (or later) to your application:

```xml
    <dependency>
        <groupId>io.opentelemetry</groupId>
        <artifactId>opentelemetry-api</artifactId>
        <version>1.0.0</version>
    </dependency>
```

1. Get the request trace ID and the span ID in your code:

```java
    import io.opentelemetry.api.trace.Span;
    
    Span span = Span.current();
    String traceId = span.getSpanContext().getTraceId();
    String spanId = span.getSpanContext().getSpanId();
```

### [Java native](#tab/java-native)

Get the request trace ID and the span ID in your code:

```java
import io.opentelemetry.api.trace.Span;

Span span = Span.current();
String traceId = span.getSpanContext().getTraceId();
String spanId = span.getSpanContext().getSpanId();
```

### [Node.js](#tab/nodejs)

Get the request trace ID and the span ID in your code:

```javascript
// Import the trace module from the OpenTelemetry API.
import { trace } from "@opentelemetry/api";

// Get the span ID and trace ID of the active span.
const activeSpan = trace.getActiveSpan();
const spanId = activeSpan?.spanContext().spanId;
const traceId = activeSpan?.spanContext().traceId;

```

### [Python](#tab/python)

Get the request trace ID and the span ID in your code:

```python
# Import the necessary libraries.
from opentelemetry import trace

# Get the trace ID and span ID of the current span.
trace_id = trace.get_current_span().get_span_context().trace_id
span_id = trace.get_current_span().get_span_context().span_id
```

---

## Next steps

### [ASP.NET Core](#tab/aspnetcore)

* To further configure the OpenTelemetry distro, see [Azure Monitor OpenTelemetry configuration](opentelemetry-configuration.md).
* To review the source code, see the [Azure Monitor AspNetCore GitHub repository](https://github.com/Azure/azure-sdk-for-net/tree/main/sdk/monitor/Azure.Monitor.OpenTelemetry.AspNetCore).
* To install the NuGet package, check for updates, or view release notes, see the [Azure Monitor AspNetCore NuGet Package](https://www.nuget.org/packages/Azure.Monitor.OpenTelemetry.AspNetCore) page.
* To become more familiar with Azure Monitor and OpenTelemetry, see the [Azure Monitor Example Application](https://github.com/Azure/azure-sdk-for-net/tree/main/sdk/monitor/Azure.Monitor.OpenTelemetry.AspNetCore/tests/Azure.Monitor.OpenTelemetry.AspNetCore.Demo).
* To learn more about OpenTelemetry and its community, see the [OpenTelemetry .NET GitHub repository](https://github.com/open-telemetry/opentelemetry-dotnet).
* To enable usage experiences, [enable web or browser user monitoring](javascript.md).
* To review frequently asked questions, troubleshooting steps, support options, or to provide OpenTelemetry feedback, see [OpenTelemetry help, support, and feedback for Azure Monitor Application Insights](.\opentelemetry-help-support-feedback.md).

#### [.NET](#tab/net)

* To further configure the OpenTelemetry distro, see [Azure Monitor OpenTelemetry configuration](opentelemetry-configuration.md)
* To review the source code, see the [Azure Monitor Exporter GitHub repository](https://github.com/Azure/azure-sdk-for-net/tree/main/sdk/monitor/Azure.Monitor.OpenTelemetry.Exporter).
* To install the NuGet package, check for updates, or view release notes, see the [Azure Monitor Exporter NuGet Package](https://www.nuget.org/packages/Azure.Monitor.OpenTelemetry.Exporter) page.
* To become more familiar with Azure Monitor and OpenTelemetry, see the [Azure Monitor Example Application](https://github.com/Azure/azure-sdk-for-net/tree/main/sdk/monitor/Azure.Monitor.OpenTelemetry.Exporter/tests/Azure.Monitor.OpenTelemetry.Exporter.Demo).
* To learn more about OpenTelemetry and its community, see the [OpenTelemetry .NET GitHub repository](https://github.com/open-telemetry/opentelemetry-dotnet).
* To enable usage experiences, [enable web or browser user monitoring](javascript.md).
* To review frequently asked questions, troubleshooting steps, support options, or to provide OpenTelemetry feedback, see [OpenTelemetry help, support, and feedback for Azure Monitor Application Insights](.\opentelemetry-help-support-feedback.md).

### [Java](#tab/java)

* To review configuration options, see [Java autoinstrumentation configuration options](java-standalone-config.md).
* To review the source code, see the [Azure Monitor Java autoinstrumentation GitHub repository](https://github.com/Microsoft/ApplicationInsights-Java).
* To learn more about OpenTelemetry and its community, see the [OpenTelemetry Java GitHub repository](https://github.com/open-telemetry/opentelemetry-java-instrumentation).
* To enable usage experiences, see [Enable web or browser user monitoring](javascript.md).
* To see release notes, see [release notes](https://github.com/microsoft/ApplicationInsights-Java/releases) on GitHub.
* To review frequently asked questions, troubleshooting steps, support options, or to provide OpenTelemetry feedback, see [OpenTelemetry help, support, and feedback for Azure Monitor Application Insights](.\opentelemetry-help-support-feedback.md).

### [Java native](#tab/java-native)

* To review the source code, see [Azure Monitor OpenTelemetry Distro in Spring Boot native image Java application](https://github.com/Azure/azure-sdk-for-java/tree/main/sdk/spring/spring-cloud-azure-starter-monitor) and [Quarkus OpenTelemetry Exporter for Azure](https://github.com/quarkiverse/quarkus-opentelemetry-exporter/tree/main/quarkus-opentelemetry-exporter-azure).
* To learn more about OpenTelemetry and its community, see the [OpenTelemetry Java GitHub repository](https://github.com/open-telemetry/opentelemetry-java-instrumentation).
* To see the release notes, see [release notes](https://github.com/Azure/azure-sdk-for-java/blob/main/sdk/spring/spring-cloud-azure-starter-monitor/CHANGELOG.md) on GitHub.
* To review frequently asked questions, troubleshooting steps, support options, or to provide OpenTelemetry feedback, see [OpenTelemetry help, support, and feedback for Azure Monitor Application Insights](.\opentelemetry-help-support-feedback.md).

[!INCLUDE [quarkus-support](./includes/quarkus-support.md)]

### [Node.js](#tab/nodejs)

* To review the source code, see the [Azure Monitor OpenTelemetry GitHub repository](https://github.com/Azure/azure-sdk-for-js/tree/main/sdk/monitor/monitor-opentelemetry).
* To install the npm package and check for updates, see the [`@azure/monitor-opentelemetry` npm Package](https://www.npmjs.com/package/@azure/monitor-opentelemetry) page.
* To become more familiar with Azure Monitor Application Insights and OpenTelemetry, see the [Azure Monitor Example Application](https://github.com/Azure-Samples/azure-monitor-opentelemetry-node.js).
* To learn more about OpenTelemetry and its community, see the [OpenTelemetry JavaScript GitHub repository](https://github.com/open-telemetry/opentelemetry-js).
* To enable usage experiences, [enable web or browser user monitoring](javascript.md).
* To review frequently asked questions, troubleshooting steps, support options, or to provide OpenTelemetry feedback, see [OpenTelemetry help, support, and feedback for Azure Monitor Application Insights](.\opentelemetry-help-support-feedback.md).

### [Python](#tab/python)

* To review the source code and extra documentation, see the [Azure Monitor Distro GitHub repository](https://github.com/Azure/azure-sdk-for-python/blob/main/sdk/monitor/azure-monitor-opentelemetry/README.md).
* To see extra samples and use cases, see [Azure Monitor Distro samples](https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/monitor/azure-monitor-opentelemetry/samples).
* To see the release notes, see [release notes](https://github.com/Azure/azure-sdk-for-python/blob/main/sdk/monitor/azure-monitor-opentelemetry/CHANGELOG.md) on GitHub.
* To install the PyPI package, check for updates, or view release notes, see the [Azure Monitor Distro PyPI Package](https://pypi.org/project/azure-monitor-opentelemetry/) page.
* To become more familiar with Azure Monitor Application Insights and OpenTelemetry, see the [Azure Monitor Example Application](https://github.com/Azure-Samples/azure-monitor-opentelemetry-python).
* To learn more about OpenTelemetry and its community, see the [OpenTelemetry Python GitHub repository](https://github.com/open-telemetry/opentelemetry-python).
* To see available OpenTelemetry instrumentations and components, see the [OpenTelemetry Contributor Python GitHub repository](https://github.com/open-telemetry/opentelemetry-python-contrib).
* To enable usage experiences, [enable web or browser user monitoring](javascript.md).
* To review frequently asked questions, troubleshooting steps, support options, or to provide OpenTelemetry feedback, see [OpenTelemetry help, support, and feedback for Azure Monitor Application Insights](.\opentelemetry-help-support-feedback.md).

---