---
title: Migrate from Application Insights SDKs to Azure Monitor OpenTelemetry
description: This article provides guidance on how to migrate .NET, Java, Node.js, and Python applications from the Application Insights Classic API SDKs to Azure Monitor OpenTelemetry.
ms.topic: how-to
ms.date: 01/26/2026
ms.custom: devx-track-dotnet, devx-track-java, devx-track-extended-java, devx-track-js, devx-track-python
---

# Migrate from Application Insights SDKs to Azure Monitor OpenTelemetry

This guide provides step-by-step instructions to migrate applications from using Application Insights SDKs (Classic API) to Azure Monitor OpenTelemetry.

Expect a similar experience with Azure Monitor OpenTelemetry instrumentation as with the Application Insights SDKs. For more information and a feature-by-feature comparison, see [release state of features](application-insights-faq.yml#what-s-the-current-release-state-of-features-within-the-azure-monitor-opentelemetry-distro).

# [.NET](#tab/dotnet)

> [!div class="checklist"]
> * ASP.NET Core migration to the [Azure Monitor OpenTelemetry Distro](https://www.nuget.org/packages/Azure.Monitor.OpenTelemetry.AspNetCore). (`Azure.Monitor.OpenTelemetry.AspNetCore` NuGet package)
> * ASP.NET, console, and WorkerService migration to the [Azure Monitor OpenTelemetry Exporter](https://www.nuget.org/packages/Azure.Monitor.OpenTelemetry.Exporter). (`Azure.Monitor.OpenTelemetry.Exporter` NuGet package)

If you're getting started with Application Insights and don't need to migrate from the Classic API, see [Enable Azure Monitor OpenTelemetry](opentelemetry-enable.md).

> [!NOTE]
> [!INCLUDE [application-insights-functions-link](./includes/application-insights-functions-link.md)]

## Prerequisites

### ASP.NET Core

* An ASP.NET Core web application already instrumented with Application Insights without any customizations.
* An actively supported version of [.NET](https://dotnet.microsoft.com/platform/support/policy/dotnet-core).

### ASP.NET

* An ASP.NET web application already instrumented with Application Insights.
* An actively supported version of [.NET Framework](/lifecycle/products/microsoft-net-framework).

### Console

* A Console application already instrumented with Application Insights.
* An actively supported version of [.NET Framework](/lifecycle/products/microsoft-net-framework) or [.NET](https://dotnet.microsoft.com/platform/support/policy/dotnet-core).

### WorkerService

* A WorkerService application already instrumented with Application Insights without any customizations.
* An actively supported version of [.NET](https://dotnet.microsoft.com/platform/support/policy/dotnet-core).

> [!TIP]
> Our product group is actively seeking feedback on this documentation. Provide feedback to otel@microsoft.com or see the [Support](#support) section.

## Remove the Application Insights SDK

> [!NOTE]
> Before continuing with these steps, you should confirm that you have a current backup of your application.

### ASP.NET Core

1. Remove NuGet packages

    Remove the `Microsoft.ApplicationInsights.AspNetCore` package from your `csproj`.

    ```sh
    dotnet remove package Microsoft.ApplicationInsights.AspNetCore
    ```

1. Remove Initialization Code and customizations

    * Remove any references to Application Insights types in your codebase.

        > [!TIP]
        > After removing the Application Insights package, you can re-build your application to get a list of references that need to be removed.

    * Remove Application Insights from your `ServiceCollection` by deleting the following line:

        ```csharp
        builder.Services.AddApplicationInsightsTelemetry();
        ```

    * Remove the `ApplicationInsights` section from your `appsettings.json`.

        ```json
        {
            "ApplicationInsights": {
                "ConnectionString": "<YOUR-CONNECTION-STRING>"
            }
        }
        ```

1. Clean and Build

    Inspect your bin directory to validate that all references to `Microsoft.ApplicationInsights.*` were removed.

1. Test your application

    Verify that your application has no unexpected consequences.

### ASP.NET

1. Remove NuGet packages

   Remove the `Microsoft.AspNet.TelemetryCorrelation` package and any `Microsoft.ApplicationInsights.*` packages from your `csproj` and `packages.config`.

1. Delete the `ApplicationInsights.config` file.

1. Delete section from your application's `Web.config` file.

    * Two [HttpModules](/troubleshoot/developer/webapps/aspnet/development/http-modules-handlers) were automatically added to your web.config when you first added ApplicationInsights to your project.

        Any references to the `TelemetryCorrelationHttpModule` and the `ApplicationInsightsWebTracking` should be removed.
        If you added Application Insights to your [Internet Information Server (IIS) Modules](/iis/get-started/introduction-to-iis/iis-modules-overview), it should also be removed.
    
        ```xml
        <configuration>
        <system.web>
            <httpModules>
            <add name="TelemetryCorrelationHttpModule" type="Microsoft.AspNet.TelemetryCorrelation.TelemetryCorrelationHttpModule, Microsoft.AspNet.TelemetryCorrelation" />
            <add name="ApplicationInsightsWebTracking" type="Microsoft.ApplicationInsights.Web.ApplicationInsightsHttpModule, Microsoft.AI.Web" />
            </httpModules>
        </system.web>
        <system.webServer>
            <modules>
            <remove name="TelemetryCorrelationHttpModule" />
            <add name="TelemetryCorrelationHttpModule" type="Microsoft.AspNet.TelemetryCorrelation.TelemetryCorrelationHttpModule, Microsoft.AspNet.TelemetryCorrelation" preCondition="managedHandler" />
            <remove name="ApplicationInsightsWebTracking" />
            <add name="ApplicationInsightsWebTracking" type="Microsoft.ApplicationInsights.Web.ApplicationInsightsHttpModule, Microsoft.AI.Web" preCondition="managedHandler" />
            </modules>
        </system.webServer>
        </configuration>
        ```

    * Also review any [assembly version redirections](/dotnet/framework/configure-apps/redirect-assembly-versions) added to your web.config.

1. Remove Initialization Code and customizations

    Remove any references to Application Insights types in your codebase.

    > [!TIP]
    > After removing the Application Insights package, you can re-build your application to get a list of references that need to be removed.

    * Remove references to `TelemetryConfiguration` or `TelemetryClient`. It's a part of your application startup to initialize the Application Insights SDK.

    The following scenarios are optional and apply to advanced users.

    * If you have any more references to the `TelemetryClient`, which are used to [manually record telemetry](./api-custom-events-metrics.md), they should be removed.
    * If you added any [custom filtering or enrichment](./api-filtering-sampling.md) in the form of a custom `TelemetryProcessor` or `TelemetryInitializer`, they should be removed. You can find them referenced in your configuration.
    * If your project has a `FilterConfig.cs` in the `App_Start` directory, check for any custom exception handlers that reference Application Insights and remove.

1. Remove JavaScript Snippet

    If you added the JavaScript SDK to collect client-side telemetry, it can also be removed although it continues to work without the .NET SDK.
    For full code samples of what to remove, review the [onboarding guide for the JavaScript SDK](./javascript-sdk.md).

1. Remove any Visual Studio Artifacts

    If you used Visual Studio to onboard to Application Insights, you could have more files left over in your project.

    * `ConnectedService.json` might have a reference to your Application Insights resource.
    * `[Your project's name].csproj` might have a reference to your Application Insights resource:

        ```xml
        <ApplicationInsightsResourceId>/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/Default-ApplicationInsights-EastUS/providers/microsoft.insights/components/WebApplication4</ApplicationInsightsResourceId>
        ```

1. Clean and Build

    Inspect your bin directory to validate that all references to `Microsoft.ApplicationInsights.` were removed.

1. Test your application

    Verify that your application has no unexpected consequences.

### Console

1. Remove NuGet packages

   Remove any `Microsoft.ApplicationInsights.*` packages from your `csproj` and `packages.config`.

    ```sh
    dotnet remove package Microsoft.ApplicationInsights
    ```

    > [!TIP]
    > If you've used [Microsoft.ApplicationInsights.WorkerService](https://www.nuget.org/packages/Microsoft.ApplicationInsights.WorkerService), refer to the WorkerService tabs.

1. Remove Initialization Code and customizations

    Remove any references to Application Insights types in your codebase.

    > [!TIP]
    > After removing the Application Insights package, you can re-build your application to get a list of references that need to be removed.

    Remove references to `TelemetryConfiguration` or `TelemetryClient`. It should be part of your application startup to initialize the Application Insights SDK.

        ```csharp
        var config = TelemetryConfiguration.CreateDefault();
        var client = new TelemetryClient(config);
        ```

    > [!TIP]
    > If you've used `AddApplicationInsightsTelemetryWorkerService()` to add Application Insights to your `ServiceCollection`, refer to the WorkerService tabs.

1. Clean and Build

    Inspect your bin directory to validate that all references to `Microsoft.ApplicationInsights.` were removed.

1. Test your application

    Verify that your application has no unexpected consequences.

### WorkerService

1. Remove NuGet packages

    Remove the `Microsoft.ApplicationInsights.WorkerService` package from your `csproj`.

    ```sh
    dotnet remove package Microsoft.ApplicationInsights.WorkerService
    ```

1. Remove Initialization Code and customizations

    Remove any references to Application Insights types in your codebase.

    > [!TIP]
    > After removing the Application Insights package, you can re-build your application to get a list of references that need to be removed.

    * Remove Application Insights from your `ServiceCollection` by deleting the following line:

        ```csharp
        builder.Services.AddApplicationInsightsTelemetryWorkerService();
        ```

    * Remove the `ApplicationInsights` section from your `appsettings.json`.

        ```json
        {
            "ApplicationInsights": {
                "ConnectionString": "<YOUR-CONNECTION-STRING>"
            }
        }
        ```

1. Clean and Build

    Inspect your bin directory to validate that all references to `Microsoft.ApplicationInsights.*` were removed.

1. Test your application

    Verify that your application has no unexpected consequences.

> [!TIP]
> Our product group is actively seeking feedback on this documentation. Provide feedback to otel@microsoft.com or see the [Support](#support) section.

## Enable OpenTelemetry

We recommended creating a development [resource](./create-workspace-resource.md) and using its [connection string](./connection-strings.md) when following these instructions.

:::image type="content" source="media/migrate-from-instrumentation-keys-to-connection-strings/migrate-from-instrumentation-keys-to-connection-strings.png" alt-text="Screenshot that shows the Application Insights overview and connection string." lightbox="media/migrate-from-instrumentation-keys-to-connection-strings/migrate-from-instrumentation-keys-to-connection-strings.png":::

Plan to update the connection string to send telemetry to the original resource after confirming migration is successful.

### ASP.NET Core

1. Install the Azure Monitor Distro

    Our Azure Monitor Distro enables automatic telemetry by including OpenTelemetry instrumentation libraries for collecting traces, metrics, logs, and exceptions, and allows collecting custom telemetry.

    Installing the Azure Monitor Distro brings the [OpenTelemetry SDK](https://www.nuget.org/packages/OpenTelemetry) as a dependency.

    ```sh
    dotnet add package Azure.Monitor.OpenTelemetry.AspNetCore
    ```

1. Add and configure both OpenTelemetry and Azure Monitor

    The OpenTelemery SDK must be configured at application startup as part of your `ServiceCollection`, typically in the `Program.cs`.

    OpenTelemetry has a concept of three signals; Traces, Metrics, and Logs.
    The Azure Monitor Distro configures each of these signals.

##### Program.cs

The following code sample demonstrates the basics.

```csharp
using Azure.Monitor.OpenTelemetry.AspNetCore;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;

public class Program
{
    public static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        // Call AddOpenTelemetry() to add OpenTelemetry to your ServiceCollection.
        // Call UseAzureMonitor() to fully configure OpenTelemetry.
        builder.Services.AddOpenTelemetry().UseAzureMonitor();

        var app = builder.Build();
        app.MapGet("/", () => "Hello World!");
        app.Run();
    }
}
```

We recommend setting your connection string in an environment variable:

`APPLICATIONINSIGHTS_CONNECTION_STRING=<YOUR-CONNECTION-STRING>`

More options to configure the connection string are detailed here: [Configure the Application Insights connection string](./opentelemetry-configuration.md?tabs=aspnetcore#connection-string).

### ASP.NET

1. Install the OpenTelemetry SDK via Azure Monitor

    Installing the Azure Monitor Exporter brings the [OpenTelemetry SDK](https://www.nuget.org/packages/OpenTelemetry) as a dependency.

    ```sh
    dotnet add package Azure.Monitor.OpenTelemetry.Exporter
    ```

1. Configure OpenTelemetry as part of your application startup

    The OpenTelemery SDK must be configured at application startup, typically in the `Global.asax.cs`.
    OpenTelemetry has a concept of three signals; Traces, Metrics, and Logs.
    Each of these signals needs to be configured as part of your application startup.
    `TracerProvider`, `MeterProvider`, and `ILoggerFactory` should be created once for your application and disposed when your application shuts down.

##### Global.asax.cs

The following code sample shows a simple example meant only to show the basics.
No telemetry is collected at this point.

```csharp
using Microsoft.Extensions.Logging;
using OpenTelemetry;
using OpenTelemetry.Metrics;
using OpenTelemetry.Trace;

public class Global : System.Web.HttpApplication
{
    private TracerProvider? tracerProvider;
    private MeterProvider? meterProvider;
    // The LoggerFactory needs to be accessible from the rest of your application.
    internal static ILoggerFactory loggerFactory;

    protected void Application_Start()
    {
        this.tracerProvider = Sdk.CreateTracerProviderBuilder()
            .Build();

        this.meterProvider = Sdk.CreateMeterProviderBuilder()
            .Build();

        loggerFactory = LoggerFactory.Create(builder =>
        {
            builder.AddOpenTelemetry();
        });
    }

    protected void Application_End()
    {
        this.tracerProvider?.Dispose();
        this.meterProvider?.Dispose();
        loggerFactory?.Dispose();
    }
}
```

### Console

1. Install the OpenTelemetry SDK via Azure Monitor

    Installing the [Azure Monitor Exporter](https://www.nuget.org/packages/Azure.Monitor.OpenTelemetry.Exporter) brings the [OpenTelemetry SDK](https://www.nuget.org/packages/OpenTelemetry) as a dependency.

    ```sh
    dotnet add package Azure.Monitor.OpenTelemetry.Exporter
    ```

1. Configure OpenTelemetry as part of your application startup

    The OpenTelemery SDK must be configured at application startup, typically in the `Program.cs`.
    OpenTelemetry has a concept of three signals; Traces, Metrics, and Logs.
    Each of these signals needs to be configured as part of your application startup.
    `TracerProvider`, `MeterProvider`, and `ILoggerFactory` should be created once for your application and disposed when your application shuts down.

The following code sample shows a simple example meant only to show the basics.
No telemetry is collected at this point.

##### Program.cs

```csharp
using Microsoft.Extensions.Logging;
using OpenTelemetry;
using OpenTelemetry.Metrics;
using OpenTelemetry.Trace;

internal class Program
{
    static void Main(string[] args)
    {
        TracerProvider tracerProvider = Sdk.CreateTracerProviderBuilder()
            .Build();

        MeterProvider meterProvider = Sdk.CreateMeterProviderBuilder()
            .Build();

        ILoggerFactory loggerFactory = LoggerFactory.Create(builder =>
        {
            builder.AddOpenTelemetry();
        });

        Console.WriteLine("Hello, World!");

        // Dispose tracer provider before the application ends.
        // It will flush the remaining spans and shutdown the tracing pipeline.
        tracerProvider.Dispose();

        // Dispose meter provider before the application ends.
        // It will flush the remaining metrics and shutdown the metrics pipeline.
        meterProvider.Dispose();

        // Dispose logger factory before the application ends.
        // It will flush the remaining logs and shutdown the logging pipeline.
        loggerFactory.Dispose();
    }
}
```

### WorkerService

1. Install the OpenTelemetry SDK via Azure Monitor

    Installing the [Azure Monitor Exporter](https://www.nuget.org/packages/Azure.Monitor.OpenTelemetry.Exporter) brings the [OpenTelemetry SDK](https://www.nuget.org/packages/OpenTelemetry) as a dependency.

    ```sh
    dotnet add package Azure.Monitor.OpenTelemetry.Exporter
    ```

    You must also install the [OpenTelemetry Extensions Hosting](https://www.nuget.org/packages/OpenTelemetry.Extensions.Hosting) package.

    ```sh
    dotnet add package OpenTelemetry.Extensions.Hosting
    ```

1. Configure OpenTelemetry as part of your application startup

    The OpenTelemery SDK must be configured at application startup, typically in the `Program.cs`.
    OpenTelemetry has a concept of three signals; Traces, Metrics, and Logs.
    Each of these signals needs to be configured as part of your application startup.
    `TracerProvider`, `MeterProvider`, and `ILoggerFactory` should be created once for your application and disposed when your application shuts down.

The following code sample shows a simple example meant only to show the basics.
No telemetry is collected at this point.

##### Program.cs

```csharp
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

public class Program
{
    public static void Main(string[] args)
    {
        var builder = Host.CreateApplicationBuilder(args);
        builder.Services.AddHostedService<Worker>();

        builder.Services.AddOpenTelemetry()
            .WithTracing()
            .WithMetrics();

        builder.Logging.AddOpenTelemetry();

        var host = builder.Build();
        host.Run();
    }
}
```

> [!TIP]
> Our product group is actively seeking feedback on this documentation. Provide feedback to otel@microsoft.com or see the [Support](#support) section.

## Install and configure instrumentation libraries

### ASP.NET Core

[Instrumentation libraries](https://opentelemetry.io/docs/specs/otel/overview/#instrumentation-libraries) can be added to your project to auto collect telemetry about specific components or dependencies.

The following libraries are included in the Distro.

* [HTTP](https://www.nuget.org/packages/OpenTelemetry.Instrumentation.Http)
* [ASP.NET Core](https://www.nuget.org/packages/OpenTelemetry.Instrumentation.AspNetCore)
* [SQL](https://www.nuget.org/packages/OpenTelemetry.Instrumentation.sqlclient)

#### Customizing instrumentation libraries

The Azure Monitor Distro includes .NET OpenTelemetry instrumentation for [ASP.NET Core](https://www.nuget.org/packages/OpenTelemetry.Instrumentation.AspNetCore/), [HttpClient](https://www.nuget.org/packages/OpenTelemetry.Instrumentation.Http/), and [SQLClient](https://www.nuget.org/packages/OpenTelemetry.Instrumentation.SqlClient).
You can customize these included instrumentations or manually add extra instrumentation on your own using the OpenTelemetry API.

Here are some examples of how to customize the instrumentation:

##### Customizing AspNetCoreTraceInstrumentationOptions

```C#
builder.Services.AddOpenTelemetry().UseAzureMonitor();
builder.Services.Configure<AspNetCoreTraceInstrumentationOptions>(options =>
{
    options.RecordException = true;
    options.Filter = (httpContext) =>
    {
        // only collect telemetry about HTTP GET requests
        return HttpMethods.IsGet(httpContext.Request.Method);
    };
});
```

##### Customizing HttpClientTraceInstrumentationOptions

```C#
builder.Services.AddOpenTelemetry().UseAzureMonitor();
builder.Services.Configure<HttpClientTraceInstrumentationOptions>(options =>
{
    options.RecordException = true;
    options.FilterHttpRequestMessage = (httpRequestMessage) =>
    {
        // only collect telemetry about HTTP GET requests
        return HttpMethods.IsGet(httpRequestMessage.Method.Method);
    };
});
```

##### Customizing SqlClientInstrumentationOptions

We provide the [SQLClient](https://www.nuget.org/packages/OpenTelemetry.Instrumentation.SqlClient) instrumentation within our package while it's still in beta. When it reaches a stable release, we'll include it as a standard package reference. Until then, to customize the SQLClient instrumentation, add the `OpenTelemetry.Instrumentation.SqlClient` package reference to your project and use its public API.

```
dotnet add package --prerelease OpenTelemetry.Instrumentation.SqlClient
```

```C#
builder.Services.AddOpenTelemetry().UseAzureMonitor().WithTracing(builder =>
{
    builder.AddSqlClientInstrumentation(options =>
    {
        options.SetDbStatementForStoredProcedure = false;
    });
});
```

### ASP.NET

[Instrumentation libraries](https://opentelemetry.io/docs/specs/otel/overview/#instrumentation-libraries) can be added to your project to auto collect telemetry about specific components or dependencies. We recommend the following libraries:

1. [OpenTelemetry.Instrumentation.AspNet](https://www.nuget.org/packages/OpenTelemetry.Instrumentation.AspNet) can be used to collect telemetry for incoming requests. Azure Monitor maps it to [Request Telemetry](./data-model-complete.md#request-telemetry).

    ```sh
    dotnet add package OpenTelemetry.Instrumentation.AspNet
    ```

    It requires adding an extra HttpModule to your `Web.config`:

    ```xml
    <system.webServer>
      <modules>
          <add
              name="TelemetryHttpModule"
              type="OpenTelemetry.Instrumentation.AspNet.TelemetryHttpModule,
                  OpenTelemetry.Instrumentation.AspNet.TelemetryHttpModule"
              preCondition="integratedMode,managedHandler" />
      </modules>
    </system.webServer>
    ```

    A complete getting started guide is available here: [OpenTelemetry.Instrumentation.AspNet Readme](https://github.com/open-telemetry/opentelemetry-dotnet-contrib/tree/main/src/OpenTelemetry.Instrumentation.AspNet)

1. [OpenTelemetry.Instrumentation.Http](https://www.nuget.org/packages/OpenTelemetry.Instrumentation.Http) can be used to collect telemetry for outbound http dependencies. Azure Monitor maps it to [Dependency Telemetry](./data-model-complete.md#dependency-telemetry).

    ```sh
    dotnet add package OpenTelemetry.Instrumentation.Http
    ```

    A complete getting started guide is available here: [OpenTelemetry.Instrumentation.Http Readme](https://github.com/open-telemetry/opentelemetry-dotnet-contrib/tree/main/src/OpenTelemetry.Instrumentation.Http)

1. [OpenTelemetry.Instrumentation.SqlClient](https://www.nuget.org/packages/OpenTelemetry.Instrumentation.SqlClient) can be used to collect telemetry for MS SQL dependencies. Azure Monitor maps it to [Dependency Telemetry](./data-model-complete.md#dependency-telemetry).

    ```sh
    dotnet add package --prerelease OpenTelemetry.Instrumentation.SqlClient
    ```

    A complete getting started guide is available here: [OpenTelemetry.Instrumentation.SqlClient Readme](https://github.com/open-telemetry/opentelemetry-dotnet-contrib/tree/main/src/OpenTelemetry.Instrumentation.SqlClient)

##### Global.asax.cs

The following code sample expands on the previous example.
It now collects telemetry, but doesn't yet send to Application Insights.

```csharp
using Microsoft.Extensions.Logging;
using OpenTelemetry;
using OpenTelemetry.Metrics;
using OpenTelemetry.Trace;

public class Global : System.Web.HttpApplication
{
    private TracerProvider? tracerProvider;
    private MeterProvider? meterProvider;
    internal static ILoggerFactory loggerFactory;

    protected void Application_Start()
    {
        this.tracerProvider = Sdk.CreateTracerProviderBuilder()
            .AddAspNetInstrumentation()
            .AddHttpClientInstrumentation()
            .AddSqlClientInstrumentation()
            .Build();

        this.meterProvider = Sdk.CreateMeterProviderBuilder()
            .AddAspNetInstrumentation()
            .AddHttpClientInstrumentation()
            .Build();

        loggerFactory = LoggerFactory.Create(builder =>
        {
            builder.AddOpenTelemetry();
        });
    }

    protected void Application_End()
    {
        this.tracerProvider?.Dispose();
        this.meterProvider?.Dispose();
        loggerFactory?.Dispose();
    }
}
```

### Console

[Instrumentation libraries](https://opentelemetry.io/docs/specs/otel/overview/#instrumentation-libraries) can be added to your project to auto collect telemetry about specific components or dependencies. We recommend the following libraries:

1. [OpenTelemetry.Instrumentation.Http](https://www.nuget.org/packages/OpenTelemetry.Instrumentation.Http) can be used to collect telemetry for outbound http dependencies. Azure Monitor maps it to [Dependency Telemetry](./data-model-complete.md#dependency-telemetry).

    ```sh
    dotnet add package OpenTelemetry.Instrumentation.Http
    ```

    A complete getting started guide is available here: [OpenTelemetry.Instrumentation.Http Readme](https://github.com/open-telemetry/opentelemetry-dotnet-contrib/tree/main/src/OpenTelemetry.Instrumentation.Http)

1. [OpenTelemetry.Instrumentation.SqlClient](https://www.nuget.org/packages/OpenTelemetry.Instrumentation.SqlClient) can be used to collect telemetry for MS SQL dependencies. Azure Monitor maps it to [Dependency Telemetry](./data-model-complete.md#dependency-telemetry).

    ```sh
    dotnet add package --prerelease OpenTelemetry.Instrumentation.SqlClient
    ```

    A complete getting started guide is available here: [OpenTelemetry.Instrumentation.SqlClient Readme](https://github.com/open-telemetry/opentelemetry-dotnet-contrib/tree/main/src/OpenTelemetry.Instrumentation.SqlClient)

The following code sample expands on the previous example.
It now collects telemetry, but doesn't yet send to Application Insights.

##### Program.cs

```csharp
using Microsoft.Extensions.Logging;
using OpenTelemetry;
using OpenTelemetry.Metrics;
using OpenTelemetry.Trace;

internal class Program
{
    static void Main(string[] args)
    {
        TracerProvider tracerProvider = Sdk.CreateTracerProviderBuilder()
            .AddHttpClientInstrumentation()
            .AddSqlClientInstrumentation()
            .Build();

        MeterProvider meterProvider = Sdk.CreateMeterProviderBuilder()
            .AddHttpClientInstrumentation()
            .Build();

        ILoggerFactory loggerFactory = LoggerFactory.Create(builder =>
        {
            builder.AddOpenTelemetry();
        });

        Console.WriteLine("Hello, World!");

        tracerProvider.Dispose();
        meterProvider.Dispose();
        loggerFactory.Dispose();
    }
}
```

### WorkerService

[Instrumentation libraries](https://opentelemetry.io/docs/specs/otel/overview/#instrumentation-libraries) can be added to your project to auto collect telemetry about specific components or dependencies. We recommend the following libraries:

1. [OpenTelemetry.Instrumentation.Http](https://www.nuget.org/packages/OpenTelemetry.Instrumentation.Http) can be used to collect telemetry for outbound http dependencies. Azure Monitor maps it to [Dependency Telemetry](./data-model-complete.md#dependency-telemetry).

    ```sh
    dotnet add package OpenTelemetry.Instrumentation.Http
    ```

    A complete getting started guide is available here: [OpenTelemetry.Instrumentation.Http Readme](https://github.com/open-telemetry/opentelemetry-dotnet-contrib/tree/main/src/OpenTelemetry.Instrumentation.Http)

1. [OpenTelemetry.Instrumentation.SqlClient](https://www.nuget.org/packages/OpenTelemetry.Instrumentation.SqlClient) can be used to collect telemetry for MS SQL dependencies. Azure Monitor maps it to [Dependency Telemetry](./data-model-complete.md#dependency-telemetry).

    ```sh
    dotnet add package --prerelease OpenTelemetry.Instrumentation.SqlClient
    ```

    A complete getting started guide is available here: [OpenTelemetry.Instrumentation.SqlClient Readme](https://github.com/open-telemetry/opentelemetry-dotnet-contrib/tree/main/src/OpenTelemetry.Instrumentation.SqlClient)

The following code sample expands on the previous example.
It now collects telemetry, but doesn't yet send to Application Insights.

##### Program.cs

```csharp
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

public class Program
{
    public static void Main(string[] args)
    {
        var builder = Host.CreateApplicationBuilder(args);
        builder.Services.AddHostedService<Worker>();

        builder.Services.AddOpenTelemetry()
            .WithTracing(builder =>
            {
                builder.AddHttpClientInstrumentation();
                builder.AddSqlClientInstrumentation();
            })
            .WithMetrics(builder =>
            {
                builder.AddHttpClientInstrumentation();
            });

        builder.Logging.AddOpenTelemetry();

        var host = builder.Build();
        host.Run();
    }
}
```

## Configure Azure Monitor

### ASP.NET Core

Application Insights offered many more configuration options via `ApplicationInsightsServiceOptions`.

| Application Insights Setting               | OpenTelemetry Alternative                                                                                                    |
|--------------------------------------------|------------------------------------------------------------------------------------------------------------------------------|
| AddAutoCollectedMetricExtractor            | N/A                                                                                                                          |
| ApplicationVersion                         | Set "service.version" on Resource                                                                                            |
| ConnectionString                           | See [instructions](./opentelemetry-configuration.md?tabs=aspnetcore#connection-string) on configuring the connection string. |
| DependencyCollectionOptions                | N/A. To customize dependencies, review the available configuration options for applicable Instrumentation libraries.         |
| DeveloperMode                              | N/A                                                                                                                          |
| EnableActiveTelemetryConfigurationSetup    | N/A                                                                                                                          |
| EnableAdaptiveSampling                     | N/A. Only fixed-rate sampling is supported.                                                                                  |
| EnableAppServicesHeartbeatTelemetryModule  | N/A                                                                                                                          |
| EnableAuthenticationTrackingJavaScript     | N/A                                                                                                                          |
| EnableAzureInstanceMetadataTelemetryModule | N/A                                                                                                                          |
| EnableDependencyTrackingTelemetryModule    | See instructions on filtering Traces.                                                                                        |
| EnableDiagnosticsTelemetryModule           | N/A                                                                                                                          |
| EnableEventCounterCollectionModule         | N/A                                                                                                                          |
| EnableHeartbeat                            | N/A                                                                                                                          |
| EnablePerformanceCounterCollectionModule   | N/A                                                                                                                          |
| EnableQuickPulseMetricStream               | AzureMonitorOptions.EnableLiveMetrics                                                                                        |
| EnableRequestTrackingTelemetryModule       | See instructions on filtering Traces.                                                                                        |
| EndpointAddress                            | Use ConnectionString.                                                                                                        |
| InstrumentationKey                         | Use ConnectionString.                                                                                                        |
| RequestCollectionOptions                   | N/A. See OpenTelemetry.Instrumentation.AspNetCore options.                                                                   |

### Remove custom configurations

The following scenarios are optional and only apply to advanced users.

* If you have any more references to the `TelemetryClient`, which could be used to [manually record telemetry](./api-custom-events-metrics.md), they should be removed.
* If you added any [custom filtering or enrichment](./api-filtering-sampling.md) in the form of a custom `TelemetryProcessor` or `TelemetryInitializer`, they should be removed. They can be found in your `ServiceCollection`.

    ```csharp
    builder.Services.AddSingleton<ITelemetryInitializer, MyCustomTelemetryInitializer>();
    ```

    ```csharp
    builder.Services.AddApplicationInsightsTelemetryProcessor<MyCustomTelemetryProcessor>();
    ```

* Remove JavaScript Snippet

    If you used the Snippet provided by the Application Insights .NET SDK, it must also be removed.
    For full code samples of what to remove, review the guide [enable client-side telemetry for web applications](./asp-net-core.md?tabs=netcorenew#enable-client-side-telemetry-for-web-applications).

    If you added the JavaScript SDK to collect client-side telemetry, it can also be removed although it continues to work without the .NET SDK.
    For full code samples of what to remove, review the [onboarding guide for the JavaScript SDK](./javascript-sdk.md).

* Remove any Visual Studio Artifacts

    If you used Visual Studio to onboard to Application Insights, you could have more files left over in your project.

    * `Properties/ServiceDependencies` directory might have a reference to your Application Insights resource.

### ASP.NET

To send your telemetry to Application Insights, the Azure Monitor Exporter must be added to the configuration of all three signals.

##### Global.asax.cs

The following code sample expands on the previous example.
It now collects telemetry and sends to Application Insights.

```csharp
public class Global : System.Web.HttpApplication
{
    private TracerProvider? tracerProvider;
    private MeterProvider? meterProvider;
    internal static ILoggerFactory loggerFactory;

    protected void Application_Start()
    {
        this.tracerProvider = Sdk.CreateTracerProviderBuilder()
            .AddAspNetInstrumentation()
            .AddHttpClientInstrumentation()
            .AddSqlClientInstrumentation()
            .AddAzureMonitorTraceExporter()
            .Build();

        this.meterProvider = Sdk.CreateMeterProviderBuilder()
            .AddAspNetInstrumentation()
            .AddHttpClientInstrumentation()
            .AddAzureMonitorMetricExporter()
            .Build();

        loggerFactory = LoggerFactory.Create(builder =>
        {
            builder.AddOpenTelemetry(logging => logging.AddAzureMonitorLogExporter());
        });
    }

    protected void Application_End()
    {
        this.tracerProvider?.Dispose();
        this.meterProvider?.Dispose();
        loggerFactory?.Dispose();
    }
}
```

We recommend setting your connection string in an environment variable:

`APPLICATIONINSIGHTS_CONNECTION_STRING=<YOUR-CONNECTION-STRING>`

More options to configure the connection string are detailed here: [Configure the Application Insights connection string](./opentelemetry-configuration.md?tabs=net#connection-string).

### Console

To send your telemetry to Application Insights, the Azure Monitor Exporter must be added to the configuration of all three signals.

##### Program.cs

The following code sample expands on the previous example.
It now collects telemetry and sends to Application Insights.

```csharp
using Microsoft.Extensions.Logging;
using OpenTelemetry;
using OpenTelemetry.Metrics;
using OpenTelemetry.Trace;

internal class Program
{
    static void Main(string[] args)
    {
        TracerProvider tracerProvider = Sdk.CreateTracerProviderBuilder()
            .AddHttpClientInstrumentation()
            .AddSqlClientInstrumentation()
            .AddAzureMonitorTraceExporter()
            .Build();

        MeterProvider meterProvider = Sdk.CreateMeterProviderBuilder()
            .AddHttpClientInstrumentation()
            .AddAzureMonitorMetricExporter()
            .Build();

        ILoggerFactory loggerFactory = LoggerFactory.Create(builder =>
        {
            builder.AddOpenTelemetry(logging => logging.AddAzureMonitorLogExporter());
        });

        Console.WriteLine("Hello, World!");

        tracerProvider.Dispose();
        meterProvider.Dispose();
        loggerFactory.Dispose();
    }
}
```

We recommend setting your connection string in an environment variable:

`APPLICATIONINSIGHTS_CONNECTION_STRING=<YOUR-CONNECTION-STRING>`

More options to configure the connection string are detailed here: [Configure the Application Insights connection string](./opentelemetry-configuration.md?tabs=net#connection-string).

### Remove custom configurations

The following scenarios are optional and apply to advanced users.

* If you have any more references to the `TelemetryClient`, which is used to [manually record telemetry](./api-custom-events-metrics.md), they should be removed.

* Remove any [custom filtering or enrichment](./api-filtering-sampling.md) added as a custom `TelemetryProcessor` or `TelemetryInitializer`. The configuration references them.

* Remove any Visual Studio Artifacts

    If you used Visual Studio to onboard to Application Insights, you could have more files left over in your project.
    
    * `ConnectedService.json` might have a reference to your Application Insights resource.
    * `[Your project's name].csproj` might have a reference to your Application Insights resource:
    
        ```xml
        <ApplicationInsightsResourceId>/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/Default-ApplicationInsights-EastUS/providers/microsoft.insights/components/WebApplication4</ApplicationInsightsResourceId>
        ```

### WorkerService

To send your telemetry to Application Insights, the Azure Monitor Exporter must be added to the configuration of all three signals.

##### Program.cs

The following code sample expands on the previous example.
It now collects telemetry and sends to Application Insights.

```csharp
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

public class Program
{
    public static void Main(string[] args)
    {
        var builder = Host.CreateApplicationBuilder(args);
        builder.Services.AddHostedService<Worker>();

        builder.Services.AddOpenTelemetry()
            .WithTracing(builder =>
            {
                builder.AddHttpClientInstrumentation();
                builder.AddSqlClientInstrumentation();
                builder.AddAzureMonitorTraceExporter();
            })
            .WithMetrics(builder =>
            {
                builder.AddHttpClientInstrumentation();
                builder.AddAzureMonitorMetricExporter();
            });

        builder.Logging.AddOpenTelemetry(logging => logging.AddAzureMonitorLogExporter());

        var host = builder.Build();
        host.Run();
    }
}
```

We recommend setting your connection string in an environment variable:

`APPLICATIONINSIGHTS_CONNECTION_STRING=<YOUR-CONNECTION-STRING>`

More options to configure the connection string are detailed here: [Configure the Application Insights connection string](./opentelemetry-configuration.md?tabs=net#connection-string).

#### More configurations

Application Insights offered many more configuration options via `ApplicationInsightsServiceOptions`.

| Application Insights Setting               | OpenTelemetry Alternative                                                                                                    |
|--------------------------------------------|------------------------------------------------------------------------------------------------------------------------------|
| AddAutoCollectedMetricExtractor            | N/A                                                                                                                          |
| ApplicationVersion                         | Set "service.version" on Resource                                                                                            |
| ConnectionString                           | See [instructions](./opentelemetry-configuration.md?tabs=aspnetcore#connection-string) on configuring the connection string. |
| DependencyCollectionOptions                | N/A. To customize dependencies, review the available configuration options for applicable Instrumentation libraries.         |
| DeveloperMode                              | N/A                                                                                                                          |
| EnableAdaptiveSampling                     | N/A. Only fixed-rate sampling is supported.                                                                                  |
| EnableAppServicesHeartbeatTelemetryModule  | N/A                                                                                                                          |
| EnableAzureInstanceMetadataTelemetryModule | N/A                                                                                                                          |
| EnableDependencyTrackingTelemetryModule    | See instructions on filtering Traces.                                                                                        |
| EnableDiagnosticsTelemetryModule           | N/A                                                                                                                          |
| EnableEventCounterCollectionModule         | N/A                                                                                                                          |
| EnableHeartbeat                            | N/A                                                                                                                          |
| EnablePerformanceCounterCollectionModule   | N/A                                                                                                                          |
| EnableQuickPulseMetricStream               | AzureMonitorOptions.EnableLiveMetrics                                                                                        |
| EndpointAddress                            | Use ConnectionString.                                                                                                        |
| InstrumentationKey                         | Use ConnectionString.                                                                                                        |

### Remove Custom Configurations

The following scenarios are optional and apply to advanced users.

* If you have any more references to the `TelemetryClient`, which are used to [manually record telemetry](./api-custom-events-metrics.md), they should be removed.

* If you added any [custom filtering or enrichment](./api-filtering-sampling.md) in the form of a custom `TelemetryProcessor` or `TelemetryInitializer`, it should be removed. You can find references in your `ServiceCollection`.

    ```csharp
    builder.Services.AddSingleton<ITelemetryInitializer, MyCustomTelemetryInitializer>();
    ```

    ```csharp
    builder.Services.AddApplicationInsightsTelemetryProcessor<MyCustomTelemetryProcessor>();
    ```

* Remove any Visual Studio Artifacts

    If you used Visual Studio to onboard to Application Insights, you could have more files left over in your project.
    
    * `Properties/ServiceDependencies` directory might have a reference to your Application Insights resource.

> [!TIP]
> Our product group is actively seeking feedback on this documentation. Provide feedback to otel@microsoft.com or see the [Support](#support) section.

## Next steps

* To review frequently asked questions (FAQ), see [Migrate from .NET Application Insights SDKs to Azure Monitor OpenTelemetry FAQ](application-insights-faq.yml#migrate-from--net-application-insights-sdks-to-azure-monitor-opentelemetry)
* [OpenTelemetry SDK's getting started guide](https://github.com/open-telemetry/opentelemetry-dotnet/tree/main/src/OpenTelemetry)
* [OpenTelemetry's example ASP.NET Core project](https://github.com/open-telemetry/opentelemetry-dotnet/tree/main/examples/AspNetCore)
* [C# and .NET Logging](/dotnet/core/extensions/logging)
* [Azure Monitor OpenTelemetry getting started with ASP.NET Core](./opentelemetry-enable.md?tabs=aspnetcore)

### Example projects

* ASP.NET Core: [Azure Monitor Distro Demo project](https://github.com/Azure/azure-sdk-for-net/tree/main/sdk/monitor/Azure.Monitor.OpenTelemetry.AspNetCore/tests/Azure.Monitor.OpenTelemetry.AspNetCore.Demo)
* ASP.NET: [OpenTelemetry's example ASP.NET project](https://github.com/open-telemetry/opentelemetry-dotnet-contrib/blob/main/examples/AspNet/Global.asax.cs)
* Console:
    * [Getting Started with Traces](https://github.com/open-telemetry/opentelemetry-dotnet/tree/main/docs/trace/getting-started-console)
    * [Getting Started with Metrics](https://github.com/open-telemetry/opentelemetry-dotnet/tree/main/docs/metrics/getting-started-console)
    * [Getting Started with Logs](https://github.com/open-telemetry/opentelemetry-dotnet/tree/main/docs/logs/getting-started-console)

> [!TIP]
> Our product group is actively seeking feedback on this documentation. Provide feedback to otel@microsoft.com or see the [Support](#support) section.

## Support

* For Azure support issues, open an [Azure support ticket](https://azure.microsoft.com/support/create-ticket/).
* For OpenTelemetry issues, contact the [OpenTelemetry .NET community](https://github.com/open-telemetry/opentelemetry-dotnet) directly.
* For a list of open issues related to Azure Monitor Exporter, see the [GitHub Issues Page](https://github.com/Azure/azure-sdk-for-net/issues?q=is%3Aopen+is%3Aissue+label%3A%22Monitor+-+Exporter%22).

# [Java](#tab/java)

There are typically no code changes when upgrading to 3.x. The 3.x SDK dependencies are no-op API versions of the 2.x SDK dependencies. However, when used with the 3.x Java agent, the 3.x Java agent provides the implementation for them. As a result, your custom instrumentation is correlated with all the new autoinstrumentation provided by the 3.x Java agent.

## Step 1: Update dependencies

| 2.x dependency | Action | Remarks |
|----------------|--------|---------|
| `applicationinsights-core` | Update the version to `3.4.3` or later | |
| `applicationinsights-web` | Update the version to `3.4.3` or later, and remove the Application Insights web filter your `web.xml` file. | |
| `applicationinsights-web-auto` | Replace with `3.4.3` or later of `applicationinsights-web` | |
| `applicationinsights-logging-log4j1_2` | Remove the dependency and remove the Application Insights appender from your Log4j configuration. | No longer needed since Log4j 1.2 is autoinstrumented in the 3.x Java agent. |
| `applicationinsights-logging-log4j2` | Remove the dependency and remove the Application Insights appender from your Log4j configuration. | No longer needed since Log4j 2 is autoinstrumented in the 3.x Java agent. |
| `applicationinsights-logging-logback` | Remove the dependency and remove the Application Insights appender from your Logback configuration. | No longer needed since Logback is autoinstrumented in the 3.x Java agent. |
| `applicationinsights-spring-boot-starter` | Replace with `3.4.3` or later of `applicationinsights-web` | The cloud role name no longer defaults to `spring.application.name`. To learn how to configure the cloud role name, see the [3.x configuration docs](./java-standalone-config.md#cloud-role-name). |

## Step 2: Add the 3.x Java agent

Add the 3.x Java agent to your Java Virtual Machine (JVM) command-line args, for example:

```
-javaagent:path/to/applicationinsights-agent-3.7.5.jar
```

If you're using the Application Insights 2.x Java agent, just replace your existing `-javaagent:...` with the previous example.

> [!NOTE] 
> If you were using the spring-boot-starter and if you prefer, there is an alternative to using the Java agent. See [3.x Spring Boot](./java-spring-boot.md).

## Step 3: Configure your Application Insights connection string

See [configuring the connection string](./java-standalone-config.md#connection-string).

## Other notes

The rest of this document describes limitations and changes that you might encounter when upgrading from 2.x to 3.x, and some workarounds that you might find helpful.

## TelemetryInitializers

2.x SDK TelemetryInitializers don't run when using the 3.x agent. Many of the use cases that previously required writing a `TelemetryInitializer` can be solved in Application Insights Java 3.x by configuring [custom dimensions](./java-standalone-config.md#custom-dimensions) or using [inherited attributes](./java-standalone-config.md#inherited-attribute-preview).

## TelemetryProcessors

2.x SDK TelemetryProcessors don't run when using the 3.x agent. Many of the use cases that previously required writing a `TelemetryProcessor` can be solved in Application Insights Java 3.x by configuring [sampling overrides](./java-standalone-config.md#sampling-overrides).

## Multiple applications in a single JVM

This use case is supported in Application Insights Java 3.x using [Cloud role name overrides (preview)](./java-standalone-config.md#cloud-role-name-overrides-preview) and/or [Connection string overrides (preview)](./java-standalone-config.md#connection-string-overrides-preview).

## Operation names

In the Application Insights Java 2.x SDK, in some cases, the operation names contained the full path, for example:

:::image type="content" source="media/java-ipa/upgrade-from-2x/operation-names-with-full-path.png" alt-text="Screenshot showing operation names with full path":::

Operation names in Application Insights Java 3.x changed to generally provide a better aggregated view
in the Application Insights Portal U/X, for example:

:::image type="content" source="media/java-ipa/upgrade-from-2x/operation-names-parameterized.png" alt-text="Screenshot showing operation names parameterized":::

However, for some applications, you might still prefer the aggregated view in the U/X that was provided by the previous operation names. In this case, you can use the [telemetry processors](./java-standalone-telemetry-processors.md)  (preview) feature in 3.x to replicate the previous behavior.

The following snippet configures three telemetry processors that combine to replicate the previous behavior.
The telemetry processors perform the following actions (in order):

1. The first telemetry processor is an attribute processor (has type `attribute`), which means it applies to all telemetry that has attributes (currently `requests` and `dependencies`, but soon also `traces`).

    It matches any telemetry that has attributes named `http.request.method` and `url.path`.
    
    Then it extracts `url.path` attribute into a new attribute named `tempName`.

1. The second telemetry processor is a span processor (has type `span`), which means it applies to `requests` and `dependencies`.

    It matches any span that has an attribute named `tempPath`.
    
    Then it updates the span name from the attribute `tempPath`.

1. The last telemetry processor is an attribute processor, same type as the first telemetry processor.

    It matches any telemetry that has an attribute named `tempPath`.
    
    Then it deletes the attribute named `tempPath`, and the attribute appears as a custom dimension.

```json
{
  "preview": {
    "processors": [
      {
        "type": "attribute",
        "include": {
          "matchType": "strict",
          "attributes": [
            { "key": "http.request.method" },
            { "key": "url.path" }
          ]
        },
        "actions": [
          {
            "key": "url.path",
            "pattern": "https?://[^/]+(?<tempPath>/[^?]*)",
            "action": "extract"
          }
        ]
      },
      {
        "type": "span",
        "include": {
          "matchType": "strict",
          "attributes": [
            { "key": "tempPath" }
          ]
        },
        "name": {
          "fromAttributes": [ "http.request.method", "tempPath" ],
          "separator": " "
        }
      },
      {
        "type": "attribute",
        "include": {
          "matchType": "strict",
          "attributes": [
            { "key": "tempPath" }
          ]
        },
        "actions": [
          { "key": "tempPath", "action": "delete" }
        ]
      }
    ]
  }
}
```

## Sampling and missing logs

Rate-limited sampling is enabled by default starting in the 3.4 agent, which can cause unexpected missing logs.

## Project example

This [Java 2.x SDK project](https://github.com/Azure-Samples/ApplicationInsights-Java-Samples/tree/main/advanced/migration-2x) is migrated to [a new project using the 3.x Java agent](https://github.com/Azure-Samples/ApplicationInsights-Java-Samples/tree/main/advanced/migration-3x).

# [Node.js](#tab/nodejs)

This guide provides two options to upgrade from the Application Insights Node.js SDK 2.X to OpenTelemetry.

* **Clean install** the [Node.js Azure Monitor OpenTelemetry Distro](https://github.com/microsoft/opentelemetry-azure-monitor-js).
    * Remove dependencies on the Application Insights classic API.
    * Familiarize yourself with OpenTelemetry APIs and terms.
    * Position yourself to use all that OpenTelemetry offers now and in the future.

* **Upgrade** to Node.js SDK 3.X.
    * Postpone code changes while preserving compatibility with existing custom events and metrics.
    * Access richer OpenTelemetry instrumentation libraries.
    * Maintain eligibility for the latest bug and security fixes.

> [!NOTE]
> [!INCLUDE [application-insights-functions-link](./includes/application-insights-functions-link.md)]

## Clean install

1. Gain prerequisite knowledge of the OpenTelemetry JavaScript Application Programming Interface (API) and Software Development Kit (SDK).

    * Read [OpenTelemetry JavaScript documentation](https://opentelemetry.io/docs/languages/js/).
    * Review [Configure Azure Monitor OpenTelemetry](opentelemetry-configuration.md?tabs=nodejs).
    * Evaluate [Add, modify, and filter OpenTelemetry](opentelemetry-add-modify.md?tabs=nodejs).

1.  Uninstall the `applicationinsights` dependency from your project.

    ```sh
    npm uninstall applicationinsights
    ```

1. Remove SDK 2.X implementation from your code.

    Remove all Application Insights instrumentation from your code. Delete any sections where the Application Insights client is initialized, modified, or called.

1. Enable Application Insights with the Azure Monitor OpenTelemetry Distro.
    > [!IMPORTANT] 
    > *Before* you import anything else, `useAzureMonitor` must be called. There might be telemetry loss if other libraries are imported first.
    Follow [getting started](opentelemetry-enable.md?tabs=nodejs) to onboard to the Azure Monitor OpenTelemetry Distro.

#### Azure Monitor OpenTelemetry Distro changes and limitations

   * The APIs from the Application Insights SDK 2.X aren't available in the Azure Monitor OpenTelemetry Distro. While Application Insights SDK 3.X provides a nonbreaking upgrade path for telemetry ingestion (such as custom events and metrics), most SDK 2.X APIs are not supported and require code changes to OpenTelemetry-based APIs.
   * Filtering dependencies, logs, and exceptions by operation name is not yet supported.

## Upgrade

1. Upgrade the `applicationinsights` package dependency.

    ```sh
    npm update applicationinsights
    ```

1. Rebuild your application.

1. Test your application.

    To avoid using unsupported configuration options in the Application Insights SDK 3.X, see [Unsupported Properties](https://github.com/microsoft/ApplicationInsights-node.js/tree/main?tab=readme-ov-file#applicationinsights-3x-sdk-unsupported-properties).

    If the SDK logs warnings about unsupported API usage after a major version bump, and you need the related functionality, continue using the Application Insights SDK 2.X.

## Changes and limitations

The following changes and limitations apply to both upgrade paths.

##### Node.js version support

For a version of Node.js to be supported by the ApplicationInsights 3.X SDK, it must have overlapping support from both the Azure SDK and OpenTelemetry. Check the [OpenTelemetry supported runtimes](https://github.com/open-telemetry/opentelemetry-js#supported-runtimes) for the latest updates. Users on older versions like Node 8, previously supported by the ApplicationInsights SDK, can still use OpenTelemetry solutions but can experience unexpected or breaking behavior. The ApplicationInsights SDK also depends on the Azure SDK for JS which does not guarantee support for any Node.js versions that have reached end-of-life. See [the Azure SDK for JS support policy](https://github.com/Azure/azure-sdk-for-js/blob/main/SUPPORT.md). For a version of Node.js to be supported by the ApplicationInsights 3.X SDK, it must have overlapping support from both the Azure SDK and OpenTelemetry.

##### Configuration options

The Application Insights SDK version 2.X offers configuration options that aren't available in the Azure Monitor OpenTelemetry Distro or in the major version upgrade to Application Insights SDK 3.X. To find these changes, along with the options we still support, see [SDK configuration documentation](https://github.com/microsoft/ApplicationInsights-node.js/tree/beta?tab=readme-ov-file#applicationinsights-shim-unsupported-properties).

##### Extended metrics

Extended metrics are supported in the Application Insights SDK 2.X; however, support for these metrics ends in both version 3.X of the ApplicationInsights SDK and the Azure Monitor OpenTelemetry Distro.

##### Telemetry Processors

While the Azure Monitor OpenTelemetry Distro and Application Insights SDK 3.X don't support TelemetryProcessors, they do allow you to pass span and log record processors. For more information on how, see [Azure Monitor OpenTelemetry Distro project](https://github.com/Azure/azure-sdk-for-js/tree/main/sdk/monitor/monitor-opentelemetry#modify-telemetry).

This example shows the equivalent of creating and applying a telemetry processor that attaches a custom property in the Application Insights SDK 2.X.

```typescript
const applicationInsights = require("applicationinsights");
applicationInsights.setup("YOUR_CONNECTION_STRING");
applicationInsights.defaultClient.addTelemetryProcessor(addCustomProperty);
applicationInsights.start();

function addCustomProperty(envelope: EnvelopeTelemetry) {
    const data = envelope.data.baseData;
    if (data?.properties) {
        data.properties.customProperty = "Custom Property Value";
    }
    return true;
}
```

This example shows how to modify an Azure Monitor OpenTelemetry Distro implementation to pass a SpanProcessor to the configuration of the distro.

```typescript
import { Context, Span} from "@opentelemetry/api";
import { ReadableSpan, SpanProcessor } from "@opentelemetry/sdk-trace-base";
const { useAzureMonitor } = require("@azure/monitor-opentelemetry");

class SpanEnrichingProcessor implements SpanProcessor {
    forceFlush(): Promise<void> {
        return Promise.resolve();
    }
    onStart(span: Span, parentContext: Context): void {
        return;
    }
    onEnd(span: ReadableSpan): void {
        span.attributes["custom-attribute"] = "custom-value";
    }
    shutdown(): Promise<void> {
        return Promise.resolve();
    }
}

const options = {
    azureMonitorExporterOptions: {
        connectionString: "YOUR_CONNECTION_STRING"
    },
    spanProcessors: [new SpanEnrichingProcessor()],
};
useAzureMonitor(options);
```

# [Python](#tab/python)

> [!NOTE]
> [!INCLUDE [application-insights-functions-link](./includes/application-insights-functions-link.md)]
> [OpenCensus Python SDK is retired](https://opentelemetry.io/blog/2023/sunsetting-opencensus/).

Follow these steps to migrate Python applications to the [Azure Monitor OpenTelemetry Distro](./opentelemetry-enable.md?tabs=python).

> [!WARNING]
> * The [OpenCensus "How to Migrate to OpenTelemetry" blog](https://opentelemetry.io/blog/2023/sunsetting-opencensus/#how-to-migrate-to-opentelemetry) is not applicable to Azure Monitor users.
> * The [OpenTelemetry OpenCensus shim](https://pypi.org/project/opentelemetry-opencensus-shim/) is not recommended or supported by Microsoft.
> * The following outlines the only migration plan for Azure Monitor customers.

## Step 1: Uninstall OpenCensus libraries

Uninstall all libraries related to OpenCensus, including all Pypi packages that start with `opencensus-*`.

```
pip freeze | grep opencensus | xargs pip uninstall -y
```

## Step 2: Remove OpenCensus from your code

Remove all instances of the OpenCensus SDK and the Azure Monitor OpenCensus exporter from your code.

Check for import statements starting with `opencensus` to find all integrations, exporters, and instances of OpenCensus API/SDK that must be removed.

The following are examples of import statements that must be removed.

```python
from opencensus.ext.azure import metrics_exporter
from opencensus.stats import aggregation as aggregation_module
from opencensus.stats import measure as measure_module

from opencensus.ext.azure.trace_exporter import AzureExporter
from opencensus.trace.samplers import ProbabilitySampler
from opencensus.trace.tracer import Tracer

from opencensus.ext.azure.log_exporter import AzureLogHandler
```

## Step 3: Familiarize yourself with OpenTelemetry Python APIs/SDKs

The following documentation provides prerequisite knowledge of the OpenTelemetry Python APIs/SDKs.

* OpenTelemetry Python [documentation](https://opentelemetry-python.readthedocs.io/en/stable/)
* Azure Monitor Distro documentation on [configuration](./opentelemetry-configuration.md?tabs=python) and [telemetry](./opentelemetry-add-modify.md?tabs=python)

> [!NOTE]
> OpenTelemetry Python and OpenCensus Python have different API surfaces, autocollection capabilities, and onboarding instructions.

## Step 4: Set up the Azure Monitor OpenTelemetry Distro

Follow the [getting started](./opentelemetry-enable.md?tabs=python#enable-opentelemetry-with-application-insights)
page to onboard onto the Azure Monitor OpenTelemetry Distro.

## Changes and limitations

The following changes and limitations may be encountered when migrating from OpenCensus to OpenTelemetry.

### Python < 3.7 support

OpenTelemetry's Python-based monitoring solutions only support Python 3.7 and greater, excluding the previously supported Python versions 2.7, 3.4, 3.5, and 3.6 from OpenCensus. We suggest upgrading for users who are on the older versions of Python since, as of writing this document, those versions have already reached [end of life](https://devguide.python.org/versions/). Users who are adamant about not upgrading may still use the OpenTelemetry solutions, but may find unexpected or breaking behavior that is unsupported. In any case, the last supported version of [opencensus-ext-azure](https://pypi.org/project/opencensus-ext-azure/) always exists, and stills work for those versions, but no new releases are made for that project.

### Configurations

OpenCensus Python provided some [configuration](https://github.com/census-instrumentation/opencensus-python#customization) options related to the collection and exporting of telemetry. You achieve the same configurations, and more, by using the [OpenTelemetry Python](https://opentelemetry-python.readthedocs.io/en/stable/) APIs and SDK. The OpenTelemetry Azure monitor Python Distro is more of a one-stop-shop for the most common monitoring needs for your Python applications. Since the Distro encapsulates the OpenTelemetry APIs/SDk, some configuration for more uncommon use cases may not currently be supported for the Distro. Instead, you can opt to onboard onto the [Azure monitor OpenTelemetry exporter](https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/monitor/azure-monitor-opentelemetry-exporter), which, with the OpenTelemetry APIs/SDKs, should be able to fit your monitoring needs. Some of these configurations include:

* Custom propagators
* Custom samplers
* Adding extra span/log processors/metrics readers

### Cohesion with Azure Functions

In order to provide distributed tracing capabilities for Python applications that call other Python applications within an Azure function, the package [opencensus-extension-azure-functions](https://pypi.org/project/opencensus-extension-azure-functions/) was provided to allow for a connected distributed graph.

Currently, the OpenTelemetry solutions for Azure Monitor don't support this scenario. As a workaround, you can manually propagate the trace context in your Azure functions application as shown in the following example.

```python
from opentelemetry.context import attach, detach
from opentelemetry.trace.propagation.tracecontext import \
  TraceContextTextMapPropagator

# Context parameter is provided for the body of the function
def main(req, context):
  functions_current_context = {
    "traceparent": context.trace_context.Traceparent,
    "tracestate": context.trace_context.Tracestate
  }
  parent_context = TraceContextTextMapPropagator().extract(
      carrier=functions_current_context
  )
  token = attach(parent_context)

  ...
  # Function logic
  ...
  detach(token)
```

### Extensions and exporters

The OpenCensus SDK offered ways to collect and export telemetry through OpenCensus integrations and exporters respectively. In OpenTelemetry, integrations are now referred to as instrumentations, whereas exporters have stayed with the same terminology. The OpenTelemetry Python instrumentations and exporters are a superset of what was provided in OpenCensus, so in terms of library coverage and functionality, OpenTelemetry libraries are a direct upgrade. As for the Azure Monitor OpenTelemetry Distro, it comes with some of the popular OpenTelemetry Python [instrumentations](.\opentelemetry-add-modify.md?tabs=python#included-instrumentation-libraries) out of the box so no extra code is necessary. Microsoft fully supports these instrumentations.

As for the other OpenTelemetry Python [instrumentations](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation) that aren't included in this list, users may still manually instrument with them. However, it's important to note that stability and behavior aren't guaranteed or supported in those cases. Therefore, use them at your own discretion.

If you would like to suggest a community instrumentation library us to include in our distro, post or up-vote an idea in our [feedback community](https://feedback.azure.com/d365community/forum/3887dc70-2025-ec11-b6e6-000d3a4f09d0). For exporters, the Azure Monitor OpenTelemetry distro comes bundled with the [Azure Monitor OpenTelemetry exporter](https://pypi.org/project/azure-monitor-opentelemetry-exporter/). If you would like to use other exporters as well, you can use them with the distro, like in this [example](./opentelemetry-configuration.md?tabs=python#enable-the-otlp-exporter).

### TelemetryProcessors

There's no concept of TelemetryProcessors in the OpenTelemetry world, but there are APIs and classes that you can use to replicate the same behavior.

#### Setting Cloud Role Name and Cloud Role Instance

Follow the instructions [here](./opentelemetry-configuration.md?tabs=python#set-the-cloud-role-name-and-the-cloud-role-instance) for how to set cloud role name and cloud role instance for your telemetry. The OpenTelemetry Azure Monitor Distro automatically fetches the values from the environment variables and fills the respective fields.

#### Modifying spans with SpanProcessors

Coming soon.

#### Modifying metrics with Views

Coming soon.

### Performance Counters

The OpenCensus Python Azure Monitor exporter automatically collected system and performance related metrics called [performance counters](https://github.com/census-instrumentation/opencensus-python/tree/master/contrib/opencensus-ext-azure#performance-counters). These metrics appear in `performanceCounters` in your Application Insights instance. In OpenTelemetry, we no longer send these metrics explicitly to `performanceCounters`. Metrics related to incoming/outgoing requests can be found under [standard metrics](./standard-metrics.md). If you would like OpenTelemetry to autocollect system related metrics, you can use the experimental system metrics [instrumentation](https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-system-metrics), contributed by the OpenTelemetry Python community. This package is experimental and not officially supported by Microsoft.

## Support

To review troubleshooting steps, support options, or to provide OpenTelemetry feedback, see [OpenTelemetry troubleshooting, support, and feedback for Azure Monitor Application Insights](.\opentelemetry-help-support-feedback.md).

---
