---
title: Configuring OpenTelemetry in Application Insights
description: Learn how to configure OpenTelemetry (OTel) settings in Application Insights for .NET, Java, Node.js, and Python applications, including connection strings and sampling options.
ms.topic: how-to
ms.date: 12/10/2025
ms.devlang: csharp
# ms.devlang: csharp, javascript, typescript, python
ms.custom: devx-track-dotnet, devx-track-extended-java, devx-track-python

#customer intent: As a developer or site reliability engineer, I want to configure OpenTelemetry (OTel) settings in Application Insights so that I can standardize telemetry data collection and enhance observability for my .NET, Java, Node.js, or Python applications.

---

# Configure Azure Monitor OpenTelemetry

This guide explains how to configure OpenTelemetry (OTel) in [Azure Monitor Application Insights](app-insights-overview.md) using the Azure Monitor OpenTelemetry distro. Proper configuration ensures consistent telemetry data collection across .NET, Java, Node.js, and Python applications, allowing for more reliable monitoring and diagnostics.

> [!NOTE]
> [!INCLUDE [application-insights-functions-link](./includes/application-insights-functions-link.md)]

## Connection string

A connection string in Application Insights defines the target location for sending telemetry data.

### [ASP.NET Core](#tab/aspnetcore)

Use one of the following three ways to configure the connection string:

* Add `UseAzureMonitor()` to your `program.cs` file.

    ```csharp
        var builder = WebApplication.CreateBuilder(args);
    
        // Add the OpenTelemetry telemetry service to the application.
        // This service will collect and send telemetry data to Azure Monitor.
        builder.Services.AddOpenTelemetry().UseAzureMonitor(options => {
            options.ConnectionString = "<YOUR-CONNECTION-STRING>";
        });
    
        var app = builder.Build();
    
        app.Run();
    ```

* Set an environment variable.

    ```console
    APPLICATIONINSIGHTS_CONNECTION_STRING=<YOUR-CONNECTION-STRING>
    ```

* Add the following section to your `appsettings.json` config file.

    ```json
      {
        "AzureMonitor": {
            "ConnectionString": "<YOUR-CONNECTION-STRING>"
        }
      }
    ```

> [!NOTE]
> If you set the connection string in more than one place, we adhere to the following precedence:
> 1. Code
> 2. Environment Variable
> 3. Configuration File

### [.NET](#tab/net)

Use one of the following two ways to configure the connection string:

* Add the Azure Monitor Exporter to each OpenTelemetry signal in application startup.

    ```csharp
        // Create a new OpenTelemetry tracer provider.
        // It is important to keep the TracerProvider instance active throughout the process lifetime.
        var tracerProvider = Sdk.CreateTracerProviderBuilder()
            .AddAzureMonitorTraceExporter(options =>
            {
                options.ConnectionString = "<YOUR-CONNECTION-STRING>";
            })
            .Build();
    
        // Create a new OpenTelemetry meter provider.
        // It is important to keep the MetricsProvider instance active throughout the process lifetime.
        var metricsProvider = Sdk.CreateMeterProviderBuilder()
            .AddAzureMonitorMetricExporter(options =>
            {
                options.ConnectionString = "<YOUR-CONNECTION-STRING>";
            })
            .Build();
    
        // Create a new logger factory.
        // It is important to keep the LoggerFactory instance active throughout the process lifetime.
        var loggerFactory = LoggerFactory.Create(builder =>
        {
            builder.AddOpenTelemetry(logging =>
            {
                logging.AddAzureMonitorLogExporter(options =>
                {
                    options.ConnectionString = "<YOUR-CONNECTION-STRING>";
                });
            });
        });
    ```

* Set an environment variable.

    ```console
    APPLICATIONINSIGHTS_CONNECTION_STRING=<YOUR-CONNECTION-STRING>
    ```

> [!NOTE]
> If you set the connection string in more than one place, we adhere to the following precedence:
> 1. Code
> 2. Environment Variable

### [Java](#tab/java)

