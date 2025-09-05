---
title: Application Insights for Worker Service apps (non-HTTP apps)
description: Monitoring .NET Core/.NET Framework non-HTTP apps with Azure Monitor Application Insights.
ms.topic: how-to
ms.devlang: csharp
ms.custom: devx-track-csharp, devx-track-dotnet
ms.date: 12/07/2024
ms.reviewer: cithomas
---

# Application Insights for Worker Service applications (non-HTTP applications)

[Application Insights SDK for Worker Service](https://www.nuget.org/packages/Microsoft.ApplicationInsights.WorkerService) is a new SDK, which is best suited for non-HTTP workloads like messaging, background tasks, and console applications. These types of applications don't have the notion of an incoming HTTP request like a traditional ASP.NET/ASP.NET Core web application. For this reason, using Application Insights packages for [ASP.NET](asp-net.md) or [ASP.NET Core](asp-net-core.md) applications isn't supported.

## Supported scenarios

The  is best suited for non-HTTP applications no matter where or how they run. If your application is running and has network connectivity to Azure, telemetry can be collected. Application Insights monitoring is supported everywhere .NET Core is supported. This package can be used in the newly introduced [.NET Core Worker Service](https://devblogs.microsoft.com/aspnet/dotnet-core-workers-in-azure-container-instances), [background tasks in ASP.NET Core](/aspnet/core/fundamentals/host/hosted-services), and console apps like .NET Core and .NET Framework.

## Prerequisites

You must have a valid Application Insights connection string. This string is required to send any telemetry to Application Insights. If you need to create a new Application Insights resource to get a connection string, see [Connection Strings](./connection-strings.md).


### Manually track other telemetry

Although the SDK automatically collects telemetry as explained, in most cases, you need to send other telemetry to Application Insights. The recommended way to track other telemetry is by obtaining an instance of `TelemetryClient` from Dependency Injection and then calling one of the supported `TrackXXX()` [API](api-custom-events-metrics.md) methods on it. Another typical use case is [custom tracking of operations](custom-operations-tracking.md). This approach is demonstrated in the preceding worker examples.

## Configure the Application Insights SDK

The default `TelemetryConfiguration` used by the Worker Service SDK is similar to the automatic configuration used in an ASP.NET or ASP.NET Core application, minus the telemetry initializers used to enrich telemetry from `HttpContext`.

You can customize the Application Insights SDK for Worker Service to change the default configuration. Users of the Application Insights ASP.NET Core SDK might be familiar with changing configuration by using ASP.NET Core built-in [dependency injection](/aspnet/core/fundamentals/dependency-injection). The Worker Service SDK is also based on similar principles. Make almost all configuration changes in the `ConfigureServices()` section by calling appropriate methods on `IServiceCollection`, as detailed in the next section.

> [!NOTE]
> When you use this SDK, changing configuration by modifying `TelemetryConfiguration.Active` isn't supported and changes won't be reflected.

### Use ApplicationInsightsServiceOptions

You can modify a few common settings by passing `ApplicationInsightsServiceOptions` to `AddApplicationInsightsTelemetryWorkerService`, as in this example:

```csharp
using Microsoft.ApplicationInsights.WorkerService;

public void ConfigureServices(IServiceCollection services)
{
    var aiOptions = new ApplicationInsightsServiceOptions();
    // Disables adaptive sampling.
    aiOptions.EnableAdaptiveSampling = false;

    // Disables live metrics (also known as QuickPulse).
    aiOptions.EnableQuickPulseMetricStream = false;
    services.AddApplicationInsightsTelemetryWorkerService(aiOptions);
}
```

The `ApplicationInsightsServiceOptions` in this SDK is in the namespace `Microsoft.ApplicationInsights.WorkerService` as opposed to `Microsoft.ApplicationInsights.AspNetCore.Extensions` in the ASP.NET Core SDK.

The following table lists commonly used settings in `ApplicationInsightsServiceOptions`.

|Setting | Description | Default
|---------------|-------|-------
|EnableQuickPulseMetricStream | Enable/Disable the live metrics feature. | True
|EnableAdaptiveSampling | Enable/Disable Adaptive Sampling. | True
|EnableHeartbeat | Enable/Disable the Heartbeats feature, which periodically (15-min default) sends a custom metric named "HeartBeatState" with information about the runtime like .NET version and Azure environment, if applicable. | True
|AddAutoCollectedMetricExtractor | Enable/Disable the AutoCollectedMetrics extractor, which is a telemetry processor that sends preaggregated metrics about Requests/Dependencies before sampling takes place. | True
|EnableDiagnosticsTelemetryModule | Enable/Disable `DiagnosticsTelemetryModule`. Disabling this setting causes the following settings to be ignored: `EnableHeartbeat`, `EnableAzureInstanceMetadataTelemetryModule`, and `EnableAppServicesHeartbeatTelemetryModule`. | True

For the most up-to-date list, see the [configurable settings in `ApplicationInsightsServiceOptions`](https://github.com/microsoft/ApplicationInsights-dotnet/blob/develop/NETCORE/src/Shared/Extensions/ApplicationInsightsServiceOptions.cs).

### Add telemetry initializers

Use [telemetry initializers](./api-filtering-sampling.md#addmodify-properties-itelemetryinitializer) when you want to define properties that are sent with all telemetry.

Add any new telemetry initializer to the `DependencyInjection` container and the SDK automatically adds them to `TelemetryConfiguration`.

```csharp
    using Microsoft.ApplicationInsights.Extensibility;

    public void ConfigureServices(IServiceCollection services)
    {
        services.AddSingleton<ITelemetryInitializer, MyCustomTelemetryInitializer>();
        services.AddApplicationInsightsTelemetryWorkerService();
    }
```

### Remove telemetry initializers

Telemetry initializers are present by default. To remove all or specific telemetry initializers, use the following sample code *after* calling `AddApplicationInsightsTelemetryWorkerService()`.

```csharp
   public void ConfigureServices(IServiceCollection services)
   {
        services.AddApplicationInsightsTelemetryWorkerService();
        // Remove a specific built-in telemetry initializer.
        var tiToRemove = services.FirstOrDefault<ServiceDescriptor>
                            (t => t.ImplementationType == typeof(AspNetCoreEnvironmentTelemetryInitializer));
        if (tiToRemove != null)
        {
            services.Remove(tiToRemove);
        }

        // Remove all initializers.
        // This requires importing namespace by using Microsoft.Extensions.DependencyInjection.Extensions;
        services.RemoveAll(typeof(ITelemetryInitializer));
   }
```

### Add telemetry processors

You can add custom telemetry processors to `TelemetryConfiguration` by using the extension method `AddApplicationInsightsTelemetryProcessor` on `IServiceCollection`. You use telemetry processors in [advanced filtering scenarios](./api-filtering-sampling.md#itelemetryprocessor-and-itelemetryinitializer) to allow for more direct control over what's included or excluded from the telemetry you send to Application Insights. Use the following example:

```csharp
    public void ConfigureServices(IServiceCollection services)
    {
        services.AddApplicationInsightsTelemetryWorkerService();
        services.AddApplicationInsightsTelemetryProcessor<MyFirstCustomTelemetryProcessor>();
        // If you have more processors:
        services.AddApplicationInsightsTelemetryProcessor<MySecondCustomTelemetryProcessor>();
    }
```

### Configure or remove default telemetry modules

Application Insights uses telemetry modules to automatically collect telemetry about specific workloads without requiring manual tracking.

The following autocollection modules are enabled by default. These modules are responsible for automatically collecting telemetry. You can disable or configure them to alter their default behavior.

* `DependencyTrackingTelemetryModule`
* `PerformanceCollectorModule`
* `QuickPulseTelemetryModule`
* `AppServicesHeartbeatTelemetryModule` (There's currently an issue involving this telemetry module. For a temporary workaround, see [GitHub Issue 1689](https://github.com/microsoft/ApplicationInsights-dotnet/issues/1689).)
* `AzureInstanceMetadataTelemetryModule`

To configure any default telemetry module, use the extension method `ConfigureTelemetryModule<T>` on `IServiceCollection`, as shown in the following example:

```csharp
    using Microsoft.ApplicationInsights.Extensibility.PerfCounterCollector.QuickPulse;
    using Microsoft.ApplicationInsights.Extensibility.PerfCounterCollector;

    public void ConfigureServices(IServiceCollection services)
    {
        services.AddApplicationInsightsTelemetryWorkerService();

            // The following configures QuickPulseTelemetryModule.
            // Similarly, any other default modules can be configured.
            services.ConfigureTelemetryModule<QuickPulseTelemetryModule>((module, o) =>
            {
                module.AuthenticationApiKey = "keyhere";
            });

            // The following removes PerformanceCollectorModule to disable perf-counter collection.
            // Similarly, any other default modules can be removed.
            var performanceCounterService = services.FirstOrDefault<ServiceDescriptor>
                                        (t => t.ImplementationType == typeof(PerformanceCollectorModule));
            if (performanceCounterService != null)
            {
                services.Remove(performanceCounterService);
            }
    }
```

### Configure the telemetry channel

The default channel is `ServerTelemetryChannel`. You can override it as the following example shows:

```csharp
using Microsoft.ApplicationInsights.Channel;

    public void ConfigureServices(IServiceCollection services)
    {
        // Use the following to replace the default channel with InMemoryChannel.
        // This can also be applied to ServerTelemetryChannel.
        services.AddSingleton(typeof(ITelemetryChannel), new InMemoryChannel() {MaxTelemetryBufferCapacity = 19898 });

        services.AddApplicationInsightsTelemetryWorkerService();
    }
```

### Disable telemetry dynamically

If you want to disable telemetry conditionally and dynamically, you can resolve the `TelemetryConfiguration` instance with an ASP.NET Core dependency injection container anywhere in your code and set the `DisableTelemetry` flag on it.

```csharp
    public void ConfigureServices(IServiceCollection services)
    {
        services.AddApplicationInsightsTelemetryWorkerService();
    }

    public void Configure(IApplicationBuilder app, IHostingEnvironment env, TelemetryConfiguration configuration)
    {
        configuration.DisableTelemetry = true;
        ...
    }
```




## Next steps

* [Track more dependencies not automatically tracked](asp-net-dependencies.md#dependency-autocollection).
* [Enrich or filter autocollected telemetry](./api-filtering-sampling.md).
* [Dependency Injection in ASP.NET Core](/aspnet/core/fundamentals/dependency-injection).

