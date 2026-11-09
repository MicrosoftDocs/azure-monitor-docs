---
title: Configure OpenTelemetry in Application Insights
description: Learn how to configure OpenTelemetry (OTel) settings in Application Insights for .NET, Java, Node.js, and Python applications, including connection strings and sampling options.
ms.topic: how-to
ms.date: 09/11/2026
ai-usage: ai-assisted
ms.devlang: csharp
# ms.devlang: csharp, javascript, typescript, python
ms.custom:
    - devx-track-dotnet, devx-track-extended-java, devx-track-python
    - sfi-ropc-nochange
    - cbo-v1.6

#customer intent: As a developer or site reliability engineer, I want to configure OpenTelemetry (OTel) settings in Application Insights so that I can standardize telemetry data collection and enhance observability for my .NET, Java, Node.js, or Python applications.

---

# Configure OpenTelemetry in Application Insights

[!INCLUDE [Choose an OpenTelemetry onboarding path](includes/opentelemetry-onboarding-paths.md)]

This guide explains how to configure OpenTelemetry (OTel) in [Azure Monitor Application Insights](app-insights-overview.md). For .NET, Node.js, and Python, use the Microsoft OpenTelemetry Distro. For Java, use the Azure Monitor OpenTelemetry Distro and its existing agent or native-image integrations.

First, [enable OpenTelemetry](opentelemetry-enable.md) for your language.

[!INCLUDE [Microsoft OpenTelemetry Distro packages](~/reusable-content/ce-skilling/azure/includes/azure-monitor/microsoft-opentelemetry-distro/microsoft-opentelemetry-packages.md)]

Don't initialize the Microsoft OpenTelemetry Distro and Azure Monitor OpenTelemetry Distro together. Azure Monitor remains the telemetry destination; standalone Azure Monitor exporters retain their existing names.