To set the connection string, see [Connection string](java-standalone-config.md#connection-string).

### [Java native](#tab/java-native)

Use one of the following two ways to configure the connection string:

* Set an environment variable.

    ```console
    APPLICATIONINSIGHTS_CONNECTION_STRING=<YOUR-CONNECTION-STRING>
    ```

* Set a property.

    ```properties
    applicationinsights.connection.string=<YOUR-CONNECTION-STRING>
    ```

### [Node.js](#tab/nodejs)

> [!TIP]
> * **TypeScript samples** for Azure Monitor OpenTelemetry (authoritative parity source): https://github.com/Azure/azure-sdk-for-js/tree/main/sdk/monitor/monitor-opentelemetry/samples-dev/src

Use one of the following two ways to configure the connection string:

* Set an environment variable.

    ```console
    APPLICATIONINSIGHTS_CONNECTION_STRING=<YOUR-CONNECTION-STRING>
    ```

* Use a configuration object.

    ```typescript
    export class BasicConnectionSample {
      static async run() {
        const { useAzureMonitor } = await import("@azure/monitor-opentelemetry");
        const options = {
          azureMonitorExporterOptions: {
            connectionString:
              process.env.APPLICATIONINSIGHTS_CONNECTION_STRING || "<YOUR-CONNECTION-STRING>",
          },
        };
        const monitor = useAzureMonitor(options);
        console.log("Azure Monitor initialized");
      }
    }
    ```

### [Python](#tab/python)

Use one of the following two ways to configure the connection string:

* Set an environment variable.

    ```console
    APPLICATIONINSIGHTS_CONNECTION_STRING=<YOUR-CONNECTION-STRING>
    ```

* Use the `configure_azure_monitor` function.

    ```python
    # Import the `configure_azure_monitor()` function from the `azure.monitor.opentelemetry` package.
    from azure.monitor.opentelemetry import configure_azure_monitor
    
    # Configure OpenTelemetry to use Azure Monitor with the specified connection string.
    # Replace `<YOUR-CONNECTION-STRING>` with the connection string of your Azure Monitor Application Insights resource.
    configure_azure_monitor(
        connection_string="<YOUR-CONNECTION-STRING>",
    )
    ```

---

## Set the Cloud Role Name and the Cloud Role Instance

For [supported languages](application-insights-faq.yml#what-s-the-current-release-state-of-features-within-the-azure-monitor-opentelemetry-distro), the Azure Monitor OpenTelemetry Distro automatically detects the resource context and provides default values for the [Cloud Role Name](app-map.md#understand-the-cloud-role-name-within-the-context-of-an-application-map) and the Cloud Role Instance properties of your component. However, you might want to override the default values to something that makes sense to your team. The cloud role name value appears on the Application Map as the name underneath a node.

### [ASP.NET Core](#tab/aspnetcore)

Set the Cloud Role Name and the Cloud Role Instance via [Resource](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/resource/sdk.md#resource-sdk) attributes. Cloud Role Name uses `service.namespace` and `service.name` attributes, although it falls back to `service.name` if `service.namespace` isn't set. Cloud Role Instance uses the `service.instance.id` attribute value. For information on standard attributes for resources, see [OpenTelemetry Semantic Conventions](https://github.com/open-telemetry/semantic-conventions/blob/main/docs/README.md).

```csharp
// Setting role name and role instance

// Create a dictionary of resource attributes.
var resourceAttributes = new Dictionary<string, object> {
    { "service.name", "my-service" },
    { "service.namespace", "my-namespace" },
    { "service.instance.id", "my-instance" }};

// Create a new ASP.NET Core web application builder.
var builder = WebApplication.CreateBuilder(args);

// Add the OpenTelemetry telemetry service to the application.
// This service will collect and send telemetry data to Azure Monitor.
builder.Services.AddOpenTelemetry()
    .UseAzureMonitor()
    // Configure the ResourceBuilder to add the custom resource attributes to all signals.
    // Custom resource attributes should be added AFTER AzureMonitor to override the default ResourceDetectors.
    .ConfigureResource(resourceBuilder => resourceBuilder.AddAttributes(resourceAttributes));

// Build the ASP.NET Core web application.
var app = builder.Build();

// Start the ASP.NET Core web application.
app.Run();
```

### [.NET](#tab/net)

Set the Cloud Role Name and the Cloud Role Instance via [Resource](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/resource/sdk.md#resource-sdk) attributes. Cloud Role Name uses `service.namespace` and `service.name` attributes, although it falls back to `service.name` if `service.namespace` isn't set. Cloud Role Instance uses the `service.instance.id` attribute value. For information on standard attributes for resources, see [OpenTelemetry Semantic Conventions](https://github.com/open-telemetry/semantic-conventions/blob/main/docs/README.md).

```csharp
// Setting role name and role instance

// Create a dictionary of resource attributes.
var resourceAttributes = new Dictionary<string, object> {
    { "service.name", "my-service" },
    { "service.namespace", "my-namespace" },
    { "service.instance.id", "my-instance" }};

// Create a resource builder.
var resourceBuilder = ResourceBuilder.CreateDefault().AddAttributes(resourceAttributes);

// Create a new OpenTelemetry tracer provider and set the resource builder.
// It is important to keep the TracerProvider instance active throughout the process lifetime.
var tracerProvider = Sdk.CreateTracerProviderBuilder()
    // Set ResourceBuilder on the TracerProvider.
    .SetResourceBuilder(resourceBuilder)
    .AddAzureMonitorTraceExporter()
    .Build();

// Create a new OpenTelemetry meter provider and set the resource builder.
// It is important to keep the MetricsProvider instance active throughout the process lifetime.
var metricsProvider = Sdk.CreateMeterProviderBuilder()
    // Set ResourceBuilder on the MeterProvider.
    .SetResourceBuilder(resourceBuilder)
    .AddAzureMonitorMetricExporter()
    .Build();

// Create a new logger factory and add the OpenTelemetry logger provider with the resource builder.
// It is important to keep the LoggerFactory instance active throughout the process lifetime.
var loggerFactory = LoggerFactory.Create(builder =>
{
    builder.AddOpenTelemetry(logging =>
    {
        // Set ResourceBuilder on the Logging config.
        logging.SetResourceBuilder(resourceBuilder);
        logging.AddAzureMonitorLogExporter();
    });
});
```

### [Java](#tab/java)

To set the cloud role name, see [cloud role name](java-standalone-config.md#cloud-role-name).

To set the cloud role instance, see [cloud role instance](java-standalone-config.md#cloud-role-instance).

### [Java native](#tab/java-native)

To set the cloud role name:

* Use the `spring.application.name` for Spring Boot native image applications.
* Use the `quarkus.application.name` for Quarkus native image applications.

[!INCLUDE [quarkus-support](./includes/quarkus-support.md)]

### [Node.js](#tab/nodejs)

Set the Cloud Role Name and the Cloud Role Instance via [Resource](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/resource/sdk.md#resource-sdk) attributes. Cloud Role Name uses `service.namespace` and `service.name` attributes, although it falls back to `service.name` if `service.namespace` isn't set. Cloud Role Instance uses the `service.instance.id` attribute value. For information on standard attributes for resources, see [OpenTelemetry Semantic Conventions](https://github.com/open-telemetry/semantic-conventions/blob/main/docs/README.md).

```typescript
export class CloudRoleSample {
  static async run() {
    const { useAzureMonitor } = await import("@azure/monitor-opentelemetry");
    const { resourceFromAttributes } = await import("@opentelemetry/resources");
    const { ATTR_SERVICE_NAME } = await import("@opentelemetry/semantic-conventions");
    const { ATTR_SERVICE_NAMESPACE, ATTR_SERVICE_INSTANCE_ID } =
      await import("@opentelemetry/semantic-conventions/incubating");

    const customResource = resourceFromAttributes({
      [ATTR_SERVICE_NAME]: process.env.OTEL_SERVICE_NAME || "my-service",
      [ATTR_SERVICE_NAMESPACE]: process.env.OTEL_SERVICE_NAMESPACE || "my-namespace",
      [ATTR_SERVICE_INSTANCE_ID]: process.env.OTEL_SERVICE_INSTANCE_ID || "my-instance",
    });

    const options = {
      resource: customResource,
      azureMonitorExporterOptions: {
        connectionString:
          process.env.APPLICATIONINSIGHTS_CONNECTION_STRING || "<YOUR-CONNECTION-STRING>",
      },
    };

    const monitor = useAzureMonitor(options);
    console.log("Azure Monitor initialized (custom resource)");
  }
}
```

### [Python](#tab/python)

Set the Cloud Role Name and the Cloud Role Instance via [Resource](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/resource/sdk.md#resource-sdk) attributes. Cloud Role Name uses `service.namespace` and `service.name` attributes, although it falls back to `service.name` if `service.namespace` isn't set. Cloud Role Instance uses the `service.instance.id` attribute value. For information on standard attributes for resources, see [OpenTelemetry Semantic Conventions](https://github.com/open-telemetry/semantic-conventions/blob/main/docs/README.md).

Set Resource attributes using the `OTEL_RESOURCE_ATTRIBUTES` and/or `OTEL_SERVICE_NAME` environment variables. `OTEL_RESOURCE_ATTRIBUTES` takes series of comma-separated key-value pairs. For example, to set the Cloud Role Name to `my-namespace.my-helloworld-service` and set Cloud Role Instance to `my-instance`, you can set `OTEL_RESOURCE_ATTRIBUTES` and `OTEL_SERVICE_NAME` as such:

```console
export OTEL_RESOURCE_ATTRIBUTES="service.namespace=my-namespace,service.instance.id=my-instance"
export OTEL_SERVICE_NAME="my-helloworld-service"
```

If you don't set the `service.namespace` Resource attribute, you can alternatively set the Cloud Role Name with only the OTEL_SERVICE_NAME environment variable or the `service.name` Resource attribute. For example, to set the Cloud Role Name to `my-helloworld-service` and set Cloud Role Instance to `my-instance`, you can set `OTEL_RESOURCE_ATTRIBUTES` and `OTEL_SERVICE_NAME` as such:

```console
export OTEL_RESOURCE_ATTRIBUTES="service.instance.id=my-instance"
export OTEL_SERVICE_NAME="my-helloworld-service"
```

---

## Enable Sampling

Sampling reduces telemetry ingestion volume and cost. Azure Monitor's OpenTelemetry distro supports two sampling strategies for traces and (optionally) lets you align application logs to your trace sampling decisions. The sampler attaches the selected sampling ratio or rate to exported spans so Application Insights can adjust experience counts accurately. For a conceptual overview, see [Learn more about sampling](sampling.md#brief-summary).

> [!IMPORTANT]
> * Sampling decisions apply to **traces** (spans).
> * **Logs** that belong to unsampled traces are dropped by default, but you can opt out of [trace-based sampling for logs](#configure-tracebased-sampling-for-logs).
> * **Metrics** are never sampled.

> [!NOTE]
> If you're seeing unexpected charges or high costs in Application Insights, common causes include high telemetry volume, data ingestion spikes, and misconfigured sampling. To start troubleshooting, see [Troubleshoot high data ingestion in Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-high-data-ingestion).

### Configure sampling using environment variables


Use standard OpenTelemetry environment variables to select the sampler and provide its argument. For more information about OpenTelemetry sampler types, see [OTEL_TRACES_SAMPLER](https://opentelemetry.io/docs/languages/sdk-configuration/general/#otel_traces_sampler).
#### [ASP.NET Core](#tab/aspnetcore)

* **`OTEL_TRACES_SAMPLER`** — sampler type
    * `microsoft.fixed_percentage` — sample a fraction of traces.
    * `microsoft.rate_limited` — cap traces per second.

* **`OTEL_TRACES_SAMPLER_ARG`** — sampler argument
    * For `microsoft.fixed_percentage`: value in **0.0–1.0** (for example, `0.1` = ~10%).
    * For `microsoft.rate_limited`: **maximum traces per second** (for example, `1.5`).

#### [.NET](#tab/net)

* **`OTEL_TRACES_SAMPLER`** — sampler type
    * `microsoft.fixed_percentage` — sample a fraction of traces.
    * `microsoft.rate_limited` — cap traces per second.

* **`OTEL_TRACES_SAMPLER_ARG`** — sampler argument
    * For `microsoft.fixed_percentage`: value in **0.0–1.0** (for example, `0.1` = ~10%).
    * For `microsoft.rate_limited`: **maximum traces per second** (for example, `1.5`).

#### [Java](#tab/java)

* **`APPLICATIONINSIGHTS_SAMPLING_PERCENTAGE`**: A value between 0-100

* **`APPLICATIONINSIGHTS_SAMPLING_REQUESTS_PER_SECOND`**: Max traces per second

#### [Java native](#tab/java-native)

* **`OTEL_TRACES_SAMPLER`** — sampler type
    * `always_on`: AlwaysOnSampler
    * `always_off`: AlwaysOffSampler
    * `trace_id_ratio`: TraceIdRatioBased
    * `parentbased_always_on`: ParentBased(root=AlwaysOnSampler)
    * `parentbased_always_off`: ParentBased(root=AlwaysOffSampler)
    * `parentbased_trace_id_ratio`: ParentBased(root=TraceIdRatioBased)

* **`OTEL_TRACES_SAMPLER_ARG`** — sampler argument
    * For `always_on`: the default value is **1.0**. No need to set the argument.
    * For `always_off`: the default value is **0.0**. No need to set the argument.
    * For `trace_id_ratio`: a value in **0.0–1.0** (for example, 0.25 = ~25%). Default is 1.0 if unset.
    * For `parentbased_always_on`: the default value is **1.0**. No need to set the argument.
    * For `parentbased_always_off`: the default value is **0.0**. No need to set the argument.
    * For `parentbased_trace_id_ratio`: a value in **0.0–1.0** (for example, 0.45 = ~45%). Default is 1.0 if unset.

#### [Node](#tab/nodejs)

* **`OTEL_TRACES_SAMPLER`** — sampler type
    * `microsoft.fixed_percentage` — sample a fraction of traces.
    * `microsoft.rate_limited` — cap traces per second.
    * `always_on`: AlwaysOnSampler
    * `always_off`: AlwaysOffSampler
    * `trace_id_ratio`: TraceIdRatioBased
    * `parentbased_always_on`: ParentBased(root=AlwaysOnSampler)
    * `parentbased_always_off`: ParentBased(root=AlwaysOffSampler)
    * `parentbased_trace_id_ratio`: ParentBased(root=TraceIdRatioBased)

* **`OTEL_TRACES_SAMPLER_ARG`** — sampler argument
    * For `microsoft.fixed_percentage`: value in **0.0–1.0** (for example, `0.1` = ~10%).
    * For `microsoft.rate_limited`: **maximum traces per second** (for example, `1.5`).
    * For `always_on`: the default value is **1.0**. No need to set the argument.
    * For `always_off`: the default value is **0.0**. No need to set the argument.
    * For `trace_id_ratio`: a value in **0.0–1.0** (for example, 0.25 = ~25%). Default is 1.0 if unset.
    * For `parentbased_always_on`: the default value is **1.0**. No need to set the argument.
    * For `parentbased_always_off`: the default value is **0.0**. No need to set the argument.
    * For `parentbased_trace_id_ratio`: a value in **0.0–1.0** (for example, 0.45 = ~45%). Default is 1.0 if unset.

#### [Python](#tab/python)

* **`OTEL_TRACES_SAMPLER`** — sampler type
    * `microsoft.fixed_percentage` — sample a fraction of traces.
    * `microsoft.rate_limited` — cap traces per second.
    * `always_on`: AlwaysOnSampler
    * `always_off`: AlwaysOffSampler
    * `trace_id_ratio`: TraceIdRatioBased
    * `parentbased_always_on`: ParentBased(root=AlwaysOnSampler)
    * `parentbased_always_off`: ParentBased(root=AlwaysOffSampler)
    * `parentbased_trace_id_ratio`: ParentBased(root=TraceIdRatioBased)

* **`OTEL_TRACES_SAMPLER_ARG`** — sampler argument
    * For `microsoft.fixed_percentage`: value in **0.0–1.0** (for example, `0.1` = ~10%).
    * For `microsoft.rate_limited`: **maximum traces per second** (for example, `1.5`).
    * For `always_on`: the default value is **1.0**. No need to set the argument.
    * For `always_off`: the default value is **0.0**. No need to set the argument.
    * For `trace_id_ratio`: a value in **0.0–1.0** (for example, 0.25 = ~25%). Default is 1.0 if unset.
    * For `parentbased_always_on`: the default value is **1.0**. No need to set the argument.
    * For `parentbased_always_off`: the default value is **0.0**. No need to set the argument.
    * For `parentbased_trace_id_ratio`: a value in **0.0–1.0** (for example, 0.45 = ~45%). Default is 1.0 if unset.

---

The following examples show how to configure sampling using environment variables.

**Fixed-percentage sampling (~10%)**

```console
export OTEL_TRACES_SAMPLER="microsoft.fixed_percentage"
export OTEL_TRACES_SAMPLER_ARG=0.1
```

**Rate-limited sampling (~1.5 traces/sec)**

```console
export OTEL_TRACES_SAMPLER="microsoft.rate_limited"
export OTEL_TRACES_SAMPLER_ARG=1.5
```

### Configure sampling in code

> [!NOTE]
> When both code-level options and environment variables are configured, **environment variables take precedence**. Default sampler behavior can differ by language.

# [ASP.NET Core](#tab/aspnetcore)

#### Fixed percentage sampling

```csharp
var builder = WebApplication.CreateBuilder(args);
builder.Services.AddOpenTelemetry().UseAzureMonitor(o =>
{
    o.SamplingRatio = 0.1F; // ~10%
});
var app = builder.Build();
app.Run();
```

#### Rate-limited sampling

```csharp
var builder = WebApplication.CreateBuilder(args);
builder.Services.AddOpenTelemetry().UseAzureMonitor(o =>
{
    o.TracesPerSecond = 1.5; // ~1.5 traces/sec
});
var app = builder.Build();
app.Run();
```

> [!NOTE]
> If you don't set a sampler in code or through environment variables, Azure Monitor uses **ApplicationInsightsSampler** by default.

# [.NET](#tab/net)

#### Fixed percentage sampling

```csharp
var tracerProvider = Sdk.CreateTracerProviderBuilder()
    .AddAzureMonitorTraceExporter(o => o.SamplingRatio = 0.1F)
    .Build();
```

#### Rate-limited sampling

```csharp
var tracerProvider = Sdk.CreateTracerProviderBuilder()
    .AddAzureMonitorTraceExporter(o => o.TracesPerSecond = 1.5F)
    .Build();
```

> [!NOTE]
> If you don't set a sampler in code or through environment variables, Azure Monitor uses **ApplicationInsightsSampler** by default.

# [Java](#tab/java)

Starting from 3.4.0, **rate‑limited sampling is the default**. For configuration options and examples, see [Java sampling](java-standalone-config.md#sampling).

# [Java native](#tab/java-native)

For Spring Boot native applications, the [sampling configurations of the OpenTelemetry Java SDK are applicable](https://opentelemetry.io/docs/languages/java/configuration/#sampler).

For Quarkus native applications, configure sampling using the [Quarkus OpenTelemetry guide](https://quarkus.io/guides/opentelemetry#sampler), then use the [Quarkus OpenTelemetry Exporter](https://docs.quarkiverse.io/quarkus-opentelemetry-exporter/dev/quarkus-opentelemetry-exporter-azure.html) to send telemetry to Application Insights.

[!INCLUDE [quarkus-support](./includes/quarkus-support.md)]

# [Node.js](#tab/nodejs)

#### Fixed percentage sampling

```typescript
const { useAzureMonitor } = await import("@azure/monitor-opentelemetry");
const monitor = useAzureMonitor({
  samplingRatio: 0.1, // ~10%
  azureMonitorExporterOptions: {
    connectionString:
      process.env.APPLICATIONINSIGHTS_CONNECTION_STRING || "<YOUR-CONNECTION-STRING>",
  },
});
```

#### Rate-limited sampling

```typescript
const { useAzureMonitor } = await import("@azure/monitor-opentelemetry");
const monitor = useAzureMonitor({
  tracesPerSecond: 1.5, // ~1.5 traces/sec
  azureMonitorExporterOptions: {
    connectionString:
      process.env.APPLICATIONINSIGHTS_CONNECTION_STRING || "<YOUR-CONNECTION-STRING>",
  },
});
```

> [!NOTE]
> If you don't set a sampler in code or through environment variables, Azure Monitor uses **ApplicationInsightsSampler** by default.

# [Python](#tab/python)

#### Fixed percentage sampling

```python
from azure.monitor.opentelemetry import configure_azure_monitor

configure_azure_monitor(
    connection_string="<YOUR-CONNECTION-STRING>",
    sampling_ratio=0.1, # 0.1 = 10% of traces sampled
)
```

#### Rate-limited sampling

```python
from azure.monitor.opentelemetry import configure_azure_monitor

configure_azure_monitor(
    connection_string="<YOUR-CONNECTION-STRING>",
    traces_per_second=1.5, # ~1.5 traces/sec
)
```

> [!NOTE]
> If you don't set any environment variables or provide either `sampling_ratio` or `traces_per_second`, `configure_azure_monitor()` uses **ApplicationInsightsSampler** by default.

---

> [!TIP]
> When using fixed‑percentage sampling and you aren't sure what to set the sampling rate as, start at **5%** (`0.05`). Adjust the rate based on the accuracy of the operations shown in the failures and performance panes. Any sampling reduces accuracy, so we recommend alerting on [OpenTelemetry metrics](opentelemetry-add-modify.md#add-custom-metrics), which are unaffected by sampling.

### Configure trace‑based sampling for logs

When enabled, log records that belong to **unsampled traces** are dropped so that your logs remain aligned with trace sampling.

* A log record is considered part of a trace when it has a valid `SpanId`.
* If the associated trace's `TraceFlags` indicate **not sampled**, the log record is **dropped**.
* Log records **without** any trace context **aren't** affected.
* The feature is **enabled by default**.

Use the following settings to configure trace-based log sampling:

# [ASP.NET Core](#tab/aspnetcore)

```csharp
builder.Services.AddOpenTelemetry().UseAzureMonitor(o =>
{
    o.EnableTraceBasedLogsSampler = true;
});
```

# [.NET](#tab/net)

```csharp
var tracerProvider = Sdk.CreateTracerProviderBuilder()
    .AddAzureMonitorTraceExporter(o => o.EnableTraceBasedLogsSampler = true)
    .Build();
```

# [Java](#tab/java)

For Java applications, trace-based sampling is enabled by default.

# [Java native](#tab/java-native)

For Spring Boot native and Quarkus native applications, trace-based sampling is enabled by default.

[!INCLUDE [quarkus-support](./includes/quarkus-support.md)]

# [Node.js](#tab/nodejs)

```typescript
const { useAzureMonitor } = await import("@azure/monitor-opentelemetry");
const monitor = useAzureMonitor({
  enableTraceBasedSamplingForLogs: true,
  azureMonitorExporterOptions: {
    connectionString:
      process.env.APPLICATIONINSIGHTS_CONNECTION_STRING || "<YOUR-CONNECTION-STRING>",
  },
});
```

# [Python](#tab/python)

```python
from azure.monitor.opentelemetry import configure_azure_monitor

configure_azure_monitor(
    connection_string="<YOUR-CONNECTION-STRING>",
    enable_trace_based_sampling_for_logs=True,
)
```

---

## Live metrics

[Live metrics](live-stream.md) provides a real-time analytics dashboard for insight into application activity and performance.

### [ASP.NET Core](#tab/aspnetcore)

> [!IMPORTANT]
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

This feature is enabled by default.

Users can disable Live Metrics when configuring the Distro.

```csharp
builder.Services.AddOpenTelemetry().UseAzureMonitor(options => {
	// Disable the Live Metrics feature.
    options.EnableLiveMetrics = false;
});
```

### [.NET](#tab/net)

This feature isn't available in the Azure Monitor .NET Exporter.

> [!NOTE]
> We recommend the [Azure Monitor OpenTelemetry Exporter](https://www.nuget.org/packages/Azure.Monitor.OpenTelemetry.Exporter) for console and worker service applications, which doesn't include live metrics.

### [Java](#tab/java)

The Live Metrics experience is enabled by default.

For more information on Java configuration, see [Configuration options: Azure Monitor Application Insights for Java](java-standalone-config.md#configuration-options-azure-monitor-application-insights-for-java).

### [Java native](#tab/java-native)

The Live Metrics aren't available today for GraalVM native applications.

### [Node.js](#tab/nodejs)

> [!IMPORTANT]
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

Users can enable/disable Live Metrics when configuring the Distro using the `enableLiveMetrics` property.

```typescript
export class LiveMetricsSample {
  static async run() {
    const { useAzureMonitor } = await import("@azure/monitor-opentelemetry");
    const options = {
      azureMonitorExporterOptions: {
        connectionString:
          process.env.APPLICATIONINSIGHTS_CONNECTION_STRING || "<YOUR-CONNECTION-STRING>",
      },
      enableLiveMetrics: true, // set to false to disable
    };
    const monitor = useAzureMonitor(options);
    console.log("Azure Monitor initialized (live metrics enabled)");
  }
}
```

<!--

TODO:

This feature is/isn't enabled by default.

Functionality and customization are covered in the following configuration sample.

```typescript
Configuration sample

```

-->

### [Python](#tab/python)

> [!IMPORTANT]
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

You can enable live metrics using the Azure monitor OpenTelemetry Distro for Python as follows:

```python
...
configure_azure_monitor(
	enable_live_metrics=True
)
...
```

---

## Enable Microsoft Entra ID (formerly Azure AD) authentication

You might want to enable Microsoft Entra authentication for a more secure connection to Azure, which prevents unauthorized telemetry from being ingested into your subscription.

For more information, see our dedicated Microsoft Entra authentication page linked for each supported language.

### [ASP.NET Core](#tab/aspnetcore)

For information on configuring Entra ID authentication, see [Microsoft Entra authentication for Application Insights](azure-ad-authentication.md?tabs=aspnetcore)

### [.NET](#tab/net)

For information on configuring Entra ID authentication, see [Microsoft Entra authentication for Application Insights](azure-ad-authentication.md?tabs=net)

### [Java](#tab/java)

For information on configuring Entra ID authentication, see [Microsoft Entra authentication for Application Insights](azure-ad-authentication.md?tabs=java)

### [Java native](#tab/java-native)

Microsoft Entra ID authentication isn't available for GraalVM Native applications.

### [Node.js](#tab/nodejs)

For information on configuring Entra ID authentication, see [Microsoft Entra authentication for Application Insights](azure-ad-authentication.md?tabs=nodejs)

### [Python](#tab/python)

For information on configuring Entra ID authentication, see [Microsoft Entra authentication for Application Insights](azure-ad-authentication.md?tabs=python)

---

## Offline Storage and Automatic Retries

Azure Monitor OpenTelemetry-based offerings cache telemetry when an application disconnects from Application Insights and retries sending for up to 48 hours. For data handling recommendations, see [Export and delete private data](../logs/personal-data-mgmt.md#export-delete-or-purge-personal-data). High-load applications occasionally drop telemetry for two reasons: exceeding the allowable time or exceeding the maximum file size. When necessary, the product prioritizes recent events over old ones.

### [ASP.NET Core](#tab/aspnetcore)

The Distro package includes the AzureMonitorExporter, which by default uses one of the following locations for offline storage (listed in order of precedence):

* Windows
    * %LOCALAPPDATA%\Microsoft\AzureMonitor
    * %TEMP%\Microsoft\AzureMonitor

* Non-Windows
    * %TMPDIR%/Microsoft/AzureMonitor
    * /var/tmp/Microsoft/AzureMonitor
    * /tmp/Microsoft/AzureMonitor

To override the default directory, you should set `AzureMonitorOptions.StorageDirectory`.

```csharp
// Create a new ASP.NET Core web application builder.
var builder = WebApplication.CreateBuilder(args);

// Add the OpenTelemetry telemetry service to the application.
// This service will collect and send telemetry data to Azure Monitor.
builder.Services.AddOpenTelemetry().UseAzureMonitor(options =>
{
    // Set the Azure Monitor storage directory to "C:\\SomeDirectory".
    // This is the directory where the OpenTelemetry SDK will store any telemetry data that can't be sent to Azure Monitor immediately.
    options.StorageDirectory = "C:\\SomeDirectory";
});

// Build the ASP.NET Core web application.
var app = builder.Build();

// Start the ASP.NET Core web application.
app.Run();
```

To disable this feature, you should set `AzureMonitorOptions.DisableOfflineStorage = true`.

### [.NET](#tab/net)

By default, the AzureMonitorExporter uses one of the following locations for offline storage (listed in order of precedence):

* Windows
    * %LOCALAPPDATA%\Microsoft\AzureMonitor
    * %TEMP%\Microsoft\AzureMonitor

* Non-Windows
    * %TMPDIR%/Microsoft/AzureMonitor
    * /var/tmp/Microsoft/AzureMonitor
    * /tmp/Microsoft/AzureMonitor

To override the default directory, you should set `AzureMonitorExporterOptions.StorageDirectory`.

```csharp
// Create a new OpenTelemetry tracer provider and set the storage directory.
// It is important to keep the TracerProvider instance active throughout the process lifetime.
var tracerProvider = Sdk.CreateTracerProviderBuilder()
    .AddAzureMonitorTraceExporter(options =>
    {
        // Set the Azure Monitor storage directory to "C:\\SomeDirectory".
        // This is the directory where the OpenTelemetry SDK will store any trace data that can't be sent to Azure Monitor immediately.
        options.StorageDirectory = "C:\\SomeDirectory";
        })
        .Build();

// Create a new OpenTelemetry meter provider and set the storage directory.
// It is important to keep the MetricsProvider instance active throughout the process lifetime.
var metricsProvider = Sdk.CreateMeterProviderBuilder()
    .AddAzureMonitorMetricExporter(options =>
    {
        // Set the Azure Monitor storage directory to "C:\\SomeDirectory".
        // This is the directory where the OpenTelemetry SDK will store any metric data that can't be sent to Azure Monitor immediately.
        options.StorageDirectory = "C:\\SomeDirectory";
        })
        .Build();

// Create a new logger factory and add the OpenTelemetry logger provider with the storage directory.
// It is important to keep the LoggerFactory instance active throughout the process lifetime.
var loggerFactory = LoggerFactory.Create(builder =>
{
    builder.AddOpenTelemetry(logging =>
    {
        logging.AddAzureMonitorLogExporter(options =>
        {
            // Set the Azure Monitor storage directory to "C:\\SomeDirectory".
            // This is the directory where the OpenTelemetry SDK will store any log data that can't be sent to Azure Monitor immediately.
            options.StorageDirectory = "C:\\SomeDirectory";
        });
    });
});
```

To disable this feature, you should set `AzureMonitorExporterOptions.DisableOfflineStorage = true`.

### [Java](#tab/java)

When the agent can't send telemetry to Azure Monitor, it stores telemetry files on disk. The files are saved in a `telemetry` folder under the directory specified by the `java.io.tmpdir` system property. Each file name starts with a timestamp and ends with the `.trn` extension. This offline storage mechanism helps ensure telemetry is retained during temporary network outages or ingestion failures.

The agent stores up to 50 MB of telemetry data by default and allows [configuration of the storage limit](./java-standalone-config.md#recovery-from-ingestion-failures). Attempts to send stored telemetry are made periodically. Telemetry files older than 48 hours are deleted and the oldest events are discarded when the storage limit is reached.

For a full list of available configurations, see [Configuration options](./java-standalone-config.md).

### [Java native](#tab/java-native)

When the agent can't send telemetry to Azure Monitor, it stores telemetry files on disk. The files are saved in a `telemetry` folder under the directory specified by the `java.io.tmpdir` system property. Each file name starts with a timestamp and ends with the `.trn` extension. This offline storage mechanism helps ensure telemetry is retained during temporary network outages or ingestion failures.

The agent stores up to 50 MB of telemetry data by default. Attempts to send stored telemetry are made periodically. Telemetry files older than 48 hours are deleted and the oldest events are discarded when the storage limit is reached.

### [Node.js](#tab/nodejs)

By default, the AzureMonitorExporter uses one of the following locations for offline storage.

- Windows
  - %TEMP%\Microsoft-AzureMonitor-`<unique-identifier>`\opentelemetry-nodejs-`<your-instrumentation-key>`
- Non-Windows
  - %TMPDIR%/Microsoft/Microsoft-AzureMonitor-`<unique-identifier>`/opentelemetry-nodejs-`<your-instrumentation-key>`
  - /var/tmp/Microsoft/Microsoft-AzureMonitor-`<unique-identifier>`/opentelemetry-nodejs-`<your-instrumentation-key>`

The `<unique-identifier>` is a hash created from user environment attributes like instrumentation key, process name, username, and application directory. This identifier solves a common multi-user system problem: when the first user creates the storage directory, their file permissions (umask settings) might block other users from accessing the same path. A unique directory for each user context ensures every user gets their own storage location with proper access permissions.

To override the default directory, you should set `storageDirectory`.

For example:

```typescript
export class OfflineStorageSample {
  static async run() {
    const { useAzureMonitor } = await import("@azure/monitor-opentelemetry");
    const options = {
      azureMonitorExporterOptions: {
        connectionString:
          process.env.APPLICATIONINSIGHTS_CONNECTION_STRING || "<YOUR-CONNECTION-STRING>",
        storageDirectory: "C:\\\\SomeDirectory",
        disableOfflineStorage: false, // set to true to disable
      },
    };
    const monitor = useAzureMonitor(options);
    console.log("Azure Monitor initialized (offline storage configured)");
  }
}
```

To disable this feature, you should set `disableOfflineStorage = true`.

### [Python](#tab/python)

By default, Azure Monitor exporters use the following path:

`<tempfile.gettempdir()>/Microsoft-AzureMonitor-<unique-identifier>/opentelemetry-python-<your-instrumentation-key>`

The `<unique-identifier>` is a hash created from user environment attributes like instrumentation key, process name, username, and application directory. This identifier solves a common multi-user system problem: when the first user creates the storage directory, their file permissions (umask settings) might block other users from accessing the same path. A unique directory for each user context ensures every user gets their own storage location with proper access permissions.

To override the default directory, you should set `storage_directory` to the directory you want.

For example:

```python
...
# Configure OpenTelemetry to use Azure Monitor with the specified connection string and storage directory.
# Replace `<YOUR-CONNECTION-STRING>` with the connection string to your Azure Monitor Application Insights resource.
# Replace `C:\\SomeDirectory` with the directory where you want to store the telemetry data before it is sent to Azure Monitor.
configure_azure_monitor(
    connection_string="<YOUR-CONNECTION-STRING>",
    storage_directory="C:\\SomeDirectory",
)
...
```

To disable this feature, you should set `disable_offline_storage` to `True`. Defaults to `False`.

For example:
```python
...
# Configure OpenTelemetry to use Azure Monitor with the specified connection string and disable offline storage.
# Replace `<YOUR-CONNECTION-STRING>` with the connection string to your Azure Monitor Application Insights resource.
configure_azure_monitor(
    connection_string="<YOUR-CONNECTION-STRING>",
    disable_offline_storage=True,
)
...
```

---

## Enable the OTLP Exporter

You might want to enable the OpenTelemetry Protocol (OTLP) Exporter alongside the Azure Monitor Exporter to send your telemetry to two locations.

> [!NOTE]
> The OTLP Exporter is shown for convenience only. We don't officially support the OTLP Exporter or any components or third-party experiences downstream of it.

### [ASP.NET Core](#tab/aspnetcore)

1. Install the [OpenTelemetry.Exporter.OpenTelemetryProtocol](https://www.nuget.org/packages/OpenTelemetry.Exporter.OpenTelemetryProtocol/) package in your project.

    ```dotnetcli
    dotnet add package OpenTelemetry.Exporter.OpenTelemetryProtocol
    ```

1. Add the following code snippet. This example assumes you have an OpenTelemetry Collector with an OTLP receiver running. For details, see the [example on GitHub](https://github.com/open-telemetry/opentelemetry-dotnet/blob/main/examples/Console/TestOtlpExporter.cs).

    ```csharp
    // Create a new ASP.NET Core web application builder.
    var builder = WebApplication.CreateBuilder(args);
    
    // Add the OpenTelemetry telemetry service to the application.
    // This service will collect and send telemetry data to Azure Monitor.
    builder.Services.AddOpenTelemetry().UseAzureMonitor();
    
    // Add the OpenTelemetry OTLP exporter to the application.
    // This exporter will send telemetry data to an OTLP receiver, such as Prometheus
    builder.Services.AddOpenTelemetry().WithTracing(builder => builder.AddOtlpExporter());
    builder.Services.AddOpenTelemetry().WithMetrics(builder => builder.AddOtlpExporter());
    
    // Build the ASP.NET Core web application.
    var app = builder.Build();
    
    // Start the ASP.NET Core web application.
    app.Run();
    ```

### [.NET](#tab/net)

1. Install the [OpenTelemetry.Exporter.OpenTelemetryProtocol](https://www.nuget.org/packages/OpenTelemetry.Exporter.OpenTelemetryProtocol/) package in your project.

    ```dotnetcli
    dotnet add package OpenTelemetry.Exporter.OpenTelemetryProtocol
    ```

1. Add the following code snippet. This example assumes you have an OpenTelemetry Collector with an OTLP receiver running. For details, see the [example on GitHub](https://github.com/open-telemetry/opentelemetry-dotnet/blob/main/examples/Console/TestOtlpExporter.cs).

    ```csharp
        // Create a new OpenTelemetry tracer provider and add the Azure Monitor trace exporter and the OTLP trace exporter.
        // It is important to keep the TracerProvider instance active throughout the process lifetime.
        var tracerProvider = Sdk.CreateTracerProviderBuilder()
            .AddAzureMonitorTraceExporter()
            .AddOtlpExporter()
            .Build();
    
        // Create a new OpenTelemetry meter provider and add the Azure Monitor metric exporter and the OTLP metric exporter.
        // It is important to keep the MetricsProvider instance active throughout the process lifetime.
        var metricsProvider = Sdk.CreateMeterProviderBuilder()
            .AddAzureMonitorMetricExporter()
            .AddOtlpExporter()
            .Build();
    ```

### [Java](#tab/java)

The Application Insights Java Agent doesn't support OTLP.
For more information about supported configurations, see the [Java supplemental documentation](java-standalone-config.md).

### [Java native](#tab/java-native)

You can't enable the OpenTelemetry Protocol (OTLP) Exporter alongside the Azure Monitor Exporter to send your telemetry to two locations.

### [Node.js](#tab/nodejs)

1. Install the [OpenTelemetry Collector Trace Exporter](https://www.npmjs.com/package/@opentelemetry/exporter-trace-otlp-http) and other OpenTelemetry packages in your project.

    ```console
    npm install @opentelemetry/api
    npm install @opentelemetry/exporter-trace-otlp-http
    npm install @opentelemetry/sdk-trace-base
    npm install @opentelemetry/sdk-trace-node
    ```

1. Add the following code snippet. This example assumes you have an OpenTelemetry Collector with an OTLP receiver running. For details, see the [example on GitHub](https://github.com/open-telemetry/opentelemetry-js/tree/main/examples/otlp-exporter-node).

    ```typescript
    export class OtlpExporterSample {
      static async run() {
        const { useAzureMonitor } = await import("@azure/monitor-opentelemetry");
        const { BatchSpanProcessor } = await import("@opentelemetry/sdk-trace-base");
        const { OTLPTraceExporter } = await import("@opentelemetry/exporter-trace-otlp-http");
    
        // Create an OTLP trace exporter (set 'url' if your collector isn't on the default endpoint).
        const otlpExporter = new OTLPTraceExporter({
          // url: "http://localhost:4318/v1/traces",
        });
    
        // Configure Azure Monitor and add the OTLP exporter as an additional span processor.
        const options = {
          azureMonitorExporterOptions: {
            connectionString:
              process.env.APPLICATIONINSIGHTS_CONNECTION_STRING || "<YOUR-CONNECTION-STRING>",
          },
          spanProcessors: [new BatchSpanProcessor(otlpExporter)],
        };
    
        const monitor = useAzureMonitor(options);
        console.log("Azure Monitor initialized (OTLP exporter added)");
      }
    }
    ```

### [Python](#tab/python)

1. Install the [opentelemetry-exporter-otlp](https://pypi.org/project/opentelemetry-exporter-otlp/) package.

1. Add the following code snippet. This example assumes you have an OpenTelemetry Collector with an OTLP receiver running. For details, see this [README](https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/monitor/azure-monitor-opentelemetry-exporter/samples/traces#collector).

    ```python
        # Import the `configure_azure_monitor()`, `trace`, `OTLPSpanExporter`, and `BatchSpanProcessor` classes from the appropriate packages.
        from azure.monitor.opentelemetry import configure_azure_monitor
        from opentelemetry import trace
        from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
        from opentelemetry.sdk.trace.export import BatchSpanProcessor
    
        # Configure OpenTelemetry to use Azure Monitor with the specified connection string.
        # Replace `<YOUR-CONNECTION-STRING>` with the connection string to your Azure Monitor Application Insights resource.
        configure_azure_monitor(
            connection_string="<YOUR-CONNECTION-STRING>",
        )
        
        # Get the tracer for the current module.
        tracer = trace.get_tracer(__name__) 
        
        # Create an OTLP span exporter that sends spans to the specified endpoint.
        # Replace `http://localhost:4317` with the endpoint of your OTLP collector.
        otlp_exporter = OTLPSpanExporter(endpoint="http://localhost:4317")
        
        # Create a batch span processor that uses the OTLP span exporter.
        span_processor = BatchSpanProcessor(otlp_exporter)
        
        # Add the batch span processor to the tracer provider.
        trace.get_tracer_provider().add_span_processor(span_processor)
        
        # Start a new span with the name "test".
        with tracer.start_as_current_span("test"):
            print("Hello world!")
    ```

---

## OpenTelemetry configurations

The following OpenTelemetry configurations can be accessed through environment variables while using the Azure Monitor OpenTelemetry Distros.

### [ASP.NET Core](#tab/aspnetcore)

| Environment variable | Description |
|----------------------|-------------|
| `APPLICATIONINSIGHTS_CONNECTION_STRING` | Set it to the connection string for your Application Insights resource. |
| `APPLICATIONINSIGHTS_STATSBEAT_DISABLED` | Set it to `true` to opt out of internal metrics collection. |
| `OTEL_RESOURCE_ATTRIBUTES` | Key-value pairs to be used as resource attributes. For more information about resource attributes, see the [Resource SDK specification](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.5.0/specification/resource/sdk.md#specifying-resource-information-via-an-environment-variable). |
| `OTEL_SERVICE_NAME` | Sets the value of the `service.name` resource attribute. If `service.name` is also provided in `OTEL_RESOURCE_ATTRIBUTES`, then `OTEL_SERVICE_NAME` takes precedence. |

### [.NET](#tab/net)

| Environment variable | Description |
|----------------------|-------------|
| `APPLICATIONINSIGHTS_CONNECTION_STRING` | Set it to the connection string for your Application Insights resource. |
| `APPLICATIONINSIGHTS_STATSBEAT_DISABLED` | Set it to `true` to opt out of internal metrics collection. |
| `OTEL_RESOURCE_ATTRIBUTES` | Key-value pairs to be used as resource attributes. For more information about resource attributes, see the [Resource SDK specification](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.5.0/specification/resource/sdk.md#specifying-resource-information-via-an-environment-variable). |
| `OTEL_SERVICE_NAME` | Sets the value of the `service.name` resource attribute. If `service.name` is also provided in `OTEL_RESOURCE_ATTRIBUTES`, then `OTEL_SERVICE_NAME` takes precedence. |

### [Java](#tab/java)

For more information about Java, see the [Java supplemental documentation](java-standalone-config.md).

### [Java native](#tab/java-native)

| Environment variable | Description |
|----------------------|-------------|
| `APPLICATIONINSIGHTS_CONNECTION_STRING` | Set it to the connection string for your Application Insights resource. |

For Spring Boot native applications, the [OpenTelemetry Java SDK configurations](https://opentelemetry.io/docs/languages/java/configuration/) are available.

For Quarkus native applications, review the [Quarkus OpenTelemetry documentation](https://quarkus.io/guides/opentelemetry#configuration).

[!INCLUDE [quarkus-support](./includes/quarkus-support.md)]

### [Node.js](#tab/nodejs)

For more information about OpenTelemetry SDK configuration, see the [OpenTelemetry documentation](https://opentelemetry.io/docs/concepts/sdk-configuration). 

### [Python](#tab/python)

For more information about OpenTelemetry SDK configuration, see the [OpenTelemetry documentation](https://opentelemetry.io/docs/concepts/sdk-configuration) and [Azure monitor Distro Usage](https://github.com/Azure/azure-sdk-for-python/blob/main/sdk/monitor/azure-monitor-opentelemetry/README.md#usage).

---

## Redact URL Query Strings

To redact URL query strings, turn off query string collection. We recommend this setting if you call Azure storage using a SAS token.

### [ASP.NET Core](#tab/aspnetcore)

When you're using the [Azure.Monitor.OpenTelemetry.AspNetCore](https://www.nuget.org/packages/Azure.Monitor.OpenTelemetry.AspNetCore) distro package, both the [ASP.NET Core](https://www.nuget.org/packages/OpenTelemetry.Instrumentation.AspNetCore/) and [HttpClient](https://www.nuget.org/packages/OpenTelemetry.Instrumentation.Http/) Instrumentation libraries are included. 
Our distro package sets Query String Redaction off by default.

To change this behavior, you must set an environment variable to either `true` or `false`.

* ASP.NET Core Instrumentation: `OTEL_DOTNET_EXPERIMENTAL_ASPNETCORE_DISABLE_URL_QUERY_REDACTION`
    Query String Redaction is disabled by default. To enable, set this environment variable to `false`.

* Http Client Instrumentation: `OTEL_DOTNET_EXPERIMENTAL_HTTPCLIENT_DISABLE_URL_QUERY_REDACTION`
    Query String Redaction is disabled by default. To enable, set this environment variable to `false`.

### [.NET](#tab/net)

When using the [Azure.Monitor.OpenTelemetry.Exporter](https://www.nuget.org/packages/Azure.Monitor.OpenTelemetry.Exporter), you must manually include either the [ASP.NET Core](https://www.nuget.org/packages/OpenTelemetry.Instrumentation.AspNetCore/) or [HttpClient](https://www.nuget.org/packages/OpenTelemetry.Instrumentation.Http/) Instrumentation libraries in your OpenTelemetry configuration.
These Instrumentation libraries have QueryString Redaction enabled by default.

To change this behavior, you must set an environment variable to either `true` or `false`.

* ASP.NET Core Instrumentation: `OTEL_DOTNET_EXPERIMENTAL_ASPNETCORE_DISABLE_URL_QUERY_REDACTION`
    Query String Redaction is enabled by default. To disable, set this environment variable to `true`.

* Http Client Instrumentation: `OTEL_DOTNET_EXPERIMENTAL_HTTPCLIENT_DISABLE_URL_QUERY_REDACTION`
    Query String Redaction is enabled by default. To disable, set this environment variable to `true`.

### [Java](#tab/java)

Add the following to the `applicationinsights.json` configuration file:

```json
{
  "preview": {
    "processors": [
      {
        "type": "attribute",
        "actions": [
          {
            "key": "url.query",
            "pattern": "^.*$",
            "replace": "REDACTED",
            "action": "mask"
          }
        ]
      },
      {
        "type": "attribute",
        "actions": [
          {
            "key": "url.full",
            "pattern": "[?].*$",
            "replace": "?REDACTED",
            "action": "mask"
          }
        ]
      }
    ]
  }
}
```

### [Java native](#tab/java-native)

We're actively working in the OpenTelemetry community to support redaction.

### [Node.js](#tab/nodejs)

When you're using the [Azure Monitor OpenTelemetry distro](https://github.com/Azure/azure-sdk-for-js/tree/main/sdk/monitor/monitor-opentelemetry) package, query strings can be redacted via creating and applying a span processor to the distro configuration.

```typescript
export class RedactQueryStringsSample {
  static async run() {
    const { useAzureMonitor } = await import("@azure/monitor-opentelemetry");
    const { SEMATTRS_HTTP_ROUTE, SEMATTRS_HTTP_TARGET, SEMATTRS_HTTP_URL } =
      await import("@opentelemetry/semantic-conventions");

    class RedactQueryStringProcessor {
      forceFlush() { return Promise.resolve(); }
      onStart() {}
      shutdown() { return Promise.resolve(); }
      onEnd(span: any) {
        const route = String(span.attributes[SEMATTRS_HTTP_ROUTE] ?? "");
        const url = String(span.attributes[SEMATTRS_HTTP_URL] ?? "");
        const target = String(span.attributes[SEMATTRS_HTTP_TARGET] ?? "");

        const strip = (s: string) => {
          const i = s.indexOf("?");
          return i === -1 ? s : s.substring(0, i);
        };

        if (route) span.attributes[SEMATTRS_HTTP_ROUTE] = strip(route);
        if (url) span.attributes[SEMATTRS_HTTP_URL] = strip(url);
        if (target) span.attributes[SEMATTRS_HTTP_TARGET] = strip(target);
      }
    }

    const options = {
      azureMonitorExporterOptions: {
        connectionString:
          process.env.APPLICATIONINSIGHTS_CONNECTION_STRING || "<YOUR-CONNECTION-STRING>",
      },
      spanProcessors: [new RedactQueryStringProcessor()],
    };

    const monitor = useAzureMonitor(options);
    console.log("Azure Monitor initialized (query strings redacted)");
  }
}
```

### [Python](#tab/python)

We're actively working in the OpenTelemetry community to support redaction.

---

## Metric export interval

You can configure the metric export interval using the `OTEL_METRIC_EXPORT_INTERVAL` environment variable.

```shell
OTEL_METRIC_EXPORT_INTERVAL=60000
```

The default value is `60000` milliseconds (60 seconds). This setting controls how often the OpenTelemetry SDK exports metrics.

[!INCLUDE [application-insights-metrics-interval](includes/application-insights-metrics-interval.md)]

For reference, see the following OpenTelemetry specifications:

* [Environment variable definitions](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/configuration/sdk-environment-variables.md#periodic-exporting-metricreader)
* [Periodic exporting metric reader](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/metrics/sdk.md#periodic-exporting-metricreader)
