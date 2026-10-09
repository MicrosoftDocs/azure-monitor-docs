---
title: Filter OpenTelemetry in Application Insights
description: Learn how to filter OpenTelemetry (OTel) data in Application Insights for .NET, Java, Node.js, and Python applications. Exclude unwanted telemetry and protect sensitive information.
ms.topic: how-to
ms.date: 09/11/2026
ai-usage: ai-assisted
# ms.devlang: csharp, javascript, typescript, python
ms.custom:
  - devx-track-dotnet, devx-track-extended-java, devx-track-python
  - sfi-ropc-nochange
  - cbo-v1.6

#customer intent: As a developer or site reliability engineer, I want to filter OpenTelemetry (OTel) data in Application Insights so that I can exclude unnecessary telemetry and protect sensitive information in my .NET, Java, Node.js, or Python applications.

---

# Filter OpenTelemetry for .NET, Java, Node.js, and Python applications

[!INCLUDE [Choose an OpenTelemetry onboarding path](includes/opentelemetry-onboarding-paths.md)]

Use this guide to filter OpenTelemetry (OTel) data in [Azure Monitor Application Insights](app-insights-overview.md). Filtering helps you exclude unnecessary telemetry and prevent collection of sensitive data to optimize performance and support compliance.

Use the Microsoft OpenTelemetry Distro for .NET, Node.js, and Python. Java continues to use the Azure Monitor OpenTelemetry Distro. First, [enable the distro](opentelemetry-enable.md) for your language. The examples that initialize the distro replace the basic initialization; don't initialize a second distro or provider for the same signal.

