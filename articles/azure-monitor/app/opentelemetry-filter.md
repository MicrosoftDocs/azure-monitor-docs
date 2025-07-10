---
title: Filtering OpenTelemetry in Application Insights
description: Learn how to filter OpenTelemetry (OTel) data in Application Insights for .NET, Java, Node.js, and Python applications to exclude unwanted telemetry and protect sensitive information.
ms.topic: how-to
ms.date: 03/23/2025
# ms.devlang: csharp, javascript, typescript, python
ms.custom: devx-track-dotnet, devx-track-extended-java, devx-track-python
ms.reviewer: mmcc

#customer intent: As a developer or site reliability engineer, I want to filter OpenTelemetry (OTel) data in Application Insights so that I can exclude unnecessary telemetry and protect sensitive information in my .NET, Java, Node.js, or Python applications.

---

# Filter Azure Monitor OpenTelemetry for .NET, Java, Node.js, and Python applications

This guide provides instructions on filtering OpenTelemetry (OTel) data within [Azure Monitor Application Insights](app-insights-overview.md). Implementing filters allows developers to exclude unnecessary telemetry and prevent the collection of sensitive information, ensuring optimized performance and compliance.

Reasons why you might want to filter out telemetry include:

* Filtering out health check telemetry to reduce noise.
* Ensuring PII and credentials aren't collected.
* Filtering out low-value telemetry to optimize performance.

To learn more about OpenTelemetry concepts, see the [OpenTelemetry overview](opentelemetry-overview.md) or [OpenTelemetry FAQ](opentelemetry-help-support-feedback.md).

> [!NOTE]
> [!INCLUDE [application-insights-functions-link](./includes/application-insights-functions-link.md)]

## Filter OpenTelemetry using instrumentation libraries