The .NET examples use `Microsoft.OpenTelemetry` and OpenTelemetry namespaces. Initialize Node.js instrumentation before application libraries load. ESM applications must preload the [Microsoft OpenTelemetry Distro loader](https://github.com/microsoft/opentelemetry-distro-javascript#esm-support). Set `APPLICATIONINSIGHTS_CONNECTION_STRING` before starting the application unless an example sets the connection string in code.

> [!NOTE]
> [!INCLUDE [application-insights-functions-link](./includes/application-insights-functions-link.md)]

## Connection string

In Application Insights, a connection string defines the target location for sending telemetry data.

# [ASP.NET Core](#tab/aspnetcore)

Use one of the following three ways to configure the connection string:

* Configure `UseMicrosoftOpenTelemetry()` in `Program.cs`.

    ```csharp
    // Import the Microsoft OpenTelemetry Distro and supporting APIs.
    using Microsoft.OpenTelemetry;

    // Create the application builder.
    var builder = WebApplication.CreateBuilder(args);

    // Configure the Microsoft OpenTelemetry Distro.
    builder.UseMicrosoftOpenTelemetry(options =>
    {
      options.Exporters = ExportTarget.AzureMonitor;

      // Set the connection string for Azure Monitor export.
      options.AzureMonitor.ConnectionString = "<ConnectionString>";
    });

    // Build the application with the configured telemetry services.
    var app = builder.Build();

    // Run the application and its telemetry providers.
    app.Run();
    ```

* Set an environment variable.

    ```bash
    export APPLICATIONINSIGHTS_CONNECTION_STRING="<ConnectionString>"
    ```

* Add the following section to `appsettings.json`, and then read it when initializing the distro.

    ```json
        {
            "AzureMonitor": {
                "ConnectionString": "<ConnectionString>"
            }
        }
    ```

    ```csharp
    // Import the Microsoft OpenTelemetry Distro and supporting APIs.
    using Microsoft.OpenTelemetry;

    // Create the application builder.
    var builder = WebApplication.CreateBuilder(args);

    // Configure the Microsoft OpenTelemetry Distro.
    builder.UseMicrosoftOpenTelemetry(options =>
    {
      options.Exporters = ExportTarget.AzureMonitor;

      // Read the environment setting before the application configuration.
      options.AzureMonitor.ConnectionString =
        builder.Configuration["APPLICATIONINSIGHTS_CONNECTION_STRING"] ??
        builder.Configuration["AzureMonitor:ConnectionString"];
    });

    // Build the application with the configured telemetry services.
    var app = builder.Build();

    // Run the application and its telemetry providers.
    app.Run();
    ```

> [!NOTE]
> An explicit `options.AzureMonitor.ConnectionString` value takes precedence. The configuration-file example checks the environment-variable key before the `AzureMonitor` section. Reading the section explicitly avoids relying on implicit configuration binding.

# [.NET](#tab/net)

Use one of the following two methods to configure the connection string:

* Configure the Microsoft OpenTelemetry Distro for all signals in application startup:

    ```csharp
    // Import the Microsoft OpenTelemetry Distro and supporting APIs.
    using Microsoft.OpenTelemetry;
    using OpenTelemetry;

    // Create the SDK and keep its providers alive until application shutdown.
    using var sdk = OpenTelemetrySdk.Create(telemetry =>
    {
      // Configure the Microsoft OpenTelemetry Distro.
      telemetry.UseMicrosoftOpenTelemetry(options =>
          {
        options.Exporters = ExportTarget.AzureMonitor;

        // Set the connection string for Azure Monitor export.
        options.AzureMonitor.ConnectionString = "<ConnectionString>";
          });
    });
    ```

  Keep `sdk` alive for the application lifetime. Dispose it only at shutdown to flush pending telemetry.

* Set an environment variable.

    ```bash
    export APPLICATIONINSIGHTS_CONNECTION_STRING="<ConnectionString>"
    ```

> [!NOTE]
> If you set the connection string in more than one place, the following precedence order applies:
> 1. Code
> 1. Environment variable


# [Java](#tab/java)

Use one of the following three ways to configure the connection string:

* Add the following section to your *applicationinsights.json* config file.

    ```json
        {
            "connectionString": "<ConnectionString>"
        }
    ```

    You can also set the connection string by specifying a file to load it from. *The file should contain only the connection string and nothing else.* If you specify a relative path, it resolves relative to the directory where `applicationinsights-agent-3.7.9.jar` is located.

    ```json
        {
            "connectionString": "${file:connection-string-file.txt}"
        }
    ```

* Set an environment variable.

    `APPLICATIONINSIGHTS_CONNECTION_STRING`


* Add `applicationinsights.connection.string` as a system property.

    ```bash
    java -javaagent:"<AgentDirectory>/applicationinsights-agent-3.7.9.jar" \
     -Dapplicationinsights.connection.string="<ConnectionString>" \
        -jar "<AppJarPath>"
    ```

> [!NOTE]
> If you set the connection string in more than one place, the following precedence order applies:
> 1. System property
> 1. Environment variable
> 1. Configuration file

If you deploy multiple applications in the same Java Virtual Machine (JVM) and want them to send telemetry to different connection strings, see [Connection string overrides (preview)](java-standalone-config.md#connection-string-overrides-preview).

# [Java native](#tab/java-native)

Use one of the following two ways to configure the connection string:

* Set an environment variable.

    ```bash
    export APPLICATIONINSIGHTS_CONNECTION_STRING="<ConnectionString>"
    ```

* For Spring Boot, set the property in `application.properties`.

    ```properties
    applicationinsights.connection.string=<ConnectionString>
    ```

# [Node.js](#tab/nodejs)

> [!TIP]
> For Microsoft OpenTelemetry Distro configuration examples, see the [Node.js samples](https://github.com/microsoft/opentelemetry-distro-javascript/tree/main/samples/src).

Use one of the following two ways to configure the connection string:

* Set an environment variable.

    ```bash
    export APPLICATIONINSIGHTS_CONNECTION_STRING="<ConnectionString>"
    ```

* Use a configuration object.

    ```typescript
    export class BasicConnectionSample {
        static async run() {
            // Import the Microsoft OpenTelemetry Distro.
            const { useMicrosoftOpenTelemetry } = await import("@microsoft/opentelemetry");

            // Configure Azure Monitor export and the options used by this sample.
            const options = {
                azureMonitor: {
                    azureMonitorExporterOptions: {
                        connectionString:
                            process.env.APPLICATIONINSIGHTS_CONNECTION_STRING ||
                            "<ConnectionString>",
                    },
                },
            };

            // Initialize the Microsoft OpenTelemetry Distro.
            const monitor = useMicrosoftOpenTelemetry(options);
            console.log("Azure Monitor initialized");
        }
    }
    ```

# [Python](#tab/python)

Use one of the following two ways to configure the connection string:

* Set an environment variable.

    ```bash
    export APPLICATIONINSIGHTS_CONNECTION_STRING="<ConnectionString>"
    ```

* Use the `use_microsoft_opentelemetry` function and enable Azure Monitor export.

    ```python
    # Import the `use_microsoft_opentelemetry()` function from the
    # `microsoft.opentelemetry` package.
    from microsoft.opentelemetry import use_microsoft_opentelemetry

    # Configure OpenTelemetry to use Azure Monitor with the specified connection string.
    use_microsoft_opentelemetry(
        enable_azure_monitor=True,
        azure_monitor_connection_string="<ConnectionString>",
    )
    ```

---

## Set the Cloud Role Name and the Cloud Role Instance

The Microsoft OpenTelemetry Distro for .NET, Node.js, and Python, and Azure Monitor OpenTelemetry for Java, detect resource context where supported and provide default values for the [Cloud Role Name](app-map.md#understand-cloud-role-names-and-nodes) and Cloud Role Instance. You can override those values for your application. The cloud role name appears on the Application Map as the name under a node.

# [ASP.NET Core](#tab/aspnetcore)

Set the Cloud Role Name and the Cloud Role Instance through [Resource](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/resource/sdk.md#resource-sdk) attributes. Cloud Role Name uses `service.namespace` and `service.name` attributes, but it falls back to `service.name` if `service.namespace` isn't set. Cloud Role Instance uses the `service.instance.id` attribute value. For information on standard attributes for resources, see [OpenTelemetry Semantic Conventions](https://github.com/open-telemetry/semantic-conventions/blob/main/docs/README.md).

<details>
<summary>Set the Cloud Role Name and the Cloud Role Instance</summary>

```csharp
// Import the Microsoft OpenTelemetry Distro and supporting APIs.
using Microsoft.OpenTelemetry;
using OpenTelemetry;
using OpenTelemetry.Resources;

// Define the service attributes used for cloud role name and instance.
var resourceAttributes = new Dictionary<string, object>
{
    ["service.name"] = "<ServiceName>",
    ["service.namespace"] = "<ServiceNamespace>",
    ["service.instance.id"] = "<ServiceInstanceId>"
};

// Create the application builder.
var builder = WebApplication.CreateBuilder(args);

builder.Services.AddOpenTelemetry()

  // Configure the Microsoft OpenTelemetry Distro.
  .UseMicrosoftOpenTelemetry(options =>
  {
    options.Exporters = ExportTarget.AzureMonitor;
  })

    // Apply the resource attributes to traces, metrics, and logs.
    .ConfigureResource(resourceBuilder => resourceBuilder.AddAttributes(
        resourceAttributes));

// Build the application with the configured telemetry services.
var app = builder.Build();

// Run the application and its telemetry providers.
app.Run();
```

</details>

# [.NET](#tab/net)

Set the Cloud Role Name and the Cloud Role Instance through [Resource](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/resource/sdk.md#resource-sdk) attributes. Cloud Role Name uses `service.namespace` and `service.name` attributes, but it falls back to `service.name` if `service.namespace` isn't set. Cloud Role Instance uses the `service.instance.id` attribute value. For information on standard attributes for resources, see [OpenTelemetry Semantic Conventions](https://github.com/open-telemetry/semantic-conventions/blob/main/docs/README.md).


```csharp
// Import the Microsoft OpenTelemetry Distro and supporting APIs.
using Microsoft.OpenTelemetry;
using OpenTelemetry;
using OpenTelemetry.Resources;

// Define the service attributes used for cloud role name and instance.
var resourceAttributes = new Dictionary<string, object>
{
    ["service.name"] = "<ServiceName>",
    ["service.namespace"] = "<ServiceNamespace>",
    ["service.instance.id"] = "<ServiceInstanceId>"
};

// Create the SDK and keep its providers alive until application shutdown.
using var sdk = OpenTelemetrySdk.Create(telemetry =>
{
  // Configure the Microsoft OpenTelemetry Distro.
  telemetry.UseMicrosoftOpenTelemetry(options =>
    options.Exporters = ExportTarget.AzureMonitor)

    // Apply the resource attributes to traces, metrics, and logs.
    .ConfigureResource(resourceBuilder =>
      resourceBuilder.AddAttributes(resourceAttributes));
});
```

# [Java](#tab/java)

> [!NOTE]
> If you don't set the cloud role name and cloud role instance, the cloud role name defaults to the name of your Application Insights resource, and the cloud role instance defaults to the machine name.

Use one of the following three ways to configure the cloud role name and cloud role instance:

* Add the following section to your *applicationinsights.json* config file.

    Set `role.name` to the cloud role name and `role.instance` to the cloud role instance:

    ```json
        {
            "role": {
                "name": "<CloudRoleName>",
                "instance": "<CloudRoleInstance>"
            }
        }
    ```

* Set environment variables.

    `APPLICATIONINSIGHTS_ROLE_NAME`
    `APPLICATIONINSIGHTS_ROLE_INSTANCE`

* Add `applicationinsights.role.name` and `applicationinsights.role.instance` as system properties.

    ```bash
    java -javaagent:"<AgentDirectory>/applicationinsights-agent-3.7.9.jar" \
        -Dapplicationinsights.role.name="<CloudRoleName>" \
        -Dapplicationinsights.role.instance="<CloudRoleInstance>" \
        -jar "<AppJarPath>"
    ```

> [!NOTE]
> If you set the cloud role name and cloud role instance in more than one place, the following precedence order applies:
> 1. System property
> 1. Environment variable
> 1. Configuration file

If you deploy multiple applications in the same JVM and want them to send telemetry to different cloud role names, see [Cloud role name overrides (preview)](java-standalone-config.md#cloud-role-name-overrides-preview).

# [Java native](#tab/java-native)

To set the cloud role name:

* Use the `spring.application.name` for Spring Boot native image applications.
* Use the `quarkus.application.name` for Quarkus native image applications.

[!INCLUDE [quarkus-support](./includes/quarkus-support.md)]

# [Node.js](#tab/nodejs)

Set the Cloud Role Name and the Cloud Role Instance through [Resource](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/resource/sdk.md#resource-sdk) attributes. Cloud Role Name uses `service.namespace` and `service.name` attributes, but it falls back to `service.name` if `service.namespace` isn't set. Cloud Role Instance uses the `service.instance.id` attribute value. For information on standard attributes for resources, see [OpenTelemetry Semantic Conventions](https://github.com/open-telemetry/semantic-conventions/blob/main/docs/README.md).

<details>
<summary>Set the Cloud Role Name and the Cloud Role Instance</summary>

```typescript
export class CloudRoleSample {
    static async run() {
        // Import the Microsoft OpenTelemetry Distro.
        const { useMicrosoftOpenTelemetry } = await import("@microsoft/opentelemetry");
        const { resourceFromAttributes } = await import("@opentelemetry/resources");
        const { ATTR_SERVICE_NAME } = await import("@opentelemetry/semantic-conventions");
        const { ATTR_SERVICE_NAMESPACE, ATTR_SERVICE_INSTANCE_ID } = await import(
            "@opentelemetry/semantic-conventions/incubating"
        );

        // Set the service attributes used for cloud role name and instance.
        const customResource = resourceFromAttributes({
            [ATTR_SERVICE_NAME]: process.env.OTEL_SERVICE_NAME || "<ServiceName>",
            [ATTR_SERVICE_NAMESPACE]:
                process.env.OTEL_SERVICE_NAMESPACE || "<ServiceNamespace>",
            [ATTR_SERVICE_INSTANCE_ID]:
                process.env.OTEL_SERVICE_INSTANCE_ID || "<ServiceInstanceId>",
        });

        // Configure Azure Monitor export and the options used by this sample.
        const options = {
            azureMonitor: {
                azureMonitorExporterOptions: {
                    connectionString:
                        process.env.APPLICATIONINSIGHTS_CONNECTION_STRING ||
                        "<ConnectionString>",
                },
            },
            resource: customResource,
        };

        // Initialize the Microsoft OpenTelemetry Distro.
        const monitor = useMicrosoftOpenTelemetry(options);
        console.log("Azure Monitor initialized (custom resource)");
    }
}
```

</details>

# [Python](#tab/python)

Set the Cloud Role Name and the Cloud Role Instance via [Resource](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/resource/sdk.md#resource-sdk) attributes. Cloud Role Name uses `service.namespace` and `service.name` attributes, although it falls back to `service.name` if `service.namespace` isn't set. Cloud Role Instance uses the `service.instance.id` attribute value. For information on standard attributes for resources, see [OpenTelemetry Semantic Conventions](https://github.com/open-telemetry/semantic-conventions/blob/main/docs/README.md).

Set Resource attributes using the `OTEL_RESOURCE_ATTRIBUTES` and/or `OTEL_SERVICE_NAME` environment variables. `OTEL_RESOURCE_ATTRIBUTES` takes a series of comma-separated key-value pairs. You can combine the service namespace and service name to set the Cloud Role Name, and use the service instance ID to set the Cloud Role Instance:

```bash
serviceName="<ServiceName>"
serviceNamespace="<ServiceNamespace>"
serviceInstanceId="<ServiceInstanceId>"

resourceAttributes="service.namespace=$serviceNamespace"
resourceAttributes+=",service.instance.id=$serviceInstanceId"
export OTEL_RESOURCE_ATTRIBUTES="$resourceAttributes"
export OTEL_SERVICE_NAME="$serviceName"
```

If you don't set the `service.namespace` Resource attribute, you can alternatively set the Cloud Role Name with only the `OTEL_SERVICE_NAME` environment variable or the `service.name` Resource attribute:

```bash
export OTEL_RESOURCE_ATTRIBUTES="service.instance.id=<ServiceInstanceId>"
export OTEL_SERVICE_NAME="<ServiceName>"
```

---

## Set resource attributes

The Microsoft OpenTelemetry Distro for .NET, Node.js, and Python, and Azure Monitor OpenTelemetry for Java, enable resource detection in supported Azure environments. For more information, see [Automatic data collection and resource detectors](opentelemetry-collect-detect.md#resource-detectors).

For manual setups, set resource attributes directly by using standard OpenTelemetry options:

```bash
# Set variables
serviceName="<ServiceName>"
location="<Location>"
subscriptionId="<SubscriptionId>"
resourceGroupName="<ResourceGroupName>"
appName="<AppName>"

# Build App Service resource ID
path="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
provider="/providers/Microsoft.Web/sites/$appName"
resourceId="$path$provider"

resourceAttributes="cloud.provider=azure,cloud.region=$location"
resourceAttributes+=",cloud.resource_id=$resourceId"
export OTEL_SERVICE_NAME="$serviceName"
export OTEL_RESOURCE_ATTRIBUTES="$resourceAttributes"
```

On Windows PowerShell:

```powershell
# Set variables
$serviceName = "<ServiceName>"
$location = "<Location>"
$subscriptionId = "<SubscriptionId>"
$resourceGroupName = "<ResourceGroupName>"
$appName = "<AppName>"

# Build App Service resource ID
$path = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
$provider = "/providers/Microsoft.Web/sites/$appName"
$resourceId = "$path$provider"

$resourceAttributes = "cloud.provider=azure,cloud.region=$location"
$resourceAttributes += ",cloud.resource_id=$resourceId"
$env:OTEL_SERVICE_NAME = $serviceName
$env:OTEL_RESOURCE_ATTRIBUTES = $resourceAttributes
```

## Enable sampling

Sampling reduces telemetry ingestion volume and cost. The distros support fixed-percentage and rate-limited sampling for Azure Monitor export. You can also align application logs with trace sampling decisions. The sampler attaches sampling information to exported spans so Application Insights can adjust experience counts. For a conceptual overview, see [Learn more about sampling](opentelemetry-sampling.md#why-sampling-matters).

> [!IMPORTANT]
> * Sampling decisions apply to **traces** (spans).
> * **Logs** can follow trace sampling decisions. This behavior is enabled by default in the Microsoft OpenTelemetry Distro for .NET and disabled by default in the Node.js and Python versions of the Microsoft OpenTelemetry Distro. See [trace-based sampling for logs](#configure-trace-based-sampling-for-logs).
> * **Metrics** are never sampled.

> [!NOTE]
> If you see unexpected charges or high costs in Application Insights, common causes include high telemetry volume, data ingestion spikes, and misconfigured sampling. To start troubleshooting, see [Troubleshoot high data ingestion in Application Insights](/troubleshoot/azure/azure-monitor/app-insights/telemetry/troubleshoot-high-data-ingestion).

### Configure sampling by using environment variables

Use standard OpenTelemetry environment variables to select the sampler and provide its argument where your distro reads them. Choose one configuration method; you don't need to configure the same sampling settings in both code and environment variables. Follow the version-specific guidance in the .NET tabs. For more information about sampler names, see [OTEL_TRACES_SAMPLER](https://opentelemetry.io/docs/languages/sdk-configuration/general/#otel_traces_sampler).

# [ASP.NET Core](#tab/aspnetcore)

For `Microsoft.OpenTelemetry` 1.1.0, use the [code examples](#configure-sampling-in-code) to set sampling in `UseMicrosoftOpenTelemetry()`. You don't also need to set `OTEL_TRACES_SAMPLER` or `OTEL_TRACES_SAMPLER_ARG`.

# [.NET](#tab/net)

For `Microsoft.OpenTelemetry` 1.1.0, use the [code examples](#configure-sampling-in-code) inside `OpenTelemetrySdk.Create()`. Configure sampling through the distro options once; you don't also need to set sampler environment variables.

# [Java](#tab/java)

> [!NOTE]
> * Starting with Java agent version 3.4.0, rate-limited sampling is available and is now the default.
>
> * Sampling only applies to logs inside of a request. Logs that aren't inside of a request (for example, startup logs) are always collected by default. If you want to sample those logs, use [sampling overrides](java-standalone-config.md#configure-sampling-overrides).

**Fixed-percentage sampling**

* **`APPLICATIONINSIGHTS_SAMPLING_PERCENTAGE`** — sampling percentage
    * Value is a percentage (for example, `33.333` = ~33.333%).

**Rate-limited sampling**

* **`APPLICATIONINSIGHTS_SAMPLING_REQUESTS_PER_SECOND`** — maximum requests per second
    * For example, `1.5`.

For configuration options and examples, see [Configure sampling overrides](java-standalone-config.md#configure-sampling-overrides).

# [Java native](#tab/java-native)

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

# [Node](#tab/nodejs)

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

# [Python](#tab/python)

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

The following examples set the sampling environment variables for Node.js and Python. For the .NET version covered in the preceding tabs, use [code-based configuration](#configure-sampling-in-code) instead.

> [!NOTE]
> The following examples aren't valid for Java. For the correct environment variables, see the previous Java tab.

**Fixed-percentage sampling (~10%)**

```bash
export OTEL_TRACES_SAMPLER="microsoft.fixed_percentage"
export OTEL_TRACES_SAMPLER_ARG=0.1
```

**Rate-limited sampling (~1.5 traces/sec)**

```bash
export OTEL_TRACES_SAMPLER="microsoft.rate_limited"
export OTEL_TRACES_SAMPLER_ARG=1.5
```

### Configure sampling in code

> [!NOTE]
> Sampler configuration and precedence depend on the language. The .NET examples set distro options explicitly. Python uses the sampler environment variables. For Node.js, avoid conflicting settings in code and the environment.

# [ASP.NET Core](#tab/aspnetcore)

#### Fixed percentage sampling

```csharp
// Import the Microsoft OpenTelemetry Distro and supporting APIs.
using Microsoft.OpenTelemetry;

// Create the application builder.
var builder = WebApplication.CreateBuilder(args);

// Configure the Microsoft OpenTelemetry Distro.
builder.UseMicrosoftOpenTelemetry(options =>
{
  options.Exporters = ExportTarget.AzureMonitor;

  // Select fixed-percentage sampling instead of rate-limited sampling.
  options.AzureMonitor.TracesPerSecond = null;

  // Keep approximately 10% of traces.
  options.AzureMonitor.SamplingRatio = 0.1F;
});

// Build the application with the configured telemetry services.
var app = builder.Build();

// Run the application and its telemetry providers.
app.Run();
```

#### Rate-limited sampling

```csharp
// Import the Microsoft OpenTelemetry Distro and supporting APIs.
using Microsoft.OpenTelemetry;

// Create the application builder.
var builder = WebApplication.CreateBuilder(args);

// Configure the Microsoft OpenTelemetry Distro.
builder.UseMicrosoftOpenTelemetry(options =>
{
  options.Exporters = ExportTarget.AzureMonitor;

  // Limit sampling to approximately 1.5 traces per second.
  options.AzureMonitor.TracesPerSecond = 1.5;
});

// Build the application with the configured telemetry services.
var app = builder.Build();

// Run the application and its telemetry providers.
app.Run();
```

> [!NOTE]
> The Microsoft OpenTelemetry Distro for .NET defaults to rate-limited sampling at five traces per second. Set `TracesPerSecond` to `null` when selecting fixed-percentage sampling in code.

# [.NET](#tab/net)

#### Fixed percentage sampling

```csharp
// Import the Microsoft OpenTelemetry Distro and supporting APIs.
using Microsoft.OpenTelemetry;
using OpenTelemetry;

// Create the SDK and keep its providers alive until application shutdown.
using var sdk = OpenTelemetrySdk.Create(telemetry =>
{
  // Configure the Microsoft OpenTelemetry Distro.
  telemetry.UseMicrosoftOpenTelemetry(options =>
  {
    options.Exporters = ExportTarget.AzureMonitor;

    // Select fixed-percentage sampling instead of rate-limited sampling.
    options.AzureMonitor.TracesPerSecond = null;

    // Keep approximately 10% of traces.
    options.AzureMonitor.SamplingRatio = 0.1F;
  });
});
```

#### Rate-limited sampling

```csharp
// Import the Microsoft OpenTelemetry Distro and supporting APIs.
using Microsoft.OpenTelemetry;
using OpenTelemetry;

// Create the SDK and keep its providers alive until application shutdown.
using var sdk = OpenTelemetrySdk.Create(telemetry =>
{
  // Configure the Microsoft OpenTelemetry Distro.
  telemetry.UseMicrosoftOpenTelemetry(options =>
  {
    options.Exporters = ExportTarget.AzureMonitor;

    // Limit sampling to approximately 1.5 traces per second.
    options.AzureMonitor.TracesPerSecond = 1.5;
  });
});
```

> [!NOTE]
> The Microsoft OpenTelemetry Distro for .NET defaults to rate-limited sampling at five traces per second. Keep the SDK alive for the application lifetime.

# [Java](#tab/java)

For Java, you can't configure sampling in code.

# [Java native](#tab/java-native)

For Spring Boot native applications, the [sampling configurations of the OpenTelemetry Java SDK are applicable](https://opentelemetry.io/docs/languages/java/configuration/#sampler).

For Quarkus native applications, configure sampling using the [Quarkus OpenTelemetry guide](https://quarkus.io/guides/opentelemetry#sampler), then use the [Quarkus OpenTelemetry Exporter](https://docs.quarkiverse.io/quarkus-opentelemetry-exporter/dev/quarkus-opentelemetry-exporter-azure.html) to send telemetry to Application Insights.

[!INCLUDE [quarkus-support](./includes/quarkus-support.md)]

# [Node.js](#tab/nodejs)

The Microsoft OpenTelemetry Distro for Node.js defaults to rate-limited sampling at five traces per second. Set `tracesPerSecond: 0` to use `samplingRatio` instead.

#### Fixed percentage sampling

```typescript
// Import the Microsoft OpenTelemetry Distro.
const { useMicrosoftOpenTelemetry } = await import("@microsoft/opentelemetry");

// Initialize the Microsoft OpenTelemetry Distro.
const monitor = useMicrosoftOpenTelemetry({
    azureMonitor: {
        azureMonitorExporterOptions: {
            connectionString:
                process.env.APPLICATIONINSIGHTS_CONNECTION_STRING || "<ConnectionString>",
        },
    },

    // Keep approximately 10% of traces.
    samplingRatio: 0.1,

    // Use the sampling ratio instead of a rate limit.
    tracesPerSecond: 0,
});
```

#### Rate-limited sampling

```typescript
// Import the Microsoft OpenTelemetry Distro.
const { useMicrosoftOpenTelemetry } = await import("@microsoft/opentelemetry");

// Initialize the Microsoft OpenTelemetry Distro.
const monitor = useMicrosoftOpenTelemetry({
    azureMonitor: {
        azureMonitorExporterOptions: {
            connectionString:
                process.env.APPLICATIONINSIGHTS_CONNECTION_STRING || "<ConnectionString>",
        },
    },

    // Limit sampling to approximately 1.5 traces per second.
    tracesPerSecond: 1.5,
});
```

> [!NOTE]
> If you don't set a sampler in code or through environment variables, Azure Monitor uses **RateLimitedSampler** by default.

# [Python](#tab/python)

The Microsoft OpenTelemetry Distro for Python defaults to rate-limited sampling at five traces per second. Configure the sampler through environment variables before initializing the distro.

#### Fixed percentage sampling

```python
import os
from microsoft.opentelemetry import use_microsoft_opentelemetry

# Select the sampler before initializing the distro.
os.environ["OTEL_TRACES_SAMPLER"] = "microsoft.fixed_percentage"

# Keep approximately 10% of traces.
os.environ["OTEL_TRACES_SAMPLER_ARG"] = "0.1"

# Initialize the Microsoft OpenTelemetry Distro with Azure Monitor export.
use_microsoft_opentelemetry(
    enable_azure_monitor=True,
    azure_monitor_connection_string="<ConnectionString>",
)
```

#### Rate-limited sampling

```python
import os
from microsoft.opentelemetry import use_microsoft_opentelemetry

# Select the sampler before initializing the distro.
os.environ["OTEL_TRACES_SAMPLER"] = "microsoft.rate_limited"

# Limit sampling to approximately 1.5 traces per second.
os.environ["OTEL_TRACES_SAMPLER_ARG"] = "1.5"

# Initialize the Microsoft OpenTelemetry Distro with Azure Monitor export.
use_microsoft_opentelemetry(
    enable_azure_monitor=True,
    azure_monitor_connection_string="<ConnectionString>",
)
```

> [!NOTE]
> Use `OTEL_TRACES_SAMPLER` and `OTEL_TRACES_SAMPLER_ARG` for Python sampling. Don't carry over the older Azure Monitor distro's `sampling_ratio` and `traces_per_second` arguments.

---

> [!TIP]
> When using fixed-percentage sampling and you're not sure what value to set for the sampling rate, start at **5%** (`0.05`). Adjust the rate based on the accuracy of the operations shown in the failures and performance panes. Any sampling reduces accuracy, so alert on [OpenTelemetry metrics](opentelemetry-add-modify.md#add-custom-metrics), which are unaffected by sampling.

### Configure sampling in the configuration file

# [ASP.NET Core](#tab/aspnetcore)

Read your sampling settings from `builder.Configuration` and assign them to `options.AzureMonitor.SamplingRatio` or `options.AzureMonitor.TracesPerSecond` when initializing the Microsoft OpenTelemetry Distro. If you select percentage sampling, also set `TracesPerSecond = null`. Validate ratios from 0 through 1 and nonnegative rate limits. You don't also need sampler environment variables for this configuration.

# [.NET](#tab/net)

Load your application's configuration and pass the validated values to `UseMicrosoftOpenTelemetry()` inside `OpenTelemetrySdk.Create()`. Use the same sampling properties as the code examples; the distro doesn't need a second provider or a separate exporter.

# [Java](#tab/java)

> [!NOTE]
> * Starting with Java agent version 3.4.0, rate-limited sampling is available and is now the default.
>
> * Sampling only applies to logs inside of a request. Logs that aren't inside of a request (for example, startup logs) are always collected by default. If you want to sample those logs, use [sampling overrides](java-standalone-config.md#configure-sampling-overrides).

If you don't configure sampling, the default is now rate-limited sampling configured to capture at most (approximately) five requests per second, along with all the dependencies and logs on those requests.

This configuration replaces the prior default, which was to capture all requests. If you still want to capture all requests, use fixed-percentage sampling and set the sampling percentage to 100.

#### Fixed percentage sampling

This example shows how to set the sampling to capture approximately a third of all requests:

```json
{
    "sampling": {
        "percentage": 33.333
    }
}
```

Set the sampling percentage by using the environment variable. It takes precedence over the sampling percentage specified in the JSON configuration.

> [!TIP]
> For the sampling percentage, choose a percentage that's close to 100/N, where N is an integer. Currently, sampling doesn't support other values.

#### Rate-limited sampling

> [!NOTE]
> The rate-limited sampling is approximate because internally it must adapt a "fixed" sampling percentage over time to emit accurate item counts on each telemetry record. Internally, the rate-limited sampling is tuned to adapt quickly (0.1 seconds) to new application loads. For this reason, you shouldn't see it exceed the configured rate by much, or for very long.

This example shows how to set the sampling to capture at most (approximately) one request per second:

```json
{
    "sampling": {
        "requestsPerSecond": 1
    }
}
```

The `requestsPerSecond` value can be a decimal, so you can configure it to capture less than one request per second if you want. For example, a value of `0.5` means capture at most one request every 2 seconds.

Set the rate limit by using the environment variable. It takes precedence over the rate limit specified in the JSON configuration.

# [Java native](#tab/java-native)

Java native doesn't support configuring sampling in a configuration file. To configure sampling, use code or environment variables.

# [Node.js](#tab/nodejs)

Configure Microsoft OpenTelemetry Distro sampling in the `useMicrosoftOpenTelemetry()` options or through environment variables. Don't edit an `applicationinsights.json` file inside the installed package. The [Microsoft OpenTelemetry Distro configuration reference](https://github.com/microsoft/opentelemetry-distro-javascript#configuration) describes the supported options.

# [Python](#tab/python)

Python doesn't support configuring sampling in a configuration file. To configure sampling, use code or environment variables.

---

### Configure trace-based sampling for logs

When you enable this feature, the system drops log records that belong to **unsampled traces** so your logs stay aligned with trace sampling.

* A log record is part of a trace when it has a valid `SpanId`.
* If the associated trace's `TraceFlags` indicate **not sampled**, the feature **drops** the log record.
* Log records **without** any trace context **aren't** affected.
* The default depends on the language and distro version. See the per-language settings that follow.

Use the following settings to configure trace-based log sampling:

# [ASP.NET Core](#tab/aspnetcore)

The distro enables trace-based log sampling by default. Set `EnableTraceBasedLogsSampler` to `false` to disable it.

```csharp
// Configure the Microsoft OpenTelemetry Distro.
builder.Services.AddOpenTelemetry().UseMicrosoftOpenTelemetry(options =>
{
  options.Exporters = ExportTarget.AzureMonitor;
});
```

# [.NET](#tab/net)

The distro enables trace-based log sampling by default, including non-hosted applications. Set `EnableTraceBasedLogsSampler` to `false` to disable it.

```csharp
// Import the Microsoft OpenTelemetry Distro and supporting APIs.
using Microsoft.OpenTelemetry;
using OpenTelemetry;

// Create the SDK and keep its providers alive until application shutdown.
using var sdk = OpenTelemetrySdk.Create(telemetry =>
{
  // Configure the Microsoft OpenTelemetry Distro.
  telemetry.UseMicrosoftOpenTelemetry(options =>
  {
    options.Exporters = ExportTarget.AzureMonitor;
  });
});
```

# [Java](#tab/java)

For Java applications, trace-based sampling is enabled by default.

# [Java native](#tab/java-native)

For Spring Boot native and Quarkus native applications, trace-based sampling is enabled by default.

[!INCLUDE [quarkus-support](./includes/quarkus-support.md)]

# [Node.js](#tab/nodejs)

```typescript
// Import the Microsoft OpenTelemetry Distro.
const { useMicrosoftOpenTelemetry } = await import("@microsoft/opentelemetry");

// Initialize the Microsoft OpenTelemetry Distro.
const monitor = useMicrosoftOpenTelemetry({
    azureMonitor: {
        // Drop logs associated with unsampled traces.
        enableTraceBasedSamplingForLogs: true,
        azureMonitorExporterOptions: {
            connectionString:
                process.env.APPLICATIONINSIGHTS_CONNECTION_STRING || "<ConnectionString>",
        },
    },
});
```

# [Python](#tab/python)

```python
from microsoft.opentelemetry import use_microsoft_opentelemetry

# Initialize the Microsoft OpenTelemetry Distro with Azure Monitor export.
use_microsoft_opentelemetry(
    enable_azure_monitor=True,
    azure_monitor_connection_string="<ConnectionString>",

    # Drop logs associated with unsampled traces.
    enable_trace_based_sampling_for_logs=True,
)
```

---

## Live metrics

[Live metrics](live-stream.md) provides a real-time analytics dashboard for insight into application activity and performance.

# [ASP.NET Core](#tab/aspnetcore)

> [!IMPORTANT]
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

This feature is enabled by default.

You can disable Live Metrics when you configure the Microsoft OpenTelemetry Distro.

```csharp
// Configure the Microsoft OpenTelemetry Distro.
builder.Services.AddOpenTelemetry().UseMicrosoftOpenTelemetry(options =>
{
  options.Exporters = ExportTarget.AzureMonitor;

  // Disable Live Metrics.
  options.AzureMonitor.EnableLiveMetrics = false;
});
```

# [.NET](#tab/net)

Live Metrics is enabled by default in the Microsoft OpenTelemetry Distro for .NET, including non-hosted applications. To disable it, set `options.AzureMonitor.EnableLiveMetrics` to `false`:

```csharp
// Import the Microsoft OpenTelemetry Distro and supporting APIs.
using Microsoft.OpenTelemetry;
using OpenTelemetry;

// Create the SDK and keep its providers alive until application shutdown.
using var sdk = OpenTelemetrySdk.Create(telemetry =>
{
  // Configure the Microsoft OpenTelemetry Distro.
  telemetry.UseMicrosoftOpenTelemetry(options =>
  {
    options.Exporters = ExportTarget.AzureMonitor;

    // Disable Live Metrics.
    options.AzureMonitor.EnableLiveMetrics = false;
  });
});
```

The standalone [Azure Monitor OpenTelemetry Exporter](https://www.nuget.org/packages/Azure.Monitor.OpenTelemetry.Exporter) doesn't include Live Metrics.

# [Java](#tab/java)

The Live Metrics experience is enabled by default.

For more information on Java configuration, see [Configure Azure Monitor Application Insights for Java](java-standalone-config.md).

# [Java native](#tab/java-native)

Live Metrics isn't available for GraalVM native applications.

# [Node.js](#tab/nodejs)

> [!IMPORTANT]
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

Live Metrics is enabled by default. You can enable or disable it with `azureMonitor.enableLiveMetrics` when configuring the Microsoft OpenTelemetry Distro.

```typescript
export class LiveMetricsSample {
    static async run() {
        // Import the Microsoft OpenTelemetry Distro.
        const { useMicrosoftOpenTelemetry } = await import("@microsoft/opentelemetry");

        // Configure Azure Monitor export and the options used by this sample.
        const options = {
            azureMonitor: {
                azureMonitorExporterOptions: {
                    connectionString:
                        process.env.APPLICATIONINSIGHTS_CONNECTION_STRING ||
                        "<ConnectionString>",
                },
                enableLiveMetrics: true,
            },
        };

        // Initialize the Microsoft OpenTelemetry Distro.
        const monitor = useMicrosoftOpenTelemetry(options);
        console.log("Azure Monitor initialized (live metrics enabled)");
    }
}
```

<!--

TODO:

This feature is enabled or disabled by default.

Functionality and customization are covered in the following configuration sample.

```typescript
Configuration sample

```

-->

# [Python](#tab/python)

> [!IMPORTANT]
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

Live Metrics is enabled by default. You can disable Live Metrics when you configure the Distro.

```python
...

# Initialize the Microsoft OpenTelemetry Distro with Azure Monitor export.
use_microsoft_opentelemetry(
    enable_azure_monitor=True,
    azure_monitor_enable_live_metrics=False,  # To disable live metrics
)
...
```

---

## Enable Microsoft Entra ID (formerly Azure AD) authentication

To create a more secure connection to Azure, enable Microsoft Entra authentication. This authentication method prevents unauthorized telemetry from being ingested into your subscription.


For more information, see the dedicated Microsoft Entra authentication page linked for each supported language.

# [ASP.NET Core](#tab/aspnetcore)

For information on configuring Entra ID authentication, see [Microsoft Entra authentication for Application Insights](azure-ad-authentication.md?tabs=aspnetcore).

For the Microsoft OpenTelemetry Distro, set `options.AzureMonitor.Credential`. See the [.NET authentication example](https://github.com/microsoft/opentelemetry-distro-dotnet/blob/main/docs/azure-monitor-getting-started.md#authenticate-the-client).

# [.NET](#tab/net)

For information on configuring Entra ID authentication, see [Microsoft Entra authentication for Application Insights](azure-ad-authentication.md?tabs=net).

Set `options.AzureMonitor.Credential` inside `UseMicrosoftOpenTelemetry()` for the Microsoft OpenTelemetry Distro.

# [Java](#tab/java)

For information on configuring Entra ID authentication, see [Microsoft Entra authentication for Application Insights](azure-ad-authentication.md?tabs=java).

# [Java native](#tab/java-native)

Microsoft Entra ID authentication isn't available for GraalVM Native applications.

# [Node.js](#tab/nodejs)

For information on configuring Entra ID authentication, see [Microsoft Entra authentication for Application Insights](azure-ad-authentication.md?tabs=nodejs).

For the Microsoft OpenTelemetry Distro, set `azureMonitor.azureMonitorExporterOptions.credential` in the [distro options](https://github.com/microsoft/opentelemetry-distro-javascript#configuration).

# [Python](#tab/python)

For information on configuring Entra ID authentication, see [Microsoft Entra authentication for Application Insights](azure-ad-authentication.md?tabs=python).

For the Microsoft OpenTelemetry Distro, pass `azure_monitor_exporter_credential` to `use_microsoft_opentelemetry()`. See the [Python authentication example](https://github.com/microsoft/opentelemetry-distro-python#quick-start).

---

## Offline storage and automatic retries


Azure Monitor OpenTelemetry-based offerings cache telemetry when an application disconnects from Application Insights and retry sending for up to 48 hours. For data handling recommendations, see [Export and delete private data](../logs/personal-data-mgmt.md#export-delete-or-purge-personal-data). High-load applications occasionally drop telemetry for two reasons: exceeding the allowable time or exceeding the maximum file size. When necessary, the product prioritizes recent events over old ones.

# [ASP.NET Core](#tab/aspnetcore)

The Microsoft OpenTelemetry Distro includes the AzureMonitorExporter, which by default uses one of the following locations for offline storage (listed in order of precedence):

* Windows
    * %LOCALAPPDATA%\Microsoft\AzureMonitor
    * %TEMP%\Microsoft\AzureMonitor

* Non-Windows
    * %TMPDIR%/Microsoft/AzureMonitor
    * /var/tmp/Microsoft/AzureMonitor
    * /tmp/Microsoft/AzureMonitor

To override the default directory, set `options.AzureMonitor.StorageDirectory` when configuring the Microsoft OpenTelemetry Distro.

```csharp
// Import the Microsoft OpenTelemetry Distro and supporting APIs.
using Microsoft.OpenTelemetry;

// Create the application builder.
var builder = WebApplication.CreateBuilder(args);

// Configure the Microsoft OpenTelemetry Distro.
builder.UseMicrosoftOpenTelemetry(options =>
{
  options.Exporters = ExportTarget.AzureMonitor;

    // Store telemetry here when the exporter cannot send it immediately.
    options.AzureMonitor.StorageDirectory = "<StorageDirectory>";
});

// Build the application with the configured telemetry services.
var app = builder.Build();

// Run the application and its telemetry providers.
app.Run();
```

To disable this feature, set `options.AzureMonitor.DisableOfflineStorage = true`.

# [.NET](#tab/net)

By default, the AzureMonitorExporter uses one of the following locations for offline storage, listed in order of precedence:


* Windows
    * %LOCALAPPDATA%\Microsoft\AzureMonitor
    * %TEMP%\Microsoft\AzureMonitor

* Non-Windows
    * %TMPDIR%/Microsoft/AzureMonitor
    * /var/tmp/Microsoft/AzureMonitor
    * /tmp/Microsoft/AzureMonitor

To override the default directory for the Microsoft OpenTelemetry Distro, set `options.AzureMonitor.StorageDirectory`.

```csharp
// Import the Microsoft OpenTelemetry Distro and supporting APIs.
using Microsoft.OpenTelemetry;
using OpenTelemetry;

// Create the SDK and keep its providers alive until application shutdown.
using var sdk = OpenTelemetrySdk.Create(telemetry =>
{
  // Configure the Microsoft OpenTelemetry Distro.
  telemetry.UseMicrosoftOpenTelemetry(options =>
    {
    options.Exporters = ExportTarget.AzureMonitor;

    // Store telemetry here when the exporter cannot send it immediately.
    options.AzureMonitor.StorageDirectory = "<StorageDirectory>";
    });
});
```

To disable this feature, set `options.AzureMonitor.DisableOfflineStorage = true`.

# [Java](#tab/java)

When the agent can't send telemetry to Azure Monitor, it stores telemetry files on disk. The files are saved in a `telemetry` folder under the directory specified by the `java.io.tmpdir` system property. Each file name starts with a timestamp and ends with the `.trn` extension. This offline storage mechanism helps ensure telemetry is retained during temporary network outages or ingestion failures.

The agent stores up to 50 MB of telemetry data by default and allows [configuration of the storage limit](./java-standalone-config.md#recovery-from-ingestion-failures). The agent periodically attempts to send stored telemetry. Telemetry files older than 48 hours are deleted, and the oldest events are discarded when the storage limit is reached.

For a full list of available configurations, see [Configuration options](./java-standalone-config.md).

# [Java native](#tab/java-native)

When the agent can't send telemetry to Azure Monitor, it stores telemetry files on disk. The files are saved in a `telemetry` folder under the directory specified by the `java.io.tmpdir` system property. Each file name starts with a timestamp and ends with the `.trn` extension. This offline storage mechanism helps ensure telemetry is retained during temporary network outages or ingestion failures.

The agent stores up to 50 MB of telemetry data by default. Attempts to send stored telemetry are made periodically. Telemetry files older than 48 hours are deleted and the oldest events are discarded when the storage limit is reached.

# [Node.js](#tab/nodejs)

By default, the AzureMonitorExporter uses one of the following locations for offline storage.

- Windows
  - %TEMP%\Microsoft-AzureMonitor-`<unique-identifier>`\opentelemetry-nodejs-`<your-instrumentation-key>`
- Non-Windows
  - %TMPDIR%/Microsoft/Microsoft-AzureMonitor-`<unique-identifier>`/opentelemetry-nodejs-`<your-instrumentation-key>`
  - /var/tmp/Microsoft/Microsoft-AzureMonitor-`<unique-identifier>`/opentelemetry-nodejs-`<your-instrumentation-key>`

The `<unique-identifier>` is a hash created from user environment attributes like instrumentation key, process name, username, and application directory. This identifier solves a common multi-user system problem: when the first user creates the storage directory, their file permissions (umask settings) might block other users from accessing the same path. A unique directory for each user context ensures every user gets their own storage location with proper access permissions.

To override the default directory, set `azureMonitor.azureMonitorExporterOptions.storageDirectory`.

For example:

```typescript
export class OfflineStorageSample {
    static async run() {
        // Import the Microsoft OpenTelemetry Distro.
        const { useMicrosoftOpenTelemetry } = await import("@microsoft/opentelemetry");

        // Configure Azure Monitor export and the options used by this sample.
        const options = {
            azureMonitor: {
                azureMonitorExporterOptions: {
                    connectionString:
                        process.env.APPLICATIONINSIGHTS_CONNECTION_STRING ||
                        "<ConnectionString>",

                    // Store telemetry here when the exporter cannot send it immediately.
                    storageDirectory: "<StorageDirectory>",
                    disableOfflineStorage: false, // set to true to disable
                },
            },
        };

        // Initialize the Microsoft OpenTelemetry Distro.
        const monitor = useMicrosoftOpenTelemetry(options);
        console.log("Azure Monitor initialized (offline storage configured)");
    }
}
```

To disable this feature, set `azureMonitor.azureMonitorExporterOptions.disableOfflineStorage = true`.

# [Python](#tab/python)

By default, Azure Monitor exporters use the following path:

`<tempfile.gettempdir()>/Microsoft-AzureMonitor-<unique-identifier>/opentelemetry-python-<your-instrumentation-key>`

The `<unique-identifier>` is a hash created from user environment attributes like instrumentation key, process name, username, and application directory. This identifier solves a common multi-user system problem: when the first user creates the storage directory, their file permissions (umask settings) might block other users from accessing the same path. A unique directory for each user context ensures every user gets their own storage location with proper access permissions.

To override the default directory, set `azure_monitor_exporter_storage_directory` to the directory you want.

For example:

```python
...
# Configure OpenTelemetry to use Azure Monitor with the specified connection string and
# storage directory.
use_microsoft_opentelemetry(
    enable_azure_monitor=True,
    azure_monitor_connection_string="<ConnectionString>",
    azure_monitor_exporter_storage_directory="<StorageDirectory>",
)
...
```

To disable this feature, set `azure_monitor_exporter_disable_offline_storage` to `True`. The default is `False`.

For example:
```python
...
# Configure OpenTelemetry to use Azure Monitor with the specified connection string and
# disable offline storage.
use_microsoft_opentelemetry(
    enable_azure_monitor=True,
    azure_monitor_connection_string="<ConnectionString>",
    azure_monitor_exporter_disable_offline_storage=True,
)
...
```

---

## Enable the OTLP Exporter

You might want to enable the OpenTelemetry Protocol (OTLP) Exporter alongside the Azure Monitor Exporter to send your telemetry to two locations.

> [!NOTE]
> The OTLP Exporter is shown for convenience only. Microsoft doesn't officially support the OTLP Exporter or any components or third-party experiences downstream of it.

# [ASP.NET Core](#tab/aspnetcore)

The Microsoft OpenTelemetry Distro includes OTLP export. Configure your collector endpoint with `OTEL_EXPORTER_OTLP_ENDPOINT`, and select both destinations:

```csharp
// Import the Microsoft OpenTelemetry Distro and supporting APIs.
using Microsoft.OpenTelemetry;

// Create the application builder.
var builder = WebApplication.CreateBuilder(args);

// Configure the Microsoft OpenTelemetry Distro.
builder.UseMicrosoftOpenTelemetry(options =>
{
  // Send telemetry to Azure Monitor and the configured OTLP collector.
  options.Exporters = ExportTarget.AzureMonitor | ExportTarget.Otlp;
});

// Build the application with the configured telemetry services.
var app = builder.Build();

// Run the application and its telemetry providers.
app.Run();
```

# [.NET](#tab/net)

Configure your collector endpoint with `OTEL_EXPORTER_OTLP_ENDPOINT`, and select both destinations. Keep the SDK alive until application shutdown:

```csharp
// Import the Microsoft OpenTelemetry Distro and supporting APIs.
using Microsoft.OpenTelemetry;
using OpenTelemetry;

// Create the SDK and keep its providers alive until application shutdown.
using var sdk = OpenTelemetrySdk.Create(telemetry =>
{
  // Configure the Microsoft OpenTelemetry Distro.
  telemetry.UseMicrosoftOpenTelemetry(options =>
  {
    // Send telemetry to Azure Monitor and the configured OTLP collector.
    options.Exporters = ExportTarget.AzureMonitor | ExportTarget.Otlp;
  });
});
```

# [Java](#tab/java)

The Application Insights Java Agent doesn't support OTLP.
For more information about supported configurations, see the [Java supplemental documentation](java-standalone-config.md).

# [Java native](#tab/java-native)

You can't enable the OpenTelemetry Protocol (OTLP) Exporter alongside the Azure Monitor Exporter to send your telemetry to two locations.

# [Node.js](#tab/nodejs)

1. Install the [OpenTelemetry Collector Trace Exporter](https://www.npmjs.com/package/@opentelemetry/exporter-trace-otlp-http) and other OpenTelemetry packages in your project.

    ```bash
    npm install @opentelemetry/api
    npm install @opentelemetry/exporter-trace-otlp-http
    npm install @opentelemetry/sdk-trace-base
    npm install @opentelemetry/sdk-trace-node
    ```

1. Add the following code snippet. This example assumes you have an OpenTelemetry Collector with an OTLP receiver running. For details, see the [example on GitHub](https://github.com/open-telemetry/opentelemetry-js/tree/main/examples/otlp-exporter-node).

    <details>
    <summary>Enable the OTLP Exporter</summary>

    ```typescript
    export class OtlpExporterSample {
        static async run() {
            // Import the Microsoft OpenTelemetry Distro.
            const { useMicrosoftOpenTelemetry } = await import("@microsoft/opentelemetry");
            const { BatchSpanProcessor } = await import("@opentelemetry/sdk-trace-base");
            const { OTLPTraceExporter } = await import(
                "@opentelemetry/exporter-trace-otlp-http"
            );
            // Create an OTLP trace exporter (set 'url' if your collector isn't on the default
            // endpoint).
            const otlpExporter = new OTLPTraceExporter({
                // url: "http://localhost:4318/v1/traces",
            });
            // Configure Azure Monitor and add the OTLP exporter as an additional span
            // processor.
            const options = {
                azureMonitor: {
                    azureMonitorExporterOptions: {
                        connectionString:
                            process.env.APPLICATIONINSIGHTS_CONNECTION_STRING ||
                            "<ConnectionString>",
                    },
                },
                spanProcessors: [new BatchSpanProcessor(otlpExporter)],
            };

            // Initialize the Microsoft OpenTelemetry Distro.
            const monitor = useMicrosoftOpenTelemetry(options);
            console.log("Azure Monitor initialized (OTLP exporter added)");
        }
    }
    ```

    </details>

# [Python](#tab/python)

1. Install the [opentelemetry-exporter-otlp](https://pypi.org/project/opentelemetry-exporter-otlp/) package.

1. Add the following code snippet. This example assumes you have an OpenTelemetry Collector with an OTLP receiver running. For details, see this [README](https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/monitor/azure-monitor-opentelemetry-exporter/samples/traces#collector).

    <details>
    <summary>Enable the OTLP Exporter</summary>

    ```python
    # Import the `use_microsoft_opentelemetry()`, `trace`, `OTLPSpanExporter`, and
    # `BatchSpanProcessor` classes from the appropriate packages.
    from microsoft.opentelemetry import use_microsoft_opentelemetry
    from opentelemetry import trace
    from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
    from opentelemetry.sdk.trace.export import BatchSpanProcessor

    # Configure OpenTelemetry to use Azure Monitor with the specified connection string.
    use_microsoft_opentelemetry(
        enable_azure_monitor=True,
        azure_monitor_connection_string="<ConnectionString>",
    )

    # Get the tracer for the current module.
    tracer = trace.get_tracer(__name__)

    # Create an OTLP span exporter that sends spans to the specified endpoint.
    # Replace `http://localhost:4317` with the endpoint of your OTLP collector.
    otlpExporter = OTLPSpanExporter(endpoint="http://localhost:4317")

    # Create a batch span processor that uses the OTLP span exporter.
    spanProcessor = BatchSpanProcessor(otlpExporter)

    # Add the batch span processor to the tracer provider.
    trace.get_tracer_provider().add_span_processor(spanProcessor)

    # Start a new span with the name "test".
    with tracer.start_as_current_span("test"):
        print("Hello world!")
    ```

    </details>

---

## OpenTelemetry configurations

You can configure the following settings through environment variables. Use the tab for your language and distro.

# [ASP.NET Core](#tab/aspnetcore)

| Environment variable | Description |
| -------------------- | ----------- |
| `APPLICATIONINSIGHTS_CONNECTION_STRING` | Set this variable to the connection string for your Application Insights resource. |
| `APPLICATIONINSIGHTS_STATSBEAT_DISABLED` | Set this variable to `true` to opt out of internal metrics collection. |
| `OTEL_RESOURCE_ATTRIBUTES` | Key-value pairs to use as resource attributes. For more information about resource attributes, see the [Resource SDK specification](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.5.0/specification/resource/sdk.md#specifying-resource-information-via-an-environment-variable). |
| `OTEL_SERVICE_NAME` | Sets the value of the `service.name` resource attribute. If `service.name` is also provided in `OTEL_RESOURCE_ATTRIBUTES`, `OTEL_SERVICE_NAME` takes precedence. |

# [.NET](#tab/net)

| Environment variable | Description |
| -------------------- | ----------- |
| `APPLICATIONINSIGHTS_CONNECTION_STRING` | Set this variable to the connection string for your Application Insights resource. |
| `APPLICATIONINSIGHTS_STATSBEAT_DISABLED` | Set this variable to `true` to opt out of internal metrics collection. |
| `OTEL_RESOURCE_ATTRIBUTES` | Key-value pairs to use as resource attributes. For more information about resource attributes, see the [Resource SDK specification](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.5.0/specification/resource/sdk.md#specifying-resource-information-via-an-environment-variable). |
| `OTEL_SERVICE_NAME` | Sets the value of the `service.name` resource attribute. If `service.name` is also provided in `OTEL_RESOURCE_ATTRIBUTES`, `OTEL_SERVICE_NAME` takes precedence. |


# [Java](#tab/java)

For more information about Java, see the [Java supplemental documentation](java-standalone-config.md).

# [Java native](#tab/java-native)

| Environment variable | Description |
| --- | --- |
| `APPLICATIONINSIGHTS_CONNECTION_STRING` | Set this variable to the connection string for your Application Insights resource. |

For Spring Boot native applications, the [OpenTelemetry Java SDK configurations](https://opentelemetry.io/docs/languages/java/configuration/) are available.

For Quarkus native applications, review the [Quarkus OpenTelemetry documentation](https://quarkus.io/guides/opentelemetry#configuration).

[!INCLUDE [quarkus-support](./includes/quarkus-support.md)]

# [Node.js](#tab/nodejs)

For more information about OpenTelemetry SDK configuration, see the [OpenTelemetry documentation](https://opentelemetry.io/docs/concepts/sdk-configuration).

# [Python](#tab/python)

For more information about OpenTelemetry SDK configuration, see the [OpenTelemetry documentation](https://opentelemetry.io/docs/concepts/sdk-configuration) and [Microsoft OpenTelemetry Distro for Python configuration](https://github.com/microsoft/opentelemetry-distro-python#configuration-reference).

---

## Redact URL query strings


To redact URL query strings, turn off query string collection. This setting is recommended if you call Azure storage by using a SAS token.

# [ASP.NET Core](#tab/aspnetcore)

The [Microsoft.OpenTelemetry distro](https://www.nuget.org/packages/Microsoft.OpenTelemetry) includes ASP.NET Core and HttpClient instrumentation. For applications that handle sensitive query strings, explicitly enable query redaction before initializing the distro:

* Set `OTEL_DOTNET_EXPERIMENTAL_ASPNETCORE_DISABLE_URL_QUERY_REDACTION` to `false` for ASP.NET Core instrumentation.
* Set `OTEL_DOTNET_EXPERIMENTAL_HTTPCLIENT_DISABLE_URL_QUERY_REDACTION` to `false` for HttpClient instrumentation.

Setting either variable to `true` disables that instrumentation's query-string redaction.

# [.NET](#tab/net)

The Microsoft OpenTelemetry Distro for .NET includes HttpClient instrumentation. Set `OTEL_DOTNET_EXPERIMENTAL_HTTPCLIENT_DISABLE_URL_QUERY_REDACTION` to `false` before initialization to enable query-string redaction. For ASP.NET Core hosting, also set `OTEL_DOTNET_EXPERIMENTAL_ASPNETCORE_DISABLE_URL_QUERY_REDACTION` to `false`.

If you use the standalone `Azure.Monitor.OpenTelemetry.Exporter` package instead, add and configure the relevant instrumentation library separately.

# [Java](#tab/java)

Add the following to the `applicationinsights.json` configuration file:

<details>
<summary>Redact URL query strings</summary>

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

</details>

# [Java native](#tab/java-native)

The OpenTelemetry community is actively working to support redaction.

# [Node.js](#tab/nodejs)

When you use the [Microsoft OpenTelemetry Distro](https://github.com/microsoft/opentelemetry-distro-javascript), you can redact query strings by adding a span processor to the distro configuration.

<details>
<summary>Redact URL query strings</summary>

```typescript
export class RedactQueryStringsSample {
    static async run() {
        // Import the Microsoft OpenTelemetry Distro.
        const { useMicrosoftOpenTelemetry } = await import("@microsoft/opentelemetry");
        const { SEMATTRS_HTTP_ROUTE, SEMATTRS_HTTP_TARGET, SEMATTRS_HTTP_URL } =
            await import("@opentelemetry/semantic-conventions");
        class RedactQueryStringProcessor {
            forceFlush() {
                return Promise.resolve();
            }
            onStart() {}
            shutdown() {
                return Promise.resolve();
            }
            onEnd(span: any) {
                const route = String(span.attributes[SEMATTRS_HTTP_ROUTE] ?? "");
                const url = String(span.attributes[SEMATTRS_HTTP_URL] ?? "");
                const target = String(span.attributes[SEMATTRS_HTTP_TARGET] ?? "");
                const strip = (s: string) => {
                    const i = s.indexOf("?");
                    return i === -1 ? s : s.substring(0, i);
                };
                if (route)
                    span.attributes[SEMATTRS_HTTP_ROUTE] = strip(route);
                if (url)
                    span.attributes[SEMATTRS_HTTP_URL] = strip(url);
                if (target)
                    span.attributes[SEMATTRS_HTTP_TARGET] = strip(target);
            }
        }

        // Configure Azure Monitor export and the options used by this sample.
        const options = {
            azureMonitor: {
                azureMonitorExporterOptions: {
                    connectionString:
                        process.env.APPLICATIONINSIGHTS_CONNECTION_STRING ||
                        "<ConnectionString>",
                },
            },
            spanProcessors: [new RedactQueryStringProcessor()],
        };

        // Initialize the Microsoft OpenTelemetry Distro.
        const monitor = useMicrosoftOpenTelemetry(options);
        console.log("Azure Monitor initialized (query strings redacted)");
    }
}
```

</details>

# [Python](#tab/python)

The OpenTelemetry community is actively working on supporting redaction.

---

## Metric export interval

You can configure the metric export interval by using the `OTEL_METRIC_EXPORT_INTERVAL` environment variable.

```bash
export OTEL_METRIC_EXPORT_INTERVAL="60000"
```

The default value is `60000` milliseconds (60 seconds). This setting controls how often the OpenTelemetry SDK exports metrics.

[!INCLUDE [application-insights-metrics-interval](includes/application-insights-metrics-interval.md)]

For reference, see the following OpenTelemetry specifications:

* [Environment variable definitions](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/configuration/sdk-environment-variables.md#periodic-exporting-metricreader)
* [Periodic exporting metric reader](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/metrics/sdk.md#periodic-exporting-metricreader)

[!INCLUDE [Help, feedback, and support](includes/opentelemetry-help-feedback-support.md)]

[!INCLUDE [Next steps](includes/opentelemetry-next-steps.md)]