For Node.js, enable instrumentation before loading application libraries. ESM applications must preload the [Microsoft OpenTelemetry Distro loader](https://github.com/microsoft/opentelemetry-distro-javascript#esm-support). Set `APPLICATIONINSIGHTS_CONNECTION_STRING` before running examples that don't set it in code.

Reasons to filter out telemetry include:

* Filtering out health check telemetry to reduce noise.
* Ensuring personal data and credentials aren't collected.
* Filtering out low-value telemetry to optimize performance.

To learn more about OpenTelemetry concepts, review the [OpenTelemetry overview](app-insights-overview.md).

> [!NOTE]
> [!INCLUDE [application-insights-functions-link](./includes/application-insights-functions-link.md)]

## Filter OpenTelemetry using instrumentation libraries

For the instrumentation libraries included with each distro, review [Automatic data collection and resource detectors](./opentelemetry-collect-detect.md#included-instrumentation-libraries).

# [ASP.NET Core](#tab/aspnetcore)

Many instrumentation libraries provide a filter option. For guidance, review the corresponding readme files:

* [ASP.NET Core](https://github.com/open-telemetry/opentelemetry-dotnet/blob/1.0.0-rc9.14/src/OpenTelemetry.Instrumentation.AspNetCore/README.md#filter)
* [HttpClient](https://github.com/open-telemetry/opentelemetry-dotnet/blob/1.0.0-rc9.14/src/OpenTelemetry.Instrumentation.Http/README.md#filter)
* [SqlClient](https://github.com/open-telemetry/opentelemetry-dotnet-contrib/blob/main/src/OpenTelemetry.Instrumentation.SqlClient/README.md#filter) <!--<sup>1</sup>-->

> [!NOTE]
> The Microsoft OpenTelemetry Distro for .NET includes a copy of the SqlClient instrumentation source code while the upstream library remains experimental.
>
> Options on a separately installed SqlClient instrumentation package don't configure the bundled copy. To use that package for custom filtering, disable the bundled instrumentation with `options.Instrumentation.EnableSqlClientInstrumentation = false`, then register your configured instrumentation once.
>
> See [Microsoft OpenTelemetry Distro instrumentation customization](https://github.com/microsoft/opentelemetry-distro-dotnet/blob/main/docs/customization.md#sql-client-customization).

# [.NET](#tab/net)

Many instrumentation libraries provide a filter option. For guidance, review the corresponding readme files:

* [ASP.NET](https://github.com/open-telemetry/opentelemetry-dotnet-contrib/blob/Instrumentation.AspNet-1.0.0-rc9.8/src/OpenTelemetry.Instrumentation.AspNet/README.md#filter)
* [HttpClient](https://github.com/open-telemetry/opentelemetry-dotnet/blob/1.0.0-rc9.14/src/OpenTelemetry.Instrumentation.Http/README.md#filter-httpclient-api)
* [SqlClient](https://github.com/open-telemetry/opentelemetry-dotnet-contrib/blob/main/src/OpenTelemetry.Instrumentation.SqlClient/README.md#filter)

> [!NOTE]
> The Microsoft OpenTelemetry Distro for .NET includes instrumentation libraries. The standalone Azure Monitor exporter doesn't. Use the [distro instrumentation options](https://github.com/microsoft/opentelemetry-distro-dotnet/blob/main/docs/azure-monitor-getting-started.md#instrumentation-options) to disable bundled libraries, or configure the relevant OpenTelemetry instrumentation options for filtering.

# [Java](#tab/java)

> [!NOTE]
> This feature is available starting with Java agent version 3.0.3.

Suppress specific autocollected telemetry by using these configuration options or environment variables:

<details>
<summary>Disable automatic instrumentation</summary>

```json
{
  "instrumentation": {
    "azureSdk": {
      "enabled": false
    },
    "cassandra": {
      "enabled": false
    },
    "jdbc": {
      "enabled": false
    },
    "jms": {
      "enabled": false
    },
    "kafka": {
      "enabled": false
    },
    "logging": {
      "enabled": false
    },
    "micrometer": {
      "enabled": false
    },
    "mongo": {
      "enabled": false
    },
    "quartz": {
      "enabled": false
    },
    "rabbitmq": {
      "enabled": false
    },
    "redis": {
      "enabled": false
    },
    "springScheduling": {
      "enabled": false
    }
  }
}
```

</details>

You can also suppress instrumentations by setting these environment variables to `false`:

* `APPLICATIONINSIGHTS_INSTRUMENTATION_AZURE_SDK_ENABLED`
* `APPLICATIONINSIGHTS_INSTRUMENTATION_CASSANDRA_ENABLED`
* `APPLICATIONINSIGHTS_INSTRUMENTATION_JDBC_ENABLED`
* `APPLICATIONINSIGHTS_INSTRUMENTATION_JMS_ENABLED`
* `APPLICATIONINSIGHTS_INSTRUMENTATION_KAFKA_ENABLED`
* `APPLICATIONINSIGHTS_INSTRUMENTATION_LOGGING_ENABLED`
* `APPLICATIONINSIGHTS_INSTRUMENTATION_MICROMETER_ENABLED`
* `APPLICATIONINSIGHTS_INSTRUMENTATION_MONGO_ENABLED`
* `APPLICATIONINSIGHTS_INSTRUMENTATION_RABBITMQ_ENABLED`
* `APPLICATIONINSIGHTS_INSTRUMENTATION_REDIS_ENABLED`
* `APPLICATIONINSIGHTS_INSTRUMENTATION_SPRING_SCHEDULING_ENABLED`

These variables take precedence over the enabled variables specified in the JSON configuration.

> [!NOTE]
> * For more fine-grained control, such as suppressing some Redis calls but not all Redis calls, see [Configure sampling overrides](java-standalone-config.md#configure-sampling-overrides).
>
> * You don't need to filter SQL telemetry for personal data reasons since all literal values are automatically scrubbed.

# [Java native](#tab/java-native)

Suppressing autocollected telemetry isn't supported with Java native. To filter telemetry, refer to the relevant external documentation:

* **Spring Boot** - [Spring Boot starter](https://opentelemetry.io/docs/zero-code/java/spring-boot-starter/)
* **Quarkus** - [Using OpenTelemetry tracing](https://quarkus.io/guides/opentelemetry-tracing)

[!INCLUDE [quarkus-support](./includes/quarkus-support.md)]

# [Node.js](#tab/nodejs)

> [!NOTE]
> This example is specific to HTTP instrumentations. For other signal types, there's currently no specific mechanism available to filter out telemetry. Instead, a custom span processor is required.

The following example shows how to exclude a certain URL from being tracked by using the [HTTP/HTTPS instrumentation library](https://github.com/open-telemetry/opentelemetry-js/tree/main/experimental/packages/opentelemetry-instrumentation-http):

<details>
<summary>Filter OpenTelemetry using instrumentation libraries</summary>

```typescript
// Import the distro API and supporting instrumentation types.
import { useMicrosoftOpenTelemetry } from "@microsoft/opentelemetry";
import type { HttpInstrumentationConfig } from "@opentelemetry/instrumentation-http";

// Define which HTTP requests to exclude.
const httpOptions: HttpInstrumentationConfig = {
    enabled: true,

    // Exclude incoming OPTIONS requests.
    ignoreIncomingRequestHook: (request) => request.method === "OPTIONS",

    // Exclude outgoing requests to the /test path.
    ignoreOutgoingRequestHook: (request) => request.path === "/test",
};

// Initialize the Microsoft OpenTelemetry Distro.
useMicrosoftOpenTelemetry({
    azureMonitor: {
        azureMonitorExporterOptions: {
            connectionString: process.env.APPLICATIONINSIGHTS_CONNECTION_STRING,
        },
    },
    instrumentationOptions: {
        http: httpOptions,
    },
});
```

</details>

# [Python](#tab/python)

> [!NOTE]
> This example is specific to HTTP instrumentations. For other signal types, there's currently no specific mechanism available to filter out telemetry. Instead, a custom span processor is required.

The following example shows how to exclude a certain URL from being tracked by using the `OTEL_PYTHON_EXCLUDED_URLS` environment variable:

```bash
export OTEL_PYTHON_EXCLUDED_URLS="http://localhost:8080/ignore"
```

Doing so excludes the endpoint shown in the following Flask example:

```python
...
# Import Flask and the Microsoft OpenTelemetry Distro.
import flask
from microsoft.opentelemetry import use_microsoft_opentelemetry

# Configure OpenTelemetry to use Azure Monitor with the specified connection string.
use_microsoft_opentelemetry(
    enable_azure_monitor=True,
    azure_monitor_connection_string="<ConnectionString>",
)

# Create a Flask application.
app = flask.Flask(__name__)


# Exclude this route through OTEL_PYTHON_EXCLUDED_URLS.
@app.route("/ignore")
def ignore():
    return "Request received but not tracked."


...
```

---

## Filter telemetry using span processors

Use a span processor to filter spans before the exporter sends them to Application Insights.

# [ASP.NET Core](#tab/aspnetcore)

1. Use a custom processor:

    > [!TIP]
    > Add the processor shown here *before* adding Azure Monitor.

    <details>
    <summary>Filter telemetry using span processors</summary>

    ```csharp
    // Import the Microsoft OpenTelemetry Distro and supporting APIs.
    using Microsoft.OpenTelemetry;
    using OpenTelemetry.Trace;

    // Create the application builder.
    var builder = WebApplication.CreateBuilder(args);

    builder.Services.AddOpenTelemetry()
      .WithTracing(tracing => tracing

        // Collect spans from the application activity source.
        .AddSource("ActivitySourceName")

        // Run the custom processor before exporting spans.
        .AddProcessor(new ActivityFilteringProcessor()))

      // Configure the Microsoft OpenTelemetry Distro.
      .UseMicrosoftOpenTelemetry(options =>
      {
        options.Exporters = ExportTarget.AzureMonitor;
      });

    // Build the application with the configured telemetry services.
    var app = builder.Build();

    // Run the application and its telemetry providers.
    app.Run();
    ```

    </details>

1. Add `ActivityFilteringProcessor.cs` to your project with the following code:

    ```csharp
    using System.Diagnostics;
    using OpenTelemetry;

    public class ActivityFilteringProcessor : BaseProcessor<Activity>
    {
        // The OnStart method is called when an activity is started. This is the ideal place
        // to filter activities.
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

# [.NET](#tab/net)

1. Use a custom processor:

    ```csharp
    // Import the Microsoft OpenTelemetry Distro and supporting APIs.
    using Microsoft.OpenTelemetry;
    using OpenTelemetry;
    using OpenTelemetry.Trace;

    // Create the SDK and keep its providers alive until application shutdown.
    using var sdk = OpenTelemetrySdk.Create(telemetry =>
    {
      telemetry.WithTracing(tracing => tracing

        // Collect spans from the application activity source.
        .AddSource("OTel.AzureMonitor.Demo")

        // Run the custom processor before exporting spans.
        .AddProcessor(new ActivityFilteringProcessor()))

        // Configure the Microsoft OpenTelemetry Distro.
        .UseMicrosoftOpenTelemetry(options =>
        {
          options.Exporters = ExportTarget.AzureMonitor;
        });
    });
    ```

    Keep `sdk` alive for the application lifetime and dispose it only at shutdown.

1. Add `ActivityFilteringProcessor.cs` to your project with the following code:

    ```csharp
    using System.Diagnostics;
    using OpenTelemetry;

    public class ActivityFilteringProcessor : BaseProcessor<Activity>
    {
        // The OnStart method is called when an activity is started. This is the ideal place
        // to filter activities.
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

# [Java](#tab/java)

To filter telemetry from Java applications, you can use sampling overrides (recommended) or telemetry processors. For more information, review the following documentation:

* [Sampling overrides](./java-standalone-sampling-overrides.md)
* [Telemetry processors (preview)](./java-standalone-telemetry-processors.md)
* [Telemetry processor examples](./java-standalone-telemetry-processors-examples.md)

# [Java native](#tab/java-native)

Sampling overrides and telemetry processors aren't supported with Java native. To filter telemetry, refer to the relevant external documentation:

* **Spring Boot** - [Spring Boot starter](https://opentelemetry.io/docs/zero-code/java/spring-boot-starter/)
* **Quarkus** - [Using OpenTelemetry tracing](https://quarkus.io/guides/opentelemetry-tracing)

[!INCLUDE [quarkus-support](./includes/quarkus-support.md)]

# [Node.js](#tab/nodejs)

You can use a custom span processor to exclude certain spans from being exported. To suppress export, set the span context's `traceFlags` to `TraceFlags.NONE`.

Use the [custom property example](/azure/azure-monitor/app/opentelemetry-add-modify?tabs=nodejs#add-a-custom-property-to-a-span), but replace the following lines of code:

```typescript
// Import the necessary packages.
import { SpanKind, TraceFlags } from "@opentelemetry/api";
import type { ReadableSpan, Span, SpanProcessor } from "@opentelemetry/sdk-trace-base";

// Create a new SpanEnrichingProcessor class.
class SpanEnrichingProcessor implements SpanProcessor {
    forceFlush(): Promise<void> {
        return Promise.resolve();
    }

    shutdown(): Promise<void> {
        return Promise.resolve();
    }

    onStart(_span: Span): void {}

    onEnd(span: ReadableSpan): void {
        // If the span is an internal span, set the trace flags to NONE.
        if (span.kind == SpanKind.INTERNAL) {
            span.spanContext().traceFlags = TraceFlags.NONE;
        }
    }
}
```

# [Python](#tab/python)

You can use a custom span processor to exclude certain spans from being exported. Set the span context's trace flags to `TraceFlags.DEFAULT`. Save the following processor as `span_filtering_processor.py`, and then register an instance:

```python
...
# Import the necessary libraries.
from microsoft.opentelemetry import use_microsoft_opentelemetry
from opentelemetry import trace
from span_filtering_processor import SpanFilteringProcessor

# Configure OpenTelemetry to use Azure Monitor with the specified connection string.
use_microsoft_opentelemetry(
    enable_azure_monitor=True,
    azure_monitor_connection_string="<ConnectionString>",
    # Register the processor that filters internal spans.
    span_processors=[SpanFilteringProcessor()],
)

...
```

Use the following code in `span_filtering_processor.py`:

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

## Filter telemetry at ingestion using data collection rules

Reduce noise or standardize telemetry before Azure Monitor stores it in a Log Analytics workspace. To achieve that goal, use ingestion-time transformations in a data collection rule (DCR) to filter or modify telemetry after Azure Monitor receives it.

Transformations use a Kusto Query Language (KQL) statement that runs on each ingested record.

Use a workspace transformation DCR for Application Insights tables. A Log Analytics workspace supports one workspace transformation DCR. Put all transformations for that workspace in the same DCR.

Activation can take up to 60 minutes after an update.

Use these resources to learn more:

* Review [data collection rules (DCRs)](../data-collection/data-collection-rule-overview.md).
* Review [transformations in Azure Monitor](../data-collection/data-collection-transformations.md).
* Review the workspace transformation tutorial for the [Azure portal](../logs/tutorial-workspace-transformations-portal.md).
* Review the workspace transformation tutorial for [Resource Manager templates](../logs/tutorial-workspace-transformations-api.md).
* Review [Create a transformation in Azure Monitor](../data-collection/data-collection-transformations-create.md).
* Review [supported KQL features in transformations](../data-collection/data-collection-transformations-kql.md).
* Review the [Application Insights tables that support ingestion-time transformations](../reference/supported-logs/microsoft-insights-components-logs.md).

### Map OpenTelemetry signals to Log Analytics tables

Application Insights stores common OpenTelemetry (OTel) signals in these tables:

* `AppTraces` (logs)
* `AppRequests` (incoming requests)
* `AppDependencies` (outgoing dependencies)
* `AppExceptions` (exceptions)
* `AppMetrics` (metrics)

In a workspace transformation DCR, use the stream name format `Microsoft-Table-<TableName>` for each table. For example, use `Microsoft-Table-AppRequests` for the `AppRequests` table.

> [!NOTE]
> A workspace transformation DCR applies to all data ingested into the selected tables in that Log Analytics workspace. If multiple applications share the same workspace, scope each transformation by using a filter such as `AppRoleName` or `ResourceGUID`.

### Use workspace transformation DCR samples

The following samples show JSON for a `Microsoft.Insights/dataCollectionRules` resource with `kind` set to `WorkspaceTransforms`. They aren't complete ARM templates or standalone deployment commands. For creation and workspace association, follow the [workspace transformation tutorial](../logs/tutorial-workspace-transformations-api.md#create-data-collection-rule-dcr).

The first example shows a DCR resource request body. The remaining examples are objects or arrays of objects for its `properties.dataFlows` array. Use one transformation per table and keep each `transformKql` value on one line.

When updating an existing workspace transformation DCR:

* If a flow already targets the table, edit that flow's `transformKql` instead of adding a second flow for the same table. Combine the example with any existing filtering or redaction requirements.
* Add a data-flow object only for a table that doesn't already have a flow. An array example contains individual flows to add or update; it doesn't replace the entire `properties.dataFlows` array.
* Preserve other data flows, destinations, and resource settings. The `laDest` destination name must match the workspace destination in `properties.destinations.logAnalytics`.

<br>
<details>
<summary><b>Define a workspace transformation DCR request body</b></summary>

This resource-body excerpt defines an unchanged-data transformation for `AppRequests`. It isn't independently deployable. Use it as the starting resource definition for a new workspace transformation DCR, not as a replacement for an existing DCR. In an ARM template, insert these fields inside the `Microsoft.Insights/dataCollectionRules` resource declaration in the `resources` array. Retain its `type`, `apiVersion`, and `name` fields and any other existing resource settings.

```json
{
  "kind": "WorkspaceTransforms",
  "location": "<Location>",
  "properties": {
    "dataSources": {},
    "destinations": {
      "logAnalytics": [
        {
          "workspaceResourceId": "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.OperationalInsights/workspaces/<WorkspaceName>",
          "name": "laDest"
        }
      ]
    },
    "dataFlows": [
      {
        "streams": ["Microsoft-Table-AppRequests"],
        "destinations": ["laDest"],
        "transformKql": "source"
      }
    ]
  }
}
```

</details>

<details>
<summary><b>Drop a telemetry type by dropping a table</b></summary>

Use this sample to block an entire telemetry type, such as all traces or all requests.

Add or update one object in `properties.dataFlows` for each table whose incoming records you want to drop. Keep flows for other tables. These transformations discard incoming records; they don't delete the tables or previously stored data.

```json
[
  {
    "streams": ["Microsoft-Table-AppTraces"],
    "destinations": ["laDest"],
    "transformKql": "source | where 1 == 0"
  },
  {
    "streams": ["Microsoft-Table-AppRequests"],
    "destinations": ["laDest"],
    "transformKql": "source | where 1 == 0"
  },
  {
    "streams": ["Microsoft-Table-AppDependencies"],
    "destinations": ["laDest"],
    "transformKql": "source | where 1 == 0"
  },
  {
    "streams": ["Microsoft-Table-AppExceptions"],
    "destinations": ["laDest"],
    "transformKql": "source | where 1 == 0"
  },
  {
    "streams": ["Microsoft-Table-AppMetrics"],
    "destinations": ["laDest"],
    "transformKql": "source | where 1 == 0"
  }
]
```

</details>

<details>
<summary><b>Drop health check requests</b></summary>

Use this sample to drop common health, readiness, and liveness endpoints.

```json
{
  "streams": ["Microsoft-Table-AppRequests"],
  "destinations": ["laDest"],
  "transformKql": "source | extend url = tolower(tostring(Url)) | where not(url contains '/health' or url contains '/healthz' or url contains '/ready' or url contains '/readyz' or url contains '/live' or url contains '/livez') | project-away url"
}
```

</details>

<details>
<summary><b>Keep only failing health check requests</b></summary>

Use this sample to keep failing health checks and drop successful health checks.

```json
{
  "streams": ["Microsoft-Table-AppRequests"],
  "destinations": ["laDest"],
  "transformKql": "source | extend url = tolower(tostring(Url)) | where not((url contains '/health' or url contains '/healthz' or url contains '/ready' or url contains '/readyz' or url contains '/live' or url contains '/livez') and Success == true) | project-away url"
}
```

</details>

<details>
<summary><b>Keep only failed or slow requests</b></summary>

Use this sample to keep requests that fail or exceed a latency threshold.

```json
{
  "streams": ["Microsoft-Table-AppRequests"],
  "destinations": ["laDest"],
  "transformKql": "source | where Success == false or DurationMs >= 1000"
}
```

</details>

<details>
<summary><b>Keep only Warning and higher traces</b></summary>

Use this sample to keep trace records with `SeverityLevel` of `Warning` (2), `Error` (3), or `Critical` (4).

```json
{
  "streams": ["Microsoft-Table-AppTraces"],
  "destinations": ["laDest"],
  "transformKql": "source | where SeverityLevel >= 2"
}
```

</details>

<details>
<summary><b>Keep only failed or slow dependencies</b></summary>

Use this sample to keep dependency calls that fail or exceed a latency threshold.

```json
{
  "streams": ["Microsoft-Table-AppDependencies"],
  "destinations": ["laDest"],
  "transformKql": "source | where Success == false or DurationMs >= 500"
}
```

</details>

<details>
<summary><b>Remove SQL statements from dependency data</b></summary>

Use this sample to remove SQL statements stored in the `Data` column while keeping dependency timing and success information.

```json
{
  "streams": ["Microsoft-Table-AppDependencies"],
  "destinations": ["laDest"],
  "transformKql": "source | extend dependencyType = tolower(tostring(DependencyType)) | extend Data = iff(dependencyType == 'sql', '', Data) | project-away dependencyType"
}
```

</details>

<details>
<summary><b>Drop synthetic traffic</b></summary>

Use this sample to drop records that include a `SyntheticSource` value.

```json
{
  "streams": ["Microsoft-Table-AppRequests"],
  "destinations": ["laDest"],
  "transformKql": "source | where isempty(SyntheticSource)"
}
```

</details>

<details>
<summary><b>Drop cancellation exceptions</b></summary>

Use this sample to drop common cancellation exception types.

```json
{
  "streams": ["Microsoft-Table-AppExceptions"],
  "destinations": ["laDest"],
  "transformKql": "source | where not(ExceptionType contains 'OperationCanceledException' or ExceptionType contains 'TaskCanceledException')"
}
```

</details>

<details>
<summary><b>Remove client IP addresses and query strings</b></summary>

Use this sample to remove client IP addresses and to store URLs without query strings.

```json
[
  {
    "streams": ["Microsoft-Table-AppRequests"],
    "destinations": ["laDest"],
    "transformKql": "source | extend Url = tostring(split(tostring(Url), '?')[0]) | project-away ClientIP"
  },
  {
    "streams": ["Microsoft-Table-AppDependencies"],
    "destinations": ["laDest"],
    "transformKql": "source | extend Data = tostring(split(tostring(Data), '?')[0]) | project-away ClientIP"
  }
]
```

</details>

<details>
<summary><b>Scope a transformation to a single service</b></summary>

Use this sample to filter a single service when multiple applications share a workspace. Keep telemetry from other services unchanged. Apply its `transformKql` to the `Microsoft-Table-AppRequests` flow in `properties.dataFlows`, preserving that flow's destination and any other filtering requirements.

```json
{
  "streams": ["Microsoft-Table-AppRequests"],
  "destinations": ["laDest"],
  "transformKql": "source | where AppRoleName != '<AppRoleName>' or Success == false or DurationMs >= 1000"
}
```

</details>

---

[!INCLUDE [Help, feedback, and support](includes/opentelemetry-help-feedback-support.md)]

[!INCLUDE [Next steps](includes/opentelemetry-next-steps.md)]