For a list of all instrumentation libraries included with the Azure Monitor OpenTelemetry Distro, see [Add and modify Azure Monitor OpenTelemetry for .NET, Java, Node.js, and Python applications](./opentelemetry-add-modify.md#included-instrumentation-libraries).

### [ASP.NET Core](#tab/aspnetcore)

Many instrumentation libraries provide a filter option. For guidance, see the corresponding readme files:

* [ASP.NET Core](https://github.com/open-telemetry/opentelemetry-dotnet/blob/1.0.0-rc9.14/src/OpenTelemetry.Instrumentation.AspNetCore/README.md#filter)
* [HttpClient](https://github.com/open-telemetry/opentelemetry-dotnet/blob/1.0.0-rc9.14/src/OpenTelemetry.Instrumentation.Http/README.md#filter)
* [SqlClient](https://github.com/open-telemetry/opentelemetry-dotnet-contrib/blob/main/src/OpenTelemetry.Instrumentation.SqlClient/README.md#filter) <sup>1</sup>

<sup>1</sup> We include the [SqlClient](https://www.nuget.org/packages/OpenTelemetry.Instrumentation.SqlClient) instrumentation in our package while it's still in beta. When it reaches a stable release, we include it as a standard package reference. Until then, to customize the SQLClient instrumentation, add the `OpenTelemetry.Instrumentation.SqlClient` package reference to your project and use its public API.

`dotnet add package --prerelease OpenTelemetry.Instrumentation.SqlClient`

```csharp
builder.Services.AddOpenTelemetry().UseAzureMonitor().WithTracing(builder =>
{
    builder.AddSqlClientInstrumentation(options =>
    {
        options.SetDbStatementForStoredProcedure = false;
    });
});
```

### [.NET](#tab/net)

Many instrumentation libraries provide a filter option. For guidance, see the corresponding readme files:

* [ASP.NET](https://github.com/open-telemetry/opentelemetry-dotnet-contrib/blob/Instrumentation.AspNet-1.0.0-rc9.8/src/OpenTelemetry.Instrumentation.AspNet/README.md#filter)
* [HttpClient](https://github.com/open-telemetry/opentelemetry-dotnet/blob/1.0.0-rc9.14/src/OpenTelemetry.Instrumentation.Http/README.md#filter-httpclient-api)
* [SqlClient](https://github.com/open-telemetry/opentelemetry-dotnet-contrib/blob/main/src/OpenTelemetry.Instrumentation.SqlClient/README.md#filter)

> [!NOTE]
> The Azure Monitor Exporter doesn't include any instrumentation libraries. You can collect dependencies from the [Azure SDKs](https://github.com/Azure/azure-sdk). For more information, see [Add, modify, and filter OpenTelemetry](/azure/azure-monitor/app/opentelemetry-add-modify?tabs=net#included-instrumentation-libraries).

### [Java](#tab/java)

Starting with Java agent version 3.0.3, specific autocollected telemetry can be suppressed. For more information, see [Configuration options: Azure Monitor Application Insights for Java](./java-standalone-config.md#suppress-specific-autocollected-telemetry).

> [!NOTE]
> There's no need to filter SQL telemetry for PII reasons since all literal values are automatically scrubbed.

### [Java native](#tab/java-native)

Suppressing autocollected telemetry isn't supported with Java native. To filter telemetry, refer to the relevant external documentation:

* **Spring Boot** - [Spring Boot starter](https://opentelemetry.io/docs/zero-code/java/spring-boot-starter/)
* **Quarkus** - [Using OpenTelemetry tracing](https://quarkus.io/guides/opentelemetry-tracing)

### [Node.js](#tab/nodejs)

> [!NOTE]
> This example is specific to HTTP instrumentations. For other signal types, there's currently no specific mechanism available to filter out telemetry. Instead, a custom span processor is required.

The following example shows how to exclude a certain URL from being tracked by using the [HTTP/HTTPS instrumentation library](https://github.com/open-telemetry/opentelemetry-js/tree/main/experimental/packages/opentelemetry-instrumentation-http):

```typescript
// Import the useAzureMonitor function and the ApplicationInsightsOptions class from the @azure/monitor-opentelemetry package.
const { useAzureMonitor, ApplicationInsightsOptions } = require("@azure/monitor-opentelemetry");

// Import the HttpInstrumentationConfig class from the @opentelemetry/instrumentation-http package.
const { HttpInstrumentationConfig }= require("@opentelemetry/instrumentation-http");

// Import the IncomingMessage and RequestOptions classes from the http and https packages, respectively.
const { IncomingMessage } = require("http");
const { RequestOptions } = require("https");

// Create a new HttpInstrumentationConfig object.
const httpInstrumentationConfig: HttpInstrumentationConfig = {
    enabled: true,
    ignoreIncomingRequestHook: (request: IncomingMessage) => {
    // Ignore OPTIONS incoming requests.
    if (request.method === 'OPTIONS') {
        return true;
    }
    return false;
    },
    ignoreOutgoingRequestHook: (options: RequestOptions) => {
    // Ignore outgoing requests with the /test path.
    if (options.path === '/test') {
        return true;
    }
    return false;
    }
};

// Create a new ApplicationInsightsOptions object.
const config: ApplicationInsightsOptions = {
    instrumentationOptions: {
    http: {
        httpInstrumentationConfig
    }
    }
};

// Enable Azure Monitor integration using the useAzureMonitor function and the ApplicationInsightsOptions object.
useAzureMonitor(config);
```

### [Python](#tab/python)

> [!NOTE]
> This example is specific to HTTP instrumentations. For other signal types, there's currently no specific mechanism available to filter out telemetry. Instead, a custom span processor is required.

The following example shows how to exclude a certain URL from being tracked by using the `OTEL_PYTHON_EXCLUDED_URLS` environment variable:

```
export OTEL_PYTHON_EXCLUDED_URLS="http://localhost:8080/ignore"
```

Doing so excludes the endpoint shown in the following Flask example:

```python
...
# Import the Flask and Azure Monitor OpenTelemetry SDK libraries.
import flask
from azure.monitor.opentelemetry import configure_azure_monitor

# Configure OpenTelemetry to use Azure Monitor with the specified connection string.
# Replace `<your-connection-string>` with the connection string to your Azure Monitor Application Insights resource.
configure_azure_monitor(
    connection_string="<your-connection-string>",
)

# Create a Flask application.
app = flask.Flask(__name__)

# Define a route. Requests sent to this endpoint will not be tracked due to
# flask_config configuration.
@app.route("/ignore")
def ignore():
    return "Request received but not tracked."
...
```

---

## Filter telemetry using span processors

### [ASP.NET Core](#tab/aspnetcore)

1. Use a custom processor:

    > [!TIP]
    > Add the processor shown here *before* adding Azure Monitor.
    
    ```csharp
    // Create an ASP.NET Core application builder.
    var builder = WebApplication.CreateBuilder(args);
    
    // Configure the OpenTelemetry tracer provider to add a new processor named ActivityFilteringProcessor.
    builder.Services.ConfigureOpenTelemetryTracerProvider((sp, builder) => builder.AddProcessor(new ActivityFilteringProcessor()));
    // Configure the OpenTelemetry tracer provider to add a new source named "ActivitySourceName".
    builder.Services.ConfigureOpenTelemetryTracerProvider((sp, builder) => builder.AddSource("ActivitySourceName"));
    // Add the Azure Monitor telemetry service to the application. This service will collect and send telemetry data to Azure Monitor.
    builder.Services.AddOpenTelemetry().UseAzureMonitor();
    
    // Build the ASP.NET Core application.
    var app = builder.Build();
    
    // Start the ASP.NET Core application.
    app.Run();
    ```

2. Add `ActivityFilteringProcessor.cs` to your project with the following code:

    ```csharp
    public class ActivityFilteringProcessor : BaseProcessor<Activity>
    {
        // The OnStart method is called when an activity is started. This is the ideal place to filter activities.
        public override void OnStart(Activity activity)
        {
            // prevents all exporters from exporting internal activities
            if (activity.Kind == ActivityKind.Internal)
            {
                activity.IsAllDataRequested = false;
            }
        }
    }
    ```

If a particular source isn't explicitly added by using `AddSource("ActivitySourceName")`, then none of the activities created by using that source are exported.

### [.NET](#tab/net)

1. Use a custom processor:
    
    ```csharp
    // Create an OpenTelemetry tracer provider builder.
    // It is important to keep the TracerProvider instance active throughout the process lifetime.
    using var tracerProvider = Sdk.CreateTracerProviderBuilder()
            .AddSource("OTel.AzureMonitor.Demo") // Add a source named "OTel.AzureMonitor.Demo".
            .AddProcessor(new ActivityFilteringProcessor()) // Add a new processor named ActivityFilteringProcessor.
            .AddAzureMonitorTraceExporter() // Add the Azure Monitor trace exporter.
            .Build();
    ```

2. Add `ActivityFilteringProcessor.cs` to your project with the following code:
    
    ```csharp
    public class ActivityFilteringProcessor : BaseProcessor<Activity>
    {
        // The OnStart method is called when an activity is started. This is the ideal place to filter activities.
        public override void OnStart(Activity activity)
        {
            // prevents all exporters from exporting internal activities
            if (activity.Kind == ActivityKind.Internal)
            {
                activity.IsAllDataRequested = false;
            }
        }
    }
    ```

If a particular source isn't explicitly added by using `AddSource("ActivitySourceName")`, then none of the activities created by using that source are exported.

### [Java](#tab/java)

To filter telemetry from Java applications, you can use sampling overrides (recommended) or telemetry processors. For more information, see the following documentation:

* [Sampling overrides](./java-standalone-sampling-overrides.md)
* [Telemetry processors (preview)](./java-standalone-telemetry-processors.md)
* [Telemetry processor examples](./java-standalone-telemetry-processors-examples.md)

### [Java native](#tab/java-native)

Sampling overrides and telemetry processors aren't supported with Java native. To filter telemetry, refer to the relevant external documentation:

* **Spring Boot** - [Spring Boot starter](https://opentelemetry.io/docs/zero-code/java/spring-boot-starter/)
* **Quarkus** - [Using OpenTelemetry tracing](https://quarkus.io/guides/opentelemetry-tracing)

### [Node.js](#tab/nodejs)

You can use a custom span processor to exclude certain spans from being exported. To mark spans to not be exported, set `TraceFlag` to `DEFAULT`.

Use the [custom property example](/azure/azure-monitor/app/opentelemetry-add-modify?tabs=nodejs#add-a-custom-property-to-a-span), but replace the following lines of code:

```typescript
// Import the necessary packages.
const { SpanKind, TraceFlags } = require("@opentelemetry/api");
const { ReadableSpan, Span, SpanProcessor } = require("@opentelemetry/sdk-trace-base");

// Create a new SpanEnrichingProcessor class.
class SpanEnrichingProcessor implements SpanProcessor {
    forceFlush(): Promise<void> {
        return Promise.resolve();
    }

    shutdown(): Promise<void> {
        return Promise.resolve();
    }

    onStart(_span: Span): void {}

    onEnd(span) {
        // If the span is an internal span, set the trace flags to NONE.
        if(span.kind == SpanKind.INTERNAL){
        span.spanContext().traceFlags = TraceFlags.NONE;
        }
    }
}
```

### [Python](#tab/python)

You can use a custom span processor to exclude certain spans from being exported. To mark spans to not be exported, set `TraceFlag` to `DEFAULT`:
    
```python
...
# Import the necessary libraries.
from azure.monitor.opentelemetry import configure_azure_monitor
from opentelemetry import trace

# Configure OpenTelemetry to use Azure Monitor with the specified connection string.
# Replace `<your-connection-string>` with the connection string to your Azure Monitor Application Insights resource.
configure_azure_monitor(
    connection_string="<your-connection-string>",
    # Configure the custom span processors to include span filter processor.
    span_processors=[span_filter_processor],
)

...
```

Add `SpanFilteringProcessor` to your project with the following code:

```python
# Import the necessary libraries.
from opentelemetry.trace import SpanContext, SpanKind, TraceFlags
from opentelemetry.sdk.trace import SpanProcessor

# Define a custom span processor called `SpanFilteringProcessor`.
class SpanFilteringProcessor(SpanProcessor):

    # Prevents exporting spans from internal activities.
    def on_start(self, span, parent_context):
        # Check if the span is an internal activity.
        if span._kind is SpanKind.INTERNAL:
            # Create a new span context with the following properties:
            #   * The trace ID is the same as the trace ID of the original span.
            #   * The span ID is the same as the span ID of the original span.
            #   * The is_remote property is set to `False`.
            #   * The trace flags are set to `DEFAULT`.
            #   * The trace state is the same as the trace state of the original span.
            span._context = SpanContext(
                span.context.trace_id,
                span.context.span_id,
                span.context.is_remote,
                TraceFlags(TraceFlags.DEFAULT),
                span.context.trace_state,
            )
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

### [.NET](#tab/net)

* To further configure the OpenTelemetry distro, see [Azure Monitor OpenTelemetry configuration](opentelemetry-configuration.md)
* To review the source code, see the [Azure Monitor Exporter GitHub repository](https://github.com/Azure/azure-sdk-for-net/tree/main/sdk/monitor/Azure.Monitor.OpenTelemetry.Exporter).
* To install the NuGet package, check for updates, or view release notes, see the [Azure Monitor Exporter NuGet Package](https://www.nuget.org/packages/Azure.Monitor.OpenTelemetry.Exporter) page.
* To become more familiar with Azure Monitor and OpenTelemetry, see the [Azure Monitor Example Application](https://github.com/Azure/azure-sdk-for-net/tree/main/sdk/monitor/Azure.Monitor.OpenTelemetry.Exporter/tests/Azure.Monitor.OpenTelemetry.Exporter.Demo).
* To learn more about OpenTelemetry and its community, see the [OpenTelemetry .NET GitHub repository](https://github.com/open-telemetry/opentelemetry-dotnet).
* To enable usage experiences, [enable web or browser user monitoring](javascript.md).
* To review frequently asked questions, troubleshooting steps, support options, or to provide OpenTelemetry feedback, see [OpenTelemetry help, support, and feedback for Azure Monitor Application Insights](.\opentelemetry-help-support-feedback.md).

### [Java](#tab/java)

* Review [Java autoinstrumentation configuration options](java-standalone-config.md).
* To review the source code, see the [Azure Monitor Java autoinstrumentation GitHub repository](https://github.com/Microsoft/ApplicationInsights-Java).
* To learn more about OpenTelemetry and its community, see the [OpenTelemetry Java GitHub repository](https://github.com/open-telemetry/opentelemetry-java-instrumentation).
* To enable usage experiences, see [Enable web or browser user monitoring](javascript.md).
* See the [release notes](https://github.com/microsoft/ApplicationInsights-Java/releases) on GitHub.
* To review frequently asked questions, troubleshooting steps, support options, or to provide OpenTelemetry feedback, see [OpenTelemetry help, support, and feedback for Azure Monitor Application Insights](.\opentelemetry-help-support-feedback.md).

### [Java native](#tab/java-native)

* For details on adding and modifying Azure Monitor OpenTelemetry, see [Add and modify Azure Monitor OpenTelemetry](opentelemetry-add-modify.md).
* To review the source code, see [Azure Monitor OpenTelemetry Distro in Spring Boot native image Java application](https://github.com/Azure/azure-sdk-for-java/tree/main/sdk/spring/spring-cloud-azure-starter-monitor) and [Quarkus OpenTelemetry Exporter for Azure](https://github.com/quarkiverse/quarkus-opentelemetry-exporter/tree/main/quarkus-opentelemetry-exporter-azure).
* To learn more about OpenTelemetry and its community, see the [OpenTelemetry Java GitHub repository](https://github.com/open-telemetry/opentelemetry-java-instrumentation).
* See the [release notes](https://github.com/Azure/azure-sdk-for-java/blob/main/sdk/spring/spring-cloud-azure-starter-monitor/CHANGELOG.md) on GitHub.
* To review frequently asked questions, troubleshooting steps, support options, or to provide OpenTelemetry feedback, see [OpenTelemetry help, support, and feedback for Azure Monitor Application Insights](.\opentelemetry-help-support-feedback.md).

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
* See the [release notes](https://github.com/Azure/azure-sdk-for-python/blob/main/sdk/monitor/azure-monitor-opentelemetry/CHANGELOG.md) on GitHub.
* To install the PyPI package, check for updates, or view release notes, see the [Azure Monitor Distro PyPI Package](https://pypi.org/project/azure-monitor-opentelemetry/) page.
* To become more familiar with Azure Monitor Application Insights and OpenTelemetry, see the [Azure Monitor Example Application](https://github.com/Azure-Samples/azure-monitor-opentelemetry-python).
* To learn more about OpenTelemetry and its community, see the [OpenTelemetry Python GitHub repository](https://github.com/open-telemetry/opentelemetry-python).
* To see available OpenTelemetry instrumentations and components, see the [OpenTelemetry Contributor Python GitHub repository](https://github.com/open-telemetry/opentelemetry-python-contrib).
* To enable usage experiences, [enable web or browser user monitoring](javascript.md).
* To review frequently asked questions, troubleshooting steps, support options, or to provide OpenTelemetry feedback, see [OpenTelemetry help, support, and feedback for Azure Monitor Application Insights](.\opentelemetry-help-support-feedback.md).

---