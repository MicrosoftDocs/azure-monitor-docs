---
title: Enable Snapshot Debugger for .NET apps in Azure Service Fabric, Cloud Services, and Virtual Machines | Microsoft Docs
description: Enable Snapshot Debugger for .NET apps in Azure Service Fabric, Azure Cloud Services, and Azure Virtual Machines.
ms.author: hannahhunter
author: hhunter-ms
ms.reviewer: charles.weininger
reviewer: cweining
ms.topic: how-to
ms.date: 03/04/2025
ms.custom: devdivchpfy22, devx-track-dotnet
---

# Enable Snapshot Debugger for .NET apps in Azure Service Fabric, Cloud Services, and Virtual Machines

If your ASP.NET or ASP.NET Core application runs in Azure App Service and requires a customized Snapshot Debugger configuration, or a preview version of .NET Core, start with [Enable Snapshot Debugger for .NET apps in Azure App Service](snapshot-debugger-app-service.md).

If your application runs in Azure Service Fabric, Azure Cloud Services, Azure Virtual Machines, or on-premises machines, you can skip enabling Snapshot Debugger on App Service and follow the guidance in this article.

## Prerequisites

- [Enable Application Insights in your .NET resource](../app/asp-net.md).
- Include the [Microsoft.ApplicationInsights.SnapshotCollector](https://www.nuget.org/packages/Microsoft.ApplicationInsights.SnapshotCollector) NuGet package version 1.4.2 or above in your app.
- Understand that snapshots may take 10 to 15 minutes to be sent to the Application Insights instance after an exception has been triggered. 

## Configure snapshot collection for ASP.NET applications

When you add the [Microsoft.ApplicationInsights.SnapshotCollector](https://www.nuget.org/packages/Microsoft.ApplicationInsights.SnapshotCollector) NuGet package to your application, the `SnapshotCollectorTelemetryProcessor` is added automatically to the `TelemetryProcessors` section of [`ApplicationInsights.config`](../app/configuration-with-applicationinsights-config.md).

If you don't see `SnapshotCollectorTelemetryProcessor` in `ApplicationInsights.config`, or if you want to customize the Snapshot Debugger configuration, you can edit it manually. 

> [!NOTE]
> Any manual configurations may get overwritten when upgrading to a newer version of the [Microsoft.ApplicationInsights.SnapshotCollector](https://www.nuget.org/packages/Microsoft.ApplicationInsights.SnapshotCollector) NuGet package.

Snapshot Collector's default configuration looks similar to the following example:

```xml
<TelemetryProcessors>
  <Add Type="Microsoft.ApplicationInsights.SnapshotCollector.SnapshotCollectorTelemetryProcessor, Microsoft.ApplicationInsights.SnapshotCollector">
    <!-- The default is true, but you can disable Snapshot Debugging by setting it to false -->
    <IsEnabled>true</IsEnabled>
    <!-- Snapshot Debugging is usually disabled in developer mode, but you can enable it by setting this to true. -->
    <!-- DeveloperMode is a property on the active TelemetryChannel. -->
    <IsEnabledInDeveloperMode>false</IsEnabledInDeveloperMode>
    <!-- How many times we need to see an exception before we ask for snapshots. -->
    <ThresholdForSnapshotting>1</ThresholdForSnapshotting>
    <!-- The maximum number of examples we create for a single problem. -->
    <MaximumSnapshotsRequired>3</MaximumSnapshotsRequired>
    <!-- The maximum number of problems that we can be tracking at any time. -->
    <MaximumCollectionPlanSize>50</MaximumCollectionPlanSize>
    <!-- How often we reconnect to the stamp. The default value is 15 minutes.-->
    <ReconnectInterval>00:15:00</ReconnectInterval>
    <!-- How often to reset problem counters. -->
    <ProblemCounterResetInterval>1.00:00:00</ProblemCounterResetInterval>
    <!-- The maximum number of snapshots allowed in ten minutes.The default value is 1. -->
    <SnapshotsPerTenMinutesLimit>3</SnapshotsPerTenMinutesLimit>
    <!-- The maximum number of snapshots allowed per day. -->
    <SnapshotsPerDayLimit>30</SnapshotsPerDayLimit>
    <!-- Whether or not to collect snapshot in low IO priority thread. The default value is true. -->
    <SnapshotInLowPriorityThread>true</SnapshotInLowPriorityThread>
    <!-- Agree to send anonymous data to Microsoft to make this product better. -->
    <ProvideAnonymousTelemetry>true</ProvideAnonymousTelemetry>
    <!-- The limit on the number of failed requests to request snapshots before the telemetry processor is disabled. -->
    <FailedRequestLimit>3</FailedRequestLimit>
  </Add>
</TelemetryProcessors>
```

Snapshots are collected _only_ on exceptions reported to Application Insights. In some cases (like on older versions of the .NET platform), you might need to [configure exception collection](../app/asp-net-exceptions.md#exceptions) to see exceptions with snapshots in the portal.

## Configure snapshot collection for ASP.NET Core applications or Worker Services

### Prerequisites

Your application should already reference one of the following Application Insights NuGet packages:
- [`Microsoft.ApplicationInsights.AspNetCore`](https://www.nuget.org/packages/Microsoft.ApplicationInsights.AspNetCore)
- [`Microsoft.ApplicationInsights.WorkerService`](https://www.nuget.org/packages/Microsoft.ApplicationInsights.WorkerService)

### Add the NuGet package

Add the [`Microsoft.ApplicationInsights.SnapshotCollector`](https://www.nuget.org/packages/Microsoft.ApplicationInsights.SnapshotCollector) NuGet package to your app.

### Update the services collection

In your application's startup code, where services are configured, add a call to the `AddSnapshotCollector` extension method. We suggest adding this line immediately after the call to `AddApplicationInsightsTelemetry`. For example:

```csharp
var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddApplicationInsightsTelemetry();
builder.Services.AddSnapshotCollector();
```

### Customize the Snapshot Collector

For most scenarios, Snapshot Collector's default settings are sufficient. However, you can customize the settings by adding the following code before the call to `AddSnapshotCollector()`:

```csharp
using Microsoft.ApplicationInsights.SnapshotCollector;
...
builder.Services.Configure<SnapshotCollectorConfiguration>(builder.Configuration.GetSection("SnapshotCollector"));
```

Next, add a `SnapshotCollector` section to _`appsettings.json`_ where you can override the defaults. 

Snapshot Collector's default *appsettings.json* configuration looks similar to the following example:

```json
{
  "SnapshotCollector": {
    "IsEnabledInDeveloperMode": false,
    "ThresholdForSnapshotting": 1,
    "MaximumSnapshotsRequired": 3,
    "MaximumCollectionPlanSize": 50,
    "ReconnectInterval": "00:15:00",
    "ProblemCounterResetInterval":"1.00:00:00",
    "SnapshotsPerTenMinutesLimit": 1,
    "SnapshotsPerDayLimit": 30,
    "SnapshotInLowPriorityThread": true,
    "ProvideAnonymousTelemetry": true,
    "FailedRequestLimit": 3
  }
}
```

If you need to customize the Snapshot Collector's behavior manually, without using _appsettings.json_, use the overload of `AddSnapshotCollector` that takes a delegate. For example:

```csharp
builder.Services.AddSnapshotCollector(config => config.IsEnabledInDeveloperMode = true);
```

## Configure snapshot collection for other .NET applications

Snapshots are collected only on exceptions that are reported to Application Insights. 

For ASP.NET and ASP.NET Core applications, the Application Insights SDK automatically reports unhandled exceptions that escape a controller method or endpoint route handler. 

For other applications, you might need to modify your code to report them. The exception handling code depends on the structure of your application. For example:

```csharp
using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.DataContracts;
using Microsoft.ApplicationInsights.Extensibility;

internal class ExampleService
{
  private readonly TelemetryClient _telemetryClient;

  public ExampleService(TelemetryClient telemetryClient)
  {
    // Obtain the TelemetryClient via dependency injection.
    _telemetryClient = telemetryClient;
  }

  public void HandleExampleRequest()
  {
    using IOperationHolder<RequestTelemetry> operation = 
        _telemetryClient.StartOperation<RequestTelemetry>("Example");
    try
    {
      // TODO: Handle the request.
      operation.Telemetry.Success = true;
    }
    catch (Exception ex)
    {
      // Report the exception to Application Insights.
      operation.Telemetry.Success = false;
      _telemetryClient.TrackException(ex);
      // TODO: Rethrow the exception if desired.
    }
  }
}
```

The following example uses `ILogger` instead of `TelemetryClient`. This example assumes you're using the [Application Insights Logger Provider](../app/ilogger.md#console-application). As the example shows, when handling an exception, be sure to pass the exception as the first parameter to `LogError`.

```csharp
using Microsoft.Extensions.Logging;

internal class LoggerExample
{
  private readonly ILogger _logger;

  public LoggerExample(ILogger<LoggerExample> logger)
  {
    _logger = logger;
  }

  public void HandleExampleRequest()
  {
    using IDisposable scope = _logger.BeginScope("Example");
    try
    {
      // TODO: Handle the request
    }
    catch (Exception ex)
    {
      // Use the LogError overload with an Exception as the first parameter.
      _logger.LogError(ex, "An error occurred.");
    }
  }
}
```

By default, the Application Insights Logger (`ApplicationInsightsLoggerProvider`) forwards exceptions to the Snapshot Debugger via `TelemetryClient.TrackException`. This behavior is controlled via the `TrackExceptionsAsExceptionTelemetry` property on the `ApplicationInsightsLoggerOptions` class. 

If you set `TrackExceptionsAsExceptionTelemetry` to `false` when configuring the Application Insights Logger, the preceding example will not trigger the Snapshot Debugger. In this case, modify your code to call `TrackException` manually.

## Next steps

- View [snapshots](snapshot-debugger-data.md?toc=/azure/azure-monitor/toc.json#access-debug-snapshots-in-the-portal) in the Azure portal.
- [Troubleshoot Snapshot Debugger issues](snapshot-debugger-troubleshoot.md).
